output "jenkins_url" {
  value = "http://jenkins.${var.namespace}.svc.cluster.local:8080"
}

output "jenkins_namespace" {
  value = var.namespace
}
