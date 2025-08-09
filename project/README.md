# Final DevOps Project

## Project Structure

- Project/
  - main.tf               — Main Terraform file for module connections
  - backend.tf            — Backend config for Terraform state (S3 + DynamoDB)
  - outputs.tf            — Common outputs for deployed resources
  - modules/              — All Terraform modules
    - s3-backend/         — S3 and DynamoDB backend storage
      - s3.tf
      - dynamodb.tf
      - variables.tf
      - outputs.tf
    - vpc/                — VPC and networking
      - vpc.tf
      - routes.tf
      - variables.tf
      - outputs.tf
    - ecr/                — AWS ECR for container images
      - ecr.tf
      - variables.tf
      - outputs.tf
    - eks/                — AWS EKS cluster
      - eks.tf
      - aws_ebs_csi_driver.tf
      - variables.tf
      - outputs.tf
    - rds/                — AWS RDS database
      - rds.tf
      - aurora.tf
      - shared.tf
      - variables.tf
      - outputs.tf
    - jenkins/            — Helm deployment of Jenkins
      - jenkins.tf
      - variables.tf
      - providers.tf
      - values.yaml
      - outputs.tf
    - argo_cd/            — Helm deployment of Argo CD
      - argo_cd.tf
      - variables.tf
      - providers.tf
      - values.yaml
      - outputs.tf
      - charts/            — Argo CD applications & repositories
        - Chart.yaml
        - values.yaml
        - templates/
          - application.yaml
          - repository.yaml
  - charts/
    - django-app/
      - templates/
        - deployment.yaml
        - service.yaml
        - configmap.yaml
        - hpa.yaml
      - Chart.yaml
      - values.yaml
  - Django/
    - app/
    - Dockerfile
    - Jenkinsfile
    - docker-compose.yaml



---

## Detailed Project Description

### **Purpose**
This project demonstrates a full-cycle DevOps workflow using **AWS Infrastructure as Code** with **Terraform**, **Kubernetes (EKS)**, **CI/CD pipelines**, and **monitoring**.

It covers:
- Infrastructure provisioning
- Application deployment
- Continuous integration & delivery
- Monitoring & observability

---

## **Technical Requirements**

- **Infrastructure:** AWS (managed via Terraform)
- **Components:**
  - VPC
  - EKS (Kubernetes cluster)
  - RDS (database)
  - ECR (container registry)
  - Jenkins (CI/CD)
  - Argo CD (GitOps deployment)
  - Prometheus & Grafana (monitoring)

---

## **Execution Steps**

### **1. Environment Preparation**
```
terraform init
```

### **2. Deploy Infrastructure**
Run:

```
terraform apply
```

Check the status of deployed resources:

```
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n monitoring
```

### **3. Access Services**
Jenkins

```
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```

Open: http://localhost:8080

Argo CD

```
kubectl port-forward svc/argocd-server 8081:443 -n argocd
```

Open: http://localhost:8081

### **4. Monitoring**
Grafana

```
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

Open: http://localhost:3000
Check metrics in Grafana Dashboard.
