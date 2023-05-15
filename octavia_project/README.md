# Octavia-CLI Airbyte :computer:

### Prerequisite :

- Docker

To install octavia CLI (Linux/WSL2/Mac): 

Download this file :

    https://raw.githubusercontent.com/airbytehq/airbyte/master/octavia-cli/install.sh 

Edit the file replacing the line 4, **VERSION=0.44.3** by **VERSION=0.42.1** 

Launch script with : 

    bash install.sh 

Launch this command : 

    source /home/yourhomename/.bashrc

Test the command by typing in your terminal : octavia --help (close and re launch terminal if necessary)

This folder contains the necessary configurations files for setting up :
-  source
-  destination 
-  connection 

# Apply the configuration to Airbyte

After launching Airbyte and set up dbt, cd to the octavia_project directory and enter 

    octavia apply

Connection is ready between our datastores in this **ELT (Airbyte + DBT) demo**.

# Ressources :books:

- [GitHub of Octavia-CLI ](https://github.com/airbytehq/airbyte/tree/master/octavia-cli)
- [Octavia-CLI documentation](https://docs.airbyte.com/cli-documentation/)
- [Octavia-CLI more...](https://airbyte.com/tutorials/version-control-airbyte-configurations)
