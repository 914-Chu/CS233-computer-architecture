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
   char *temp_in = new char[length];
   for (int i = 0; i < length; i++) {
   	for(int j = 8; j > 0; j--) {
		for(int k = 0; k < length; k++){ 
			int *temp = new int[8];
			int sum = 0;
			int index = 0;
   			temp[k] = (message[k] >> j) & 1;
			
			for(int i = 1; i <= 128; i*=2) {
				sum += temp[index]*i;
			      	index++;
			}
		}
	}
   }
   return message_out;
}	
