module "gce-lb-fr" {
  source       = "../../"
  region       = "${var.region}"
  service_port = "${var.service_port}"
  name         = "${var.network_name}"
  target_tags  = ["${var.target_tags}"]
  network      = "${var.network}"
}
