{*******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcDynArrays.pas                                         }
{   File version:     5.30                                                     }
{   Description:      Utility functions for dynamic arrays                     }
{                                                                              }
{   Copyright:        Copyright (c) 2000-2018, David J Butler                  }
{                     All rights reserved.                                     }
{                     Redistribution and use in source and binary forms, with  }
{                     or without modification, are permitted provided that     }
{                     the following conditions are met:                        }
{                     Redistributions of source code must retain the above     }
{                     copyright notice, this list of conditions and the        }
{                     following disclaimer.                                    }
{                     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND   }
{                     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED          }
{                     WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED   }
{                     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A          }
{                     PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL     }
{                     THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,    }
{                     INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR             }
{                     CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,    }
{                     PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF     }
{                     USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)         }
{                     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER   }
{                     IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING        }
{                     NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE   }
{                     USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE             }
{                     POSSIBILITY OF SUCH DAMAGE.                              }
{                                                                              }
{   Github:           https://github.com/fundamentalslib                       }
{   E-mail:           fundamentals.library at gmail.com                        }
{                                                                              }
{ Revision history:                                                            }
{                                                                              }
{   2000/03/08  1.01  Initial verison: array functions.                        }
{   2000/04/10  1.02  Added Append, Renamed Delete to Remove and added         }
{                     StringArrays.                                            }
{   2000/06/01  1.03  Added Range and Dup constructors for dynamic arrays.     }
{   2000/06/03  1.04  Added ArrayInsert functions.                             }
{   2000/06/14  1.05  Unit now generated from a template using a source        }
{                     pre-processor.                                           }
{   2000/07/04  1.06  Revision for first Fundamentals release.                 }
{   2000/07/24  1.07  Added TrimArray functions.                               }
{   2000/07/26  1.08  Added Difference functions.                              }
{   2000/09/02  1.09  Added RemoveDuplicates functions.                        }
{                     Added Count functions.                                   }
{                     Fixed bug in Sort.                                       }
{   2000/09/27  1.10  Fixed bug in ArrayInsert.                                }
{   2001/11/11  2.11  Revision.                                                }
{   2002/05/31  3.12  Refactored for Fundamentals 3.                           }
{   2003/09/11  3.13  Added InterfaceArray functions.                          }
{   2004/01/18  3.14  Added WideStringArray functions.                         }
{   2004/07/24  3.15  Optimizations of Sort functions.                         }
{   2004/08/22  3.16  Compilable with Delphi 8.                                }
{   2005/06/10  4.17  Compilable with FreePascal 2 Win32 i386.                 }
{   2005/08/19  4.18  Compilable with FreePascal 2 Linux i386.                 }
{   2005/09/21  4.19  Revised for Fundamentals 4.                              }
{   2006/03/04  4.20  Compilable with Delphi 2006 Win32/.NET.                  }
{   2007/06/08  4.21  Compilable with FreePascal 2.04 Win32 i386               }
{   2009/10/09  4.22  Compilable with Delphi 2009 Win32/.NET.                  }
{   2010/06/27  4.23  Compilable with FreePascal 2.4.0 OSX x86-64.             }
{   2011/04/03  4.24  Support for Delphi XE string and integer types.          }
{   2011/04/04  4.25  Split dynamic array functions from Utils unit.           }
{   2012/08/26  4.26  UnicodeString functions.                                 }
{   2015/03/13  4.27  RawByteString functions.                                 }
{   2016/01/09  5.28  Revised for Fundamentals 5.                              }
{   2016/04/16  5.29  Changes for FreePascal 3.0.0.                            }
{   2018/07/17  5.30  Int32/Word32 functions.                                  }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 7 Win32                      5.28  2016/01/09                       }
{   Delphi XE7 Win32                    5.28  2016/01/09                       }
{   Delphi XE7 Win64                    5.28  2016/01/09                       }
{   Delphi 10 Win32                     5.28  2016/01/09                       }
{   Delphi 10 Win64                     5.28  2016/01/09                       }
{   FreePascal 3.0.0 Win32              5.29  2016/04/16                       }
{                                                                              }
{*******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

{$IFDEF DEBUG}
{$IFDEF TEST}
  {$DEFINE DYNARRAYS_TEST}
{$ENDIF}
{$ENDIF}

unit flcDynArrays;

interface

uses
  { System }
  SysUtils,

  { Fundamentals }
  flcStdTypes,
  flcUtils;



{                                                                              }
{ Dynamic arrays                                                               }
{                                                                              }
{%DEFINE DynArrayAppend}
function  DynArrayAppend%1%(var V: %2%Array; const R: %3%): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}{%ENDDEF}
{%TEMPLATE DynArrayAppend ''  'Byte'          'Byte'}
{%TEMPLATE DynArrayAppend ''  'Word'          'Word'}
{%TEMPLATE DynArrayAppend ''  'Word32'        'Word32'}
{%TEMPLATE DynArrayAppend ''  'LongWord'      'LongWord'}
{%TEMPLATE DynArrayAppend ''  'NativeUInt'    'NativeUInt'}
{%TEMPLATE DynArrayAppend ''  'ShortInt'      'ShortInt'}
{%TEMPLATE DynArrayAppend ''  'SmallInt'      'SmallInt'}
{%TEMPLATE DynArrayAppend ''  'LongInt'       'LongInt'}
{%TEMPLATE DynArrayAppend ''  'Int32'         'Int32'}
{%TEMPLATE DynArrayAppend ''  'Int64'         'Int64'}
{%TEMPLATE DynArrayAppend ''  'NativeInt'     'NativeInt'}
{%TEMPLATE DynArrayAppend ''  'Single'        'Single'}
{%TEMPLATE DynArrayAppend ''  'Double'        'Double'}
{%TEMPLATE DynArrayAppend ''  'Extended'      'Extended'}
{%TEMPLATE DynArrayAppend ''  'Currency'      'Currency'}
{%TEMPLATE DynArrayAppend ''  'Boolean'       'Boolean'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayAppend 'A' 'AnsiString'    'AnsiString'}
{%TEMPLATE DynArrayAppend 'B' 'RawByteString' 'RawByteString'}
{$ENDIF}
{%TEMPLATE DynArrayAppend 'W' 'WideString'    'WideString'}
{%TEMPLATE DynArrayAppend 'U' 'UnicodeString' 'UnicodeString'}
{%TEMPLATE DynArrayAppend ''  'String'        'String'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayAppend ''  'Pointer'    'Pointer'}
{$ENDIF}
{%TEMPLATE DynArrayAppend ''  'Object'      'TObject'}
{%TEMPLATE DynArrayAppend ''  'Interface'   'IInterface'}
{%TEMPLATE DynArrayAppend ''  'ByteSet'     'ByteSet'}
{%TEMPLATE DynArrayAppend ''  'ByteCharSet' 'ByteCharSet'}

