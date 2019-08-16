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
branch=1.2
rflag=false
output=output

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Please run script as root"
    exit
fi

# Make sure that we can find the `dtc` command
# (The binary is target-independent so we can just use the one in the BBB toolchain directory)
export PATH=$PATH:/usr/bin/bbb_toolchain/usr/bin

# Process command arguments

while getopts "v:i:b:o:t:" option
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
	\?)
	    exit 1
	    ;;
    esac
done
: ${BASE_DIR:=../../buildroot-2019.02.2/${output}}

if ! ${rflag}
then
    echo "-t target must be specified" >&2
    exit 1
fi

rootfs_dir=${BASE_DIR}/images

# Copy the package .its file
cp ${input} ${rootfs_dir}/
input_name=$(basename ${input})

# Build the full package
${BASE_DIR}/build/uboot-${branch}/tools/mkimage -E -f ${rootfs_dir}/${input_name} kpack-${version}.itb


