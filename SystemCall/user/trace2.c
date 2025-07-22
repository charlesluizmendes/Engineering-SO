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