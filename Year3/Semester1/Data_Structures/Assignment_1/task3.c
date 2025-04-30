#include<stdio.h>
#include<stdlib.h>
#include <string.h> //for strcpy and strcmp
#include <ctype.h>  //for isalnum

#define MAX_STRING_SIZE 20 //max length of a string
#define ARRAY_SIZE 59  //has table size
#define NAME_PROMPT "Enter term to get frequency or type \"quit\" to escape\n>>> " //invitation to the user
#define NEW_LINE_PROMPT ">>> " //where the user should input the name

typedef struct Element Element;

struct Element{
    char name[MAX_STRING_SIZE];
    int frequency; //the amount of times this name is in the table
};

Element* hashTable[ARRAY_SIZE]; //array representing the hash table using element pointers
int collisions = 0;
int num_terms = 0;

int hash_function1(char* s){ //generates a slot number for each name (s) wanted to insert into the hash table
    int hash = 0;
    while(*s){ //goes through each character of the name string if not NULL
       hash = (hash + *s - 'A') % ARRAY_SIZE; //this is based on ASCII (where A = 65),converting them into numbers and fitting hash between the array size range
       s++; //moves to next character of string
    }
    return hash; //number where the name will be stored in the hash table
}

int hash_function3(char* s){ //secondary hash function for double hashing
int hash = 0;
  while(*s){ //iterate over each character in the string until terminated by null or \0
      hash = 1+ (hash + *s-'A') % (ARRAY_SIZE - 1); //update hash value same as previous function, -1 to not jump outside the value range
      s++; //next character
    }
return hash;
}

Element* createNewElement(char* name){ //creates a new element in which you store name and its count (frequency)
    Element *newElement = (Element*)malloc(sizeof(Element)); //allocates memory to a new element
    strcpy(newElement->name, name); //pass the input name as the new elements name
    newElement->frequency = 1; //name has appeared once
	return newElement; //returns pointer to the new element created
}

Element* search (char* name){ //searches and returns the element with name name or NULL if the element is not present
    int slot = hash_function1(name); //get the slot number of the input name
    int startingSlot = slot; //retain the slot we started on
    int jumpSize = hash_function3(name); //calculate the size we'll jump if collision occurs

    while (hashTable[slot] != NULL) { //while not empty
     if (strcmp(hashTable[slot]->name, name) == 0) //if slot is occupied with the name we're searching for (function compares strings and if equal returns 0)
        return hashTable[slot]; //return found name
     slot = (slot + jumpSize) % ARRAY_SIZE; //jump to the next slot if name not found
     if (slot == startingSlot) //if we loop back to the original index
        break; //name not found
    }
    return NULL; //null slot hit
}

void insert(char* name){ //add element at the correct place in the list
    int slot = hash_function1(name); //get the slot number where we're trying to fit the input name
    int startingSlot = slot; //retain the slot we started on
    int jumpSize = hash_function3(name); //calculate the size we'll jump if collision occurs

    while (hashTable[slot] != NULL){
         if (strcmp(hashTable[slot]->name, name) == 0) { //name already exists
            return; 
         }
        collisions++; //there's collision of hash slots
        slot = (slot + jumpSize) % ARRAY_SIZE; //move to next slot if there's collision
        if (slot == startingSlot) //if we loop back to the original index
          printf("Hash Table full");
    }
    //if slot was found
    hashTable[slot] = createNewElement(name); //inserts new element to available slot
    num_terms++; //unique name was added
}

void printNumberOfOccurences(char* name){ //prints the number of time a name has appeared, or 0 if not in the file
    Element*element = search(name); //search for the input name
    if (element)  //if element found
      printf("%s - %d\n", name, element->frequency); 
    else 
      printf("%s - 0 (not in table)\n", name);

}

void addOrIncrement(char* name){ //searches the name in the array, if it is there increment its count, if not, add it
    Element*element = search(name); //search for the input name
    if (element)  //if name found 
      element->frequency++; //increase frequency
    else 
      insert(name); //add name if not found
}

// Reads strings of alpha numeric characters from input file. Truncates strings which are too long to string_max-1
void next_token (char *buf, FILE *f, int string_max ) {
	buf[0] = fgetc(f); //reads in characters

	while ( !isalnum(buf[0]) && !feof(f) ) { buf[0] = fgetc(f); } // start by skipping any characters we're not interested in
	// read string of alphanumeric characters
	int i=1;
	for (;;) {
		buf[i] = fgetc(f); // get next character from file
		if( !isalnum(buf[i]) ) { 
            if(buf[i]!=' ') // we still want to keep spaces
                break; // only load letters and numbers
        } 
		if( feof(f) ) { break; }          // file ended?
		if( i < (string_max-1) ) { ++i; } // truncate strings that are too long
	}
	buf[i] = '\0'; // NULL terminate the string
}

//  Reads the contents of a file and adds them to the hash table - returns 1 if file was successfully read and 0 if not.
int load_file ( char *fname ) {
	FILE *f; 
	char buf[MAX_STRING_SIZE];

	f = fopen(fname, "r"); //read specified file
	if (!f) {  //check if file exists, if not output message of error
		printf("Unable to open %s\n", fname);
		return 0; 
	}
	
	while ( !feof(f) ) { // read until the end of the file
		next_token(buf, f, MAX_STRING_SIZE);
		addOrIncrement(buf); //count of names stored
	}
    
    printf("File %s loaded\n", fname);
    float load = (float)num_terms / ARRAY_SIZE; 
    printf("     Capacity   : %i\n     Num Terms  : %i\n     Collisions : %i\n     Load       : %.2f%%\n", ARRAY_SIZE, num_terms, collisions, load);

	fclose(f); //close file
	return 1;
}
void printHashTable() {
    for (int i = 0; i < ARRAY_SIZE; i++) {
        if (hashTable[i] != NULL) { // Only print if the slot is occupied
            printf("Slot %d: %s (Frequency: %d)\n", i, hashTable[i]->name, hashTable[i]->frequency);
        } else {
            printf("Slot %d: EMPTY\n", i);
        }
    }
}

int main(int argc, char *argv[]){
    Element element; 
    char name[MAX_STRING_SIZE];

    if (load_file("names.csv") == 0)
        printf("Error with loading file");

    else {
        printf("%s", NAME_PROMPT); //print user invitattionsA
        scanf(" %[^\n]", &name); //read the name user is sarching for, read until enter has been pressed
        while (strcmp(name, "quit") != 0) { //if user doesn't type quit, print if searched name is in table and its frequency
           printNumberOfOccurences(name);
           printf("%s ", NEW_LINE_PROMPT);
           scanf(" %[^\n]", &name); //read the next name user is sarching for
        }
       //printHashTable();

    }
    return 0; 
}
