# Configure apt sources
rm -f /etc/apt/sources.list.d/*
cat <<EOF > /etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu xenial main universe
deb-src http://archive.ubuntu.com/ubuntu xenial main universe

deb http://archive.ubuntu.com/ubuntu xenial-security main universe
deb-src http://archive.ubuntu.com/ubuntu xenial-security main universe

deb http://archive.ubuntu.com/ubuntu xenial-updates main universe
deb-src http://archive.ubuntu.com/ubuntu xenial-updates main universe
EOF

# Update the box
export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade
apt-get -y install apt-transport-https curl
apt-get clean

# Tweak sshd to prevent DNS resolution (speed up logins)
printf '\nUseDNS no\n' >> /etc/ssh/sshd_config
