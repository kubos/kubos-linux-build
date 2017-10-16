#!/bin/bash

buildroot_tar="buildroot-2016.11.tar.gz"
buildroot_url="https://buildroot.uclibc.org/downloads/$buildroot_tar"

board="$KUBOS_BOARD"

echo "Building for Board: $board"

cd .. #cd out of the kubos-linux-build directory

kubos update

apt-get install dosfstools

echo "getting buildroot"

wget $buildroot_url && tar xvzf $buildroot_tar && rm $buildroot_tar

cd ./buildroot*

make BR2_EXTERNAL=../kubos-linux-build ${board}_defconfig

echo "STARTING BUILD"

make

if [[ $board == "beaglebone-black" ]];
then
    echo "Copying beaglebone sdimage to $CIRCLE_ARTIFACTS"
    cp ./output/images/kubos-linux.tar.gz $CIRCLE_ARTIFACTS/
    /bin/bash ../kubos-linux-build/post.sh
else
    echo "The output artifacts are not configured for board \"$board\""
fi
