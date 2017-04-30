#!/system/bin/sh

AP_LOGDIR=/data/hisi_logs/ap_log/coredump
MCU_FREEZE="mcu freeze"
MCU_PANIC="mcu panic"
# make sure 4M flash space
sh /etc/log/clean_log.sh 360 ap_log

# export TIMESTAMP for log tag
export TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# prepare directory
sh /etc/log/prepare_dir.sh
mkdir -p $AP_LOGDIR/$TIMESTAMP
chmod 774 $AP_LOGDIR/$TIMESTAMP
chown root:system $AP_LOGDIR/$TIMESTAMP

# save the dump files
cat /proc/balong/memory/mcu > $AP_LOGDIR/$TIMESTAMP/mcu_memory.bin
cat /proc/balong/memory/telemntn > $AP_LOGDIR/$TIMESTAMP/telemntn_memory.bin
cat /proc/balong/memory/sram_acpu > $AP_LOGDIR/$TIMESTAMP/sram_acpu_memory.bin
cat /proc/balong/memory/sram_mcu > $AP_LOGDIR/$TIMESTAMP/sram_mcu_memory.bin
cat /proc/balong/memory/modem > $AP_LOGDIR/$TIMESTAMP/modem_memory.bin
cat /proc/balong/log/android > $AP_LOGDIR/$TIMESTAMP/a_mntn.bin
#cat /proc/balong/log/mcu > $AP_LOGDIR/$TIMESTAMP/mcu_log.bin
cat /mnt/pstore/* > $AP_LOGDIR/$TIMESTAMP/last_kmsg
cat /proc/last_kirq > $AP_LOGDIR/$TIMESTAMP/last_kirq
cat /proc/last_ktask > $AP_LOGDIR/$TIMESTAMP/last_ktask

# save log event
if [ "$1" == "$MCU_FREEZE" ]
then
	echo $TIMESTAMP" : MCU local watchdog triggered system reset!" >> $AP_LOGDIR/history.log
elif [ "$1" == "$MCU_PANIC" ]
then
    echo $TIMESTAMP" : "$1" ..." >> $AP_LOGDIR/history.log
fi
chmod 664 $AP_LOGDIR/$TIMESTAMP/*
chown root:system $AP_LOGDIR/$TIMESTAMP/*
chmod 664 $AP_LOGDIR/history.log
chown root:system $AP_LOGDIR/history.log

sync

reboot

exit