{%DEFINE DynArrayAppendArray}
function  DynArrayAppend%1%Array(var V: %1%Array; const R: %2%): Integer; overload;{%ENDDEF}
{%TEMPLATE DynArrayAppendArray 'Byte'          'array of Byte'}
{%TEMPLATE DynArrayAppendArray 'Word'          'array of Word'}
{%TEMPLATE DynArrayAppendArray 'Word32'        'array of Word32'}
{%TEMPLATE DynArrayAppendArray 'Cardinal'      'array of Cardinal'}
{%TEMPLATE DynArrayAppendArray 'NativeUInt'    'array of NativeUInt'}
{%TEMPLATE DynArrayAppendArray 'ShortInt'      'array of ShortInt'}
{%TEMPLATE DynArrayAppendArray 'SmallInt'      'array of SmallInt'}
{%TEMPLATE DynArrayAppendArray 'Integer'       'array of LongInt'}
{%TEMPLATE DynArrayAppendArray 'Int32'         'array of Int32'}
{%TEMPLATE DynArrayAppendArray 'Int64'         'array of Int64'}
{%TEMPLATE DynArrayAppendArray 'NativeInt'     'array of NativeInt'}
{%TEMPLATE DynArrayAppendArray 'Single'        'array of Single'}
{%TEMPLATE DynArrayAppendArray 'Double'        'array of Double'}
{%TEMPLATE DynArrayAppendArray 'Extended'      'array of Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayAppendArray 'AnsiString'    'array of AnsiString'}
{%TEMPLATE DynArrayAppendArray 'RawByteString' 'array of RawByteString'}
{$ENDIF}
{%TEMPLATE DynArrayAppendArray 'WideString'    'array of WideString'}
{%TEMPLATE DynArrayAppendArray 'UnicodeString' 'array of UnicodeString'}
{%TEMPLATE DynArrayAppendArray 'String'        'array of String'}
{$IFNDEF CLR}
{%TEMPLATE DynArrayAppendArray 'Currency'      'array of Currency'}
{%TEMPLATE DynArrayAppendArray 'Pointer'       'array of Pointer'}
{%TEMPLATE DynArrayAppendArray 'ByteCharSet'   'array of ByteCharSet'}
{%TEMPLATE DynArrayAppendArray 'ByteSet'       'array of ByteSet'}
{$ENDIF}
{%TEMPLATE DynArrayAppendArray 'Object'        'ObjectArray'}

{%DEFINE DynArrayRemove}
function  DynArrayRemove%1%(var V: %2%Array; const Idx: Integer; const Count: Integer = 1): Integer; overload;{%ENDDEF}
{%TEMPLATE DynArrayRemove ''  'Byte'}
{%TEMPLATE DynArrayRemove ''  'Word'}
{%TEMPLATE DynArrayRemove ''  'Word32'}
{%TEMPLATE DynArrayRemove ''  'LongWord'}
{%TEMPLATE DynArrayRemove ''  'NativeUInt'}
{%TEMPLATE DynArrayRemove ''  'ShortInt'}
{%TEMPLATE DynArrayRemove ''  'SmallInt'}
{%TEMPLATE DynArrayRemove ''  'LongInt'}
{%TEMPLATE DynArrayRemove ''  'Int32'}
{%TEMPLATE DynArrayRemove ''  'Int64'}
{%TEMPLATE DynArrayRemove ''  'NativeInt'}
{%TEMPLATE DynArrayRemove ''  'Single'}
{%TEMPLATE DynArrayRemove ''  'Double'}
{%TEMPLATE DynArrayRemove ''  'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayRemove 'A' 'AnsiString'}
{%TEMPLATE DynArrayRemove 'B' 'RawByteString'}
{$ENDIF}
{%TEMPLATE DynArrayRemove 'W' 'WideString'}
{%TEMPLATE DynArrayRemove 'U' 'UnicodeString'}
{%TEMPLATE DynArrayRemove ''  'String'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayRemove ''  'Pointer'}
{$ENDIF}
{$IFNDEF CLR}
{%TEMPLATE DynArrayRemove ''  'Currency'}
{$ENDIF}
function  DynArrayRemove(var V: ObjectArray; const Idx: Integer; const Count: Integer = 1;
          const FreeObjects: Boolean = False): Integer; overload;
{%TEMPLATE DynArrayRemove ''  'Interface'}

{%DEFINE DynArrayRemoveDuplicates}
procedure DynArrayRemoveDuplicates%1%(var V: %2%Array; const IsSorted: Boolean); overload;{%ENDDEF}
{%TEMPLATE DynArrayRemoveDuplicates ''  'Byte'}
{%TEMPLATE DynArrayRemoveDuplicates ''  'Word'}
{%TEMPLATE DynArrayRemoveDuplicates ''  'LongWord'}
{%TEMPLATE DynArrayRemoveDuplicates ''  'ShortInt'}
{%TEMPLATE DynArrayRemoveDuplicates ''  'SmallInt'}
{%TEMPLATE DynArrayRemoveDuplicates ''  'LongInt'}
{%TEMPLATE DynArrayRemoveDuplicates ''  'Int64'}
{%TEMPLATE DynArrayRemoveDuplicates ''  'Single'}
{%TEMPLATE DynArrayRemoveDuplicates ''  'Double'}
{%TEMPLATE DynArrayRemoveDuplicates ''  'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayRemoveDuplicates 'A' 'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayRemoveDuplicates 'W' 'WideString'}
{%TEMPLATE DynArrayRemoveDuplicates 'U' 'UnicodeString'}
{%TEMPLATE DynArrayRemoveDuplicates ''  'String'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayRemoveDuplicates ''  'Pointer'}
{$ENDIF}

{%DEFINE DynArrayTrimLeft}
procedure DynArrayTrimLeft%1%(var S: %2%Array; const TrimList: array of %3%); overload;{%ENDDEF}
{%TEMPLATE DynArrayTrimLeft ''  'Byte'          'Byte'}
{%TEMPLATE DynArrayTrimLeft ''  'Word'          'Word'}
{%TEMPLATE DynArrayTrimLeft ''  'LongWord'      'LongWord'}
{%TEMPLATE DynArrayTrimLeft ''  'ShortInt'      'ShortInt'}
{%TEMPLATE DynArrayTrimLeft ''  'SmallInt'      'SmallInt'}
{%TEMPLATE DynArrayTrimLeft ''  'LongInt'       'LongInt'}
{%TEMPLATE DynArrayTrimLeft ''  'Int64'         'Int64'}
{%TEMPLATE DynArrayTrimLeft ''  'Single'        'Single'}
{%TEMPLATE DynArrayTrimLeft ''  'Double'        'Double'}
{%TEMPLATE DynArrayTrimLeft ''  'Extended'      'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayTrimLeft 'A' 'AnsiString'    'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayTrimLeft 'W' 'WideString'    'WideString'}
{%TEMPLATE DynArrayTrimLeft 'U' 'UnicodeString' 'UnicodeString'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayTrimLeft ''  'Pointer'    'Pointer'}
{$ENDIF}

{%DEFINE DynArrayTrimRight}
procedure DynArrayTrimRight%1%(var S: %2%Array; const TrimList: array of %3%); overload;{%ENDDEF}
{%TEMPLATE DynArrayTrimRight ''  'Byte'          'Byte'}
{%TEMPLATE DynArrayTrimRight ''  'Word'          'Word'}
{%TEMPLATE DynArrayTrimRight ''  'LongWord'      'LongWord'}
{%TEMPLATE DynArrayTrimRight ''  'ShortInt'      'ShortInt'}
{%TEMPLATE DynArrayTrimRight ''  'SmallInt'      'SmallInt'}
{%TEMPLATE DynArrayTrimRight ''  'LongInt'       'LongInt'}
{%TEMPLATE DynArrayTrimRight ''  'Int64'         'Int64'}
{%TEMPLATE DynArrayTrimRight ''  'Single'        'Single'}
{%TEMPLATE DynArrayTrimRight ''  'Double'        'Double'}
{%TEMPLATE DynArrayTrimRight ''  'Extended'      'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayTrimRight 'A' 'AnsiString'    'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayTrimRight 'W' 'WideString'    'WideString'}
{%TEMPLATE DynArrayTrimRight 'U' 'UnicodeString' 'UnicodeString'}
{%TEMPLATE DynArrayTrimRight ''  'String'        'String'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayTrimRight ''  'Pointer'       'Pointer'}
{$ENDIF}

{%DEFINE DynArrayInsert}
function  DynArrayInsert%1%(var V: %2%Array; const Idx: Integer; const Count: Integer): Integer; overload;{%ENDDEF}
{%TEMPLATE DynArrayInsert ''  'Byte'}
{%TEMPLATE DynArrayInsert ''  'Word'}
{%TEMPLATE DynArrayInsert ''  'Word32'}
{%TEMPLATE DynArrayInsert ''  'LongWord'}
{%TEMPLATE DynArrayInsert ''  'NativeUInt'}
{%TEMPLATE DynArrayInsert ''  'ShortInt'}
{%TEMPLATE DynArrayInsert ''  'SmallInt'}
{%TEMPLATE DynArrayInsert ''  'LongInt'}
{%TEMPLATE DynArrayInsert ''  'Int32'}
{%TEMPLATE DynArrayInsert ''  'Int64'}
{%TEMPLATE DynArrayInsert ''  'NativeInt'}
{%TEMPLATE DynArrayInsert ''  'Single'}
{%TEMPLATE DynArrayInsert ''  'Double'}
{%TEMPLATE DynArrayInsert ''  'Extended'}
{%TEMPLATE DynArrayInsert ''  'Currency'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayInsert 'A' 'AnsiString'}
{%TEMPLATE DynArrayInsert 'B' 'RawByteString'}
{$ENDIF}
{%TEMPLATE DynArrayInsert 'W' 'WideString'}
{%TEMPLATE DynArrayInsert 'U' 'UnicodeString'}
{%TEMPLATE DynArrayInsert ''  'String'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayInsert ''  'Pointer'}
{%TEMPLATE DynArrayInsert ''  'Object'}
{$ENDIF}
{%TEMPLATE DynArrayInsert ''  'Interface'}

{%DEFINE DynArrayPosNext}
function  DynArrayPosNext%1%(const Find: %3%; const V: %2%Array; const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer; overload;{%ENDDEF}
{%TEMPLATE DynArrayPosNext ''  'Byte'          'Byte'}
{%TEMPLATE DynArrayPosNext ''  'Word'          'Word'}
{%TEMPLATE DynArrayPosNext ''  'Word32'        'Word32'}
{%TEMPLATE DynArrayPosNext ''  'LongWord'      'LongWord'}
{%TEMPLATE DynArrayPosNext ''  'NativeUInt'    'NativeUInt'}
{%TEMPLATE DynArrayPosNext ''  'ShortInt'      'ShortInt'}
{%TEMPLATE DynArrayPosNext ''  'SmallInt'      'SmallInt'}
{%TEMPLATE DynArrayPosNext ''  'LongInt'       'LongInt'}
{%TEMPLATE DynArrayPosNext ''  'Int32'         'Int32'}
{%TEMPLATE DynArrayPosNext ''  'Int64'         'Int64'}
{%TEMPLATE DynArrayPosNext ''  'NativeInt'     'NativeInt'}
{%TEMPLATE DynArrayPosNext ''  'Single'        'Single'}
{%TEMPLATE DynArrayPosNext ''  'Double'        'Double'}
{%TEMPLATE DynArrayPosNext ''  'Extended'      'Extended'}
{%TEMPLATE DynArrayPosNext ''  'Boolean'       'Boolean'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayPosNext 'A' 'AnsiString'    'AnsiString'}
{%TEMPLATE DynArrayPosNext 'B' 'RawByteString' 'RawByteString'}
{$ENDIF}
{%TEMPLATE DynArrayPosNext 'W' 'WideString'    'WideString'}
{%TEMPLATE DynArrayPosNext 'U' 'UnicodeString' 'UnicodeString'}
{%TEMPLATE DynArrayPosNext ''  'String'        'String'}
{$IFNDEF ManagedCode}
function  DynArrayPosNext(const Find: Pointer; const V: PointerArray;
          const PrevPos: Integer = -1): Integer; overload;
{$ENDIF}
function  DynArrayPosNext(const Find: TObject; const V: ObjectArray;
          const PrevPos: Integer = -1): Integer; overload;
function  DynArrayPosNext(const ClassType: TClass; const V: ObjectArray;
          const PrevPos: Integer = -1): Integer; overload;
function  DynArrayPosNext(const ClassName: String; const V: ObjectArray;
          const PrevPos: Integer = -1): Integer; overload;

{%DEFINE DynArrayCount}
function  DynArrayCount%1%(const Find: %3%; const V: %2%Array;
          const IsSortedAscending: Boolean = False): Integer; overload;{%ENDDEF}
{%TEMPLATE DynArrayCount ''  'Byte'          'Byte'}
{%TEMPLATE DynArrayCount ''  'Word'          'Word'}
{%TEMPLATE DynArrayCount ''  'LongWord'      'LongWord'}
{%TEMPLATE DynArrayCount ''  'ShortInt'      'ShortInt'}
{%TEMPLATE DynArrayCount ''  'SmallInt'      'SmallInt'}
{%TEMPLATE DynArrayCount ''  'LongInt'       'LongInt'}
{%TEMPLATE DynArrayCount ''  'Int64'         'Int64'}
{%TEMPLATE DynArrayCount ''  'Single'        'Single'}
{%TEMPLATE DynArrayCount ''  'Double'        'Double'}
{%TEMPLATE DynArrayCount ''  'Extended'      'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayCount 'A' 'AnsiString'    'AnsiString'}
{%TEMPLATE DynArrayCount 'B' 'RawByteString' 'RawByteString'}
{$ENDIF}
{%TEMPLATE DynArrayCount 'W' 'WideString'    'WideString'}
{%TEMPLATE DynArrayCount 'U' 'UnicodeString' 'UnicodeString'}
{%TEMPLATE DynArrayCount ''  'String'        'String'}
{%TEMPLATE DynArrayCount ''  'Boolean'       'Boolean'}

{%DEFINE DynArrayRemoveAll}
procedure DynArrayRemoveAll%1%(const Find: %3%; var V: %2%Array;
          const IsSortedAscending: Boolean = False); overload; {%ENDDEF}
{%TEMPLATE DynArrayRemoveAll ''  'Byte'          'Byte'}
{%TEMPLATE DynArrayRemoveAll ''  'Word'          'Word'}
{%TEMPLATE DynArrayRemoveAll ''  'LongWord'      'LongWord'}
{%TEMPLATE DynArrayRemoveAll ''  'ShortInt'      'ShortInt'}
{%TEMPLATE DynArrayRemoveAll ''  'SmallInt'      'SmallInt'}
{%TEMPLATE DynArrayRemoveAll ''  'LongInt'       'LongInt'}
{%TEMPLATE DynArrayRemoveAll ''  'Int64'         'Int64'}
{%TEMPLATE DynArrayRemoveAll ''  'Single'        'Single'}
{%TEMPLATE DynArrayRemoveAll ''  'Double'        'Double'}
{%TEMPLATE DynArrayRemoveAll ''  'Extended'      'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayRemoveAll 'A' 'AnsiString'    'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayRemoveAll 'W' 'WideString'    'WideString'}
{%TEMPLATE DynArrayRemoveAll 'U' 'UnicodeString' 'UnicodeString'}
{%TEMPLATE DynArrayRemoveAll ''  'String'        'String'}

{%DEFINE DynArrayIntersection}
function  DynArrayIntersection%1%(const V1, V2: %2%Array;
          const IsSortedAscending: Boolean = False): %2%Array; overload;{%ENDDEF}
{%TEMPLATE DynArrayIntersection ''  'Byte'}
{%TEMPLATE DynArrayIntersection ''  'Word'}
{%TEMPLATE DynArrayIntersection ''  'LongWord'}
{%TEMPLATE DynArrayIntersection ''  'ShortInt'}
{%TEMPLATE DynArrayIntersection ''  'SmallInt'}
{%TEMPLATE DynArrayIntersection ''  'LongInt'}
{%TEMPLATE DynArrayIntersection ''  'Int64'}
{%TEMPLATE DynArrayIntersection ''  'Single'}
{%TEMPLATE DynArrayIntersection ''  'Double'}
{%TEMPLATE DynArrayIntersection ''  'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayIntersection 'A' 'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayIntersection 'W' 'WideString'}
{%TEMPLATE DynArrayIntersection 'U' 'UnicodeString'}
{%TEMPLATE DynArrayIntersection ''  'String'}

{%DEFINE DynArrayDifference}
function  DynArrayDifference%1%(const V1, V2: %2%Array;
          const IsSortedAscending: Boolean = False): %2%Array; overload;{%ENDDEF}
{%TEMPLATE DynArrayDifference ''  'Byte'}
{%TEMPLATE DynArrayDifference ''  'Word'}
{%TEMPLATE DynArrayDifference ''  'LongWord'}
{%TEMPLATE DynArrayDifference ''  'ShortInt'}
{%TEMPLATE DynArrayDifference ''  'SmallInt'}
{%TEMPLATE DynArrayDifference ''  'LongInt'}
{%TEMPLATE DynArrayDifference ''  'Int64'}
{%TEMPLATE DynArrayDifference ''  'Single'}
{%TEMPLATE DynArrayDifference ''  'Double'}
{%TEMPLATE DynArrayDifference ''  'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayDifference 'A' 'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayDifference 'W' 'WideString'}
{%TEMPLATE DynArrayDifference 'U' 'UnicodeString'}
{%TEMPLATE DynArrayDifference ''  'String'}

{%DEFINE DynArrayReverse}
procedure DynArrayReverse%1%(var V: %2%Array); overload;{%ENDDEF}
{%TEMPLATE DynArrayReverse ''  'Byte'}
{%TEMPLATE DynArrayReverse ''  'Word'}
{%TEMPLATE DynArrayReverse ''  'LongWord'}
{%TEMPLATE DynArrayReverse ''  'ShortInt'}
{%TEMPLATE DynArrayReverse ''  'SmallInt'}
{%TEMPLATE DynArrayReverse ''  'LongInt'}
{%TEMPLATE DynArrayReverse ''  'Int64'}
{%TEMPLATE DynArrayReverse ''  'Single'}
{%TEMPLATE DynArrayReverse ''  'Double'}
{%TEMPLATE DynArrayReverse ''  'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayReverse 'A' 'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayReverse 'W' 'WideString'}
{%TEMPLATE DynArrayReverse 'U' 'UnicodeString'}
{%TEMPLATE DynArrayReverse ''  'String'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayReverse ''  'Pointer'}
{$ENDIF}
{%TEMPLATE DynArrayReverse ''  'Object'}

{%DEFINE OpenArrayAsDynArray}
function  As%1%Array(const V: array of %2%): %1%Array; overload;{%ENDDEF}
{%TEMPLATE OpenArrayAsDynArray 'Boolean'       'Boolean'}
{%TEMPLATE OpenArrayAsDynArray 'Byte'          'Byte'}
{%TEMPLATE OpenArrayAsDynArray 'Word'          'Word'}
{%TEMPLATE OpenArrayAsDynArray 'Word32'        'Word32'}
{%TEMPLATE OpenArrayAsDynArray 'LongWord'      'LongWord'}
{%TEMPLATE OpenArrayAsDynArray 'Cardinal'      'Cardinal'}
{%TEMPLATE OpenArrayAsDynArray 'NativeUInt'    'NativeUInt'}
{%TEMPLATE OpenArrayAsDynArray 'ShortInt'      'ShortInt'}
{%TEMPLATE OpenArrayAsDynArray 'SmallInt'      'SmallInt'}
{%TEMPLATE OpenArrayAsDynArray 'LongInt'       'LongInt'}
{%TEMPLATE OpenArrayAsDynArray 'Integer'       'Integer'}
{%TEMPLATE OpenArrayAsDynArray 'Int32'         'Int32'}
{%TEMPLATE OpenArrayAsDynArray 'Int64'         'Int64'}
{%TEMPLATE OpenArrayAsDynArray 'NativeInt'     'NativeInt'}
{%TEMPLATE OpenArrayAsDynArray 'Single'        'Single'}
{%TEMPLATE OpenArrayAsDynArray 'Double'        'Double'}
{%TEMPLATE OpenArrayAsDynArray 'Extended'      'Extended'}
{%TEMPLATE OpenArrayAsDynArray 'Currency'      'Currency'}
{$IFDEF SupportAnsiString}
{%TEMPLATE OpenArrayAsDynArray 'AnsiString'    'AnsiString'}
{%TEMPLATE OpenArrayAsDynArray 'RawByteString' 'RawByteString'}
{$ENDIF}
{%TEMPLATE OpenArrayAsDynArray 'WideString'    'WideString'}
{%TEMPLATE OpenArrayAsDynArray 'UnicodeString' 'UnicodeString'}
{%TEMPLATE OpenArrayAsDynArray 'String'        'String'}
{$IFNDEF ManagedCode}
{%TEMPLATE OpenArrayAsDynArray 'Pointer'    'Pointer'}
{$ENDIF}
{%TEMPLATE OpenArrayAsDynArray 'ByteCharSet'    'ByteCharSet'}
function  AsObjectArray(const V: array of TObject): ObjectArray; overload;
function  AsInterfaceArray(const V: array of IInterface): InterfaceArray; overload;

{%DEFINE DynArrayRange}
function  DynArrayRange%1%(const First: %1%; const Count: Integer;
          const Increment: %1% = 1): %1%Array;{%ENDDEF}
{%TEMPLATE DynArrayRange 'Byte'}
{%TEMPLATE DynArrayRange 'Word'}
{%TEMPLATE DynArrayRange 'LongWord'}
{%TEMPLATE DynArrayRange 'Cardinal'}
{%TEMPLATE DynArrayRange 'ShortInt'}
{%TEMPLATE DynArrayRange 'SmallInt'}
{%TEMPLATE DynArrayRange 'LongInt'}
{%TEMPLATE DynArrayRange 'Integer'}
{%TEMPLATE DynArrayRange 'Int64'}
{%TEMPLATE DynArrayRange 'Single'}
{%TEMPLATE DynArrayRange 'Double'}
{%TEMPLATE DynArrayRange 'Extended'}

{%DEFINE DynArrayDup}
function  DynArrayDup%1%(const V: %2%; const Count: Integer): %1%Array;{%ENDDEF}
{%TEMPLATE DynArrayDup 'Byte'          'Byte'       }
{%TEMPLATE DynArrayDup 'Word'          'Word'       }
{%TEMPLATE DynArrayDup 'LongWord'      'LongWord'   }
{%TEMPLATE DynArrayDup 'Cardinal'      'Cardinal'   }
{%TEMPLATE DynArrayDup 'NativeUInt'    'NativeUInt' }
{%TEMPLATE DynArrayDup 'ShortInt'      'ShortInt'   }
{%TEMPLATE DynArrayDup 'SmallInt'      'SmallInt'   }
{%TEMPLATE DynArrayDup 'LongInt'       'LongInt'    }
{%TEMPLATE DynArrayDup 'Integer'       'Integer'    }
{%TEMPLATE DynArrayDup 'Int64'         'Int64'      }
{%TEMPLATE DynArrayDup 'NativeInt'     'NativeInt'  }
{%TEMPLATE DynArrayDup 'Single'        'Single'     }
{%TEMPLATE DynArrayDup 'Double'        'Double'     }
{%TEMPLATE DynArrayDup 'Extended'      'Extended'   }
{%TEMPLATE DynArrayDup 'Currency'      'Currency'   }
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayDup 'AnsiString'    'AnsiString' }
{$ENDIF}
{%TEMPLATE DynArrayDup 'WideString'    'WideString' }
{%TEMPLATE DynArrayDup 'UnicodeString' 'UnicodeString' }
{%TEMPLATE DynArrayDup 'String'        'String'     }
{%TEMPLATE DynArrayDup 'ByteCharSet'   'ByteCharSet'    }
{%TEMPLATE DynArrayDup 'Object'        'TObject'    }

{%DEFINE SetLengthAndZero}
procedure SetLengthAndZero(var V: %1%Array; const NewLength: Integer); overload;{%ENDDEF}
{%TEMPLATE SetLengthAndZero 'Byte'       }
{%TEMPLATE SetLengthAndZero 'Word'       }
{%TEMPLATE SetLengthAndZero 'Word32'     }
{%TEMPLATE SetLengthAndZero 'LongWord'   }
{%TEMPLATE SetLengthAndZero 'NativeUInt' }
{%TEMPLATE SetLengthAndZero 'ShortInt'   }
{%TEMPLATE SetLengthAndZero 'SmallInt'   }
{%TEMPLATE SetLengthAndZero 'LongInt'    }
{%TEMPLATE SetLengthAndZero 'Int32'      }
{%TEMPLATE SetLengthAndZero 'Int64'      }
{%TEMPLATE SetLengthAndZero 'NativeInt'  }
{%TEMPLATE SetLengthAndZero 'Single'     }
{%TEMPLATE SetLengthAndZero 'Double'     }
{%TEMPLATE SetLengthAndZero 'Extended'   }
{%TEMPLATE SetLengthAndZero 'Currency'   }
{%TEMPLATE SetLengthAndZero 'ByteCharSet'}
{%TEMPLATE SetLengthAndZero 'Boolean'    }
{$IFNDEF ManagedCode}
{%TEMPLATE SetLengthAndZero 'Pointer'    }
{$ENDIF}
procedure SetLengthAndZero(var V: ObjectArray; const NewLength: Integer;
          const FreeObjects: Boolean = False); overload;

{%DEFINE DynArrayIsEqual}
function  DynArrayIsEqual%1%(const V1, V2: %2%Array): Boolean; overload;{%ENDDEF}
{%TEMPLATE DynArrayIsEqual ''  'Byte'}
{%TEMPLATE DynArrayIsEqual ''  'Word'}
{%TEMPLATE DynArrayIsEqual ''  'LongWord'}
{%TEMPLATE DynArrayIsEqual ''  'ShortInt'}
{%TEMPLATE DynArrayIsEqual ''  'SmallInt'}
{%TEMPLATE DynArrayIsEqual ''  'LongInt'}
{%TEMPLATE DynArrayIsEqual ''  'Int64'}
{%TEMPLATE DynArrayIsEqual ''  'Single'}
{%TEMPLATE DynArrayIsEqual ''  'Double'}
{%TEMPLATE DynArrayIsEqual ''  'Extended'}
{%TEMPLATE DynArrayIsEqual ''  'Currency'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayIsEqual 'A' 'AnsiString'}
{%TEMPLATE DynArrayIsEqual 'B' 'RawByteString'}
{$ENDIF}
{%TEMPLATE DynArrayIsEqual 'W' 'WideString'}
{%TEMPLATE DynArrayIsEqual 'U' 'UnicodeString'}
{%TEMPLATE DynArrayIsEqual ''  'String'}
{%TEMPLATE DynArrayIsEqual ''  'ByteCharSet'}

{%DEFINE DynArrayToDynArray}
function  %1%ArrayTo%2%Array(const V: %1%Array): %2%Array;{%ENDDEF}
{%TEMPLATE DynArrayToDynArray 'Byte'     'LongInt'}
{%TEMPLATE DynArrayToDynArray 'Word'     'LongInt'}
{%TEMPLATE DynArrayToDynArray 'ShortInt' 'LongInt'}
{%TEMPLATE DynArrayToDynArray 'SmallInt' 'LongInt'}
{%TEMPLATE DynArrayToDynArray 'LongInt'  'Int64'}
{%TEMPLATE DynArrayToDynArray 'LongInt'  'Single'}
{%TEMPLATE DynArrayToDynArray 'LongInt'  'Double'}
{%TEMPLATE DynArrayToDynArray 'LongInt'  'Extended'}
{%TEMPLATE DynArrayToDynArray 'Single'   'Double'}
{%TEMPLATE DynArrayToDynArray 'Single'   'Extended'}
{%TEMPLATE DynArrayToDynArray 'Single'   'Currency'}
{%TEMPLATE DynArrayToDynArray 'Single'   'LongInt'}
{%TEMPLATE DynArrayToDynArray 'Single'   'Int64'}
{%TEMPLATE DynArrayToDynArray 'Double'   'Extended'}
{%TEMPLATE DynArrayToDynArray 'Double'   'Currency'}
{%TEMPLATE DynArrayToDynArray 'Double'   'LongInt'}
{%TEMPLATE DynArrayToDynArray 'Double'   'Int64'}
{%TEMPLATE DynArrayToDynArray 'Extended' 'Currency'}
{%TEMPLATE DynArrayToDynArray 'Extended' 'LongInt'}
{%TEMPLATE DynArrayToDynArray 'Extended' 'Int64'}

{%DEFINE DynArrayFromIndexes}
function  %1%ArrayFromIndexes(const V: %1%Array;
          const Indexes: IntegerArray): %1%Array;{%ENDDEF}
{%TEMPLATE DynArrayFromIndexes 'Byte'}
{%TEMPLATE DynArrayFromIndexes 'Word'}
{%TEMPLATE DynArrayFromIndexes 'LongWord'}
{%TEMPLATE DynArrayFromIndexes 'Cardinal'}
{%TEMPLATE DynArrayFromIndexes 'ShortInt'}
{%TEMPLATE DynArrayFromIndexes 'SmallInt'}
{%TEMPLATE DynArrayFromIndexes 'LongInt'}
{%TEMPLATE DynArrayFromIndexes 'Integer'}
{%TEMPLATE DynArrayFromIndexes 'Int64'}
{%TEMPLATE DynArrayFromIndexes 'Single'}
{%TEMPLATE DynArrayFromIndexes 'Double'}
{%TEMPLATE DynArrayFromIndexes 'Extended'}
{%TEMPLATE DynArrayFromIndexes 'String'}

{%DEFINE DynArraySort}
procedure DynArraySort%1%(const V: %2%Array); overload;{%ENDDEF}
{%TEMPLATE DynArraySort ''  'Byte'}
{%TEMPLATE DynArraySort ''  'Word'}
{%TEMPLATE DynArraySort ''  'LongWord'}
{%TEMPLATE DynArraySort ''  'NativeUInt'}
{%TEMPLATE DynArraySort ''  'ShortInt'}
{%TEMPLATE DynArraySort ''  'SmallInt'}
{%TEMPLATE DynArraySort ''  'LongInt'}
{%TEMPLATE DynArraySort ''  'Int64'}
{%TEMPLATE DynArraySort ''  'NativeInt'}
{%TEMPLATE DynArraySort ''  'Single'}
{%TEMPLATE DynArraySort ''  'Double'}
{%TEMPLATE DynArraySort ''  'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArraySort 'A' 'AnsiString'}
{%TEMPLATE DynArraySort 'B' 'RawByteString'}
{$ENDIF}
{%TEMPLATE DynArraySort 'W' 'WideString'}
{%TEMPLATE DynArraySort 'U' 'UnicodeString'}
{%TEMPLATE DynArraySort ''  'String'}

{%DEFINE DynArrayPairSort}
procedure DynArraySort(const Key: %1%Array; const Data: %2%Array); overload;{%ENDDEF}
{%TEMPLATE DynArrayPairSort 'Integer' 'Integer'}
{%TEMPLATE DynArrayPairSort 'Integer' 'Int64'}
{%TEMPLATE DynArrayPairSort 'Integer' 'AnsiString'}
{%TEMPLATE DynArrayPairSort 'Integer' 'Extended'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayPairSort 'Integer' 'Pointer'}
{$ENDIF}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayPairSort 'AnsiString' 'Integer'}
{%TEMPLATE DynArrayPairSort 'AnsiString' 'Int64'}
{%TEMPLATE DynArrayPairSort 'AnsiString' 'AnsiString'}
{%TEMPLATE DynArrayPairSort 'AnsiString' 'Extended'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayPairSort 'AnsiString' 'Pointer'}
{$ENDIF}
{$ENDIF}
{%TEMPLATE DynArrayPairSort 'Extended' 'Integer'}
{%TEMPLATE DynArrayPairSort 'Extended' 'Int64'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayPairSort 'Extended' 'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayPairSort 'Extended' 'Extended'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayPairSort 'Extended' 'Pointer'}
{$ENDIF}



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF DYNARRAYS_TEST}
procedure Test;
{$ENDIF}



implementation



{                                                                              }
{ DynArrayAppend                                                               }
{                                                                              }
{%DEFINE DynArrayAppendImpl}
function DynArrayAppend%1%(var V: %2%Array; const R: %3%): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;
{%ENDDEF}
{%TEMPLATE DynArrayAppendImpl ''  'Byte'          'Byte'}
{%TEMPLATE DynArrayAppendImpl ''  'Word'          'Word'}
{%TEMPLATE DynArrayAppendImpl ''  'Word32'        'Word32'}
{%TEMPLATE DynArrayAppendImpl ''  'LongWord'      'LongWord'}
{%TEMPLATE DynArrayAppendImpl ''  'NativeUInt'    'NativeUInt'}
{%TEMPLATE DynArrayAppendImpl ''  'ShortInt'      'ShortInt'}
{%TEMPLATE DynArrayAppendImpl ''  'SmallInt'      'SmallInt'}
{%TEMPLATE DynArrayAppendImpl ''  'Int32'         'Int32'}
{%TEMPLATE DynArrayAppendImpl ''  'LongInt'       'LongInt'}
{%TEMPLATE DynArrayAppendImpl ''  'Int64'         'Int64'}
{%TEMPLATE DynArrayAppendImpl ''  'NativeInt'     'NativeInt'}
{%TEMPLATE DynArrayAppendImpl ''  'Single'        'Single'}
{%TEMPLATE DynArrayAppendImpl ''  'Double'        'Double'}
{%TEMPLATE DynArrayAppendImpl ''  'Extended'      'Extended'}
{%TEMPLATE DynArrayAppendImpl ''  'Currency'      'Currency'}
{%TEMPLATE DynArrayAppendImpl ''  'Boolean'       'Boolean'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayAppendImpl 'A' 'AnsiString'    'AnsiString'}
{%TEMPLATE DynArrayAppendImpl 'B' 'RawByteString' 'RawByteString'}
{$ENDIF}
{%TEMPLATE DynArrayAppendImpl 'W' 'WideString'    'WideString'}
{%TEMPLATE DynArrayAppendImpl 'U' 'UnicodeString' 'UnicodeString'}
{%TEMPLATE DynArrayAppendImpl ''  'String'        'String'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayAppendImpl ''  'Pointer'    'Pointer'}
{$ENDIF}
{%TEMPLATE DynArrayAppendImpl ''  'Object'     'TObject'}
{%TEMPLATE DynArrayAppendImpl ''  'Interface'  'IInterface'}
{%TEMPLATE DynArrayAppendImpl ''  'ByteSet'    'ByteSet'}
{%TEMPLATE DynArrayAppendImpl ''  'ByteCharSet'    'ByteCharSet'}


{%DEFINE DynArrayAppendArrayImpl}
{$IFDEF ManagedCode}
function DynArrayAppend%2%Array(var V: %2%Array; const R: array of %1%): Integer;
var I, L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 0 to L - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ELSE}
function DynArrayAppend%2%Array(var V: %2%Array; const R: array of %1%): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      Move(R[0], V[Result], Sizeof(%1%) * L);
    end;
end;
{$ENDIF}
{%ENDDEF}
{%TEMPLATE DynArrayAppendArrayImpl 'Byte'       'Byte'}
{%TEMPLATE DynArrayAppendArrayImpl 'Word'       'Word'}
{%TEMPLATE DynArrayAppendArrayImpl 'Word32'     'Word32'}
{%TEMPLATE DynArrayAppendArrayImpl 'Cardinal'   'Cardinal'}
{%TEMPLATE DynArrayAppendArrayImpl 'NativeUInt' 'NativeUInt'}
{%TEMPLATE DynArrayAppendArrayImpl 'ShortInt'   'ShortInt'}
{%TEMPLATE DynArrayAppendArrayImpl 'SmallInt'   'SmallInt'}
{%TEMPLATE DynArrayAppendArrayImpl 'Int32'      'Int32'}
{%TEMPLATE DynArrayAppendArrayImpl 'LongInt'    'Integer'}
{%TEMPLATE DynArrayAppendArrayImpl 'Int64'      'Int64'}
{%TEMPLATE DynArrayAppendArrayImpl 'NativeInt'  'NativeInt'}
{%TEMPLATE DynArrayAppendArrayImpl 'Single'     'Single'}
{%TEMPLATE DynArrayAppendArrayImpl 'Double'     'Double'}
{%TEMPLATE DynArrayAppendArrayImpl 'Extended'   'Extended'}
{$IFNDEF CLR}
{%TEMPLATE DynArrayAppendArrayImpl 'Currency'   'Currency'}
{%TEMPLATE DynArrayAppendArrayImpl 'Pointer'    'Pointer'}
{%TEMPLATE DynArrayAppendArrayImpl 'ByteCharSet' 'ByteCharSet'}
{%TEMPLATE DynArrayAppendArrayImpl 'ByteSet'    'ByteSet'}
{$ENDIF}

function DynArrayAppendObjectArray(var V: ObjectArray; const R: ObjectArray): Integer;
var I, LR : Integer;
begin
  Result := Length(V);
  LR := Length(R);
  if LR > 0 then
    begin
      SetLength(V, Result + LR);
      for I := 0 to LR - 1 do
        V[Result + I] := R[I];
    end;
end;

{$IFDEF SupportAnsiString}
function DynArrayAppendAnsiStringArray(var V: AnsiStringArray; const R: array of AnsiString): Integer;
var I, LR : Integer;
begin
  Result := Length(V);
  LR := Length(R);
  if LR > 0 then
    begin
      SetLength(V, Result + LR);
      for I := 0 to LR - 1 do
        V[Result + I] := R[I];
    end;
end;

function DynArrayAppendRawByteStringArray(var V: RawByteStringArray; const R: array of RawByteString): Integer;
var I, LR : Integer;
begin
  Result := Length(V);
  LR := Length(R);
  if LR > 0 then
    begin
      SetLength(V, Result + LR);
      for I := 0 to LR - 1 do
        V[Result + I] := R[I];
    end;
end;
{$ENDIF}

function DynArrayAppendWideStringArray(var V: WideStringArray; const R: array of WideString): Integer;
var I, LR : Integer;
begin
  Result := Length(V);
  LR := Length(R);
  if LR > 0 then
    begin
      SetLength(V, Result + LR);
      for I := 0 to LR - 1 do
        V[Result + I] := R[I];
    end;
end;

function DynArrayAppendUnicodeStringArray(var V: UnicodeStringArray; const R: array of UnicodeString): Integer;
var I, LR : Integer;
begin
  Result := Length(V);
  LR := Length(R);
  if LR > 0 then
    begin
      SetLength(V, Result + LR);
      for I := 0 to LR - 1 do
        V[Result + I] := R[I];
    end;
end;

function DynArrayAppendStringArray(var V: StringArray; const R: array of String): Integer;
var I, LR : Integer;
begin
  Result := Length(V);
  LR := Length(R);
  if LR > 0 then
    begin
      SetLength(V, Result + LR);
      for I := 0 to LR - 1 do
        V[Result + I] := R[I];
    end;
end;



{                                                                              }
{ DynArrayRemove                                                               }
{                                                                              }
{%DEFINE DynArrayRemoveMemImpl}
function DynArrayRemove(var V: %1%Array; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M{$IFDEF CLR}, F{$ENDIF}: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxInt(Idx, 0);
  J := MinInt(Count, L - I);
  M := L - J - I;
  {$IFDEF CLR}
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  {$ELSE}
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(%2%));
  {$ENDIF}
  SetLength(V, L - J);
  Result := J;
end;
{%ENDDEF}
{%TEMPLATE DynArrayRemoveMemImpl 'Byte'       'Byte'}
{%TEMPLATE DynArrayRemoveMemImpl 'Word'       'Word'}
{%TEMPLATE DynArrayRemoveMemImpl 'Word32'     'Word32'}
{%TEMPLATE DynArrayRemoveMemImpl 'LongWord'   'LongWord'}
{%TEMPLATE DynArrayRemoveMemImpl 'NativeUInt' 'NativeUInt'}
{%TEMPLATE DynArrayRemoveMemImpl 'ShortInt'   'ShortInt'}
{%TEMPLATE DynArrayRemoveMemImpl 'SmallInt'   'SmallInt'}
{%TEMPLATE DynArrayRemoveMemImpl 'LongInt'    'LongInt'}
{%TEMPLATE DynArrayRemoveMemImpl 'Int32'      'Int32'}
{%TEMPLATE DynArrayRemoveMemImpl 'Int64'      'Int64'}
{%TEMPLATE DynArrayRemoveMemImpl 'NativeInt'  'NativeInt'}
{%TEMPLATE DynArrayRemoveMemImpl 'Single'     'Single'}
{%TEMPLATE DynArrayRemoveMemImpl 'Double'     'Double'}
{%TEMPLATE DynArrayRemoveMemImpl 'Extended'   'Extended'}
{$IFNDEF CLR}
{%TEMPLATE DynArrayRemoveMemImpl 'Currency'   'Currency'}
{%TEMPLATE DynArrayRemoveMemImpl 'Pointer'    'Pointer'}
{$ENDIF}

function DynArrayRemove(var V: ObjectArray; const Idx: Integer; const Count: Integer;
    const FreeObjects: Boolean): Integer;
var I, J, K, L, M, F : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxInt(Idx, 0);
  J := MinInt(Count, L - I);
  if FreeObjects then
    for K := I to I + J - 1 do
      FreeAndNil(V[K]);
  M := L - J - I;
  for F := I to I + M - 1 do
    V[F] := V[F + J];
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemoveA(var V: AnsiStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxInt(Idx, 0);
  J := MinInt(Count, L - I);
  for K := I to L - J - 1 do
    V[K] := V[K + J];
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemoveB(var V: RawByteStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxInt(Idx, 0);
  J := MinInt(Count, L - I);
  for K := I to L - J - 1 do
    V[K] := V[K + J];
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemoveW(var V: WideStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxInt(Idx, 0);
  J := MinInt(Count, L - I);
  for K := I to L - J - 1 do
    V[K] := V[K + J];
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemoveU(var V: UnicodeStringArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxInt(Idx, 0);
  J := MinInt(Count, L - I);
  for K := I to L - J - 1 do
    V[K] := V[K + J];
  SetLength(V, L - J);
  Result := J;
end;

function DynArrayRemove(var V: StringArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxInt(Idx, 0);
  J := MinInt(Count, L - I);
  for K := I to L - J - 1 do
    V[K] := V[K + J];
  SetLength(V, L - J);
  Result := J;
end;

{$IFDEF ManagedCode}
function DynArrayRemove(var V: InterfaceArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L, M, F : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxInt(Idx, 0);
  J := MinInt(Count, L - I);
  for K := I to I + J - 1 do
    V[K] := nil;
  M := L - J - I;
  for F := 0 to M - 1 do
    V[I + F] := V[I + J + F];
  for F := 0 to J - 1 do
    V[L - J + F] := nil;
  SetLength(V, L - J);
  Result := J;
end;
{$ELSE}
function DynArrayRemove(var V: InterfaceArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, K, L, M : Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxInt(Idx, 0);
  J := MinInt(Count, L - I);
  for K := I to I + J - 1 do
    V[K] := nil;
  M := L - J - I;
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(IInterface));
  FillChar(V[L - J], J * SizeOf(IInterface), #0);
  SetLength(V, L - J);
  Result := J;
end;
{$ENDIF}



{                                                                              }
{ DynArrayRemoveDuplicates                                                     }
{                                                                              }
{%DEFINE DynArrayRemoveDuplicatesImpl}
procedure DynArrayRemoveDuplicates%1%(var V: %2%Array; const IsSorted: Boolean);
var I, C, J, L : Integer;
    F          : %3%;
begin
  L := Length(V);
  if L = 0 then
    exit;

  if IsSorted then
    begin
      J := 0;
      repeat
        F := V[J];
        I := J + 1;
        while (I < L) and (V[I] = F) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            DynArrayRemove%1%(V, J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      repeat
        repeat
          I := DynArrayPosNext%1%(V[J], V, J);
          if I >= 0 then
            DynArrayRemove%1%(V, I, 1);
        until I < 0;
        Inc(J);
      until J >= Length(V);
    end;
end;
{%ENDDEF}
{%TEMPLATE DynArrayRemoveDuplicatesImpl ''  'Byte'          'Byte'      }
{%TEMPLATE DynArrayRemoveDuplicatesImpl ''  'Word'          'Word'      }
{%TEMPLATE DynArrayRemoveDuplicatesImpl ''  'LongWord'      'LongWord'  }
{%TEMPLATE DynArrayRemoveDuplicatesImpl ''  'ShortInt'      'ShortInt'  }
{%TEMPLATE DynArrayRemoveDuplicatesImpl ''  'SmallInt'      'SmallInt'  }
{%TEMPLATE DynArrayRemoveDuplicatesImpl ''  'LongInt'       'LongInt'   }
{%TEMPLATE DynArrayRemoveDuplicatesImpl ''  'Int64'         'Int64'     }
{%TEMPLATE DynArrayRemoveDuplicatesImpl ''  'Single'        'Single'    }
{%TEMPLATE DynArrayRemoveDuplicatesImpl ''  'Double'        'Double'    }
{%TEMPLATE DynArrayRemoveDuplicatesImpl ''  'Extended'      'Extended'  }
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayRemoveDuplicatesImpl 'A' 'AnsiString'    'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayRemoveDuplicatesImpl 'W' 'WideString'    'WideString'}
{%TEMPLATE DynArrayRemoveDuplicatesImpl 'U' 'UnicodeString' 'UnicodeString'}
{%TEMPLATE DynArrayRemoveDuplicatesImpl ''  'String'        'String'    }
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayRemoveDuplicatesImpl ''  'Pointer'       'Pointer'   }
{$ENDIF}


{%DEFINE DynArrayTrimLeftImpl}
procedure DynArrayTrimLeft%1%(var S: %2%Array; const TrimList: array of %3%); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := 0;
  R := True;
  while R and (I < Length(S)) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Inc(I);
            break;
          end;
    end;
  if I > 0 then
    DynArrayRemove%1%(S, 0, I - 1);
end;
{%ENDDEF}
{%TEMPLATE DynArrayTrimLeftImpl ''  'Byte'          'Byte'}
{%TEMPLATE DynArrayTrimLeftImpl ''  'Word'          'Word'}
{%TEMPLATE DynArrayTrimLeftImpl ''  'LongWord'      'LongWord'}
{%TEMPLATE DynArrayTrimLeftImpl ''  'ShortInt'      'ShortInt'}
{%TEMPLATE DynArrayTrimLeftImpl ''  'SmallInt'      'SmallInt'}
{%TEMPLATE DynArrayTrimLeftImpl ''  'LongInt'       'LongInt'}
{%TEMPLATE DynArrayTrimLeftImpl ''  'Int64'         'Int64'}
{%TEMPLATE DynArrayTrimLeftImpl ''  'Single'        'Single'}
{%TEMPLATE DynArrayTrimLeftImpl ''  'Double'        'Double'}
{%TEMPLATE DynArrayTrimLeftImpl ''  'Extended'      'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayTrimLeftImpl 'A' 'AnsiString'    'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayTrimLeftImpl 'W' 'WideString'    'WideString'}
{%TEMPLATE DynArrayTrimLeftImpl 'U' 'UnicodeString' 'UnicodeString'}
{%TEMPLATE DynArrayTrimLeftImpl ''  'String'        'String'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayTrimLeftImpl ''  'Pointer'       'Pointer'}
{$ENDIF}

{%DEFINE DynArrayTrimRightImpl}
procedure DynArrayTrimRight%1%(var S: %2%Array; const TrimList: array of %3%); overload;
var I, J : Integer;
    R    : Boolean;
begin
  I := Length(S) - 1;
  R := True;
  while R and (I >= 0) do
    begin
      R := False;
      for J := 0 to High(TrimList) do
        if S[I] = TrimList[J] then
          begin
            R := True;
            Dec(I);
            break;
          end;
    end;
  if I < Length(S) - 1 then
    SetLength(S, I + 1);
end;
{%ENDDEF}
{%TEMPLATE DynArrayTrimRightImpl ''  'Byte'          'Byte'}
{%TEMPLATE DynArrayTrimRightImpl ''  'Word'          'Word'}
{%TEMPLATE DynArrayTrimRightImpl ''  'LongWord'      'LongWord'}
{%TEMPLATE DynArrayTrimRightImpl ''  'ShortInt'      'ShortInt'}
{%TEMPLATE DynArrayTrimRightImpl ''  'SmallInt'      'SmallInt'}
{%TEMPLATE DynArrayTrimRightImpl ''  'LongInt'       'LongInt'}
{%TEMPLATE DynArrayTrimRightImpl ''  'Int64'         'Int64'}
{%TEMPLATE DynArrayTrimRightImpl ''  'Single'        'Single'}
{%TEMPLATE DynArrayTrimRightImpl ''  'Double'        'Double'}
{%TEMPLATE DynArrayTrimRightImpl ''  'Extended'      'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayTrimRightImpl 'A' 'AnsiString'    'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayTrimRightImpl 'W' 'WideString'    'WideString'}
{%TEMPLATE DynArrayTrimRightImpl 'U' 'UnicodeString' 'UnicodeString'}
{%TEMPLATE DynArrayTrimRightImpl ''  'String'        'String'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayTrimRightImpl ''  'Pointer'       'Pointer'}
{$ENDIF}

{                                                                              }
{ DynArrayInsert                                                               }
{                                                                              }
{%DEFINE DynArrayInsertImpl}
{$IFDEF ManagedCode}
function DynArrayInsert%1%(var V: %2%Array; const Idx: Integer; const Count: Integer): Integer;
var I, L, J : Integer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  for J := 0 to L - I - 1 do
    V[I + Count + J] := V[I + J];
  for J := 0 to Count - 1 do
    V[I + J] := %4%;
  Result := I;
end;
{$ELSE}
function DynArrayInsert%1%(var V: %2%Array; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(%3%));
  FillChar(P^, Count * Sizeof(%3%), #0);
  Result := I;
end;
{$ENDIF}
{%ENDDEF}
{%TEMPLATE DynArrayInsertImpl ''  'Byte'          'Byte'          '0'}
{%TEMPLATE DynArrayInsertImpl ''  'Word'          'Word'          '0'}
{%TEMPLATE DynArrayInsertImpl ''  'Word32'        'Word32'        '0'}
{%TEMPLATE DynArrayInsertImpl ''  'LongWord'      'LongWord'      '0'}
{%TEMPLATE DynArrayInsertImpl ''  'NativeUInt'    'NativeUInt'    '0'}
{%TEMPLATE DynArrayInsertImpl ''  'ShortInt'      'ShortInt'      '0'}
{%TEMPLATE DynArrayInsertImpl ''  'SmallInt'      'SmallInt'      '0'}
{%TEMPLATE DynArrayInsertImpl ''  'LongInt'       'LongInt'       '0'}
{%TEMPLATE DynArrayInsertImpl ''  'Int32'         'Int32'         '0'}
{%TEMPLATE DynArrayInsertImpl ''  'Int64'         'Int64'         '0'}
{%TEMPLATE DynArrayInsertImpl ''  'NativeInt'     'NativeInt'     '0'}
{%TEMPLATE DynArrayInsertImpl ''  'Single'        'Single'        '0.0'}
{%TEMPLATE DynArrayInsertImpl ''  'Double'        'Double'        '0.0'}
{%TEMPLATE DynArrayInsertImpl ''  'Extended'      'Extended'      '0.0'}
{%TEMPLATE DynArrayInsertImpl ''  'Currency'      'Currency'      '0.0'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayInsertImpl 'A' 'AnsiString'    'AnsiString'    ''''''}
{%TEMPLATE DynArrayInsertImpl 'B' 'RawByteString' 'RawByteString' ''''''}
{$ENDIF}
{%TEMPLATE DynArrayInsertImpl 'W' 'WideString'    'WideString'    ''''''}
{%TEMPLATE DynArrayInsertImpl 'U' 'UnicodeString' 'UnicodeString' ''''''}
{%TEMPLATE DynArrayInsertImpl ''  'String'        'String'        ''''''}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayInsertImpl ''  'Pointer'       'Pointer'       'nil'}
{%TEMPLATE DynArrayInsertImpl ''  'Object'        'Pointer'       'nil'}
{$ENDIF}
{%TEMPLATE DynArrayInsertImpl ''  'Interface'     'IInterface'    'nil'}

{%DEFINE ArrayValue}%1%{%ENDDEF}

{                                                                              }
{ DynArrayPosNext                                                              }
{   PosNext finds the next occurance of Find in V, -1 if it was not found.     }
{     Searches from Item[PrevPos + 1], ie PrevPos = -1 to find first           }
{     occurance.                                                               }
{                                                                              }
{%DEFINE DynArrayPosNextImpl}
function DynArrayPosNext%5%(const %4%: %2%; const V: %1%Array; const PrevPos: Integer;
    const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : %2%;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxInt(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          while L <= H do
            begin
              I := (L + H) div 2;
              D := {%TEMPLATE %3% 'V[I]'};
              if %4% = D then
                begin
                  while (I > 0) and ({%TEMPLATE %3% 'V[I - 1]'} = %4%) do
                    Dec(I);
                  Result := I;
                  exit;
                end else
              if D > %4% then
                H := I - 1
              else
                L := I + 1;
            end;
          Result := -1;
        end
      else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1
        else
          if {%TEMPLATE %3% 'V[PrevPos + 1]'} = %4% then
            Result := PrevPos + 1
          else
            Result := -1;
    end
  else
    begin // linear search
      for I := MaxInt(PrevPos + 1, 0) to Length(V) - 1 do
        if {%TEMPLATE %3% 'V[I]'} = %4% then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;
{%ENDDEF}
{%DEFINE DynArrayPosNextArrayImpl}{%TEMPLATE DynArrayPosNextImpl '%2%' '%3%' 'ArrayValue' 'Find' '%1%'}{%ENDDEF}
{%TEMPLATE DynArrayPosNextArrayImpl ''  'Byte'          'Byte'       }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'Word'          'Word'       }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'Word32'        'Word32'     }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'LongWord'      'LongWord'   }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'NativeUInt'    'NativeUInt' }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'ShortInt'      'ShortInt'   }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'SmallInt'      'SmallInt'   }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'LongInt'       'LongInt'    }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'Int32'         'Int32'      }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'Int64'         'Int64'      }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'NativeInt'     'NativeInt'  }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'Single'        'Single'     }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'Double'        'Double'     }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'Extended'      'Extended'   }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'Boolean'       'Boolean'    }
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayPosNextArrayImpl 'A' 'AnsiString'    'AnsiString' }
{%TEMPLATE DynArrayPosNextArrayImpl 'B' 'RawByteString' 'RawByteString' }
{$ENDIF}
{%TEMPLATE DynArrayPosNextArrayImpl 'W' 'WideString'    'WideString' }
{%TEMPLATE DynArrayPosNextArrayImpl 'U' 'UnicodeString' 'UnicodeString' }
{%TEMPLATE DynArrayPosNextArrayImpl ''  'String'        'String'     }
function DynArrayPosNext(const Find: TObject; const V: ObjectArray; const PrevPos: Integer): Integer;
var I : Integer;
begin
  for I := MaxInt(PrevPos + 1, 0) to Length(V) - 1 do
    if V[I] = Find then
      begin
        Result := I;
        exit;
       end;
  Result := -1;
