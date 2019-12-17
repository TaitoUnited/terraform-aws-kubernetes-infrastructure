# Kubernetes infrastructure for AWS

Kubernetes infrastructure module designed to get you up and running in no time. Provides all the necessary components for running your projects: Kubernetes, NGINX ingress, cert-manager, container registry, databases, database proxies, networking, monitoring, and permissions. Use it either as a module, or as an example for your own customized infrastructure.

This module is used [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/). See the [aws template](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/aws/terraform) as an example on how to use this module.

> TIP: If you plan to run all services using AWS serverless technologies instead of Kubernetes, use the serverless submodule to install the same infrastructure without Kubernetes. In the serverless setup Kubernetes is replaced with a bastion host to provide VPC access.
