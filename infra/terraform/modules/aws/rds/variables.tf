#! datastream variables

variable "rds_endpoint" {
  type = string
}

variable "publication" {
  type = string
}

variable "replication_slot" {
  type = string
}

variable "datastream_user" {
  type = string
}

variable "datastream_password" {
  type      = string
  sensitive = true
}

variable "parameter_group_name" {
  type        = string
  description = "Name of the parameter group to use in the RDS instance"
}


#! aws variables 
variable "db_name" {
  default = "mydatabase"
}
variable "db_username" {
  default = "dbadminuser"
}
variable "db_password" {
  default = "SuperSecurePass123"
}