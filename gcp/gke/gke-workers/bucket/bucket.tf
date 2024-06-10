
resource "google_storage_bucket" "snapshots" {
 name          = "${data.terraform_remote_state.k8s.outputs.clustername_abbreviated}-snapshots"
 location      = "${var.bucket_region}"
 storage_class = "STANDARD"

 uniform_bucket_level_access = true
 force_destroy = true

 labels = {
      "org" = lower(var.tags["org"]),
      "division" = lower(var.tags["division"]),
      "project" = lower(var.tags["project"]),
      "team"    = lower(var.tags["team"])
  }
}

resource "google_storage_bucket_iam_member" "snapshots" {
  bucket = "${data.terraform_remote_state.k8s.outputs.clustername_abbreviated}-snapshots"
  role   = "roles/storage.admin"
  member = "serviceAccount:${data.terraform_remote_state.k8s.outputs.gcp_service_account_email}"
  depends_on = [google_storage_bucket.snapshots]
}
