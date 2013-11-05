#!/bin/bash -e

BASE_DISTRO_DIR=$(dirname $0)
BASE_DISTRO=$(basename ${BASE_DISTRO_DIR})

if ! (test -e ${BASE_DISTRO_DIR}/${BASE_DISTRO}.json); then
	echo
	echo Packer file not found.
	echo
	echo Choose one of the following box types to generate:
	find . -iname "debian*" -type d
	echo
	echo by invoking the script inside the chosen directory
	echo e.g. debian-6-amd64/$(basename $0)
    echo
	exit 1
fi


cd ${BASE_DISTRO_DIR}

packer validate ${BASE_DISTRO}.json
packer build ${BASE_DISTRO}.json

s3cmd put ${BASE_DISTRO}.box s3://s3.cargomedia.ch/vagrant-boxes/
s3cmd setacl --acl-public --recursive s3://s3.cargomedia.ch/vagrant-boxes/
cd -

