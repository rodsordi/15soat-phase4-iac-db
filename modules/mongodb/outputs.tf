output "service_name" {
  description = "MongoDB Kubernetes service name"
  value       = kubernetes_service.mongodb.metadata[0].name
}

output "namespace" {
  description = "MongoDB Kubernetes namespace"
  value       = kubernetes_namespace.database.metadata[0].name
}

output "endpoint" {
  description = "MongoDB internal cluster endpoint"
  value       = "${kubernetes_service.mongodb.metadata[0].name}.${kubernetes_namespace.database.metadata[0].name}.svc.cluster.local:27017"
}

output "secret_arn" {
  description = "MongoDB secret ARN in AWS Secrets Manager"
  value       = aws_secretsmanager_secret.mongodb_credentials.arn
}

output "connection_uri" {
  description = "MongoDB connection URI"
  value       = "mongodb://${var.admin_username}:${random_password.mongodb_root_password.result}@${kubernetes_service.mongodb.metadata[0].name}.${kubernetes_namespace.database.metadata[0].name}.svc.cluster.local:27017/${var.database_name}?authSource=admin"
  sensitive   = true
}
