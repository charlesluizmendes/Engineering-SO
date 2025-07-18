# Bootloader x86

Bootloader simples em Assembly x86 para a disciplina COS773.

**Código fonte:** https://github.com/charlesluizmendes/Engineering-SO/tree/main/Bootloader

## Requisitos

```bash
sudo apt update
sudo apt install build-essential qemu-system-x86 gdb xxd
```

## Compilar

```bash
make all
```

## Executar

```bash
make test
```

## Comandos

- `make all` - Compila o bootloader
- `make test` - Executa no QEMU
- `make clean` - Limpa arquivos gerados
- `make info` - Mostra informações do arquivo

## Como usar

1. Digite qualquer tecla - aparece na tela
2. Enter - nova linha
3. ESC - sai do sistema

## Arquivos

- `bootloader.s` - Código fonte
- `Makefile` - Script de compilação
- `bootloader.img` - Arquivo final (512 bytes)
