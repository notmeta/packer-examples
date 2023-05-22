#_preseed_V1
# Automatic installation
d-i auto-install/enable boolean true

# Preseeding only locale sets language, country and locale.
d-i debian-installer/language string en
d-i debian-installer/country string US
d-i debian-installer/locale string en_US.UTF-8

d-i console-setup/ask_detect boolean false
d-i debconf/frontend select noninteractive

# Keyboard selection.
d-i keyboard-configuration/xkb-keymap select us
d-i keymap select us

choose-mirror-bin mirror/http/proxy string
d-i apt-setup/use_mirror boolean true
d-i base-installer/kernel/override-image string linux-server

### Clock and time zone setup
d-i clock-setup/utc boolean true
d-i clock-setup/utc-auto boolean true
d-i time/zone string UTC

# Avoid that last message about the install being complete.
d-i finish-install/reboot_in_progress note

# This is fairly safe to set, it makes grub install automatically to the MBR
# if no other operating system is detected on the machine.
d-i grub-installer/only_debian boolean true

# This one makes grub-installer install to the MBR if it also finds some other
# OS, which is less safe as it might not be able to boot that other OS.
d-i grub-installer/with_other_os boolean true

# Set dev for grub boot
d-i grub-installer/bootdev string /dev/sda

### Mirror settings
# If you select ftp, the mirror/country string does not need to be set.
d-i mirror/country string manual
d-i mirror/http/directory string /ubuntu/
d-i mirror/http/hostname string archive.ubuntu.com
d-i mirror/http/proxy string

# This makes partman automatically partition without confirmation.
d-i partman-efi/non_efi_system boolean true
d-i partman-auto-lvm/guided_size string max
d-i partman-auto/choose_recipe select atomic
d-i partman-auto/method string lvm
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-lvm/device_remove_lvm boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman/confirm_write_new_label boolean true

### Account setup
d-i passwd/root-login boolean false
d-i passwd/user-fullname string ${username}
d-i passwd/user-uid string 1000 ${userId}
d-i passwd/user-password password ${password}
d-i passwd/user-password-again password ${password}
d-i passwd/username string ${username}

# The installer will warn about weak passwords. If you are sure you know
# what you're doing and want to override it, uncomment this.
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false

### Package selection
tasksel tasksel/first multiselect standard, server
d-i pkgsel/include string openssh-server sudo cryptsetup libssl-dev libreadline-dev zlib1g-dev linux-source dkms nfs-common linux-headers-$(uname -r) perl cifs-utils software-properties-common rsync ifupdown
d-i pkgsel/install-language-support boolean false

# disable automatic package updates
d-i pkgsel/update-policy select none
d-i pkgsel/upgrade select full-upgrade

# Disable polularity contest
popularity-contest popularity-contest/participate boolean false

# Select base install
tasksel tasksel/first multiselect standard, ssh-server

# Setup passwordless sudo for packer user
d-i preseed/late_command string \
echo "${username} ALL=(ALL:ALL) NOPASSWD:ALL" > /target/etc/sudoers.d/${username} && chmod 0440 /target/etc/sudoers.d/${username}
