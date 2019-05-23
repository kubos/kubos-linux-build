#!/bin/bash
#
# Copyright (C) 2017 Kubos Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Format SD Card for use with Kubos Linux on the iOBC
#
# Inputs:
#  * d {device} - sets the SD card device name (default /dev/sdb)
#  * b {branch} - sets the branch name of the uboot that has been built
#  * p - Copy pre-built kpack-base.itb and kernel files to their appropriate
#        partitions.
#  * pp - Build the kpack-base.itb and kernel files and then copy them
#  * ppp - Only build and copy the files. Skip the other steps
#  * s - Size, in MB, of SD card (default 4000)
#  * w - wipe the SD card (before formatting it)
#

set -e
 
device=/dev/sdb
branch=master
wipe=false
package=0
size=3800

# Process command arguments

while getopts "d:b:ps:w" option
do
    case $option in
	d)
	  device=${OPTARG}
	  ;;
	b)  
	  branch=${OPTARG}
	  ;;
	p)
	  package=$((package+1))
	  ;;
	s)
	  size=${OPTARG}
	  ;;
	w)  
	  wipe=true
	  ;;
	\?)
      	  exit 1
      	  ;;
    esac
done
: ${BASE_DIR:=../../buildroot-2019.02.2/output}

if ${wipe}; then
  echo '\nWiping SD card. This may take a while...'
  dd if=/dev/zero of=${device} bs=1MB count=${size} status=progress
  sleep 1
fi

if [ "${package}" -lt "3" ]; then
  echo '\nCreating partitions'

  # Create the partition table
  parted ${device} mklabel msdos

  boot_size=20
  rootfs_size=20
  upgrade_size=52

  sd_size=`expr $size - 4`
  upgrade_start=`expr $sd_size - $upgrade_size`
  rootfs_start=`expr $upgrade_start - $rootfs_size`
  boot_start=`expr $rootfs_start - $boot_size`

  # Create the partitions
  parted ${device} mkpart primary   ext4    4M                  ${boot_start}M
  parted ${device} mkpart extended          ${boot_start}M      ${sd_size}M
  parted -a minimal ${device} mkpart logical   fat16   ${boot_start}M      ${rootfs_start}M
  parted -a minimal ${device} mkpart logical   ext4    ${rootfs_start}M    ${upgrade_start}M
  parted -a minimal ${device} mkpart logical   ext4    ${upgrade_start}M   ${sd_size}M

  sleep 1

  # Configure the partitions
  mkfs.ext4 ${device}1
  mkfs.fat ${device}5
  mkfs.ext4 ${device}6
  mkfs.ext4 ${device}7

  sleep 1
fi

# Load the base version of Kubos Linux
if [ "${package}" -gt "1" ]; then
  echo '\nBuilding the Kubos Linux base package'
  export PATH=$PATH:/usr/bin/iobc_toolchain/usr/bin
  echo $PATH
  ./kubos-package.sh -b ${branch} -v base
fi

if [ "${package}" -gt "0" ]; then
  mkdir /tmp-kubos

  echo '\nCopying the base package to the upgrade partition'
  mount ${device}7 /tmp-kubos
  cp kpack-base.itb /tmp-kubos
  sleep 1
  umount ${device}7

  echo '\nCopying the kernel to the boot partition'
  mount ${device}5 /tmp-kubos
  cp kubos-kernel.itb /tmp-kubos/kernel
  sleep 1
  umount ${device}5

  echo '\nCopying the rootfs to the rootfs partition'
  mount ${device}6 /tmp-kubos
  tar -xf ${BASE_DIR}/images/rootfs.tar -C /tmp-kubos
  sleep 1
  umount ${device}6

  rmdir /tmp-kubos
fi

echo '\nSD card formatted successfully'

exit 0

