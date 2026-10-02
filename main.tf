module "work_order_db" {
  source = "./modules/rds-postgres"

  identifier        = "work-order-db-${var.environment}"
  database_name     = var.work_order_db_name
  vpc_id            = var.vpc_id
  subnet_ids        = var.database_subnet_ids
  instance_class    = var.db_instance_class
  environment       = var.environment
}

module "billing_db" {
  source = "./modules/rds-postgres"

  identifier        = "billing-db-${var.environment}"
  database_name     = var.billing_db_name
  vpc_id            = var.vpc_id
  subnet_ids        = var.database_subnet_ids
  instance_class    = var.db_instance_class
  environment       = var.environment
}

module "exec_db" {
  source = "./modules/documentdb"

  cluster_identifier = "exec-docdb-${var.environment}"
  database_name      = var.exec_db_name
  vpc_id             = var.vpc_id
  subnet_ids         = var.database_subnet_ids
  instance_class     = var.documentdb_instance_class
  environment        = var.environment
}

