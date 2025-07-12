## Lesson 6 — Kubernetes Deployment with Terraform, ECR, and Helm
# Проєкт: Деплой Django-застосунку в кластер Kubernetes на AWS
# Структура проєкту
```
lesson-6/
├── main.tf
├── backend.tf
├── outputs.tf
├── modules/
│   ├── s3-backend/
│   ├── vpc/
│   ├── ecr/
│   └── eks/
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── values.yaml
│       └── Chart.yaml
```
 
# Компоненти
Kubernetes кластер (EKS) створено через Terraform у вже існуючій VPC.

ECR репозиторій створено через Terraform, образ Django додано через Docker + AWS CLI.

# Helm chart реалізує:

Deployment з образом із ECR та підключенням ConfigMap

Service типу LoadBalancer для доступу до застосунку

HPA (Horizontal Pod Autoscaler) для автозбільшення кількості подів

ConfigMap зі змінними середовища з теми 4

README.md з описом усіх етапів розгортання

# Кроки розгортання
1. Ініціалізація Terraform
```
terraform init
```
2. Створення інфраструктури
```
terraform apply
```
⚠️ Переконайтесь, що у вас є правильні AWS credentials (aws configure або через ~/.aws/credentials).

3. Побудова та пуш Docker-образу
```
# Login to ECR
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.<region>.amazonaws.com

# Build image
docker buildx build -t <image-name>:latest .

# Tag and push
docker tag <image-name>:latest <repo-url>:latest
docker push <repo-url>:latest
```
4. Деплой через Helm
```
helm upgrade --install django-app ./charts/django-app --namespace default
```
# Перевірка
```
# Перевірка подів
kubectl get pods

# Сервіс із LoadBalancer
kubectl get svc

# HPA
kubectl get hpa
```
# Результат
Доступ до застосунку через зовнішню IP-адресу (kubectl get svc).

Автомасштабування працює (HPA піднімає поди при навантаженні).

Django-застосунок використовує змінні середовища з ConfigMap.