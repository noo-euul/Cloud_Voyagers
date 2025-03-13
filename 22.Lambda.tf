
data "aws_subnets" "private_subnets" {
  provider = aws.seoul
  filter {
    name   = "tag:Name"
    values = ["CV_private_seoul_a", "CV_private_seoul_c"]
  }
}

data "aws_subnets" "private_subnets_us" {
  provider = aws.virginia
  filter {
    name   = "tag:Name"
    values = ["CV_private_virginia_a", "CV_private_virginia_c"]
  }
}

data "aws_cognito_user_pool" "cognito_user_pool" {
  provider = aws.seoul
  user_pool_id = aws_cognito_user_pool.main.id
}

data "aws_cognito_user_pool" "cognito_user_pool_us" {
  provider = aws.virginia
  user_pool_id = aws_cognito_user_pool.main_us.id
}

data "aws_cognito_user_pool_client" "cognito_user_pool_client" {
  provider = aws.seoul
  user_pool_id = aws_cognito_user_pool.main.id  # ✅ user_pool_id 사용
  client_id    = aws_cognito_user_pool_client.main.id  # ✅ client_id 사용
}

data "aws_cognito_user_pool_client" "cognito_user_pool_client_us" {
  provider = aws.virginia
  user_pool_id = aws_cognito_user_pool.main_us.id  # ✅ user_pool_id 사용
  client_id    = aws_cognito_user_pool_client.main_us.id  # ✅ client_id 사용
}

variable "eks_fastapi_url" {
  default = "http://adfb7055a1bc74c9a8142905c7d56dcc-6b56e5b1e0833a8d.elb.ap-northeast-2.amazonaws.com"
}
# resource "aws_lambda_layer_version" "lambda_dependencies" {
#   layer_name          = "LambdaDependencies"
#   description         = "Lambda Dependencies Layer"
#   compatible_runtimes = ["python3.9"]

#   filename = "./lambda_package/lambda_package.zip"
# }

##################################################################
##################################################################

resource "aws_lambda_function" "init_db_lambda" {
  provider = aws.seoul
  function_name = "DB_Initialize_Aurora"
  runtime       = "python3.9"
  handler       = "lambda_init_db.lambda_handler"
  timeout       = 30
  role          = aws_iam_role.lambda_role.arn
  filename      = "./lambda_package/lambda_init_db.zip"

  vpc_config {
    subnet_ids         = data.aws_subnets.private_subnets.ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      COGNITO_USER_POOL_ID = data.aws_cognito_user_pool.cognito_user_pool.user_pool_id
      COGNITO_CLIENT_ID       = data.aws_cognito_user_pool_client.cognito_user_pool_client.client_id
      COGNITO_REGION       = "${var.region_seoul}"
      FASTAPI_URL = "${var.eks_fastapi_url}"
    }
  }
}

resource "aws_lambda_function" "login_user_lambda" {
  provider = aws.seoul
  function_name = "DB_Insert_User_Login"
  runtime       = "python3.9"
  handler       = "lambda_login.lambda_handler"
  timeout       = 30
  role          = aws_iam_role.lambda_role.arn
  filename      = "./lambda_package/lambda_login.zip"

  vpc_config {
    subnet_ids         = data.aws_subnets.private_subnets.ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      COGNITO_USER_POOL_ID = data.aws_cognito_user_pool.cognito_user_pool.user_pool_id
      COGNITO_CLIENT_ID       = data.aws_cognito_user_pool_client.cognito_user_pool_client.client_id
      COGNITO_REGION       = "${var.region_seoul}"
      FASTAPI_URL = "${var.eks_fastapi_url}"
    }
  }
}

resource "aws_lambda_function" "insert_data_lambda" {
  provider = aws.seoul
  function_name = "DB_Insert_User_Data"
  runtime       = "python3.9"
  handler       = "lambda_insert_data.lambda_handler"
  timeout       = 30
  role          = aws_iam_role.lambda_role.arn
  filename      = "./lambda_package/lambda_insert_data.zip"

  vpc_config {
    subnet_ids         = data.aws_subnets.private_subnets.ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      COGNITO_USER_POOL_ID = data.aws_cognito_user_pool.cognito_user_pool.user_pool_id
      COGNITO_CLIENT_ID       = data.aws_cognito_user_pool_client.cognito_user_pool_client.client_id
      COGNITO_REGION       = "${var.region_seoul}"
      FASTAPI_URL = "${var.eks_fastapi_url}"
    }
  }
}

resource "aws_lambda_function" "update_data_lambda" {
  provider = aws.seoul
  function_name = "DB_update_User_Data"
  runtime       = "python3.9"
  handler       = "lambda_update_data.lambda_handler"
  timeout       = 30
  role          = aws_iam_role.lambda_role.arn
  filename      = "./lambda_package/lambda_update_data.zip"

  vpc_config {
    subnet_ids         = data.aws_subnets.private_subnets.ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      COGNITO_USER_POOL_ID = data.aws_cognito_user_pool.cognito_user_pool.user_pool_id
      COGNITO_CLIENT_ID       = data.aws_cognito_user_pool_client.cognito_user_pool_client.client_id
      COGNITO_REGION       = "${var.region_seoul}"
      FASTAPI_URL = "${var.eks_fastapi_url}"
    }
  }
}

