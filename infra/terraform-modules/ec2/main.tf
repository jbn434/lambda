resource "aws_iam_role" "ssm_role" {
  name = "${var.instance_name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.instance_name}-ssm-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-sg"
  description = "Allow PostgreSQL access from Lambda SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.lambda_security_group_id]
    description     = "Allow PostgreSQL from Lambda"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  associate_public_ip_address = false

  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )

user_data = <<-EOF
  #!/bin/bash
  set -euxo pipefail

  # Log everything to file and console
  exec > >(tee /var/log/userdata.log | logger -t user-data -s 2>/dev/console) 2>&1

  # Give cloud-init and network some time
  sleep 20

  # Install dependencies
  apt-get update -y
  apt-get install -y curl gnupg2 lsb-release ca-certificates software-properties-common sudo

  # Add PostgreSQL GPG key and repository for Ubuntu 24.04 (noble)
  curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql.gpg
  echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt noble-pgdg main" > /etc/apt/sources.list.d/pgdg.list

  # Install PostgreSQL 15
  apt-get update -y
  apt-get install -y postgresql-15

  # Enable and start PostgreSQL service
  systemctl enable postgresql
  systemctl start postgresql

  # Configure PostgreSQL for external access
  sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/15/main/postgresql.conf
  echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/15/main/pg_hba.conf
  systemctl restart postgresql

  # Install and start SSM agent
  snap install amazon-ssm-agent --classic
  sleep 5
  systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
  systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

  # Debug outputs
  psql --version || echo "PostgreSQL client not found"
  systemctl status postgresql || true
  journalctl -u postgresql.service || true
EOF



}
