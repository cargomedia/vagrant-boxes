#!/bin/sh
set -e
cd $(dirname $0)

vagrant basebox build --force debian-6-amd64
vagrant basebox validate debian-6-amd64
vagrant basebox export debian-6-amd64
