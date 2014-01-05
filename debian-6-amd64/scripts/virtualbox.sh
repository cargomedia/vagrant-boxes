if test -f .vbox_version ; then

  # Without libdbus virtualbox would not start automatically after compile
  apt-get -y install --no-install-recommends libdbus-1-3

  # The netboot installs the VirtualBox support (old) so we have to remove it
  if test -f /etc/init.d/virtualbox-ose-guest-utils ; then
    /etc/init.d/virtualbox-ose-guest-utils stop
  fi

  rmmod vboxguest
  aptitude -y purge virtualbox-ose-guest-x11 virtualbox-ose-guest-dkms virtualbox-ose-guest-utils
  aptitude -y install dkms

  # Install the VirtualBox guest additions
  VBOX_ISO=VBoxGuestAdditions.iso
  mount -o loop $VBOX_ISO /mnt
  yes|sh /mnt/VBoxLinuxAdditions.run
  umount /mnt

  # Cleanup Virtualbox
  rm $VBOX_ISO
fi
