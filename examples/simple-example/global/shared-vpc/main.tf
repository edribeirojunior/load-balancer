provider google {
  region  = "${var.region}"
  project = "${var.service_project}"
}

module "gce-lb-http" {
  source            = "../../load-balancer-global"
  name              = "group-http-lb"
  project           = "${var.service_project}"
  target_tags       = ["instance-template-test"]
  firewall_projects = ["${var.host_project}"]
  firewall_networks = ["${var.network}"]

  backends = {
    "0" = [
      {
        group = "${var.instance_group}"
      },
    ]
  }

  backend_params = [
    // health check path, port name, port number, timeout seconds.
    "/,http,80,10",
  ]
}
