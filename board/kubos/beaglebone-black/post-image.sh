#!/bin/sh

BOARD_DIR="$(dirname $0)"
CURR_DIR="$(pwd)"
BRANCH=$2
OUTPUT=$(basename ${BASE_DIR})

GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

# Create the kernel FIT file
cp ${BOARD_DIR}/kubos-kernel.its ${BINARIES_DIR}/
cd ${BR2_EXTERNAL_KUBOS_LINUX_PATH}/tools
./kubos-kernel.sh -b ${BRANCH} -i ${BINARIES_DIR}/kubos-kernel.its -o ${OUTPUT}
mv kubos-kernel.itb ${BINARIES_DIR}/kernel

# Copy the upgrade schema for later
cp kpack.its ${BINARIES_DIR}/

cd ${CURR_DIR}

# Generate the images
genimage \
    --rootpath "${TARGET_DIR}" \
    --tmppath "${GENIMAGE_TMP}" \
    --inputpath "${BINARIES_DIR}" \
    --outputpath "${BINARIES_DIR}" \
    --config "${GENIMAGE_CFG}"

# Build the upgrade package
cd ${BINARIES_DIR}
${BUILD_DIR}/uboot-${BRANCH}/tools/mkimage -f kpack.its kpack-$(date +%Y.%m.%d).itb

# Package it all up for easy transfer
tar -czf ${BINARIES_DIR}/kubos-linux.tar.gz -C ${BINARIES_DIR} kubos-linux.img kpack-$(date +%Y.%m.%d).itb
