1. Makefile
Primeira versão (insegura):

$U/_trace\
$U/_trace1\
$U/_trace2\
$U/_trace3\




2. kernel/proc.c

na função allocproc(void):

c

p->context.sp = p->kstack + PGSIZE;
p->trace_mask = 0; // INSERIR ESSA LINHA AQUI
return p;

Na função fork(void):

c

safestrcpy(np->name, p->name, sizeof(p->name));
np->trace_mask = p->trace_mask; // INSERIR ESSA LINHA AQUI
pid = np->pid;




3. kernel/proc.h

na struct proc:

c

int trace_mask;




4. Kernel/syscall.c

Na declaração de variável:

c

extern uint64 sys_trace(void);

Na declaração de vetor:

c

SYS_trace]   sys_trace,

c

Criar esse vetor logo abaixo das declarações de variáveis:

static char *syscall_names[] = {
  [SYS_fork]    "fork",
  [SYS_exit]    "exit", 
  [SYS_wait]    "wait",
  [SYS_pipe]    "pipe",
  [SYS_read]    "read",
  [SYS_kill]    "kill",
  [SYS_exec]    "exec",
  [SYS_fstat]   "fstat",
  [SYS_chdir]   "chdir",
  [SYS_dup]     "dup",
  [SYS_getpid]  "getpid",
  [SYS_sbrk]    "sbrk",
  [SYS_sleep]   "sleep",
  [SYS_uptime]  "uptime",
  [SYS_open]    "open",
  [SYS_write]   "write",
  [SYS_mknod]   "mknod",
  [SYS_unlink]  "unlink",
  [SYS_link]    "link",
  [SYS_mkdir]   "mkdir",
  [SYS_close]   "close",
  [SYS_trace]   "trace",
};

Alterar a syscall(void):

c

