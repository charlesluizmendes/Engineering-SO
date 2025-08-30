## Arquivo:
kernel/riscv.h

## Codigo:
```c
#define PTE_COW (1L << 8) // COW mapping (usa bit RSW)
```
## Explicação:
Define um novo *flag* de PTE (`PTE_COW`) reutilizando um dos bits RSW para marcar mapeamentos Copy-on-Write. Esse bit será usado para detectar *page faults* de escrita em páginas compartilhadas entre processos.

---

## Arquivo:
kernel/kalloc.c - Sistema de contagem de referência

## Codigo:
```c
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
```
## Explicação:
Implementa contagem de referência por página para suportar COW: cada página física tem um contador (inicializado em `freerange` e `kalloc`), incrementado em compartilhamentos e decrementado em `kfree`. A página só retorna à *freelist* quando o contador zera, evitando *free* prematuro de páginas ainda compartilhadas.

---

## Arquivo:
kernel/defs.h - Adicionar protótipos das funções

## Codigo:
```c
// kalloc.c
void*           kalloc(void);
void            kfree(void *);
void            kinit(void);
void            inc_ref_count(uint64);  // Nova função
int             get_ref_count(uint64);  // Nova função
```
## Explicação:
Expõe as novas funções de contagem de referência (`inc_ref_count` e `get_ref_count`) para que outros módulos (ex.: `vm.c`) possam atualizar e consultar o estado de compartilhamento das páginas.

---

## Arquivo:
kernel/vm.c - Modificar uvmcopy() e copyout()

## Codigo:
```c
// Modifica a função uvmcopy() existente
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");

    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);

    // Se a página é writeable, torna-se COW
    if(flags & PTE_W) {
      // Remove PTE_W e adiciona PTE_COW
      flags = (flags & ~PTE_W) | PTE_COW;
      // Atualiza PTE do parent também
      *pte = PA2PTE(pa) | flags;
    }

    // Mapeia a mesma página física no child
    if(mappages(new, i, PGSIZE, pa, flags) != 0) {
      goto err;
    }

    // Incrementa contador de referência
    inc_ref_count(pa);
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
  return -1;
}

// Adiciona nova função para lidar com falhas de página COW
int
cow_fault(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;
  uint flags;
  char *mem;

  if(va >= MAXVA)
    return -1;

  if((pte = walk(pagetable, va, 0)) == 0)
    return -1;

  if((*pte & PTE_V) == 0)
    return -1;

  if((*pte & PTE_COW) == 0)
    return -1;

  pa = PTE2PA(*pte);
  flags = PTE_FLAGS(*pte);

  // Remove PTE_COW e adiciona PTE_W
  flags = (flags & ~PTE_COW) | PTE_W;

  // Se há apenas uma referência, pode reusar a página
  if(get_ref_count(pa) == 1) {
    *pte = PA2PTE(pa) | flags;
    return 0;
  }

  // Aloca nova página
  if((mem = kalloc()) == 0)
    return -1;

  // Copia conteúdo da página original
  memmove(mem, (char*)pa, PGSIZE);

  // Atualiza PTE para apontar para a nova página
  *pte = PA2PTE(mem) | flags;

  // Decrementa referência da página original
  kfree((char*)pa);

  return 0;
}

// Modifica a função copyout() existente
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    va0 = PGROUNDDOWN(dstva);

    if((pte = walk(pagetable, va0, 0)) == 0)
      return -1;
    if((*pte & PTE_V) == 0)
      return -1;

    // Verifica se é página COW
    if(*pte & PTE_COW) {
      if(cow_fault(pagetable, va0) != 0)
        return -1;
      // Recarrega pte após cow_fault
      if((pte = walk(pagetable, va0, 0)) == 0)
        return -1;
    }

    if((*pte & PTE_W) == 0)
      return -1;

    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);

    len -= n;
    src += n;
    dstva = va0 + PGSIZE;
  }
  return 0;
}
```
## Explicação:
Em `uvmcopy`, páginas *writable* passam a ser mapeadas como COW (remove `PTE_W`, adiciona `PTE_COW`) tanto no pai quanto no filho, e o contador de referência da página física é incrementado.  
A nova `cow_fault` trata *page faults* de escrita em páginas COW: se a página ainda é compartilhada (refcount > 1), aloca uma nova página e copia os dados; caso contrário, apenas troca COW→W.  
Em `copyout`, antes de escrever, detecta COW e invoca `cow_fault` para garantir que a escrita ocorra numa página privada e gravável.

---

## Arquivo:
kernel/trap.c - Modificar usertrap()

## Codigo:
```c
// Na função usertrap(), adiciona tratamento para page faults COW
// Localiza a seção que trata page faults e adiciona:

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
  } else {
    uint64 cause = r_scause();

    // Trata page fault de escrita (causa 15)
    if(cause == 15) {
      uint64 va = r_stval();

      // Tenta tratar como COW fault
      if(va < p->sz && cow_fault(p->pagetable, va) == 0) {
        // COW fault tratada com sucesso
      } else {
        // Não é COW fault ou falhou - mata o processo
        printf("usertrap(): unexpected scause %lx pid=%d
", r_scause(), p->pid);
        printf("            sepc=%lx stval=%lx
", r_sepc(), r_stval());
        setkilled(p);
      }
    } else {
      printf("usertrap(): unexpected scause %lx pid=%d
", r_scause(), p->pid);
      printf("            sepc=%lx stval=%lx
", r_sepc(), r_stval());
      setkilled(p);
    }
  }

  if(killed(p))
    exit(-1);

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2)
    yield();

  usertrapret();
}
```
## Explicação:
Amplia `usertrap` para capturar *page faults* de escrita (scause=15) vindos do modo usuário. Quando ocorre em uma página marcada COW, delega a correção para `cow_fault`. Se não for COW ou falhar, o processo é finalizado, preservando a robustez do kernel.

---

## Arquivo:
kernel/defs.h - Adicionar protótipo cow_fault

## Codigo:
```c
// Na seção de vm.c, adiciona:
int             cow_fault(pagetable_t, uint64);
```
## Explicação:
Expõe o protótipo de `cow_fault` para que `trap.c` (e outros módulos) possam invocá-la ao lidar com *page faults* de escrita em páginas COW.


# Testes

```
$ make clean
$ make qemu
$ cowtest
$ usertests -q
```