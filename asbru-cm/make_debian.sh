#!/bin/bash

if [[ -z "$1" ]]; then
	echo "Please give me a release name matching GitHub. It is case sensitive like 5.0.0-RC1" 1>&2
	echo "You can find releases under https://github.com/asbru-cm/asbru-cm/releases" 1>&2
	exit 1
fi



PACKAGE_DIR=./tmp
RELEASE=$1
RELEASE_DEBIAN=${1,,}

rm -rf $PACKAGE_DIR
mkdir $PACKAGE_DIR

wget -q https://github.com/asbru-cm/asbru-cm/archive/$RELEASE.tar.gz -O $PACKAGE_DIR/asbru-cm_$RELEASE_DEBIAN.orig.tar.gz

if [ $? -ne 0 ]; then
	echo "An error occured while downloading release $RELEASE"
	echo "Please check if that release actually exists and the server isn't down"
	exit 1
fi

tar -xzf /tmp/asbru-packaging/asbru-cm_$RELEASE_DEBIAN.orig.tar.gz -C $PACKAGE_DIR

cp -R debian/ $PACKAGE_DIR/asbru-cm-$RELEASE/debian/

cd $PACKAGE_DIR/asbru-cm-$RELEASE/

debuild -us -uc

echo "If everything went good you will find your packages here under $PACKAGE_DIR"
