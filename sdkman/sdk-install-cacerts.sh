#!/bin/bash

### Auto import Cloudflare Zero Trust certificate after install

source <(sed 's/__sdk_install/__sdk_builtin_install/g' "${SDKMAN_DIR}/src/sdkman-install.sh")

function __sdk_install() {
  __sdk_builtin_install "$@"

  # only run for java installs
  if [ "$1" != "java" ]; then
    return 1
  fi

  local exit_code=$?

  if ((exit_code==0)); then
    local java_home
    java_home="$(sdk home "${1}" "${2}")"

    # format cloudflare certificate
    openssl x509 -in /usr/local/share/ca-certificates/managed-warp.pem -inform pem -out "${SDKMAN_DIR}/etc/managed-warp.der" -outform der
    # install cloudflare certificate
    "${java_home}/bin/keytool" -import -trustcacerts -alias 'Cloudflare Root CA' -file "${SDKMAN_DIR}/etc/managed-warp.der" -keystore "$java_home/lib/security/cacerts" -storepass changeit -noprompt 2>&1
  fi

  return "${exit_code}"
}
