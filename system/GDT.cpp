// GDT Setup Implementation
// Author: Antonio G. Bares Jr.

#include "GDT.h"

namespace system
{
  GDT_entry GDT_entries[3];
  GDT_pointer GDT_ptr;

  // descriptor_set : GDT_entry
  // Sets up descriptor for GDT
  void discriptor_set(const unsigned int index, const uint32_t base, const uint32_t limit, const uint8_t access, const uint8_t granularity)
  {
    GDT_ptr.limit = 0;
    // Set base bits
    GDT_entries[index].base_low = (base & 0xFFFF);
    GDT_entries[index].base_mid = ((base >> 16) & 0xFF);
    GDT_entries[index].base_high = ((base >> 24) & 0xFF);

    // Set limit bits
    GDT_entries[index].limit_low = (limit & 0xFFFF);
    GDT_entries[index].granularity = ((limit >> 16) & 0xF);

    // Set access bits
    GDT_entries[index].access = access;

    // Set flags in MSB of MSW including granularity
    GDT_entries[index].granularity = ((granularity << 4) | GDT_entries[index].granularity);

  }

  // GDT_init : void
  // Global Descriptor Table Initialization
  void GDT_init()
  {
    GDT_ptr.limit = (sizeof(GDT_entry) * 3) - 1;
    GDT_ptr.base = uint32_t(&GDT_entries);

    // NULL descriptor
    discriptor_set(0, 0, 0, 0, 0);

    // Kernel Code segment
    discriptor_set(1, 0, 0xFFFFFFFF, 0x9A, 0xC);

    // Kernel Data segment
    discriptor_set(2, 0, 0xFFFFFFFF, 0x92, 0xC);

    // Flush old GDT and load new GDT
    //GDT_flush();
  }

}
