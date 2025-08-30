## Arquivo:
kernel/defs.h

## Codigo:
```c
void            vmprint(pagetable_t);  // ADICIONAR ESTA LINHA

void            superinit(void);  // ADICIONAR
void*           superalloc(void);
void            superfree(void*);

int             growproc_super(int);

int             map_superpage(pagetable_t, uint64, uint64, int);
uint64          uvmalloc_super(pagetable_t, uint64, uint64);
```
## Explicação:
Adiciona protótipos para depuração de TLB/VM (`vmprint`), gerenciamento de **superpages** (2MB) e rotas especializadas de crescimento/allocação de memória de usuário (inclui `map_superpage` e `uvmalloc_super`).

---

## Arquivo:
kernel/kalloc.c

## Codigo:
```c
struct {
  struct spinlock lock;
  void *freelist[8];  // Pool de superpages
  int count;
} supermem;
```

### Em kinit():
```c
  superinit();
```

```c
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
    printf("superinit: not enough memory for superpages
");
    return;
  }
  
  // Alocar 8 superpages em vez de 4
  for(int i = 0; i < 8 && aligned + SUPERPAGE_SIZE <= PHYSTOP; i++){
    if(supermem.count < 8){
      supermem.freelist[supermem.count++] = (void*)aligned;
      printf("superinit: reserved superpage at %p
", (void*)aligned);
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
  printf("superalloc: free_count=%d
", supermem.count);
  if(supermem.count > 0){
    r = supermem.freelist[--supermem.count];
    memset(r, 0, SUPERPAGE_SIZE);
    printf("superalloc: allocated %p, remaining=%d
", r, supermem.count);
  } else {
    r = 0;
    printf("superalloc: no superpages available!
");
  }
  release(&supermem.lock);
  
  return r;
}

void
superfree(void *pa)
{
  // Se não está alinhado em 2MB, não é uma superpage nossa
  if(((uint64)pa % SUPERPAGE_SIZE) != 0){
    printf("superfree: ignoring non-aligned address %p
", pa);
    return;
  }

  acquire(&supermem.lock);
  if(supermem.count < 8){
    supermem.freelist[supermem.count++] = pa;
    printf("superfree: freed superpage %p
", pa);
  }
  release(&supermem.lock);
}
```
## Explicação:
Cria um **pool de superpages** gerenciado por `supermem` (até 8 regiões de 2MB). `superinit` reserva e alinha fisicamente, `superalloc`/`superfree` gerenciam o pool com logs de depuração.

---

## Arquivo:
kernel/param.h

## Codigo:
```c
#define SUPERPAGE_SIZE (2 * 1024 * 1024)  // 2MB
```
## Explicação:
Define o tamanho da superpage (2 MiB), usado em alocação e mapeamento.

---

## Arquivo:
kernel/memlayout.h

## Codigo:
```c
#ifndef __ASSEMBLER__
struct usyscall {
  int pid;  // Process ID
};
#endif
```
## Explicação:
Cria uma página de dados **USYSCALL** no espaço do usuário para *fast path* de informações simples (ex.: `pid`).

---

## Arquivo:
kernel/proc.c

## Codigo:
```c
// Allocate a USYSCALL page - ADICIONAR ESTA SEÇÃO
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }
  p->usyscall->pid = p->pid;
```

```c
// ADICIONAR: free USYSCALL page
  if(p->usyscall)
    kfree((void*)p->usyscall);
  p->usyscall = 0;
```

```c
// ADICIONAR: map the USYSCALL page
  if(mappages(pagetable, USYSCALL, PGSIZE,
              (uint64)(p->usyscall), PTE_R | PTE_U) < 0){
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }
```

```c
  uvmunmap(pagetable, USYSCALL, 1, 0);  // ADICIONAR ESTA LINHA
```

```c
// Função para crescer processo usando superpages
int
growproc_super(int n)
{
  uint64 sz, newsz;
  struct proc *p = myproc();

  sz = p->sz;
  if(n > 0){
    newsz = sz + n;
    
    // Usar nossa função especializada
    if((newsz = uvmalloc_super(p->pagetable, sz, newsz)) == 0) {
      return -1;
    }
    p->sz = newsz;
  } else if(n < 0){
    newsz = uvmdealloc(p->pagetable, sz, sz + n);
    p->sz = newsz;
  }
  return 0;
}
```
## Explicação:
Aloca, mapeia e libera a página **USYSCALL** no ciclo de vida do processo. Introduz `growproc_super` para expansão de heap com tentativa de usar superpages.

