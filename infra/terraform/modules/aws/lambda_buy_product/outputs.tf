output "lambda_name" {
  value = aws_lambda_function.get_item.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.get_item.arn
}

output "ecr_repo_url" {
  value = aws_ecr_repository.get_item.repository_url
}