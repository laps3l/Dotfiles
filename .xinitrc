## Set cursor
xsetroot -cursor_name left_ptr

### Suspend off
xset dpms 0 0 0 &
xset -dpms &
xset s noblank &
xset s off &

## Update Xresources
xrdb -load ~/.Xresources

### Startup
hsetroot -fill /home/laps3/Pictures/Wallpapers/minimalist1.jpg &

## Load fonts
xset +fp /usr/share/fonts
xset fp rehash

## Startx
exec xmonad
