#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
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
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
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

uint64
sys_explode(void) {
  char *s;
  argaddr(0, (uint64*)&s);
  printf("%s\n", s);  // usa ponteiro diretamente → inseguro
  return 0;
}

/*
uint64
sys_explode(void) {
  char *s;
  char buf[100];
  argaddr(0, (uint64*)&s);

  if(copyinstr(myproc()->pagetable, buf, (uint64)s, sizeof(buf)) < 0)
    return -1;

  printf("%s\n", buf);
  return 0;
}
*/

uint64
sys_trace(void)
{
  int mask;
  
  argint(0, &mask);
  
  // Validação opcional: verificar se a máscara é válida
  if(mask < 0) {
    return -1;
  }
  
  myproc()->trace_mask = mask;
  return 0;
}