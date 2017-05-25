#!/bin/bash

./kubos-kernel.sh
mount /dev/mmcblk0p5 boot
rm -rvf boot/*
cp kubos-kernel.itb boot/kernel
sync
umount boot

mount /dev/mmcblk0p6 rootfs
rm -rvf rootfs/*
tar --overwrite -xvf ../../buildroot-2016.11/output/images/rootfs.tar -C rootfs
sync
sleep 1
umount rootfs
