if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then

  # Install the VirtualBox guest additions
  VBOX_ISO=VBoxGuestAdditions.iso
  mount -o loop $VBOX_ISO /mnt
  sh /mnt/VBoxLinuxAdditions.run || [ $? -eq 1 ]
  umount /mnt

  # Cleanup Virtualbox
  rm $VBOX_ISO
fi
