#!/bin/bash

function set_lock() {
  (set -C; : > ${1} ) 2> /dev/null
  if [ ${?} != "0" ]; then
    echo "Lock File exists - exiting"
    exit 1
  fi
}

function cleanup() {
  if [[ -f "${LOCK_FILE}" ]]; then
    rm "${LOCK_FILE}"
  fi
  if [[ -f "${ERROR_LOG}" ]]; then
    rm "${ERROR_LOG}"
  fi
  if [ "${ERROR}" -gt 0 ]; then
    echo -e "${TYPE} failed:\n${ERROR_MSG}\n\n\n${MSG}" | mailx -s "[CRON]: ${TYPE} of ${HOSTNAME} failed!" "${EMAIL}"
    notify_users_error
  else
    echo -e "${TYPE} completed:${MSG}" | mailx -s "[CRON]: ${TYPE} of ${HOSTNAME} completed" "${EMAIL}"
    notify_users_done
  fi
  unset PASSPHRASE
  unset GOOGLE_DRIVE_SETTINGS
  unset ENCRYPT_KEY
  unset COMMON_OPTS
  unset BACKUP_OPTS
  unset EXCLUDE_OPTS
  unset DIR_EXCLUDE
  unset REMOTE_DIR
  unset BACKDIRS
  unset EMAIL
  unset TYPE
}

function err_report() {
  local LASTLINE
  local LASTERR
  LASTLINE="${1}"
  LASTERR="${2}"
  ERROR_MSG=$(<${ERROR_LOG})
  ERROR_MSG="${ERROR_MSG}\nLine ${LASTLINE}: exit status of last command: ${LASTERR}"
  ERROR=1

  exit ${LASTERR}
}

# Setup handlers for errors and exit
# NOTE: error handling in bash is... interesting :)
function setup() {
  set_lock "${LOCK_FILE}"
  trap cleanup EXIT
  trap 'err_report ${LINENO} ${?}' ERR

  if [[ ! -d /var/backup ]]; then
    mkdir /var/backup
  fi

  if [[ ! -d /var/log/backup ]]; then
    mkdir /var/log/backup
  fi
  
  notify_users_start
}

function dump_disk_info() {
  rm -f /var/backup/partition_info.txt
  rm -f /var/backup/fs_info.txt
  touch /var/backup/partition_info.txt
  touch /var/backup/fs_info.txt
  touch /var/backup/raid_info.txt

  # TODO:
  # Only match ext3 partitions
  # Breaks if vfat, should also match /dev/md*
  # for partition in $(blkid | grep -E '/dev/sd.*TYPE="ext4"' | cut -f1 -d":"); do
  #   if [[ ${partition} != 'swap' ]]; then
  #     dumpe2fs -h ${partition} >> /var/backup/fs_info.txt 2>/dev/null
  #   fi
  # done

  # Dump partition info, needs name of disks else it will fail. Append "|| true" to ignore
  # Requires sfdisk
  if command -v "sfdisk" &>/dev/null; then
    for DISK in $(lsblk -ndro KNAME,TYPE | awk '$2 ~ /disk/ { print $1 }'); do
      sfdisk --dump /dev/${DISK} >> /var/backup/partition_info.txt
    done
  else
    echo "No sfdisk installed"
  fi

  # Dump raid meta data
  if command -v "mdadm" &>/dev/null; then
    # Ignore return value greater than 0
    mdadm -Evvvvs >> /var/backup/raid_info.txt || true
  fi
}

# Arch Linux package list
function dump_package_list() {
  if [ -f /etc/arch-release ]; then
    pacman -Q | gzip > /var/backup/packages.txt.gz
  fi
}

function notify_users_start() {
  if [ -e /usr/bin/notify-send ]; then
    /usr/local/sbin/user-notification.sh "emblem-generic" "Duplicity backup" "... Backup is starting"
  fi
}

function notify_users_done() {
  if [ -e /usr/bin/notify-send ]; then
    /usr/local/sbin/user-notification.sh "emblem-generic" "Duplicity backup" "... Backup completed"
  fi
}

function notify_users_error() {
  if [ -e /usr/bin/notify-send ]; then
    /usr/local/sbin/user-notification.sh "emblem-urgent" "Duplicity backup" "... Backup failed!"
  fi
}
