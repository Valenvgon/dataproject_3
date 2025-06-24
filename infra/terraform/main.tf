# #! --- GCP Modules ---

# module "app_gcp" {
#     source= "./modules/gcp/gcp_flask"

#     gcp_project = var.gcp_project
#     gcp_region  = var.gcp_region
#     artifact_repo_generator = var.artifact_repo_generator
#     flask_image = var.flask_image
#     list_url   = var.list_url
#     add_url    = var.add_url
#     buy_url    = var.buy_url

# }

#! --- AWS Lambda functions ---
module "lambda_list" {
    source = "./modules/aws/lambda_add"
}