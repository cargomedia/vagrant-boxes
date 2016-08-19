if test -f .vbox_version ; then
    # Install vagrant keys
    mkdir -pm 700 /home/vagrant/.ssh
    curl -kLo /home/vagrant/.ssh/authorized_keys 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
    chmod 0600 /home/vagrant/.ssh/authorized_keys
    chown -R vagrant:vagrant /home/vagrant/.ssh

    apt-get -y install nfs-common
    apt-get -y install resolvconf
fi
