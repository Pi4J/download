#!/bin/bash
set -e

#----------------------------------------
# BUILD API REPO INDICES (using Docker)
#----------------------------------------
docker run --rm \
           --volume ~/.gnupg/pi4j.key:/gnupg/pi4j.key \
           --volume $(pwd):/build \
           pi4j/pi4j-builder-repo:latest .build/build.sh
