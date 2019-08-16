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
# Create SD Card image for use with Kubos Linux on the iOBC
#
# Inputs:
#  * d {device} - sets the SD card device name for optional flashing (does not flash by default)
#  * b {branch} - sets the branch name of the uboot that has been built
#  * i {image}  - sets the name of the generated image file
#  * o {name}   - specifies which output directory should be used
#  * p - Copy pre-built kpack-base.itb and kernel files to their appropriate
#        partitions.
#  * pp - Build the kpack-base.itb and kernel files and then copy them
#  * ppp - Only build and copy the files. Skip the other steps
#  * s - Size, in MB, of SD card (default 3800)
#  * t {target} - target device to build image for
#
 
device=""
image=kubos-linux.img
branch=1.2
package=0
size=3800
output=output
target=none

# Process command arguments

while getopts "d:b:i:ps:wo:t:" option
do
    case $option in
	d)
	  device=${OPTARG}
	  ;;
	b)  
	  branch=${OPTARG}
	  ;;
        i)
          image=${OPTARG}
          ;;
	p)
	  package=$((package+1))
	  ;;
	s)
	  size=${OPTARG}
	  ;;
	o)
	  output=${OPTARG}
	  ;;
	t)
	  target=$OPTARG
	  rflag=true
	    ;;
	\?)
      	  exit 1
      	  ;;
    esac
done
: ${BASE_DIR:=../../buildroot-2019.02.2/${output}}

if [ "${package}" -gt "1" ] && [ ! ${rflag} ]; then
    echo "-t target must be specified in order to build kernel" >&2
    exit 1
fi

if [ "${package}" -lt "3" ]; then

  if [[ $(/usr/bin/id -u) -ne 0 ]]; then
      echo "Please run script as root"
      exit
  fi

  echo '\nCreating ramdisk'
  mkdir -p ramdisk
  mount -t tmpfs -o size=${size}M tmpfs ramdisk/
  cd ramdisk/
  echo '\nCreating image file'
  dd if=/dev/zero of=${image} bs=1M count=${size}
  losetup /dev/loop0 ${image}

  echo '\nCreating partitions'

  # Create the partition table
  parted /dev/loop0 mklabel msdos

  # Create the partitions
  # Partition sizes are now all 4MB aligned
  boot_size=20
  rootfs_size=60
  upgrade_size=240
  envar_size=4

  sd_size=`expr ${size} - 4`
  envar_start=`expr ${sd_size} - ${envar_size}`
  upgrade_start=`expr ${envar_start} - ${upgrade_size}`
  rootfs_start=`expr ${upgrade_start} - ${rootfs_size}`
  boot_start=`expr ${rootfs_start} - ${boot_size}`

  parted -a minimal /dev/loop0 mkpart primary ext4   4M                  ${boot_start}M
  parted -a minimal /dev/loop0 mkpart extended       ${boot_start}M      ${sd_size}M
  parted -a minimal /dev/loop0 mkpart logical fat16  ${boot_start}M      ${rootfs_start}M
  parted -a minimal /dev/loop0 mkpart logical ext4   ${rootfs_start}M    ${upgrade_start}M
  parted -a minimal /dev/loop0 mkpart logical ext4   ${upgrade_start}M   ${envar_start}M
  parted -a minimal /dev/loop0 mkpart logical ext4   ${envar_start}M   ${sd_size}M

  sleep 1

  echo '\nFormatting partitions'

  # Configure the partitions
  mkfs.ext4 /dev/loop0p1
  mkfs.fat /dev/loop0p5
  mkfs.ext4 /dev/loop0p6
  mkfs.ext4 /dev/loop0p7
  mkfs.ext4 /dev/loop0p8

  sleep 1

  cd ..
fi

if [ "${package}" -gt "2" ]; then
  echo '\nMounting existing image'
  if [ -f ${image} ]; then
    losetup /dev/loop0 ${image}
  else
    echo '\nExisting image not found!\nQuitting now.'
    exit 1
  fi  
fi


# Load the base version of Kubos Linux
if [ "${package}" -gt "1" ]; then
  echo '\nBuilding the Kubos Linux base package'
  export PATH=$PATH:/usr/bin/iobc_toolchain/usr/bin
  echo $PATH
  ./kubos-package.sh -k -b ${branch} -v base -o ${output} -t ${target}
fi

if [ "${package}" -gt "0" ]; then
  mkdir -p /tmp-kubos

  echo '\nCopying the base package to the upgrade partition'
  mount /dev/loop0p7 /tmp-kubos
  cp kpack-base.itb /tmp-kubos/
  sleep 1
  umount /dev/loop0p7

  echo '\nCopying the kernel to the boot partition'
  mount /dev/loop0p5 /tmp-kubos
  cp kubos-kernel.itb /tmp-kubos/kernel
  sleep 1
  umount /dev/loop0p5

  echo '\nCopying the rootfs to the rootfs partition'
  mount /dev/loop0p6 /tmp-kubos
  tar -xf ${BASE_DIR}/images/rootfs.tar -C /tmp-kubos
  sleep 1
  umount /dev/loop0p6

  echo '\nCreating the user partition overlay'
  mount /dev/loop0p1 /tmp-kubos
  cp ../common/user-overlay/* /tmp-kubos -R
  sleep 1
  umount /dev/loop0p1

  rmdir /tmp-kubos
fi

echo '\nCleaning up ramdisk'
losetup -d /dev/loop0

if [ "${package}" -lt "3" ]; then
  mv ramdisk/${image} ${image}
  umount ramdisk
  rmdir ramdisk
fi

echo '\nSD card image created!'

if [ -n "${device}" ]; then
  echo "\nFlashing image to ${device}"
  dd if=${image} of=${device} bs=4M status=progress
fi

exit 0

