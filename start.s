.extern kernel_main
.global start
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

.section .text

  start:
    mov $stack_top, %esp  // Set up stack pointer
    call GDT_load
    call Paging_setup
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
    jmp $0x08, $.CS_flush

  .CS_flush:
    ret

  // Paging & Virtual Memory Setup
  Paging_setup:

    // Map virtual memory for physical address execution
    lea Page_Table1, %eax
    movl $7, %ebx           // Set Page Table flags
    movl $(4 * 1024), %ecx

    // Loop through each page table entry
    .loop1:
    mov %ebx, (%eax)
    add $4, %eax
    add $4096, %ebx
    loop .loop1

    lea Page_Table1, %ebx
    lea Page_Directory, %edx
    or $7, %ebx             // Set Page directory flags
    mov $1024, %ecx

    // Loop through each page directory entry
    .loop3:
    mov %ebx, (%edx)
    add $4, %edx
    add $4096, %ebx
    loop .loop3

    // Setup page directory
    lea Page_Directory, %ecx
    mov %ecx, %cr3

    // Turn on Paging
    mov %cr0, %ecx
    or $0x80000000, %ecx
    mov %ecx, %cr0
