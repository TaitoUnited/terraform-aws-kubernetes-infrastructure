/**
 * Copyright 2020 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  worker_groups = [
    {
      name                 = "default_worker_group"
      instance_type        = local.nodePools[0].machineType
      subnets              = module.network.private_subnets
      asg_desired_capacity = local.nodePools[0].minNodeCount
      asg_min_size         = local.nodePools[0].minNodeCount
      asg_max_size         = local.nodePools[0].maxNodeCount
    },
  ]

  /* TODO enable worker_groups_launch_template?
  worker_groups_launch_template = [
    {
      instance_type                            = "${local.kubernetes[0].machineType}"
      subnets                                  = module.network.private_subnets
      additional_security_group_ids            = "${aws_security_group.worker_group_mgmt_one.id},${aws_security_group.worker_group_mgmt_two.id}"
      override_instance_type                   = "${local.nodePools[0].machineTypeOverride}"
      asg_desired_capacity                     = local.nodePools[0].minNodeCount
      asg_min_size                             = local.nodePools[0].minNodeCount
      asg_max_size                             = local.nodePools[0].maxNodeCount
      spot_instance_pools                      = 10
      on_demand_percentage_above_base_capacity = "0"
    },
  ]
  */

  workers_group_defaults = {
    root_volume_size = var.nodePools[0].diskSizeGb
    root_volume_type = "gp2"
  }
}

module "kubernetes" {
  # TODO: count                        = local.kubernetes != "" ? 1 : 0

  source                               = "terraform-aws-modules/eks/aws"
  version                              = "6.0.2"
  cluster_name                         = local.kubernetes.name
  subnets                              = module.network.private_subnets
  tags                                 = local.tags
  vpc_id                               = module.network.vpc_id
  worker_groups                        = local.worker_groups
  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  workers_group_defaults               = local.workers_group_defaults

  /* TODO enable worker_groups_launch_template?
  worker_groups_launch_template        = "${local.worker_groups_launch_template}"
  worker_group_launch_template_count   = "1"
  */

  map_roles          = [
    {
      rolearn = aws_iam_role.cicd.arn
      username = "cicd-role"
      groups    = ["system:masters"]
    }
  ]

  map_users          = [
    for arn in concat([ aws_iam_user.cicd.arn ], local.developers):
    {
      userarn = arn
      username = regex("[^/]*$", arn)
      groups    = ["system:masters"]
    }
  ]

  workers_additional_policies = [
    aws_iam_policy.logger.arn
  ]

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  write_kubeconfig      = false
  write_aws_auth_config = false

  kubeconfig_aws_authenticator_env_variables = {
    AWS_PROFILE = var.user_profile
  }
}
