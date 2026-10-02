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

variable "vpc_id" {
  type        = string
  description = "VPC ID where databases will reside"
}

variable "database_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for DB subnet groups"
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