end;

function DynArrayPosNext(const ClassType: TClass; const V: ObjectArray; const PrevPos: Integer): Integer;
var I : Integer;
begin
  for I := MaxInt(PrevPos + 1, 0) to Length(V) - 1 do
    if V[I] is ClassType then
      begin
        Result := I;
        exit;
       end;
  Result := -1;
end;

function DynArrayPosNext(const ClassName: String; const V: ObjectArray; const PrevPos: Integer): Integer;
var I : Integer;
    T : TObject;
begin
  for I := MaxInt(PrevPos + 1, 0) to Length(V) - 1 do
    begin
      T := V[I];
      if Assigned(T) and (T.ClassName = ClassName) then
        begin
          Result := I;
          exit;
         end;
    end;
  Result := -1;
end;

{$IFNDEF ManagedCode}
function DynArrayPosNext(const Find: Pointer; const V: PointerArray; const PrevPos: Integer): Integer;
var I : Integer;
begin
  for I := MaxInt(PrevPos + 1, 0) to Length(V) - 1 do
    if V[I] = Find then
      begin
        Result := I;
        exit;
       end;
  Result := -1;
end;
{$ENDIF}



{                                                                              }
{ DynArrayCount                                                                }
{                                                                              }
{%DEFINE DynArrayCountImpl}
function DynArrayCount%1%(const Find: %3%; const V: %2%Array; const IsSortedAscending: Boolean = False): Integer;
var I, J : Integer;
begin
  if IsSortedAscending then
    begin
      I := DynArrayPosNext%1%(Find, V, -1, True);
      if I = -1 then
        Result := 0 else
        begin
          Result := 1;
          J := Length(V);
          while (I + Result < J) and (V[I + Result] = Find) do
            Inc(Result);
        end;
    end
  else
    begin
      J := -1;
      Result := 0;
      repeat
        I := DynArrayPosNext%1%(Find, V, J, False);
        if I >= 0 then
          begin
            Inc(Result);
            J := I;
          end;
      until I < 0;
    end;
