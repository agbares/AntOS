// GDT Setup Specification
// Author: Antonio G. Bares Jr.

#ifndef GDT_H
#define GDT_H

#include <stddef.h>
#include <stdint.h>

namespace system
{
  // Global Descriptor Table entry
  struct GDT_entry
  {
    uint16_t limit_low;
    uint16_t base_low;
    uint8_t base_mid;
    uint8_t access;
    uint16_t granularity;
    uint8_t base_high;

  } __attribute__((packed));

  // Pointer to Global Descriptor Table
  // Note: Limit is max bytes taken up by the GDT minus 1
  struct GDT_pointer
  {
    uint16_t limit;
    uint32_t base;
  } __attribute__ ((packed));

  extern GDT_entry GDT_entries[3];
  extern GDT_pointer GDT_ptr;

  // GDT_flush : void
  // Function to reload segment registers in the CPU
  // Implementation is found in start.s
  extern "C"
  void GDT_flush();

  extern void discriptor_set(const unsigned int, const uint32_t, const uint32_t, const uint8_t, const uint8_t);
  extern void GDT_init();
}

#endif  // GTD_H
