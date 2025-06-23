resource "google_artifact_registry_repository" "repo_generate" {
  project       = var.gcp_project
  location      = var.gcp_region
  repository_id = var.artifact_repo_generator
  format        = "DOCKER"
}

resource "null_resource" "build_and_push_docker" {
  depends_on = [google_artifact_registry_repository.repo_generate]

  provisioner "local-exec" {
    working_dir = "/Users/valentinvg/Documents/GitHub/dataproject_3/modules/gcp/gcp_flask/"
    command = <<-EOT
      docker build --platform=linux/amd64 -t  europe-west1-docker.pkg.dev/${var.gcp_project}/${var.artifact_repo_generator}/${var.image_name}:latest .
      docker push europe-west1-docker.pkg.dev/${var.gcp_project}/${var.artifact_repo_generator}/${var.image_name}:latest
    EOT
  }
}

resource "google_cloud_run_service" "store" {

  depends_on = [google_artifact_registry_repository.repo_generate , null_resource.build_and_push_docker]



  name     = "gcpflask"
  location = var.gcp_region

  template {
    spec {
      containers {
        image = "europe-west1-docker.pkg.dev/${var.gcp_project}/${var.artifact_repo_generator}/${var.image_name}:latest"
        env {
          name  = "LIST_ENDPOINT"
          value = var.list_url
        }
        env {
          name  = "ADD_ENDPOINT"
          value = var.add_url
        }
        env {
          name  = "BUY_ENDPOINT"
          value = var.buy_url
        }
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "public_access" {
  service = google_cloud_run_service.store.name
  location = google_cloud_run_service.store.location
  role = "roles/run.invoker"
  member = "allUsers"
}