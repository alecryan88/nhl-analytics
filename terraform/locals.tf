locals {
  aws_ecr_url  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
  config       = yamldecode(file("../config.yml"))
  loader_names = toset(local.config.loaders[*].name)
  environment_config = { for idx, item in local.config.loaders : item.name =>
    {
      "name"               = "${var.environment}-${local.config.project_name}-${item.name}"
      "s3_bucket_name"     = "${var.environment}-${local.config.project_name}-${item.name}-${data.aws_caller_identity.current.account_id}"
      "schedule"           = item.schedule
      "output_file_format" = item.output_file_format
      "original_name"      = item.name
    }
  }
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.environment}-${local.config.project_name}"
}