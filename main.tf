data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

data "aws_availability_zones" "available_zones" {
  state = "available"
}

data "aws_ec2_instance_type_offerings" "supported" {
  location_type = "availability-zone"

  filter {
    name   = "instance-type"
    values = [var.ec2_instance_type]
  }
}

data "aws_subnet" "default_subnet" {
  for_each = toset(data.aws_subnets.default_subnets.ids)
  id       = each.value
}

locals {
  supported_azs = toset(data.aws_ec2_instance_type_offerings.supported.locations)
  supported_subnet_ids = [
    for subnet_id in data.aws_subnets.default_subnets.ids :
    subnet_id
    if contains(local.supported_azs, data.aws_subnet.default_subnet[subnet_id].availability_zone)
  ]
  instance_count = length(local.supported_subnet_ids) > 0 ? min(var.ec2_instance_count, length(local.supported_subnet_ids)) : 0
}

resource "aws_security_group" "web_servers" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Security group for ${var.environment} web servers"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    description = "Allow HTTP traffic from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH access from internal admin networks only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-web-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "web_server" {
  count                  = local.instance_count
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.ec2_instance_type
  subnet_id              = local.supported_subnet_ids[count.index % length(local.supported_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.web_servers.id]
  monitoring             = var.enable_detailed_monitoring

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from ${var.environment} server ${count.index + 1} (${var.ec2_instance_type})" > index.html
              python3 -m http.server 80 &
              EOF

  tags = {
    Name        = "${var.project_name}-${var.environment}-web-${count.index + 1}"
    Environment = var.environment
    ServerNumber = tostring(count.index + 1)
  }
}

resource "aws_s3_bucket" "environment_storage" {
  bucket        = "${var.project_name}-${var.environment}-storage-${substr(data.aws_vpc.default_vpc.id, 4, 8)}"
  force_destroy = var.environment == "dev"

  tags = {
    Name        = "${var.project_name}-${var.environment}-storage"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "environment_storage_versioning" {
  bucket = aws_s3_bucket.environment_storage.id

  versioning_configuration {
    status = var.environment == "prod" ? "Enabled" : "Suspended"
  }
}
