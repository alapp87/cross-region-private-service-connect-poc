variable "project_id" {
  type        = string
  description = "GCP project ID"
  default     = "efx-psc-poc-b"
}

variable "psc_endpoint_region" {
  type        = string
  description = "Region used for the PSC endpoint"
  default     = "us-central1"
}

variable "service_attachment_id" {
  type        = string
  description = "Service Attachment ID of the published service."
  default     = "projects/efx-psc-poc-a/regions/us-central1/serviceAttachments/apache-web-server"
}

resource "google_compute_global_address" "global_lb_ip" {
  name         = "global-lb-ip"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

resource "google_compute_network" "global_lb_network" {
  name                    = "global-lb-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "psc_subnetwork" {
  name                     = "psc-subnetwork"
  ip_cidr_range            = "172.16.0.0/24"
  region                   = var.psc_endpoint_region
  network                  = google_compute_network.global_lb_network.id
  private_ip_google_access = true
}

resource "google_compute_region_network_endpoint_group" "psc_neg" {
  name                  = "psc-neg"
  region                = var.psc_endpoint_region
  network_endpoint_type = "PRIVATE_SERVICE_CONNECT"
  psc_target_service    = var.service_attachment_id
  network               = google_compute_network.global_lb_network.id
  subnetwork            = google_compute_subnetwork.psc_subnetwork.id
}

resource "google_compute_backend_service" "global_backend_service" {
  name                  = "global-backend-service"
  load_balancing_scheme = "EXTERNAL"
  protocol              = "TCP"

  backend {
    group = google_compute_region_network_endpoint_group.psc_neg.id
  }
}

resource "google_compute_target_tcp_proxy" "global_tcp_proxy" {
  name            = "global-tcp-proxy"
  backend_service = google_compute_backend_service.global_backend_service.id
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name                  = "global-forwarding-rule"
  ip_address            = google_compute_global_address.global_lb_ip.address
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_tcp_proxy.global_tcp_proxy.id
}
