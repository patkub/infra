#!/bin/bash

# Patch SDKMAN! to automatically install Cloudflare Zero Trust certificate when installing a Java JDK.

# copy sdkman cacerts script to sdkman ext directory
cp "$(dirname "$0")/sdk-install-cacerts.sh" "$HOME/.sdkman/ext/"

# append sdkman cacerts script to bashrc
if ! grep -q -x 'source "$HOME/.sdkman/ext/sdk-install-cacerts.sh"' "$HOME/.bashrc"; then
  echo 'source "$HOME/.sdkman/ext/sdk-install-cacerts.sh"' >> "$HOME/.bashrc"
else
  echo "$HOME/.bashrc already sources sdkman certs script"
fi
