#!/system/bin/sh

TIMESTAMP=$1

AP_LOGDIR=/data/hisi_logs/ap_log/coredump

if test -f "/data/dontpanic/apanic_console"  || test -f "/data/dontpanic/apanic_threads"
then

# make sure 8sM flash space
sh /etc/log/clean_log.sh 360 ap_log

# prepare directory
sh /etc/log/prepare_dir.sh
mkdir -p $AP_LOGDIR/$TIMESTAMP
chmod 774 $AP_LOGDIR/$TIMESTAMP
chown root:system $AP_LOGDIR/$TIMESTAMP

# save the fastbootlog files
mv /data/dontpanic/apanic_console $AP_LOGDIR/$TIMESTAMP/apanic_console
mv /data/dontpanic/apanic_threads $AP_LOGDIR/$TIMESTAMP/apanic_threads
chmod 664 $AP_LOGDIR/$TIMESTAMP/*
chown root:system $AP_LOGDIR/$TIMESTAMP/*

# save log event
echo $TIMESTAMP" : dontpanic happen ..." >> $AP_LOGDIR/history.log
chmod 664 $AP_LOGDIR/history.log
chown root:system $AP_LOGDIR/history.log

sync
fi

exit

