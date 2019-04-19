#!/bin/bash

# Some working variables
G="\033[32m"
B="\033[39m"
Y="\033[33m"
OK="${G}OK${B}"
ERROR="${Y}ERROR${B}"

PACKAGE_OUTPUT="./tmp"
ORIG_PACKAGE_NAME="Gtk2-GladeXML-1.007"
PACKAGE_NAME="libgtk2-gladexml-perl_1.007"
PACKAGE_SRC="https://cpan.metacpan.org/authors/id/T/TS/TSCH/${ORIG_PACKAGE_NAME}.tar.gz"

rm -rf ${PACKAGE_OUTPUT}
mkdir -p ${PACKAGE_OUTPUT}

wget -q ${PACKAGE_SRC} -O ${PACKAGE_OUTPUT}/${ORIG_PACKAGE_NAME}.tar.gz

if [ $? -ne 0 ]; then
  echo "An error occured while downloading ${ORIG_PACKAGE_NAME} from ${PACKAGE_SRC}"
  exit 1
fi

tar -xzf ${PACKAGE_OUTPUT}/${ORIG_PACKAGE_NAME}.tar.gz -C ${PACKAGE_OUTPUT}

cp -R debian/ ${PACKAGE_OUTPUT}/${ORIG_PACKAGE_NAME}/

cd ${PACKAGE_OUTPUT}/${ORIG_PACKAGE_NAME}/

mv ../${ORIG_PACKAGE_NAME}.tar.gz ../${PACKAGE_NAME}.orig.tar.gz

echo -n "Building package ${PACKAGE_NAME} release, be patient ..."

debuild -us -uc

if [ $? -eq 0 ] ; then
  echo -e " $OK !"
  echo "This look like good news, package succesfully build in ${PACKAGE_OUTPUT} :)"
else
  echo -e "${ERROR}"
  echo "Bad news, something did not happen as expected, check .build file in ${PACKAGE_OUTPUT} to get more information."
fi
