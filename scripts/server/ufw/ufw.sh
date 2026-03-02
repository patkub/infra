# Configure UFW rules for Meerkat

# Allow connections from WARP devices
sudo ufw allow from 100.96.0.0/12 to any comment 'Cloudflare WARP'
sudo ufw allow from 2606:4700:cf1:1000::/64 to any comment 'Cloudflare WARP'
