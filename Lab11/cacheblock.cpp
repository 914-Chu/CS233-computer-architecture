#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t tag_shift = _cache_config.get_num_block_offset_bits() + _cache_config.get_num_index_bits();
  uint32_t index_shift = _cache_config.get_num_block_offset_bits();
  return (_tag << tag_shift) | (_index << index_shift);
}
