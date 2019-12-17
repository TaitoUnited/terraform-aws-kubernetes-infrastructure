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

resource "helm_release" "metrics_server" {
  depends_on = [module.kubernetes]

  count      = var.helm_enabled ? 1 : 0

  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-charts.storage.googleapis.com/"
  chart      = "metrics-server"
  version    = "2.8.8"
  wait       = false

  /* https://github.com/kubernetes-incubator/metrics-server/issues/157#issuecomment-544875105 */
  set {
    name  = "hostNetwork.enabled"
    value = "true"
  }

  /* https://github.com/kubernetes-incubator/metrics-server/issues/278#issuecomment-529770452 */
  set {
    name  = "args"
    value = "{--kubelet-preferred-address-types=InternalIP,--kubelet-insecure-tls}"
  }

  set {
    name  = "rbac.pspEnabled"
    value    = "false" # TODO: var.kubernetes_pod_security_policy
  }
}

resource "helm_release" "fluentd_cloudwatch" {
  depends_on = [module.kubernetes, helm_release.metrics_server]

  count      = var.helm_enabled ? 1 : 0

  name       = "fluentd-cloudwatch"
  namespace  = "kube-system"
  repository = "https://kubernetes-charts-incubator.storage.googleapis.com/"
  chart      = "fluentd-cloudwatch"
  version    = "0.11.1"
  wait       = false

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "logGroupName"
    value = var.kubernetes_name
  }
}
