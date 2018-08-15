//--------------------------------------------------------------------
// Variables

variable "owner" {
  type = "string"
  description = "Owner of AWS Resources"
}

variable "ttl" {
    type = "string"
    description= "TTL of AWS Resources"
}

variable "cluster_name" {
  description = "Name of Consul Clusrer"
  type = "string"
}



locals {
  resource_tags = {
    Owner       = "${var.owner}"
    TTL         = "${var.ttl}"
    ClusterName = "${var.cluster_name}"
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
  source            = "app.terraform.io/Darnold-NVC/consul-cluster/aws"
  version           = "1.4.2"
  key_name          = "${var.consul_cluster_key_name}"
  servers           = "${var.consul_cluster_servers}"
  subnet            = "${data.terraform_remote_state.network.public_subnet}"
  vpc_id            = "${data.terraform_remote_state.network.vpc_id}"
  resource_tags     = "${local.resource_tags}"
  availability_zone = "${data.aws_subnet.selected.availability_zone}"
  env               = "${var.env}"
}
