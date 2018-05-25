extern kernel_main
global start
global _start
global GDT_flush
extern _ZN6system7GDT_ptrE

MB_MAGIC equ 0x1BADB002
MB_FLAGS equ (1 << 0) | (1 << 1)
MB_CHECKSUM equ (0 - (MB_MAGIC + MB_FLAGS))
KERNEL_STACK_SIZE equ 4096

section .multiboot
  align 4
  dd MB_MAGIC
  dd MB_FLAGS
  dd MB_CHECKSUM

  KERNEL_VIRTUAL_BASE equ 0xC0000000
  KERNEL_PAGE_NUMBER equ (KERNEL_VIRTUAL_BASE >> 22)

section .bss
  align 16
  stack_bottom:
    resb KERNEL_STACK_SIZE
  stack_top:

section .data

  align 4096
  BootPageDirectoryVirtualAddress:
    dd 0x00000083
    times (KERNEL_PAGE_NUMBER - 1) dd 0
    dd 0x00000083
    times (1024 - KERNEL_PAGE_NUMBER - 1) dd 0

section .text
  start:
  _start equ (start - 0xC0000000)
  ; Set up page for higher half kernel
  BootPageDirectoryPhysicalAddress equ (BootPageDirectoryVirtualAddress - KERNEL_VIRTUAL_BASE)
  mov ecx, BootPageDirectoryPhysicalAddress
  mov cr3, ecx

  ; Set PSE bit in CR4 to enable 4MB pages
  mov ecx, cr4
  or ecx, 0x00000010
  mov cr4, ecx

  ; Set PG bit in CR0 to enable paging
  mov ecx, cr0
  or ecx, 0x80000000
  mov cr0, ecx

  ; Must execute a long jump in order to move the EIP to
  ; the virtual address space of the higher half kernel
  lea ecx, [higher_half_start]
  jmp ecx

  higher_half_start:
    ; Unmap the identity map for the first 4 MB
    mov dword [BootPageDirectoryVirtualAddress], 0
    invlpg [0]

    ; Set up stack in higher higher half
    mov esp, stack_top


    call kernel_main

    cli
    hlt
