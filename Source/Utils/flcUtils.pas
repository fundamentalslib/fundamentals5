{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcUtils.pas                                             }
{   File version:     5.66                                                     }
{   Description:      Utility functions.                                       }
{                                                                              }
{   Copyright:        Copyright (c) 2000-2019, David J Butler                  }
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
{   2000/02/02  0.01  Initial version.                                         }
{   2000/03/08  1.02  Added array functions.                                   }
{   2000/04/10  1.03  Added Append, Renamed Delete to Remove and added         }
{                     StringArrays.                                            }
{   2000/05/03  1.04  Added Path functions.                                    }
{   2000/05/08  1.05  Revision.                                                }
{   2000/06/01  1.06  Added Range and Dup constructors for dynamic arrays.     }
{   2000/06/03  1.07  Added ArrayInsert functions.                             }
{   2000/06/06  1.08  Added bit functions from cMaths.                         }
{   2000/06/08  1.09  Removed data structure classes.                          }
{   2000/06/10  1.10  Added linked lists for Integer, Int64, Extended and      }
{                     String.                                                  }
{   2000/06/14  1.11  cUtils now generated from a template using a source      }
{                     pre-processor.                                           }
{   2000/07/04  1.12  Revision for first Fundamentals release.                 }
{   2000/07/24  1.13  Added TrimArray functions.                               }
{   2000/07/26  1.14  Added Difference functions.                              }
{   2000/09/02  1.15  Added RemoveDuplicates functions.                        }
{                     Added Count functions.                                   }
{   2000/09/27  1.16  Fixed bug in ArrayInsert.                                }
{   2000/11/29  1.17  Moved SetFPUPrecision to cSysUtils.                      }
{   2001/05/03  1.18  Improved bit functions. Added Pascal versions of         }
{                     assembly routines.                                       }
{   2001/05/13  1.19  Added CharCount.                                         }
{   2001/05/15  1.20  Added PosNext (ClassType, ObjectArray).                  }
{   2001/05/18  1.21  Added hashing functions from cMaths.                     }
{   2001/07/07  1.22  Added TBinaryTreeNode.                                   }
{   2001/11/11  2.23  Revision.                                                }
{   2002/01/03  2.24  Added EncodeBase64, DecodeBase64 from cMaths and         }
{                     optimized. Added LongWordToHex, HexToLongWord.           }
{   2002/03/30  2.25  Fixed bug in DecodeBase64.                               }
{   2002/04/02  2.26  Removed dependencies on all other units to remove        }
{                     initialization code associated with SysUtils. This       }
{                     allows usage of cUtils in projects and still have        }
{                     very small binaries.                                     }
{                     Fixed bug in LongWordToHex.                              }
{   2002/05/31  3.27  Refactored for Fundamentals 3.                           }
{                     Moved linked lists to cLinkedLists.                      }
{   2002/08/09  3.28  Added HashInteger.                                       }
{   2002/10/06  3.29  Renamed Cond to iif.                                     }
{   2002/12/12  3.30  Small revisions.                                         }
{   2003/03/14  3.31  Removed ApproxZero. Added FloatZero, FloatsEqual and     }
{                     FloatsCompare. Added documentation and test cases for    }
{                     comparison functions.                                    }
{                     Added support for Currency type.                         }
{   2003/07/27  3.32  Added fast ZeroMem and FillMem routines.                 }
{   2003/09/11  3.33  Added InterfaceArray functions.                          }
{   2004/01/18  3.34  Added WideStringArray functions.                         }
{   2004/07/24  3.35  Optimizations of Sort functions.                         }
{   2004/08/01  3.36  Improved validation in base conversion routines.         }
{   2004/08/22  3.37  Compilable with Delphi 8.                                }
{   2005/06/10  4.38  Compilable with FreePascal 2 Win32 i386.                 }
{   2005/08/19  4.39  Compilable with FreePascal 2 Linux i386.                 }
{   2005/09/21  4.40  Revised for Fundamentals 4.                              }
{   2006/03/04  4.41  Compilable with Delphi 2006 Win32/.NET.                  }
{   2007/06/08  4.42  Compilable with FreePascal 2.04 Win32 i386               }
{   2007/08/08  4.43  Changes to memory functions for Delphi 2006/2007.        }
{   2008/06/06  4.44  Fixed bug in case insensitive hashing functions.         }
{   2009/10/09  4.45  Compilable with Delphi 2009 Win32/.NET.                  }
{   2010/06/27  4.46  Compilable with FreePascal 2.4.0 OSX x86-64.             }
{   2012/04/03  4.47  Support for Delphi XE string and integer types.          }
{   2012/04/04  4.48  Moved dynamic arrays functions to cDynArrays.            }
{   2012/04/11  4.49  StringToFloat/FloatToStr functions.                      }
{   2012/08/26  4.50  UnicodeString versions of functions.                     }
{   2013/01/29  4.51  Compilable with Delphi XE3 x86-64.                       }
{   2013/03/22  4.52  Minor fixes.                                             }
{   2013/05/12  4.53  Added string type definitions.                           }
{   2013/11/15  4.54  Revision.                                                }
{   2015/03/13  4.55  RawByteString functions.                                 }
{   2015/05/06  4.56  Add UTF functions from unit cUnicodeCodecs.              }
{   2015/06/07  4.57  Moved bit functions to unit cBits32.                     }
{   2016/01/09  5.58  Revised for Fundamentals 5.                              }
{   2016/01/29  5.59  StringRefCount functions.                                }
{   2017/10/07  5.60  Moved functions to units flcBase64, flcUTF, flcCharSet.  }
{   2017/11/01  5.61  Added TBytes functions.                                  }
{   2018/07/11  5.62  Moved functions to units flcFloats, flcASCII.            }
{   2018/07/11  5.63  Moved standard types to unit flcStdTypes.                }
{   2018/08/12  5.64  Removed WideString functions and CLR code.               }
{   2018/08/14  5.65  ByteChar changes.                                        }
{   2019/04/02  5.66  Swap changes.                                            }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 5 Win32                      4.55  2015/03/14                       }
{   Delphi 6 Win32                      4.55  2015/03/14                       }
{   Delphi 7 Win32                      5.65  2019/02/24                       }
{   Delphi 2007 Win32                   4.50  2012/08/26                       }
{   Delphi 2009 Win32                   4.46  2011/09/27                       }
{   Delphi 2009 .NET                    4.45  2009/10/09                       }
{   Delphi XE                           4.52  2013/03/22                       }
{   Delphi XE2 Win32                    5.65  2019/03/02                       }
{   Delphi XE2 Win64                    5.65  2019/03/02                       }
{   Delphi XE3 Win32                    5.65  2019/03/02                       }
{   Delphi XE3 Win64                    5.65  2019/03/02                       }
{   Delphi XE6 Win32                    5.65  2019/03/02                       }
{   Delphi XE6 Win64                    5.65  2019/03/02                       }
{   Delphi XE7 Win32                    5.65  2019/03/02                       }
{   Delphi XE7 Win64                    5.65  2019/03/02                       }
{   Delphi XE8 Win32                    5.58  2016/01/10                       }
{   Delphi XE8 Win64                    5.58  2016/01/10                       }
{   Delphi 10 Win32                     5.58  2016/01/09                       }
{   Delphi 10 Win64                     5.58  2016/01/09                       }
{   Delphi 10.2 Win32                   5.63  2018/07/17                       }
{   Delphi 10.2 Win64                   5.63  2018/07/17                       }
{   Delphi 10.2 Linux64                 5.63  2018/07/17                       }
{   FreePascal 2.4.0 OSX x86-64         4.46  2010/06/27                       }
{   FreePascal 2.6.2 Linux x64          4.55  2015/04/01                       }
{   FreePascal 3.0.4 Win32              5.65  2019/02/24                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

{$IFDEF DEBUG}
{$IFDEF TEST}
  {$DEFINE UTILS_TEST}
{$ENDIF}
{$ENDIF}

unit flcUtils;

interface

uses
  { System }
  SysUtils,
  { Fundamentals }
  flcStdTypes;



{                                                                              }
{ Version                                                                      }
{                                                                              }
const
  FundamentalsVersion = '5.0.6';



{                                                                              }
{ Compare result                                                               }
{   Generic compare result enumeration.                                        }
{                                                                              }
type
  TCompareResult = (
      crLess,
      crEqual,
      crGreater,
      crUndefined
      );
  TCompareResultSet = set of TCompareResult;

function InverseCompareResult(const C: TCompareResult): TCompareResult;



{                                                                              }
{ Integer functions                                                            }
{                                                                              }

{ Min returns smallest of A and B                                              }
{ Max returns greatest of A and B                                              }
function  MinInt(const A, B: Integer): Integer;   {$IFDEF UseInline}inline;{$ENDIF}
function  MaxInt(const A, B: Integer): Integer;   {$IFDEF UseInline}inline;{$ENDIF}
function  MinCrd(const A, B: Cardinal): Cardinal; {$IFDEF UseInline}inline;{$ENDIF}
function  MaxCrd(const A, B: Cardinal): Cardinal; {$IFDEF UseInline}inline;{$ENDIF}

{ Bounded returns Value if in Min..Max range, otherwise Min or Max             }
function  Int32Bounded(const Value: Int32; const Min, Max: Int32): Int32;       {$IFDEF UseInline}inline;{$ENDIF}
function  Int64Bounded(const Value: Int64; const Min, Max: Int64): Int64;       {$IFDEF UseInline}inline;{$ENDIF}
function  Int32BoundedByte(const Value: Int32): Int32;                          {$IFDEF UseInline}inline;{$ENDIF}
function  Int64BoundedByte(const Value: Int64): Int64;                          {$IFDEF UseInline}inline;{$ENDIF}
function  Int32BoundedWord(const Value: Int32): Int32;                          {$IFDEF UseInline}inline;{$ENDIF}
function  Int64BoundedWord(const Value: Int64): Int64;                          {$IFDEF UseInline}inline;{$ENDIF}
function  Int64BoundedWord32(const Value: Int64): Word32;                       {$IFDEF UseInline}inline;{$ENDIF}



{                                                                              }
{ String construction from buffer                                              }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrPToStrA(const P: PAnsiChar; const L: Integer): AnsiString;
{$ENDIF}
function  StrPToStrB(const P: Pointer; const L: Integer): RawByteString;
function  StrPToStrU(const P: PWideChar; const L: Integer): UnicodeString;
function  StrPToStr(const P: PChar; const L: Integer): String;

function  StrZLenA(const S: Pointer): Integer;
function  StrZLenW(const S: PWideChar): Integer;
function  StrZLen(const S: PChar): Integer;

{$IFDEF SupportAnsiString}
function  StrZPasA(const A: PAnsiChar): AnsiString;
{$ENDIF}
function  StrZPasB(const A: PByteChar): RawByteString;
function  StrZPasU(const A: PWideChar): UnicodeString;
function  StrZPas(const A: PChar): String;



{                                                                              }
{ RawByteString conversion functions                                           }
{                                                                              }
procedure RawByteBufToWideBuf(const Buf: Pointer; const BufSize: Integer; const DestBuf: Pointer);
function  RawByteStrPtrToUnicodeString(const S: Pointer; const Len: Integer): UnicodeString;
function  RawByteStringToUnicodeString(const S: RawByteString): UnicodeString;

procedure WideBufToRawByteBuf(const Buf: Pointer; const Len: Integer; const DestBuf: Pointer);
function  WideBufToRawByteString(const P: PWideChar; const Len: Integer): RawByteString;

function  UnicodeStringToRawByteString(const S: UnicodeString): RawByteString;



{                                                                              }
{ String conversion functions                                                  }
{                                                                              }
{$IFDEF SupportAnsiString}
function  ToAnsiString(const A: String): AnsiString;       {$IFDEF UseInline}inline;{$ENDIF}
{$ENDIF}
function  ToRawByteString(const A: String): RawByteString; {$IFDEF UseInline}inline;{$ENDIF}
function  ToUnicodeString(const A: String): UnicodeString; {$IFDEF UseInline}inline;{$ENDIF}



{                                                                              }
{ String internals                                                             }
{                                                                              }
{$IFNDEF SupportStringRefCount}
{$IFDEF DELPHI}
function StringRefCount(const S: RawByteString): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
function StringRefCount(const S: UnicodeString): Integer; overload; {$IFDEF UseInline}inline;{$ENDIF}
{$DEFINE ImplementsStringRefCount}
{$ENDIF}
{$ENDIF}



{                                                                              }
{ String append functions                                                      }
{                                                                              }
{$IFDEF SupportAnsiString}
procedure StrAppendChA(var A: AnsiString; const C: AnsiChar);    {$IFDEF UseInline}inline;{$ENDIF}
{$ENDIF}
procedure StrAppendChB(var A: RawByteString; const C: ByteChar); {$IFDEF UseInline}inline;{$ENDIF}
procedure StrAppendChU(var A: UnicodeString; const C: WideChar); {$IFDEF UseInline}inline;{$ENDIF}
procedure StrAppendCh(var A: String; const C: Char);             {$IFDEF UseInline}inline;{$ENDIF}



{                                                                              }
{ ByteCharSet functions                                                        }
{                                                                              }
function  WideCharInCharSet(const A: WideChar; const C: ByteCharSet): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
function  CharInCharSet(const A: Char; const C: ByteCharSet): Boolean;         {$IFDEF UseInline}inline;{$ENDIF}



{                                                                              }
{ String compare functions                                                     }
{                                                                              }
{   Returns  -1  if A < B                                                      }
{             0  if A = B                                                      }
{             1  if A > B                                                      }
{                                                                              }
function  CharCompareB(const A, B: ByteChar): Integer; {$IFDEF UseInline}inline;{$ENDIF}
function  CharCompareW(const A, B: WideChar): Integer; {$IFDEF UseInline}inline;{$ENDIF}
function  CharCompare(const A, B: Char): Integer;      {$IFDEF UseInline}inline;{$ENDIF}

function  StrPCompareB(const A, B: Pointer; const Len: Integer): Integer;
function  StrPCompareW(const A, B: PWideChar; const Len: Integer): Integer;
function  StrPCompare(const A, B: PChar; const Len: Integer): Integer;

{$IFDEF SupportAnsiString}
function  StrCompareA(const A, B: AnsiString): Integer;
{$ENDIF}
function  StrCompareB(const A, B: RawByteString): Integer;
function  StrCompareU(const A, B: UnicodeString): Integer;
function  StrCompare(const A, B: String): Integer;



{                                                                              }
{ Swap                                                                         }
{                                                                              }
procedure Swap(var X, Y: Boolean); overload;
procedure Swap(var X, Y: Byte); overload;
procedure Swap(var X, Y: Word); overload;
procedure Swap(var X, Y: Word32); overload;
procedure Swap(var X, Y: ShortInt); overload;
procedure Swap(var X, Y: SmallInt); overload;
procedure Swap(var X, Y: Int32); overload;
procedure Swap(var X, Y: Int64); overload;     {$IFDEF UseInline}inline;{$ENDIF}
procedure SwapLW(var X, Y: LongWord);          {$IFDEF UseInline}inline;{$ENDIF}
procedure SwapLI(var X, Y: LongInt);           {$IFDEF UseInline}inline;{$ENDIF}
procedure SwapInt(var X, Y: Integer);          {$IFDEF UseInline}inline;{$ENDIF}
procedure SwapCrd(var X, Y: Cardinal);         {$IFDEF UseInline}inline;{$ENDIF}
procedure Swap(var X, Y: Single); overload;    {$IFDEF UseInline}inline;{$ENDIF}
procedure Swap(var X, Y: Double); overload;    {$IFDEF UseInline}inline;{$ENDIF}
procedure SwapExt(var X, Y: Extended);         {$IFDEF UseInline}inline;{$ENDIF}
procedure Swap(var X, Y: Currency); overload;  {$IFDEF UseInline}inline;{$ENDIF}
{$IFDEF SupportAnsiString}
procedure SwapA(var X, Y: AnsiString);         {$IFDEF UseInline}inline;{$ENDIF}
{$ENDIF}
procedure SwapB(var X, Y: RawByteString);      {$IFDEF UseInline}inline;{$ENDIF}
procedure SwapU(var X, Y: UnicodeString);      {$IFDEF UseInline}inline;{$ENDIF}
procedure Swap(var X, Y: String); overload;    {$IFDEF UseInline}inline;{$ENDIF}
procedure Swap(var X, Y: TObject); overload;
procedure SwapObjects(var X, Y);
procedure Swap(var X, Y: Pointer); overload;



{                                                                              }
{ Inline if                                                                    }
{                                                                              }
{   iif returns TrueValue if Expr is True, otherwise it returns FalseValue.    }
{                                                                              }
function  iif(const Expr: Boolean; const TrueValue: Integer;
          const FalseValue: Integer = 0): Integer; overload;              {$IFDEF UseInline}inline;{$ENDIF}
function  iif(const Expr: Boolean; const TrueValue: Int64;
          const FalseValue: Int64 = 0): Int64; overload;                  {$IFDEF UseInline}inline;{$ENDIF}
function  iif(const Expr: Boolean; const TrueValue: Extended;
          const FalseValue: Extended = 0.0): Extended; overload;          {$IFDEF UseInline}inline;{$ENDIF}
{$IFDEF SupportAnsiString}
function  iifA(const Expr: Boolean; const TrueValue: AnsiString;
          const FalseValue: AnsiString = ''): AnsiString; overload;       {$IFDEF UseInline}inline;{$ENDIF}
{$ENDIF}
function  iifB(const Expr: Boolean; const TrueValue: RawByteString;
          const FalseValue: RawByteString = ''): RawByteString; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  iifU(const Expr: Boolean; const TrueValue: UnicodeString;
          const FalseValue: UnicodeString = ''): UnicodeString; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  iif(const Expr: Boolean; const TrueValue: String;
          const FalseValue: String = ''): String; overload;               {$IFDEF UseInline}inline;{$ENDIF}
function  iif(const Expr: Boolean; const TrueValue: TObject;
          const FalseValue: TObject = nil): TObject; overload;            {$IFDEF UseInline}inline;{$ENDIF}



{                                                                              }
{ Direct comparison                                                            }
{                                                                              }
{   Compare(I1, I2) returns crLess if I1 < I2, crEqual if I1 = I2 or           }
{   crGreater if I1 > I2.                                                      }
{                                                                              }
function  Compare(const I1, I2: Boolean): TCompareResult; overload;
function  Compare(const I1, I2: Integer): TCompareResult; overload;
function  Compare(const I1, I2: Int64): TCompareResult; overload;
function  Compare(const I1, I2: Extended): TCompareResult; overload;
{$IFDEF SupportAnsiString}
function  CompareA(const I1, I2: AnsiString): TCompareResult;
{$ENDIF}
function  CompareB(const I1, I2: RawByteString): TCompareResult;
function  CompareU(const I1, I2: UnicodeString): TCompareResult;
function  CompareChB(const I1, I2: ByteChar): TCompareResult;
function  CompareChW(const I1, I2: WideChar): TCompareResult;

function  Sgn(const A: Int64): Integer; overload;
function  Sgn(const A: Extended): Integer; overload;



{                                                                              }
{ Convert result                                                               }
{                                                                              }
type
  TConvertResult = (
      convertOK,
      convertFormatError,
      convertOverflow
      );



{                                                                              }
{ Integer-String conversions                                                   }
{                                                                              }
const
  StrHexDigitsUpper : String = '0123456789ABCDEF';
  StrHexDigitsLower : String = '0123456789abcdef';

function  ByteCharToInt(const A: ByteChar): Integer;                            {$IFDEF UseInline}inline;{$ENDIF}
function  WideCharToInt(const A: WideChar): Integer;                            {$IFDEF UseInline}inline;{$ENDIF}
function  CharToInt(const A: Char): Integer;                                    {$IFDEF UseInline}inline;{$ENDIF}

function  IntToByteChar(const A: Integer): ByteChar;                            {$IFDEF UseInline}inline;{$ENDIF}
function  IntToWideChar(const A: Integer): WideChar;                            {$IFDEF UseInline}inline;{$ENDIF}
function  IntToChar(const A: Integer): Char;                                    {$IFDEF UseInline}inline;{$ENDIF}

function  IsHexByteChar(const Ch: ByteChar): Boolean;
function  IsHexWideChar(const Ch: WideChar): Boolean;
function  IsHexChar(const Ch: Char): Boolean;                                   {$IFDEF UseInline}inline;{$ENDIF}

function  HexByteCharToInt(const A: ByteChar): Integer;
function  HexWideCharToInt(const A: WideChar): Integer;
function  HexCharToInt(const A: Char): Integer;                                 {$IFDEF UseInline}inline;{$ENDIF}

function  IntToUpperHexByteChar(const A: Integer): ByteChar;
function  IntToUpperHexWideChar(const A: Integer): WideChar;
function  IntToUpperHexChar(const A: Integer): Char;                            {$IFDEF UseInline}inline;{$ENDIF}

function  IntToLowerHexByteChar(const A: Integer): ByteChar;
function  IntToLowerHexWideChar(const A: Integer): WideChar;
function  IntToLowerHexChar(const A: Integer): Char;                            {$IFDEF UseInline}inline;{$ENDIF}

{$IFDEF SupportAnsiString}
function  IntToStringA(const A: Int64): AnsiString;
{$ENDIF}
function  IntToStringB(const A: Int64): RawByteString;
function  IntToStringU(const A: Int64): UnicodeString;
function  IntToString(const A: Int64): String;

{$IFDEF SupportAnsiString}
function  UIntToStringA(const A: NativeUInt): AnsiString;
{$ENDIF}
function  UIntToStringB(const A: NativeUInt): RawByteString;
function  UIntToStringU(const A: NativeUInt): UnicodeString;
function  UIntToString(const A: NativeUInt): String;

{$IFDEF SupportAnsiString}
function  Word32ToStrA(const A: Word32; const Digits: Integer = 0): AnsiString;
{$ENDIF}
function  Word32ToStrB(const A: Word32; const Digits: Integer = 0): RawByteString;
function  Word32ToStrU(const A: Word32; const Digits: Integer = 0): UnicodeString;
function  Word32ToStr(const A: Word32; const Digits: Integer = 0): String;

{$IFDEF SupportAnsiString}
function  Word32ToHexA(const A: Word32; const Digits: Integer = 0; const UpperCase: Boolean = True): AnsiString;
{$ENDIF}
function  Word32ToHexB(const A: Word32; const Digits: Integer = 0; const UpperCase: Boolean = True): RawByteString;
function  Word32ToHexU(const A: Word32; const Digits: Integer = 0; const UpperCase: Boolean = True): UnicodeString;
function  Word32ToHex(const A: Word32; const Digits: Integer = 0; const UpperCase: Boolean = True): String;

{$IFDEF SupportAnsiString}
function  Word32ToOctA(const A: Word32; const Digits: Integer = 0): AnsiString;
{$ENDIF}
function  Word32ToOctB(const A: Word32; const Digits: Integer = 0): RawByteString;
function  Word32ToOctU(const A: Word32; const Digits: Integer = 0): UnicodeString;
function  Word32ToOct(const A: Word32; const Digits: Integer = 0): String;

{$IFDEF SupportAnsiString}
function  Word32ToBinA(const A: Word32; const Digits: Integer = 0): AnsiString;
{$ENDIF}
function  Word32ToBinB(const A: Word32; const Digits: Integer = 0): RawByteString;
function  Word32ToBinU(const A: Word32; const Digits: Integer = 0): UnicodeString;
function  Word32ToBin(const A: Word32; const Digits: Integer = 0): String;

function  TryStringToInt64PB(const BufP: Pointer; const BufLen: Integer; out Value: Int64; out StrLen: Integer): TConvertResult;
function  TryStringToInt64PW(const BufP: Pointer; const BufLen: Integer; out Value: Int64; out StrLen: Integer): TConvertResult;
function  TryStringToInt64P(const BufP: Pointer; const BufLen: Integer; out Value: Int64; out StrLen: Integer): TConvertResult;

{$IFDEF SupportAnsiString}
function  TryStringToInt64A(const S: AnsiString; out A: Int64): Boolean;
{$ENDIF}
function  TryStringToInt64B(const S: RawByteString; out A: Int64): Boolean;
function  TryStringToInt64U(const S: UnicodeString; out A: Int64): Boolean;
function  TryStringToInt64(const S: String; out A: Int64): Boolean;

{$IFDEF SupportAnsiString}
function  StringToInt64DefA(const S: AnsiString; const Default: Int64): Int64;
{$ENDIF}
function  StringToInt64DefB(const S: RawByteString; const Default: Int64): Int64;
function  StringToInt64DefU(const S: UnicodeString; const Default: Int64): Int64;
function  StringToInt64Def(const S: String; const Default: Int64): Int64;

{$IFDEF SupportAnsiString}
function  StringToInt64A(const S: AnsiString): Int64;
{$ENDIF}
function  StringToInt64B(const S: RawByteString): Int64;
function  StringToInt64U(const S: UnicodeString): Int64;
function  StringToInt64(const S: String): Int64;

{$IFDEF SupportAnsiString}
function  TryStringToIntA(const S: AnsiString; out A: Integer): Boolean;
{$ENDIF}
function  TryStringToIntB(const S: RawByteString; out A: Integer): Boolean;
function  TryStringToIntU(const S: UnicodeString; out A: Integer): Boolean;
function  TryStringToInt(const S: String; out A: Integer): Boolean;

{$IFDEF SupportAnsiString}
function  StringToIntDefA(const S: AnsiString; const Default: Integer): Integer;
{$ENDIF}
function  StringToIntDefB(const S: RawByteString; const Default: Integer): Integer;
function  StringToIntDefU(const S: UnicodeString; const Default: Integer): Integer;
function  StringToIntDef(const S: String; const Default: Integer): Integer;

{$IFDEF SupportAnsiString}
function  StringToIntA(const S: AnsiString): Integer;
{$ENDIF}
function  StringToIntB(const S: RawByteString): Integer;
function  StringToIntU(const S: UnicodeString): Integer;
function  StringToInt(const S: String): Integer;

{$IFDEF SupportAnsiString}
function  TryStringToWord32A(const S: AnsiString; out A: Word32): Boolean;
{$ENDIF}
function  TryStringToWord32B(const S: RawByteString; out A: Word32): Boolean;
function  TryStringToWord32U(const S: UnicodeString; out A: Word32): Boolean;
function  TryStringToWord32(const S: String; out A: Word32): Boolean;

{$IFDEF SupportAnsiString}
function  StringToWord32A(const S: AnsiString): Word32;
{$ENDIF}
function  StringToWord32B(const S: RawByteString): Word32;
function  StringToWord32U(const S: UnicodeString): Word32;
function  StringToWord32(const S: String): Word32;

{$IFDEF SupportAnsiString}
function  HexToUIntA(const S: AnsiString): NativeUInt;
{$ENDIF}
function  HexToUIntB(const S: RawByteString): NativeUInt;
function  HexToUIntU(const S: UnicodeString): NativeUInt;
function  HexToUInt(const S: String): NativeUInt;

{$IFDEF SupportAnsiString}
function  TryHexToWord32A(const S: AnsiString; out A: Word32): Boolean;
{$ENDIF}
function  TryHexToWord32B(const S: RawByteString; out A: Word32): Boolean;
function  TryHexToWord32U(const S: UnicodeString; out A: Word32): Boolean;
function  TryHexToWord32(const S: String; out A: Word32): Boolean;

{$IFDEF SupportAnsiString}
function  HexToWord32A(const S: AnsiString): Word32;
{$ENDIF}
function  HexToWord32B(const S: RawByteString): Word32;
function  HexToWord32U(const S: UnicodeString): Word32;
function  HexToWord32(const S: String): Word32;

{$IFDEF SupportAnsiString}
function  TryOctToWord32A(const S: AnsiString; out A: Word32): Boolean;
{$ENDIF}
function  TryOctToWord32B(const S: RawByteString; out A: Word32): Boolean;
function  TryOctToWord32U(const S: UnicodeString; out A: Word32): Boolean;
function  TryOctToWord32(const S: String; out A: Word32): Boolean;

{$IFDEF SupportAnsiString}
function  OctToWord32A(const S: AnsiString): Word32;
{$ENDIF}
function  OctToWord32B(const S: RawByteString): Word32;
function  OctToWord32U(const S: UnicodeString): Word32;
function  OctToWord32(const S: String): Word32;

{$IFDEF SupportAnsiString}
function  TryBinToWord32A(const S: AnsiString; out A: Word32): Boolean;
{$ENDIF}
function  TryBinToWord32B(const S: RawByteString; out A: Word32): Boolean;
function  TryBinToWord32U(const S: UnicodeString; out A: Word32): Boolean;
function  TryBinToWord32(const S: String; out A: Word32): Boolean;

{$IFDEF SupportAnsiString}
function  BinToWord32A(const S: AnsiString): Word32;
{$ENDIF}
function  BinToWord32B(const S: RawByteString): Word32;
function  BinToWord32U(const S: UnicodeString): Word32;
function  BinToWord32(const S: String): Word32;

{$IFDEF SupportAnsiString}
function  BytesToHexA(const P: Pointer; const Count: Integer;
          const UpperCase: Boolean = True): AnsiString;
{$ENDIF}



{                                                                              }
{ Network byte order                                                           }
{                                                                              }
function  hton16(const A: Word): Word;
function  ntoh16(const A: Word): Word;
function  hton32(const A: Word32): Word32;
function  ntoh32(const A: Word32): Word32;
function  hton64(const A: Int64): Int64;
function  ntoh64(const A: Int64): Int64;



{                                                                              }
{ Pointer-String conversions                                                   }
{                                                                              }
{$IFDEF SupportAnsiString}
function  PointerToStrA(const P: Pointer): AnsiString;
{$ENDIF}
function  PointerToStrB(const P: Pointer): RawByteString;
function  PointerToStrU(const P: Pointer): UnicodeString;
function  PointerToStr(const P: Pointer): String;

{$IFDEF SupportAnsiString}
function  StrToPointerA(const S: AnsiString): Pointer;
{$ENDIF}
function  StrToPointerB(const S: RawByteString): Pointer;
function  StrToPointerU(const S: UnicodeString): Pointer;
function  StrToPointer(const S: String): Pointer;

{$IFDEF SupportInterface}
{$IFDEF SupportAnsiString}
function  InterfaceToStrA(const I: IInterface): AnsiString;
{$ENDIF}
function  InterfaceToStrB(const I: IInterface): RawByteString;
function  InterfaceToStrU(const I: IInterface): UnicodeString;
function  InterfaceToStr(const I: IInterface): String;
{$ENDIF}

function  ObjectClassName(const O: TObject): String;
function  ClassClassName(const C: TClass): String;
function  ObjectToStr(const O: TObject): String;



{                                                                              }
{ Hashing functions                                                            }
{                                                                              }
{   HashBuf uses a every byte in the buffer to calculate a hash.               }
{                                                                              }
{   HashStr is a general purpose string hashing function.                      }
{                                                                              }
{   If Slots = 0 the hash value is in the Word32 range (0-$FFFFFFFF),          }
{   otherwise the value is in the range from 0 to Slots-1. Note that the       }
{   'mod' operation, which is used when Slots <> 0, is comparitively slow.     }
{                                                                              }
function  HashBuf(const Hash: Word32; const Buf; const BufSize: Integer): Word32;

{$IFDEF SupportAnsiString}
function  HashStrA(const S: AnsiString;
          const Index: Integer = 1; const Count: Integer = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: Word32 = 0): Word32;
{$ENDIF}
function  HashStrB(const S: RawByteString;
          const Index: Integer = 1; const Count: Integer = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: Word32 = 0): Word32;
function  HashStrU(const S: UnicodeString;
          const Index: Integer = 1; const Count: Integer = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: Word32 = 0): Word32;
function  HashStr(const S: String;
          const Index: Integer = 1; const Count: Integer = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: Word32 = 0): Word32;

function  HashInteger(const I: Integer; const Slots: Word32 = 0): Word32;
function  HashWord32(const I: Word32; const Slots: Word32 = 0): Word32;



{                                                                              }
{ Memory operations                                                            }
{                                                                              }
const
  Bytes1KB  = 1024;
  Bytes1MB  = 1024 * Bytes1KB;
  Bytes1GB  = 1024 * Bytes1MB;
  Bytes64KB = 64 * Bytes1KB;
  Bytes64MB = 64 * Bytes1MB;
  Bytes2GB  = 2 * Word32(Bytes1GB);

{$IFDEF ASM386_DELPHI}{$IFNDEF DELPHI2006_UP}
  {$DEFINE UseAsmMemFunction}
{$ENDIF}{$ENDIF}
{$IFDEF UseInline}{$IFNDEF UseAsmMemFunction}
  {$DEFINE InlineMemFunction}
{$ENDIF}{$ENDIF}

procedure FillMem(var Buf; const Count: Integer; const Value: Byte); {$IFDEF InlineMemFunction}inline;{$ENDIF}
procedure ZeroMem(var Buf; const Count: Integer);                    {$IFDEF InlineMemFunction}inline;{$ENDIF}
procedure GetZeroMem(var P: Pointer; const Size: Integer);           {$IFDEF InlineMemFunction}inline;{$ENDIF}
procedure MoveMem(const Source; var Dest; const Count: Integer);     {$IFDEF InlineMemFunction}inline;{$ENDIF}
function  EqualMem(const Buf1; const Buf2; const Count: Integer): Boolean;
function  EqualMemNoAsciiCase(const Buf1; const Buf2; const Count: Integer): Boolean;
function  CompareMem(const Buf1; const Buf2; const Count: Integer): Integer;
function  CompareMemNoAsciiCase(const Buf1; const Buf2; const Count: Integer): Integer;
function  LocateMem(const Buf1; const Size1: Integer; const Buf2; const Size2: Integer): Integer;
function  LocateMemNoAsciiCase(const Buf1; const Size1: Integer; const Buf2; const Size2: Integer): Integer;
procedure ReverseMem(var Buf; const Size: Integer);



{                                                                              }
{ IInterface                                                                   }
{                                                                              }
{$IFDEF DELPHI5_DOWN}
type
  IInterface = interface
    ['{00000000-0000-0000-C000-000000000046}']
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;
{$ENDIF}



{                                                                              }
{ Dynamic arrays                                                               }
{                                                                              }
procedure FreeObjectArray(var V); overload;
procedure FreeObjectArray(var V; const LoIdx, HiIdx: Integer); overload;
procedure FreeAndNilObjectArray(var V: ObjectArray);



{                                                                              }
{ TBytes functions                                                             }
{                                                                              }
procedure BytesSetLengthAndZero(var V: TBytes; const NewLength: Integer);

procedure BytesInit(var V: TBytes; const R: Byte); overload;
procedure BytesInit(var V: TBytes; const S: String); overload;

function  BytesAppend(var V: TBytes; const R: Byte): Integer; overload;
function  BytesAppend(var V: TBytes; const R: TBytes): Integer; overload;
function  BytesAppend(var V: TBytes; const R: array of Byte): Integer; overload;
function  BytesAppend(var V: TBytes; const R: String): Integer; overload;

function  BytesCompare(const A, B: TBytes): Integer;

function  BytesEqual(const A, B: TBytes): Boolean;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF UTILS_TEST}
procedure Test;
{$ENDIF}



