#!/usr/bin/zsh

i3_config="$1"

setopt nobgnice

swaylock='swaylock -fFc CDCDCD'
eval $swaylock
swayidle -w before-sleep "$swaylock" &

xrdb ~/dotfiles/x/Xresources

import-gsettings \
    gtk-theme:gtk-theme-name \
    icon-theme:gtk-icon-theme-name \
    cursor-theme:gtk-cursor-theme-name \
    font-name:gtk-font-name

udiskie -s --appindicator &
redshift-gtk &

$BROWSER &
$TERMINAL -a WeeChat weechat &
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

if [[ "$HOST" == "Hitagi" ]]; then
    pkill gebaard; gebaard &
fi
