#!/bin/bash
GITHUB_USER="a-givertzman"

# 1. Установка утилит и официального бинарника Hysteria
apt update && apt install -y curl openssl
bash <(curl -fsSL https://hy2.io)

# 2. Создание директорий и генерация самоподписанного SSL-сертификата
mkdir -p /etc/hysteria
openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/hysteria/server.key -out /etc/hysteria/server.crt -days 3650 -subj "/CN=://microsoft.com"

# 3. Скачивание конфига с вашего GitHub
curl -o /etc/hysteria/config.yaml https://github.com/a-givertzman/rem-conf/blob/6a4d020ef85a6a798c9a049a0c3eae39b431f8ae/config.yaml

# 4. Настройка автозапуска и старт сервиса
systemctl enable hysteria-server.service
systemctl restart hysteria-server.service

echo "=== HYSTERIA 2 SUCCESSFULY INSTALLED ==="
systemctl status hysteria-server.service --no-pager
