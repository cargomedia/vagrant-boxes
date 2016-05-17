if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then

    echo 'Clear out swap and disable until reboot'
    readonly swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
    readonly swappart=$(readlink -f /dev/disk/by-uuid/"$swapuuid")
    /sbin/swapoff "$swappart"
    dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is ignored"
    /sbin/mkswap -U "$swapuuid" "$swappart"

    echo 'Zero out the free space'
    dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is ignored"
    rm -f /EMPTY

    echo 'Syncing disks'
    sync
fi
