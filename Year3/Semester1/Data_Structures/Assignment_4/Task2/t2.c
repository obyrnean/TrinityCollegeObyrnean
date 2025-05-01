#include <stdio.h>
#include <stdlib.h>
#include "t2.h"

Graph* create_graph(int num_nodes){ // creates a graph with num_nodes nodes, assuming nodes are stored in alphabetical order (A, B, C..)
    Graph* g = (Graph*)malloc(sizeof(Graph)); //allocate memory to graph
    g->num_nodes = num_nodes; //set amount of nodes in the graph

    for (int i = 0; i < num_nodes; i++) { //initialise matrix 10x10
        for (int j = 0; j < num_nodes; j++) {
          if (i == j) //if its the same node 
             g->adj_matrix[i][j] = 0; //distance to itself is 0
          else
             g->adj_matrix[i][j] = 100000; //not connected initially (give it a large number)
        }
    }
    return g;
}

void add_edge(Graph *g, int from, int to, int weight){ // adds an undirected weighted edge between from and to
    g->adj_matrix[from][to] = weight;
    g->adj_matrix[to][from] = weight; //set both ways since there's no specified direction
}

void dijkstra(Graph* g, int origin){ // implements the dijkstra algorithm and prints the order in which the nodes are made permament, and the length of the shortest path between the origin node and all the other nodes
    int permanent[MAX_VERTICES]; //stores permanent nodes (no further change in distances)
    int cost[MAX_VERTICES]; //stores the shortest distance
    int predecessor[MAX_VERTICES]; //keeps track of previous node (shortest distance)
    int num_nodes = g->num_nodes;

    for (int i = 0; i < num_nodes; i++) { //initialise arrays
        cost[i] = 100000; //no set distance
        permanent[i] = 0; //no nodes are permanent
        predecessor[i] = -1; //no parents assigned (negative number for not assigned)
    }
    cost[origin] = 0; //starting distance is 0

    printf("Permanent nodes in order: ");
    for (int i = 0; i < num_nodes; i++) { //go thorugh each node in the graph
        int min_cost = 100000; //initialisation for minimum cost and 
        int n = -1; //smallest distance node index not assigned yet

        for (int j = 0; j < num_nodes; j++) { //loop thorugh neighbour nodes
            if (!permanent[j] && cost[j] < min_cost) { //while its not permanent and its distance is smaller than the minimum distance
                min_cost = cost[j]; //set as new smallest distance
                n = j; //node with smallest distance 
            }
        }
        permanent[n] = 1; //make visited node permanent
        printf("%c ", n + 'A');

        for (int n2 = 0; n2 < num_nodes; n2++) { //loop thorugh all nodes
            if (!permanent[n2] && g->adj_matrix[n][n2] != 100000) { //if its not permanent and actually are connected
                int new_cost = cost[n] + g->adj_matrix[n][n2]; //calculates the new distance from origin passin through previous node until new one
                if (new_cost < cost[n2]) { //if the new calculated distance is smaller
                    cost[n2] = new_cost; //shorter path found
                    predecessor[n2] = n; //update node predecessor
                }
            }
        }
    }

    for (int i = 0; i < num_nodes; i++) { //print out the shortest distance form origin (A) to all other nodes
        if (cost[i] == 100000) 
            printf("\n%c and %c are not connected\n", origin + 'A', i + 'A');
         else 
            printf("\nThe length of the shortest path between %c and %c is %d", origin + 'A', i + 'A', cost[i]);
    }
}

void delete_graph(Graph* g){
    free(g); //free memory in graph
}
