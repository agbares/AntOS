#include "terminal.h"

volatile uint16_t* VGABuffer = (uint16_t*) 0xC00B8000;
const int VGA_COLS = 80;
const int VGA_ROWS = 25;

int terminalColumn = 0;
int terminalRow = 0;
uint8_t terminalColor = 0x0F; // Black background, white foreground

void terminal_init()
{
  // Clear textmode buffer
  for (int column = 0; column < VGA_COLS; column++)
  {
    for(int row = 0; row < VGA_ROWS; row++)
    {
      // Note: The VGA textmode buffer has a size of 'VGA_COLS x VGA_ROWS'
      const size_t index = (VGA_COLS * row) + column;

      // The VGA Buffer follows the following form in bits: BBBBFFFFCCCCCCCC
      // Where:
      //  B -> Background color
      //  F -> Foreground color
      //  C -> ASCII character
      VGABuffer[index] = ((uint16_t)terminalColor << 8) | ' '; // Set character to blank
    }
  }
}
void terminal_putc(const char c)
{
  switch(c)
  {
    case '\n':
      terminalColumn = 0;
      terminalRow++;
      break;

    default:;
      const size_t index = (VGA_COLS * terminalRow) + terminalColumn;
      VGABuffer[index] = ((uint16_t)terminalColor << 8) | c;
      terminalColumn++;
      break;

  }

  // If the terminal column exceeds the max columns, then reset the terminal columns
  if (terminalColumn >= VGA_COLS)
  {
    terminalColumn = 0;
    terminalRow++;
  }

  // If the terminal row exceeds the max rows, then reset the terminal rows
  if (terminalRow >= VGA_ROWS)
  {
    terminalColumn = 0;
    terminalRow = 0;
  }
}

void terminal_print(const char* cstring)
{
  for(size_t i = 0; cstring[i] != '\0'; i++)
    terminal_putc(cstring[i]);
}

// extern void terminal_print(int value)
// {
//   value = 0;
// }
