resource "aws_db_subnet_group" "prod" {
  name       = "prod"
  subnet_ids = [aws_subnet.prod_private_1.id, aws_subnet.prod_private_2.id]
}

resource "aws_db_instance" "prod" {
  identifier              = "prod"
  db_name                 = var.prod_rds_db_name
  username                = var.prod_rds_username
  password                = var.prod_rds_password
  port                    = "5432"
  engine                  = "postgres"
  engine_version          = "14.2"
  instance_class          = var.prod_rds_instance_class
  allocated_storage       = "20"
  storage_encrypted       = false
  vpc_security_group_ids  = [aws_security_group.rds_prod.id]
  db_subnet_group_name    = aws_db_subnet_group.prod.name
  multi_az                = false
  storage_type            = "gp2"
  publicly_accessible     = false
  backup_retention_period = 5
  skip_final_snapshot     = true
}

# RDS Security Group (traffic ECS -> RDS)
resource "aws_security_group" "rds_prod" {
  name        = "rds-prod"
  vpc_id      = aws_vpc.prod.id

  ingress {
    protocol        = "tcp"
    from_port       = "5432"
    to_port         = "5432"
    security_groups = [aws_security_group.prod_ecs_backend.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}