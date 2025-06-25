resource "google_datastream_stream" "replication" {
  stream_id    = "rds-to-bigquery"
  display_name = "Replication RDS to BigQuery"
  location     = var.gcp_region
  desired_state = "RUNNING"

  source_config {
    source_connection_profile = var.source_connection_profile_id

    postgresql_source_config {
      replication_slot = var.replication_slot
      publication      = var.publication

      include_objects {
        postgresql_schemas {
            schema = "public"

        postgresql_tables {
            table = "test_datastream"
    }

        postgresql_tables {
            table = "productos"
    }
  }
}

    }
  }

  destination_config {
    destination_connection_profile = var.destination_connection_profile_id

    bigquery_destination_config {
      data_freshness = "900s"

      source_hierarchy_datasets {
        dataset_template {
          location = var.gcp_region
        }
      }
    }
  }
      backfill_all {}

}
