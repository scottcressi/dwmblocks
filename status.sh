#!/usr/bin/env sh

status_volume(){
    VOL=$(amixer sget Master | awk -F'[][]' '/Right:/ { print $2 }' | sed 's/%//g')
    if [ "$VOL" -ne 100 ] ; then
        echo VOL:"$VOL |"
    fi
}

status_memory(){
    MEM=$(awk '/MemAvailable/ {print $2 / 1024}' /proc/meminfo | sed 's/\..*//g')
    if [ "$MEM" -le "2048" ] ; then
        echo MEM:"$MEM |"
    fi
}

status_battery(){
    if [ -d /sys/module/battery ] ; then
        BAT=$(cat /sys/class/power_supply/BAT1/capacity)
        if [ "$BAT" -lt 20 ] ; then
            echo BAT:"$BAT" "$(cat /sys/class/power_supply/BAT1/status) |"
        fi
    fi
}

status_signalstrength(){
    if [ -d /sys/module/battery ] ; then
        INTERFACE="$(/sbin/iw dev | awk '$1=="Interface"{print $2}')"
        SIG=$(/sbin/iw dev "$INTERFACE" link | awk '/signal/ {print $2}' | sed 's/-//g')
        if [ "$SIG" -gt 80 ] ; then
            echo "SIG: unstable |"
        elif [ "$SIG" -gt 90 ] ; then
            echo "SIG: unusable |"
        fi
    fi
}

status_ssid(){
    if [ -d /sys/module/battery ] ; then
        SSID=$(/sbin/iw dev | awk '/ssid/ {print $2}')
        if [ "$SSID" = "" ] ; then
            echo "SSID NOT CONNECTED |"
        fi
    fi
}

status_disk(){
    DISK=$(df -h / | awk '/dev/ {print $5}' | sed 's/%//g')
    if [ "$DISK" -gt 50 ] ; then
        echo DISK:"$DISK |"
    fi
}

status_cpu(){
    PROCESSORS=$(grep -c processor /proc/cpuinfo)
    MAX=$(($PROCESSORS / 2))00
    LOAD=$(awk '{print $1}' /proc/loadavg | sed 's/\.//g')
    if [ "$LOAD" -ge "$MAX" ] ; then
        echo CPU:"$LOAD |"
    fi
}

status_caps(){
    CAP=$(cat /sys/devices/platform/i8042/serio0/input/input0/input0::capslock/brightness)
    if [ "$CAP" = 1 ] ; then
        echo CAP:"on |"
    fi
}

status_ip(){
    IP=$(ip route get 1.2.3.4 | awk '{print $7}')
    echo IP:"$IP |"
}

status_internet(){
    #ROUTER=$(ip route | awk '/default/ {print $3}' | uniq)
    ROUTER=8.8.8.8
    if [ "$(ping -c 1 "$ROUTER" -W 1 -q > /dev/null 2>&1 ; echo $?)" -ne 0 ] ; then
        echo "NET:DOWN |"
    fi
}

status_date(){
    date '+%a %b %-m/%d/%g %_I:%M'
}

status_containers(){
    CONTAINER=$(sudo ls /var/lib/docker/containers/ | wc -l)
    if [ "$CONTAINER" -ne 0 ] ; then
        echo CONTAINER: "$CONTAINER |"
    fi
}

status_mounts(){
    MOUNT=$(grep -c 'cifs\|nfs' /etc/mtab)
    if [ "$MOUNT" -ne 0 ] ; then
        echo MOUNT: "$MOUNT |"
    fi
}

status_vpn_location(){
    VPN=$(mullvad status | grep -c Connected)
    LOCATION=$(mullvad status --location | grep Location:)
    if [ "$VPN" = 1 ] ; then
        echo "$LOCATION |"
    fi
}

status_vpn(){
    VPN=$(mullvad status | grep -c Connected)
    if [ "$VPN" != 1 ] ; then
        echo "VPN:DOWN |"
    fi
}

status_vpn_blocked(){
    BLOCKED=$(mullvad always-require-vpn get | awk '{print $5}')
    if [ "$BLOCKED" = "allowed" ] ; then
        echo "vpn blocking off |"
    fi
}

status_brightness(){
    BRIGHTNESS=$(cat /sys/class/backlight/*/brightness)
    if [ "$BRIGHTNESS" != 1500 ] ; then
        echo BRIGHTNESS:"$BRIGHTNESS |"
    fi
}

status_wallpaper(){
    find ~/wallpapers/ -maxdepth 1 -type f | shuf | head -1 | xargs xwallpaper --maximize
}

status_git(){
    COUNTER=0
    #FOO=$(( $COUNTER+1 ))
    #echo $FOO
    for i in $(find ~/repos/personal -maxdepth 1 -mindepth 1 -type d) ; do
        CHANGES=$(git -C "$i" status -s | wc -l)
        COUNTER=$(( $COUNTER+$CHANGES ))
    done
    if [ $COUNTER != 0 ] ; then
        echo GIT:"$COUNTER |"
    fi
}

status_updates(){
    sudo apt-get update -q -q
    PACKAGES=$(apt-get -s dist-upgrade | grep "^[[:digit:]]\\+ upgraded" | sed 's/installed.*/installed/g')
    echo PACKAGES:"$PACKAGES |"
}

time_status(){
    echo ; echo volume ; time status_volume ; echo
    echo ; echo memory ; time status_memory ; echo
    echo ; echo battery ; time status_battery ; echo
    echo ; echo strength ; time status_signalstrength ; echo
    echo ; echo ssid ; time status_ssid ; echo
    echo ; echo disk ; time status_disk ; echo
    echo ; echo cpu ; time status_cpu ; echo
    echo ; echo caps ; time status_caps ; echo
    echo ; echo ip ; time status_ip ; echo
    echo ; echo internet ; time status_internet ; echo
    echo ; echo date ; time status_date ; echo
    echo ; echo containers ; time status_containers ; echo
    echo ; echo mounts ; time status_mounts ; echo
    echo ; echo vpn ; time status_vpn ; echo
    echo ; echo vpn_blocked ; time status_vpn_blocked ; echo
    echo ; echo brightness ; time status_brightness ; echo
    echo ; echo wallpaper ; time status_wallpaper ; echo
    echo ; echo git ; time status_git ; echo
    echo ; echo updates ; time status_updates ; echo
}

$1
