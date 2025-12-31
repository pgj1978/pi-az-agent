#!/bin/bash

# Check if the agent configuration file exists
if [ ! -f ./config.sh ]; then
    echo "Agent configuration file not found. Exiting."
    exit 1
fi

# Configure the agent
echo "Configuring Agent..."
./config.sh --unattended \
    --url "$AZP_URL" \
    --auth PAT \
    --token "$AZP_TOKEN" \
    --pool "$AZP_POOL" \
    --agent "$AZP_AGENT_NAME" \
    --work "$AZP_WORK" \
    --acceptTeeEula \
    --replace

# Check for configuration success
if [ $? -ne 0 ]; then
    echo "Error: Agent configuration failed."
    exit 1
fi

# Start the agent
echo "Starting Agent..."
exec ./run.sh
