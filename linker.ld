ENTRY(start)

SECTIONS
{
  /* Place the kernel at the beginning of the 1MB section */
  . = 1M;

  /*  Multiboot header needs to be placed at the beginning of the kernel  */
  .rodata BLOCK(4K) : ALIGN(4K)
  {
    *(.multiboot)
  }

  .text BLOCK(4K) : ALIGN(4K)
  {
    *(.text)
  }

  .rodata BLOCK(4K) : ALIGN(4K)
  {
    *(.rodata)
  }

  .data BLOCK(4K) : ALIGN(4K)
  {
    *(.data)
  }

  .bss BLOCK(4K) : ALIGN(4K)
  {
    *(COMMON)
    *(.bss)
  }
}
