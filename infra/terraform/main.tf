# #! --- GCP Modules ---

module "artifact_registry" {
    source = "./modules/gcp/artifact_registry"
    gcp_region = var.gcp_region
}

module "gcp_flask" {
    source = "./modules/gcp/gcp_flask"
    db_host = module.rds.rds_endpoint
    db_name = var.db_name
    db_pass = var.db_pass
    db_user = var.db_user
    base_url = var.base_url
    depends_on = [module.artifact_registry, module.rds]
}

resource "google_datastream_connection_profile" "aws_rds_source" {
  location              = var.gcp_region
  connection_profile_id = "aws-rds-source"
  display_name          = "AWS RDS Source Profile"

  postgresql_profile {
    hostname = var.rds_endpoint
    port     = 5432
    username = var.db_user
    password = var.db_pass
    database = var.db_name
  }
  depends_on = [module.gcp_flask, module.rds]
}

resource "google_datastream_connection_profile" "bq_sink" {
  location              = var.gcp_region
  connection_profile_id = "bq-sink"
  display_name          = "BigQuery Sink Profile"

  bigquery_profile {}
}

module "datastream" {
  source = "./modules/gcp/datastream"
  gcp_region             = var.gcp_region
  rds_endpoint       = var.rds_endpoint
  rds_user           = var.db_user
  rds_password       = var.db_pass
  rds_db_name        = var.db_name
  vpc_host           = var.vpc_host
  subnet             = var.subnet
  bigquery_dataset   = var.bigquery_dataset

  source_connection_profile_id      = google_datastream_connection_profile.aws_rds_source.id
  destination_connection_profile_id = google_datastream_connection_profile.bq_sink.id
  depends_on = [
    google_datastream_connection_profile.aws_rds_source,
    google_datastream_connection_profile.bq_sink
  ]
}

#! --- AWS Lambda functions ---
module "get_products" {
  source      = "./modules/aws/lambda_list"
  account_id  = var.account_id
  aws_region  = var.aws_region 

  db_host = module.rds.rds_endpoint
  db_name = var.db_name
  db_user = var.db_user
  db_pass = var.db_pass
  lambda_subnet_ids     = [module.rds.subnet_a_id, module.rds.subnet_b_id]
  rds_security_group_id = module.rds.rds_sg_id
  depends_on =[module.gcp_flask, module.rds]
}

module "add_product" {
  source      = "./modules/aws/lambda_add"
  account_id  = var.account_id
  aws_region  = var.aws_region
  

  db_host = module.rds.rds_endpoint
  db_name = var.db_name
  db_user = var.db_user
  db_pass = var.db_pass

  lambda_subnet_ids     = [module.rds.subnet_a_id, module.rds.subnet_b_id]
  rds_security_group_id = module.rds.rds_sg_id
  lambda_exec_role_arn = module.get_products.lambda_exec_role_arn

  depends_on = [module.get_products]
}

module "get_item" {
  source      = "./modules/aws/lambda_buy_product"
  account_id  = var.account_id
  aws_region  = var.aws_region

  db_host = module.rds.rds_endpoint
  db_name = var.db_name
  db_user = var.db_user
  db_pass = var.db_pass
  lambda_subnet_ids     = [module.rds.subnet_a_id, module.rds.subnet_b_id]
  rds_security_group_id = module.rds.rds_sg_id
  lambda_exec_role_arn  = module.get_products.lambda_exec_role_arn
  depends_on = [module.add_product]
}

#! RDS MODULE 

module "rds" {
  source = "./modules/aws/rds"

  db_name             = var.db_name
  db_username         = var.db_user
  db_password         = var.db_pass
  rds_endpoint        = var.rds_endpoint
  publication         = var.publication
  replication_slot    = var.replication_slot
  datastream_user     = var.datastream_user
  datastream_password = var.datastream_password
  parameter_group_name = "pg-datastream-csov"
}

module "api_gateway" {
  source = "./modules/aws/api_gateway"

  aws_region = var.aws_region

  get_products_lambda_arn  = module.get_products.lambda_arn
  get_products_lambda_name = module.get_products.lambda_name

  get_item_lambda_arn  = module.get_item.lambda_arn
  get_item_lambda_name = module.get_item.lambda_name

  add_product_lambda_arn  = module.add_product.lambda_arn
  add_product_lambda_name = module.add_product.lambda_name

  depends_on = [
    module.get_products,
    module.add_product,
    module.get_item,
    module.rds
  ]
}