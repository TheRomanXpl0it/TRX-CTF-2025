CC = gcc
CFLAGS = -O1 -no-pie -static -g
P = ../fs/initramfs.cpio.gz.extracted/e

e: e.c
	$(CC) e.c helpers.c -o $P $(CFLAGS)