#!/bin/sh

TIMEOUT=60

if [ -z "$1" ]
then
    echo "No exploit supplied"
    # No exploit executable supplied
    timeout $TIMEOUT qemu-system-x86_64 \
        -kernel ./bzImage \
        -cpu qemu64,+smap,+smep \
        -smp 2 \
        -m 1G \
        -initrd ./initramfs.cpio.gz \
        -append "console=ttyS0 quiet loglevel=3 oops=panic panic_on_warn=1 panic=-1 pti=on page_alloc.shuffle=1" \
        -no-reboot \
        -nographic \
        -monitor /dev/null \

else
    echo "Exploit supplied"
    # Exploit executable supplied as first argument
    timeout $TIMEOUT qemu-system-x86_64 \
        -kernel ./bzImage \
        -cpu qemu64,+smap,+smep \
        -smp 2 \
        -m 1G \
        -initrd ./initramfs.cpio.gz \
        -append "console=ttyS0 quiet loglevel=3 oops=panic panic_on_warn=1 panic=-1 pti=on page_alloc.shuffle=1" \
        -no-reboot \
        -nographic \
        -monitor /dev/null \
        -drive file=$1,format=raw,index=0,media=disk \

fi

