#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

void win() {
    printf("IMPOSSIBLE! GRAHHHHHHHHHH\n");
    puts(getenv("FLAG"));
}

int main() {
    char buf[0x20];
    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);

    puts("You pathetic pwners are worthless without your precious leaks!!!");
    read(0, buf, 0x50);
}