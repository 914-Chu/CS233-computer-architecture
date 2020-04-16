#include "cachesimulator.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.
   */
  vector<Cache::Block*> blocks = _cache->get_blocks_in_set(extract_index(address, _cache->get_config()));
  uint32_t tag = extract_tag(address, _cache->get_config());
  for(auto b  : blocks){
      if(b->is_valid() && b->get_tag() == tag){
          _hits++;
          return b;
      }
  }
  return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */
  vector<Cache::Block*> blocks = _cache->get_blocks_in_set(extract_index(address, _cache->get_config()));
  uint32_t tag = extract_tag(address, _cache->get_config());
  Cache::Block* temp = blocks[0];
  for(auto b : blocks) {
      if(!b->is_valid()){
          b->set_tag(tag);
          b->read_data_from_memory(_memory);
          b->mark_as_valid();
          b->mark_as_clean();
          //++_use_clock;
          //b->set_last_used_time(_use_clock.get_count());
          return b;
      }
      if(b->get_last_used_time() < temp->get_last_used_time()){
          temp = b;
      }
  }
  if(temp->is_dirty()) temp->write_data_to_memory(_memory);
  temp->set_tag(tag);
  temp->read_data_from_memory(_memory);
  temp->mark_as_valid();
  temp->mark_as_clean();
  //++_use_clock;
  //temp->set_last_used_time(_use_clock.get_count());
  return temp;
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */
  Cache::Block* target = find_block(address);
  if(target == NULL) target = bring_block_into_cache(address);
  _use_clock++;
  target->set_last_used_time(_use_clock.get_count());  
  uint32_t offset = extract_block_offset(address, _cache->get_config());
  return target->read_word_at_offset(offset);
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */
  Cache::Block* target = find_block(address); 
  if(target == NULL) {
      if(_policy.is_write_allocate()) target = bring_block_into_cache(address);
      else {
          _memory->write_word(address, word);
          return;
      }
  }
  uint32_t offset = extract_block_offset(address, _cache->get_config());
  _use_clock++;
  target->set_last_used_time(_use_clock.get_count());
  target->write_word_at_offset(word, offset);
  if(_policy.is_write_back()) target->mark_as_dirty();
  else _memory->write_word(address, word);
}
