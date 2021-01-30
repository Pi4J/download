#!/bin/bash
set -e

#----------------------------------------
# BUILD API REPO INDICES (using Docker)
#----------------------------------------
cp ~/.gnupg/pi4j.key .   # copy local Pi4J PGP privat key to to use during build
docker run --rm --volume $(pwd):/build pi4j/pi4j-builder-repo:latest .build/build.sh
rm pi4j.key              # remove local copy of Pi4J PGP private key
