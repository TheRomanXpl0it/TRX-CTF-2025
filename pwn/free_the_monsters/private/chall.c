#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

typedef struct Equipment{
    unsigned long long attack;
    unsigned long long defense;
    char name[0x20];
}Equipment;

typedef struct Player{
    unsigned long long level;
    char name[0x20];
    Equipment * helmet;
    Equipment * chest;
    Equipment * gloves;
    Equipment * waist;
    Equipment * legs;
    Equipment * weapon;
    Equipment * jewel;
    Equipment * earing;
    Equipment * charm;
    Equipment * talisman;
    Equipment * kinsect;
    Equipment * palico;
    Equipment * palamute;
}Player;

typedef struct Monster{
    unsigned long long attack;
    unsigned long long defense;
    unsigned long long health;
    char name[0x18];
}Monster;

typedef struct Quest{
    unsigned long long reward;
    char name[0x20];
    Monster * monster;
}Quest;

Quest * active_quest;

Player player = {
    .name = "Hunter",
    .level = 1,
    .helmet = NULL,
    .chest = NULL,
    .gloves = NULL,
    .waist = NULL,
    .legs = NULL,
    .weapon = NULL,
    .jewel = NULL,
    .earing = NULL,
    .charm = NULL,
    .talisman = NULL,
    .kinsect = NULL,
    .palico = NULL,
    .palamute = NULL
};

void setup(){
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stdin, NULL, _IONBF, 0);
    printf("Please select a name for your hunter!\n");
    printf("> ");
    read(0, player.name, 0x20);
    player.name[strcspn(player.name, "\n")] = 0;
}

void win(){
    printf("Congratulations! You beat magnamalo, now the village is safe!\n");
    return;
}

void menu(){
    printf("1. Check player status\n2. Select a quest\n3. Embark on a quest\n4. Change equipment\n5. Exit\n> ");
}

void select_quest(){
    int choice;
    printf("Please select a quest:\n");
    printf("1. Hunt a Great Izuchi\n2. Hunt a Great Baggi\n3. Hunt a Magnamalo\n> ");
    scanf("%d", &choice);

    switch(choice){
        case 1:
            printf("Mission \"Hunt a Great Izuchi\" accepted!\n");
            active_quest = (Quest *)malloc(sizeof(Quest));
            strcpy(active_quest->name, "Hunt a Great Izuchi");
            active_quest->reward = 100;
            active_quest->monster = (Monster *)malloc(sizeof(Monster));
            strcpy(active_quest->monster->name, "Great Izuchi");
            active_quest->monster->attack = 10;
            active_quest->monster->defense = 10;
            active_quest->monster->health = 100;
            break;
        case 2:
            if (player.level < 100){
                printf("You need to level up to accept this quest!\n");
                return;
            }
            printf("Mission \"Hunt a Great Baggi\" accepted!\n");
            active_quest = (Quest *)malloc(sizeof(Quest));
            strcpy(active_quest->name, "Hunt a Great Baggi");
            active_quest->reward = 200;
            active_quest->monster = (Monster *)malloc(sizeof(Monster));
            strcpy(active_quest->monster->name, "Great Baggi");
            active_quest->monster->attack = 20;
            active_quest->monster->defense = 20;
            active_quest->monster->health = 200;
            break;
        case 3:
            if (player.level < 1000){
                printf("You need to level up to accept this quest!\n");
                return;
            }
            printf("Mission \"Hunt a Magnamalo\" accepted!\n");
            active_quest = (Quest *)malloc(sizeof(Quest));
            strcpy(active_quest->name, "Hunt a Magnamalo");
            active_quest->reward = 300;
            active_quest->monster = (Monster *)malloc(sizeof(Monster));
            strcpy(active_quest->monster->name, "Magnamalo");
            active_quest->monster->attack = 30;
            active_quest->monster->defense = 30;
            active_quest->monster->health = 300;
            break;
        default:
            printf("Invalid choice\n");
    }

}

void banner(){
    char banner [] = "   __  ___              __            __             __            _____\n\
  /  |/  /__  ___  ___ / /____ ____  / /  __ _____  / /____ ____  / ___/\n\
 / /|_/ / _ \\/ _ \\(_-</ __/ -_) __/ / _ \\/ // / _ \\/ __/ -_) __/ / /__  \n\
/_/  /_/\\___/_//_/___/\\__/\\__/_/   /_//_/\\_,_/_//_/\\__/\\__/_/    \\___/  \n\
Free the monsters.\nPowered by the newest Libc engine®\n";
    printf("%s\n", banner);
}

