#!/bin/bash

# This script installs a static version of GCC. This is needed because we do
# not have a copy of the MinGW C Runtime installed yet, but we still need a
# way to compile it.

VERSION=14.2.0
ARCHITECTURE=x86
PACKAGE=mingw64-$ARCHITECTURE-gcc-static-$VERSION
GMP_VERSION=6.3.0
MPFR_VERSION=4.2.1
MPC_VERSION=1.3.1

# Create a separate scratch directory and change into it.
mkdir    $PACKAGE
cd       $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../gcc-$VERSION.tar.xz
cd       gcc-$VERSION

# Make sure that we use our new utilities from binutils
export PATH=/opt/mingw64-LegacyUpdate-14.2.0-v1/x86/bin:$PATH

# Building GCC requires GMP, MPFR, and MPC. Let's have the build system build them.
tar -xvf ../../gmp-$GMP_VERSION.tar.xz
tar -xvf ../../mpc-$MPC_VERSION.tar.gz
tar -xvf ../../mpfr-$MPFR_VERSION.tar.xz
mv -v gmp-$GMP_VERSION/ gmp
mv -v mpfr-$MPFR_VERSION/ mpfr/
mv -v mpc-$MPC_VERSION/ mpc/

# Create a directory outside of the source tree.

mkdir build
cd    build

../configure --prefix=/opt/mingw64-LegacyUpdate-14.2.0-v1/x86       \
             --target=i686-w64-mingw32                              \
             --enable-languages=c,c++                               \
             --disable-shared                                       \
             --disable-multilib                                     \
             --disable-threads                                      &&

# --- Descriptions go here ---
# --prefix=/opt/*: This switch will install the files into that directory.
# --target=i686-w64-mingw32: This switch tells the compiler to target the Win32
#                            architecture.
# --enable-languages=c,c++:  We only need the C and C++ languages to be built.
# --disable-shared:          Install a static version of GCC since we don't have
#                            the MinGW C Runtime yet.
# --disable-threads:         Disable threading support as we don't have a
#                            threading library just yet.
# --disable-multilib:        Disable multilib support since it's not necessary
#                            here and causes problems.

# Compile the static version of GCC.
make all-gcc

# Install the static version of GCC
sudo make install-gcc
