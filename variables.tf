variable "consul_cluster_key_name" {}
variable "consul_cluster_servers" {}
variable "consul_cluster_ssh_private_key" {}
variable "consul_cluster_tagName" {}
variable "organization" {}
variable "network_ws" {}

variable "host_name" {
  default = "consul"
}

variable "consul_download_url" {}

variable "consul_access" {
  default = "0.0.0.0/0"
}

variable "domain" {
  default = "this-demo.rocks"
}

variable "service_port" {
  default = 80
}

variable "set_dns" {
  default = true
}

variable "service_healthcheck_healthy_threshold" {
  default = 2
}

variable "service_healthcheck_unhealthy_threshold" {
  default = 3
}

variable "service_healthcheck_timeout" {
  default = 3
}

variable "service_healthcheck_interval" {
  default = 300
}

variable "cross_zone_load_balancing" {
  default = true
}

variable "connection_draining_timeout" {
  default = 400
}

variable "connection_draining" {
  default = true
}

variable "idle_timeout" {
  default = 400
}
