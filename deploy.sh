#!/bin/bash
set -e
APP_DIR="/opt/chengpt-web"
USER="www-data"
DOMAIN="$1"
if [ -z "$DOMAIN" ]; then
  echo "Usage: sudo ./deploy.sh your.domain.com"
  exit 1
fi

apt update
apt install -y python3-pip python3-venv nginx certbot python3-certbot-nginx

rm -rf $APP_DIR
mkdir -p $APP_DIR
cp -r ./* "$APP_DIR"
chown -R $USER:$USER "$APP_DIR"

python3 -m venv "$APP_DIR/venv"
"$APP_DIR/venv/bin/pip" install -r "$APP_DIR/requirements.txt"

sed -i "s|CHENGPT_API=.*|CHENGPT_API=http://127.0.0.1:8080/chat|" "$APP_DIR/.env"

cat >/etc/systemd/system/chengpt.service <<EOF
[Unit]
Description=ChenGPT Flask App
After=network.target

[Service]
User=$USER
WorkingDirectory=$APP_DIR
Environment=PATH=$APP_DIR/venv/bin
ExecStart=$APP_DIR/venv/bin/gunicorn --workers 3 --bind 127.0.0.1:8080 server:app

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable chengpt
systemctl restart chengpt

cat >/etc/nginx/sites-available/chengpt <<EOF
server {
  listen 80;
  server_name $DOMAIN;
  location / {
    proxy_pass http://127.0.0.1:8080;
    include proxy_params;
  }
}
EOF

ln -sf /etc/nginx/sites-available/chengpt /etc/nginx/sites-enabled/chengpt
nginx -t
systemctl restart nginx

certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos -m "admin@$DOMAIN"

echo "✅ 部署完成，可访问 https://$DOMAIN"
