#!/system/bin/sh

AP_LOGDIR=/data/hisi_logs/ap_log/coredump
CP_LOGDIR=/data/hisi_logs/cp_log/coredump


# make sure 96M flash space
sh /etc/log/clean_log.sh 360 cp_log

# export TIMESTAMP for log tag
export TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# prepare directory
sh /etc/log/prepare_dir.sh
mkdir -p $CP_LOGDIR/$TIMESTAMP
chmod 774 $CP_LOGDIR/$TIMESTAMP
chown root:system $CP_LOGDIR/$TIMESTAMP

# save the dump files
cat /proc/balong/memory/sram_acpu > $CP_LOGDIR/$TIMESTAMP/sram_acpu_memory.bin
cat /proc/balong/memory/sram_mcu > $CP_LOGDIR/$TIMESTAMP/sram_mcu_memory.bin
cat /proc/balong/memory/bbe16_sdr > $CP_LOGDIR/$TIMESTAMP/bbe16_sdr_memory.bin
cat /proc/balong/memory/bbe16_tds_table > $CP_LOGDIR/$TIMESTAMP/bbe16_tds_table_memory.bin
cat /proc/balong/memory/bbe16_img_ddr > $CP_LOGDIR/$TIMESTAMP/bbe16_img_ddr_memory.bin
cat /proc/balong/memory/bbe16_dtcm > $CP_LOGDIR/$TIMESTAMP/bbe16_dtcm_memory.bin
cat /proc/balong/memory/telemntn > $CP_LOGDIR/$TIMESTAMP/telemntn_memory.bin
cat /proc/balong/memory/peri_sc > $CP_LOGDIR/$TIMESTAMP/peri_sc.bin
cat /proc/balong/memory/modem_sc > $CP_LOGDIR/$TIMESTAMP/modem_sc.bin

# save the log file
cat /proc/balong/log/modem > $CP_LOGDIR/$TIMESTAMP/modem_log.bin
cat /proc/balong/memory/modem > $CP_LOGDIR/$TIMESTAMP/modem_memory.bin

cat /mnt/pstore/* > $CP_LOGDIR/$TIMESTAMP/last_kmsg
cat /proc/last_kirq > $CP_LOGDIR/$TIMESTAMP/last_kirq
cat /proc/last_ktask > $CP_LOGDIR/$TIMESTAMP/last_ktask
if test -f "/proc/core_trace/core_flag" 
then

flag=`cat /proc/core_trace/core_flag`
if [ $flag == '10000000' ] 
then
	cat /proc/balong/memory/trace_mem > $CP_LOGDIR/$TIMESTAMP/modem_core.bin
else
        touch  $CP_LOGDIR/$TIMESTAMP/record.log
	echo "the flag is invalid" > $CP_LOGDIR/$TIMESTAMP/record.log
fi 
else
	touch $CP_LOGDIR/$TIMESTAMP/check.log
	echo "the read file does not exist">$CP_LOGDIR/$TIMESTAMP/check.log
fi
# save log event
echo $TIMESTAMP" : "$1" ..." >> $AP_LOGDIR/history.log
chmod 664 $CP_LOGDIR/$TIMESTAMP/*
chown root:system $CP_LOGDIR/$TIMESTAMP/*
chmod 664 $AP_LOGDIR/history.log
chown root:system $AP_LOGDIR/history.log

/*collect modem reset info for apr*/
modem_resetinfo -i $CP_LOGDIR/$TIMESTAMP/modem_log.bin -f $CP_LOGDIR/$TIMESTAMP/reset.log

sync
#only reboot modem
#reboot -n

exit

