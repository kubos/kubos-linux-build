#!/bin/bash

board="at91sam9g20isis"
buildroot_tar="buildroot-2016.11.tar.gz"
buildroot_url="https://buildroot.uclibc.org/downloads/$buildroot_tar"

cd .. #cd out of the kubos-linux-build directory

kubos update

echo "getting buildroot"

wget $buildroot_url && tar xvzf $buildroot_tar && rm $buildroot_tar

cd ./buildroot*

make BR2_EXTERNAL=../kubos-linux-build ${board}_defconfig

echo "STARTING BUILD"

make

