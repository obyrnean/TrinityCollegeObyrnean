#include "TextAnalyser.h"
#include <iostream>
#include <fstream>
using namespace std;

void TextAnalyser::ReadFile(string filename) {
    cout << "TextAnalyser::ReadFile, filename='" << filename << "'." << endl;
    ifstream file;
    file.open(filename);
    if (!file.is_open()) {
        cout << "unable to open file with filename='" << filename << "'." << endl;
        return;
    }
    string word;
    UnsortedWordList list = UnsortedWordList();

    while (file >> word) {
        list.CountWord(word);
    }

        if (readIntoA)
            this->listA = list;
        else
            this->listB = list;

        this->readIntoA = !this->readIntoA;
}

void TextAnalyser::Intersection(){
    UnsortedWordList list = UnsortedWordList();
    Node* current_A = this->listA.Front();

    while (current_A != nullptr) {
        Node* current_B = this->listB.Front();
        while (current_B != nullptr) {
            if (current_A->word == current_B->word) {
                int count = 0;
                if (current_A->count < current_B->count)
                    count = current_A->count;
                else
                    count = current_B->count;

                for (int i = 0; i < count; ++i) {
                    list.CountWord(current_A->word);
                }
            }
            current_B = current_B->link;
        }
        current_A = current_A->link;
    }
    this->listC = list;
}

void TextAnalyser::Union() {
    UnsortedWordList list = UnsortedWordList();
    Node* current = nullptr;

    current = this->listA.Front();
    while (current != nullptr) {
        int count = current->count;
        for (int i = 0; i < count; ++i) {
            list.CountWord(current->word);
        }
        current = current->link;
    }

    current = this->listB.Front();
    while (current != nullptr) {
        int count = current->count;
        for (int i = 0; i < count; ++i) {
            list.CountWord(current->word);
        }
        current = current->link;
    }

    this->listC = list;
}
