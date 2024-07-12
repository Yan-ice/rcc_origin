
BOOTLOADER := opensbi_fw_jump_nezha.bin
# BOOTLOADER := fw_jump.bin

WORK_DIR = $(shell pwd)
USER_DIR = $(WORK_DIR)/user

FS_IMG = $(USER_DIR)/fs.img
BUILD_DIR = $(WORK_DIR)/os/build

KERNEL_NAME = rcc
KERNEL_ELF = $(BUILD_DIR)/$(KERNEL_NAME).elf
KERNEL_BIN = $(BUILD_DIR)/$(KERNEL_NAME).bin
KERNEL_DISASM = $(BUILD_DIR)/$(KERNEL_NAME).txt

MMK_BIN = $(WORK_DIR)/MMK_skip_qemu.bin

KERNEL_ENTRY_PA = 0x80800000
MMK_ENTRY_PA = 0x80200000
run:
	cd os && make
	./qemu-system-riscv64-4.2.0 \
                -machine virt \
                -nographic \
                -bios $(BOOTLOADER) \
                -device loader,file=$(KERNEL_BIN),addr=$(KERNEL_ENTRY_PA) \
                -device loader,file=$(MMK_BIN),addr=$(MMK_ENTRY_PA) \
                -drive file=$(FS_IMG),if=none,format=raw,id=x0 \
        -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

run_nezha:
	cd os && make
	xfel ddr d1
	xfel write 0x40000000 $(BOOTLOADER) 
	xfel write 0x40200000 $(KERNEL_BIN)
	xfel exec 0x40000000

