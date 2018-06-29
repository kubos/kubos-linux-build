#!/bin/bash

set -e -o pipefail

buildroot_tar="buildroot-2017.02.8.tar.gz"
buildroot_url="https://buildroot.uclibc.org/downloads/$buildroot_tar"

board="$KUBOS_BOARD"

echo "Building for Board: $board"

cd .. #cd out of the kubos-linux-build directory

kubos update

echo "getting buildroot"

wget $buildroot_url && tar xvzf $buildroot_tar && rm $buildroot_tar

cd ./buildroot*

make BR2_EXTERNAL=../kubos-linux-build ${board}_defconfig

echo "STARTING BUILD"

make