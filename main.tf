//--------------------------------------------------------------------
// Variables

variable "resource_tags" {
  type = "map"

  default = {
    Owner       = "darnold"
    TTL         = 48
    ClusterName = "consul-demos"
  }
}

//--------------------------------------------------------------------
data "terraform_remote_state" "network" {
  backend = "atlas"

  config {
    name = "${var.organization}/${var.network_ws}"
  }
}

provider "aws" {
  region = "${data.terraform_remote_state.network.region}"
}

data "aws_subnet" "selected" {
  id = "${data.terraform_remote_state.network.public_subnet}"
}

//--------------------------------------------------------------------
// Modules
module "consul_cluster" {
  source              = "app.terraform.io/Darnold-Hashicorp/consul-cluster/aws"
  version             = "1.3.2"
  key_name            = "${var.consul_cluster_key_name}"
  servers             = "${var.consul_cluster_servers}"
  ssh_private_key     = "${var.consul_cluster_ssh_private_key}"
  subnet              = "${data.terraform_remote_state.network.public_subnet}"
  tagName             = "${var.consul_cluster_tagName}"
  vpc_id              = "${data.terraform_remote_state.network.vpc_id}"
  consul_config       = "${path.root}/consul_config.json"
  consul_download_url = "${var.consul_download_url}"
  resource_tags       = "${var.resource_tags}"
  availability_zone   = "${data.aws_subnet.selected.availability_zone}"
  env                 = "${var.env}"
}
