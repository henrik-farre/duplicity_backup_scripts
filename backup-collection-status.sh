#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Needs root access"
  exit 1
fi

# For PyDrive credentials
cd /root/.duplicity/
# shellcheck disable=SC1091
source /root/.duplicity/conf

if [[ "${#}" -eq 0 ]]; then
  echo "Missing argument:"
  echo "1: Remote dir, e.g. etc"
  exit 1
fi

DIR=${1:-}

duplicity collection-status ${COMMON_OPTS} "${REMOTE_DIR}/${DIR}"
