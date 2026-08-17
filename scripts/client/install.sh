#!/usr/bin/env bash

# Get absolute path to this script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Make scripts executable
chmod +x "$SCRIPT_DIR"/ssh/ssh.sh
chmod +x "$SCRIPT_DIR"/npm/npm.sh
chmod +x "$SCRIPT_DIR"/sdkman/patch.sh

# Setup SSH for Meerkat
"$SCRIPT_DIR"/ssh/ssh.sh

# Configure npmrc
"$SCRIPT_DIR"/npm/npm.sh

# Patch SDKMAN! to automatically install Cloudflare Zero Trust certificate when installing a Java JDK.
"$SCRIPT_DIR"/sdkman/patch.sh
