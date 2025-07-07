output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.this.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.this.invoke_arn
}

output "vpc_id" {
  value = aws_vpc.lambda_vpc.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "lambda_sg_id" {
  value = aws_security_group.lambda_sg.id
}
