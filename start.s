.extern kernel_main
.global start
.global _start
.global .GDT_flush
.extern _ZN6system7GDT_ptrE // GDT_ptr

// Set up multiboot
.set MB_MAGIC, 0x1BADB002
.set MB_FLAGS, (1 << 0) | (1 << 1)  // Load modules on page boundaries and provide memory map
.set MB_CHECKSUM, (0 - (MB_MAGIC + MB_FLAGS))

.section .multiboot
  .align 4
  .long MB_MAGIC
  .long MB_FLAGS
  .long MB_CHECKSUM

// Base of higher-half kernel
.equ KERNEL_VIRTUAL_BASE, 0xC0000000
// Page Table index in virtual memory
.equ KERNEL_PAGE_NUMBER, (KERNEL_VIRTUAL_BASE >> 22)

.section .bss
  .align 16
  stack_bottom: .skip 4096 // 4096-byte stack
  stack_top:

  .align 4096
  .lcomm Page_Table1, (1024 * 4 * 1024)
  .lcomm Page_Directory, (1024 * 4 * 1)

.section .data
  GDT_content:
    .byte 0, 0, 0, 0, 0, 0, 0, 0            // Null selector
    .byte 255, 255, 0, 0, 0, 0x9A, 0xCF, 0  // Kernel mode code selector
    .byte 255, 255, 0, 0, 0, 0x92, 0xCF, 0  // Kernel mode data selector

  GDT_pointer:
    .byte 24, 0, 0, 0, 0, 0

  .align 4096
  BootPageDirectoryVirtualAddress:
    .long 0x00000083
    .rept (KERNEL_PAGE_NUMBER - 1)
      .long 0
      .endr

    .long 0x00000083
    .rept (1024 - KERNEL_PAGE_NUMBER - 1)
      .long 0
    .endr

.section .text


  start:
    .set _start, (start - 0xC0000000)
    .set BootPageDirectoryPhysicalAddress, (BootPageDirectoryVirtualAddress - KERNEL_VIRTUAL_BASE)

    mov $BootPageDirectoryPhysicalAddress, %ecx
    mov %ecx, %cr3

    // Set PSE bit in CR4 to enable 4MB pages
    mov %cr4, %ecx
    or $0x00000010, %ecx
    mov %ecx, %cr4

    // Set PG bit in CR0 to enable paging
    mov %cr0, %ecx
    or $0x80000000, %ecx
    mov %ecx, %cr0

    lea higher_half_start, %ecx
    jmp *%ecx


    // mov $stack_top - KERNEL_VIRTUAL_BASE, %esp  // Set up stack pointer
    // call GDT_load
    //call Paging_setup
    //call Start_in_higher_half
    // call kernel_main



    // hang:
    //   cli
    //   hlt
    //   jmp hang

    higher_half_start:
      // Unmap the identity map for the first 4 MB
      // movl $0, (BootPageDirectoryVirtualAddress)
      // invlpg (0)

      // mov $stack_top, %esp

      call kernel_main

      hang:
        cli
        hlt
        jmp hang

  // GDT Initialization
  GDT_load:
    mov $GDT_content, %ebx
    movl $GDT_pointer, %eax
    movl %ebx, 2(%eax)
    lgdt (%eax)

  .GDT_flush:
    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    jmp $0x08, $.CS_flush - KERNEL_VIRTUAL_BASE

  .CS_flush:
    ret
  //
  // // Paging & Virtual Memory Setup
  // Paging_setup:
  //
  //   // Map virtual memory for physical address execution
  //   lea Page_Table1 - KERNEL_VIRTUAL_BASE, %eax
  //   movl $7, %ebx           // Set Page Table flags
  //   movl $(4 * 1024), %ecx
  //
  //   // Loop through each page table entry
  //   .loop1:
  //   mov %ebx, (%eax)
  //   add $4, %eax
  //   add $4096, %ebx
  //   loop .loop1
  //
  //   lea Page_Table1 - KERNEL_VIRTUAL_BASE, %eax
  //   add $(KERNEL_PAGE_NUMBER * 1024 * 4), %eax
  //   mov $7, %ebx
  //   mov $(4 * 1024), %ecx
  //
  //   .loop2:
  //   mov %ebx, (%eax)
  //   add $4, %eax
  //   add $4096, %ebx
  //   loop .loop2
  //
  //   lea Page_Table1 - KERNEL_VIRTUAL_BASE, %ebx
  //   lea Page_Directory - KERNEL_VIRTUAL_BASE, %edx
  //   or $7, %ebx             // Set Page directory flags
  //   mov $1024, %ecx
  //
  //   // Loop through each page directory entry
  //   .loop3:
  //   mov %ebx, (%edx)
  //   add $4, %edx
  //   add $4096, %ebx
  //   loop .loop3
  //
  //   // Setup page directory
  //   lea Page_Directory - KERNEL_VIRTUAL_BASE, %ecx
  //   mov %ecx, %cr3
  //
  //   // Turn on Paging
  //   mov %cr0, %ecx
  //   or $0x80000000, %ecx
  //   mov %ecx, %cr0
  //
  //   ret
  //
  // Start_in_higher_half:
  //   lea .higherhalf, %ecx
  //   jmp %ecx
  //
  //   .higherhalf:
  //     ret
