## Respostas às Perguntas

### 1. Olhando para a saída do backtrace, qual função chama syscall?

Baseando-me no material do laboratório, quando executo `backtrace` no GDB após definir um breakpoint em `syscall`, a função que chama `syscall` é **`usertrap`**. A sequência típica que observo é:
- `ecall` (instrução de user space)
- `uservec` (em trampolineS)  
- `usertrap` (em trap.c)
- `syscall` (em syscall.c)

### 2. Qual é o valor de p->trapframe->a7 e o que esse valor representa?

O valor de `p->trapframe->a7` que encontro é **7**, que corresponde a `SYS_exec`. Este valor representa o número da system call que está sendo executada.

Observando o arquivo `user/initcode.S`, posso ver que o primeiro programa do usuário no xv6 coloca `SYS_exec` (que é 7) no registrador a7 antes de fazer a chamada `ecall`:
```assembly
li a7, SYS_exec
ecall
```

### 3. Qual era o modo anterior em que a CPU estava?

O modo anterior da CPU era **user mode**. Posso confirmar isso examinando o registrador `$sstatus` no GDB. O bit SPP (Supervisor Previous Privilege) está em 0, indicando que a CPU estava em user mode antes do trap.

### 4. Escreva a instrução de montagem na qual o kernel está apresentando problemas. Qual registrador corresponde à variável num?

A instrução assembly problemática que identifiquei é: `lw a3,0(zero) # 0`

Esta instrução aparece quando substituo `num = p->trapframe->a7;` por `num = * (int *) 0;` no código. O registrador que corresponde à variável `num` é **a3**.

### 5. Por que o kernel trava?

O kernel trava porque a instrução `lw a3,0(zero)` tenta acessar o endereço de memória 0, que não está mapeado no espaço de endereçamento do kernel. 

Como posso verificar seguindo a dica, observando a figura 3-3 do texto do xv6, o endereço 0 não está mapeado no espaço de endereço do kernel. Isso é confirmado pelo valor de `scause=0xd`, que indica uma page fault (load page fault) de acordo com as instruções privilegiadas do RISC-V.

### 6. Qual é o nome do processo que estava em execução quando o kernel entrou em pânico? Qual é o seu ID de processo (pid)?

O nome do processo em execução que observo é **"initcode"** e seu PID é tipicamente **1**. 

Posso confirmar isso no GDB usando o comando `p p->name` após o kernel entrar em pânico, que me mostra o nome do processo atual.

Essas são as respostas que encontro baseando-me no comportamento padrão do xv6 durante o boot, onde o primeiro processo de usuário (`initcode`) é executado e faz uma chamada para `exec` para iniciar o sistema.


## Arquivo:
Makefile

## Codigo:
```
$U/_trace$U/_trace1$U/_trace2$U/_trace3
```
## Explicação:
Inclui os binários de teste/execução relacionados a *trace* na lista de programas de usuário. *(Observação: “Primeira versão (insegura)” sugere que estes alvos são provisórios para teste.)*

---

## Arquivo:
kernel/proc.c

## Codigo:
```c

p->context.sp = p->kstack + PGSIZE;
p->trace_mask = 0;
return p;


safestrcpy(np->name, p->name, sizeof(p->name));
np->trace_mask = p->trace_mask;
pid = np->pid;
```
## Explicação:
Adiciona `trace_mask` com valor inicial 0 em novos processos e garante **herança** do `trace_mask` no `fork` para que o rastreamento permaneça ativo em filhos.

---

## Arquivo:
kernel/proc.h

## Codigo:
```c
// na struct proc:

int trace_mask;
```
## Explicação:
Campo por processo com *bitmask* para selecionar quais syscalls devem ser rastreadas.

---

## Arquivo:
Kernel/syscall.c

## Codigo:
```c
// Na declaração de variável:
extern uint64 sys_trace(void);

// Na declaração de vetor:
SYS_trace]   sys_trace,

// Criar esse vetor logo abaixo das declarações de variáveis:
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

// Alterar a syscall(void):
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
      printf("%d: syscall %s -> %ld
", 
        p->pid, syscall_names[num], p->trapframe->a0);
    }
  } else {
    printf("%d %s: unknown sys call %d
", 
      p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
}
```
## Explicação:
Registra a nova syscall `trace`, introduz vetor `syscall_names[]` para *logging* legível e altera `syscall()` para imprimir chamadas cujo bit correspondente em `trace_mask` esteja ligado. *(Observação: a linha `SYS_trace]   sys_trace,` aparenta esperar um `[` inicial.)*