implementation

uses
  { System }
  Math;



{                                                                              }
{ CPU identification                                                           }
{                                                                              }
{$IFDEF ASM386_DELPHI}
var
  CPUIDInitialised : Boolean = False;
  CPUIDSupport     : Boolean = False;
  MMXSupport       : Boolean = False;

procedure InitialiseCPUID; assembler;
asm
      // Set CPUID flag
      PUSHFD
      POP     EAX
      OR      EAX, $200000
      PUSH    EAX
      POPFD

      // Check if CPUID flag is still set
      PUSHFD
      POP     EAX
      AND     EAX, $200000
      JNZ     @CPUIDSupported

      // CPUID not supported
      MOV     BYTE PTR [CPUIDSupport], 0
      MOV     BYTE PTR [MMXSupport], 0
      JMP     @CPUIDFin

      // CPUID supported
  @CPUIDSupported:
      MOV     BYTE PTR [CPUIDSupport], 1

      PUSH    EBX

      // Perform CPUID function 1
      MOV     EAX, 1
      {$IFDEF DELPHI5_DOWN}
      DW      0FA2h
      {$ELSE}
      CPUID
      {$ENDIF}

      // Check if MMX feature flag is set
      AND     EDX, $800000
      SETNZ   AL
      MOV     BYTE PTR [MMXSupport], AL

      POP     EBX

  @CPUIDFin:
      MOV     BYTE PTR [CPUIDInitialised], 1
end;
{$ENDIF}



{                                                                              }
{ Range check error                                                            }
{                                                                              }

resourcestring
  SRangeCheckError = 'Range check error';

procedure RaiseRangeCheckError; {$IFDEF UseInline}inline;{$ENDIF}
begin
  raise ERangeError.Create(SRangeCheckError);
end;



{                                                                              }
{ Integer                                                                      }
{                                                                              }
function MinInt(const A, B: Integer): Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function MaxInt(const A, B: Integer): Integer;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function MinCrd(const A, B: Cardinal): Cardinal;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function MaxCrd(const A, B: Cardinal): Cardinal;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Int32Bounded(const Value: Int32; const Min, Max: Int32): Int32;
begin
  if Value < Min then
    Result := Min else
  if Value > Max then
    Result := Max
  else
    Result := Value;
end;

function Int64Bounded(const Value: Int64; const Min, Max: Int64): Int64;
begin
  if Value < Min then
    Result := Min else
  if Value > Max then
    Result := Max
  else
    Result := Value;
end;

function Int32BoundedByte(const Value: Int32): Int32;
begin
  if Value < MinByte then
    Result := MinByte else
  if Value > MaxByte then
    Result := MaxByte
  else
    Result := Value;
end;

function Int64BoundedByte(const Value: Int64): Int64;
begin
  if Value < MinByte then
    Result := MinByte else
  if Value > MaxByte then
    Result := MaxByte
  else
    Result := Value;
end;

function Int32BoundedWord(const Value: Int32): Int32;
begin
  if Value < MinWord then
    Result := MinWord else
  if Value > MaxWord then
    Result := MaxWord
  else
    Result := Value;
end;

function Int64BoundedWord(const Value: Int64): Int64;
begin
  if Value < MinWord then
    Result := MinWord else
  if Value > MaxWord then
    Result := MaxWord
  else
    Result := Value;
end;

function Int64BoundedWord32(const Value: Int64): Word32;
begin
  if Value < MinWord32 then
    Result := MinWord32 else
  if Value > MaxWord32 then
    Result := MaxWord32
  else
    Result := Word32(Value);
end;



{                                                                              }
{ String construction from buffer                                              }
{                                                                              }
{$IFDEF SupportAnsiString}
function StrPToStrA(const P: PAnsiChar; const L: Integer): AnsiString;
begin
  if L <= 0 then
    SetLength(Result, 0)
  else
    begin
      SetLength(Result, L);
      MoveMem(P^, Pointer(Result)^, L);
    end;
end;
{$ENDIF}

function StrPToStrB(const P: Pointer; const L: Integer): RawByteString;
begin
  if L <= 0 then
    SetLength(Result, 0)
  else
    begin
      SetLength(Result, L);
      MoveMem(P^, Pointer(Result)^, L);
    end;
end;

function StrPToStrU(const P: PWideChar; const L: Integer): UnicodeString;
begin
  if L <= 0 then
    SetLength(Result, 0)
  else
    begin
      SetLength(Result, L);
      MoveMem(P^, Pointer(Result)^, L * SizeOf(WideChar));
    end;
end;

function StrPToStr(const P: PChar; const L: Integer): String;
begin
  if L <= 0 then
    SetLength(Result, 0)
  else
    begin
      SetLength(Result, L);
      MoveMem(P^, Pointer(Result)^, L * SizeOf(Char));
    end;
end;



