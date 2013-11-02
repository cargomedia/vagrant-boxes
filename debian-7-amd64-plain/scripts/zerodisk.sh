#!/bin/bash -x
# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -fr /EMPTY
