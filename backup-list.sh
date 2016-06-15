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
  echo "2: (Optional) time argument for duplicity"
  exit 1
fi

DIR=${1:-}
TIME=${2:-}

ARGS=""
if [[ -n ${TIME} ]]; then
  ARGS="--time ${TIME}"
fi

duplicity list-current-files ${ARGS} ${COMMON_OPTS} "${REMOTE_DIR}/${DIR}"

unset PASSPHRASE
unset DPBX_ACCESS_TOKEN
unset DPBX_APP_KEY
unset DPBX_APP_SECRET
unset ENCRYPT_KEY
unset COMMON_OPTS
unset BACKUP_OPTS
unset EXCLUDE_OPTS
unset DIR_EXCLUDE
unset REMOTE_DIR
unset BACKDIRS
unset EMAIL
