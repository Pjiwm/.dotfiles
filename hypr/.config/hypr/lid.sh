#!/bin/sh
# Lid switch handler for Hyprland.
# Disables the internal panel (eDP-1) on lid close ONLY when an external
# monitor is connected; re-enables it on lid open.
# When no external monitor is present, do nothing and let systemd-logind
# handle the lid (suspend).
#
# NOTE: This config uses hyprland.lua (the non-legacy parser). Runtime monitor
# changes MUST go through `hyprctl eval 'hl.monitor{...}'` — the old
# `hyprctl keyword monitor ...` silently fails under the Lua parser with
# "keyword can't work with non-legacy parsers. Use eval."

INTERNAL="eDP-1"
action="$1"   # "close" or "open"

# Number of connected monitors that are NOT the internal panel.
external_count=$(hyprctl monitors all -j | jq "[.[] | select(.name != \"$INTERNAL\")] | length")

case "$action" in
    close)
        if [ "${external_count:-0}" -gt 0 ]; then
            hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true })'
        fi
        ;;
    open)
        # Reapply the configured rule for the internal panel (scale 1.6, etc.)
        hyprctl eval 'hl.monitor({ output = "desc:BOE 0x0BC9", mode = "2560x1600@165", position = "0x0", scale = 1.6 })'
        ;;
esac
