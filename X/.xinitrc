#!/usr/bin/bash

source ~/.envrc

if [ -f .Xmodmap ]; then
    xmodmap .Xmodmap
fi

if [ -f .Xresources ]; then
    xrdb -merge .Xresources
fi

xset s off
xset -dpms

source /etc/X11/xinit/xinitrc.d/30-dbus

eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

exec keynav &
exec firefox-nightly &
exec hexchat &
exec sskype &
exec dropboxd &

exec compton &
exec awesome

