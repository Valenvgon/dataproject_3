resource "aws_api_gateway_rest_api" "main" {
  name        = "ProductosAPI"
  description = "API Gateway REST para acceder a las Lambdas de productos"
}

resource "aws_api_gateway_resource" "get_products" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "get-products"
}

resource "aws_api_gateway_resource" "get_item" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "get-item"
}

resource "aws_api_gateway_resource" "add_product" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "add-product"
}

resource "aws_api_gateway_method" "get_products" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.get_products.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_products" {
  depends_on              = [aws_api_gateway_method.get_products]
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.get_products.id
  http_method             = aws_api_gateway_method.get_products.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.get_products_lambda_arn}/invocations"
}

resource "aws_lambda_permission" "allow_get_products" {
  statement_id  = "AllowExecutionFromAPIGatewayGetProducts"
  action        = "lambda:InvokeFunction"
  function_name = var.get_products_lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

resource "aws_api_gateway_method" "get_item" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.get_item.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_item" {
  depends_on              = [aws_api_gateway_method.get_item]
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.get_item.id
  http_method             = aws_api_gateway_method.get_item.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.get_item_lambda_arn}/invocations"
}

resource "aws_lambda_permission" "allow_get_item" {
  statement_id  = "AllowExecutionFromAPIGatewayGetItem"
  action        = "lambda:InvokeFunction"
  function_name = var.get_item_lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

resource "aws_api_gateway_method" "add_product" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.add_product.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "add_product" {
  depends_on              = [aws_api_gateway_method.add_product]
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.add_product.id
  http_method             = aws_api_gateway_method.add_product.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.add_product_lambda_arn}/invocations"
}

resource "aws_lambda_permission" "allow_add_product" {
  statement_id  = "AllowExecutionFromAPIGatewayAddProduct"
  action        = "lambda:InvokeFunction"
  function_name = var.add_product_lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.get_products,
    aws_api_gateway_integration.get_item,
    aws_api_gateway_integration.add_product
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id

  triggers = {
    redeploy = timestamp()
  }
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.main.id
  deployment_id = aws_api_gateway_deployment.deployment.id
}