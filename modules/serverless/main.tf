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

/* Provider */

provider "aws" {
  region  = var.region
  profile = var.user_profile
}

/* Common data */

locals {
  tags = {
    name        = var.name
    workspace   = terraform.workspace
  }

  authorizedNetworkIPs = [
    for net in var.variables.authorizedNetworks:
    net.ip
  ]

  developers = var.variables.developers

  postgresClusters = try(var.variables.postgresClusters, [])
  mysqlClusters = try(var.variables.mysqlClusters, [])

}

data "aws_availability_zones" "available" {
}

/* Resource group for all resources */
/* TODO: how to use terraform variable inside a JSON block?
resource "aws_resourcegroups_group" "zone" {
  name = "${var.name}"
  tags = local.tags

  resource_query {
    query = <<JSON
{
  "TagFilters": [
    {
      "Key": "project",
      "Values": ["${var.name}"]
    }
  ]
}
JSON
  }

  lifecycle {
    prevent_destroy = true
  }
}
*/
