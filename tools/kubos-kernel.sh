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
 
input=kubos-kernel.its
branch=1.2
output=output

# Process command arguments

while getopts "i:b:o:" option
do
    case $option in
	i)
	    input=$OPTARG
	    ;;
	b)
	    branch=$OPTARG
	    ;;
	o)
	    output=$OPTARG
	    ;;
	\?)
	    exit 1
	    ;;
    esac
done
: ${BASE_DIR:=../../buildroot-2019.02.2/${output}}

# Build the package
${BASE_DIR}/build/uboot-${branch}/tools/mkimage -f ${input} kubos-kernel.itb


