#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

ICON=${1:-"emblem-generic"}
TITLE="${2:-"Title"}"
MESSAGE=${3:-"Message"}
DISPLAY=":0.0"

for DBUS_SESSION in /run/user/*/bus; do
  DBUS_SESSION_BUS_ADDRESS="unix:path=${DBUS_SESSION}" /usr/bin/notify-send -i "${ICON}" "${TITLE}" "${MESSAGE}"
done
