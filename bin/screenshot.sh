#!/bin/bash
cd ~/ss
eval $( tr '\0' '\n' < /proc/`pidof awesome`/environ | grep -e DISPLAY -e XAUTHORITY ) scrot
