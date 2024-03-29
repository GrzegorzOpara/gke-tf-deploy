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

variable "node_size" {
  description = "The VM type of the node"
  type        = string
}

variable "node_pool_size" {
  description = "The number of VM in a node pool"
  type        = number
}