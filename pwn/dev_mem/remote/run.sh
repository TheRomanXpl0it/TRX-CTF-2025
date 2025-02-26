#!/bin/sh
TIMEOUT=40

if [ -z "$1" ]
then
    echo "No exploit supplied"
    # No exploit executable supplied
    qemu-system-x86_64 \
        -kernel ./bzImage \
        -initrd ./initramfs.cpio.gz \
        -cpu qemu64,+smap,+smep \
        -smp 1 \
        -m 1G \
        -append "console=ttyS0 quiet loglevel=3 oops=panic panic_on_warn=1 panic=-1 pti=on" \
        -no-reboot \
        -nographic \
        -monitor /dev/null \

else
    echo "Exploit supplied"
    # Exploit executable supplied as first argument
    qemu-system-x86_64 \
        -kernel ./bzImage \
        -initrd ./initramfs.cpio.gz \
        -cpu qemu64,+smap,+smep \
        -smp 1 \
        -m 1G \
        -append "console=ttyS0 quiet loglevel=3 oops=panic panic_on_warn=1 panic=-1 pti=on" \
        -no-reboot \
        -nographic \
        -monitor /dev/null \
        -drive file=$1,format=raw,index=0,media=disk \

fi

