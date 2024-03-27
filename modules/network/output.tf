output "vpc_id" {
  description = "The ID of the created VPC."
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "The name of the created VPC."
  value       = google_compute_network.vpc.name
}

output "gke_subnet_id" {
  description = "The ID of the GKE subnet."
  value       = google_compute_subnetwork.subnet-gke.id
}