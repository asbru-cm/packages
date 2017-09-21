#!/bin/bash

if [[ -z "$1" ]]; then
	echo "Please give me a release name matching GitHub. It is case sensitive like 5.0.0-RC1" 1>&2
	echo "You can find releases under https://github.com/asbru-cm/asbru-cm/releases" 1>&2
	exit 1
fi

rm -rf /tmp/asbru-packaging
mkdir /tmp/asbru-packaging

RELEASE=$1
RELEASE_DEBIAN=${1,,}

wget https://github.com/asbru-cm/asbru-cm/archive/$RELEASE.tar.gz -O /tmp/asbru-packaging/asbru-cm_$RELEASE_DEBIAN.orig.tar.gz

tar -xzf /tmp/asbru-packaging/asbru-cm_$RELEASE_DEBIAN.orig.tar.gz -C /tmp/asbru-packaging/

cp -R debian/ /tmp/asbru-packaging/asbru-cm-$RELEASE/debian/

cd /tmp/asbru-packaging/asbru-cm-$RELEASE/

debuild -us -uc
