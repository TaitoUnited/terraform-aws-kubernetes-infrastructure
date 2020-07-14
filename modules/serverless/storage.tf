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

resource "aws_s3_bucket" "state" {
  count  = var.state_bucket != "" ? 1 : 0
  bucket = var.state_bucket
  region = var.region

  tags = merge(
    local.tags,
    {
      "purpose" = "state"
    },
  )

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = var.archive_day_limit
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket              = aws_s3_bucket.state[0].id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket" "projects" {
  count  = var.projects_bucket != "" ? 1 : 0
  bucket = var.projects_bucket
  region = var.region

  tags = merge(
    local.tags,
    {
      "purpose" = "projects"
    },
  )

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = var.archive_day_limit
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "projects" {
  bucket              = aws_s3_bucket.projects[0].id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket" "assets" {
  count  = var.assets_bucket != "" ? 1 : 0
  bucket = var.assets_bucket
  region = var.region

  tags = merge(
    local.tags,
    {
      "purpose" = "assets"
    },
  )

  cors_rule {
    allowed_origins = ["*"]
    allowed_methods = ["GET", "HEAD"]
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = var.archive_day_limit
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  policy = "${data.aws_iam_policy_document.publicassets.json}"
}

data "aws_iam_policy_document" "publicassets" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.assets_bucket}",
      "arn:aws:s3:::${var.assets_bucket}/*"
    ]
  }
}
