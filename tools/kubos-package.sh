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
 # kubos-package: Create KubOS Linux Upgrade Package (kpack)
 # 
 
version=$(date +%Y.%m.%d)
input=kpack.its
branch=master
rootfs_dir=../../buildroot-2016.11/output/images
rootfs_img=$rootfs_dir/rootfs.img
rootfs_tar=$rootfs_dir/rootfs.tar
rootfs_sz=13000

# Process command arguments

while getopts "s:v:i:b:" option
do
    case $option in
        s)
	    rootfs_sz=$OPTARG
	    ;;
	v)
	    version=$OPTARG
	    ;;
	i)
	    input=$OPTARG
	    ;;
	b)
	    branch=$OPTARG
	    ;;
	\?)
	    exit 1
	    ;;
    esac
done

# Create kernel.itb
./kubos-kernel.sh -b ${branch}

# Create rootfs.img
# Currently the image needs ~13M of space. Increase if necessary.
dd if=/dev/zero of=$rootfs_img bs=1K count=$rootfs_sz
mkfs.ext4 $rootfs_img
sudo mount -o loop $rootfs_img /mnt
sudo tar -xf $rootfs_tar -C /mnt
sudo umount /mnt

# Build the full package
../../buildroot-2016.11/output/build/uboot-${branch}/tools/mkimage -f ${input} kpack-${version}.itb


