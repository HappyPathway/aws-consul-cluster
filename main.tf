//--------------------------------------------------------------------
// Variables

//--------------------------------------------------------------------
// Workspace Data
data "terraform_remote_state" "darnold_hashicorp_dev_network" {
  backend = "atlas"

  config {
    address = "app.terraform.io"
    name    = "Darnold-Hashicorp/DevNetwork"
  }
}

//--------------------------------------------------------------------
// Modules
module "consul_cluster" {
  source  = "app.terraform.io/Darnold-Hashicorp/consul-cluster/aws"
  version = "1.0.1"

  key_name          = "${var.consul_cluster_key_name}"
  servers           = "${var.consul_cluster_servers}"
  service_conf      = "${var.consul_cluster_service_conf}"
  service_conf_dest = "${var.consul_cluster_service_conf_dest}"
  ssh_private_key   = "${var.consul_cluster_ssh_private_key}"
  subnets           = "${data.terraform_remote_state.darnold_hashicorp_dev_network.private_subnet}"
  tagName           = "${var.consul_cluster_tagName}"
  vpc_id            = "${data.terraform_remote_state.darnold_hashicorp_dev_network.vpc_id}"
}
