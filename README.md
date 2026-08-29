# Raspberry Pi Composite Delay

## Install

Use [raspi-imager](https://www.raspberrypi.com/software/) and select "Raspberry Pi OS Lite" (in other options)

Boot the Raspberry Pi and install project:

```bash
sudo apt update
sudo apt install -y git
sudo chmod a+rwx /opt
cd /opt
git clone --recursive https://github.com/below-industries/rasp-composite-delay
cd rasp-composite-delay

make install-5 # raspberry pi 5
make install-4 # raspberry pi 4

reboot
```
