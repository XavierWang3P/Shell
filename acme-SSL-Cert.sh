export DP_Id=""
export DP_Key=""

export CF_Token=""
export CF_Account_ID=""

acme.sh --renew --dns dns_cf -d 2mb.xyz -d '*.2mb.xyz' --force
acme.sh --renew --dns dns_dp -d xavier.wang -d '*.xavier.wang' --force

acme.sh --install-cert -d xavier.wang --key-file /etc/nginx/ssl/xavier.wang/xavier.wang.key --fullchain-file /etc/nginx/ssl/xavier.wang/xavier.wang.pem
acme.sh --install-cert -d 2mb.xyz --key-file /etc/nginx/ssl/2mb.xyz/2mb.xyz.key --fullchain-file /etc/nginx/ssl/2mb.xyz/2mb.xyz.pem
acme.sh --install-cert -d 2mb.xyz --key-file /etc/cockpit/ws-certs.d/shell.2mb.xyz.key --fullchain-file /etc/cockpit/ws-certs.d/shell.2mb.xyz.cert