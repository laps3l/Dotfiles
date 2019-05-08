#!/bin/bash

TODAY="$(($(date +'%d') + 0))"
#MONTH="$(date +'%m')"
#YEAR="$(date +'%Y')"

(
echo " ^fg(#FCFCFC)^fn(FontAwesome:size=12)^fg(#dcdcdc)^fn(Inconsolata:pixelsize=12:antialias=True:hinting=True) Calendar"; echo
\
cal -w | sed -re "s/^(.*[A-Za-z][A-Za-z]*.*)$/^fg(#2D2D2D)^bg(#001DFF)\1/;s/(^|[ ])($TODAY)($|[ ])/\1^bg(#001DFF)^fg(#232323)\2^fg(#6C6C6C)^bg(#232323)\3/"
sleep 20
) | dzen2 -fg '#FCFCFC' -bg '#232323' -fn 'Inconsolata:pixelsize=12:antialias=True:hinting=True' -x 1223 -y 32 -w 143 -l 9 -sa c -e 'onstart=uncollapse;button3=exit'
