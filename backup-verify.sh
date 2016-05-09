#!/bin/bash
set -o nounset
set -o errexit
set -o errtrace
set -o pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Needs root access"
  exit 1
fi

# For PyDrive credentials
cd /root/.duplicity/
source /root/.duplicity/conf

if [[ "${#}" -eq 0 ]]; then
  echo "Missing argument:"
  echo "Remote dir, e.g. etc"
  exit 1
fi

DIR=${1:-}

duplicity verify $COMMON_OPTS "${REMOTE_DIR}/${DIR}" "/${DIR}"

unset PASSPHRASE
unset GOOGLE_DRIVE_SETTINGS
unset ENCRYPT_KEY
unset COMMON_OPTS
unset BACKUP_OPTS
unset EXCLUDE_OPTS
unset DIR_EXCLUDE
unset REMOTE_DIR
unset BACKDIRS
