resource "random_password" "master_password" {
  length  = 20
  special = false
}

resource "aws_docdb_subnet_group" "this" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.cluster_identifier}-subnet-group"
  }
}

resource "aws_security_group" "docdb" {
  name        = "${var.cluster_identifier}-sg"
  description = "Security group for DocumentDB / Mongo cluster"
  vpc_id      = var.vpc_id

  ingress {
    description = "MongoDB protocol traffic from VPC"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_identifier}-sg"
  }
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "docdb"
  master_username         = "docdbadmin"
  master_password         = random_password.master_password.result
  db_subnet_group_name    = aws_docdb_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.docdb.id]
  skip_final_snapshot     = true
  deletion_protection     = false
  storage_encrypted       = true

  tags = {
    Name = var.cluster_identifier
  }
}

resource "aws_docdb_cluster_instance" "this" {
  count              = 1
  identifier         = "${var.cluster_identifier}-node-1"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class

  tags = {
    Name = "${var.cluster_identifier}-instance"
  }
}

resource "aws_secretsmanager_secret" "docdb_credentials" {
  name                    = "${var.cluster_identifier}-credentials-${var.environment}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "docdb_credentials" {
  secret_id = aws_secretsmanager_secret.docdb_credentials.id
  secret_string = jsonencode({
    engine   = "docdb"
    endpoint = aws_docdb_cluster.this.endpoint
    port     = 27017
    database = var.database_name
    username = aws_docdb_cluster.this.master_username
    password = random_password.master_password.result
    uri      = "mongodb://${aws_docdb_cluster.this.master_username}:${random_password.master_password.result}@${aws_docdb_cluster.this.endpoint}:27017/${var.database_name}?tls=true&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
  })
}
