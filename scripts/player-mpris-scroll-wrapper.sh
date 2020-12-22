#!/usr/bin/env bash

# https://github.com/noctuid/zscroll#use-with-polybar
$HOME/miniconda3/bin/zscroll --delay 0.2 \
        --length 25 \
        --update-check true \
        "$HOME/.local/bin/player-mpris-tail.py status -f '{title} - {artist}'"
