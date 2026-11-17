#!/bin/sh

PROFILE="cmatrix"

pkill -f 'cmatrix-screensaver-terminal' 2>/dev/null
sleep 0.3

gnome-terminal \
    --profile="$PROFILE" \
    --title="cmatrix-screensaver-terminal-1" \
    --full-screen \
    --hide-menubar \
    -- cmatrix -C magenta -u 6 &

sleep 0.5

gnome-terminal \
    --profile="$PROFILE" \
    --title="cmatrix-screensaver-terminal-2" \
    --full-screen \
    --hide-menubar \
    -- cmatrix -C cyan -u 6 &

exit 0
