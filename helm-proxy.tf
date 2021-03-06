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

resource "helm_release" "postgres_proxy" {
  depends_on = [module.kubernetes, helm_release.letsencrypt_issuer]

  count      = var.helm_enabled ? length(local.postgresClusters) : 0
  name       = local.postgresClusters[count.index].name
  namespace  = "db-proxy"
  repository = "https://kubernetes-charts.storage.googleapis.com/"
  chart      = "socat-tunneller"
  version    = local.socat_tunneler_version
  wait       = false

  set {
    name  = "tunnel.host"
    value = split(":", module.postgres.this_db_instance_endpoint)[0]
  }

  set {
    name  = "tunnel.port"
    value = split(":", module.postgres.this_db_instance_endpoint)[1]
  }
}

resource "helm_release" "mysql_proxy" {
  depends_on = [module.kubernetes, helm_release.postgres_proxy]

  count      = var.helm_enabled ? length(local.mysqlClusters) : 0
  name       = local.mysqlClusters[count.index].name
  namespace  = "db-proxy"
  repository = "https://kubernetes-charts.storage.googleapis.com/"
  chart      = "socat-tunneller"
  version    = local.socat_tunneler_version
  wait       = false

  set {
    name  = "tunnel.host"
    value = split(":", module.mysql.this_db_instance_endpoint)[0]
  }

  set {
    name  = "tunnel.port"
    value = split(":", module.mysql.this_db_instance_endpoint)[1]
  }
}
