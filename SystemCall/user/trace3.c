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