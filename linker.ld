ENTRY(_start)

SECTIONS
{
  . = 0xC0100000;


  /*  Multiboot header needs to be placed at the beginning of the kernel  */
  /*
  .rodata ALIGN(4K) : AT(ADDR(.rodata) - 0xC0000000)
  {
    *(.multiboot)
    *(.rodata)
  }

  .text ALIGN(4K) : AT(ADDR(.text) - 0xC0000000)
  {
    *(.text)
  }

  .data ALIGN(4K) : AT(ADDR(.data) - 0xC0000000)
  {
    *(.data)
  }

  .bss ALIGN(4K) : AT(ADDR(.bss) - 0xC0000000)
  {
    *(COMMON)
    *(.bss)
  }
  */

  .rodata ALIGN(0x1000) : AT(ADDR(.rodata) - 0xC0000000)
  {
    *(.multiboot)
    *(.rodata*)
  }

  .text ALIGN(0x1000) : AT(ADDR(.text) - 0xC0000000)
  {
    *(.text)
  }

  .data ALIGN(0x1000) : AT(ADDR(.data) - 0xC0000000)
  {
    *(.data)
  }

  .bss ALIGN(0x1000) : AT(ADDR(.bss) - 0xC0000000)
  {
    *(COMMON)
    *(.bss)
  }

}