void print_player_info(){
    printf("Name: %s\nLevel: %llu\n", player.name, player.level);
    if(player.helmet != NULL){
        printf("Helmet: %s\nAttack: %llu\nDefense: %llu\n", player.helmet->name, player.helmet->attack, player.helmet->defense);
        printf("====================================\n");
    }
    if(player.chest != NULL){
        printf("Chest: %s\nAttack: %llu\nDefense: %llu\n", player.chest->name, player.chest->attack, player.chest->defense);
        printf("====================================\n");
    }
    if(player.gloves != NULL){
        printf("Gloves: %s\nAttack: %llu\nDefense: %llu\n", player.gloves->name, player.gloves->attack, player.gloves->defense);
        printf("====================================\n");
    }
    if(player.waist != NULL){
        printf("Waist: %s\nAttack: %llu\nDefense: %llu\n", player.waist->name, player.waist->attack, player.waist->defense);
        printf("====================================\n");
    }
    if(player.legs != NULL){
        printf("Legs: %s\nAttack: %llu\nDefense: %llu\n", player.legs->name, player.legs->attack, player.legs->defense);
        printf("====================================\n");
    }
    if(player.weapon != NULL){
        printf("Weapon: %s\nAttack: %llu\nDefense: %llu\n", player.weapon->name, player.weapon->attack, player.weapon->defense);
        printf("====================================\n");
    }
    if(player.jewel != NULL){
        printf("Jewel: %s\nAttack: %llu\nDefense: %llu\n", player.jewel->name, player.jewel->attack, player.jewel->defense);
        printf("====================================\n");
    }
    if(player.earing != NULL){
        printf("Earing: %s\nAttack: %llu\nDefense: %llu\n", player.earing->name, player.earing->attack, player.earing->defense);
        printf("====================================\n");
    }
    if(player.charm != NULL){
        printf("Charm: %s\nAttack: %llu\nDefense: %llu\n", player.charm->name, player.charm->attack, player.charm->defense);
        printf("====================================\n");
    }
    if(player.talisman != NULL){
        printf("Talisman: %s\nAttack: %llu\nDefense: %llu\n", player.talisman->name, player.talisman->attack, player.talisman->defense);
        printf("====================================\n");
    }
    if(player.kinsect != NULL){
        printf("Kinsect: %s\nAttack: %llu\nDefense: %llu\n", player.kinsect->name, player.kinsect->attack, player.kinsect->defense);
        printf("====================================\n");
    }
    if(player.palico != NULL){
        printf("Palico: %s\nAttack: %llu\nDefense: %llu\n", player.palico->name, player.palico->attack, player.palico->defense);
        printf("====================================\n");
    }
    if(player.palamute != NULL){
        printf("Palamute: %s\nAttack: %llu\nDefense: %llu\n", player.palamute->name, player.palamute->attack, player.palamute->defense);
        printf("====================================\n");
    }
}

void embark_quest(){
    if(active_quest == NULL){
        printf("Please select a quest first!\n");
        return;
    }
    printf("Embarking on quest: %s\n", active_quest->name);
    printf("Hunting monster: %s\n", active_quest->monster->name);
    printf("Monster attack: %llu\nMonster defense: %llu\nMonster health: %llu\n", active_quest->monster->attack, active_quest->monster->defense, active_quest->monster->health);
    printf("You have defeated the monster!\n");
    printf("Your character has leveled up!\n");
    if(player.level < 100 && player.level + active_quest->reward >= 100){
        printf("You have unlocked a new quest: Hunt a Great Baggi\n");
        printf("You can now equip a helmet and chest!\n");
    }
    if(player.level < 1000 && player.level + active_quest->reward >= 1000){
        printf("You have unlocked a new quest: Hunt a Magnamalo\n");
        printf("You can now equip gloves, waist and legs!\n");
    }
    player.level += active_quest->reward;
    active_quest = NULL;
}

