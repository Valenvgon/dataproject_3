output "lambda_name" {
  value = aws_lambda_function.add_product.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.add_product.arn
}

output "ecr_repo_url" {
  value = aws_ecr_repository.add_product.repository_url
}