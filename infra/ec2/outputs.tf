output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "ec2_private_ip" {
  value = module.ec2.private_ip
}

output "ec2_instance_name" {
  value = module.ec2.instance_name
}

output "sql_backup_bucket" {
  value = var.sql_backup_bucket
}
