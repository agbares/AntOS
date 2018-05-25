CXX = i386-elf-g++
CC = i386-elf-gcc
# AS = i386-elf-gcc
AS = nasm
CFLAGS = -std=c++11 -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti -c
# AFLAGS = -std=gnu99 -ffreestanding -c
AFLAGS = -f elf
LDFLAGS = -ffreestanding -nostdlib -lgcc -T
LINKSCRIPT = linker.ld
OBJ = start_intel.o kernel.o terminal.o CString.o system/GDT.o
EXECUTABLE = kernel.elf

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJ)
	$(CC) $(LDFLAGS) $(LINKSCRIPT) $(OBJ) -o $@

# start.o: start.s
# 	$(AS) $(AFLAGS) start.s -o $@
start_intel.o: start_intel.s
	$(AS) $(AFLAGS) start_intel.s -o $@

kernel.o: kernel.cpp
	$(CXX) $(CFLAGS) kernel.cpp -o $@

terminal.o: terminal.h terminal.cpp
	$(CXX) $(CFLAGS) terminal.cpp -o $@

CString.o: CString.h CString.cpp
	$(CXX) $(CFLAGS) CString.cpp -o $@

system/GDT.o: system/GDT.h system/GDT.cpp
	$(CXX) $(CFLAGS) system/GDT.cpp -o $@

.PHONY: clean

clean:
	rm *.o kernel.elf

run:
	qemu-system-i386 -kernel $(EXECUTABLE) -d cpu_reset,int -no-reboot

