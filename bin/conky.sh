#!/usr/local/bin/bash

conky | while read -r; do xsetroot -name "BOTTOM=$REPLY"; done &

