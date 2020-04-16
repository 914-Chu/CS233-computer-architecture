#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t output;
  uint32_t tag_bits = cache_config.get_num_tag_bits();
  uint32_t from = cache_config.get_num_index_bits() + cache_config.get_num_block_offset_bits();
  if(tag_bits < 32){
  	uint32_t mask = (((1<<tag_bits)-1) << from);
        output = (mask & address) >> from;
  }else output = address;
  return output;
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t index_bits = cache_config.get_num_index_bits();
  uint32_t from = cache_config.get_num_block_offset_bits();
  uint32_t mask = (((1<<index_bits)-1) << from);
  return (mask & address) >> from;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t offset_bits = cache_config.get_num_block_offset_bits();
  uint32_t mask = ((1<<offset_bits)-1);
  return mask & address;
}
