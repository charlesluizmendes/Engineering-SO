AS   = as
LD   = ld
CC   = gcc
QEMU = qemu-system-i386

CFLAGS = -m32 -ffreestanding -nostdlib -fno-pie -fno-pic

BOOT_SRC = bootloader.s
BOOT_OBJ = bootloader.o
BOOT_BIN = bootloader.bin

KERNEL_SRC = kernel.c
KERNEL_OBJ = kernel.o
KERNEL_BIN = kernel.bin

IMAGE = os.img

all: $(IMAGE)

$(KERNEL_OBJ): $(KERNEL_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) -m elf_i386 -Ttext 0x1000 -e kmain --oformat binary -o $@ $<

$(BOOT_OBJ): $(BOOT_SRC) $(KERNEL_BIN)
	@ks=$$(stat -c%s $(KERNEL_BIN)); \
	sectors=$$(( (ks + 511) / 512 )); \
	echo "🔢 kernel = $$sectors setor(es)"; \
	$(AS) --32 --defsym KERNEL_SECTORS=$$sectors $(BOOT_SRC) -o $@

$(BOOT_BIN): $(BOOT_OBJ)
	$(LD) -m elf_i386 -Ttext 0x7C00 --oformat binary -o $@ $<

$(IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	cp $(BOOT_BIN) $@
	cat $(KERNEL_BIN) >> $@
	@sz=$$(stat -c%s $@); pad=$$(( (512 - (sz%512)) % 512 )); \
	if [ $$pad -ne 0 ]; then dd if=/dev/zero bs=$$pad count=1 >> $@ 2>/dev/null; fi

run: $(IMAGE)
	$(QEMU) -no-reboot -fda $(IMAGE)

clean:
	rm -f $(BOOT_OBJ) $(BOOT_BIN) $(KERNEL_OBJ) $(KERNEL_BIN) $(IMAGE)

.PHONY: all run clean