1. kernel/riscv.h:

c

// Adicionar após as outras funções r_* e ANTES do final do arquivo
#ifndef __ASSEMBLER__
static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
  return x;
}
#endif






2. kernel/printf.c:

c

void
backtrace(void)
{
  printf("backtrace:\n");
  
  uint64 fp = r_fp();  // Frame pointer atual (s0)
  uint64 page_start = PGROUNDDOWN(fp);
  uint64 page_end = page_start + PGSIZE;
  
  // Percorrer a stack usando frame pointers
  while (fp >= page_start && fp < page_end) {
    // Return address está em fp-8
    uint64 return_addr = *(uint64*)(fp - 8);
    printf("%p\n", (void*)return_addr);  // CAST PARA void*
    
    // Frame pointer anterior está em fp-16
    uint64 prev_fp = *(uint64*)(fp - 16);
    
    // Verificar se o próximo frame pointer é válido
    if (prev_fp <= fp || prev_fp >= page_end) {
      break;
    }
    
    fp = prev_fp;
  }
}

Alterar a panic()

c

void
panic(char *s)
{
  pr.locking = 0;
  printf("panic: ");
  printf(s);
  printf("\n");
  backtrace();  // ADICIONAR ESTA LINHA
  panicked = 1; // freeze uart output from other CPUs
  for(;;)
    ;
}





3. kernel/defs.h:

c

// printf.c
void            printf(char*, ...);
void            panic(char*) __attribute__((noreturn));
void            printfinit(void);
void            backtrace(void);  // ADICIONAR ESTA LINHA





4. kernel/sysproc.c:

Alterar sys_sleep:

c

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  backtrace();  // ADICIONAR ESTA LINHA

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

c

uint64
sys_sigalarm(void)
{
  int interval;
  uint64 handler;
  
  argint(0, &interval);
  argaddr(1, &handler);
  
  struct proc *p = myproc();
  p->alarm_interval = interval;
  p->alarm_handler = (void(*)())handler;
  p->alarm_ticks = 0;
  p->alarm_active = 0;
  
  return 0;
}

uint64
sys_sigreturn(void)
{
  struct proc *p = myproc();
  
  if (p->alarm_active && p->alarm_trapframe) {
    // Restore saved trapframe
    memmove(p->trapframe, p->alarm_trapframe, sizeof(struct trapframe));
    p->alarm_active = 0;
  }
  
  return 0;
}






5. kernel/syscall.h:

c

#define SYS_sigalarm 22
#define SYS_sigreturn 23





6. kernel/syscall.c:

c

extern uint64 sys_sigalarm(void);
extern uint64 sys_sigreturn(void);

c

static uint64 (*syscalls[])(void) = {
[SYS_fork]    sys_fork,
[SYS_exit]    sys_exit,
[SYS_wait]    sys_wait,
[SYS_pipe]    sys_pipe,
[SYS_read]    sys_read,
[SYS_kill]    sys_kill,
[SYS_exec]    sys_exec,
[SYS_fstat]   sys_fstat,
[SYS_chdir]   sys_chdir,
[SYS_dup]     sys_dup,
[SYS_getpid]  sys_getpid,
[SYS_sbrk]    sys_sbrk,
[SYS_sleep]   sys_sleep,
[SYS_uptime]  sys_uptime,
[SYS_open]    sys_open,
[SYS_write]   sys_write,
[SYS_mknod]   sys_mknod,
[SYS_unlink]  sys_unlink,
[SYS_link]    sys_link,
[SYS_mkdir]   sys_mkdir,
[SYS_close]   sys_close,
[SYS_sigalarm] sys_sigalarm,    // ADICIONAR
[SYS_sigreturn] sys_sigreturn,  // ADICIONAR
};







7. user/usys.pl:

c

entry("sigalarm");
entry("sigreturn");






8. user/user.h:

c

int sigalarm(int ticks, void (*handler)());
int sigreturn(void);






9. kernel/proc.h:

N função struct proc:

c

// ADICIONAR CAMPOS DO ALARM:
  int alarm_interval;          // Alarm interval in ticks
  void (*alarm_handler)();     // Alarm handler function
  int alarm_ticks;            // Ticks since last alarm
  struct trapframe *alarm_trapframe; // Saved trapframe for alarm
  int alarm_active;           // Whether alarm is currently active








10. kernel/proc.c:

Na allocproc(void):

c

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

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;

  // ADICIONAR INICIALIZAÇÃO DOS CAMPOS DO ALARM:
  p->alarm_interval = 0;
  p->alarm_handler = 0;
  p->alarm_ticks = 0;
  p->alarm_trapframe = 0;
  p->alarm_active = 0;

  return p;
}

Na função freeproc:

c

static void
freeproc(struct proc *p)
{
  if(p->trapframe)
    kfree((void*)p->trapframe);
  p->trapframe = 0;
  if(p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
  
  // ADICIONAR LIMPEZA DOS CAMPOS DO ALARM:
  if(p->alarm_trapframe)
    kfree((void*)p->alarm_trapframe);
  p->alarm_trapframe = 0;
  p->alarm_interval = 0;
  p->alarm_handler = 0;
  p->alarm_ticks = 0;
  p->alarm_active = 0;
}






11. kernel/trap.c:

função usertrap e o bloco if(which_dev == 2):

c

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
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    killed(p);
  }

  if(killed(p))
    exit(-1);

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2){
    // ADICIONAR LÓGICA DO ALARM AQUI:
    struct proc *p = myproc();
    
    if(p->alarm_interval > 0) {
      p->alarm_ticks++;
      
      if(p->alarm_ticks >= p->alarm_interval && !p->alarm_active) {
        // Save current trapframe
        if(p->alarm_trapframe == 0) {
          p->alarm_trapframe = (struct trapframe*)kalloc();
          if(p->alarm_trapframe == 0) {
            // Out of memory, skip alarm
            p->alarm_ticks = 0;
            yield();
            goto end;
          }
        }
        
        memmove(p->alarm_trapframe, p->trapframe, sizeof(struct trapframe));
        
        // Set up to call alarm handler
        p->trapframe->epc = (uint64)p->alarm_handler;
        p->alarm_ticks = 0;
        p->alarm_active = 1;
      }
    }
    
    yield();
  }

end:
  usertrapret();
}






12. Mo Makefile:

UPROGS=\
	$U/_cat\
	$U/_echo\
	$U/_forktest\
	$U/_grep\
	$U/_init\
	$U/_kill\
	$U/_ln\
	$U/_ls\
	$U/_mkdir\
	$U/_rm\
	$U/_sh\
	$U/_stressfs\
	$U/_usertests\
	$U/_grind\
	$U/_wc\
	$U/_zombie\
	$U/_alarmtest\     # ADICIONAR ESTA LINHA



make clean
make qemu
bttest
(em outro terminal) addr2line -e kernel/kernel x0000000080001e2c 0x0000000080001d4e 0x0000000080001a70
alarmtest