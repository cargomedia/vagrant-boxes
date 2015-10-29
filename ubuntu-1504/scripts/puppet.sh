# Prepare puppetlabs repo
wget http://apt.puppetlabs.com/puppetlabs-release-pc1-vivid.deb
dpkg -i puppetlabs-release-pc1-vivid.deb
rm puppetlabs-release-pc1-vivid.deb
apt-get update

# Prevent puppet agent from auto-starting
mkdir -p /etc/systemd/system/puppet.service.d
cat > /etc/systemd/system/puppet.service.d/disable.conf << EOF
[Service]
EnvironmentFile=/not/there
EOF

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
