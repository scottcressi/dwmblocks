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
    MAX="$PROCESSORS"00
    LOAD=$(awk '{print $1}' /proc/loadavg | sed 's/\.//g')
    if [ "$LOAD" -ge "$MAX" ] ; then
        echo CPU:"$LOAD |"
    fi
}

status_caps(){
    CAP=$(xset q | awk '/Caps/ {print $4}')
    if [ "$CAP" = "on" ] ; then
        echo CAP:"$CAP |"
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
    date '+%a %b %-m/%d/%g%_I:%M'
}

status_containers(){
    CONTAINER=$(pgrep -c containerd-shim)
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

status_vpn(){
    VPN=$(ip tuntap | wc -l)
    LOCATION=$(grep Connected /var/log/mullvad-vpn/daemon.log | tail -1 | sed 's/.*country: //g' | sed 's/, latitude.*//g' | sed 's/, city: Some(//g' | sed 's/)//g')
    if [ "$VPN" = 0 ] ; then
        echo "VPN:DOWN |"
    else
        echo "VPN:$LOCATION |"
    fi
}

status_vpn_blocked(){
    BLOCKED=$(mullvad always-require-vpn get | awk '{print $5}')
    if [ "$BLOCKED" = "blocked" ] ; then
        echo "vpn blocking on |"
    fi
}

status_brightness(){
    BRIGHTNESS=$(xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' ')
    if [ "$BRIGHTNESS" != 1.0 ] ; then
        echo BRIGHTNESS:"$BRIGHTNESS |"
    fi
}

status_wallpaper(){
    find ~/wallpapers/ -maxdepth 1 -type f | shuf | head -1 | xargs xwallpaper --maximize
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
    echo ; echo brightness ; time status_brightness ; echo
    echo ; echo wallpaper ; time status_wallpaper ; echo
}

$1
