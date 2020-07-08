resource "aws_route53_zone" "default_domain" {
  name            = var.default_domain
}
