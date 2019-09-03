
terraform {
  required_version = "~> 0.12"
}

# ----------------------------------------------------------------------------------------------------------------------
# Locals
# ----------------------------------------------------------------------------------------------------------------------

locals {
  identifier = "${lower(var.name)}"
}

# ----------------------------------------------------------------------------------------------------------------------
# Load Balance
# ----------------------------------------------------------------------------------------------------------------------

resource "google_compute_forwarding_rule" "default" {
  project               = "${var.project}"
  name                  = "${var.name}"
  target                = "${google_compute_target_pool.default.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "${var.service_port}"
  region                = "${var.region}"
}

resource "google_compute_target_pool" "default" {
  project          = "${var.project}"
  name             = "${var.name}"
  region           = "${var.region}"
  session_affinity = "${var.session_affinity}"

  health_checks = [
    "${google_compute_http_health_check.default.name}",
  ]
}

resource "google_compute_http_health_check" "default" {
  project      = "${var.project}"
  name         = "${var.name}-hc"
  request_path = "/"
  port         = "${var.service_port}"
}

resource "google_compute_firewall" "default-lb-fw" {
  project = var.firewall_project == "" ? var.project : var.firewall_project
  name    = "${var.name}-vm-service"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["${var.service_port}"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = "${var.target_tags}"
}
