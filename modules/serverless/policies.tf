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
  name        = "${var.name}-kubernetes-user"

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
      "arn:aws:s3:::${var.projects_bucket}/*",
      "arn:aws:s3:::${var.assets_bucket}/*"
    ]
  }
}

resource "aws_iam_policy" "assetsreader" {
  name   = "${var.name}-assetsreader"
  policy = "${data.aws_iam_policy_document.assetsreader.json}"
}

data "aws_iam_policy_document" "assetsreader" {
  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.assets_bucket}",
      "arn:aws:s3:::${var.assets_bucket}/*"
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
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.name}/devops/*"
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
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.name}/devops/*"
    ]
  }
}
