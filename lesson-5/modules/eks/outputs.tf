output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}
