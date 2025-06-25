variable "gcp_project" { default = "sand-457022"}

variable "gcp_region"  { default = "europe-west1" }

variable "artifact_repo_generator" { default = "flask-store-repo" }

variable "image_name" {default = "gcpflask"}

variable "module_path_gcp" {type = string}

variable "db_host" {
  type        = string 
  description = "Endpoint de la base de datos PostgreSQL (RDS)"
}