#!/bin/sh
# -*- mode: shell-script -*-
VERSION=2020.03.04
SRCARCHIVE=nautilus-dropbox-2020.03.04.tar.bz2
DIRECTORY=nautilus-dropbox-${VERSION}

rm -rf emacs-${VERSION}*

sudo apt install -y libnautilus-extension-dev python3-docutils porg
wget https://linux.dropbox.com/packages/${SRCARCHIVE}
tar xf ${SRCARCHIVE}
cd ${DIRECTORY}
./configure
make -j
sudo porg -lD make install
cd ../
rm -rf DIRECTORY
