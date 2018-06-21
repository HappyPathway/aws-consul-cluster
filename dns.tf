data "aws_route53_zone" "selected" {
  count = "${var.set_dns ? 1 : 0}"
  name  = "${var.domain}"
}

resource "aws_route53_record" "consul" {
  count   = "${var.set_dns ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.host_name}.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = ["${module.consul_cluster.public_addresses}"]
}
