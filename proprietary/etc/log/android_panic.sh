#!/system/bin/sh

# log dir define
HISI_LOGDIR=/data/hisi_logs
AP_LOGDIR=/data/hisi_logs/ap_log/coredump
DUMP_DIR=/data/hisi_logs/memorydump

#check whether to save logs
closeflag=`cat /proc/balong/stats/close`
if [ $closeflag -ne 1 ]; then
# check whether exc file need to create
excflag=`cat /sys/class/exc_class/exc_dev/exc`
if test $excflag = 1

then
# make sure 8M flash space
sh /etc/log/clean_log.sh 360 ap_log
sh /etc/log/clean_log.sh 50 memorydump

# export TIMESTAMP for log tag
export TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# prepare directory
sh /etc/log/prepare_dir.sh
mkdir -p $AP_LOGDIR/$TIMESTAMP
chmod 774 $AP_LOGDIR/$TIMESTAMP
chown root:system $AP_LOGDIR/$TIMESTAMP
mkdir -p $DUMP_DIR/$TIMESTAMP
chmod 774 $DUMP_DIR/$TIMESTAMP
chown root:system $DUMP_DIR/$TIMESTAMP

export INFO=$(cat /sys/class/exc_class/exc_dev/info)
echo $TIMESTAMP" : android reboot!" $INFO >> $AP_LOGDIR/history.log
chmod 664 $AP_LOGDIR/history.log
chown root:system $AP_LOGDIR/history.log

# save the dump files
cat /proc/balong/memory/sram_acpu > $AP_LOGDIR/$TIMESTAMP/sram_acpu_memory.bin
cat /proc/balong/memory/sram_mcu > $AP_LOGDIR/$TIMESTAMP/sram_mcu_memory.bin
cat /proc/balong/log/android > $AP_LOGDIR/$TIMESTAMP/a_mntn.bin
cat /proc/balong/memory/mcu_rstsys > $AP_LOGDIR/$TIMESTAMP/mcu_memory.bin
cat /mnt/pstore/* > $AP_LOGDIR/$TIMESTAMP/last_kmsg
cat /proc/last_kirq > $AP_LOGDIR/$TIMESTAMP/last_kirq
cat /proc/last_ktask > $AP_LOGDIR/$TIMESTAMP/last_ktask
cat /proc/last_modid > $AP_LOGDIR/$TIMESTAMP/last_modid
if [ -f /proc/balong/log/fastboot ]; then
	cat /proc/balong/log/fastboot > $AP_LOGDIR/$TIMESTAMP/fastboot_log_current
fi
if [ -f $HISI_LOGDIR/fastboot_backup ]; then
	cat $HISI_LOGDIR/fastboot_backup > $AP_LOGDIR/$TIMESTAMP/fastboot_log_last
fi
chmod 664 $AP_LOGDIR/$TIMESTAMP/*
chown root:system $AP_LOGDIR/$TIMESTAMP/*

if [ -f "/proc/balong/memory/dump_low128M" ]; then
cat /proc/balong/memory/dump_low128M > $DUMP_DIR/$TIMESTAMP/dump_low_memory.lzf
fi

if [ -f "/proc/balong/memory/dump_kernel360M" ]; then
cat /proc/balong/memory/dump_kernel360M > $DUMP_DIR/$TIMESTAMP/dump_kernel_memory.lzf
fi
chmod 664 $DUMP_DIR/$TIMESTAMP/*
chown root:system $DUMP_DIR/$TIMESTAMP/*

if test -f "/proc/core_trace/core_flag" 
then

flag=`cat /proc/core_trace/core_flag`

if [ $flag == '00001000' ] 
then
	cat /proc/balong/memory/trace_mem > $AP_LOGDIR/$TIMESTAMP/android_acore0.bin
elif [ $flag == '00001001' ]
then
	cat /proc/balong/memory/trace_mem > $AP_LOGDIR/$TIMESTAMP/android_acore1.bin
elif [ $flag == '00001010' ]
then
	cat /proc/balong/memory/trace_mem > $AP_LOGDIR/$TIMESTAMP/android_acore2.bin
elif [ $flag == '00001011' ]
then
	cat /proc/balong/memory/trace_mem > $AP_LOGDIR/$TIMESTAMP/android_acore3.bin
else
        touch  $AP_LOGDIR/$TIMESTAMP/record.log
	echo "the flag is invalid" > $AP_LOGDIR/$TIMESTAMP/record.log
fi 

else
	touch $AP_LOGDIR/$TIMESTAMP/check.log
	echo "the read file does not exist">$AP_LOGDIR/$TIMESTAMP/check.log
fi
chmod 664 $AP_LOGDIR/$TIMESTAMP/*
chown root:system $AP_LOGDIR/$TIMESTAMP/*
sync

fi

wdtrstflag=`cat /proc/balong/reboot/reboot`

flag=$((wdtrstflag&0x1))
if [ $flag -ne 0 ]; then
sh /etc/log/reboot_history_write.sh "ACPU watchdog triggered system reset!"
sh /etc/log/wdg_rstlog_save.sh AP_LOGDIR
fi

flag=$((wdtrstflag&0x2))
if [ $flag -ne 0 ]; then
sh /etc/log/reboot_history_write.sh "MCU local watchdog triggered system reset!"
sh /etc/log/wdg_rstlog_save.sh AP_LOGDIR
fi

flag=$((wdtrstflag&0x4))
if [ $flag -ne 0 ]; then
sh /etc/log/reboot_history_write.sh "MCU global watchdog triggered system reset!"
sh /etc/log/wdg_rstlog_save.sh AP_LOGDIR
fi

flag=$((wdtrstflag&0x8))
if [ $flag -ne 0 ]; then
sh /etc/log/reboot_history_write.sh "android COLD BOOT"
fi

flag=$((wdtrstflag&0x10))
if [ $flag -ne 0 ]; then
sh /etc/log/reboot_history_write.sh "android reboot! NORMAL"
fi

flag=$((wdtrstflag&0x80))
if [ $flag -ne 0 ]; then
sh /etc/log/reboot_history_write.sh "Tsensor triggered system reset!"
fi

sync

fi #end if closeflag

#make sure exc module have initialized completely 	
echo 0 > /sys/class/exc_class/exc_dev/exc
echo 1 > /sys/class/exc_class/exc_dev/value

if [ -f /proc/balong/log/fastboot ]; then
	cat /proc/balong/log/fastboot > $HISI_LOGDIR/fastboot_backup
fi


setprop ctl.start logserver
/system/bin/crashnotice -t info_system_crash

exit

