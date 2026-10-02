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
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  type        = number
  default     = 100
}

variable "environment" {
  type        = string
  default     = "prd"
}
