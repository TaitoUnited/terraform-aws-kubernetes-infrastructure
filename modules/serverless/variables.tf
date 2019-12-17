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
  type = string
  description = "AWS region."
}

/* Users */

variable "developers" {
  type    = list(string)
  default = []
  description = "ARNs of developers (e.g. [ \"arn:aws:iam::1234567890:user/john-doe\" ])."
}

/* Settings */

variable "email" {
  type        = string
  description = "Email address for DevOps support."
}

variable "bastion_authorized_networks" {
  type        = list(string)
  description = "CIDRs that are authorized to access the bastion host."
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

variable "assets_bucket" {
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

variable "helm_nginx_ingress_classes" {
  type        = list(string)
  default     = [ "nginx" ]
  description = "NGINX ingress class for each NGINX ingress installation. Provide multiple if you want to install multiple NGINX ingresses."
}

variable "helm_nginx_ingress_replica_counts" {
  type        = list(string)
  default     = []
  description = "Replica count for each NGINX ingress installation. Provide multiple if you want to install multiple NGINX ingresses."
}

/* Postgres */

variable "postgres_instances" {
  type        = list(string)
  default     = []
  description = "Name for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters. NOTE: Currently supports only one PostgreSQL cluster as Terraform does not support count for modules."
}

variable "postgres_tiers" {
  type    = list(string)
  default = ["db.t3.medium"]
  description = "Tier for each PostgreSQL cluster. Provide multiple if you require multiple clusters."
}

variable "postgres_sizes" {
  type    = list(string)
  default = ["20"]
  description = "Size for each PostgreSQL cluster. Provide multiple if you require multiple clusters."
}

variable "postgres_admins" {
  type    = list(string)
  default = ["dummy"]
  description = "Admin username for each PostgreSQL cluster. Provide multiple if you require multiple clusters."
}

/* MySQL */

variable "mysql_instances" {
  type    = list(string)
  default = []
  description = "Name for each MySQL cluster. Provide multiple if you require multiple clusters. NOTE: Currently supports only one MySQL cluster as Terraform does not support count for modules."
}

variable "mysql_tiers" {
  type    = list(string)
  default = ["db.t3.medium"]
  description = "Tier for each MySQL cluster. Provide multiple if you require multiple clusters."
}

variable "mysql_sizes" {
  type    = list(string)
  default = ["20"]
  description = "Size for each MySQL cluster. Provide multiple if you require multiple clusters."
}

variable "mysql_admins" {
  type    = list(string)
  default = ["dummy"]
  description = "Admin username for each MySQL cluster. Provide multiple if you require multiple clusters."
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
