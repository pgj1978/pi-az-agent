# Azure DevOps Agent for Raspberry Pi (ARM64)

This project provides a Dockerized Azure DevOps self-hosted agent specifically configured for ARM64 architecture (e.g., Raspberry Pi). It includes **PowerShell (pwsh)** support.

## Features
- **Base Image:** Ubuntu 22.04 (ARM64)
- **PowerShell:** Pre-installed (v7.4.6)
- **Docker-in-Docker:** Capable of running Docker commands on the host.
- **Auto-restart:** Configured to restart automatically on failure or reboot.

## Prerequisites
- Docker
- Docker Compose

## Setup

1. **Clone the repository:**
   ```bash
   git clone git@github.com:pgj1978/pi-az-agent.git
   cd pi-az-agent
   ```

2. **Configure Environment:**
   Copy the template to a new `.env` file:
   ```bash
   cp .env.template .env
   ```

   Edit `.env` and provide your Azure DevOps details:
   ```ini
   AZP_URL=https://dev.azure.com/yourorganization
   AZP_TOKEN=your_pat_token
   AZP_AGENT_NAME=pi-agent
   AZP_POOL=Default
   ```

## Usage

### Start the Agent
To start the agent in the background:
```bash
docker compose up -d
```

### View Logs
To check the logs:
```bash
docker compose logs -f
```

### Stop the Agent
```bash
docker compose down
```

## Development & Updates

If you need to modify the Docker image (e.g., add more tools):

1. **Edit the `Dockerfile`**.
2. **Build and Push** (assumes a local registry at `localhost:5000`):
   ```bash
   ./build_and_push.sh
   ```
   *Note: This script builds the image and pushes it to a local registry. The `docker-compose.yml` is configured to pull from this local registry.*

3. **Restart the Service:**
   ```bash
   docker compose up -d
   ```

## License
[MIT](LICENSE)
