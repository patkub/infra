#!/bin/bash

# Enable globstar for recursive globbing
shopt -s globstar

# Get absolute path to this script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Make scripts executable
chmod +x "$SCRIPT_DIR"/**/*.sh

# Configure UFW rules for Meerkat
"$SCRIPT_DIR"/ufw/ufw.sh

# Setup sshd for Meerkat
"$SCRIPT_DIR"/sshd/sshd.sh
