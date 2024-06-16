#!/bin/bash
# Move to the same directory as this script
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Import common utils
. ./utils.sh


if [ -e "/nix" ]; then
    echo "(!) Nix is already installed! Skipping installation."
else
    apt_get_update_if_exists
    check_command curl "curl ca-certificates" "curl ca-certificates" "curl ca-certificates"
    check_command gpg2 gnupg2 gnupg gnupg2
    check_command dirmngr dirmngr dirmngr dirmngr
    check_command xz xz-utils xz xz
    check_command git git git git
    check_command xargs findutils findutils findutils

    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux \
        --extra-conf "sandbox = false" \
        --init none \
        --no-confirm


    mkdir -p /etc/sudoers.d
    echo 'Defaults    env_keep += "PATH"' >> /etc/sudoers.d/env_keep
fi