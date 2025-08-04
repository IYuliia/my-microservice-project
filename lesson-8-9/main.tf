provider "aws" {
  region = "eu-central-1"
}

provider "kubernetes" {
  host                   = module.eks.endpoint
  cluster_ca_certificate = base64decode(module.eks.kubeconfig_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}



module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-bucket-hw-devops-iyuliia"   
  table_name  = "terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "lesson-5-vpc"
}

module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-5-ecr"
  scan_on_push = true
}

module "eks" {
  source       = "./modules/eks"
  region = "eu-central-1"
  cluster_name = "my-eks-cluster"
  subnet_ids   = module.vpc.private_subnet_ids
}

module "jenkins" {
  source      = "./modules/jenkins"
  
  namespace          = "jenkins"
  jenkins_admin_password = "StrongPassword123"
  kubeconfig_path    = "~/.kube/config"
  chart_repository   = "https://charts.jenkins.io"
  chart_name         = "jenkins"
  chart_version      = "4.1.5"
}

module "argo_cd" {
  source      = "./modules/argo_cd"
  
  kubeconfig_path  = "~/.kube/config"
  namespace        = "argocd"
  chart_repository = "https://argoproj.github.io/argo-helm"
  chart_name       = "argo-cd"
  chart_version    = "5.27.4"
}

module "rds" {
  source         = "./modules/rds"
  use_aurora     = true
  db_engine      = "postgres"
  engine_version = "14.9"
  instance_class = "db.t3.medium"
  db_name        = "exampledb"
  db_username    = "admin"
  db_password    = "YourStrongPassword123!"
  subnet_ids     = module.vpc.private_subnets
  vpc_id         = module.vpc.vpc_id
}
