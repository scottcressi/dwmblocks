#!/usr/bin/env bash

status_volume(){
    amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }'
}

status_memory(){
    free -h | awk '/^Mem/ { print $3"/"$2 }' | sed s/i//g
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
        /sbin/iwconfig "$INTERFACE" | grep Signal | awk '{print $4,$5}' | sed 's/level=//g'
    else
        echo n/a
    fi
}

status_network(){
    if [ -d /sys/module/battery ] ; then
        INTERFACE="$(/sbin/iw dev | awk '$1=="Interface"{print $2}')"
        /sbin/iwconfig "$INTERFACE" | grep ESSID | awk '{print $4}' | sed 's/ESSID://g' | sed 's/"//g'
    else
        echo n/a
    fi
}

status_disk(){
    df -h / | grep dev | awk '{print $5}'
}

status_cpu(){
    LOAD="$(awk '{print $1}' /proc/loadavg)"
    CPU="$(lscpu | grep -E '^CPU\(s\)' | awk '{print $2}')"
    echo "$LOAD"/"$CPU"
}

status_caps(){
    xset q | grep Caps | awk '{print $4}'
}

status_ip(){
    ip route get 8.8.8.8 | head -1 | awk '{print $7}'
}

status_date(){
    date '+%a %b %-m/%d/%Y %I:%M'
}

status_wallpaper(){
    find ~/wallpapers/ -type f | shuf | head -1 | xargs xwallpaper --maximize
}

$1
