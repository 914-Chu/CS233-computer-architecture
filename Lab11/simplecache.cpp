#include "simplecache.h"
#include <iostream>

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  int index_range = _cache.size();
  for(int i = 0; i < index_range; i++){
     //std::cout << "8" << std::endl;
     if(i == index) {
         //std::cout << "10" << std::endl;  
         for(int j = 0; j < _associativity; j++){ 
             if(tag == _cache[i][j].tag() && _cache[i][j].valid()) {
                 //std::cout << "12" << std::endl;   
                 return _cache[i][j].get_byte(block_offset);
             }
         }
     }
  }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign (see "C++ Rule of Three")
    int index_range = _cache.size(); 
    for(int i = 0; i < index_range; i++){                                                         
        //std::cout << "26" << std::endl;                                                          
        if(i == index) {                                                                          
        //std::cout << "28" << std::endl;      
            //bool inserted = false;                                                     
            for(int j = 0; j < _associativity; j++){                                              
                if(!_cache[i][j].valid()) {                          
               //std::cout << "32" << std::endl;                                              
                   _cache[i][j].replace(tag, data);
                   break;
                }else if(j+1 == _associativity) _cache[i][0].replace(tag, data); 
             }                      
        }  
    }
}
