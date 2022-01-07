#!/bin/sh
# -*- mode: shell-script -*-

VERSION=${1:-4.4}
SRCARCHIVE=ffmpeg-${VERSION}.tar.xz
DIRNAME=ffmpeg-${VERSION}

rm -rf ffmpeg-${VERSION}*

sudo apt install -y make nasm yasm libx264-dev libx265-dev
wget https://ffmpeg.org/releases/${SRCARCHIVE}
tar xf ${SRCARCHIVE}
cd ${DIRNAME}
./configure --prefix=${HOME}/.local --enable-gpl --enable-libx264 --enable-nonfree
make -j
porg -l -D make install

rm -rf ffmpeg-${VERSION}*
