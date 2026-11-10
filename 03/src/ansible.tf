# Локальные переменные с данными ВМ для каждой группы
locals {
  # Группа webservers (из count-vm.tf)
  web_instances = [
    for instance in yandex_compute_instance.web : {
      name = instance.name
      ip   = instance.network_interface[0].nat_ip_address
      fqdn = instance.fqdn
    }
  ]

  # Группа databases (из for_each-vm.tf)
  db_instances = [
    for instance in yandex_compute_instance.db : {
      name = instance.name
      ip   = instance.network_interface[0].nat_ip_address
      fqdn = instance.fqdn
    }
  ]

  # Группа storage (из disk_vm.tf)
  storage_instances = [
    {
      name = yandex_compute_instance.storage.name
      ip   = yandex_compute_instance.storage.network_interface[0].nat_ip_address
      fqdn = yandex_compute_instance.storage.fqdn
    }
  ]
}

# Генерация inventory-файла через templatefile
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl", {
    web_instances     = local.web_instances
    db_instances      = local.db_instances
    storage_instances = local.storage_instances
  })
  filename = "${path.module}/inventory.ini"
}
