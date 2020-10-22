#!/bin/bash
# The cluster this agent should check into.
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config

# Disable privileged containers.
echo 'ECS_DISABLE_PRIVILEGED=true' >> /etc/ecs/ecs.config

set -x

#install the Docker volume plugin
if [ "${instance_enabled_ebs_rexray}" == "true" ]; then
  docker plugin install rexray/ebs REXRAY_PREEMPT=true EBS_REGION=${instance_region} --grant-all-permissions
fi
if [ "${instance_enabled_efs_rexray}" == "true" ]; then
  docker plugin install rexray/efs REXRAY_PREEMPT=true EFS_REGION=${instance_region} --grant-all-permissions
  yum install amazon-efs-utils
  systemctl enable --now amazon-ecs-volume-plugin
fi
#restart the ECS agent
#systemctl restart ecs
