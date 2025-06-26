resource "null_resource" "init_schema" {
  provisioner "local-exec" {
    command = <<EOT
      export PGPASSWORD=${var.db_password}
      psql -h ${aws_db_instance.postgres_db.address} \
           -U ${var.db_username} \
           -d ${var.db_name} \
           -p 5432 \
           -f ../../../../../modules/schemas/rds_products_schema.sql

    EOT
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [aws_db_instance.postgres_db]
}