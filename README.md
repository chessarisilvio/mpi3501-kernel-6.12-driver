# mpi3501-kernel-6.12-driver
Custom Device Tree overlay for MPI3501 3.5" TFT (ILI9486) on Raspberry Pi OS Bookworm (kernel 6.12+)

![License](https://img.shields.io/github/license/chessarisilvio/mpi3501-kernel-6.12-driver)
![Platform](https://img.shields.io/badge/platform-Raspberry%20Pi-red)
![Kernel](https://img.shields.io/badge/kernel-6.12%2B-blue)
![Driver](https://img.shields.io/badge/driver-ILI9486-green)

# MPI3501 RPi Driver

**Custom Device Tree overlay for MPI3501 3.5" TFT display (ILI9486 + XPT2046 touch) on Raspberry Pi with modern kernels (6.12+)**

## 📌 Overview

This project provides a working driver solution for the **MPI3501 3.5" GPIO TFT display** on:
- Raspberry Pi OS **Bookworm** (Debian 13)
- Kernel **6.12.47+** (or newer)
- Hardware: Raspberry Pi 3 Model B+ (compatible with Pi 2/3/4/Zero 2W)

The original vendor drivers only work on kernel 6.1 (Legacy). This repository contains:
- Custom Device Tree Source (.dts) and compiled overlay (.dtbo)
- Xorg configuration for framebuffer rendering
- Touch calibration config
- Switch scripts for TFT/HDMI modes

## ✨ Features
- ✅ Full 480x320 @ 30 FPS framebuffer support
- ✅ Touchscreen (XPT2046) with precise calibration
- ✅ Desktop environment (XFCE tested) on 3.5" display
- ✅ Easy switch between TFT and HDMI modes
- ✅ No kernel downgrade required

## 🛠️ Hardware
- **Display:** MPI3501 3.5" TFT (ILI9486 controller, SPI interface)
- **Touch:** XPT2046 resistive touchscreen
- **Connection:** GPIO header (SPI0)
- **Raspberry Pi:** 3B+ tested (should work on Pi 2/3/4/Zero 2W)

## 🚀 Installation
### Prerequisites
- Raspberry Pi 3 Model B/B+ (Pi 2/4/Zero 2W should work)
- Raspberry Pi OS **Bookworm** (Debian 13, kernel 6.12+)
- MPI3501 3.5" TFT display connected to GPIO header
- Internet connection (for package installation)

### Step 1: Update system
sudo apt update
sudo apt upgrade -y
sudo reboot

### Step 2: Clone this repository

cd ~
git clone https://github.com/chessarisilvio/mpi3501-kernel-6.12-driver.git
cd mpi3501-kernel-6.12-driver

### Step 3: Install dependencies
sudo apt install -y xserver-xorg-video-fbdev xserver-xorg-input-evdev xinput

### Step 4: Install Device Tree overlay
Copy compiled overlay to boot directory
sudo cp mpi3501-custom.dtbo /boot/firmware/overlays/

Enable overlay in config.txt
echo "dtoverlay=mpi3501-custom" | sudo tee -a /boot/firmware/config.txt

Disable conflicting KMS driver (comment out if present)
sudo sed -i 's/^dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/' /boot/firmware/config.txt

### Step 5: Install Xorg configuration
Copy display config
sudo cp 99-fbdev.conf /usr/share/X11/xorg.conf.d/

Copy touchscreen config
sudo cp 99-touch.conf /usr/share/X11/xorg.conf.d/

Keep backup copies in home
cp 99-fbdev.conf ~/
cp 99-touch.conf ~/

### Step 6: Install switch scripts
Copy scripts to home directory
cp switch-to-lcd.sh ~/
cp switch-to-hdmi.sh ~/
cp start-tft-desktop.sh ~/

Make executable
chmod +x ~/switch-to-lcd.sh ~/switch-to-hdmi.sh ~/start-tft-desktop.sh

### Step 7: Reboot
sudo reboot

### Step 8: Start desktop on TFT
After reboot, via SSH:

ssh pi@raspberrypi.local # or use IP address
~/start-tft-desktop.sh

The desktop should now appear on the 3.5" TFT display with working touch!

## 📺 Usage
### TFT Mode (3.5" display)
Switch to TFT mode
bash ~/switch-to-lcd.sh
sudo reboot

After reboot, start desktop
~/start-tft-desktop.sh

### HDMI Mode (external monitor)
Switch to HDMI mode
bash ~/switch-to-hdmi.sh
sudo reboot

Desktop will start automatically via LightDM
Or start manually:
sudo systemctl start lightdm

### Verify display is working
Check framebuffer device exists
ls -la /dev/fb1

Check driver loaded
dmesg | grep fb_ili9486

Check touchscreen
DISPLAY=:0 xinput list

## ⚙️ Advanced Configuration

### Adjust touch calibration
If touch is inverted or inaccurate, edit calibration values:
sudo nano /usr/share/X11/xorg.conf.d/99-touch.conf

Modify `Calibration` line (format: xmin xmax ymin ymax):
Option "Calibration" "200 3900 3900 200"

Run calibration tool for precise values:
DISPLAY=:0 xinput_calibrator

### Change SPI frequency (advanced)
**Warning:** Values >16 MHz may cause color corruption on some displays.

Edit source file:
nano mpi3501-custom.dts
Change line:
spi-max-frequency = <16000000>; // Try 20000000 or 24000000
Recompile and install:

dtc -I dts -O dtb -o mpi3501-custom.dtbo mpi3501-custom.dts
sudo cp mpi3501-custom.dtbo /boot/firmware/overlays/
sudo reboot

### Install desktop environment (if not present)

sudo apt install -y xfce4 xfce4-goodies lightdm

## 🔧 Recompiling from source (optional)

If you modify the `.dts` file:
Install device tree compiler
sudo apt install device-tree-compiler

Compile DTS to DTBO
dtc -I dts -O dtb -o mpi3501-custom.dtbo mpi3501-custom.dts

Install new overlay
sudo cp mpi3501-custom.dtbo /boot/firmware/overlays/
sudo reboot

## 📦 What gets installed

- `/boot/firmware/overlays/mpi3501-custom.dtbo` - Device tree overlay
- `/usr/share/X11/xorg.conf.d/99-fbdev.conf` - Display config
- `/usr/share/X11/xorg.conf.d/99-touch.conf` - Touch config
- `~/switch-to-lcd.sh` - TFT mode script
- `~/switch-to-hdmi.sh` - HDMI mode script
- `~/start-tft-desktop.sh` - Desktop launcher


## 📋 Files

- `mpi3501-custom.dts` - Device Tree Source
- `mpi3501-custom.dtbo` - Compiled overlay
- `99-fbdev.conf` - Xorg framebuffer config
- `99-touch.conf` - Touchscreen calibration
- `switch-to-lcd.sh` - Enable TFT mode
- `switch-to-hdmi.sh` - Enable HDMI mode
- `start-tft-desktop.sh` - Launch desktop on TFT

## 🔧 Technical Details

### Display specs
- Resolution: 480x320
- Interface: SPI0 (CE0)
- SPI frequency: 16 MHz
- Driver: fb_ili9486 (fbtft staging)

### GPIO mapping
- DC (Data/Command): GPIO 24
- RESET: GPIO 25
- Touchscreen pendown: GPIO 17

## Troubleshooting

### Display not working after reboot

**Symptom:** `/dev/fb1` does not exist, desktop won't start on TFT

**Solutions:**
1. Check overlay is loaded:
vcgencmd get_config int | grep dtoverlay
Should show: dtoverlay=mpi3501-custom

2. Verify overlay file exists:
ls -la /boot/firmware/overlays/mpi3501-custom.dtbo

4. Check kernel messages:
dmesg | grep -i "fb_ili9486|fbtft|spi"

5. If you see `error -EBUSY: Failed to request GPIO`, check that no other overlay is using the same GPIOs (24, 25, 17)

### Touch not responding

**Symptom:** Screen works but touch does nothing

**Solutions:**
1. Check touchscreen device exists:
DISPLAY=:0 xinput list
Should show: "ADS7846 Touchscreen"

2. If device is "floating slave", reattach it:
DISPLAY=:0 xinput reattach 6 2

3. Verify touch config is loaded:
cat /usr/share/X11/xorg.conf.d/99-touch.conf

5. Check kernel detected touchscreen:
dmesg | grep ads7846

### Touch inverted or inaccurate

**Symptom:** Touch works but coordinates are wrong (e.g., touching top moves cursor to bottom)

**Solution:**
Edit calibration values:
sudo nano /usr/share/X11/xorg.conf.d/99-touch.conf

Try these options:
- Invert Y: Change `Option "InvertY" "1"` to `"0"` (or vice versa)
- Swap axes: Change `Option "SwapAxes" "0"` to `"1"`
- Calibration values: Run `DISPLAY=:0 xinput_calibrator` and use output values

Restart X after changes:
sudo pkill Xorg
~/start-tft-desktop.sh

### Colors corrupted or wrong
**Symptom:** Display shows wrong colors, pink/green tint, or random pixels

**Solutions:**

1. **Lower SPI frequency** (most common fix):
nano mpi3501-custom.dts
Change: spi-max-frequency = <16000000>;
to: spi-max-frequency = <12000000>;

Recompile and reboot:
dtc -I dts -O dtb -o mpi3501-custom.dtbo mpi3501-custom.dts
sudo cp mpi3501-custom.dtbo /boot/firmware/overlays/
sudo reboot

2. Check display is properly seated on GPIO header

### X server fails with "no screens found"

**Symptom:** Desktop won't start, logs show `(EE) no screens found`

**Solutions:**

1. Check `/dev/fb1` exists:
ls -la /dev/fb1

3. Verify Xorg config points to correct framebuffer:
grep fbdev /usr/share/X11/xorg.conf.d/99-fbdev.conf
Should show: Option "fbdev" "/dev/fb1"

4. Make sure KMS driver is disabled in `/boot/firmware/config.txt`:
grep vc4-kms /boot/firmware/config.txt
Should be commented: #dtoverlay=vc4-kms-v3d

### HDMI not working after switching back

**Symptom:** After using TFT, HDMI shows only console or blank screen

**Solutions:**
1. Run HDMI switch script:
bash ~/switch-to-hdmi.sh
sudo reboot

2. Manually re-enable KMS:
sudo sed -i 's/^#dtoverlay=vc4-kms-v3d/dtoverlay=vc4-kms-v3d/' /boot/firmware/config.txt
sudo reboot

3. Remove TFT Xorg configs:
sudo rm /usr/share/X11/xorg.conf.d/99-fbdev.conf
sudo rm /usr/share/X11/xorg.conf.d/99-touch.conf
sudo systemctl restart lightdm

### Low FPS / laggy desktop

**Symptom:** Desktop feels slow, ~5-10 FPS

**This is normal for SPI displays.** Improvements:

1. Disable compositor in XFCE:
   - Settings → Window Manager Tweaks → Compositor → Uncheck "Enable display compositing"

2. Use lightweight theme and remove unnecessary panel widgets

3. Consider using a lighter WM:
sudo apt install openbox
Then use: DISPLAY=:0 openbox-session &

4. Check CPU temperature (throttling starts at ~80°C):
vcgencmd measure_temp

### Permission denied errors

**Symptom:** Scripts fail with permission errors

**Solution:**
chmod +x ~/switch-to-lcd.sh ~/switch-to-hdmi.sh ~/start-tft-desktop.sh

### Still not working?

1. Check full Xorg log:
cat /var/log/Xorg.0.log

2. Check system journal:
journalctl -xe

3. Open an issue on GitHub with:
   - Output of `uname -a`
   - Content of `/boot/firmware/config.txt`
   - Output of `dmesg | grep -i "fb_ili9486\|fbtft"`
   - Full `/var/log/Xorg.0.log`

## 📜 License
GPL-3.0
GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007

Copyright (C) 2025 [chessarisilvio]

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.


## Credits

Based on reverse engineering of vendor kernel 6.1 overlay.
