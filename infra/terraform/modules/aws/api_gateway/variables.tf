variable "get_products_lambda_arn" {
  type = string
}

variable "get_products_lambda_name" {
  type = string
}

variable "get_item_lambda_arn" {
  type    = string
  default = ""
}

variable "get_item_lambda_name" {
  type    = string
  default = ""
}

variable "add_product_lambda_arn" {
  type    = string
  default = ""
}

variable "add_product_lambda_name" {
  type    = string
  default = ""
}

variable "aws_region" {
  type = string
}