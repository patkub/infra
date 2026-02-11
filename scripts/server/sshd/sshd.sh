# Setup sshd for Meerkat
if ! grep -q -x '# Cloudflared config' "/etc/ssh/sshd_config.d/cloudflared.conf"; then
  sudo cat << EOF >> "/etc/ssh/sshd_config.d/cloudflared.conf"
# Cloudflared config
PasswordAuthentication no
PubkeyAuthentication yes
TrustedUserCAKeys /etc/ssh/ca.pub

# For non warp devices, allow epicpatka@gmail.com to login as patrick
Match Address *,!100.96.0.0/12 User patrick
  AuthorizedPrincipalsCommand /bin/echo 'epicpatka'
  AuthorizedPrincipalsCommandUser nobody
EOF
else
  echo "/etc/ssh/sshd_config.d/cloudflared.conf already contains Cloudflared config"
fi
