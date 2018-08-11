manualinstall() {
	[[ -f /usr/bin/$1 ]] || (
	cd /tmp
	rm -rf /tmp/$1*
	curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz &&
	sudo -u $name tar -xvf $1.tar.gz &>/dev/null &&
	cd $1 &&
	sudo -u $name makepkg --noconfirm -si &>/dev/null
	cd /tmp) ;}