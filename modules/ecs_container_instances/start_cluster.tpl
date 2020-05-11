#!/bin/bash


#start cluster
#ECS_CLUSTER is an environment variable inside AWS ECS AMI
echo 'ECS_CLUSTER'=${cluster_name} >> /etc/ecs/ecs.config