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

resource "random_string" "postgres_admin_password" {
  count    = length(local.postgresClusters)

  length  = 32
  special = false
  upper   = true

  keepers = {
    postgres_instance = local.postgresClusters[count.index].name
    postgres_admin    = local.postgresClusters[count.index].adminUsername
  }
}

module "postgres" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.5.0"

  # Do not create anything if there are no instances (count not supported)
  create_db_instance = length(local.postgresClusters) > 0
  create_db_option_group = length(local.postgresClusters) > 0
  create_db_parameter_group = length(local.postgresClusters) > 0
  create_db_subnet_group = length(local.postgresClusters) > 0

  identifier = length(local.postgresClusters) > 0 ? local.postgresClusters[0].name : "dummy"
  username   = length(local.postgresClusters) > 0 ? local.postgresClusters[0].adminUsername : "dummy"
  password   = length(local.postgresClusters) > 0 ? random_string.postgres_admin_password[0].result : "dummy"
  port       = "5432"

  tags = local.tags

  engine            = "postgres"
  engine_version    = "10.6"
  instance_class    = length(local.postgresClusters) > 0 ? local.postgresClusters[0].tier : ""
  allocated_storage = length(local.postgresClusters) > 0 ? local.postgresClusters[0].size : ""
  storage_type      = "gp2"
  storage_encrypted = false

  # TODO: kms_key_id = "arm:aws:kms:<region>:<account id>:key/<kms key id>"

  maintenance_window = "Tue:02:00-Tue:05:00"
  backup_window      = "05:00-07:00"

  vpc_security_group_ids = [aws_security_group.postgres.id]
  subnet_ids             = module.network.database_subnets

  # DB parameter group
  family = "postgres10"

  # DB option group
  major_engine_version = "10.6"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = length(local.postgresClusters) > 0 ? local.postgresClusters[0].name : "dummy"

  # Database Deletion Protection
  deletion_protection = true

  # Daily backups
  # TODO: configurable daily backups
  backup_retention_period = 7

  # Logging
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # Enhanced Monitoring
  monitoring_interval = "30"
  monitoring_role_arn = aws_iam_role.monitoring.arn
}
