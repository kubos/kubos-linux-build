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
 # Format SD Card for use with KubOS Linux on the iOBC
 #
 # Inputs:
 #  * d {device} - sets the SD card device name (default /dev/sdb)
 #  * b {branch} - sets the branch name of the uboot that has been built
 #  * p - Copy pre-built kpack-base.itb and kernel files to their appropriate 
 #        partitions.
 #  * pp - Build the kpack-base.itb and kernel files and then copy them
 #  * ppp - Only build and copy the files. Skip the other steps
 #  * w - wipe the SD card (before formatting it)
 # 

set -e
 
device=/dev/sdb
branch=master
wipe=false
package=0

# Process command arguments

while getopts "d:b:pw" option
do
    case $option in
	d)
	  device=${OPTARG}
	  ;;
	b)  
	  branch=${OPTARG}
	  ;;
	k)
	  package=$((package+1))
	  ;;
	w)  
	  wipe=true
	  ;;
	\?)
      	  exit 1
      	  ;;
    esac
done

if ${wipe}; then
  echo 'Wiping SD card. This may take a while...'
  dd if=/dev/zero of=${device} bs=1MB count=4000 status=progress
  sleep 1
fi

if [ "${package}" -lt "3" ]; then
# Create the partition table
parted ${device} mklabel msdos

# Create the partitions
parted ${device} mkpart primary linux-swap 1M 513M
parted ${device} mkpart extended 513M 4000M
parted ${device} mkpart logical fat16 513M 534M i
parted ${device} mkpart logical ext4 534M 555M i
parted ${device} mkpart logical ext4 555M 606M i
parted ${device} mkpart logical ext4 606M 4000M

sleep 1

# Configure the partitions
mkswap ${device}1
mkfs.fat ${device}5
mkfs.ext4 ${device}6
mkfs.ext4 ${device}7
mkfs.ext4 ${device}8

sleep 1
fi

# Load the base version of KubOS Linux
if [ "${package}" -gt "1" ]; then
  export PATH=$PATH:/usr/bin/iobc_toolchain/usr/bin
  echo $PATH
  ./kubos-package.sh -b ${branch} -v base
fi

if [ "${package}" -gt "0" ]; then
  mkdir -p ~/upgrade
  mount ${device}7 ~/upgrade
  cp kpack-base.itb ~/upgrade
  sleep 1
  umount ${device}7

  mkdir -p ~/boot
  mount ${device}5 ~/boot
  cp kubos-package.itb ~/boot/package
  sleep 1
  umount ${device}5
fi

exit 0

