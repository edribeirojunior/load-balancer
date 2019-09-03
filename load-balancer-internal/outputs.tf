output ip_address {
  description = "The internal IP assigned to the regional fowarding rule."
  value       = "${google_compute_forwarding_rule.default.ip_address}"
}
