#!/bin/bash

artifact_url="https://${CIRCLE_BUILD_NUM}-73321966-gh.circle-artifacts.com/0${CIRCLE_ARTIFACTS}/kubos-linux.tar.gz"
curl --request POST --header "Content-Type: application/json" --data '{"text": "SD card image should be available at: '$artifact_url'"}' $ARTIFACT_WEBHOOK_URL
