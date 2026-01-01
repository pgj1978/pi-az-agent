FROM ubuntu:latest

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      jq \
      git \
      iputils-ping \
      libcurl4 \
      libicu-dev \
      libssl-dev \
      libkrb5-dev \
      zlib1g-dev \
      wget \
      ca-certificates \
      build-essential \
      docker.io # Install Docker client

# Install Docker Compose v2 (ARM64)
RUN mkdir -p /usr/local/lib/docker/cli-plugins && \
    curl -SL https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-linux-aarch64 -o /usr/local/lib/docker/cli-plugins/docker-compose && \
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Change 'docker' group GID to 991 to match the host (Raspberry Pi)
# This ensures 'myuser' can access /var/run/docker.sock which is owned by gid 991
RUN groupmod -g 991 docker

# Install PowerShell 7.4.6 (ARM64)
RUN wget -q https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell-7.4.6-linux-arm64.tar.gz -O /tmp/powershell.tar.gz && \
    mkdir -p /opt/microsoft/powershell/7 && \
    tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 && \
    chmod +x /opt/microsoft/powershell/7/pwsh && \
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh && \
    rm /tmp/powershell.tar.gz

# Create directory for the agent
RUN mkdir -p /azp/agent

# Handle user creation with UID 1000 (match host user)
# Ubuntu image might have a user with UID 1000, remove it if it exists to avoid conflict
RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu || true
RUN useradd -m -u 1000 -s /bin/bash myuser
RUN usermod -aG docker myuser

# Download and extract the agent (ARM64 for Raspberry Pi)
RUN curl -sL https://download.agent.dev.azure.com/agent/4.266.2/vsts-agent-linux-arm64-4.266.2.tar.gz | tar -xz -C /azp/agent

# Create the _work directory and set ownership before switching user
RUN mkdir -p /azp/agent/_work && \
    chown -R myuser:myuser /azp/agent

# Copy the entrypoint script and set ownership to myuser
COPY --chown=myuser:myuser entrypoint.sh /azp/agent/

# Switch to the non-root user
USER myuser

WORKDIR /azp/agent
RUN chmod +x entrypoint.sh

# Entrypoint script
ENTRYPOINT ["./entrypoint.sh"]
