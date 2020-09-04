#!/usr/bin/env bash

status_volume(){
    amixer sget Master | awk -F'[][]' '/Right:/ { print $2 }'
}

status_memory(){
    awk '/MemAvailable/ {printf( "%.2f\n", $2 / 1024 )}' /proc/meminfo
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
    LOAD="$(awk '{print $1}' /proc/loadavg)"
    CPU="$(lscpu | grep -E '^CPU\(s\)' | awk '{print $2}')"
    echo "$LOAD"/"$CPU"
}

status_caps(){
    xset q | awk '/Caps/ {print $4}'
}

status_ip(){
    ip route get 8.8.8.8 | head -1 | awk '{print $7}'
}

status_internet_access(){
    if [ "$(ping -c 1 8.8.8.8 -W 1 ; echo $?)" != "0" ] ; then
        echo yes
    else
        echo DOWN
    fi
}

status_router(){
    if [ "$(ping -c 1 192.168.1.1 -W 1 ; echo $?)" != "0" ] ; then
        echo yes
    else
        echo DOWN
    fi
}

status_date(){
    date '+%a %b %-m/%d/%Y %I:%M'
}

status_wallpaper(){
    find ~/wallpapers/ -type f | shuf | head -1 | xargs xwallpaper --maximize
}

$1
