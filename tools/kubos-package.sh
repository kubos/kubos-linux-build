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
# kubos-package: Create Kubos Linux Upgrade Package (kpack)
#
 
version=$(date +%Y.%m.%d)
input=kpack.its
branch=master
rootfs_sz=60000
rflag=false
kernel=false

# Process command arguments

while getopts "s:v:i:b:o:t:k" option
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
	o)
	    output=$OPTARG
	    ;;
	t)
	    target=$OPTARG
	    rflag=true
	    ;;
	k)
	    kernel=true
            ;;
	\?)
	    exit 1
	    ;;
    esac
done
: ${BASE_DIR:=../../buildroot-2017.02.8/${output}}

if ! ${rflag}
then
    echo "-t target must be specified" >&2
    exit 1
fi

rootfs_dir=${BASE_DIR}/images
rootfs_img=${rootfs_dir}/rootfs.img
rootfs_tar=${rootfs_dir}/rootfs.tar

# Create kernel.itb if requested
if ${kernel}
then
    cp ../board/kubos/${target}/kubos-kernel.its ${BASE_DIR}/images/
    ./kubos-kernel.sh -b ${branch} -i ${BASE_DIR}/images/kubos-kernel.its -o ${output}
    cp kubos-kernel.itb ${rootfs_dir}/kernel
fi

# Create rootfs.img
# Currently the image needs ~13M of space. Increase if necessary.
dd if=/dev/zero of=${rootfs_img} bs=1K count=$rootfs_sz
mkfs.ext4 ${rootfs_img}
sudo mount -o loop ${rootfs_img} /mnt
sudo tar -xf ${rootfs_tar} -C /mnt
sudo umount /mnt

# Copy the package .its file
cp ${input} ${rootfs_dir}/
input_name=$(basename ${input})

# Build the full package
${BASE_DIR}/build/uboot-${branch}/tools/mkimage -f ${rootfs_dir}/${input_name} kpack-${version}.itb


