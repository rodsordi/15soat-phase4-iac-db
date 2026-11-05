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
  value       = var.enable_documentdb && length(module.exec_db) > 0 ? module.exec_db[0].cluster_endpoint : null
}

output "exec_docdb_secret_arn" {
  description = "Workshop Execution DB secret ARN"
  value       = var.enable_documentdb && length(module.exec_db) > 0 ? module.exec_db[0].secret_arn : null
}

output "resolved_vpc_id" {
  description = "Resolved VPC ID where databases reside"
  value       = local.resolved_vpc_id
}

output "resolved_database_subnet_ids" {
  description = "Resolved Subnet IDs used for database subnets"
  value       = local.resolved_subnet_ids
}
