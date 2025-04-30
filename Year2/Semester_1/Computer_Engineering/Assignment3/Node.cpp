#include "Node.h"
#include <iostream>

using namespace std;

Node::Node(string newWord){ // constructor with word
    this -> word = newWord;
}

Node::Node(string newWord, int newCount){ // constructor with word and count
    this->word = newWord;
    this->count = newCount;
}
