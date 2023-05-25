FROM python:3.8

WORKDIR /app

ADD . /app

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    # install prequired modules to support install of mlflow and related components
    apt-get install -y --no-install-recommends nodejs build-essential openjdk-11-jre-headless \
    # cmake and protobuf-compiler required for onnx install
    cmake protobuf-compiler && \
    # install required python packages
    pip install mlflow boto3 psycopg2-binary psycopg2 && \
    # clean cache
    apt-get autoremove -yqq --purge && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    npm cache clean --force && \
    # adding an unprivileged user
    groupadd --gid 10001 mlflow && \
    useradd --uid 10001 --gid mlflow --shell /bin/bash --create-home mlflow

# the "mlflow" user created above, represented numerically for optimal compatibility with Kubernetes security policies
USER 10001

CMD ["bash"]