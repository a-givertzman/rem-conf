#!/bin/bash
GITHUB_USER="a-givertzman"

# 1. Полная очистка старых конфигов и создание чистой папки
rm -rf /etc/hysteria
mkdir -p /etc/hysteria

# 2. Установка необходимых системных утилит
apt update && apt install -y curl openssl

# 3. Установка официального сервера Hysteria 2 (от root)
HYSTERIA_USER=root bash <(curl -fsSL https://get.hy2.sh/)

# 4. Гарантированная автоматическая генерация ОБОИХ файлов ключей без вопросов (-batch)
mkdir -p /etc/hysteria
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/hysteria/server.key -out /etc/hysteria/server.crt -subj "/CN=://microsoft.com" -batch

# 5. Исправление прав для Debian 12 (чтобы служба Hysteria могла прочесть ключи)
chown -R hysteria:hysteria /etc/hysteria
chmod 644 /etc/hysteria/server.crt
chmod 600 /etc/hysteria/server.key

# 6. Скачивание конфига с вашего GitHub
curl -o /etc/hysteria/config.yaml https://raw.githubusercontent.com/a-givertzman/rem-conf/refs/heads/master/config.yaml

# 7. Настройка автозапуска и старт сервиса
systemctl daemon-reload
systemctl enable hysteria-server.service
systemctl restart hysteria-server.service

echo "=== HYSTERIA 2 SUCCESSFULY INSTALLED ==="
systemctl status hysteria-server.service --no-pager
