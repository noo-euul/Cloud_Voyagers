
resource "random_string" "node_suffix" {
  length  = 4
  special = false
  upper   = false
}

provider "aws" {
  region = "ap-northeast-2"  # 서울 리전
  alias  = "seoul"
}

provider "aws" {
  region = "us-east-1"  # 버지니아 리전
  alias  = "virginia"
}

variable "key_name" {
  default = "rds-fastapi-secret28"
}

variable "id_count" {
  default = "703671924997"
}

variable "id_admin" {
  default = "wkohadmin"
}

variable "region_seoul" {
  default = "ap-northeast-2"
}

variable "region_virginia" {
  default = "us-east-1"
}

##################################################################
##################################################################

resource "aws_secretsmanager_secret" "rds_secret" { 
  provider = aws.seoul
  name = var.key_name
  kms_key_id = aws_kms_key.boyage_key.arn
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  provider = aws.seoul
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = "superadmin"
    password = "qwer!234"
  })
}

resource "aws_secretsmanager_secret" "rds_secret_us" { 
  provider = aws.virginia
  name = var.key_name
  kms_key_id = aws_kms_key.boyage_key_us.arn
}

resource "aws_secretsmanager_secret_version" "rds_secret_version_us" {
  provider = aws.virginia
  secret_id     = aws_secretsmanager_secret.rds_secret_us.id
  secret_string = jsonencode({
    username = "superadmin"
    password = "qwer!234"
  })
}

##################################################################
##################################################################

resource "aws_kms_key" "boyage_key" {
  provider = aws.seoul
  description             = "KMS key for encrypting EKS DB Secrets"
  deletion_window_in_days = 7
  enable_key_rotation     = true

    policy = jsonencode({
    Version = "2012-10-17",
    Id      = "KMS_Initial_Policy",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = "*"
        },
        Action    = "kms:*",
        Resource  = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "eks_db_kms_alias" {
  provider = aws.seoul
  name          = "alias/eks-db-kms"
  target_key_id = aws_kms_key.boyage_key.key_id
}

resource "aws_kms_key" "boyage_key_us" {
  provider = aws.virginia
  description             = "KMS key for encrypting EKS DB Secrets"
  deletion_window_in_days = 7
  enable_key_rotation     = true

    policy = jsonencode({
    Version = "2012-10-17",
    Id      = "kms-initial-policy",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = "*"
        },
        Action    = "kms:*",
        Resource  = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "eks_db_kms_alias_us" {
  provider = aws.virginia
  name          = "alias/eks-db-kms"
  target_key_id = aws_kms_key.boyage_key_us.key_id
}

resource "aws_iam_policy_attachment" "attach_vpc_full_access" {
  name       = "attach_vpc_full_access"
  roles      = []
  users      = ["${var.id_admin}"]
  groups     = []
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_kms_key_policy" "guardduty_kms_policy" {
  provider = aws.seoul
  key_id = aws_kms_key.boyage_key.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowRootAccountFullAccess",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.id_count}:root"
        },
        Action    = "kms:*",
        Resource  = "*"
      },
      {
        Sid       = "AllowGuardDutyToEncrypt",
        Effect    = "Allow",
        Principal = {
          Service = "guardduty.amazonaws.com"
        },
        Action   = [
          "kms:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_key_policy" "guardduty_kms_policy_us" {
  provider = aws.virginia
  key_id = aws_kms_key.boyage_key_us.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowRootAccountFullAccess",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.id_count}:root"
        },
        Action    = "kms:*",
        Resource  = "*"
      },
      {
        Sid       = "AllowGuardDutyToEncrypt",
        Effect    = "Allow",
        Principal = {
          Service = "guardduty.amazonaws.com"
        },
        Action   = [
          "kms:*"
        ],
        Resource = "*"
      }
    ]
  })
}

##################################################################
##################################################################

resource "aws_iam_role" "eks_role" {
  name = "EKS_Role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = [
            "eks.amazonaws.com",
            "ec2.amazonaws.com",
            "kms.amazonaws.com",
            "lambda.amazonaws.com",
            "rds.amazonaws.com",
            "dms.amazonaws.com",
            "secretsmanager.amazonaws.com",
            "iam.amazonaws.com",
            "apigateway.amazonaws.com",
            "cloudfront.amazonaws.com",
            "route53.amazonaws.com",
            "elasticache.amazonaws.com"
          ] 
        },
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_access_attach" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy" "eks_proxy_access" {
  name        = "EKS_Proxy_Access"
  description = "Allow users to access EKS Kubernetes API via IAM authentication"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "eks:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_proxy_access_attach" {
  role       = aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.eks_proxy_access.arn
}

resource "aws_iam_policy" "iam_pass_role" {
  name        = "IAM_PassRole_Policy"
  description = "Allow IAM roles to be passed to EKS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "iam:PassRole"
        ],
        Resource = aws_iam_role.eks_role.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam_pass_role_attach" {
  role       = aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.iam_pass_role.arn
}

resource "aws_iam_policy" "eks_management_policy" {
  name        = "EKS_Management_Policy"
  description = "Policy to manage EKS clusters with identity provider config"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "eks:AssociateIdentityProviderConfig",
          "eks:DescribeCluster",
          "eks:UpdateClusterConfig",
          "eks:UpdateClusterVersion",
          "eks:TagResource",
          "eks:AccessKubernetesApi"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_management_policy_attach" {
  role       = aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.eks_management_policy.arn
}

