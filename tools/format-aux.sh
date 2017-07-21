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
 # Create Auxiliary SD Card image for use with KubOS Linux on the 
 # Pumpkin MBM2
 #
 # Inputs:
 #  * i {path}  - The path of the *.itb file to be loaded into the upgrade
 #                partition. It will be renamed to kpack-base.itb
 #  * s         - Size, in MB, of SD card (default 3800)
 #

size=3800
sd_size=`expr ${size} - 4`
input=kpack-base.itb

# Process command arguments

while getopts "i:s:" option
do
    case $option in
        i)
          input=${OPTARG}
          ;;
	s)
	  size=${OPTARG}
	  ;;
	\?)
	  exit 1
	  ;;
    esac
done

mkdir -p ramdisk

sudo mount -t tmpfs -o size=${size}M tmpfs ramdisk/
cd ramdisk/

sudo dd if=/dev/zero of=aux-sd.img bs=1M count=${size}
sudo losetup /dev/loop0 aux-sd.img 
sudo parted /dev/loop0 mklabel msdos
sudo parted /dev/loop0 mkpart primary ext4 4M 60M
sudo parted /dev/loop0 mkpart primary ext4 60M ${sd_size}M

sudo mkfs.ext4 /dev/loop0p1

sudo mkdir -p /tmp-kubos
sudo mount /dev/loop0p1 /tmp-kubos
sudo cp ../${input} /tmp-kubos/kpack-base.itb
sudo umount /dev/loop0p1
sudo rmdir /tmp-kubos/
sudo losetup -d /dev/loop0
cd ..
sudo mv ramdisk/aux-sd.img .
sudo umount ramdisk
sudo rmdir ramdisk


