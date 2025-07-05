resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.function_name}-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "secrets_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"  # Adjust to read-only in prod
}


resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = var.handler       # Should point to wrapper handler, e.g. "lambda-wrapper.handler"
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout

filename         = var.lambda_package
source_code_hash = filebase64sha256(var.lambda_package)




  tags = var.tags
}

