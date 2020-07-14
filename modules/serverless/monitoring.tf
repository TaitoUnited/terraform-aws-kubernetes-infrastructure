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

/* TODO: implement enable/disable once terraform supports count for modules */
module "notify_slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "2.3.0"

  sns_topic_name = "${var.name}-uptimez"
  slack_webhook_url = var.messaging_webhook
  slack_channel     = var.messaging_critical_channel
  slack_username    = "${var.name} uptime check"

  tags = local.tags
}
