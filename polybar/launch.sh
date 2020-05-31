#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
    for m in $(polybar --list-monitors | cut -d":" -f1); do
        MONITOR=$m polybar -c ~/.config/polybar/config.ini main &
    done
else
    polybar -c ~/.config/polybar/config.ini main &
fi