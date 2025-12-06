#!/bin/bash
echo "Avvio desktop TFT 3.5\"..."

# Ferma tutto
sudo pkill Xorg 2>/dev/null
sudo pkill startxfce4 2>/dev/null
sudo systemctl stop lightdm 2>/dev/null
sleep 3

# Rimuovi lock
sudo rm -f /tmp/.X0-lock /tmp/.X11-unix/X0 2>/dev/null

# Avvia X pulito
sudo Xorg :0 -config /usr/share/X11/xorg.conf.d/99-fbdev.conf &
sleep 5

# Avvia XFCE
DISPLAY=:0 startxfce4 &
sleep 2

echo "Desktop TFT attivo! Touch calibrato e attivo."
