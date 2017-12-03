#include "cstring.h"

CString::CString()
{
  length = 0;
  *string = '\0';
}

CString::CString(const char* cstring)
{
  int i = 0;

  do
  {
    string[i] = cstring[i];
    i++;
  } while(cstring[i] != '\0');

  length = i - 1;
}

CString::CString(const int value)
{
  
}

// Accessors
const char* CString::getString() const
{
  return string;
}

int CString::getLength() const
{
  return length;
}


// Mutators
void CString::setString(const char* cstring)
{
  int i = 0;

  do
  {
    string[i] = cstring[i];
    i++;
  } while(cstring[i] != '\0');

  length = i - 1;
}



// char* cstrcat(const char* cstring1, const char* cstring2)
// {
//   return NULL;
// }
//
// char* cstrcpy(char* destination, const char* source)
// {
//   return NULL;
// }
//
// int cstrcmp(const char* cstring1, const char* cstring2)
// {
//   return 0;
// }
//
// int cstrlen(const char* cstring)
// {
//   int i = 0;
//   while(cstring[i] != '\0')
//   {
//     i++;
//   }
//
//   return i + 1;
// }
