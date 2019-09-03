
provider google {
  region = "${var.region}"
}

module "gce-ilb" {
  source      = "../../lod-balancer-internal"
  region      = "${var.region}"
  name        = "group-ilb"
  ports       = ["${var.service_port}"]
  health_port = "${var.service_port}"
  source_tags = ["${var.source_tags}"]
  target_tags = ["${var.target_tags}"]

  backends = [
    {
      group = "${var.instance_group}"
    }
  ]
}
