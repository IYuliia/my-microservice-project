output "jenkins_url" {
  description = "URL of the Jenkins service"
  value       = module.jenkins.jenkins_url
}

output "admin_password" {
  description = "Initial admin password for Jenkins"
  value       = module.jenkins.admin_password
}
