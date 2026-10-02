variable "cluster_identifier" {
  type        = string
  description = "Cluster identifier for DocumentDB"
}

variable "database_name" {
  type        = string
  description = "Database name"
  default     = "exec_db"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for DocumentDB subnet group"
}

variable "instance_class" {
  type        = string
  default     = "db.t4g.medium"
}

variable "environment" {
  type        = string
  default     = "prd"
}
