#!/bin/sh

while true; do
    # --- Brightness ---
    BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/brightness)
    MAX=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    BRIGHTNESSPERCENTAGE=$(( 100 * BRIGHTNESS / MAX ))%

    
    # --- Volume ---
    MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    if [ "$MUTE" = "yes" ]; then
        VOLUME="0%"
    else
        VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)
    fi

    # --- Battery ---
    BAT=$(cat /sys/class/power_supply/BAT0/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

    # --- Wi-Fi ---
    WIFI=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active \
       | awk -F: '$2 ~ /wireless/ {print $1}')

    [ -n "$WIFI" ] || WIFI="No connection"


    # --- Print status ---
    echo "Brightness: $BRIGHTNESSPERCENTAGE | WiFi: $WIFI | Volume: $VOLUME | Battery: $BAT% ($STATUS) | $(date +'%d.%m.%Y %X')"

    sleep 5
done