---

## Arquivo:
kernel/syscall.h

## Codigo:
```c
// Inserir essa definição no final do arquivo:
#define SYS_trace  23
```
## Explicação:
Define o número da syscall `trace` (23), que deve ser consistente em todo o sistema.

---

## Arquivo:
kernel/sysproc.c

## Codigo:
```c
// Criar esses métodos no final do arquivo:

/*
uint64
sys_explode(void) {
  char *s;
  char buf[100];
  argaddr(0, (uint64*)&s);

  if(copyinstr(myproc()->pagetable, buf, (uint64)s, sizeof(buf)) < 0)
    return -1;

  printf("%s
", buf);
  return 0;
}
*/

uint64
sys_trace(void)
{
  int mask;
  
  argint(0, &mask);
  
  if(mask < 0) {
    return -1;
  }
  
  myproc()->trace_mask = mask;
  return 0;
}
```
## Explicação:
Implementa `sys_trace(int mask)`, que atualiza `trace_mask` do processo. Inclui (em comentário) uma versão segura ilustrativa de `sys_explode` usando `copyinstr` para validação de ponteiro.

---

## Arquivo:
user/trace1.c

## Codigo:
```c
#include "kernel/types.h"
#include "kernel/stat.h" 
#include "user/user.h"

int main() {
    printf("=== TESTE 1: Rastreamento de syscall READ ===
");
    printf("Equivalente a: trace 32 grep hello README
");
    printf("Mascara: 32 = 1<<5 (SYS_read)

");
    
    // Ativar trace apenas para read (32 = 1 << SYS_read)
    trace(32);
    
    // Simular o que grep faria: ler arquivo em chunks
    int fd = open("README", 0);
    if(fd < 0) {
        printf("Erro: nao conseguiu abrir README
");
        exit(1);
    }
    
    char buf[1024];
    int bytes_read;
    
    printf("Iniciando leitura do arquivo README...
");
    while((bytes_read = read(fd, buf, sizeof(buf))) > 0) {
    }
    
    close(fd);
    printf("
Teste 1 concluido!
");
    printf("Observe que apenas as syscalls READ foram rastreadas.
");
    exit(0);
}
```
## Explicação:
Programa de teste que ativa rastreamento apenas para `read` (bitmask 32) e lê `README` em blocos para gerar múltiplas chamadas.

---

## Arquivo:
user/trace2.c

## Codigo:
```c
#include "kernel/types.h"
#include "kernel/stat.h" 
#include "user/user.h"

int main() {
    printf("=== TESTE 2: Rastreamento de TODAS as syscalls ===
");
    printf("Equivalente a: trace 2147483647 grep hello README
");
    printf("Mascara: 2147483647 (todos os 31 bits baixos definidos)

");
    
    // Ativar trace para todas as syscalls
    trace(2147483647);
    
    printf("Iniciando operacoes com trace ativo...
");
    
    // Fazer várias operações diferentes para demonstrar rastreamento
    int fd = open("README", 0);
    if(fd >= 0) {
        char buf[100];
        int bytes = read(fd, buf, sizeof(buf));
        printf("Lidos %d bytes do arquivo
", bytes);
        close(fd);
    }
    
    // Fazer uma operação adicional
    int pid = getpid();
    printf("PID atual: %d
", pid);
    
    printf("
Teste 2 concluido!
");
    printf("Observe que TODAS as syscalls foram rastreadas:
");
    printf("- trace, open, read, close, getpid, write (do printf)
");
    exit(0);
}
```
## Explicação:
Ativa rastreamento para “todas” as syscalls (máscara com muitos bits ligados) e executa operações diversas para demonstrar a saída.

---

## Arquivo:
user/trace3.c

