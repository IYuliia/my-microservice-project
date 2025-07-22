output "argo_cd_server_url" {
  description = "URL to access Argo CD server"
  value       = "https://${helm_release.argo_cd.name}.${var.namespace}.svc.cluster.local"
}

output "argo_cd_admin_password" {
  description = "Initial admin password for Argo CD"
  value       = kubernetes_secret.argo_cd_initial_admin_password.data["password"]
  sensitive   = true
}
