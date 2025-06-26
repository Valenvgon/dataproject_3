resource "aws_db_parameter_group" "postgresql_datastream" {
  name        = "pg-datastream-csov"
  family      = "postgres15"
  description = "Parameter group for Datastream logical replication"


  parameter {
    name         = "max_replication_slots"
    value        = "10"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_wal_senders"
    value        = "10"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "rds.logical_replication"
    value        = "1"
    apply_method = "pending-reboot" 
  }
}

resource "aws_db_instance" "postgres_db" {
  identifier              = "deportiva-postgres"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = true
  skip_final_snapshot     = true
  multi_az                = false
  storage_encrypted       = true
  parameter_group_name = aws_db_parameter_group.postgresql_datastream.name


  tags = {
    Name = "rds-deportiva"
  }
}


