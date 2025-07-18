# Makefile para Bootloader COS773
# IMPORTANTE: Linhas de comando devem começar com TAB!

# Variáveis
AS = as
LD = ld
QEMU = qemu-system-i386
TARGET = bootloader.img
SOURCE = bootloader.s
OBJECT = bootloader.o

# Regra principal
all: $(TARGET)

# Compila assembly para objeto
$(OBJECT): $(SOURCE)
	$(AS) --32 $(SOURCE) -o $(OBJECT)

# Liga objeto para imagem binária
$(TARGET): $(OBJECT)
	$(LD) -m elf_i386 -Ttext 0x7c00 --oformat binary -o $(TARGET) $(OBJECT)
	@echo "✅ Bootloader compilado com sucesso!"
	@echo "📁 Tamanho: $$(stat -c%s $(TARGET)) bytes"

# Testa no QEMU
test: $(TARGET)
	@echo "🚀 Iniciando QEMU..."
	$(QEMU) -fda $(TARGET)

# Debug com QEMU
debug: $(TARGET)
	@echo "🐛 Iniciando QEMU em modo debug..."
	@echo "Em outro terminal: gdb -> target remote :1234"
	$(QEMU) -fda $(TARGET) -s -S

# Informações do arquivo
info: $(TARGET)
	@echo "=== INFORMAÇÕES DO BOOTLOADER ==="
	@echo "Arquivo: $(TARGET)"
	@echo "Tamanho: $$(stat -c%s $(TARGET)) bytes"
	@echo "Assinatura de boot (últimos 2 bytes):"
	@xxd -l 2 -s +510 $(TARGET)

# Limpa arquivos gerados
clean:
	@echo "🧹 Limpando arquivos..."
	rm -f $(OBJECT) $(TARGET)

# Reinstala dependências
deps:
	@echo "📦 Instalando dependências..."
	sudo apt update
	sudo apt install -y build-essential qemu-system-x86 xxd

# Verifica ferramentas
check:
	@echo "🔍 Verificando ferramentas..."
	@which $(AS) || echo "❌ 'as' não encontrado"
	@which $(LD) || echo "❌ 'ld' não encontrado" 
	@which $(QEMU) || echo "❌ 'qemu-system-i386' não encontrado"
	@which xxd || echo "⚠️  'xxd' não encontrado (opcional)"

# Ajuda
help:
	@echo "=== MAKEFILE BOOTLOADER COS773 ==="
	@echo "Comandos disponíveis:"
	@echo "  make all    - Compila o bootloader"
	@echo "  make test   - Testa no QEMU"
	@echo "  make debug  - Debug com GDB"
	@echo "  make info   - Mostra informações"
	@echo "  make clean  - Limpa arquivos"
	@echo "  make deps   - Instala dependências"
	@echo "  make check  - Verifica ferramentas"
	@echo "  make help   - Mostra esta ajuda"

# Declara alvos que não são arquivos
.PHONY: all test debug info clean deps check help
