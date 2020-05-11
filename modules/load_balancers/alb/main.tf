

resource "aws_alb" "load_balancer" {
  
  name                      =   "alb"
  subnets                   =    ["${var.public_subnet_ids}"]
  security_groups           =   ["${aws_security_group.alb_http.id}"]
}


resource "aws_alb_target_group" "front_end" {
  vpc_id                    =   "${var.vpc_id}"
  name                      =   "${var.target_group_name}"
  protocol                  =   "HTTP"
  port                      =   "80"

  deregistration_delay      =   180
  
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn         =   "${aws_alb.load_balancer.arn}"
  #ssl_policy
  protocol                  =   "HTTP"
  port                      =   "80"

  default_action  {
    type                    =   "forward"
    target_group_arn        =   "${aws_alb_target_group.front_end.arn}"
  }
}




resource "aws_security_group" "alb_http" {
  name                      =   "${var.environment}_http_sg"
  vpc_id                    =   "${var.vpc_id}"

  ingress{
    from_port               =   80
    to_port                 =   80
    protocol                =   "tcp"
    cidr_blocks             =   ["0.0.0.0/0"]
  }

  egress {
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["0.0.0.0/0"]
  }

}


