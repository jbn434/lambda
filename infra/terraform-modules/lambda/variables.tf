variable "function_name"         { type = string }
variable "handler"               { type = string }
variable "runtime"               { type = string }
variable "memory_size"           { type = number }
variable "timeout"               { type = number }
variable "tags"                  { type = map(string) }

variable "lambda_role_arn" {}
variable "lambda_package" {
  description = "Path to the Lambda deployment package (zip file)"
  type        = string
}
