#include <stdio.h>
#include <stdlib.h>
#include "filter.h"

// modify this code by fusing loops together
void
filter_fusion(pixel_t **image1, pixel_t **image2) {
    for (int i = 1; i < SIZE - 1; i ++) {
        if(i < SIZE -1) filter1(image1, image2, i);
	if(i > 1 && i < SIZE -2) filter2(image1, image2, i);
	if(i < SIZE && i > 5) filter3(image2, i-5);
    }
/*
    for (int i = 2; i < SIZE - 2; i ++) {
        filter2(image1, image2, i);
    }

    for (int i = 1; i < SIZE - 5; i ++) {
        filter3(image2, i);
    }
*/
}

// modify this code by adding software prefetching
void
filter_prefetch(pixel_t **image1, pixel_t **image2) {
/*
    for (int i = 1; i < SIZE - 1; i ++) {
        //for(int j = 0; j < 50; j++){
        //filter1(image1, image2, i);
	__builtin_prefetch(image1[i+30], 0, 3);
        __builtin_prefetch(image2[i+30], 1, 3); 
        //}
        //int j1 = 2;
        //int j2 = 1;
        filter1(image1, image2, i);
    }

    for (int i = 2; i < SIZE - 2; i ++) {
        //int j1 = 3; 
        //int j2 = 1;   
        //filter2(image1, image2, i); 
        __builtin_prefetch(&image1[i+30], 0, 3);                            
        __builtin_prefetch(&image2[i+30], 1, 3);   
 
    
        filter2(image1, image2, i);
        
    }

    for (int i = 1; i < SIZE - 5; i ++) {
        //int j1 = 3;   
        //int j2 = 5; 
	//filter3(image2, i);             
        __builtin_prefetch(image2[i+30], 0, 3);  
	//__builtin_prefetch(&a[i+j1], 0, 1);    
        //filter3(image2, i);
	__builtin_prefetch(image2[i+30], 1, 3);   
        filter3(image2, i);
    }
*/

	//int temp = 0;
	for (int i = 1 ; i < SIZE-1 ; i++) {
		//filter1(image1, image2, i);
    	 	__builtin_prefetch ((image1[i+10]), 0, 3);
    	 	__builtin_prefetch ((image2[i+10]), 1, 0);
                filter1(image1, image2, i);
	}

	for (int i = 2 ; i < SIZE-2 ; i ++) {
		//filter2(image1, image2, i);
    	 	__builtin_prefetch ((image1[i+10]), 0, 3);
    	 	__builtin_prefetch ((image2[i+10]), 1, 0);
    		//}
                filter2(image1, image2, i);
	}

	//temp = 0;
	for (int i = 1 ; i < SIZE-5 ; i ++) {
		//filter3(image2, i);
    	 	__builtin_prefetch ((image2[i+10]), 0, 0);
	       	__builtin_prefetch ((image2[i+10]), 1, 0);
		//}
                filter3(image2, i); 
	}

}

// modify this code by adding software prefetching and fusing loops together
void
filter_all(pixel_t **image1, pixel_t **image2) {

    for (int i = 1; i < SIZE - 1; i ++) {
	__builtin_prefetch ((image1[i+10]), 0, 3);                          
	__builtin_prefetch ((image2[i+10]), 1, 3);
        if(i < SIZE -1) {
	    filter1(image1, image2, i);
            //__builtin_prefetch ((image1[i+35]), 0, 3);
	    //__builtin_prefetch ((image2[i+35]), 1, 3);
	}
	if(i > 1 && i < SIZE-2){
            filter2(image1, image2, i);
	    //__builtin_prefetch ((image1[i+35]), 0, 3);    
    	    //__builtin_prefetch ((image2[i+35]), 1, 3);
        }
	if(i < SIZE && i > 5){
            filter3(image2, i - 5);
            //__builtin_prefetch ((image2[i+35]), 0, 3);
        }
    }

/*
    for (int i = 2; i < SIZE - 2; i ++) {
        filter2(image1, image2, i);
    }

    for (int i = 1; i < SIZE - 5; i ++) {
        filter3(image2, i);
    }
*/
}
