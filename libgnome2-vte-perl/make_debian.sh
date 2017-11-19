#!/bin/bash

# Some working variables
G="\033[32m"
B="\033[39m"
Y="\033[33m"
OK="${G}OK${B}"
ERROR="${Y}ERROR${B}"

PACKAGE_DIR=./tmp

rm -rf $PACKAGE_DIR
mkdir $PACKAGE_DIR

wget -q http://search.cpan.org/CPAN/authors/id/X/XA/XAOC/Gnome2-Vte-0.11.tar.gz -O $PACKAGE_DIR/Gnome2-Vte-0.11.tar.gz 

if [ $? -ne 0 ]; then
        echo "An error occured while downloading Gnome2-Vte"
        exit 1
fi

tar -xzf tmp/Gnome2-Vte-0.11.tar.gz -C $PACKAGE_DIR

cp -R debian/ $PACKAGE_DIR/Gnome2-Vte-0.11/debian/

cd $PACKAGE_DIR/Gnome2-Vte-0.11/

mv ../Gnome2-Vte-0.11.tar.gz ../libgnome2-vte-perl_0.11.orig.tar.gz

echo -n "Building package release, be patient ..."

debuild -us -uc

if [ $? -eq 0 ] ; then
  echo -e " $OK !"
  echo "This look like good news, package succesfully build in $PACKAGE_DIR :)"
else
  echo -e "${ERROR}"
  echo "Bad news, something did not happen as expected, check .build file in $PACKAGE_DIR to get more information."
fi
