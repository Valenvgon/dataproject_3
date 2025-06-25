variable "gcp_region" {}
variable "rds_endpoint" {}
variable "rds_user" {}
variable "rds_password" {}
variable "rds_db_name" {}

variable "vpc_host" {
  description = "ID del VPC peered en GCP (ej: projects/.../global/networks/...)"
}

variable "subnet" {
  description = "CIDR block reservado para Datastream peering (ej: 10.0.0.0/29)"
}

variable "bigquery_dataset" {}

variable "publication" {
  description = "Nombre de la publicación en PostgreSQL"
  type        = string
  default     = "rds_publication"
}

variable "replication_slot" {
  description = "Nombre del replication slot en PostgreSQL"
  type        = string
  default     = "datastream_slot"
}

variable "source_connection_profile_id" {
  description = "ID del connection profile de origen (RDS)"
  type        = string
}

variable "destination_connection_profile_id" {
  description = "ID del connection profile de destino (BigQuery)"
  type        = string
}
