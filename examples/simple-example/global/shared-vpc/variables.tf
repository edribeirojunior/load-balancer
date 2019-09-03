variable region {
  default = "southamerica-east1"
}

variable host_project {
  description = "ID for the Shared VPC host project"
}

variable service_project {
  description = "ID for the Shared VPC service project where instances will be deployed"
}

variable service_account_email {
  description = "The email of the service account for the MIG instance template."
  default     = "default"
}

variable network {
  description = "ID of network to launch instances on"
}

variable subnetwork {
  description = "ID of subnetwork to launch instances on"
}

variable "instance_group" {

}
