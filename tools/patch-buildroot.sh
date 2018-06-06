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
# The current version of BuildRoot that we use doesn't properly verify
# the Python modules as part of the build process. It attempts to compile
# everything, which includes Python3 modules. Since we don't support
# Python3 at the moment, this process fails. The latest version of
# the pycompile.py script fixes this issue. For the sake of time, we'll
# just update that single file, rather than attempting to upgrade to the
# latest version of BuildRoot
#

cp pycompile.py ../../buildroot-2017.02.8/support/scripts