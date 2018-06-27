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

if [[ $board == "beaglebone-black" ] -o [ $board == "pumpkin-mbm2" ]];
then
	echo "Creating Aux SD image"
	
	cd ../kubos-linux-build/tools
	./kubos-package.sh -t pumpkin-mbm2 -o output -v kpack-base.itb -k
	sudo ./format-aux.sh -i kpack-base.itb
	tar -czf aux-sd.tar.gz aux-sd.img
	# Delete the .img file to free disk space back up
	rm aux-sd.img
fi
