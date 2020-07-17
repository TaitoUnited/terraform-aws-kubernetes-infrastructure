# Servless infrastructure for AWS

Serverless infrastructure designed to get you up and running in no time. Provides all the necessary components for running your projects: bastion host, databases, database proxies, networking, monitoring, and permissions. Use it either as a module, or as an example for your own customized infrastructure.

This module is used by Taito CLI [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates). See the [aws template](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/aws/terraform) as an example on how to use this module.

> NOTE: This is almost identical to the AWS Kubernetes infrastructure (Kubernetes has been replaced with bastion host).

Example YAML for variables:

```
authorizedNetworks:
  - ip: 127.127.127.127

developers:
  - arn: arn:aws:iam::0123456789:user/john-doe
  - arn: arn:aws:iam::0123456789:user/jane-doe

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

NOTE: Currently this module supports only 1 postgres cluster, and 1 mysql cluster, because Terraform does not yet support count for modules.

Similar YAML format is used also by the following modules:

* [Kubernetes infrastructure for AWS](https://registry.terraform.io/modules/TaitoUnited/kubernetes-infrastructure/aws)
* [Kubernetes infrastructure for Azure](https://registry.terraform.io/modules/TaitoUnited/kubernetes-infrastructure/azurerm)
* [Kubernetes infrastructure for Google Cloud](https://registry.terraform.io/modules/TaitoUnited/kubernetes-infrastructure/google)
* [Kubernetes infrastructure for Digital Ocean](https://registry.terraform.io/modules/TaitoUnited/kubernetes-infrastructure/digitalocean)
