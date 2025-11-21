# Mechyam Infrastructure & DevOps Automation

This repository contains the **Infrastructure as Code (IaC)** and **Kubernetes Manifests** required to deploy the Mechyam application (Java Backend + React Frontend) on AWS EKS using GitOps principles.

## 🚀 Project Overview

The project implements a full DevOps lifecycle, including infrastructure provisioning, container orchestration, CI/CD pipelines, and GitOps synchronization.

### 🛠️ Tech Stack
* **Cloud Provider:** AWS (Amazon Web Services)
* **Infrastructure as Code:** Terraform (VPC, EKS, Security Groups)
* **Orchestration:** Kubernetes (AWS EKS)
* **GitOps:** ArgoCD (Automated Sync & Self-Healing)
* **CI Pipeline:** GitHub Actions (Docker Build & Push)
* **Containerization:** Docker (Multi-stage builds)
* **Database:** MySQL (In-cluster deployment)

---

## 📂 Repository Structure

```text
mechyam-infra/
├── terraform/             # Terraform code to provision AWS EKS Cluster
│   ├── main.tf            # VPC, EKS, and Node Group definitions
│   ├── variables.tf       # Configurable variables (Region, Instance Types)
│   ├── outputs.tf         # Outputs (Cluster Name, Kubeconfig command)
│   └── versions.tf        # Provider constraints
│
├── k8s/                   # Kubernetes Manifests (The "Desired State")
│   ├── namespace.yaml     # 'devops-assignment' namespace
│   ├── mysql.yaml         # MySQL Deployment & Service
│   ├── backend-deployment.yaml  # Spring Boot App with Probes & Prometheus config
│   ├── backend-service.yaml     # ClusterIP Service for Backend
│   ├── frontend-deployment.yaml # React App (Nginx)
│   ├── frontend-service.yaml    # LoadBalancer Service (Public Access)
│   └── configmap.yaml           # Environment Configuration
│
└── argocd/                # ArgoCD Configuration
    └── application.yaml   # App-of-Apps definition for GitOps Sync
```
⚙️ Deployment Instructions
Prerequisites
AWS CLI (configured with credentials)

Terraform (v1.6+)

Kubectl

Git

Phase 1: Infrastructure Provisioning (Terraform)
Navigate to the terraform directory:
```
cd terraform
```
Initialize and Apply:
```
terraform init
terraform apply --auto-approve
```
(This will create a VPC, Public Subnets, and an EKS Cluster with t3.medium nodes).

Connect to the Cluster:
```
aws eks update-kubeconfig --region ap-south-1 --name mechyam-eks
```
Phase 2: GitOps Bootstrap (ArgoCD)
Install ArgoCD into the cluster:
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
Apply the GitOps Application manifest:
```
kubectl apply -f argocd/application.yaml
ArgoCD Automation:
```
ArgoCD will detect the k8s/ folder in this repository.

It will automatically sync the state, create the devops-assignment namespace, and deploy MySQL, Backend, and Frontend.

Self-Heal Enabled: Any manual changes to the cluster will be automatically overwritten by Git.

🔍 Observability & Configuration Features
Prometheus Metrics:

Pods are annotated with prometheus.io/scrape: "true" and prometheus.io/path: "/mechyam/actuator/prometheus".

Health Checks (Probes):

Liveness & Readiness Probes are configured with extended timeouts (5s) and delays (60s+) to accommodate Java Spring Boot startup times.

Redis health checks are explicitly disabled via MANAGEMENT_HEALTH_REDIS_ENABLED=false to prevent false negatives.

Zero-Downtime Deployment:

Kubernetes Rolling Updates are enabled.

Service Discovery:
```
Frontend connects to Backend via internal DNS: http://backend-service:8080.
```
🧪 Verification
To verify the deployment is successful:

Check Pod Status:
```
kubectl get pods -n devops-assignment
```
# Expected: All pods should be 1/1 Running

Get Public URL:
```
kubectl get svc frontend-service -n devops-assignment
Copy the EXTERNAL-IP (AWS Load Balancer URL) to access the application.
```
🧹 Cleanup
To destroy all resources and stop billing:
```
cd terraform
terraform destroy --auto-approve
```
Author: Rohith Kumar Project: DevOps Assignment
