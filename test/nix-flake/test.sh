#!/bin/bash

set -e

source dev-container-features-test-lib

check "nix" ls /nix
check "keep_env" cat /etc/sudoers.d/env_keep
check "sudoers" env | grep /nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin

reportResults
