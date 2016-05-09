# Duplicity backup scripts
Backup/Restore scripts for duplicity with Google drive as backend

## Setup
* scripts have to be in /usr/local/sbin/
* conf.skel needs to be copied to /root/.duplicity/conf and empty vars have to have been configured:
  * PASSPHRASE   : GPG passphrase
  * ENCRYPT_KEY  : GPG key id
  * REMOTE_DIR   : Remote dir, for Google drive: gdocs://YOUR_GMAIL/SOME_DIR/$HOSTNAME
  * BACKDIRS     : Dirs to backup, without leading /, e.g.: "home var/lib some/other/dir"
  * EMAIL        : Email to send cron mails to
* include/exclude files have to be in /usr/local/etc/duplicity, and named like this:
  * exclude-common: common patterns that should be ignored for all backups
  * exclude-DIR-HOSTNAME: where DIR is the directory being backed up, where / is replaced with -, e.g. var/log => var-log, HOSTNAME: is the systems hostname
