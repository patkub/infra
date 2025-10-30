#!/bin/bash

### Auto import Cloudflare Zero Trust certificate after install

# exit immediately on error
set -e

# load sdkman install script and replace __sdk_install with __sdk_builtin_install
source <(sed 's/__sdk_install/__sdk_builtin_install/g' "${SDKMAN_DIR}/src/sdkman-install.sh")

function __sdk_install() {
  # call original sdkman install function
  __sdk_builtin_install "$@"

  # only run for java installs
  if [ "$1" != "java" ]; then
    return 1
  fi

  # get java home
  local java_home="$(sdk home "${1}" "${2}")"

  # format cloudflare certificate
  openssl x509 -in /usr/local/share/ca-certificates/managed-warp.pem -inform pem -out "${SDKMAN_DIR}/etc/managed-warp.der" -outform der
  # import cloudflare certificate
  "${java_home}/bin/keytool" -import -trustcacerts -alias 'Cloudflare Root CA' -file "${SDKMAN_DIR}/etc/managed-warp.der" -cacerts -storepass changeit -noprompt 2>&1

  # return status of last command
  return $?
}
