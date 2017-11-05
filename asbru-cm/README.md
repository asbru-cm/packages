# Building packages

## Debian / Ubuntu / Mint (.deb)

1. Make sure you have the necessary dependencies installed
    - debuild
    - jq
    - curl
1. Clone this repository somewhere you like
1. Move into the asbru-cm/ folder
1. Run ./make_debian.sh
1. The packages will all be created under ./tmp/ you can copy them from there and delete the tmp folder afterwards.

## Centos / Fedora / OpenSUSE (.rpm)

1. Make sure you have the necessary dependencies installed
    - rpm-build
    - jq
    - curl
1. Clone this repository somewhere you like
1. Move into the asbru-cm/ folder
1. Run ./make_rpm.sh
1. The packages will all be created under ./RPMS/noarch/ you can copy them from there and delete the tmp folder afterwards.
