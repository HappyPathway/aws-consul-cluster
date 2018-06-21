//--------------------------------------------------------------------
// Variables

//--------------------------------------------------------------------
data "terraform_remote_state" "network" {
  backend = "atlas"

  config {
    name = "${var.organization}/${var.workspace}"
  }
}

provider "aws" {
  region = "${data.terraform_remote_state.network.region}"
}

//--------------------------------------------------------------------
// Modules
module "consul_cluster" {
  source              = "app.terraform.io/Darnold-Hashicorp/consul-cluster/aws"
  version             = "1.0.7"
  key_name            = "${var.consul_cluster_key_name}"
  servers             = "${var.consul_cluster_servers}"
  ssh_private_key     = "${var.consul_cluster_ssh_private_key}"
  subnet              = "${data.terraform_remote_state.network.public_subnet}"
  tagName             = "${var.consul_cluster_tagName}"
  vpc_id              = "${data.terraform_remote_state.network.vpc_id}"
  consul_config       = "${path.root}/consul_config.json"
  consul_download_url = "https://s3.us-east-2.amazonaws.com/consul-dev-artifacts/consul-connect/1.2.0-beta4/consul_1.2.0-beta4_linux_amd64.zip"
}
