# ENV

PROJECT_DIR ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
RUN_ARGS ?=

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

.PHONY: setup-rasp-5-config
setup-rasp-5-config:
	sudo $(PROJECT_DIR)/line_in_file.sh "include custom.txt" "/boot/firmware/config.txt"
	sudo $(PROJECT_DIR)/line_in_file.sh "vc4.tv_norm=PAL" "/boot/firmware/config.txt" "vc4.tv_norm"
	sudo $(PROJECT_DIR)/line_in_file.sh "quiet" "/boot/firmware/cmdline.txt"
	sudo cp -f $(PROJECT_DIR)/system/config-5.ini /boot/firmware/custom.txt

.PHONY: setup-rasp-4-config
setup-rasp-4-config:
	sudo $(PROJECT_DIR)/line_in_file.sh "include custom.txt" "/boot/firmware/config.txt"
	sudo $(PROJECT_DIR)/line_in_file.sh "vc4.tv_norm=PAL" "/boot/firmware/cmdline.txt" "vc4.tv_norm"
	sudo $(PROJECT_DIR)/line_in_file.sh "quiet" "/boot/firmware/cmdline.txt"
	sudo cp -f $(PROJECT_DIR)/system/config-4.ini /boot/firmware/custom.txt

.PHONY: setup-services
setup-services:
	sudo ln -fs $(PROJECT_DIR)/system/getty@tty1.service /etc/systemd/system/getty@tty1.service
	sudo systemctl daemon-reload
	sudo systemctl enable getty@tty1.service seatd.service

.PHONY: setup-bashrc
setup-bashrc:
	$(PROJECT_DIR)/line_in_file.sh "make -C $(PROJECT_DIR) start-weston" "$(HOME)/.bashrc"

.PHONY: install-5
install-5: remove-passwd apt-install setup-weston setup-rasp-5-config setup-services setup-bashrc

.PHONY: install-4
install-4: remove-passwd apt-install setup-weston setup-rasp-4-config setup-services setup-bashrc

.PHONY: run
run:
	@$(PROJECT_DIR)/delay.sh $(RUN_ARGS)

.PHONY: start-weston
start-weston:
	@echo "on" | sudo tee /sys/class/drm/card1-Composite-1/status
	@/usr/bin/weston --shell=kiosk-shell.so --xwayland -- kitty --hold make -C $(PROJECT_DIR) run
