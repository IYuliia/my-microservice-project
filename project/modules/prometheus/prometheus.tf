resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_repository" "kube_prometheus_stack" {
  name = "prometheus-community"
  url  = var.chart_repository
}

# Розгортання Prometheus Helm Release
resource "helm_release" "kube_prometheus_stack" {
  name       = var.release_name
  repository = helm_repository.kube_prometheus_stack.name
  chart      = var.chart_name
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = var.chart_version
  values = [prometheus.tf
    file("${path.module}/values.yaml")
  ]

  dynamic "set" {
    for_each = var.set_values
    content {
      name  = set.value.name
      value = set.value.value
      type  = set.value.type
    }
  }

  depends_on = [
    kubernetes_namespace.monitoring
  ]
}