resource "aws_lambda_function" "select_data_lambda" {
  provider = aws.seoul
  function_name = "DB_select_User_Data"
  runtime       = "python3.9"
  handler       = "lambda_select_data.lambda_handler"
  timeout       = 30
  role          = aws_iam_role.lambda_role.arn
  filename      = "./lambda_package/lambda_select_data.zip"

  vpc_config {
    subnet_ids         = data.aws_subnets.private_subnets.ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      COGNITO_USER_POOL_ID = data.aws_cognito_user_pool.cognito_user_pool.user_pool_id
      COGNITO_CLIENT_ID       = data.aws_cognito_user_pool_client.cognito_user_pool_client.client_id
      COGNITO_REGION       = "${var.region_seoul}"
      FASTAPI_URL = "${var.eks_fastapi_url}"
    }
  }
}

##############################


resource "aws_lambda_function" "init_db_lambda_us" {
  provider = aws.virginia
  function_name = "DB_Initialize_Aurora"
  runtime       = "python3.9"
  handler       = "lambda_init_db.lambda_handler"
  timeout       = 30
  role          = aws_iam_role.lambda_role.arn
  filename      = "./lambda_package/lambda_init_db.zip"

  vpc_config {
    subnet_ids         = data.aws_subnets.private_subnets_us.ids
    security_group_ids = [aws_security_group.lambda_sg_us.id]
  }

  environment {
    variables = {
      COGNITO_USER_POOL_ID = data.aws_cognito_user_pool.cognito_user_pool_us.user_pool_id
      COGNITO_CLIENT_ID       = data.aws_cognito_user_pool_client.cognito_user_pool_client_us.client_id
      COGNITO_REGION       = "${var.region_virginia}"
      FASTAPI_URL = "${var.eks_fastapi_url}"
    }
  }
}

resource "aws_lambda_function" "login_user_lambda_us" {
  provider = aws.virginia
  function_name = "DB_Insert_User_Login"
  runtime       = "python3.9"
  handler       = "lambda_login.lambda_handler"
  timeout       = 30
  role          = aws_iam_role.lambda_role.arn
  filename      = "./lambda_package/lambda_login.zip"

  vpc_config {
    subnet_ids         = data.aws_subnets.private_subnets_us.ids
    security_group_ids = [aws_security_group.lambda_sg_us.id]
  }

  environment {
    variables = {
      COGNITO_USER_POOL_ID = data.aws_cognito_user_pool.cognito_user_pool_us.user_pool_id
      COGNITO_CLIENT_ID       = data.aws_cognito_user_pool_client.cognito_user_pool_client_us.client_id
      COGNITO_REGION       = "${var.region_virginia}"
      FASTAPI_URL = "${var.eks_fastapi_url}"
    }
  }
}

resource "aws_lambda_function" "insert_data_lambda_us" {
  provider = aws.virginia
  function_name = "DB_Insert_User_Data"
  runtime       = "python3.9"
  handler       = "lambda_insert_data.lambda_handler"
  timeout       = 30
  role          = aws_iam_role.lambda_role.arn
  filename      = "./lambda_package/lambda_insert_data.zip"

  vpc_config {
    subnet_ids         = data.aws_subnets.private_subnets_us.ids
    security_group_ids = [aws_security_group.lambda_sg_us.id]
  }

  environment {
    variables = {
      COGNITO_USER_POOL_ID = data.aws_cognito_user_pool.cognito_user_pool_us.user_pool_id
      COGNITO_CLIENT_ID       = data.aws_cognito_user_pool_client.cognito_user_pool_client_us.client_id
      COGNITO_REGION       = "${var.region_virginia}"
      FASTAPI_URL = "${var.eks_fastapi_url}"
    }
  }
}

resource "aws_lambda_function" "update_data_lambda_us" {
  provider = aws.virginia
  function_name = "DB_update_User_Data"
  runtime       = "python3.9"
  handler       = "lambda_update_data.lambda_handler"
  timeout       = 30
  role          = aws_iam_role.lambda_role.arn
  filename      = "./lambda_package/lambda_update_data.zip"

  vpc_config {
    subnet_ids         = data.aws_subnets.private_subnets_us.ids
    security_group_ids = [aws_security_group.lambda_sg_us.id]
  }

  environment {
    variables = {
      COGNITO_USER_POOL_ID = data.aws_cognito_user_pool.cognito_user_pool_us.user_pool_id
      COGNITO_CLIENT_ID       = data.aws_cognito_user_pool_client.cognito_user_pool_client_us.client_id
      COGNITO_REGION       = "${var.region_virginia}"
      FASTAPI_URL = "${var.eks_fastapi_url}"
    }
  }
}

resource "aws_lambda_function" "select_data_lambda_us" {
  provider = aws.virginia
  function_name = "DB_select_User_Data"
  runtime       = "python3.9"
  handler       = "lambda_select_data.lambda_handler"
  timeout       = 30
  role          = aws_iam_role.lambda_role.arn
  filename      = "./lambda_package/lambda_select_data.zip"

  vpc_config {
    subnet_ids         = data.aws_subnets.private_subnets_us.ids
    security_group_ids = [aws_security_group.lambda_sg_us.id]
  }

  environment {
    variables = {
      COGNITO_USER_POOL_ID = data.aws_cognito_user_pool.cognito_user_pool_us.user_pool_id
      COGNITO_CLIENT_ID       = data.aws_cognito_user_pool_client.cognito_user_pool_client_us.client_id
      COGNITO_REGION       = "${var.region_virginia}"
      FASTAPI_URL = "${var.eks_fastapi_url}"
    }
  }
}