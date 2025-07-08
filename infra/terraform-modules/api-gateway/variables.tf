variable "api_name"             { type = string }
variable "stage_name"           { type = string }
variable "lambda_function_name" { type = string }
variable "lambda_invoke_arn"    { type = string }
variable "region" {
  type = string
}
variable "log_group_name" {
  description = "Name of the CloudWatch Log Group for API Gateway access logs"
  type        = string
}
