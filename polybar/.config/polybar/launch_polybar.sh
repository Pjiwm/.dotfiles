if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar -c ~/.config/polybar/config.ini --reload main &
  done
else
  polybar -c ~/.config/polybar/config.ini --reload main &
fi
