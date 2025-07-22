variable "namespace" {
  type        = string
  description = "Namespace для Jenkins"
  default     = "jenkins"
}

variable "chart_version" {
  type        = string
  description = "Версія Helm чарта Jenkins"
  default     = "3.5.5"
}

variable "jenkins_admin_password" {
  type        = string
  description = "Пароль адміністратора Jenkins"
  default     = "changeme"
}


