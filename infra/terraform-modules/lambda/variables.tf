variable "function_name"         { type = string }
variable "handler"               { type = string }
variable "runtime"               { type = string }
variable "memory_size"           { type = number }
variable "timeout"               { type = number }
variable "tags"                  { type = map(string) }

variable "lambda_package" {
  description = "Path to the Lambda deployment package (zip file)"
  type        = string
}

# NEW: networking variables
variable "vpc_cidr" {
  type = string
}

variable "subnet_azs" {
  type = list(string)
}

variable "subnet_cidrs" {
  type = list(string)
}

variable "resource_name_prefix" {
  type = string
}
