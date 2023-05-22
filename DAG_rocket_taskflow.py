import requests
import requests.exceptions as requests_exceptions
import pendulum
import pathlib
from airflow.decorators import dag, task
from airflow.providers.http.operators.http import SimpleHttpOperator
from airflow.operators.bash import BashOperator

@dag(
        schedule=None,
        start_date=pendulum.now().subtract(days=14),
        catchup=False,
        tags=["rocket", "demo"]
)
def download_rocket_launch():
    """
    ### Download images from the last rocket launches
    """
    @task()
    def _get_launches():
        launches = requests.get("https://ll.thespacedevs.com/2.0.0/launch/upcoming").json()
        print(len(launches["results"]) + " launches found !")
        return launches

    @task()
    def _get_pictures(launches : dict):
        print(launches)
        # Ensure directory exists
        pathlib.Path("/tmp/images").mkdir(parents=True, exist_ok=True)
        
        image_urls = [launch["image"] for launch in launches["results"]]
        for image_url in image_urls:
            try:
                response = requests.get(image_url)
                image_filename = image_url.split("/")[-1]
                target_file = f"/tmp/images/{image_filename}"
                with open(target_file, "wb") as f:
                    f.write(response.content)
                print(f"Downloaded {image_url} to {target_file}")
            except requests_exceptions.MissingSchema:
                print(f"{image_url} appears to be an invalid URL.")
            except requests_exceptions.ConnectionError:
                print(f"Could not connect to {image_url}.")
    
    notify = BashOperator(
        task_id="notify",
        bash_command='echo "There are now $(ls /tmp/images/ | wc -l) images."',
    )

    launches = _get_launches()
    get_pictures = _get_pictures(launches)
    get_pictures >> notify

download_rocket_launch()
