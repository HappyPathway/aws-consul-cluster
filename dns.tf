data "aws_route53_zone" "selected" {
  count = "${var.set_dns ? 1 : 0}"
  name  = "${var.domain}"
}

resource "aws_route53_record" "consul" {
  count   = "${var.set_dns ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${lookup(var.resource_tags, "ClusterName")}.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elb.consul.dns_name}"]
}
