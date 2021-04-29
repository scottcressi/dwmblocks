#!/usr/bin/env sh

status_volume(){
    VOL=$(amixer sget Master | awk -F'[][]' '/Right:/ { print $2 }')
    echo VOL:"$VOL"
}

status_memory(){
    MEM=$(awk '/MemAvailable/ {printf( "%.1fg", $2 / 1024 / 1024 )}' /proc/meminfo)
    echo MEM:"$MEM"
}

status_battery(){
    if [ -d /sys/module/battery ] ; then
        BAT=$(cat /sys/class/power_supply/BAT1/capacity)
        echo BAT:"$BAT"
        if [ "$BAT" -lt 10 ] ; then
            notify-send --expire-time 1000 --urgency critical "$(date)" "BATTERY LOW"
        fi
    fi
}

status_signalstrength(){
    if [ -d /sys/module/battery ] ; then
        INTERFACE="$(/sbin/iw dev | awk '$1=="Interface"{print $2}')"
        SIG=$(/sbin/iw dev "$INTERFACE" link | awk '/signal/ {print $2}')
        echo SIG:"$SIG"
    fi
}

status_ssid(){
    if [ -d /sys/module/battery ] ; then
        SSID=$(/sbin/iw dev | awk '/ssid/ {print $2}')
        echo SSID:"$SSID"
    fi
}

status_disk(){
    DISK=$(df -h / | awk '/dev/ {print $5}')
    echo DISK:"$DISK"
}

status_cpu(){
    CPU=$(awk '{print $1}' /proc/loadavg)
    echo CPU:"$CPU"
}

status_caps(){
    CAP=$(xset q | awk '/Caps/ {print $4}')
    echo CAP:"$CAP"
}

status_ip(){
    IP=$(ip route get 1.2.3.4 | awk '{print $7}')
    echo IP:"$IP"
}

status_internet(){
    #ROUTER=$(ip route | awk '/default/ {print $3}' | uniq)
    ROUTER=8.8.8.8
    if [ "$(ping -c 1 "$ROUTER" -W 10 -q > /dev/null 2>&1 ; echo $?)" = "0" ] ; then
        echo NET:up
    else
        echo NET:DOWN
    fi
}

status_date(){
    date '+%a %b %-m/%d/%Y %_I:%M %S'
}

status_containers(){
    CONTAINER=$(pgrep -c containerd-shim)
    echo CONTAINER:"$CONTAINER"
}

status_mounts(){
    MOUNT=$(grep -c 'cifs\|nfs' /etc/mtab)
    echo MOUNT:"$MOUNT"
}

status_vpn(){
    VPN=$(ip tuntap | wc -l)
    if [ "$VPN" = 1 ] ; then
        echo VPN:up
    else
        echo VPN:down
    fi
}

$1
