#!/usr/bin/env bash
# Script to setup a bastion server.

# setup
set -e

# check if bastion user exists
if ! id -u bastion 2>/dev/null; then
  useradd -m bastion
  cd ~bastion
  mkdir .ssh
  chown bastion:bastion .ssh
  chmod 0700 .ssh
  touch .ssh/authorized_keys
  chown bastion:bastion .ssh/authorized_keys
  chmod 0600 .ssh/authorized_keys
fi

cat > ~bastion/.ssh/authorized_keys <<EOF
${authorized_keys}
EOF
