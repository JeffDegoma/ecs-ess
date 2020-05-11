
//security groups
resource "aws_security_group" "ecs_ec2" {
  name                      =   "sg_for_container_host"
  vpc_id                    =   "${var.vpc_id}"//in network outputs
}

resource "aws_security_group_rule" "outbound" {
  type                      =   "egress"
  from_port                 =   0
  to_port                   =   0
  protocol                  =  "-1"
  cidr_blocks               =  ["0.0.0.0/0"]
  security_group_id         =   "${aws_security_group.ecs_ec2.id}"
}
resource "aws_security_group_rule" "inbound" {
  type                      =   "ingress"
  from_port                 =   80
  to_port                   =   80
  protocol                  =  "tcp"
  security_group_id         =   "${aws_security_group.ecs_ec2.id}"
  source_security_group_id  =   "${var.alb_to_ecs_ec2}" 
  lifecycle   {
    create_before_destroy   =   true
  }
}



resource "aws_launch_configuration" "launch_config" {
  image_id                  =   "ami-0fd3e3d7875748187"
  instance_type             =   "t2.micro"
  security_groups           =   ["${aws_security_group.ecs_ec2.id}"]
  key_name                  =    "singsing"
  iam_instance_profile      =   "${var.environment}_ecs_instance_profile"
  user_data                 =   "${data.template_file.user_sh.rendered}"
  lifecycle {
    create_before_destroy = true #create replacement resource before destroying the previous resource
  }
} 


//asg
resource "aws_autoscaling_group" "asg" {
  name                      =    "asg"
  max_size                  =    "2"
  min_size                  =    "2"
  vpc_zone_identifier       =    ["${var.public_subnet_ids}"] //place instances inside public subnet
  launch_configuration      =    "${aws_launch_configuration.launch_config.id}"
  tag {
    key                     =    "Name"
    value                   =    "seton-dev"
    propagate_at_launch     =    true
  }
}


data "template_file" "user_sh" {
  template                  =    "${file("${path.module}/start_cluster.tpl")}"// where template is located
  # variables interpolated into template file
  vars {
    cluster_name            =    "${aws_ecs_cluster.seton_cluster.name}"
  }
}

resource "aws_ecs_cluster" "seton_cluster" {
  name                      =   "${var.cluster_name}"
}