variable "aws_region" {
  type        = string
  description = "AWS region for database resources"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, stg, prd)"
  default     = "prd"
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name used for VPC and Subnet auto-discovery"
  default     = "fiap-workshop-eks"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where databases will reside (optional, auto-discovered if blank)"
  default     = ""
}

variable "database_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for DB subnet groups (optional, auto-discovered if blank)"
  default     = []
}

variable "work_order_db_name" {
  type        = string
  description = "Database name for Work Order service"
  default     = "work_order_db"
}

variable "billing_db_name" {
  type        = string
  description = "Database name for Billing service"
  default     = "billing_db"
}

variable "exec_db_name" {
  type        = string
  description = "Database name for Workshop Execution service"
  default     = "exec_db"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t4g.micro"
}

variable "documentdb_instance_class" {
  type        = string
  description = "DocumentDB instance class"
  default     = "db.t4g.medium"
}

variable "enable_documentdb" {
  type        = bool
  description = "Flag to enable or disable DocumentDB provisioning (disabled for AWS Academy compatibility)"
  default     = false
}

variable "enable_mongodb" {
  type        = bool
  description = "Flag to enable or disable MongoDB provisioning on EKS"
  default     = true
}
