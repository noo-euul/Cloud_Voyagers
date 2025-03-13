
resource "aws_cognito_user_pool" "main" {
  provider = aws.seoul
  name = "boyage_user_pool"   //  Cognito 사용자 풀 리소스 생성성

  password_policy {   // 비밀번호 정책책
    minimum_length                   = 8    // 최소 비밀번호 길이
    require_lowercase                = false   // 소문자 포함 여부
    require_uppercase                = false   // 대문자 포함 여부
    require_numbers                   = false    // 숫자 포함 여부
    require_symbols                   = false   // 특수문자 포함 여부
    temporary_password_validity_days = 7    // 임시 비밀번호 유효 기간
  }

  username_configuration {    // 사용자 이름 설정
    case_sensitive = false    // 사용자 로그인 시 대소문자 구분 여부
  }

  auto_verified_attributes = ["email"]    // 이메일 자동 인증

  schema {    // 사용자 속성
    name                = "email"   // 속성 이름
    attribute_data_type = "String"    // 데이터 유형
    required            = true    // 필수 여부
    mutable             = false   // 수정 가능 여부
  }

  schema {
    name                = "name"
    attribute_data_type = "String"
    required            = false
    mutable             = true
  }

  lifecycle {
    ignore_changes = [schema]  # Terraform이 schema 변경을 무시함
  }

  depends_on = [aws_iam_role.lambda_role ]
}

resource "aws_cognito_user_pool_client" "main" { 
  provider = aws.seoul
  name                         = "boyage_user_pool_client"    // 앱 클라이언트 이름름
  user_pool_id                 = aws_cognito_user_pool.main.id    // 연결할 유저 풀
  generate_secret              = false    // 클라이언트 시크릿 생성 여부 (false = 공개)
  explicit_auth_flows          = ["ALLOW_USER_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH",
   "ALLOW_USER_PASSWORD_AUTH" , "ALLOW_ADMIN_USER_PASSWORD_AUTH"]    // 인증 방식
  allowed_oauth_flows          = ["code", "implicit"]   // 인증 플로우 설정
  allowed_oauth_scopes         = ["email", "openid", "profile"]   // OAuth 권한 범위
  supported_identity_providers = ["COGNITO"]
  callback_urls                = ["https://boyage_user_pool_client/callback"]
  logout_urls                  = ["https://boyage_user_pool_client/logout"]

  access_token_validity  = 1  # ✅ 1시간 (최대 24시간)
  id_token_validity      = 1  # ✅ 1시간 (최대 24시간)
  refresh_token_validity = 30 # ✅ 30일 (최대 3650일)
  token_validity_units {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "days"
  }
}

resource "aws_cognito_user_pool_domain" "main" { 
  provider = aws.seoul
  domain       = "boyage-auth"
  user_pool_id = aws_cognito_user_pool.main.id
}

##############################

resource "aws_cognito_user_pool" "main_us" {
  provider = aws.virginia
  name = "boyage_user_pool"   //  Cognito 사용자 풀 리소스 생성성

  password_policy {   // 비밀번호 정책책
    minimum_length                   = 8    // 최소 비밀번호 길이
    require_lowercase                = false   // 소문자 포함 여부
    require_uppercase                = false   // 대문자 포함 여부
    require_numbers                   = false    // 숫자 포함 여부
    require_symbols                   = false   // 특수문자 포함 여부
    temporary_password_validity_days = 7    // 임시 비밀번호 유효 기간
  }

  username_configuration {    // 사용자 이름 설정
    case_sensitive = false    // 사용자 로그인 시 대소문자 구분 여부
  }

  auto_verified_attributes = ["email"]    // 이메일 자동 인증
  //auto_verified_attributes = ["phone_number"]

  schema {    // 사용자 속성
    name                = "email"   // 속성 이름
    attribute_data_type = "String"    // 데이터 유형
    required            = true    // 필수 여부
    mutable             = false   // 수정 가능 여부
  }

  schema {
    name                = "name"
    attribute_data_type = "String"
    required            = false
    mutable             = true
  }

  lifecycle {
    ignore_changes = [schema]  # Terraform이 schema 변경을 무시함
  }

  depends_on = [aws_iam_role.lambda_role ]
}

