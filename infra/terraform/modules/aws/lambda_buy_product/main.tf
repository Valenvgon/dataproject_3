resource "aws_ecr_repository" "get_item" {
  name                 = "get-item"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
}

resource "null_resource" "build_and_push_lambda_image" {
  provisioner "local-exec" {
    command = <<EOT
      docker buildx inspect lambda-builder >/dev/null 2>&1 || docker buildx create --name lambda-builder --driver docker-container --use
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.get_item.repository_url}
      docker buildx build \
        --builder lambda-builder \
        --platform linux/amd64 \
        --push \
        --provenance=false \
        -t ${aws_ecr_repository.get_item.repository_url}:latest \
        ${path.module}/../../../../modules/aws/aws_lambda_buy

    EOT
    interpreter = ["/bin/bash", "-c"]
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [aws_ecr_repository.get_item]
}

resource "aws_lambda_function" "get_item" {
  function_name = "getItem"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.get_item.repository_url}:latest"
  role          = var.lambda_exec_role_arn
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