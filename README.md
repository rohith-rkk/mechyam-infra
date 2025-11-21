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

## ⚙️ Deployment Instructions
Prerequisites
AWS CLI (configured with credentials)

Terraform (v1.6+)

Kubectl

Git

## Phase 1: Infrastructure Provisioning (Terraform)
1.Navigate to the terraform directory:
cd terraform
2.Initialize and Apply:
terraform init
terraform apply --auto-approve
(This will create a VPC, Public Subnets, and an EKS Cluster with t3.medium nodes).

3.Connect to the Cluster:
aws eks update-kubeconfig --region ap-south-1 --name mechyam-eks

## Phase 2: GitOps Bootstrap (ArgoCD)
1.Install ArgoCD into the cluster:
kubectl create namespace argocd
kubectl apply -n argocd -f [https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml](https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml)
