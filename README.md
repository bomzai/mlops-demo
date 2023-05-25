# mlops-demo

A simple Data & MLOps stack.

## 1. Repository structure

```
.
├── configs/                   # Configuration file for each environment
│   ├── local_docker.env
│   └── ...
├── stack/                     # Each folder is a component of the stack
│   ├── prerequisite/          # This component is always deployed
│   ├── coder/
│   │   ├── scripts/           # Script and utilities folder       
│   │   │   ├── init.sh        # Initialisation script for the component
│   │   │   └── ...
│   │   ├── ...
│   │   └── docker-compose.yml # Docker-compose file use to deploy this component
│   ├── mlflow/
│   ├── prefect/
│   └── ...
├── examples/                  # Example code and various stuff
├── docs/                      # Docs
├── ...
├── deploy.sh
├── destroy.sh
└── README.md
```

## 2. Local docker deployment

### 2.1 How to deploy

1. Open a terminal at the root of this repo.

2. Deploy the stack using the deployment script and the sample configuration file:

    ```
    ./deploy.sh configs/local_docker.env coder mlflow prefect
    ```

3. Now you can connect to :
    - Coder : http://localhost:7080
    - MLFlow UI : http://localhost:5000
    - Prefect UI : http://localhost:4200

### 2.2 How to destroy

1. Open a terminal at the root of this repo.

2. Deploy the stack using the deployment script and the sample configuration file:

    ```
    ./destroy.sh configs/local_docker.env coder mlflow prefect
    ```

3. Everything has been cleaned up !