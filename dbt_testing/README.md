# Execute the demo :computer:

Prerequistes :

- Docker
- Octavia CLI 

To install octavia CLI : 

Download this file :

    https://raw.githubusercontent.com/airbytehq/airbyte/master/octavia-cli/install.sh 

Edit the file replacing the line 4, **VERSION=0.44.3** by **VERSION=0.42.1** 

1 - Launch Airbyte and databases :

    cd airbyte && docker-compose up
    cd databases && docker-compose up -d

2 - Apply Airbyte configurations :

    cd octavia_project && octavia apply

3 - **Sync manually the ELT by clicking on "Connections" inside your Airbyte navigator**, select the **"mysql_to_postgres_athlete"** connections and click on **"Sync now"**

# Resources :books:

- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
