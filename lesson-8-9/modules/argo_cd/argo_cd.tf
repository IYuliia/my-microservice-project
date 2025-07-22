provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  repository = var.chart_repository
  chart      = var.chart_name
  namespace  = var.namespace
  version    = var.chart_version

  values = [file("${path.module}/values.yaml")]

  create_namespace = true

  depends_on = [null_resource.wait_for_namespace]
}

resource "null_resource" "wait_for_namespace" {
  provisioner "local-exec" {
    command = "kubectl wait --for=condition=available --timeout=300s deployment/argo-cd-server -n ${var.namespace}"
  }
  triggers = {
    always_run = timestamp()
  }
}
