#!/bin/sh
#
# Copyright (C) 2018 Kubos Corporation
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
# Rotate log files

# Maximum number of archive files to maintain for any particular log file
MAX_COUNT=9

# Check how many archive files we have for this log
ARCHIVE_COUNT=$(find /var/log/ -maxdepth 1 -name "$1.*" | wc -l)

# If at the max limit, delete the oldest one
if [[ ${ARCHIVE_COUNT} -ge ${MAX_COUNT} ]]
then
        OLDEST=$(find /var/log/ -maxdepth 1 -name "$1.*" | sort -r | tail -n1)
        rm -rf "$OLDEST"
fi
# Move current log file to new archive file
mv -f /var/log/$1 /var/log/$1.$(date +%Y.%m.%d-%H.%M.%S)
