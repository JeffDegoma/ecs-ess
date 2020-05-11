variable "vpc_id" {
  description       =   "vpc id"
}

variable "public_subnet_ids" {
  type              =   "list"
  description       =   "ids of each public subnet created" //variable traverses to where the alb module is called
}

variable "target_group_name" {
  default       =   "seton-cluster"
}


variable "environment" {
  default       =   "development"
}


