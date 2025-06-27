resource "null_resource" "init_schema" {
  provisioner "local-exec" {
    command = <<EOT
      export PGPASSWORD=${var.db_password}
      psql -h ${aws_db_instance.postgres_db.address} \
           -U ${var.db_username} \
           -d ${var.db_name} \
           -p 5432 \
           -f /Users/valentinvg/Documents/GitHub/dataproject_3/modules/schemas

    EOT
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [aws_db_instance.postgres_db]
}