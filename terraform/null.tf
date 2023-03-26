resource "null_resource" "local_setup" {
  for_each = local.loader_names

  triggers = {
    loader_names = each.value
  }

  provisioner "local-exec" {
    command = "python3 scripts/setup/local_setup.py ${each.value}"
    environment = {
      S3_BUCKET_NAME = "${var.environment}-${local.config.project_name}-${each.key}"
    }
  }

}

resource "null_resource" "local_destroy" {
  for_each = local.loader_names

  triggers = {
    loader_names = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "python3 scripts/setup/local_destroy.py"
    environment = {
      S3_BUCKET_NAME = "${var.environment}-${local.config.project_name}-${each.key}"
    }
  }

  depends_on = [
    null_resource.local_setup
  ]
}
