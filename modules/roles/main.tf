//iam roles w/policies for ecs container instance and services
resource "aws_iam_role" "ecs_instance_role" {
    name               =    "${var.environment}_ecs_role"//role name in aws
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}



//iam role policy for ecs container instance
resource "aws_iam_role_policy_attachment" "ecs_cluser_policy" {
    role               =    "${aws_iam_role.ecs_instance_role.name}"
    policy_arn         =    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


//iam instance profile
//attach iam role to iam instance profile
//reference iam instance profile in asg
resource "aws_iam_instance_profile" "ecs_instance_profile" {
    name               =   "${var.environment}_ecs_instance_profile"
    role               =   "${aws_iam_role.ecs_instance_role.name}"
    path               =    "/"
}


resource "aws_iam_role" "ecs_service_role" {
    name              =   "${var.environment}_service_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs_service_policy" {
    name              =     "${var.environment}_service_policy"
       policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:RegisterTargets",
        "ec2:Describe*",
        "ec2:AuthorizeSecurityGroupIngress"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
  
}

resource "aws_iam_policy_attachment" "attach_ecs_service_policy" {
  name              =      "ecs_service_attachment"
  roles             =       ["${aws_iam_role.ecs_service_role.name}"]
  policy_arn        =       "${aws_iam_policy.ecs_service_policy.arn}"
}