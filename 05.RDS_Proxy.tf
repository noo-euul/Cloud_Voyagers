
##################################################################
##################################################################

resource "aws_db_proxy" "fastapi_proxy" {
  provider = aws.seoul
  name                   = "rds-fastapi-proxy"
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = false
  role_arn               = aws_iam_role.eks_rds_role.arn
  vpc_security_group_ids = [
    aws_security_group.aurora_sg.id,
    aws_security_group.proxy_sg.id,
    aws_security_group.eks_sg.id,
    data.aws_security_group.eks_seoul_cluster_sg.id
    ]
  vpc_subnet_ids = [aws_subnet.CV_private_seoul_a.id, aws_subnet.CV_private_seoul_c.id]

  auth {
    auth_scheme = "SECRETS"   # IAM OR SECRET
    description = "IAM authentication for AuroraDB"
    secret_arn  = aws_secretsmanager_secret.rds_secret.arn
    iam_auth = "DISABLED"
  }
  
  depends_on = [aws_iam_role.eks_rds_role,
    aws_security_group.aurora_sg,
    aws_security_group.proxy_sg,
    aws_security_group.eks_sg,
    data.aws_security_group.eks_seoul_cluster_sg]
}

resource "aws_db_proxy_target" "rds_proxy_target" {
  provider = aws.seoul
  db_proxy_name          = aws_db_proxy.fastapi_proxy.name
  target_group_name      = "default"
  db_cluster_identifier  = aws_rds_cluster.aurora_mysql.cluster_identifier

  depends_on = [ aws_db_proxy.fastapi_proxy ]
}

##################################################################
##################################################################

resource "aws_db_proxy" "fastapi_proxy_us" {
  provider = aws.virginia
  name                   = "rds-fastapi-proxy-us"
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = false
  role_arn               = aws_iam_role.eks_rds_role.arn
  vpc_security_group_ids = [
    aws_security_group.aurora_sg_us.id,
    aws_security_group.proxy_sg_us.id,
    aws_security_group.eks_sg_us.id,
    data.aws_security_group.eks_virginia_cluster_sg.id
    ]
  vpc_subnet_ids         = [aws_subnet.CV_private_virginia_a.id, aws_subnet.CV_private_virginia_c.id]

  auth {
    auth_scheme = "SECRETS"   # IAM OR SECRET
    description = "IAM authentication for AuroraDB"
    secret_arn  = aws_secretsmanager_secret.rds_secret_us.arn
    iam_auth = "DISABLED"
  }

    depends_on = [
      aws_iam_role.eks_rds_role,
      aws_security_group.aurora_sg_us,
      aws_security_group.proxy_sg_us,
      aws_security_group.eks_sg_us,
      data.aws_security_group.eks_virginia_cluster_sg]
}

resource "aws_db_proxy_target" "rds_proxy_target_us" {
  provider = aws.virginia
  db_proxy_name          = aws_db_proxy.fastapi_proxy_us.name
  target_group_name      = "default"
  db_cluster_identifier  = aws_rds_cluster.aurora_mysql_us.cluster_identifier

  depends_on = [ aws_db_proxy.fastapi_proxy_us ]
}
