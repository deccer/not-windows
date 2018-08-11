#!/bin/bash

curl -s https://raw.githubusercontent.com/deccer/not-windows/master/install-scripts/arch/base-0-variables.sh > base-0-variables.sh
curl -s https://raw.githubusercontent.com/deccer/not-windows/master/install-scripts/arch/base-1-ext4.sh > base-1-ext4.sh
curl -s https://raw.githubusercontent.com/deccer/not-windows/master/install-scripts/arch/base-2-helpers.sh > base-2-helpers.sh
curl -s https://raw.githubusercontent.com/deccer/not-windows/master/install-scripts/arch/base-2-chroot.sh > base-2-chroot.sh

chmod -x base-1-ext4.sh
chmod -x base-2-chroot.sh

base-1-ext4.sh