{                                                                              }
{ String construction from zero terminated buffer                              }
{                                                                              }
function StrZLenA(const S: Pointer): Integer;
var P : PByteChar;
begin
  if not Assigned(S) then
    Result := 0
  else
    begin
      Result := 0;
      P := S;
      while Ord(P^) <> 0 do
        begin
          Inc(Result);
          Inc(P);
        end;
    end;
end;

function StrZLenW(const S: PWideChar): Integer;
var P : PWideChar;
begin
  if not Assigned(S) then
    Result := 0
  else
    begin
      Result := 0;
      P := S;
      while P^ <> #0 do
        begin
          Inc(Result);
          Inc(P);
        end;
    end;
end;

function StrZLen(const S: PChar): Integer;
var P : PChar;
begin
  if not Assigned(S) then
    Result := 0
  else
    begin
      Result := 0;
      P := S;
      while P^ <> #0 do
        begin
          Inc(Result);
          Inc(P);
        end;
    end;
end;

{$IFDEF SupportAnsiString}
function StrZPasA(const A: PAnsiChar): AnsiString;
var I, L : Integer;
    P : PAnsiChar;
begin
  L := StrZLenA(A);
  SetLength(Result, L);
  if L = 0 then
    exit;
  I := 0;
  P := A;
  while I < L do
    begin
      Result[I + 1] := P^;
      Inc(I);
      Inc(P);
    end;
end;
{$ENDIF}

function StrZPasB(const A: PByteChar): RawByteString;
var I, L : Integer;
    P : PByteChar;
begin
  L := StrZLenA(A);
  SetLength(Result, L);
  if L = 0 then
    exit;
  I := 0;
  P := A;
  while I < L do
    begin
      Result[I + 1] := P^;
      Inc(I);
      Inc(P);
    end;
end;

function StrZPasU(const A: PWideChar): UnicodeString;
var I, L : Integer;
begin
  L := StrZLenW(A);
  SetLength(Result, L);
  if L = 0 then
    exit;
  I := 0;
  while I < L do
    begin
      Result[I + 1] := A[I];
      Inc(I);
    end;
end;

function StrZPas(const A: PChar): String;
var I, L : Integer;
begin
  L := StrZLen(A);
  SetLength(Result, L);
  if L = 0 then
    exit;
  I := 0;
  while I < L do
    begin
      Result[I + 1] := A[I];
      Inc(I);
    end;
end;



{                                                                              }
{ RawByteString conversion functions                                           }
{                                                                              }

resourcestring
  SRawByteStringConvertError = 'RawByteString conversion error';

procedure RawByteBufToWideBuf(const Buf: Pointer; const BufSize: Integer;
    const DestBuf: Pointer);
var I : Integer;
    P : Pointer;
    Q : Pointer;
    V : Word32;
begin
  if BufSize <= 0 then
    exit;
  P := Buf;
  Q := DestBuf;
  for I := 1 to BufSize div 4 do
    begin
      // convert 4 characters per iteration
      V := PWord32(P)^;
      Inc(PWord32(P));
      PWord32(Q)^ := (V and $FF) or ((V and $FF00) shl 8);
      Inc(PWord32(Q));
      V := V shr 16;
      PWord32(Q)^ := (V and $FF) or ((V and $FF00) shl 8);
      Inc(PWord32(Q));
    end;
  // convert remaining (<4)
  for I := 1 to BufSize mod 4 do
    begin
      PWord(Q)^ := PByte(P)^;
      Inc(PByte(P));
      Inc(PWord(Q));
    end;
end;

function RawByteStrPtrToUnicodeString(const S: Pointer; const Len: Integer): UnicodeString;
begin
  if Len <= 0 then
    Result := ''
  else
    begin
      SetLength(Result, Len);
      RawByteBufToWideBuf(S, Len, PWideChar(Result));
    end;
end;

function RawByteStringToUnicodeString(const S: RawByteString): UnicodeString;
var L : Integer;
begin
  L := Length(S);
  SetLength(Result, L);
  if L > 0 then
    RawByteBufToWideBuf(Pointer(S), L, PWideChar(Result));
end;

procedure WideBufToRawByteBuf(const Buf: Pointer; const Len: Integer;
    const DestBuf: Pointer);
var I : Integer;
    S : PWideChar;
    Q : PByte;
    V : Word32;
    W : Word;
begin
  if Len <= 0 then
    exit;
  S := Buf;
  Q := DestBuf;
  for I := 1 to Len div 2 do
    begin
      // convert 2 characters per iteration
      V := PWord32(S)^;
      if V and $FF00FF00 <> 0 then
        raise EConvertError.Create(SRawByteStringConvertError);
      Q^ := Byte(V);
      Inc(Q);
      Q^ := Byte(V shr 16);
      Inc(Q);
      Inc(S, 2);
    end;
  // convert remaining character
  if Len mod 2 = 1 then
    begin
      W := Ord(S^);
      if W > $FF then
        raise EConvertError.Create(SRawByteStringConvertError);
      Q^ := Byte(W);
    end;
end;

function WideBufToRawByteString(const P: PWideChar; const Len: Integer): RawByteString;
var I : Integer;
    S : PWideChar;
    Q : PByte;
    V : WideChar;
begin
  if Len <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, Len);
  S := P;
  Q := Pointer(Result);
  for I := 1 to Len do
    begin
      V := S^;
      if Ord(V) > $FF then
        raise EConvertError.Create(SRawByteStringConvertError);
      Q^ := Byte(V);
      Inc(S);
      Inc(Q);
    end;
end;

function UnicodeStringToRawByteString(const S: UnicodeString): RawByteString;
begin
  Result := WideBufToRawByteString(PWideChar(S), Length(S));
end;



{                                                                              }
{ String conversion functions                                                  }
{                                                                              }
{$IFDEF SupportAnsiString}
function ToAnsiString(const A: String): AnsiString;
begin
  {$IFDEF StringIsUnicode}
  Result := AnsiString(A);
  {$ELSE}
  Result := A;
  {$ENDIF}
end;
{$ENDIF}

function ToRawByteString(const A: String): RawByteString;
begin
  {$IFDEF StringIsUnicode}
  Result := RawByteString(A);
  {$ELSE}
  Result := A;
  {$ENDIF}
end;

function ToUnicodeString(const A: String): UnicodeString;
begin
  Result := UnicodeString(A);
end;



{                                                                              }
{ String internals functions                                                   }
{                                                                              }
{$IFNDEF SupportStringRefCount}
{$IFDEF DELPHI}
function StringRefCount(const S: UnicodeString): Integer;
var P : PInt32;
begin
  P := Pointer(S);
  if not Assigned(P) then
    Result := 0
  else
    begin
      Dec(P, 2);
      Result := P^;
    end;
end;

function StringRefCount(const S: RawByteString): Integer;
var P : PInt32;
begin
  P := Pointer(S);
  if not Assigned(P) then
    Result := 0
  else
    begin
      Dec(P, 2);
      Result := P^;
    end;
end;
{$ENDIF}
{$ENDIF}



{                                                                              }
{ String append functions                                                      }
{                                                                              }
{$IFDEF SupportAnsiString}
procedure StrAppendChA(var A: AnsiString; const C: AnsiChar);
begin
  A := A + C;
end;
{$ENDIF}

procedure StrAppendChB(var A: RawByteString; const C: ByteChar);
begin
  A := A + C;
end;

procedure StrAppendChU(var A: UnicodeString; const C: WideChar);
begin
  A := A + C;
end;

procedure StrAppendCh(var A: String; const C: Char);
begin
  A := A + C;
end;



{                                                                              }
{ ByteCharSet functions                                                        }
{                                                                              }
function WideCharInCharSet(const A: WideChar; const C: ByteCharSet): Boolean;
begin
  if Ord(A) >= $100 then
    Result := False
  else
    Result := ByteChar(Ord(A)) in C;
end;

function CharInCharSet(const A: Char; const C: ByteCharSet): Boolean;
begin
  {$IFDEF CharIsWide}
  if Ord(A) >= $100 then
    Result := False
  else
    Result := ByteChar(Ord(A)) in C;
  {$ELSE}
  Result := A in C;
  {$ENDIF}
end;



{                                                                              }
{ Compare                                                                      }
{                                                                              }
function CharCompareB(const A, B: ByteChar): Integer;
begin
  if Ord(A) < Ord(B) then
    Result := -1 else
    if Ord(A) > Ord(B) then
      Result := 1
    else
      Result := 0;
end;

function CharCompareW(const A, B: WideChar): Integer;
begin
  if Ord(A) < Ord(B) then
    Result := -1 else
    if Ord(A) > Ord(B) then
      Result := 1
    else
      Result := 0;
end;

function CharCompare(const A, B: Char): Integer;
begin
  {$IFDEF CharIsWide}
  Result := CharCompareW(A, B);
  {$ELSE}
  Result := CharCompareB(A, B);
  {$ENDIF}
end;

function StrPCompareB(const A, B: Pointer; const Len: Integer): Integer;
var P, Q : PByte;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      if P^ = Q^ then
        begin
          Inc(P);
          Inc(Q);
        end
      else
        begin
          if Ord(P^) < Ord(Q^) then
            Result := -1
          else
            Result := 1;
          exit;
        end;
  Result := 0;
end;

function StrPCompareW(const A, B: PWideChar; const Len: Integer): Integer;
var P, Q : PWideChar;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      if Ord(P^) = Ord(Q^) then
        begin
          Inc(P);
          Inc(Q);
        end
      else
        begin
          if Ord(P^) < Ord(Q^) then
            Result := -1
          else
            Result := 1;
          exit;
        end;
  Result := 0;
end;

function StrPCompare(const A, B: PChar; const Len: Integer): Integer;
var P, Q : PChar;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      if Ord(P^) = Ord(Q^) then
        begin
          Inc(P);
          Inc(Q);
        end
      else
        begin
          if Ord(P^) < Ord(Q^) then
            Result := -1
          else
            Result := 1;
          exit;
        end;
  Result := 0;
end;


{$IFDEF SupportAnsiString}
function StrCompareA(const A, B: AnsiString): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareB(Pointer(A), Pointer(B), I);
  if Result <> 0 then
    exit;
  if L = M then
    Result := 0 else
  if L < M then
    Result := -1
  else
    Result := 1;
end;
{$ENDIF}

function StrCompareB(const A, B: RawByteString): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareB(Pointer(A), Pointer(B), I);
  if Result <> 0 then
    exit;
  if L = M then
    Result := 0 else
  if L < M then
    Result := -1
  else
    Result := 1;
end;

function StrCompareU(const A, B: UnicodeString): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareW(Pointer(A), Pointer(B), I);
  if Result <> 0 then
    exit;
  if L = M then
    Result := 0 else
  if L < M then
    Result := -1
  else
    Result := 1;
end;

function StrCompare(const A, B: String): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompare(Pointer(A), Pointer(B), I);
  if Result <> 0 then
    exit;
  if L = M then
    Result := 0 else
  if L < M then
    Result := -1
  else
    Result := 1;
end;



{                                                                              }
{ Swap                                                                         }
{                                                                              }
{$IFDEF ASM386_DELPHI}
procedure Swap(var X, Y: Boolean); register; assembler;
asm
      MOV     CL, [EDX]
      XCHG    BYTE PTR [EAX], CL
      MOV     [EDX], CL
end;
{$ELSE}
procedure Swap(var X, Y: Boolean);
var F : Boolean;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure Swap(var X, Y: Byte); register; assembler;
asm
      MOV     CL, [EDX]
      XCHG    BYTE PTR [EAX], CL
      MOV     [EDX], CL
end;
{$ELSE}
procedure Swap(var X, Y: Byte);
var F : Byte;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure Swap(var X, Y: ShortInt); register; assembler;
asm
      MOV     CL, [EDX]
      XCHG    BYTE PTR [EAX], CL
      MOV     [EDX], CL
end;
{$ELSE}
procedure Swap(var X, Y: ShortInt);
var F : ShortInt;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure Swap(var X, Y: Word); register; assembler;
asm
      MOV     CX, [EDX]
      XCHG    WORD PTR [EAX], CX
      MOV     [EDX], CX
end;
{$ELSE}
procedure Swap(var X, Y: Word);
var F : Word;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure Swap(var X, Y: SmallInt); register; assembler;
asm
      MOV     CX, [EDX]
      XCHG    WORD PTR [EAX], CX
      MOV     [EDX], CX
end;
{$ELSE}
procedure Swap(var X, Y: SmallInt);
var F : SmallInt;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure Swap(var X, Y: Int32); register; assembler;
asm
      MOV     ECX, [EDX]
      XCHG    [EAX], ECX
      MOV     [EDX], ECX
end;
{$ELSE}
procedure Swap(var X, Y: Int32);
var F : Int32;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure Swap(var X, Y: Word32); register; assembler;
asm
      MOV     ECX, [EDX]
      XCHG    [EAX], ECX
      MOV     [EDX], ECX
end;
{$ELSE}
procedure Swap(var X, Y: Word32);
var F : Word32;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure Swap(var X, Y: Pointer); register; assembler;
asm
      MOV     ECX, [EDX]
      XCHG    [EAX], ECX
      MOV     [EDX], ECX
end;
{$ELSE}
procedure Swap(var X, Y: Pointer);
var F : Pointer;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure Swap(var X, Y: TObject); register; assembler;
asm
      MOV     ECX, [EDX]
      XCHG    [EAX], ECX
      MOV     [EDX], ECX
end;
{$ELSE}
procedure Swap(var X, Y: TObject);
var F : TObject;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

procedure Swap(var X, Y: Int64);
var F : Int64;
begin
  F := X;
  X := Y;
  Y := F;
end;

procedure SwapLW(var X, Y: LongWord);
var F : LongWord;
begin
  F := X;
  X := Y;
  Y := F;
end;

procedure SwapLI(var X, Y: LongInt);
var F : LongInt;
begin
  F := X;
  X := Y;
  Y := F;
end;

procedure SwapInt(var X, Y: Integer);
var F : Integer;
begin
  F := X;
  X := Y;
  Y := F;
end;

procedure SwapCrd(var X, Y: Cardinal);
var F : Cardinal;
begin
  F := X;
  X := Y;
  Y := F;
end;

procedure Swap(var X, Y: Single);
var F : Single;
begin
  F := X;
  X := Y;
  Y := F;
end;

procedure Swap(var X, Y: Double);
var F : Double;
begin
  F := X;
  X := Y;
  Y := F;
end;

procedure SwapExt(var X, Y: Extended);
var F : Extended;
begin
  F := X;
  X := Y;
  Y := F;
end;

procedure Swap(var X, Y: Currency);
var F : Currency;
begin
  F := X;
  X := Y;
  Y := F;
end;

{$IFDEF SupportAnsiString}
procedure SwapA(var X, Y: AnsiString);
var F : AnsiString;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

procedure SwapB(var X, Y: RawByteString);
var F : RawByteString;
begin
  F := X;
  X := Y;
  Y := F;
end;

procedure SwapU(var X, Y: UnicodeString);
var F : UnicodeString;
begin
  F := X;
  X := Y;
  Y := F;
end;

procedure Swap(var X, Y: String);
var F : String;
begin
  F := X;
  X := Y;
  Y := F;
end;

{$IFDEF ASM386_DELPHI}
procedure SwapObjects(var X, Y); register; assembler;
asm
      MOV     ECX, [EDX]
      XCHG    [EAX], ECX
      MOV     [EDX], ECX
end;
{$ELSE}
procedure SwapObjects(var X, Y);
var F: TObject;
begin
  F := TObject(X);
  TObject(X) := TObject(Y);
  TObject(Y) := F;
end;
{$ENDIF}



{                                                                              }
{ iif                                                                          }
{                                                                              }
function iif(const Expr: Boolean; const TrueValue, FalseValue: Integer): Integer;
begin
  if Expr then
    Result := TrueValue
  else
    Result := FalseValue;
end;

function iif(const Expr: Boolean; const TrueValue, FalseValue: Int64): Int64;
begin
  if Expr then
    Result := TrueValue
  else
    Result := FalseValue;
end;

function iif(const Expr: Boolean; const TrueValue, FalseValue: Extended): Extended;
begin
  if Expr then
    Result := TrueValue
  else
    Result := FalseValue;
end;

function iif(const Expr: Boolean; const TrueValue, FalseValue: String): String;
begin
  if Expr then
    Result := TrueValue
  else
    Result := FalseValue;
end;

{$IFDEF SupportAnsiString}
function iifA(const Expr: Boolean; const TrueValue, FalseValue: AnsiString): AnsiString;
begin
  if Expr then
    Result := TrueValue
  else
    Result := FalseValue;
end;
{$ENDIF}

function iifB(const Expr: Boolean; const TrueValue, FalseValue: RawByteString): RawByteString;
begin
  if Expr then
    Result := TrueValue
  else
    Result := FalseValue;
end;

function iifU(const Expr: Boolean; const TrueValue, FalseValue: UnicodeString): UnicodeString;
begin
  if Expr then
    Result := TrueValue
  else
    Result := FalseValue;
end;

function iif(const Expr: Boolean; const TrueValue, FalseValue: TObject): TObject;
begin
  if Expr then
    Result := TrueValue
  else
    Result := FalseValue;
end;




{                                                                              }
{ Compare                                                                      }
{                                                                              }
function InverseCompareResult(const C: TCompareResult): TCompareResult;
begin
  if C = crLess then
    Result := crGreater else
  if C = crGreater then
    Result := crLess
  else
    Result := C;
end;

function Compare(const I1, I2: Integer): TCompareResult;
begin
  if I1 < I2 then
    Result := crLess else
  if I1 > I2 then
    Result := crGreater
  else
    Result := crEqual;
end;

function Compare(const I1, I2: Int64): TCompareResult;
begin
  if I1 < I2 then
    Result := crLess else
  if I1 > I2 then
    Result := crGreater
  else
    Result := crEqual;
end;

function Compare(const I1, I2: Extended): TCompareResult;
begin
  if I1 < I2 then
    Result := crLess else
  if I1 > I2 then
    Result := crGreater
  else
    Result := crEqual;
end;

function Compare(const I1, I2: Boolean): TCompareResult;
begin
  if I1 = I2 then
    Result := crEqual else
  if I1 then
    Result := crGreater
  else
    Result := crLess;
end;

{$IFDEF SupportAnsiString}
function CompareA(const I1, I2: AnsiString): TCompareResult;
begin
  case StrCompareA(I1, I2) of
    -1 : Result := crLess;
     1 : Result := crGreater;
  else
    Result := crEqual;
  end;
end;
{$ENDIF}

function CompareB(const I1, I2: RawByteString): TCompareResult;
begin
  case StrCompareB(I1, I2) of
    -1 : Result := crLess;
     1 : Result := crGreater;
  else
    Result := crEqual;
  end;
end;

function CompareU(const I1, I2: UnicodeString): TCompareResult;
begin
  if I1 = I2 then
    Result := crEqual else
  if I1 > I2 then
    Result := crGreater
  else
    Result := crLess;
end;

function CompareChB(const I1, I2: ByteChar): TCompareResult;
begin
  if I1 = I2 then
    Result := crEqual else
  if I1 > I2 then
    Result := crGreater
  else
    Result := crLess;
end;

function CompareChW(const I1, I2: WideChar): TCompareResult;
begin
  if I1 = I2 then
    Result := crEqual else
  if I1 > I2 then
    Result := crGreater
  else
    Result := crLess;
end;

function Sgn(const A: Int64): Integer;
begin
  if A < 0 then
    Result := -1 else
  if A > 0 then
    Result := 1
  else
    Result := 0;
end;

function Sgn(const A: Extended): Integer;
begin
  if A < 0 then
    Result := -1 else
  if A > 0 then
    Result := 1
  else
    Result := 0;
end;



{                                                                              }
{ Ascii char conversion lookup                                                 }
{                                                                              }
const
  HexLookup: array[Byte] of Byte = (
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      0,   1,   2,   3,   4,   5,   6,   7,   8,   9,   $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, 10,  11,  12,  13,  14,  15,  $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, 10,  11,  12,  13,  14,  15,  $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
      $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF);



{                                                                              }
{ Integer-String conversions                                                   }
{                                                                              }
function ByteCharToInt(const A: ByteChar): Integer;
begin
  if A in [ByteChar(Ord('0'))..ByteChar(Ord('9'))] then
    Result := Ord(A) - Ord('0')
  else
    Result := -1;
