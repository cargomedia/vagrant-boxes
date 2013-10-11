#!/bin/sh -e
cd $(dirname $0)

#veewee vbox build --force debian-6-amd64
#veewee vbox validate debian-6-amd64
#/usr/bin/vagrant package --base debian-6-amd64 --output debian-6-amd64.box
#s3cmd put debian-6-amd64.box s3://s3.cargomedia.ch/vagrant-boxes/

#veewee vbox build --force debian-6-amd64-plain
#/usr/bin/vagrant package --base debian-6-amd64-plain --output debian-6-amd64-plain.box

cd debian-7.1-amd64/
packer validate debian-7.1-amd64.json
packer build debian-7.1-amd64.json

exit 0
s3cmd put debian-6-amd64-plain.box s3://s3.cargomedia.ch/vagrant-boxes/

s3cmd setacl --acl-public --recursive s3://s3.cargomedia.ch/vagrant-boxes/

