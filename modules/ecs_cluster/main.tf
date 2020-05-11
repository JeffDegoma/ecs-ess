
module "network" {
  source                    = "../network"
}

//imports ecs_container_instances(host for docker containers)
module "ecs_container_instances" {
  source                    = "../ecs_container_instances"

  vpc_id                    =  "${module.network.vpc}"
  public_subnet_ids         =  "${module.network.public_subnets}"
  alb_to_ecs_ec2            =  "${module.alb.alb_to_ecs_ec2}"
}
 
module "alb" {
  source                    = "../load_balancers/alb"

  public_subnet_ids         =  ["${module.network.public_subnets}"]
  vpc_id                    =  "${module.network.vpc}"
  
}

module "deployment" {
  source = "../../deployment"

  load_balancer_arn         = "${module.alb.load_balancer_arn}"
}

