#!/bin/bash

current_im=$(fcitx5-remote -n)
case "$current_im" in
    "mozc") echo "日本語" ;;
    "keyboard-us") echo "English" ;;
    *) echo "$current_im" ;;
esac
