#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  argint(0, &n);
  
  addr = myproc()->sz;
  
  printf("sys_sbrk: n=%d, addr=0x%x, addr%%2MB=%d\n", n, addr, addr % (2 * 1024 * 1024));
  
  // Para alocações grandes (>= 2MB), tentar usar superpages
  if(n >= 2 * 1024 * 1024){
    printf("sys_sbrk: large allocation, trying to use superpages\n");
    
    uint64 current_addr = addr;
    uint64 target_addr = addr + n;
    
    // Primeiro, alocar páginas normais até próximo boundary de 2MB
    uint64 next_2mb_boundary = (((current_addr) + (2*1024*1024) - 1) & ~((2*1024*1024) - 1));
    
    printf("sys_sbrk: current=0x%lx, next_boundary=0x%lx, target=0x%lx\n", 
           current_addr, next_2mb_boundary, target_addr);
    
    // Se há pelo menos uma região de 2MB para usar superpage
    if(next_2mb_boundary + (2*1024*1024) <= target_addr) {
      printf("sys_sbrk: can use superpage(s)\n");
      
      // Crescer até o boundary com páginas normais
      if(next_2mb_boundary > current_addr) {
        int pages_to_boundary = next_2mb_boundary - current_addr;
        printf("sys_sbrk: growing %d bytes to reach boundary\n", pages_to_boundary);
        if(growproc(pages_to_boundary) < 0)
          return -1;
        current_addr = myproc()->sz;
      }
      
      // Agora usar superpages para regiões de 2MB
      while(current_addr + (2*1024*1024) <= target_addr) {
        printf("sys_sbrk: trying superpage at 0x%lx\n", current_addr);
        
        void *mem = superalloc();
        if(mem != 0) {
          printf("sys_sbrk: got superpage at %p\n", mem);
          
          if(map_superpage(myproc()->pagetable, current_addr, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) == 0) {
            printf("sys_sbrk: successfully mapped superpage\n");
            myproc()->sz += (2*1024*1024);
            current_addr += (2*1024*1024);
            continue;
          } else {
            printf("sys_sbrk: failed to map superpage\n");
            superfree(mem);
          }
        }
        
        // Fallback: usar páginas normais para esta região de 2MB
        printf("sys_sbrk: using normal pages for 2MB region\n");
        if(growproc(2*1024*1024) < 0)
          return -1;
        current_addr = myproc()->sz;
      }
      
      // Resto com páginas normais
      if(current_addr < target_addr) {
        int remaining = target_addr - current_addr;
        printf("sys_sbrk: allocating remaining %d bytes with normal pages\n", remaining);
        if(growproc(remaining) < 0)
          return -1;
      }
      
      return addr;
    }
  }
  
  // Usar sistema normal para alocações pequenas
  if(growproc(n) < 0)
    return -1;
  
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


#ifdef LAB_PGTBL
int
sys_pgpte(void)
{
  uint64 va;
  struct proc *p;  

  p = myproc();
  argaddr(0, &va);
  pte_t *pte = pgpte(p->pagetable, va);
  if(pte != 0) {
      return (uint64) *pte;
  }
  return 0;
}
#endif

#ifdef LAB_PGTBL
int
sys_kpgtbl(void)
{
  struct proc *p;  

  p = myproc();
  vmprint(p->pagetable);
  return 0;
}
#endif


uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
