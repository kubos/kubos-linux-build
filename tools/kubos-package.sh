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
rflag=false
kernel=false
output=output

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Please run script as root"
    exit
fi

# Process command arguments

while getopts "s:v:i:b:o:t:k" option
do
    case $option in
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

# Create kernel.itb if requested
if ${kernel}
then
    cp ../board/kubos/${target}/kubos-kernel.its ${BASE_DIR}/images/
    ./kubos-kernel.sh -b ${branch} -i ${BASE_DIR}/images/kubos-kernel.its -o ${output}
    cp kubos-kernel.itb ${rootfs_dir}/kernel
fi
# Copy the package .its file
cp ${input} ${rootfs_dir}/
input_name=$(basename ${input})

# Build the full package
${BASE_DIR}/build/uboot-${branch}/tools/mkimage -f ${rootfs_dir}/${input_name} kpack-${version}.itb


