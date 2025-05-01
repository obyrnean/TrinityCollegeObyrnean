#include <stdio.h>
#include <stdlib.h>
#include "bst.h"

void tree_insert(Tree_Node** root, char data){ //inserts new node in the binary tree
    if (*root == NULL) { //if the root (starting at topmost node) is empty
        *root = (Tree_Node*)malloc(sizeof(Tree_Node)); //instantly creates a new node
        (*root)->data = data; //define new node data
        (*root)->left = (*root)->right = NULL; //for now, it is a leaf node with no neighbours
    } else { 
        if (data < (*root)->data) { //if the data is smaller than the current roots data
            tree_insert(&(*root)->left, data); //insert in the left subtree
        } else { //if greater
            tree_insert(&(*root)->right, data); //insert in the right subtree
        }
    }
}
Tree_Node* create_bst (char data[]){ //creates the binary tree
    Tree_Node* root = NULL; //initialize the tree as empty
    for (int i = 0; data[i] != '\0'; i++) { //for every character in the input string until NULL
        tree_insert(&root, data[i]); //insert each character from the array into the tree
    }
    return root; //return the root of the tree (starting node)
}
Tree_Node* tree_search(Tree_Node* root, char data){ //searches a character in the tree
     if (root == NULL || root->data == data) //if we reached a non existent node or if data matches
        return root; //return node if found or NULL (since root == NULL) if not found
    if (data < root->data) //if data smaller than current data
        return tree_search(root->left, data);  //search in the left subtree
     else 
        return tree_search(root->right, data); //search in the right subtree
    return NULL;
}
void tree_print_sorted(Tree_Node* root){ //prints the whole organised tree (ascending character order)
    if (root == NULL) 
       return; //nothing to do if empty (end reached)
    tree_print_sorted(root->left); //go through left subtree (smaller values)
    printf("%c ", root->data); //print the node's data
    tree_print_sorted(root->right); //go through right subtree (larger values)
}
void tree_delete(Tree_Node* root){
    if (root == NULL) 
       return; //nothing to do if empty (end reached)
    tree_delete(root->left); //delete left subtree
    tree_delete(root->right); //delete right subtree
    free(root); //free current root node
}
