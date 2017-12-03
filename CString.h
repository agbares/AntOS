#ifndef CSTRING_H
#define CSTRING_H

#include <stddef.h>
#include <stdint.h>

class CString
{
private:
  unsigned int length;
  char* string;

public:
  CString();
  CString(const char*);
  CString(const int);

  // Accessors
  const char* getString() const;
  int getLength() const;


  // Mutators
  void setString(const char*);
  void setString(const int);

};

// extern char* cstrcat(const char* cstring1, const char* cstring2);
// extern char* cstrcpy(char* destination, const char* source);
// extern int cstrcmp(const char* cstring1, const char* cstring2);
// extern int cstrlen(const char* cstring);

#endif  // CSTRING_H
