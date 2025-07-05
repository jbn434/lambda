module "lambda" {
  source               = "../terraform-modules/lambda"
  function_name        = var.function_name
  handler              = var.handler
  lambda_package       = "${path.module}/${var.lambda_package}"
  lambda_role_arn      = var.lambda_role_arn
  runtime              = var.runtime
  memory_size          = var.memory_size
  timeout              = var.timeout
  environment_variables = var.environment_variables
  tags                 = var.tags
}

