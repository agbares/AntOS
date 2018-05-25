#include <stddef.h>
#include <stdint.h>

#include "terminal.h"
#include "cstring.h"
#include "system/GDT.h"

// Run basic checks to ensure x86-elf cross compiler is used
#if defined(__linux__)
  #error "Must be compiled with a cross-compiler."
#elif !defined(__i386)
  #error "This must be compiled with an x86-elf compiler"
#endif

extern "C"
void kernel_main()
{
  terminal_init();

  terminal_print("Hello, World!\n\0");
  terminal_print("Welcome to the kernel.\n\0");
  terminal_print("Setting up GDT...\n\0");

  system::GDT_init();
  //
  // terminal_print("Complete\n\0");

  // terminal_print("Length of string: " + (char) cstrlen("str"));

}
