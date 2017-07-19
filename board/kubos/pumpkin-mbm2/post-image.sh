#!/bin/sh

BOARD_DIR="$(dirname $0)"
CURR_DIR="$(pwd)"

GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

# Create the kernel FIT file
cd ${BR2_EXTERNAL_KUBOS_LINUX_PATH}/tools
./kubos-kernel.sh -b pumpkin-upgrade -i ../${BOARD_DIR}/kubos-kernel.its -o output-pumpkin

mv kubos-kernel.itb $BINARIES_DIR/kernel
cd ${CURR_DIR}

# Create the user data partition
dd if=/dev/zero of=userpart.img bs=1M count=2000
mkfs.ext4 userpart.img
losetup /dev/loop0 userpart.img
mkdir /tmp-kubos
mount /dev/loop0 /tmp-kubos
cp ${BR2_EXTERNAL_KUBOS_LINUX_PATH}/common/user-overlay/* /tmp-kubos -R
umount /dev/loop0
rmdir /tmp-kubos
losetup -d /dev/loop0

mv userpart.img $BINARIES_DIR/userpart.img

# Generate the images
genimage \
    --rootpath "${TARGET_DIR}" \
    --tmppath "${GENIMAGE_TMP}" \
    --inputpath "${BINARIES_DIR}" \
    --outputpath "${BINARIES_DIR}" \
    --config "${GENIMAGE_CFG}"
