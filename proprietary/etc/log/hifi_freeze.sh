#!/system/bin/sh

AP_LOGDIR=/data/hisi_logs/ap_log/coredump
HIFI_LOGDIR=/data/hisi_logs/hifi_log/coredump

# make sure 16M flash space
sh /etc/log/clean_log.sh 112 hifi_log

# export TIMESTAMP for log tag
export TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# prepare directory
sh /etc/log/prepare_dir.sh
mkdir -p $HIFI_LOGDIR/$TIMESTAMP
chmod 774 $HIFI_LOGDIR/$TIMESTAMP
chown root:system $HIFI_LOGDIR/$TIMESTAMP

# save the dump files
cat /proc/balong/memory/sram_acpu > $HIFI_LOGDIR/$TIMESTAMP/sram_acpu_memory.bin
cat /proc/balong/memory/sram_mcu > $HIFI_LOGDIR/$TIMESTAMP/sram_mcu_memory.bin
cat /proc/balong/memory/hifi > $HIFI_LOGDIR/$TIMESTAMP/hifi_memory.bin
cat /proc/balong/log/android > $HIFI_LOGDIR/$TIMESTAMP/a_mntn.bin
cat /mnt/pstore/* > $HIFI_LOGDIR/$TIMESTAMP/last_kmsg
cat /proc/last_kirq > $HIFI_LOGDIR/$TIMESTAMP/last_kirq
cat /proc/last_ktask > $HIFI_LOGDIR/$TIMESTAMP/last_ktask
cat /sys/kernel/debug/hissc/rh > $HIFI_LOGDIR/$TIMESTAMP/rh
cat /sys/kernel/debug/hissc/stat > $HIFI_LOGDIR/$TIMESTAMP/stat
# save log event
echo $TIMESTAMP" : hifi freeze ..." >> $AP_LOGDIR/history.log
chmod 664 $HIFI_LOGDIR/$TIMESTAMP/*
chown root:system $HIFI_LOGDIR/$TIMESTAMP/*
chmod 664 $AP_LOGDIR/history.log
chown root:system $AP_LOGDIR/history.log
sync

/system/bin/crashnotice -t info_hifi_crash

#only reboot hifi
#reboot -n

exit

