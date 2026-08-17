#!/usr/bin/env bash

# Patch SDKMAN! to automatically install Cloudflare Zero Trust certificate when installing a Java JDK.

# Get absolute path to this script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# copy sdkman cacerts script to sdkman ext directory
cp "$SCRIPT_DIR/sdk-install-cacerts.sh" "$HOME/.sdkman/ext/"

# append sdkman cacerts script to bashrc
if ! grep -q -x 'source "$HOME/.sdkman/ext/sdk-install-cacerts.sh"' "$HOME/.bashrc"; then
  echo 'source "$HOME/.sdkman/ext/sdk-install-cacerts.sh"' >> "$HOME/.bashrc"
else
  echo "$HOME/.bashrc already sources sdkman certs script"
fi
