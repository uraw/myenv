#!/bin/sh
# -*- mode: shell-script -*-

VERSION=${1:-4.4}
SRCARCHIVE=ffmpeg-${VERSION}.tar.xz
DIRECTORY=ffmpeg-${VERSION}

rm -rf ffmpeg-${VERSION}*

sudo apt install -y make nasm yasm libx264-dev libx265-dev
wget https://ffmpeg.org/releases/${SRCARCHIVE}
tar xf ${SRCARCHIVE}
cd ${DIRECTORY}
./configure --enable-gpl --enable-libx264 --enable-nonfree
make -j
sudo porg -lD make install
cd ..
rm -rf ${DIRECTORY}
