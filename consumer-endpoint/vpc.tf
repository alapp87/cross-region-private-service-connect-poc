resource "google_compute_network" "consumer_endpoint" {
  name                    = "consumer-endpoint"
  auto_create_subnetworks = false
}

# A subnet needs to be in the same region as the producer service
resource "google_compute_subnetwork" "consumer_endpoint" {
  name                     = "consumer-endpoint-${var.region}"
  ip_cidr_range            = "172.16.0.0/29"
  region                   = var.psc_endpoint_region
  network                  = google_compute_network.consumer_endpoint.name
  private_ip_google_access = true
}

# Other regional subnets can be used to host applications
# The test VM will be deployed in this region to test x-region access
resource "google_compute_subnetwork" "consumer_subnet" {
  name                     = "consumer-subnet-${var.region}"
  ip_cidr_range            = "172.17.0.0/29"
  region                   = var.region
  network                  = google_compute_network.consumer_endpoint.name
  private_ip_google_access = true
}
