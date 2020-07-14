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

module "ssm-bastion" {
  source            = "JamesWoolfenden/ssm-bastion/aws"
  version           ="0.1.10"
  allowed_ips       = join(" ", local.authorizedNetworkIPs)
  common_tags       = local.tags
  vpc_id            = module.network.vpc_id
  instance_type     = "t2.micro"
  ssm_standard_role = "arn:aws:iam::${var.account_id}:policy/${var.name}-logger"
  subnet_id         = module.network.public_subnets[0]
  environment       = var.name
  name              = "${var.name}-bastion"
}
