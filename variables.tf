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

/* Labeling */

variable "name" {
  type        = string
  description = "Name that groups all the created resources together. Preferably globally unique to avoid naming conflicts."
}

/* AWS provider */

variable "account_id" {
  type = string
  description = "AWS account id."
}

variable "user_profile" {
  type        = string
  description = "AWS user profile that used to create the resources."
}

variable "region" {
  type        = string
  description = "AWS region."
}

/* Domain */

variable "default_domain" {
  type = string
  description = "Default domain (e.g. mydomain.com)"
}

/* Secrets */

variable "cicd_secrets_path" {
  type    = string
  default = ""
  description = "With this you can limit secret read permissions of CI/CD role to a specific subpath under /${var.name} (e.g. '/devops' becomes /${var.name}/devops)."
}

/* Settings */

variable "email" {
  type        = string
  description = "Email address for DevOps support."
}

variable "archive_day_limit" {
  type = number
  description = "Defines how long storage bucket files should be kept in archive after they have been deleted."
}

/* Buckets */

variable "state_bucket" {
  type        = string
  default = ""
  description = "Name of storage bucket used for storing remote Terraform state."
}

variable "projects_bucket" {
  type        = string
  default     = ""
  description = "Name of storage bucket used for storing function packages, etc."
}

variable "public_bucket" {
  type        = string
  default     = ""
  description = "Name of storage bucket used for storing static assets."
}

/* Helm */

variable "helm_enabled" {
  type        = bool
  default     = "false"
  description = "Installs helm apps if set to true. Should be set to true only after Kubernetes cluster already exists."
}

/* Messaging */

variable "messaging_webhook" {
  type        = string
  description = "Slack webhook for sending monitoring alerts."
}

variable "messaging_critical_channel" {
  type        = string
  description = "Slack channel name for receiving critical alerts."
}

# Additional variables as a json/yaml

variable "variables" {
  type    = any
  description = "Ingress and services as json/yaml. See README.md for format."
}
