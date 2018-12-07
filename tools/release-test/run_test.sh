#! /bin/bash
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

set -e

DIR=$PWD
PASS='sshpass -p Kubos123'
BINARY=target/arm-unknown-linux-gnueabihf/release/release-test
TARGET_DIR=/home/kubos/release-test
LOG_FILE=${TARGET_DIR}/test-output
TELEM_FILE=telem-results
TELEM_PATH=${TARGET_DIR}/${TELEM_FILE}.tar.gz

# Setup a shell session for us to use
RESPONSE=$(kubos-shell-client -i ${1} -p 8010 start << EOT
EOT
)

CHANNEL_LINE=$(echo "${RESPONSE}" | grep "Starting shell session")
# Save our shell session's channel ID for later
CHANNEL_ID=$(echo ${CHANNEL_LINE:26})

# Setup the test directory on the target OBC
RESPONSE=$(kubos-shell-client -i ${1} -p 8010 join -c ${CHANNEL_ID} << EOT
cd /home/kubos
mkdir -p ${TARGET_DIR}
EOT
)

# Build our test project
CC=/usr/bin/bbb_toolchain/usr/bin/arm-linux-gcc cargo build --release --target arm-unknown-linux-gnueabihf
arm-linux-strip ${BINARY}

# Transfer our test binary to the OBC
kubos-file-client -r ${1} -p 8008 upload ${BINARY} ${TARGET_DIR}/release-test
kubos-file-client -r ${1} -p 8008 upload manifest.toml ${TARGET_DIR}/manifest.toml

# Register the app with the applications service
RESPONSE=$(echo "mutation { register(path: \"${TARGET_DIR}\"){ success, errors, entry { app { uuid } } } }" | nc -uw1 ${1} 8000)
if ! [[ "${RESPONSE}" =~ "\"success\":true" ]]; then
    echo -e "\033[0;31mApp registration failed. Response: ${RESPONSE}\033[0m" >&2
fi

# Extract the UUID so we can start the application
UUID=$(echo `expr match "${RESPONSE}" '.*\([[:alnum:]]\{8\}-[[:alnum:]]\{4\}-[[:alnum:]]\{4\}-[[:alnum:]]\{4\}-[[:alnum:]]\{12\}\)'`)

# Run the tests
RESPONSE=$(echo "mutation { startApp(uuid: \"${UUID}\", runLevel: \"OnCommand\") { success, errors }}" | nc -uw1 ${1} 8000)
if ! [[ "${RESPONSE}" =~ "\"success\":true" ]]; then
    echo -e "\033[0;31mFailed to start app. Response: ${RESPONSE}\033[0m" >&2
fi

# Get our results
kubos-file-client -r ${1} -p 8008 download ${LOG_FILE}
kubos-file-client -r ${1} -p 8008 download ${TELEM_PATH}
tar -xzf ${TELEM_FILE}.tar.gz ${TELEM_FILE}

# Test Cleanup
RESPONSE=$(echo "mutation { uninstall(uuid: \"${UUID}\", version: \"1.0\") { success, errors } }" | nc -uw1 ${1} 8000)
if ! [[ "${RESPONSE}" =~ "\"success\":true" ]]; then
    echo -e "\033[0;31mFailed to uninstall app. Response: ${RESPONSE}\033[0m" >&2
fi

IGNORE=$(kubos-shell-client -i ${1} -p 8010 join -c ${CHANNEL_ID} << EOT
rm release-test -R
EOT
)

IGNORE=$(kubos-shell-client -i ${1} -p 8010 kill -c ${CHANNEL_ID})

# The grep command will fail if there are no results. We need to not bail when we hit the error so
# we can print a message
set +e

# Verify results
TELEM_RESULTS=$(grep timestamp telem-results)
if [[ -z ${TELEM_RESULTS} ]]; then
    echo -e "\033[0;31mRouted telemetry test failed\033[0m" >&2
    FAILURES=1
fi
TEST_RESULTS=$(grep "Failed - [1-9]" test-output)
if [[ ! -z ${TEST_RESULTS} ]]; then
    echo -e "\033[0;31mTest failure/s detected: \n${TEST_RESULTS}\033[0m" >&2
    FAILURES=1
fi

if [[ ! -z ${FAILURES} ]]; then
    echo -e "\033[0;31mRelease Test Failed\033[0m" >&2
else
    echo -e "\033[0;32mRelease Test Completed Successfully\033[0m" >&2
fi