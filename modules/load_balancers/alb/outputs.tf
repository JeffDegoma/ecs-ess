output "load_balancer_arn" {
  value             = "${aws_alb_target_group.front_end.arn}"
}

output "alb_to_ecs_ec2" {
  value             = "${aws_security_group.alb_http.id}"
  description       = "only allowing traffic from alb to ec2 container instances"
}
