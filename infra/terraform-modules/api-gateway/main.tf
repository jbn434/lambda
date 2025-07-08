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
}


# --- Lambda permission for API Gateway ---
resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.nestjs_api.execution_arn}/*/*"
}

resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = var.log_group_name
  retention_in_days = 14
}

resource "aws_iam_role" "api_gw_cloudwatch_role" {
  name = "${var.api_name}-api-gw-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "apigateway.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "api_gw_logging_policy" {
  name = "${var.api_name}-api-gw-logs-policy"
  role = aws_iam_role.api_gw_cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_api_gateway_account" "api_account" {
  cloudwatch_role_arn = aws_iam_role.api_gw_cloudwatch_role.arn
  depends_on = [
    aws_iam_role_policy.api_gw_logging_policy
  ]
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.nestjs_api.id
  stage_name    = var.stage_name

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format = jsonencode({
      requestId       = "$context.requestId"
      apiId           = "$context.apiId"
      domainName      = "$context.domainName"
      stage           = "$context.stage"
      protocol        = "$context.protocol"
      httpMethod      = "$context.httpMethod"
      path            = "$context.path"
      status          = "$context.status"
      responseLatency = "$context.responseLatency"
      responseLength  = "$context.responseLength"
      sourceIp        = "$context.identity.sourceIp"
      userAgent       = "$context.identity.userAgent"
    })
  }
}
