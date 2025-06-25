#! GCP variables 
variable "gcp_project" { default = "sand-457022"}
variable "gcp_region"  { default = "europe-west1" }
variable "module_path_gcp" { type= string}

variable "rds_endpoint" {
  description = "Endpoint de la base de datos RDS"
  type        = string
}

variable "db_user" {
  description = "Usuario de la base de datos"
  type        = string
  default     = "admin"
}

variable "db_pass" {
  description = "Contraseña de la base de datos"
  type        = string
  default     = "admin"
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "mydatabase"
}

variable "vpc_host" {
  description = "Nombre completo del VPC host para Datastream peering"
  type        = string
  default     = "projects/data-project-3/global/networks/default"
}

variable "subnet" {
  description = "CIDR reservado para Datastream peering (debe estar libre)"
  type        = string
  default     = "10.200.0.0/29"
}

variable "bigquery_dataset" {
  description = "Nombre del dataset de BigQuery donde replicará Datastream"
  type        = string
  default     = "rdsdata"
}

#! AWS variables
variable "aws_region"  { default = "us-east-1" }



