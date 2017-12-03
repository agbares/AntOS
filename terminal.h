#ifndef TERMINAL_H
#define TERMINAL_H

#include <stddef.h>
#include <stdint.h>

extern volatile uint16_t* VGABuffer;
extern const int VGA_COLS;
extern const int VGA_ROWS;

extern int terminalColumn;
extern int terminalRow;
extern uint8_t terminalColor;

extern void terminal_init();
extern void terminal_putc(const char c);
extern void terminal_print(const char* cstring);

// extern void terminal_print(int value);

#endif  // TERMINAL_H
