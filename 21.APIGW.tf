resource "aws_api_gateway_rest_api" "api_gateway" {
  provider = aws.seoul
  name        = "BoyageAPI-Gateway"
  description = "API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"] 
  }
}

resource "aws_api_gateway_rest_api" "api_gateway_us" {
  provider = aws.virginia
  name        = "BoyageAPI-Gateway"
  description = "API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"] 
  }
}

##############################

resource "aws_api_gateway_authorizer" "cognito_auth" {
  provider = aws.seoul
  name          = "CognitoJWTAuthorizer"
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.main.arn]
}

resource "aws_api_gateway_authorizer" "cognito_auth_us" {
  provider = aws.virginia
  name          = "CognitoJWTAuthorizer"
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_us.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.main.arn]
}

##################################################################
##################################################################

resource "aws_api_gateway_resource" "dbcheck_gateway" {
  provider = aws.seoul
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "dbcheck"
}

resource "aws_api_gateway_resource" "init_db_gateway" {
  provider = aws.seoul
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "init_db"
}

resource "aws_api_gateway_resource" "login_gateway" {
  provider = aws.seoul
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "login"
}

resource "aws_api_gateway_resource" "insert_data_gateway" {
  provider = aws.seoul
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "insert_data"
}

resource "aws_api_gateway_resource" "update_data_gateway" {
  provider = aws.seoul
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "update_data"
}

resource "aws_api_gateway_resource" "select_data_gateway" {
  provider = aws.seoul
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "select_data"
}

##############################

resource "aws_api_gateway_resource" "dbcheck_gateway_us" {
  provider = aws.virginia
  rest_api_id = aws_api_gateway_rest_api.api_gateway_us.id
  parent_id   = aws_api_gateway_rest_api.api_gateway_us.root_resource_id
  path_part   = "dbcheck"
}

resource "aws_api_gateway_resource" "init_db_gateway_us" {
  provider = aws.virginia
  rest_api_id = aws_api_gateway_rest_api.api_gateway_us.id
  parent_id   = aws_api_gateway_rest_api.api_gateway_us.root_resource_id
  path_part   = "init_db"
}

resource "aws_api_gateway_resource" "login_gateway_us" {
  provider = aws.virginia
  rest_api_id = aws_api_gateway_rest_api.api_gateway_us.id
  parent_id   = aws_api_gateway_rest_api.api_gateway_us.root_resource_id
  path_part   = "login"
}

resource "aws_api_gateway_resource" "insert_data_gateway_us" {
  provider = aws.virginia
  rest_api_id = aws_api_gateway_rest_api.api_gateway_us.id
  parent_id   = aws_api_gateway_rest_api.api_gateway_us.root_resource_id
  path_part   = "insert_data"
}

resource "aws_api_gateway_resource" "update_data_gateway_us" {
  provider = aws.virginia
  rest_api_id = aws_api_gateway_rest_api.api_gateway_us.id
  parent_id   = aws_api_gateway_rest_api.api_gateway_us.root_resource_id
  path_part   = "update_data"
}

resource "aws_api_gateway_resource" "select_data_gateway_us" {
  provider = aws.virginia
  rest_api_id = aws_api_gateway_rest_api.api_gateway_us.id
  parent_id   = aws_api_gateway_rest_api.api_gateway_us.root_resource_id
  path_part   = "select_data"
}

##################################################################
##################################################################