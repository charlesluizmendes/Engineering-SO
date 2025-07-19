# bootloader.s – Bootloader COS773 (≤512 B, PM)
# -------------------------------------------------------------
# - lê kernel.bin (setores 2..) em 0x1000
# - habilita A20, masca PIC e NMI
# - carrega GDT/IDT, entra em modo protegido
# - salta para o kernel (32 bits)

.code16
.globl _start

.equ KERNEL_LOAD_ADDR, 0x1000
.equ CODE_SEL,         0x08
.equ DATA_SEL,         0x10

boot_drive: .byte 0

# --------------- início (real mode) ---------------------------
_start:
    cli
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw $0x7C00, %sp
    sti

    movb %dl, boot_drive

    movw $msg_loading, %si
    call print

    call load_kernel_wrapper
    jc load_fail

    movw $msg_ok, %si
    call print

    call enable_a20
    call mask_pic_nmi

    cli
    lgdt gdt_desc
    lidt idt_desc

    movl %cr0, %eax
    orl  $1, %eax
    movl %eax, %cr0
    jmp  $CODE_SEL, $pm_entry

load_fail:
    movw $msg_fail, %si
    call print
    cli
    hlt

# ---------- habilita A20 (port 0x92) --------------------------
enable_a20:
    in   $0x92, %al
    or   $0x02, %al
    out  %al, $0x92
    ret

# ---------- mascara PIC + desliga NMI ------------------------
mask_pic_nmi:
    movb $0xFF, %al
    out  %al, $0xA1
    out  %al, $0x21
    movb $0x80, %al
    out  %al, $0x70
    ret

# ---------- lê kernel com retries ---------------------------
load_kernel_wrapper:
    movb $3, %ch           # 3 tentativas
.retry:
    pushw %cx
    call load_kernel
    jnc .ok
    popw %cx
    dec %ch
    jz .fail
    xorw %ax, %ax          # reset disk
    int $0x13
    jmp .retry
.ok:
    popw %cx
    clc
    ret
.fail:
    stc
    ret

load_kernel:
    xorw %ax, %ax
    movw %ax, %es
    movw $KERNEL_LOAD_ADDR, %bx
    movb boot_drive, %dl
    movb $KERNEL_SECTORS, %al
    movb $2, %cl
    xor  %ch, %ch
    xor  %dh, %dh
    movb $0x02, %ah
    int  $0x13
    ret

# ---------- impressão simples --------------------------------
print:
    pushw %ax
.lp: 
    lodsb
    testb %al, %al
    jz   .done
    movb $0x0E, %ah
    int  $0x10
    jmp  .lp
.done:
    popw %ax
    ret

# ---------- mensagens ----------------------------------------
msg_loading: .ascii "Load\r\n\0"
msg_ok:      .ascii "OK\r\n\0"
msg_fail:    .ascii "ERR\r\n\0"

# ---------- GDT ----------------------------------------------
.align 8
gdt_start:
    .quad 0x0000000000000000
    .quad 0x00CF9A000000FFFF    # code
    .quad 0x00CF92000000FFFF    # data
gdt_end:

gdt_desc:
    .word gdt_end - gdt_start - 1
    .long gdt_start

# ---------- IDT ----------------------------------------------
.code32
idt_stub:
    cli
    hlt
    jmp idt_stub
.code16

.macro IDT_ENTRY
    .word idt_stub
    .word CODE_SEL
    .byte 0
    .byte 0x8E
    .word 0
.endm

.align 8
idt_start:
    .rept 32
        IDT_ENTRY
    .endr
idt_end:

idt_desc:
    .word idt_end - idt_start - 1
    .long idt_start

# ---------- entrada modo protegido ---------------------------
.code32
pm_entry:
    mov $DATA_SEL, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    mov $0x9FC00, %esp

    mov $KERNEL_LOAD_ADDR, %eax
    jmp *%eax

# ---------- padding e assinatura -----------------------------
.org 510
.word 0xAA55