#!/usr/bin/bash

source ~/.envrc

if [ -f .Xresources ]; then
    xrdb -merge -override .Xresources
fi

# Disable this shitty power saving
xset s off
xset -dpms

# Don't ring bells
xset b off

source /etc/X11/xinit/xinitrc.d/30-dbus
pulseaudio --start

eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

exec keynav &
exec redshift-gtk &
exec firefox-nightly &
exec $TERMINAL -title "WeeChat" -e weechat &
exec sskype &
exec dropboxd &

exec compton &
exec awesome

