variable "name" {
  default = "tf-lb-https-gke"
}

variable "service_port" {
  default = "30000"
}

variable "service_port_name" {
  default = "http"
}

variable "target_tags" {
  default = "tf-lb-https-gke"
}

variable "backend" {}

data "google_client_config" "current" {}

variable "region" {
  default = "southamerica-east1"
}

variable "zone" {
  default = "southamerica-east1-c"
}

variable "network_name" {
  default = "default"
}

variable "url_map" {

}

