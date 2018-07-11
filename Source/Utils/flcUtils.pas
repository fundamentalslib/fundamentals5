{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcUtils.pas                                             }
{   File version:     5.61                                                     }
{   Description:      Simple data types: Definitions and utility functions.    }
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
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 5 Win32                      4.55  2015/03/14                       }
{   Delphi 6 Win32                      4.55  2015/03/14                       }
{   Delphi 7 Win32                      4.55  2015/03/14                       }
{   Delphi 2007 Win32                   4.50  2012/08/26                       }
{   Delphi 2009 Win32                   4.46  2011/09/27                       }
{   Delphi 2009 .NET                    4.45  2009/10/09                       }
{   Delphi XE                           4.52  2013/03/22                       }
{   Delphi XE2 Win32                    4.54  2014/01/31                       }
{   Delphi XE2 Win64                    4.54  2014/01/31                       }
{   Delphi XE3 Win64                    4.51  2013/01/29                       }
{   Delphi XE7 Win32                    5.59  2016/01/09                       }
{   Delphi XE7 Win64                    5.59  2016/01/09                       }
{   Delphi XE8 Win32                    5.58  2016/01/10                       }
{   Delphi XE8 Win64                    5.58  2016/01/10                       }
{   Delphi 10 Win32                     5.58  2016/01/09                       }
{   Delphi 10 Win64                     5.58  2016/01/09                       }
{   FreePascal 2.0.4 Linux i386                                                }
{   FreePascal 2.4.0 OSX x86-64         4.46  2010/06/27                       }
{   FreePascal 2.6.0 Win32              4.50  2012/08/30                       }
{   FreePascal 2.6.2 Linux x64          4.55  2015/04/01                       }
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
  SysUtils;



{                                                                              }
{ Version                                                                      }
{                                                                              }
const
  FundamentalsVersion = '5.01';



{                                                                              }
{ Integer types                                                                }
{                                                                              }
{   Unsigned integers                     Signed integers                      }
{   --------------------------------      --------------------------------     }
{   Byte        unsigned 8 bits           ShortInt   signed 8 bits             }
{   Word        unsigned 16 bits          SmallInt   signed 16 bits            }
{   LongWord    unsigned 32 bits          LongInt    signed 32 bits            }
{   UInt64      unsigned 64 bits          Int64      signed 64 bits            }
{   Cardinal    unsigned 32 bits          Integer    signed 32 bits            }
{   NativeUInt  unsigned system word      NativeInt  signed system word        }
{                                                                              }
type
  Int8      = ShortInt;
  Int16     = SmallInt;
  Int32     = LongInt;

  UInt8     = Byte;
  UInt16    = Word;
  UInt32    = LongWord;
  {$IFNDEF SupportUInt64}
  UInt64    = type Int64;
  {$ENDIF}

  Word8     = UInt8;
  Word16    = UInt16;
  Word32    = UInt32;
  Word64    = UInt64;

  {$IFNDEF SupportNativeInt}
  {$IFDEF CPU_X86_64}
  NativeInt   = type Int64;
  {$ELSE}
  NativeInt   = type Integer;
  {$ENDIF}
  PNativeInt  = ^NativeInt;
  {$ENDIF}
  {$IFDEF FREEPASCAL}
  PNativeInt  = ^NativeInt;
  {$ENDIF}
  {$IFDEF DELPHI2010}
  PNativeInt  = ^NativeInt;
  {$ENDIF}

  {$IFNDEF SupportNativeUInt}
  {$IFDEF CPU_X86_64}
  NativeUInt  = type Word64;
  {$ELSE}
  NativeUInt  = type Cardinal;
  {$ENDIF}
  PNativeUInt = ^NativeUInt;
  {$ENDIF}
  {$IFDEF FREEPASCAL}
  PNativeUInt = ^NativeUInt;
  {$ENDIF}
  {$IFDEF DELPHI2010}
  PNativeUInt = ^NativeUInt;
  {$ENDIF}

  {$IFDEF DELPHI5_DOWN}
  PByte       = ^Byte;
  PWord       = ^Word;
  PLongWord   = ^LongWord;
  PShortInt   = ^ShortInt;
  PSmallInt   = ^SmallInt;
  PLongInt    = ^LongInt;
  PInteger    = ^Integer;
  PInt64      = ^Int64;
  {$ENDIF}

  PInt8     = ^Int8;
  PInt16    = ^Int16;
  PInt32    = ^Int32;

  PWord8    = ^Word8;
  PWord16   = ^Word16;
  PWord32   = ^Word32;

  PUInt8    = ^UInt8;
  PUInt16   = ^UInt16;
  PUInt32   = ^UInt32;
  PUInt64   = ^UInt64;

  {$IFNDEF ManagedCode}
  SmallIntRec = packed record
    case Integer of
      0 : (Lo, Hi : Byte);
      1 : (Bytes  : array[0..1] of Byte);
  end;

  LongIntRec = packed record
    case Integer of
      0 : (Lo, Hi : Word);
      1 : (Words  : array[0..1] of Word);
      2 : (Bytes  : array[0..3] of Byte);
  end;
  PLongIntRec = ^LongIntRec;
  {$ENDIF}

const
  MinByte       = Low(Byte);
  MaxByte       = High(Byte);
  MinWord       = Low(Word);
  MaxWord       = High(Word);
  MinShortInt   = Low(ShortInt);
  MaxShortInt   = High(ShortInt);
  MinSmallInt   = Low(SmallInt);
  MaxSmallInt   = High(SmallInt);
  MinLongWord   = LongWord(Low(LongWord));
  MaxLongWord   = LongWord(High(LongWord));
  MinLongInt    = LongInt(Low(LongInt));
  MaxLongInt    = LongInt(High(LongInt));
  MinInt64      = Int64(Low(Int64));
  MaxInt64      = Int64(High(Int64));
  MinInteger    = Integer(Low(Integer));
  MaxInteger    = Integer(High(Integer));
  MinCardinal   = Cardinal(Low(Cardinal));
  MaxCardinal   = Cardinal(High(Cardinal));
  MinNativeUInt = NativeUInt(Low(NativeUInt));
  MaxNativeUInt = NativeUInt(High(NativeUInt));
  MinNativeInt  = NativeInt(Low(NativeInt));
  MaxNativeInt  = NativeInt(High(NativeInt));

const
  BitsPerByte       = 8;
  BitsPerLongWord   = 32;
  NativeWordSize    = SizeOf(NativeInt);
  BitsPerNativeWord = NativeWordSize * 8;



{                                                                              }
{ Boolean types                                                                }
{                                                                              }
{   Boolean    -        -                                                      }
{   ByteBool   Bool8    8 bits                                                 }
{   WordBool   Bool16   16 bits                                                }
{   LongBool   Bool32   32 bits                                                }
{                                                                              }
type
  Bool8     = ByteBool;
  Bool16    = WordBool;
  Bool32    = LongBool;

  {$IFDEF DELPHI5_DOWN}
  PBoolean  = ^Boolean;
  PByteBool = ^ByteBool;
  PWordBool = ^WordBool;
  {$ENDIF}
  {$IFNDEF FREEPASCAL}
  PLongBool = ^LongBool;
  {$ENDIF}

  PBool8    = ^Bool8;
  PBool16   = ^Bool16;
  PBool32   = ^Bool32;



{                                                                              }
{ Real types                                                                   }
{                                                                              }
{   Floating point                                                             }
{     Single    32 bits  7-8 significant digits                                }
{     Double    64 bits  15-16 significant digits                              }
{     Extended  80 bits  19-20 significant digits (mapped to Double in .NET)   }
{                                                                              }
{   Fixed point                                                                }
{     Currency  64 bits  19-20 significant digits, 4 after the decimal point.  }
{                                                                              }
const
  MinSingle   : Single   = 1.5E-45;
  MaxSingle   : Single   = 3.4E+38;
  MinDouble   : Double   = 5.0E-324;
  MaxDouble   : Double   = 1.7E+308;
  {$IFDEF ExtendedIsDouble}
  MinExtended : Extended = 5.0E-324;
  MaxExtended : Extended = 1.7E+308;
  {$ELSE}
  MinExtended : Extended = 3.4E-4932;
  MaxExtended : Extended = 1.1E+4932;
  {$ENDIF}
  {$IFNDEF CLR}
  MinCurrency : Currency = -922337203685477.5807;
  MaxCurrency : Currency = 922337203685477.5807;
  {$ENDIF}

type
  {$IFDEF DELPHI5_DOWN}
  PSingle   = ^Single;
  PDouble   = ^Double;
  PExtended = ^Extended;
  PCurrency = ^Currency;
  {$ENDIF}

  {$IFNDEF ManagedCode}
  {$IFNDEF ExtendedIsDouble}
  ExtendedRec = packed record
    case Boolean of
      True: (
        Mantissa : packed array[0..1] of LongWord; { MSB of [1] is the normalized 1 bit }
        Exponent : Word;                           { MSB is the sign bit                }
      );
      False: (Value: Extended);
  end;
  {$ENDIF}
  {$ENDIF}

  {$IFDEF ExtendedIsDouble}
  Float  = Double;
  {$DEFINE FloatIsDouble}
  {$ELSE}
  Float  = Extended;
  {$DEFINE FloatIsExtended}
  {$ENDIF}
  PFloat = ^Float;

{$IFNDEF ManagedCode}
{$IFNDEF ExtendedIsDouble}
const
  ExtendedNan      : ExtendedRec = (Mantissa:($FFFFFFFF, $FFFFFFFF); Exponent:$7FFF);
  ExtendedInfinity : ExtendedRec = (Mantissa:($00000000, $80000000); Exponent:$7FFF);
{$ENDIF}
{$ENDIF}



{                                                                              }
{ String types                                                                 }
{                                                                              }
{   AnsiString                                                                 }
{   RawByteString                                                              }
{   UTF8String                                                                 }
{   AsciiString                                                                }
{   WideString                                                                 }
{   UnicodeString                                                              }
{   UCS4String                                                                 }
{                                                                              }



{                                                                              }
{ AnsiString                                                                   }
{   AnsiChar is a byte character.                                              }
{   AnsiString is a reference counted, code page aware, byte string.           }
{                                                                              }
{$IFNDEF SupportAnsiChar}
type
  AnsiChar = Byte;
  PAnsiChar = ^AnsiChar;
{$DEFINE AnsiCharIsOrd}
{$ENDIF}

{$IFNDEF SupportAnsiString}
type
  AnsiString = array of AnsiChar;
{$DEFINE AnsiStringIsArray}
{$ENDIF}

{$IFNDEF SupportAnsiString}
const
  StrEmptyA = nil;
  StrBaseA = 0;
{$ELSE}
const
  StrEmptyA = '';
  StrBaseA = 1;
{$ENDIF}



{                                                                              }
{ RawByteString                                                                }
{   RawByteString is an alias for AnsiString where all bytes are raw bytes     }
{   that do not undergo any character set translation.                         }
{   Under Delphi 2009 RawByteString is defined as "type AnsiString($FFFF)".    }
{                                                                              }
type
  RawByteChar = AnsiChar;
  PRawByteChar = ^RawByteChar;
  {$IFNDEF SupportRawByteString}
  RawByteString = AnsiString;
  PRawByteString = ^RawByteString;
  {$ENDIF}
  {$IFDEF SupportRawByteString}
  {$IFDEF FREEPASCAL}
  PRawByteString = ^RawByteString;
  {$ENDIF}
  {$ENDIF}
  RawByteCharSet = set of RawByteChar;

{$IFNDEF SupportRawByteString}
const
  StrEmptyB = nil;
  StrBaseB = 0;
{$ELSE}
const
  StrEmptyB = '';
  StrBaseB = 1;
{$ENDIF}



{                                                                              }
{ UTF8String                                                                   }
{   UTF8String is a variable character length encoding for Unicode strings.    }
{   For Ascii values, a UTF8String is the same as a AsciiString.               }
{   Under Delphi 2009 UTF8String is defined as "type AnsiString($FDE9)"        }
{                                                                              }
type
  {$IFNDEF SupportUTF8String}
  UTF8Char = AnsiChar;
  PUTF8Char = ^UTF8Char;
  UTF8String = AnsiString;
  PUTF8String = ^UTF8String;
  {$ENDIF}
  UTF8StringArray = array of UTF8String;



{                                                                              }
{ AsciiString                                                                  }
{   AsciiString is an alias for AnsiString where all bytes are from Ascii.     }
{                                                                              }
type
  AsciiChar = AnsiChar;
  PAsciiChar = ^AsciiChar;
  AsciiString = AnsiString;
  AsciiCharSet = set of AsciiChar;
  AsciiStringArray = array of AsciiString;



{                                                                              }
{ WideString                                                                   }
{   WideChar is a 16-bit character.                                            }
{   WideString is not reference counted.                                       }
{                                                                              }
{$IFNDEF SupportWideChar}
type
  WideChar = Word;
  PWideChar = ^WideChar;
{$DEFINE WideCharIsOrd}
{$ENDIF}

{$IFNDEF SupportWideString}
{$IFDEF StringIsUnicode}
type
  WideString = String;
{$DEFINE WideStringIsString}
{$ELSE}
type
  WideString = array of WideChar;
{$DEFINE WideStringIsArray}
{$ENDIF}
{$ENDIF}

type
  TWideCharMatchFunction = function (const Ch: WideChar): Boolean;

{$IFNDEF SupportWideString}
{$IFDEF WideStringIsArray}
const
  StrEmptyW = nil;
  StrBaseW = 0;
{$ENDIF}
{$IFDEF WideStringIsString}
const
  StrEmptyW = '';
  StrBaseW = 1;
{$ENDIF}
{$ELSE}
const
  StrEmptyW = '';
  StrBaseW = 1;
{$ENDIF}



{                                                                              }
{ UnicodeString                                                                }
{   UnicodeString in Delphi 2009 is reference counted, code page aware,        }
{   variable character length unicode string. Defaults to UTF-16 encoding.     }
{   WideString is not reference counted.                                       }
{                                                                              }
type
  UnicodeChar = WideChar;
  PUnicodeChar = ^UnicodeChar;
  {$IFNDEF SupportUnicodeString}
  UnicodeString = WideString;
  PUnicodeString = ^UnicodeString;
  {$ENDIF}



{                                                                              }
{ UCS4String                                                                   }
{   UCS4Char is a 32-bit character from the Unicode character set.             }
{   UCS4String is a reference counted string of UCS4Char characters.           }
{                                                                              }
type
  {$IFNDEF SupportUCS4String}
  UCS4Char = LongWord;
  PUCS4Char = ^UCS4Char;
  UCS4String = array of UCS4Char;
  {$ENDIF}
  UCS4StringArray = array of UCS4String;

const
  UCS4_STRING_TERMINATOR = $9C;
  UCS4_LF                = $0A;
  UCS4_CR                = $0D;



{                                                                              }
{ TBytes                                                                       }
{   TBytes is a dynamic array of bytes.                                        }
{                                                                              }
{$IFNDEF TBytesDeclared}
type
  TBytes = array of Byte;
{$ENDIF}



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
function  Int32Bounded(const Value: LongInt; const Min, Max: LongInt): LongInt; {$IFDEF UseInline}inline;{$ENDIF}
function  Int64Bounded(const Value: Int64; const Min, Max: Int64): Int64;       {$IFDEF UseInline}inline;{$ENDIF}
function  Int32BoundedByte(const Value: LongInt): LongInt;                      {$IFDEF UseInline}inline;{$ENDIF}
function  Int64BoundedByte(const Value: Int64): Int64;                          {$IFDEF UseInline}inline;{$ENDIF}
function  Int32BoundedWord(const Value: LongInt): LongInt;                      {$IFDEF UseInline}inline;{$ENDIF}
function  Int64BoundedWord(const Value: Int64): Int64;                          {$IFDEF UseInline}inline;{$ENDIF}
function  Int64BoundedLongWord(const Value: Int64): LongWord;                   {$IFDEF UseInline}inline;{$ENDIF}



{                                                                              }
{ Float functions                                                              }
{                                                                              }

{ Min returns smallest of A and B                                              }
{ Max returns greatest of A and B                                              }
{ Clip returns Value if in Low..High range, otherwise Low or High              }
function  DoubleMin(const A, B: Double): Double; {$IFDEF UseInline}inline;{$ENDIF}
function  DoubleMax(const A, B: Double): Double; {$IFDEF UseInline}inline;{$ENDIF}

function  ExtendedMin(const A, B: Extended): Extended; {$IFDEF UseInline}inline;{$ENDIF}
function  ExtendedMax(const A, B: Extended): Extended; {$IFDEF UseInline}inline;{$ENDIF}

function  FloatMin(const A, B: Float): Float; {$IFDEF UseInline}inline;{$ENDIF}
function  FloatMax(const A, B: Float): Float; {$IFDEF UseInline}inline;{$ENDIF}
function  FloatClip(const Value: Float; const Low, High: Float): Float;

{ InXXXRange returns True if A in range of type XXX                            }
function  InSingleRange(const A: Float): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
function  InDoubleRange(const A: Float): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
{$IFNDEF CLR}
function  InCurrencyRange(const A: Float): Boolean; overload;
function  InCurrencyRange(const A: Int64): Boolean; overload;
{$ENDIF}

{ ExtendedExponent returns the exponent component of an Extended value         }
{$IFNDEF ExtendedIsDouble}
function  ExtendedExponentBase2(const A: Extended; var Exponent: Integer): Boolean;
function  ExtendedExponentBase10(const A: Extended; var Exponent: Integer): Boolean;
{$ENDIF}

{ ExtendedIsInfinity is True if A is a positive or negative infinity.          }
{ ExtendedIsNaN is True if A is Not-a-Number.                                  }
{$IFNDEF ExtendedIsDouble}
function  ExtendedIsInfinity(const A: Extended): Boolean;
function  ExtendedIsNaN(const A: Extended): Boolean;
{$ENDIF}



{                                                                              }
{ Approximate comparison of floating point values                              }
{                                                                              }
{   FloatZero, FloatOne, FloatsEqual and FloatsCompare are functions for       }
{   comparing floating point numbers based on a fixed CompareDelta difference  }
{   between the values. This means that values are considered equal if the     }
{   unsigned difference between the values are less than CompareDelta.         }
{                                                                              }
const
  // Minimum CompareDelta values for the different floating point types:
  // The values were chosen to be slightly higher than the minimum value that
  // the floating-point type can store.
  SingleCompareDelta   = 1.0E-34;
  DoubleCompareDelta   = 1.0E-280;
  {$IFDEF ExtendedIsDouble}
  ExtendedCompareDelta = DoubleCompareDelta;
  {$ELSE}
  ExtendedCompareDelta = 1.0E-4400;
  {$ENDIF}

  // Default CompareDelta is set to SingleCompareDelta. This allows any type
  // of floating-point value to be compared with any other.
  DefaultCompareDelta = SingleCompareDelta;

function  FloatZero(const A: Float;
          const CompareDelta: Float = DefaultCompareDelta): Boolean;
function  FloatOne(const A: Float;
          const CompareDelta: Float = DefaultCompareDelta): Boolean;

function  FloatsEqual(const A, B: Float;
          const CompareDelta: Float = DefaultCompareDelta): Boolean;
function  FloatsCompare(const A, B: Float;
          const CompareDelta: Float = DefaultCompareDelta): TCompareResult;



{                                                                              }
{ Scaled approximate comparison of floating point values                       }
{                                                                              }
{   ApproxEqual and ApproxCompare are functions for comparing floating point   }
{   numbers based on a scaled order of magnitude difference between the        }
{   values. CompareEpsilon is the ratio applied to the largest of the two      }
{   exponents to give the maximum difference (CompareDelta) for comparison.    }
{                                                                              }
{   For example:                                                               }
{                                                                              }
{   When the CompareEpsilon is 1.0E-9, the result of                           }
{                                                                              }
{   ApproxEqual(1.0E+20, 1.000000001E+20) = False, but the result of           }
{   ApproxEqual(1.0E+20, 1.0000000001E+20) = True, ie the first 9 digits of    }
{   the mantissas of the values must be the same.                              }
{                                                                              }
{   Note that for A <> 0.0, the value of ApproxEqual(A, 0.0) will always be    }
{   False. Rather use the unscaled FloatZero, FloatsEqual and FloatsCompare    }
{   functions when specifically testing for zero.                              }
{                                                                              }
const
  // Smallest (most sensitive) CompareEpsilon values allowed for the different
  // floating point types:
  SingleCompareEpsilon   = 1.0E-5;
  DoubleCompareEpsilon   = 1.0E-13;
  ExtendedCompareEpsilon = 1.0E-17;

  // Default CompareEpsilon is set for half the significant digits of the
  // Extended type.
  DefaultCompareEpsilon  = 1.0E-10;

{$IFNDEF ExtendedIsDouble}
function  ExtendedApproxEqual(const A, B: Extended;
          const CompareEpsilon: Double = DefaultCompareEpsilon): Boolean;
function  ExtendedApproxCompare(const A, B: Extended;
          const CompareEpsilon: Double = DefaultCompareEpsilon): TCompareResult;
{$ENDIF}

function  DoubleApproxEqual(const A, B: Double;
          const CompareEpsilon: Double = DefaultCompareEpsilon): Boolean;
function  DoubleApproxCompare(const A, B: Double;
          const CompareEpsilon: Double = DefaultCompareEpsilon): TCompareResult;

function  FloatApproxEqual(const A, B: Float;
          const CompareEpsilon: Float = DefaultCompareEpsilon): Boolean;
function  FloatApproxCompare(const A, B: Float;
          const CompareEpsilon: Float = DefaultCompareEpsilon): TCompareResult;




