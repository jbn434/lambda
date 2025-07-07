variable "instance_name" {}
variable "instance_type" {}
variable "ami_id" {}
variable "tags" {
  type = map(string)
}
variable "sql_backup_bucket" {
  description = "Name of the S3 bucket containing the SQL backup"
  type        = string
}
