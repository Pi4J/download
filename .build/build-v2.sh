#!/bin/bash
set -e

CODENAME=v2
DISTRIBUTION=dists/${CODENAME}

# define the file filters used to determine all releases and snapshots for version 2.x
FILE_FILTER_PREFIX="pi4j-2\.[0-9]\.[0-9]"
RELEASE_FILE_FILTER="${FILE_FILTER_PREFIX}.deb"
TESTING_FILE_FILTER="${FILE_FILTER_PREFIX}-SNAPSHOT.deb"

# clean and create working directories
rm -R {${DISTRIBUTION},tmp} || true
mkdir -p ${DISTRIBUTION}/{stable,testing}/binary-all
mkdir -p tmp

#----------------------------------------
# [V2] DISTRIBUTION [STABLE] COMPONENT
#----------------------------------------

# define constant for [STABLE] component
COMPONENT=stable

echo "------------------------------------"
echo "BUILDING Pi4J APT REPOSITORY FOR:   "
echo "   > ${DISTRIBUTION}/${COMPONENT}"
echo "------------------------------------"
echo "THE FOLLOWING FILES WILL BE INCLUDED:"
ls ${RELEASE_FILE_FILTER} || true
echo "------------------------------------"

# copy all Pi4J V2.x release|stable distribution packages (.deb) to temporary working directory
cp ${RELEASE_FILE_FILTER} tmp || true

# create 'Package' file for the [V2] distribution [STABLE] component
dpkg-scanpackages --multiversion --extra-override .build/pi4j.override tmp > ${DISTRIBUTION}/${COMPONENT}/binary-all/Packages

# remove "tmp/" root path from "Filename" in Packages file
sed -i 's/^Filename: tmp\//Filename: /g' ${DISTRIBUTION}/${COMPONENT}/binary-all/Packages

# create compressed Packages file for the [V2] distribution [STABLE] component
gzip -k -f ${DISTRIBUTION}/${COMPONENT}/binary-all/Packages

# create Release files for the [V2] distribution [STABLE] component
apt-ftparchive release ${DISTRIBUTION}/${COMPONENT}/binary-all > ${DISTRIBUTION}/${COMPONENT}/binary-all/Release

#----------------------------------------
# [V2] DISTRIBUTION [TESTING] COMPONENT
#----------------------------------------

# define constant for [TESTING] component
COMPONENT=testing

# clean temporary working directory
rm -R tmp/* || true

echo "------------------------------------"
echo "BUILDING Pi4J APT REPOSITORY FOR:   "
echo "   > ${DISTRIBUTION}/${COMPONENT}"
echo "------------------------------------"
echo "THE FOLLOWING FILES WILL BE INCLUDED:"
ls ${TESTING_FILE_FILTER} || true
echo "------------------------------------"

# copy all Pi4J testing|snapshot distribution packages (.deb) to temporary working directory
cp ${TESTING_FILE_FILTER} tmp || true

# create 'Package' file for the [V2] distribution [TESTING] component
dpkg-scanpackages --multiversion --extra-override .build/pi4j.override tmp > ${DISTRIBUTION}/${COMPONENT}/binary-all/Packages

# remove "tmp/" root path from "Filename" in Packages file
sed -i 's/^Filename: tmp\//Filename: /g' ${DISTRIBUTION}/${COMPONENT}/binary-all/Packages

# create compressed Packages file for the [V2] distribution [TESTING] component
gzip -k -f ${DISTRIBUTION}/${COMPONENT}/binary-all/Packages

# create Release files for the [V2] distribution [TESTING] component
apt-ftparchive release ${DISTRIBUTION}/${COMPONENT}/binary-all > ${DISTRIBUTION}/${COMPONENT}/binary-all/Release


#----------------------------------------
# CREATE AND SIGN [V2] RELEASE
#----------------------------------------

# create Release files for the [V1] distribution
apt-ftparchive \
  -o APT::FTPArchive::Release::Origin="https://pi4j.com/download" \
  -o APT::FTPArchive::Release::Label="The Pi4J Project" \
  -o APT::FTPArchive::Release::Suite="${CODENAME}" \
  -o APT::FTPArchive::Release::Codename="${CODENAME}" \
  -o APT::FTPArchive::Release::Architectures="all" \
  -o APT::FTPArchive::Release::Components="stable testing" \
  release ${DISTRIBUTION} > ${DISTRIBUTION}/Release

# import PGP private key from file
gpg --import pi4j.key

# sign Release files for the [V1] distribution
gpg --default-key "team@pi4j.com" -abs -o - ${DISTRIBUTION}/Release > ${DISTRIBUTION}/Release.gpg
gpg --default-key "team@pi4j.com" --clearsign -o - ${DISTRIBUTION}/Release > ${DISTRIBUTION}/InRelease

# clean and remove temporary working directory
rm -R tmp
