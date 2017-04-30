#!/system/bin/sh

# log dir define
DUMP_DIR=/data/hisi_logs/memorydump
MCU_LOGDIR_STRING="MCU_LOGDIR"
AP_LOGDIR_STRING="AP_LOGDIR"

if [ "$1" == "$AP_LOGDIR_STRING" ]
then
	TEMP=/data/hisi_logs/ap_log/coredump
fi

if [ "$1" == "$MCU_LOGDIR_STRING" ]
then
	TEMP=/data/hisi_logs/mcu_log/coredump
fi

# make sure 4M flash space
sh /etc/log/clean_log.sh 360 ap_log
sh /etc/log/clean_log.sh 50 memorydump
# export TIMESTAMP for log tag
export TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# prepare directory
sh /etc/log/prepare_dir.sh
mkdir -p $TEMP/$TIMESTAMP
chmod 774 $TEMP/$TIMESTAMP
mkdir -p $DUMP_DIR/$TIMESTAMP
chmod 774 $DUMP_DIR/$TIMESTAMP
chown root:system $TEMP/$TIMESTAMP
chown root:system $DUMP_DIR/$TIMESTAMP

# save log file
cat /proc/balong/memory/acpu_rstlog > $TEMP/$TIMESTAMP/a_mntn.bin
cat /proc/balong/memory/acpu_rstsram > $TEMP/$TIMESTAMP/sram_acpu_memory.bin
cat /proc/balong/memory/mcu_rstsram > $TEMP/$TIMESTAMP/sram_mcu_memory.bin
cat /proc/balong/memory/mcu_rstsys > $TEMP/$TIMESTAMP/mcu_memory.bin
cat /proc/balong/memory/modem_rstlog > $TEMP/$TIMESTAMP/modem_log.bin
cat /proc/balong/memory/telemntn_area > $TEMP/$TIMESTAMP/telemntn_memory.bin
cat /mnt/pstore/* > $TEMP/$TIMESTAMP/last_kmsg
cat /proc/last_kirq > $TEMP/$TIMESTAMP/last_kirq
cat /proc/last_ktask > $TEMP/$TIMESTAMP/last_ktask
if [ -f /proc/balong/log/fastboot ]; then
	cat /proc/balong/log/fastboot > $TEMP/$TIMESTAMP/fastboot_log_current
fi
if [ -f /data/hisi_logs/fastboot_backup ]; then
	cat /data/hisi_logs/fastboot_backup > $TEMP/$TIMESTAMP/fastboot_log_last
fi

if [ -f "/proc/balong/memory/dump_low128M" ]; then
cat /proc/balong/memory/dump_low128M > $DUMP_DIR/$TIMESTAMP/dump_low_memory.lzf
fi
if [ -f "/proc/balong/memory/dump_kernel360M" ]; then
cat /proc/balong/memory/dump_kernel360M > $DUMP_DIR/$TIMESTAMP/dump_kernel_memory.lzf
fi
chmod 664 $TEMP/$TIMESTAMP/*
chmod 664 $DUMP_DIR/$TIMESTAMP/*
chown root:system $TEMP/$TIMESTAMP/*
chown root:system $DUMP_DIR/$TIMESTAMP/*

sync

exit