---

## Arquivo:
kernel/riscv.h

## Codigo:
```c
#define PTE_LEAF(pte) (((pte) & PTE_R) | ((pte) & PTE_W) | ((pte) & PTE_X))
```
## Explicação:
Macro utilitária para identificar PTEs **folha** (têm R/W/X).

---

## Arquivo:
Kernel/sysproc.h

## Codigo:
```c
Alterar sys_sbrk(void):

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  argint(0, &n);
  
  addr = myproc()->sz;
  
  printf("sys_sbrk: n=%d, addr=0x%x, addr%%2MB=%d
", n, addr, addr % (2 * 1024 * 1024));
  
  // Para alocações grandes (>= 2MB), tentar usar superpages
  if(n >= 2 * 1024 * 1024){
    printf("sys_sbrk: large allocation, trying to use superpages
");
    
    uint64 current_addr = addr;
    uint64 target_addr = addr + n;
    
    // Primeiro, alocar páginas normais até próximo boundary de 2MB
    uint64 next_2mb_boundary = (((current_addr) + (2*1024*1024) - 1) & ~((2*1024*1024) - 1));
    
    printf("sys_sbrk: current=0x%lx, next_boundary=0x%lx, target=0x%lx
", 
           current_addr, next_2mb_boundary, target_addr);
    
    // Se há pelo menos uma região de 2MB para usar superpage
    if(next_2mb_boundary + (2*1024*1024) <= target_addr) {
      printf("sys_sbrk: can use superpage(s)
");
      
      // Crescer até o boundary com páginas normais
      if(next_2mb_boundary > current_addr) {
        int pages_to_boundary = next_2mb_boundary - current_addr;
        printf("sys_sbrk: growing %d bytes to reach boundary
", pages_to_boundary);
        if(growproc(pages_to_boundary) < 0)
          return -1;
        current_addr = myproc()->sz;
      }
      
      // Agora usar superpages para regiões de 2MB
      while(current_addr + (2*1024*1024) <= target_addr) {
        printf("sys_sbrk: trying superpage at 0x%lx
", current_addr);
        
        void *mem = superalloc();
        if(mem != 0) {
          printf("sys_sbrk: got superpage at %p
", mem);
          
          if(map_superpage(myproc()->pagetable, current_addr, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) == 0) {
            printf("sys_sbrk: successfully mapped superpage
");
            myproc()->sz += (2*1024*1024);
            current_addr += (2*1024*1024);
            continue;
          } else {
            printf("sys_sbrk: failed to map superpage
");
            superfree(mem);
          }
        }
        
        // Fallback: usar páginas normais para esta região de 2MB
        printf("sys_sbrk: using normal pages for 2MB region
");
        if(growproc(2*1024*1024) < 0)
          return -1;
        current_addr = myproc()->sz;
      }
      
      // Resto com páginas normais
      if(current_addr < target_addr) {
        int remaining = target_addr - current_addr;
        printf("sys_sbrk: allocating remaining %d bytes with normal pages
", remaining);
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
```
## Explicação:
Optimiza `sbrk` para **alocações grandes**: alinha ao próximo limite de 2 MB, tenta superpages por blocos e faz *fallback* para páginas normais quando necessário, preservando o comportamento tradicional para alocações pequenas.

---

## Arquivo:
kernel/proc.h

## Codigo:
```c
  struct usyscall *usyscall;   // ADICIONAR ESTA LINHA - data page for syscall speedup
```
## Explicação:
Campo no `struct proc` para apontar para a página **USYSCALL** do processo.

---

## Arquivo:
kernel/vm.c

## Codigo:
```c
void
vmprint_recursive(pagetable_t pagetable, int level)
{
  for(int i = 0; i < 512; i++){
    pte_t pte = pagetable[i];
    if(pte & PTE_V){
      // Print dots for indentation
      for(int j = 0; j <= level; j++){
        printf(".. ");
      }
      
      uint64 va = (uint64)i << (12 + 9 * (2 - level));
      uint64 pa = PTE2PA(pte);
      
      printf("0x%016lx: pte 0x%016lx pa 0x%016lx
", va, pte, pa);
      
      // If not a leaf page, recurse
      if(level < 2 && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
        uint64 child = PTE2PA(pte);
        vmprint_recursive((pagetable_t)child, level + 1);
      }
    }
  }
}
```
---

