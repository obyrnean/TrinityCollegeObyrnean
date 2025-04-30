#include <stdio.h>
#include <string.h>
//#define max_len 100


int next_field(FILE *csv, char *buffer, int max_len);

int main() {
  FILE *pFile = fopen("data.csv","r"); //read specified file
  char field[100];
  int c_field;

  if (pFile==NULL) perror ("Error opening file"); //check if file exists, if not output message

else { 
   fgets(field, sizeof(field), pFile); //read first line (skip header)

   while (!feof(pFile)) { //if its not end of file
    c_field = next_field(pFile, field, sizeof(field)); //store return value of function and update field
    printf("%s\n", field); //print each field of the line
   
    if (c_field == 1) //if next line
      printf("\n");
    /*while (next_field(pFile, field, sizeof(field)) == 0) {
      printf("%s\n", field);
    }
    printf("%s\n", field);
    printf("\n"); */
    //c = fgetc(pFile);
   }   
  } 
    fclose (pFile); //close file
    return 0;
}

int next_field(FILE *csv, char *buffer, int max_len) {
  int i = 0; 
  char c = fgetc(csv);

  while (c != EOF && c != ',' && c != '\n'){ 
     if (i < max_len - 1) {
            buffer[i] = c; //store each character in the buffer
            i++;
     }
     c = fgetc(csv); //read in next character
  }

  buffer[i] = '\0'; //to create a valid string we need to null-terminate

  if (c == ',') return 0;
  else if (c == EOF || c == '\n') return 1;
  return 1; 
}
