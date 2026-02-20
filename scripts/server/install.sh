#!/bin/bash

# Get absolute path to this script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Make scripts executable
chmod +x "$SCRIPT_DIR"/**/*.sh

# Setup sshd for Meerkat
"$SCRIPT_DIR"/sshd/sshd.sh
