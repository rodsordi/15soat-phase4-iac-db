variable "identifier" {
  type        = string
  description = "Identifier for the RDS instance"
}

variable "database_name" {
  type        = string
  description = "Initial database name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for DB subnet group"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t4g.micro"
}

variable "engine_version" {
  type        = string
  description = "PostgreSQL engine version"
  default     = "16.10"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage in GB"
  default     = 20
}

variable "max_allocated_storage" {
  type        = number
  description = "Maximum allocated storage for autoscaling in GB"
  default     = 100
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "prd"
}
