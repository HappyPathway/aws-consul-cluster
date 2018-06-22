resource "aws_security_group" "consul" {
  vpc_id = "${data.terraform_remote_state.network.vpc_id}"
  name   = "${lookup(var.resource_tags, "ClusterName")}-elb"

  ingress {
    from_port   = "8500"
    to_port     = "8500"
    protocol    = "tcp"
    cidr_blocks = ["${var.consul_access}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "consul_traffic_from_elb_to_cluster" {
  type                     = "ingress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.consul.id}"
  source_security_group_id = "${module.consul_cluster.security_group}"
}

resource "aws_security_group_rule" "consul_traffic_from_cluster_to_elb" {
  type                     = "ingress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.consul.id}"
  security_group_id        = "${module.consul_cluster.security_group}"
}

resource "aws_elb" "consul" {
  name            = "${lookup(var.resource_tags, "ClusterName")}"
  subnets         = ["${data.terraform_remote_state.network.private_subnet}"]
  security_groups = ["${module.consul_cluster.security_group}", "${aws_security_group.consul.id}"]
  internal        = false
  instances       = ["${module.consul_cluster.instances}"]

  listener {
    instance_port     = "8500"
    instance_protocol = "http"
    lb_port           = "8500"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = "${var.service_healthcheck_healthy_threshold}"
    unhealthy_threshold = "${var.service_healthcheck_unhealthy_threshold}"
    timeout             = "${var.service_healthcheck_timeout}"
    target              = "TCP:8500"
    interval            = "${var.service_healthcheck_interval}"
  }

  cross_zone_load_balancing   = "${var.cross_zone_load_balancing}"
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"

  tags = "${merge(map("Name", "${lookup(var.resource_tags, "ClusterName")}-consul"), var.resource_tags)}"
}

resource "aws_lb_cookie_stickiness_policy" "cookie_stickness" {
  name                     = "${lookup(var.resource_tags, "ClusterName")}-cookiestickness"
  load_balancer            = "${aws_elb.consul.id}"
  lb_port                  = "8500"
  cookie_expiration_period = 600
}
