#!/bin/bash

git clone https://github.com/Xyce/Xyce.git
cd Xyce
git checkout Release-7.6.0
./bootstrap

mkdir -p "$HOME/tools/XyceInstall/Parallel"

SRCDIR="$(pwd)"
ARCHDIR="$HOME/tools/XyceLibs/Parallel"

mkdir build
cd build

$SRCDIR/configure \
CXXFLAGS="-O3" \
ARCHDIR="$ARCHDIR" \
CPPFLAGS="-I/usr/include/suitesparse" \
--enable-mpi \
CXX=mpicxx \
CC=mpicc \
F77=mpif77 \
--enable-stokhos \
--enable-amesos2 \
--prefix=$HOME/tools/XyceInstall/Parallel

make -j4
make install
