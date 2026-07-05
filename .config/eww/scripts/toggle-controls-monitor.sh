#!/bin/sh

windows="device-control music-window resource-monitor"

all_open=true
for name in $windows; do
  if ! eww -c "$HOME/.config/eww" active-windows | grep -qw "$name"; then
    all_open=false
    break
  fi
done

if $all_open; then
  eww -c "$HOME/.config/eww" close $windows
else
  eww -c "$HOME/.config/eww" open-many $windows
fi
