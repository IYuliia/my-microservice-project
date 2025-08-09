output "db_endpoint" {
  value = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : aws_db_instance.this[0].endpoint
}
