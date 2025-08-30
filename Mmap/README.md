1. Markfile:

$U/_mmaptest\

kernel/defs.h:

struct vma;  // Forward declaration for mmap
void            munmap_vma(struct vma *vma);
int             mmap_handler(uint64 va, struct vma *vma);



2. kernel/fcntj.h:

#define PROT_READ       0x1
#define PROT_WRITE      0x2
#define PROT_EXEC       0x4

// mmap flags
#define MAP_SHARED      0x01
#define MAP_PRIVATE     0x02



3. kernel/nenkayout.h:

#define MMAPBASE (MAXVA - MMAPSIZE)
#define MMAPSIZE (128 * PGSIZE) 



4. kernel/proc.c:

#include "sleeplock.h"    // ← Adicionar se não existir
#include "fs.h"           // ← Adicionar se não existir
#include "file.h"         // ← Adicionar se não existir
#include "fcntl.h"   

static struct proc*
allocproc(void)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == UNUSED) {
      goto found;
    } else {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;

  // Allocate a trapframe page.
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
  if(p->pagetable == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // Initialize VMAs
  for (int i = 0; i < NVMA; i++) {
    p->vmas[i].used = 0;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;

  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if(p->trapframe)
    kfree((void*)p->trapframe);
  p->trapframe = 0;
  
  if(p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  
  // Clean up VMAs
  for (int i = 0; i < NVMA; i++) {
    if (p->vmas[i].used) {
      fileclose(p->vmas[i].f);
      p->vmas[i].used = 0;
    }
  }
  
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}

void
exit(int status)
{
  struct proc *p = myproc();

  if(p == initproc)
    panic("init exiting");

  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd]){
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  // Unmap all VMAs and write back MAP_SHARED pages
  for (int i = 0; i < NVMA; i++) {
    if (p->vmas[i].used) {
      struct vma *vma = &p->vmas[i];
      
      if (vma->flags == MAP_SHARED) {
        begin_op();  // Início da transação
        
        // Write back dirty pages
        for (uint64 addr = vma->addr; addr < vma->addr + vma->len; addr += PGSIZE) {
          pte_t *pte = walk(p->pagetable, addr, 0);
          if (pte && (*pte & PTE_V)) {
            uint64 pa = PTE2PA(*pte);
            uint64 file_offset = addr - vma->addr;  // Remove vma->offset since it's always 0
            
            // Calculate bytes to write for this page
            uint64 bytes_to_write = PGSIZE;
            if (file_offset + PGSIZE > vma->len) {
              bytes_to_write = vma->len - file_offset;
            }
            
            if (bytes_to_write > 0) {
              ilock(vma->f->ip);
              writei(vma->f->ip, 0, pa, file_offset, bytes_to_write);
              iunlock(vma->f->ip);
            }
          }
        }
        
        end_op();  // Fim da transação
      }
      
      fileclose(vma->f);
      vma->used = 0;
    }
  }

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  acquire(&wait_lock);

  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup(p->parent);
  
  acquire(&p->lock);

  p->xstate = status;
  p->state = ZOMBIE;

  release(&wait_lock);

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}


5. kernel/proc.h:

#define NVMA 16

struct vma {
  int used;                    // 1 if this VMA is being used, 0 otherwise
  uint64 addr;                // Starting virtual address
  uint64 len;                 // Length in bytes
  int prot;                   // Protection (PROT_READ, PROT_WRITE)
  int flags;                  // MAP_SHARED or MAP_PRIVATE
  struct file *f;             // Pointer to mapped file
  uint64 offset;              // Offset in the file (for this lab, always 0)
};

  struct vma vmas[NVMA];        // Virtual memory areas



6. kernel/syscall.c:

extern uint64 sys_mmap(void);
extern uint64 sys_munmap(void);

[SYS_mmap]   sys_mmap,
[SYS_munmap] sys_munmap,




7. kernel/syscall.h:

#define SYS_mmap   22
#define SYS_munmap 23




8. kernel/sysfile.c:

#include "memlayout.h" 

uint64
sys_mmap(void)
{
  uint64 addr;
  int len, prot, flags, fd;
  uint64 offset;
  struct file *f;
  struct proc *p = myproc();

  // Get arguments from user
  argaddr(0, &addr);
  argint(1, &len);
  argint(2, &prot);
  argint(3, &flags);
  argint(4, &fd);
  argaddr(5, &offset);

  // For this lab, addr should be 0 and offset should be 0
  if (addr != 0 || offset != 0)
    return 0xffffffffffffffff;

  // Get the file
  if ((f = myproc()->ofile[fd]) == 0)
    return 0xffffffffffffffff;

  // Check if file is readable if PROT_READ
  if (prot & PROT_READ && !f->readable)
    return 0xffffffffffffffff;

  // Check if file is writable if PROT_WRITE and MAP_SHARED
  if (prot & PROT_WRITE && flags == MAP_SHARED && !f->writable)
    return 0xffffffffffffffff;

  // Find unused VMA
  struct vma *vma = 0;
  for (int i = 0; i < NVMA; i++) {
    if (p->vmas[i].used == 0) {
      vma = &p->vmas[i];
      break;
    }
  }
  if (vma == 0)
    return 0xffffffffffffffff;

  // Find unused virtual address space
  uint64 va = MMAPBASE;
  for (uint64 test_va = MMAPBASE; test_va < MMAPBASE + MMAPSIZE; test_va += PGSIZE) {
    int overlap = 0;
    for (int i = 0; i < NVMA; i++) {
      if (p->vmas[i].used && 
          test_va < p->vmas[i].addr + p->vmas[i].len &&
          test_va + len > p->vmas[i].addr) {
        overlap = 1;
        break;
      }
    }
    if (!overlap && test_va + len <= MMAPBASE + MMAPSIZE) {
      va = test_va;
      break;
    }
  }

  // Set up VMA
  vma->used = 1;
  vma->addr = va;
  vma->len = len;
  vma->prot = prot;
  vma->flags = flags;
  vma->f = f;
  vma->offset = offset;
  filedup(f);  // Increase reference count

  return va;
}

uint64
sys_munmap(void)
{
  uint64 addr;
  int len;
  struct proc *p = myproc();

  argaddr(0, &addr);
  argint(1, &len);

  // Find VMA containing this address
  struct vma *vma = 0;
  for (int i = 0; i < NVMA; i++) {
    if (p->vmas[i].used && 
        addr >= p->vmas[i].addr && 
        addr < p->vmas[i].addr + p->vmas[i].len) {
      vma = &p->vmas[i];
      break;
    }
  }

  if (vma == 0)
    return -1;

  // Write back dirty pages if MAP_SHARED before unmapping
  if (vma->flags == MAP_SHARED) {
    begin_op();  // Início da transação
    
    for (uint64 va = addr; va < addr + len; va += PGSIZE) {
      // Make sure we don't go beyond the VMA
      if (va >= vma->addr + vma->len)
        break;
        
      pte_t *pte = walk(p->pagetable, va, 0);
      if (pte && (*pte & PTE_V)) {
        // Page is present, write it back
        uint64 pa = PTE2PA(*pte);
        uint64 file_offset = va - vma->addr;  // Remove vma->offset since it's always 0
        
        // Calculate bytes to write for this page
        uint64 bytes_to_write = PGSIZE;
        if (file_offset + PGSIZE > vma->len) {
          bytes_to_write = vma->len - file_offset;
        }
        
        if (bytes_to_write > 0) {
          ilock(vma->f->ip);
          writei(vma->f->ip, 0, pa, file_offset, bytes_to_write);
          iunlock(vma->f->ip);
        }
      }
    }
    
    end_op();  // Fim da transação
  }

  // Unmap pages
  uvmunmap(p->pagetable, addr, len/PGSIZE, 1);

  // Check if we're unmapping the entire region or just the beginning/end
  if (addr == vma->addr && len >= vma->len) {
    // Unmapping entire region
    fileclose(vma->f);
    vma->used = 0;
  } else if (addr == vma->addr) {
    // Unmapping from beginning
    vma->addr += len;
    vma->len -= len;
  } else if (addr + len == vma->addr + vma->len) {
    // Unmapping from end
    vma->len -= len;
  } else {
    // Middle unmapping not supported in this lab
    return -1;
  }

  return 0;
}

void
munmap_vma(struct vma *vma)
{
  struct proc *p = myproc();
  
  // Write back dirty pages if MAP_SHARED
  if (vma->flags == MAP_SHARED) {
    begin_op();  // Início da transação
    
    for (uint64 addr = vma->addr; addr < vma->addr + vma->len; addr += PGSIZE) {
      pte_t *pte = walk(p->pagetable, addr, 0);
      if (pte && (*pte & PTE_V)) {
        // Page is present, write it back
        uint64 pa = PTE2PA(*pte);
        uint64 file_offset = addr - vma->addr;  // Remove vma->offset since it's always 0
        
        // Make sure we don't write beyond the mapped length
        uint64 bytes_to_write = PGSIZE;
        if (file_offset + PGSIZE > vma->len) {
          bytes_to_write = vma->len - file_offset;
        }
        
        if (bytes_to_write > 0) {
          // Lock the inode and write
          ilock(vma->f->ip);
          int written = writei(vma->f->ip, 0, pa, file_offset, bytes_to_write);
          iunlock(vma->f->ip);
          
          if (written != bytes_to_write) {
            printf("munmap_vma: error writing back page at addr %p (wrote %d, expected %d)\n", 
                   (void*)addr, written, (int)bytes_to_write);
          }
        }
      }
    }
    
    end_op();  // Fim da transação
  }

  // Close file
  fileclose(vma->f);
  vma->used = 0;
}




9.kernel/trap.c:

#include "sleeplock.h"  // DEVE vir antes de file.h
#include "fs.h"         // DEVE vir antes de file.h (define NDIRECT)
#include "file.h"       // Agora pode ser incluído
#include "fcntl.h"  

void
usertrap(void)
{
  int which_dev = 0;

  if((r_sstatus() & SSTATUS_SPP) != 0)
    panic("usertrap: not from user mode");

  // send interrupts and exceptions to kerneltrap(),
  // since we're now in the kernel.
  w_stvec((uint64)kernelvec);

  struct proc *p = myproc();
  
  // save user program counter.
  p->trapframe->epc = r_sepc();
  
  if(r_scause() == 8){
    // system call

    if(killed(p))
      exit(-1);

    // sepc points to the ecall instruction,
    // but we want to return to the next instruction.
    p->trapframe->epc += 4;

    // an interrupt will change sepc, scause, and sstatus,
    // so enable only now that we're done with those registers.
    intr_on();

    syscall();
  } else if((which_dev = devintr()) != 0){
    // ok
  } else if(r_scause() == 13 || r_scause() == 15) {
    // Page fault - load page fault (13) or store page fault (15)
    uint64 va = r_stval();
    
    // Check if this is a mmap-related page fault
    struct vma *vma = 0;
    
    // Find VMA containing the faulting address
    for (int i = 0; i < NVMA; i++) {
      if (p->vmas[i].used && 
          va >= p->vmas[i].addr && 
          va < p->vmas[i].addr + p->vmas[i].len) {
        vma = &p->vmas[i];
        break;
      }
    }
    
    if (vma) {
      // This is a mmap page fault
      // Check if it's a write to a read-only mapping
      if (r_scause() == 15 && !(vma->prot & PROT_WRITE)) {
        printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
        printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
        setkilled(p);
      } else if (mmap_handler(va, vma) < 0) {
        setkilled(p);
      }
    } else {
      // Regular page fault - not in any VMA
      printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
      printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
      setkilled(p);
    }
  } else {
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    setkilled(p);
  }

  if(killed(p))
    exit(-1);

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2)
    yield();

  usertrapret();
}

int
mmap_handler(uint64 va, struct vma *vma)
{
  struct proc *p = myproc();
  uint64 pa;
  uint flags = PTE_U;
  
  // Check permissions
  if (vma->prot & PROT_READ)
    flags |= PTE_R;
  if (vma->prot & PROT_WRITE)
    flags |= PTE_W;
  if (vma->prot & PROT_EXEC)
    flags |= PTE_X;
    
  // Allocate physical page
  if ((pa = (uint64)kalloc()) == 0)
    return -1;
  memset((void*)pa, 0, PGSIZE);
  
  // Calculate offset in file
  uint64 offset = (va - vma->addr) + vma->offset;
  
  // Read from file
  ilock(vma->f->ip);
  int bytes_read = readi(vma->f->ip, 0, pa, offset, PGSIZE);
  iunlock(vma->f->ip);
  
  if (bytes_read < 0) {
    kfree((void*)pa);
    return -1;
  }
  
  // Map the page
  va = PGROUNDDOWN(va);
  if (mappages(p->pagetable, va, PGSIZE, pa, flags) != 0) {
    kfree((void*)pa);
    return -1;
  }
  
  return 0;
}



10. user/user.h:

void* mmap(void *addr, int len, int prot, int flags, int fd, int offset);
int munmap(void *addr, int len);

user/usys.pl:

entry("mmap");
entry("munmap");



mmaptest