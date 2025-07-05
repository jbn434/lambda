# --- API Gateway REST API ---
resource "aws_api_gateway_rest_api" "nestjs_api" {
  name        = var.api_name
  description = "API Gateway for NestJS Lambda"
}

# --- Proxy resource /{proxy+} ---
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.nestjs_api.id
  parent_id   = aws_api_gateway_rest_api.nestjs_api.root_resource_id
  path_part   = "{proxy+}"
}

# --- ANY method ---
resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.nestjs_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# --- Integration with Lambda ---
resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.nestjs_api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# --- Deployment & stage ---
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.proxy_integration]
  rest_api_id = aws_api_gateway_rest_api.nestjs_api.id
  stage_name  = var.stage_name
}

# --- Lambda permission for API Gateway ---
resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.nestjs_api.execution_arn}/*/*"
}
