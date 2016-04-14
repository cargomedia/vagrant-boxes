# Update the box
apt-get -y update
export DEBIAN_FRONTEND=noninteractive
apt-get -y -o Dpkg::Options::="--force-confnew" upgrade

apt-get -y install linux-headers-$(uname -r) build-essential apt-transport-https
apt-get -y install zlib1g-dev libssl-dev libreadline-gplv2-dev
apt-get clean

# Tweak sshd to prevent DNS resolution (speed up logins)
printf '\nUseDNS no\n' >> /etc/ssh/sshd_config
