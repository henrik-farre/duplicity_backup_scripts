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

if [[ "${#}" -ne 3 ]]; then
  echo "3 arguments are needed:"
  echo "1: File to restore: relative to dir, e.g. hosts"
  echo "2: Remote dir, e.g. etc"
  echo "3: Restore destination, NOTE: should be full path, else it will end up in /root/.duplicity/"
  echo "4: (Optional) time argument for duplicity, e.g. 3D"
  exit 1
fi

FILE=${1:-}
DIR=${2:-}
RESTORE_DEST=${3:-}
TIME=${4:-}

ARGS=""
if [[ -n ${TIME} ]]; then
  ARGS="--time ${TIME}"
fi

duplicity ${ARGS} ${COMMON_OPTS} --file-to-restore "${FILE}" "${REMOTE_DIR}/${DIR}" "${RESTORE_DEST}"

unset PASSPHRASE
unset ENCRYPT_KEY
unset COMMON_OPTS
unset BACKUP_OPTS
unset EXCLUDE_OPTS
unset DIR_EXCLUDE
unset GOOGLE_DRIVE_SETTINGS
unset REMOTE_DIR
unset BACKDIRS
unset EMAIL
