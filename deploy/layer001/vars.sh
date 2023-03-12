#!/usr/bin/env bash

# export TERRAFORM_WORKSPACE=jason-local-farm-runner
export TF_STATE_BUCKET="tf-state-uopdateme"
export TF_STATE_OBJECT_KEY="serverless-jenkins.tfstate"
export TF_LOCK_DB="terraform_lock_updateme"
export AWS_REGION=eu-west-1

#PRIVATE_SUBNETS='["","",""]'
#PUBLIC_SUBNETS='["","",""]'

#export TF_VAR_route53_zone_id=""
#export TF_VAR_route53_domain_name="exampledomain.com"
#export TF_VAR_vpc_id=""
#export TF_VAR_efs_subnet_ids=${PRIVATE_SUBNETS}
#export TF_VAR_jenkins_controller_subnet_ids=${PRIVATE_SUBNETS}
#export TF_VAR_alb_subnet_ids=${PUBLIC_SUBNETS}