resource "aws_cognito_user_pool_client" "main_us" { 
  provider = aws.virginia
  name                         = "boyage_user_pool_client"    // 앱 클라이언트 이름름
  user_pool_id                 = aws_cognito_user_pool.main_us.id    // 연결할 유저 풀
  generate_secret              = false    // 클라이언트 시크릿 생성 여부 (false = 공개)
  explicit_auth_flows          = ["ALLOW_USER_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH",
   "ALLOW_USER_PASSWORD_AUTH" , "ALLOW_ADMIN_USER_PASSWORD_AUTH"]    // 인증 방식
  allowed_oauth_flows          = ["code", "implicit"]   // 인증 플로우 설정
  allowed_oauth_scopes         = ["email", "openid", "profile"]   // OAuth 권한 범위
  supported_identity_providers = ["COGNITO"]
  callback_urls                = ["https://boyage_user_pool_client/callback"]
  logout_urls                  = ["https://boyage_user_pool_client/logout"]

  access_token_validity  = 1  # ✅ 1시간 (최대 24시간)
  id_token_validity      = 1  # ✅ 1시간 (최대 24시간)
  refresh_token_validity = 30 # ✅ 30일 (최대 3650일)
  token_validity_units {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "days"
  }
}

resource "aws_cognito_user_pool_domain" "main_us" { 
  provider = aws.virginia
  domain       = "boyage-auth"
  user_pool_id = aws_cognito_user_pool.main_us.id
}

##################################################################
##################################################################

locals {
  users = [
    { username = "wkoh", email = "wkoh@admin.com" },
    { username = "neseo", email = "neseo@admin.com" },
    { username = "jypark", email = "jypark@admin.com" },
    { username = "mskim", email = "mskim@admin.com" }
  ]
}

resource "aws_cognito_user" "create_user" {
  provider = aws.seoul
  for_each = { for user in local.users : user.username => user }
  user_pool_id = aws_cognito_user_pool.main.id
  username     = each.value.username
  attributes = {
    email = each.value.email
    email_verified  = "true"  // 이메일을 확인 완료 상태로 설정
  }

  password = "qwer!234"
  force_alias_creation = true
  message_action = "SUPPRESS" // "SUPPRESS"를 사용하면 초기 이메일 전송을 막을 수 있음

  lifecycle {
    ignore_changes = [password]
  }
}

##############################

locals {
  users_us = [
    { username = "test1", email = "test1@admin.com" },
    { username = "test2", email = "test2@admin.com" },
    { username = "test3", email = "test3@admin.com" },
    { username = "test4", email = "test4@admin.com" }
  ]
}

resource "aws_cognito_user" "create_user_us" {
  provider = aws.virginia
  for_each = { for user in local.users_us : user.username => user }
  user_pool_id = aws_cognito_user_pool.main_us.id
  username     = each.value.username
  attributes = {
    email = each.value.email
    email_verified  = "true"  // 이메일을 확인 완료 상태로 설정
  }

  password = "qwer!234"
  force_alias_creation = true
  message_action = "SUPPRESS" // "SUPPRESS"를 사용하면 초기 이메일 전송을 막을 수 있음

  lifecycle {
    ignore_changes = [password]
  }
}

##################################################################
##################################################################

resource "aws_iam_role_policy" "cognito_get_user_inline_policy" {
  name   = "CognitoGetUserInlinePolicy"
  role   = aws_iam_role.lambda_role.id  # 기존 Role에 직접 정책 추가
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
            "cognito-idp:*"
        ]
        Resource = "arn:aws:cognito-idp:ap-northeast-2:${var.id_count}:userpool/${aws_cognito_user_pool.main.id}"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_cognito_invoke" {
  name        = "lambda_cognito_invoke"
  description = "Allow Cognito to invoke Lambda function"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": "lambda:InvokeFunction",
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "aws:SourceArn": aws_cognito_user_pool.main.arn
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cognito_policy" {
  name        = "Lambda_Cognito_Policy"
  description = "Policy to allow Lambda to manage Cognito users"
  
  policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cognito-idp:AdminInitiateAuth",
                "cognito-idp:AdminRespondToAuthChallenge",
                "cognito-idp:InitiateAuth",
                "cognito-idp:RespondToAuthChallenge",
                "cognito-idp:AdminGetUser",
                "cognito-idp:AdminSetUserMFAPreference",
                "cognito-idp:AdminUpdateUserAttributes"
            ],
            "Resource": "arn:aws:cognito-idp:ap-northeast-2:${var.id_count}:userpool/${aws_cognito_user_pool.main.id}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": "arn:aws:lambda:ap-northeast-2:${var.id_count}:function:*"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_cognito_policy_attachment" {
  policy_arn = aws_iam_policy.cognito_policy.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_cognito_attach" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.lambda_cognito_invoke.arn
}