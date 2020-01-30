/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // Length must be a multiple of 8
   assert((length % 8) == 0);

   // allocates an array for the output
   char *message_out = new char[length];
   for (int i=0; i<length; i++) {
   	message_out[i] = 0;    // Initialize all elements to zero.
   }

	// TODO: write your code here
  
   int t[8] = {1,2,4,8,16,32,64,128};
   for (int i = 0; i < length/8; i++){
       for (int j = 0; j < 8; j++) {
           int sum = 0;
           for (int k = 0; k < 8; k++) {
               sum += (((message_in[k+8*i] >> j) & 1)*t[k]); 
           }
           message_out[j+8*i] = sum; 
       }

   }
   return message_out;
}	
