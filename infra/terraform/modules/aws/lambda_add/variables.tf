variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-north-1"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository to store the Lambda image"
  type        = string
  default     = "lambda-app-repo"
}

variable "image_tag" {
  description = "Docker image tag to use when building/pushing"
  type        = string
  default     = "latest"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "app-py-container"
}

variable "lambda_role_name" {
  description = "IAM Role name for Lambda execution"
  type        = string
  default     = "lambda-execution-role"
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 10
}

variable "lambda_memory" {
  description = "Lambda memory size in MB"
  type        = number
  default     = 128
}

variable "dockerfile_path" {
  description = "Path to the Dockerfile relative to the Terraform root"
  type        = string
  default     = "Dockerfile"
}

