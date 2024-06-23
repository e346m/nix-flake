#!/bin/bash

set -e

source dev-container-features-test-lib

check "nix" ls /nix
check "User is codespace?" bash -c  "stat -c %U /nix | grep codespace"

reportResults
