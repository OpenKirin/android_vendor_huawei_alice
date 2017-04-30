#!/system/bin/sh

SAVE_DIR=`pwd`
MEM_DUMP="memorydump"
# get the log dir like /data/hisi_logs/ap_log/coredump
if [ -n "$2" ]
then
	if [ "$2" == "$MEM_DUMP" ]
	then
	    LOGDIR=/data/hisi_logs/"$2"
	else
        LOGDIR=/data/hisi_logs/"$2"/coredump
	fi
else
	exit
fi
	
# check cd command run correctly
if [ -d "$LOGDIR" ] 
then
        cd $LOGDIR
else
	exit
fi

if [ $? != 0 ]
then
	exit
fi

if [ -n "$1" ]
then
	dlimit=$1
else
	dlimit=64
fi
	
# direcory current size
dsize=`busybox du -d 0 -m | busybox awk '{print $1}'`

# delete the oldest logfile
# only log file dir with date-time format like 20120917-085723/
# don't delete reset.log
while [ $dsize -gt $dlimit ]
do
	fname=`busybox ls -c | busybox tail -1`
	rm -r $fname
	dsize=`busybox du -d 0 -m | busybox awk '{print $1}'`
done

cd $SAVE_DIR

exit
