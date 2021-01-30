#!/bin/bash

DISTRIBUTION=dists/v1

# clean and create working directories
rm -R {dists,tmp}
mkdir -p ${DISTRIBUTION}/{stable,testing}/binary-all
mkdir -p tmp

#----------------------------------------
# [V1] DISTRIBUTION [STABLE] COMPONENT
#----------------------------------------

# define constant for [STABLE] component
COMPONENT=stable

# copy all Pi4J V1.x release|stable distribution packages (.deb) to temporary working directory
cp pi4j-[0.1]*\.[0-9].deb tmp

# create 'Package' file for the [V1] distribution [STABLE] component
dpkg-scanpackages --multiversion --extra-override .build/pi4j.override tmp > ${DISTRIBUTION}/${COMPONENT}/binary-all/Packages

# remove "tmp/" root path from "Filename" in Packages file
sed -i 's/^Filename: tmp\//Filename: /g' ${DISTRIBUTION}/${COMPONENT}/binary-all/Packages

# create compressed Packages file for the [V1] distribution [STABLE] component
gzip -k -f ${DISTRIBUTION}/${COMPONENT}/binary-all/Packages

# create Release files for the [V1] distribution [STABLE] component
apt-ftparchive release ${DISTRIBUTION}/${COMPONENT}/binary-all > ${DISTRIBUTION}/${COMPONENT}/binary-all/Release


#----------------------------------------
# [V1] DISTRIBUTION [TESTING] COMPONENT
#----------------------------------------

# define constant for [TESTING] component
COMPONENT=testing

# clean temporary working directory
rm -R tmp/*

# copy all Pi4J testing|snapshot distribution packages (.deb) to temporary working directory
cp pi4j-[0.1]*\.[0-9]-SNAPSHOT.deb tmp

# create 'Package' file for the [V1] distribution [TESTING] component
dpkg-scanpackages --multiversion --extra-override .build/pi4j.override tmp > ${DISTRIBUTION}/${COMPONENT}/binary-all/Packages

# remove "tmp/" root path from "Filename" in Packages file
sed -i 's/^Filename: tmp\//Filename: /g' ${DISTRIBUTION}/${COMPONENT}/binary-all/Packages

# create compressed Packages file for the [V1] distribution [TESTING] component
gzip -k -f ${DISTRIBUTION}/${COMPONENT}/binary-all/Packages

# create Release files for the [V1] distribution [TESTING] component
apt-ftparchive release ${DISTRIBUTION}/${COMPONENT}/binary-all > ${DISTRIBUTION}/${COMPONENT}/binary-all/Release


#----------------------------------------
# CREATE AND SIGN [V1] RELEASE
#----------------------------------------

# create Release files for the [V1] distribution
apt-ftparchive \
  -o APT::FTPArchive::Release::Origin="https://test.pi4j.com/download" \
  -o APT::FTPArchive::Release::Label="The Pi4J Project" \
  -o APT::FTPArchive::Release::Suite="v1" \
  -o APT::FTPArchive::Release::Codename="v1" \
  -o APT::FTPArchive::Release::Architectures="all" \
  -o APT::FTPArchive::Release::Components="stable testing" \
  release dists/v1 > dists/v1/Release


# sign Release files for the [V1] distribution
gpg --default-key "team@pi4j.com" -abs -o - dists/v1/Release > dists/v1/Release.gpg
gpg --default-key "team@pi4j.com" --clearsign -o - dists/v1/Release > dists/v1/InRelease

# clean and remove temporary working directory
rm -R tmp