##################################################################
##################################################################

resource "aws_iam_role" "eks_rds_role" {
  name = "EKS_RDS_Node_Role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
     {
        Effect = "Allow",
        Principal = { Service = [
            "eks.amazonaws.com",
            "ec2.amazonaws.com",
            "kms.amazonaws.com",
            "lambda.amazonaws.com",
            "rds.amazonaws.com",
            "dms.amazonaws.com",
            "secretsmanager.amazonaws.com",
            "iam.amazonaws.com",
            "apigateway.amazonaws.com",
            "cloudfront.amazonaws.com",
            "route53.amazonaws.com",
            "elasticache.amazonaws.com"
           ]
        },  # ✅ 추가됨
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "eks_node_instance_profile" {
  name = "eks_node_instance_profile"
  role = aws_iam_role.eks_rds_role.name
}

resource "aws_iam_role_policy_attachment" "eks_rds_admin_access" {
  role       = aws_iam_role.eks_rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  role       = aws_iam_role.eks_rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry" {
  role       = aws_iam_role.eks_rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy" {
  role       = aws_iam_role.eks_rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role_policy_attachment" "rds_data_access" {
  role       = aws_iam_role.eks_rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
}

resource "aws_iam_role_policy_attachment" "secretsmanager_access" {
  role       = aws_iam_role.eks_rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "kms_full_access" {
  role       = aws_iam_role.eks_rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser"
}

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  role       = aws_iam_role.eks_rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_policy" "eks_rds_inline_policy" {
  name        = "EKS_RDS_Inline_Policy"
  description = "Inline policy for EKS RDS role"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:GetRole",
          "iam:UpdateRole",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRole",
          "iam:PassRole"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_rds_inline_policy_attach" {
  role       = aws_iam_role.eks_rds_role.name
  policy_arn = aws_iam_policy.eks_rds_inline_policy.arn  # ✅ 올바르게 선언된 정책 참조
}

resource "aws_iam_policy" "rds_iam_auth" {
  name        = "RDS_IAM_Authentication"
  description = "Allow IAM authentication to RDS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "rds-db:connect"
        ],
        Resource = "arn:aws:rds-db:ap-northeast-2:${var.id_count}:dbuser/superadmin"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_iam_auth_attach" {
  role       = aws_iam_role.eks_rds_role.name
  policy_arn = aws_iam_policy.rds_iam_auth.arn
}

##################################################################
##################################################################

resource "aws_iam_role" "dms_vpc_role" {
  name = "DMS_VPC_Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "dms.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dms_vpc_policy" {
  role       = aws_iam_role.dms_vpc_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
}

resource "aws_iam_role_policy_attachment" "dms_cloudwatch_policy" {
  role       = aws_iam_role.dms_vpc_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSCloudWatchLogsRole"
}

resource "aws_iam_role_policy_attachment" "dms_s3_policy" {
  role       = aws_iam_role.dms_vpc_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSRedshiftS3Role"
}

##################################################################
##################################################################

resource "aws_iam_role" "lambda_role" {
  name = "Lambda_Role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = [
            "eks.amazonaws.com",
            "ec2.amazonaws.com",
            "s3.amazonaws.com",
            "kms.amazonaws.com",
            "rds.amazonaws.com",
            "dms.amazonaws.com",
            "secretsmanager.amazonaws.com",
            "iam.amazonaws.com",
            "apigateway.amazonaws.com",
            "cloudfront.amazonaws.com",
            "route53.amazonaws.com",
            "elasticache.amazonaws.com",
            "lambda.amazonaws.com",
            "cognito-idp.amazonaws.com"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_rds_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_secretsmanager_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_policy" "lambda_vpc_rds_policy" {
  name        = "LambdaVPCAndRDSPolicy"
  description = "IAM policy for Lambda to access VPC and RDS Proxy"
  
  policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:AssignPrivateIpAddresses",
        "ec2:UnassignPrivateIpAddresses",
        "ec2:AttachNetworkInterface"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "rds:DescribeDBInstances",
        "rds:DescribeDBClusters",
        "rds-db:connect"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction",
        "lambda:GetFunctionConfiguration"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "*"
    }
  ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_rds_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_vpc_rds_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_rds_full_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_full_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_policy_attachment" "lambda_policy_attach" {
  name       = "lambda-basic-execution"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy_attachment" "lambda_policy" {
  name       = "lambda-cognito-policy"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoPowerUser" # Cognito 관리 권한 추가
}

##################################################################
##################################################################

resource "aws_iam_role" "api_role" {
  name = "API_Role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = [
            "eks.amazonaws.com",
            "ec2.amazonaws.com",
            "kms.amazonaws.com",
            "lambda.amazonaws.com",
            "rds.amazonaws.com",
            "dms.amazonaws.com",
            "secretsmanager.amazonaws.com",
            "iam.amazonaws.com",
            "apigateway.amazonaws.com",
            "cloudfront.amazonaws.com",
            "route53.amazonaws.com",
            "elasticache.amazonaws.com"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apigateway_access" {
  role       = aws_iam_role.api_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
}

resource "aws_iam_role_policy_attachment" "cloudfront_access" {
  role       = aws_iam_role.api_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudFrontFullAccess"
}

resource "aws_iam_role_policy_attachment" "route53_access" {
  role       = aws_iam_role.api_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_role_policy_attachment" "elasticache_access" {
  role       = aws_iam_role.api_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
}

##################################################################
##################################################################