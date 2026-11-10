terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
  required_version = "~>1.17.0"
}

provider "yandex" {
  #token     = var.token
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  service_account_key_file = file("/home/admin1/ter-homeworks/02/src/.authorized_key.json")
}
