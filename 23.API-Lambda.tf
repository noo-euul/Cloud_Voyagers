
resource "aws_api_gateway_method" "init_db_method" {
  provider = aws.seoul
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.init_db_gateway.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "init_db_integration" {
  provider = aws.seoul
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.init_db_gateway.id
  http_method             = aws_api_gateway_method.init_db_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.init_db_lambda.invoke_arn
}

resource "aws_api_gateway_method" "dbcheck_method" {
  provider = aws.seoul
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.dbcheck_gateway.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "dbcheck_integration" {
  provider = aws.seoul
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.dbcheck_gateway.id
  http_method             = aws_api_gateway_method.dbcheck_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.init_db_lambda.invoke_arn
}

resource "aws_lambda_permission" "init_db_gateway_permission" {
  provider = aws.seoul
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.init_db_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway_us.execution_arn}/*/*"
}

##############################

resource "aws_api_gateway_method" "init_db_method_us" {
  provider = aws.virginia
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_us.id
  resource_id   = aws_api_gateway_resource.init_db_gateway_us.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "init_db_integration_us" {
  provider = aws.virginia
  rest_api_id             = aws_api_gateway_rest_api.api_gateway_us.id
  resource_id             = aws_api_gateway_resource.init_db_gateway_us.id
  http_method             = aws_api_gateway_method.init_db_method_us.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.init_db_lambda_us.invoke_arn
}

resource "aws_api_gateway_method" "dbcheck_method_us" {
  provider = aws.virginia
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_us.id
  resource_id   = aws_api_gateway_resource.dbcheck_gateway_us.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "dbcheck_integration_us" {
  provider = aws.virginia
  rest_api_id             = aws_api_gateway_rest_api.api_gateway_us.id
  resource_id             = aws_api_gateway_resource.dbcheck_gateway_us.id
  http_method             = aws_api_gateway_method.dbcheck_method_us.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.init_db_lambda_us.invoke_arn
}

resource "aws_lambda_permission" "init_db_gateway_permission_us" {
  provider = aws.virginia
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.init_db_lambda_us.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway_us.execution_arn}/*/*"
}

###################################################################
###################################################################

resource "aws_api_gateway_method" "login_method" {
  provider = aws.seoul
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.login_gateway.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "login_integration" {
  provider = aws.seoul
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.login_gateway.id
  http_method             = aws_api_gateway_method.login_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.login_user_lambda.invoke_arn
}

resource "aws_lambda_permission" "login_user_gateway_permission" {
  provider = aws.seoul
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.login_user_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}

##############################

resource "aws_api_gateway_method" "login_method_us" {
  provider = aws.virginia
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_us.id
  resource_id   = aws_api_gateway_resource.login_gateway_us.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth_us.id
}

resource "aws_api_gateway_integration" "login_integration_us" {
  provider = aws.virginia
  rest_api_id             = aws_api_gateway_rest_api.api_gateway_us.id
  resource_id             = aws_api_gateway_resource.login_gateway_us.id
  http_method             = aws_api_gateway_method.login_method_us.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.login_user_lambda_us.invoke_arn
}

resource "aws_lambda_permission" "login_user_gateway_permission_us" {
  provider = aws.virginia
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.login_user_lambda_us.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway_us.execution_arn}/*/*"
}

##################################################################
##################################################################

resource "aws_api_gateway_method" "insert_data_method" {
  provider = aws.seoul
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.insert_data_gateway.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "insert_data_integration" {
  provider = aws.seoul
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.insert_data_gateway.id
  http_method             = aws_api_gateway_method.insert_data_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.insert_data_lambda.invoke_arn
}

resource "aws_lambda_permission" "insert_data_gateway_permission" {
  provider = aws.seoul
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.insert_data_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}

##############################

resource "aws_api_gateway_method" "insert_data_method_us" {
  provider = aws.virginia
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_us.id
  resource_id   = aws_api_gateway_resource.insert_data_gateway_us.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth_us.id
}

resource "aws_api_gateway_integration" "insert_data_integration_us" {
  provider = aws.virginia
  rest_api_id             = aws_api_gateway_rest_api.api_gateway_us.id
  resource_id             = aws_api_gateway_resource.insert_data_gateway_us.id
  http_method             = aws_api_gateway_method.insert_data_method_us.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.insert_data_lambda_us.invoke_arn
}

resource "aws_lambda_permission" "insert_data_gateway_permission_us" {
  provider = aws.virginia
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.insert_data_lambda_us.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway_us.execution_arn}/*/*"
}

##################################################################
##################################################################

resource "aws_api_gateway_method" "update_data_method" {
  provider = aws.seoul
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.update_data_gateway.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "update_data_integration" {
  provider = aws.seoul
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.update_data_gateway.id
  http_method             = aws_api_gateway_method.update_data_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.update_data_lambda.invoke_arn
}

resource "aws_lambda_permission" "update_data_gateway_permission" {
  provider = aws.seoul
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_data_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}

##############################

resource "aws_api_gateway_method" "update_data_method_us" {
  provider = aws.virginia
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_us.id
  resource_id   = aws_api_gateway_resource.update_data_gateway_us.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth_us.id
}

resource "aws_api_gateway_integration" "update_data_integration_us" {
  provider = aws.virginia
  rest_api_id             = aws_api_gateway_rest_api.api_gateway_us.id
  resource_id             = aws_api_gateway_resource.update_data_gateway_us.id
  http_method             = aws_api_gateway_method.update_data_method_us.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.update_data_lambda_us.invoke_arn
}

resource "aws_lambda_permission" "update_data_gateway_permission_us" {
  provider = aws.virginia
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_data_lambda_us.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway_us.execution_arn}/*/*"
}

##################################################################
##################################################################

resource "aws_api_gateway_method" "select_data_method" {
  provider = aws.seoul
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.select_data_gateway.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "select_data_integration" {
  provider = aws.seoul
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.select_data_gateway.id
  http_method             = aws_api_gateway_method.select_data_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.select_data_lambda.invoke_arn
}

resource "aws_lambda_permission" "select_data_gateway_permission" {
  provider = aws.seoul
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.select_data_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}

##############################

resource "aws_api_gateway_method" "select_data_method_us" {
  provider = aws.virginia
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_us.id
  resource_id   = aws_api_gateway_resource.select_data_gateway_us.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth_us.id
}

resource "aws_api_gateway_integration" "select_data_integration_us" {
  provider = aws.virginia
  rest_api_id             = aws_api_gateway_rest_api.api_gateway_us.id
  resource_id             = aws_api_gateway_resource.select_data_gateway_us.id
  http_method             = aws_api_gateway_method.select_data_method_us.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.select_data_lambda_us.invoke_arn
}

resource "aws_lambda_permission" "select_data_gateway_permission_us" {
  provider = aws.virginia
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.select_data_lambda_us.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway_us.execution_arn}/*/*"
}

##################################################################
##################################################################

resource "aws_api_gateway_deployment" "api_deployment" {
  provider = aws.seoul
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  
  triggers = {
    redeployment = sha1(jsonencode({
      "init_db"      = aws_api_gateway_method.init_db_method.id,
      "dbcheck"      = aws_api_gateway_method.dbcheck_method.id,
      "login_user"   = aws_api_gateway_method.login_method.id
      "insert_data"  = aws_api_gateway_method.insert_data_method.id,
      "update_data"  = aws_api_gateway_method.update_data_method.id,
      "select_data"  = aws_api_gateway_method.select_data_method.id
    }))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.init_db_method,
    aws_api_gateway_method.dbcheck_method,
    aws_api_gateway_method.login_method,
    aws_api_gateway_method.insert_data_method,
    aws_api_gateway_method.update_data_method,
    aws_api_gateway_method.select_data_method,
    aws_api_gateway_integration.init_db_integration,
    aws_api_gateway_integration.dbcheck_integration,
    aws_api_gateway_integration.login_integration,
    aws_api_gateway_integration.insert_data_integration,
    aws_api_gateway_integration.update_data_integration,
    aws_api_gateway_integration.select_data_integration
  ]
}

resource "aws_api_gateway_stage" "api_stage" {
  provider = aws.seoul
  stage_name    = "stage_01"
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
}

##############################

resource "aws_api_gateway_deployment" "api_deployment_us" {
  provider = aws.virginia
  rest_api_id = aws_api_gateway_rest_api.api_gateway_us.id
  
  triggers = {
    redeployment = sha1(jsonencode({
      "init_db"      = aws_api_gateway_method.init_db_method_us.id,
      "dbcheck"      = aws_api_gateway_method.dbcheck_method_us.id,
      "login_user"   = aws_api_gateway_method.login_method_us.id
      "insert_data"  = aws_api_gateway_method.insert_data_method_us.id,
      "update_data"  = aws_api_gateway_method.update_data_method_us.id,
      "select_data"  = aws_api_gateway_method.select_data_method_us.id
    }))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.init_db_method_us,
    aws_api_gateway_method.dbcheck_method_us,
    aws_api_gateway_method.login_method_us,
    aws_api_gateway_method.insert_data_method_us,
    aws_api_gateway_method.update_data_method_us,
    aws_api_gateway_method.select_data_method_us,
    aws_api_gateway_integration.init_db_integration_us,
    aws_api_gateway_integration.dbcheck_integration_us,
    aws_api_gateway_integration.login_integration_us,
    aws_api_gateway_integration.insert_data_integration_us,
    aws_api_gateway_integration.update_data_integration_us,
    aws_api_gateway_integration.select_data_integration_us
  ]
}

resource "aws_api_gateway_stage" "api_stage_us" {
  provider = aws.virginia
  stage_name    = "stage_01"
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_us.id
  deployment_id = aws_api_gateway_deployment.api_deployment_us.id
}