end;
{%ENDDEF}
{%TEMPLATE DynArrayCountImpl ''  'Byte'          'Byte'}
{%TEMPLATE DynArrayCountImpl ''  'Word'          'Word'}
{%TEMPLATE DynArrayCountImpl ''  'LongWord'      'LongWord'}
{%TEMPLATE DynArrayCountImpl ''  'ShortInt'      'ShortInt'}
{%TEMPLATE DynArrayCountImpl ''  'SmallInt'      'SmallInt'}
{%TEMPLATE DynArrayCountImpl ''  'LongInt'       'LongInt'}
{%TEMPLATE DynArrayCountImpl ''  'Int64'         'Int64'}
{%TEMPLATE DynArrayCountImpl ''  'Single'        'Single'}
{%TEMPLATE DynArrayCountImpl ''  'Double'        'Double'}
{%TEMPLATE DynArrayCountImpl ''  'Extended'      'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayCountImpl 'A' 'AnsiString'    'AnsiString'}
{%TEMPLATE DynArrayCountImpl 'B' 'RawByteString' 'RawByteString'}
{$ENDIF}
{%TEMPLATE DynArrayCountImpl 'W' 'WideString'    'WideString'}
{%TEMPLATE DynArrayCountImpl 'U' 'UnicodeString' 'UnicodeString'}
{%TEMPLATE DynArrayCountImpl ''  'String'        'String'}
{%TEMPLATE DynArrayCountImpl ''  'Boolean'       'Boolean'}


{                                                                              }
{ DynArrayRemoveAll                                                            }
{                                                                              }
{%DEFINE DynArrayRemoveAllImpl}
procedure DynArrayRemoveAll%1%(const Find: %3%; var V: %2%Array; const IsSortedAscending: Boolean = False);
var I, J : Integer;
begin
  I := DynArrayPosNext%1%(Find, V, -1, IsSortedAscending);
  while I >= 0 do
    begin
      J := 1;
      while (I + J < Length(V)) and (V[I + J] = Find) do
        Inc(J);
      DynArrayRemove%1%(V, I, J);
      I := DynArrayPosNext%1%(Find, V, I, IsSortedAscending);
    end;
end;
{%ENDDEF}
{%TEMPLATE DynArrayRemoveAllImpl ''  'Byte'          'Byte'}
{%TEMPLATE DynArrayRemoveAllImpl ''  'Word'          'Word'}
{%TEMPLATE DynArrayRemoveAllImpl ''  'LongWord'      'LongWord'}
{%TEMPLATE DynArrayRemoveAllImpl ''  'ShortInt'      'ShortInt'}
{%TEMPLATE DynArrayRemoveAllImpl ''  'SmallInt'      'SmallInt'}
{%TEMPLATE DynArrayRemoveAllImpl ''  'LongInt'       'LongInt'}
{%TEMPLATE DynArrayRemoveAllImpl ''  'Int64'         'Int64'}
{%TEMPLATE DynArrayRemoveAllImpl ''  'Single'        'Single'}
{%TEMPLATE DynArrayRemoveAllImpl ''  'Double'        'Double'}
{%TEMPLATE DynArrayRemoveAllImpl ''  'Extended'      'Extended'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayRemoveAllImpl 'A' 'AnsiString'    'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayRemoveAllImpl 'W' 'WideString'    'WideString'}
{%TEMPLATE DynArrayRemoveAllImpl 'U' 'UnicodeString' 'UnicodeString'}
{%TEMPLATE DynArrayRemoveAllImpl ''  'String'        'String'}


{                                                                              }
{ DynArrayIntersection                                                         }
{   If both arrays are sorted ascending then time is o(n) instead of o(n^2).   }
{                                                                              }
{%DEFINE DynArrayIntersectionFloatImpl}
function DynArrayIntersection(const V1, V2: %1%Array; const IsSortedAscending: Boolean): %1%Array;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) >= 0) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;
{%ENDDEF}
{%TEMPLATE DynArrayIntersectionFloatImpl 'Single'}
{%TEMPLATE DynArrayIntersectionFloatImpl 'Double'}
{%TEMPLATE DynArrayIntersectionFloatImpl 'Extended'}
{%DEFINE DynArrayIntersectionImpl}
function DynArrayIntersection%1%(const V1, V2: %2%Array; const IsSortedAscending: Boolean): %2%Array;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] = V2[J] then
                DynArrayAppend%1%(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext%1%(V1[I], V2) >= 0) and (DynArrayPosNext%1%(V1[I], Result) = -1) then
        DynArrayAppend%1%(Result, V1[I]);
