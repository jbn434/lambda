function_name  = "backend-api-dev"
lambda_package = "backend-api.zip"
handler        =  "dist/lambda.handler"
runtime        = "nodejs18.x"
memory_size    =510
timeout        = 40
lambda_role_arn = "arn:aws:iam::123456789012:role/lambda-execution-role"

tags = {
  Environment = "dev"
  Project     = "backend-api"
}

