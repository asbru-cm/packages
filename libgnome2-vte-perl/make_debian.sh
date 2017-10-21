#!/bin/bash

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

debuild -us -uc

echo "If everything went good you will find your packages here under $PACKAGE_DIR"
