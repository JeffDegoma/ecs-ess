variable "cluster_name" {
  default       =       "seton_cluster"
}

variable "load_balancer_arn" {
  description   =       "arn of load_balancer"
}

variable "service_role" {
  description   =       "iam role for ess service"
  default       =       "" //called in modules role
}

