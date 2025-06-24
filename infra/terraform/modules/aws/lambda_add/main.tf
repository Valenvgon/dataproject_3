locals {
  # Complete image URI (repo URL + tag)
  image_uri       = "${aws_ecr_repository.lambda_repo.repository_url}:${var.image_tag}"
  # Platform to build for. On Macs con Apple Silicon, build the x86_64 image for Lambda
  docker_platform = "linux/amd64" # Cambia a "linux/arm64" si quieres usar la arquitectura arm64
}

# ---------- Container registry ----------
resource "aws_ecr_repository" "lambda_repo" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ---------- IAM for Lambda ----------
resource "aws_iam_role" "lambda_exec_role" {
  name               = "${var.ecr_repository_name}-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ---------- Build & push (local-exec) ----------
resource "null_resource" "ecr_login_build_push" {
  provisioner "local-exec" {
    working_dir = "/Users/valentinvg/Documents/GitHub/dataproject_3/modules/aws/aws_lambda_add"
    command = <<EOT
aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.lambda_repo.repository_url}

docker build --platform=${local.docker_platform} -t ${local.image_uri} .

docker push ${local.image_uri}
EOT
  }

  # Reconstruye si cambia el código o el Dockerfile
  triggers = {
    dockerfile_hash = filesha256("/Users/valentinvg/Documents/GitHub/dataproject_3/modules/aws/aws_lambda_add/dockerfile")
    app_hash        = filesha256("/Users/valentinvg/Documents/GitHub/dataproject_3/modules/aws/aws_lambda_add/app.py")
  }
}

# ---------- Lambda  ----------
resource "aws_lambda_function" "app" {
  function_name = var.lambda_function_name
  package_type  = "Image"
  image_uri     = local.image_uri
  role          = aws_iam_role.lambda_exec_role.arn

  architectures = ["x86_64"]            # o ["arm64"] si compilas arm
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory

  depends_on = [null_resource.ecr_login_build_push]
}
