variable "gcp_project" {}

variable "gcp_region" { default = "europe-west1" }

variable "artifact_repo_generator" { default = "frontend" }

variable "image_name" { default = "frontend" }



variable "db_host" {
  type        = string
  description = "Endpoint de la base de datos PostgreSQL (RDS)"
}

variable "db_user" {
  type        = string
  description = "Usuario de la base de datos PostgreSQL (RDS)"
}

variable "db_pass" {
  type        = string
  description = "Contraseña de la base de datos PostgreSQL (RDS)"
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string

}

variable "base_url" {
  description = "URL base del API Gateway que utilizan las funciones"
  type        = string
}
