#include <stdio.h>
#include <string.h>
#include <stdbool.h>
//#define max_len 100

 typedef struct Pokemon { //define structure of a pokemon
 char name[50];
 char type1[50], type2[50];
 char total[50], hp[50], attack[50], defense[50], sp_atk[50], sp_def[50], speed[50];
 char generation[50], legendary[50], pokedex_entry[500];
} Pokemon;

//Functions: 
int next_field(FILE *csv, char *buffer, int max_len);
void Pokedex(FILE *csv, Pokemon pokemons[]);

int main() {
  FILE *pFile = fopen("pokemon.csv","r"); //read specified file
  char field[1000];
  Pokemon pokemons[700];
  int sum = 0;

  if (pFile==NULL) perror ("Error opening file"); //check if file exists, if not output message

else
  { 
   fgets(field, sizeof(field), pFile); //read first line (skip header)
   Pokedex(pFile, pokemons); //update pokemon information

   for (int i = 0; i < 649; i++){
    printf("Pokemon: %s - Attack strength: %s\n", pokemons[i].name, pokemons[i].attack);
   }

  // printf("Average attack strength of pokemons: %d\n", sum);

  } 
    fclose (pFile); //close file
    return 0;
}

//FUNCTION 1: 
int next_field(FILE *csv, char *buffer, int max_len) {
  int i = 0; 
  char c = fgetc(csv);
  bool quotes = false; 

  while (c != EOF) { 
    if (c == '"')
     quotes = !quotes;
     else if (c == ',' && !quotes) 
      break;  //stop on comma if not inside quotes
     else if (c == '\n' && !quotes) 
      break;  //stop on newline if not inside quotes
     else if (i < max_len - 1) {
      buffer[i] = c;  //store the character in the buffer
      i++;
    }
     c = fgetc(csv); //read in next character
  }

  buffer[i] = '\0'; //to create a valid string we need to null-terminate
  if (c == ',') return 0;
  if (c == EOF || c == '\n') return 1;
  return 1; 
}

//FUNCTION 2: 
void Pokedex(FILE *csv, Pokemon pokemons[]) {
  int c_field, i = 0;
  char field[700];

  while (!feof(csv)) { //if its not end of file
   Pokemon character; //declare a character to store in arrays of pokemon

   c_field = next_field(csv, field, sizeof(field)); //character numbers (we can ignore i believe)

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.name, field); //copy and paste the string in field to character name

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.type1, field);

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.type2, field);

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.total, field);

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.hp, field);

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.attack, field);

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.defense, field);

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.sp_atk, field);

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.sp_def, field);

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.speed, field);

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.generation, field);

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.legendary, field);

   c_field = next_field(csv, field, sizeof(field));
   strcpy(character.pokedex_entry, field);

   pokemons[i] = character;
   i++;

   if (c_field == 1)
    continue;
  }
}
