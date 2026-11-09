# Создаём 3 одинаковых диска через count
resource "yandex_compute_disk" "extra" {
  count = 3

  name = "extra-disk-${count.index + 1}"
  zone = var.default_zone
  size = 1 # 1 ГБ, как требует задание
  type = "network-hdd"
}

# Создаём 1 экземпляр ВМ "storage" (без count/for_each)
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  # Обязательный загрузочный диск
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = "network-hdd"
      size     = 5
    }
    auto_delete = true
  }

  # Динамическое подключение дополнительных дисков
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.extra
    content {
      disk_id = secondary_disk.value.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
  }
}
