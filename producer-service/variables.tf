variable "project_id" {
  type        = string
  description = "GCP project ID"
  default     = "efx-psc-poc-a"
}

variable "region" {
  type        = string
  description = "Used region for regional resources"
  default     = "southamerica-east1"
}

variable "accepted_consumers" {
  type = list(object({
    connection_limit : number
    project_number : number
  }))
  description = "List of consumers which are eligible to connect to the published PSC service"
  default = [{
    connection_limit = 100
    project_number   = 959908602026
  }]
}