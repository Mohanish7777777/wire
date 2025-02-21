FROM ubuntu:latest

# Install dependencies and Docker
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    git \
    sudo

# Install Docker
RUN curl -fsSL https://get.docker.com | sh

# Install and run Nginx Proxy
RUN docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock -t jwilder/nginx-proxy

# Clone dPanel and setup
WORKDIR /opt
RUN git clone https://github.com/paimpozhil/dPanel.git
WORKDIR /opt/dPanel/stdcontainers
RUN chmod a+x *.sh

# Expose necessary ports (modify as needed)
EXPOSE 80 443

CMD ["bash"]
