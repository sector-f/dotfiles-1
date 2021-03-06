#!/bin/sh
# Uses X resources to only run once per X11


PROP=autostart.wasrun
HASPROP=$(xrdb -query|grep $PROP)

if [ "$HASPROP" != "" ]
then
  exit 0;
fi

echo "$PROP: on" | xrdb -merge

killall nm-applet || true
XDG_CONFIG_HOME=$HOME/.config/bspwm/theme_overrides nm-applet &

mpd

{ killall mpdscribble; sleep 4; mpdscribble; } &
#{ killall mpdas; sleep 4; mdpas; } &

randwallpaper

#cadence-session-start --system-start &

