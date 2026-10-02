resource "random_password" "master_password" {
  length  = 20
  special = false
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.identifier}-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.identifier}-sg"
  description = "Security group for ${var.identifier} PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL traffic from VPC"
    from_port   = 5432
    to_port     = 5432
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
    Name = "${var.identifier}-sg"
  }
}

resource "aws_db_instance" "this" {
  identifier                  = var.identifier
  engine                      = "postgres"
  engine_version              = "16.3"
  instance_class              = var.instance_class
  allocated_storage           = var.allocated_storage
  max_allocated_storage       = var.max_allocated_storage
  storage_type                = "gp3"
  db_name                     = var.database_name
  username                    = "dbadmin"
  password                    = random_password.master_password.result
  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  skip_final_snapshot         = true
  deletion_protection         = false
  auto_minor_version_upgrade  = true
  publicly_accessible         = false

  tags = {
    Name = var.identifier
  }
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "${var.identifier}-credentials-${var.environment}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    engine   = "postgres"
    host     = aws_db_instance.this.address
    port     = aws_db_instance.this.port
    database = var.database_name
    username = aws_db_instance.this.username
    password = random_password.master_password.result
    jdbc_url = "jdbc:postgresql://${aws_db_instance.this.address}:${aws_db_instance.this.port}/${var.database_name}"
  })
}
