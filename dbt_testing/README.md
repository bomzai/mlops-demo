# Execute the demo :computer:

1 - You need an **airbyte instance** on your localhost, follow these steps to run it :

- [AIRBYTE LOCAL DEPLOYMENT](https://docs.airbyte.com/deploying-airbyte/local-deployment/)

2 - Use the **trino_demo to set up datastores**, clone it here :

- <span style="background-color: #0000A0">**git clone --recursive https://github.com/bomzai trino_demo.git**</span>
- [TRINO_DEMO REPOSITORY](https://github.com/bomzai/trino_demo)

3 - After launching Airbyte and the trino_demo project, you should go to **[localhost:8000](localhost:8000) to connect to Airbyte** (if prompted enter user=airbyte, password=password). You should wait for trino_demo is fully up

4 - cd to the mlops-demo/dbt_testing/postgres folder and run :
    docker-compose up -d

5 - ! Before going further, **please refer to the README.md of the octavia_project folder** then, to add octavia-cli to your environment and apply the configurations for Airbyte !

6 - You got everything you need and **you can sync manually the ELT by clicking on "Connections" inside your Airbyte navigator**, select the **"mysql_to_postgres_films"** connections (You can review settings) and click on **"Sync now"**

7 - You can connect to Postgres datastore and see the tables and result produces by the data transfer and the DBT transformations 



# Resources :books:

- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
