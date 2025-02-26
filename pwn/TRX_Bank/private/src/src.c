#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define MENU_SIZE (sizeof (MENU) / sizeof (const char *))
#define MAX_ACCOUNTS 0x20

typedef struct __attribute__((__packed__)) {
    char iban[0x20];
    uint64_t balance;
} bank_account;

const char* MENU[] = {
    "View existing accounts",
    "Open a new bank account",
    "Close an existing account",
    "Make a deposit",
    "Make a transfer",
    "Talk to the bank manager",
    "Exit\n"
};

bank_account *accounts[MAX_ACCOUNTS];
FILE *fp_rand;

void init_chall() {
    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stderr, NULL, _IONBF, 0);

    fp_rand = fopen("/dev/urandom", "rb");
}

bank_account* get_account(char *iban) {
    for (int i=0; i<MAX_ACCOUNTS; i++) {
        if (!accounts[i])
            continue;
        
        if (strncmp(accounts[i]->iban, iban, sizeof(accounts[i]->iban)) == 0)
            return accounts[i];
    }
    return NULL;
}

void deposit() {
    bank_account *dst;
    char buf[0x20];
    uint64_t n = 0;

    puts("Please enter your IBAN:");
    fgets(buf, sizeof(buf), stdin);
    buf[strcspn(buf, "\n")] = 0;

    if (!(dst = get_account(buf))) {
        puts("Invalid IBAN");
        return;
    }

    puts("How much do you want to deposit?");
    scanf("%lu", &n);
    getchar();

    dst -> balance += n;

    puts("Deposit successfully completed!");
}

void transfer() {
    uint64_t n;
    bank_account *dst, *src;
    char buf[0x20];

    puts("Please enter your IBAN:");
    fgets(buf, sizeof(buf), stdin);
    buf[strcspn(buf, "\n")] = 0;

    if (!(src = get_account(buf))) {
        puts("Invalid IBAN");
        return;
    }

    puts("Please enter the receiver's IBAN:");
    fgets(buf, sizeof(buf), stdin);
    buf[strcspn(buf, "\n")] = 0;

    if (!(dst = get_account(buf))) {
        puts("Invalid IBAN");
        return;
    }

    if (dst == src) {
        puts("You can't make a transfer to yourself!");
        return;
    }

    puts("How much do you want to transfer?");
    scanf("%lu", &n);
    getchar();

    if (src -> balance < n) {
        puts("Your balance is insufficient");
        return;
    }

    src -> balance -= n;
    dst -> balance += n;

    puts("Transfer successfully completed!");
}

void close_account() {
    bank_account *acc;
    char buf[0x20];
    bank_account *tmp[MAX_ACCOUNTS];

    puts("Please enter your IBAN:");
    fgets(buf, sizeof(buf), stdin);
    buf[strcspn(buf, "\n")] = 0;

    if (!(acc = get_account(buf))) {
        puts("Invalid IBAN");
        return;
    }

    free(acc);
    memset(tmp, 0, sizeof(tmp));
    for (int i=0, j=0; i<MAX_ACCOUNTS; i++) {
        if (!accounts[i] || accounts[i] == acc)
            continue;
        
        tmp[j] = accounts[i];
        j++;
    }

    memcpy(accounts, tmp, sizeof(accounts));
    puts("Successfully closed the account!");
}

void open_account() {
    for (int i=0; i<MAX_ACCOUNTS; i++) {
        if (accounts[i])
            continue;

        if (!(accounts[i] = malloc(sizeof(bank_account))))
            _exit(-1);

        accounts[i]->iban[0] = 'I';
        accounts[i]->iban[1] = 'T';
        for (int j=2; j<0x1f; j++) {
            fread(accounts[i]->iban+j, 1, 1, fp_rand);
            accounts[i]->iban[j] = '0' + (unsigned char)accounts[i]->iban[j] % 10;
        }
        accounts[i]->iban[0x1f] = 0;
        accounts[i]->balance = 0;

        printf("Account created, your IBAN is %s\n", accounts[i]->iban);
        return;
    }  

    puts("Too many accounts!");
}

void view_accounts() {
    for (int i=0; i<MAX_ACCOUNTS; i++) {
        if (!accounts[i])
            continue;

        printf("[%d] IBAN: %s\n", i+1, accounts[i]->iban);
    }
}

void leave() {
    int tmp = rand() % 100;
    printf("We're sorry to see you go! Your refund will arrive approximately in %d days!\n", tmp);
    fclose(fp_rand);
}

void secret_backdoor() {
    uint64_t addr;

    puts("Dear customer, please provide the secret keyword to prove your identity:");

    if (scanf("%p%*c", (void**)&addr) != 1 || addr != (uint64_t)secret_backdoor) {
        puts("Wrong!");
        _exit(-1);
    }
    
    puts("And here's the security question...");
    fgets((char*)&fp_rand->_markers, 0x78, stdin);
    memset((char*)&fp_rand->_codecvt, 0, 0x20);
    puts("Verification complete, you can now recover your account!");
}

int main() {
    init_chall();
    char choice;

    while (1) {
        for (int i=0; i<MENU_SIZE; i++)
            printf("%d) %s\n", i+1, MENU[i]);
        printf("> ");
        
        scanf("%c%*c", &choice);
        if (choice == '\n')
            _exit(0);

        switch (choice) {
        case '1':
            view_accounts();
            break;
        case '2':
            open_account();
            break;
        case '3':
            close_account();
            break;
        case '4':
            deposit();
            break;
        case '5':
            transfer();
            break;
        case '6':
            secret_backdoor();
            break;
        case '7':
            leave();
            _exit(0);
        default:
            puts("Invalid choice");
        }
    }
}