#!/system/bin/sh

AP_LOGDIR=/data/hisi_logs/ap_log/coredump
CP_LOGDIR=/data/hisi_logs/cp_log/coredump
HIFI_LOGDIR=/data/hisi_logs/hifi_log/coredump
DUMP_DIR=/data/hisi_logs/memorydump

# if direcory not existed ,then create it
if [ ! -d $AP_LOGDIR ];then
mkdir -p $AP_LOGDIR
chmod 774 $AP_LOGDIR
chown root:system $AP_LOGDIR
chmod 774 /data/hisi_logs/ap_log
chown root:system /data/hisi_logs/ap_log
chmod 774 /data/hisi_logs
chown root:system /data/hisi_logs
fi

if [ ! -d $CP_LOGDIR ];then
mkdir -p $CP_LOGDIR
chmod 774 $CP_LOGDIR
chown root:system $CP_LOGDIR
chmod 774 /data/hisi_logs/cp_log
chown root:system /data/hisi_logs/cp_log
chmod 774 /data/hisi_logs
chown root:system /data/hisi_logs
fi

if [ ! -d $HIFI_LOGDIR ];then
mkdir -p $HIFI_LOGDIR
chmod 774 $HIFI_LOGDIR
chown root:system $HIFI_LOGDIR
chmod 774 /data/hisi_logs/hifi_log
chown root:system /data/hisi_logs/hifi_log
chmod 774 /data/hisi_logs
chown root:system /data/hisi_logs
fi

if [ ! -d $DUMP_DIR ];then
mkdir -p $DUMP_DIR
chmod 774 $DUMP_DIR
chown root:system $DUMP_DIR
chmod 774 /data/hisi_logs
chown root:system /data/hisi_logs
fi

exit

