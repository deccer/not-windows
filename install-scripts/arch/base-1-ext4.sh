#!/bin/bash

set -e
set -o pipefail
set -o errtrace
set -o nounset
set -o errexit  

source base-0-variables.sh

(
	echo o
	echo Y
	echo n
	echo 1
	echo 
	echo +256M
	echo ef00
	echo n
	echo 2
	echo
	echo +8G
	echo 8200
	echo n
	echo 3
	echo 
	echo 
	echo 8300
	echo w
	echo Y
) | gdisk $BLOCKDEVICEDISK > /dev/null

mkfs.fat -F 32 $BLOCKDEVICEBOOT

mkswap $BLOCKDEVICESWAP
swapon $BLOCKDEVICESWAP
mkfs.ext4 $BLOCKDEVICEROOT

mount $BLOCKDEVICEROOT $MNT
mkdir -p $MNT/boot
mount $BLOCKDEVICEBOOT $MNT/boot

pacstrap $MNT base base-devel git
genfstab -U $MNT >> $MNT/etc/fstab

cp base-0-variables.sh $MNT
cp base-2-chroot.sh $MNT
cp base-2-helpers.sh $MNT
arch-chroot $MNT bash base-2-chroot.sh

echo 'Installation finished, please reboot now.'
