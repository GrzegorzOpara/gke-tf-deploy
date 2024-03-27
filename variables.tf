variable "project_id" {
  description = "The ID of your GCP project"
  type        = string
}

variable "region" {
  description = "The GCP region where the network and cluster will be deployed."
  type        = string
}

variable "zone" {
  description = "The zone in GCP region where the cluster will be deployed."
  type        = string
}