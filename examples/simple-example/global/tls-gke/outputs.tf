output "load-balancer-ip" {
  value = "${module.gce-lb-https.external_ip}"
}