end;

function WideCharToInt(const A: WideChar): Integer;
begin
  if (Ord(A) >= Ord('0')) and (Ord(A) <= Ord('9')) then
    Result := Ord(A) - Ord('0')
  else
    Result := -1;
end;

function CharToInt(const A: Char): Integer;
begin
  {$IFDEF CharIsWide}
  Result := WideCharToInt(A);
  {$ELSE}
  Result := ByteCharToInt(A);
  {$ENDIF}
end;

function IntToByteChar(const A: Integer): ByteChar;
begin
  if (A < 0) or (A > 9) then
    Result := ByteChar($00)
  else
    Result := ByteChar(48 + A);
end;

function IntToWideChar(const A: Integer): WideChar;
begin
  if (A < 0) or (A > 9) then
    Result := WideChar($00)
  else
    Result := WideChar(48 + A);
end;

function IntToChar(const A: Integer): Char;
begin
  {$IFDEF CharIsWide}
  Result := IntToWideChar(A);
  {$ELSE}
  Result := IntToByteChar(A);
  {$ENDIF}
end;

function IsHexByteChar(const Ch: ByteChar): Boolean;
begin
  Result := HexLookup[Ord(Ch)] <= 15;
end;

function IsHexWideChar(const Ch: WideChar): Boolean;
begin
  if Ord(Ch) <= $FF then
    Result := HexLookup[Ord(Ch)] <= 15
  else
    Result := False;
end;

function IsHexChar(const Ch: Char): Boolean;
begin
  {$IFDEF CharIsWide}
  Result := IsHexWideChar(Ch);
  {$ELSE}
  Result := IsHexByteChar(Ch);
  {$ENDIF}
end;

function HexByteCharToInt(const A: ByteChar): Integer;
var B : Byte;
begin
  B := HexLookup[Ord(A)];
  if B = $FF then
    Result := -1
  else
    Result := B;
end;

function HexWideCharToInt(const A: WideChar): Integer;
var B : Byte;
begin
  if Ord(A) > $FF then
    Result := -1
  else
    begin
      B := HexLookup[Ord(A)];
      if B = $FF then
        Result := -1
      else
        Result := B;
    end;
end;

function HexCharToInt(const A: Char): Integer;
begin
  {$IFDEF CharIsWide}
  Result := HexWideCharToInt(A);
  {$ELSE}
  Result := HexByteCharToInt(A);
  {$ENDIF}
end;

function IntToUpperHexByteChar(const A: Integer): ByteChar;
begin
  if (A < 0) or (A > 15) then
    Result := ByteChar($00)
  else
  if A <= 9 then
    Result := ByteChar(48 + A)
  else
    Result := ByteChar(55 + A);
end;

function IntToUpperHexWideChar(const A: Integer): WideChar;
begin
  if (A < 0) or (A > 15) then
    Result := #$00
  else
  if A <= 9 then
    Result := WideChar(48 + A)
  else
    Result := WideChar(55 + A);
end;

function IntToUpperHexChar(const A: Integer): Char;
begin
  {$IFDEF CharIsWide}
  Result := IntToUpperHexWideChar(A);
  {$ELSE}
  Result := IntToUpperHexByteChar(A);
  {$ENDIF}
end;

function IntToLowerHexByteChar(const A: Integer): ByteChar;
begin
  if (A < 0) or (A > 15) then
    Result := ByteChar($00)
  else
  if A <= 9 then
    Result := ByteChar(48 + A)
  else
    Result := ByteChar(87 + A);
end;

function IntToLowerHexWideChar(const A: Integer): WideChar;
begin
  if (A < 0) or (A > 15) then
    Result := #$00
  else
  if A <= 9 then
    Result := WideChar(48 + A)
  else
    Result := WideChar(87 + A);
end;

function IntToLowerHexChar(const A: Integer): Char;
begin
  {$IFDEF CharIsWide}
  Result := IntToLowerHexWideChar(A);
  {$ELSE}
  Result := IntToLowerHexByteChar(A);
  {$ENDIF}
end;

{$IFDEF SupportAnsiString}
function IntToStringA(const A: Int64): AnsiString;
var T : Int64;
    L, I : Integer;
begin
  // special cases
  if A = 0 then
    begin
      Result := ToAnsiString('0');
      exit;
    end;
  if A = MinInt64 then
    begin
      Result := ToAnsiString('-9223372036854775808');
      exit;
    end;
  // calculate string length
  if A < 0 then
    L := 1
  else
    L := 0;
  T := A;
  while T <> 0 do
    begin
      T := T div 10;
      Inc(L);
    end;
  // convert
  SetLength(Result, L);
  I := 0;
  T := A;
  if T < 0 then
    begin
      Result[1] := ByteChar(Ord('-'));
      T := -T;
    end;
  while T > 0 do
    begin
      Result[L - I] := IntToByteChar(T mod 10);
      T := T div 10;
      Inc(I);
    end;
end;
{$ENDIF}

function IntToStringB(const A: Int64): RawByteString;
var T : Int64;
    L, I : Integer;
begin
  // special cases
  if A = 0 then
    begin
      Result := ToRawByteString('0');
      exit;
    end;
  if A = MinInt64 then
    begin
      Result := ToRawByteString('-9223372036854775808');
      exit;
    end;
  // calculate string length
  if A < 0 then
    L := 1
  else
    L := 0;
  T := A;
  while T <> 0 do
    begin
      T := T div 10;
      Inc(L);
    end;
  // convert
  SetLength(Result, L);
  I := 0;
  T := A;
  if T < 0 then
    begin
      Result[1] := '-';
      T := -T;
    end;
  while T > 0 do
    begin
      Result[L - I] := UTF8Char(IntToByteChar(T mod 10));
      T := T div 10;
      Inc(I);
    end;
end;

function IntToStringU(const A: Int64): UnicodeString;
var L, T, I : Integer;
begin
  // special cases
  if A = 0 then
    begin
      Result := '0';
      exit;
    end;
  if A = MinInt64 then
    begin
      Result := '-9223372036854775808';
      exit;
    end;
  // calculate string length
  if A < 0 then
    L := 1
  else
    L := 0;
  T := A;
  while T <> 0 do
    begin
      T := T div 10;
      Inc(L);
    end;
  // convert
  SetLength(Result, L);
  I := 0;
  T := A;
  if T < 0 then
    begin
      Result[1] := '-';
      T := -T;
    end;
  while T > 0 do
    begin
      Result[L - I] := IntToWideChar(T mod 10);
      T := T div 10;
      Inc(I);
    end;
end;

function IntToString(const A: Int64): String;
var T : Int64;
    L, I : Integer;
begin
  // special cases
  if A = 0 then
    begin
      Result := '0';
      exit;
    end;
  if A = MinInt64 then
    begin
      Result := '-9223372036854775808';
      exit;
    end;
  // calculate string length
  if A < 0 then
    L := 1
  else
    L := 0;
  T := A;
  while T <> 0 do
    begin
      T := T div 10;
      Inc(L);
    end;
  // convert
  SetLength(Result, L);
  I := 0;
  T := A;
  if T < 0 then
    begin
      Result[1] := '-';
      T := -T;
    end;
  while T > 0 do
    begin
      Result[L - I] := IntToChar(T mod 10);
      T := T div 10;
      Inc(I);
    end;
end;

{$IFDEF SupportAnsiString}
function NativeUIntToBaseA(
         const Value: NativeUInt;
         const Digits: Integer;
         const Base: Byte;
         const UpperCase: Boolean = True): AnsiString;
var D : NativeUInt;
    L : Integer;
    V : Byte;
begin
  Assert((Base >= 2) and (Base <= 16));
  if Value = 0 then // handle zero value
    begin
      if Digits = 0 then
        L := 1
      else
        L := Digits;
      SetLength(Result, L);
      for V := 0 to L - 1 do
        Result[1 + V] := ByteChar(Ord('0'));
      exit;
    end;
  // determine number of digits in result
  L := 0;
  D := Value;
  while D > 0 do
    begin
      Inc(L);
      D := D div Base;
    end;
  if L < Digits then
    L := Digits;
  // do conversion
  SetLength(Result, L);
  D := Value;
  while D > 0 do
    begin
      V := D mod Base + 1;
      if UpperCase then
        Result[L] := ByteChar(StrHexDigitsUpper[V])
      else
        Result[L] := ByteChar(StrHexDigitsLower[V]);
      Dec(L);
      D := D div Base;
    end;
  while L > 0 do
    begin
      Result[L] := ByteChar(Ord('0'));
      Dec(L);
    end;
end;
{$ENDIF}

function NativeUIntToBaseB(
         const Value: NativeUInt;
         const Digits: Integer;
         const Base: Byte;
         const UpperCase: Boolean = True): RawByteString;
var D : NativeUInt;
    L : Integer;
    V : Byte;
begin
  Assert((Base >= 2) and (Base <= 16));
  if Value = 0 then // handle zero value
    begin
      if Digits = 0 then
        L := 1
      else
        L := Digits;
      SetLength(Result, L);
      for V := 0 to L - 1 do
        Result[1 + V] := '0';
      exit;
    end;
  // determine number of digits in result
  L := 0;
  D := Value;
  while D > 0 do
    begin
      Inc(L);
      D := D div Base;
    end;
  if L < Digits then
    L := Digits;
  // do conversion
  SetLength(Result, L);
  D := Value;
  while D > 0 do
    begin
      V := D mod Base + 1;
      if UpperCase then
        Result[L] := UTF8Char(StrHexDigitsUpper[V])
      else
        Result[L] := UTF8Char(StrHexDigitsLower[V]);
      Dec(L);
      D := D div Base;
    end;
  while L > 0 do
    begin
      Result[L] := '0';
      Dec(L);
    end;
end;

function NativeUIntToBaseU(
         const Value: NativeUInt;
         const Digits: Integer;
         const Base: Byte;
         const UpperCase: Boolean = True): UnicodeString;
var D : NativeUInt;
    L : Integer;
    V : Byte;
begin
  Assert((Base >= 2) and (Base <= 16));
  if Value = 0 then // handle zero value
    begin
      if Digits = 0 then
        L := 1
      else
        L := Digits;
      SetLength(Result, L);
      for V := 1 to L do
        Result[V] := '0';
      exit;
    end;
  // determine number of digits in result
  L := 0;
  D := Value;
  while D > 0 do
    begin
      Inc(L);
      D := D div Base;
    end;
  if L < Digits then
    L := Digits;
  // do conversion
  SetLength(Result, L);
  D := Value;
  while D > 0 do
    begin
      V := D mod Base + 1;
      if UpperCase then
        Result[L] := WideChar(StrHexDigitsUpper[V])
      else
        Result[L] := WideChar(StrHexDigitsLower[V]);
      Dec(L);
      D := D div Base;
    end;
  while L > 0 do
    begin
      Result[L] := '0';
      Dec(L);
    end;
end;

function NativeUIntToBase(
         const Value: NativeUInt;
         const Digits: Integer;
         const Base: Byte;
         const UpperCase: Boolean = True): String;
var D : NativeUInt;
    L : Integer;
    V : Byte;
begin
  Assert((Base >= 2) and (Base <= 16));
  if Value = 0 then // handle zero value
    begin
      if Digits = 0 then
        L := 1
      else
        L := Digits;
      SetLength(Result, L);
      for V := 1 to L do
        Result[V] := '0';
      exit;
    end;
  // determine number of digits in result
  L := 0;
  D := Value;
  while D > 0 do
    begin
      Inc(L);
      D := D div Base;
    end;
  if L < Digits then
    L := Digits;
  // do conversion
  SetLength(Result, L);
  D := Value;
  while D > 0 do
    begin
      V := D mod Base + 1;
      if UpperCase then
        Result[L] := Char(StrHexDigitsUpper[V])
      else
        Result[L] := Char(StrHexDigitsLower[V]);
      Dec(L);
      D := D div Base;
    end;
  while L > 0 do
    begin
      Result[L] := '0';
      Dec(L);
    end;
end;

{$IFDEF SupportAnsiString}
function UIntToStringA(const A: NativeUInt): AnsiString;
begin
  Result := NativeUIntToBaseA(A, 0, 10);
end;
{$ENDIF}

function UIntToStringB(const A: NativeUInt): RawByteString;
begin
  Result := NativeUIntToBaseB(A, 0, 10);
end;

function UIntToStringU(const A: NativeUInt): UnicodeString;
begin
  Result := NativeUIntToBaseU(A, 0, 10);
end;

function UIntToString(const A: NativeUInt): String;
begin
  Result := NativeUIntToBase(A, 0, 10);
end;

{$IFDEF SupportAnsiString}
function Word32ToStrA(const A: Word32; const Digits: Integer): AnsiString;
begin
  Result := NativeUIntToBaseA(A, Digits, 10);
end;
{$ENDIF}

function Word32ToStrB(const A: Word32; const Digits: Integer): RawByteString;
begin
  Result := NativeUIntToBaseB(A, Digits, 10);
end;

function Word32ToStrU(const A: Word32; const Digits: Integer): UnicodeString;
begin
  Result := NativeUIntToBaseU(A, Digits, 10);
end;

function Word32ToStr(const A: Word32; const Digits: Integer): String;
begin
  Result := NativeUIntToBase(A, Digits, 10);
end;

{$IFDEF SupportAnsiString}
function Word32ToHexA(const A: Word32; const Digits: Integer; const UpperCase: Boolean): AnsiString;
begin
  Result := NativeUIntToBaseA(A, Digits, 16, UpperCase);
end;
{$ENDIF}

function Word32ToHexB(const A: Word32; const Digits: Integer; const UpperCase: Boolean): RawByteString;
begin
  Result := NativeUIntToBaseB(A, Digits, 16, UpperCase);
end;

function Word32ToHexU(const A: Word32; const Digits: Integer; const UpperCase: Boolean): UnicodeString;
begin
  Result := NativeUIntToBaseU(A, Digits, 16, UpperCase);
end;

function Word32ToHex(const A: Word32; const Digits: Integer; const UpperCase: Boolean): String;
begin
  Result := NativeUIntToBase(A, Digits, 16, UpperCase);
end;

{$IFDEF SupportAnsiString}
function Word32ToOctA(const A: Word32; const Digits: Integer): AnsiString;
begin
  Result := NativeUIntToBaseA(A, Digits, 8);
end;
{$ENDIF}

function Word32ToOctB(const A: Word32; const Digits: Integer): RawByteString;
begin
  Result := NativeUIntToBaseB(A, Digits, 8);
end;

function Word32ToOctU(const A: Word32; const Digits: Integer): UnicodeString;
begin
  Result := NativeUIntToBaseU(A, Digits, 8);
end;

function Word32ToOct(const A: Word32; const Digits: Integer): String;
begin
  Result := NativeUIntToBase(A, Digits, 8);
end;

{$IFDEF SupportAnsiString}
function Word32ToBinA(const A: Word32; const Digits: Integer): AnsiString;
begin
  Result := NativeUIntToBaseA(A, Digits, 2);
end;
{$ENDIF}

function Word32ToBinB(const A: Word32; const Digits: Integer): RawByteString;
begin
  Result := NativeUIntToBaseB(A, Digits, 2);
end;

function Word32ToBinU(const A: Word32; const Digits: Integer): UnicodeString;
begin
  Result := NativeUIntToBaseU(A, Digits, 2);
end;

function Word32ToBin(const A: Word32; const Digits: Integer): String;
begin
  Result := NativeUIntToBase(A, Digits, 2);
end;

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF} // Delphi 7 incorrectly overflowing for -922337203685477580 * 10
function TryStringToInt64PB(const BufP: Pointer; const BufLen: Integer; out Value: Int64; out StrLen: Integer): TConvertResult;
var Len : Integer;
    DigVal : Integer;
    P : PByte;
    Ch : Byte;
    HasDig : Boolean;
    Neg : Boolean;
    Res : Int64;
begin
  if BufLen <= 0 then
    begin
      Value := 0;
      StrLen := 0;
      Result := convertFormatError;
      exit;
    end;
  P := BufP;
  Len := 0;
  // check sign
  Ch := P^;
  if Ch in [Ord('+'), Ord('-')] then
    begin
      Inc(Len);
      Inc(P);
      Neg := Ch = Ord('-');
    end
  else
    Neg := False;
  // skip leading zeros
  HasDig := False;
  while (Len < BufLen) and (P^ = Ord('0')) do
    begin
      Inc(Len);
      Inc(P);
      HasDig := True;
    end;
  // convert digits
  Res := 0;
  while Len < BufLen do
    begin
      Ch := P^;
      if Ch in [Ord('0')..Ord('9')] then
        begin
          HasDig := True;
          if (Res > 922337203685477580) or
             (Res < -922337203685477580) then
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          Res := Res * 10;
          DigVal := ByteCharToInt(ByteChar(Ch));
          if ((Res = 9223372036854775800) and (DigVal > 7)) or
             ((Res = -9223372036854775800) and (DigVal > 8)) then
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          if Neg then
            Dec(Res, DigVal)
          else
            Inc(Res, DigVal);
          Inc(Len);
          Inc(P);
        end
      else
        break;
    end;
  StrLen := Len;
  if not HasDig then
    begin
      Value := 0;
      Result := convertFormatError;
    end
  else
    begin
      Value := Res;
      Result := convertOK;
    end;
end;
{$IFDEF QOn}{$Q+}{$ENDIF}

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF} // Delphi 7 incorrectly overflowing for -922337203685477580 * 10
function TryStringToInt64PW(const BufP: Pointer; const BufLen: Integer; out Value: Int64; out StrLen: Integer): TConvertResult;
var Len : Integer;
    DigVal : Integer;
    P : PWideChar;
    Ch : WideChar;
    HasDig : Boolean;
    Neg : Boolean;
    Res : Int64;
begin
  if BufLen <= 0 then
    begin
      Value := 0;
      StrLen := 0;
      Result := convertFormatError;
      exit;
    end;
  P := BufP;
  Len := 0;
  // check sign
  Ch := P^;
  if (Ch = '+') or (Ch = '-') then
    begin
      Inc(Len);
      Inc(P);
      Neg := Ch = '-';
    end
  else
    Neg := False;
  // skip leading zeros
  HasDig := False;
  while (Len < BufLen) and (P^ = '0') do
    begin
      Inc(Len);
      Inc(P);
      HasDig := True;
    end;
  // convert digits
  Res := 0;
  while Len < BufLen do
    begin
      Ch := P^;
      if (Ch >= '0') and (Ch <= '9') then
        begin
          HasDig := True;
          if (Res > 922337203685477580) or
             (Res < -922337203685477580) then
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          Res := Res * 10;
          DigVal := WideCharToInt(Ch);
          if ((Res = 9223372036854775800) and (DigVal > 7)) or
             ((Res = -9223372036854775800) and (DigVal > 8)) then
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          if Neg then
            Dec(Res, DigVal)
          else
            Inc(Res, DigVal);
          Inc(Len);
          Inc(P);
        end
      else
        break;
    end;
  StrLen := Len;
  if not HasDig then
    begin
      Value := 0;
      Result := convertFormatError;
    end
  else
    begin
      Value := Res;
      Result := convertOK;
    end;
end;
{$IFDEF QOn}{$Q+}{$ENDIF}

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF} // Delphi 7 incorrectly overflowing for -922337203685477580 * 10
function TryStringToInt64P(const BufP: Pointer; const BufLen: Integer; out Value: Int64; out StrLen: Integer): TConvertResult;
var Len : Integer;
    DigVal : Integer;
    P : PChar;
    Ch : Char;
    HasDig : Boolean;
    Neg : Boolean;
    Res : Int64;
