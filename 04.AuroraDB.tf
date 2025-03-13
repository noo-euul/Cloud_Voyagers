
resource "aws_db_subnet_group" "aurora_subnet_group" {
  provider   = aws.seoul
  name       = "aurora-subnet-group"
  subnet_ids = [
    aws_subnet.CV_private_seoul_a.id,
    aws_subnet.CV_private_seoul_c.id
    ]

  tags = {
    Name        = "Aurora-Subnet-Group"
  }
}

resource "aws_rds_cluster" "aurora_mysql" {
  provider           = aws.seoul
  apply_immediately  = true
  cluster_identifier = "aurora-mysql-cluster"
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.05.2"
  database_name      = "boyageDB"
  master_username    = "superadmin"
  master_password    = "qwer!234"
  storage_encrypted    = false
  deletion_protection  = false
  enable_http_endpoint = false
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_group.name
  iam_database_authentication_enabled = false
  skip_final_snapshot = true

  vpc_security_group_ids = [
    aws_security_group.aurora_sg.id,
    aws_security_group.proxy_sg.id,
    aws_security_group.eks_sg.id,
    ]

  tags = {
    Name        = "Aurora-MySQL-Cluster"
  }

  depends_on = [aws_db_subnet_group.aurora_subnet_group,aws_security_group.aurora_sg,aws_security_group.proxy_sg,aws_security_group.eks_sg]
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  provider           = aws.seoul
  count              = 2
  identifier         = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_mysql.id
  instance_class     = "db.t3.medium"
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.05.2"
  publicly_accessible = true

  tags = {
    Name        = "Aurora-Instance-${count.index}"
  }

  depends_on = [aws_rds_cluster.aurora_mysql]
}

##################################################################
##################################################################

resource "aws_db_subnet_group" "aurora_subnet_group_us" {
  provider   = aws.virginia
  name       = "aurora-subnet-group-us"
  subnet_ids = [
    aws_subnet.CV_private_virginia_a.id,
    aws_subnet.CV_private_virginia_c.id
    ]

  tags = {
    Name        = "Aurora-Subnet-Group-Us"
  }
}

resource "aws_rds_cluster" "aurora_mysql_us" {
  provider           = aws.virginia
  apply_immediately  = true
  cluster_identifier = "aurora-mysql-cluster-us"
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.05.2"
  database_name      = "boyageDB"
  master_username    = "superadmin"
  master_password    = "qwer!234"
  storage_encrypted    = false  # ✅ KMS로 암호화 가능
  deletion_protection  = false
  enable_http_endpoint = false  # ✅ HTTP 비활성화 (보안 강화)
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_group_us.name
  iam_database_authentication_enabled = false
  skip_final_snapshot = true

  vpc_security_group_ids = [
    aws_security_group.aurora_sg_us.id,
    aws_security_group.proxy_sg_us.id,
    aws_security_group.eks_sg_us.id,
    ]

  tags = {
    Name        = "Aurora-MySQL-Cluster-Us"
  }

  depends_on = [aws_db_subnet_group.aurora_subnet_group_us,aws_security_group.aurora_sg_us,aws_security_group.proxy_sg_us,aws_security_group.eks_sg_us]
}

resource "aws_rds_cluster_instance" "aurora_instance_us" {
  provider           = aws.virginia
  count              = 2
  identifier         = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_mysql_us.id
  instance_class     = "db.t3.medium"
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.05.2"
  publicly_accessible = true

  tags = {
    Name        = "Aurora-Instance-${count.index}"
  }

  depends_on = [aws_rds_cluster.aurora_mysql_us]
}
