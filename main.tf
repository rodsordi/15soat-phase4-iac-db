data "aws_vpc" "eks_vpc" {
  count = var.vpc_id == "" ? 1 : 0
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-vpc"]
  }
}

locals {
  resolved_vpc_id = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.eks_vpc[0].id
}

data "aws_subnets" "database_subnets" {
  count = length(var.database_subnet_ids) == 0 ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [local.resolved_vpc_id]
  }

  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = ["1"]
  }
}

locals {
  resolved_subnet_ids = length(var.database_subnet_ids) > 0 ? var.database_subnet_ids : data.aws_subnets.database_subnets[0].ids
}

module "work_order_db" {
  source = "./modules/rds-postgres"

  identifier     = "work-order-db-${var.environment}"
  database_name  = var.work_order_db_name
  vpc_id         = local.resolved_vpc_id
  subnet_ids     = local.resolved_subnet_ids
  instance_class = var.db_instance_class
  environment    = var.environment
}

module "billing_db" {
  source = "./modules/rds-postgres"

  identifier     = "billing-db-${var.environment}"
  database_name  = var.billing_db_name
  vpc_id         = local.resolved_vpc_id
  subnet_ids     = local.resolved_subnet_ids
  instance_class = var.db_instance_class
  environment    = var.environment
}

module "exec_db" {
  count  = var.enable_documentdb ? 1 : 0
  source = "./modules/documentdb"

  cluster_identifier = "exec-docdb-${var.environment}"
  database_name      = var.exec_db_name
  vpc_id             = local.resolved_vpc_id
  subnet_ids         = local.resolved_subnet_ids
  instance_class     = var.documentdb_instance_class
  environment        = var.environment
}