begin
  if BufLen <= 0 then
    begin
      Value := 0;
      StrLen := 0;
      Result := convertFormatError;
      exit;
    end;
  P := BufP;
  Len := 0;
  // check sign
  Ch := P^;
  if (Ch = '+') or (Ch = '-') then
    begin
      Inc(Len);
      Inc(P);
      Neg := Ch = '-';
    end
  else
    Neg := False;
  // skip leading zeros
  HasDig := False;
  while (Len < BufLen) and (P^ = '0') do
    begin
      Inc(Len);
      Inc(P);
      HasDig := True;
    end;
  // convert digits
  Res := 0;
  while Len < BufLen do
    begin
      Ch := P^;
      if (Ch >= '0') and (Ch <= '9') then
        begin
          HasDig := True;
          if (Res > 922337203685477580) or
             (Res < -922337203685477580) then
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          Res := Res * 10;
          DigVal := CharToInt(Ch);
          if ((Res = 9223372036854775800) and (DigVal > 7)) or
             ((Res = -9223372036854775800) and (DigVal > 8)) then
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          if Neg then
            Dec(Res, DigVal)
          else
            Inc(Res, DigVal);
          Inc(Len);
          Inc(P);
        end
      else
        break;
    end;
  StrLen := Len;
  if not HasDig then
    begin
      Value := 0;
      Result := convertFormatError;
    end
  else
    begin
      Value := Res;
      Result := convertOK;
    end;
end;
{$IFDEF QOn}{$Q+}{$ENDIF}

