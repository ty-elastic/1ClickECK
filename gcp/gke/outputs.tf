output "cluster_name" {
  value = google_container_cluster.k8s.name
}

output "gcp_project" {
  value = google_container_cluster.k8s.project
}

output "region" {
  value = google_container_cluster.k8s.location
}

output "gke_count" {
  value = length(google_container_cluster.k8s)
}

output "gke_cluster_id" {
  value = google_container_cluster.k8s.id
}

output "gcp_service_account_email" {
  value = google_service_account.kubernetes.email
}

output "clustername_abbreviated" {
  value = lower(replace(google_container_cluster.k8s.name, "-", ""))
}