# 🚀 Project4 - EKS Microservices Platform

## 📌 Overview

Project4 is a cloud-native microservices platform deployed on Amazon EKS using Kubernetes and automated through a Jenkins CI/CD pipeline.

### Features

- Infrastructure as Code using Terraform
- Amazon EKS Cluster Deployment
- Kubernetes Deployments and Services
- AWS Load Balancer Controller
- ALB Ingress
- IAM Roles for Service Accounts (IRSA)
- OIDC Provider Integration
- Jenkins CI/CD Pipeline
- Docker Image Build & Push
- GitHub Webhooks
- Microservice-to-Microservice Communication

---

# 🏗 Architecture

```text
Developer
    │
    ▼
 GitHub Repository
    │
    ▼
 Jenkins Pipeline
    │
    ├── Build Docker Images
    ├── Push Images to Docker Hub
    └── Deploy to EKS
    │
    ▼
 Amazon EKS Cluster
    │
    ▼
 AWS Load Balancer Controller
    │
    ▼
 Application Load Balancer
    │
    ▼
 End Users

Microservice Communication

User Service
      │
      ▼
Order Service
      │
      ▼
Product Service
```

---

# 🛠 Tech Stack

## Cloud

- AWS
- Amazon EKS
- IAM
- EC2
- VPC
- Application Load Balancer

## DevOps

- Terraform
- Jenkins
- Docker
- GitHub

## Kubernetes

- Deployments
- Services
- Ingress
- Namespaces
- Service Discovery

## Application

- Python
- Flask
- Gunicorn

---

# 📂 Project Structure

```text
Project4-EKS-Microservices-Platform/

├── Terraform/
│   ├── provider.tf
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── K8s/
│   ├── namespace.yaml
│   ├── ingress/
│   │   └── ingress.yaml
│   ├── user-service/
│   ├── product-service/
│   └── order-service/
│
├── user-service/
├── product-service/
├── order-service/
│
└── Jenkinsfile
```

---

# 🚀 Deploy Infrastructure

## Initialize Terraform

```bash
terraform init
```

## Validate

```bash
terraform validate
```

## Plan

```bash
terraform plan
```

## Apply

```bash
terraform apply
```

---

# ☸ Configure kubectl

```bash
aws eks update-kubeconfig \
--region ap-south-1 \
--name project4-eks
```

Verify:

```bash
kubectl get nodes
```

---

# 🔐 Configure OIDC Provider

Check OIDC URL:

```bash
aws eks describe-cluster \
--name project4-eks \
--region ap-south-1 \
--query "cluster.identity.oidc.issuer" \
--output text
```

Associate OIDC Provider:

```bash
eksctl utils associate-iam-oidc-provider \
--cluster project4-eks \
--region ap-south-1 \
--approve
```

Verify:

```bash
aws iam list-open-id-connect-providers
```

---

# 🔐 Create IAM Policy For AWS Load Balancer Controller

Download Policy

```bash
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
```

Create Policy

```bash
aws iam create-policy \
--policy-name AWSLoadBalancerControllerIAMPolicy \
--policy-document file://iam_policy.json
```

---

# 👤 Create IRSA Service Account

```bash
eksctl create iamserviceaccount \
--cluster=project4-eks \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--role-name AmazonEKSLoadBalancerControllerRole \
--attach-policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/AWSLoadBalancerControllerIAMPolicy \
--approve
```

Verify:

```bash
kubectl get sa aws-load-balancer-controller -n kube-system
```

---

# 🚦 Install AWS Load Balancer Controller

Add Helm Repository

```bash
helm repo add eks https://aws.github.io/eks-charts

helm repo update
```

Install Controller

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
-n kube-system \
--set clusterName=project4-eks \
--set serviceAccount.create=false \
--set serviceAccount.name=aws-load-balancer-controller
```

Verify:

```bash
kubectl get pods -n kube-system
```

Expected:

```text
aws-load-balancer-controller Running
```

---

# 📦 Deploy Kubernetes Resources

Create Namespace

```bash
kubectl apply -f K8s/namespace.yaml
```

Deploy Resources

```bash
kubectl apply -f K8s/
```

Verify

```bash
kubectl get pods -n project4

