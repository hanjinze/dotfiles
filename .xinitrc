#!/usr/local/bin/bash
if [ -f $HOME/.Xmodmap ]; then
    /usr/local/bin/xmodmap $HOME/.Xmodmap
fi

#exec awesome -c ~/.config/awesome/rc.lua >> ~/.cache/awesome/awesome.log 2>> ~/.cache/awesome/awesome-error.log
#exec openbox
xsetroot -name " " &
feh --bg-tile ~/.wallpapers/solarized.png
( sleep 3 && conky | dzen2 -xs 1 -x 500 -e '' -fg '#dcdcdc' -bg '#002b36' -ta r -fn '-*-terminus-*-*-*-*-*-*-*-*-*-*-*-*' -p ) & 
xmodmap $HOME/.Xmodmap &
exec ck-launch-session dbus-launch $HOME/dotfiles/dwm/dwm
