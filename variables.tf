variable "consul_cluster_key_name" {}
variable "consul_cluster_servers" {}
variable "consul_cluster_ssh_private_key" {}
variable "consul_cluster_tagName" {}
variable "organization" {}
variable "workspace" {}

variable "set_dns" {
  default = false
}

variable "host_name" {
  default = "consul"
}

variable "domain" {}
