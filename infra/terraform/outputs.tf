output "api_gateway_url" {
  value       = module.api_gateway.invoke_url
  description = "Invoke URL for the AWS API Gateway"
}