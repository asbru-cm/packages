# Purpose

As of Debian Buster, Gtk2::GladeXML perl module has been removed and is not delivered by the Debian project anymore.

The following script and procedure will create a .deb package for Gtk2::GladeXML that can be used for [Ásbrú Connection Manager](https://asbru-cm.net) ; and possibly for other projects having the same dependency.

# How to build

## For Ubuntu

If starting from a very clean Ubuntu installation, please make sure you have the "multivers" repository enabled:

    sudo apt-add-repository multiverse

## For any Debian based distribution

    sudo apt update
    sudo apt install wget git debhelper devscripts libglade2-dev
    git clone https://github.com/asbru-cm/packages.git
    cd packages/libgtk2-gladexml-perl
    ./make_debian.sh
