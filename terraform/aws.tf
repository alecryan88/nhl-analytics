
resource "aws_s3_bucket" "buckets" {
  for_each = {
    for index, loader in local.environment_config : loader.name => loader
  }
  bucket        = each.value.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  for_each = {
    for index, loader in local.environment_config : loader.name => loader
  }
  bucket = each.value.s3_bucket_name

  queue {
    queue_arn = snowflake_pipe.pipes[each.value.name].notification_channel
    #When object is created in S3 bucket => send notification to queue
    events = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    #Requires a bucket to configure the notification
    aws_s3_bucket.buckets,
    #Requires an exisiting pipe to get the SQS notification channel
    snowflake_pipe.pipes
  ]
}


resource "aws_iam_role" "snowflake_acccess_role" {
  name               = "${var.environment}-${local.config.project_name}-snowflake-access-role"
  assume_role_policy = data.aws_iam_policy_document.snowflake_assume_role_policy.json

  inline_policy {
    name   = "${var.environment}-snowflake_s3_access_policy"
    policy = data.aws_iam_policy_document.s3_inline_acces_policy.json
  }
}

resource "aws_iam_policy" "lambda_s3" {
  name        = "${var.environment}-lambda-s3-permissions"
  description = "Policy for lambda function to put objects to the necessary bucket."
  policy      = data.aws_iam_policy_document.lambda_s3.json
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.environment}-role-for-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_execution_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_s3.arn
}

resource "aws_lambda_function" "loader_lambdas" {
  for_each         = data.archive_file.zip
  function_name    = "${var.environment}-${local.config.project_name}-${each.key}"
  role             = aws_iam_role.iam_for_lambda.arn
  package_type     = "Zip"
  runtime          = "python3.9"
  handler          = "app.handler"
  filename         = each.value.output_path
  timeout          = 60
  source_code_hash = each.value.output_sha
  environment {
    variables = {
      "S3_BUCKET_NAME" : "${var.environment}-${local.config.project_name}-${each.key}"
    }
  }

  depends_on = [
    #Requires a zip file with app code/dependencies before function can be created
    data.archive_file.zip
  ]

}

// Create the "cron" schedule
resource "aws_cloudwatch_event_rule" "schedule" {
  for_each = {
    for index, loader in local.environment_config : loader.name => loader
  }
  name                = each.value.name
  schedule_expression = each.value.schedule
}

// Set the action to perform when the event is triggered
resource "aws_cloudwatch_event_target" "invoke_lambda" {
  for_each = {
    for index, loader in local.environment_config : loader.name => loader
  }
  rule = each.value.name
  arn  = aws_lambda_function.loader_lambdas[each.value.original_name].arn
}

