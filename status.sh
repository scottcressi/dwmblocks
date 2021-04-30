#!/usr/bin/env sh

status_volume(){
    VOL=$(amixer sget Master | awk -F'[][]' '/Right:/ { print $2 }' | sed 's/%//g')
    if [ "$VOL" -lt 100 ] ; then
        echo VOL:"$VOL"
    fi
}

status_memory(){
    MEM=$(awk '/MemAvailable/ {print $2 / 1024}' /proc/meminfo | sed 's/\..*//g')
    if [ "$MEM" -le "2048" ] ; then
        echo MEM:"$MEM"
    fi
}

status_battery(){
    if [ -d /sys/module/battery ] ; then
        BAT=$(cat /sys/class/power_supply/BAT1/capacity)
        if [ "$BAT" -lt 50 ] ; then
            echo BAT:"$BAT" "$(cat /sys/class/power_supply/BAT1/status)"
        fi
    fi
}

status_signalstrength(){
    if [ -d /sys/module/battery ] ; then
        INTERFACE="$(/sbin/iw dev | awk '$1=="Interface"{print $2}')"
        SIG=$(/sbin/iw dev "$INTERFACE" link | awk '/signal/ {print $2}' | sed 's/-//g')
        if [ "$SIG" -gt 67 ] ; then
            echo SIG:"$SIG"
        fi
    fi
}

status_ssid(){
    if [ -d /sys/module/battery ] ; then
        SSID=$(/sbin/iw dev | awk '/ssid/ {print $2}')
        echo SSID:"$SSID"
    fi
}

status_disk(){
    DISK=$(df -h / | awk '/dev/ {print $5}' | sed 's/%//g')
    if [ "$DISK" -gt 50 ] ; then
        echo DISK:"$DISK"
    fi
}

status_cpu(){
    PROCESSORS=$(grep -c processor /proc/cpuinfo)
    MAX="$PROCESSORS"00
    LOAD=$(awk '{print $1}' /proc/loadavg | sed 's/\.//g')
    if [ "$LOAD" -ge "$MAX" ] ; then
        echo CPU:"$LOAD"
    fi
}

status_caps(){
    CAP=$(xset q | awk '/Caps/ {print $4}')
    if [ "$CAP" = "on" ] ; then
        echo CAP:"$CAP"
    fi
}

status_ip(){
    IP=$(ip route get 1.2.3.4 | awk '{print $7}')
    echo IP:"$IP"
}

status_internet(){
    #ROUTER=$(ip route | awk '/default/ {print $3}' | uniq)
    ROUTER=8.8.8.8
    if [ "$(ping -c 1 "$ROUTER" -q > /dev/null 2>&1 ; echo $?)" -ne 0 ] ; then
        echo NET:DOWN
    fi
}

status_date(){
    date '+%a %b %-m/%d/%Y %_I:%M %S'
}

status_containers(){
    CONTAINER=$(pgrep -c containerd-shim)
    if [ "$CONTAINER" -ne 0 ] ; then
        echo CONTAINER: "$CONTAINER"
    fi
}

status_mounts(){
    MOUNT=$(grep -c 'cifs\|nfs' /etc/mtab)
    if [ "$MOUNT" -ne 0 ] ; then
        echo MOUNT: "$MOUNT"
    fi
}

status_vpn(){
    VPN=$(ip tuntap | wc -l)
    if [ "$VPN" = 0 ] ; then
        echo VPN:DOWN
    fi
}

$1
