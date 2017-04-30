#!/system/bin/sh

AP_LOGDIR=/data/hisi_logs/ap_log/coredump


# make sure 16M flash space
sh /etc/log/clean_log.sh 360 ap_log

# export TIMESTAMP for log tag
export TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# prepare directory
sh /etc/log/prepare_dir.sh

# save log event
echo $TIMESTAMP" : thermal reboot..." >> $AP_LOGDIR/history.log

chmod 664 $AP_LOGDIR/history.log
chown root:system $AP_LOGDIR/history.log

sync

echo 1 > /sys/devices/platform/hi6620-tsensor.1/tsensor0_state
#only reboot hifi
reboot

exit

