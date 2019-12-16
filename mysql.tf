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

resource "random_string" "mysql_admin_password" {
  count    = length(var.mysql_instances)

  length  = 32
  special = false
  upper   = true

  keepers = {
    mysql_instance = var.mysql_instances[count.index]
    mysql_admin    = var.mysql_admins[count.index]
  }
}

module "mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.5.0"

  # Do not create anything if there are no instances (count not supported)
  create_db_instance = length(var.mysql_instances) > 0
  create_db_option_group = length(var.mysql_instances) > 0
  create_db_parameter_group = length(var.mysql_instances) > 0
  create_db_subnet_group = length(var.mysql_instances) > 0

  identifier = length(var.mysql_instances) > 0 ? var.mysql_instances[0] : "dummy"
  username   = var.mysql_admins[0]
  password   = length(var.mysql_instances) > 0 ? random_string.mysql_admin_password[0].result : "dummy"
  port       = "3306"

  tags = local.tags

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = length(var.mysql_instances) > 0 ? var.mysql_tiers[0] : ""
  allocated_storage = length(var.mysql_instances) > 0 ? var.mysql_sizes[0] : ""
  storage_type      = "gp2"
  storage_encrypted = false

  # TODO: kms_key_id  = "arm:aws:kms:<region>:<account id>:key/<kms key id>"

  maintenance_window = "Tue:02:00-Tue:05:00"
  backup_window      = "05:00-07:00"

  vpc_security_group_ids = [aws_security_group.mysql.id]
  subnet_ids             = module.network.database_subnets

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = length(var.mysql_instances) > 0 ? var.mysql_instances[0] : "dummy"

  # Database Deletion Protection
  deletion_protection = true

  # Daily backups
  # TODO: configurable daily backups
  backup_retention_period = 7

  # Logging
  enabled_cloudwatch_logs_exports = ["audit", "slowquery"]

  # Enhanced Monitoring
  monitoring_interval = "30"
  monitoring_role_arn = aws_iam_role.monitoring.arn

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    },
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"
      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
