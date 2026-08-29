# ENV

PROJECT_DIR ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# ACTIONS

.PHONY: remove-passwd
remove-passwd:
	sudo passwd -d $(shell whoami)

.PHONY: apt-install
apt-install:
	sudo apt update
	sudo apt install -y weston seatd kitty ffmpeg

.PHONY: setup-weston
setup-weston:
	ln -fs $(PROJECT_DIR)/system/weston.ini $(HOME)/.config/weston.ini

.PHONY: setup-rasp-config
setup-rasp-config:
	sudo $(PROJECT_DIR)/line_in_file.sh "include forge-invar.txt" "/boot/firmware/config.txt"
	sudo $(PROJECT_DIR)/line_in_file.sh "vc4.tv_norm=PAL" "/boot/firmware/config.txt" "vc4.tv_norm"
	sudo cp -f $(PROJECT_DIR)/system/config.ini /boot/firmware/forge-invar.txt

.PHONY: setup-services
setup-services:
	sudo ln -fs $(PROJECT_DIR)/system/getty@tty1.service /etc/systemd/system/getty@tty1.service
	sudo systemctl daemon-reload
	sudo systemctl enable getty@tty1.service seatd.service

.PHONY: setup-bashrc
setup-bashrc:
	$(PROJECT_DIR)/line_in_file.sh "make -C $(PROJECT_DIR) start-weston" "$(HOME)/.bashrc"

.PHONY: install
install: remove-passwd setup-rasp-config apt-install setup-weston setup-rasp-config setup-services setup-bashrc

.PHONY: run
run:
	$(PROJECT_DIR)/delay.sh

.PHONY: start-weston
start-weston:
	/usr/bin/weston --shell=kiosk-shell.so --xwayland -- kitty --hold make -C $(PROJECT_DIR) run
