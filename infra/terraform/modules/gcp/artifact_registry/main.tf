resource "google_artifact_registry_repository" "frontend_repo" {
  location      = var.gcp_region
  repository_id = "frontend"
  format        = "DOCKER"
  description   = "Repo Docker para imágenes del frontend"
}