/* kernel.c – mínimo 32 bits: mostra mensagem e dorme */
void kmain(void)
{
    char *vga = (char *)0xB8000;
    const char *msg = "Kernel C inicializado com sucesso!";
    for (int i = 0; msg[i]; ++i) {
        vga[i * 2]     = msg[i];
        vga[i * 2 + 1] = 0x0F;
    }

    __asm__ __volatile__("cli");   /* IF=0, ninguém acorda o CPU      */
    for (;;)
        __asm__ __volatile__("hlt");
}