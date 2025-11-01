#!/bin/bash

# Make scripts executable
chmod +x ./$(dirname "$0")/**/*.sh

# Setup sshd for Meerkat
./$(dirname "$0")/sshd/sshd.sh
