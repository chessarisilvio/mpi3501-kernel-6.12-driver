#!/bin/bash
CONF=/boot/firmware/config.txt

# Disabilita HDMI KMS
sudo sed -i 's/^dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/' "$CONF"
sudo sed -i 's/^max_framebuffers/#max_framebuffers/' "$CONF"
sudo sed -i 's/^hdmi_force_hotplug/#hdmi_force_hotplug/' "$CONF"
sudo sed -i 's/^disable_fw_kms_setup/#disable_fw_kms_setup/' "$CONF"

# Abilita overlay TFT custom
sudo sed -i 's/^#dtoverlay=mpi3501-custom/dtoverlay=mpi3501-custom/' "$CONF"

# Ripristina config X TFT
sudo cp -f ~/99-fbdev.conf /usr/share/X11/xorg.conf.d/99-fbdev.conf
sudo cp -f ~/99-touch.conf /usr/share/X11/xorg.conf.d/99-touch.conf

echo "✅ Modalità LCD 3.5\" attivata. Riavvia con: sudo reboot"
