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

# Install PowerShell 7.4.6 (ARM64)
RUN wget -q https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell-7.4.6-linux-arm64.tar.gz -O /tmp/powershell.tar.gz && \
    mkdir -p /opt/microsoft/powershell/7 && \
    tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 && \
    chmod +x /opt/microsoft/powershell/7/pwsh && \
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh && \
    rm /tmp/powershell.tar.gz

# Create directory for the agent
RUN mkdir -p /azp/agent

# Add a user
RUN useradd -m -s /bin/bash myuser
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
