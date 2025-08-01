output "argocd_url" {
  description = "The Argo CD UI endpoint"
  value       = "http://argocd-server.${var.namespace}.svc.cluster.local"
}

output "argocd_namespace" {
  description = "The namespace where Argo CD is installed"
  value       = var.namespace
}
