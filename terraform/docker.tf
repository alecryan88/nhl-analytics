// Creates ECR repo for each image
resource "aws_ecr_repository" "loader_ecr_repos" {
  for_each = {
    for index, loader in local.environment_config : loader.name => loader
  }
  name                 = each.value.name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

// Creates image locally
resource "docker_image" "local_loader_images" {
  for_each = {
    for index, loader in local.environment_config : loader.name => loader
  }
  name = "${local.aws_ecr_url}/${each.value.name}:latest"
  build {
    context    = "../loaders/${each.value.original_name}"
    dockerfile = "Dockerfile"
  }
  force_remove = true

}

// Pushes local image to ecr repo
resource "docker_registry_image" "loader_images" {
  for_each      = docker_image.local_loader_images
  name          = each.value.name
  keep_remotely = true


  depends_on = [
    aws_ecr_repository.loader_ecr_repos,
    docker_image.local_loader_images
  ]
}


output "test" {
  value = docker_registry_image.loader_images
}