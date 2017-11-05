#!/bin/bash

#     __       _            __  
#    /_/      | |          /_/    
#    / \   ___| |__  _ __ _   _   
#   / _ \ / __| '_ \| '__| | | |  
#  / ___ \\__ \ |_) | |  | |_| |  https://asbru-cm.net
# /_/   \_\___/_.__/|_|   \__,_|  
#        Connection Manager       
#

# Some working variables
G="\033[32m"
B="\033[39m"
Y="\033[33m"
OK="${G}OK${B}"
ERROR="${Y}ERROR${B}"

# Let's check some basic requirements
if ! [ -x "$(command -v rpmbuild)" ]; then
  echo "rpmbuild is required, did you install the 'rpm' package yet ?"
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
  echo "Either we could not fetch the latest release or no releasename is given." 1>&2
  echo "Please provide a release name matching GitHub. It is case sensitive like 5.0.0-RC1" 1>&2
  echo "You can find Ásbrú releases at https://github.com/asbru-cm/asbru-cm/releases" 1>&2
  echo " " 1>&2
  echo "If you want this tool to guess the latest release automatically, make sure the following tools are available:" 1>&2
  echo " - curl (https://curl.haxx.se/)" 1>&2
  echo " - jq (https://stedolan.github.io/jq)" 1>&2
  echo " " 1>&2
  exit 1
fi

PACKAGE_DIR=./rpm
RELEASE_RPM=${RELEASE,,}
RPM_VERSION=${RELEASE_RPM/-/"~"}
RELEASE_COUNT=1

# Makes sure working directories exist
mkdir -p ${PACKAGE_DIR}/{SOURCES,tmp}

# Look for a "free" release count
while [ -f ${PACKAGE_DIR}/RPMS/noarch/asbru-cm-${RPM_VERSION}-${RELEASE_COUNT}.noarch.rpm ] ; do
  RELEASE_COUNT=$((${RELEASE_COUNT} + 1))
done

echo -n "Building package release ${RPM_VERSION}, be patient... "

if [ ! -f ${PACKAGE_DIR}/SOURCES/${RPM_VERSION}.tar.gz ] ; then
  wget -q https://github.com/asbru-cm/asbru-cm/archive/${RELEASE}.tar.gz -O ${PACKAGE_DIR}/SOURCES/${RPM_VERSION}.tar.gz
fi

if [ $? -ne 0 ]; then
  echo "An error occured while downloading release ${RELEASE}"
  echo "Please check if that release actually exists and the server isn't down"
  exit 1
fi

cd ${PACKAGE_DIR}
rpmbuild -bb --define "_topdir $(pwd)" --define "_version ${RPM_VERSION}" --define "_release ${RELEASE_COUNT}" --define "_github_version ${RELEASE}" --define "_buildshell /bin/bash" ./SPECS/asbru.spec >> ./tmp/buildlog 2>&1

if [ $? -eq 0 ] ; then
  echo -e " $OK !"
  echo "This look like good news, package succesfully build in ${PACKAGE_DIR}/RPMS :)"
else
  echo -e "${ERROR}"
  echo "Bad news, something did not happen as expected, check ${PACKAGE_DIR}/tmp/buildlog to get more information."
fi

echo "All done."
