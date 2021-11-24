terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "learning-bucket-24112021"
    key    = "hello-key"
    region = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "our-network" {
  cidr_block = "10.0.0.0/16"

  tags = {
    # To change
    service = "vpc"
    Name    = "learn-network"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }
}

resource "aws_internet_gateway" "our-getway" {
  vpc_id = aws_vpc.our-network.id

  tags = {
    # To change
    service = "gateway"
    Name    = "learn-gateway"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }
}

resource "aws_route_table" "our-route-table" {
  vpc_id = aws_vpc.our-network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.our-getway.id
  }

  tags = {
    # To change
    service = "route-table"
    Name    = "learn-route-table"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }
}

resource "aws_nat_gateway" "our-private-nat-gateway" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.our-subnet.id

  tags = {
    # To change
    service = "nat-gateway"
    Name    = "learn-nat-gateway"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }
}

resource "aws_nat_gateway" "our-public-nat-gateway" {
  subnet_id     = aws_subnet.our-subnet3.id

  tags = {
    # To change
    service = "nat-gateway"
    Name    = "learn-nat-gateway"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.our-getway]
}

resource "aws_subnet" "our-subnet" {
  vpc_id     = aws_vpc.our-network.id
  cidr_block = var.CIDR1

  tags = {
    # To change
    service = "subnet"
    Name    = "learn-subnet"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }
}

resource "aws_subnet" "our-subnet2" {
  vpc_id     = aws_vpc.our-network.id
  cidr_block = var.CIDR2

  tags = {
    # To change
    service = "subnet"
    Name    = "learn-subnet2"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }
}

resource "aws_subnet" "our-subnet3" {
  vpc_id     = aws_vpc.our-network.id
  cidr_block = var.CIDR3

  tags = {
    # To change
    service = "subnet"
    Name    = "learn-subnet3"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }
}

resource "aws_subnet" "our-subnet4" {
  vpc_id     = aws_vpc.our-network.id
  cidr_block = var.CIDR4

  tags = {
    # To change
    service = "subnet"
    Name    = "learn-subnet4"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }
}

# Using our server
resource "aws_instance" "our-core" {
  ami                         = var.EC2_AMI
  instance_type               = var.EC2_type
  associate_public_ip_address = true
  #availability_zone                    = "us-east-1d"
  disable_api_termination              = false
  ebs_optimized                        = false
  get_password_data                    = false
  hibernation                          = false
  iam_instance_profile                 = aws_iam_instance_profile.our-profile.name
  instance_initiated_shutdown_behavior = "stop"
  ipv6_address_count                   = 0

  # We are not changing it since we already have one
  key_name              = var.keys
  monitoring            = false
  secondary_private_ips = []
  security_groups       = [aws_security_group.our-security-group.id]
  source_dest_check     = true
  subnet_id             = aws_subnet.our-subnet.id

  tags = {
    # To change
    service = "ec2"
    Name    = "learn-ec2"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 8
    volume_type           = "gp2"

    tags = {
      # To change
      service = "block-device"
      Name    = "learn-block-device"

      # Defined in terraform.tfvars
      owner       = var.author
      platform    = var.platform
      environment = var.environment
    }
  }
}

resource "aws_security_group" "our-security-group" {
  name        = "learning-group"
  description = "Allow only SSH from the specific IP"
  vpc_id      = aws_vpc.our-network.id

  ingress {
    description      = "SSH from only one IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.CIDR_to_allow_inbound_SSH]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    # To change
    service = "block-device"
    Name    = "learn-block-device"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }
}

resource "aws_s3_bucket" "our-bucket" {
  bucket = "learning-bucket-24112021"
  acl    = "private"

  tags = {
    # To change
    service = "s3"
    Name    = "learn-s3"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }
}

resource "aws_iam_instance_profile" "our-profile" {
  name = "learn-profile"
  role = aws_iam_role.our-role.name
}

resource "aws_iam_role" "our-role" {
  name = "learning-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  # We are trusting role assumance to the EC2 instances
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    # To change
    service = "role"
    Name    = "learn-role"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "our-attachment" {
  role       = aws_iam_role.our-role.name
  policy_arn = aws_iam_policy.our-policy.arn
}

resource "aws_iam_policy" "our-policy" {
  name        = "learning-policy"
  path        = "/"
  description = "Policy that allows access to a single S3 bucket"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "s3:ListBucket",
          "Resource" : aws_s3_bucket.our-bucket.arn
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : [
            "s3:PutObject",
            "s3:GetObject"
          ],

          # https://stackoverflow.com/a/58224248
          "Resource" : format("%s/%s", aws_s3_bucket.our-bucket.arn, "/*")
        }
      ]
    }
  )

  tags = {
    # To change
    service = "policy"
    Name    = "learn-policy"

    # Defined in terraform.tfvars
    owner       = var.author
    platform    = var.platform
    environment = var.environment
  }
}