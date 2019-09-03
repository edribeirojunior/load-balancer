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
  region                = "${var.region}"
  network               = "${data.google_compute_network.network.self_link}"
  subnetwork            = "${data.google_compute_subnetwork.network.self_link}"
  load_balancing_scheme = "INTERNAL"
  backend_service       = "${google_compute_region_backend_service.default.self_link}"
  ip_address            = "${var.ip_address}"
  ip_protocol           = "${var.ip_protocol}"
  ports                 = ["${var.ports}"]
}

resource "google_compute_region_backend_service" "default" {
  project          = "${var.project}"
  name             = "${var.name}"
  region           = "${var.region}"
  protocol         = "${var.ip_protocol}"
  timeout_sec      = 10
  session_affinity = "${var.session_affinity}"
  backend          = ["${var.backends}"]
  health_checks    = ["${element(compact(concat(google_compute_health_check.tcp.*.self_link, google_compute_health_check.http.*.self_link)), 0)}"]
}

resource "google_compute_health_check" "tcp" {
  count   = "${var.http_health_check ? 0 : 1}"
  project = "${var.project}"
  name    = "${var.name}-hc"

  tcp_health_check {
    port = "${var.health_port}"
  }
}

resource "google_compute_health_check" "http" {
  count   = "${var.http_health_check ? 1 : 0}"
  project = "${var.project}"
  name    = "${var.name}-hc"

  http_health_check {
    port = "${var.health_port}"
  }
}

resource "google_compute_firewall" "default-ilb-fw" {
  project = "${var.network_project == "" ? var.project : var.network_project}"
  name    = "${var.name}-ilb-fw"
  network = "${data.google_compute_network.network.name}"

  allow {
    protocol = "${lower(var.ip_protocol)}"
    ports    = ["${var.ports}"]
  }

  source_tags = ["${var.source_tags}"]
  target_tags = ["${var.target_tags}"]
}

resource "google_compute_firewall" "default-hc" {
  project = "${var.network_project == "" ? var.project : var.network_project}"
  name    = "${var.name}-hc"
  network = "${data.google_compute_network.network.name}"

  allow {
    protocol = "tcp"
    ports    = ["${var.health_port}"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["${var.target_tags}"]
}
