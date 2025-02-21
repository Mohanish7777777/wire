# Dockerfile for WireGuard VPN

# Use a lightweight base image
FROM debian:latest

# Install dependencies
RUN apt update && apt install -y wireguard iptables netcat-openbsd && rm -rf /var/lib/apt/lists/*

# Enable IP forwarding
RUN echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf && \
    echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf

# Create WireGuard directory
RUN mkdir -p /etc/wireguard

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose WireGuard port
EXPOSE 51820/udp
EXPOSE 8000/tcp

# Start WireGuard and print a message on port 8000
CMD ["/entrypoint.sh"]
