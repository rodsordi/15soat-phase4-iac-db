output "work_order_db_endpoint" {
  description = "Work Order PostgreSQL endpoint"
  value       = module.work_order_db.endpoint
}

output "work_order_db_secret_arn" {
  description = "Work Order DB secret ARN"
  value       = module.work_order_db.secret_arn
}

output "billing_db_endpoint" {
  description = "Billing PostgreSQL endpoint"
  value       = module.billing_db.endpoint
}

output "billing_db_secret_arn" {
  description = "Billing DB secret ARN"
  value       = module.billing_db.secret_arn
}

output "exec_docdb_cluster_endpoint" {
  description = "Workshop Execution DocumentDB/MongoDB cluster endpoint"
  value       = module.exec_db.cluster_endpoint
}

output "exec_docdb_secret_arn" {
  description = "Workshop Execution DB secret ARN"
  value       = module.exec_db.secret_arn
}

