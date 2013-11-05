#!/bin/bash -e
cd $(dirname $0)

function usage() {
	echo "Usage: $(basename ${0}) <template>"
	echo
	echo "Available templates:"
	find . -iname "*.json" -type f
	exit 1
}

if (test -z "${1}"); then
	usage
fi

DISTRO=$(dirname ${1})
TEMPLATE=$(basename ${1})
if ! (test -e ${DISTRO}/${TEMPLATE}); then
	echo "Template does not exist: ${1}"
	echo
	usage
fi


cd ${DISTRO}
packer validate ${TEMPLATE}
packer build ${TEMPLATE}

s3cmd put ${BASE_DISTRO}.box s3://s3.cargomedia.ch/vagrant-boxes/
s3cmd setacl --acl-public --recursive s3://s3.cargomedia.ch/vagrant-boxes/
