#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

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

// Array para contagem de referência das páginas
// Índice = endereço físico / PGSIZE
struct {
  struct spinlock lock;
  int ref_count[PHYSTOP / PGSIZE];
} ref_counts;

// Retorna o índice do array de referência para um endereço físico
static int
ref_index(uint64 pa)
{
  return pa / PGSIZE;
}

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&ref_counts.lock, "ref_counts");
  
  // Inicializa contadores de referência com 0
  for(int i = 0; i < PHYSTOP / PGSIZE; i++) {
    ref_counts.ref_count[i] = 0;
  }
  
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    // Inicializa a referência da página como 1 antes de liberá-la
    acquire(&ref_counts.lock);
    ref_counts.ref_count[ref_index((uint64)p)] = 1;
    release(&ref_counts.lock);
    kfree(p);
  }
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");
  
  // Decrementa contador de referência
  acquire(&ref_counts.lock);
  int idx = ref_index((uint64)pa);
  if(ref_counts.ref_count[idx] <= 0)
    panic("kfree: ref count");
  
  ref_counts.ref_count[idx]--;
  
  // Só libera a página se não há mais referências
  if(ref_counts.ref_count[idx] > 0) {
    release(&ref_counts.lock);
    return;
  }
  release(&ref_counts.lock);

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

  if(r) {
    memset((char*)r, 5, PGSIZE); // fill with junk
    
    // Inicializa contador de referência como 1
    acquire(&ref_counts.lock);
    ref_counts.ref_count[ref_index((uint64)r)] = 1;
    release(&ref_counts.lock);
  }

  return (void*)r;
}

// Incrementa contador de referência de uma página
void
inc_ref_count(uint64 pa)
{
  if(pa >= PHYSTOP)
    panic("inc_ref_count: pa too high");
  
  acquire(&ref_counts.lock);
  int idx = ref_index(pa);
  if(ref_counts.ref_count[idx] <= 0)
    panic("inc_ref_count: ref count");
  ref_counts.ref_count[idx]++;
  release(&ref_counts.lock);
}

// Retorna contador de referência de uma página
int
get_ref_count(uint64 pa)
{
  if(pa >= PHYSTOP)
    return 0;
  
  acquire(&ref_counts.lock);
  int count = ref_counts.ref_count[ref_index(pa)];
  release(&ref_counts.lock);
  return count;
}