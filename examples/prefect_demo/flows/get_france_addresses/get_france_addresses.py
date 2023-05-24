import sys
import prefect
from prefect import flow, task, get_run_logger
from prefect.blocks.system import Secret
import requests
import gzip
import shutil
import pandas as pd
from datetime import datetime
from sqlalchemy import create_engine


@task
def download_file(base_url, filename, destination_folder):
    url = "/".join([base_url, filename])
    destination = "/".join([destination_folder, filename])
    r = requests.get(url, allow_redirects=True)
    get_run_logger().info("Downloading {}".format(filename))
    open(destination, 'wb').write(r.content)

    return destination


@task
def decompress_file(file_path: str):
    get_run_logger().info("Extracting {}".format(file_path))
    destination = "{}.csv".format(file_path)
    with gzip.open(file_path, 'rb') as f_in:
        with open(destination, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
    return destination


@task
def read_file(file_path: str, extraction_date: str):
    get_run_logger().info("Reading {}".format(file_path))
    df = pd.read_csv(file_path)
    get_run_logger().info("Read {} lines".format(len(df)))
    # TODO: Add some tests for data schema verification
    df['extraction_date'] = extraction_date
    return df


@task
def load_to_db(df: pd.DataFrame, postgres_secret: str, target_table: str):

    # Get postgres connection string and connect to postgres
    get_run_logger().info("Connecting to postgres")
    conn_string = Secret.load(postgres_secret).get()
    db = create_engine(conn_string)
    conn = db.connect()

    # Create SQL request from Dataframe and sending to postgres
    get_run_logger().info("Loading data to postgres")
    df.to_sql('addresses', con=conn, if_exists='append', index=False)

    conn.close()


@flow()
def retrieve_adresses(base_url: str, filename: str, dbname: str, tablename: str, postgres_secret: str):
    starting_date = datetime.today().isoformat()

    downloaded_file_path = download_file(base_url, filename, ".")
    csv_file_path = decompress_file(downloaded_file_path)
    addresses_df = read_file(csv_file_path, starting_date)
    load_to_db(addresses_df, postgres_secret, tablename)


if __name__ == "__main__":
    base_url = sys.argv[1]
    filename = sys.argv[2]
    dbname = sys.argv[3]
    tablename = sys.argv[4]
    postgres_secret = sys.argv[5]
    retrieve_adresses(base_url, filename, dbname, tablename, postgres_secret)
