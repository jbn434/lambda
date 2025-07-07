module "lambda" {
  source               = "../terraform-modules/lambda"
  function_name        = var.function_name
  handler              = var.handler
  lambda_package       = "${path.module}/${var.lambda_package}"
  runtime              = var.runtime
  memory_size          = var.memory_size
  timeout              = var.timeout
  tags                 = var.tags
  vpc_cidr             = var.vpc_cidr
  subnet_azs           = var.subnet_azs
  subnet_cidrs         = var.subnet_cidrs
  resource_name_prefix = var.resource_name_prefix

}

