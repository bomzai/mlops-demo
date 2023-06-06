# Octavia-CLI Airbyte :computer:

- The airbyte folder contains examples of configurations files generated with Octavia 

### Prerequisites :

- Docker
- Octavia-CLI (airbyte client)

To install octavia CLI (Linux/WSL2/Mac): 

Download this file :

    https://raw.githubusercontent.com/airbytehq/airbyte/master/octavia-cli/install.sh 

Edit the file replacing the line 4, **VERSION=0.44.3** by **VERSION=0.42.1** 

Launch the script : 

    bash install.sh 

Environment variables from stack/airbyte/configs/*/* should be placed in your ~/.octavia file

Run : 

    source /home/yourhomename/.bashrc

# Apply the configuration to Airbyte

After deploying airbyte, run :

    cd stack/airbyte/configs
    octavia apply


# Ressources :books:

- [GitHub of Octavia-CLI ](https://github.com/airbytehq/airbyte/tree/master/octavia-cli)
- [Octavia-CLI documentation](https://docs.airbyte.com/cli-documentation/)
- [Octavia-CLI more...](https://airbyte.com/tutorials/version-control-airbyte-configurations)
