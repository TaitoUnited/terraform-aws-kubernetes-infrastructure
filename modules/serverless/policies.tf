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

resource "aws_iam_policy" "logger" {
  name        = "${var.name}-logger"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "kubernetesuser" {
  name        = "${var.name}-kubernetesuser"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:DescribeCluster",
        "eks:ListClusters"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "deployer" {
  name   = "${var.name}-deployer"
  policy = "${data.aws_iam_policy_document.deployer.json}"
}

data "aws_iam_policy_document" "deployer" {
  statement {
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::${var.projects_bucket}",
      "arn:aws:s3:::${var.projects_bucket}/*",
      "arn:aws:s3:::${var.public_bucket}",
      "arn:aws:s3:::${var.public_bucket}/*"
    ]
  }
}

resource "aws_iam_policy" "serverlessdeployer" {
  name   = "${var.name}-serverlessdeployer"
  policy = "${data.aws_iam_policy_document.serverlessdeployer.json}"
}

data "aws_iam_policy_document" "serverlessdeployer" {
  statement {
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
      "route53:ListHostedZones",
      "route53:GetHostedZone",
      "route53:ListTagsForResource",
      "route53:ListResourceRecordSets",
      "route53:ChangeResourceRecordSets",
      "route53:GetChange",
      "route53:CreateHealthCheck",
      "acm:ListCertificates",
      "acm:DescribeCertificate",
      "acm:ListTagsForCertificate",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:PutRolePolicy",
      "apigateway:*",
      "lambda:*",
    ]

    # TODO: Limit modification rights to instances of a zone
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::${var.projects_bucket}",
      "arn:aws:s3:::${var.projects_bucket}/*",
      "arn:aws:s3:::${var.public_bucket}",
      "arn:aws:s3:::${var.public_bucket}/*"
    ]
  }
}

resource "aws_iam_policy" "devopssecretreader" {
  name   = "${var.name}-devopssecretreader"
  policy = "${data.aws_iam_policy_document.devopssecretreader.json}"
}

data "aws_iam_policy_document" "devopssecretreader" {
  statement {
    actions = [
      "ssm:DescribeParameters",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.name}${var.cicd_secrets_path}/*"
    ]
  }
}

resource "aws_iam_policy" "devopssecretwriter" {
  name   = "${var.name}-devopssecretwriter"
  policy = "${data.aws_iam_policy_document.devopssecretwriter.json}"
}

data "aws_iam_policy_document" "devopssecretwriter" {
  statement {
    actions = [
      "ssm:DescribeParameters",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:DeleteParameters"
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.name}${var.cicd_secrets_path}/*"
    ]
  }
}
