


output "rds_endpoint" {
  value = aws_db_instance.postgres_db.address
}

output "subnet_a_id" {
  value = aws_subnet.private_a.id
}

output "subnet_b_id" {
  value = aws_subnet.private_b.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}