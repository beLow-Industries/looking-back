# Looking Back

> Raspberry Pi Composite Delay

## 0. Prepare Raspberry Pi

Plug-in:

* Keyboard
* HDMI display
* USB Video capture device
* Composite output cable

## 1. Install

Use [raspi-imager](https://www.raspberrypi.com/software/) and select "Raspberry Pi OS Lite" (in other options)

## 2. Add project to rasp

### 2.A. Move file before inserting card

```bash
# if mounted to /run/media/(user)/rootfs
sudo chmod a+rwx /run/media/$(whoami)/rootfs/opt/
cp -r . /run/media/$(whoami)/rootfs/opt/
sudo umount -R /run/media/$(whoami)/rootfs
sudo umount -R /run/media/$(whoami)/bootfs
```

Boot the Raspberry Pi and login

### 2.B. Clone project from remote

Boot the Raspberry Pi and login

```bash
sudo apt update
sudo apt install -y git
sudo chmod a+rwx /opt
cd /opt
git clone --recursive https://github.com/below-industries/looking-back
cd looking-back
```

## 3. Install the project

```bash
make install-5 # raspberry pi 5
make install-4 # raspberry pi 4
```

> Note: if prompting for `raspi-config` select "2 Display Options" and enable composite, then select "finish"

## 4. Configure delay (optional)

In `~/.bashrc` before the last line, add

```bash
export RUN_ARGS=60
```

(with the selected delay)

## 5. Enjoy

```bash
reboot
```
