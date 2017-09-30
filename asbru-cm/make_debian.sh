#!/bin/bash

# Some working variables
G="\033[32m"
B="\033[39m"
Y="\033[33m"
OK="${G}OK${B}"
ERROR="${Y}ERROR${B}"

# Let's check some basic requirements
if ! [ -x "$(command -v debuild)" ]; then
  echo "debuild is required, did you install the 'devscripts' package yet ?"
  exit 1
fi

# Some other optional requirements
if [ -x "$(command -v jq)" ]; then
  JQ=$(command -v jq)
else
  JQ=""
fi
if [ -x "$(command -v curl)" ]; then
  CURL=$(command -v curl)
else
  CURL=""
fi

if [[ -z "$1" ]]; then
  if [ ! "$JQ" == "" ] && [ ! "$CURL" == "" ] ; then
    # Try to guess the latest release
    echo -n "No release given, querying GitHub ..."
    all_releases=$(${CURL} -s https://api.github.com/repos/asbru-cm/asbru-cm/tags)
    if [ $? -eq 0 ] ; then
      echo -e " $OK !"
      echo -n -e "Extracting latest version ..."
      RELEASE=$(echo $all_releases | ${JQ} -r '.[0] | .name')
      echo -e " found [$RELEASE], $OK !"
    fi
  fi
else
  RELEASE=$1
fi

if [[ -z "$RELEASE" ]] ; then
  echo -e "${ERROR}"
  echo "Please provide a release name matching GitHub. It is case sensitive like 5.0.0-RC1" 1>&2
  echo "You can find Ásbrú releases at https://github.com/asbru-cm/asbru-cm/releases" 1>&2
  echo " " 1>&2
  echo "If you want this tool to guess the latest release automatically, make sure the following tools are available:" 1>&2
  echo " - curl (https://curl.haxx.se/)" 1>&2
  echo " - jq (https://stedolan.github.io/jq)" 1>&2
  echo " " 1>&2
  exit 1
fi

PACKAGE_DIR=./tmp
RELEASE_DEBIAN=${RELEASE,,}
DEBIAN_VERSION=${RELEASE_DEBIAN/-/"~"}

echo -n "Building package release ${DEBIAN_VERSION}, be patient ..."

rm -rf $PACKAGE_DIR
mkdir $PACKAGE_DIR

wget -q https://github.com/asbru-cm/asbru-cm/archive/$RELEASE.tar.gz -O $PACKAGE_DIR/asbru-cm_$RELEASE_DEBIAN.orig.tar.gz

if [ $? -ne 0 ]; then
  echo "An error occured while downloading release $RELEASE"
  echo "Please check if that release actually exists and the server isn't down"
  exit 1
fi

tar -xzf $PACKAGE_DIR/asbru-cm_$RELEASE_DEBIAN.orig.tar.gz -C $PACKAGE_DIR

cp -R debian/ $PACKAGE_DIR/asbru-cm-$RELEASE/debian/

cd $PACKAGE_DIR/asbru-cm-$RELEASE/

mv ../asbru-cm_$RELEASE_DEBIAN.orig.tar.gz ../asbru-cm_$DEBIAN_VERSION.orig.tar.gz

debuild -us -uc > /dev/null

if [ $? -eq 0 ] ; then
  echo -e " $OK !"
  echo "This look like good news, package succesfully build in $PACKAGE_DIR :)"
else
  echo -e "${ERROR}"
  echo "Bad news, something did not happen as expected, check .build file in $PACKAGE_DIR to get more information."
fi

echo "All done."
