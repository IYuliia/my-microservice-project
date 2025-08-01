# CI/CD Pipeline with Jenkins, Helm, Terraform, and Argo CD
## Project Overview
This project implements a full CI/CD process using Jenkins, Helm, Terraform, and Argo CD for a Django application deployed on Kubernetes. The pipeline automates the following:

Building a Docker image of the Django app.

Publishing the Docker image to AWS Elastic Container Registry (ECR).

Updating the Helm chart repository with the new image tag.

Deploying and synchronizing the app in Kubernetes via Argo CD, which monitors the Helm chart repository for changes.

## Project Structure
```
lesson-8-9/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB
├── outputs.tf               # Загальні виводи ресурсів
│
├── modules/                 # Каталог з усіма модулями
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакета
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf  
│   ├── ecr/                 # Модуль для ECR
│   │   ├── ecr.tf           # Створення ECR репозиторію
│   │   ├── variables.tf     # Змінні для ECR
│   │   └── outputs.tf       # Виведення URL репозиторію
│   │
│   ├── eks/                      # Модуль для Kubernetes кластера
│   │   ├── eks.tf                # Створення кластера
│   │   ├── aws_ebs_csi_driver.tf # Встановлення плагіну csi drive
│   │   ├── variables.tf     # Змінні для EKS
│   │   └── outputs.tf       # Виведення інформації про кластер
│   │
│   ├── jenkins/             # Модуль для Helm-установки Jenkins
│   │   ├── jenkins.tf       # Helm release для Jenkins
│   │   ├── variables.tf     # Змінні (ресурси, креденшели, values)
│   │   ├── providers.tf     # Оголошення провайдерів
│   │   ├── values.yaml      # Конфігурація jenkins
│   │   └── outputs.tf       # Виводи (URL, пароль адміністратора)
│   │ 
│   └── argo_cd/             # ✅ Новий модуль для Helm-установки Argo CD
│       ├── jenkins.tf       # Helm release для Jenkins
│       ├── variables.tf     # Змінні (версія чарта, namespace, repo URL тощо)
│       ├── providers.tf     # Kubernetes+Helm.  переносимо з модуля jenkins
│       ├── values.yaml      # Кастомна конфігурація Argo CD
│       ├── outputs.tf       # Виводи (hostname, initial admin password)
│		    └──charts/                  # Helm-чарт для створення app'ів
│ 	 	    ├── Chart.yaml
│	  	    ├── values.yaml          # Список applications, repositories
│			    └── templates/
│		        ├── application.yaml
│		        └── repository.yaml
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml     # ConfigMap зі змінними середовища
```

## Terraform Workflow
Run these commands to provision all infrastructure components:

```
terraform init
terraform validate
terraform apply -auto-approve
```

terraform init — initializes Terraform working directory and backend.

terraform validate — checks syntax and configuration correctness.

terraform apply — deploys resources defined in Terraform configurations (Jenkins, Argo CD, EKS, ECR, etc).

## Accessing Services

Jenkins UI:
URL: http://<jenkins-url> (check Terraform output)
Default Admin Password: (from Terraform output jenkins_admin_password)

Argo CD UI:
URL: http://<argocd-url> (from Terraform output)
Default Admin Password: (from Terraform output argocd_admin_password)

## Jenkins Pipeline Usage

The Jenkins pipeline is configured via Jenkinsfile to:

Build the Django app Docker image using Kaniko agent.

Push the image to AWS ECR.

Update the Helm chart’s values.yaml with the new Docker image tag.

Commit and push changes back to the Helm chart Git repository.

Trigger the pipeline manually from Jenkins UI or configure webhook triggers.

## Argo CD Application

Argo CD monitors the Helm chart Git repository.

When Helm chart updates are pushed (by Jenkins pipeline), Argo CD automatically syncs changes and deploys the updated app to Kubernetes.

You can check Argo CD app status using:

```
argocd app get <app-name>
argocd app sync <app-name>
```

## Notes & Troubleshooting

Ensure your local kubeconfig has access to the Kubernetes cluster.

Jenkins requires AWS credentials with ECR push permissions.

Argo CD needs permissions to access your Helm chart Git repository.

Check pod statuses for Jenkins and Argo CD in their respective namespaces:

```
kubectl get pods -n jenkins
kubectl get pods -n argocd
```