# Data Project 3

This repository contains a simple multi‑cloud application. The backend is built on AWS using a PostgreSQL RDS instance exposed through several Lambda functions and an API Gateway. A frontend written in Flask is containerised and deployed to Google Cloud Run. Data from the RDS instance can optionally be replicated into BigQuery using Google Datastream.

## Repository structure

```
infra/            # Terraform configuration
modules/          # Application code and SQL schema
```

- `modules/aws/*` contains the code for the Lambda functions.
- `modules/gcp/web` contains the Flask application used as a minimal UI.
- `modules/schemas/rds_products_schema.sql` defines the initial database schema and seed data.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform) 1.4+
- Docker engine with Buildx enabled (used to build Lambda and Cloud Run images)
- AWS credentials configured locally (for deploying RDS and Lambda)
- Google Cloud SDK authenticated to your project (for Artifact Registry and Cloud Run)
- Optional: Python 3.10+ if you want to run the Flask application locally

Before running Terraform you must provide values for the variables defined in `infra/terraform/variables.tf`. Copy `infra/terraform/terraform.tfvars` as a starting point and update the IDs, passwords and endpoints for your environment.

## Deploying with Terraform

1. Initialise the working directory:
   ```bash
   cd infra/terraform
   terraform init
   ```
2. Review the plan (optional):
   ```bash
   terraform plan
   ```
3. Apply the configuration:
   ```bash
   terraform apply
   ```
   Terraform will build and push Docker images for the Lambdas and the Flask service. On completion you will have an RDS instance, three Lambda functions behind an API Gateway, the Datastream configuration and a Cloud Run service.

## Running the Flask app locally

The frontend can also be executed without Cloud Run. This is useful for testing the UI during development.

```bash
cd modules/gcp/web
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

By default the application points to the API Gateway URL hard coded in `app.py`. Modify the `BASE_URL` constant if your API Gateway endpoint differs. Once started the app will be available at [http://localhost:8080](http://localhost:8080).

## Accessing the app on Cloud Run

When the Terraform deployment finishes, a Cloud Run service named `frontend` is created. You can obtain its URL with:

```bash
gcloud run services describe frontend --region <REGION> --format='value(status.url)'
```

Navigate to the URL in your browser to use the application hosted on Cloud Run.