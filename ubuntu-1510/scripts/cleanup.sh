# Clean up
apt-get -y remove linux-headers-$(uname -r) build-essential
apt-get -y autoremove
apt-get -y clean

# Removing leftover leases and persistent rules
echo 'cleaning up dhcp leases'
rm -f /var/lib/dhcp/*

# Make sure Udev doesn't block our network
echo 'cleaning up udev rules'
rm -f /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules

echo 'Adding a 2 sec delay to the interface up, to make the dhclient happy'
printf '\npre-up sleep 2\n' >> /etc/network/interfaces
