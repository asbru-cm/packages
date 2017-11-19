# Purpose

On certain debian based systems there is no .deb for the Gnome2::Vte perl module. 
This should help to provide a finished .deb which will be compiled from CPAN.

# How to build

    sudo apt-add-repository multiverse
    sudo apt update
    sudo apt install git debhelper devscripts libvte-dev libgtk2-perl libextutils-pkgconfig-perl libextutils-depends-perl
    git clone git@github.com:asbru-cm/packages.git
    cd packages/libgnome2-vte-perl
    ./make_debian.sh
