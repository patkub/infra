#!/bin/bash

# Setup client-side cloudflared SSH host for Meerkat
if ! grep -q -x 'Host meerkat' "$HOME/.ssh/config"; then
  echo "Adding SSH config for Meerkat to $HOME/.ssh/config"
  cat << EOF >> "$HOME/.ssh/config"
# Meerkat
Host meerkat
  HostName meerkat.patkub.vip

Match host meerkat.patkub.vip exec "/usr/bin/cloudflared access ssh-gen --hostname meerkat.patkub.vip"
  ProxyCommand /usr/bin/cloudflared access ssh --hostname meerkat.patkub.vip
  IdentityFile ~/.cloudflared/meerkat.patkub.vip-cf_key
  CertificateFile ~/.cloudflared/meerkat.patkub.vip-cf_key-cert.pub
# End Meerkat
EOF
else
  echo "$HOME/.ssh/config already contains config for Meerkat"
fi
