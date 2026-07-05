#!/bin/sh

fallback="$HOME/.config/eww/icons/music-solid.png"
last=""

playerctl --follow metadata --format '{{mpris:artUrl}}' 2>/dev/null | while IFS= read -r art; do
  if [ -n "$art" ]; then
    last="$art"
    printf '%s\n' "$art"
  elif [ -n "$last" ]; then
    printf '%s\n' "$last"
  else
    printf '%s\n' "$fallback"
  fi
done
