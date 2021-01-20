{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcUtils.pas                                             }
{   File version:     5.76                                                     }
{   Description:      Utility functions.                                       }
{                                                                              }
{   Copyright:        Copyright (c) 2000-2021, David J Butler                  }
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
{   2020/03/13  5.67  NativeInt changes.                                       }
{   2020/03/30  5.68  EqualMem optimisations and tests.                        }
{   2020/06/02  5.69  String to/from UInt64 conversion functions.              }
{   2020/06/07  5.70  Remove IInterface definition for Delphi 5.               }
{   2020/06/15  5.71  Byte/Word versions of memory functions.                  }
{   2020/07/20  5.72  Replace Bounded functions with IsInRange functions.      }
{   2020/07/25  5.73  Optimise EqualMem and EqualMemNoAsciiCase.               }
{   2020/07/25  5.74  Add common String and Ascii functions.                   }
{   2020/12/12  5.75  Compilable with Delphi 2007 Win32.                       }
{   2021/01/20  5.76  Move tests to seperate unit.                             }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 7-10.4 Win32/Win64           5.76  2021/01/20                       }
{   Delphi 10.2-10.4 Linux64            5.69  2020/06/02                       }
{   FreePascal 3.0.4 Win64              5.69  2020/06/02                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

unit flcUtils;

interface

uses
  { System }
  SysUtils,

  { Fundamentals }
  flcStdTypes;



{                                                                              }
{ Release                                                                      }
{                                                                              }
const
  FundamentalsRelease   = '5.0.9';
  FundamentalsTitleText = 'Fundamentals Library ' + FundamentalsRelease;



{                                                                              }
{ Exception                                                                    }
{                                                                              }
type
  ERangeCheckError = class(Exception)
  public
    constructor Create;
  end;



{                                                                              }
{ Integer functions                                                            }
{                                                                              }

{ Min returns smallest of A and B                                              }
{ Max returns greatest of A and B                                              }
function  MinInt(const A, B: Int64): Int64;                   {$IFDEF UseInline}inline;{$ENDIF}
function  MaxInt(const A, B: Int64): Int64;                   {$IFDEF UseInline}inline;{$ENDIF}
function  MinUInt(const A, B: UInt64): UInt64;                {$IFDEF UseInline}inline;{$ENDIF}
function  MaxUInt(const A, B: UInt64): UInt64;                {$IFDEF UseInline}inline;{$ENDIF}
function  MinNatInt(const A, B: NativeInt): NativeInt;        {$IFDEF UseInline}inline;{$ENDIF}
function  MaxNatInt(const A, B: NativeInt): NativeInt;        {$IFDEF UseInline}inline;{$ENDIF}
function  MinNatUInt(const A, B: NativeUInt): NativeUInt;     {$IFDEF UseInline}inline;{$ENDIF}
function  MaxNatUInt(const A, B: NativeUInt): NativeUInt;     {$IFDEF UseInline}inline;{$ENDIF}

{ IsInRange returns True if Value is in range of type }
function  IsIntInInt32Range(const Value: Int64): Boolean;     {$IFDEF UseInline}inline;{$ENDIF}
function  IsIntInInt16Range(const Value: Int64): Boolean;     {$IFDEF UseInline}inline;{$ENDIF}
function  IsIntInInt8Range(const Value: Int64): Boolean;      {$IFDEF UseInline}inline;{$ENDIF}

function  IsUIntInInt32Range(const Value: UInt64): Boolean;   {$IFDEF UseInline}inline;{$ENDIF}
function  IsUIntInInt16Range(const Value: UInt64): Boolean;   {$IFDEF UseInline}inline;{$ENDIF}
function  IsUIntInInt8Range(const Value: UInt64): Boolean;    {$IFDEF UseInline}inline;{$ENDIF}

function  IsIntInUInt32Range(const Value: Int64): Boolean;    {$IFDEF UseInline}inline;{$ENDIF}
function  IsIntInUInt16Range(const Value: Int64): Boolean;    {$IFDEF UseInline}inline;{$ENDIF}
function  IsIntInUInt8Range(const Value: Int64): Boolean;     {$IFDEF UseInline}inline;{$ENDIF}

function  IsUIntInUInt32Range(const Value: UInt64): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  IsUIntInUInt16Range(const Value: UInt64): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  IsUIntInUInt8Range(const Value: UInt64): Boolean;   {$IFDEF UseInline}inline;{$ENDIF}



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

procedure FillMem(var Buf; const Count: NativeInt; const Value: Byte); {$IFDEF UseInline}inline;{$ENDIF}
procedure ZeroMem(var Buf; const Count: NativeInt);                    {$IFDEF UseInline}inline;{$ENDIF}
procedure GetZeroMem(var P: Pointer; const Size: NativeInt);           {$IFDEF UseInline}inline;{$ENDIF}

procedure MoveMem(const Source; var Dest; const Count: NativeInt);     {$IFDEF UseInline}inline;{$ENDIF}

function  EqualMem(const Buf1; const Buf2; const Count: NativeInt): Boolean;
function  EqualMemNoAsciiCaseB(const Buf1; const Buf2; const Count: NativeInt): Boolean;
function  EqualMemNoAsciiCaseW(const Buf1; const Buf2; const Count: NativeInt): Boolean;

function  CompareMemB(const Buf1; const Buf2; const Count: NativeInt): Integer;
function  CompareMemW(const Buf1; const Buf2; const Count: NativeInt): Integer;
function  CompareMemNoAsciiCaseB(const Buf1; const Buf2; const Count: NativeInt): Integer;
function  CompareMemNoAsciiCaseW(const Buf1; const Buf2; const Count: NativeInt): Integer;

function  LocateMemB(const Buf1; const Count1: NativeInt; const Buf2; const Count2: NativeInt): NativeInt;
function  LocateMemW(const Buf1; const Count1: NativeInt; const Buf2; const Count2: NativeInt): NativeInt;
function  LocateMemNoAsciiCaseB(const Buf1; const Count1: NativeInt; const Buf2; const Count2: NativeInt): NativeInt;
function  LocateMemNoAsciiCaseW(const Buf1; const Count1: NativeInt; const Buf2; const Count2: NativeInt): NativeInt;

procedure ReverseMem(var Buf; const Size: NativeInt);



{                                                                              }
{ ByteChar ASCII constants                                                     }
{                                                                              }
const
  AsciiNULL = ByteChar(#0);
  AsciiSOH  = ByteChar(#1);
  AsciiSTX  = ByteChar(#2);
  AsciiETX  = ByteChar(#3);
  AsciiEOT  = ByteChar(#4);
  AsciiENQ  = ByteChar(#5);
  AsciiACK  = ByteChar(#6);
  AsciiBEL  = ByteChar(#7);
  AsciiBS   = ByteChar(#8);
  AsciiHT   = ByteChar(#9);
  AsciiLF   = ByteChar(#10);
  AsciiVT   = ByteChar(#11);
  AsciiFF   = ByteChar(#12);
  AsciiCR   = ByteChar(#13);
  AsciiSO   = ByteChar(#14);
  AsciiSI   = ByteChar(#15);
  AsciiDLE  = ByteChar(#16);
  AsciiDC1  = ByteChar(#17);
  AsciiDC2  = ByteChar(#18);
  AsciiDC3  = ByteChar(#19);
  AsciiDC4  = ByteChar(#20);
  AsciiNAK  = ByteChar(#21);
  AsciiSYN  = ByteChar(#22);
  AsciiETB  = ByteChar(#23);
  AsciiCAN  = ByteChar(#24);
  AsciiEM   = ByteChar(#25);
  AsciiEOF  = ByteChar(#26);
  AsciiESC  = ByteChar(#27);
  AsciiFS   = ByteChar(#28);
  AsciiGS   = ByteChar(#29);
  AsciiRS   = ByteChar(#30);
  AsciiUS   = ByteChar(#31);
  AsciiSP   = ByteChar(#32);
  AsciiDEL  = ByteChar(#127);
  AsciiXON  = AsciiDC1;
  AsciiXOFF = AsciiDC3;

  AsciiCRLF = AsciiCR + AsciiLF;

  AsciiDecimalPoint = ByteChar(#46);
  AsciiComma        = ByteChar(#44);
  AsciiBackSlash    = ByteChar(#92);
  AsciiForwardSlash = ByteChar(#47);
  AsciiPercent      = ByteChar(#37);
  AsciiAmpersand    = ByteChar(#38);
  AsciiPlus         = ByteChar(#43);
  AsciiMinus        = ByteChar(#45);
  AsciiEqualSign    = ByteChar(#61);
  AsciiSingleQuote  = ByteChar(#39);
  AsciiDoubleQuote  = ByteChar(#34);

  AsciiDigit0 = ByteChar(#48);
  AsciiDigit9 = ByteChar(#57);
  AsciiUpperA = ByteChar(#65);
  AsciiUpperZ = ByteChar(#90);
  AsciiLowerA = ByteChar(#97);
  AsciiLowerZ = ByteChar(#122);



{                                                                              }
{ ASCII low case lookup                                                        }
{                                                                              }
const
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
{ WideChar ASCII constants                                                     }
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

  {$IFDEF DELPHI5}
  WideCRLF = WideString(#13#10);
  {$ELSE}
  {$IFDEF DELPHI7_DOWN}
  WideCRLF = WideString(WideCR) + WideString(WideLF);
  {$ELSE}
  WideCRLF = WideCR + WideLF;
  {$ENDIF}
  {$ENDIF}



{                                                                              }
{ Character functions                                                          }
{                                                                              }
function  CharCompareB(const A, B: ByteChar): Integer;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharCompareW(const A, B: WideChar): Integer;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharCompare(const A, B: Char): Integer;       {$IFDEF UseInline}inline;{$ENDIF}

function  CharCompareNoAsciiCaseB(const A, B: ByteChar): Integer;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharCompareNoAsciiCaseW(const A, B: WideChar): Integer;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharCompareNoAsciiCase(const A, B: Char): Integer;       {$IFDEF UseInline}inline;{$ENDIF}

function  CharEqualNoAsciiCaseB(const A, B: ByteChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharEqualNoAsciiCaseW(const A, B: WideChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharEqualNoAsciiCase(const A, B: Char): Boolean;       {$IFDEF UseInline}inline;{$ENDIF}

function  CharIsAsciiB(const C: ByteChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharIsAsciiW(const C: WideChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharIsAscii(const C: Char): Boolean;       {$IFDEF UseInline}inline;{$ENDIF}

function  CharIsAsciiUpperCaseB(const C: ByteChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharIsAsciiUpperCaseW(const C: WideChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharIsAsciiUpperCase(const C: Char): Boolean;       {$IFDEF UseInline}inline;{$ENDIF}

function  CharIsAsciiLowerCaseB(const C: ByteChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharIsAsciiLowerCaseW(const C: WideChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharIsAsciiLowerCase(const C: Char): Boolean;       {$IFDEF UseInline}inline;{$ENDIF}

function  CharAsciiLowCaseB(const C: ByteChar): ByteChar;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharAsciiLowCaseW(const C: WideChar): WideChar;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharAsciiLowCase(const C: Char): Char;           {$IFDEF UseInline}inline;{$ENDIF}

function  CharAsciiUpCaseB(const C: ByteChar): ByteChar;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharAsciiUpCaseW(const C: WideChar): WideChar;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharAsciiUpCase(const C: Char): Char;           {$IFDEF UseInline}inline;{$ENDIF}

function  CharAsciiHexValueB(const C: ByteChar): Integer;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharAsciiHexValueW(const C: WideChar): Integer;  {$IFDEF UseInline}inline;{$ENDIF}

function  CharAsciiIsHexB(const C: ByteChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharAsciiIsHexW(const C: WideChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}



{                                                                              }
{ String construction from buffer                                              }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrPToStrA(const P: PAnsiChar; const L: NativeInt): AnsiString;
{$ENDIF}
function  StrPToStrB(const P: Pointer; const L: NativeInt): RawByteString;
function  StrPToStrU(const P: PWideChar; const L: NativeInt): UnicodeString;
function  StrPToStr(const P: PChar; const L: NativeInt): String;

function  StrZLenA(const S: Pointer): NativeInt;
function  StrZLenW(const S: PWideChar): NativeInt;
function  StrZLen(const S: PChar): NativeInt;

{$IFDEF SupportAnsiString}
function  StrZPasA(const A: PAnsiChar): AnsiString;
{$ENDIF}
function  StrZPasB(const A: PByteChar): RawByteString;
function  StrZPasU(const A: PWideChar): UnicodeString;
function  StrZPas(const A: PChar): String;



{                                                                              }
{ RawByteString conversion functions                                           }
{                                                                              }
procedure RawByteBufToWideBuf(const Buf: Pointer; const BufSize: NativeInt; const DestBuf: Pointer);
function  RawByteStrPtrToUnicodeString(const S: Pointer; const Len: NativeInt): UnicodeString;
function  RawByteStringToUnicodeString(const S: RawByteString): UnicodeString;

procedure WideBufToRawByteBuf(const Buf: Pointer; const Len: NativeInt; const DestBuf: Pointer);
function  WideBufToRawByteString(const P: PWideChar; const Len: NativeInt): RawByteString;

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
{ String functions                                                             }
{                                                                              }
{ Compare returns:                                                             }
{            -1  if A < B                                                      }
{             0  if A = B                                                      }
{             1  if A > B                                                      }
{                                                                              }
function  StrPCompareB(const A, B: Pointer; const Len: NativeInt): Integer;    {$IFDEF UseInline}inline;{$ENDIF}
function  StrPCompareW(const A, B: PWideChar; const Len: NativeInt): Integer;  {$IFDEF UseInline}inline;{$ENDIF}
function  StrPCompare(const A, B: PChar; const Len: NativeInt): Integer;       {$IFDEF UseInline}inline;{$ENDIF}

function  StrPCompareNoAsciiCaseB(const A, B: Pointer; const Len: NativeInt): Integer;    {$IFDEF UseInline}inline;{$ENDIF}
function  StrPCompareNoAsciiCaseW(const A, B: PWideChar; const Len: NativeInt): Integer;  {$IFDEF UseInline}inline;{$ENDIF}
function  StrPCompareNoAsciiCase(const A, B: PChar; const Len: NativeInt): Integer;       {$IFDEF UseInline}inline;{$ENDIF}

function  StrPEqualB(const A, B: Pointer; const Len: NativeInt): Boolean;    {$IFDEF UseInline}inline;{$ENDIF}
function  StrPEqualW(const A, B: PWideChar; const Len: NativeInt): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  StrPEqual(const A, B: PChar; const Len: NativeInt): Boolean;       {$IFDEF UseInline}inline;{$ENDIF}

function  StrPEqualNoAsciiCaseB(const A, B: Pointer; const Len: NativeInt): Boolean;    {$IFDEF UseInline}inline;{$ENDIF}
function  StrPEqualNoAsciiCaseW(const A, B: PWideChar; const Len: NativeInt): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  StrPEqualNoAsciiCase(const A, B: PChar; const Len: NativeInt): Boolean;       {$IFDEF UseInline}inline;{$ENDIF}

{$IFDEF SupportAnsiString}
function  StrCompareA(const A, B: AnsiString): Integer;
{$ENDIF}
function  StrCompareB(const A, B: RawByteString): Integer;
function  StrCompareU(const A, B: UnicodeString): Integer;
function  StrCompare(const A, B: String): Integer;

{$IFDEF SupportAnsiString}
function  StrCompareNoAsciiCaseA(const A, B: AnsiString): Integer;
{$ENDIF}
function  StrCompareNoAsciiCaseB(const A, B: RawByteString): Integer;
function  StrCompareNoAsciiCaseU(const A, B: UnicodeString): Integer;
function  StrCompareNoAsciiCase(const A, B: String): Integer;

function  StrEqualNoAsciiCaseB(const A, B: RawByteString): Boolean;
function  StrEqualNoAsciiCaseU(const A, B: UnicodeString): Boolean;
function  StrEqualNoAsciiCase(const A, B: String): Boolean;

function  StrStartsWithB(const A, B: RawByteString): Boolean;
function  StrStartsWithU(const A, B: UnicodeString): Boolean;
function  StrStartsWith(const A, B: String): Boolean;

function  StrStartsWithNoAsciiCaseB(const A, B: RawByteString): Boolean;
function  StrStartsWithNoAsciiCaseU(const A, B: UnicodeString): Boolean;
function  StrStartsWithNoAsciiCase(const A, B: String): Boolean;

function  StrEndsWithB(const A, B: RawByteString): Boolean;
function  StrEndsWithU(const A, B: UnicodeString): Boolean;
function  StrEndsWith(const A, B: String): Boolean;

function  StrEndsWithNoAsciiCaseB(const A, B: RawByteString): Boolean;
function  StrEndsWithNoAsciiCaseU(const A, B: UnicodeString): Boolean;
function  StrEndsWithNoAsciiCase(const A, B: String): Boolean;

function  StrPosB(const S, M: RawByteString): Int32;  {$IFDEF UseInline}inline;{$ENDIF}
function  StrPosU(const S, M: UnicodeString): Int32;  {$IFDEF UseInline}inline;{$ENDIF}
function  StrPos(const S, M: String): Int32;          {$IFDEF UseInline}inline;{$ENDIF}

function  StrPosNoAsciiCaseB(const S, M: RawByteString): Int32;  {$IFDEF UseInline}inline;{$ENDIF}
function  StrPosNoAsciiCaseU(const S, M: UnicodeString): Int32;  {$IFDEF UseInline}inline;{$ENDIF}
function  StrPosNoAsciiCase(const S, M: String): Int32;          {$IFDEF UseInline}inline;{$ENDIF}

{$IFDEF SupportAnsiString}
function  StrAsciiUpperCaseA(const S: AnsiString): AnsiString;
{$ENDIF}
function  StrAsciiUpperCaseB(const S: RawByteString): RawByteString;
function  StrAsciiUpperCaseU(const S: UnicodeString): UnicodeString;
function  StrAsciiUpperCase(const S: String): String;  {$IFDEF UseInline}inline;{$ENDIF}

procedure StrAsciiConvertUpperCaseB(var S: RawByteString);
procedure StrAsciiConvertUpperCaseU(var S: UnicodeString);
procedure StrAsciiConvertUpperCase(var S: String);     {$IFDEF UseInline}inline;{$ENDIF}

{$IFDEF SupportAnsiString}
function  StrAsciiLowerCaseA(const S: AnsiString): AnsiString;
{$ENDIF}
function  StrAsciiLowerCaseB(const S: RawByteString): RawByteString;
function  StrAsciiLowerCaseU(const S: UnicodeString): UnicodeString;
function  StrAsciiLowerCase(const S: String): String;  {$IFDEF UseInline}inline;{$ENDIF}

procedure StrAsciiConvertLowerCaseB(var S: RawByteString);
procedure StrAsciiConvertLowerCaseU(var S: UnicodeString);
procedure StrAsciiConvertLowerCase(var S: String);     {$IFDEF UseInline}inline;{$ENDIF}

procedure StrAsciiConvertFirstUpB(var S: RawByteString);
procedure StrAsciiConvertFirstUpU(var S: UnicodeString);
procedure StrAsciiConvertFirstUp(var S: String);

function  StrAsciiFirstUpB(const S: RawByteString): RawByteString;  {$IFDEF UseInline}inline;{$ENDIF}
function  StrAsciiFirstUpU(const S: UnicodeString): UnicodeString;  {$IFDEF UseInline}inline;{$ENDIF}
function  StrAsciiFirstUp(const S: String): String;                 {$IFDEF UseInline}inline;{$ENDIF}

function  IsAsciiBufB(const Buf: Pointer; const Len: NativeInt): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  IsAsciiBufW(const Buf: Pointer; const Len: NativeInt): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}

function  IsAsciiStringB(const S: RawByteString): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  IsAsciiStringU(const S: UnicodeString): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  IsAsciiString(const S: String): Boolean;          {$IFDEF UseInline}inline;{$ENDIF}



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
          const FalseValue: AnsiString = ''): AnsiString;                 {$IFDEF UseInline}inline;{$ENDIF}
{$ENDIF}
function  iifB(const Expr: Boolean; const TrueValue: RawByteString;
          const FalseValue: RawByteString = ''): RawByteString;           {$IFDEF UseInline}inline;{$ENDIF}
function  iifU(const Expr: Boolean; const TrueValue: UnicodeString;
          const FalseValue: UnicodeString = ''): UnicodeString;           {$IFDEF UseInline}inline;{$ENDIF}
function  iif(const Expr: Boolean; const TrueValue: String;
          const FalseValue: String = ''): String; overload;               {$IFDEF UseInline}inline;{$ENDIF}
function  iif(const Expr: Boolean; const TrueValue: TObject;
          const FalseValue: TObject = nil): TObject; overload;            {$IFDEF UseInline}inline;{$ENDIF}



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

function  InverseCompareResult(const C: TCompareResult): TCompareResult;



{                                                                              }
{ Direct comparison                                                            }
{                                                                              }
{   Compare(I1, I2) returns crLess if I1 < I2, crEqual if I1 = I2 or           }
{   crGreater if I1 > I2.                                                      }
{                                                                              }
function  Compare(const I1, I2: Boolean): TCompareResult; overload;
function  Compare(const I1, I2: Integer): TCompareResult; overload;
function  Compare(const I1, I2: Int64): TCompareResult; overload;
function  Compare(const I1, I2: Double): TCompareResult; overload;
{$IFDEF SupportAnsiString}
function  CompareA(const I1, I2: AnsiString): TCompareResult;
{$ENDIF}
function  CompareB(const I1, I2: RawByteString): TCompareResult;
function  CompareU(const I1, I2: UnicodeString): TCompareResult;
function  CompareChB(const I1, I2: ByteChar): TCompareResult;
function  CompareChW(const I1, I2: WideChar): TCompareResult;

function  Sgn(const A: Int64): Integer; overload;
function  Sgn(const A: Double): Integer; overload;



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

function  ByteCharDigitToInt(const A: ByteChar): Integer;                       {$IFDEF UseInline}inline;{$ENDIF}
function  WideCharDigitToInt(const A: WideChar): Integer;                       {$IFDEF UseInline}inline;{$ENDIF}
function  CharDigitToInt(const A: Char): Integer;                               {$IFDEF UseInline}inline;{$ENDIF}

function  IntToByteCharDigit(const A: Integer): ByteChar;                       {$IFDEF UseInline}inline;{$ENDIF}
function  IntToWideCharDigit(const A: Integer): WideChar;                       {$IFDEF UseInline}inline;{$ENDIF}
function  IntToCharDigit(const A: Integer): Char;                               {$IFDEF UseInline}inline;{$ENDIF}

function  IsHexByteCharDigit(const Ch: ByteChar): Boolean;
function  IsHexWideCharDigit(const Ch: WideChar): Boolean;
function  IsHexCharDigit(const Ch: Char): Boolean;                              {$IFDEF UseInline}inline;{$ENDIF}

function  HexByteCharDigitToInt(const A: ByteChar): Integer;
function  HexWideCharDigitToInt(const A: WideChar): Integer;
function  HexCharDigitToInt(const A: Char): Integer;                            {$IFDEF UseInline}inline;{$ENDIF}

function  IntToUpperHexByteCharDigit(const A: Integer): ByteChar;
function  IntToUpperHexWideCharDigit(const A: Integer): WideChar;
function  IntToUpperHexCharDigit(const A: Integer): Char;                       {$IFDEF UseInline}inline;{$ENDIF}

function  IntToLowerHexByteCharDigit(const A: Integer): ByteChar;
function  IntToLowerHexWideCharDigit(const A: Integer): WideChar;
function  IntToLowerHexCharDigit(const A: Integer): Char;                       {$IFDEF UseInline}inline;{$ENDIF}

{$IFDEF SupportAnsiString}
function  IntToStringA(const A: Int64): AnsiString;
{$ENDIF}
function  IntToStringB(const A: Int64): RawByteString;
function  IntToStringU(const A: Int64): UnicodeString;
function  IntToString(const A: Int64): String;

{$IFDEF SupportAnsiString}
function  UIntToStringA(const A: UInt64): AnsiString;
{$ENDIF}
function  UIntToStringB(const A: UInt64): RawByteString;
function  UIntToStringU(const A: UInt64): UnicodeString;
function  UIntToString(const A: UInt64): String;

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
function  TryStringToUInt64A(const S: AnsiString; out A: UInt64): Boolean;
{$ENDIF}
function  TryStringToUInt64B(const S: RawByteString; out A: UInt64): Boolean;
function  TryStringToUInt64U(const S: UnicodeString; out A: UInt64): Boolean;
function  TryStringToUInt64(const S: String; out A: UInt64): Boolean;

{$IFDEF SupportAnsiString}
function  StringToInt64DefA(const S: AnsiString; const Default: Int64): Int64;
{$ENDIF}
function  StringToInt64DefB(const S: RawByteString; const Default: Int64): Int64;
function  StringToInt64DefU(const S: UnicodeString; const Default: Int64): Int64;
function  StringToInt64Def(const S: String; const Default: Int64): Int64;

{$IFDEF SupportAnsiString}
function  StringToUInt64DefA(const S: AnsiString; const Default: UInt64): UInt64;
{$ENDIF}
function  StringToUInt64DefB(const S: RawByteString; const Default: UInt64): UInt64;
function  StringToUInt64DefU(const S: UnicodeString; const Default: UInt64): UInt64;
function  StringToUInt64Def(const S: String; const Default: UInt64): UInt64;

{$IFDEF SupportAnsiString}
function  StringToInt64A(const S: AnsiString): Int64;
{$ENDIF}
function  StringToInt64B(const S: RawByteString): Int64;
function  StringToInt64U(const S: UnicodeString): Int64;
function  StringToInt64(const S: String): Int64;

{$IFDEF SupportAnsiString}
function  StringToUInt64A(const S: AnsiString): UInt64;
{$ENDIF}
function  StringToUInt64B(const S: RawByteString): UInt64;
function  StringToUInt64U(const S: UnicodeString): UInt64;
function  StringToUInt64(const S: String): UInt64;

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
function  HexToUIntA(const S: AnsiString): UInt64;
{$ENDIF}
function  HexToUIntB(const S: RawByteString): UInt64;
function  HexToUIntU(const S: UnicodeString): UInt64;
function  HexToUInt(const S: String): UInt64;

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
function  BytesToHexA(const P: Pointer; const Count: NativeInt;
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
function  HashBuf(const Hash: Word32; const Buf; const BufSize: NativeInt): Word32;

{$IFDEF SupportAnsiString}
function  HashStrA(const S: AnsiString;
          const Index: NativeInt = 1; const Count: NativeInt = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: Word32 = 0): Word32;
{$ENDIF}
function  HashStrB(const S: RawByteString;
          const Index: NativeInt = 1; const Count: NativeInt = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: Word32 = 0): Word32;
function  HashStrU(const S: UnicodeString;
          const Index: NativeInt = 1; const Count: NativeInt = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: Word32 = 0): Word32;
function  HashStr(const S: String;
          const Index: NativeInt = 1; const Count: NativeInt = -1;
          const AsciiCaseSensitive: Boolean = True;
          const Slots: Word32 = 0): Word32;

function  HashInteger(const I: Integer; const Slots: Word32 = 0): Word32;
function  HashNativeUInt(const I: NativeUInt; const Slots: Word32): Word32;
function  HashWord32(const I: Word32; const Slots: Word32 = 0): Word32;



{                                                                              }
{ Dynamic arrays                                                               }
{                                                                              }
procedure FreeObjectArray(var V); overload;
procedure FreeObjectArray(var V; const LoIdx, HiIdx: Integer); overload;
procedure FreeAndNilObjectArray(var V: ObjectArray);



{                                                                              }
{ TBytes functions                                                             }
{                                                                              }
procedure BytesSetLengthAndZero(var V: TBytes; const NewLength: NativeInt);

procedure BytesInit(var V: TBytes; const R: Byte); overload;
procedure BytesInit(var V: TBytes; const S: String); overload;
procedure BytesInit(var V: TBytes; const S: array of Byte); overload;

function  BytesAppend(var V: TBytes; const R: Byte): NativeInt; overload;
function  BytesAppend(var V: TBytes; const R: TBytes): NativeInt; overload;
function  BytesAppend(var V: TBytes; const R: array of Byte): NativeInt; overload;
function  BytesAppend(var V: TBytes; const R: String): NativeInt; overload;

function  BytesCompare(const A, B: TBytes): Integer;

function  BytesEqual(const A, B: TBytes): Boolean;



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
constructor ERangeCheckError.Create;
begin
  inherited Create('Range check error');
end;



{                                                                              }
{ Integer                                                                      }
{                                                                              }
function MinInt(const A, B: Int64): Int64;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function MaxInt(const A, B: Int64): Int64;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function MinUInt(const A, B: UInt64): UInt64;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function MaxUInt(const A, B: UInt64): UInt64;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function MinNatInt(const A, B: NativeInt): NativeInt;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function MaxNatInt(const A, B: NativeInt): NativeInt;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function MinNatUInt(const A, B: NativeUInt): NativeUInt;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function MaxNatUInt(const A, B: NativeUInt): NativeUInt;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function IsIntInInt32Range(const Value: Int64): Boolean;
begin
  Result := (Value >= MinInt32) and (Value <= MaxInt32);
end;

function IsIntInInt16Range(const Value: Int64): Boolean;
begin
  Result := (Value >= MinInt16) and (Value <= MaxInt16);
end;

function IsIntInInt8Range(const Value: Int64): Boolean;
begin
  Result := (Value >= MinInt8) and (Value <= MaxInt8);
end;

function IsUIntInInt32Range(const Value: UInt64): Boolean;
begin
  Result := Value <= MaxInt32;
end;

function IsUIntInInt16Range(const Value: UInt64): Boolean;
begin
  Result := Value <= MaxInt16;
end;

function IsUIntInInt8Range(const Value: UInt64): Boolean;
begin
  Result := Value <= MaxInt8;
end;

function IsIntInUInt32Range(const Value: Int64): Boolean;
begin
  Result := (Value >= MinUInt32) and (Value <= MaxUInt32);
end;

function IsIntInUInt16Range(const Value: Int64): Boolean;
begin
  Result := (Value >= MinUInt16) and (Value <= MaxUInt16);
end;

function IsIntInUInt8Range(const Value: Int64): Boolean;
begin
  Result := (Value >= MinUInt8) and (Value <= MaxUInt8);
end;

function IsUIntInUInt32Range(const Value: UInt64): Boolean;
begin
  Result := Value <= MaxUInt32;
end;

function IsUIntInUInt16Range(const Value: UInt64): Boolean;
begin
  Result := Value <= MaxUInt16;
end;

function IsUIntInUInt8Range(const Value: UInt64): Boolean;
begin
  Result := Value <= MaxUInt8;
end;



{                                                                              }
{ Memory                                                                       }
{                                                                              }
{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}

procedure FillMem(var Buf; const Count: NativeInt; const Value: Byte);
begin
  FillChar(Buf, Count, Value);
end;

procedure ZeroMem(var Buf; const Count: NativeInt);
begin
  FillChar(Buf, Count, #0);
end;

procedure GetZeroMem(var P: Pointer; const Size: NativeInt);
begin
  GetMem(P, Size);
  ZeroMem(P^, Size);
end;

procedure MoveMem(const Source; var Dest; const Count: NativeInt);
begin
  Move(Source, Dest, Count);
end;

function EqualMem24(const Buf1; const Buf2): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
var
  P : Pointer;
  Q : Pointer;
begin
  P := @Buf1;
  Q := @Buf2;
  if PWord16(P)^ = PWord16(Q)^ then
    begin
      Inc(PWord16(P));
      Inc(PWord16(Q));
      Result := PByte(P)^ = PByte(Q)^;
    end
  else
    Result := False;
end;

function EqualMemTo64(const Buf1; const Buf2; const Count: Byte): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
var
  P : Pointer;
  Q : Pointer;
begin
  P := @Buf1;
  Q := @Buf2;
  case Count of
    0 : Result := True;
    1 : Result := PByte(P)^ = PByte(Q)^;
    2 : Result := PWord16(P)^ = PWord16(Q)^;
    3 : Result := EqualMem24(P^, Q^);
    4 : Result := PWord32(P)^ = PWord32(Q)^;
    5 : begin
          Result := PWord32(P)^ = PWord32(Q)^;
          if Result then
            begin
              Inc(PWord32(P));
              Inc(PWord32(Q));
              Result := PByte(P)^ = PByte(Q)^;
            end;
        end;
    6 : begin
          Result := PWord32(P)^ = PWord32(Q)^;
          if Result then
            begin
              Inc(PWord32(P));
              Inc(PWord32(Q));
              Result := PWord16(P)^ = PWord16(Q)^;
            end;
        end;
    7 : begin
          Result := PWord32(P)^ = PWord32(Q)^;
          if Result then
            begin
              Inc(PWord32(P));
              Inc(PWord32(Q));
              Result := EqualMem24(P^, Q^);
            end;
        end;
    8 : Result := PWord64(P)^ = PWord64(Q)^;
  else
    Result := False;
  end;
end;

function EqualMem(const Buf1; const Buf2; const Count: NativeInt): Boolean;
var
  P : Pointer;
  Q : Pointer;
  I : NativeInt;
begin
  if Count <= 0 then
    begin
      Result := True;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  if P = Q then
    begin
      Result := True;
      exit;
    end;
  if Count <= 8 then
    begin
      Result := EqualMemTo64(P^, Q^, Byte(Count));
      exit;
    end;
  I := Count;
  while I >= SizeOf(Word64) do
    if PWord64(P)^ = PWord64(Q)^ then
      begin
        Inc(PWord64(P));
        Inc(PWord64(Q));
        Dec(I, SizeOf(Word64));
      end
    else
      begin
        Result := False;
        exit;
      end;
  if I > 0 then
    begin
      Assert(I < SizeOf(Word64));
      Result := EqualMemTo64(P^, Q^, Byte(I));
    end
  else
    Result := True;
end;

function EqualWord8NoAsciiCaseB(const A, B: Byte): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
var
  C, D : Byte;
begin
  if A = B then
    Result := True
  else
    begin
      C := A;
      D := B;
      if C in [Ord('A')..Ord('Z')] then
        Inc(C, 32);
      if D in [Ord('A')..Ord('Z')] then
        Inc(D, 32);
      if C = D then
        Result := True
      else
        Result := False;
    end;
end;

function EqualWord16NoAsciiCaseB(const A, B: Word16): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
begin
  if A = B then
    Result := True
  else
    Result :=
        EqualWord8NoAsciiCaseB(Byte(A), Byte(B)) and
        EqualWord8NoAsciiCaseB(Byte(A shr 8), Byte(B shr 8));
end;

function EqualWord32NoAsciiCaseB(const A, B: Word32): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
begin
  if A = B then
    Result := True
  else
    Result :=
        EqualWord16NoAsciiCaseB(Word16(A), Word16(B)) and
        EqualWord16NoAsciiCaseB(Word16(A shr 16), Word16(B shr 16));
end;

function EqualWord64NoAsciiCaseB(const A, B: Word64): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
begin
  if A = B then
    Result := True
  else
    Result :=
        EqualWord32NoAsciiCaseB(Word32(A), Word32(B)) and
        EqualWord32NoAsciiCaseB(Word32(A shr 32), Word32(B shr 32));
end;

function EqualMemTo64NoAsciiCaseB(const Buf1; const Buf2; const Count: Byte): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
var
  P : Pointer;
  Q : Pointer;
begin
  P := @Buf1;
  Q := @Buf2;
  case Count of
    0 : Result := True;
    1 : Result := EqualWord8NoAsciiCaseB(PByte(P)^, PByte(Q)^);
    2 : Result := EqualWord16NoAsciiCaseB(PWord16(P)^, PWord16(Q)^);
    3 : begin
          if EqualWord16NoAsciiCaseB(PWord16(P)^, PWord16(Q)^) then
            begin
              Inc(PWord16(P));
              Inc(PWord16(Q));
              Result := EqualWord8NoAsciiCaseB(PByte(P)^, PByte(Q)^);
            end
          else
            Result := False;
        end;
    4 : Result := EqualWord32NoAsciiCaseB(PWord32(P)^, PWord32(Q)^);
    5 : begin
          if EqualWord32NoAsciiCaseB(PWord32(P)^, PWord32(Q)^) then
            begin
              Inc(PWord32(P));
              Inc(PWord32(Q));
              Result := EqualWord8NoAsciiCaseB(PByte(P)^, PByte(Q)^);
            end
          else
            Result := False;
        end;
    6 : begin
          if EqualWord32NoAsciiCaseB(PWord32(P)^, PWord32(Q)^) then
            begin
              Inc(PWord32(P));
              Inc(PWord32(Q));
              Result := EqualWord16NoAsciiCaseB(PWord16(P)^, PWord16(Q)^);
            end
          else
            Result := False;
        end;
    7 : begin
          if EqualWord32NoAsciiCaseB(PWord32(P)^, PWord32(Q)^) then
            begin
              Inc(PWord32(P));
              Inc(PWord32(Q));
              if EqualWord16NoAsciiCaseB(PWord16(P)^, PWord16(Q)^) then
                begin
                  Inc(PWord16(P));
                  Inc(PWord16(Q));
                  Result := EqualWord8NoAsciiCaseB(PByte(P)^, PByte(Q)^);
                end
              else
                Result := False;
            end
          else
            Result := False;
        end;
    8 : Result := EqualWord64NoAsciiCaseB(PWord64(P)^, PWord64(Q)^);
  else
    Result := False;
  end;
end;

function EqualMemNoAsciiCaseB(const Buf1; const Buf2; const Count: NativeInt): Boolean;
var
  P, Q : Pointer;
  I    : NativeInt;
begin
  if Count <= 0 then
    begin
      Result := True;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  if P = Q then
    begin
      Result := True;
      exit;
    end;
  if Count <= 8 then
    begin
      Result := EqualMemTo64NoAsciiCaseB(P^, Q^, Byte(Count));
      exit;
    end;
  I := Count;
  while I >= SizeOf(Word64) do
    begin
      if not EqualWord64NoAsciiCaseB(PWord64(P)^, PWord64(Q)^) then
        begin
          Result := False;
          exit;
        end;
      Inc(PWord64(P));
      Inc(PWord64(Q));
      Dec(I, SizeOf(Word64));
    end;
  if I > 0 then
    begin
      Assert(I < SizeOf(Word64));
      Result := EqualMemTo64NoAsciiCaseB(P^, Q^, Byte(I));
    end
  else
    Result := True;
end;

function EqualWord16NoAsciiCaseW(const A, B: Word16): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
var
  C, D : Word16;
begin
  if A = B then
    Result := True
  else
    begin
      C := A;
      D := B;
      if C in [Ord('A')..Ord('Z')] then
        Inc(C, 32);
      if D in [Ord('A')..Ord('Z')] then
        Inc(D, 32);
      if C = D then
        Result := True
      else
        Result := False;
    end;
end;

function EqualWord32NoAsciiCaseW(const A, B: Word32): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
begin
  if A = B then
    Result := True
  else
    Result :=
        EqualWord16NoAsciiCaseW(Word16(A), Word16(B)) and
        EqualWord16NoAsciiCaseW(Word16(A shr 16), Word16(B shr 16));
end;

function EqualWord64NoAsciiCaseW(const A, B: Word64): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
begin
  if A = B then
    Result := True
  else
    Result :=
        EqualWord32NoAsciiCaseW(Word32(A), Word32(B)) and
        EqualWord32NoAsciiCaseW(Word32(A shr 32), Word32(B shr 32));
end;

function EqualMemTo64NoAsciiCaseW(const P: Pointer; const Q: Pointer; const Count: Byte): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
var
  A, B : PByte;
begin
  case Count of
    0 : Result := True;
    1 : begin
          Result := EqualWord16NoAsciiCaseW(PWord16(P)^, PWord16(Q)^);
          exit;
        end;
    2 : begin
          Result := EqualWord32NoAsciiCaseW(PWord32(P)^, PWord32(Q)^);
          exit;
        end;
    3 : begin
          if EqualWord32NoAsciiCaseW(PWord32(P)^, PWord32(Q)^) then
            begin
              A := P;
              B := Q;
              Inc(PWord32(A));
              Inc(PWord32(B));
              Result := EqualWord16NoAsciiCaseW(PWord16(A)^, PWord16(B)^);
            end
          else
            Result := False;
          exit;
        end;
    4 : begin
          Result := EqualWord64NoAsciiCaseW(PWord64(P)^, PWord64(Q)^);
          exit;
        end;
  else
    Result := False;
  end;
end;

function EqualMemNoAsciiCaseW(const Buf1; const Buf2; const Count: NativeInt): Boolean;
var
  P, Q : Pointer;
  I    : NativeInt;
begin
  if Count <= 0 then
    begin
      Result := True;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  if P = Q then
    begin
      Result := True;
      exit;
    end;
  if Count <= 4 then
    begin
      Result := EqualMemTo64NoAsciiCaseW(P, Q, Byte(Count));
      exit;
    end;
  I := Count;
  while I >= SizeOf(Word64) div SizeOf(WideChar) do
    begin
      if not EqualWord64NoAsciiCaseW(PWord64(P)^, PWord64(Q)^) then
        begin
          Result := False;
          exit;
        end;
      Inc(PWord64(P));
      Inc(PWord64(Q));
      Dec(I, SizeOf(Word64) div SizeOf(WideChar));
    end;
  if I > 0 then
    begin
      Assert(I < SizeOf(Word64) div SizeOf(WideChar));
      Result := EqualMemTo64NoAsciiCaseW(P, Q, Byte(I));
    end
  else
    Result := True;
end;

function CompareMemB(const Buf1; const Buf2; const Count: NativeInt): Integer;
var
  P, Q : Pointer;
  I    : NativeInt;
  C, D : Byte;
begin
  if Count <= 0 then
    begin
      Result := 0;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  if P = Q then
    begin
      Result := 0;
      exit;
    end;
  I := Count;
  while I >= SizeOf(Word64) do
    if PWord64(P)^ = PWord64(Q)^ then
      begin
        Inc(PWord64(P));
        Inc(PWord64(Q));
        Dec(I, SizeOf(Word64));
      end
    else
      break;
  while I > 0 do
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
      Dec(I);
    end;
  Result := 0;
end;

function CompareMemW(const Buf1; const Buf2; const Count: NativeInt): Integer;
var
  P, Q : Pointer;
  I    : NativeInt;
  C, D : Word16;
begin
  if Count <= 0 then
    begin
      Result := 0;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  if P = Q then
    begin
      Result := 0;
      exit;
    end;
  I := Count;
  while I >= SizeOf(Word64) div SizeOf(WideChar) do
    if PWord64(P)^ = PWord64(Q)^ then
      begin
        Inc(PWord64(P));
        Inc(PWord64(Q));
        Dec(I, SizeOf(Word64) div SizeOf(WideChar));
      end
    else
      break;
  while I > 0 do
    begin
      C := PWord16(P)^;
      D := PWord16(Q)^;
      if C = D then
        begin
          Inc(PWord16(P));
          Inc(PWord16(Q));
        end
      else
        begin
          if C < D then
            Result := -1
          else
            Result := 1;
          exit;
        end;
      Dec(I);
    end;
  Result := 0;
end;

function CompareMemNoAsciiCaseB(const Buf1; const Buf2; const Count: NativeInt): Integer;
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
  if P = Q then
    begin
      Result := 0;
      exit;
    end;
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

function CompareMemNoAsciiCaseW(const Buf1; const Buf2; const Count: NativeInt): Integer;
var P, Q : Pointer;
    I    : Integer;
    C, D : Word16;
begin
  if Count <= 0 then
    begin
      Result := 0;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  if P = Q then
    begin
      Result := 0;
      exit;
    end;
  for I := 1 to Count do
    begin
      C := PWord16(P)^;
      D := PWord16(Q)^;
      if (C >= Ord('A')) and (C <= Ord('Z')) then
        C := C or 32;
      if (D >= Ord('A')) and (D <= Ord('Z')) then
        D := D or 32;
      if C = D then
        begin
          Inc(PWord16(P));
          Inc(PWord16(Q));
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

function LocateMemB(const Buf1; const Count1: NativeInt; const Buf2; const Count2: NativeInt): NativeInt;
var
  P, Q : PByte;
  I    : NativeInt;
begin
  if (Count1 <= 0) or (Count2 <= 0) or (Count2 > Count1) then
    begin
      Result := -1;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  for I := 0 to Count1 - Count2 do
    begin
      if P = Q then
        begin
          Result := I;
          exit;
        end;
      if EqualMem(P^, Q^, Count2) then
        begin
          Result := I;
          exit;
        end;
      Inc(P);
    end;
  Result := -1;
end;

function LocateMemW(const Buf1; const Count1: NativeInt; const Buf2; const Count2: NativeInt): NativeInt;
var
  P, Q : PWord16;
  I    : NativeInt;
begin
  if (Count1 <= 0) or (Count2 <= 0) or (Count2 > Count1) then
    begin
      Result := -1;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  for I := 0 to Count1 - Count2 do
    begin
      if P = Q then
        begin
          Result := I;
          exit;
        end;
      if EqualMem(P^, Q^, Count2 * SizeOf(WideChar)) then
        begin
          Result := I;
          exit;
        end;
      Inc(P);
    end;
  Result := -1;
end;

function LocateMemNoAsciiCaseB(const Buf1; const Count1: NativeInt; const Buf2; const Count2: NativeInt): NativeInt;
var
  P, Q : PByte;
  I    : NativeInt;
begin
  if (Count1 <= 0) or (Count2 <= 0) or (Count2 > Count1) then
    begin
      Result := -1;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  for I := 0 to Count1 - Count2 do
    begin
      if P = Q then
        begin
          Result := I;
          exit;
        end;
      if EqualMemNoAsciiCaseB(P^, Q^, Count2) then
        begin
          Result := I;
          exit;
        end;
      Inc(P);
    end;
  Result := -1;
end;

function LocateMemNoAsciiCaseW(const Buf1; const Count1: NativeInt; const Buf2; const Count2: NativeInt): NativeInt;
var
  P, Q : PWord16;
  I    : NativeInt;
begin
  if (Count1 <= 0) or (Count2 <= 0) or (Count2 > Count1) then
    begin
      Result := -1;
      exit;
    end;
  P := @Buf1;
  Q := @Buf2;
  for I := 0 to Count1 - Count2 do
    begin
      if P = Q then
        begin
          Result := I;
          exit;
        end;
      if EqualMemNoAsciiCaseW(P^, Q^, Count2) then
        begin
          Result := I;
          exit;
        end;
      Inc(P);
    end;
  Result := -1;
end;

procedure ReverseMem(var Buf; const Size: NativeInt);
var
  I : NativeInt;
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
{$IFDEF QOn}{$Q+}{$ENDIF}



{                                                                              }
{ Character compare functions                                                  }
{                                                                              }
function CharCompareB(const A, B: ByteChar): Integer;
begin
  if Ord(A) = Ord(B) then
    Result := 0
  else
  if Ord(A) < Ord(B) then
    Result := -1
  else
    Result := 1;
end;

function CharCompareW(const A, B: WideChar): Integer;
begin
  if Ord(A) = Ord(B) then
    Result := 0
  else
  if Ord(A) < Ord(B) then
    Result := -1
  else
    Result := 1;
end;

function CharCompare(const A, B: Char): Integer;
begin
  {$IFDEF CharIsWide}
  Result := CharCompareW(A, B);
  {$ELSE}
  Result := CharCompareB(A, B);
  {$ENDIF}
end;

function CharCompareNoAsciiCaseB(const A, B: ByteChar): Integer;
var
  C, D : Byte;
begin
  C := Byte(A);
  D := Byte(B);
  if C = D then
    Result := 0
  else
    begin
      if C in [Ord('A')..Ord('Z')] then
        Inc(C, 32);
      if D in [Ord('A')..Ord('Z')] then
        Inc(D, 32);
      if C = D then
        Result := 0
      else
      if C < D then
        Result := -1
      else
        Result := 1;
    end;
end;

function CharCompareNoAsciiCaseW(const A, B: WideChar): Integer;
var
  C, D : Word16;
begin
  C := Word16(A);
  D := Word16(B);
  if C = D then
    Result := 0
  else
    begin
      case C of
        Ord('A')..Ord('Z') : Inc(C, 32);
      end;
      case D of
        Ord('A')..Ord('Z') : Inc(D, 32);
      end;
      if C = D then
        Result := 0
      else
      if C < D then
        Result := -1
      else
        Result := 1;
    end;
end;

function CharCompareNoAsciiCase(const A, B: Char): Integer;
begin
  {$IFDEF StringIsUnicode}
  Result := CharCompareNoAsciiCaseW(A, B);
  {$ELSE}
  Result := CharCompareNoAsciiCaseB(A, B);
  {$ENDIF}
end;

function CharEqualNoAsciiCaseB(const A, B: ByteChar): Boolean;
var
  C, D : Byte;
begin
  C := Byte(A);
  D := Byte(B);
  if C = D then
    Result := True
  else
    begin
      if C in [Ord('A')..Ord('Z')] then
        Inc(C, 32);
      if D in [Ord('A')..Ord('Z')] then
        Inc(D, 32);
      Result := C = D;
    end;
end;

function CharEqualNoAsciiCaseW(const A, B: WideChar): Boolean;
var
  C, D : Word16;
begin
  C := Word16(A);
  D := Word16(B);
  if C = D then
    Result := True
  else
    begin
      case C of
        Ord('A')..Ord('Z') : Inc(C, 32);
      end;
      case D of
        Ord('A')..Ord('Z') : Inc(D, 32);
      end;
      Result := C = D;
    end;
end;

function CharEqualNoAsciiCase(const A, B: Char): Boolean;
begin
  {$IFDEF StringIsUnicode}
  Result := CharEqualNoAsciiCaseW(A, B);
  {$ELSE}
  Result := CharEqualNoAsciiCaseB(A, B);
  {$ENDIF}
end;

function CharIsAsciiB(const C: ByteChar): Boolean;
begin
  Result := Ord(C) <= 127;
end;

function CharIsAsciiW(const C: WideChar): Boolean;
begin
  Result := Ord(C) <= 127;
end;

function CharIsAscii(const C: Char): Boolean;
begin
  Result := Ord(C) <= 127;
end;

function CharIsAsciiUpperCaseB(const C: ByteChar): Boolean;
begin
  Result := Ord(C) in [Ord('A')..Ord('Z')];
end;

function CharIsAsciiUpperCaseW(const C: WideChar): Boolean;
begin
  case Ord(C) of
    Ord('A')..Ord('Z') : Result := True;
  else
    Result := False;
  end;
end;

function CharIsAsciiUpperCase(const C: Char): Boolean;
begin
  {$IFDEF CharIsWide}
  Result := CharIsAsciiUpperCaseW(C);
  {$ELSE}
  Result := CharIsAsciiUpperCaseB(C);
  {$ENDIF}
end;

function CharIsAsciiLowerCaseB(const C: ByteChar): Boolean;
begin
  Result := Ord(C) in [Ord('a')..Ord('z')];
end;

function CharIsAsciiLowerCaseW(const C: WideChar): Boolean;
begin
  case Ord(C) of
    Ord('a')..Ord('z') : Result := True;
  else
    Result := False;
  end;
end;

function CharIsAsciiLowerCase(const C: Char): Boolean;
begin
  {$IFDEF CharIsWide}
  Result := CharIsAsciiUpperCaseW(C);
  {$ELSE}
  Result := CharIsAsciiUpperCaseB(C);
  {$ENDIF}
end;

function CharAsciiLowCaseB(const C: ByteChar): ByteChar;
begin
  if Ord(C) in [Ord('A')..Ord('Z')] then
    Result := ByteChar(Ord(C) + 32)
  else
    Result := C;
end;

function CharAsciiLowCaseW(const C: WideChar): WideChar;
begin
  case Ord(C) of
    Ord('A')..Ord('Z') : Result := WideChar(Ord(C) + 32)
  else
    Result := C;
  end;
end;

function CharAsciiLowCase(const C: Char): Char;
begin
  {$IFDEF CharIsWide}
  Result := CharAsciiLowCaseW(C);
  {$ELSE}
  Result := CharAsciiLowCaseB(C);
  {$ENDIF}
end;

function CharAsciiUpCaseB(const C: ByteChar): ByteChar;
begin
  if Ord(C) in [Ord('a')..Ord('a')] then
    Result := ByteChar(Ord(C) - 32)
  else
    Result := C;
end;

function CharAsciiUpCaseW(const C: WideChar): WideChar;
begin
  case Ord(C) of
    Ord('a')..Ord('z') : Result := WideChar(Ord(C) - 32)
  else
    Result := C;
  end;
end;

function CharAsciiUpCase(const C: Char): Char;
begin
  {$IFDEF CharIsWide}
  Result := CharAsciiUpCaseW(C);
  {$ELSE}
  Result := CharAsciiUpCaseB(C);
  {$ENDIF}
end;

function CharAsciiHexValueB(const C: ByteChar): Integer;
begin
  case Ord(C) of
    Ord('0')..Ord('9') : Result := Ord(C) - Ord('0');
    Ord('A')..Ord('F') : Result := Ord(C) - Ord('A') + 10;
    Ord('a')..Ord('f') : Result := Ord(C) - Ord('a') + 10;
  else
    Result := -1;
  end;
end;

function CharAsciiHexValueW(const C: WideChar): Integer;
begin
  if Ord(C) >= $80 then
    Result := -1
  else
    Result := CharAsciiHexValueB(ByteChar(Ord(C)));
end;

function CharAsciiIsHexB(const C: ByteChar): Boolean;
begin
  Result := CharAsciiHexValueB(C) >= 0;
end;

function CharAsciiIsHexW(const C: WideChar): Boolean;
begin
  Result := CharAsciiHexValueW(C) >= 0;
end;



{                                                                              }
{ String construction from buffer                                              }
{                                                                              }
{$IFDEF SupportAnsiString}
function StrPToStrA(const P: PAnsiChar; const L: NativeInt): AnsiString;
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

function StrPToStrB(const P: Pointer; const L: NativeInt): RawByteString;
begin
  if L <= 0 then
    SetLength(Result, 0)
  else
    begin
      SetLength(Result, L);
      MoveMem(P^, Pointer(Result)^, L);
    end;
end;

function StrPToStrU(const P: PWideChar; const L: NativeInt): UnicodeString;
begin
  if L <= 0 then
    SetLength(Result, 0)
  else
    begin
      SetLength(Result, L);
      MoveMem(P^, Pointer(Result)^, L * SizeOf(WideChar));
    end;
end;

function StrPToStr(const P: PChar; const L: NativeInt): String;
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
function StrZLenA(const S: Pointer): NativeInt;
var
  P : PByteChar;
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

function StrZLenW(const S: PWideChar): NativeInt;
var
  P : PWideChar;
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

function StrZLen(const S: PChar): NativeInt;
var
  P : PChar;
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
var
  I, L : NativeInt;
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
var
  I, L : NativeInt;
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
var
  I, L : NativeInt;
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
var
  I, L : NativeInt;
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

const
  SRawByteStringConvertError = 'RawByteString conversion error';

procedure RawByteBufToWideBuf(
          const Buf: Pointer; const BufSize: NativeInt;
          const DestBuf: Pointer);
var
  I : NativeInt;
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

function RawByteStrPtrToUnicodeString(const S: Pointer; const Len: NativeInt): UnicodeString;
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

procedure WideBufToRawByteBuf(
          const Buf: Pointer; const Len: NativeInt;
          const DestBuf: Pointer);
var
  I : NativeInt;
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

function WideBufToRawByteString(const P: PWideChar; const Len: NativeInt): RawByteString;
var
  I : NativeInt;
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
{ String compare functions                                                     }
{                                                                              }
function StrPCompareB(const A, B: Pointer; const Len: NativeInt): Integer;
begin
  Result := CompareMemB(A^, B^, Len);
end;

function StrPCompareW(const A, B: PWideChar; const Len: NativeInt): Integer;
begin
  Result := CompareMemW(A^, B^, Len);
end;

function StrPCompare(const A, B: PChar; const Len: NativeInt): Integer;
begin
  {$IFDEF CharIsWide}
  Result := StrPCompareW(A, B, Len);
  {$ELSE}
  Result := StrPCompareB(A, B, Len);
  {$ENDIF}
end;

function StrPCompareNoAsciiCaseB(const A, B: Pointer; const Len: NativeInt): Integer;
begin
  Result := CompareMemNoAsciiCaseB(A^, B^, Len);
end;

function StrPCompareNoAsciiCaseW(const A, B: PWideChar; const Len: NativeInt): Integer;
begin
  Result := CompareMemNoAsciiCaseW(A^, B^, Len);
end;

function StrPCompareNoAsciiCase(const A, B: PChar; const Len: NativeInt): Integer;
begin
  {$IFDEF CharIsWide}
  Result := StrPCompareNoAsciiCaseW(A, B, Len);
  {$ELSE}
  Result := StrPCompareNoAsciiCaseB(A, B, Len);
  {$ENDIF}
end;

function StrPEqualB(const A, B: Pointer; const Len: NativeInt): Boolean;
begin
  Result := EqualMem(A^, B^, Len);
end;

function StrPEqualW(const A, B: PWideChar; const Len: NativeInt): Boolean;
begin
  Result := EqualMem(A^, B^, Len * SizeOf(WideChar));
end;

function StrPEqual(const A, B: PChar; const Len: NativeInt): Boolean;
begin
  {$IFDEF CharIsWide}
  Result := EqualMem(A^, B^, Len * SizeOf(WideChar));
  {$ELSE}
  Result := EqualMem(A^, B^, Len);
  {$ENDIF}
end;

function StrPEqualNoAsciiCaseB(const A, B: Pointer; const Len: NativeInt): Boolean;
begin
  Result := EqualMemNoAsciiCaseB(A^, B^, Len);
end;

function StrPEqualNoAsciiCaseW(const A, B: PWideChar; const Len: NativeInt): Boolean;
begin
  Result := EqualMemNoAsciiCaseW(A^, B^, Len);
end;

function StrPEqualNoAsciiCase(const A, B: PChar; const Len: NativeInt): Boolean;
begin
  {$IFDEF CharIsWide}
  Result := EqualMemNoAsciiCaseW(A^, B^, Len);
  {$ELSE}
  Result := EqualMemNoAsciiCaseB(A^, B^, Len);
  {$ENDIF}
end;

{$IFDEF SupportAnsiString}
function StrCompareA(const A, B: AnsiString): Integer;
var
  L, M, I : NativeInt;
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
var
  L, M, I : NativeInt;
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
var
  L, M, I : NativeInt;
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
var
  L, M, I : NativeInt;
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

{$IFDEF SupportAnsiString}
function StrCompareNoAsciiCaseA(const A, B: AnsiString): Integer;
var
  L, M, I: NativeInt;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareNoAsciiCaseB(PByteChar(A), PByteChar(B), I);
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

function StrCompareNoAsciiCaseB(const A, B: RawByteString): Integer;
var
  L, M, I: NativeInt;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    I := L
  else
    I := M;
  Result := StrPCompareNoAsciiCaseB(PByteChar(A), PByteChar(B), I);
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
var
  L, M, I: NativeInt;
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
var
  L, M, I: Integer;
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

function StrEqualNoAsciiCaseB(const A, B: RawByteString): Boolean;
var
  L, M : NativeInt;
begin
  L := Length(A);
  M := Length(B);
  if L <> M then
    Result := False
  else
    Result := StrPEqualNoAsciiCaseB(PByteChar(A), PByteChar(B), L);
end;

function StrEqualNoAsciiCaseU(const A, B: UnicodeString): Boolean;
var
  L, M : NativeInt;
begin
  L := Length(A);
  M := Length(B);
  if L <> M then
    Result := False
  else
    Result := StrPEqualNoAsciiCaseW(PWideChar(A), PWideChar(B), L);
end;

function StrEqualNoAsciiCase(const A, B: String): Boolean;
var
  L, M : NativeInt;
begin
  L := Length(A);
  M := Length(B);
  if L <> M then
    Result := False
  else
    Result := StrPEqualNoAsciiCase(PChar(A), PChar(B), L);
end;

function StrStartsWithB(const A, B: RawByteString): Boolean;
var
  L, M : NativeInt;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    Result := False
  else
    Result := StrPEqualB(PByteChar(A), PByteChar(B), M);
end;

function StrStartsWithU(const A, B: UnicodeString): Boolean;
var
  L, M : NativeInt;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    Result := False
  else
    Result := StrPEqualW(PWideChar(A), PWideChar(B), M);
end;

function StrStartsWith(const A, B: String): Boolean;
var
  L, M : NativeInt;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    Result := False
  else
    Result := StrPEqual(PChar(A), PChar(B), M);
end;

function StrStartsWithNoAsciiCaseB(const A, B: RawByteString): Boolean;
var
  L, M : NativeInt;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    Result := False
  else
    Result := StrPEqualNoAsciiCaseB(PByteChar(A), PByteChar(B), M);
end;

function StrStartsWithNoAsciiCaseU(const A, B: UnicodeString): Boolean;
var
  L, M : NativeInt;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    Result := False
  else
    Result := StrPEqualNoAsciiCaseW(PWideChar(A), PWideChar(B), M);
end;

function StrStartsWithNoAsciiCase(const A, B: String): Boolean;
var
  L, M : NativeInt;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    Result := False
  else
    Result := StrPEqualNoAsciiCase(PChar(A), PChar(B), M);
end;

function StrEndsWithB(const A, B: RawByteString): Boolean;
var
  L, M : NativeInt;
  P : PByteChar;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    Result := False
  else
    begin
      P := PByteChar(A);
      Inc(P, L - M);
      Result := StrPEqualB(P, PByteChar(B), M);
    end;
end;

function StrEndsWithU(const A, B: UnicodeString): Boolean;
var
  L, M : NativeInt;
  P : PWideChar;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    Result := False
  else
    begin
      P := PWideChar(A);
      Inc(P, L - M);
      Result := StrPEqualW(P, PWideChar(B), M);
    end;
end;

function StrEndsWith(const A, B: String): Boolean;
var
  L, M : NativeInt;
  P : PChar;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    Result := False
  else
    begin
      P := PChar(A);
      Inc(P, L - M);
      Result := StrPEqual(P, PChar(B), M);
    end;
end;

function StrEndsWithNoAsciiCaseB(const A, B: RawByteString): Boolean;
var
  L, M : NativeInt;
  P : PByteChar;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    Result := False
  else
    begin
      P := PByteChar(A);
      Inc(P, L - M);
      Result := StrPEqualNoAsciiCaseB(P, PByteChar(B), M);
    end;
end;

function StrEndsWithNoAsciiCaseU(const A, B: UnicodeString): Boolean;
var
  L, M : NativeInt;
  P : PWideChar;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    Result := False
  else
    begin
      P := PWideChar(A);
      Inc(P, L - M);
      Result := StrPEqualNoAsciiCaseW(P, PWideChar(B), M);
    end;
end;

function StrEndsWithNoAsciiCase(const A, B: String): Boolean;
var
  L, M : NativeInt;
  P : PChar;
begin
  L := Length(A);
  M := Length(B);
  if L < M then
    Result := False
  else
    begin
      P := PChar(A);
      Inc(P, L - M);
      Result := StrPEqualNoAsciiCase(P, PChar(B), M);
    end;
end;

function StrPosB(const S, M: RawByteString): Int32;
begin
  Result := LocateMemB(Pointer(S)^, Length(S), Pointer(M)^, Length(M));
end;

function StrPosU(const S, M: UnicodeString): Int32;
begin
  Result := LocateMemW(Pointer(S)^, Length(S), Pointer(M)^, Length(M));
end;

function StrPos(const S, M: String): Int32;
begin
  {$IFDEF StringIsUnicode}
  Result := StrPosU(S, M);
  {$ELSE}
  Result := StrPosB(S, M);
  {$ENDIF}
end;

function StrPosNoAsciiCaseB(const S, M: RawByteString): Int32;
begin
  Result := LocateMemNoAsciiCaseB(Pointer(S)^, Length(S), Pointer(M)^, Length(M));
end;

function StrPosNoAsciiCaseU(const S, M: UnicodeString): Int32;
begin
  Result := LocateMemNoAsciiCaseW(Pointer(S)^, Length(S), Pointer(M)^, Length(M));
end;

function StrPosNoAsciiCase(const S, M: String): Int32;
begin
  {$IFDEF StringIsUnicode}
  Result := StrPosNoAsciiCaseU(S, M);
  {$ELSE}
  Result := StrPosNoAsciiCaseB(S, M);
  {$ENDIF}
end;

{$IFDEF SupportAnsiString}
function StrAsciiUpperCaseA(const S: AnsiString): AnsiString;
var
  U : Boolean;
  P : PAnsiChar;
  Q : PAnsiChar;
  L : NativeInt;
  I : NativeInt;
  B : AnsiChar;
begin
  Result := S;
  U := False;
  P := Pointer(S);
  Q := Pointer(Result);
  L := Length(S);
  for I := 0 to L - 1 do
    begin
      B := P^;
      if B in ['a'..'z'] then
        begin
          B := AnsiChar(Ord(B) - 32);
          if not U then
            begin
              UniqueString(Result);
              U := True;
              Q := Pointer(Result);
              Inc(Q, I);
            end;
          Q^ := B;
        end;
      Inc(P);
      Inc(Q);
    end;
end;
{$ENDIF}

function StrAsciiUpperCaseB(const S: RawByteString): RawByteString;
var
  U : Boolean;
  P : PByteChar;
  Q : PByteChar;
  L : NativeInt;
  I : NativeInt;
  B : Byte;
begin
  Result := S;
  U := False;
  P := Pointer(S);
  Q := Pointer(Result);
  L := Length(S);
  for I := 0 to L - 1 do
    begin
      B := Ord(P^);
      if B in [Ord('a')..Ord('z')] then
        begin
          Dec(B, 32);
          if not U then
            begin
              {$IFDEF SupportAnsiString}
              UniqueString(AnsiString(Result));
              {$ELSE}
              Result := Copy(S, 1, L);
              {$ENDIF}
              U := True;
              Q := Pointer(Result);
              Inc(Q, I);
            end;
          Q^ := ByteChar(B);
        end;
      Inc(P);
      Inc(Q);
    end;
end;

function StrAsciiUpperCaseU(const S: UnicodeString): UnicodeString;
var
  U : Boolean;
  P : PWideChar;
  Q : PWideChar;
  L : NativeInt;
  I : NativeInt;
  B : Word16;
begin
  Result := S;
  U := False;
  P := Pointer(S);
  Q := Pointer(Result);
  L := Length(S);
  for I := 0 to L - 1 do
    begin
      B := Ord(P^);
      case B of
        Ord('a')..Ord('z') :
          begin
            Dec(B, 32);
            if not U then
              begin
                UniqueString(Result);
                U := True;
                Q := Pointer(Result);
                Inc(Q, I);
              end;
            Q^ := WideChar(B);
          end;
      end;
      Inc(P);
      Inc(Q);
    end;
end;

function StrAsciiUpperCase(const S: String): String;
begin
  {$IFDEF StringIsUnicode}
  Result := StrAsciiUpperCaseU(S);
  {$ELSE}
  Result := StrAsciiUpperCaseB(S);
  {$ENDIF}
end;

procedure StrAsciiConvertUpperCaseB(var S: RawByteString);
begin
  S := StrAsciiUpperCaseB(S);
end;

procedure StrAsciiConvertUpperCaseU(var S: UnicodeString);
begin
  S := StrAsciiUpperCaseU(S);
end;

procedure StrAsciiConvertUpperCase(var S: String);
begin
  {$IFDEF StringIsUnicode}
  StrAsciiConvertUpperCaseU(S);
  {$ELSE}
  StrAsciiConvertUpperCaseB(S);
  {$ENDIF}
end;

{$IFDEF SupportAnsiString}
function StrAsciiLowerCaseA(const S: AnsiString): AnsiString;
var
  U : Boolean;
  P : PAnsiChar;
  Q : PAnsiChar;
  L : NativeInt;
  I : NativeInt;
  B : AnsiChar;
begin
  Result := S;
  U := False;
  P := Pointer(S);
  Q := Pointer(Result);
  L := Length(S);
  for I := 0 to L - 1 do
    begin
      B := P^;
      if B in ['A'..'Z'] then
        begin
          B := AnsiChar(Ord(B) + 32);
          if not U then
            begin
              UniqueString(Result);
              U := True;
              Q := Pointer(Result);
              Inc(Q, I);
            end;
          Q^ := B;
        end;
      Inc(P);
      Inc(Q);
    end;
end;
{$ENDIF}

function StrAsciiLowerCaseB(const S: RawByteString): RawByteString;
var
  U : Boolean;
  P : PByteChar;
  Q : PByteChar;
  L : NativeInt;
  I : NativeInt;
  B : Byte;
begin
  Result := S;
  U := False;
  P := Pointer(S);
  Q := Pointer(Result);
  L := Length(S);
  for I := 0 to L - 1 do
    begin
      B := Ord(P^);
      if B in [Ord('A')..Ord('Z')] then
        begin
          Inc(B, 32);
          if not U then
            begin
              {$IFDEF SupportAnsiString}
              UniqueString(AnsiString(Result));
              {$ELSE}
              Result := Copy(S, 1, L);
              {$ENDIF}
              U := True;
              Q := Pointer(Result);
              Inc(Q, I);
            end;
          Q^ := ByteChar(B);
        end;
      Inc(P);
      Inc(Q);
    end;
end;

function StrAsciiLowerCaseU(const S: UnicodeString): UnicodeString;
var
  U : Boolean;
  P : PWideChar;
  Q : PWideChar;
  L : NativeInt;
  I : NativeInt;
  B : Word16;
begin
  Result := S;
  U := False;
  P := Pointer(S);
  Q := Pointer(Result);
  L := Length(S);
  for I := 0 to L - 1 do
    begin
      B := Ord(P^);
      case B of
        Ord('A')..Ord('Z') :
          begin
            Inc(B, 32);
            if not U then
              begin
                UniqueString(Result);
                U := True;
                Q := Pointer(Result);
                Inc(Q, I);
              end;
            Q^ := WideChar(B);
          end;
      end;
      Inc(P);
      Inc(Q);
    end;
end;

function StrAsciiLowerCase(const S: String): String;
begin
  {$IFDEF StringIsUnicode}
  Result := StrAsciiLowerCaseU(S);
  {$ELSE}
  Result := StrAsciiLowerCaseB(S);
  {$ENDIF}
end;

procedure StrAsciiConvertLowerCaseB(var S: RawByteString);
begin
  S := StrAsciiLowerCaseB(S);
end;

procedure StrAsciiConvertLowerCaseU(var S: UnicodeString);
begin
  S := StrAsciiLowerCaseU(S);
end;

procedure StrAsciiConvertLowerCase(var S: String);
begin
  {$IFDEF StringIsUnicode}
  StrAsciiConvertLowerCaseU(S);
  {$ELSE}
  StrAsciiConvertLowerCaseB(S);
  {$ENDIF}
end;

procedure StrAsciiConvertFirstUpB(var S: RawByteString);
var
  C : ByteChar;
begin
  if S <> '' then
    begin
      C := S[1];
      if C in [AsciiLowerA..AsciiLowerZ] then
        S[1] := CharAsciiUpCaseB(C);
    end;
end;

procedure StrAsciiConvertFirstUpU(var S: UnicodeString);
var
  C : WideChar;
begin
  if S <> '' then
    begin
      C := S[1];
      if (Ord(C) >= Ord(AsciiLowerA)) and (Ord(C) <= Ord(AsciiLowerZ)) then
        S[1] := CharAsciiUpCaseW(C);
    end;
end;

procedure StrAsciiConvertFirstUp(var S: String);
var
  C : Char;
begin
  if S <> '' then
    begin
      C := S[1];
      if (Ord(C) >= Ord(AsciiLowerA)) and (Ord(C) <= Ord(AsciiLowerZ)) then
        S[1] := CharAsciiUpCase(C);
    end;
end;

function StrAsciiFirstUpB(const S: RawByteString): RawByteString;
begin
  Result := S;
  StrAsciiConvertFirstUpB(Result);
end;

function StrAsciiFirstUpU(const S: UnicodeString): UnicodeString;
begin
  Result := S;
  StrAsciiConvertFirstUpU(Result);
end;

function StrAsciiFirstUp(const S: String): String;
begin
  Result := S;
  StrAsciiConvertFirstUp(Result);
end;

function IsAsciiBufB(const Buf: Pointer; const Len: NativeInt): Boolean;
var
  I : NativeInt;
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

function IsAsciiBufW(const Buf: Pointer; const Len: NativeInt): Boolean;
var
  I : NativeInt;
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

function IsAsciiStringB(const S: RawByteString): Boolean;
begin
  Result := IsAsciiBufB(Pointer(S), Length(S));
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
  Result := IsAsciiStringB(S);
  {$ENDIF}
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

function Compare(const I1, I2: Double): TCompareResult;
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

function Sgn(const A: Double): Integer;
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
  AsciiHexLookup: array[Byte] of Byte = (
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
function ByteCharDigitToInt(const A: ByteChar): Integer;
begin
  if A in [ByteChar(Ord('0'))..ByteChar(Ord('9'))] then
    Result := Ord(A) - Ord('0')
  else
    Result := -1;
end;

function WideCharDigitToInt(const A: WideChar): Integer;
begin
  if (Ord(A) >= Ord('0')) and (Ord(A) <= Ord('9')) then
    Result := Ord(A) - Ord('0')
  else
    Result := -1;
end;

function CharDigitToInt(const A: Char): Integer;
begin
  {$IFDEF CharIsWide}
  Result := WideCharDigitToInt(A);
  {$ELSE}
  Result := ByteCharDigitToInt(A);
  {$ENDIF}
end;

function IntToByteCharDigit(const A: Integer): ByteChar;
begin
  if (A < 0) or (A > 9) then
    Result := ByteChar($00)
  else
    Result := ByteChar(48 + A);
end;

function IntToWideCharDigit(const A: Integer): WideChar;
begin
  if (A < 0) or (A > 9) then
    Result := WideChar($00)
  else
    Result := WideChar(48 + A);
end;

function IntToCharDigit(const A: Integer): Char;
begin
  {$IFDEF CharIsWide}
  Result := IntToWideCharDigit(A);
  {$ELSE}
  Result := IntToByteCharDigit(A);
  {$ENDIF}
end;

function IsHexByteCharDigit(const Ch: ByteChar): Boolean;
begin
  Result := AsciiHexLookup[Ord(Ch)] <= 15;
end;

function IsHexWideCharDigit(const Ch: WideChar): Boolean;
begin
  if Ord(Ch) <= $FF then
    Result := AsciiHexLookup[Ord(Ch)] <= 15
  else
    Result := False;
end;

function IsHexCharDigit(const Ch: Char): Boolean;
begin
  {$IFDEF CharIsWide}
  Result := IsHexWideCharDigit(Ch);
  {$ELSE}
  Result := IsHexByteCharDigit(Ch);
  {$ENDIF}
end;

function HexByteCharDigitToInt(const A: ByteChar): Integer;
var B : Byte;
begin
  B := AsciiHexLookup[Ord(A)];
  if B = $FF then
    Result := -1
  else
    Result := B;
end;

function HexWideCharDigitToInt(const A: WideChar): Integer;
var B : Byte;
begin
  if Ord(A) > $FF then
    Result := -1
  else
    begin
      B := AsciiHexLookup[Ord(A)];
      if B = $FF then
        Result := -1
      else
        Result := B;
    end;
end;

function HexCharDigitToInt(const A: Char): Integer;
begin
  {$IFDEF CharIsWide}
  Result := HexWideCharDigitToInt(A);
  {$ELSE}
  Result := HexByteCharDigitToInt(A);
  {$ENDIF}
end;

function IntToUpperHexByteCharDigit(const A: Integer): ByteChar;
begin
  if (A < 0) or (A > 15) then
    Result := ByteChar($00)
  else
  if A <= 9 then
    Result := ByteChar(48 + A)
  else
    Result := ByteChar(55 + A);
end;

function IntToUpperHexWideCharDigit(const A: Integer): WideChar;
begin
  if (A < 0) or (A > 15) then
    Result := #$00
  else
  if A <= 9 then
    Result := WideChar(48 + A)
  else
    Result := WideChar(55 + A);
end;

function IntToUpperHexCharDigit(const A: Integer): Char;
begin
  {$IFDEF CharIsWide}
  Result := IntToUpperHexWideCharDigit(A);
  {$ELSE}
  Result := IntToUpperHexByteCharDigit(A);
  {$ENDIF}
end;

function IntToLowerHexByteCharDigit(const A: Integer): ByteChar;
begin
  if (A < 0) or (A > 15) then
    Result := ByteChar($00)
  else
  if A <= 9 then
    Result := ByteChar(48 + A)
  else
    Result := ByteChar(87 + A);
end;

function IntToLowerHexWideCharDigit(const A: Integer): WideChar;
begin
  if (A < 0) or (A > 15) then
    Result := #$00
  else
  if A <= 9 then
    Result := WideChar(48 + A)
  else
    Result := WideChar(87 + A);
end;

function IntToLowerHexCharDigit(const A: Integer): Char;
begin
  {$IFDEF CharIsWide}
  Result := IntToLowerHexWideCharDigit(A);
  {$ELSE}
  Result := IntToLowerHexByteCharDigit(A);
  {$ENDIF}
end;

{$IFDEF SupportAnsiString}
function IntToStringA(const A: Int64): AnsiString;
var
  T : Int64;
  L : Integer;
  I : Integer;
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
      Result[L - I] := IntToByteCharDigit(T mod 10);
      T := T div 10;
      Inc(I);
    end;
end;
{$ENDIF}

function IntToStringB(const A: Int64): RawByteString;
var
  T : Int64;
  L : Integer;
  I : Integer;
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
      Result[L - I] := UTF8Char(IntToByteCharDigit(T mod 10));
      T := T div 10;
      Inc(I);
    end;
end;

function IntToStringU(const A: Int64): UnicodeString;
var
  T : Int64;
  L : Integer;
  I : Integer;
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
      Result[L - I] := IntToWideCharDigit(T mod 10);
      T := T div 10;
      Inc(I);
    end;
end;

function IntToString(const A: Int64): String;
var
  T : Int64;
  L : Integer;
  I : Integer;
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
      Result[L - I] := IntToCharDigit(T mod 10);
      T := T div 10;
      Inc(I);
    end;
end;

{$IFDEF SupportAnsiString}
function UIntToBaseA(
         const Value: UInt64;
         const Digits: Integer;
         const Base: Byte;
         const UpperCase: Boolean = True): AnsiString;
var D : UInt64;
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

function UIntToBaseB(
         const Value: UInt64;
         const Digits: Integer;
         const Base: Byte;
         const UpperCase: Boolean = True): RawByteString;
var D : UInt64;
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

function UIntToBaseU(
         const Value: UInt64;
         const Digits: Integer;
         const Base: Byte;
         const UpperCase: Boolean = True): UnicodeString;
var D : UInt64;
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

function UIntToBase(
         const Value: UInt64;
         const Digits: Integer;
         const Base: Byte;
         const UpperCase: Boolean = True): String;
var D : UInt64;
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
function UIntToStringA(const A: UInt64): AnsiString;
begin
  Result := UIntToBaseA(A, 0, 10);
end;
{$ENDIF}

function UIntToStringB(const A: UInt64): RawByteString;
begin
  Result := UIntToBaseB(A, 0, 10);
end;

function UIntToStringU(const A: UInt64): UnicodeString;
begin
  Result := UIntToBaseU(A, 0, 10);
end;

function UIntToString(const A: UInt64): String;
begin
  Result := UIntToBase(A, 0, 10);
end;

{$IFDEF SupportAnsiString}
function Word32ToStrA(const A: Word32; const Digits: Integer): AnsiString;
begin
  Result := UIntToBaseA(A, Digits, 10);
end;
{$ENDIF}

function Word32ToStrB(const A: Word32; const Digits: Integer): RawByteString;
begin
  Result := UIntToBaseB(A, Digits, 10);
end;

function Word32ToStrU(const A: Word32; const Digits: Integer): UnicodeString;
begin
  Result := UIntToBaseU(A, Digits, 10);
end;

function Word32ToStr(const A: Word32; const Digits: Integer): String;
begin
  Result := UIntToBase(A, Digits, 10);
end;

{$IFDEF SupportAnsiString}
function Word32ToHexA(const A: Word32; const Digits: Integer; const UpperCase: Boolean): AnsiString;
begin
  Result := UIntToBaseA(A, Digits, 16, UpperCase);
end;
{$ENDIF}

function Word32ToHexB(const A: Word32; const Digits: Integer; const UpperCase: Boolean): RawByteString;
begin
  Result := UIntToBaseB(A, Digits, 16, UpperCase);
end;

function Word32ToHexU(const A: Word32; const Digits: Integer; const UpperCase: Boolean): UnicodeString;
begin
  Result := UIntToBaseU(A, Digits, 16, UpperCase);
end;

function Word32ToHex(const A: Word32; const Digits: Integer; const UpperCase: Boolean): String;
begin
  Result := UIntToBase(A, Digits, 16, UpperCase);
end;

{$IFDEF SupportAnsiString}
function Word32ToOctA(const A: Word32; const Digits: Integer): AnsiString;
begin
  Result := UIntToBaseA(A, Digits, 8);
end;
{$ENDIF}

function Word32ToOctB(const A: Word32; const Digits: Integer): RawByteString;
begin
  Result := UIntToBaseB(A, Digits, 8);
end;

function Word32ToOctU(const A: Word32; const Digits: Integer): UnicodeString;
begin
  Result := UIntToBaseU(A, Digits, 8);
end;

function Word32ToOct(const A: Word32; const Digits: Integer): String;
begin
  Result := UIntToBase(A, Digits, 8);
end;

{$IFDEF SupportAnsiString}
function Word32ToBinA(const A: Word32; const Digits: Integer): AnsiString;
begin
  Result := UIntToBaseA(A, Digits, 2);
end;
{$ENDIF}

function Word32ToBinB(const A: Word32; const Digits: Integer): RawByteString;
begin
  Result := UIntToBaseB(A, Digits, 2);
end;

function Word32ToBinU(const A: Word32; const Digits: Integer): UnicodeString;
begin
  Result := UIntToBaseU(A, Digits, 2);
end;

function Word32ToBin(const A: Word32; const Digits: Integer): String;
begin
  Result := UIntToBase(A, Digits, 2);
end;

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF} // Delphi 7 incorrectly overflowing for -922337203685477580 * 10
function TryStringToUInt64PB(const BufP: Pointer; const BufLen: Integer; out Value: UInt64; out StrLen: Integer): TConvertResult;
var
  ChP    : PByte;
  Len    : Integer;
  HasDig : Boolean;
  Res    : UInt64;
  Ch     : Byte;
  DigVal : Integer;
begin
  if BufLen <= 0 then
    begin
      Value := 0;
      StrLen := 0;
      Result := convertFormatError;
      exit;
    end;
  Assert(Assigned(BufP));
  ChP := BufP;
  Len := 0;
  HasDig := False;
  // skip leading zeros
  while (Len < BufLen) and (ChP^ = Ord('0')) do
    begin
      Inc(Len);
      Inc(ChP);
      HasDig := True;
    end;
  // convert digits
  Res := 0;
  while Len < BufLen do
    begin
      Ch := ChP^;
      if Ch in [Ord('0')..Ord('9')] then
        begin
          HasDig := True;
          {$IFDEF DELPHI7}
          if (PWord64Rec(@Res)^.Word32Hi > $19999999) or
             ((PWord64Rec(@Res)^.Word32Hi = $19999999) and (PWord64Rec(@Res)^.Word32Lo > $99999999)) then
          {$ELSE}
          if (Res > 1844674407370955161) then
          {$ENDIF}
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          Res := Res * 10;
          DigVal := ByteCharDigitToInt(ByteChar(Ch));
          {$IFDEF DELPHI7}
          if (PWord64Rec(@Res)^.Word32Hi = $FFFFFFFF) and (PWord64Rec(@Res)^.Word32Lo = $FFFFFFFA) and (DigVal > 5) then
          {$ELSE}
          if (Res = 18446744073709551610) and (DigVal > 5) then
          {$ENDIF}
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          Inc(Res, DigVal);
          Inc(Len);
          Inc(ChP);
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

function TryStringToUInt64PW(const BufP: Pointer; const BufLen: Integer; out Value: UInt64; out StrLen: Integer): TConvertResult;
var
  ChP    : PWideChar;
  Len    : Integer;
  HasDig : Boolean;
  Res    : UInt64;
  Ch     : WideChar;
  DigVal : Integer;
begin
  if BufLen <= 0 then
    begin
      Value := 0;
      StrLen := 0;
      Result := convertFormatError;
      exit;
    end;
  Assert(Assigned(BufP));
  ChP := BufP;
  Len := 0;
  HasDig := False;
  // skip leading zeros
  while (Len < BufLen) and (ChP^ = '0') do
    begin
      Inc(Len);
      Inc(ChP);
      HasDig := True;
    end;
  // convert digits
  Res := 0;
  while Len < BufLen do
    begin
      Ch := ChP^;
      if (Ch >= '0') and (Ch <= '9') then
        begin
          HasDig := True;
          {$IFDEF DELPHI7}
          if (PWord64Rec(@Res)^.Word32Hi > $19999999) or
             ((PWord64Rec(@Res)^.Word32Hi = $19999999) and (PWord64Rec(@Res)^.Word32Lo > $99999999)) then
          {$ELSE}
          if (Res > 1844674407370955161) then
          {$ENDIF}
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          Res := Res * 10;
          DigVal := WideCharDigitToInt(Ch);
          {$IFDEF DELPHI7}
          if (PWord64Rec(@Res)^.Word32Hi = $FFFFFFFF) and (PWord64Rec(@Res)^.Word32Lo = $FFFFFFFA) and (DigVal > 5) then
          {$ELSE}
          if (Res = 18446744073709551610) and (DigVal > 5) then
          {$ENDIF}
            begin
              Value := 0;
              StrLen := Len;
              Result := convertOverflow;
              exit;
            end;
          Inc(Res, DigVal);
          Inc(Len);
          Inc(ChP);
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

function TryStringToUInt64P(const BufP: Pointer; const BufLen: Integer; out Value: UInt64; out StrLen: Integer): TConvertResult; {$IFDEF UseInline}inline;{$ENDIF}
begin
  {$IFDEF StringIsUnicode}
  Result := TryStringToUInt64PW(BufP, BufLen, Value, StrLen);
  {$ELSE}
  Result := TryStringToUInt64PB(BufP, BufLen, Value, StrLen);
  {$ENDIF}
end;

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
          DigVal := ByteCharDigitToInt(ByteChar(Ch));
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
          DigVal := WideCharDigitToInt(Ch);
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
          DigVal := CharDigitToInt(Ch);
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
function TryStringToUInt64A(const S: AnsiString; out A: UInt64): Boolean;
var L, N : Integer;
begin
  L := Length(S);
  Result := TryStringToUInt64PB(PAnsiChar(S), L, A, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;
{$ENDIF}

function TryStringToUInt64B(const S: RawByteString; out A: UInt64): Boolean;
var L, N : Integer;
begin
  L := Length(S);
  Result := TryStringToUInt64PB(Pointer(S), L, A, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;

function TryStringToUInt64U(const S: UnicodeString; out A: UInt64): Boolean;
var L, N : Integer;
begin
  L := Length(S);
  Result := TryStringToUInt64PW(PWideChar(S), L, A, N) = convertOK;
  if Result then
    if N < L then
      Result := False;
end;

function TryStringToUInt64(const S: String; out A: UInt64): Boolean;
var L, N : Integer;
begin
  L := Length(S);
  Result := TryStringToUInt64P(PChar(S), L, A, N) = convertOK;
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
function StringToUInt64DefA(const S: AnsiString; const Default: UInt64): UInt64;
begin
  if not TryStringToUInt64A(S, Result) then
    Result := Default;
end;
{$ENDIF}

function StringToUInt64DefB(const S: RawByteString; const Default: UInt64): UInt64;
begin
  if not TryStringToUInt64B(S, Result) then
    Result := Default;
end;

function StringToUInt64DefU(const S: UnicodeString; const Default: UInt64): UInt64;
begin
  if not TryStringToUInt64U(S, Result) then
    Result := Default;
end;

function StringToUInt64Def(const S: String; const Default: UInt64): UInt64;
begin
  if not TryStringToUInt64(S, Result) then
    Result := Default;
end;

{$IFDEF SupportAnsiString}
function StringToInt64A(const S: AnsiString): Int64;
begin
  if not TryStringToInt64A(S, Result) then
    raise ERangeCheckError.Create;
end;
{$ENDIF}

function StringToInt64B(const S: RawByteString): Int64;
begin
  if not TryStringToInt64B(S, Result) then
    raise ERangeCheckError.Create;
end;

function StringToInt64U(const S: UnicodeString): Int64;
begin
  if not TryStringToInt64U(S, Result) then
    raise ERangeCheckError.Create;
end;

function StringToInt64(const S: String): Int64;
begin
  if not TryStringToInt64(S, Result) then
    raise ERangeCheckError.Create;
end;

{$IFDEF SupportAnsiString}
function StringToUInt64A(const S: AnsiString): UInt64;
begin
  if not TryStringToUInt64A(S, Result) then
    raise ERangeCheckError.Create;
end;
{$ENDIF}

function StringToUInt64B(const S: RawByteString): UInt64;
begin
  if not TryStringToUInt64B(S, Result) then
    raise ERangeCheckError.Create;
end;

function StringToUInt64U(const S: UnicodeString): UInt64;
begin
  if not TryStringToUInt64U(S, Result) then
    raise ERangeCheckError.Create;
end;

function StringToUInt64(const S: String): UInt64;
begin
  if not TryStringToUInt64(S, Result) then
    raise ERangeCheckError.Create;
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
    raise ERangeCheckError.Create;
end;
{$ENDIF}

function StringToIntB(const S: RawByteString): Integer;
begin
  if not TryStringToIntB(S, Result) then
    raise ERangeCheckError.Create;
end;

function StringToIntU(const S: UnicodeString): Integer;
begin
  if not TryStringToIntU(S, Result) then
    raise ERangeCheckError.Create;
end;

function StringToInt(const S: String): Integer;
begin
  if not TryStringToInt(S, Result) then
    raise ERangeCheckError.Create;
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
    raise ERangeCheckError.Create;
end;
{$ENDIF}

function StringToWord32B(const S: RawByteString): Word32;
begin
  if not TryStringToWord32B(S, Result) then
    raise ERangeCheckError.Create;
end;

function StringToWord32U(const S: UnicodeString): Word32;
begin
  if not TryStringToWord32U(S, Result) then
    raise ERangeCheckError.Create;
end;

function StringToWord32(const S: String): Word32;
begin
  if not TryStringToWord32(S, Result) then
    raise ERangeCheckError.Create;
end;

{$IFDEF SupportAnsiString}
function BaseStrToUIntA(const S: AnsiString; const BaseLog2: Byte;
    var Valid: Boolean): UInt64;
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
    C := AsciiHexLookup[Ord(S[L])];
    if C > M then // invalid digit
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    {$IFDEF FPC}
    Result := Result + UInt64(C) shl N;
    {$ELSE}
    Inc(Result, UInt64(C) shl N);
    {$ENDIF}
    Inc(N, BaseLog2);
    if N > 64 then // overflow
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

function BaseStrToUIntB(const S: RawByteString; const BaseLog2: Byte;
    var Valid: Boolean): UInt64;
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
    C := AsciiHexLookup[Ord(S[L])];
    if C > M then // invalid digit
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    {$IFDEF FPC}
    Result := Result + UInt64(C) shl N;
    {$ELSE}
    Inc(Result, UInt64(C) shl N);
    {$ENDIF}
    Inc(N, BaseLog2);
    if N > 64 then // overflow
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    Dec(L);
  until L = 0;
  Valid := True;
end;

function BaseStrToUIntU(const S: UnicodeString; const BaseLog2: Byte;
    var Valid: Boolean): UInt64;
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
      C := AsciiHexLookup[Ord(D)];
    if C > M then // invalid digit
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    {$IFDEF FPC}
    Result := Result + UInt64(C) shl N;
    {$ELSE}
    Inc(Result, UInt64(C) shl N);
    {$ENDIF}
    Inc(N, BaseLog2);
    if N > 64 then // overflow
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    Dec(L);
  until L = 0;
  Valid := True;
end;

function BaseStrToUInt(const S: String; const BaseLog2: Byte;
    var Valid: Boolean): UInt64;
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
      C := AsciiHexLookup[Ord(D)];
    {$ELSE}
    C := AsciiHexLookup[Ord(D)];
    {$ENDIF}
    if C > M then // invalid digit
      begin
        Valid := False;
        Result := 0;
        exit;
      end;
    {$IFDEF FPC}
    Result := Result + UInt64(C) shl N;
    {$ELSE}
    Inc(Result, UInt64(C) shl N);
    {$ENDIF}
    Inc(N, BaseLog2);
    if N > 64 then // overflow
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
function HexToUIntA(const S: AnsiString): UInt64;
var R : Boolean;
begin
  Result := BaseStrToUIntA(S, 4, R);
  if not R then
    raise ERangeCheckError.Create;
end;
{$ENDIF}

function HexToUIntB(const S: RawByteString): UInt64;
var R : Boolean;
begin
  Result := BaseStrToUIntB(S, 4, R);
  if not R then
    raise ERangeCheckError.Create;
end;

function HexToUIntU(const S: UnicodeString): UInt64;
var R : Boolean;
begin
  Result := BaseStrToUIntU(S, 4, R);
  if not R then
    raise ERangeCheckError.Create;
end;

function HexToUInt(const S: String): UInt64;
var R : Boolean;
begin
  Result := BaseStrToUInt(S, 4, R);
  if not R then
    raise ERangeCheckError.Create;
end;

{$IFDEF SupportAnsiString}
function TryHexToWord32A(const S: AnsiString; out A: Word32): Boolean;
begin
  A := BaseStrToUIntA(S, 4, Result);
end;
{$ENDIF}

function TryHexToWord32B(const S: RawByteString; out A: Word32): Boolean;
begin
  A := BaseStrToUIntB(S, 4, Result);
end;

function TryHexToWord32U(const S: UnicodeString; out A: Word32): Boolean;
begin
  A := BaseStrToUIntU(S, 4, Result);
end;

function TryHexToWord32(const S: String; out A: Word32): Boolean;
begin
  A := BaseStrToUInt(S, 4, Result);
end;

{$IFDEF SupportAnsiString}
function HexToWord32A(const S: AnsiString): Word32;
var R : Boolean;
begin
  Result := BaseStrToUIntA(S, 4, R);
  if not R then
    raise ERangeCheckError.Create;
end;
{$ENDIF}

function HexToWord32B(const S: RawByteString): Word32;
var R : Boolean;
begin
  Result := BaseStrToUIntB(S, 4, R);
  if not R then
    raise ERangeCheckError.Create;
end;

function HexToWord32U(const S: UnicodeString): Word32;
var R : Boolean;
begin
  Result := BaseStrToUIntU(S, 4, R);
  if not R then
    raise ERangeCheckError.Create;
end;

function HexToWord32(const S: String): Word32;
var R : Boolean;
begin
  Result := BaseStrToUInt(S, 4, R);
  if not R then
    raise ERangeCheckError.Create;
end;

{$IFDEF SupportAnsiString}
function TryOctToWord32A(const S: AnsiString; out A: Word32): Boolean;
begin
  A := BaseStrToUIntA(S, 3, Result);
end;
{$ENDIF}

function TryOctToWord32B(const S: RawByteString; out A: Word32): Boolean;
begin
  A := BaseStrToUIntB(S, 3, Result);
end;

function TryOctToWord32U(const S: UnicodeString; out A: Word32): Boolean;
begin
  A := BaseStrToUIntU(S, 3, Result);
end;

function TryOctToWord32(const S: String; out A: Word32): Boolean;
begin
  A := BaseStrToUInt(S, 3, Result);
end;

{$IFDEF SupportAnsiString}
function OctToWord32A(const S: AnsiString): Word32;
var R : Boolean;
begin
  Result := BaseStrToUIntA(S, 3, R);
  if not R then
    raise ERangeCheckError.Create;
end;
{$ENDIF}

function OctToWord32B(const S: RawByteString): Word32;
var R : Boolean;
begin
  Result := BaseStrToUIntB(S, 3, R);
  if not R then
    raise ERangeCheckError.Create;
end;

function OctToWord32U(const S: UnicodeString): Word32;
var R : Boolean;
begin
  Result := BaseStrToUIntU(S, 3, R);
  if not R then
    raise ERangeCheckError.Create;
end;

function OctToWord32(const S: String): Word32;
var R : Boolean;
begin
  Result := BaseStrToUInt(S, 3, R);
  if not R then
    raise ERangeCheckError.Create;
end;

{$IFDEF SupportAnsiString}
function TryBinToWord32A(const S: AnsiString; out A: Word32): Boolean;
begin
  A := BaseStrToUIntA(S, 1, Result);
end;
{$ENDIF}

function TryBinToWord32B(const S: RawByteString; out A: Word32): Boolean;
begin
  A := BaseStrToUIntB(S, 1, Result);
end;

function TryBinToWord32U(const S: UnicodeString; out A: Word32): Boolean;
begin
  A := BaseStrToUIntU(S, 1, Result);
end;

function TryBinToWord32(const S: String; out A: Word32): Boolean;
begin
  A := BaseStrToUInt(S, 1, Result);
end;

{$IFDEF SupportAnsiString}
function BinToWord32A(const S: AnsiString): Word32;
var R : Boolean;
begin
  Result := BaseStrToUIntA(S, 1, R);
  if not R then
    raise ERangeCheckError.Create;
end;
{$ENDIF}

function BinToWord32B(const S: RawByteString): Word32;
var R : Boolean;
begin
  Result := BaseStrToUIntB(S, 1, R);
  if not R then
    raise ERangeCheckError.Create;
end;

function BinToWord32U(const S: UnicodeString): Word32;
var R : Boolean;
begin
  Result := BaseStrToUIntU(S, 1, R);
  if not R then
    raise ERangeCheckError.Create;
end;

function BinToWord32(const S: String): Word32;
var R : Boolean;
begin
  Result := BaseStrToUInt(S, 1, R);
  if not R then
    raise ERangeCheckError.Create;
end;



{$IFDEF SupportAnsiString}
function BytesToHexA(const P: Pointer; const Count: NativeInt;
         const UpperCase: Boolean): AnsiString;
var Q : PByte;
    D : PAnsiChar;
    L : NativeInt;
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
  Result := UIntToBaseA(NativeUInt(P), NativeWordSize * 2, 16, True);
end;
{$ENDIF}

function PointerToStrB(const P: Pointer): RawByteString;
begin
  Result := UIntToBaseB(NativeUInt(P), NativeWordSize * 2, 16, True);
end;

function PointerToStrU(const P: Pointer): UnicodeString;
begin
  Result := UIntToBaseU(NativeUInt(P), NativeWordSize * 2, 16, True);
end;

function PointerToStr(const P: Pointer): String;
begin
  Result := UIntToBase(NativeUInt(P), NativeWordSize * 2, 16, True);
end;

{$IFDEF SupportAnsiString}
function StrToPointerA(const S: AnsiString): Pointer;
var V : Boolean;
begin
  Result := Pointer(BaseStrToUIntA(S, 4, V));
end;
{$ENDIF}

function StrToPointerB(const S: RawByteString): Pointer;
var V : Boolean;
begin
  Result := Pointer(BaseStrToUIntB(S, 4, V));
end;

function StrToPointerU(const S: UnicodeString): Pointer;
var V : Boolean;
begin
  Result := Pointer(BaseStrToUIntU(S, 4, V));
end;

function StrToPointer(const S: String): Pointer;
var V : Boolean;
begin
  Result := Pointer(BaseStrToUInt(S, 4, V));
end;

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

function HashBuf(const Hash: Word32; const Buf; const BufSize: NativeInt): Word32;
var
  P : PByte;
  I : NativeInt;
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
function HashStrA(
         const S: AnsiString;
         const Index: NativeInt; const Count: NativeInt;
         const AsciiCaseSensitive: Boolean;
         const Slots: Word32): Word32;
var
  I, L, A, B : NativeInt;
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

function HashStrB(
         const S: RawByteString;
         const Index: NativeInt; const Count: NativeInt;
         const AsciiCaseSensitive: Boolean;
         const Slots: Word32): Word32;
var
  I, L, A, B : NativeInt;
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

function HashStrU(
         const S: UnicodeString;
         const Index: NativeInt; const Count: NativeInt;
         const AsciiCaseSensitive: Boolean;
         const Slots: Word32): Word32;
var
  I, L, A, B : NativeInt;
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

function HashStr(
         const S: String;
         const Index: NativeInt; const Count: NativeInt;
         const AsciiCaseSensitive: Boolean;
         const Slots: Word32): Word32;
var
  I, L, A, B : NativeInt;
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
var
  P : PByte;
  J : Integer;
begin
  if not HashTableInit then
    InitHashTable;
  Result := $FFFFFFFF;
  P := @I;
  for J := 0 to SizeOf(Integer) - 1 do
    begin
      Result := HashTable[Byte(Result) xor P^] xor (Result shr 8);
      Inc(P);
    end;
  if Slots <> 0 then
    Result := Result mod Slots;
end;

function HashNativeUInt(const I: NativeUInt; const Slots: Word32): Word32;
var
  P : PByte;
  J : Integer;
begin
  if not HashTableInit then
    InitHashTable;
  Result := $FFFFFFFF;
  P := @I;
  for J := 0 to SizeOf(NativeUInt) - 1 do
    begin
      Result := HashTable[Byte(Result) xor P^] xor (Result shr 8);
      Inc(P);
    end;
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
procedure BytesSetLengthAndZero(var V: TBytes; const NewLength: NativeInt);
var
  OldLen, NewLen : NativeInt;
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

procedure BytesInit(var V: TBytes; const S: array of Byte);
var L, I : Integer;
begin
  L := Length(S);
  SetLength(V, L);
  for I := 0 to L - 1 do
    V[I] := S[I];
end;

function BytesAppend(var V: TBytes; const R: Byte): NativeInt;
begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
end;

function BytesAppend(var V: TBytes; const R: TBytes): NativeInt;
var
  L : NativeInt;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      MoveMem(R[0], V[Result], L);
    end;
end;

function BytesAppend(var V: TBytes; const R: array of Byte): NativeInt;
var
  L : NativeInt;
begin
  Result := Length(V);
  L := Length(R);
  if L > 0 then
    begin
      SetLength(V, Result + L);
      MoveMem(R[0], V[Result], L);
    end;
end;

function BytesAppend(var V: TBytes; const R: String): NativeInt;
var
  L, I : NativeInt;
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
var
  L, N : NativeInt;
begin
  L := Length(A);
  N := Length(B);
  if L < N then
    Result := -1
  else
  if L > N then
    Result := 1
  else
    Result := CompareMemB(Pointer(A)^, Pointer(B)^, L);
end;

function BytesEqual(const A, B: TBytes): Boolean;
var
  L, N : NativeInt;
begin
  L := Length(A);
  N := Length(B);
  if L <> N then
    Result := False
  else
    Result := EqualMem(Pointer(A)^, Pointer(B)^, L);
end;



end.

