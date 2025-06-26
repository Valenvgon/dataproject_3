resource "null_resource" "build_and_push_docker" {
  

  provisioner "local-exec" {
    working_dir = "${path.module}/../../modules/gcp/web"
    command = <<-EOT
      docker build --platform=linux/amd64 -t  europe-west1-docker.pkg.dev/${var.gcp_project}/${var.artifact_repo_generator}/${var.image_name}:latest .
      docker push europe-west1-docker.pkg.dev/${var.gcp_project}/${var.artifact_repo_generator}/${var.image_name}:latest
    EOT
  }
}

resource "google_cloud_run_service" "frontend" {
  name     = "frontend"
  location = var.gcp_region

  template {
    spec {
      containers {
        image = "europe-west1-docker.pkg.dev/${var.gcp_project}/${var.artifact_repo_generator}/${var.image_name}:latest"
        ports {
          container_port = 8080
        }
        env {
  name  = "DB_HOST"
  value = var.db_host
}

env {
  name  = "DB_NAME"
  value = var.db_name
}

env {
  name  = "DB_USER"
  value = var.db_user
}

env {
  name  = "DB_PASS"
  value = var.db_pass
}
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

  depends_on = [null_resource.build_and_push_docker]  
}

resource "google_cloud_run_service_iam_member" "public_access" {
  service = google_cloud_run_service.frontend.name
  location = google_cloud_run_service.frontend.location
  role = "roles/run.invoker"
  member = "allUsers"

  depends_on= [google_cloud_run_service.frontend]
}