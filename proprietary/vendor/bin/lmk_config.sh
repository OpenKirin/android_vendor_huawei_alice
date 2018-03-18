#!/system/bin/sh
MemTotalStr=`cat /proc/meminfo | grep MemTotal`
MemTotal=${MemTotalStr:16:8}
# check MemTotal less than or equal 2GB
if [ $MemTotal -le 2097152 ];then
    if [ normal = $(getprop ro.runmode) ];then
        chown -h root.system /sys/module/lowmemorykiller/parameters/lmk_multi_kill
        chmod 660 /sys/module/lowmemorykiller/parameters/lmk_multi_kill
        chown -h root.system /sys/module/lowmemorykiller/parameters/lmk_multi_fadj
        chmod 660 /sys/module/lowmemorykiller/parameters/lmk_multi_fadj
        echo 1 > /sys/module/lowmemorykiller/parameters/lmk_multi_kill
        echo 529 > /sys/module/lowmemorykiller/parameters/lmk_multi_fadj
        echo "0,1,2,3,8,9" > /sys/module/lowmemorykiller/parameters/adj
        echo "18432,34560,41472,48384,55296,80640" > /sys/module/lowmemorykiller/parameters/minfree
    fi
fi
