#!/bin/bash

set -e -o pipefail

klb_dir=$(cd `dirname "$0"`; pwd)
. "$klb_dir/tools/deps.sh"

# cd out of the kubos-linux-build directory
cd "$klb_dir/.."

echo "Getting Buildroot $buildroot_version"

wget "$buildroot_url" && tar xzf "$buildroot_tar" && rm "$buildroot_tar"

cd "$buildroot_dir_abs"

echo "Configuring Buildroot for $klb_board"
make BR2_EXTERNAL=$klb_dir ${klb_board}_defconfig

echo "Removing old toolchains"
rm /usr/bin/*_toolchain -R

echo "Building KubOS $klb_latest_tag"
make
