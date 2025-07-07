variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "lambda_security_group_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "sql_backup_bucket" {
  type        = string
}
