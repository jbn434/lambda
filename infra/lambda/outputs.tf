output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "lambda_function_arn" {
  value = module.lambda.lambda_arn  # changed to match available output
}

output "lambda_function_invoke_arn" {
  value = module.lambda.lambda_invoke_arn
}

output "vpc_id" {
  value = module.lambda.vpc_id
}

output "private_subnet_ids" {
  value = module.lambda.private_subnet_ids
}

output "lambda_sg_id" {
  value = module.lambda.lambda_sg_id
}
