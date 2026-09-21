if [ -d /opt/local/bin ]; then
    PATH="/opt/local/bin:${PATH}"
fi
if [ -d /opt/vc/bin ]; then
    PATH="/opt/vc/bin:${PATH}"
fi
export PATH

alias rpi-temp='vcgencmd measure_temp 2>/dev/null || awk "{printf \"%.1f°C\n\", \$1/1000}" /sys/class/thermal/thermal_zone0/temp 2>/dev/null'
alias rpi-clock='vcgencmd measure_clock arm 2>/dev/null'
alias rpi-throttled='vcgencmd get_throttled 2>/dev/null'
alias rpi-mem='vcgencmd get_mem arm 2>/dev/null; vcgencmd get_mem gpu 2>/dev/null'

rpi-info() {
    echo "=== Raspberry Pi Status ==="
    [ -f /proc/device-tree/model ] && echo "Model:    $(tr -d '\0' </proc/device-tree/model 2>/dev/null)"
    echo "Temp:     $(vcgencmd measure_temp 2>/dev/null || awk '{printf "%.1f°C\n", $1/1000}' /sys/class/thermal/thermal_zone0/temp 2>/dev/null)"
    echo "Clock:    $(vcgencmd measure_clock arm 2>/dev/null || echo 'N/A')"
    echo "Throttle: $(vcgencmd get_throttled 2>/dev/null || echo 'N/A')"
    echo "Memory:   $(vcgencmd get_mem arm 2>/dev/null) / $(vcgencmd get_mem gpu 2>/dev/null)"
}
