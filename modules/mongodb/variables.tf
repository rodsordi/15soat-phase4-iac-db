variable "service_name" {
  type        = string
  description = "Kubernetes service and StatefulSet name for MongoDB"
  default     = "mongodb"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace for MongoDB database"
  default     = "infra-database"
}

variable "database_name" {
  type        = string
  description = "Default database name for Workshop Execution"
  default     = "exec_db"
}

variable "admin_username" {
  type        = string
  description = "Root administrator username for MongoDB"
  default     = "mongoadmin"
}

variable "mongodb_version" {
  type        = string
  description = "Docker image tag for MongoDB"
  default     = "7.0"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "prd"
}