end;
{%ENDDEF}
{%TEMPLATE DynArrayIntersectionImpl ''  'Byte'}
{%TEMPLATE DynArrayIntersectionImpl ''  'Word'}
{%TEMPLATE DynArrayIntersectionImpl ''  'LongWord'}
{%TEMPLATE DynArrayIntersectionImpl ''  'ShortInt'}
{%TEMPLATE DynArrayIntersectionImpl ''  'SmallInt'}
{%TEMPLATE DynArrayIntersectionImpl ''  'LongInt'}
{%TEMPLATE DynArrayIntersectionImpl ''  'Int64'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayIntersectionImpl 'A' 'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayIntersectionImpl 'W' 'WideString'}
{%TEMPLATE DynArrayIntersectionImpl 'U' 'UnicodeString'}
{%TEMPLATE DynArrayIntersectionImpl ''  'String'}


{                                                                              }
{ DynArrayDifference                                                           }
{   Returns elements in V1 but not in V2.                                      }
{   If both arrays are sorted ascending then time is o(n) instead of o(n^2).   }
{                                                                              }
{%DEFINE DynArrayDifferenceFloatImpl}
function DynArrayDifference(const V1, V2: %1%Array; const IsSortedAscending: Boolean): %1%Array;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext(V1[I], V2) = -1) and (DynArrayPosNext(V1[I], Result) = -1) then
        DynArrayAppend(Result, V1[I]);
