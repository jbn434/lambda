module "ec2" {
  source = "../terraform-modules/ec2"

  instance_name             = var.instance_name
  instance_type             = var.instance_type
  ami_id                    = var.ami_id

  vpc_id                    = data.terraform_remote_state.lambda.outputs.vpc_id
  subnet_id                 = data.terraform_remote_state.lambda.outputs.private_subnet_ids[0]
  lambda_security_group_id = data.terraform_remote_state.lambda.outputs.lambda_sg_id

  tags                      = var.tags
}
