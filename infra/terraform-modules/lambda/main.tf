resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.function_name}-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "secrets_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_vpc" "lambda_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.resource_name_prefix}-vpc"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.lambda_vpc.id
  cidr_block        = var.subnet_cidrs[0]
  availability_zone = var.subnet_azs[0]

  tags = {
    Name = "${var.resource_name_prefix}-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.lambda_vpc.id
  cidr_block        = var.subnet_cidrs[1]
  availability_zone = var.subnet_azs[1]

  tags = {
    Name = "${var.resource_name_prefix}-subnet-2"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.lambda_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.subnet_azs[0]

  tags = {
    Name = "${var.resource_name_prefix}-public-subnet-1"
  }
}

resource "aws_internet_gateway" "lambda_igw" {
  vpc_id = aws_vpc.lambda_vpc.id

  tags = {
    Name = "${var.resource_name_prefix}-igw"
  }
}

resource "aws_eip" "nat_eip" {

  tags = {
    Name = "${var.resource_name_prefix}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "${var.resource_name_prefix}-nat-gw"
  }

  depends_on = [aws_internet_gateway.lambda_igw]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.lambda_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.resource_name_prefix}-private-rt"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lambda_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lambda_igw.id
  }

  tags = {
    Name = "${var.resource_name_prefix}-public-rt"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "lambda_sg" {
  name        = "${var.resource_name_prefix}-sg"
  description = "Security group for Lambda in VPC"
  vpc_id      = aws_vpc.lambda_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.resource_name_prefix}-sg"
  }
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout

  filename         = var.lambda_package
  source_code_hash = filebase64sha256(var.lambda_package)

  vpc_config {
    subnet_ids         = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  tags = var.tags
}
