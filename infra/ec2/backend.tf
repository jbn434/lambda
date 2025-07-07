terraform {
  backend "s3" {
    bucket = "back-up-tester"
    key    = "dev/ec2/terraform.tfstate"
    region = "us-east-1"
  }
}
