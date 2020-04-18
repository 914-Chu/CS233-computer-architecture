#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest)
{
    //int bs = 10;
/*
    for(int j = 0; j < SIZE; j += 10){
        for(int i = 0; i < SIZE; i += 10){
            for (int y = j; y < min(j+10, SIZE); y ++) {
                for (int x = i; x < min(i+10, SIZE); x ++) {
                    dest[x][y] = src[y][x];
                }
            }
        }
    }
*/
/*
    for(int j = 0; j < SIZE; j += 32){
        for(int i = 0; i < SIZE; i++){
           for(int y = j; y < min(j+32, SIZE); y++){
              dest[i][y] = src[y][i];
           }
        }
    }
*/ 
  
   for(int i = 0; i < SIZE; i+= 40){
       for(int j = 0; j < SIZE; j++){
           for(int x = i; x < min(i+40, SIZE); x++){
               dest[x][j] = src[j][x];
           }
       }

   }

/*
    for(int i = 0; i < SIZE; i += bs){                                       
        for(int j = 0; j < SIZE; j += bs){                                      
            for (int x = i; x < min(i+bs, SIZE); x ++) {                        
                for (int y = j; y < min(j+bs, SIZE); y ++) {                   
                   dest[x][y] = src[y][x];                          
                }                                                              
            }                                                                  
       }                                                                        
   }  
*/
}
