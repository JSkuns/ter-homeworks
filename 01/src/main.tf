terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
    random = { # провайдер для генерации пароля
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
  }
  required_version = "~>1.17.0" /*Многострочный комментарий.
 Требуемая версия terraform */
}
provider "docker" {}

#однострочный комментарий

resource "random_password" "random_string" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}


resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "hello_world" {
  image = docker_image.nginx.image_id
  name  = "hello_world"

  ports {
    internal = 80
    external = 9090
  }
}

