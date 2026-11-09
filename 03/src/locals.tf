locals {
  # Читаем публичный SSH-ключ, указываем абсолютный путь.
  ssh_public_key = file("/home/admin1/.ssh/id_ed25519.pub")
}
