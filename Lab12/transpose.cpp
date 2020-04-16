#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"
#include <iostream>
// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) 
{
    int bs = 5;
 
    for(int j = 0; j < SIZE; j += bs){
        for(int i = 0; i < SIZE; i += bs){
            for (int y = j; y < min(j+bs, SIZE); y ++) {
                for (int x = i; x < min(i+bs, SIZE); x ++) {
                    dest[x][y] = src[y][x];
                    //std::cout << x << " " << y << " " << std::endl;
                    //dest[x][y] = src[y][x];
                }
            }
        }
    }

/*
    for(int i = 0; i < SIZE; i += bs){                                       
        for(int j = 0; j < SIZE; j += bs){                                      
            for (int x = i; x < min(i+bs, SIZE); x ++) {                        
                for (int y = j; y < min(j+bs, SIZE); y ++) {                   
                   dest[x][y] = src[y][x];                                      
                   //std::cout << x << " " << y << " " << std::endl;            
                   //dest[x][y] = src[y][x];                                   
                }                                                              
            }                                                                  
       }                                                                        
   }  
*/
}