end;
{%ENDDEF}
{%TEMPLATE DynArrayDifferenceFloatImpl 'Single'}
{%TEMPLATE DynArrayDifferenceFloatImpl 'Double'}
{%TEMPLATE DynArrayDifferenceFloatImpl 'Extended'}
{%DEFINE DynArrayDifferenceImpl}
function DynArrayDifference%1%(const V1, V2: %2%Array; const IsSortedAscending: Boolean): %2%Array;
var I, J, L, LV : Integer;
begin
  SetLength(Result, 0);
  if IsSortedAscending then
    begin
      I := 0;
      J := 0;
      L := Length(V1);
      LV := Length(V2);
      while (I < L) and (J < LV) do
        begin
          while (I < L) and (V1[I] < V2[J]) do
            Inc(I);
          if I < L then
            begin
              if V1[I] <> V2[J] then
                DynArrayAppend%1%(Result, V1[I]);
              while (J < LV) and (V2[J] <= V1[I]) do
                Inc(J);
            end;
        end;
    end
  else
    for I := 0 to Length(V1) - 1 do
      if (DynArrayPosNext%1%(V1[I], V2) = -1) and (DynArrayPosNext%1%(V1[I], Result) = -1) then
        DynArrayAppend%1%(Result, V1[I]);
end;
{%ENDDEF}
{%TEMPLATE DynArrayDifferenceImpl ''  'Byte'}
{%TEMPLATE DynArrayDifferenceImpl ''  'Word'}
{%TEMPLATE DynArrayDifferenceImpl ''  'LongWord'}
{%TEMPLATE DynArrayDifferenceImpl ''  'ShortInt'}
{%TEMPLATE DynArrayDifferenceImpl ''  'SmallInt'}
{%TEMPLATE DynArrayDifferenceImpl ''  'LongInt'}
{%TEMPLATE DynArrayDifferenceImpl ''  'Int64'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayDifferenceImpl 'A' 'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayDifferenceImpl 'W' 'WideString'}
{%TEMPLATE DynArrayDifferenceImpl 'U' 'UnicodeString'}
{%TEMPLATE DynArrayDifferenceImpl ''  'String'}


{                                                                              }
{ DynArrayReverse                                                              }
{                                                                              }
{%DEFINE DynArrayReverseImpl}
procedure DynArrayReverse%1%(var V: %2%Array);
var I, L : Integer;
begin
  L := Length(V);
  for I := 1 to L div 2 do
    Swap%1%(V[I - 1], V[L - I]);
end;
{%ENDDEF}
{%TEMPLATE DynArrayReverseImpl ''  'Byte'}
{%TEMPLATE DynArrayReverseImpl ''  'Word'}
{%TEMPLATE DynArrayReverseImpl ''  'LongWord'}
{%TEMPLATE DynArrayReverseImpl ''  'ShortInt'}
{%TEMPLATE DynArrayReverseImpl ''  'SmallInt'}
{%TEMPLATE DynArrayReverseImpl ''  'LongInt'}
{%TEMPLATE DynArrayReverseImpl ''  'Int64'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayReverseImpl 'A' 'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayReverseImpl 'W' 'WideString'}
{%TEMPLATE DynArrayReverseImpl 'U' 'UnicodeString'}
{%TEMPLATE DynArrayReverseImpl ''  'String'}
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayReverseImpl ''  'Pointer'}
{$ENDIF}
{%TEMPLATE DynArrayReverseImpl ''  'Object'}
{%TEMPLATE DynArrayReverseImpl ''  'Single'}
{%TEMPLATE DynArrayReverseImpl ''  'Double'}
{%TEMPLATE DynArrayReverseImpl ''  'Extended'}


{                                                                              }
{ Returns an open array (V) as a dynamic array.                                }
{                                                                              }
{%DEFINE OpenArrayAsDynArrayImpl}
function As%1%Array(const V: array of %2%): %1%Array;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;
{%ENDDEF}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Boolean'       'Boolean'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Byte'          'Byte'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Word'          'Word'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Word32'        'Word32'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'LongWord'      'LongWord'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Cardinal'      'Cardinal'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'NativeUInt'    'NativeUInt'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'ShortInt'      'ShortInt'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'SmallInt'      'SmallInt'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'LongInt'       'LongInt'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Integer'       'Integer'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Int32'         'Int32'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Int64'         'Int64'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'NativeInt'     'NativeInt'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Single'        'Single'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Double'        'Double'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Extended'      'Extended'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Currency'      'Currency'}
{$IFDEF SupportAnsiString}
{%TEMPLATE OpenArrayAsDynArrayImpl 'AnsiString'    'AnsiString'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'RawByteString' 'RawByteString'}
{$ENDIF}
{%TEMPLATE OpenArrayAsDynArrayImpl 'WideString'    'WideString'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'UnicodeString' 'UnicodeString'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'String'        'String'}
{$IFNDEF ManagedCode}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Pointer'       'Pointer'}
{$ENDIF}
{%TEMPLATE OpenArrayAsDynArrayImpl 'ByteCharSet'   'ByteCharSet'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Object'        'TObject'}
{%TEMPLATE OpenArrayAsDynArrayImpl 'Interface'     'IInterface'}


{%DEFINE DynArrayRangeImpl}
function DynArrayRange%1%(const First: %1%; const Count: Integer; const Increment: %1%): %1%Array;
var I : Integer;
    J : %1%;
begin
  SetLength(Result, Count);
  J := First;
  for I := 0 to Count - 1 do
    begin
      Result[I] := J;
      J := J + Increment;
    end;
end;
{%ENDDEF}
{%TEMPLATE DynArrayRangeImpl 'Byte'}
{%TEMPLATE DynArrayRangeImpl 'Word'}
{%TEMPLATE DynArrayRangeImpl 'LongWord'}
{%TEMPLATE DynArrayRangeImpl 'Cardinal'}
{%TEMPLATE DynArrayRangeImpl 'ShortInt'}
{%TEMPLATE DynArrayRangeImpl 'SmallInt'}
{%TEMPLATE DynArrayRangeImpl 'LongInt'}
{%TEMPLATE DynArrayRangeImpl 'Integer'}
{%TEMPLATE DynArrayRangeImpl 'Int64'}
{%TEMPLATE DynArrayRangeImpl 'Single'}
{%TEMPLATE DynArrayRangeImpl 'Double'}
{%TEMPLATE DynArrayRangeImpl 'Extended'}


{                                                                              }
{ DynArrayDup                                                                  }
{                                                                              }
{$IFDEF ManagedCode}
function DynArrayDupByte(const V: Byte; const Count: Integer): ByteArray;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := 0;
end;
{$ELSE}
function DynArrayDupByte(const V: Byte; const Count: Integer): ByteArray;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  FillChar(Result[0], Count, V);
end;
{$ENDIF}

{%DEFINE DynArrayDupImpl}
function DynArrayDup%1%(const V: %2%; const Count: Integer): %1%Array;
var I : Integer;
begin
  if Count <= 0 then
    begin
      SetLength(Result, 0);
      exit;
    end;
  SetLength(Result, Count);
  for I := 0 to Count - 1 do
    Result[I] := V;
end;
{%ENDDEF}
{%TEMPLATE DynArrayDupImpl 'Word'          'Word'}
{%TEMPLATE DynArrayDupImpl 'LongWord'      'LongWord'}
{%TEMPLATE DynArrayDupImpl 'Cardinal'      'Cardinal'}
{%TEMPLATE DynArrayDupImpl 'NativeUInt'    'NativeUInt'}
{%TEMPLATE DynArrayDupImpl 'ShortInt'      'ShortInt'}
{%TEMPLATE DynArrayDupImpl 'SmallInt'      'SmallInt'}
{%TEMPLATE DynArrayDupImpl 'LongInt'       'LongInt'}
{%TEMPLATE DynArrayDupImpl 'Integer'       'Integer'}
{%TEMPLATE DynArrayDupImpl 'Int64'         'Int64'}
{%TEMPLATE DynArrayDupImpl 'NativeInt'     'NativeInt'}
{%TEMPLATE DynArrayDupImpl 'Single'        'Single'}
{%TEMPLATE DynArrayDupImpl 'Double'        'Double'}
{%TEMPLATE DynArrayDupImpl 'Extended'      'Extended'}
{%TEMPLATE DynArrayDupImpl 'Currency'      'Currency'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayDupImpl 'AnsiString'    'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayDupImpl 'WideString'    'WideString'}
{%TEMPLATE DynArrayDupImpl 'UnicodeString' 'UnicodeString'}
{%TEMPLATE DynArrayDupImpl 'String'        'String'}
{%TEMPLATE DynArrayDupImpl 'ByteCharSet'   'ByteCharSet'}
{%TEMPLATE DynArrayDupImpl 'Object'        'TObject'}


{                                                                              }
{ SetLengthAndZero                                                             }
{                                                                              }
{%DEFINE SetLengthAndZeroImpl}
{$IFDEF ManagedCode}
procedure SetLengthAndZero(var V: %1%Array; const NewLength: Integer);
var OldLen, NewLen, I : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  for I := 0 to NewLen - OldLen - 1 do
    V[OldLen + I] := %3%;
end;
{$ELSE}
procedure SetLengthAndZero(var V: %1%Array; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(%2%) * (NewLen - OldLen), #0);
end;
{$ENDIF}
{%ENDDEF}
{%TEMPLATE SetLengthAndZeroImpl 'Byte'       'Byte'       '0'}
{%TEMPLATE SetLengthAndZeroImpl 'Word'       'Word'       '0'}
{%TEMPLATE SetLengthAndZeroImpl 'Word32'     'Word32'     '0'}
{%TEMPLATE SetLengthAndZeroImpl 'LongWord'   'LongWord'   '0'}
{%TEMPLATE SetLengthAndZeroImpl 'NativeUInt' 'NativeUInt' '0'}
{%TEMPLATE SetLengthAndZeroImpl 'ShortInt'   'ShortInt'   '0'}
{%TEMPLATE SetLengthAndZeroImpl 'SmallInt'   'SmallInt'   '0'}
{%TEMPLATE SetLengthAndZeroImpl 'LongInt'    'LongInt'    '0'}
{%TEMPLATE SetLengthAndZeroImpl 'Int32'      'Int32'      '0'}
{%TEMPLATE SetLengthAndZeroImpl 'Int64'      'Int64'      '0'}
{%TEMPLATE SetLengthAndZeroImpl 'NativeInt'  'NativeInt'  '0'}
{%TEMPLATE SetLengthAndZeroImpl 'Single'     'Single'     '0.0'}
{%TEMPLATE SetLengthAndZeroImpl 'Double'     'Double'     '0.0'}
{%TEMPLATE SetLengthAndZeroImpl 'Extended'   'Extended'   '0.0'}
{%TEMPLATE SetLengthAndZeroImpl 'Currency'   'Currency'   '0.0'}
{%TEMPLATE SetLengthAndZeroImpl 'ByteCharSet' 'ByteCharSet'    '[]'}
{%TEMPLATE SetLengthAndZeroImpl 'Boolean'    'Boolean'    'False'}
{$IFNDEF Managedcode}
{%TEMPLATE SetLengthAndZeroImpl 'Pointer'  'Pointer'   'nil'}
{$ENDIF}
procedure SetLengthAndZero(var V: ObjectArray; const NewLength: Integer;
    const FreeObjects: Boolean);
var I, L : Integer;
begin
  L := Length(V);
  if L = NewLength then
    exit;
  if (L > NewLength) and FreeObjects then
    for I := NewLength to L - 1 do
      FreeAndNil(V[I]);
  SetLength(V, NewLength);
  if L > NewLength then
    exit;
  {$IFDEF ManagedCode}
  for I := 0 to NewLength - L - 1 do
    V[L + I] := nil;
  {$ELSE}
  FillChar(V[L], Sizeof(Pointer) * (NewLength - L), #0);
  {$ENDIF}
end;



{                                                                              }
{ DynArrayIsEqual                                                              }
{                                                                              }
{%DEFINE DynArrayIsEqualMemImpl}
{$IFDEF ManagedCode}
function DynArrayIsEqual(const V1, V2: %1%Array): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function DynArrayIsEqual(const V1, V2: %1%Array): Boolean;
var L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  Result := EqualMem(Pointer(V1)^, Pointer(V2)^, Sizeof(%1%) * L);
end;
{$ENDIF}
{%ENDDEF}
{%DEFINE DynArrayIsEqualBruteImpl}
function DynArrayIsEqual%1%(const V1, V2: %2%Array): Boolean;
var I, L : Integer;
begin
  L := Length(V1);
  if L <> Length(V2) then
    begin
      Result := False;
      exit;
    end;
  for I := 0 to L - 1 do
    if V1[I] <> V2[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{%ENDDEF}
{%TEMPLATE DynArrayIsEqualMemImpl   'Byte'}
{%TEMPLATE DynArrayIsEqualMemImpl   'Word'}
{%TEMPLATE DynArrayIsEqualMemImpl   'LongWord'}
{%TEMPLATE DynArrayIsEqualMemImpl   'ShortInt'}
{%TEMPLATE DynArrayIsEqualMemImpl   'SmallInt'}
{%TEMPLATE DynArrayIsEqualMemImpl   'LongInt'}
{%TEMPLATE DynArrayIsEqualMemImpl   'Int64'}
{%TEMPLATE DynArrayIsEqualMemImpl   'Single'}
{%TEMPLATE DynArrayIsEqualMemImpl   'Double'}
{%TEMPLATE DynArrayIsEqualMemImpl   'Extended'}
{%TEMPLATE DynArrayIsEqualMemImpl   'Currency'}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayIsEqualBruteImpl 'A' 'AnsiString'}
{%TEMPLATE DynArrayIsEqualBruteImpl 'B' 'RawByteString'}
{$ENDIF}
{%TEMPLATE DynArrayIsEqualBruteImpl 'W' 'WideString'}
{%TEMPLATE DynArrayIsEqualBruteImpl 'U' 'UnicodeString'}
{%TEMPLATE DynArrayIsEqualBruteImpl ''  'String'}
{%TEMPLATE DynArrayIsEqualBruteImpl ''  'ByteCharSet'}


{                                                                              }
{ Dynamic array to Dynamic array                                               }
{                                                                              }
{%DEFINE DynArrayToDynArrayImpl}
function %1%ArrayTo%2%Array(const V: %1%Array): %2%Array;
var I, L : Integer;
begin
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := %3%V[I]%4%;
end;
{%ENDDEF}
{%TEMPLATE DynArrayToDynArrayImpl 'Byte'     'LongInt'  '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'Word'     'LongInt'  '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'ShortInt' 'LongInt'  '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'SmallInt' 'LongInt'  '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'LongInt'  'Int64'    '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'LongInt'  'Single'   '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'LongInt'  'Double'   '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'LongInt'  'Extended' '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'Single'   'Double'   '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'Single'   'Extended' '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'Single'   'Currency' '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'Single'   'LongInt'  'LongInt(Trunc(' '))'}
{%TEMPLATE DynArrayToDynArrayImpl 'Single'   'Int64'    'Trunc(' ')'}
{%TEMPLATE DynArrayToDynArrayImpl 'Double'   'Extended' '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'Double'   'Currency' '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'Double'   'LongInt'  'LongInt(Trunc(' '))'}
{%TEMPLATE DynArrayToDynArrayImpl 'Double'   'Int64'    'Trunc(' ')'}
{%TEMPLATE DynArrayToDynArrayImpl 'Extended' 'Currency' '' ''}
{%TEMPLATE DynArrayToDynArrayImpl 'Extended' 'LongInt'  'LongInt(Trunc(' '))'}
{%TEMPLATE DynArrayToDynArrayImpl 'Extended' 'Int64'    'Trunc(' ')'}


{                                                                              }
{ Array from indexes                                                           }
{                                                                              }
{%DEFINE DynArrayFromIndexesImpl}
function %1%ArrayFromIndexes(const V: %1%Array; const Indexes: IntegerArray): %1%Array;
var I, L : Integer;
begin
  L := Length(Indexes);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;
{%ENDDEF}
{%TEMPLATE DynArrayFromIndexesImpl 'Byte'}
{%TEMPLATE DynArrayFromIndexesImpl 'Word'}
{%TEMPLATE DynArrayFromIndexesImpl 'LongWord'}
{%TEMPLATE DynArrayFromIndexesImpl 'Cardinal'}
{%TEMPLATE DynArrayFromIndexesImpl 'ShortInt'}
{%TEMPLATE DynArrayFromIndexesImpl 'SmallInt'}
{%TEMPLATE DynArrayFromIndexesImpl 'LongInt'}
{%TEMPLATE DynArrayFromIndexesImpl 'Integer'}
{%TEMPLATE DynArrayFromIndexesImpl 'Int64'}
{%TEMPLATE DynArrayFromIndexesImpl 'Single'}
{%TEMPLATE DynArrayFromIndexesImpl 'Double'}
{%TEMPLATE DynArrayFromIndexesImpl 'Extended'}
{%TEMPLATE DynArrayFromIndexesImpl 'String'}


{                                                                              }
{ Dynamic array sort                                                           }
{                                                                              }
{%DEFINE DynArraySortImpl}
procedure DynArraySort%1%(const V: %2%Array);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : %3%;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := V[M];
      repeat
        while V[I] < W do
          Inc(I);
        while V[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := V[I];
            V[I] := V[J];
            V[J] := T;
            if M = I then
              begin
                M := J;
                W := V[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := V[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  I := Length(V);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{%ENDDEF}
{%TEMPLATE DynArraySortImpl ''  'Byte'          'Byte'       }
{%TEMPLATE DynArraySortImpl ''  'Word'          'Word'       }
{%TEMPLATE DynArraySortImpl ''  'LongWord'      'LongWord'   }
{%TEMPLATE DynArraySortImpl ''  'NativeUInt'    'NativeUInt' }
{%TEMPLATE DynArraySortImpl ''  'ShortInt'      'ShortInt'   }
{%TEMPLATE DynArraySortImpl ''  'SmallInt'      'SmallInt'   }
{%TEMPLATE DynArraySortImpl ''  'LongInt'       'LongInt'    }
{%TEMPLATE DynArraySortImpl ''  'Int64'         'Int64'      }
{%TEMPLATE DynArraySortImpl ''  'NativeInt'     'NativeInt'  }
{%TEMPLATE DynArraySortImpl ''  'Single'        'Single'     }
{%TEMPLATE DynArraySortImpl ''  'Double'        'Double'     }
{%TEMPLATE DynArraySortImpl ''  'Extended'      'Extended'   }
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArraySortImpl 'A' 'AnsiString'    'AnsiString' }
{%TEMPLATE DynArraySortImpl 'B' 'RawByteString' 'RawByteString' }
{$ENDIF}
{%TEMPLATE DynArraySortImpl 'W' 'WideString'    'WideString' }
{%TEMPLATE DynArraySortImpl 'U' 'UnicodeString' 'UnicodeString' }
{%TEMPLATE DynArraySortImpl ''  'String'        'String'     }


{%DEFINE DynArrayPairSortImpl}
{$IFDEF ManagedCode}
procedure DynArraySort(const Key: %1%Array; const Data: %2%Array);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : %3%;
      A       : %4%;
  begin
    repeat
      I := L;
      J := R;
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while Key[I] < W do
          Inc(I);
        while Key[J] > W do
          Dec(J);
        if I <= J then
          begin
            T := Key[I];
            Key[I] := Key[J];
            Key[J] := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Key[J];
              end else
              if M = J then
                begin
                  M := I;
                  W := Key[I];
                end;
            Inc(I);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ELSE}
procedure DynArraySort(const Key: %1%Array; const Data: %2%Array);

  procedure QuickSort(L, R: Integer);
  var I, J, M : Integer;
      W, T    : %3%;
      P, Q    : P%3%;
      A       : %4%;
  begin
    repeat
      I := L;
      P := @Key[I];
      J := R;
      Q := @Key[J];
      M := (L + R) shr 1;
      W := Key[M];
      repeat
        while P^ < W do
          begin
            Inc(P);
            Inc(I);
          end;
        while Q^ > W do
          begin
            Dec(Q);
            Dec(J);
          end;
        if I <= J then
          begin
            T := P^;
            P^ := Q^;
            Q^ := T;
            A := Data[I];
            Data[I] := Data[J];
            Data[J] := A;
            if M = I then
              begin
                M := J;
                W := Q^;
              end else
              if M = J then
                begin
                  M := I;
                  W := P^;
                end;
            Inc(P);
            Inc(I);
            Dec(Q);
            Dec(J);
          end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      L := I;
    until I >= R;
  end;

var I : Integer;
begin
  Assert(Length(Key) = Length(Data));
  I := Length(Key);
  if I > 0 then
    QuickSort(0, I - 1);
end;
{$ENDIF}
{%ENDDEF}
{%TEMPLATE DynArrayPairSortImpl 'Integer' 'Integer'    'Integer' 'Integer'   }
{%TEMPLATE DynArrayPairSortImpl 'Integer' 'Int64'      'Integer' 'Int64'     }
{%TEMPLATE DynArrayPairSortImpl 'Integer' 'AnsiString' 'Integer' 'AnsiString'}
{%TEMPLATE DynArrayPairSortImpl 'Integer' 'Extended'   'Integer' 'Extended'  }
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayPairSortImpl 'Integer' 'Pointer'  'Integer' 'Pointer'   }
{$ENDIF}
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayPairSortImpl 'AnsiString' 'Integer'    'AnsiString' 'Integer'   }
{%TEMPLATE DynArrayPairSortImpl 'AnsiString' 'Int64'      'AnsiString' 'Int64'     }
{%TEMPLATE DynArrayPairSortImpl 'AnsiString' 'AnsiString' 'AnsiString' 'AnsiString'}
{%TEMPLATE DynArrayPairSortImpl 'AnsiString' 'Extended'   'AnsiString' 'Extended'  }
{$IFNDEF Managedcode}
{%TEMPLATE DynArrayPairSortImpl 'AnsiString' 'Pointer'   'AnsiString' 'Pointer'   }
{$ENDIF}
{$ENDIF}
{%TEMPLATE DynArrayPairSortImpl 'Extended' 'Integer'    'Extended'   'Integer'   }
{%TEMPLATE DynArrayPairSortImpl 'Extended' 'Int64'      'Extended'   'Int64'     }
{$IFDEF SupportAnsiString}
{%TEMPLATE DynArrayPairSortImpl 'Extended' 'AnsiString' 'Extended'   'AnsiString'}
{$ENDIF}
{%TEMPLATE DynArrayPairSortImpl 'Extended' 'Extended'   'Extended'   'Extended'  }
{$IFNDEF ManagedCode}
{%TEMPLATE DynArrayPairSortImpl 'Extended' 'Pointer'  'Extended'   'Pointer'   }
{$ENDIF}



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF DYNARRAYS_TEST}
{$ASSERTIONS ON}
procedure Test_IntegerArray;
var S, T : IntegerArray;
    F    : Integer;
begin
  S := nil;
  for F := 1 to 100 do
    begin
      DynArrayAppend(S, F);
      Assert(Length(S) = F,                 'Append');
      Assert(S[F - 1] = F,                  'Append');
    end;

  T := Copy(S);
  DynArrayAppendIntegerArray(S, T);
  for F := 1 to 100 do
    Assert(S[F + 99] = F,                   'Append');
  Assert(DynArrayPosNext(60, S) = 59,               'PosNext');
  Assert(DynArrayPosNext(60, T) = 59,               'PosNext');
  Assert(DynArrayPosNext(60, S, 59) = 159,          'PosNext');
  Assert(DynArrayPosNext(60, T, 59) = -1,           'PosNext');
  Assert(DynArrayPosNext(60, T, -1, True) = 59,     'PosNext');
  Assert(DynArrayPosNext(60, T, 59, True) = -1,     'PosNext');

  for F := 1 to 100 do
    begin
      DynArrayRemove(S, DynArrayPosNext(F, S), 1);
      Assert(Length(S) = 200 - F,           'Remove');
    end;
  for F := 99 downto 0 do
    begin
      DynArrayRemove(S, DynArrayPosNext(F xor 3 + 1, S), 1);
      Assert(Length(S) = F,                 'Remove');
    end;

  S := AsIntegerArray([3, 1, 2, 5, 4]);
  DynArraySort(S);
  Assert(S[0] = 1, 'Sort');
  Assert(S[1] = 2, 'Sort');
  Assert(S[2] = 3, 'Sort');
  Assert(S[3] = 4, 'Sort');
  Assert(S[4] = 5, 'Sort');

  S := AsIntegerArray([3, 5, 5, 2, 5, 5, 1]);
  DynArraySort(S);
  Assert(S[0] = 1, 'Sort');
  Assert(S[1] = 2, 'Sort');
  Assert(S[2] = 3, 'Sort');
  Assert(S[3] = 5, 'Sort');
  Assert(S[4] = 5, 'Sort');
  Assert(S[5] = 5, 'Sort');
  Assert(S[6] = 5, 'Sort');

  SetLength(S, 1000);
  for F := 0 to 999 do
    S[F] := F mod 5;
  DynArraySort(S);
  for F := 0 to 999 do
    Assert(S[F] = F div 200, 'Sort');

  S := AsIntegerArray([6, 3, 5, 1]);
  T := AsIntegerArray([1, 2, 3, 4]);
  DynArraySort(S, T);
  Assert(S[0] = 1, 'Sort');
  Assert(S[1] = 3, 'Sort');
  Assert(S[2] = 5, 'Sort');
  Assert(S[3] = 6, 'Sort');
  Assert(T[0] = 4, 'Sort');
  Assert(T[1] = 2, 'Sort');
  Assert(T[2] = 3, 'Sort');
  Assert(T[3] = 1, 'Sort');
end;

procedure Test_ObjectArray;
var S, T : ObjectArray;
    F    : Integer;
    V    : TObject;
begin
  S := nil;
  V := TObject.Create;
  try
    for F := 1 to 100 do
      begin
        DynArrayAppend(S, V);
        Assert(Length(S) = F,            'Append');
        Assert(S[F - 1] = V,             'Append');
      end;
    T := Copy(S);
    for F := 1 to 10 do
      begin
        DynArrayRemove(S, F - 1, 1, False);
        Assert(Length(S) = 100 - F,      'Remove');
      end;
    DynArrayRemove(S, 89, 1, False);
    Assert(Length(S) = 89,               'Remove');
    DynArrayRemove(S, 87, 1, False);
    Assert(Length(S) = 88,               'Remove');
    DynArrayAppendObjectArray(S, T);
    Assert(Length(S) = 188,              'AppendObjectArray');
    DynArrayRemove(S, 10, 88, False);
    Assert(Length(S) = 100,              'Remove');
    DynArrayRemove(S, 0, 100, False);
    Assert(Length(S) = 0,                'Remove');
  finally
    V.Free;
  end;
end;

procedure Test_StringArray;
var S, T : StringArray;
    U    : String;
    F    : Integer;
begin
  S := nil;
  for F := 1 to 100 do
    begin
      U := IntToStr(F);
      DynArrayAppend(S, U);
      Assert(Length(S) = F,                 'Append');
      Assert(S[F - 1] = U,                  'Append');
    end;

  T := Copy(S);
  DynArrayAppendStringArray(S, T);
  for F := 1 to 100 do
    Assert(S[F + 99] = IntToStr(F),         'Append');
  Assert(DynArrayPosNext('60', S) = 59,               'PosNext');
  Assert(DynArrayPosNext('60', T) = 59,               'PosNext');
  Assert(DynArrayPosNext('60', S, 59) = 159,          'PosNext');
  Assert(DynArrayPosNext('60', T, 59) = -1,           'PosNext');
  Assert(DynArrayPosNext('60', T, -1, True) = 59,     'PosNext');
  Assert(DynArrayPosNext('60', T, 59, True) = -1,     'PosNext');

  for F := 1 to 100 do
    begin
      DynArrayRemove(S, DynArrayPosNext(IntToStr(F), S), 1);
      Assert(Length(S) = 200 - F,           'Remove');
    end;
  for F := 99 downto 0 do
    begin
      DynArrayRemove(S, DynArrayPosNext(IntToStr(F xor 3 + 1), S), 1);
      Assert(Length(S) = F,                 'Remove');
    end;

  S := AsStringArray(['3', '1', '2', '5', '4']);
  DynArraySort(S);
  Assert(S[0] = '1', 'Sort');
  Assert(S[1] = '2', 'Sort');
  Assert(S[2] = '3', 'Sort');
  Assert(S[3] = '4', 'Sort');
  Assert(S[4] = '5', 'Sort');

  S := AsStringArray(['3', '5', '5', '2', '5', '5', '1']);
  DynArraySort(S);
  Assert(S[0] = '1', 'Sort');
  Assert(S[1] = '2', 'Sort');
  Assert(S[2] = '3', 'Sort');
  Assert(S[3] = '5', 'Sort');
  Assert(S[4] = '5', 'Sort');
  Assert(S[5] = '5', 'Sort');
  Assert(S[6] = '5', 'Sort');

  SetLength(S, 1000);
  for F := 0 to 999 do
    S[F] := IntToStr(F mod 5);
  DynArraySort(S);
  for F := 0 to 999 do
    Assert(S[F] = IntToStr(F div 200), 'Sort');
end;

procedure Test;
begin
  Test_IntegerArray;
  Test_ObjectArray;
  Test_StringArray;
end;
{$ENDIF}



end.

