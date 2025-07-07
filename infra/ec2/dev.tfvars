instance_name = "postgres-ec2-dev"
instance_type = "t2.micro"
ami_id        = "ami-020cba7c55df1f615"

tags = {
  Environment = "dev"
  Project     = "backend-api"
}