void
syscall(void)
{
  int num;
  struct proc *p = myproc();

  num = p->trapframe->a7;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    p->trapframe->a0 = syscalls[num]();
    
    // Verificar se deve rastrear esta syscall
    if(p->trace_mask & (1 << num)) {
      printf("%d: syscall %s -> %ld\n", 
        p->pid, syscall_names[num], p->trapframe->a0);
    }
  } else {
    printf("%d %s: unknown sys call %d\n", 
      p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
}




5. kernel/syscall.h

Inserir essa definição no final do arquivo:

c

#define SYS_trace  23




6. kernel/sysproc.c

Criar esses métodos no final do arquivo:

c

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




7. Vamos criar os 3 arquivos novos:

user/trace1.c

c

#include "kernel/types.h"
#include "kernel/stat.h" 
#include "user/user.h"

int main() {
    printf("=== TESTE 1: Rastreamento de syscall READ ===\n");
    printf("Equivalente a: trace 32 grep hello README\n");
    printf("Mascara: 32 = 1<<5 (SYS_read)\n\n");
    
    // Ativar trace apenas para read (32 = 1 << SYS_read)
    trace(32);
    
    // Simular o que grep faria: ler arquivo em chunks
    int fd = open("README", 0);
    if(fd < 0) {
        printf("Erro: nao conseguiu abrir README\n");
        exit(1);
    }
    
    char buf[1024];
    int bytes_read;
    
    printf("Iniciando leitura do arquivo README...\n");
    while((bytes_read = read(fd, buf, sizeof(buf))) > 0) {
        // Simular processamento (procurar por "hello")
        // Apenas lendo, o trace vai mostrar as chamadas read
    }
    
    close(fd);
    printf("\nTeste 1 concluido!\n");
    printf("Observe que apenas as syscalls READ foram rastreadas.\n");
    exit(0);
}


user/trace2.c

c

#include "kernel/types.h"
#include "kernel/stat.h" 
#include "user/user.h"

int main() {
    printf("=== TESTE 2: Rastreamento de TODAS as syscalls ===\n");
    printf("Equivalente a: trace 2147483647 grep hello README\n");
    printf("Mascara: 2147483647 (todos os 31 bits baixos definidos)\n\n");
    
    // Ativar trace para todas as syscalls
    trace(2147483647);
    
    printf("Iniciando operacoes com trace ativo...\n");
    
    // Fazer várias operações diferentes para demonstrar rastreamento
    int fd = open("README", 0);
    if(fd >= 0) {
        char buf[100];
        int bytes = read(fd, buf, sizeof(buf));
        printf("Lidos %d bytes do arquivo\n", bytes);
        close(fd);
    }
    
    // Fazer uma operação adicional
    int pid = getpid();
    printf("PID atual: %d\n", pid);
    
    printf("\nTeste 2 concluido!\n");
    printf("Observe que TODAS as syscalls foram rastreadas:\n");
    printf("- trace, open, read, close, getpid, write (do printf)\n");
    exit(0);
}


user/trace3.c

c

#include "kernel/types.h"
#include "kernel/stat.h" 
#include "user/user.h"

int main() {
    printf("=== TESTE 3: Rastreamento de FORK e heranca ===\n");
    printf("Equivalente a: trace 2 usertests forkforkfork\n");
    printf("Mascara: 2 = 1<<1 (SYS_fork)\n\n");
    
    // Ativar trace apenas para fork
    trace(2);
    
    printf("Processo pai (PID %d) iniciando teste de fork...\n", getpid());
    
    // Fazer múltiplos forks para demonstrar herança
    printf("\n--- Criando processo filho 1 ---\n");
    int pid1 = fork();
    if(pid1 == 0) {
        // Processo filho 1
        printf("Filho 1 (PID %d) executando...\n", getpid());
        
        // Filho também pode fazer fork (herda o trace_mask)
        printf("Filho 1 criando neto...\n");
        int pid_neto = fork();
        if(pid_neto == 0) {
            // Processo neto
            printf("Neto (PID %d) executando e terminando...\n", getpid());
            exit(0);
        }
        wait(0); // Esperar o neto
        printf("Filho 1 terminando...\n");
        exit(0);
    }
    
    printf("\n--- Criando processo filho 2 ---\n");  
    int pid2 = fork();
    if(pid2 == 0) {
        // Processo filho 2
        printf("Filho 2 (PID %d) executando e terminando...\n", getpid());
        exit(0);
    }
    
    // Processo pai espera pelos filhos
    wait(0); // Esperar filho 1
    wait(0); // Esperar filho 2
    
    printf("\nTeste 3 concluido!\n");
    printf("Observe que:\n");
    printf("- Todas as chamadas fork foram rastreadas\n");
    printf("- Filhos herdaram o trace_mask do pai\n");
    printf("- Netos também conseguem fazer fork rastreado\n");
    exit(0);
}




8. user/user.h

Declarar esse parâmetro:

c

int trace(int);





9. user/usys.pl

Declarar essa entrada:

c

entry("trace");




make clean
make qemu
trace 32 grep hello README
trace 2147483647 grep hello README
trace 2 usertests forkforkfork
trace1
trace2
trace3

make clean
make grade


=====================================================================================


1. kernel/sysproc.c – implementação da syscall
Primeira versão (insegura):

c

uint64
sys_explode(void) {
  char *s;
  argaddr(0, (uint64*)&s);
  printf("%s\n", s);  // ⚠️ usa ponteiro diretamente → inseguro
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

  printf("%s\n", buf); // ⚠️ usa ponteiro seguro → correção
  return 0;
}
*/




2. kernel/syscall.c – registro da syscall
Parte 1: declarar no topo
c

extern uint64 sys_explode(void);

Parte 2: adicionar no vetor syscalls[]
c

[SYS_explode] sys_explode,




3. kernel/syscall.h – número da syscall
Adicionamos no final:

c

#define SYS_explode 22




4. user/user.h – declaração para o usuário
Adicionamos:

c

int explode(char *s);




5. user/usys.pl – entrada da syscall
Adicionamos:

perl

entry("explode");




6. user/attack.c – programa malicioso
Criamos:

c

#include "kernel/types.h"
#include "user/user.h"

int main() {
  explode((char*)0xFFFFFFFF);  // ponteiro inválido
  exit(0);
}



make clean
make qemu
attack

Se o kernel travar ou reiniciar, o "ataque" funcionou.





