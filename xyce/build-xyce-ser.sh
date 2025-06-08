#!/bin/bash

git clone https://github.com/Xyce/Xyce.git
cd Xyce
git checkout Release-7.6.0
./bootstrap

mkdir -p "$HOME/tools/XyceInstall/Serial"

SRCDIR="$(pwd)"
ARCHDIR="$HOME/tools/XyceLibs/Serial"

mkdir build
cd build

$SRCDIR/configure \
CXXFLAGS="-O3" \
ARCHDIR="$ARCHDIR" \
CPPFLAGS="-I/usr/include/suitesparse" \
--enable-stokhos \
--enable-amesos2 \
--prefix=$HOME/tools/XyceInstall/Serial

make -j8
make install
