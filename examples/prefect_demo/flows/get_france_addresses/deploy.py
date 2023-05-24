from get_france_addresses import *
from prefect.deployments import Deployment

deployment = Deployment.build_from_flow(
    flow=retrieve_adresses,
    name="get-france-addresses",
    parameters={"base_url": "https://adresse.data.gouv.fr/data/ban/adresses/latest/csv",
                "filename": "adresses-75.csv.gz",
                "dbname": "mlops_demo",
                "tablename": "addresses",
                "postgres_secret": "postgres-credentials"},
    infra_overrides={"env": {"PREFECT_LOGGING_LEVEL": "DEBUG"}},
    work_queue_name="test",
)

if __name__ == "__main__":
    deployment.apply()
