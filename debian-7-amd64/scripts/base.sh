# Update the box
apt-get -y update
apt-get -y install apt-transport-https
apt-get -y install zlib1g-dev libssl-dev libreadline-gplv2-dev
apt-get -y install curl unzip
apt-get clean

# Tweak sshd to prevent DNS resolution (speed up logins)
printf '\nUseDNS no\n' >> /etc/ssh/sshd_config
