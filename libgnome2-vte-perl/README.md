# Purpose

On certain debian based systems there is no .deb for the Gnome2::Vte perl module. 
This should help to provide a finished .deb which will be compiled from CPAN.

# How to build

## For Ubuntu

If starting from a very clean Ubuntu installation, please make sure you have the "multivers" repository enabled:

    sudo apt-add-repository multiverse

## For any Debian based distribution

    sudo apt update
    sudo apt install wget git build-essential debhelper devscripts libvte-dev libgtk2-perl libextutils-pkgconfig-perl libextutils-depends-perl
    git clone https://github.com/asbru-cm/packages.git
    cd packages/libgnome2-vte-perl
    ./make_debian.sh
