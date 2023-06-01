# Airflow docker compose

Instantiate airflow. Dockerfile inspired from [here](https://airflow.apache.org/docs/apache-airflow/2.6.1/docker-compose.yaml) using `LocalExecutor` instead of Celery and an external postgres database.

Find an example dag in `airflow/example`.

### Container description

* **airflow-webserver:** presents a handy user interface to inspect, trigger and debug the behaviour of DAGs and tasks.
* **airflow-scheduler:** handles both triggering scheduled workflows, and submitting Tasks to the executor to run.
* **airflow-triggerer:** an Airflow service similar to a scheduler or a worker that runs an asyncio event loop in your Airflow environment. Running a triggerer is essential for using deferrable operators.
* **airflow-init:** initialization service for Airflow, perform checks.
* **init-container:** initialize ariflow acess and database inside postgres. 