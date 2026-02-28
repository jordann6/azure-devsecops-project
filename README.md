Azure DevSecOps Project: Blue/Green AKS Deployment
This project demonstrates a production-grade DevSecOps pipeline for a containerized Python application. It utilizes a security-first approach, featuring Infrastructure as Code (IaC), multi-stage Docker builds, and a Blue/Green deployment strategy on Azure Kubernetes Service (AKS).

Architecture Overview
The system architecture includes the following components:

Infrastructure: Provisioned via Terraform, including Azure Kubernetes Service (AKS) and Azure Container Registry (ACR).

Application: A Flask-based web application served by Gunicorn.

Containerization: Multi-stage Docker builds to reduce attack surface and image size.

Security: Non-root user execution within containers and integrated vulnerability scanning.

Deployment: Blue/Green strategy to ensure zero-downtime updates and easy rollbacks.

Prerequisites
Azure CLI

Terraform

Docker Desktop (configured for linux/amd64 builds)

kubectl

.Project Structure
├── .github/workflows/ # CI/CD pipeline definitions
├── infra/ # Terraform HCL files for Azure provisioning
├── manifests/ # Kubernetes deployment and service YAMLs
├── src/ # Python application source code
├── Dockerfile # Multi-stage Docker configuration
└── requirements.txt # Python dependencies

Implementation Notes
Architecture Mismatch & Troubleshooting

During initial development on Apple Silicon (ARM64), a CrashLoopBackOff error (exec format error) was identified when deploying to Azure's AMD64 nodes. This was resolved by implementing multi-platform builds:
docker build --platform linux/amd64 -t <acr-name>.azurecr.io/app:v1 .

Security Hardening

The Dockerfile utilizes a two-stage build process:

Builder Stage: Compiles dependencies and prepares the environment.

Runtime Stage: Copies only necessary binaries to a python:slim base image and executes as a non-root appuser to prevent container escape vulnerabilities.

Cost Management
Infrastructure is managed as ephemeral environments. The following commands are used to manage the cloud lifecycle:

terraform apply: Provisions the full environment.

terraform destroy: Tears down all resources to prevent unnecessary cloud spend.
