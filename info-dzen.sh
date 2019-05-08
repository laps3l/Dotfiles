!/bin/bash

FG='#000000'
BG='#000000'
fg_title='#001DFF'

font1="Inconsolata:size=10"
font_title="Inconsolata:size=10"
icons2="FontAwesome:size=11"
icons4="FontAwesome:size=9"

Disk=$(df -h / | awk 'NR==2 {total=$2; used=$3; print used" / "total}')
OS=$(sed -rn '/^NAME/ s/^NAME="?([a-z A-Z]+).?$/\1/p' /etc/os-release)
Kernel=$(uname -r)
Uptime=$(uptime -p)
Shell=$(echo "$SHELL" | awk -F/ '{for ( i=1; i <= NF; i++) sub(".", substr(toupper($i),1,1) , $i); print $NF}')
Cpu=$(awk < /proc/cpuinfo '/model name/{gsub(/[(TMR)]/,"");print $4,$5,$6,$8}' | head -1)
Gpu=$(lspci|awk '/VGA/{print $5,$8,$9}' | tr -d '[]')
Cores=$(nproc)
Motherboard=$(cat /sys/devices/virtual/dmi/id/board_{name,vendor} | awk '!(NR%2){print$1,p}{p=$0}')
Bdate=$(cat /sys/devices/virtual/dmi/id/bios_date)
Bvendor=$(awk < /sys/devices/virtual/dmi/id/bios_vendor '{print $NR,$2}')
Hd=$(cat /sys/class/block/sda/device/model)
Layout=$(setxkbmap -print | awk -F"+" '/xkb_symbols/{for ( i=1; i <= NF; i++) sub(".", substr(toupper($i),1,1) , $i); print $2}')

PACKAGES="$(
PACK=$(type apt xbps-query emerge pacman nix-env rpm apk cave gaze 2>/dev/null | grep '\/')
PACK="${PACK##*/}"
if [ "$PACK" = 'apt' ]; then
        dpkg -l | wc -l
elif [ "$PACK" = 'xbps-query' ];then
        xbps-query -l | wc -l
elif [ "$PACK" = 'emerge' ];then
        ls -d /var/db/pkg/*/* | wc -l
elif [ "$PACK" = 'pacman' ];then
        pacman -Q | wc -l
elif [ "$PACK" = 'nix-env' ];then
        ls -d -1 /nix/store/ | wc -l
elif [ "$PACK" = 'rpm' ];then
        rpm -qa | wc -l
elif [ "$PACK" = 'apk' ];then
        apk info | wc -l
elif [ "$PACK" = 'cave' ];then
        xpkgs=$(ls -d -1 /var/db/paludis/repositories/cross-installed/*/data/* | wc -l)
        pkgs=$(ls -d -1 /var/db/paludis/repositories/installed/data/* | wc -l)
        printf $((pkgs + xpkgs))
elif [ "$PACK" = 'gaze' ];then
        gaze installed | wc -l
fi
)"
De="$(
if [ ! -z "$DISPLAY" ]; then
# check if xprop is installed
if [ ! -z "$(type xprop)" ]; then
        id="$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)"
        id="${id##* }"
        if printf "$id" | grep -q "^[[:digit:]]\+$"; then
                wm="$(xprop -id "$id" -notype -len 100 -f _NET_WM_NAME 8t)"
                wm="$(printf '%s\n' "$wm" | sed -nr '/_NET_WM_NAME/ s/^.*"([a-zA-Z0-9 ()]+)"/\1/p')"
                printf "$wm"
        fi
fi

# if xprop is not installed or occur any errors, look for process
[ -z "$wm" ] && \
        ps -e | grep -v 'grep' | grep -m 1 -o -F \
        -e "i3" \
        -e "bspwm" \
        -e "dwm" \
        -e "xmonad" \
        -e "windowchef" \
        -e "openbox" \
        -e "fluxbox" \
        -e "spectrwm" \
        -e "awesome" \
        -e "dwm" \
        -e "2bwm" \
        -e "herbstluftwm" \
        -e "monsterwm" \
        -e "fvwm"
else
                printf 'none'
fi)"
Ram=$(free -mh | awk 'NR==2 {total=$2; used=$3; print used" / "total}')
Net=$(ping -W 1 -c 1 8.8.8.8 >/dev/null 2>&1 && echo On || echo Off)
Ip=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
Monitor=$(awk < /var/log/Xorg.0.log '/Display/{print $6,$7}'|tr -d '()'|sed -n '1p') 
#Keyboard=$(hwinfo --short | awk '/keyboard/ {for(i=1; i<=1; i++) {getline; print $2,$3,$NF}}')


(
 echo "   ^fg(#FCFCFC)^fn($font_title)^p(+2)^fg($fg_title)^bg(#000000) System Information "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) OS         ^fn($icons4)^fn($font1) $OS  "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) Kernel     ^fn($icons4)^fn($font1) $Kernel  "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) Uptime     ^fn($icons4)^fn($font1) $Uptime  "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) Packages   ^fn($icons4)^fn($font1) $PACKAGES  "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) Wm         ^fn($icons4)^fn($font1) $De "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) Shell      ^fn($icons4)^fn($font1) $Shell    "
 echo "   ^fg(#001DFF)------------------------------------------------------------------"
 echo "   ^fg(#FCFCFC)^fn($font_title)^p(+82)^fg($fg_title)^bg(#000000) INFO "
 echo ""
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) Processor  ^fn($icons4)^fn($font1) $Cpu    "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) CPU(s)     ^fn($icons4)^fn($font1) $Cores    "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) Monitor    ^fn($icons4)^fn($font1) $Monitor    "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) Mother     ^fn($icons4)^fn($font1) $Motherboard    "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) HD Model   ^fn($icons4)^fn($font1) $Hd    "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) Bios Date  ^fn($icons4)^fn($font1) $Bdate    "
 echo "   ^fg(#001DFF)---------------------------------------------------------------------"
 echo "   ^fg(#FCFCFC)^fn($font_title)^p(+83)^fg($fg_title)^bg(#000000) HARDWARE "
 echo ""
 echo "   ^fg(#FCFCFC)^fn($font_title)^fg($fg_title)^bg(#000000) RAM "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) Ram        ^fn($icons4)^fn($font1) $Ram  "
 echo "   ^fg(#FCFCFC)^fn($font_title)^fg($fg_title)^bg(#000000) HDD "
 echo "   ^fg(#FCFCFC)^fn($icons2)^fn($font1) Disk       ^fn($icons4)^fn($font1) $Disk  "
 echo ""
 echo "   ^fg(#001DFF)---------------------------------------------------------------------"
 echo "   ^fg(#FCFCFC)^fn($font_title)^p(+83)^fg($fg_title)^bg(#000000) MY APPS "
 echo "   ^ca(1,xst -e vim)^fg(#FCFCFC)^fn($icons2)^fn($font1) Vim ^ca() " 
 echo "   ^ca(1,xst -e ranger)^fg(#FCFCFC)^fn($icons2)^fn($font1) Ranger ^ca() "   
 echo "   ^ca(1,Telegram)^fg(#FCFCFC)^fn($icons2)^fn($font1) Telegram ^ca() "   
 echo ""

) | dzen2 -p -y 32 -w 300 -bg $BG -fg $FG -l 43 -sa l -ta c -e 'onstart=uncollapse;button1=exit;button3=exit' -fn $font1
