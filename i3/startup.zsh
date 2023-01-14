#!/usr/bin/zsh

i3_config="$1"

setopt nobgnice

swayidle -w before-sleep "swaylock -fFc CDCDCD" &

xrdb ~/dotfiles/x/Xresources

import-gsettings \
    gtk-theme:gtk-theme-name \
    icon-theme:gtk-icon-theme-name \
    cursor-theme:gtk-cursor-theme-name \
    font-name:gtk-font-name

udiskie -s --appindicator &
wlsunset -t 3400 -l 32 -L 35 &

$BROWSER &
$TERMINAL -a senpai senpai-irc &
telegram-desktop &
transmission-gtk -m &

pkill dunst
if [[ "$HOST" == "Akatsuki" ]]; then
    "${i3_config}"/ws-1.py &
    dunst -config ~/dotfiles/dunstrc \
        -geometry "600x5+1620-48" -font "Ubuntu Mono 15" &
else
    dunst -config ~/dotfiles/dunstrc &
fi
"${i3_config}"/dunst-fullscreen-inhibitor.py
