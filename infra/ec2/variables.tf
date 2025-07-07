variable "instance_name" {}
variable "instance_type" {}
variable "ami_id" {}
variable "tags" {
  type = map(string)
}
