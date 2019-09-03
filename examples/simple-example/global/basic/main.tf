provider "google" {
  region = "${var.group1_region}"
}

module "gce-lb-http" {
  source            = "../../load-balancer-global"
  name              = "${var.network_name}"
  target_tags       = ["${var.target_tags}"]
  firewall_networks = ["${var.network}"]

  backends = {
    "0" = [
      {
        group = "${var.region_instance_group}"
      }

    ]
  }

  backend_params = [
    // health check path, port name, port number, timeout seconds.
    "/,http,80,10",
  ]
}
