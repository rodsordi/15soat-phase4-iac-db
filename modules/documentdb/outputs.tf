output "cluster_endpoint" {
  description = "Cluster endpoint for DocumentDB"
  value       = aws_docdb_cluster.this.endpoint
}

output "reader_endpoint" {
  description = "Reader endpoint for DocumentDB"
  value       = aws_docdb_cluster.this.reader_endpoint
}

output "port" {
  description = "DocumentDB port"
  value       = aws_docdb_cluster.this.port
}

output "secret_arn" {
  description = "The ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.docdb_credentials.arn
}
