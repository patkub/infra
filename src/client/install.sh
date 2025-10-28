#!/bin/bash

# Make scripts executable
chmod +x ./$(dirname "$0")/**/*.sh

# Setup SSH for Meerkat
./$(dirname "$0")/ssh/ssh.sh

# Patch SDKMAN! to automatically install Cloudflare Zero Trust certificate when installing a Java JDK.
./$(dirname "$0")/sdkman/patch.sh
