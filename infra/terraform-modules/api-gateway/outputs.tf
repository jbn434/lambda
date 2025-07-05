output "api_url" {
  value = "https://${aws_api_gateway_rest_api.nestjs_api.id}.execute-api.${var.region}.amazonaws.com/${var.stage_name}"
}

output "api_gateway_execution_arn" {
  value = aws_api_gateway_rest_api.nestjs_api.execution_arn
}

