#! /bin/sh
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

set -ex

DIR=$PWD
PASS='sshpass -p Kubos123'
BINARY=target/arm-unknown-linux-gnueabihf/release/release-test
TARGET_DIR=/home/kubos/release-test
LOG_FILE=${TARGET_DIR}/test-output
TELEM_FILE=telem-results
TELEM_PATH=${TARGET_DIR}/${TELEM_FILE}.tar.gz

# Test Setup
# TODO: Replace with shell client command
$PASS ssh kubos@$1 "mkdir -p ${TARGET_DIR}"

# Pre-build the file transfer client
kubos use -b master
cd /home/vagrant/.kubos/kubos/clients/file-client
git pull origin master
cargo build
cd ${DIR}

# Build our test project
CC=/usr/bin/bbb_toolchain cargo build --release --target arm-unknown-linux-gnueabihf
arm-linux-strip ${BINARY}

# Transfer our test binary to the OBC
# TODO: Use file transfer client for transfer
/home/vagrant/.kubos/kubos/target/debug/file-client upload ${BINARY} ${TARGET_DIR}/release-test -r ${1} -p 8008
$PASS scp ${BINARY} kubos@${1}:${TARGET_DIR}

# Run our tests
# TODO: Use shell client for execution
# TODO: Register the app and use the apps service for execution
$PASS ssh kubos@$1 "cd release-test; ./release-test -r OnCommand"

# Get our results
# TODO: Use file transfer client
$PASS scp kubos@${1}:${LOG_FILE} .
$PASS scp kubos@${1}:${TELEM_PATH} .
tar -xzf ${TELEM_FILE}.tar.gz ${TELEM_FILE}

# Cleanup the test folder on the OBC
#$PASS ssh kubos@$1 'rm release-test -R'