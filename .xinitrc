#!/usr/local/bin/bash
if [ -f $HOME/.Xmodmap ]; then
    /usr/local/bin/xmodmap $HOME/.Xmodmap
fi

#exec awesome -c ~/.config/awesome/rc.lua >> ~/.cache/awesome/awesome.log 2>> ~/.cache/awesome/awesome-error.log
#exec openbox
#exec ~/bin/conky.sh &
( sleep 3 && conky | dzen2 -xs 1 -y -1 -x '500' -e '' -fg '#dcdcdc' -bg '#262626' -ta r -fn '-*-gelly-*-*-*-*-*-*-*-*-*-*-*-*' -p ) & 
exec $HOME/.config/dwm/dwm