### Alterar walk(pagetable_t pagetable, uint64 va, int alloc):
```c
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
  // Debug para superpages
  if(va >= 0x200000 && va <= 0x800000 && (va % SUPERPAGE_SIZE) == 0) {
    printf("walk: looking for va=0x%lx, alloc=%d
", va, alloc);
  }
  
  if(va >= MAXVA)
    panic("walk");
  
  for(int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      // Debug específico para nossos endereços
      if(va >= 0x200000 && va <= 0x800000 && (va % SUPERPAGE_SIZE) == 0) {
        printf("walk: level %d, pte=0x%lx, PTE_LEAF=%d
", level, *pte, PTE_LEAF(*pte) ? 1 : 0);
      }
      
      pagetable = (pagetable_t)PTE2PA(*pte);

      if(PTE_LEAF(*pte)) {
        if(va >= 0x200000 && va <= 0x800000 && (va % SUPERPAGE_SIZE) == 0) {
          printf("walk: found leaf PTE at level %d, pte=0x%lx, returning!
", level, *pte);
        }
        return pte;
      }

    } else {
      if(va >= 0x200000 && va <= 0x800000 && (va % SUPERPAGE_SIZE) == 0) {
        printf("walk: level %d, pte not valid (0x%lx)
", level, *pte);
      }
      
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  
  if(va >= 0x200000 && va <= 0x800000 && (va % SUPERPAGE_SIZE) == 0) {
    printf("walk: returning leaf level PTE
");
  }
  
  return &pagetable[PX(0, va)];
}
```

---

### Alterar uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free):
```c
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages * PGSIZE; a += PGSIZE){
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
      panic("uvmunmap: not a leaf");

    if(do_free){
      uint64 pa = PTE2PA(*pte);
      
      // Se PA está no range das superpages E endereço está alinhado, é superpage
      if(pa >= 0x80200000 && pa <= 0x81200000 && (pa % SUPERPAGE_SIZE) == 0 && 
         (a % SUPERPAGE_SIZE) == 0) {
        printf("uvmunmap: freeing superpage at pa=0x%lx
", pa);
        superfree((void*)pa);
        // Pular o resto da superpage
        uint64 end_superpage = (a & ~(SUPERPAGE_SIZE - 1)) + SUPERPAGE_SIZE;
        for(uint64 b = a; b < end_superpage && b < va + npages * PGSIZE; b += PGSIZE) {
          pte_t *pte_b = walk(pagetable, b, 0);
          if(pte_b) *pte_b = 0;
        }
        a = end_superpage - PGSIZE; // -PGSIZE porque o loop fará +=PGSIZE
      } else {
        kfree((void*)pa);
        *pte = 0;
      }
    } else {
      *pte = 0;
    }
  }
}
```

---

### Alterar uvmcopy(pagetable_t old, pagetable_t new, uint64 sz):
```c
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  printf("uvmcopy: copying sz=0x%lx
", sz);

  for(i = 0; i < sz; ){
    // Verificar se é uma superpage
    if((i % SUPERPAGE_SIZE) == 0 && i >= 0x200000) {
      printf("uvmcopy: checking superpage at va=0x%lx
", i);
      
      // USAR NÍVEL 1 para detectar superpages
      pte_t *pte_l1 = walk(old, i, 1);
      if(pte_l1) {
        printf("uvmcopy: pte_l1=0x%lx, PTE_V=%d, PTE_LEAF=%d
", 
               *pte_l1, (*pte_l1 & PTE_V) ? 1 : 0, PTE_LEAF(*pte_l1) ? 1 : 0);
      }
      
      if(pte_l1 && (*pte_l1 & PTE_V) && PTE_LEAF(*pte_l1)) {
        pa = PTE2PA(*pte_l1);
        printf("uvmcopy: pa=0x%lx, in_range=%d
", pa, 
               (pa >= 0x80200000 && pa <= 0x81200000) ? 1 : 0);
               
        if(pa >= 0x80200000 && pa <= 0x81200000) {
          printf("uvmcopy: copying superpage at va=0x%lx, pa=0x%lx
", i, pa);
          
          // Alocar nova superpage para o filho
          char *new_mem = superalloc();
          if(new_mem == 0) {
            printf("uvmcopy: no superpage available, using normal pages
");
            goto normal_pages;
          }
          
          // Copiar conteúdo da superpage
          memmove(new_mem, (void*)pa, SUPERPAGE_SIZE);
          
          // Mapear no processo filho
          flags = PTE_FLAGS(*pte_l1);
          if(map_superpage(new, i, (uint64)new_mem, flags) != 0) {
            printf("uvmcopy: failed to map superpage
");
            superfree(new_mem);
            goto err;
          }
          
          printf("uvmcopy: successfully copied superpage
");
          i += SUPERPAGE_SIZE;
          continue;
        }
      }
    }
    
normal_pages:
    // Página normal
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
      kfree(mem);
      goto err;
    }
    
    i += PGSIZE;
  }
  
  printf("uvmcopy: finished copying successfully
");
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
  return -1;
}
```

