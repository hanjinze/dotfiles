#!/bin/sh

if [ "$1" = "-window" ] ; then
    import -quality 95 $HOME/ss/`date +'%Y%m%d-%H%M%S'`-sel.png
else
    scrot '%Y%m%d-%H%M%S-full.png' -m -e 'mv $f '$HOME'/ss'
fi
