#!/bin/bash
GITHUB_USER="a-givertzman"

# 1. Сброс старых блокировок, очистка и подготовка окружения
systemctl stop hysteria-server.service 2>/dev/null
rm -rf /etc/hysteria
mkdir -p /etc/hysteria

# 2. Установка необходимых системных утилит
apt update && apt install -y curl openssl

# 3. Генерация сертификатов во временную папку (Алгоритм EC Elliptic Curve — быстро и без ошибок)
openssl req -x509 -nodes -days 3650 -newkey ec -pkeyopt ec_paramgen_curve:P-256 \
  -keyout /tmp/server.key -out /tmp/server.crt \
  -subj "/CN=://microsoft.com" -batch

# Перенос готовых файлов в целевую папку
mv /tmp/server.key /etc/hysteria/server.key
mv /tmp/server.crt /etc/hysteria/server.crt

# 4. Установка официального сервера Hysteria 2
HYSTERIA_USER=root bash <(curl -fsSL https://get.hy2.sh/)

# 6. Скачивание конфига с вашего GitHub
curl -o /etc/hysteria/config.yaml https://raw.githubusercontent.com/a-givertzman/rem-conf/refs/heads/master/config.yaml

# 7. Фиксация жестких прав для бесперебойного запуска от имени root
chmod 644 /etc/hysteria/server.crt
chmod 600 /etc/hysteria/server.key
chmod 644 /etc/hysteria/config.yaml

# 8. Настройка автозапуска и старт сервиса
systemctl daemon-reload
systemctl enable hysteria-server.service
systemctl restart hysteria-server.service

echo "=== HYSTERIA 2 SUCCESSFULY INSTALLED ==="
systemctl status hysteria-server.service --no-pager
