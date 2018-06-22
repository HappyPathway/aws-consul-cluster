output "cluster_sg" {
  value = "${module.consul_cluster.security_group}"
}

output "instances" {
  value = "${module.consul_cluster.instances}"
}