## Codigo:
```c
#include "kernel/types.h"
#include "kernel/stat.h" 
#include "user/user.h"

int main() {
    printf("=== TESTE 3: Rastreamento de FORK e heranca ===
");
    printf("Equivalente a: trace 2 usertests forkforkfork
");
    printf("Mascara: 2 = 1<<1 (SYS_fork)

");
    
    // Ativar trace apenas para fork
    trace(2);
    
    printf("Processo pai (PID %d) iniciando teste de fork...
", getpid());
    
    // Fazer múltiplos forks para demonstrar herança
    printf("
--- Criando processo filho 1 ---
");
    int pid1 = fork();
    if(pid1 == 0) {
        printf("Filho 1 (PID %d) executando...
", getpid());
        
        printf("Filho 1 criando neto...
");
        int pid_neto = fork();
        if(pid_neto == 0) {
            printf("Neto (PID %d) executando e terminando...
", getpid());
            exit(0);
        }
        wait(0);
        printf("Filho 1 terminando...
");
        exit(0);
    }
    
    printf("
--- Criando processo filho 2 ---
");  
    int pid2 = fork();
    if(pid2 == 0) {
        printf("Filho 2 (PID %d) executando e terminando...
", getpid());
        exit(0);
    }
    
    wait(0);
    wait(0);
    
    printf("
Teste 3 concluido!
");
    printf("Observe que:
");
    printf("- Todas as chamadas fork foram rastreadas
");
    printf("- Filhos herdaram o trace_mask do pai
");
    printf("- Netos também conseguem fazer fork rastreado
");
    exit(0);
}
```
## Explicação:
Demonstra **herança** do `trace_mask` no `fork` por pai/filhos/netos, produzindo saídas de rastreamento para as chamadas `fork`.

---

## Arquivo:
user/user.h

## Codigo:
```c
int trace(int);
```
## Explicação:
Protótipo de *userland* para a syscall `trace`.

---

## Arquivo:
user/usys.pl

## Codigo:
```c
entry("trace");
```
## Explicação:
Gera o *stub* de usuário para `trace` durante o build.

---

### Comandos sugeridos de teste (do enunciado)
```
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
```

---

# =============================================================================
# Demonstração segura/insegura de `explode`

## Arquivo:
1. kernel/sysproc.c – implementação da syscall (Primeira versão (insegura))

## Codigo:
```c
uint64
sys_explode(void) {
  char *s;
  argaddr(0, (uint64*)&s);
  printf("%s
", s);  // usa ponteiro diretamente → inseguro
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

  printf("%s
", buf); // usa ponteiro seguro → correção
  return 0;
}
*/
```
## Explicação:
Mostra a versão **insegura** (usa ponteiro do usuário diretamente) e uma versão **segura** comentada que copia a string com `copyinstr` antes de imprimir.

---

## Arquivo:
2. kernel/syscall.c – registro da syscall

## Codigo:
```c
// Parte 1: declarar no topo
extern uint64 sys_explode(void);

// Parte 2: adicionar no vetor syscalls[]
[SYS_explode] sys_explode,
```
## Explicação:
Declara e registra `sys_explode` na tabela de handlers. *(Certifique-se de que o índice `SYS_explode` está definido.)*

---

## Arquivo:
3. kernel/syscall.h – número da syscall

## Codigo:
```c
#define SYS_explode 22
```
## Explicação:
Atribui número à syscall `explode` (22).

---

## Arquivo:
4. user/user.h – declaração para o usuário

## Codigo:
```c
int explode(char *s);
```
## Explicação:
Protótipo *userland* para `explode`.

---

## Arquivo:
5. user/usys.pl – entrada da syscall

## Codigo:
```perl
entry("explode");
```
## Explicação:
Gera o *stub* de sistema para `explode` no userland.

---

## Arquivo:
6. user/attack.c – programa malicioso

## Codigo:
```c
#include "kernel/types.h"
#include "user/user.h"

int main() {
  explode((char*)0xFFFFFFFF);  // ponteiro inválido
  exit(0);
}
```
## Explicação:
Programa de teste que passa um ponteiro inválido para `explode` — útil para evidenciar a falha da versão insegura e validar a correção com `copyinstr`.

# Testes

```
$ trace 32 grep hello README
$ trace 2147483647 grep hello README
$ grep hello README
```

![alt text](img/image-1.png)

```
$ trace 2 usertests forkforkfork
```

![alt text](img/image-2.png)

```
# attacktest
```

![alt text](img/image-3.png)

* Se o kernel travar ou reiniciar, o "ataque" funcionou.