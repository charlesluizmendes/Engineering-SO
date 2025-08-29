1. kenel/bio.c:

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


2. kernel/kalloc.c:

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem[NCPU];

void
kinit()
{
  // Initialize locks for each CPU
  for(int i = 0; i < NCPU; i++) {
    char name[16];
    snprintf(name, sizeof(name), "kmem_%d", i);
    initlock(&kmem[i].lock, name);
    kmem[i].freelist = 0;
  }
  freerange(end, (void*)PHYSTOP);
}

void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  // Add to current CPU's free list
  push_off(); // Disable interrupts to prevent migration
  int cpu = cpuid();
  acquire(&kmem[cpu].lock);
  r->next = kmem[cpu].freelist;
  kmem[cpu].freelist = r;
  release(&kmem[cpu].lock);
  pop_off(); // Re-enable interrupts
}

void *
kalloc(void)
{
  struct run *r;

  push_off(); // Disable interrupts to prevent migration
  int cpu = cpuid();
  
  acquire(&kmem[cpu].lock);
  r = kmem[cpu].freelist;
  if(r)
    kmem[cpu].freelist = r->next;
  release(&kmem[cpu].lock);

  // If our CPU's list is empty, try to steal from other CPUs
  if(!r) {
    for(int i = 0; i < NCPU; i++) {
      if(i == cpu) continue; // Skip our own CPU
      
      acquire(&kmem[i].lock);
      r = kmem[i].freelist;
      if(r) {
        kmem[i].freelist = r->next;
        release(&kmem[i].lock);
        break;
      }
      release(&kmem[i].lock);
    }
  }

  pop_off(); // Re-enable interrupts

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}