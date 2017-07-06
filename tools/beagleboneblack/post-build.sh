#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
        sed -i '/GENERIC_SERIAL/a\
        tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

if [ ! -d ${TARGET_DIR}/boot ]; then
    mkdir ${TARGET_DIR}/boot
fi

cp ${BINARIES_DIR}/*.dtb ${TARGET_DIR}/boot
cp ${BINARIES_DIR}/zImage ${TARGET_DIR}/bootkkk
