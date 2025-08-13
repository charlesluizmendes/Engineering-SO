// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.

#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBUCKET 13  // Prime number for good hash distribution

struct hashbucket {
  struct spinlock lock;
  struct buf *head;
};

struct {
  struct spinlock lock;
  struct buf buf[NBUF];
  struct hashbucket bucket[NBUCKET];
} bcache;

// Hash function for (dev, blockno)
static int
hash(uint dev, uint blockno)
{
  return (dev + blockno) % NBUCKET;
}

void
binit(void)
{
  struct buf *b;
  
  initlock(&bcache.lock, "bcache");
  
  // Initialize hash buckets
  for(int i = 0; i < NBUCKET; i++) {
    char name[32];
    snprintf(name, sizeof(name), "bcache.bucket_%d", i);
    initlock(&bcache.bucket[i].lock, name);
    bcache.bucket[i].head = 0;
  }
  
  // Initialize all buffers and add them to bucket 0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    initsleeplock(&b->lock, "buffer");
    b->next = bcache.bucket[0].head;
    bcache.bucket[0].head = b;
    b->refcnt = 0;
    b->valid = 0;
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;
  int bucket_id = hash(dev, blockno);
  
  acquire(&bcache.bucket[bucket_id].lock);
  
  // Is the block already cached in this bucket?
  for(b = bcache.bucket[bucket_id].head; b; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.bucket[bucket_id].lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  
  release(&bcache.bucket[bucket_id].lock);
  
  // Not cached. Need to find an unused buffer.
  // Look in all buckets for a buffer with refcnt == 0
  for(int i = 0; i < NBUCKET; i++) {
    acquire(&bcache.bucket[i].lock);
    
    struct buf *prev = 0;
    for(b = bcache.bucket[i].head; b; prev = b, b = b->next) {
      if(b->refcnt == 0) {
        // Found an unused buffer, remove it from current bucket
        if(prev)
          prev->next = b->next;
        else
          bcache.bucket[i].head = b->next;
        
        // Configure the buffer
        b->dev = dev;
        b->blockno = blockno;
        b->valid = 0;
        b->refcnt = 1;
        
        release(&bcache.bucket[i].lock);
        
        // Add to the correct bucket
        acquire(&bcache.bucket[bucket_id].lock);
        b->next = bcache.bucket[bucket_id].head;
        bcache.bucket[bucket_id].head = b;
        release(&bcache.bucket[bucket_id].lock);
        
        acquiresleep(&b->lock);
        return b;
      }
    }
    release(&bcache.bucket[i].lock);
  }
  
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;
  
  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
  
  releasesleep(&b->lock);
  
  int bucket_id = hash(b->dev, b->blockno);
  acquire(&bcache.bucket[bucket_id].lock);
  b->refcnt--;
  release(&bcache.bucket[bucket_id].lock);
}

void
bpin(struct buf *b) 
{
  int bucket_id = hash(b->dev, b->blockno);
  acquire(&bcache.bucket[bucket_id].lock);
  b->refcnt++;
  release(&bcache.bucket[bucket_id].lock);
}

void
bunpin(struct buf *b) 
{
  int bucket_id = hash(b->dev, b->blockno);
  acquire(&bcache.bucket[bucket_id].lock);
  b->refcnt--;
  release(&bcache.bucket[bucket_id].lock);
}