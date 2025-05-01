#include "t4.h"
#include <stdio.h> 
#include <stdlib.h>
#include <string.h> //for strcpy and strcmp
#include <stdbool.h> 


GameYears year[MAX_YEARS]; //array of years that will store lists of games
int yearCount = 0; //count of years
Game allGames[MAX_GAMES]; //array to store all games
int totalGames = 0; //total number of games across all years

void add_games(Game game) {
     if (totalGames >= MAX_GAMES) {
        printf("Error: Maximum number of games reached. Cannot add more games.\n");
        return;
    }

    //Always add the game to the allGames array
    allGames[totalGames] = game;
    totalGames++;
    
    for (int i = 0; i < yearCount; i++) { //checks if the release year of the game is already in the array
        if (year[i].year == atoi(game.release_year)) { 
            year[i].games[year[i].count] = game; //if it is, adds the game to the list of games of that year
            year[i].count++; //increment number of games in the year
            return;
        }
    }
    year[yearCount].year = atoi(game.release_year); //add year if it doesn't exist
    year[yearCount].count = 1; //initialize count of added year
    year[yearCount].games[0] = game; //add game as first in the list of this year
    yearCount++;
    
}

void printGames() { //sort and print top 5 games for each year
        quickSort(allGames, totalGames); //sort the games for all years

        printf("Top 10 games for all 20 years:\n");
        for (int j = 0; j < 10 && j < totalGames; j++) { //print top 5 games of the year
            int num = j + 1; 
            printf("%d. Title: %s. Score: %s\n", num, allGames[j].title, allGames[j].score);
        }
        printf("\n");
}


//SORTING FUNCTIONS (from task 2):
void quickSort(Game arr[], int size) { 
    quickSorting(arr, 0, size - 1);
}

void swapGames(Game* i, Game* j) { //swaps two elements (positions)
  Game h = *i; //temporary storing value
  *i = *j; 
  *j = h;  
}

int partitionQuicksort(Game arr[], int smaller, int larger) { //sorts values in the array into smaller than and greater than pivot sections
  int pivot = atoi(arr[smaller].score); //choose pivot to be the first element of the array
  int next = smaller + 1; //next value to the right of pivot

  for (int j = smaller + 1; j <= larger; j++) { //check the array values
        if (atoi(arr[j].score) > pivot) { //if current value is smaller than pivot we want to sort to the left
            swapGames(&arr[next], &arr[j]);
            next++; //continue to the next value in the array
        }
    }
    swapGames(&arr[smaller], &arr[next - 1]); //swap pivot to correct possition
    return next - 1;  //chosen pivot index
}

void quickSorting(Game arr[], int smallest, int largest) {
    if (smallest < largest) { //until no more division is possible
        int pivot_index = partitionQuicksort(arr, smallest, largest); //sort array and get pivot index
        quickSorting(arr, smallest, pivot_index - 1); //continue sorting the left side of the pivot (smaller values)
        quickSorting(arr, pivot_index + 1, largest); //continue sorting the right side of the pivot (larger values)
    }
}


//FILE LOADING FUNCTIONS:
int load_file (char *fname) {
	FILE *f; 
	char buf[1000];
    int cbuf = 0;

	f = fopen(fname, "r"); //read specified file
	if (!f) {  //check if file exists, if not output message of error
		printf("Unable to open %s\n", fname);
		return 0; 
	}

	fgets(buf, sizeof(buf), f); //read first line (skip header)

	while ( !feof(f) ) { // read until the end of the file
        Game game;
		cbuf = next_token(buf, f, MAX_STRING_SIZE);
        strcpy(game.title, buf);
        cbuf = next_token(buf, f, MAX_STRING_SIZE);
        strcpy(game.platform, buf);
        cbuf = next_token(buf, f, MAX_STRING_SIZE);
        strcpy(game.score, buf);
        cbuf = next_token(buf, f, MAX_STRING_SIZE);
        strcpy(game.release_year, buf);

        add_games(game); 

        if (cbuf == 1) continue;
	}
    
    printf("File %s loaded\n", fname);
	fclose(f); //close file
	return 1;
}

int next_token (char *buf, FILE *f, int string_max) { //reads strings of alpha numeric characters from input file. Truncates strings which are too long to string_max-1
  int i = 0;
  char c = fgetc(f);
  bool quotes = false;

  while (c != EOF) {
    if (c == '"')
     quotes = !quotes;
     else if (c == ',' && !quotes)
      break;  //stop on comma if not inside quotes
     else if (c == '\n' && !quotes)
      break;  //stop on newline if not inside quotes
     else if (i < string_max - 1) {
      buf[i] = c;  //store the character in the buffer
      i++;
    }
     c = fgetc(f); //read in next character
  }
  buf[i] = '\0'; //to create a valid string we need to null-terminate
  if (c == ',') return 0;
  if (c == EOF || c == '\n') return 1;
  return 1;

}

