output "instance_id" {
  value = aws_instance.ec2_instance.id
}

output "private_ip" {
  value = aws_instance.ec2_instance.private_ip
}

output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
}

output "instance_name" {
  value = var.instance_name
}
