#!/bin/bash

set -e -o pipefail

klb_dir=$(cd `dirname "$0"/..`; pwd)
. "$klb_dir/tools/deps.sh"

klb_out_dir=output/$klb_board
buildroot_out_dir=$buildroot_dir_abs/output

echo "Tagging KubOS $klb_latest_tag"
sed -i "s/0.0.0/$klb_latest_tag/g" "$klb_dir/common/linux-kubos.config"


$klb_dir/build.sh

if [[ ! -d "$klb_out_dir" ]]; then
    mkdir -p "$klb_out_dir"
fi


echo "Build successful, copying images to $klb_out_dir"

case "$klb_board" in
    pumpkin-mbm2|beaglebone-black)
        cp $buildroot_out_dir/images/kubos-linux.tar.gz  \
           $buildroot_out_dir/images/aux-sd.tar.gz \
           $buildroot_out_dir/images/kpack-base.itb \
           $klb_out_dir
        ;;
    at91sam9g20isis)
        cp $buildroot_out_dir/images/kubos-linux.tar.gz  \
           $buildroot_out_dir/images/at91sam9g20isis.dtb \
           $buildroot_out_dir/images/u-boot.bin \
           $klb_out_dir
        ;;
esac

echo "Done"
