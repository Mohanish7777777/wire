# Use an official lightweight base image
FROM debian:latest

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    git \
    nginx \
    sudo

# Clone dPanel
WORKDIR /opt
RUN git clone https://github.com/paimpozhil/dPanel.git
WORKDIR /opt/dPanel/stdcontainers
RUN chmod a+x *.sh

# Expose necessary ports
EXPOSE 80 443

# Start Nginx proxy and dPanel
CMD ["bash", "-c", "service nginx start && tail -f /dev/null"]
