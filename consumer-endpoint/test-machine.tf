# VM to test connectivity ot the producer across regions through the PSC
resource "google_compute_instance" "vm_instance" {
  name         = "test-machine"
  machine_type = "e2-micro"
  zone         = "us-east1-c"

  tags = ["http-server", "https-server", "allow-ssh"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250113"
      size  = 10
      type  = "pd-balanced"
    }
    auto_delete = true
  }

  network_interface {
    stack_type = "IPV4_ONLY"
    subnetwork = google_compute_subnetwork.consumer_subnet.id
  }
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.consumer_endpoint.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.source_ip_ranges

  target_tags = ["allow-ssh"] # Matches the tag assigned to the instance
}
