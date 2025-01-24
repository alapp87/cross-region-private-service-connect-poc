# IP Address
resource "google_compute_address" "consumer_apache_web_server_endpoint" {
  name         = "consumer-apache-web-server-endpoint"
  region       = var.psc_endpoint_region
  subnetwork   = google_compute_subnetwork.consumer_endpoint.id
  address_type = "INTERNAL"
}

# PSC endpoint
# Endpoint needs to be in the same region as the producer service
resource "google_compute_forwarding_rule" "consumer_endpoint" {
  name                    = "consumer-endpoint"
  region                  = var.psc_endpoint_region
  network                 = google_compute_network.consumer_endpoint.id
  ip_address              = google_compute_address.consumer_apache_web_server_endpoint.id
  target                  = var.service_attachment_id
  load_balancing_scheme   = ""   # Explicit empty string required for PSC
  allow_psc_global_access = true # this allows cross region access
}
