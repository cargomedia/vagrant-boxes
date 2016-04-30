# Prepare puppetlabs repo
wget -q http://apt.puppetlabs.com/puppetlabs-release-pc1-vivid.deb -O puppetlabs-release-pc1.deb
dpkg -i puppetlabs-release-pc1.deb
rm puppetlabs-release-pc1.deb
apt-get update

# Install
apt-get install -qy puppet-agent

# Symlink binaries to PATH
binaries=( puppet facter mco hiera )
for binary in ${binaries[@]}; do
  binary_dest="/usr/bin/${binary}"
  rm -f "${binary_dest}"
  ln -s "/opt/puppetlabs/bin/${binary}" "${binary_dest}"
done

# Disable puppet service
systemctl stop puppet
rm /lib/systemd/system/puppet.service
systemctl daemon-reload
