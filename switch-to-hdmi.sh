#!/bin/bash
CONF=/boot/firmware/config.txt

# Disabilita TFT custom
sudo sed -i 's/^dtoverlay=mpi3501-custom/#dtoverlay=mpi3501-custom/' "$CONF"

# Abilita HDMI KMS
sudo sed -i 's/^#dtoverlay=vc4-kms-v3d/dtoverlay=vc4-kms-v3d/' "$CONF"
sudo sed -i 's/^#max_framebuffers/max_framebuffers/' "$CONF"
sudo sed -i 's/^#hdmi_force_hotplug/hdmi_force_hotplug/' "$CONF"
sudo sed -i 's/^#disable_fw_kms_setup/disable_fw_kms_setup/' "$CONF"

# Rimuove eventuali config Xorg del TFT
sudo rm -f /usr/share/X11/xorg.conf.d/99-fbdev.conf /usr/share/X11/xorg.conf.d/99-touch.conf 2>/dev/null

echo "✅ Modalità HDMI attivata. Riavvia con: sudo reboot"
