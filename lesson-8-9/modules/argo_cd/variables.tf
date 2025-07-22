variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Namespace to install Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_repository" {
  description = "Helm chart repository URL"
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "argo-cd"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "5.27.4" # Приклад, онови за потреби
}
