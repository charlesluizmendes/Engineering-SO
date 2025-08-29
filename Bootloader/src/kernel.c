/* kernel.c – escreve na linha 10 para não sobrescrever mensagens anteriores */
void kmain(void)
{
    char *vga = (char *)0xB8000;
    const char *msg = "Kernel C inicializado com sucesso!";
    
    // Escreve na linha 10 (10 * 80 caracteres por linha * 2 bytes por caractere)
    int line_offset = 10 * 80 * 2;
    
    for (int i = 0; msg[i]; ++i) {
        vga[line_offset + i * 2]     = msg[i];
        vga[line_offset + i * 2 + 1] = 0x0A;  // Verde
    }

    __asm__ __volatile__("cli");
    for (;;)
        __asm__ __volatile__("hlt");
}