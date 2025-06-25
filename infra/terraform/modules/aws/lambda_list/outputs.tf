output "lambda_name" {
  value = aws_lambda_function.get_products.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.get_products.arn
}

output "ecr_repo_url" {
  value = aws_ecr_repository.get_products.repository_url
}

output "lambda_exec_role_arn" {
  value = aws_iam_role.lambda_exec_role.arn
}
