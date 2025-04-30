#include <stdio.h>
#include <string.h>

int main() {
    char name[50];
    int age;

    printf("Name >> ");
    scanf("%s", &name); //get the users name

    printf("Age >> ");
    scanf("%d", &age); //get users age

    printf("Hello %s (%d)", name, age);

    return 0;
}
