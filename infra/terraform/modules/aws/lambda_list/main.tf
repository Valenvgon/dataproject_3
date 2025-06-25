resource "aws_ecr_repository" "get_products" {
  name          = "get-products"
  force_delete  = true
  image_tag_mutability = "MUTABLE"
}

resource "null_resource" "build_and_push_lambda_image" {
  provisioner "local-exec" {
    command = <<EOT
      docker buildx inspect lambda-builder >/dev/null 2>&1 || docker buildx create --name lambda-builder --driver docker-container --use
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.get_products.repository_url}
      docker buildx build \
        --builder lambda-builder \
        --platform linux/amd64 \
        --push \
        --provenance=false \
        -t ${aws_ecr_repository.get_products.repository_url}:latest \
        ../../lambdas/get_products
    EOT
    interpreter = ["/bin/bash", "-c"]
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [aws_ecr_repository.get_products]
}

resource "aws_lambda_function" "get_products" {
  function_name = "getProducts"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.get_products.repository_url}:latest"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 10

  environment {
    variables = {
      DB_HOST     = var.db_host
      DB_NAME     = var.db_name
      DB_USER     = var.db_user
      DB_PASSWORD = var.db_pass
    }
  }

  vpc_config {
    subnet_ids         = var.lambda_subnet_ids
    security_group_ids = [var.rds_security_group_id]
  }

  depends_on = [null_resource.build_and_push_lambda_image]
}

# IAM Role para que la Lambda pueda ejecutarse
resource "aws_iam_role" "lambda_exec_role" {
  name = "get_products_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Política básica: logs, invocación, etc.
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "lambda_vpc_access_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}