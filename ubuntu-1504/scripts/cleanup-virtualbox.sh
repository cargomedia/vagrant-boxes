#!/bin/sh -eux
#Adapted 2016, Cargo Media AG (tech@cargomedia.ch)
#Copyright 2012-2014, Chef Software, Inc. (<legal@chef.io>)
#Copyright 2011-2012, Tim Dysinger (<tim@dysinger.net>)

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

if test -f .vbox_version ; then
    echo "Fill with 0 the swap partition to reduce box size"
    readonly swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
    readonly swappart=$(readlink -f /dev/disk/by-uuid/"$swapuuid")
    /sbin/swapoff "$swappart"
    dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is ignored"
    /sbin/mkswap -U "$swapuuid" "$swappart"

    echo "Fill filesystem with 0 to reduce box size"
    dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is ignored"
    rm -f /EMPTY
    # Block until the empty file has been removed, otherwise, Packer
    # will try to kill the box while the disk is still full and that's bad
    sync
fi
