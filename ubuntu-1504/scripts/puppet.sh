# Prepare puppetlabs repo
wget http://apt.puppetlabs.com/puppetlabs-release-pc1-vivid.deb
dpkg -i puppetlabs-release-pc1-vivid.deb
rm puppetlabs-release-pc1-vivid.deb
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
