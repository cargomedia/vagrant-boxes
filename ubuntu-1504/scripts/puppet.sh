# Prepare puppetlabs repo
wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
dpkg -i puppetlabs-release-wheezy.deb
rm puppetlabs-release-wheezy.deb
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
