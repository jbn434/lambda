
function_name  = "backend-api-stage"
lambda_package = "backend-api.zip"
handler        =  "dist/lambda.handler"
runtime        = "nodejs18.x"
memory_size    =510
timeout        = 40

tags = {
  Environment = "stage"
  Project     = "backend-api"
}

vpc_cidr             = "10.20.0.0/16"
subnet_azs           = ["us-east-1a", "us-east-1b"]
subnet_cidrs         = ["10.20.1.0/24", "10.20.2.0/24"]
resource_name_prefix = "lambda-stage"
public_subnet_cidr = "10.20.3.0/24"
