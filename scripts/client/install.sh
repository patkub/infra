#!/bin/bash

# Make scripts executable
chmod +x ./$(dirname "$0")/ssh/ssh.sh
chmod +x ./$(dirname "$0")/npm/npm.sh
chmod +x ./$(dirname "$0")/sdkman/patch.sh

# Setup SSH for Meerkat
./$(dirname "$0")/ssh/ssh.sh

# Configure npmrc
./$(dirname "$0")/npm/npm.sh

# Patch SDKMAN! to automatically install Cloudflare Zero Trust certificate when installing a Java JDK.
./$(dirname "$0")/sdkman/patch.sh
