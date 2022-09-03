# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "canary_script_bucket" {
  bucket = var.canary_script_bucket_name
}

resource "aws_s3_bucket" "canary_artifacts_bucket" {
  bucket = var.canary_artifacts_bucket_name
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "canary_role_permissions_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${var.canary_artifacts_bucket_name}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
    ]
    resources = [
      "arn:aws:s3:::${var.canary_artifacts_bucket_name}",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${var.canary_script_bucket_name}",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
    ]
    resources = [
      "arn:aws:logs:${var.aws_region}:${var.aws_account_number}:log-group:/aws/lambda/cwsyn-${var.canary_name}-*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "xray:PutTraceSegments",
    ]
    resources = [
      "*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData",
    ]
    resources = [
      "*",
    ]
    condition {
      test     = "StringEquals"
      variable = "cloudwatch:namespace"

      values = [
        "CloudWatchSynthetics",
      ]
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "canary_role_permissions" {
  name   = "${terraform.workspace}-canary-role-permissions"
  policy = data.aws_iam_policy_document.canary_role_permissions_policy_document.json
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "canary_assume_role_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "canary_role" {
  name               = "${terraform.workspace}-canary-role"
  assume_role_policy = data.aws_iam_policy_document.canary_assume_role_policy_document.json
  managed_policy_arns = [
    aws_iam_policy.canary_role_permissions.arn,
  ]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "canary_role_policy_attachment" {
  role       = aws_iam_role.canary_role.name
  policy_arn = aws_iam_policy.canary_role_permissions.arn
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary
resource "aws_synthetics_canary" "static_website_canary" {
  name                 = var.canary_name
  s3_bucket            = var.canary_script_bucket_name
  s3_key               = var.canary_s3_key
  artifact_s3_location = "s3://${var.canary_artifacts_bucket_name}"
  execution_role_arn   = aws_iam_role.canary_role.arn
  handler              = var.canary_handler
  runtime_version      = var.canary_runtime_version
  start_canary         = false

  schedule {
    expression = var.canary_schedule_expression
  }

  delete_lambda = true
}
