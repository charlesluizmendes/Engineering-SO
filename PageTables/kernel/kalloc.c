// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

struct {
  struct spinlock lock;
  void *freelist[8];  // Pool de superpages
  int count;
} supermem;

#define SUPERPAGE_SIZE (2 * 1024 * 1024)  // 2MB

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
  
  // Chamar inicialização de superpages separadamente
  superinit();
}

void
superinit()
{
  initlock(&supermem.lock, "supermem");
  supermem.count = 0;
  
  // Começar bem longe do fim do kernel
  uint64 start = PGROUNDUP((uint64)end);
  start += 64 * PGSIZE;  
  
  uint64 aligned = (start + SUPERPAGE_SIZE - 1) & ~(SUPERPAGE_SIZE - 1);
  
  if(aligned + 8 * SUPERPAGE_SIZE > PHYSTOP){  // Aumentar para 8
    printf("superinit: not enough memory for superpages\n");
    return;
  }
  
  // Alocar 8 superpages em vez de 4
  for(int i = 0; i < 8 && aligned + SUPERPAGE_SIZE <= PHYSTOP; i++){
    if(supermem.count < 8){
      supermem.freelist[supermem.count++] = (void*)aligned;
      printf("superinit: reserved superpage at %p\n", (void*)aligned);
    }
    aligned += SUPERPAGE_SIZE;
  }
}

// Alocar uma superpage (2MB)
void*
superalloc(void)
{
  void *r;
  
  acquire(&supermem.lock);
  printf("superalloc: free_count=%d\n", supermem.count);
  if(supermem.count > 0){
    r = supermem.freelist[--supermem.count];
    memset(r, 0, SUPERPAGE_SIZE);
    printf("superalloc: allocated %p, remaining=%d\n", r, supermem.count);
  } else {
    r = 0;
    printf("superalloc: no superpages available!\n");
  }
  release(&supermem.lock);
  
  return r;
}

void
superfree(void *pa)
{
  // Se não está alinhado em 2MB, não é uma superpage nossa
  if(((uint64)pa % SUPERPAGE_SIZE) != 0){
    printf("superfree: ignoring non-aligned address %p\n", pa);
    return;
  }

  acquire(&supermem.lock);
  if(supermem.count < 8){
    supermem.freelist[supermem.count++] = pa;
    printf("superfree: freed superpage %p\n", pa);
  }
  release(&supermem.lock);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