{$IFDEF SupportAnsiString}
function TryStringToInt64A(const S: AnsiString; out A: Int64): Boolean;
var L, N : Integer;
begin
  L := Length(S);
  Result := TryStringToInt64PB(PAnsiChar(S), L, A, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;
{$ENDIF}

function TryStringToInt64B(const S: RawByteString; out A: Int64): Boolean;
var L, N : Integer;
begin
  L := Length(S);
  Result := TryStringToInt64PB(Pointer(S), L, A, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;

function TryStringToInt64U(const S: UnicodeString; out A: Int64): Boolean;
var L, N : Integer;
begin
  L := Length(S);
  Result := TryStringToInt64PW(PWideChar(S), L, A, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;

function TryStringToInt64(const S: String; out A: Int64): Boolean;
var L, N : Integer;
begin
  L := Length(S);
  Result := TryStringToInt64P(PChar(S), L, A, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;

{$IFDEF SupportAnsiString}
function StringToInt64DefA(const S: AnsiString; const Default: Int64): Int64;
begin
  if not TryStringToInt64A(S, Result) then
    Result := Default;
end;
{$ENDIF}

function StringToInt64DefB(const S: RawByteString; const Default: Int64): Int64;
begin
  if not TryStringToInt64B(S, Result) then
    Result := Default;
end;

function StringToInt64DefU(const S: UnicodeString; const Default: Int64): Int64;
begin
  if not TryStringToInt64U(S, Result) then
    Result := Default;
end;

function StringToInt64Def(const S: String; const Default: Int64): Int64;
begin
  if not TryStringToInt64(S, Result) then
    Result := Default;
end;

{$IFDEF SupportAnsiString}
function StringToInt64A(const S: AnsiString): Int64;
begin
  if not TryStringToInt64A(S, Result) then
    RaiseRangeCheckError;
end;
{$ENDIF}

function StringToInt64B(const S: RawByteString): Int64;
begin
  if not TryStringToInt64B(S, Result) then
    RaiseRangeCheckError;
end;

function StringToInt64U(const S: UnicodeString): Int64;
begin
  if not TryStringToInt64U(S, Result) then
    RaiseRangeCheckError;
end;

function StringToInt64(const S: String): Int64;
begin
  if not TryStringToInt64(S, Result) then
    RaiseRangeCheckError;
end;

{$IFDEF SupportAnsiString}
function TryStringToIntA(const S: AnsiString; out A: Integer): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64A(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinInteger) or (B > MaxInteger) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := Integer(B);
  Result := True;
end;
{$ENDIF}

function TryStringToIntB(const S: RawByteString; out A: Integer): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64B(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinInteger) or (B > MaxInteger) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := Integer(B);
  Result := True;
end;

function TryStringToIntU(const S: UnicodeString; out A: Integer): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64U(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinInteger) or (B > MaxInteger) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := Integer(B);
  Result := True;
end;

function TryStringToInt(const S: String; out A: Integer): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinInteger) or (B > MaxInteger) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := Integer(B);
  Result := True;
end;

{$IFDEF SupportAnsiString}
function StringToIntDefA(const S: AnsiString; const Default: Integer): Integer;
begin
  if not TryStringToIntA(S, Result) then
    Result := Default;
end;
{$ENDIF}

function StringToIntDefB(const S: RawByteString; const Default: Integer): Integer;
begin
  if not TryStringToIntB(S, Result) then
    Result := Default;
end;

function StringToIntDefU(const S: UnicodeString; const Default: Integer): Integer;
begin
  if not TryStringToIntU(S, Result) then
    Result := Default;
end;

function StringToIntDef(const S: String; const Default: Integer): Integer;
begin
  if not TryStringToInt(S, Result) then
    Result := Default;
end;

{$IFDEF SupportAnsiString}
function StringToIntA(const S: AnsiString): Integer;
begin
  if not TryStringToIntA(S, Result) then
    RaiseRangeCheckError;
end;
{$ENDIF}

function StringToIntB(const S: RawByteString): Integer;
begin
  if not TryStringToIntB(S, Result) then
    RaiseRangeCheckError;
end;

function StringToIntU(const S: UnicodeString): Integer;
begin
  if not TryStringToIntU(S, Result) then
    RaiseRangeCheckError;
end;

function StringToInt(const S: String): Integer;
begin
  if not TryStringToInt(S, Result) then
    RaiseRangeCheckError;
end;

{$IFDEF SupportAnsiString}
function TryStringToWord32A(const S: AnsiString; out A: Word32): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64A(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinWord32) or (B > MaxWord32) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := Word32(B);
  Result := True;
end;
{$ENDIF}

function TryStringToWord32B(const S: RawByteString; out A: Word32): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64B(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinWord32) or (B > MaxWord32) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := Word32(B);
  Result := True;
end;

function TryStringToWord32U(const S: UnicodeString; out A: Word32): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64U(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinWord32) or (B > MaxWord32) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := Word32(B);
  Result := True;
end;

function TryStringToWord32(const S: String; out A: Word32): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinWord32) or (B > MaxWord32) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := Word32(B);
  Result := True;
end;

{$IFDEF SupportAnsiString}
function StringToWord32A(const S: AnsiString): Word32;
begin
  if not TryStringToWord32A(S, Result) then
    RaiseRangeCheckError;
end;
{$ENDIF}

function StringToWord32B(const S: RawByteString): Word32;
begin
  if not TryStringToWord32B(S, Result) then
    RaiseRangeCheckError;
end;

function StringToWord32U(const S: UnicodeString): Word32;
begin
  if not TryStringToWord32U(S, Result) then
    RaiseRangeCheckError;
end;

function StringToWord32(const S: String): Word32;
begin
  if not TryStringToWord32(S, Result) then
    RaiseRangeCheckError;
end;

{$IFDEF SupportAnsiString}
function BaseStrToNativeUIntA(const S: AnsiString; const BaseLog2: Byte;
    var Valid: Boolean): NativeUInt;
var N : Byte;
    L : Integer;
    M : Byte;
    C : Byte;
begin
  Assert(BaseLog2 <= 4); // maximum base 16
  L := Length(S);
  if L = 0 then // empty string is invalid
    begin
      Valid := False;
      Result := 0;
      exit;
    end;
  M := (1 shl BaseLog2) - 1; // maximum digit value
  N := 0;
  Result := 0;
  repeat
    C := HexLookup[Ord(S[L])];
    if C > M then // invalid digit
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    {$IFDEF FPC}
    Result := Result + NativeUInt(C) shl N;
    {$ELSE}
    Inc(Result, NativeUInt(C) shl N);
    {$ENDIF}
    Inc(N, BaseLog2);
    if N > BitsPerNativeWord then // overflow
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    Dec(L);
  until L = 0;
  Valid := True;
end;
{$ENDIF}

function BaseStrToNativeUIntB(const S: RawByteString; const BaseLog2: Byte;
    var Valid: Boolean): NativeUInt;
var N : Byte;
    L : Integer;
    M : Byte;
    C : Byte;
begin
  Assert(BaseLog2 <= 4); // maximum base 16
  L := Length(S);
  if L = 0 then // empty string is invalid
    begin
      Valid := False;
      Result := 0;
      exit;
    end;
  M := (1 shl BaseLog2) - 1; // maximum digit value
  N := 0;
  Result := 0;
  repeat
    C := HexLookup[Ord(S[L])];
    if C > M then // invalid digit
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    {$IFDEF FPC}
    Result := Result + NativeUInt(C) shl N;
    {$ELSE}
    Inc(Result, NativeUInt(C) shl N);
    {$ENDIF}
    Inc(N, BaseLog2);
    if N > BitsPerNativeWord then // overflow
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    Dec(L);
  until L = 0;
  Valid := True;
end;

function BaseStrToNativeUIntU(const S: UnicodeString; const BaseLog2: Byte;
    var Valid: Boolean): NativeUInt;
var N : Byte;
    L : Integer;
    M : Byte;
    C : Byte;
    D : WideChar;
begin
  Assert(BaseLog2 <= 4); // maximum base 16
  L := Length(S);
  if L = 0 then // empty string is invalid
    begin
      Valid := False;
      Result := 0;
      exit;
    end;
  M := (1 shl BaseLog2) - 1; // maximum digit value
  N := 0;
  Result := 0;
  repeat
    D := S[L];
    if Ord(D) > $FF then
      C := $FF
    else
      C := HexLookup[Ord(D)];
    if C > M then // invalid digit
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    {$IFDEF FPC}
    Result := Result + NativeUInt(C) shl N;
    {$ELSE}
    Inc(Result, NativeUInt(C) shl N);
    {$ENDIF}
    Inc(N, BaseLog2);
    if N > BitsPerNativeWord then // overflow
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    Dec(L);
  until L = 0;
  Valid := True;
end;

function BaseStrToNativeUInt(const S: String; const BaseLog2: Byte;
    var Valid: Boolean): NativeUInt;
var N : Byte;
    L : Integer;
    M : Byte;
    C : Byte;
    D : Char;
begin
  Assert(BaseLog2 <= 4); // maximum base 16
  L := Length(S);
  if L = 0 then // empty string is invalid
    begin
      Valid := False;
      Result := 0;
      exit;
    end;
  M := (1 shl BaseLog2) - 1; // maximum digit value
  N := 0;
  Result := 0;
  repeat
    D := S[L];
    {$IFDEF CharIsWide}
    if Ord(D) > $FF then
      C := $FF
    else
      C := HexLookup[Ord(D)];
    {$ELSE}
    C := HexLookup[Ord(D)];
    {$ENDIF}
    if C > M then // invalid digit
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    {$IFDEF FPC}
    Result := Result + NativeUInt(C) shl N;
    {$ELSE}
    Inc(Result, NativeUInt(C) shl N);
    {$ENDIF}
    Inc(N, BaseLog2);
    if N > BitsPerNativeWord then // overflow
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    Dec(L);
  until L = 0;
  Valid := True;
end;

{$IFDEF SupportAnsiString}
function HexToUIntA(const S: AnsiString): NativeUInt;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntA(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;
{$ENDIF}

function HexToUIntB(const S: RawByteString): NativeUInt;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntB(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

function HexToUIntU(const S: UnicodeString): NativeUInt;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntU(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

function HexToUInt(const S: String): NativeUInt;
var R : Boolean;
begin
  Result := BaseStrToNativeUInt(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

{$IFDEF SupportAnsiString}
function TryHexToWord32A(const S: AnsiString; out A: Word32): Boolean;
begin
  A := BaseStrToNativeUIntA(S, 4, Result);
end;
{$ENDIF}

function TryHexToWord32B(const S: RawByteString; out A: Word32): Boolean;
begin
  A := BaseStrToNativeUIntB(S, 4, Result);
end;

function TryHexToWord32U(const S: UnicodeString; out A: Word32): Boolean;
begin
  A := BaseStrToNativeUIntU(S, 4, Result);
end;

function TryHexToWord32(const S: String; out A: Word32): Boolean;
begin
  A := BaseStrToNativeUInt(S, 4, Result);
end;

{$IFDEF SupportAnsiString}
function HexToWord32A(const S: AnsiString): Word32;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntA(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;
{$ENDIF}

function HexToWord32B(const S: RawByteString): Word32;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntB(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

function HexToWord32U(const S: UnicodeString): Word32;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntU(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

function HexToWord32(const S: String): Word32;
var R : Boolean;
begin
  Result := BaseStrToNativeUInt(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

{$IFDEF SupportAnsiString}
function TryOctToWord32A(const S: AnsiString; out A: Word32): Boolean;
begin
  A := BaseStrToNativeUIntA(S, 3, Result);
end;
{$ENDIF}

function TryOctToWord32B(const S: RawByteString; out A: Word32): Boolean;
begin
  A := BaseStrToNativeUIntB(S, 3, Result);
end;

function TryOctToWord32U(const S: UnicodeString; out A: Word32): Boolean;
begin
  A := BaseStrToNativeUIntU(S, 3, Result);
end;

function TryOctToWord32(const S: String; out A: Word32): Boolean;
begin
  A := BaseStrToNativeUInt(S, 3, Result);
end;

{$IFDEF SupportAnsiString}
function OctToWord32A(const S: AnsiString): Word32;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntA(S, 3, R);
  if not R then
    RaiseRangeCheckError;
end;
{$ENDIF}

function OctToWord32B(const S: RawByteString): Word32;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntB(S, 3, R);
  if not R then
    RaiseRangeCheckError;
end;

function OctToWord32U(const S: UnicodeString): Word32;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntU(S, 3, R);
  if not R then
    RaiseRangeCheckError;
end;

function OctToWord32(const S: String): Word32;
var R : Boolean;
begin
  Result := BaseStrToNativeUInt(S, 3, R);
  if not R then
    RaiseRangeCheckError;
end;

{$IFDEF SupportAnsiString}
function TryBinToWord32A(const S: AnsiString; out A: Word32): Boolean;
begin
  A := BaseStrToNativeUIntA(S, 1, Result);
end;
{$ENDIF}

function TryBinToWord32B(const S: RawByteString; out A: Word32): Boolean;
begin
  A := BaseStrToNativeUIntB(S, 1, Result);
end;

function TryBinToWord32U(const S: UnicodeString; out A: Word32): Boolean;
begin
  A := BaseStrToNativeUIntU(S, 1, Result);
end;

function TryBinToWord32(const S: String; out A: Word32): Boolean;
begin
  A := BaseStrToNativeUInt(S, 1, Result);
end;

{$IFDEF SupportAnsiString}
function BinToWord32A(const S: AnsiString): Word32;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntA(S, 1, R);
  if not R then
    RaiseRangeCheckError;
end;
{$ENDIF}

function BinToWord32B(const S: RawByteString): Word32;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntB(S, 1, R);
  if not R then
    RaiseRangeCheckError;
end;

function BinToWord32U(const S: UnicodeString): Word32;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntU(S, 1, R);
  if not R then
    RaiseRangeCheckError;
end;

function BinToWord32(const S: String): Word32;
var R : Boolean;
begin
  Result := BaseStrToNativeUInt(S, 1, R);
  if not R then
    RaiseRangeCheckError;
end;



{$IFDEF SupportAnsiString}
function BytesToHexA(const P: Pointer; const Count: Integer;
         const UpperCase: Boolean): AnsiString;
var Q : PByte;
    D : PAnsiChar;
    L : Integer;
    V : Byte;
begin
  Q := P;
  L := Count;
  if (L <= 0) or not Assigned(Q) then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, Count * 2);
  D := Pointer(Result);
  while L > 0 do
    begin
      V := Q^ shr 4 + 1;
      if UpperCase then
        D^ := AnsiChar(StrHexDigitsUpper[V])
      else
        D^ := AnsiChar(StrHexDigitsLower[V]);
      Inc(D);
      V := Q^ and $F + 1;
      if UpperCase then
        D^ := AnsiChar(StrHexDigitsUpper[V])
      else
        D^ := AnsiChar(StrHexDigitsLower[V]);
      Inc(D);
      Inc(Q);
      Dec(L);
    end;
end;
{$ENDIF}



{                                                                              }
{ Network byte order                                                           }
{                                                                              }
function hton16(const A: Word): Word;
begin
  Result := Word(A shr 8) or Word(A shl 8);
end;

function ntoh16(const A: Word): Word;
begin
  Result := Word(A shr 8) or Word(A shl 8);
end;

function hton32(const A: Word32): Word32;
var BufH : array[0..3] of Byte;
    BufN : array[0..3] of Byte;
begin
  PWord32(@BufH)^ := A;
  BufN[0] := BufH[3];
  BufN[1] := BufH[2];
  BufN[2] := BufH[1];
  BufN[3] := BufH[0];
  Result := PWord32(@BufN)^;
end;

function ntoh32(const A: Word32): Word32;
var BufH : array[0..3] of Byte;
    BufN : array[0..3] of Byte;
begin
  PWord32(@BufH)^ := A;
  BufN[0] := BufH[3];
  BufN[1] := BufH[2];
  BufN[2] := BufH[1];
  BufN[3] := BufH[0];
  Result := PWord32(@BufN)^;
end;

function hton64(const A: Int64): Int64;
var BufH : array[0..7] of Byte;
    BufN : array[0..7] of Byte;
begin
  PInt64(@BufH)^ := A;
  BufN[0] := BufH[7];
  BufN[1] := BufH[6];
  BufN[2] := BufH[5];
  BufN[3] := BufH[4];
  BufN[4] := BufH[3];
  BufN[5] := BufH[2];
  BufN[6] := BufH[1];
  BufN[7] := BufH[0];
  Result := PInt64(@BufN)^;
end;

function ntoh64(const A: Int64): Int64;
var BufH : array[0..7] of Byte;
    BufN : array[0..7] of Byte;
begin
  PInt64(@BufH)^ := A;
  BufN[0] := BufH[7];
  BufN[1] := BufH[6];
  BufN[2] := BufH[5];
  BufN[3] := BufH[4];
  BufN[4] := BufH[3];
  BufN[5] := BufH[2];
  BufN[6] := BufH[1];
  BufN[7] := BufH[0];
  Result := PInt64(@BufN)^;
end;



{                                                                              }
{ Pointer-String conversions                                                   }
{                                                                              }
{$IFDEF SupportAnsiString}
function PointerToStrA(const P: Pointer): AnsiString;
begin
  Result := NativeUIntToBaseA(NativeUInt(P), NativeWordSize * 2, 16, True);
end;
{$ENDIF}

function PointerToStrB(const P: Pointer): RawByteString;
begin
  Result := NativeUIntToBaseB(NativeUInt(P), NativeWordSize * 2, 16, True);
end;

function PointerToStrU(const P: Pointer): UnicodeString;
begin
  Result := NativeUIntToBaseU(NativeUInt(P), NativeWordSize * 2, 16, True);
end;

function PointerToStr(const P: Pointer): String;
begin
  Result := NativeUIntToBase(NativeUInt(P), NativeWordSize * 2, 16, True);
end;

{$IFDEF SupportAnsiString}
function StrToPointerA(const S: AnsiString): Pointer;
var V : Boolean;
begin
  Result := Pointer(BaseStrToNativeUIntA(S, 4, V));
end;
{$ENDIF}

function StrToPointerB(const S: RawByteString): Pointer;
var V : Boolean;
begin
  Result := Pointer(BaseStrToNativeUIntB(S, 4, V));
end;

function StrToPointerU(const S: UnicodeString): Pointer;
var V : Boolean;
begin
  Result := Pointer(BaseStrToNativeUIntU(S, 4, V));
end;

function StrToPointer(const S: String): Pointer;
var V : Boolean;
begin
  Result := Pointer(BaseStrToNativeUInt(S, 4, V));
end;

{$IFDEF SupportInterface}
{$IFDEF SupportAnsiString}
function InterfaceToStrA(const I: IInterface): AnsiString;
begin
  Result := NativeUIntToBaseA(NativeUInt(I), NativeWordSize * 2, 16, True);
end;
{$ENDIF}

function InterfaceToStrB(const I: IInterface): RawByteString;
begin
  Result := NativeUIntToBaseB(NativeUInt(I), NativeWordSize * 2, 16, True);
end;

function InterfaceToStrU(const I: IInterface): UnicodeString;
begin
  Result := NativeUIntToBaseU(NativeUInt(I), NativeWordSize * 2, 16, True);
end;

function InterfaceToStr(const I: IInterface): String;
begin
  Result := NativeUIntToBase(NativeUInt(I), NativeWordSize * 2, 16, True);
end;
{$ENDIF}

function ObjectClassName(const O: TObject): String;
begin
  if not Assigned(O) then
    Result := 'nil'
  else
    Result := O.ClassName;
end;

function ClassClassName(const C: TClass): String;
begin
  if not Assigned(C) then
    Result := 'nil'
  else
    Result := C.ClassName;
end;

function ObjectToStr(const O: TObject): String;
begin
  if not Assigned(O) then
    Result := 'nil'
  else
    Result := O.ClassName + '@' + PointerToStr(Pointer(O));
end;



{                                                                              }
{ Hash functions                                                               }
{   Derived from a CRC32 algorithm.                                            }
{                                                                              }
var
  HashTableInit : Boolean = False;
  HashTable     : array[Byte] of Word32;
  HashPoly      : Word32 = $EDB88320;

procedure InitHashTable;
var I, J : Byte;
    R    : Word32;
begin
  for I := $00 to $FF do
    begin
      R := I;
      for J := 8 downto 1 do
        if R and 1 <> 0 then
          R := (R shr 1) xor HashPoly
        else
          R := R shr 1;
      HashTable[I] := R;
    end;
  HashTableInit := True;
end;

function HashByte(const Hash: Word32; const C: Byte): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := HashTable[Byte(Hash) xor C] xor (Hash shr 8);
end;

function HashCharB(const Hash: Word32; const Ch: ByteChar): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := HashByte(Hash, Byte(Ch));
end;

function HashCharW(const Hash: Word32; const Ch: WideChar): Word32; {$IFDEF UseInline}inline;{$ENDIF}
var C1, C2 : Byte;
begin
  C1 := Byte(Ord(Ch) and $FF);
  C2 := Byte(Ord(Ch) shr 8);
  Result := Hash;
  Result := HashByte(Result, C1);
  Result := HashByte(Result, C2);
end;

function HashChar(const Hash: Word32; const Ch: Char): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  {$IFDEF CharIsWide}
  Result := HashCharW(Hash, Ch);
  {$ELSE}
  Result := HashCharB(Hash, Ch);
  {$ENDIF}
end;

function HashCharNoAsciiCaseB(const Hash: Word32; const Ch: ByteChar): Word32; {$IFDEF UseInline}inline;{$ENDIF}
var C : Byte;
begin
  C := Byte(Ch);
  if C in [Ord('A')..Ord('Z')] then
    C := C or 32;
  Result := HashCharB(Hash, ByteChar(C));
end;

function HashCharNoAsciiCaseW(const Hash: Word32; const Ch: WideChar): Word32; {$IFDEF UseInline}inline;{$ENDIF}
var C : Word;
begin
  C := Word(Ch);
  if C <= $FF then
    if Byte(C) in [Ord('A')..Ord('Z')] then
      C := C or 32;
  Result := HashCharW(Hash, WideChar(C));
end;

function HashCharNoAsciiCase(const Hash: Word32; const Ch: Char): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  {$IFDEF CharIsWide}
  Result := HashCharNoAsciiCaseW(Hash, Ch);
  {$ELSE}
  Result := HashCharNoAsciiCaseB(Hash, Ch);
  {$ENDIF}
end;

function HashBuf(const Hash: Word32; const Buf; const BufSize: Integer): Word32;
var P : PByte;
    I : Integer;
begin
  if not HashTableInit then
    InitHashTable;
  Result := Hash;
  P := @Buf;
  for I := 0 to BufSize - 1 do
    begin
      Result := HashByte(Result, P^);
      Inc(P);
    end;
end;

{$IFDEF SupportAnsiString}
function HashStrA(const S: AnsiString;
         const Index: Integer; const Count: Integer;
         const AsciiCaseSensitive: Boolean;
         const Slots: Word32): Word32;
var I, L, A, B : Integer;
begin
  if not HashTableInit then
    InitHashTable;
  A := Index;
  if A < 1 then
    A := 1;
  L := Length(S);
  B := Count;
  if B < 0 then
    B := L
  else
    begin
      B := A + B - 1;
      if B > L then
        B := L;
    end;
  Result := $FFFFFFFF;
  if AsciiCaseSensitive then
    for I := A to B do
      Result := HashCharB(Result, S[I])
  else
    for I := A to B do
      Result := HashCharNoAsciiCaseB(Result, S[I]);
  if Slots > 0 then
    Result := Result mod Slots;
end;
{$ENDIF}

function HashStrB(const S: RawByteString;
         const Index: Integer; const Count: Integer;
         const AsciiCaseSensitive: Boolean;
         const Slots: Word32): Word32;
var I, L, A, B : Integer;
begin
  if not HashTableInit then
    InitHashTable;
  A := Index;
  if A < 1 then
    A := 1;
  L := Length(S);
  B := Count;
  if B < 0 then
    B := L
  else
    begin
      B := A + B - 1;
      if B > L then
        B := L;
    end;
  Result := $FFFFFFFF;
  if AsciiCaseSensitive then
    for I := A to B do
      Result := HashCharB(Result, ByteChar(S[I]))
  else
    for I := A to B do
      Result := HashCharNoAsciiCaseB(Result, ByteChar(S[I]));
  if Slots > 0 then
    Result := Result mod Slots;
end;

function HashStrU(const S: UnicodeString;
         const Index: Integer; const Count: Integer;
         const AsciiCaseSensitive: Boolean;
         const Slots: Word32): Word32;
var I, L, A, B : Integer;
begin
  if not HashTableInit then
    InitHashTable;
  A := Index;
  if A < 1 then
    A := 1;
  L := Length(S);
  B := Count;
  if B < 0 then
    B := L
  else
    begin
      B := A + B - 1;
      if B > L then
        B := L;
    end;
  Result := $FFFFFFFF;
  if AsciiCaseSensitive then
    for I := A to B do
      Result := HashCharW(Result, S[I])
  else
    for I := A to B do
      Result := HashCharNoAsciiCaseW(Result, S[I]);
  if Slots > 0 then
    Result := Result mod Slots;
end;

function HashStr(const S: String;
         const Index: Integer; const Count: Integer;
         const AsciiCaseSensitive: Boolean;
         const Slots: Word32): Word32;
var I, L, A, B : Integer;
begin
  if not HashTableInit then
    InitHashTable;
  A := Index;
  if A < 1 then
    A := 1;
  L := Length(S);
  B := Count;
  if B < 0 then
    B := L
  else
    begin
      B := A + B - 1;
      if B > L then
        B := L;
    end;
  Result := $FFFFFFFF;
  if AsciiCaseSensitive then
    for I := A to B do
      Result := HashChar(Result, S[I])
  else
    for I := A to B do
      Result := HashCharNoAsciiCase(Result, S[I]);
  if Slots > 0 then
    Result := Result mod Slots;
end;

{ HashInteger based on the CRC32 algorithm. It is a very good all purpose hash }
{ with a highly uniform distribution of results.                               }
function HashInteger(const I: Integer; const Slots: Word32): Word32;
var P : PByte;
begin
  if not HashTableInit then
    InitHashTable;
  Result := $FFFFFFFF;
  P := @I;
  Result := HashTable[Byte(Result) xor P^] xor (Result shr 8);
  Inc(P);
  Result := HashTable[Byte(Result) xor P^] xor (Result shr 8);
  Inc(P);
  Result := HashTable[Byte(Result) xor P^] xor (Result shr 8);
  Inc(P);
  Result := HashTable[Byte(Result) xor P^] xor (Result shr 8);
  if Slots <> 0 then
    Result := Result mod Slots;
end;

function HashWord32(const I: Word32; const Slots: Word32): Word32;
var P : PByte;
begin
  if not HashTableInit then
    InitHashTable;
  Result := $FFFFFFFF;
  P := @I;
  Result := HashTable[Byte(Result) xor P^] xor (Result shr 8);
  Inc(P);
  Result := HashTable[Byte(Result) xor P^] xor (Result shr 8);
  Inc(P);
  Result := HashTable[Byte(Result) xor P^] xor (Result shr 8);
  Inc(P);
  Result := HashTable[Byte(Result) xor P^] xor (Result shr 8);
  if Slots <> 0 then
    Result := Result mod Slots;
end;



{                                                                              }
{ Memory                                                                       }
{                                                                              }
{$IFDEF UseAsmMemFunction}
procedure FillMem(var Buf; const Count: Integer; const Value: Byte);
asm
      // EAX = Buf, EDX = Count, CL = Value
      OR      EDX, EDX
      JLE     @Fin
      // Set 4 bytes of ECX to Value byte
      MOV     CH, CL
      SHL     ECX, 8
      MOV     CL, CH
      SHL     ECX, 8
      MOV     CL, CH
      CMP     EDX, 16
      JBE     @SmallFillMem
      // General purpose FillMem
    @GeneralFillMem:
      PUSH    EDI
      MOV     EDI, EAX
      MOV     EAX, ECX
      MOV     ECX, EDX
      SHR     ECX, 2
      REP     STOSD
      AND     EDX, 3
      MOV     ECX, EDX
      REP     STOSB
      POP     EDI
      RET
      // FillMem for small blocks
    @SmallFillMem:
      JMP     DWORD PTR @JumpTable[EDX * 4]
    @JumpTable:
      DD      @Fill0,  @Fill1,  @Fill2,  @Fill3
      DD      @Fill4,  @Fill5,  @Fill6,  @Fill7
      DD      @Fill8,  @Fill9,  @Fill10, @Fill11
      DD      @Fill12, @Fill13, @Fill14, @Fill15
      DD      @Fill16
    @Fill16:
      MOV     DWORD PTR [EAX], ECX
      MOV     DWORD PTR [EAX + 4], ECX
      MOV     DWORD PTR [EAX + 8], ECX
      MOV     DWORD PTR [EAX + 12], ECX
      RET
    @Fill15:
      MOV     BYTE PTR [EAX + 14], CL
    @Fill14:
      MOV     DWORD PTR [EAX], ECX
      MOV     DWORD PTR [EAX + 4], ECX
      MOV     DWORD PTR [EAX + 8], ECX
      MOV     WORD PTR [EAX + 12], CX
      RET
    @Fill13:
      MOV     BYTE PTR [EAX + 12], CL
    @Fill12:
      MOV     DWORD PTR [EAX], ECX
      MOV     DWORD PTR [EAX + 4], ECX
      MOV     DWORD PTR [EAX + 8], ECX
      RET
    @Fill11:
      MOV     BYTE PTR [EAX + 10], CL
    @Fill10:
      MOV     DWORD PTR [EAX], ECX
      MOV     DWORD PTR [EAX + 4], ECX
      MOV     WORD PTR [EAX + 8], CX
      RET
    @Fill9:
      MOV     BYTE PTR [EAX + 8], CL
    @Fill8:
      MOV     DWORD PTR [EAX], ECX
      MOV     DWORD PTR [EAX + 4], ECX
      RET
    @Fill7:
      MOV     BYTE PTR [EAX + 6], CL
    @Fill6:
      MOV     DWORD PTR [EAX], ECX
      MOV     WORD PTR [EAX + 4], CX
      RET
    @Fill5:
      MOV     BYTE PTR [EAX + 4], CL
    @Fill4:
      MOV     DWORD PTR [EAX], ECX
      RET
    @Fill3:
      MOV     BYTE PTR [EAX + 2], CL
    @Fill2:
      MOV     WORD PTR [EAX], CX
      RET
    @Fill1:
      MOV     BYTE PTR [EAX], CL
    @Fill0:
    @Fin:
end;
{$ELSE}
procedure FillMem(var Buf; const Count: Integer; const Value: Byte);
begin
  FillChar(Buf, Count, Value);
end;
{$ENDIF}

{$IFDEF UseAsmMemFunction}
procedure ZeroMem(var Buf; const Count: Integer);
asm
    // EAX = Buf, EDX = Count
    OR     EDX, EDX
    JLE    @Zero0
    CMP    EDX, 16
    JA     @GeneralZeroMem
    XOR    ECX, ECX
    JMP    DWORD PTR @SmallZeroJumpTable[EDX * 4]
  @SmallZeroJumpTable:
    DD     @Zero0,  @Zero1,  @Zero2,  @Zero3
    DD     @Zero4,  @Zero5,  @Zero6,  @Zero7
    DD     @Zero8,  @Zero9,  @Zero10, @Zero11
    DD     @Zero12, @Zero13, @Zero14, @Zero15
    DD     @Zero16
  @Zero16:
    MOV    DWORD PTR [EAX], ECX
    MOV    DWORD PTR [EAX + 4], ECX
    MOV    DWORD PTR [EAX + 8], ECX
    MOV    DWORD PTR [EAX + 12], ECX
    RET
  @Zero15:
    MOV    BYTE PTR [EAX + 14], CL
  @Zero14:
    MOV    DWORD PTR [EAX], ECX
    MOV    DWORD PTR [EAX + 4], ECX
    MOV    DWORD PTR [EAX + 8], ECX
    MOV    WORD PTR [EAX + 12], CX
    RET
  @Zero13:
    MOV    BYTE PTR [EAX + 12], CL
  @Zero12:
    MOV    DWORD PTR [EAX], ECX
    MOV    DWORD PTR [EAX + 4], ECX
    MOV    DWORD PTR [EAX + 8], ECX
    RET
  @Zero11:
    MOV    BYTE PTR [EAX + 10], CL
  @Zero10:
    MOV    DWORD PTR [EAX], ECX
    MOV    DWORD PTR [EAX + 4], ECX
    MOV    WORD PTR [EAX + 8], CX
    RET
  @Zero9:
    MOV    BYTE PTR [EAX + 8], CL
  @Zero8:
    MOV    DWORD PTR [EAX], ECX
    MOV    DWORD PTR [EAX + 4], ECX
    RET
  @Zero7:
    MOV    BYTE PTR [EAX + 6], CL
  @Zero6:
    MOV    DWORD PTR [EAX], ECX
    MOV    WORD PTR [EAX + 4], CX
    RET
  @Zero5:
    MOV    BYTE PTR [EAX + 4], CL
  @Zero4:
    MOV    DWORD PTR [EAX], ECX
    RET
  @Zero3:
    MOV    BYTE PTR [EAX + 2], CL
  @Zero2:
    MOV    WORD PTR [EAX], CX
    RET
  @Zero1:
    MOV    BYTE PTR [EAX], CL
  @Zero0:
    RET
  @GeneralZeroMem:
    PUSH   EDI
    MOV    EDI, EAX
    XOR    EAX, EAX
    MOV    ECX, EDX
    SHR    ECX, 2
    REP    STOSD
    MOV    ECX, EDX
    AND    ECX, 3
    REP    STOSB
    POP    EDI
end;
{$ELSE}
procedure ZeroMem(var Buf; const Count: Integer);
begin
  FillChar(Buf, Count, #0);
end;
{$ENDIF}

procedure GetZeroMem(var P: Pointer; const Size: Integer);
begin
  GetMem(P, Size);
  ZeroMem(P^, Size);
end;

{$IFDEF UseAsmMemFunction}
{ Note: MoveMem implements a "safe move", that is, the Source and Dest memory  }
{ blocks are allowed to overlap.                                               }
procedure MoveMem(const Source; var Dest; const Count: Integer);
asm
    // EAX = Source, EDX = Dest, ECX = Count
    OR     ECX, ECX
    JLE    @Move0
    CMP    EAX, EDX
    JE     @Move0
    JB     @CheckSafe
  @GeneralMove:
    CMP    ECX, 16
    JA     @LargeMove
    JMP    DWORD PTR @SmallMoveJumpTable[ECX * 4]
  @CheckSafe:
    ADD    EAX, ECX
    CMP    EAX, EDX
    JBE    @IsSafe
  @NotSafe:
    SUB    EAX, ECX
    CMP    ECX, 10
    JA     @LargeMoveReverse
    JMP    DWORD PTR @SmallMoveJumpTable[ECX * 4]
  @IsSafe:
    SUB    EAX, ECX
    CMP    ECX, 16
    JA     @LargeMove
    JMP    DWORD PTR @SmallMoveJumpTable[ECX * 4]
  @SmallMoveJumpTable:
    DD     @Move0,  @Move1,  @Move2,  @Move3
    DD     @Move4,  @Move5,  @Move6,  @Move7
    DD     @Move8,  @Move9,  @Move10, @Move11
    DD     @Move12, @Move13, @Move14, @Move15
    DD     @Move16
  @Move16:
    PUSH   EBX
    MOV    ECX, [EAX]
    MOV    EBX, [EAX + 4]
    MOV    [EDX],      ECX
    MOV    [EDX + 4],  EBX
    MOV    ECX, [EAX + 8]
    MOV    EBX, [EAX + 12]
    MOV    [EDX + 8],  ECX
    MOV    [EDX + 12], EBX
    POP    EBX
    RET
  @Move15:
    PUSH   EBX
    MOV    ECX, [EAX]
    MOV    EBX, [EAX + 4]
    MOV    [EDX],      ECX
    MOV    [EDX + 4],  EBX
    MOV    ECX, [EAX + 8]
    MOV    BX,  [EAX + 12]
    MOV    AL,  [EAX + 14]
    MOV    [EDX + 8],  ECX
    MOV    [EDX + 12], BX
    MOV    [EDX + 14], AL
    POP    EBX
    RET
  @Move14:
    PUSH   EBX
    MOV    ECX, [EAX]
    MOV    EBX, [EAX + 4]
    MOV    [EDX],      ECX
    MOV    [EDX + 4],  EBX
    MOV    ECX, [EAX + 8]
    MOV    BX,  [EAX + 12]
    MOV    [EDX + 8],  ECX
    MOV    [EDX + 12], BX
    POP    EBX
    RET
  @Move13:
    PUSH   EBX
    MOV    ECX, [EAX]
    MOV    EBX, [EAX + 4]
    MOV    [EDX],      ECX
    MOV    [EDX + 4],  EBX
    MOV    ECX, [EAX + 8]
    MOV    BL,  [EAX + 12]
    MOV    [EDX + 8],  ECX
    MOV    [EDX + 12], BL
    POP    EBX
    RET
  @Move12:
    PUSH   EBX
    MOV    ECX, [EAX]
    MOV    EBX, [EAX + 4]
    MOV    EAX, [EAX + 8]
    MOV    [EDX],     ECX
    MOV    [EDX + 4], EBX
    MOV    [EDX + 8], EAX
    POP    EBX
    RET
  @Move11:
    PUSH   EBX
    MOV    ECX, [EAX]
    MOV    EBX, [EAX + 4]
    MOV    [EDX],      ECX
    MOV    [EDX + 4],  EBX
    MOV    CX,  [EAX + 8]
    MOV    BL,  [EAX + 10]
    MOV    [EDX + 8],  CX
    MOV    [EDX + 10], BL
    POP    EBX
    RET
  @Move10:
    PUSH   EBX
    MOV    ECX, [EAX]
    MOV    EBX, [EAX + 4]
    MOV    AX,  [EAX + 8]
    MOV    [EDX],     ECX
    MOV    [EDX + 4], EBX
    MOV    [EDX + 8], AX
    POP    EBX
    RET
  @Move9:
    PUSH   EBX
    MOV    ECX, [EAX]
    MOV    EBX, [EAX + 4]
    MOV    AL,  [EAX + 8]
    MOV    [EDX],     ECX
    MOV    [EDX + 4], EBX
    MOV    [EDX + 8], AL
    POP    EBX
    RET
  @Move8:
    MOV    ECX, [EAX]
    MOV    EAX, [EAX + 4]
    MOV    [EDX],     ECX
    MOV    [EDX + 4], EAX
    RET
  @Move7:
    PUSH   EBX
    MOV    ECX, [EAX]
    MOV    BX,  [EAX + 4]
    MOV    AL,  [EAX + 6]
    MOV    [EDX],     ECX
    MOV    [EDX + 4], BX
    MOV    [EDX + 6], AL
    POP    EBX
    RET
  @Move6:
    MOV    ECX, [EAX]
    MOV    AX,  [EAX + 4]
    MOV    [EDX],     ECX
    MOV    [EDX + 4], AX
    RET
  @Move5:
    MOV    ECX, [EAX]
    MOV    AL,  [EAX + 4]
    MOV    [EDX],     ECX
    MOV    [EDX + 4], AL
    RET
  @Move4:
    MOV    ECX, [EAX]
    MOV    [EDX], ECX
    RET
  @Move3:
    MOV    CX, [EAX]
    MOV    AL, [EAX + 2]
    MOV    [EDX],     CX
    MOV    [EDX + 2], AL
    RET
  @Move2:
    MOV    CX, [EAX]
    MOV    [EDX], CX
    RET
  @Move1:
    MOV    CL, [EAX]
    MOV    [EDX], CL
  @Move0:
    RET
  @LargeMove:
    PUSH   ESI
    PUSH   EDI
    MOV    ESI, EAX
    MOV    EDI, EDX
    MOV    EDX, ECX
    SHR    ECX, 2
    REP    MOVSD
    MOV    ECX, EDX
    AND    ECX, 3
    REP    MOVSB
    POP    EDI
    POP    ESI
    RET
  @LargeMoveReverse:
    PUSH   ESI
    PUSH   EDI
    MOV    ESI, EAX
    MOV    EDI, EDX
    LEA    ESI, [ESI + ECX - 4]
    LEA    EDI, [EDI + ECX - 4]
    MOV    EDX, ECX
    SHR    ECX, 2
    STD
    REP    MOVSD
    ADD    ESI, 3
    ADD    EDI, 3
    MOV    ECX, EDX
    AND    ECX, 3
    REP    MOVSB
    CLD
    POP    EDI
    POP    ESI
end;
{$ELSE}
procedure MoveMem(const Source; var Dest; const Count: Integer);
begin
  Move(Source, Dest, Count);
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
function EqualMem(const Buf1; const Buf2; const Count: Integer): Boolean;
asm
      // EAX = Buf1, EDX = Buf2, ECX = Count
      OR      ECX, ECX
      JLE     @Fin1
      CMP     EAX, EDX
      JE      @Fin1
      PUSH    ESI
      PUSH    EDI
      MOV     ESI, EAX
      MOV     EDI, EDX
      MOV     EDX, ECX
      SHR     ECX, 2
      XOR     EAX, EAX
      REPE    CMPSD
      JNE     @Fin0
      MOV     ECX, EDX
      AND     ECX, 3
      REPE    CMPSB
      JNE     @Fin0
      INC     EAX
@Fin0:
      POP     EDI
      POP     ESI
      RET
@Fin1:
      MOV     AL, 1
end;
{$ELSE}
function EqualMem(const Buf1; const Buf2; const Count: Integer): Boolean;
var P, Q : Pointer;
    D, I : Integer;
begin
  P := @Buf1;
  Q := @Buf2;
  if (Count <= 0) or (P = Q) then
    begin
      Result := True;
      exit;
    end;
  D := Word32(Count) div 4;
  for I := 1 to D do
    if PWord32(P)^ = PWord32(Q)^ then
      begin
        Inc(PWord32(P));
        Inc(PWord32(Q));
      end
    else
      begin
        Result := False;
        exit;
      end;
  D := Word32(Count) and 3;
  for I := 1 to D do
    if PByte(P)^ = PByte(Q)^ then
      begin
        Inc(PByte(P));
        Inc(PByte(Q));
      end
    else
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ENDIF}

function EqualMemNoAsciiCase(const Buf1; const Buf2; const Count: Integer): Boolean;
var P, Q : Pointer;
    I    : Integer;
    C, D : Byte;
begin
  if Count <= 0 then
    begin
      Result := True;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  for I := 1 to Count do
    begin
      C := PByte(P)^;
      D := PByte(Q)^;
      if C in [Ord('A')..Ord('Z')] then
        C := C or 32;
      if D in [Ord('A')..Ord('Z')] then
        D := D or 32;
      if C = D then
        begin
          Inc(PByte(P));
          Inc(PByte(Q));
        end
      else
        begin
          Result := False;
          exit;
        end;
    end;
  Result := True;
end;

function CompareMem(const Buf1; const Buf2; const Count: Integer): Integer;
var P, Q : Pointer;
    I    : Integer;
    C, D : Byte;
begin
  if Count <= 0 then
    begin
      Result := 0;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  for I := 1 to Count do
    begin
      C := PByte(P)^;
      D := PByte(Q)^;
      if C = D then
        begin
          Inc(PByte(P));
          Inc(PByte(Q));
        end
      else
        begin
          if C < D then
            Result := -1
          else
            Result := 1;
          exit;
        end;
    end;
  Result := 0;
end;

function CompareMemNoAsciiCase(const Buf1; const Buf2; const Count: Integer): Integer;
var P, Q : Pointer;
    I    : Integer;
    C, D : Byte;
begin
  if Count <= 0 then
    begin
      Result := 0;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  for I := 1 to Count do
    begin
      C := PByte(P)^;
      D := PByte(Q)^;
      if C in [Ord('A')..Ord('Z')] then
        C := C or 32;
      if D in [Ord('A')..Ord('Z')] then
        D := D or 32;
      if C = D then
        begin
          Inc(PByte(P));
          Inc(PByte(Q));
        end
      else
        begin
          if C < D then
            Result := -1
          else
            Result := 1;
          exit;
        end;
    end;
  Result := 0;
end;

function LocateMem(const Buf1; const Size1: Integer; const Buf2; const Size2: Integer): Integer;
var P, Q : PByte;
    I    : Integer;
begin
  if (Size1 <= 0) or (Size2 <= 0) or (Size2 > Size1) then
    begin
      Result := -1;
      exit;
    end;
  for I := 0 to Size1 - Size2 do
    begin
      P := @Buf1;
      Inc(P, I);
      Q := @Buf2;
      if P = Q then
        begin
          Result := I;
          exit;
        end;
      if EqualMem(P^, Q^, Size2) then
        begin
          Result := I;
          exit;
        end;
    end;
  Result := -1;
end;

function LocateMemNoAsciiCase(const Buf1; const Size1: Integer; const Buf2; const Size2: Integer): Integer;
var P, Q : PByte;
    I    : Integer;
begin
  if (Size1 <= 0) or (Size2 <= 0) or (Size2 > Size1) then
    begin
      Result := -1;
      exit;
    end;
  for I := 0 to Size1 - Size2 do
    begin
      P := @Buf1;
      Inc(P, I);
      Q := @Buf2;
      if P = Q then
        begin
          Result := I;
          exit;
        end;
      if EqualMemNoAsciiCase(P^, Q^, Size2) then
        begin
          Result := I;
          exit;
        end;
    end;
  Result := -1;
end;

procedure ReverseMem(var Buf; const Size: Integer);
var I : Integer;
    P : PByte;
    Q : PByte;
    T : Byte;
begin
  P := @Buf;
  Q := P;
  Inc(Q, Size - 1);
  for I := 1 to Size div 2 do
    begin
      T := P^;
      P^ := Q^;
      Q^ := T;
      Inc(P);
      Dec(Q);
    end;
end;



{                                                                              }
{ FreeAndNil                                                                   }
{                                                                              }
procedure FreeAndNil(var Obj);
var Temp : TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;

procedure FreeObjectArray(var V);
var I : Integer;
    A : ObjectArray absolute V;
begin
  for I := Length(A) - 1 downto 0 do
    FreeAndNil(A[I]);
end;

procedure FreeObjectArray(var V; const LoIdx, HiIdx: Integer);
var I : Integer;
    A : ObjectArray absolute V;
begin
  for I := HiIdx downto LoIdx do
    FreeAndNil(A[I]);
end;

// Note: The parameter can not be changed to be untyped and then typecasted
// using an absolute variable, as in FreeObjectArray. The reference counting
// will be done incorrectly.
procedure FreeAndNilObjectArray(var V: ObjectArray);
var W : ObjectArray;
begin
  W := V;
  V := nil;
  FreeObjectArray(W);
end;



{                                                                              }
{ TBytes functions                                                             }
{                                                                              }
procedure BytesSetLengthAndZero(var V: TBytes; const NewLength: Integer);
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
  ZeroMem(V[OldLen], NewLen - OldLen);
end;

procedure BytesInit(var V: TBytes; const R: Byte);
begin
  SetLength(V, 1);
  V[0] := R;
end;

procedure BytesInit(var V: TBytes; const S: String);
var L, I : Integer;
begin
  L := Length(S);
  SetLength(V, L);
  for I := 0 to L - 1 do
    V[I] := Ord(S[I + 1]);
end;

function BytesAppend(var V: TBytes; const R: Byte): Integer;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function BytesAppend(var V: TBytes; const R: TBytes): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      MoveMem(R[0], V[Result], L);
    end;
end;

function BytesAppend(var V: TBytes; const R: array of Byte): Integer;
var L : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      MoveMem(R[0], V[Result], L);
    end;
end;

function BytesAppend(var V: TBytes; const R: String): Integer;
var L, I : Integer;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      for I := 1 to L do
        V[Result] := Ord(R[I]);
    end;
end;

function BytesCompare(const A, B: TBytes): Integer;
var L, N : Integer;
begin
  L := Length(A);
  N := Length(B);
  if L < N then
    Result := -1
  else
  if L > N then
    Result := 1
  else
    Result := CompareMem(Pointer(A)^, Pointer(B)^, L);
end;

function BytesEqual(const A, B: TBytes): Boolean;
var L, N : Integer;
begin
  L := Length(A);
  N := Length(B);
  if L <> N then
    Result := False
  else
    Result := EqualMem(Pointer(A)^, Pointer(B)^, L);
end;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF UTILS_TEST}
{$ASSERTIONS ON}
procedure Test_Misc;
var A, B : Byte;
    C, D : Word32;
    P, Q : TObject;
begin
  // Integer types
  Assert(Sizeof(Int16Rec) = Sizeof(Int16), 'Int16Rec');
  Assert(Sizeof(Int32Rec) = Sizeof(Int32), 'Int32Rec');

  // Min / Max
  Assert(MinInt(-1, 1) = -1, 'MinI');
  Assert(MaxInt(-1, 1) = 1, 'MaxI');
  Assert(MinCrd(1, 2) = 1, 'MinC');
  Assert(MaxCrd(1, 2) = 2, 'MaxC');
  Assert(MaxCrd($FFFFFFFF, 0) = $FFFFFFFF, 'MaxC');
  Assert(MinCrd($FFFFFFFF, 0) = 0, 'MinC');

  // Bouded
  Assert(Int32Bounded(10, 5, 12) = 10,                            'Bounded');
  Assert(Int32Bounded(3, 5, 12) = 5,                              'Bounded');
  Assert(Int32Bounded(15, 5, 12) = 12,                            'Bounded');
  Assert(Int32BoundedByte(256) = 255,                             'BoundedByte');
  Assert(Int32BoundedWord(-5) = 0,                                'BoundedWord');
  Assert(Int64BoundedWord32($100000000) = $FFFFFFFF,              'BoundedWord');

  // Swap
  A := $11; B := $22;
  Swap(A, B);
  Assert((A = $22) and (B = $11),              'Swap');
  C := $11111111; D := $22222222;
  Swap(C, D);
  Assert((C = $22222222) and (D = $11111111),  'Swap');
  P := TObject.Create;
  Q := nil;
  SwapObjects(P, Q);
  Assert(Assigned(Q) and not Assigned(P),      'SwapObjects');
  Q.Free;

  // iif
  Assert(iif(True, 1, 2) = 1,         'iif');
  Assert(iif(False, 1, 2) = 2,        'iif');
  Assert(iif(True, -1, -2) = -1,      'iif');
  Assert(iif(False, -1, -2) = -2,     'iif');
  Assert(iif(True, '1', '2') = '1',   'iif');
  Assert(iif(False, '1', '2') = '2',  'iif');
  Assert(iifU(True, '1', '2') = '1',  'iif');
  Assert(iifU(False, '1', '2') = '2', 'iif');
  Assert(iif(True, 1.1, 2.2) = 1.1,   'iif');
  Assert(iif(False, 1.1, 2.2) = 2.2,  'iif');

  // Compare
  Assert(Compare(1, 1) = crEqual,          'Compare');
  Assert(Compare(1, 2) = crLess,           'Compare');
  Assert(Compare(1, 0) = crGreater,        'Compare');

  Assert(Compare(1.0, 1.0) = crEqual,      'Compare');
  Assert(Compare(1.0, 1.1) = crLess,       'Compare');
  Assert(Compare(1.0, 0.9) = crGreater,    'Compare');

  Assert(Compare(False, False) = crEqual,  'Compare');
  Assert(Compare(True, True) = crEqual,    'Compare');
  Assert(Compare(False, True) = crLess,    'Compare');
  Assert(Compare(True, False) = crGreater, 'Compare');

  {$IFDEF SupportAnsiString}
  Assert(CompareA(ToAnsiString(''), ToAnsiString('')) = crEqual,        'Compare');
  Assert(CompareA(ToAnsiString('a'), ToAnsiString('a')) = crEqual,      'Compare');
  Assert(CompareA(ToAnsiString('a'), ToAnsiString('b')) = crLess,       'Compare');
  Assert(CompareA(ToAnsiString('b'), ToAnsiString('a')) = crGreater,    'Compare');
  Assert(CompareA(ToAnsiString(''), ToAnsiString('a')) = crLess,        'Compare');
  Assert(CompareA(ToAnsiString('a'), ToAnsiString('')) = crGreater,     'Compare');
  Assert(CompareA(ToAnsiString('aa'), ToAnsiString('a')) = crGreater,   'Compare');
  {$ENDIF}

  Assert(CompareB(ToRawByteString(''), ToRawByteString('')) = crEqual,        'Compare');
  Assert(CompareB(ToRawByteString('a'), ToRawByteString('a')) = crEqual,      'Compare');
  Assert(CompareB(ToRawByteString('a'), ToRawByteString('b')) = crLess,       'Compare');
  Assert(CompareB(ToRawByteString('b'), ToRawByteString('a')) = crGreater,    'Compare');
  Assert(CompareB(ToRawByteString(''), ToRawByteString('a')) = crLess,        'Compare');
  Assert(CompareB(ToRawByteString('a'), ToRawByteString('')) = crGreater,     'Compare');
  Assert(CompareB(ToRawByteString('aa'), ToRawByteString('a')) = crGreater,   'Compare');

  Assert(CompareU(ToUnicodeString(''), ToUnicodeString('')) = crEqual,        'Compare');
  Assert(CompareU(ToUnicodeString('a'), ToUnicodeString('a')) = crEqual,      'Compare');
  Assert(CompareU(ToUnicodeString('a'), ToUnicodeString('b')) = crLess,       'Compare');
  Assert(CompareU(ToUnicodeString('b'), ToUnicodeString('a')) = crGreater,    'Compare');
  Assert(CompareU(ToUnicodeString(''), ToUnicodeString('a')) = crLess,        'Compare');
  Assert(CompareU(ToUnicodeString('a'), ToUnicodeString('')) = crGreater,     'Compare');
  Assert(CompareU(ToUnicodeString('aa'), ToUnicodeString('a')) = crGreater,   'Compare');

  Assert(Sgn(1) = 1,     'Sign');
  Assert(Sgn(0) = 0,     'Sign');
  Assert(Sgn(-1) = -1,   'Sign');
  Assert(Sgn(2) = 1,     'Sign');
  Assert(Sgn(-2) = -1,   'Sign');
  Assert(Sgn(-1.5) = -1, 'Sign');
  Assert(Sgn(1.5) = 1,   'Sign');
  Assert(Sgn(0.0) = 0,   'Sign');

  Assert(InverseCompareResult(crLess) = crGreater, 'ReverseCompareResult');
  Assert(InverseCompareResult(crGreater) = crLess, 'ReverseCompareResult');
end;

procedure Test_IntStr;
var I : Int64;
    W : Word32;
    L : Integer;
    {$IFDEF SupportAnsiString}
    A : AnsiString;
    {$ENDIF}
begin
  Assert(HexCharToInt('A') = 10,   'HexCharToInt');
  Assert(HexCharToInt('a') = 10,   'HexCharToInt');
  Assert(HexCharToInt('1') = 1,    'HexCharToInt');
  Assert(HexCharToInt('0') = 0,    'HexCharToInt');
  Assert(HexCharToInt('F') = 15,   'HexCharToInt');
  Assert(HexCharToInt('G') = -1,   'HexCharToInt');

  {$IFDEF SupportAnsiString}
  Assert(IntToStringA(0) = ToAnsiString('0'),                           'IntToStringA');
  Assert(IntToStringA(1) = ToAnsiString('1'),                           'IntToStringA');
  Assert(IntToStringA(-1) = ToAnsiString('-1'),                         'IntToStringA');
  Assert(IntToStringA(10) = ToAnsiString('10'),                         'IntToStringA');
  Assert(IntToStringA(-10) = ToAnsiString('-10'),                       'IntToStringA');
  Assert(IntToStringA(123) = ToAnsiString('123'),                       'IntToStringA');
  Assert(IntToStringA(-123) = ToAnsiString('-123'),                     'IntToStringA');
  Assert(IntToStringA(MinInt32) = ToAnsiString('-2147483648'),          'IntToStringA');
  {$IFNDEF DELPHI7_DOWN}
  Assert(IntToStringA(-2147483649) = ToAnsiString('-2147483649'),       'IntToStringA');
  {$ENDIF}
  Assert(IntToStringA(MaxInt32) = ToAnsiString('2147483647'),           'IntToStringA');
  Assert(IntToStringA(2147483648) = ToAnsiString('2147483648'),         'IntToStringA');
  Assert(IntToStringA(MinInt64) = ToAnsiString('-9223372036854775808'), 'IntToStringA');
  Assert(IntToStringA(MaxInt64) = ToAnsiString('9223372036854775807'),  'IntToStringA');
  {$ENDIF}

  Assert(IntToStringB(0) = ToRawByteString('0'),                           'IntToStringB');
  Assert(IntToStringB(1) = ToRawByteString('1'),                           'IntToStringB');
  Assert(IntToStringB(-1) = ToRawByteString('-1'),                         'IntToStringB');
  Assert(IntToStringB(10) = ToRawByteString('10'),                         'IntToStringB');
  Assert(IntToStringB(-10) = ToRawByteString('-10'),                       'IntToStringB');
  Assert(IntToStringB(123) = ToRawByteString('123'),                       'IntToStringB');
  Assert(IntToStringB(-123) = ToRawByteString('-123'),                     'IntToStringB');
  Assert(IntToStringB(MinInt32) = ToRawByteString('-2147483648'),          'IntToStringB');
  {$IFNDEF DELPHI7_DOWN}
  Assert(IntToStringB(-2147483649) = ToRawByteString('-2147483649'),       'IntToStringB');
  {$ENDIF}
  Assert(IntToStringB(MaxInt32) = ToRawByteString('2147483647'),           'IntToStringB');
  Assert(IntToStringB(2147483648) = ToRawByteString('2147483648'),         'IntToStringB');
  Assert(IntToStringB(MinInt64) = ToRawByteString('-9223372036854775808'), 'IntToStringB');
  Assert(IntToStringB(MaxInt64) = ToRawByteString('9223372036854775807'),  'IntToStringB');

  Assert(IntToStringU(0) = '0',                     'IntToString');
  Assert(IntToStringU(1) = '1',                     'IntToString');
  Assert(IntToStringU(-1) = '-1',                   'IntToString');
  Assert(IntToStringU(1234567890) = '1234567890',   'IntToString');
  Assert(IntToStringU(-1234567890) = '-1234567890', 'IntToString');

  Assert(IntToString(0) = '0',                     'IntToString');
  Assert(IntToString(1) = '1',                     'IntToString');
  Assert(IntToString(-1) = '-1',                   'IntToString');
  Assert(IntToString(1234567890) = '1234567890',   'IntToString');
  Assert(IntToString(-1234567890) = '-1234567890', 'IntToString');

  {$IFDEF SupportAnsiString}
  Assert(UIntToStringA(0) = ToAnsiString('0'),                  'UIntToString');
  Assert(UIntToStringA($FFFFFFFF) = ToAnsiString('4294967295'), 'UIntToString');
  {$ENDIF}
  Assert(UIntToStringU(0) = '0',                  'UIntToString');
  Assert(UIntToStringU($FFFFFFFF) = '4294967295', 'UIntToString');
  Assert(UIntToString(0) = '0',                   'UIntToString');
  Assert(UIntToString($FFFFFFFF) = '4294967295',  'UIntToString');

  {$IFDEF SupportAnsiString}
  Assert(Word32ToStrA(0, 8) = ToAnsiString('00000000'),           'Word32ToStr');
  Assert(Word32ToStrA($FFFFFFFF, 0) = ToAnsiString('4294967295'), 'Word32ToStr');
  {$ENDIF}
  Assert(Word32ToStrB(0, 8) = ToRawByteString('00000000'),           'Word32ToStr');
  Assert(Word32ToStrB($FFFFFFFF, 0) = ToRawByteString('4294967295'), 'Word32ToStr');
  Assert(Word32ToStrU(0, 8) = '00000000',           'Word32ToStr');
  Assert(Word32ToStrU($FFFFFFFF, 0) = '4294967295', 'Word32ToStr');
  Assert(Word32ToStr(0, 8) = '00000000',            'Word32ToStr');
  Assert(Word32ToStr($FFFFFFFF, 0) = '4294967295',  'Word32ToStr');
  Assert(Word32ToStr(123) = '123',                  'Word32ToStr');
  Assert(Word32ToStr(10000) = '10000',              'Word32ToStr');
  Assert(Word32ToStr(99999) = '99999',              'Word32ToStr');
  Assert(Word32ToStr(1, 1) = '1',                   'Word32ToStr');
  Assert(Word32ToStr(1, 3) = '001',                 'Word32ToStr');
  Assert(Word32ToStr(1234, 3) = '1234',             'Word32ToStr');

  {$IFDEF SupportAnsiString}
  Assert(Word32ToHexA(0, 8) = ToAnsiString('00000000'),         'Word32ToHex');
  Assert(Word32ToHexA($FFFFFFFF, 0) = ToAnsiString('FFFFFFFF'), 'Word32ToHex');
  Assert(Word32ToHexA($10000) = ToAnsiString('10000'),          'Word32ToHex');
  Assert(Word32ToHexA($12345678) = ToAnsiString('12345678'),    'Word32ToHex');
  Assert(Word32ToHexA($AB, 4) = ToAnsiString('00AB'),           'Word32ToHex');
  Assert(Word32ToHexA($ABCD, 8) = ToAnsiString('0000ABCD'),     'Word32ToHex');
  Assert(Word32ToHexA($CDEF, 2) = ToAnsiString('CDEF'),         'Word32ToHex');
  Assert(Word32ToHexA($ABC3, 0, False) = ToAnsiString('abc3'),  'Word32ToHex');
  {$ENDIF}

  Assert(Word32ToHexU(0, 8) = '00000000',         'Word32ToHex');
  Assert(Word32ToHexU(0) = '0',                   'Word32ToHex');
  Assert(Word32ToHexU($FFFFFFFF, 0) = 'FFFFFFFF', 'Word32ToHex');
  Assert(Word32ToHexU($AB, 4) = '00AB',           'Word32ToHex');
  Assert(Word32ToHexU($ABC3, 0, False) = 'abc3',  'Word32ToHex');

  Assert(Word32ToHex(0, 8) = '00000000',          'Word32ToHex');
  Assert(Word32ToHex($FFFFFFFF, 0) = 'FFFFFFFF',  'Word32ToHex');
  Assert(Word32ToHex(0) = '0',                    'Word32ToHex');
  Assert(Word32ToHex($ABCD, 8) = '0000ABCD',      'Word32ToHex');
  Assert(Word32ToHex($ABC3, 0, False) = 'abc3',   'Word32ToHex');

  {$IFDEF SupportAnsiString}
  Assert(StringToIntA(ToAnsiString('0')) = 0,       'StringToInt');
  Assert(StringToIntA(ToAnsiString('1')) = 1,       'StringToInt');
  Assert(StringToIntA(ToAnsiString('-1')) = -1,     'StringToInt');
  Assert(StringToIntA(ToAnsiString('10')) = 10,     'StringToInt');
  Assert(StringToIntA(ToAnsiString('01')) = 1,      'StringToInt');
  Assert(StringToIntA(ToAnsiString('-10')) = -10,   'StringToInt');
  Assert(StringToIntA(ToAnsiString('-01')) = -1,    'StringToInt');
  Assert(StringToIntA(ToAnsiString('123')) = 123,   'StringToInt');
  Assert(StringToIntA(ToAnsiString('-123')) = -123, 'StringToInt');
  {$ENDIF}

  Assert(StringToIntB(ToRawByteString('321')) = 321,   'StringToInt');
  Assert(StringToIntB(ToRawByteString('-321')) = -321, 'StringToInt');

  Assert(StringToIntU('321') = 321,   'StringToInt');
  Assert(StringToIntU('-321') = -321, 'StringToInt');

  {$IFDEF SupportAnsiString}
  A := ToAnsiString('-012A');
  Assert(TryStringToInt64PB(PAnsiChar(A), Length(A), I, L) = convertOK,          'StringToInt');
  Assert((I = -12) and (L = 4),                                                  'StringToInt');
  A := ToAnsiString('-A012');
  Assert(TryStringToInt64PB(PAnsiChar(A), Length(A), I, L) = convertFormatError, 'StringToInt');
  Assert((I = 0) and (L = 1),                                                    'StringToInt');

  Assert(TryStringToInt64A(ToAnsiString('0'), I),                        'StringToInt');
  Assert(I = 0,                                            'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('-0'), I),                       'StringToInt');
  Assert(I = 0,                                            'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('+0'), I),                       'StringToInt');
  Assert(I = 0,                                            'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('1234'), I),                     'StringToInt');
  Assert(I = 1234,                                         'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('-1234'), I),                    'StringToInt');
  Assert(I = -1234,                                        'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('000099999'), I),                'StringToInt');
  Assert(I = 99999,                                        'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('999999999999999999'), I),       'StringToInt');
  Assert(I = 999999999999999999,                           'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('-999999999999999999'), I),      'StringToInt');
  Assert(I = -999999999999999999,                          'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('4294967295'), I),               'StringToInt');
  Assert(I = $FFFFFFFF,                                    'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('4294967296'), I),               'StringToInt');
  Assert(I = $100000000,                                   'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('9223372036854775807'), I),      'StringToInt');
  Assert(I = 9223372036854775807,                          'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(TryStringToInt64A(ToAnsiString('-9223372036854775808'), I),     'StringToInt');
  Assert(I = -9223372036854775808,                         'StringToInt');
  {$ENDIF}
  Assert(not TryStringToInt64A(ToAnsiString(''), I),                     'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('-'), I),                    'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('+'), I),                    'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('+-0'), I),                  'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('0A'), I),                   'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('1A'), I),                   'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString(' 0'), I),                   'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('0 '), I),                   'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('9223372036854775808'), I),  'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(not TryStringToInt64A(ToAnsiString('-9223372036854775809'), I), 'StringToInt');
  {$ENDIF}
  {$ENDIF}

  Assert(TryStringToInt64U('9223372036854775807', I),      'StringToInt');
  Assert(I = 9223372036854775807,                          'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(TryStringToInt64U('-9223372036854775808', I),     'StringToInt');
  Assert(I = -9223372036854775808,                         'StringToInt');
  Assert(not TryStringToInt64U('', I),                     'StringToInt');
  Assert(not TryStringToInt64U('-', I),                    'StringToInt');
  Assert(not TryStringToInt64U('0A', I),                   'StringToInt');
  Assert(not TryStringToInt64U('9223372036854775808', I),  'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(not TryStringToInt64U('-9223372036854775809', I), 'StringToInt');
  {$ENDIF}
  {$ENDIF}

  Assert(TryStringToInt64('9223372036854775807', I),       'StringToInt');
  Assert(I = 9223372036854775807,                          'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(TryStringToInt64('-9223372036854775808', I),      'StringToInt');
  Assert(I = -9223372036854775808,                         'StringToInt');
  {$ENDIF}
  Assert(not TryStringToInt64('', I),                      'StringToInt');
  Assert(not TryStringToInt64('-', I),                     'StringToInt');
  Assert(not TryStringToInt64('9223372036854775808', I),   'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(not TryStringToInt64('-9223372036854775809', I),  'StringToInt');
  {$ENDIF}

  {$IFDEF SupportAnsiString}
  Assert(StringToInt64A(ToAnsiString('0')) = 0,                                       'StringToInt64');
  Assert(StringToInt64A(ToAnsiString('1')) = 1,                                       'StringToInt64');
  Assert(StringToInt64A(ToAnsiString('-123')) = -123,                                 'StringToInt64');
  Assert(StringToInt64A(ToAnsiString('-0001')) = -1,                                  'StringToInt64');
  Assert(StringToInt64A(ToAnsiString('-9223372036854775807')) = -9223372036854775807, 'StringToInt64');
  {$IFNDEF DELPHI7_DOWN}
  Assert(StringToInt64A(ToAnsiString('-9223372036854775808')) = -9223372036854775808, 'StringToInt64');
  {$ENDIF}
  Assert(StringToInt64A(ToAnsiString('9223372036854775807')) = 9223372036854775807,   'StringToInt64');

  Assert(HexToUIntA(ToAnsiString('FFFFFFFF')) = $FFFFFFFF, 'HexStringToUInt');
  Assert(HexToUIntA(ToAnsiString('FFFFFFFF')) = $FFFFFFFF, 'HexStringToUInt');
  {$ENDIF}
  Assert(HexToUInt('FFFFFFFF') = $FFFFFFFF,  'HexStringToUInt');

  Assert(HexToWord32('FFFFFFFF') = $FFFFFFFF,  'HexToWord32');
  Assert(HexToWord32('0') = 0,                 'HexToWord32');
  Assert(HexToWord32('123456') = $123456,      'HexToWord32');
  Assert(HexToWord32('ABC') = $ABC,            'HexToWord32');
  Assert(HexToWord32('abc') = $ABC,            'HexToWord32');
  Assert(not TryHexToWord32('', W),            'HexToWord32');
  Assert(not TryHexToWord32('x', W),           'HexToWord32');

  {$IFDEF SupportAnsiString}
  Assert(HexToWord32A(ToAnsiString('FFFFFFFF')) = $FFFFFFFF, 'HexToWord32');
  Assert(HexToWord32A(ToAnsiString('0')) = 0,                'HexToWord32');
  Assert(HexToWord32A(ToAnsiString('ABC')) = $ABC,           'HexToWord32');
  Assert(HexToWord32A(ToAnsiString('abc')) = $ABC,           'HexToWord32');
  Assert(not TryHexToWord32A(ToAnsiString(''), W),           'HexToWord32');
  Assert(not TryHexToWord32A(ToAnsiString('x'), W),          'HexToWord32');
  {$ENDIF}

  Assert(HexToWord32B(ToRawByteString('FFFFFFFF')) = $FFFFFFFF, 'HexToWord32');
  Assert(HexToWord32B(ToRawByteString('0')) = 0,                'HexToWord32');
  Assert(HexToWord32B(ToRawByteString('ABC')) = $ABC,           'HexToWord32');
  Assert(HexToWord32B(ToRawByteString('abc')) = $ABC,           'HexToWord32');
  Assert(not TryHexToWord32B(ToRawByteString(''), W),           'HexToWord32');
  Assert(not TryHexToWord32B(ToRawByteString('x'), W),          'HexToWord32');

  Assert(HexToWord32U('FFFFFFFF') = $FFFFFFFF, 'HexToWord32');
  Assert(HexToWord32U('0') = 0,                'HexToWord32');
  Assert(HexToWord32U('123456') = $123456,     'HexToWord32');
  Assert(HexToWord32U('ABC') = $ABC,           'HexToWord32');
  Assert(HexToWord32U('abc') = $ABC,           'HexToWord32');
  Assert(not TryHexToWord32U('', W),           'HexToWord32');
  Assert(not TryHexToWord32U('x', W),          'HexToWord32');

  {$IFDEF SupportAnsiString}
  Assert(not TryStringToWord32A(ToAnsiString(''), W),             'StringToWord32');
  Assert(StringToWord32A(ToAnsiString('123')) = 123,              'StringToWord32');
  Assert(StringToWord32A(ToAnsiString('4294967295')) = $FFFFFFFF, 'StringToWord32');
  Assert(StringToWord32A(ToAnsiString('999999999')) = 999999999,  'StringToWord32');
  {$ENDIF}

  Assert(StringToWord32B(ToRawByteString('0')) = 0,                  'StringToWord32');
  Assert(StringToWord32B(ToRawByteString('4294967295')) = $FFFFFFFF, 'StringToWord32');

  Assert(StringToWord32U('0') = 0,                  'StringToWord32');
  Assert(StringToWord32U('4294967295') = $FFFFFFFF, 'StringToWord32');

  Assert(StringToWord32('0') = 0,                   'StringToWord32');
  Assert(StringToWord32('4294967295') = $FFFFFFFF,  'StringToWord32');
end;

procedure Test_Hash;
begin
  // HashStr
  {$IFDEF SupportAnsiString}
  Assert(HashStrA(ToAnsiString('Fundamentals')) = $3FB7796E, 'HashStr');
  Assert(HashStrA(ToAnsiString('0')) = $B2420DE,             'HashStr');
  Assert(HashStrA(ToAnsiString('Fundamentals'), 1, -1, False) = HashStrA(ToAnsiString('FUNdamentals'), 1, -1, False), 'HashStr');
  Assert(HashStrA(ToAnsiString('Fundamentals'), 1, -1, True) <> HashStrA(ToAnsiString('FUNdamentals'), 1, -1, True),  'HashStr');
  {$ENDIF}

  Assert(HashStrB(ToRawByteString('Fundamentals')) = $3FB7796E, 'HashStr');
  Assert(HashStrB(ToRawByteString('0')) = $B2420DE,             'HashStr');
  Assert(HashStrB(ToRawByteString('Fundamentals'), 1, -1, False) = HashStrB(ToRawByteString('FUNdamentals'), 1, -1, False), 'HashStr');
  Assert(HashStrB(ToRawByteString('Fundamentals'), 1, -1, True) <> HashStrB(ToRawByteString('FUNdamentals'), 1, -1, True),  'HashStr');

  Assert(HashStrU(ToUnicodeString('Fundamentals')) = $FD6ED837, 'HashStr');
  Assert(HashStrU(ToUnicodeString('0')) = $6160DBF3,            'HashStr');
  Assert(HashStrU(ToUnicodeString('Fundamentals'), 1, -1, False) = HashStrU(ToUnicodeString('FUNdamentals'), 1, -1, False), 'HashStr');
  Assert(HashStrU(ToUnicodeString('Fundamentals'), 1, -1, True) <> HashStrU(ToUnicodeString('FUNdamentals'), 1, -1, True),  'HashStr');

  {$IFDEF StringIsUnicode}
  Assert(HashStr('Fundamentals') = $FD6ED837, 'HashStr');
  Assert(HashStr('0') = $6160DBF3,            'HashStr');
  {$ELSE}
  Assert(HashStr('Fundamentals') = $3FB7796E, 'HashStr');
  Assert(HashStr('0') = $B2420DE,             'HashStr');
  {$ENDIF}
  Assert(HashStr('Fundamentals', 1, -1, False) = HashStr('FUNdamentals', 1, -1, False), 'HashStr');
  Assert(HashStr('Fundamentals', 1, -1, True) <> HashStr('FUNdamentals', 1, -1, True),  'HashStr');
end;

procedure Test_Memory;
var I, J : Integer;
    {$IFDEF SupportAnsiString}
    A, B : AnsiString;
    {$ENDIF}
begin
  {$IFDEF SupportAnsiString}
  for I := -1 to 33 do
    begin
      A := ToAnsiString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      B := ToAnsiString('                                    ');
      MoveMem(A[1], B[1], I);
      for J := 1 to MinInt(I, 10) do
        Assert(B[J] = AnsiChar(48 + J - 1),     'MoveMem');
      for J := 11 to MinInt(I, 36) do
        Assert(B[J] = AnsiChar(65 + J - 11),    'MoveMem');
      for J := MaxInt(I + 1, 1) to 36 do
        Assert(B[J] = AnsiChar(Ord(' ')),                  'MoveMem');
      Assert(EqualMem(A[1], B[1], I),     'CompareMem');
    end;

  for J := 1000 to 1500 do
    begin
      SetLength(A, 4096);
      for I := 1 to 4096 do
        A[I] := AnsiChar(Ord('A'));
      SetLength(B, 4096);
      for I := 1 to 4096 do
        B[I] := AnsiChar(Ord('B'));
      MoveMem(A[1], B[1], J);
      for I := 1 to J do
        Assert(B[I] = AnsiChar(Ord('A')), 'MoveMem');
      for I := J + 1 to 4096 do
        Assert(B[I] = AnsiChar(Ord('B')), 'MoveMem');
      Assert(EqualMem(A[1], B[1], J),     'CompareMem');
    end;

  B := ToAnsiString('1234567890');
  MoveMem(B[1], B[3], 4);
  Assert(B = ToAnsiString('1212347890'), 'MoveMem');
  MoveMem(B[3], B[2], 4);
  Assert(B = ToAnsiString('1123447890'), 'MoveMem');
  MoveMem(B[1], B[3], 2);
  Assert(B = ToAnsiString('1111447890'), 'MoveMem');
  MoveMem(B[5], B[7], 3);
  Assert(B = ToAnsiString('1111444470'), 'MoveMem');
  MoveMem(B[9], B[10], 1);
  Assert(B = ToAnsiString('1111444477'), 'MoveMem');

  for I := -1 to 33 do
    begin
      A := ToAnsiString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      ZeroMem(A[1], I);
      for J := 1 to I do
        Assert(A[J] = AnsiChar(0),                       'ZeroMem');
      for J := MaxInt(I + 1, 1) to 10 do
        Assert(A[J] = AnsiChar(48 + J - 1),     'ZeroMem');
      for J := MaxInt(I + 1, 11) to 36 do
        Assert(A[J] = AnsiChar(65 + J - 11),    'ZeroMem');
    end;

  for I := -1 to 33 do
    begin
      A := ToAnsiString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      FillMem(A[1], I, Ord('!'));
      for J := 1 to I do
        Assert(A[J] = AnsiChar(Ord('!')),                      'FillMem');
      for J := MaxInt(I + 1, 1) to 10 do
        Assert(A[J] = AnsiChar(48 + J - 1),     'FillMem');
      for J := MaxInt(I + 1, 11) to 36 do
        Assert(A[J] = AnsiChar(65 + J - 11),    'FillMem');
    end;
  {$ENDIF}
end;

{$IFDEF ImplementsStringRefCount}
procedure Test_StringRefCount;
const
  C1 = 'ABC';
var
  B, C : RawByteString;
  {$IFDEF SupportUnicodeString}
  U, V : UnicodeString;
  {$ENDIF}
begin
  B := C1;
  Assert(StringRefCount(B) = -1);
  C := B;
  Assert(StringRefCount(C) = -1);
  C[1] := '1';
  Assert(StringRefCount(C) = 1);
  B := C;
  Assert(StringRefCount(B) = 2);

  {$IFDEF SupportUnicodeString}
  U := C1;
  Assert(StringRefCount(U) = -1);
  V := U;
  Assert(StringRefCount(V) = -1);
  V[1] := '1';
  Assert(StringRefCount(V) = 1);
  U := V;
  Assert(StringRefCount(U) = 2);
  {$ENDIF}
end;
{$ENDIF}

procedure Test;
begin
  {$IFDEF CPU_INTEL386}
  Set8087CW(Default8087CW);
  {$ENDIF}
  Test_Misc;
  Test_IntStr;
  Test_Hash;
  Test_Memory;
  {$IFDEF ImplementsStringRefCount}
  Test_StringRefCount;
  {$ENDIF}
end;
{$ENDIF}



end.