{                                                                              }
{ ASCII constants                                                              }
{                                                                              }
const
  AsciiNULL = AsciiChar(#0);
  AsciiSOH  = AsciiChar(#1);
  AsciiSTX  = AsciiChar(#2);
  AsciiETX  = AsciiChar(#3);
  AsciiEOT  = AsciiChar(#4);
  AsciiENQ  = AsciiChar(#5);
  AsciiACK  = AsciiChar(#6);
  AsciiBEL  = AsciiChar(#7);
  AsciiBS   = AsciiChar(#8);
  AsciiHT   = AsciiChar(#9);
  AsciiLF   = AsciiChar(#10);
  AsciiVT   = AsciiChar(#11);
  AsciiFF   = AsciiChar(#12);
  AsciiCR   = AsciiChar(#13);
  AsciiSO   = AsciiChar(#14);
  AsciiSI   = AsciiChar(#15);
  AsciiDLE  = AsciiChar(#16);
  AsciiDC1  = AsciiChar(#17);
  AsciiDC2  = AsciiChar(#18);
  AsciiDC3  = AsciiChar(#19);
  AsciiDC4  = AsciiChar(#20);
  AsciiNAK  = AsciiChar(#21);
  AsciiSYN  = AsciiChar(#22);
  AsciiETB  = AsciiChar(#23);
  AsciiCAN  = AsciiChar(#24);
  AsciiEM   = AsciiChar(#25);
  AsciiEOF  = AsciiChar(#26);
  AsciiESC  = AsciiChar(#27);
  AsciiFS   = AsciiChar(#28);
  AsciiGS   = AsciiChar(#29);
  AsciiRS   = AsciiChar(#30);
  AsciiUS   = AsciiChar(#31);
  AsciiSP   = AsciiChar(#32);
  AsciiDEL  = AsciiChar(#127);
  AsciiXON  = AsciiDC1;
  AsciiXOFF = AsciiDC3;

  AsciiCRLF = AsciiCR + AsciiLF;

  AsciiDecimalPoint = AsciiChar(#46);
  AsciiComma        = AsciiChar(#44);
  AsciiBackSlash    = AsciiChar(#92);
  AsciiForwardSlash = AsciiChar(#47);
  AsciiPercent      = AsciiChar(#37);
  AsciiAmpersand    = AsciiChar(#38);
  AsciiPlus         = AsciiChar(#43);
  AsciiMinus        = AsciiChar(#45);
  AsciiEqualSign    = AsciiChar(#61);
  AsciiSingleQuote  = AsciiChar(#39);
  AsciiDoubleQuote  = AsciiChar(#34);

  AsciiDigit0 = AsciiChar(#48);
  AsciiDigit9 = AsciiChar(#57);
  AsciiUpperA = AsciiChar(#65);
  AsciiUpperZ = AsciiChar(#90);
  AsciiLowerA = AsciiChar(#97);
  AsciiLowerZ = AsciiChar(#122);

  AsciiLowCaseLookup: array[Byte] of Byte = (
    $00, $01, $02, $03, $04, $05, $06, $07,
    $08, $09, $0A, $0B, $0C, $0D, $0E, $0F,
    $10, $11, $12, $13, $14, $15, $16, $17,
    $18, $19, $1A, $1B, $1C, $1D, $1E, $1F,
    $20, $21, $22, $23, $24, $25, $26, $27,
    $28, $29, $2A, $2B, $2C, $2D, $2E, $2F,
    $30, $31, $32, $33, $34, $35, $36, $37,
    $38, $39, $3A, $3B, $3C, $3D, $3E, $3F,
    $40, $61, $62, $63, $64, $65, $66, $67,
    $68, $69, $6A, $6B, $6C, $6D, $6E, $6F,
    $70, $71, $72, $73, $74, $75, $76, $77,
    $78, $79, $7A, $5B, $5C, $5D, $5E, $5F,
    $60, $61, $62, $63, $64, $65, $66, $67,
    $68, $69, $6A, $6B, $6C, $6D, $6E, $6F,
    $70, $71, $72, $73, $74, $75, $76, $77,
    $78, $79, $7A, $7B, $7C, $7D, $7E, $7F,
    $80, $81, $82, $83, $84, $85, $86, $87,
    $88, $89, $8A, $8B, $8C, $8D, $8E, $8F,
    $90, $91, $92, $93, $94, $95, $96, $97,
    $98, $99, $9A, $9B, $9C, $9D, $9E, $9F,
    $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7,
    $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF,
    $B0, $B1, $B2, $B3, $B4, $B5, $B6, $B7,
    $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF,
    $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7,
    $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF,
    $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7,
    $D8, $D9, $DA, $DB, $DC, $DD, $DE, $DF,
    $E0, $E1, $E2, $E3, $E4, $E5, $E6, $E7,
    $E8, $E9, $EA, $EB, $EC, $ED, $EE, $EF,
    $F0, $F1, $F2, $F3, $F4, $F5, $F6, $F7,
    $F8, $F9, $FA, $FB, $FC, $FD, $FE, $FF);



{                                                                              }
{ WideChar constants                                                           }
{                                                                              }
const
  WideNULL = WideChar(#0);
  WideSOH  = WideChar(#1);
  WideSTX  = WideChar(#2);
  WideETX  = WideChar(#3);
  WideEOT  = WideChar(#4);
  WideENQ  = WideChar(#5);
  WideACK  = WideChar(#6);
  WideBEL  = WideChar(#7);
  WideBS   = WideChar(#8);
  WideHT   = WideChar(#9);
  WideLF   = WideChar(#10);
  WideVT   = WideChar(#11);
  WideFF   = WideChar(#12);
  WideCR   = WideChar(#13);
  WideSO   = WideChar(#14);
  WideSI   = WideChar(#15);
  WideDLE  = WideChar(#16);
  WideDC1  = WideChar(#17);
  WideDC2  = WideChar(#18);
  WideDC3  = WideChar(#19);
  WideDC4  = WideChar(#20);
  WideNAK  = WideChar(#21);
  WideSYN  = WideChar(#22);
  WideETB  = WideChar(#23);
  WideCAN  = WideChar(#24);
  WideEM   = WideChar(#25);
  WideEOF  = WideChar(#26);
  WideESC  = WideChar(#27);
  WideFS   = WideChar(#28);
  WideGS   = WideChar(#29);
  WideRS   = WideChar(#30);
  WideUS   = WideChar(#31);
  WideSP   = WideChar(#32);
  WideDEL  = WideChar(#127);
  WideXON  = WideDC1;
  WideXOFF = WideDC3;

  WideSingleQuote = WideChar('''');
  WideDoubleQuote = WideChar('"');

  WideNoBreakSpace       = WideChar(#$00A0);
  WideLineSeparator      = WideChar(#$2028);
  WideParagraphSeparator = WideChar(#$2029);

  WideBOM_MSB_First      = WideChar(#$FFFE);
  WideBOM_LSB_First      = WideChar(#$FEFF);

  WideObjectReplacement  = WideChar(#$FFFC);
  WideCharReplacement    = WideChar(#$FFFD);
  WideInvalid            = WideChar(#$FFFF);

  WideCopyrightSign      = WideChar(#$00A9);
  WideRegisteredSign     = WideChar(#$00AE);

  WideHighSurrogateFirst        = WideChar(#$D800);
  WideHighSurrogateLast         = WideChar(#$DB7F);
  WideLowSurrogateFirst         = WideChar(#$DC00);
  WideLowSurrogateLast          = WideChar(#$DFFF);
  WidePrivateHighSurrogateFirst = WideChar(#$DB80);
  WidePrivateHighSurrogateLast  = WideChar(#$DBFF);



{                                                                              }
{ ASCII functions                                                              }
{                                                                              }
function  IsAsciiCharA(const C: AnsiChar): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
function  IsAsciiCharW(const C: WideChar): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
function  IsAsciiChar(const C: Char): Boolean;      {$IFDEF UseInline}inline;{$ENDIF}

function  IsAsciiBufB(const Buf: Pointer; const Len: Integer): Boolean;
function  IsAsciiBufW(const Buf: Pointer; const Len: Integer): Boolean;

function  IsAsciiStringA(const S: AnsiString): Boolean;    {$IFDEF UseInline}inline;{$ENDIF}
function  IsAsciiStringB(const S: RawByteString): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
function  IsAsciiStringW(const S: WideString): Boolean;    {$IFDEF UseInline}inline;{$ENDIF}
function  IsAsciiStringU(const S: UnicodeString): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
function  IsAsciiString(const S: String): Boolean;         {$IFDEF UseInline}inline;{$ENDIF}

function  AsciiHexCharValue(const C: AnsiChar): Integer;
function  AsciiHexCharValueW(const C: WideChar): Integer;

function  AsciiIsHexChar(const C: AnsiChar): Boolean;
function  AsciiIsHexCharW(const C: WideChar): Boolean;

function  AsciiDecimalCharValue(const C: AnsiChar): Integer;
function  AsciiDecimalCharValueW(const C: WideChar): Integer;

function  AsciiIsDecimalChar(const C: AnsiChar): Boolean;
function  AsciiIsDecimalCharW(const C: WideChar): Boolean;

function  AsciiOctalCharValue(const C: AnsiChar): Integer;
function  AsciiOctalCharValueW(const C: WideChar): Integer;

function  AsciiIsOctalChar(const C: AnsiChar): Boolean;
function  AsciiIsOctalCharW(const C: WideChar): Boolean;



{                                                                              }
{ ASCII case conversion                                                        }
{                                                                              }
function  AsciiLowCaseA(const C: AnsiChar): AnsiChar;
function  AsciiLowCaseW(const C: WideChar): WideChar;
function  AsciiLowCase(const C: Char): Char;

function  AsciiUpCaseA(const C: AnsiChar): AnsiChar;
function  AsciiUpCaseW(const C: WideChar): WideChar;
function  AsciiUpCase(const C: Char): Char;

procedure AsciiConvertUpperA(var S: AnsiString);
procedure AsciiConvertUpperB(var S: RawByteString);
procedure AsciiConvertUpperW(var S: WideString);
procedure AsciiConvertUpperU(var S: UnicodeString);
procedure AsciiConvertUpper(var S: String);

procedure AsciiConvertLowerA(var S: AnsiString);
procedure AsciiConvertLowerB(var S: RawByteString);
procedure AsciiConvertLowerW(var S: WideString);
procedure AsciiConvertLowerU(var S: UnicodeString);
procedure AsciiConvertLower(var S: String);

function  AsciiUpperCaseA(const A: AnsiString): AnsiString;
function  AsciiUpperCaseB(const A: RawByteString): RawByteString;
function  AsciiUpperCaseW(const A: WideString): WideString;
function  AsciiUpperCaseU(const A: UnicodeString): UnicodeString;
function  AsciiUpperCase(const A: String): String;

function  AsciiLowerCaseA(const A: AnsiString): AnsiString;
function  AsciiLowerCaseB(const A: RawByteString): RawByteString;
function  AsciiLowerCaseW(const A: WideString): WideString;
function  AsciiLowerCaseU(const A: UnicodeString): UnicodeString;
function  AsciiLowerCase(const A: String): String;

procedure AsciiConvertFirstUpA(var S: AnsiString);
procedure AsciiConvertFirstUpB(var S: RawByteString);
procedure AsciiConvertFirstUpW(var S: WideString);
procedure AsciiConvertFirstUp(var S: String);

function  AsciiFirstUpA(const S: AnsiString): AnsiString;
function  AsciiFirstUpB(const S: RawByteString): RawByteString;
function  AsciiFirstUpW(const S: WideString): WideString;
function  AsciiFirstUp(const S: String): String;

procedure AsciiConvertArrayUpper(var S: AsciiStringArray);
procedure AsciiConvertArrayLower(var S: AsciiStringArray);



{                                                                              }
{ String construction from buffer                                              }
{                                                                              }
{$IFNDEF ManagedCode}
function  StrPToStrA(const P: PAnsiChar; const L: Integer): AnsiString;
function  StrPToStrB(const P: PAnsiChar; const L: Integer): RawByteString;
function  StrPToStrW(const P: PWideChar; const L: Integer): WideString;
function  StrPToStrU(const P: PWideChar; const L: Integer): UnicodeString;
function  StrPToStr(const P: PChar; const L: Integer): String;
{$ENDIF}



{                                                                              }
{ RawByteString conversion functions                                           }
{                                                                              }
procedure RawByteBufToWideBuf(const Buf: Pointer; const BufSize: Integer; const DestBuf: Pointer);
function  RawByteStrPtrToWideString(const S: PAnsiChar; const Len: Integer): WideString;
function  RawByteStrPtrToUnicodeString(const S: PAnsiChar; const Len: Integer): UnicodeString;
function  RawByteStringToWideString(const S: RawByteString): WideString;
function  RawByteStringToUnicodeString(const S: RawByteString): UnicodeString;

procedure WideBufToRawByteBuf(const Buf: Pointer; const Len: Integer; const DestBuf: Pointer);
function  WideBufToRawByteString(const P: PWideChar; const Len: Integer): RawByteString;

function  WideStringToRawByteString(const S: WideString): RawByteString;
function  UnicodeStringToRawByteString(const S: UnicodeString): RawByteString;

function  WideStringToUnicodeString(const S: WideString): UnicodeString;



{                                                                              }
{ String conversion functions                                                  }
{                                                                              }
function  ToAnsiString(const A: String): AnsiString;       {$IFDEF UseInline}inline;{$ENDIF}
function  ToRawByteString(const A: String): RawByteString; {$IFDEF UseInline}inline;{$ENDIF}
function  ToWideString(const A: String): WideString;       {$IFDEF UseInline}inline;{$ENDIF}
function  ToUnicodeString(const A: String): UnicodeString; {$IFDEF UseInline}inline;{$ENDIF}



{                                                                              }
{ String internals                                                             }
{                                                                              }
{$IFNDEF SupportStringRefCount}
{$IFDEF DELPHI}
function StringRefCount(const S: RawByteString): LongInt; overload; {$IFDEF UseInline}inline;{$ENDIF}
function StringRefCount(const S: UnicodeString): LongInt; overload; {$IFDEF UseInline}inline;{$ENDIF}
{$DEFINE ImplementsStringRefCount}
{$ENDIF}
{$ENDIF}



{                                                                              }
{ String append functions                                                      }
{                                                                              }
procedure StrAppendChA(var A: AnsiString; const C: AnsiChar);    {$IFDEF UseInline}inline;{$ENDIF}
procedure StrAppendChB(var A: RawByteString; const C: AnsiChar); {$IFDEF UseInline}inline;{$ENDIF}
procedure StrAppendChW(var A: WideString; const C: WideChar);    {$IFDEF UseInline}inline;{$ENDIF}
procedure StrAppendChU(var A: UnicodeString; const C: WideChar); {$IFDEF UseInline}inline;{$ENDIF}
procedure StrAppendCh(var A: String; const C: Char);             {$IFDEF UseInline}inline;{$ENDIF}



{                                                                              }
{ String compare functions                                                     }
{                                                                              }
{   Returns  -1  if A < B                                                      }
{             0  if A = B                                                      }
{             1  if A > B                                                      }
{                                                                              }
function  CharCompareA(const A, B: AnsiChar): Integer; {$IFDEF UseInline}inline;{$ENDIF}
function  CharCompareW(const A, B: WideChar): Integer; {$IFDEF UseInline}inline;{$ENDIF}
function  CharCompare(const A, B: Char): Integer;      {$IFDEF UseInline}inline;{$ENDIF}

function  CharCompareNoAsciiCaseA(const A, B: AnsiChar): Integer; {$IFDEF UseInline}inline;{$ENDIF}
function  CharCompareNoAsciiCaseW(const A, B: WideChar): Integer; {$IFDEF UseInline}inline;{$ENDIF}
function  CharCompareNoAsciiCase(const A, B: Char): Integer;      {$IFDEF UseInline}inline;{$ENDIF}

function  CharEqualNoAsciiCaseA(const A, B: AnsiChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharEqualNoAsciiCaseW(const A, B: WideChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharEqualNoAsciiCase(const A, B: Char): Boolean;       {$IFDEF UseInline}inline;{$ENDIF}
{$IFDEF ManagedCode}
function  StrPCompareA(const A, B: AnsiString; const Len: Integer): Integer;
function  StrPCompareNoAsciiCaseA(const A, B: AnsiString; const Len: Integer): Integer;
{$ELSE}
function  StrPCompareA(const A, B: PAnsiChar; const Len: Integer): Integer;
function  StrPCompareW(const A, B: PWideChar; const Len: Integer): Integer;
function  StrPCompare(const A, B: PChar; const Len: Integer): Integer;

function  StrPCompareNoAsciiCaseA(const A, B: PAnsiChar; const Len: Integer): Integer;
function  StrPCompareNoAsciiCaseW(const A, B: PWideChar; const Len: Integer): Integer;
function  StrPCompareNoAsciiCase(const A, B: PChar; const Len: Integer): Integer;
{$ENDIF}

{$IFNDEF CLR}
function  StrCompareA(const A, B: AnsiString): Integer;
function  StrCompareB(const A, B: RawByteString): Integer;
function  StrCompareW(const A, B: WideString): Integer;
function  StrCompareU(const A, B: UnicodeString): Integer;
function  StrCompare(const A, B: String): Integer;

function  StrCompareNoAsciiCaseA(const A, B: AnsiString): Integer;
function  StrCompareNoAsciiCaseB(const A, B: RawByteString): Integer;
function  StrCompareNoAsciiCaseW(const A, B: WideString): Integer;
function  StrCompareNoAsciiCaseU(const A, B: UnicodeString): Integer;
function  StrCompareNoAsciiCase(const A, B: String): Integer;
{$ENDIF}



{                                                                              }
{ Swap                                                                         }
{                                                                              }
procedure Swap(var X, Y: Boolean); overload;
procedure Swap(var X, Y: Byte); overload;
procedure Swap(var X, Y: Word); overload;
procedure Swap(var X, Y: LongWord); overload;
procedure Swap(var X, Y: ShortInt); overload;
procedure Swap(var X, Y: SmallInt); overload;
procedure Swap(var X, Y: LongInt); overload;
procedure Swap(var X, Y: Int64); overload;
procedure Swap(var X, Y: Single); overload;
procedure Swap(var X, Y: Double); overload;
procedure Swap(var X, Y: Extended); overload;
procedure Swap(var X, Y: Currency); overload;
procedure SwapA(var X, Y: AnsiString); overload;
procedure SwapB(var X, Y: RawByteString);
procedure SwapW(var X, Y: WideString); overload;
procedure SwapU(var X, Y: UnicodeString); overload;
procedure Swap(var X, Y: String); overload;
procedure Swap(var X, Y: TObject); overload;
{$IFDEF ManagedCode}
procedure SwapObjects(var X, Y: TObject);
{$ELSE}
procedure SwapObjects(var X, Y);
{$ENDIF}
{$IFNDEF ManagedCode}
procedure Swap(var X, Y: Pointer); overload;
{$ENDIF}



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
function  iifA(const Expr: Boolean; const TrueValue: AnsiString;
          const FalseValue: AnsiString = StrEmptyA): AnsiString; overload;{$IFDEF UseInline}inline;{$ENDIF}
function  iifB(const Expr: Boolean; const TrueValue: RawByteString;
          const FalseValue: RawByteString = StrEmptyB): RawByteString; overload; {$IFDEF UseInline}inline;{$ENDIF}
function  iifW(const Expr: Boolean; const TrueValue: WideString;
          const FalseValue: WideString = StrEmptyW): WideString; overload;       {$IFDEF UseInline}inline;{$ENDIF}
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
function  CompareA(const I1, I2: AnsiString): TCompareResult;
function  CompareB(const I1, I2: RawByteString): TCompareResult;
function  CompareW(const I1, I2: WideString): TCompareResult;
function  CompareU(const I1, I2: UnicodeString): TCompareResult;
function  CompareChA(const I1, I2: AnsiChar): TCompareResult;
function  CompareChW(const I1, I2: WideChar): TCompareResult;

function  Sgn(const A: LongInt): Integer; overload;
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

function  AnsiCharToInt(const A: AnsiChar): Integer;                            {$IFDEF UseInline}inline;{$ENDIF}
function  WideCharToInt(const A: WideChar): Integer;                            {$IFDEF UseInline}inline;{$ENDIF}
function  CharToInt(const A: Char): Integer;                                    {$IFDEF UseInline}inline;{$ENDIF}

function  IntToAnsiChar(const A: Integer): AnsiChar;                            {$IFDEF UseInline}inline;{$ENDIF}
function  IntToWideChar(const A: Integer): WideChar;                            {$IFDEF UseInline}inline;{$ENDIF}
function  IntToChar(const A: Integer): Char;                                    {$IFDEF UseInline}inline;{$ENDIF}

function  IsHexAnsiChar(const Ch: AnsiChar): Boolean;
function  IsHexWideChar(const Ch: WideChar): Boolean;
function  IsHexChar(const Ch: Char): Boolean;                                   {$IFDEF UseInline}inline;{$ENDIF}

function  HexAnsiCharToInt(const A: AnsiChar): Integer;
function  HexWideCharToInt(const A: WideChar): Integer;
function  HexCharToInt(const A: Char): Integer;                                 {$IFDEF UseInline}inline;{$ENDIF}

function  IntToUpperHexAnsiChar(const A: Integer): AnsiChar;
function  IntToUpperHexWideChar(const A: Integer): WideChar;
function  IntToUpperHexChar(const A: Integer): Char;                            {$IFDEF UseInline}inline;{$ENDIF}

function  IntToLowerHexAnsiChar(const A: Integer): AnsiChar;
function  IntToLowerHexWideChar(const A: Integer): WideChar;
function  IntToLowerHexChar(const A: Integer): Char;                            {$IFDEF UseInline}inline;{$ENDIF}

function  IntToStringA(const A: Int64): AnsiString;
function  IntToStringB(const A: Int64): RawByteString;
function  IntToStringW(const A: Int64): WideString;
function  IntToStringU(const A: Int64): UnicodeString;
function  IntToString(const A: Int64): String;

function  UIntToStringA(const A: NativeUInt): AnsiString;
function  UIntToStringB(const A: NativeUInt): RawByteString;
function  UIntToStringW(const A: NativeUInt): WideString;
function  UIntToStringU(const A: NativeUInt): UnicodeString;
function  UIntToString(const A: NativeUInt): String;

function  LongWordToStrA(const A: LongWord; const Digits: Integer = 0): AnsiString;
function  LongWordToStrB(const A: LongWord; const Digits: Integer = 0): RawByteString;
function  LongWordToStrW(const A: LongWord; const Digits: Integer = 0): WideString;
function  LongWordToStrU(const A: LongWord; const Digits: Integer = 0): UnicodeString;
function  LongWordToStr(const A: LongWord; const Digits: Integer = 0): String;

function  LongWordToHexA(const A: LongWord; const Digits: Integer = 0; const UpperCase: Boolean = True): AnsiString;
function  LongWordToHexB(const A: LongWord; const Digits: Integer = 0; const UpperCase: Boolean = True): RawByteString;
function  LongWordToHexW(const A: LongWord; const Digits: Integer = 0; const UpperCase: Boolean = True): WideString;
function  LongWordToHexU(const A: LongWord; const Digits: Integer = 0; const UpperCase: Boolean = True): UnicodeString;
function  LongWordToHex(const A: LongWord; const Digits: Integer = 0; const UpperCase: Boolean = True): String;

function  LongWordToOctA(const A: LongWord; const Digits: Integer = 0): AnsiString;
function  LongWordToOctB(const A: LongWord; const Digits: Integer = 0): RawByteString;
function  LongWordToOctW(const A: LongWord; const Digits: Integer = 0): WideString;
function  LongWordToOctU(const A: LongWord; const Digits: Integer = 0): UnicodeString;
function  LongWordToOct(const A: LongWord; const Digits: Integer = 0): String;

function  LongWordToBinA(const A: LongWord; const Digits: Integer = 0): AnsiString;
function  LongWordToBinB(const A: LongWord; const Digits: Integer = 0): RawByteString;
function  LongWordToBinW(const A: LongWord; const Digits: Integer = 0): WideString;
function  LongWordToBinU(const A: LongWord; const Digits: Integer = 0): UnicodeString;
function  LongWordToBin(const A: LongWord; const Digits: Integer = 0): String;

function  TryStringToInt64PA(const BufP: Pointer; const BufLen: Integer; out Value: Int64; out StrLen: Integer): TConvertResult;
function  TryStringToInt64PW(const BufP: Pointer; const BufLen: Integer; out Value: Int64; out StrLen: Integer): TConvertResult;
function  TryStringToInt64P(const BufP: Pointer; const BufLen: Integer; out Value: Int64; out StrLen: Integer): TConvertResult;

function  TryStringToInt64A(const S: AnsiString; out A: Int64): Boolean;
function  TryStringToInt64B(const S: RawByteString; out A: Int64): Boolean;
function  TryStringToInt64W(const S: WideString; out A: Int64): Boolean;
function  TryStringToInt64U(const S: UnicodeString; out A: Int64): Boolean;
function  TryStringToInt64(const S: String; out A: Int64): Boolean;

function  StringToInt64DefA(const S: AnsiString; const Default: Int64): Int64;
function  StringToInt64DefB(const S: RawByteString; const Default: Int64): Int64;
function  StringToInt64DefW(const S: WideString; const Default: Int64): Int64;
function  StringToInt64DefU(const S: UnicodeString; const Default: Int64): Int64;
function  StringToInt64Def(const S: String; const Default: Int64): Int64;

function  StringToInt64A(const S: AnsiString): Int64;
function  StringToInt64B(const S: RawByteString): Int64;
function  StringToInt64W(const S: WideString): Int64;
function  StringToInt64U(const S: UnicodeString): Int64;
function  StringToInt64(const S: String): Int64;

function  TryStringToIntA(const S: AnsiString; out A: Integer): Boolean;
function  TryStringToIntB(const S: RawByteString; out A: Integer): Boolean;
function  TryStringToIntW(const S: WideString; out A: Integer): Boolean;
function  TryStringToIntU(const S: UnicodeString; out A: Integer): Boolean;
function  TryStringToInt(const S: String; out A: Integer): Boolean;

function  StringToIntDefA(const S: AnsiString; const Default: Integer): Integer;
function  StringToIntDefB(const S: RawByteString; const Default: Integer): Integer;
function  StringToIntDefW(const S: WideString; const Default: Integer): Integer;
function  StringToIntDefU(const S: UnicodeString; const Default: Integer): Integer;
function  StringToIntDef(const S: String; const Default: Integer): Integer;

function  StringToIntA(const S: AnsiString): Integer;
function  StringToIntB(const S: RawByteString): Integer;
function  StringToIntW(const S: WideString): Integer;
function  StringToIntU(const S: UnicodeString): Integer;
function  StringToInt(const S: String): Integer;

function  TryStringToLongWordA(const S: AnsiString; out A: LongWord): Boolean;
function  TryStringToLongWordB(const S: RawByteString; out A: LongWord): Boolean;
function  TryStringToLongWordW(const S: WideString; out A: LongWord): Boolean;
function  TryStringToLongWordU(const S: UnicodeString; out A: LongWord): Boolean;
function  TryStringToLongWord(const S: String; out A: LongWord): Boolean;

function  StringToLongWordA(const S: AnsiString): LongWord;
function  StringToLongWordB(const S: RawByteString): LongWord;
function  StringToLongWordW(const S: WideString): LongWord;
function  StringToLongWordU(const S: UnicodeString): LongWord;
function  StringToLongWord(const S: String): LongWord;

function  HexToUIntA(const S: AnsiString): NativeUInt;
function  HexToUIntB(const S: RawByteString): NativeUInt;
function  HexToUIntW(const S: WideString): NativeUInt;
function  HexToUIntU(const S: UnicodeString): NativeUInt;
function  HexToUInt(const S: String): NativeUInt;

function  TryHexToLongWordA(const S: AnsiString; out A: LongWord): Boolean;
function  TryHexToLongWordB(const S: RawByteString; out A: LongWord): Boolean;
function  TryHexToLongWordW(const S: WideString; out A: LongWord): Boolean;
function  TryHexToLongWordU(const S: UnicodeString; out A: LongWord): Boolean;
function  TryHexToLongWord(const S: String; out A: LongWord): Boolean;

function  HexToLongWordA(const S: AnsiString): LongWord;
function  HexToLongWordB(const S: RawByteString): LongWord;
function  HexToLongWordW(const S: WideString): LongWord;
function  HexToLongWordU(const S: UnicodeString): LongWord;
function  HexToLongWord(const S: String): LongWord;

function  TryOctToLongWordA(const S: AnsiString; out A: LongWord): Boolean;
function  TryOctToLongWordB(const S: RawByteString; out A: LongWord): Boolean;
function  TryOctToLongWordW(const S: WideString; out A: LongWord): Boolean;
function  TryOctToLongWordU(const S: UnicodeString; out A: LongWord): Boolean;
function  TryOctToLongWord(const S: String; out A: LongWord): Boolean;

function  OctToLongWordA(const S: AnsiString): LongWord;
function  OctToLongWordB(const S: RawByteString): LongWord;
function  OctToLongWordW(const S: WideString): LongWord;
function  OctToLongWordU(const S: UnicodeString): LongWord;
function  OctToLongWord(const S: String): LongWord;

function  TryBinToLongWordA(const S: AnsiString; out A: LongWord): Boolean;
function  TryBinToLongWordB(const S: RawByteString; out A: LongWord): Boolean;
function  TryBinToLongWordW(const S: WideString; out A: LongWord): Boolean;
function  TryBinToLongWordU(const S: UnicodeString; out A: LongWord): Boolean;
function  TryBinToLongWord(const S: String; out A: LongWord): Boolean;

function  BinToLongWordA(const S: AnsiString): LongWord;
function  BinToLongWordB(const S: RawByteString): LongWord;
function  BinToLongWordW(const S: WideString): LongWord;
function  BinToLongWordU(const S: UnicodeString): LongWord;
function  BinToLongWord(const S: String): LongWord;

function  BytesToHex(
          {$IFDEF ManagedCode}const P: array of Byte;
          {$ELSE}             const P: Pointer; const Count: Integer;{$ENDIF}
          const UpperCase: Boolean = True): AnsiString;



{                                                                              }
{ Float-String conversions                                                     }
{                                                                              }
function  FloatToStringA(const A: Extended): AnsiString;
function  FloatToStringB(const A: Extended): RawByteString;
function  FloatToStringW(const A: Extended): WideString;
function  FloatToStringU(const A: Extended): UnicodeString;
function  FloatToString(const A: Extended): String;

function  TryStringToFloatPA(const BufP: Pointer; const BufLen: Integer; out Value: Extended; out StrLen: Integer): TConvertResult;
function  TryStringToFloatPW(const BufP: Pointer; const BufLen: Integer; out Value: Extended; out StrLen: Integer): TConvertResult;
function  TryStringToFloatP(const BufP: Pointer; const BufLen: Integer; out Value: Extended; out StrLen: Integer): TConvertResult;

function  TryStringToFloatA(const A: AnsiString; out B: Extended): Boolean;
function  TryStringToFloatB(const A: RawByteString; out B: Extended): Boolean;
function  TryStringToFloatW(const A: WideString; out B: Extended): Boolean;
function  TryStringToFloatU(const A: UnicodeString; out B: Extended): Boolean;
function  TryStringToFloat(const A: String; out B: Extended): Boolean;

function  StringToFloatA(const A: AnsiString): Extended;
function  StringToFloatB(const A: RawByteString): Extended;
function  StringToFloatW(const A: WideString): Extended;
function  StringToFloatU(const A: UnicodeString): Extended;
function  StringToFloat(const A: String): Extended;

function  StringToFloatDefA(const A: AnsiString; const Default: Extended): Extended;
function  StringToFloatDefB(const A: RawByteString; const Default: Extended): Extended;
function  StringToFloatDefW(const A: WideString; const Default: Extended): Extended;
function  StringToFloatDefU(const A: UnicodeString; const Default: Extended): Extended;
function  StringToFloatDef(const A: String; const Default: Extended): Extended;



{                                                                              }
{ Network byte order                                                           }
{                                                                              }
function  hton16(const A: Word): Word;
function  ntoh16(const A: Word): Word;
function  hton32(const A: LongWord): LongWord;
function  ntoh32(const A: LongWord): LongWord;
function  hton64(const A: Int64): Int64;
function  ntoh64(const A: Int64): Int64;



{                                                                              }
{ Pointer-String conversions                                                   }
{                                                                              }
{$IFNDEF ManagedCode}
function  PointerToStrA(const P: Pointer): AnsiString;
function  PointerToStrB(const P: Pointer): RawByteString;
function  PointerToStrW(const P: Pointer): WideString;
function  PointerToStrU(const P: Pointer): UnicodeString;
function  PointerToStr(const P: Pointer): String;

function  StrToPointerA(const S: AnsiString): Pointer;
function  StrToPointerB(const S: RawByteString): Pointer;
function  StrToPointerW(const S: WideString): Pointer;
function  StrToPointerU(const S: UnicodeString): Pointer;
function  StrToPointer(const S: String): Pointer;

{$IFDEF SupportInterface}
function  InterfaceToStrA(const I: IInterface): AnsiString;
function  InterfaceToStrB(const I: IInterface): RawByteString;
function  InterfaceToStrW(const I: IInterface): WideString;
function  InterfaceToStrU(const I: IInterface): UnicodeString;
function  InterfaceToStr(const I: IInterface): String;
{$ENDIF}
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
{   If Slots = 0 the hash value is in the LongWord range (0-$FFFFFFFF),        }
{   otherwise the value is in the range from 0 to Slots-1. Note that the       }
{   'mod' operation, which is used when Slots <> 0, is comparitively slow.     }
{                                                                              }
function  HashBuf(const Hash: LongWord; const Buf; const BufSize: Integer): LongWord;

function  HashStrA(const S: AnsiString;
          const Index: Integer = 1; const Count: Integer = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: LongWord = 0): LongWord;
function  HashStrB(const S: RawByteString;
          const Index: Integer = 1; const Count: Integer = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: LongWord = 0): LongWord;
function  HashStrW(const S: WideString;
          const Index: Integer = 1; const Count: Integer = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: LongWord = 0): LongWord;
function  HashStrU(const S: UnicodeString;
          const Index: Integer = 1; const Count: Integer = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: LongWord = 0): LongWord;
function  HashStr(const S: String;
          const Index: Integer = 1; const Count: Integer = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: LongWord = 0): LongWord;

function  HashInteger(const I: Integer; const Slots: LongWord = 0): LongWord;
function  HashLongWord(const I: LongWord; const Slots: LongWord = 0): LongWord;



{                                                                              }
{ Memory operations                                                            }
{                                                                              }
{$IFDEF DELPHI5_DOWN}
type
  PPointer = ^Pointer;
{$ENDIF}

const
  Bytes1KB  = 1024;
  Bytes1MB  = 1024 * Bytes1KB;
  Bytes1GB  = 1024 * Bytes1MB;
  Bytes64KB = 64 * Bytes1KB;
  Bytes64MB = 64 * Bytes1MB;
  Bytes2GB  = 2 * LongWord(Bytes1GB);

{$IFNDEF ManagedCode}
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
{$ENDIF}



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
{ Sets                                                                         }
{                                                                              }
type
  CharSet = set of AnsiChar;
  AnsiCharSet = CharSet;
  ByteSet = set of Byte;
  PCharSet = ^CharSet;
  PByteSet = ^ByteSet;



{                                                                              }
{ Dynamic arrays                                                               }
{                                                                              }
type
  ByteArray = array of Byte;
  WordArray = array of Word;
  LongWordArray = array of LongWord;
  CardinalArray = LongWordArray;
  NativeUIntArray = array of NativeUInt;
  ShortIntArray = array of ShortInt;
  SmallIntArray = array of SmallInt;
  LongIntArray = array of LongInt;
  IntegerArray = LongIntArray;
  NativeIntArray = array of NativeInt;
  Int64Array = array of Int64;
  SingleArray = array of Single;
  DoubleArray = array of Double;
  ExtendedArray = array of Extended;
  CurrencyArray = array of Currency;
  BooleanArray = array of Boolean;
  AnsiStringArray = array of AnsiString;
  RawByteStringArray = array of RawByteString;
  WideStringArray = array of WideString;
  UnicodeStringArray = array of UnicodeString;
  StringArray = array of String;
  {$IFNDEF ManagedCode}
  PointerArray = array of Pointer;
  {$ENDIF}
  ObjectArray = array of TObject;
  InterfaceArray = array of IInterface;
  CharSetArray = array of CharSet;
  ByteSetArray = array of ByteSet;



{$IFDEF ManagedCode}
procedure FreeObjectArray(var V: ObjectArray); overload;
procedure FreeObjectArray(var V: ObjectArray; const LoIdx, HiIdx: Integer); overload;
{$ELSE}
procedure FreeObjectArray(var V); overload;
procedure FreeObjectArray(var V; const LoIdx, HiIdx: Integer); overload;
{$ENDIF}
procedure FreeAndNilObjectArray(var V: ObjectArray);



{                                                                              }
{ Array pointers                                                               }
{                                                                              }

{ Maximum array elements                                                       }
const
  MaxArraySize = $7FFFFFFF; // 2 Gigabytes
  MaxByteArrayElements = MaxArraySize div Sizeof(Byte);
  MaxWordArrayElements = MaxArraySize div Sizeof(Word);
  MaxLongWordArrayElements = MaxArraySize div Sizeof(LongWord);
  MaxCardinalArrayElements = MaxArraySize div Sizeof(Cardinal);
  MaxNativeUIntArrayElements = MaxArraySize div Sizeof(NativeUInt);
  MaxShortIntArrayElements = MaxArraySize div Sizeof(ShortInt);
  MaxSmallIntArrayElements = MaxArraySize div Sizeof(SmallInt);
  MaxLongIntArrayElements = MaxArraySize div Sizeof(LongInt);
  MaxIntegerArrayElements = MaxArraySize div Sizeof(Integer);
  MaxInt64ArrayElements = MaxArraySize div Sizeof(Int64);
  MaxNativeIntArrayElements = MaxArraySize div Sizeof(NativeInt);
  MaxSingleArrayElements = MaxArraySize div Sizeof(Single);
  MaxDoubleArrayElements = MaxArraySize div Sizeof(Double);
  MaxExtendedArrayElements = MaxArraySize div Sizeof(Extended);
  MaxBooleanArrayElements = MaxArraySize div Sizeof(Boolean);
  {$IFNDEF CLR}
  MaxCurrencyArrayElements = MaxArraySize div Sizeof(Currency);
  MaxAnsiStringArrayElements = MaxArraySize div Sizeof(AnsiString);
  MaxRawByteStringArrayElements = MaxArraySize div Sizeof(RawByteString);
  MaxWideStringArrayElements = MaxArraySize div Sizeof(WideString);
  MaxUnicodeStringArrayElements = MaxArraySize div Sizeof(UnicodeString);
  {$IFDEF StringIsUnicode}
  MaxStringArrayElements = MaxArraySize div Sizeof(UnicodeString);
  {$ELSE}
  MaxStringArrayElements = MaxArraySize div Sizeof(AnsiString);
  {$ENDIF}
  MaxPointerArrayElements = MaxArraySize div Sizeof(Pointer);
  MaxObjectArrayElements = MaxArraySize div Sizeof(TObject);
  MaxInterfaceArrayElements = MaxArraySize div Sizeof(IInterface);
  MaxCharSetArrayElements = MaxArraySize div Sizeof(CharSet);
  MaxByteSetArrayElements = MaxArraySize div Sizeof(ByteSet);
  {$ENDIF}

{ Static array types                                                           }
type
  TStaticByteArray = array[0..MaxByteArrayElements - 1] of Byte;
  TStaticWordArray = array[0..MaxWordArrayElements - 1] of Word;
  TStaticLongWordArray = array[0..MaxLongWordArrayElements - 1] of LongWord;
  TStaticNativeUIntArray = array[0..MaxNativeUIntArrayElements - 1] of NativeUInt;
  TStaticShortIntArray = array[0..MaxShortIntArrayElements - 1] of ShortInt;
  TStaticSmallIntArray = array[0..MaxSmallIntArrayElements - 1] of SmallInt;
  TStaticLongIntArray = array[0..MaxLongIntArrayElements - 1] of LongInt;
  TStaticInt64Array = array[0..MaxInt64ArrayElements - 1] of Int64;
  TStaticNativeIntArray = array[0..MaxNativeIntArrayElements - 1] of NativeInt;
  TStaticSingleArray = array[0..MaxSingleArrayElements - 1] of Single;
  TStaticDoubleArray = array[0..MaxDoubleArrayElements - 1] of Double;
  TStaticExtendedArray = array[0..MaxExtendedArrayElements - 1] of Extended;
  TStaticBooleanArray = array[0..MaxBooleanArrayElements - 1] of Boolean;
  {$IFNDEF CLR}
  TStaticCurrencyArray = array[0..MaxCurrencyArrayElements - 1] of Currency;
  TStaticAnsiStringArray = array[0..MaxAnsiStringArrayElements - 1] of AnsiString;
  TStaticRawByteStringArray = array[0..MaxRawByteStringArrayElements - 1] of RawByteString;
  TStaticWideStringArray = array[0..MaxWideStringArrayElements - 1] of WideString;
  TStaticUnicodeStringArray = array[0..MaxUnicodeStringArrayElements - 1] of UnicodeString;
  {$IFDEF StringIsUnicode}
  TStaticStringArray = TStaticUnicodeStringArray;
  {$ELSE}
  TStaticStringArray = TStaticAnsiStringArray;
  {$ENDIF}
  TStaticPointerArray = array[0..MaxPointerArrayElements - 1] of Pointer;
  TStaticObjectArray = array[0..MaxObjectArrayElements - 1] of TObject;
  TStaticInterfaceArray = array[0..MaxInterfaceArrayElements - 1] of IInterface;
  TStaticCharSetArray = array[0..MaxCharSetArrayElements - 1] of CharSet;
  TStaticByteSetArray = array[0..MaxByteSetArrayElements - 1] of ByteSet;
  {$ENDIF}
  TStaticCardinalArray = TStaticLongWordArray;
  TStaticIntegerArray = TStaticLongIntArray;

{ Static array pointers                                                        }
type
  PStaticByteArray = ^TStaticByteArray;
  PStaticWordArray = ^TStaticWordArray;
  PStaticLongWordArray = ^TStaticLongWordArray;
  PStaticCardinalArray = ^TStaticCardinalArray;
  PStaticNativeUIntArray = ^TStaticNativeUIntArray;
  PStaticShortIntArray = ^TStaticShortIntArray;
  PStaticSmallIntArray = ^TStaticSmallIntArray;
  PStaticLongIntArray = ^TStaticLongIntArray;
  PStaticIntegerArray = ^TStaticIntegerArray;
  PStaticInt64Array = ^TStaticInt64Array;
  PStaticNativeIntArray = ^TStaticNativeIntArray;
  PStaticSingleArray = ^TStaticSingleArray;
  PStaticDoubleArray = ^TStaticDoubleArray;
  PStaticExtendedArray = ^TStaticExtendedArray;
  PStaticBooleanArray = ^TStaticBooleanArray;
  {$IFNDEF CLR}
  PStaticCurrencyArray = ^TStaticCurrencyArray;
  PStaticAnsiStringArray = ^TStaticAnsiStringArray;
  PStaticRawByteStringArray = ^TStaticRawByteStringArray;
  PStaticWideStringArray = ^TStaticWideStringArray;
  PStaticUnicodeStringArray = ^TStaticUnicodeStringArray;
  PStaticStringArray = ^TStaticStringArray;
  PStaticPointerArray = ^TStaticPointerArray;
  PStaticObjectArray = ^TStaticObjectArray;
  PStaticInterfaceArray = ^TStaticInterfaceArray;
  PStaticCharSetArray = ^TStaticCharSetArray;
  PStaticByteSetArray = ^TStaticByteSetArray;
  {$ENDIF}



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

function Int32Bounded(const Value: LongInt; const Min, Max: LongInt): LongInt;
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

function Int32BoundedByte(const Value: LongInt): LongInt;
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

function Int32BoundedWord(const Value: LongInt): LongInt;
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

function Int64BoundedLongWord(const Value: Int64): LongWord;
begin
  if Value < MinLongWord then
    Result := MinLongWord else
  if Value > MaxLongWord then
    Result := MaxLongWord
  else
    Result := LongWord(Value);
end;



{                                                                              }
{ Real                                                                         }
{                                                                              }
function DoubleMin(const A, B: Double): Double;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function DoubleMax(const A, B: Double): Double;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function ExtendedMin(const A, B: Extended): Extended;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function ExtendedMax(const A, B: Extended): Extended;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function FloatMin(const A, B: Float): Float;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function FloatMax(const A, B: Float): Float;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function FloatClip(const Value: Float; const Low, High: Float): Float;
begin
  if Value < Low then
    Result := Low else
  if Value > High then
    Result := High
  else
    Result := Value;
end;

function InSingleRange(const A: Float): Boolean;
var B : Float;
begin
  B := Abs(A);
  Result := (B >= MinSingle) and (B <= MaxSingle);
end;

{$IFDEF CLR}
function InDoubleRange(const A: Float): Boolean;
begin
  Result := True;
end;
{$ELSE}
function InDoubleRange(const A: Float): Boolean;
var B : Float;
begin
  B := Abs(A);
  Result := (B >= MinDouble) and (B <= MaxDouble);
end;
{$ENDIF}

{$IFNDEF CLR}
function InCurrencyRange(const A: Float): Boolean;
begin
  Result := (A >= MinCurrency) and (A <= MaxCurrency);
end;

function InCurrencyRange(const A: Int64): Boolean;
begin
  Result := (A >= MinCurrency) and (A <= MaxCurrency);
end;
{$ENDIF}

{$IFNDEF ExtendedIsDouble}
function ExtendedExponentBase2(const A: Extended; var Exponent: Integer): Boolean;
var RecA : ExtendedRec absolute A;
    ExpA : Word;
begin
  ExpA := RecA.Exponent and $7FFF;
  if ExpA = $7FFF then // A is NaN, Infinity, ...
    begin
      Exponent := 0;
      Result := False;
    end
  else
    begin
      Exponent := Integer(ExpA) - 16383;
      Result := True;
    end;
end;

function ExtendedExponentBase10(const A: Extended; var Exponent: Integer): Boolean;
const Log2_10 = 3.32192809488736; // Log2(10)
begin
  Result := ExtendedExponentBase2(A, Exponent);
  if Result then
    Exponent := Round(Exponent / Log2_10);
end;
{$ENDIF}

{$IFNDEF ExtendedIsDouble}
function ExtendedIsInfinity(const A: Extended): Boolean;
var Ext : ExtendedRec absolute A;
begin
  if Ext.Exponent and $7FFF <> $7FFF then
    Result := False
  else
    Result := (Ext.Mantissa[1] = $80000000) and (Ext.Mantissa[0] = 0);
end;

function ExtendedIsNaN(const A: Extended): Boolean;
var Ext : ExtendedRec absolute A;
begin
  if Ext.Exponent and $7FFF <> $7FFF then
    Result := False
  else
    Result := (Ext.Mantissa[1] <> $80000000) or (Ext.Mantissa[0] <> 0)
end;
{$ENDIF}



{                                                                              }
{ Approximate comparison                                                       }
{                                                                              }
function FloatZero(const A: Float; const CompareDelta: Float): Boolean;
begin
  Assert(CompareDelta >= 0.0);
  Result := Abs(A) <= CompareDelta;
end;

function FloatOne(const A: Float; const CompareDelta: Float): Boolean;
begin
  Assert(CompareDelta >= 0.0);
  Result := Abs(A - 1.0) <= CompareDelta;
end;

function FloatsEqual(const A, B: Float; const CompareDelta: Float): Boolean;
begin
  Assert(CompareDelta >= 0.0);
  Result := Abs(A - B) <= CompareDelta;
end;

function FloatsCompare(const A, B: Float; const CompareDelta: Float): TCompareResult;
var D : Float;
begin
  Assert(CompareDelta >= 0.0);
  D := A - B;
  if Abs(D) <= CompareDelta then
    Result := crEqual else
  if D >= CompareDelta then
    Result := crGreater
  else
    Result := crLess;
end;



{$IFNDEF ExtendedIsDouble}
{                                                                              }
{ Scaled approximate comparison                                                }
{                                                                              }
{   The ApproxEqual and ApproxCompare functions were taken from the freeware   }
{   FltMath unit by Tempest Software, as taken from Knuth, Seminumerical       }
{   Algorithms, 2nd ed., Addison-Wesley, 1981, pp. 217-220.                    }
{                                                                              }
function ExtendedApproxEqual(const A, B: Extended; const CompareEpsilon: Double): Boolean;
var ExtA : ExtendedRec absolute A;
    ExtB : ExtendedRec absolute B;
    ExpA : Word;
    ExpB : Word;
    Exp  : ExtendedRec;
begin
  ExpA := ExtA.Exponent and $7FFF;
  ExpB := ExtB.Exponent and $7FFF;
  if (ExpA = $7FFF) and
     ((ExtA.Mantissa[1] <> $80000000) or (ExtA.Mantissa[0] <> 0)) then
    { A is NaN }
    Result := False else
  if (ExpB = $7FFF) and
     ((ExtB.Mantissa[1] <> $80000000) or (ExtB.Mantissa[0] <> 0)) then
    { B is NaN }
    Result := False else
  if (ExpA = $7FFF) or (ExpB = $7FFF) then
    { A or B is infinity. Use the builtin comparison, which will       }
    { properly account for signed infinities, comparing infinity with  }
    { infinity, or comparing infinity with a finite value.             }
    Result := A = B else
  begin
    { We are comparing two finite values, so take the difference and   }
    { compare that against the scaled Epsilon.                         }
    Exp.Value := 1.0;
    if ExpA < ExpB then
      Exp.Exponent := ExpB
    else
      Exp.Exponent := ExpA;
    Result := Abs(A - B) <= (CompareEpsilon * Exp.Value);
  end;
end;

function ExtendedApproxCompare(const A, B: Extended; const CompareEpsilon: Double): TCompareResult;
var ExtA : ExtendedRec absolute A;
    ExtB : ExtendedRec absolute B;
    ExpA : Word;
    ExpB : Word;
    Exp  : ExtendedRec;
    D, E : Extended;
begin
  ExpA := ExtA.Exponent and $7FFF;
  ExpB := ExtB.Exponent and $7FFF;
  if (ExpA = $7FFF) and
     ((ExtA.Mantissa[1] <> $80000000) or (ExtA.Mantissa[0] <> 0)) then
    { A is NaN }
    Result := crUndefined else
  if (ExpB = $7FFF) and
     ((ExtB.Mantissa[1] <> $80000000) or (ExtB.Mantissa[0] <> 0)) then
    { B is NaN }
    Result := crUndefined else
  if (ExpA = $7FFF) or (ExpB = $7FFF) then
    { A or B is infinity. Use the builtin comparison, which will       }
    { properly account for signed infinities, comparing infinity with  }
    { infinity, or comparing infinity with a finite value.             }
    Result := Compare(A, B) else
  begin
    { We are comparing two finite values, so take the difference and   }
    { compare that against the scaled Epsilon.                         }
    Exp.Value := 1.0;
    if ExpA < ExpB then
      Exp.Exponent := ExpB
    else
      Exp.Exponent := ExpA;
    E := CompareEpsilon * Exp.Value;
    D := A - B;
    if Abs(D) <= E then
      Result := crEqual else
    if D >= E then
      Result := crGreater
    else
      Result := crLess;
  end;
end;
{$ENDIF}

// Knuth: approximatelyEqual
// return fabs(a - b) <= ( (fabs(a) < fabs(b) ? fabs(b) : fabs(a)) * epsilon);
function DoubleApproxEqual(const A, B: Double; const CompareEpsilon: Double): Boolean;
var AbsA, AbsB, R : Float;
begin
  AbsA := Abs(A);
  AbsB := Abs(B);
  if AbsA < AbsB then
    R := AbsB
  else
    R := AbsA;
  R := R * CompareEpsilon;
  Result := Abs(A - B) <= R;
end;

function DoubleApproxCompare(const A, B: Double; const CompareEpsilon: Double): TCompareResult;
var AbsA, AbsB, R, D : Float;
begin
  AbsA := Abs(A);
  AbsB := Abs(B);
  if AbsA < AbsB then
    R := AbsB
  else
    R := AbsA;
  R := R * CompareEpsilon;
  D := A - B;
  if Abs(D) <= R then
    Result := crEqual
  else
  if D < 0 then
    Result := crLess
  else
    Result := crGreater;
end;

function FloatApproxEqual(const A, B: Float; const CompareEpsilon: Float): Boolean;
var AbsA, AbsB, R : Float;
begin
  AbsA := Abs(A);
  AbsB := Abs(B);
  if AbsA < AbsB then
    R := AbsB
  else
    R := AbsA;
  R := R * CompareEpsilon;
  Result := Abs(A - B) <= R;
end;

function FloatApproxCompare(const A, B: Float; const CompareEpsilon: Float): TCompareResult;
var AbsA, AbsB, R, D : Float;
begin
  AbsA := Abs(A);
  AbsB := Abs(B);
  if AbsA < AbsB then
    R := AbsB
  else
    R := AbsA;
  R := R * CompareEpsilon;
  D := A - B;
  if Abs(D) <= R then
    Result := crEqual
  else
  if D < 0 then
    Result := crLess
  else
    Result := crGreater;
end;



{                                                                              }
{ US-ASCII String functions                                                    }
{                                                                              }
function IsAsciiCharA(const C: AnsiChar): Boolean;
begin
  Result := C in [AnsiChar(0)..AnsiChar(127)];
end;

function IsAsciiCharW(const C: WideChar): Boolean;
begin
  Result := Ord(C) <= 127;
end;

function IsAsciiChar(const C: Char): Boolean;
begin
  Result := Ord(C) <= 127;
end;

function IsAsciiBufB(const Buf: Pointer; const Len: Integer): Boolean;
var I : Integer;
    P : PByte;
begin
  P := Buf;
  for I := 1 to Len do
    if P^ >= $80 then
      begin
        Result := False;
        exit;
      end
    else
      Inc(P);
  Result := True;
end;

function IsAsciiBufW(const Buf: Pointer; const Len: Integer): Boolean;
var I : Integer;
    P : PWord16;
begin
  P := Buf;
  for I := 1 to Len do
    if P^ >= $80 then
      begin
        Result := False;
        exit;
      end
    else
      Inc(P);
  Result := True;
end;

function IsAsciiStringA(const S: AnsiString): Boolean;
begin
  Result := IsAsciiBufB(PAnsiChar(S), Length(S));
end;

function IsAsciiStringB(const S: RawByteString): Boolean;
begin
  Result := IsAsciiBufB(PAnsiChar(S), Length(S));
end;

function IsAsciiStringW(const S: WideString): Boolean;
begin
  Result := IsAsciiBufW(PWideChar(S), Length(S));
end;

function IsAsciiStringU(const S: UnicodeString): Boolean;
begin
  Result := IsAsciiBufW(PWideChar(S), Length(S));
end;

function IsAsciiString(const S: String): Boolean;
begin
  {$IFDEF StringIsUnicode}
  Result := IsAsciiStringU(S);
  {$ELSE}
  Result := IsAsciiStringA(S);
  {$ENDIF}
end;



{                                                                              }
{ ASCII functions                                                              }
{                                                                              }
function AsciiHexCharValue(const C: AnsiChar): Integer;
begin
  case Ord(C) of
    Ord('0')..Ord('9') : Result := Ord(C) - Ord('0');
    Ord('A')..Ord('F') : Result := Ord(C) - Ord('A') + 10;
    Ord('a')..Ord('f') : Result := Ord(C) - Ord('a') + 10;
  else
    Result := -1;
  end;
end;

function AsciiHexCharValueW(const C: WideChar): Integer;
begin
  if Ord(C) >= $80 then
    Result := -1
  else
    Result := AsciiHexCharValue(AnsiChar(Ord(C)));
end;

function AsciiIsHexChar(const C: AnsiChar): Boolean;
begin
  Result := AsciiHexCharValue(C) >= 0;
end;

function AsciiIsHexCharW(const C: WideChar): Boolean;
begin
  Result := AsciiHexCharValueW(C) >= 0;
end;

function AsciiDecimalCharValue(const C: AnsiChar): Integer;
begin
  case Ord(C) of
    Ord('0')..Ord('9') : Result := Ord(C) - Ord('0');
  else
    Result := -1;
  end;
end;

function AsciiDecimalCharValueW(const C: WideChar): Integer;
begin
  if Ord(C) >= $80 then
    Result := -1
  else
    Result := AsciiDecimalCharValue(AnsiChar(Ord(C)));
end;

function AsciiIsDecimalChar(const C: AnsiChar): Boolean;
begin
  Result := AsciiDecimalCharValue(C) >= 0;
end;

function AsciiIsDecimalCharW(const C: WideChar): Boolean;
begin
  Result := AsciiDecimalCharValueW(C) >= 0;
end;

function AsciiOctalCharValue(const C: AnsiChar): Integer;
begin
  case Ord(C) of
    Ord('0')..Ord('7') : Result := Ord(C) - Ord('0');
  else
    Result := -1;
  end;
end;

function AsciiOctalCharValueW(const C: WideChar): Integer;
begin
  if Ord(C) >= $80 then
    Result := -1
  else
    Result := AsciiOctalCharValue(AnsiChar(Ord(C)));
end;

function AsciiIsOctalChar(const C: AnsiChar): Boolean;
begin
  Result := AsciiOctalCharValue(C) >= 0;
end;

function AsciiIsOctalCharW(const C: WideChar): Boolean;
begin
  Result := AsciiOctalCharValueW(C) >= 0;
end;



{                                                                              }
{ ASCII case conversion                                                        }
{                                                                              }
const
  AsciiCaseDiff = Byte(AsciiLowerA) - Byte(AsciiUpperA);

{$IFDEF ASM386_DELPHI}
function AsciiLowCaseA(const C: AnsiChar): AnsiChar; register; assembler;
asm
      CMP     AL, AsciiUpperA
      JB      @@exit
      CMP     AL, AsciiUpperZ
      JA      @@exit
      ADD     AL, AsciiCaseDiff
@@exit:
end;
{$ELSE}
function AsciiLowCaseA(const C: AnsiChar): AnsiChar;
begin
  if C in [AsciiUpperA..AsciiUpperZ] then
    Result := AsciiChar(Byte(C) + AsciiCaseDiff)
  else
    Result := C;
end;
{$ENDIF}

function AsciiLowCaseW(const C: WideChar): WideChar;
begin
  case Ord(C) of
    Ord(AsciiUpperA)..Ord(AsciiUpperZ) : Result := WideChar(Ord(C) + AsciiCaseDiff)
  else
    Result := C;
  end;
end;

function AsciiLowCase(const C: Char): Char;
begin
  case Ord(C) of
    Ord(AsciiUpperA)..Ord(AsciiUpperZ) : Result := Char(Ord(C) + AsciiCaseDiff)
  else
    Result := C;
  end;
end;

{$IFDEF ASM386_DELPHI}
function AsciiUpCaseA(const C: AnsiChar): AnsiChar; register; assembler;
asm
      CMP     AL, AsciiLowerA
      JB      @@exit
      CMP     AL, AsciiLowerZ
      JA      @@exit
      SUB     AL, AsciiLowerA - AsciiUpperA
@@exit:
end;
{$ELSE}
function AsciiUpCaseA(const C: AnsiChar): AnsiChar;
begin
  if C in [AsciiLowerA..AsciiLowerZ] then
    Result := AsciiChar(Byte(C) - AsciiCaseDiff)
  else
    Result := C;
end;
{$ENDIF}

function AsciiUpCaseW(const C: WideChar): WideChar;
begin
  case Ord(C) of
    Ord(AsciiLowerA)..Ord(AsciiLowerZ) : Result := WideChar(Ord(C) - AsciiCaseDiff)
  else
    Result := C;
  end;
end;

function AsciiUpCase(const C: Char): Char;
begin
  case Ord(C) of
    Ord(AsciiLowerA)..Ord(AsciiLowerZ) : Result := Char(Ord(C) - AsciiCaseDiff)
  else
    Result := C;
  end;
end;

{$IFDEF ASM386_DELPHI}
procedure AsciiConvertUpperA(var S: AnsiString);
asm
      OR      EAX, EAX
      JZ      @Exit
      PUSH    EAX
      MOV     EAX, [EAX]
      OR      EAX, EAX
      JZ      @ExitP
      MOV     ECX, [EAX - 4]
      OR      ECX, ECX
      JZ      @ExitP
      XOR     DH, DH
  @L2:
      DEC     ECX
      MOV     DL, [EAX + ECX]
      CMP     DL, AsciiLowerA
      JB      @L1
      CMP     DL, AsciiLowerZ
      JA      @L1
      OR      DH, DH
      JZ      @Uniq
  @L3:
      SUB     DL, AsciiCaseDiff
      MOV     [EAX + ECX], DL
  @L1:
      OR      ECX, ECX
      JNZ     @L2
      OR      DH, DH
      JNZ     @Exit
  @ExitP:
      POP     EAX
  @Exit:
      RET
  @Uniq:
      POP     EAX
      PUSH    ECX
      PUSH    EDX
      CALL    UniqueString
      POP     EDX
      POP     ECX
      MOV     DH, 1
      JMP     @L3
end;
{$ELSE}
procedure AsciiConvertUpperA(var S: AnsiString);
var F : Integer;
begin
  for F := StrBaseA to Length(S) - (1 - StrBaseA) do
    if S[F] in [AsciiLowerA..AsciiLowerZ] then
      S[F] := AnsiChar(Ord(S[F]) - AsciiCaseDiff);
end;
{$ENDIF}

procedure AsciiConvertUpperB(var S: RawByteString);
var F : Integer;
    B : Byte;
begin
  for F := StrBaseB to Length(S) - (1 - StrBaseB) do
    begin
      B := Ord(S[F]);
      if (B >= Ord(AsciiLowerA)) and (B <= Ord(AsciiLowerZ)) then
        S[F] := AnsiChar(B - AsciiCaseDiff);
    end;
end;

procedure AsciiConvertUpperW(var S: WideString);
var F : Integer;
    C : WideChar;
begin
  for F := StrBaseW to Length(S) - (1 - StrBaseW) do
    begin
      C := S[F];
      if Ord(C) <= $FF then
        if AnsiChar(Ord(C)) in [AsciiLowerA..AsciiLowerZ] then
          S[F] := WideChar(Ord(C) - AsciiCaseDiff);
    end;
end;

procedure AsciiConvertUpperU(var S: UnicodeString);
var F : Integer;
    C : WideChar;
begin
  for F := 1 to Length(S) do
    begin
      C := S[F];
      if Ord(C) <= $FF then
        if AnsiChar(Ord(C)) in [AsciiLowerA..AsciiLowerZ] then
          S[F] := WideChar(Ord(C) - AsciiCaseDiff);
    end;
end;

procedure AsciiConvertUpper(var S: String);
var F : Integer;
    C : Char;
begin
  for F := 1 to Length(S) do
    begin
      C := S[F];
      {$IFDEF StringIsUnicode}
      if Ord(C) <= $FF then
      {$ENDIF}
        if AnsiChar(Ord(C)) in [AsciiLowerA..AsciiLowerZ] then
          S[F] := Char(Ord(C) - AsciiCaseDiff);
    end;
end;

{$IFDEF ASM386_DELPHI}
procedure AsciiConvertLowerA(var S: AsciiString);
asm
      OR      EAX, EAX
      JZ      @Exit
      PUSH    EAX
      MOV     EAX, [EAX]
      OR      EAX, EAX
      JZ      @ExitP
      MOV     ECX, [EAX - 4]
      OR      ECX, ECX
      JZ      @ExitP
      XOR     DH, DH
  @L2:
      DEC     ECX
      MOV     DL, [EAX + ECX]
      CMP     DL, AsciiUpperA
      JB      @L1
      CMP     DL, AsciiUpperZ
      JA      @L1
      OR      DH, DH
      JZ      @Uniq
  @L3:
      ADD     DL, AsciiCaseDiff
      MOV     [EAX + ECX], DL
  @L1:
      OR      ECX, ECX
      JNZ     @L2
      OR      DH, DH
      JNZ     @Exit
  @ExitP:
      POP     EAX
  @Exit:
      RET
  @Uniq:
      POP     EAX
      PUSH    ECX
      PUSH    EDX
      CALL    UniqueString
      POP     EDX
      POP     ECX
      MOV     DH, 1
      JMP     @L3
end;
{$ELSE}
procedure AsciiConvertLowerA(var S: AnsiString);
var F : Integer;
begin
  for F := StrBaseA to Length(S) - (1 - StrBaseA) do
    if S[F] in [AsciiUpperA..AsciiUpperZ] then
      S[F] := AnsiChar(Ord(S[F]) + AsciiCaseDiff);
end;
{$ENDIF}

procedure AsciiConvertLowerB(var S: RawByteString);
var F : Integer;
begin
  for F := StrBaseB to Length(S) - (1 - StrBaseB) do
    if S[F] in [AsciiUpperA..AsciiUpperZ] then
      S[F] := AnsiChar(Ord(S[F]) + AsciiCaseDiff);
end;

procedure AsciiConvertLowerW(var S: WideString);
var F : Integer;
    C : WideChar;
begin
  for F := StrBaseW to Length(S) - (1 - StrBaseW) do
    begin
      C := S[F];
      if Ord(C) <= $FF then
        if AnsiChar(Ord(C)) in [AsciiUpperA..AsciiUpperZ] then
          S[F] := WideChar(Ord(C) + AsciiCaseDiff);
    end;
end;

procedure AsciiConvertLowerU(var S: UnicodeString);
var F : Integer;
    C : WideChar;
begin
  for F := 1 to Length(S) do
    begin
      C := S[F];
      if Ord(C) <= $FF then
        if AnsiChar(Ord(C)) in [AsciiUpperA..AsciiUpperZ] then
          S[F] := WideChar(Ord(C) + AsciiCaseDiff);
    end;
end;

procedure AsciiConvertLower(var S: String);
var F : Integer;
    C : Char;
begin
  for F := 1 to Length(S) do
    begin
      C := S[F];
      {$IFDEF StringIsUnicode}
      if Ord(C) <= $FF then
      {$ENDIF}
        if AnsiChar(Ord(C)) in [AsciiUpperA..AsciiUpperZ] then
          S[F] := Char(Ord(C) + AsciiCaseDiff);
    end;
end;

function AsciiUpperCaseA(const A: AnsiString): AnsiString;
begin
  Result := A;
  AsciiConvertUpperA(Result);
end;

function AsciiUpperCaseB(const A: RawByteString): RawByteString;
begin
  Result := A;
  AsciiConvertUpperB(Result);
end;

function AsciiUpperCaseW(const A: WideString): WideString;
begin
  Result := A;
  AsciiConvertUpperW(Result);
end;

function AsciiUpperCaseU(const A: UnicodeString): UnicodeString;
begin
  Result := A;
  AsciiConvertUpperU(Result);
end;

function AsciiUpperCase(const A: String): String;
begin
  Result := A;
  AsciiConvertUpper(Result);
end;

function AsciiLowerCaseA(const A: AnsiString): AnsiString;
begin
  Result := A;
  AsciiConvertLowerA(Result);
end;

function AsciiLowerCaseB(const A: RawByteString): RawByteString;
begin
  Result := A;
  AsciiConvertLowerB(Result);
end;

function AsciiLowerCaseW(const A: WideString): WideString;
begin
  Result := A;
  AsciiConvertLowerW(Result);
end;

function AsciiLowerCaseU(const A: UnicodeString): UnicodeString;
begin
  Result := A;
  AsciiConvertLowerU(Result);
end;

function AsciiLowerCase(const A: String): String;
begin
  Result := A;
  AsciiConvertLower(Result);
end;

procedure AsciiConvertFirstUpA(var S: AnsiString);
var C : AnsiChar;
begin
  if S <> StrEmptyA then
    begin
      C := S[StrBaseA];
      if C in [AsciiLowerA..AsciiLowerZ] then
        S[StrBaseA] := AsciiUpCaseA(C);
    end;
end;

procedure AsciiConvertFirstUpB(var S: RawByteString);
var C : AnsiChar;
begin
  if S <> StrEmptyA then
    begin
      C := S[StrBaseB];
      if C in [AsciiLowerA..AsciiLowerZ] then
        S[StrBaseB] := AsciiUpCaseA(C);
    end;
end;

procedure AsciiConvertFirstUpW(var S: WideString);
var C : WideChar;
begin
  if S <> StrEmptyW then
    begin
      C := S[StrBaseW];
      if (Ord(C) >= Ord(AsciiLowerA)) and (Ord(C) <= Ord(AsciiLowerZ)) then
        S[StrBaseW] := AsciiUpCaseW(C);
    end;
end;

procedure AsciiConvertFirstUp(var S: String);
var C : Char;
begin
  if S <> '' then
    begin
      C := S[1];
      if (Ord(C) >= Ord(AsciiLowerA)) and (Ord(C) <= Ord(AsciiLowerZ)) then
        S[1] := AsciiUpCase(C);
    end;
end;

function AsciiFirstUpA(const S: AnsiString): AnsiString;
begin
  Result := S;
  AsciiConvertFirstUpA(Result);
end;

function AsciiFirstUpB(const S: RawByteString): RawByteString;
begin
  Result := S;
  AsciiConvertFirstUpB(Result);
end;

function AsciiFirstUpW(const S: WideString): WideString;
begin
  Result := S;
  AsciiConvertFirstUpW(Result);
end;

function AsciiFirstUp(const S: String): String;
begin
  Result := S;
  AsciiConvertFirstUp(Result);
end;

procedure AsciiConvertArrayUpper(var S: AsciiStringArray);
var I : Integer;
begin
  for I := 0 to Length(S) - 1 do
    AsciiConvertUpperA(S[I]);
end;

procedure AsciiConvertArrayLower(var S: AsciiStringArray);
var I : Integer;
begin
  for I := 0 to Length(S) - 1 do
    AsciiConvertLowerA(S[I]);
end;



{                                                                              }
{ String construction from buffer                                              }
{                                                                              }
{$IFNDEF ManagedCode}
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

function StrPToStrB(const P: PAnsiChar; const L: Integer): RawByteString;
begin
  if L <= 0 then
    SetLength(Result, 0)
  else
    begin
      SetLength(Result, L);
      MoveMem(P^, Pointer(Result)^, L);
    end;
end;

function StrPToStrW(const P: PWideChar; const L: Integer): WideString;
begin
  if L <= 0 then
    SetLength(Result, 0)
  else
    begin
      SetLength(Result, L);
      MoveMem(P^, Pointer(Result)^, L * SizeOf(WideChar));
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
{$ENDIF}



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
    V : LongWord;
begin
  if BufSize <= 0 then
    exit;
  P := Buf;
  Q := DestBuf;
  for I := 1 to BufSize div 4 do
    begin
      // convert 4 characters per iteration
      V := PLongWord(P)^;
      Inc(PLongWord(P));
      PLongWord(Q)^ := (V and $FF) or ((V and $FF00) shl 8);
      Inc(PLongWord(Q));
      V := V shr 16;
      PLongWord(Q)^ := (V and $FF) or ((V and $FF00) shl 8);
      Inc(PLongWord(Q));
    end;
  // convert remaining (<4)
  for I := 1 to BufSize mod 4 do
    begin
      PWord(Q)^ := PByte(P)^;
      Inc(PByte(P));
      Inc(PWord(Q));
    end;
end;

function RawByteStrPtrToWideString(const S: PAnsiChar; const Len: Integer): WideString;
begin
  if Len <= 0 then
    Result := StrEmptyW
  else
    begin
      SetLength(Result, Len);
      RawByteBufToWideBuf(S, Len, PWideChar(Result));
    end;
end;

function RawByteStrPtrToUnicodeString(const S: PAnsiChar; const Len: Integer): UnicodeString;
begin
  if Len <= 0 then
    Result := ''
  else
    begin
      SetLength(Result, Len);
      RawByteBufToWideBuf(S, Len, PWideChar(Result));
    end;
end;

function RawByteStringToWideString(const S: RawByteString): WideString;
var L : Integer;
begin
  L := Length(S);
  SetLength(Result, L);
  if L > 0 then
    RawByteBufToWideBuf(PAnsiChar(S), L, PWideChar(Result));
end;

function RawByteStringToUnicodeString(const S: RawByteString): UnicodeString;
var L : Integer;
begin
  L := Length(S);
  SetLength(Result, L);
  if L > 0 then
    RawByteBufToWideBuf(PAnsiChar(S), L, PWideChar(Result));
end;

procedure WideBufToRawByteBuf(const Buf: Pointer; const Len: Integer;
    const DestBuf: Pointer);
var I : Integer;
    S : PWideChar;
    Q : PAnsiChar;
    V : LongWord;
    W : Word;
begin
  if Len <= 0 then
    exit;
  S := Buf;
  Q := DestBuf;
  for I := 1 to Len div 2 do
    begin
      // convert 2 characters per iteration
      V := PLongWord(S)^;
      if V and $FF00FF00 <> 0 then
        raise EConvertError.Create(SRawByteStringConvertError);
      Q^ := AnsiChar(V);
      Inc(Q);
      Q^ := AnsiChar(V shr 16);
      Inc(Q);
      Inc(S, 2);
    end;
  // convert remaining character
  if Len mod 2 = 1 then
    begin
      W := Ord(S^);
      if W > $FF then
        raise EConvertError.Create(SRawByteStringConvertError);
      Q^ := AnsiChar(W);
    end;
end;

function WideBufToRawByteString(const P: PWideChar; const Len: Integer): RawByteString;
var I : Integer;
    S : PWideChar;
    Q : PAnsiChar;
    V : WideChar;
begin
  if Len <= 0 then
    begin
      Result := StrEmptyB;
      exit;
    end;
  SetLength(Result, Len);
  S := P;
  Q := PAnsiChar(Result);
  for I := 1 to Len do
    begin
      V := S^;
      if Ord(V) > $FF then
        raise EConvertError.Create(SRawByteStringConvertError);
      Q^ := AnsiChar(Byte(V));
      Inc(S);
      Inc(Q);
    end;
end;

function WideStringToRawByteString(const S: WideString): RawByteString;
begin
  Result := WideBufToRawByteString(PWideChar(S), Length(S));
end;

function UnicodeStringToRawByteString(const S: UnicodeString): RawByteString;
begin
  Result := WideBufToRawByteString(PWideChar(S), Length(S));
end;



{                                                                              }
{ String conversion functions                                                  }
{                                                                              }
function ToAnsiString(const A: String): AnsiString;
begin
  {$IFDEF StringIsUnicode}
  Result := AnsiString(A);
  {$ELSE}
  Result := A;
  {$ENDIF}
end;

function ToRawByteString(const A: String): RawByteString;
begin
  {$IFDEF StringIsUnicode}
  Result := RawByteString(A);
  {$ELSE}
  Result := A;
  {$ENDIF}
end;

{$IFNDEF SupportWideString}
{$IFDEF StringIsUnicode}
function ToWideString(const A: String): WideString;
var L : Integer;
begin
  L := Length(A);
  SetLength(Result, L);
  Move(PChar(A)^, PWideChar(Result)^, L * SizeOf(WideChar));
end;
{$ELSE}
function ToWideString(const A: String): WideString;
var L : Integer;
begin
  L := Length(A);
  SetLength(Result, L);
  RawByteBufToWideBuf(PChar(A), Length(A), PWideChar(Result));
end;
{$ENDIF}
{$ELSE}
function ToWideString(const A: String): WideString;
var L, I : Integer;
begin
  L := Length(A);
  SetLength(Result, L);
  for I := 1 to L do
    Result[I] := WideChar(A[I]);
end;
{$ENDIF}

function ToUnicodeString(const A: String): UnicodeString;
begin
  Result := UnicodeString(A);
end;



{                                                                              }
{ String internals functions                                                   }
{                                                                              }
{$IFNDEF SupportStringRefCount}
{$IFDEF DELPHI}
function StringRefCount(const S: UnicodeString): LongInt;
var P : PLongInt;
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

function StringRefCount(const S: RawByteString): LongInt;
var P : PLongInt;
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
{$IFNDEF SupportAnsiString}
procedure StrAppendChA(var A: AnsiString; const C: AnsiChar);
var L : Integer;
begin
  L := Length(A);
  SetLength(A, L + 1);
  A[L] := C;
end;
{$ELSE}
procedure StrAppendChA(var A: AnsiString; const C: AnsiChar);
begin
  A := A + C;
end;
{$ENDIF}

{$IFNDEF SupportAnsiString}
procedure StrAppendChB(var A: RawByteString; const C: AnsiChar);
var L : Integer;
begin
  L := Length(A);
  SetLength(A, L + 1);
  A[L] := C;
end;
{$ELSE}
procedure StrAppendChB(var A: RawByteString; const C: AnsiChar);
begin
  A := A + C;
end;
{$ENDIF}

{$IFNDEF SupportWideString}
procedure StrAppendChW(var A: WideString; const C: WideChar);
var L : Integer;
begin
  L := Length(A);
  SetLength(A, L + 1);
  A[L] := C;
end;
{$ELSE}
procedure StrAppendChW(var A: WideString; const C: WideChar);
begin
  A := A + C;
end;
{$ENDIF}

{$IFNDEF SupportUnicodeString}
procedure StrAppendChU(var A: UnicodeString; const C: WideChar);
var L : Integer;
begin
  L := Length(A);
  SetLength(A, L + 1);
  A[L] := C;
end;
{$ELSE}
procedure StrAppendChU(var A: UnicodeString; const C: WideChar);
begin
  A := A + C;
end;
{$ENDIF}

procedure StrAppendCh(var A: String; const C: Char);
begin
  A := A + C;
end;



{                                                                              }
{ Compare                                                                      }
{                                                                              }
function CharCompareA(const A, B: AnsiChar): Integer;
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
  Result := CharCompareA(A, B);
  {$ENDIF}
end;

function CharCompareNoAsciiCaseA(const A, B: AnsiChar): Integer;
var C, D : AnsiChar;
begin
  C := AsciiUpCaseA(A);
  D := AsciiUpCaseA(B);
  if C < D then
    Result := -1 else
    if C > D then
      Result := 1
    else
      Result := 0;
end;

function CharCompareNoAsciiCaseW(const A, B: WideChar): Integer;
var C, D : WideChar;
begin
  C := AsciiUpCaseW(A);
  D := AsciiUpCaseW(B);
  if Ord(C) < Ord(D) then
    Result := -1 else
    if Ord(C) > Ord(D) then
      Result := 1
    else
      Result := 0;
end;

function CharCompareNoAsciiCase(const A, B: Char): Integer;
var C, D : Char;
begin
  C := AsciiUpCase(A);
  D := AsciiUpCase(B);
  if Ord(C) < Ord(D) then
    Result := -1 else
    if Ord(C) > Ord(D) then
      Result := 1
    else
      Result := 0;
end;

function CharEqualNoAsciiCaseA(const A, B: AnsiChar): Boolean;
begin
  Result := AsciiUpCaseA(A) = AsciiUpCaseA(B);
end;

function CharEqualNoAsciiCaseW(const A, B: WideChar): Boolean;
begin
  Result := AsciiUpCaseW(A) = AsciiUpCaseW(B);
end;

function CharEqualNoAsciiCase(const A, B: Char): Boolean;
begin
  Result := AsciiUpCase(A) = AsciiUpCase(B);
end;

{$IFDEF CLR}
function StrPCompareA(const A, B: AnsiString; const Len: Integer): Integer;
var C, D : Integer;
    I    : Integer;
begin
  for I := 1 to Len do
    begin
      C := Ord(A[I]);
      D := Ord(B[I]);
      if C <> D then
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

function StrPCompareNoAsciiCaseA(const A, B: AnsiString; const Len: Integer): Integer;
var C, D : Integer;
    I    : Integer;
begin
  for I := 1 to Len do
    begin
      C := Ord(AsciiLowCaseLookup[A[I]]);
      D := Ord(AsciiLowCaseLookup[B[I]]);
      if C <> D then
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
{$ELSE}
function StrPCompareA(const A, B: PAnsiChar; const Len: Integer): Integer;
var P, Q : PAnsiChar;
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

function StrPCompareNoAsciiCaseA(const A, B: PAnsiChar; const Len: Integer): Integer;
var P, Q : PByte;
    C, D : Byte;
    I    : Integer;
begin
  P := Pointer(A);
  Q := Pointer(B);
  if P <> Q then
    for I := 1 to Len do
      begin
        C := AsciiLowCaseLookup[P^];
        D := AsciiLowCaseLookup[Q^];
        if C = D then
          begin
            Inc(P);
            Inc(Q);
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

function StrPCompareNoAsciiCaseW(const A, B: PWideChar; const Len: Integer): Integer;
var P, Q : PWideChar;
    C, D : Word;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      begin
        C := Ord(P^);
        D := Ord(Q^);
        if C <= $7F then
          C := AsciiLowCaseLookup[Byte(C)];
        if D <= $7F then
          D := AsciiLowCaseLookup[Byte(D)];
        if C = D then
          begin
            Inc(P);
            Inc(Q);
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

function StrPCompareNoAsciiCase(const A, B: PChar; const Len: Integer): Integer;
var P, Q : PChar;
    C, D : Integer;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      begin
        C := Ord(P^);
        D := Ord(Q^);
        if C <= $7F then
          C := Integer(AsciiLowCaseLookup[Byte(C)]);
        if D <= $7F then
          D := Integer(AsciiLowCaseLookup[Byte(D)]);
        if C = D then
          begin
            Inc(P);
            Inc(Q);
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
{$ENDIF}

{$IFDEF CLR}
function StrCompare(const A, B: AnsiString): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareA(A, B, I);
  if Result <> 0 then
    exit;
  if L = M then
    Result := 0 else
  if L < M then
    Result := -1
  else
    Result := 1;
end;

function StrCompareNoCase(const A, B: AnsiString): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareNoAsciiCaseA(A, B, I);
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

{$IFNDEF CLR}
function StrCompareA(const A, B: AnsiString): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareA(Pointer(A), Pointer(B), I);
  if Result <> 0 then
    exit;
  if L = M then
    Result := 0 else
  if L < M then
    Result := -1
  else
    Result := 1;
end;

function StrCompareB(const A, B: RawByteString): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareA(Pointer(A), Pointer(B), I);
  if Result <> 0 then
    exit;
  if L = M then
    Result := 0 else
  if L < M then
    Result := -1
  else
    Result := 1;
end;

function StrCompareW(const A, B: WideString): Integer;
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

function StrCompareNoAsciiCaseA(const A, B: AnsiString): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareNoAsciiCaseA(Pointer(A), Pointer(B), I);
  if Result <> 0 then
    exit;
  if L = M then
    Result := 0 else
  if L < M then
    Result := -1
  else
    Result := 1;
end;

function StrCompareNoAsciiCaseB(const A, B: RawByteString): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareNoAsciiCaseA(Pointer(A), Pointer(B), I);
  if Result <> 0 then
    exit;
  if L = M then
    Result := 0 else
  if L < M then
    Result := -1
  else
    Result := 1;
end;

function StrCompareNoAsciiCaseW(const A, B: WideString): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareNoAsciiCaseW(Pointer(A), Pointer(B), I);
  if Result <> 0 then
    exit;
  if L = M then
    Result := 0 else
  if L < M then
    Result := -1
  else
    Result := 1;
end;

function StrCompareNoAsciiCaseU(const A, B: UnicodeString): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareNoAsciiCaseW(Pointer(A), Pointer(B), I);
  if Result <> 0 then
    exit;
  if L = M then
    Result := 0 else
  if L < M then
    Result := -1
  else
    Result := 1;
end;

function StrCompareNoAsciiCase(const A, B: String): Integer;
var L, M, I: Integer;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareNoAsciiCase(Pointer(A), Pointer(B), I);
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
procedure Swap(var X, Y: LongInt); register; assembler;
asm
      MOV     ECX, [EDX]
      XCHG    [EAX], ECX
      MOV     [EDX], ECX
end;
{$ELSE}
procedure Swap(var X, Y: LongInt);
var F : LongInt;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure Swap(var X, Y: LongWord); register; assembler;
asm
      MOV     ECX, [EDX]
      XCHG    [EAX], ECX
      MOV     [EDX], ECX
end;
{$ELSE}
procedure Swap(var X, Y: LongWord);
var F : LongWord;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

{$IFNDEF ManagedCode}
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

procedure Swap(var X, Y: Extended);
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

procedure SwapA(var X, Y: AnsiString);
var F : AnsiString;
begin
  F := X;
  X := Y;
  Y := F;
end;

procedure SwapB(var X, Y: RawByteString);
var F : RawByteString;
begin
  F := X;
  X := Y;
  Y := F;
end;

procedure SwapW(var X, Y: WideString);
var F : WideString;
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

{$IFDEF ManagedCode}
procedure SwapObjects(var X, Y: TObject);
var F: TObject;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ELSE}
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
{$ENDIF}{$ENDIF}



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

function iifA(const Expr: Boolean; const TrueValue, FalseValue: AnsiString): AnsiString;
begin
  if Expr then
    Result := TrueValue
  else
    Result := FalseValue;
end;

function iifB(const Expr: Boolean; const TrueValue, FalseValue: RawByteString): RawByteString;
begin
  if Expr then
    Result := TrueValue
  else
    Result := FalseValue;
end;

function iifW(const Expr: Boolean; const TrueValue, FalseValue: WideString): WideString;
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

function CompareA(const I1, I2: AnsiString): TCompareResult;
begin
  case StrCompareA(I1, I2) of
    -1 : Result := crLess;
     1 : Result := crGreater;
  else
    Result := crEqual;
  end;
end;

function CompareB(const I1, I2: RawByteString): TCompareResult;
begin
  case StrCompareB(I1, I2) of
    -1 : Result := crLess;
     1 : Result := crGreater;
  else
    Result := crEqual;
  end;
end;

function CompareW(const I1, I2: WideString): TCompareResult;
begin
  case StrCompareW(I1, I2) of
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

function CompareChA(const I1, I2: AnsiChar): TCompareResult;
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

function Sgn(const A: LongInt): Integer;
begin
  if A < 0 then
    Result := -1 else
  if A > 0 then
    Result := 1
  else
    Result := 0;
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
  HexLookup: array[AnsiChar] of Byte = (
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
function AnsiCharToInt(const A: AnsiChar): Integer;
begin
  if A in [AnsiChar(Ord('0'))..AnsiChar(Ord('9'))] then
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
  Result := AnsiCharToInt(A);
  {$ENDIF}
end;

function IntToAnsiChar(const A: Integer): AnsiChar;
begin
  if (A < 0) or (A > 9) then
    Result := AnsiChar($00)
  else
    Result := AnsiChar(48 + A);
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
  Result := IntToAnsiChar(A);
  {$ENDIF}
end;

function IsHexAnsiChar(const Ch: AnsiChar): Boolean;
begin
  Result := HexLookup[Ch] <= 15;
end;

function IsHexWideChar(const Ch: WideChar): Boolean;
begin
  if Ord(Ch) <= $FF then
    Result := HexLookup[AnsiChar(Ch)] <= 15
  else
    Result := False;
end;

function IsHexChar(const Ch: Char): Boolean;
begin
  {$IFDEF CharIsWide}
  Result := IsHexWideChar(Ch);
  {$ELSE}
  Result := IsHexAnsiChar(Ch);
  {$ENDIF}
end;

function HexAnsiCharToInt(const A: AnsiChar): Integer;
var B : Byte;
begin
  B := HexLookup[A];
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
      B := HexLookup[AnsiChar(Ord(A))];
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
  Result := HexAnsiCharToInt(A);
  {$ENDIF}
end;

function IntToUpperHexAnsiChar(const A: Integer): AnsiChar;
begin
  if (A < 0) or (A > 15) then
    Result := AnsiChar($00)
  else
  if A <= 9 then
    Result := AnsiChar(48 + A)
  else
    Result := AnsiChar(55 + A);
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
  Result := IntToUpperHexAnsiChar(A);
  {$ENDIF}
end;

function IntToLowerHexAnsiChar(const A: Integer): AnsiChar;
begin
  if (A < 0) or (A > 15) then
    Result := AnsiChar($00)
  else
  if A <= 9 then
    Result := AnsiChar(48 + A)
  else
    Result := AnsiChar(87 + A);
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
  Result := IntToLowerHexAnsiChar(A);
  {$ENDIF}
end;

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
      Result[StrBaseA] := AnsiChar(Ord('-'));
      T := -T;
    end;
  while T > 0 do
    begin
      Result[StrBaseA + L - I - 1] := IntToAnsiChar(T mod 10);
      T := T div 10;
      Inc(I);
    end;
end;

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
      Result[StrBaseB] := AnsiChar('-');
      T := -T;
    end;
  while T > 0 do
    begin
      Result[StrBaseB + L - I - 1] := IntToAnsiChar(T mod 10);
      T := T div 10;
      Inc(I);
    end;
end;

function IntToStringW(const A: Int64): WideString;
var T : Int64;
    L, I : Integer;
begin
  // special cases
  if A = 0 then
    begin
      Result := ToWideString('0');
      exit;
    end;
  if A = MinInt64 then
    begin
      Result := ToWideString('-9223372036854775808');
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
      Result[StrBaseW] := '-';
      T := -T;
    end;
  while T > 0 do
    begin
      Result[StrBaseW + L - I - 1] := IntToWideChar(T mod 10);
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
        Result[StrBaseA + V] := AnsiChar(Ord('0'));
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
        Result[StrBaseA + L - 1] := AnsiChar(StrHexDigitsUpper[V])
      else
        Result[StrBaseA + L - 1] := AnsiChar(StrHexDigitsLower[V]);
      Dec(L);
      D := D div Base;
    end;
  while L > 0 do
    begin
      Result[L] := AnsiChar(Ord('0'));
      Dec(L);
    end;
end;

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
        Result[StrBaseB + V] := AnsiChar(Ord('0'));
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
        Result[StrBaseB + L - 1] := AnsiChar(StrHexDigitsUpper[V])
      else
        Result[StrBaseB + L - 1] := AnsiChar(StrHexDigitsLower[V]);
      Dec(L);
      D := D div Base;
    end;
  while L > 0 do
    begin
      Result[StrBaseB + L - 1] := AnsiChar(Ord('0'));
      Dec(L);
    end;
end;

function NativeUIntToBaseW(
         const Value: NativeUInt;
         const Digits: Integer;
         const Base: Byte;
         const UpperCase: Boolean = True): WideString;
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

function UIntToStringA(const A: NativeUInt): AnsiString;
begin
  Result := NativeUIntToBaseA(A, 0, 10);
end;

function UIntToStringB(const A: NativeUInt): RawByteString;
begin
  Result := NativeUIntToBaseB(A, 0, 10);
end;

function UIntToStringW(const A: NativeUInt): WideString;
begin
  Result := NativeUIntToBaseW(A, 0, 10);
end;

function UIntToStringU(const A: NativeUInt): UnicodeString;
begin
  Result := NativeUIntToBaseU(A, 0, 10);
end;

function UIntToString(const A: NativeUInt): String;
begin
  Result := NativeUIntToBase(A, 0, 10);
end;

function LongWordToStrA(const A: LongWord; const Digits: Integer): AnsiString;
begin
  Result := NativeUIntToBaseA(A, Digits, 10);
end;

function LongWordToStrB(const A: LongWord; const Digits: Integer): RawByteString;
begin
  Result := NativeUIntToBaseB(A, Digits, 10);
end;

function LongWordToStrW(const A: LongWord; const Digits: Integer): WideString;
begin
  Result := NativeUIntToBaseW(A, Digits, 10);
end;

function LongWordToStrU(const A: LongWord; const Digits: Integer): UnicodeString;
begin
  Result := NativeUIntToBaseU(A, Digits, 10);
end;

function LongWordToStr(const A: LongWord; const Digits: Integer): String;
begin
  Result := NativeUIntToBase(A, Digits, 10);
end;

function LongWordToHexA(const A: LongWord; const Digits: Integer; const UpperCase: Boolean): AnsiString;
begin
  Result := NativeUIntToBaseA(A, Digits, 16, UpperCase);
end;

function LongWordToHexB(const A: LongWord; const Digits: Integer; const UpperCase: Boolean): RawByteString;
begin
  Result := NativeUIntToBaseB(A, Digits, 16, UpperCase);
end;

function LongWordToHexW(const A: LongWord; const Digits: Integer; const UpperCase: Boolean): WideString;
begin
  Result := NativeUIntToBaseW(A, Digits, 16, UpperCase);
end;

function LongWordToHexU(const A: LongWord; const Digits: Integer; const UpperCase: Boolean): UnicodeString;
begin
  Result := NativeUIntToBaseU(A, Digits, 16, UpperCase);
end;

function LongWordToHex(const A: LongWord; const Digits: Integer; const UpperCase: Boolean): String;
begin
  Result := NativeUIntToBase(A, Digits, 16, UpperCase);
end;

function LongWordToOctA(const A: LongWord; const Digits: Integer): AnsiString;
begin
  Result := NativeUIntToBaseA(A, Digits, 8);
end;

function LongWordToOctB(const A: LongWord; const Digits: Integer): RawByteString;
begin
  Result := NativeUIntToBaseB(A, Digits, 8);
end;

function LongWordToOctW(const A: LongWord; const Digits: Integer): WideString;
begin
  Result := NativeUIntToBaseW(A, Digits, 8);
end;

function LongWordToOctU(const A: LongWord; const Digits: Integer): UnicodeString;
begin
  Result := NativeUIntToBaseU(A, Digits, 8);
end;

function LongWordToOct(const A: LongWord; const Digits: Integer): String;
begin
  Result := NativeUIntToBase(A, Digits, 8);
end;

function LongWordToBinA(const A: LongWord; const Digits: Integer): AnsiString;
begin
  Result := NativeUIntToBaseA(A, Digits, 2);
end;

function LongWordToBinB(const A: LongWord; const Digits: Integer): RawByteString;
begin
  Result := NativeUIntToBaseB(A, Digits, 2);
end;

function LongWordToBinW(const A: LongWord; const Digits: Integer): WideString;
begin
  Result := NativeUIntToBaseW(A, Digits, 2);
end;

function LongWordToBinU(const A: LongWord; const Digits: Integer): UnicodeString;
begin
  Result := NativeUIntToBaseU(A, Digits, 2);
end;

function LongWordToBin(const A: LongWord; const Digits: Integer): String;
begin
  Result := NativeUIntToBase(A, Digits, 2);
end;

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF} // Delphi 7 incorrectly overflowing for -922337203685477580 * 10
function TryStringToInt64PA(const BufP: Pointer; const BufLen: Integer; out Value: Int64; out StrLen: Integer): TConvertResult;
var Len : Integer;
    DigVal : Integer;
    P : PAnsiChar;
    Ch : AnsiChar;
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
  if Ch in [AnsiChar(Ord('+')), AnsiChar(Ord('-'))] then
    begin
      Inc(Len);
      Inc(P);
      Neg := Ch = AnsiChar(Ord('-'));
    end
  else
    Neg := False;
  // skip leading zeros
  HasDig := False;
  while (Len < BufLen) and (P^ = AnsiChar(Ord('0'))) do
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
      if Ch in [AnsiChar(Ord('0'))..AnsiChar(Ord('9'))] then
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
          DigVal := AnsiCharToInt(Ch);
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

function TryStringToInt64A(const S: AnsiString; out A: Int64): Boolean;
var L, N : Integer;
begin
  L := Length(S);
  Result := TryStringToInt64PA(PAnsiChar(S), L, A, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;

function TryStringToInt64B(const S: RawByteString; out A: Int64): Boolean;
var L, N : Integer;
begin
  L := Length(S);
  Result := TryStringToInt64PA(PAnsiChar(S), L, A, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;

function TryStringToInt64W(const S: WideString; out A: Int64): Boolean;
var L, N : Integer;
begin
  L := Length(S);
  Result := TryStringToInt64PW(PWideChar(S), L, A, N) = convertOK;
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

function StringToInt64DefA(const S: AnsiString; const Default: Int64): Int64;
begin
  if not TryStringToInt64A(S, Result) then
    Result := Default;
end;

function StringToInt64DefB(const S: RawByteString; const Default: Int64): Int64;
begin
  if not TryStringToInt64B(S, Result) then
    Result := Default;
end;

function StringToInt64DefW(const S: WideString; const Default: Int64): Int64;
begin
  if not TryStringToInt64W(S, Result) then
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

function StringToInt64A(const S: AnsiString): Int64;
begin
  if not TryStringToInt64A(S, Result) then
    RaiseRangeCheckError;
end;

function StringToInt64B(const S: RawByteString): Int64;
begin
  if not TryStringToInt64B(S, Result) then
    RaiseRangeCheckError;
end;

function StringToInt64W(const S: WideString): Int64;
begin
  if not TryStringToInt64W(S, Result) then
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

function TryStringToIntW(const S: WideString; out A: Integer): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64W(S, B);
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

function StringToIntDefA(const S: AnsiString; const Default: Integer): Integer;
begin
  if not TryStringToIntA(S, Result) then
    Result := Default;
end;

function StringToIntDefB(const S: RawByteString; const Default: Integer): Integer;
begin
  if not TryStringToIntB(S, Result) then
    Result := Default;
end;

function StringToIntDefW(const S: WideString; const Default: Integer): Integer;
begin
  if not TryStringToIntW(S, Result) then
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

function StringToIntA(const S: AnsiString): Integer;
begin
  if not TryStringToIntA(S, Result) then
    RaiseRangeCheckError;
end;

function StringToIntB(const S: RawByteString): Integer;
begin
  if not TryStringToIntB(S, Result) then
    RaiseRangeCheckError;
end;

function StringToIntW(const S: WideString): Integer;
begin
  if not TryStringToIntW(S, Result) then
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

function TryStringToLongWordA(const S: AnsiString; out A: LongWord): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64A(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinLongWord) or (B > MaxLongWord) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := LongWord(B);
  Result := True;
end;

function TryStringToLongWordB(const S: RawByteString; out A: LongWord): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64B(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinLongWord) or (B > MaxLongWord) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := LongWord(B);
  Result := True;
end;

function TryStringToLongWordW(const S: WideString; out A: LongWord): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64W(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinLongWord) or (B > MaxLongWord) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := LongWord(B);
  Result := True;
end;

function TryStringToLongWordU(const S: UnicodeString; out A: LongWord): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64U(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinLongWord) or (B > MaxLongWord) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := LongWord(B);
  Result := True;
end;

function TryStringToLongWord(const S: String; out A: LongWord): Boolean;
var B : Int64;
begin
  Result := TryStringToInt64(S, B);
  if not Result then
    begin
      A := 0;
      exit;
    end;
  if (B < MinLongWord) or (B > MaxLongWord) then
    begin
      A := 0;
      Result := False;
      exit;
    end;
  A := LongWord(B);
  Result := True;
end;

function StringToLongWordA(const S: AnsiString): LongWord;
begin
  if not TryStringToLongWordA(S, Result) then
    RaiseRangeCheckError;
end;

function StringToLongWordB(const S: RawByteString): LongWord;
begin
  if not TryStringToLongWordB(S, Result) then
    RaiseRangeCheckError;
end;

function StringToLongWordW(const S: WideString): LongWord;
begin
  if not TryStringToLongWordW(S, Result) then
    RaiseRangeCheckError;
end;

function StringToLongWordU(const S: UnicodeString): LongWord;
begin
  if not TryStringToLongWordU(S, Result) then
    RaiseRangeCheckError;
end;

function StringToLongWord(const S: String): LongWord;
begin
  if not TryStringToLongWord(S, Result) then
    RaiseRangeCheckError;
end;

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
    C := HexLookup[S[L]];
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
    C := HexLookup[S[L]];
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

function BaseStrToNativeUIntW(const S: WideString; const BaseLog2: Byte;
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
      C := HexLookup[AnsiChar(Ord(D))];
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
      C := HexLookup[AnsiChar(Ord(D))];
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
      C := HexLookup[AnsiChar(Ord(D))];
    {$ELSE}
    C := HexLookup[D];
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

function HexToUIntA(const S: AnsiString): NativeUInt;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntA(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

function HexToUIntB(const S: RawByteString): NativeUInt;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntB(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

function HexToUIntW(const S: WideString): NativeUInt;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntW(S, 4, R);
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

function TryHexToLongWordA(const S: AnsiString; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUIntA(S, 4, Result);
end;

function TryHexToLongWordB(const S: RawByteString; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUIntB(S, 4, Result);
end;

function TryHexToLongWordW(const S: WideString; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUIntW(S, 4, Result);
end;

function TryHexToLongWordU(const S: UnicodeString; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUIntU(S, 4, Result);
end;

function TryHexToLongWord(const S: String; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUInt(S, 4, Result);
end;

function HexToLongWordA(const S: AnsiString): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntA(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

function HexToLongWordB(const S: RawByteString): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntB(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

function HexToLongWordW(const S: WideString): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntW(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

function HexToLongWordU(const S: UnicodeString): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntU(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

function HexToLongWord(const S: String): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUInt(S, 4, R);
  if not R then
    RaiseRangeCheckError;
end;

function TryOctToLongWordA(const S: AnsiString; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUIntA(S, 3, Result);
end;

function TryOctToLongWordB(const S: RawByteString; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUIntB(S, 3, Result);
end;

function TryOctToLongWordW(const S: WideString; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUIntW(S, 3, Result);
end;

function TryOctToLongWordU(const S: UnicodeString; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUIntU(S, 3, Result);
end;

function TryOctToLongWord(const S: String; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUInt(S, 3, Result);
end;

function OctToLongWordA(const S: AnsiString): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntA(S, 3, R);
  if not R then
    RaiseRangeCheckError;
end;

function OctToLongWordB(const S: RawByteString): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntB(S, 3, R);
  if not R then
    RaiseRangeCheckError;
end;

function OctToLongWordW(const S: WideString): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntW(S, 3, R);
  if not R then
    RaiseRangeCheckError;
end;

function OctToLongWordU(const S: UnicodeString): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntU(S, 3, R);
  if not R then
    RaiseRangeCheckError;
end;

function OctToLongWord(const S: String): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntW(ToWideString(S), 3, R);
  if not R then
    RaiseRangeCheckError;
end;

function TryBinToLongWordA(const S: AnsiString; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUIntA(S, 1, Result);
end;

function TryBinToLongWordB(const S: RawByteString; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUIntB(S, 1, Result);
end;

function TryBinToLongWordW(const S: WideString; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUIntW(S, 1, Result);
end;

function TryBinToLongWordU(const S: UnicodeString; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUIntU(S, 1, Result);
end;

function TryBinToLongWord(const S: String; out A: LongWord): Boolean;
begin
  A := BaseStrToNativeUInt(S, 1, Result);
end;

function BinToLongWordA(const S: AnsiString): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntA(S, 1, R);
  if not R then
    RaiseRangeCheckError;
end;

function BinToLongWordB(const S: RawByteString): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntB(S, 1, R);
  if not R then
    RaiseRangeCheckError;
end;

function BinToLongWordW(const S: WideString): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntW(S, 1, R);
  if not R then
    RaiseRangeCheckError;
end;

function BinToLongWordU(const S: UnicodeString): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUIntU(S, 1, R);
  if not R then
    RaiseRangeCheckError;
end;

function BinToLongWord(const S: String): LongWord;
var R : Boolean;
begin
  Result := BaseStrToNativeUInt(S, 1, R);
  if not R then
    RaiseRangeCheckError;
end;



{                                                                              }
{ Float-String conversions                                                     }
{                                                                              }
function FloatToStringS(const A: Extended): String;
var B : Extended;
    {$IFNDEF SupportShortString}
    S : String;
    {$ELSE}
    S : ShortString;
    {$ENDIF}
    L, I : Integer;
    E : Integer;
begin
  // handle special floating point values
  {$IFNDEF ExtendedIsDouble}
  if ExtendedIsInfinity(A) or ExtendedIsNaN(A) then
    begin
      Result := '';
      exit;
    end;
  {$ENDIF}
  B := Abs(A);
  // very small numbers (Double precision) are zero
  if B < 1e-300 then
    begin
      Result := '0';
      exit;
    end;
  // up to 15 digits (around Double precsion) before or after decimal use non-scientific notation
  if (B < 1e-15) or (B >= 1e+15) then
    Str(A, S)
  else
    Str(A:0:15, S);
  // trim preceding spaces
  I := 1;
  while S[I] = ' ' do
    Inc(I);
  if I > 1 then
    S := Copy(S, I, Length(S) - I + 1);
  // find exponent
  L := Length(S);
  E := 0;
  for I := 1 to L do
    if S[I] = 'E' then
      begin
        E := I;
        break;
      end;
  if E = 0 then
    begin
      // trim trailing zeros
      I := L;
      while S[I] = '0' do
        Dec(I);
      if S[I] = '.' then
        Dec(I);
      if I < L then
        SetLength(S, I);
    end
  else
    begin
      // trim trailing zeros in mantissa
      I := E - 1;
      while S[I] = '0' do
        Dec(I);
      if S[I] = '.' then
        Dec(I);
      if I < E - 1 then
        S := Copy(S, 1, I) + Copy(S, E, L - E + 1);
    end;
  // return formatted float string
  {$IFDEF SupportShortString}
  Result := String(S);
  {$ELSE}
  Result := S;
  {$ENDIF}
end;

function FloatToStringA(const A: Extended): AnsiString;
begin
  Result := AnsiString(FloatToStringS(A));
end;

function FloatToStringB(const A: Extended): RawByteString;
begin
  Result := RawByteString(FloatToStringS(A));
end;

function FloatToStringW(const A: Extended): WideString;
begin
  Result := WideString(FloatToStringS(A));
end;

function FloatToStringU(const A: Extended): UnicodeString;
begin
  Result := UnicodeString(FloatToStringS(A));
end;

function FloatToString(const A: Extended): String;
begin
  Result := String(FloatToStringS(A));
end;

function TryStringToFloatPA(const BufP: Pointer; const BufLen: Integer; out Value: Extended; out StrLen: Integer): TConvertResult;
var Len : Integer;
    DigVal : Integer;
    DigValF : Extended;
    P : PAnsiChar;
    Ch : AnsiChar;
    HasDig : Boolean;
    Neg : Boolean;
    Res : Extended;
    Ex : Extended;
    ExI : Int64;
    L : Integer;
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
  if (Ch = AnsiChar(Ord('+'))) or (Ch = AnsiChar(Ord('-'))) then
    begin
      Inc(Len);
      Inc(P);
      Neg := Ch = AnsiChar(Ord('-'));
    end
  else
    Neg := False;
  // skip leading zeros
  HasDig := False;
  while (Len < BufLen) and (P^ = AnsiChar(Ord('0'))) do
    begin
      Inc(Len);
      Inc(P);
      HasDig := True;
    end;
  // convert integer digits
  Res := 0.0;
  while Len < BufLen do
    begin
      Ch := P^;
      if (Ch >= AnsiChar(Ord('0'))) and (Ch <= AnsiChar(Ord('9'))) then
        begin
          HasDig := True;
          // maximum Extended is roughly 1.1e4932, maximum Double is roughly 1.7e308
          if Abs(Res) >= 1.0e+290 then
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          Res := Res * 10.0;
          DigVal := AnsiCharToInt(Ch);
          if Neg then
            Res := Res - DigVal
          else
            Res := Res + DigVal;
          Inc(Len);
          Inc(P);
        end
      else
        break;
    end;
  // convert decimal digits
  if (Len < BufLen) and (P^ = AnsiChar(Ord('.'))) then
    begin
      Inc(Len);
      Inc(P);
      ExI := 0;
      while Len < BufLen do
        begin
          Ch := P^;
          if (Ch >= AnsiChar(Ord('0'))) and (Ch <= AnsiChar(Ord('9'))) then
            begin
              HasDig := True;
              // minimum Extended is roughly 3.6e-4951, minimum Double is roughly 5e-324
              if ExI >= 1000 then
                begin
                  Value := 0;
                  StrLen := Len;
                  Result := convertOverflow;
                  exit;
                end;
              DigVal := AnsiCharToInt(Ch);
              Inc(ExI);
              DigValF := DigVal;
              DigValF := DigValF / Power(10.0, ExI);
              if Neg then
                Res := Res - DigValF
              else
                Res := Res + DigValF;
              Inc(Len);
              Inc(P);
            end
          else
            break;
        end;
    end;
  // check valid digit
  if not HasDig then
    begin
      Value := 0;
      StrLen := Len;
      Result := convertFormatError;
      exit;
    end;
  // convert exponent
  if Len < BufLen then
    begin
      Ch := P^;
      if (Ch = AnsiChar(Ord('e'))) or (Ch = AnsiChar(Ord('E'))) then
        begin
          Inc(Len);
          Inc(P);
          Result := TryStringToInt64PA(P, BufLen - Len, ExI, L);
          Inc(Len, L);
          if Result <> convertOK then
            begin
              Value := 0;
              StrLen := Len;
              exit;
            end;
          if ExI <> 0 then
            begin
              if (ExI > 1000) or (ExI < -1000) then
                begin
                  Value := 0;
                  StrLen := Len;
                  Result := convertOverflow;
                  exit;
                end;
              Ex := ExI;
              Ex := Power(10.0, Ex);
              Res := Res * Ex;
            end;
        end;
    end;
  // success
  Value := Res;
  StrLen := Len;
  Result := convertOK;
end;

function TryStringToFloatPW(const BufP: Pointer; const BufLen: Integer; out Value: Extended; out StrLen: Integer): TConvertResult;
var Len : Integer;
    DigVal : Integer;
    DigValF : Extended;
    P : PWideChar;
    Ch : WideChar;
    HasDig : Boolean;
    Neg : Boolean;
    Res : Extended;
    Ex : Extended;
    ExI : Int64;
    L : Integer;
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
  // convert integer digits
  Res := 0.0;
  while Len < BufLen do
    begin
      Ch := P^;
      if (Ch >= '0') and (Ch <= '9') then
        begin
          HasDig := True;
          // maximum Extended is roughly 1.1e4932, maximum Double is roughly 1.7e308
          if Abs(Res) >= 1.0e+1000 then
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          Res := Res * 10.0;
          DigVal := WideCharToInt(Ch);
          if Neg then
            Res := Res - DigVal
          else
            Res := Res + DigVal;
          Inc(Len);
          Inc(P);
        end
      else
        break;
    end;
  // convert decimal digits
  if (Len < BufLen) and (P^ = '.') then
    begin
      Inc(Len);
      Inc(P);
      ExI := 0;
      while Len < BufLen do
        begin
          Ch := P^;
          if (Ch >= '0') and (Ch <= '9') then
            begin
              HasDig := True;
              // minimum Extended is roughly 3.6e-4951, minimum Double is roughly 5e-324
              if ExI >= 1000 then
                begin
                  Value := 0;
                  StrLen := Len;
                  Result := convertOverflow;
                  exit;
                end;
              DigVal := WideCharToInt(Ch);
              Inc(ExI);
              DigValF := DigVal;
              DigValF := DigValF / Power(10.0, ExI);
              if Neg then
                Res := Res - DigValF
              else
                Res := Res + DigValF;
              Inc(Len);
              Inc(P);
            end
          else
            break;
        end;
    end;
  // check valid digit
  if not HasDig then
    begin
      Value := 0;
      StrLen := Len;
      Result := convertFormatError;
      exit;
    end;
  // convert exponent
  if Len < BufLen then
    begin
      Ch := P^;
      if (Ch = 'e') or (Ch = 'E') then
        begin
          Inc(Len);
          Inc(P);
          Result := TryStringToInt64PW(P, BufLen - Len, ExI, L);
          Inc(Len, L);
          if Result <> convertOK then
            begin
              Value := 0;
              StrLen := Len;
              exit;
            end;
          if ExI <> 0 then
            begin
              if (ExI > 1000) or (ExI < -1000) then
                begin
                  Value := 0;
                  StrLen := Len;
                  Result := convertOverflow;
                  exit;
                end;
              Ex := ExI;
              Ex := Power(10.0, Ex);
              Res := Res * Ex;
            end;
        end;
    end;
  // success
  Value := Res;
  StrLen := Len;
  Result := convertOK;
end;

function TryStringToFloatP(const BufP: Pointer; const BufLen: Integer; out Value: Extended; out StrLen: Integer): TConvertResult;
var Len : Integer;
    DigVal : Integer;
    DigValF : Extended;
    P : PChar;
    Ch : Char;
    HasDig : Boolean;
    Neg : Boolean;
    Res : Extended;
    Ex : Extended;
    ExI : Int64;
    L : Integer;
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
  // convert integer digits
  Res := 0.0;
  while Len < BufLen do
    begin
      Ch := P^;
      if (Ch >= '0') and (Ch <= '9') then
        begin
          HasDig := True;
          // maximum Extended is roughly 1.1e4932, maximum Double is roughly 1.7e308
          if Abs(Res) >= 1.0e+1000 then
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          Res := Res * 10.0;
          DigVal := CharToInt(Ch);
          if Neg then
            Res := Res - DigVal
          else
            Res := Res + DigVal;
          Inc(Len);
          Inc(P);
        end
      else
        break;
    end;
  // convert decimal digits
  if (Len < BufLen) and (P^ = '.') then
    begin
      Inc(Len);
      Inc(P);
      ExI := 0;
      while Len < BufLen do
        begin
          Ch := P^;
          if (Ch >= '0') and (Ch <= '9') then
            begin
              HasDig := True;
              // minimum Extended is roughly 3.6e-4951, minimum Double is roughly 5e-324
              if ExI >= 1000 then
                begin
                  Value := 0;
                  StrLen := Len;
                  Result := convertOverflow;
                  exit;
                end;
              DigVal := CharToInt(Ch);
              Inc(ExI);
              DigValF := DigVal;
              DigValF := DigValF / Power(10.0, ExI);
              if Neg then
                Res := Res - DigValF
              else
                Res := Res + DigValF;
              Inc(Len);
              Inc(P);
            end
          else
            break;
        end;
    end;
  // check valid digit
  if not HasDig then
    begin
      Value := 0;
      StrLen := Len;
      Result := convertFormatError;
      exit;
    end;
  // convert exponent
  if Len < BufLen then
    begin
      Ch := P^;
      if (Ch = 'e') or (Ch = 'E') then
        begin
          Inc(Len);
          Inc(P);
          Result := TryStringToInt64P(P, BufLen - Len, ExI, L);
          Inc(Len, L);
          if Result <> convertOK then
            begin
              Value := 0;
              StrLen := Len;
              exit;
            end;
          if ExI <> 0 then
            begin
              if (ExI > 1000) or (ExI < -1000) then
                begin
                  Value := 0;
                  StrLen := Len;
                  Result := convertOverflow;
                  exit;
                end;
              Ex := ExI;
              Ex := Power(10.0, Ex);
              Res := Res * Ex;
            end;
        end;
    end;
  // success
  Value := Res;
  StrLen := Len;
  Result := convertOK;
end;

function TryStringToFloatA(const A: AnsiString; out B: Extended): Boolean;
var L, N : Integer;
begin
  L := Length(A);
  Result := TryStringToFloatPA(PAnsiChar(A), L, B, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;

function TryStringToFloatB(const A: RawByteString; out B: Extended): Boolean;
var L, N : Integer;
begin
  L := Length(A);
  Result := TryStringToFloatPA(PAnsiChar(A), L, B, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;

function TryStringToFloatW(const A: WideString; out B: Extended): Boolean;
var L, N : Integer;
begin
  L := Length(A);
  Result := TryStringToFloatPW(PWideChar(A), L, B, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;

function TryStringToFloatU(const A: UnicodeString; out B: Extended): Boolean;
var L, N : Integer;
begin
  L := Length(A);
  Result := TryStringToFloatPW(PWideChar(A), L, B, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;

function TryStringToFloat(const A: String; out B: Extended): Boolean;
var L, N : Integer;
begin
  L := Length(A);
  Result := TryStringToFloatP(PChar(A), L, B, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;

function StringToFloatA(const A: AnsiString): Extended;
begin
  if not TryStringToFloatA(A, Result) then
    RaiseRangeCheckError;
end;

function StringToFloatB(const A: RawByteString): Extended;
begin
  if not TryStringToFloatB(A, Result) then
    RaiseRangeCheckError;
end;

function StringToFloatW(const A: WideString): Extended;
begin
  if not TryStringToFloatW(A, Result) then
    RaiseRangeCheckError;
end;

function StringToFloatU(const A: UnicodeString): Extended;
begin
  if not TryStringToFloatU(A, Result) then
    RaiseRangeCheckError;
end;

function StringToFloat(const A: String): Extended;
begin
  if not TryStringToFloat(A, Result) then
    RaiseRangeCheckError;
end;

function StringToFloatDefA(const A: AnsiString; const Default: Extended): Extended;
begin
  if not TryStringToFloatA(A, Result) then
    Result := Default;
end;

function StringToFloatDefB(const A: RawByteString; const Default: Extended): Extended;
begin
  if not TryStringToFloatB(A, Result) then
    Result := Default;
end;

function StringToFloatDefW(const A: WideString; const Default: Extended): Extended;
begin
  if not TryStringToFloatW(A, Result) then
    Result := Default;
end;

function StringToFloatDefU(const A: UnicodeString; const Default: Extended): Extended;
begin
  if not TryStringToFloatU(A, Result) then
    Result := Default;
end;

function StringToFloatDef(const A: String; const Default: Extended): Extended;
begin
  if not TryStringToFloat(A, Result) then
    Result := Default;
end;




{$IFDEF ManagedCode}
function BytesToHex(const P: array of Byte; const UpperCase: Boolean): AnsiString;
var D : Integer;
    E : Integer;
    L : Integer;
    V : Byte;
    W : Byte;
begin
  L := Length(P);
  if L = 0 then
    begin
      Result := StrEmptyA;
      exit;
    end;
  SetLength(Result, L * 2);
  D := 1;
  E := 1;
  while L > 0 do
    begin
      W := P[E];
      V := W shr 4 + 1;
      Inc(E);
      if UpperCase then
        Result[D] := AnsiChar(StrHexDigitsUpper[V])
      else
        Result[D] := AnsiChar(StrHexDigitsLower[V]);
      Inc(D);
      V := W and $F + 1;
      if UpperCase then
        Result[D] := AnsiChar(StrHexDigitsUpper[V])
      else
        Result[D] := AnsiChar(StrHexDigitsLower[V]);
      Inc(D);
      Dec(L);
    end;
end;
{$ELSE}
function BytesToHex(const P: Pointer; const Count: Integer;
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
      Result := StrEmptyA;
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

function hton32(const A: LongWord): LongWord;
var BufH : array[0..3] of Byte;
    BufN : array[0..3] of Byte;
begin
  PLongWord(@BufH)^ := A;
  BufN[0] := BufH[3];
  BufN[1] := BufH[2];
  BufN[2] := BufH[1];
  BufN[3] := BufH[0];
  Result := PLongWord(@BufN)^;
end;

function ntoh32(const A: LongWord): LongWord;
var BufH : array[0..3] of Byte;
    BufN : array[0..3] of Byte;
begin
  PLongWord(@BufH)^ := A;
  BufN[0] := BufH[3];
  BufN[1] := BufH[2];
  BufN[2] := BufH[1];
  BufN[3] := BufH[0];
  Result := PLongWord(@BufN)^;
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



{$IFNDEF SupportWideString}
function WideStringToUnicodeString(const S: WideString): UnicodeString;
var L, I : Integer;
begin
  L := Length(S);
  SetLength(Result, L);
  for I := 1 to L do
    Result[I] := S[I - 1];
end;
{$ELSE}
function WideStringToUnicodeString(const S: WideString): UnicodeString;
begin
  Result := S;
end;
{$ENDIF}



{                                                                              }
{ Pointer-String conversions                                                   }
{                                                                              }
{$IFNDEF ManagedCode}
function PointerToStrA(const P: Pointer): AnsiString;
begin
  Result := NativeUIntToBaseA(NativeUInt(P), NativeWordSize * 2, 16, True);
end;

function PointerToStrB(const P: Pointer): RawByteString;
begin
  Result := NativeUIntToBaseB(NativeUInt(P), NativeWordSize * 2, 16, True);
end;

function PointerToStrW(const P: Pointer): WideString;
begin
  Result := NativeUIntToBaseW(NativeUInt(P), NativeWordSize * 2, 16, True);
end;

function PointerToStrU(const P: Pointer): UnicodeString;
begin
  Result := NativeUIntToBaseU(NativeUInt(P), NativeWordSize * 2, 16, True);
end;

function PointerToStr(const P: Pointer): String;
begin
  Result := NativeUIntToBase(NativeUInt(P), NativeWordSize * 2, 16, True);
end;

function StrToPointerA(const S: AnsiString): Pointer;
var V : Boolean;
begin
  Result := Pointer(BaseStrToNativeUIntA(S, 4, V));
end;

function StrToPointerB(const S: RawByteString): Pointer;
var V : Boolean;
begin
  Result := Pointer(BaseStrToNativeUIntB(S, 4, V));
end;

function StrToPointerW(const S: WideString): Pointer;
var V : Boolean;
begin
  Result := Pointer(BaseStrToNativeUIntW(S, 4, V));
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
function InterfaceToStrA(const I: IInterface): AnsiString;
begin
  Result := NativeUIntToBaseA(NativeUInt(I), NativeWordSize * 2, 16, True);
end;

function InterfaceToStrB(const I: IInterface): RawByteString;
begin
  Result := NativeUIntToBaseB(NativeUInt(I), NativeWordSize * 2, 16, True);
end;

function InterfaceToStrW(const I: IInterface): WideString;
begin
  Result := NativeUIntToBaseW(NativeUInt(I), NativeWordSize * 2, 16, True);
end;

function InterfaceToStrU(const I: IInterface): UnicodeString;
begin
  Result := WideStringToUnicodeString(NativeUIntToBaseW(NativeUInt(I), NativeWordSize * 2, 16, True));
end;

function InterfaceToStr(const I: IInterface): String;
begin
  Result := NativeUIntToBase(NativeUInt(I), NativeWordSize * 2, 16, True);
end;
{$ENDIF}
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
    Result := O.ClassName{$IFNDEF CLR} + '@' + PointerToStr(Pointer(O)){$ENDIF};
end;



{                                                                              }
{ Hash functions                                                               }
{   Derived from a CRC32 algorithm.                                            }
{                                                                              }
var
  HashTableInit : Boolean = False;
  HashTable     : array[Byte] of LongWord;
  HashPoly      : LongWord = $EDB88320;

procedure InitHashTable;
var I, J : Byte;
    R    : LongWord;
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

function HashByte(const Hash: LongWord; const C: Byte): LongWord; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := HashTable[Byte(Hash) xor C] xor (Hash shr 8);
end;

function HashCharA(const Hash: LongWord; const Ch: AnsiChar): LongWord; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := HashByte(Hash, Byte(Ch));
end;

function HashCharW(const Hash: LongWord; const Ch: WideChar): LongWord; {$IFDEF UseInline}inline;{$ENDIF}
var C1, C2 : Byte;
begin
  C1 := Byte(Ord(Ch) and $FF);
  C2 := Byte(Ord(Ch) shr 8);
  Result := Hash;
  Result := HashByte(Result, C1);
  Result := HashByte(Result, C2);
end;

function HashChar(const Hash: LongWord; const Ch: Char): LongWord; {$IFDEF UseInline}inline;{$ENDIF}
begin
  {$IFDEF CharIsWide}
  Result := HashCharW(Hash, Ch);
  {$ELSE}
  Result := HashCharA(Hash, Ch);
  {$ENDIF}
end;

function HashCharNoAsciiCaseA(const Hash: LongWord; const Ch: AnsiChar): LongWord; {$IFDEF UseInline}inline;{$ENDIF}
var C : Byte;
begin
  C := Byte(Ch);
  if C in [Ord('A')..Ord('Z')] then
    C := C or 32;
  Result := HashCharA(Hash, AnsiChar(C));
end;

function HashCharNoAsciiCaseW(const Hash: LongWord; const Ch: WideChar): LongWord; {$IFDEF UseInline}inline;{$ENDIF}
var C : Word;
begin
  C := Word(Ch);
  if C <= $FF then
    if Byte(C) in [Ord('A')..Ord('Z')] then
      C := C or 32;
  Result := HashCharW(Hash, WideChar(C));
end;

function HashCharNoAsciiCase(const Hash: LongWord; const Ch: Char): LongWord; {$IFDEF UseInline}inline;{$ENDIF}
begin
  {$IFDEF CharIsWide}
  Result := HashCharNoAsciiCaseW(Hash, Ch);
  {$ELSE}
  Result := HashCharNoAsciiCaseA(Hash, Ch);
  {$ENDIF}
end;

function HashBuf(const Hash: LongWord; const Buf; const BufSize: Integer): LongWord;
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

function HashStrA(const S: AnsiString;
         const Index: Integer; const Count: Integer;
         const AsciiCaseSensitive: Boolean;
         const Slots: LongWord): LongWord;
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
      Result := HashCharA(Result, S[I])
  else
    for I := A to B do
      Result := HashCharNoAsciiCaseA(Result, S[I]);
  if Slots > 0 then
    Result := Result mod Slots;
end;

function HashStrB(const S: RawByteString;
         const Index: Integer; const Count: Integer;
         const AsciiCaseSensitive: Boolean;
         const Slots: LongWord): LongWord;
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
      Result := HashCharA(Result, S[I])
  else
    for I := A to B do
      Result := HashCharNoAsciiCaseA(Result, S[I]);
  if Slots > 0 then
    Result := Result mod Slots;
end;

function HashStrW(const S: WideString;
         const Index: Integer; const Count: Integer;
         const AsciiCaseSensitive: Boolean;
         const Slots: LongWord): LongWord;
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

function HashStrU(const S: UnicodeString;
         const Index: Integer; const Count: Integer;
         const AsciiCaseSensitive: Boolean;
         const Slots: LongWord): LongWord;
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
         const Slots: LongWord): LongWord;
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
{$IFDEF ManagedCode}
function HashInteger(const I: Integer; const Slots: LongWord): LongWord;
begin
  if not HashTableInit then
    InitHashTable;
  Result := $FFFFFFFF;
  Result := HashTable[Byte(Result) xor  (I and $000000FF)]         xor (Result shr 8);
  Result := HashTable[Byte(Result) xor ((I and $0000FF00) shr 8)]  xor (Result shr 8);
  Result := HashTable[Byte(Result) xor ((I and $00FF0000) shr 16)] xor (Result shr 8);
  Result := HashTable[Byte(Result) xor ((I and $FF000000) shr 24)] xor (Result shr 8);
  if Slots <> 0 then
    Result := Result mod Slots;
end;
{$ELSE}
function HashInteger(const I: Integer; const Slots: LongWord): LongWord;
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
{$ENDIF}

{$IFDEF ManagedCode}
function HashLongWord(const I: LongWord; const Slots: LongWord): LongWord;
begin
  if not HashTableInit then
    InitHashTable;
  Result := $FFFFFFFF;
  Result := HashTable[Byte(Result) xor  (I and $000000FF)]         xor (Result shr 8);
  Result := HashTable[Byte(Result) xor ((I and $0000FF00) shr 8)]  xor (Result shr 8);
  Result := HashTable[Byte(Result) xor ((I and $00FF0000) shr 16)] xor (Result shr 8);
  Result := HashTable[Byte(Result) xor ((I and $FF000000) shr 24)] xor (Result shr 8);
  if Slots <> 0 then
    Result := Result mod Slots;
end;
{$ELSE}
function HashLongWord(const I: LongWord; const Slots: LongWord): LongWord;
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
{$ENDIF}



{$IFNDEF ManagedCode}
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
  D := LongWord(Count) div 4;
  for I := 1 to D do
    if PLongWord(P)^ = PLongWord(Q)^ then
      begin
        Inc(PLongWord(P));
        Inc(PLongWord(Q));
      end
    else
      begin
        Result := False;
        exit;
      end;
  D := LongWord(Count) and 3;
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
{$ENDIF}



{                                                                              }
{ FreeAndNil                                                                   }
{                                                                              }
{$IFDEF ManagedCode}
procedure FreeAndNil(var Obj: TObject);
var Temp : TObject;
begin
  Temp := Obj;
  Obj := nil;
  Temp.Free;
end;
{$ELSE}
procedure FreeAndNil(var Obj);
var Temp : TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;
{$ENDIF}

{$IFDEF ManagedCode}
procedure FreeObjectArray(var V: ObjectArray);
var I : Integer;
begin
  for I := Length(V) - 1 downto 0 do
    FreeAndNil(V[I]);
end;

procedure FreeObjectArray(var V: ObjectArray; const LoIdx, HiIdx: Integer);
var I : Integer;
begin
  for I := HiIdx downto LoIdx do
    FreeAndNil(V[I]);
end;
{$ELSE}
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
{$ENDIF}

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
    C, D : LongWord;
    P, Q : TObject;
    W    : WideChar;
begin
  // Integer types
  {$IFNDEF ManagedCode}
  Assert(Sizeof(SmallIntRec) = Sizeof(SmallInt), 'SmallIntRec');
  Assert(Sizeof(LongIntRec) = Sizeof(LongInt),   'LongIntRec');
  {$ENDIF}

  // Min / Max
  Assert(MinInt(-1, 1) = -1, 'MinI');
  Assert(MaxInt(-1, 1) = 1, 'MaxI');
  Assert(MinCrd(1, 2) = 1, 'MinC');
  Assert(MaxCrd(1, 2) = 2, 'MaxC');
  Assert(MaxCrd($FFFFFFFF, 0) = $FFFFFFFF, 'MaxC');
  Assert(MinCrd($FFFFFFFF, 0) = 0, 'MinC');
  Assert(FloatMin(-1.0, 1.0) = -1.0, 'FloatMin');
  Assert(FloatMax(-1.0, 1.0) = 1.0, 'FloatMax');

  // Bouded
  Assert(Int32Bounded(10, 5, 12) = 10,                            'Bounded');
  Assert(Int32Bounded(3, 5, 12) = 5,                              'Bounded');
  Assert(Int32Bounded(15, 5, 12) = 12,                            'Bounded');
  Assert(Int32BoundedByte(256) = 255,                             'BoundedByte');
  Assert(Int32BoundedWord(-5) = 0,                                'BoundedWord');
  Assert(Int64BoundedLongWord($100000000) = $FFFFFFFF,            'BoundedWord');

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
  Assert(iifW(True, ToWideString('1'), ToWideString('2')) = ToWideString('1'),  'iif');
  Assert(iifW(False, ToWideString('1'), ToWideString('2')) = ToWideString('2'), 'iif');
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

  Assert(CompareA(ToAnsiString(''), ToAnsiString('')) = crEqual,        'Compare');
  Assert(CompareA(ToAnsiString('a'), ToAnsiString('a')) = crEqual,      'Compare');
  Assert(CompareA(ToAnsiString('a'), ToAnsiString('b')) = crLess,       'Compare');
  Assert(CompareA(ToAnsiString('b'), ToAnsiString('a')) = crGreater,    'Compare');
  Assert(CompareA(ToAnsiString(''), ToAnsiString('a')) = crLess,        'Compare');
  Assert(CompareA(ToAnsiString('a'), ToAnsiString('')) = crGreater,     'Compare');
  Assert(CompareA(ToAnsiString('aa'), ToAnsiString('a')) = crGreater,   'Compare');

  Assert(CompareB(ToRawByteString(''), ToRawByteString('')) = crEqual,        'Compare');
  Assert(CompareB(ToRawByteString('a'), ToRawByteString('a')) = crEqual,      'Compare');
  Assert(CompareB(ToRawByteString('a'), ToRawByteString('b')) = crLess,       'Compare');
  Assert(CompareB(ToRawByteString('b'), ToRawByteString('a')) = crGreater,    'Compare');
  Assert(CompareB(ToRawByteString(''), ToRawByteString('a')) = crLess,        'Compare');
  Assert(CompareB(ToRawByteString('a'), ToRawByteString('')) = crGreater,     'Compare');
  Assert(CompareB(ToRawByteString('aa'), ToRawByteString('a')) = crGreater,   'Compare');

  Assert(CompareW(ToWideString(''), ToWideString('')) = crEqual,        'Compare');
  Assert(CompareW(ToWideString('a'), ToWideString('a')) = crEqual,      'Compare');
  Assert(CompareW(ToWideString('a'), ToWideString('b')) = crLess,       'Compare');
  Assert(CompareW(ToWideString('b'), ToWideString('a')) = crGreater,    'Compare');
  Assert(CompareW(ToWideString(''), ToWideString('a')) = crLess,        'Compare');
  Assert(CompareW(ToWideString('a'), ToWideString('')) = crGreater,     'Compare');
  Assert(CompareW(ToWideString('aa'), ToWideString('a')) = crGreater,   'Compare');

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

  // ASCII
  Assert(IsAsciiStringA(ToAnsiString('012XYZabc{}_ ')), 'IsUSASCIIString');
  Assert(not IsAsciiStringA(ToAnsiString(#$80)), 'IsUSASCIIString');
  Assert(IsAsciiStringA(ToAnsiString('')), 'IsUSASCIIString');
  Assert(IsAsciiStringW(ToWideString('012XYZabc{}_ ')), 'IsUSASCIIWideString');
  W := WideChar(#$0080);
  Assert(not IsAsciiStringW(W), 'IsUSASCIIWideString');
  W := WideChar($2262);
  Assert(not IsAsciiStringW(W), 'IsUSASCIIWideString');
  Assert(IsAsciiStringW(StrEmptyW), 'IsUSASCIIWideString');
end;

procedure Test_Float;
{$IFNDEF ExtendedIsDouble}
var E : Integer;
{$ENDIF}
begin
  Assert(not FloatZero(1e-1, 1e-2),   'FloatZero');
  Assert(FloatZero(1e-2, 1e-2),       'FloatZero');
  Assert(not FloatZero(1e-1, 1e-9),   'FloatZero');
  Assert(not FloatZero(1e-8, 1e-9),   'FloatZero');
  Assert(FloatZero(1e-9, 1e-9),       'FloatZero');
  Assert(FloatZero(1e-10, 1e-9),      'FloatZero');
  Assert(not FloatZero(0.2, 1e-1),    'FloatZero');
  Assert(FloatZero(0.09, 1e-1),       'FloatZero');

  Assert(FloatOne(1.0, 1e-1),         'FloatOne');
  Assert(FloatOne(1.09999, 1e-1),     'FloatOne');
  Assert(FloatOne(0.90001, 1e-1),     'FloatOne');
  Assert(not FloatOne(1.10001, 1e-1), 'FloatOne');
  Assert(not FloatOne(1.2, 1e-1),     'FloatOne');
  Assert(not FloatOne(0.89999, 1e-1), 'FloatOne');

  Assert(not FloatsEqual(2.0, -2.0, 1e-1),             'FloatsEqual');
  Assert(not FloatsEqual(1.0, 0.0, 1e-1),              'FloatsEqual');
  Assert(FloatsEqual(2.0, 2.0, 1e-1),                  'FloatsEqual');
  Assert(FloatsEqual(2.0, 2.09, 1e-1),                 'FloatsEqual');
  Assert(FloatsEqual(2.0, 1.90000001, 1e-1),           'FloatsEqual');
  Assert(not FloatsEqual(2.0, 2.10001, 1e-1),          'FloatsEqual');
  Assert(not FloatsEqual(2.0, 2.2, 1e-1),              'FloatsEqual');
  Assert(not FloatsEqual(2.0, 1.8999999, 1e-1),        'FloatsEqual');
  Assert(FloatsEqual(2.00000000011, 2.0, 1e-2),        'FloatsEqual');
  Assert(FloatsEqual(2.00000000011, 2.0, 1e-9),        'FloatsEqual');
  Assert(not FloatsEqual(2.00000000011, 2.0, 1e-10),   'FloatsEqual');
  Assert(not FloatsEqual(2.00000000011, 2.0, 1e-11),   'FloatsEqual');

  {$IFNDEF ExtendedIsDouble}
  Assert(FloatsCompare(0.0, 0.0, MinExtended) = crEqual,  'FloatsCompare');
  Assert(FloatsCompare(1.2, 1.2, MinExtended) = crEqual,  'FloatsCompare');
  Assert(FloatsCompare(1.23456789e-300, 1.23456789e-300, MinExtended) = crEqual, 'FloatsCompare');
  Assert(FloatsCompare(1.23456780e-300, 1.23456789e-300, MinExtended) = crLess,  'FloatsCompare');
  {$ENDIF}
  Assert(FloatsCompare(1.4e-5, 1.5e-5, 1e-4) = crEqual,   'FloatsCompare');
  Assert(FloatsCompare(1.4e-5, 1.5e-5, 1e-5) = crEqual,   'FloatsCompare');
  Assert(FloatsCompare(1.4e-5, 1.5e-5, 1e-6) = crLess,    'FloatsCompare');
  Assert(FloatsCompare(1.4e-5, 1.5e-5, 1e-7) = crLess,    'FloatsCompare');
  Assert(FloatsCompare(0.5003, 0.5001, 1e-1) = crEqual,   'FloatsCompare');
  Assert(FloatsCompare(0.5003, 0.5001, 1e-2) = crEqual,   'FloatsCompare');
  Assert(FloatsCompare(0.5003, 0.5001, 1e-3) = crEqual,   'FloatsCompare');
  Assert(FloatsCompare(0.5003, 0.5001, 1e-4) = crGreater, 'FloatsCompare');
  Assert(FloatsCompare(0.5003, 0.5001, 1e-5) = crGreater, 'FloatsCompare');

  {$IFNDEF ExtendedIsDouble}
  Assert(ExtendedApproxEqual(0.0, 0.0),                                'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(0.0, 1e-100, 1e-10),                  'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(1.0, 1e-100, 1e-10),                  'ExtendedApproxEqual');
  Assert(ExtendedApproxEqual(1.0, 1.0),                                'ExtendedApproxEqual');
  Assert(ExtendedApproxEqual(-1.0, -1.0),                              'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(1.0, -1.0),                           'ExtendedApproxEqual');
  Assert(ExtendedApproxEqual(1e-100, 1e-100, 1e-10),                   'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(0.0, 1.0, 1e-9),                      'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(-1.0, 1.0, 1e-9),                     'ExtendedApproxEqual');
  Assert(ExtendedApproxEqual(0.12345, 0.12349, 1e-3),                  'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(0.12345, 0.12349, 1e-4),              'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(0.12345, 0.12349, 1e-5),              'ExtendedApproxEqual');
  Assert(ExtendedApproxEqual(1.2345e+100, 1.2349e+100, 1e-3),          'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(1.2345e+100, 1.2349e+100, 1e-4),      'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(1.2345e+100, 1.2349e+100, 1e-5),      'ExtendedApproxEqual');
  Assert(ExtendedApproxEqual(1.2345e-100, 1.2349e-100, 1e-3),          'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(1.2345e-100, 1.2349e-100, 1e-4),      'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(1.2345e-100, 1.2349e-100, 1e-5),      'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(1.0e+20, 1.00000001E+20, 1e-8),       'ExtendedApproxEqual');
  Assert(ExtendedApproxEqual(1.0e+20, 1.000000001E+20, 1e-8),          'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(1.0e+20, 1.000000001E+20, 1e-9),      'ExtendedApproxEqual');
  Assert(ExtendedApproxEqual(1.0e+20, 1.0000000001E+20, 1e-9),         'ExtendedApproxEqual');
  Assert(not ExtendedApproxEqual(1.0e+20, 1.0000000001E+20, 1e-10),    'ExtendedApproxEqual');

  Assert(ExtendedApproxCompare(0.0, 0.0) = crEqual,                         'ExtendedApproxCompare');
  Assert(ExtendedApproxCompare(0.0, 1.0) = crLess,                          'ExtendedApproxCompare');
  Assert(ExtendedApproxCompare(1.0, 0.0) = crGreater,                       'ExtendedApproxCompare');
  Assert(ExtendedApproxCompare(-1.0, 1.0) = crLess,                         'ExtendedApproxCompare');
  Assert(ExtendedApproxCompare(1.2345e+10, 1.2349e+10, 1e-3) = crEqual,     'ExtendedApproxCompare');
  Assert(ExtendedApproxCompare(1.2345e+10, 1.2349e+10, 1e-4) = crLess,      'ExtendedApproxCompare');
  Assert(ExtendedApproxCompare(-1.2345e-10, -1.2349e-10, 1e-3) = crEqual,   'ExtendedApproxCompare');
  Assert(ExtendedApproxCompare(-1.2345e-10, -1.2349e-10, 1e-4) = crGreater, 'ExtendedApproxCompare');
  {$ENDIF}

  Assert(FloatApproxEqual(0.0, 0.0),                                'FloatApproxEqual');
  Assert(not FloatApproxEqual(0.0, 1e-100, 1e-10),                  'FloatApproxEqual');
  Assert(not FloatApproxEqual(1.0, 1e-100, 1e-10),                  'FloatApproxEqual');
  Assert(FloatApproxEqual(1.0, 1.0),                                'FloatApproxEqual');
  Assert(FloatApproxEqual(-1.0, -1.0),                              'FloatApproxEqual');
  Assert(not FloatApproxEqual(1.0, -1.0),                           'FloatApproxEqual');
  Assert(FloatApproxEqual(1e-100, 1e-100, 1e-10),                   'FloatApproxEqual');
  Assert(not FloatApproxEqual(0.0, 1.0, 1e-9),                      'FloatApproxEqual');
  Assert(not FloatApproxEqual(-1.0, 1.0, 1e-9),                     'FloatApproxEqual');
  Assert(FloatApproxEqual(0.12345, 0.12349, 1e-3),                  'FloatApproxEqual');
  Assert(not FloatApproxEqual(0.12345, 0.12349, 1e-4),              'FloatApproxEqual');
  Assert(not FloatApproxEqual(0.12345, 0.12349, 1e-5),              'FloatApproxEqual');
  Assert(FloatApproxEqual(1.2345e+100, 1.2349e+100, 1e-3),          'FloatApproxEqual');
  Assert(not FloatApproxEqual(1.2345e+100, 1.2349e+100, 1e-4),      'FloatApproxEqual');
  Assert(not FloatApproxEqual(1.2345e+100, 1.2349e+100, 1e-5),      'FloatApproxEqual');
  Assert(FloatApproxEqual(1.2345e-100, 1.2349e-100, 1e-3),          'FloatApproxEqual');
  Assert(not FloatApproxEqual(1.2345e-100, 1.2349e-100, 1e-4),      'FloatApproxEqual');
  Assert(not FloatApproxEqual(1.2345e-100, 1.2349e-100, 1e-5),      'FloatApproxEqual');
  // Assert(not FloatApproxEqual(1.0e+20, 1.00000001E+20, 1e-8),       'FloatApproxEqual');
  Assert(FloatApproxEqual(1.0e+20, 1.000000001E+20, 1e-8),          'FloatApproxEqual');
  // Assert(not FloatApproxEqual(1.0e+20, 1.000000001E+20, 1e-9),      'FloatApproxEqual');
  Assert(FloatApproxEqual(1.0e+20, 1.0000000001E+20, 1e-9),         'FloatApproxEqual');
  // Assert(not FloatApproxEqual(1.0e+20, 1.0000000001E+20, 1e-10),    'FloatApproxEqual');

  Assert(FloatApproxCompare(0.0, 0.0) = crEqual,                         'FloatApproxCompare');
  Assert(FloatApproxCompare(0.0, 1.0) = crLess,                          'FloatApproxCompare');
  Assert(FloatApproxCompare(1.0, 0.0) = crGreater,                       'FloatApproxCompare');
  Assert(FloatApproxCompare(-1.0, 1.0) = crLess,                         'FloatApproxCompare');
  Assert(FloatApproxCompare(1.2345e+10, 1.2349e+10, 1e-3) = crEqual,     'FloatApproxCompare');
  Assert(FloatApproxCompare(1.2345e+10, 1.2349e+10, 1e-4) = crLess,      'FloatApproxCompare');
  Assert(FloatApproxCompare(-1.2345e-10, -1.2349e-10, 1e-3) = crEqual,   'FloatApproxCompare');
  Assert(FloatApproxCompare(-1.2345e-10, -1.2349e-10, 1e-4) = crGreater, 'FloatApproxCompare');

  {$IFNDEF ExtendedIsDouble}
  Assert(ExtendedExponentBase10(1.0, E),    'ExtendedExponent');
  Assert(E = 0,                          'ExtendedExponent');
  Assert(ExtendedExponentBase10(10.0, E),   'ExtendedExponent');
  Assert(E = 1,                          'ExtendedExponent');
  Assert(ExtendedExponentBase10(0.1, E),    'ExtendedExponent');
  Assert(E = -1,                         'ExtendedExponent');
  Assert(ExtendedExponentBase10(1e100, E),  'ExtendedExponent');
  Assert(E = 100,                        'ExtendedExponent');
  Assert(ExtendedExponentBase10(1e-100, E), 'ExtendedExponent');
  Assert(E = -100,                       'ExtendedExponent');
  Assert(ExtendedExponentBase10(0.999, E),  'ExtendedExponent');
  Assert(E = 0,                          'ExtendedExponent');
  Assert(ExtendedExponentBase10(-0.999, E), 'ExtendedExponent');
  Assert(E = 0,                          'ExtendedExponent');
  {$ENDIF}
end;

procedure Test_IntStr;
var I : Int64;
    W : LongWord;
    L : Integer;
    A : AnsiString;
begin
  Assert(HexCharToInt('A') = 10,   'HexCharToInt');
  Assert(HexCharToInt('a') = 10,   'HexCharToInt');
  Assert(HexCharToInt('1') = 1,    'HexCharToInt');
  Assert(HexCharToInt('0') = 0,    'HexCharToInt');
  Assert(HexCharToInt('F') = 15,   'HexCharToInt');
  Assert(HexCharToInt('G') = -1,   'HexCharToInt');

  Assert(IntToStringA(0) = ToAnsiString('0'),                           'IntToStringA');
  Assert(IntToStringA(1) = ToAnsiString('1'),                           'IntToStringA');
  Assert(IntToStringA(-1) = ToAnsiString('-1'),                         'IntToStringA');
  Assert(IntToStringA(10) = ToAnsiString('10'),                         'IntToStringA');
  Assert(IntToStringA(-10) = ToAnsiString('-10'),                       'IntToStringA');
  Assert(IntToStringA(123) = ToAnsiString('123'),                       'IntToStringA');
  Assert(IntToStringA(-123) = ToAnsiString('-123'),                     'IntToStringA');
  Assert(IntToStringA(MinLongInt) = ToAnsiString('-2147483648'),        'IntToStringA');
  {$IFNDEF DELPHI7_DOWN}
  Assert(IntToStringA(-2147483649) = ToAnsiString('-2147483649'),       'IntToStringA');
  {$ENDIF}
  Assert(IntToStringA(MaxLongInt) = ToAnsiString('2147483647'),         'IntToStringA');
  Assert(IntToStringA(2147483648) = ToAnsiString('2147483648'),         'IntToStringA');
  Assert(IntToStringA(MinInt64) = ToAnsiString('-9223372036854775808'), 'IntToStringA');
  Assert(IntToStringA(MaxInt64) = ToAnsiString('9223372036854775807'),  'IntToStringA');

  Assert(IntToStringB(0) = ToRawByteString('0'),                           'IntToStringB');
  Assert(IntToStringB(1) = ToRawByteString('1'),                           'IntToStringB');
  Assert(IntToStringB(-1) = ToRawByteString('-1'),                         'IntToStringB');
  Assert(IntToStringB(10) = ToRawByteString('10'),                         'IntToStringB');
  Assert(IntToStringB(-10) = ToRawByteString('-10'),                       'IntToStringB');
  Assert(IntToStringB(123) = ToRawByteString('123'),                       'IntToStringB');
  Assert(IntToStringB(-123) = ToRawByteString('-123'),                     'IntToStringB');
  Assert(IntToStringB(MinLongInt) = ToRawByteString('-2147483648'),        'IntToStringB');
  {$IFNDEF DELPHI7_DOWN}
  Assert(IntToStringB(-2147483649) = ToRawByteString('-2147483649'),       'IntToStringB');
  {$ENDIF}
  Assert(IntToStringB(MaxLongInt) = ToRawByteString('2147483647'),         'IntToStringB');
  Assert(IntToStringB(2147483648) = ToRawByteString('2147483648'),         'IntToStringB');
  Assert(IntToStringB(MinInt64) = ToRawByteString('-9223372036854775808'), 'IntToStringB');
  Assert(IntToStringB(MaxInt64) = ToRawByteString('9223372036854775807'),  'IntToStringB');

  Assert(IntToStringW(0) = ToWideString('0'),                     'IntToWideString');
  Assert(IntToStringW(1) = ToWideString('1'),                     'IntToWideString');
  Assert(IntToStringW(-1) = ToWideString('-1'),                   'IntToWideString');
  Assert(IntToStringW(1234567890) = ToWideString('1234567890'),   'IntToWideString');
  Assert(IntToStringW(-1234567890) = ToWideString('-1234567890'), 'IntToWideString');

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

  Assert(UIntToStringA(0) = ToAnsiString('0'),                  'UIntToString');
  Assert(UIntToStringA($FFFFFFFF) = ToAnsiString('4294967295'), 'UIntToString');
  Assert(UIntToStringW(0) = ToWideString('0'),                  'UIntToString');
  Assert(UIntToStringW($FFFFFFFF) = ToWideString('4294967295'), 'UIntToString');
  Assert(UIntToStringU(0) = '0',                  'UIntToString');
  Assert(UIntToStringU($FFFFFFFF) = '4294967295', 'UIntToString');
  Assert(UIntToString(0) = '0',                   'UIntToString');
  Assert(UIntToString($FFFFFFFF) = '4294967295',  'UIntToString');

  Assert(LongWordToStrA(0, 8) = ToAnsiString('00000000'),           'LongWordToStr');
  Assert(LongWordToStrA($FFFFFFFF, 0) = ToAnsiString('4294967295'), 'LongWordToStr');
  Assert(LongWordToStrB(0, 8) = ToRawByteString('00000000'),           'LongWordToStr');
  Assert(LongWordToStrB($FFFFFFFF, 0) = ToRawByteString('4294967295'), 'LongWordToStr');
  Assert(LongWordToStrW(0, 8) = ToWideString('00000000'),           'LongWordToStr');
  Assert(LongWordToStrW($FFFFFFFF, 0) = ToWideString('4294967295'), 'LongWordToStr');
  Assert(LongWordToStrU(0, 8) = '00000000',           'LongWordToStr');
  Assert(LongWordToStrU($FFFFFFFF, 0) = '4294967295', 'LongWordToStr');
  Assert(LongWordToStr(0, 8) = '00000000',            'LongWordToStr');
  Assert(LongWordToStr($FFFFFFFF, 0) = '4294967295',  'LongWordToStr');
  Assert(LongWordToStr(123) = '123',                  'LongWordToStr');
  Assert(LongWordToStr(10000) = '10000',              'LongWordToStr');
  Assert(LongWordToStr(99999) = '99999',              'LongWordToStr');
  Assert(LongWordToStr(1, 1) = '1',                   'LongWordToStr');
  Assert(LongWordToStr(1, 3) = '001',                 'LongWordToStr');
  Assert(LongWordToStr(1234, 3) = '1234',             'LongWordToStr');

  Assert(LongWordToHexA(0, 8) = ToAnsiString('00000000'),         'LongWordToHex');
  Assert(LongWordToHexA($FFFFFFFF, 0) = ToAnsiString('FFFFFFFF'), 'LongWordToHex');
  Assert(LongWordToHexA($10000) = ToAnsiString('10000'),          'LongWordToHex');
  Assert(LongWordToHexA($12345678) = ToAnsiString('12345678'),    'LongWordToHex');
  Assert(LongWordToHexA($AB, 4) = ToAnsiString('00AB'),           'LongWordToHex');
  Assert(LongWordToHexA($ABCD, 8) = ToAnsiString('0000ABCD'),     'LongWordToHex');
  Assert(LongWordToHexA($CDEF, 2) = ToAnsiString('CDEF'),         'LongWordToHex');
  Assert(LongWordToHexA($ABC3, 0, False) = ToAnsiString('abc3'),  'LongWordToHex');

  Assert(LongWordToHexW(0, 8) = ToWideString('00000000'),         'LongWordToHex');
  Assert(LongWordToHexW(0) = ToWideString('0'),                   'LongWordToHex');
  Assert(LongWordToHexW($FFFFFFFF, 0) = ToWideString('FFFFFFFF'), 'LongWordToHex');
  Assert(LongWordToHexW($AB, 4) = ToWideString('00AB'),           'LongWordToHex');
  Assert(LongWordToHexW($ABC3, 0, False) = ToWideString('abc3'),  'LongWordToHex');

  Assert(LongWordToHexU(0, 8) = '00000000',         'LongWordToHex');
  Assert(LongWordToHexU(0) = '0',                   'LongWordToHex');
  Assert(LongWordToHexU($FFFFFFFF, 0) = 'FFFFFFFF', 'LongWordToHex');
  Assert(LongWordToHexU($AB, 4) = '00AB',           'LongWordToHex');
  Assert(LongWordToHexU($ABC3, 0, False) = 'abc3',  'LongWordToHex');

  Assert(LongWordToHex(0, 8) = '00000000',          'LongWordToHex');
  Assert(LongWordToHex($FFFFFFFF, 0) = 'FFFFFFFF',  'LongWordToHex');
  Assert(LongWordToHex(0) = '0',                    'LongWordToHex');
  Assert(LongWordToHex($ABCD, 8) = '0000ABCD',      'LongWordToHex');
  Assert(LongWordToHex($ABC3, 0, False) = 'abc3',   'LongWordToHex');

  Assert(StringToIntA(ToAnsiString('0')) = 0,       'StringToInt');
  Assert(StringToIntA(ToAnsiString('1')) = 1,       'StringToInt');
  Assert(StringToIntA(ToAnsiString('-1')) = -1,     'StringToInt');
  Assert(StringToIntA(ToAnsiString('10')) = 10,     'StringToInt');
  Assert(StringToIntA(ToAnsiString('01')) = 1,      'StringToInt');
  Assert(StringToIntA(ToAnsiString('-10')) = -10,   'StringToInt');
  Assert(StringToIntA(ToAnsiString('-01')) = -1,    'StringToInt');
  Assert(StringToIntA(ToAnsiString('123')) = 123,   'StringToInt');
  Assert(StringToIntA(ToAnsiString('-123')) = -123, 'StringToInt');

  Assert(StringToIntB(ToRawByteString('321')) = 321,   'StringToInt');
  Assert(StringToIntB(ToRawByteString('-321')) = -321, 'StringToInt');

  Assert(StringToIntW(ToWideString('321')) = 321,   'StringToInt');
  Assert(StringToIntW(ToWideString('-321')) = -321, 'StringToInt');

  Assert(StringToIntU('321') = 321,   'StringToInt');
  Assert(StringToIntU('-321') = -321, 'StringToInt');

  A := ToAnsiString('-012A');
  Assert(TryStringToInt64PA(PAnsiChar(A), Length(A), I, L) = convertOK,          'StringToInt');
  Assert((I = -12) and (L = 4),                                                  'StringToInt');
  A := ToAnsiString('-A012');
  Assert(TryStringToInt64PA(PAnsiChar(A), Length(A), I, L) = convertFormatError, 'StringToInt');
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

  Assert(TryStringToInt64W(ToWideString('9223372036854775807'), I),      'StringToInt');
  Assert(I = 9223372036854775807,                          'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(TryStringToInt64W(ToWideString('-9223372036854775808'), I),     'StringToInt');
  Assert(I = -9223372036854775808,                         'StringToInt');
  {$ENDIF}
  Assert(not TryStringToInt64W(ToWideString(''), I),                     'StringToInt');
  Assert(not TryStringToInt64W(ToWideString('-'), I),                    'StringToInt');
  Assert(not TryStringToInt64W(ToWideString('0A'), I),                   'StringToInt');
  Assert(not TryStringToInt64W(ToWideString('9223372036854775808'), I),  'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(not TryStringToInt64W(ToWideString('-9223372036854775809'), I), 'StringToInt');
  {$ENDIF}

  Assert(TryStringToInt64U('9223372036854775807', I),      'StringToInt');
  Assert(I = 9223372036854775807,                          'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(TryStringToInt64U('-9223372036854775808', I),     'StringToInt');
  Assert(I = -9223372036854775808,                         'StringToInt');
  {$ENDIF}
  Assert(not TryStringToInt64U('', I),                     'StringToInt');
  Assert(not TryStringToInt64U('-', I),                    'StringToInt');
  Assert(not TryStringToInt64U('0A', I),                   'StringToInt');
  Assert(not TryStringToInt64U('9223372036854775808', I),  'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(not TryStringToInt64U('-9223372036854775809', I), 'StringToInt');
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
  Assert(HexToUInt('FFFFFFFF') = $FFFFFFFF,  'HexStringToUInt');

  Assert(HexToLongWord('FFFFFFFF') = $FFFFFFFF,  'HexToLongWord');
  Assert(HexToLongWord('0') = 0,                 'HexToLongWord');
  Assert(HexToLongWord('123456') = $123456,      'HexToLongWord');
  Assert(HexToLongWord('ABC') = $ABC,            'HexToLongWord');
  Assert(HexToLongWord('abc') = $ABC,            'HexToLongWord');
  Assert(not TryHexToLongWord('', W),            'HexToLongWord');
  Assert(not TryHexToLongWord('x', W),           'HexToLongWord');

  Assert(HexToLongWordA(ToAnsiString('FFFFFFFF')) = $FFFFFFFF, 'HexToLongWord');
  Assert(HexToLongWordA(ToAnsiString('0')) = 0,                'HexToLongWord');
  Assert(HexToLongWordA(ToAnsiString('ABC')) = $ABC,           'HexToLongWord');
  Assert(HexToLongWordA(ToAnsiString('abc')) = $ABC,           'HexToLongWord');
  Assert(not TryHexToLongWordA(ToAnsiString(''), W),           'HexToLongWord');
  Assert(not TryHexToLongWordA(ToAnsiString('x'), W),          'HexToLongWord');

  Assert(HexToLongWordB(ToRawByteString('FFFFFFFF')) = $FFFFFFFF, 'HexToLongWord');
  Assert(HexToLongWordB(ToRawByteString('0')) = 0,                'HexToLongWord');
  Assert(HexToLongWordB(ToRawByteString('ABC')) = $ABC,           'HexToLongWord');
  Assert(HexToLongWordB(ToRawByteString('abc')) = $ABC,           'HexToLongWord');
  Assert(not TryHexToLongWordB(ToRawByteString(''), W),           'HexToLongWord');
  Assert(not TryHexToLongWordB(ToRawByteString('x'), W),          'HexToLongWord');

  Assert(HexToLongWordW(ToWideString('FFFFFFFF')) = $FFFFFFFF, 'HexToLongWord');
  Assert(HexToLongWordW(ToWideString('0')) = 0,                'HexToLongWord');
  Assert(HexToLongWordW(ToWideString('123456')) = $123456,     'HexToLongWord');
  Assert(HexToLongWordW(ToWideString('ABC')) = $ABC,           'HexToLongWord');
  Assert(HexToLongWordW(ToWideString('abc')) = $ABC,           'HexToLongWord');
  Assert(not TryHexToLongWordW(ToWideString(''), W),           'HexToLongWord');
  Assert(not TryHexToLongWordW(ToWideString('x'), W),          'HexToLongWord');

  Assert(HexToLongWordU('FFFFFFFF') = $FFFFFFFF, 'HexToLongWord');
  Assert(HexToLongWordU('0') = 0,                'HexToLongWord');
  Assert(HexToLongWordU('123456') = $123456,     'HexToLongWord');
  Assert(HexToLongWordU('ABC') = $ABC,           'HexToLongWord');
  Assert(HexToLongWordU('abc') = $ABC,           'HexToLongWord');
  Assert(not TryHexToLongWordU('', W),           'HexToLongWord');
  Assert(not TryHexToLongWordU('x', W),          'HexToLongWord');

  Assert(not TryStringToLongWordA(ToAnsiString(''), W),             'StringToLongWord');
  Assert(StringToLongWordA(ToAnsiString('123')) = 123,              'StringToLongWord');
  Assert(StringToLongWordA(ToAnsiString('4294967295')) = $FFFFFFFF, 'StringToLongWord');
  Assert(StringToLongWordA(ToAnsiString('999999999')) = 999999999,  'StringToLongWord');

  Assert(StringToLongWordB(ToRawByteString('0')) = 0,                  'StringToLongWord');
  Assert(StringToLongWordB(ToRawByteString('4294967295')) = $FFFFFFFF, 'StringToLongWord');

  Assert(StringToLongWordW(ToWideString('0')) = 0,                  'StringToLongWord');
  Assert(StringToLongWordW(ToWideString('4294967295')) = $FFFFFFFF, 'StringToLongWord');

  Assert(StringToLongWordU('0') = 0,                  'StringToLongWord');
  Assert(StringToLongWordU('4294967295') = $FFFFFFFF, 'StringToLongWord');

  Assert(StringToLongWord('0') = 0,                   'StringToLongWord');
  Assert(StringToLongWord('4294967295') = $FFFFFFFF,  'StringToLongWord');
end;

procedure Test_FloatStr;
var A : AnsiString;
    E : Extended;
    L : Integer;
begin
  // FloatToStr
  {$IFNDEF FREEPASCAL}
  Assert(FloatToStringA(0.0) = ToAnsiString('0'));
  Assert(FloatToStringA(-1.5) = ToAnsiString('-1.5'));
  Assert(FloatToStringA(1.5) = ToAnsiString('1.5'));
  Assert(FloatToStringA(1.1) = ToAnsiString('1.1'));
  Assert(FloatToStringA(123) = ToAnsiString('123'));
  Assert(FloatToStringA(0.00000000000001) = ToAnsiString('0.00000000000001'));
  Assert(FloatToStringA(0.000000000000001) = ToAnsiString('0.000000000000001'));
  Assert(FloatToStringA(0.0000000000000001) = ToAnsiString('1E-0016'));
  Assert(FloatToStringA(0.0000000000000012345) = ToAnsiString('0.000000000000001'));
  Assert(FloatToStringA(0.00000000000000012345) = ToAnsiString('1.2345E-0016'));
  {$IFNDEF ExtendedIsDouble}
  Assert(FloatToStringA(123456789.123456789) = ToAnsiString('123456789.123456789'));
  {$IFDEF DELPHIXE2_UP}
  Assert(FloatToStringA(123456789012345.1234567890123456789) = ToAnsiString('123456789012345.123'));
  {$ELSE}
  Assert(FloatToStringA(123456789012345.1234567890123456789) = ToAnsiString('123456789012345.1234'));
  {$ENDIF}
  Assert(FloatToStringA(1234567890123456.1234567890123456789) = ToAnsiString('1.23456789012346E+0015'));
  {$ENDIF}
  Assert(FloatToStringA(0.12345) = ToAnsiString('0.12345'));
  Assert(FloatToStringA(1e100) = ToAnsiString('1E+0100'));
  Assert(FloatToStringA(1.234e+100) = ToAnsiString('1.234E+0100'));
  Assert(FloatToStringA(-1.5e-100) = ToAnsiString('-1.5E-0100'));
  {$IFNDEF ExtendedIsDouble}
  Assert(FloatToStringA(1.234e+1000) = ToAnsiString('1.234E+1000'));
  Assert(FloatToStringA(-1e-4000) = ToAnsiString('0'));
  {$ENDIF}

  Assert(FloatToStringB(0.0) = ToRawByteString('0'));
  Assert(FloatToStringB(-1.5) = ToRawByteString('-1.5'));
  Assert(FloatToStringB(1.5) = ToRawByteString('1.5'));
  Assert(FloatToStringB(1.1) = ToRawByteString('1.1'));

  Assert(FloatToStringW(0.0) = ToWideString('0'));
  Assert(FloatToStringW(-1.5) = ToWideString('-1.5'));
  Assert(FloatToStringW(1.5) = ToWideString('1.5'));
  Assert(FloatToStringW(1.1) = ToWideString('1.1'));
  {$IFNDEF ExtendedIsDouble}
  Assert(FloatToStringW(123456789.123456789) = ToWideString('123456789.123456789'));
  {$IFDEF DELPHIXE2_UP}
  Assert(FloatToStringW(123456789012345.1234567890123456789) = ToWideString('123456789012345.123'));
  {$ELSE}
  Assert(FloatToStringW(123456789012345.1234567890123456789) = ToWideString('123456789012345.1234'));
  {$ENDIF}
  Assert(FloatToStringW(1234567890123456.1234567890123456789) = ToWideString('1.23456789012346E+0015'));
  {$ENDIF}
  Assert(FloatToStringW(0.12345) = ToWideString('0.12345'));
  Assert(FloatToStringW(1e100) = ToWideString('1E+0100'));
  Assert(FloatToStringW(1.234e+100) = ToWideString('1.234E+0100'));
  Assert(FloatToStringW(1.5e-100) = ToWideString('1.5E-0100'));

  Assert(FloatToStringU(0.0) = '0');
  Assert(FloatToStringU(-1.5) = '-1.5');
  Assert(FloatToStringU(1.5) = '1.5');
  Assert(FloatToStringU(1.1) = '1.1');
  {$IFNDEF ExtendedIsDouble}
  Assert(FloatToStringU(123456789.123456789) = '123456789.123456789');
  {$IFDEF DELPHIXE2_UP}
  Assert(FloatToStringU(123456789012345.1234567890123456789) = '123456789012345.123');
  {$ELSE}
  Assert(FloatToStringU(123456789012345.1234567890123456789) = '123456789012345.1234');
  {$ENDIF}
  Assert(FloatToStringU(1234567890123456.1234567890123456789) = '1.23456789012346E+0015');
  {$ENDIF}
  Assert(FloatToStringU(0.12345) = '0.12345');
  Assert(FloatToStringU(1e100) = '1E+0100');
  Assert(FloatToStringU(1.234e+100) = '1.234E+0100');
  Assert(FloatToStringU(1.5e-100) = '1.5E-0100');

  Assert(FloatToString(0.0) = '0');
  Assert(FloatToString(-1.5) = '-1.5');
  Assert(FloatToString(1.5) = '1.5');
  Assert(FloatToString(1.1) = '1.1');
  {$IFNDEF ExtendedIsDouble}
  Assert(FloatToString(123456789.123456789) = '123456789.123456789');
  {$IFDEF DELPHIXE2_UP}
  Assert(FloatToString(123456789012345.1234567890123456789) = '123456789012345.123');
  {$ELSE}
  Assert(FloatToString(123456789012345.1234567890123456789) = '123456789012345.1234');
  {$ENDIF}
  Assert(FloatToString(1234567890123456.1234567890123456789) = '1.23456789012346E+0015');
  {$ENDIF}
  Assert(FloatToString(0.12345) = '0.12345');
  Assert(FloatToString(1e100) = '1E+0100');
  Assert(FloatToString(1.234e+100) = '1.234E+0100');
  Assert(FloatToString(1.5e-100) = '1.5E-0100');
  {$ENDIF}

  // StrToFloat
  A := ToAnsiString('123.456');
  Assert(TryStringToFloatPA(PAnsiChar(A), Length(A), E, L) = convertOK);
  Assert((E = 123.456) and (L = 7));
  A := ToAnsiString('-000.500A');
  Assert(TryStringToFloatPA(PAnsiChar(A), Length(A), E, L) = convertOK);
  Assert((E = -0.5) and (L = 8));
  A := ToAnsiString('1.234e+002X');
  Assert(TryStringToFloatPA(PAnsiChar(A), Length(A), E, L) = convertOK);
  Assert((E = 123.4) and (L = 10));
  A := ToAnsiString('1.2e300x');
  Assert(TryStringToFloatPA(PAnsiChar(A), Length(A), E, L) = convertOK);
  {$IFNDEF ExtendedIsDouble}
  Assert(ExtendedApproxEqual(E, 1.2e300, 1e-2) and (L = 7));
  {$ENDIF}
  A := ToAnsiString('1.2e-300e');
  Assert(TryStringToFloatPA(PAnsiChar(A), Length(A), E, L) = convertOK);
  {$IFNDEF ExtendedIsDouble}
  Assert(ExtendedApproxEqual(E, 1.2e-300, 1e-2) and (L = 8));
  {$ENDIF}

  // 9999..9999 overflow
  {$IFNDEF ExtendedIsDouble}
  A := '';
  for L := 1 to 5000 do
    A := A + '9';
  Assert(TryStringToFloatPA(PAnsiChar(A), Length(A), E, L) = convertOverflow);
  Assert((E = 0.0) and (L >= 200));
  {$ENDIF}

  // 1200..0000
  {$IFNDEF ExtendedIsDouble}
  A := ToAnsiString('12');
  for L := 1 to 100 do
    A := A + '0';
  Assert(TryStringToFloatPA(PAnsiChar(A), Length(A), E, L) = convertOK);
  Assert(ExtendedApproxEqual(E, 1.2e+101, 1e-2) and (L = 102));
  {$ENDIF}

  // 0.0000..0001 overflow
  {$IFNDEF ExtendedIsDouble}
  A := '0.';
  for L := 1 to 5000 do
    A := A + '0';
  A := A + '1';
  Assert(TryStringToFloatPA(PAnsiChar(A), Length(A), E, L) = convertOverflow);
  Assert((E = 0.0) and (L >= 500));
  {$ENDIF}

  // 0.0000..000123
  {$IFNDEF ExtendedIsDouble}
  A := '0.';
  for L := 1 to 100 do
    A := A + '0';
  A := A + '123';
  Assert(TryStringToFloatPA(PAnsiChar(A), Length(A), E, L) = convertOK);
  Assert(ExtendedApproxEqual(E, 1.23e-101, 1e-3) and (L = 105));
  {$ENDIF}

  // 1200..0000e100
  {$IFNDEF ExtendedIsDouble}
  A := '12';
  for L := 1 to 100 do
    A := A + '0';
  A := A + 'e100';
  Assert(TryStringToFloatPA(PAnsiChar(A), Length(A), E, L) = convertOK);
  Assert(ExtendedApproxEqual(E, 1.2e+201, 1e-1) and (L = 106));
  {$ENDIF}

  Assert(StringToFloatA(ToAnsiString('0')) = 0.0);
  Assert(StringToFloatA(ToAnsiString('1')) = 1.0);
  Assert(StringToFloatA(ToAnsiString('1.5')) = 1.5);
  Assert(StringToFloatA(ToAnsiString('+1.5')) = 1.5);
  Assert(StringToFloatA(ToAnsiString('-1.5')) = -1.5);
  Assert(StringToFloatA(ToAnsiString('1.1')) = 1.1);
  Assert(StringToFloatA(ToAnsiString('-00.00')) = 0.0);
  Assert(StringToFloatA(ToAnsiString('+00.00')) = 0.0);
  Assert(StringToFloatA(ToAnsiString('0000000000000000000000001.1000000000000000000000000')) = 1.1);
  Assert(StringToFloatA(ToAnsiString('.5')) = 0.5);
  Assert(StringToFloatA(ToAnsiString('-.5')) = -0.5);
  {$IFNDEF ExtendedIsDouble}
  Assert(ExtendedApproxEqual(StringToFloatA(ToAnsiString('1.123456789')), 1.123456789, 1e-10));
  Assert(ExtendedApproxEqual(StringToFloatA(ToAnsiString('123456789.123456789')), 123456789.123456789, 1e-10));
  Assert(ExtendedApproxEqual(StringToFloatA(ToAnsiString('1.5e500')), 1.5e500, 1e-2));
  Assert(ExtendedApproxEqual(StringToFloatA(ToAnsiString('+1.5e+500')), 1.5e500, 1e-2));
  Assert(ExtendedApproxEqual(StringToFloatA(ToAnsiString('1.2E-500')), 1.2e-500, 1e-2));
  Assert(ExtendedApproxEqual(StringToFloatA(ToAnsiString('-1.2E-500')), -1.2e-500, 1e-2));
  Assert(ExtendedApproxEqual(StringToFloatA(ToAnsiString('-1.23456789E-500')), -1.23456789e-500, 1e-9));
  {$ENDIF}

  Assert(not TryStringToFloatA(ToAnsiString(''), E));
  Assert(not TryStringToFloatA(ToAnsiString('+'), E));
  Assert(not TryStringToFloatA(ToAnsiString('-'), E));
  Assert(not TryStringToFloatA(ToAnsiString('.'), E));
  Assert(not TryStringToFloatA(ToAnsiString(' '), E));
  Assert(not TryStringToFloatA(ToAnsiString(' 0'), E));
  Assert(not TryStringToFloatA(ToAnsiString('0 '), E));
  Assert(not TryStringToFloatA(ToAnsiString('--0'), E));
  Assert(not TryStringToFloatA(ToAnsiString('0X'), E));
end;

procedure Test_Hash;
begin
  // HashStr
  Assert(HashStrA(ToAnsiString('Fundamentals')) = $3FB7796E, 'HashStr');
  Assert(HashStrA(ToAnsiString('0')) = $B2420DE,             'HashStr');
  Assert(HashStrA(ToAnsiString('Fundamentals'), 1, -1, False) = HashStrA(ToAnsiString('FUNdamentals'), 1, -1, False), 'HashStr');
  Assert(HashStrA(ToAnsiString('Fundamentals'), 1, -1, True) <> HashStrA(ToAnsiString('FUNdamentals'), 1, -1, True),  'HashStr');

  Assert(HashStrB(ToRawByteString('Fundamentals')) = $3FB7796E, 'HashStr');
  Assert(HashStrB(ToRawByteString('0')) = $B2420DE,             'HashStr');
  Assert(HashStrB(ToRawByteString('Fundamentals'), 1, -1, False) = HashStrB(ToRawByteString('FUNdamentals'), 1, -1, False), 'HashStr');
  Assert(HashStrB(ToRawByteString('Fundamentals'), 1, -1, True) <> HashStrB(ToRawByteString('FUNdamentals'), 1, -1, True),  'HashStr');

  Assert(HashStrW(ToWideString('Fundamentals')) = $FD6ED837, 'HashStr');
  Assert(HashStrW(ToWideString('0')) = $6160DBF3,            'HashStr');
  Assert(HashStrW(ToWideString('Fundamentals'), 1, -1, False) = HashStrW(ToWideString('FUNdamentals'), 1, -1, False), 'HashStr');
  Assert(HashStrW(ToWideString('Fundamentals'), 1, -1, True) <> HashStrW(ToWideString('FUNdamentals'), 1, -1, True),  'HashStr');

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

{$IFNDEF ManagedCode}
procedure Test_Memory;
var I, J : Integer;
    A, B : AnsiString;
begin
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
end;
{$ENDIF}

{$IFDEF ImplementsStringRefCount}
procedure Test_StringRefCount;
const
  C1 = 'ABC';
var
  B, C : RawByteString;
  U, V : UnicodeString;
begin
  B := C1;
  Assert(StringRefCount(B) = -1);
  C := B;
  Assert(StringRefCount(C) = -1);
  C[1] := '1';
  Assert(StringRefCount(C) = 1);
  B := C;
  Assert(StringRefCount(B) = 2);

  U := C1;
  Assert(StringRefCount(U) = -1);
  V := U;
  Assert(StringRefCount(V) = -1);
  V[1] := '1';
  Assert(StringRefCount(V) = 1);
  U := V;
  Assert(StringRefCount(U) = 2);
end;
{$ENDIF}

procedure Test;
begin
  {$IFDEF CPU_INTEL386}
  Set8087CW(Default8087CW);
  {$ENDIF}
  Test_Misc;
  Test_Float;
  Test_IntStr;
  Test_FloatStr;
  Test_Hash;
  {$IFNDEF ManagedCode}
  Test_Memory;
  {$ENDIF}
  {$IFDEF ImplementsStringRefCount}
  Test_StringRefCount;
  {$ENDIF}
end;
{$ENDIF}



end.

