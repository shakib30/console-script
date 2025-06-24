#!/bin/bash

# Function to install Nexus CLI with 'Y' auto accepted using expect
install_nexus_cli() {
    echo "Installing Nexus CLI using expect..."
    expect <<EOF
spawn bash -c "curl https://cli.nexus.xyz/ | sh"
expect {
    "Do you accept the Terms of Use" {
        send "y\r"
        exp_continue
    }
    eof
}
EOF
}

# Step 1: Check if the nexus-network CLI is already installed.
if ! command -v nexus-network &> /dev/null
then
    echo "Nexus Network CLI could not be found. Starting installation..."

    # Call the expect-based installer
    install_nexus_cli

    # Update the PATH for the current session
    echo "Updating PATH for the current session..."
    if [ -f "$HOME/.profile" ]; then
        source "$HOME/.profile"
    fi
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi

    # Verify again if the command is now available
    if ! command -v nexus-network &> /dev/null
    then
        echo "Failed to update PATH. Please restart your terminal and run this script again."
        exit 1
    fi
    echo "Installation complete!"
else
    echo "Nexus Network CLI is already installed."
fi

# Step 2: Get the Node ID from the user
echo "" 
echo "Please enter your Node ID and press Enter:"
read node_id

# Check if the user actually provided an ID
if [ -z "$node_id" ]
then
  echo "Error: You did not enter a Node ID. Please try again."
  exit 1
fi

# Step 3: Start the Nexus node
echo "Starting Nexus Network node with your ID: '$node_id'..."
nexus-network start --node-id "$node_id"

echo "Node has been started."
