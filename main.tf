provider "aws" {
    region = "ap-southeast-1"
}


module "ecs" {
    source = "modules/ecs_cluster"
}


