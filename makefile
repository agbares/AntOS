CC = i386-elf-g++
AS = i386-elf-gcc
CFLAGS = -std=c++11 -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti -c
AFLAGS = -std=gnu99 -ffreestanding -c
LDFLAGS = -ffreestanding -nostdlib -lgcc -T
LINKSCRIPT = linker.ld
OBJ = start.o kernel.o terminal.o CString.o system/GDT.o
EXECUTABLE = kernel.elf

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJ)
	$(AS) $(LDFLAGS) $(LINKSCRIPT) $(OBJ) -o $@

start.o: start.s
	$(AS) $(AFLAGS) start.s -o $@

kernel.o: kernel.cpp
	$(CC) $(CFLAGS) kernel.cpp -o $@

terminal.o: terminal.h terminal.cpp
	$(CC) $(CFLAGS) terminal.cpp -o $@

CString.o: CString.h CString.cpp
	$(CC) $(CFLAGS) CString.cpp -o $@

system/GDT.o: system/GDT.h system/GDT.cpp
	$(CC) $(CFLAGS) system/GDT.cpp -o $@

.PHONY: clean

clean:
	rm *.o
