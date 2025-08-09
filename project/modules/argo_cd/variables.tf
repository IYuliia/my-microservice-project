variable "kubeconfig_path" {
  description = "Path to kubeconfig"
  type        = string
  default     = "~/.kube/config"
}

variable "chart_repository" {
  description = "Helm chart repository URL"
  type        = string
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
}

variable "namespace" {
  description = "Namespace to deploy Argo CD"
  type        = string
  default     = "argocd"
}
