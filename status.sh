#!/usr/bin/env bash

status_volume(){
    amixer sget Master | awk -F'[][]' '/Right:/ { print $2 }'
}

status_memory(){
    awk '/MemAvailable/ {printf( "%.1fg", $2 / 1024 / 1024 )}' /proc/meminfo
}

status_battery(){
    if [ -d /sys/module/battery ] ; then
        cat /sys/class/power_supply/BAT1/capacity
    else
        echo n/a
    fi
}

status_strength(){
    if [ -d /sys/module/battery ] ; then
        INTERFACE="$(/sbin/iw dev | awk '$1=="Interface"{print $2}')"
        /sbin/iw dev "$INTERFACE" link | awk '/signal/ {print $2}'
    else
        echo n/a
    fi
}

status_network(){
    if [ -d /sys/module/battery ] ; then
        /sbin/iw dev | awk '/ssid/ {print $2}'
    else
        echo n/a
    fi
}

status_disk(){
    df -h / | awk '/dev/ {print $5}'
}

status_cpu(){
    awk '{print $1}' /proc/loadavg
}

status_caps(){
    xset q | awk '/Caps/ {print $4}'
}

status_ip(){
    ip route get 1.2.3.4 | awk '{print $7}'
}

status_router(){
    for interface in $(ls /sys/class/net/ | grep -v lo) ;
    do
      if [[ $(cat /sys/class/net/"$interface"/carrier) = 1 ]] ; then online=1 ; fi
    done
    if ! [ $online ] ; then echo "Not online" > /dev/stderr ; else echo "online" ; exit ; fi
}

status_date(){
    date '+%a %b %-m/%d/%Y %I:%M'
}

$1
