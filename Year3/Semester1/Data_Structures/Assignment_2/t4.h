#ifndef T4_H_
#define T4_H_

#include <stdio.h>

#define MAX_STRING_SIZE 100 //max length of a string
#define MAX_YEARS 20 //last 20 years
#define MAX_GAMES 1000

typedef struct Game Game;
typedef struct GameYears GameYears;

struct Game { //game details
    char title[MAX_STRING_SIZE];
    char platform[MAX_STRING_SIZE];
    char score[MAX_STRING_SIZE];
    char release_year[MAX_STRING_SIZE];
};

struct GameYears { //store all games for each year
    int year, count;
    Game games[100];
};

//funtions:
void add_games(Game game);
void printGames();

void quickSort(Game arr[], int size);
void swapGames(Game* i, Game* j);
int partitionQuicksort (Game arr[], int smaller, int larger);
void quickSorting(Game arr[], int smallest, int largest);

int load_file(char *fname);
int next_token(char *buf, FILE *f, int string_max);


#endif
