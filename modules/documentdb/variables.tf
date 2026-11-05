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
  description = "DocumentDB instance class"
  default     = "db.t4g.medium"
}

variable "storage_encrypted" {
  type        = bool
  description = "Whether cluster storage is encrypted (set to false for AWS Academy Learner Lab compatibility)"
  default     = false
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "prd"
}
