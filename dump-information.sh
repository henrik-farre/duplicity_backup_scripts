#!/bin/bash
set -o nounset
set -o errexit
set -o errtrace
set -o pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Needs root access"
  exit 1
fi

source /usr/local/sbin/includes.sh

dump_disk_info
dump_package_list
