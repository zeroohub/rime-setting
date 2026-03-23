#!/bin/bash
# Restart fcitx5 via KWin's VirtualKeyboard DBus interface.
# This ensures fcitx5-wayland-launcher is properly restarted by KWin,
# fixing candidate window position offset after hotplugging an external monitor.

echo "Waiting for display configuration to settle..."
sleep 2

echo "Disabling KWin VirtualKeyboard..."
qdbus6 org.kde.KWin /VirtualKeyboard \
    org.freedesktop.DBus.Properties.Set \
    org.kde.kwin.VirtualKeyboard enabled "false"

sleep 1

echo "Re-enabling KWin VirtualKeyboard..."
qdbus6 org.kde.KWin /VirtualKeyboard \
    org.freedesktop.DBus.Properties.Set \
    org.kde.kwin.VirtualKeyboard enabled "true"

sleep 2

if pgrep -f "fcitx5-wayland-launcher" > /dev/null; then
    echo "fcitx5 restarted successfully."
else
    echo "Warning: fcitx5-wayland-launcher not found, restart may have failed."
fi
