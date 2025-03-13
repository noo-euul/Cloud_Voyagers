
data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

# S3 버킷 생성
resource "aws_s3_bucket" "CV_seoul_s3" {
  provider = aws.seoul
  bucket = "boyage-monitoring-logs-s3"

  tags = {
    Name        = "MyCloudFrontBucket"
    Environment = "Production"
  }
}

# S3 버킷 설정 (Object Ownership)
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.CV_seoul_s3.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# S3 퍼블릭 액세스 차단 (보안 강화)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.CV_seoul_s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##################################################################
##################################################################

resource "aws_iam_role" "s3_role" {
  name = "s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = [
            "logs.amazonaws.com",
            "guardduty.amazonaws.com",
            "s3.amazonaws.com"
            ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "guardduty_cloudwatch_policy" {
  bucket = aws_s3_bucket.CV_seoul_s3.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowGuardDutyToWrite"
        Effect    = "Allow"
        Principal = {
          Service = "guardduty.amazonaws.com"
        }
        Action    = "s3:PutObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.CV_seoul_s3.id}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "${local.aws_account_id}"
          }
        }
      },
      {
        Sid       = "AllowCloudWatchToWrite"
        Effect    = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
        Action    = "s3:PutObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.CV_seoul_s3.id}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "${local.aws_account_id}"
          }
        }
      },
      {
        Sid       = "AllowCloudWatchToRead"
        Effect    = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.CV_seoul_s3.id}/*"
      },
      {
        Sid       = "AllowListBucket"
        Effect    = "Allow"
        Principal = {
          Service = "guardduty.amazonaws.com"
        }
        Action    = "s3:ListBucket"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.CV_seoul_s3.id}"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "${local.aws_account_id}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "CloudWatchGuardDutyS3Access"
  description = "Allows CloudWatch Logs and GuardDuty to write logs to S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:PutObject",
          "s3:GetObject", 
          "s3:ListBucket"
          ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.CV_seoul_s3.id}",
          "arn:aws:s3:::${aws_s3_bucket.CV_seoul_s3.id}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}


# resource "aws_iam_policy" "lambda_policy" {
#   name        = "test1-lambda-policy"
#   description = "IAM policy for Lambda to access S3, KMS, and CloudWatch"

#   policy = <<EOF
#   {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "s3:PutObject",
#         "s3:GetObject",
#         "s3:ListBucket"
#       ],
#       "Resource": [
#         "arn:aws:s3:::boyage1-guard-duty-s3",
#         "arn:aws:s3:::boyage1-guard-duty-s3/*"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "kms:Encrypt",
#         "kms:Decrypt",
#         "kms:GenerateDataKey",
#         "kms:DescribeKey"
#       ],
#       "Resource": "arn:aws:kms:ap-northeast-2:${var.id_count}:key/*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ],
#       "Resource": "arn:aws:logs:*:*:*"
#     }
#     ]
#   }
#   EOF
# }

# resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = aws_iam_policy.lambda_policy.arn
# }


# resource "aws_kms_key_policy" "s3_kms_policy" {
#   key_id = aws_kms_key.boyage_key.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "Enable IAM User Permissions"
#         Effect = "Allow"
#         Principal = {
#           AWS = [
#             "arn:aws:iam::${var.id_count}:root",
#             "arn:aws:iam::${var.id_count}:role/test1-role-csequevd",
#             "arn:aws:iam::${var.id_count}:role/guardduty-service-role"
#             ]
#         }
#         Action   = "kms:*"
#         Resource = "*"
#       },
#       {
#         Sid    = "AllowS3UseOfKMS"
#         Effect = "Allow"
#         Principal = {
#           Service = "s3.amazonaws.com"
#         }
#         Action   = [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:ReEncrypt*",
#           "kms:GenerateDataKey*",
#           "kms:DescribeKey"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
#   bucket = data.aws_s3_bucket.kmstest.id

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.boyage_key.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }
