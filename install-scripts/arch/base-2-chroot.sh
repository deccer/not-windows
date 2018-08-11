#!/bin/bash

set -e
set -o pipefail
set -o errtrace
set -o nounset
set -o errexit  

source base-0-variables.sh
source base-2-helpers.sh

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

echo $LANG.UTF-8 UTF-8 > /etc/locale.gen
locale-gen

echo LANG=$LANG.UTF-8 >> /etc/locale.conf
echo KEYMAP=$KEYMAP > /etc/vconsole.conf
echo FONT=$FONT >> /etc/vconsole.conf

echo $HOSTNAME >> /etc/hostname
echo 127.0.0.1	$HOSTNAME.localdomain	$HOSTNAME >> /etc/hosts

useradd -m -G wheel -s /bin/bash $DEFAULTUSER
echo 'root ALL=(ALL) ALL' > /etc/sudoers
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
echo '%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu' >> /etc/sudoers

MKINITCPIOCONF=/etc/mkinitcpio.conf
echo 'MODULES=()' > $MKINITCPIOCONF
echo 'BINARIES=()' >> $MKINITCPIOCONF
echo 'FILES=()' >> $MKINITCPIOCONF
echo 'HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)' >> $MKINITCPIOCONF
echo 'COMPRESSION=lzma' >> $MKINITCPIOCONF

mkinitcpio -p linux

LOADERCONF=/boot/loader/loader.conf
bootctl --path=/boot install
echo 'default arch' > $LOADERCONF
echo 'timeout 3' >> $LOADERCONF
echo 'editor  0' >> $LOADERCONF
BOOTENTRY=/boot/loader/entries/arch.conf
echo 'title   Arch Linux' > $BOOTENTRY
echo 'linux   /vmlinuz-linux' >> $BOOTENTRY
echo 'initrd  /initramfs-linux.img' >> $BOOTENTRY
echo "options root=$BLOCKDEVICEROOT rw" >> $BOOTENTRY

systemctl enable dhcpcd.service

echo Installation almost complete. Setting passwords
echo Choose a password for root:
passwd

echo Choose a password for "${DEFAULTUSER}":
passwd $DEFAULTUSER

manualinstall packer

exit