#! GCP variables 
variable "gcp_project" {   
    type = string 
    description = "ID del proyecto de GCP"

}

variable "gcp_region"  {
    type = string
    description = "Region donde se desplegan los recursos de GCP"
    default = "europe-west1" 

}




variable "rds_endpoint" {
  description = "Endpoint de la base de datos RDS"
  type        = string
}


    #! DB config 
variable "db_user" {
  description = "Usuario de la base de datos"
  type        = string
  default     = "dbadminuser"
}

variable "db_pass" {
  description = "Contraseña de la base de datos"
  type        = string
  default     = "SuperSecurePass123"
}


variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "mydatabase"
}
    #! -----------------------------------------------

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
variable "aws_region"  { default = "eu-west-1" }

variable "account_id" {
  description = "ID de la cuenta AWS"
  type        = string
}

#? this for datastream moduel 
variable "publication" {
  description = "Nombre de la publicación para Datastream"
  type        = string
  default     = "rds_publication"
}

variable "replication_slot" {
  description = "Nombre del replication slot para Datastream"
  type        = string
  default     = "rds_slot"
}

variable "datastream_user" {
  description = "Nombre del usuario para Datastream"
  type        = string
  default     = "datastream_user"
}

variable "datastream_password" {
  description = "Contraseña del usuario para Datastream"
  type        = string
  sensitive   = true
}


variable "rds_allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the RDS instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}