void change_equipment(){
    printf("Select equipment to change:\n");
    printf("1. Helmet\n2. Chest\n3. Gloves\n4. Waist\n5. Legs\n6. Weapon\n7. Jewel\n8. Earing\n9. Charm\n10. Talisman\n11. Kinsect\n12. Palico\n13. Palamute\n> ");
    int choice;
    scanf("%d", &choice);
    switch(choice){
        case 1:
            if (player.level < 100){
                printf("You need to level up to equip helmet!\n");
                return;
            }
            printf("What do you want to do?\n1. Equip helmet\n2. Unequip helmet\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.helmet = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter helmet name: ");
                read(0, player.helmet->name, 0x20);
                printf("Enter helmet attack: ");
                scanf("%llu", &player.helmet->attack);
                printf("Enter helmet defense: ");
                scanf("%llu", &player.helmet->defense);
            }else if(choice == 2){
                free(player.helmet);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        case 2:
            if (player.level < 100){
                printf("You need to level up to equip chest!\n");
                return;
            }
            printf("What do you want to do?\n1. Equip chest\n2. Unequip chest\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.chest = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter chest name: ");
                read(0, player.chest->name, 0x20);
                printf("Enter chest attack: ");
                scanf("%llu", &player.chest->attack);
                printf("Enter chest defense: ");
                scanf("%llu", &player.chest->defense);
            }else if(choice == 2){
                free(player.chest);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        case 3:
            if (player.level < 1000){
                printf("You need to level up to equip gloves!\n");
                return;
            }
            printf("What do you want to do?\n1. Equip gloves\n2. Unequip gloves\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.gloves = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter gloves name: ");
                read(0, player.gloves->name, 0x20);
                printf("Enter gloves attack: ");
                scanf("%llu", &player.gloves->attack);
                printf("Enter gloves defense: ");
                scanf("%llu", &player.gloves->defense);
            }else if(choice == 2){
                free(player.gloves);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        case 4:
            if (player.level < 1000){
                printf("You need to level up to equip waist!\n");
                return;
            }
            printf("What do you want to do?\n1. Equip waist\n2. Unequip waist\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.waist = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter waist name: ");
                read(0, player.waist->name, 0x20);
                printf("Enter waist attack: ");
                scanf("%llu", &player.waist->attack);
                printf("Enter waist defense: ");
                scanf("%llu", &player.waist->defense);
            }else if(choice == 2){
                free(player.waist);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        case 5:
            if (player.level < 1000){
                printf("You need to level up to equip legs!\n");
                return;
            }
            printf("What do you want to do?\n1. Equip legs\n2. Unequip legs\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.legs = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter legs name: ");
                read(0, player.legs->name, 0x20);
                printf("Enter legs attack: ");
                scanf("%llu", &player.legs->attack);
                printf("Enter legs defense: ");
                scanf("%llu", &player.legs->defense);
            }else if(choice == 2){
                free(player.legs);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        case 6:
            printf("What do you want to do?\n1. Equip weapon\n2. Unequip weapon\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.weapon = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter weapon name: ");
                read(0, player.weapon->name, 0x20);
                printf("Enter weapon attack: ");
                scanf("%llu", &player.weapon->attack);
                printf("Enter weapon defense: ");
                scanf("%llu", &player.weapon->defense);
            }else if(choice == 2){
                free(player.weapon);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        case 7:
            printf("What do you want to do?\n1. Equip jewel\n2. Unequip jewel\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.jewel = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter jewel name: ");
                read(0, player.jewel->name, 0x20);
                printf("Enter jewel attack: ");
                scanf("%llu", &player.jewel->attack);
                printf("Enter jewel defense: ");
                scanf("%llu", &player.jewel->defense);
            }else if(choice == 2){
                free(player.jewel);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        case 8:
            printf("What do you want to do?\n1. Equip earing\n2. Unequip earing\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.earing = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter earing name: ");
                read(0, player.earing->name, 0x20);
                printf("Enter earing attack: ");
                scanf("%llu", &player.earing->attack);
                printf("Enter earing defense: ");
                scanf("%llu", &player.earing->defense);
            }else if(choice == 2){
                free(player.earing);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        case 9:
            printf("What do you want to do?\n1. Equip charm\n2. Unequip charm\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.charm = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter charm name: ");
                read(0, player.charm->name, 0x20);
                printf("Enter charm attack: ");
                scanf("%llu", &player.charm->attack);
                printf("Enter charm defense: ");
                scanf("%llu", &player.charm->defense);
            }else if(choice == 2){
                free(player.charm);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        case 10:
            printf("What do you want to do?\n1. Equip talisman\n2. Unequip talisman\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.talisman = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter talisman name: ");
                read(0, player.talisman->name, 0x20);
                printf("Enter talisman attack: ");
                scanf("%llu", &player.talisman->attack);
                printf("Enter talisman defense: ");
                scanf("%llu", &player.talisman->defense);
            }else if(choice == 2){
                free(player.talisman);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        case 11:
            printf("What do you want to do?\n1. Equip kinsect\n2. Unequip kinsect\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.kinsect = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter kinsect name: ");
                read(0, player.kinsect->name, 0x20);
                printf("Enter kinsect attack: ");
                scanf("%llu", &player.kinsect->attack);
                printf("Enter kinsect defense: ");
                scanf("%llu", &player.kinsect->defense);
            }else if(choice == 2){
                free(player.kinsect);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        case 12:
            printf("What do you want to do?\n1. Equip palico\n2. Unequip palico\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.palico = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter palico name: ");
                read(0, player.palico->name, 0x20);
                printf("Enter palico attack: ");
                scanf("%llu", &player.palico->attack);
                printf("Enter palico defense: ");
                scanf("%llu", &player.palico->defense);
            }else if(choice == 2){
                free(player.palico);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        case 13:
            printf("What do you want to do?\n1. Equip palamute\n2. Unequip palamute\n> ");
            scanf("%d", &choice);
            if(choice == 1){
                player.palamute = (Equipment *)malloc(sizeof(Equipment));
                printf("Enter palamute name: ");
                read(0, player.palamute->name, 0x20);
                printf("Enter palamute attack: ");
                scanf("%llu", &player.palamute->attack);
                printf("Enter palamute defense: ");
                scanf("%llu", &player.palamute->defense);
            }else if(choice == 2){
                free(player.palamute);
            }
            else{
                printf("Invalid choice\n");
            }
            break;
        default:
            printf("Invalid choice\n");
    }

}

int main(){
    setup();
    banner();
    int choice;
    while(1){
        menu();
        scanf("%d", &choice);
        switch(choice){
            case 1:
                print_player_info();
                break;
            case 2:
                select_quest();
                break;
            case 3:
                embark_quest();
                break;
            case 4:
                change_equipment();
                break;
            case 5:
                return 0;
                break;
            default:
                printf("Invalid choice\n");
        }
    }
}