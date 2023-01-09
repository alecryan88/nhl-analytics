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


resource "null_resource" "copy_app_code" {
  for_each = local.loader_names

  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = "cp ../loaders/${each.value}/app.py ../loaders/${each.value}/venv/lib/python${var.python_version}/site-packages"
  }

  depends_on = [
    #app.py in the loader folder needs to exist prior to it being copied into the venv package
    null_resource.local_setup

  ]

}


resource "time_sleep" "wait_15_seconds" {
  create_duration = "15s"
}