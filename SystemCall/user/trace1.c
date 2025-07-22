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