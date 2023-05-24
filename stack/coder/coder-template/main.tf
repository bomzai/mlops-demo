terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 0.7.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

locals {
  username = data.coder_workspace.me.owner
}

data "coder_provisioner" "me" {
}

provider "docker" {
}

data "coder_workspace" "me" {
}

resource "coder_agent" "main" {
  arch                   = data.coder_provisioner.me.arch
  os                     = "linux"
  startup_script_timeout = 180
  startup_script         = <<EOT
    #!/bin/bash
    set -e

    # Install VSCode
    curl -fsSL https://code-server.dev/install.sh | sh -s -- --method=standalone --prefix=/tmp/code-server --version 4.11.0
    # Jupyter
    pip install jupyterlab==3.6.3 jupyterlab-git==0.41.0
    # Additional packages
    pip install --user mlflow==2.3.1 prefect==2.7.10

    # Set path for local packages
    grep -s -q 'export PATH=.*/\.local/bin' .proile || (echo "export PATH=$PATH:$HOME/.local/bin" >> $HOME/.profile)
    source $HOME/.profile

    # Start VSCode (non-blocking)
    /tmp/code-server/bin/code-server --auth none --port 13337 >/tmp/code-server.log 2>&1 &

    # Start Jupyter (non-blocking)
    jupyter-lab --ip='*' --LabApp.token='' --port 8888 --LabApp.base_url=/@${data.coder_workspace.me.owner}/${lower(data.coder_workspace.me.name)}/apps/j >/tmp/jupyter.log 2>&1 &

    # Install VSCode extensions
    /tmp/code-server/bin/code-server --install-extension ms-python.python
    /tmp/code-server/bin/code-server --install-extension redhat.vscode-yaml
    /tmp/code-server/bin/code-server --install-extension ms-azuretools.vscode-docker 
    /tmp/code-server/bin/code-server --install-extension scala-lang.scala

    echo "***** Workspace has been setup ! *****"
  EOT

  # These env variables will be set when using VSCode or Jupyterlab
  env = {
    MLFLOW_TRACKING_URI = "${data.coder_parameter.mlflow_uri.value}"
    PREFECT_API_URL = "${data.coder_parameter.prefect_uri.value}"
  }
}

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "code"
  url          = "http://localhost:13337/?folder=/home/${local.username}"
  icon         = "/icon/code.svg"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 5
    threshold = 6
  }
}

resource "coder_app" "jupyter" {
  agent_id      = coder_agent.main.id
  slug          = "j"  
  display_name  = "jupyter-lab"
  icon          = "/icon/jupyter.svg"
  url           = "http://localhost:8888/@${data.coder_workspace.me.owner}/${lower(data.coder_workspace.me.name)}/apps/j"
  share         = "owner"
  subdomain     = false  

  healthcheck {
    url       = "http://localhost:8888/healthz"
    interval  = 10
    threshold = 20
  }  
}

resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.me.id}-home"
  # Protect the volume from being deleted due to changes in attributes.
  lifecycle {
    ignore_changes = all
  }
  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace.me.owner
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.me.owner_id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  # This field becomes outdated if the workspace is renamed but can
  # be useful for debugging or cleaning out dangling volumes.
  labels {
    label = "coder.workspace_name_at_creation"
    value = data.coder_workspace.me.name
  }
}

resource "docker_image" "main" {
  name = "coder-${data.coder_workspace.me.id}"
  build {
    context = "./build"
    build_args = {
      USER = local.username
    }
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "build/*") : filesha1(f)]))
  }
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  image = docker_image.main.name
  # Uses lower() to avoid Docker restriction on container names.
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"
  # Hostname makes the shell more user friendly: coder@my-workspace:~$
  hostname = data.coder_workspace.me.name
  # Use the docker gateway if the access URL is 127.0.0.1
  entrypoint = ["sh", "-c", replace(coder_agent.main.init_script, "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]
  env        = ["CODER_AGENT_TOKEN=${coder_agent.main.token}"] 
  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }
  volumes {
    container_path = "/home/${local.username}"
    volume_name    = docker_volume.home_volume.name
    read_only      = false
  }
  networks_advanced { 
    name = "bridge" 
  }
  networks_advanced { 
    name = "${data.coder_parameter.docker_network.value}" 
  }
  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace.me.owner
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.me.owner_id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }
}

data "coder_parameter" "mlflow_uri" {
  name        = "MLFlow URI"
  description = "The URI of MLFlow"
  mutable     = true
  default     = "http://mlflow:5000"
}

data "coder_parameter" "prefect_uri" {
  name        = "Prefect API URI"
  description = "The URI of Prefect API"
  mutable     = true
  default     = "http://prefect:4200/api"
}

data "coder_parameter" "docker_network" {
  name        = "Docker Network"
  description = "Namer of the stack docker network"
  mutable     = true
  default     = "stack"
}