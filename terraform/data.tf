data "aws_iam_policy_document" "s3_inline_acces_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      
    ]
    effect = "Allow"
    resources = values(tomap({
      for key, val in aws_s3_bucket.buckets : key => "${val.arn}/*"
    }))
  }

  statement {
    actions = [
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = values(tomap({
      for key, val in aws_s3_bucket.buckets : key => val.arn
    }))
  }

}


data "aws_iam_policy_document" "snowflake_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [snowflake_storage_integration.storage_integration.storage_aws_iam_user_arn]
    }
    effect = "Allow"

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [snowflake_storage_integration.storage_integration.storage_aws_external_id]
    }
  }
}


data "aws_iam_policy_document" "lambda_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }

}

data "aws_iam_policy_document" "lambda_s3" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "*"
    ]
  }
}

data "archive_file" "zip" {
  for_each    = local.loader_names
  type        = "zip"
  source_dir  = "../loaders/${each.value}/venv/lib/python3.9/site-packages"
  output_path = "../loaders/${each.value}/lambda.zip"

  depends_on = [
    null_resource.copy_app_code
  ]

}

data "aws_caller_identity" "current" {}
