#!/bin/sh -e
cd $(dirname $0)

vagrant basebox build --force debian-6-amd64
vagrant basebox validate debian-6-amd64
vagrant basebox export debian-6-amd64

s3cmd put debian-6-amd64.box s3://s3.cargomedia.ch/vagrant-boxes/
s3cmd setacl --acl-public --recursive s3://s3.cargomedia.ch/vagrant-boxes/
