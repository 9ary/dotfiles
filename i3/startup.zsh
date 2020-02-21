#!/usr/bin/zsh

setopt nobgnice

xrdb ~/dotfiles/x/Xresources

import-gsettings \
    gtk-theme:gtk-theme-name \
    icon-theme:gtk-icon-theme-name \
    cursor-theme:gtk-cursor-theme-name \
    font-name:gtk-font-name

udiskie -s &
redshift &
pidof ydotoold || ydotoold &
~/dotfiles/i3/fullscreen-manager.py &

$BROWSER &
$TERMINAL -name WeeChat -e weechat &
telegram-desktop &
qbittorrent &

if [[ "$HOST" == "Akatsuki" ]]; then
    mako --anchor bottom-center --width 600 --font "Ubuntu Mono 15" &
else
    mako &
fi

if [[ "$HOST" == "Hitagi" ]]; then
    pkill libinput-debug-; libinput-gestures &
    swayidle -w before-sleep 'swaylock -fFc 333333' &
fi
