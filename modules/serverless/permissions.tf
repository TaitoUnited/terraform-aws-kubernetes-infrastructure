/**
 * Copyright 2019 Taito United
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

/* Logger role */

resource "aws_iam_role_policy_attachment" "logger_logger" {
  role       = aws_iam_role.logger.name
  policy_arn = aws_iam_policy.logger.arn
}

/* Monitoring role */

resource "aws_iam_role_policy_attachment" "monitoring_rds" {
  role       = aws_iam_role.monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

/* Gateway role */

resource "aws_iam_role_policy_attachment" "gateway_assetsreader" {
  role       = aws_iam_role.gateway.name
  policy_arn = aws_iam_policy.assetsreader.arn
}

/* CI/CD role */

resource "aws_iam_role_policy_attachment" "cicd_kubernetesuser" {
  role       = aws_iam_role.cicd.name
  policy_arn = aws_iam_policy.kubernetesuser.arn
}

resource "aws_iam_role_policy_attachment" "cicd_registryuser" {
  role       = aws_iam_role.cicd.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "cicd_deployer" {
  role       = aws_iam_role.cicd.name
  policy_arn = aws_iam_policy.deployer.arn
}

resource "aws_iam_role_policy_attachment" "cicd_devopssecretreader" {
  role       = aws_iam_role.cicd.name
  policy_arn = aws_iam_policy.devopssecretreader.arn
}

/* CI/CD user */

resource "aws_iam_user_policy_attachment" "cicd_kubernetesuser" {
  user       = aws_iam_user.cicd.name
  policy_arn = aws_iam_policy.kubernetesuser.arn
}

resource "aws_iam_user_policy_attachment" "cicd_registryuser" {
  user       = aws_iam_user.cicd.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_user_policy_attachment" "cicd_deployer" {
  user       = aws_iam_user.cicd.name
  policy_arn = aws_iam_policy.deployer.arn
}

resource "aws_iam_user_policy_attachment" "cicd_devopssecretreader" {
  user       = aws_iam_user.cicd.name
  policy_arn = aws_iam_policy.devopssecretreader.arn
}

/* Developers */

resource "aws_iam_user_policy_attachment" "developer_kubernetesuser" {
  count      = length(var.developers)
  user       = regex("[^/]*$", var.developers[count.index])
  policy_arn = aws_iam_policy.kubernetesuser.arn
}

resource "aws_iam_user_policy_attachment" "developer_registryuser" {
  count      = length(var.developers)
  user       = regex("[^/]*$", var.developers[count.index])
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_user_policy_attachment" "developer_deployer" {
  count      = length(var.developers)
  user       = regex("[^/]*$", var.developers[count.index])
  policy_arn = aws_iam_policy.deployer.arn
}

resource "aws_iam_user_policy_attachment" "developer_devopssecretwriter" {
  count      = length(var.developers)
  user       = regex("[^/]*$", var.developers[count.index])
  policy_arn = aws_iam_policy.devopssecretwriter.arn
}
