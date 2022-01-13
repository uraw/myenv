#!/bin/sh
# -*- mode: shell-script -*-
VERSION=${1:-27.1}
SRCARCHIVE=emacs-${VERSION}.tar.xz
DIRECTORY=emacs-${VERSION}

rm -rf emacs-${VERSION}*

sudo apt install -y autoconf automake libc6-dev libx11-dev libxaw7-dev libjpeg-dev libpng-dev libgif-dev \
     libtiff5-dev libtiff-dev libgnutls28-dev libcairo2-dev libxml2-dev libharfbuzz-dev libgmp3-dev libtinfo-dev wget \
     clang gcc
wget https://ftp.gnu.org/gnu/emacs/${SRCARCHIVE}
tar xf ${SRCARCHIVE}
cd ${DIRECTORY}
./configure --prefix=${HOME}/.local --without-mailutils --with-x-toolkit=lucid --without-pop --with-cairo --with-json
make -j
make install
rm -rf emacs-${VERSION}*
