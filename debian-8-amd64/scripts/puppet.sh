# Prepare puppetlabs repo
wget http://apt.puppetlabs.com/puppetlabs-release-jessie.deb
dpkg -i puppetlabs-release-jessie.deb
rm puppetlabs-release-jessie.deb
apt-get update

# Install puppet/facter
apt-get install -y puppet facter

# Configure
cat > /etc/puppet/puppet.conf << EOF
[main]
confdir = /etc/puppet
ssldir = /etc/puppet/ssl
logdir = /var/log/puppet
rundir = /var/run/puppet
EOF

# Reinstall puppet.service when needed (no autostart)
systemctl stop puppet
rm -f /lib/systemd/system/puppet.service /var/lib/puppet/state/agent_disabled.lock /etc/init.d/puppet
systemctl daemon-reload
