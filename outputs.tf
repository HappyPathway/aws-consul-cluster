output "cluster_sg" {
  value = "${module.consul_cluster.security_group}"
}

output "cluster" {
  value = "${module.consul_cluster.cluster}"
}
