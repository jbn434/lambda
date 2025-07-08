module "api_gateway" {
  source                = "../terraform-modules/api-gateway"
  api_name              = var.api_name
  stage_name            = var.stage_name
  lambda_function_name  = data.terraform_remote_state.lambda.outputs.lambda_function_name
  lambda_invoke_arn     = data.terraform_remote_state.lambda.outputs.lambda_function_invoke_arn
  region                = var.region
  log_group_name        = var.log_group_name
}
