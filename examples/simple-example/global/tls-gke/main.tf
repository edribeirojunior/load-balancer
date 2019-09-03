provider "google" {
  region = "${var.region}"
}

module "gce-lb-https" {
  source            = "../../load-balancer-global"
  name              = "${var.name}"
  ssl               = true
  private_key       = "${tls_private_key.example.private_key_pem}"
  certificate       = "${tls_self_signed_cert.example.cert_pem}"
  firewall_networks = ["${var.network_name}"]

  // Make sure when you create the cluster that you provide the `--tags` argument to add the appropriate `target_tags` referenced in the http module. 
  target_tags = ["${var.target_tags}"]

  // Use custom url map.
  url_map        = "${var.url_map}"
  create_url_map = false

  // Get selfLink URLs for the actual instance groups (not the manager) of the existing GKE cluster:
  //   gcloud compute instance-groups list --uri
  backends = {
    "0" = [
      {
        # Each node pool instance group should be added to the backend.
        group = "${var.backend}"
      },
    ]
  }

  // You also must add the named port on the existing GKE clusters instance group that correspond to the `service_port` and `service_port_name` referenced in the module definition.
  //   gcloud compute instance-groups set-named-ports INSTANCE_GROUP_NAME --named-ports=NAME:PORT
  // replace `INSTANCE_GROUP_NAME` with the name of your GKE cluster's instance group and `NAME` and `PORT` with the values of `service_port_name` and `service_port` respectively.
  backend_params = [
    // health check path, port name, port number, timeout seconds.
    "/,${var.service_port_name},${var.service_port},10",
  ]
}
