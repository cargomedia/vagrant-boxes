# Configure apt sources
rm -f /etc/apt/sources.list.d/*
cat <<EOF > /etc/apt/sources.list
deb http://ftp.debian.org/debian wheezy main contrib non-free
deb-src  http://ftp.debian.org/debian wheezy main contrib non-free

deb http://ftp.debian.org/debian wheezy-updates main contrib non-free
deb-src  http://ftp.debian.org/debian wheezy-updates main contrib non-free

deb http://security.debian.org/ wheezy/updates main contrib non-free
deb-src http://security.debian.org/ wheezy/updates main contrib non-free
EOF

# Update the box
export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade
apt-get -y install apt-transport-https curl
apt-get clean

# Tweak sshd to prevent DNS resolution (speed up logins)
printf '\nUseDNS no\n' >> /etc/ssh/sshd_config
