variable "environment" {
  default          =   "development"
}


variable "cluster_name" {
  default          =    "seton_cluster"
}


variable "vpc_id" {
  description      =    "vpc id"
}

variable "public_subnet_ids" {
  type             =    "list"
  description      =    "public subnets"
}

variable "alb_to_ecs_ec2" {
  description      =    "http traffic through alb only"
}
