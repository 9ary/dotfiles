#!/usr/bin/zsh

setopt nobgnice

systemd_setup=/etc/sway/conf.d/10-systemd.conf
[[ -x $systemd_setup ]] && $systemd_setup

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
    dunst -config ~/dotfiles/dunstrc &
fi

if [[ "$HOST" == "Hitagi" ]]; then
    dunst -config ~/dotfiles/dunstrc \
        -geometry "300x5-20+20" -font "Ubuntu Mono 11.5" &
    pkill libinput-debug-; libinput-gestures &
    swayidle -w before-sleep 'swaylock -fFc 333333' &
fi
