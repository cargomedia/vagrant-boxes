if test -f .vbox_version ; then
    # Zero out the free space to save space in the final image:
    dd if=/dev/zero of=/EMPTY bs=1M
    rm -f /EMPTY
fi
