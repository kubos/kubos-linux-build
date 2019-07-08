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

klb_dir=$(cd `dirname "$0"`/..; pwd)
. "$klb_dir/tools/deps.sh"

version=$(date +%Y.%m.%d)
input=kpack-NOR.its
branch=$uboot_branch_iobc

# Process command arguments

while getopts "v:i:b:" option
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
	\?)
	    exit 1
	    ;;
    esac
done
: ${BASE_DIR:=../../$buildroot_dirname/output}

rootfs_dir=${BASE_DIR}/images

if [[ ! -d "$rootfs_dir" ]]; then
    echo "Buildroot images dir doesn't exist: $rootfs_dir"
    exit 1
fi

# copy the package its ile
cp ${input} ${rootfs_dir}/
input_name=$(basename ${input})

# Build the package relative to buildroot
out_dir=$PWD

pushd ${rootfs_dir}
${BASE_DIR}/build/uboot-${branch}/tools/mkimage -f ${rootfs_dir}/${input_name} "${out_dir}/kpack-nor-${version}.itb"
popd


