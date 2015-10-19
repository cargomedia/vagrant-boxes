if test -f .vbox_version ; then

  # Kernel headers needed
  apt-get -y install --no-install-recommends libdbus-1-3

  # Install the VirtualBox guest additions
  VBOX_ISO=VBoxGuestAdditions.iso
  mount -o loop $VBOX_ISO /mnt
  yes|sh /mnt/VBoxLinuxAdditions.run || [ $? -eq 1 ]
  umount /mnt

  # Cleanup Virtualbox
  rm $VBOX_ISO
fi
