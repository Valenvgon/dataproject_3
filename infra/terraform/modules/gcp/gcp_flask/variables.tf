variable "gcp_project" { default = "sand-457022"}
variable "gcp_region"  { default = "europe-west1" }
variable "artifact_repo_generator" { default = "flask-store-repo" }
variable "flask_image" {default ="gcr.io/my-project/flask-store:latest"}
variable "list_url" {type = string }
variable "add_url"  {type = string }
variable "buy_url" {type = string }
variable "image_name" {default = "gcpflask"}

