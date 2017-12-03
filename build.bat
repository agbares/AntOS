echo Assembling start.s...
i386-elf-gcc -std=gnu99 -ffreestanding -c start.s -o start.o

echo Compiling kernel.cpp...
i386-elf-g++ -c kernel.cpp -o kernel.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti

echo Compiling terminal.cpp...
i386-elf-g++ -c terminal.cpp -o terminal.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti

echo Compiling cstring.cpp...
i386-elf-g++ -c CString.cpp -o CString.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti

echo Compiling GDT.cpp
i386-elf-g++ -c system/GDT.cpp -o system/GDT.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti

echo Linking kernel...
i386-elf-gcc -ffreestanding -nostdlib -T linker.ld start.o kernel.o terminal.o CString.o system/GDT.o -o kernel.elf -lgcc
