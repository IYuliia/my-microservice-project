resource "helm_repository" "grafana" {
  name = "grafana"
  url  = var.chart_repository
}

resource "helm_release" "grafana" {
  name       = var.release_name
  repository = helm_repository.grafana.name
  chart      = var.chart_name
  namespace  = var.namespace
  version    = var.chart_version
  values = [
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

  # depends_on = [kubernetes_namespace.monitoring] 
}