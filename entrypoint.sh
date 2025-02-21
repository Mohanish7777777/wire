#!/bin/bash

# Generate WireGuard keys
umask 077
wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey

# Read keys
PRIVATE_KEY=$(cat /etc/wireguard/privatekey)

# Create WireGuard config
cat <<EOL > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $PRIVATE_KEY
Address = 10.0.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
EOL

# Start WireGuard
wg-quick up wg0

# Print a message on port 8000
echo "WireGuard is running" | nc -l -p 8000
