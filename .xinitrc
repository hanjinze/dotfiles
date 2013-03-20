if [ -f $HOME/.Xmodmap ]; then
    /usr/local/bin/xmodmap $HOME/.Xmodmap
fi

#exec awesome -c ~/.config/awesome/rc.lua >> ~/.cache/awesome/awesome.log 2>> ~/.cache/awesome/awesome-error.log
#exec openbox
exec $HOME/src/dwm/dwm
