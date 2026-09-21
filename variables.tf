variable "aws_region" {
  description = "AWS region where all resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment  must be  dev or prod"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be either 'dev' or 'prod'."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "multi-env"
}

variable "ec2_instance_type" {
  description = "EC2 instance size — t3.micro for dev, t3.small for prod"
  type        = string
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances to launch — 1 for dev, 3 for prod"
  type        = number
}

variable "enable_detailed_monitoring" {
  description = "Whether to turn on detailed CloudWatch monitoring for EC2 instances"
  type        = bool
  default     = false
}
