#!/usr/bin/env bash

# https://github.com/noctuid/zscroll#use-with-polybar
zscroll --delay 0.2 \
        --length 25 \
        --update-check true \
        "/home/minhduc0711/.config/polybar/scripts/player-mpris-tail.py status -f '{title} - {artist}'" &
wait
