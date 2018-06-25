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
  source            = "app.terraform.io/Darnold-Hashicorp/consul-cluster/aws"
  version           = "1.3.9"
  key_name          = "${var.consul_cluster_key_name}"
  servers           = "${var.consul_cluster_servers}"
  subnet            = "${data.terraform_remote_state.network.public_subnet}"
  vpc_id            = "${data.terraform_remote_state.network.vpc_id}"
  resource_tags     = "${var.resource_tags}"
  availability_zone = "${data.aws_subnet.selected.availability_zone}"
  env               = "${var.env}"
}