---

### Alocar memória usando superpages quando possível
```c
uint64
uvmalloc_super(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  char *mem;
  uint64 a;
  int perm = PTE_W | PTE_X | PTE_R | PTE_U;

  if(newsz < oldsz)
    return oldsz;

  oldsz = PGROUNDUP(oldsz);
  a = oldsz;
  
  printf("uvmalloc_super: oldsz=%p newsz=%p size=%d
", (void*)oldsz, (void*)newsz, (int)(newsz-oldsz));
  
  // Primeiro, páginas normais até próximo boundary de 2MB
  uint64 superpage_boundary = (((a) + SUPERPAGE_SIZE - 1) & ~(SUPERPAGE_SIZE - 1));
  
  printf("Current addr: %p, boundary: %p
", (void*)a, (void*)superpage_boundary);
  
  for(; a < superpage_boundary && a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, perm) != 0){
      kfree(mem);
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
  }
  
  // Usar superpages para regiões alinhadas de 2MB+
  for(; a + SUPERPAGE_SIZE <= newsz; a += SUPERPAGE_SIZE){
    printf("Trying superpage at va=%p
", (void*)a);
    
    mem = superalloc();
    if(mem != 0){
      printf("Got superpage at pa=%p
", mem);
      // Conseguiu superpage
      if(map_superpage(pagetable, a, (uint64)mem, perm) == 0){
        printf("Successfully mapped superpage
");
        continue; // Sucesso
      } else {
        printf("Failed to map superpage
");
        superfree(mem);
      }
    } else {
      printf("No superpage available, using normal pages
");
    }
    
    // Fallback: usar 512 páginas normais (2MB)
    for(uint64 b = a; b < a + SUPERPAGE_SIZE; b += PGSIZE){
      char *page = kalloc();
      if(page == 0){
        uvmdealloc(pagetable, b, oldsz);
        return 0;
      }
      memset(page, 0, PGSIZE);
      if(mappages(pagetable, b, PGSIZE, (uint64)page, perm) != 0){
        kfree(page);
        uvmdealloc(pagetable, b, oldsz);
        return 0;
      }
    }
  }
  
  // Páginas normais para o resto
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, perm) != 0){
      kfree(mem);
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
  }

  return newsz;
}
```

---

### map_superpage
```c
int
map_superpage(pagetable_t pagetable, uint64 va, uint64 pa, int perm)
{
  pte_t *pte;

  if(va % SUPERPAGE_SIZE != 0 || pa % SUPERPAGE_SIZE != 0)
    return -1;

  // NÃO usar walk() que pode criar page tables
  // Vamos acessar diretamente o nível 1
  pte_t *pte_l2 = &pagetable[PX(2, va)];  // Nível 2
  if(!(*pte_l2 & PTE_V)) {
    // Precisa criar nível 1
    pagetable_t l1_table = (pagetable_t)kalloc();
    if(l1_table == 0)
      return -1;
    memset(l1_table, 0, PGSIZE);
    *pte_l2 = PA2PTE(l1_table) | PTE_V;
  }
  
  // Agora acessar nível 1 diretamente
  pagetable_t l1_table = (pagetable_t)PTE2PA(*pte_l2);
  pte = &l1_table[PX(1, va)];
  
  if(*pte & PTE_V) {
    printf("map_superpage: level 1 already mapped, pte=0x%lx
", *pte);
    return -1;
  }

  // Configurar PTE para superpage no nível 1
  *pte = PA2PTE(pa) | perm | PTE_V;
  printf("map_superpage: mapped va=0x%lx -> pa=0x%lx, pte=0x%lx
", va, pa, *pte);

  return 0;
}
```
## Explicação:
Adiciona ferramentas de depuração (`vmprint_recursive`) e amplia o **VM** para lidar com superpages: mudanças em `walk` (reconhecer folhas), `uvmunmap` (liberação de 2 MB em bloco), `uvmcopy` (cópia otimizada quando a origem é superpage), `uvmalloc_super` (alocação híbrida normal/superpage) e `map_superpage` (mapeamento direto no nível 1).


# Testes

```
$ make clean
$ make qemu
$ pgtbltest
```