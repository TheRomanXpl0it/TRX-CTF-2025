CC = gcc

CFLAGS = -Wall -O0

all: main

SOURCES = $(wildcard *.c)
OBJECTS = $(SOURCES:.c=.o)

main: $(OBJECTS)
	$(CC) -o challenge $(OBJECTS) $(CFLAGS)
	rm -f $(OBJECTS)