# bootloader.s - Bootloader COS773
.code16
.globl _start

_start:
    # Inicialização
    cli
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es  
    movw %ax, %ss
    movw $0x7c00, %sp
    sti
    
    # Limpa tela
    movw $0x0600, %ax
    movw $0x0700, %bx
    movw $0x0000, %cx
    movw $0x184f, %dx
    int $0x10
    
    # Posiciona cursor
    movw $0x0200, %ax
    movw $0x0000, %bx
    movw $0x0000, %dx
    int $0x10
    
    # Mostra mensagem
    movw $welcome_msg, %si
    call print_string
    
main_loop:
    # Lê tecla
    movw $0x0000, %ax
    int $0x16
    
    # ESC = sair
    cmpb $27, %al
    je goodbye
    
    # Enter = nova linha
    cmpb $13, %al
    je new_line
    
    # Imprime tecla
    movb $0x0e, %ah
    int $0x10
    jmp main_loop
    
new_line:
    movb $13, %al
    movb $0x0e, %ah
    int $0x10
    movb $10, %al
    movb $0x0e, %ah  
    int $0x10
    jmp main_loop
    
goodbye:
    movw $bye_msg, %si
    call print_string

halt:
    hlt
    jmp halt

print_string:
    pushw %ax
    pushw %si
    
print_loop:
    lodsb
    testb %al, %al
    jz print_done
    movb $0x0e, %ah
    int $0x10
    jmp print_loop
    
print_done:
    popw %si
    popw %ax
    ret

welcome_msg:
    .ascii "=== BOOTLOADER COS773 ===\r\n"
    .ascii "Sistema Operacional\r\n"
    .ascii "Digite teclas (ESC=sair)\r\n> "
    .byte 0

bye_msg:
    .ascii "\r\nTchau! Sistema encerrado.\r\n"
    .byte 0

.org 510
.word 0xaa55