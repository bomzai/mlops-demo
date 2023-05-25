import sys
from prefect import flow, get_run_logger
from prefect.blocks.system import Secret
from sqlalchemy import create_engine, text

@flow()
def create_database(dbname: str, postgres_secret: str):
    get_run_logger().info("Get credentials")
    postgres_connection_string = Secret.load(postgres_secret).get()

    get_run_logger().info("Connect to postgres")
    db = create_engine(postgres_connection_string)
    conn = db.connect()
    conn.autocommit = True

    get_run_logger().info("Create database if not exists")
    db_list = [name[0] for name in conn.execute(text("SELECT datname FROM pg_database;"))]
    if dbname.lower() not in db_list:
        conn.execute(text("COMMIT"))
        conn.execute(text("CREATE DATABASE {};".format(dbname)))
    conn.close()

if __name__ == "__main__":
    dbname = sys.argv[1]
    postgres_secret = sys.argv[2]
    create_database(dbname, postgres_secret)