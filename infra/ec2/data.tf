data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket = "back-up-tester"
    key    = "dev/lambda/terraform.tfstate"
    region = "us-east-1"
  }
}
