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


resource "null_resource" "local_requirements_install" {
  for_each = local.loader_names

  triggers = {
    requirements_change = "${file("../loaders/${each.value}/requirements.txt")}"
  }

  provisioner "local-exec" {
    command = "python3 scripts/setup/local_install_req.py ${each.value}"
  }

  depends_on = [
    null_resource.local_setup
  ]

}


resource "null_resource" "local_requirements_freeze" {
  for_each = local.loader_names

  triggers = {
    archive_zip = "${data.archive_file.zip[each.value].output_sha}"
  }

  provisioner "local-exec" {
    command = "python3 scripts/setup/local_freeze_req.py nhl-api-game-events"
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
    code_change = "${sha1(file("../loaders/${each.value}/app.py"))}"
  }

  provisioner "local-exec" {
    command = "cp ../loaders/${each.value}/app.py ../loaders/${each.value}/venv/lib/python${var.python_version}/site-packages"
  }

  depends_on = [
    #app.py in the loader folder needs to exist prior to it being copied into the venv package
    null_resource.local_setup

  ]

}