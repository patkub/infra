#!/usr/bin/env bash

# append certfile entry to npmrc
if ! grep -q -x '//registry.npmjs.org/:certfile=/usr/local/share/ca-certificates/managed-warp.pem' "$HOME/.npmrc"; then
  echo '//registry.npmjs.org/:certfile=/usr/local/share/ca-certificates/managed-warp.pem' >> "$HOME/.npmrc"
else
  echo "$HOME/.npmrc already contains certfile entry"
fi
