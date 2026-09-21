output "active_workspace" {
  description = "The Terraform workspace that is currently active"
  value       = terraform.workspace
}

output "deployed_environment" {
  description = "The environment that resources were deployed into"
  value       = var.environment
}

output "vpc_id" {
  description = "ID of the default VPC used for deployment"
  value       = data.aws_vpc.default_vpc.id
}

output "subnet_ids" {
  description = "List of subnet IDs available inside the default VPC"
  value       = data.aws_subnets.default_subnets.ids
}

output "ami_id" {
  description = "ID of the latest Amazon Linux 2023 AMI that was selected"
  value       = data.aws_ami.amazon_linux_2023.id
}

output "security_group_id" {
  description = "ID of the security group attached to the web servers"
  value       = aws_security_group.web_servers.id
}

output "web_server_ids" {
  description = "List of EC2 instance IDs for all provisioned web servers"
  value       = aws_instance.web_server[*].id
}

output "ec2_instance_type" {
  description = "The EC2 instance type used in this environment"
  value       = var.ec2_instance_type
}

output "total_web_servers" {
  description = "Total number of web server instances that were created"
  value       = length(aws_instance.web_server)
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket used for environment storage"
  value       = aws_s3_bucket.environment_storage.bucket
}

output "web_server_public_ips" {
  description = "Public IP addresses of all web server instances"
  value       = aws_instance.web_server[*].public_ip
}

output "web_server_urls" {
  description = "Clickable HTTP URLs for each web server"
  value       = [for ip in aws_instance.web_server[*].public_ip : "http://${ip}"]
}
