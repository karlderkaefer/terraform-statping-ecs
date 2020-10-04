#!/bin/bash
# The cluster this agent should check into.
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config

# Disable privileged containers.
echo 'ECS_DISABLE_PRIVILEGED=true' >> /etc/ecs/ecs.config

set -x

#install the Docker volume plugin
docker plugin install rexray/ebs REXRAY_PREEMPT=true EBS_REGION=${instance_region} --grant-all-permissions
#restart the ECS agent
stop ecs
start ecs
