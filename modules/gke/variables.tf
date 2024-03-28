variable "project_id" {
  description = "The ID of your GCP project"
  type        = string
}

variable "region" {
  description = "The GCP region where the cluster will be deployed."
  type        = string
}

variable "zone" {
  description = "The zone in GCP region where the cluster will be deployed."
  type        = string
}

variable "network_id" {
  description = "The VPC network cluster is deployed to."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the created private vpc connection."
  type        = string
}

variable "min_nodes" {
  description = "Min number of nodes for autoscaler"
  type        = number
}

variable "max_nodes" {
  description = "Max number of nodes for autoscaler"
  type        = number
}