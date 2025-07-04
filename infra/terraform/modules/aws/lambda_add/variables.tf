variable "account_id" {
  type        = string
  description = "ID de la cuenta AWS"
}

variable "aws_region" {
  type        = string
  description = "Región AWS"
}

variable "db_host" {
  type        = string
  description = "Endpoint de la base de datos RDS"
}

variable "db_name" {
  type        = string
  description = "Nombre de la base de datos"
}

variable "db_user" {
  type        = string
  description = "Usuario para la base de datos"
}

variable "db_pass" {
  type        = string
  description = "Contraseña de la base de datos"
}
variable "lambda_subnet_ids" {
  type = list(string)
}

variable "rds_security_group_id" {
  type = string
}

variable "lambda_exec_role_arn" {
  type        = string
  description = "ARN del rol IAM compartido para las Lambdas"
}