#include <stdio.h>
#include <stdlib.h>
#include "t1.h"

Graph* create_graph(int num_nodes){ //creates a graph with num_nodes nodes, assuming nodes are stored in alphabetical order (A, B, C..)
    Graph* g = (Graph*)malloc(sizeof(Graph)); //allocate memory to graph
    g->num_nodes = num_nodes; //set amount of nodes in the graph
    g->adj_list = (Node**)malloc(num_nodes * sizeof(Node*)); //allocate memory in the graph for the lists in each node

    for (int i = 0; i < num_nodes; i++)
        g->adj_list[i] = NULL; //initiate lists to NULL

    return g;
}

void add_edge(Graph *g, int from, int to){ //adds a directed edge
    Node* new_node = (Node*)malloc(sizeof(Node)); //allocate memory to new node
    new_node->vertex = to; //set the new node as the vertex wanted to go to
    new_node->next = g->adj_list[from]; //add the destination's next to be the first vertex in the list
    g->adj_list[from] = new_node; //add the destination to the top of the source node list
}

void bfs(Graph* g, int origin){ //implements breath first search and prints the results (neighbours first, then rest of nodes)
    int* visited = (int*)malloc(g->num_nodes*sizeof(int)); //create array of visited nodes in graph
    for (int i = 0; i < g->num_nodes; i++) 
      visited[i] = 0; //mark all as unvisited

    int front = 0; //initialise front of queue
    int end = 0; //initialise end of queue
    int visit_order[/*g->num_nodes*/6]; //array storing the order of nodes to visit (queue form)
    visit_order[end++] = origin; //add first node (origin) as first in array
    visited[origin] = 1; //state as visited

    printf("\nBFS from origin %c: ", origin + 'A'); //convert origin back to character

    while (front < end) { //goes through each node
      int node = visit_order[front++];
      printf("%c ", node + 'A'); //print nodes in BFS order
      Node* current = g->adj_list[node]; //go trhough the list of the current node

      while (current != NULL) { //until end of list
        if (!visited[current->vertex]) { //while not visited 
             visited[current->vertex] = 1; //mark as visited
             visit_order[end++] = current->vertex; //and add to the visited queue at the end
        }
        current = current->next; //move to next node in list
      }
    }
    free(visited);
}

void dfs(Graph* g, int origin){ //implements depth first search and prints the results (one neighbours path first, then rest)
    int* visited = (int*)malloc(g->num_nodes * sizeof(int)); //create array of visited nodes in graph
    for (int i = 0; i < g->num_nodes; i++) 
      visited[i] = 0; //mark all as unvisited

    printf("\nDFS from origin %c: ", origin + 'A');

    /*visited[origin] = 1;
    printf("%c ", origin + 'A');

    Node* temp = g->adj_list[node];
    while (temp != NULL) {
      if (!visited[temp->vertex])
        dfs(g, node??);
    temp = temp->next; 
    } */

    dfs_2(g, origin, visited);

    free(visited);
}

void dfs_2(Graph* g, int node, int* visited) {
    printf("%c ", node + 'A'); //print nodes in DFS order
    visited[node] = 1; //mark node as visited
    Node* current = g->adj_list[node]; //get head of the list of current value

    while (current != NULL) { //until end of list
      if (!visited[current->vertex]) //while not visited 
        dfs_2(g, current->vertex, visited); //recal function
    current = current->next; //move to next node in list
    }
}

void delete_graph(Graph* g){ //deletes the graph and all its data structures
    for (int i = 0; i < g->num_nodes; i++) { //go through each node and its list
      Node* current = g->adj_list[i]; //start first node in list
      while (current != NULL) { //until the end of list
         Node* delete_node = current;
         current = current->next; //next node in list
         free(delete_node); //delete previous node 
      }
    }
    free(g->adj_list); //free nodes
    free(g); //free graph
}
