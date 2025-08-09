resource "aws_rds_cluster" "aurora" {
  count                     = var.use_aurora ? 1 : 0
  cluster_identifier        = "aurora-cluster"
  engine                    = var.db_engine
  engine_version            = var.engine_version
  master_username           = var.db_username
  master_password           = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.this.name
  vpc_security_group_ids    = [aws_security_group.this.id]
  skip_final_snapshot       = true
}

resource "aws_rds_cluster_instance" "aurora_writer" {
  count              = var.use_aurora ? 1 : 0
  identifier         = "aurora-writer"
  cluster_identifier = aws_rds_cluster.aurora[0].id
  instance_class     = var.instance_class
  engine             = var.db_engine
}
