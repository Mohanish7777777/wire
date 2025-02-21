# Dockerfile for WireGuard VPN

# Use a lightweight base image
FROM debian:latest

# Install dependencies
RUN apt update && apt install -y wireguard iptables && rm -rf /var/lib/apt/lists/*

# Enable IP forwarding
RUN echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf && \
    echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf

# Create WireGuard directory
RUN mkdir -p /etc/wireguard

# Generate WireGuard keys
RUN umask 077 && \
    wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey

# Read generated keys
RUN PRIVATE_KEY=$(cat /etc/wireguard/privatekey) && \
    PUBLIC_KEY=$(cat /etc/wireguard/publickey) && \
    echo "[Interface]
PrivateKey = $PRIVATE_KEY
Address = 10.0.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE" > /etc/wireguard/wg0.conf

# Expose WireGuard port
EXPOSE 51820/udp

# Install netcat for testing
RUN apt install -y netcat

# Start WireGuard and print a message on port 8000
CMD ["/bin/sh", "-c", "wg-quick up wg0 && echo 'WireGuard is running' | nc -l -p 8000"]
