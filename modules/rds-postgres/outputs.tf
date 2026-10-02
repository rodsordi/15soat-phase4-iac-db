output "endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.this.address
}

output "port" {
  description = "The database port"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "The database name"
  value       = aws_db_instance.this.db_name
}

output "secret_arn" {
  description = "The ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.db_credentials.arn
}
