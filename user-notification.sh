#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail
set -o xtrace
IFS=$'\n\t'

ICON=${1:-"emblem-generic"}
TITLE="${2:-"Title"}"
MESSAGE=${3:-"Message"}
TIME_OUT=${4:-1000}

for USER_UID in /run/user/*; do
  sudo -u \#"${USER_UID##*/}" DISPLAY=:0.0 /usr/bin/notify-send -i "${ICON}" "${TITLE}" "${MESSAGE}" -t "${TIME_OUT}"
done
