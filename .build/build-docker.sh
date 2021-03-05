#!/bin/bash
set -e

#----------------------------------------
# BUILD API REPO INDICES (using Docker)
#----------------------------------------
cp ~/.gnupg/pi4j.key .   # copy local Pi4J PGP privat key to to use during build

# build Pi4J [V1] distribution APT repository metadata
docker run --rm --volume $(pwd):/build pi4j/pi4j-builder-repo:latest .build/build-v1.sh

# build Pi4J [V2] distribution APT repository metadata
docker run --rm --volume $(pwd):/build pi4j/pi4j-builder-repo:latest .build/build-v2.sh

rm pi4j.key              # remove local copy of Pi4J PGP private key
