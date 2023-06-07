# Octavia-CLI Airbyte :computer:

- The airbyte folder contains examples of configurations files generated with Octavia 

# Prerequisites :

- Docker
- Octavia-CLI (airbyte client)

Install octavia CLI, download :

    https://raw.githubusercontent.com/airbytehq/airbyte/master/octavia-cli/install.sh 


Edit the file replacing the line 4, **VERSION=0.44.3** by **VERSION=0.42.1** and run :



    bash install.sh 

Environment variables in configuration.yaml files (stack/airbyte/configs/*) should be placed in your ~/.octavia file (**you can copy it from local_docker.env**), then run :


    source /home/yourhomename/.bashrc

# Examples for the demo

Deploy MySQL, run :

    docker-compose -f examples/airbyte_demo/mysql/docker-compose.yaml --env-file ./configs/local_docker.env up --build --detach

# Apply the configuration to Airbyte

After deploying airbyte, run :

    cd examples/airbyte_demo/configs
    octavia apply --force

# Sync data

Sync manually data transfer at [http//localhost:8000](http//localhost:8000)


# Ressources :books:

- [GitHub of Octavia-CLI ](https://github.com/airbytehq/airbyte/tree/master/octavia-cli)
- [Octavia-CLI documentation](https://docs.airbyte.com/cli-documentation/)
- [Octavia-CLI more...](https://airbyte.com/tutorials/version-control-airbyte-configurations)