kubectl get svc -n project4

kubectl get ingress -n project4
```

---

# 🔄 Jenkins CI/CD Pipeline

Pipeline Flow

```text
Checkout
↓
Build User Service
↓
Build Product Service
↓
Build Order Service
↓
Docker Login
↓
Push Images
↓
Configure EKS Access
↓
Deploy To Kubernetes
↓
Verify Rollout
```

GitHub Webhook

```text
http://<JENKINS_PUBLIC_IP>:8080/github-webhook/
```

---

# 🌐 Application Endpoints

```text
/users
/products
/orders
```

Example

```text
http://<ALB-DNS>/users
```

---

# 🔄 Microservice Communication

User Service

```text
http://order-service/orders
```

Order Service

```text
http://product-service/products
```

Flow

```text
User Service
      │
      ▼
Order Service
      │
      ▼
Product Service
```

Example Response

```json
{
  "service": "user-service",
  "user": "Dhusinth",
  "order": {
    "service": "order-service",
    "order_id": 1001,
    "product": [
      {
        "id": 1,
        "name": "Laptop",
        "price": 50000,
        "stock": 10
      }
    ]
  }
}
```

---

# 🔍 Useful Commands

Get Nodes

```bash
kubectl get nodes
```

Get Pods

```bash
kubectl get pods -n project4
```

Get Services

```bash
kubectl get svc -n project4
```

Get Ingress

```bash
kubectl get ingress -n project4
```

View Logs

```bash
kubectl logs deployment/user-service -n project4

kubectl logs deployment/order-service -n project4

kubectl logs deployment/product-service -n project4
```

---

# 🐛 Troubleshooting

## Jenkins Cannot Access EKS

Error

```text
You must be logged in to the server
```

Fix

```bash
kubectl edit configmap aws-auth -n kube-system
```

Add:

```yaml
- rolearn: arn:aws:iam::<ACCOUNT_ID>:role/JenkinsEKSRole
  username: jenkins
  groups:
    - system:masters
```

---

## ImagePullBackOff

Error

```text
ImagePullBackOff
```

Cause

Images were built on Apple Silicon (ARM64) while EKS nodes are AMD64.

Verify

```bash
docker image inspect image-name \
--format='{{.Architecture}}'
```

Fix

Build images on Jenkins EC2 (AMD64).

---

## ALB Not Created

Verify Controller

```bash
kubectl get pods -n kube-system
```

Check

```text
aws-load-balancer-controller
```

Verify:

- OIDC Provider exists
- IAM Role attached
- IRSA configured

---

## Unauthorized kubectl Access

Verify IAM Identity

```bash
aws sts get-caller-identity
```

Refresh kubeconfig

```bash
aws eks update-kubeconfig \
--region ap-south-1 \
--name project4-eks
```

---

## Blank Page On ALB

Cause:

Ingress exposes:

```text
/users
/products
/orders
```

Root path `/` is not configured.

---

# 📸 Screenshots

Add screenshots under:

```text
/screenshots
```

Recommended screenshots:

- Architecture Diagram
- Jenkins Pipeline
- EKS Cluster
- AWS ALB
- Running Pods
- Ingress
- Microservice Communication Output

---

# 📚 Learning Outcomes

- Terraform Infrastructure as Code
- Amazon EKS
- Kubernetes Networking
- Service Discovery
- AWS Load Balancer Controller
- Jenkins CI/CD
- Docker Containerization
- IAM Roles for Service Accounts (IRSA)
- OIDC Authentication
- Microservices Architecture
- AWS Cloud Deployment

---

# 👨‍💻 Author

**Dhusinth**

DevOps | AWS | Kubernetes | Terraform | Jenkins | Docker