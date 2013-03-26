#!/usr/local/bin/bash
if [ -f $HOME/.Xmodmap ]; then
    /usr/local/bin/xmodmap $HOME/.Xmodmap
fi

#exec awesome -c ~/.config/awesome/rc.lua >> ~/.cache/awesome/awesome.log 2>> ~/.cache/awesome/awesome-error.log
#exec openbox
xsetroot -name " " &
feh --no-xinerama --bg-center ~/.wallpapers/LightningColor.png
( sleep 3 && conky | dzen2 -xs 1 -x 500 -e '' -fg '#dcdcdc' -bg '#262626' -ta r -fn '-*-montecarlo-medium-*-*-*-*-*-*-*-*-*-*-*' -p ) & 
exec $HOME/.config/dwm/dwm
