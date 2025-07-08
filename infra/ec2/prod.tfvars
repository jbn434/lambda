instance_name = "postgres-ec2-prod"
instance_type = "t2.micro"
ami_id        = "ami-020cba7c55df1f615"
sql_backup_bucket = "idlms-website-built-artifact"
tags = {
  Environment = "prod"
  Project     = "backend-api"
}
