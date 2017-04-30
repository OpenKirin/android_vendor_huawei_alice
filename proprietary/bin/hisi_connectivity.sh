#!/system/bin/sh

function mk_dirs()
{
    umask 002
    chmod 660 /dev/hwfm
    chown system:system /dev/hwfm
    chmod 660 /dev/hwgnss
    chown system:system /dev/hwgnss
    chmod 660 /sys/devices/hi110x_ps/gnss_lowpower_state
    chown system:system /sys/devices/hi110x_ps/gnss_lowpower_state

    chmod 660 /dev/hwbt
    chown bluetooth:bluetooth /dev/hwbt
    chmod 660 /dev/hwbfgdbg
    chmod 660 /dev/hwcoexist
    echo 1 > /sys/devices/hi110x_ps/bfg_lowpower_enable

    chmod 660 /sys/devices/hi110x_power/powerpin_state
    echo 12 > /sys/devices/hi110x_power/powerpin_state

    mkdir -p /data/gnss/pgps
    chown system:system /data/gnss
    chown system:system /data/gnss/pgps
    mkdir -p /data/hwlogdir/gnss_log/device/
    chown system:system /data/hwlogdir
    mkdir -p /data/hwlogdir/gnss_log/eph_alm
    chown system:system /data/hwlogdir/gnss_log/eph_alm

    mkdir -p /data/hwlogdir/chr_log

    chmod 660 /dev/chrKmsgWifi
    chown system:system /dev/chrKmsgWifi
    chmod 660 /dev/chrKmsgBFG
    chown system:system /dev/chrKmsgBFG
    chmod 660 /dev/chrAppWifi
    chown wifi:wifi /dev/chrAppWifi
    chmod 660 /dev/chrAppBt
    chown bluetooth:bluetooth /dev/chrAppBt
    chmod 660 /dev/chrAppGnss
    chown system:system /dev/chrAppGnss

    mkdir -p /data/hwlogdir/wifi_log
    mkdir -p /data/hwlogdir/wifi_log/dump
    mkdir -p /data/hwlogdir/bfg_log

    mkdir -p /data/hwlogdir/exception/

    chmod 0666 /data/misc/wifi/wpa_supplicant.conf
}

function load_drivers()
{
    #insmod /system/lib/wifi.ko
    #insmod /system/lib/oamdrv.ko
}
function main_user()
{
    local mode
    mode=$1

    if [ $mode != "recovery" ] ; then
	mk_dirs
    fi

    load_drivers

    if [ $mode != "recovery" ] ; then
        /system/bin/ini_start&
    fi
}

#--------------------main-----------------
#in normal mode, the service run without argument.
#in recovery mode, the service run with argument "recovery"
if [ $# != 0 ] ; then
    main_user $@
else
    main_user normal
fi

exit
