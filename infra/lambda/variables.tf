variable "function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "lambda_package" {
  type        = string
  description = "Local path to the Lambda ZIP file"
}

variable "handler" {
  type        = string
  description = "Handler for the Lambda function"
}

variable "runtime" {
  type        = string
  description = "Lambda runtime"
}

variable "memory_size" {
  type        = number
  description = "Lambda memory size"
}

variable "timeout" {
  type        = number
  description = "Lambda timeout in seconds"
}


variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

# NEW: network inputs
variable "vpc_cidr"           { type = string }
variable "subnet_azs"         { type = list(string) }
variable "subnet_cidrs"       { type = list(string) }
variable "resource_name_prefix" { type = string }
