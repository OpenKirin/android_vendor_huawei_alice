#!/system/bin/sh

AP_LOGDIR=/data/hisi_logs/ap_log/coredump


reboot_reason=$1

# export TIMESTAMP for log tag
export TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# prepare directory
sh /etc/log/prepare_dir.sh

# save log event

echo $TIMESTAMP" :" $reboot_reason >> $AP_LOGDIR/history.log
chmod 664 $AP_LOGDIR/history.log
chown root:system $AP_LOGDIR/history.log

sync

exit

