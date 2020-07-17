# Kubernetes infrastructure for AWS

Kubernetes infrastructure module designed to get you up and running in no time. Provides all the necessary components for running your projects: Kubernetes, NGINX ingress, cert-manager, container registry, databases, database proxies, networking, monitoring, and permissions. Use it either as a module, or as an example for your own customized infrastructure.

This module is used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/). See the [aws template](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/aws/terraform) as an example on how to use this module.

> TIP: If you plan to run all services using AWS serverless technologies instead of Kubernetes, use the serverless submodule to install the same infrastructure without Kubernetes. In the serverless setup Kubernetes is replaced with a bastion host to provide VPC access.

Example YAML for variables:

```
# TODO: support for authorized network CIDRs on Kubernetes setup
authorizedNetworks:
  - cidr: 127.127.127.127/32

developers:
  - arn: arn:aws:iam::0123456789:user/john-doe
  - arn: arn:aws:iam::0123456789:user/jane-doe

kubernetes:
  name: zone1-common-kube
  context: zone1
  nodePools:
    - name: pool-1
      machineType: n1-standard-1
      diskSizeGb: 100
      minNodeCount: 1
      maxNodeCount: 1
  nginxIngressControllers:
    - class: nginx
      replicas: 3

postgresClusters:
  - name: zone1-common-postgres
    tier: db.t3.medium
    size: 20
    adminUsername: admin
    # TODO: support for database users
    users:
      - username: john.doe
        read:
          - my-project-prod
        write:
          - another-project-prod

mysqlClusters:
  - name: zone1-common-mysql
    tier: db.t3.medium
    size: 20
    adminUsername: admin
    # TODO: support for database users
    users:
      - username: john.doe
        read:
          - my-project-prod
        write:
          - another-project-prod
```

NOTE: Currently this module supports only 1 kubernetes node pool, 1 postgres cluster, and 1 mysql cluster, because Terraform does not yet support count for modules.

Similar YAML format is used also by the following modules:

* [Kubernetes infrastructure for AWS](https://registry.terraform.io/modules/TaitoUnited/kubernetes-infrastructure/aws)
* [Kubernetes infrastructure for Azure](https://registry.terraform.io/modules/TaitoUnited/kubernetes-infrastructure/azurerm)
* [Kubernetes infrastructure for Google Cloud](https://registry.terraform.io/modules/TaitoUnited/kubernetes-infrastructure/google)
* [Kubernetes infrastructure for Digital Ocean](https://registry.terraform.io/modules/TaitoUnited/kubernetes-infrastructure/digitalocean)
