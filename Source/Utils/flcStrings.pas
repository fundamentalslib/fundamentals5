{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcStrings.pas                                           }
{   File version:     5.69                                                     }
{   Description:      String utility functions                                 }
{                                                                              }
{   Copyright:        Copyright (c) 1999-2018, David J Butler                  }
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
{   1999/10/19  0.01  Split from Maths unit.                                   }
{   1999/10/26  0.02  Revision.                                                }
{   1999/10/30  0.03  Added Count, Reverse.                                    }
{   1999/10/31  0.04  Improved Match.                                          }
{                     Added Replace, Count, PadInside.                         }
{   1999/11/06  1.05  Added Remove, TrimEllipse.                               }
{   1999/11/09  1.06  Added Pack functions.                                    }
{   1999/11/17  1.07  Added PosN, Before, After, Between and Split.            }
{   1999/11/22  1.08  Added Join.                                              }
{   1999/11/23  1.09  Added Translate.                                         }
{   1999/12/02  1.10  Fixed bugs in Replace and Match reported by daiqingbo.   }
{   1999/12/27  1.11  Added SelfTest procedure and Bug fixes.                  }
{   2000/01/04  1.12  Added InsensitiveCharSet.                                }
{   2000/01/08  1.13  Added Append.                                            }
{   2000/05/08  1.14  Revision.                                                }
{   2000/07/20  1.15  Bug fixes.                                               }
{   2000/08/30  1.16  Bug fixes.                                               }
{   2000/09/04  1.17  Added MatchFileMask.                                     }
{   2000/09/31  1.18  Added HexEscapeText and HexUnescapeText.                 }
{   2000/12/04  1.19  Changes to CopyRange, CopyLeft to avoid memory           }
{                     allocation in specific cases.                            }
{   2001/04/22  1.20  Added CaseSensitive parameter to Match, PosNext, PosN    }
{   2001/04/25  1.21  Added CopyEx, MatchLeft and MatchRight.                  }
{   2001/04/28  1.22  Refactoring.                                             }
{                     Replaced PosNext and PosPrev with Pos.                   }
{   2001/04/29  1.23  Improvements.                                            }
{   2001/05/13  1.24  Added simple regular expression matching.                }
{                     Added CharClassStr conversion routines.                  }
{   2001/06/01  1.25  Added TQuickLexer                                        }
{   2001/07/07  1.26  Optimizations.                                           }
{   2001/07/30  1.27  Revision.                                                }
{   2001/08/22  1.28  Revision.                                                }
{   2001/11/11  2.29  Revision.                                                }
{   2002/02/14  2.30  Added MatchPattern.                                      }
{   2002/04/03  3.31  Added string functions from cUtils.                      }
{   2002/04/14  3.32  Moved TQuickLexer to unit cQuickLexer.                   }
{   2002/12/14  3.33  Major revision. Removed rarely used functions.           }
{   2003/07/28  3.34  Minor changes.                                           }
{   2003/08/04  3.35  Changed parameters of StrMatch functions to be           }
{                     consistent with other string functions.                  }
{                     Changed StrCompare functions to return integer result.   }
{   2003/09/06  3.36  Removed dependancy on Delphi's Math and Variant units.   }
{                     This saves about 25K when used in a DLL.                 }
{   2003/11/07  3.37  Compilable with FreePascal 1.90 Win32 i386.              }
{   2004/07/31  3.38  Improved StrReplace function to efficiently handle       }
{                     cases where millions of matches are found.               }
{   2004/08/01  3.39  Added ToLongWord conversion functions.                   }
{   2005/06/10  4.40  Compilable with FreePascal 2 Win32 i386.                 }
{   2005/09/20  4.41  Added TStringBuilder class.                              }
{   2005/09/21  4.42  Revised for Fundamentals 4.                              }
{   2007/06/08  4.43  Compilable with FreePascal 2.0.4 Win32 i386              }
{   2008/08/18  4.44  StrP functions; added Str prefix to some functions.      }
{   2009/01/04  4.45  Added AsciiChar and AsciiString.                         }
{                     Initial update for Delphi 2009.                          }
{   2009/10/09  4.46  Compilable with Delphi 2009 Win32/.NET.                  }
{   2010/06/27  4.47  Compilable with FreePascal 2.4.0 OSX x86-64              }
{   2011/03/17  4.48  Compilable with Delphi 5.                                }
{   2011/05/28  4.49  Fix in TWideStringBuilder.                               }
{   2011/06/14  4.50  Added Append(BufPtr) method to TStringBuilder.           }
{   2011/09/30  4.51  Improved UnicodeString support.                          }
{   2011/10/17  4.52  WideString functions.                                    }
{   2012/03/26  4.53  Add A and W string functions.                            }
{   2012/08/24  4.54  Improvements to StrZ functions.                          }
{   2012/08/25  4.55  Add U string functions.                                  }
{   2012/08/28  4.56  Add Unicode character functions from cUnicode.           }
{   2012/08/29  4.57  Improve pattern matcher functions.                       }
{   2013/05/12  4.58  Move string type definitions to Utils unit.              }
{   2014/08/26  4.59  StringBuilder unit tests.                                }
{   2015/03/13  4.60  RawByteString functions.                                 }
{   2015/04/11  4.61  UnicodeString functions.                                 }
{   2016/01/09  5.62  Revised for Fundamentals 5.                              }
{   2016/04/13  5.63  Change pattern match functions to RawByteString.         }
{   2016/04/16  5.64  Changes to compile with FreePascal 3.0.0.                }
{   2017/10/07  5.65  Created units flcStringPatternMatcher, flcStringBuilder  }
{   2017/10/24  5.66  Created units flcUnicodeChar, flcZeroTerminatedString    }
{   2018/07/17  5.67  Type changes.                                            }
{   2018/08/11  5.68  Created unit flcUnicodeString.                           }
{   2018/08/11  5.69  Removed dependency on flcCharSet.                        }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 5 Win32                      4.60  2015/03/14                       }
{   Delphi 6 Win32                      4.60  2015/03/14                       }
{   Delphi 7 Win32                      5.62  2016/01/09                       }
{   Delphi 2007 Win32                   4.57  2012/08/29                       }
{   Delphi 2009 Win32                   4.50  2011/09/27                       }
{   Delphi 2009 .NET                    4.46  2009/10/09                       }
{   Delphi XE                           4.57  2012/08/29                       }
{   Delphi XE3 Win64                    4.57  2013/01/29                       }
{   Delphi XE6 Win32                    4.59  2014/08/26                       }
{   Delphi XE7 Win32                    5.62  2016/01/09                       }
{   Delphi XE7 Win64                    5.62  2016/01/09                       }
{   Delphi 10 Win32                     5.62  2016/01/09                       }
{   Delphi 10 Win64                     5.62  2016/01/09                       }
{   Delphi 10.2 Win32                   5.67  2018/07/17                       }
{   Delphi 10.2 Win64                   5.67  2018/07/17                       }
{   Delphi 10.2 Linux64                 5.67  2018/07/17                       }
{   FreePascal 2.0.4 Linux i386         4.45  2009/06/06                       }
{   FreePascal 2.4.0 OSX x86-64         4.47  2010/06/27                       }
{   FreePascal 2.6.0 Win32              4.57  2012/08/30                       }
{   FreePascal 3.0.0 Win32              5.64  2016/04/16                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

{$IFDEF DEBUG}
{$IFDEF TEST}
  {$DEFINE STRINGS_TEST}
{$ENDIF}
{$ENDIF}

unit flcStrings;

interface

uses
  { System }
  SysUtils,
  {$IFDEF CLR}
  Borland.Vcl.StrUtils,
  {$ENDIF}
  { Fundamentals }
  flcStdTypes,
  flcASCII;



{                                                                              }
{ Exceptions                                                                   }
{                                                                              }
type
  EStringError = class(Exception);
  EStrInvalidArgument = class(EStringError);



{                                                                              }
{ ByteChar constants                                                           }
{                                                                              }
const
  { Common characters }
  chTab          = AsciiHT;
  chSpace        = AsciiSP;
  chDecimalPoint = AnsiChar('.');
  chComma        = AnsiChar(',');
  chBackSlash    = AnsiChar('\');
  chForwardSlash = AnsiChar('/');
  chPercent      = AnsiChar('%');
  chAmpersand    = AnsiChar('&');
  chPlus         = AnsiChar('+');
  chMinus        = AnsiChar('-');
  chEqual        = AnsiChar('=');
  chLessThan     = AnsiChar('<');
  chGreaterThan  = AnsiChar('>');
  chSingleQuote  = AnsiChar('''');
  chDoubleQuote  = AnsiChar('"');
  chExclamation  = AnsiChar('!');
  chHash         = AnsiChar('#');
  chDollar       = AnsiChar('$');
  chCaret        = AnsiChar('^');
  chAsterisk     = AnsiChar('*');

  { Common sequences }
  CRLF        = AsciiCR + AsciiLF;
  LFCR        = AsciiLF + AsciiCR;
  DosNewLine  = CRLF;
  UnixNewLine = AsciiLF;

  { Character sets }
  csComplete        = [AnsiChar(#0)..AnsiChar(#255)];
  csAnsi            = [AnsiChar(#0)..AnsiChar(#255)];
  csAscii           = [AnsiChar(#0)..AnsiChar(#127)];
  csNotAscii        = csComplete - csAscii;
  csAsciiCtl        = [AnsiChar(#0)..AnsiChar(#31)];
  csAsciiText       = [AnsiChar(#32)..AnsiChar(#127)];
  csAlphaLow        = [AnsiChar('a')..AnsiChar('z')];
  csAlphaUp         = [AnsiChar('A')..AnsiChar('Z')];
  csAlpha           = csAlphaLow + csAlphaUp;
  csNotAlpha        = csComplete - csAlpha;
  csNumeric         = [AnsiChar('0')..AnsiChar('9')];
  csNotNumeric      = csComplete - csNumeric;
  csAlphaNumeric    = csNumeric + csAlpha;
  csNotAlphaNumeric = csComplete - csAlphaNumeric;
  csWhiteSpace      = csAsciiCtl + [AnsiChar(#32)];
  csSign            = [chPlus, chMinus];
  csExponent        = [AnsiChar('E'), AnsiChar('e')];
  csBinaryDigit     = [AnsiChar('0')..AnsiChar('1')];
  csOctalDigit      = [AnsiChar('0')..AnsiChar('7')];
  csHexDigitLow     = csNumeric + [AnsiChar('a')..AnsiChar('f')];
  csHexDigitUp      = csNumeric + [AnsiChar('A')..AnsiChar('F')];
  csHexDigit        = csNumeric + [AnsiChar('A')..AnsiChar('F'), AnsiChar('a')..AnsiChar('f')];
  csQuotes          = [chSingleQuote, chDoubleQuote];
  csParentheses     = [AnsiChar('('), AnsiChar(')')];
  csCurlyBrackets   = [AnsiChar('{'), AnsiChar('}')];
  csBlockBrackets   = [AnsiChar('['), AnsiChar(']')];
  csPunctuation     = [AnsiChar('.'), AnsiChar(','), AnsiChar(':'), AnsiChar('/'),
                       AnsiChar('?'), AnsiChar('<'), AnsiChar('>'), AnsiChar(';'),
                       AnsiChar('"'), AnsiChar(''''), AnsiChar('['), AnsiChar(']'),
                       AnsiChar('{'), AnsiChar('}'), AnsiChar('+'), AnsiChar('='),
                       AnsiChar('-'), AnsiChar('\'), AnsiChar('('), AnsiChar(')'),
                       AnsiChar('*'), AnsiChar('&'), AnsiChar('^'), AnsiChar('%'),
                       AnsiChar('$'), AnsiChar('#'), AnsiChar('@'), AnsiChar('!'),
                       AnsiChar('`'), AnsiChar('~')];
  csSlash           = [chBackSlash, chForwardSlash];



{                                                                              }
{ UCS4 constants                                                               }
{                                                                              }
const
  Ucs4NULL             = UCS4Char(AsciiNULL);
  Ucs4HT               = UCS4Char(AsciiHT);
  Ucs4LF               = UCS4Char(AsciiLF);
  Ucs4CR               = UCS4Char(AsciiCR);
  Ucs4StringTerminator = UCS4Char($9C);



{                                                                              }
{ String functions                                                             }
{                                                                              }
{$IFDEF SupportAnsiString}
procedure SetLengthAndZeroA(var S: AnsiString; const NewLength: Integer);
{$ENDIF}
procedure SetLengthAndZeroB(var S: RawByteString; const NewLength: Integer);
{$IFDEF SupportWideString}
procedure SetLengthAndZeroW(var S: WideString; const NewLength: Integer);
{$ENDIF}
{$IFDEF SupportUnicodeString}
procedure SetLengthAndZeroU(var S: UnicodeString; const NewLength: Integer);
{$ENDIF}

function  ToStringChA(const A: AnsiChar): String; {$IFDEF UseInline}inline;{$ENDIF}
function  ToStringChW(const A: WideChar): String; {$IFDEF UseInline}inline;{$ENDIF}

{$IFDEF SupportAnsiString}
function  ToStringA(const A: AnsiString): String; {$IFDEF UseInline}inline;{$ENDIF}
{$ENDIF}
function  ToStringB(const A: RawByteString): String; {$IFDEF UseInline}inline;{$ENDIF}
{$IFDEF SupportWideString}
function  ToStringW(const A: WideString): String; {$IFDEF UseInline}inline;{$ENDIF}
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  ToStringU(const A: UnicodeString): String; {$IFDEF UseInline}inline;{$ENDIF}
{$ENDIF}



{                                                                              }
{ Match                                                                        }
{                                                                              }
function  CharMatchNoAsciiCaseA(const A, B: AnsiChar): Boolean;
function  CharMatchNoAsciiCaseW(const A, B: WideChar): Boolean;
function  CharMatchNoAsciiCaseAW(const A: AnsiChar; const B: WideChar): Boolean;
function  CharMatchNoAsciiCaseAS(const A: AnsiChar; const B: Char): Boolean;
function  CharMatchNoAsciiCase(const A, B: Char): Boolean;

function  CharMatchA(const A, B: AnsiChar; const AsciiCaseSensitive: Boolean = True): Boolean;
function  CharMatchW(const A, B: WideChar; const AsciiCaseSensitive: Boolean = True): Boolean;
function  CharMatchAW(const A: AnsiChar; const B: WideChar; const AsciiCaseSensitive: Boolean = True): Boolean;
function  CharMatchAS(const A: AnsiChar; const B: Char; const AsciiCaseSensitive: Boolean = True): Boolean;
function  CharMatch(const A, B: Char; const AsciiCaseSensitive: Boolean = True): Boolean;

function  CharSetMatchCharA(const A: ByteCharSet; const B: AnsiChar; const AsciiCaseSensitive: Boolean = True): Boolean;
function  CharSetMatchCharW(const A: ByteCharSet; const B: WideChar; const AsciiCaseSensitive: Boolean = True): Boolean;
function  CharSetMatchChar(const A: ByteCharSet; const B: Char; const AsciiCaseSensitive: Boolean = True): Boolean;

{$IFNDEF ManagedCode}
function  StrPMatchA(const A, B: PByteChar; const Len: Integer): Boolean; overload;
function  StrPMatchW(const A, B: PWideChar; const Len: Integer): Boolean; overload;
function  StrPMatchAW(const A: PWideChar; B: PByteChar; const Len: Integer): Boolean; overload;
function  StrPMatchAS(const A: PChar; B: PByteChar; const Len: Integer): Boolean; overload;
function  StrPMatch(const A, B: PChar; const Len: Integer): Boolean; overload;

function  StrPMatchA(const S, M: PByteChar; const LenS, LenM: Integer): Boolean; overload;
function  StrPMatchW(const S, M: PWideChar; const LenS, LenM: Integer): Boolean; overload;
function  StrPMatchAW(const S: PWideChar; const M: PByteChar; const LenS, LenM: Integer): Boolean; overload;
function  StrPMatchAS(const S: PChar; const M: PByteChar; const LenS, LenM: Integer): Boolean; overload;
function  StrPMatch(const S, M: PChar; const LenS, LenM: Integer): Boolean; overload;
function  StrPMatchStrPA(const S: PChar; const M: PByteChar; const LenS, LenM: Integer): Boolean;

{$IFDEF SupportAnsiString}
function  StrPMatchStrA(const S: PAnsiChar; const Len: Integer; const M: AnsiString): Boolean;
{$ENDIF}
function  StrPMatchStrB(const S: PByteChar; const Len: Integer; const M: RawByteString): Boolean;
{$IFDEF SupportWideString}
function  StrPMatchStrW(const S: PWideChar; const Len: Integer; const M: WideString): Boolean;
{$ENDIF}
{$IFDEF SupportAnsiString}
function  StrPMatchStrAW(const S: PWideChar; const Len: Integer; const M: AnsiString): Boolean;
function  StrPMatchStrAS(const S: PChar; const Len: Integer; const M: AnsiString): Boolean;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrPMatchStrU(const S: PWideChar; const Len: Integer; const M: UnicodeString): Boolean;
{$ENDIF}
function  StrPMatchStr(const S: PChar; const Len: Integer; const M: String): Boolean;

function  StrPMatchNoAsciiCaseA(const A, B: PByteChar; const Len: Integer): Boolean;
function  StrPMatchNoAsciiCaseW(const A, B: PWideChar; const Len: Integer): Boolean;
function  StrPMatchNoAsciiCaseAW(const A: PWideChar; const B: PByteChar; const Len: Integer): Boolean;
function  StrPMatchNoAsciiCaseAS(const A: PChar; const B: PByteChar; const Len: Integer): Boolean;
function  StrPMatchNoAsciiCase(const A, B: PChar; const Len: Integer): Boolean;

function  StrPMatchLenA(const P: PByteChar; const Len: Integer; const M: ByteCharSet): Integer;
function  StrPMatchLenW(const P: PWideChar; const Len: Integer; const M: ByteCharSet): Integer; overload;
function  StrPMatchLenW(const P: PWideChar; const Len: Integer; const M: TWideCharMatchFunction): Integer; overload;
function  StrPMatchLen(const P: PChar; const Len: Integer; const M: ByteCharSet): Integer;

function  StrPMatchCountA(const P: PByteChar; const Len: Integer; const M: ByteCharSet): Integer;
function  StrPMatchCountW(const P: PWideChar; const Len: Integer; const M: ByteCharSet): Integer; overload;
function  StrPMatchCountW(const P: PWideChar; const Len: Integer; const M: TWideCharMatchFunction): Integer; overload;

function  StrPMatchCharA(const P: PByteChar; const Len: Integer; const M: ByteCharSet): Boolean;
function  StrPMatchCharW(const P: PWideChar; const Len: Integer; const M: ByteCharSet): Boolean; overload;
function  StrPMatchCharW(const P: PWideChar; const Len: Integer; const M: TWideCharMatchFunction): Boolean; overload;
function  StrPMatchChar(const P: PChar; const Len: Integer; const M: ByteCharSet): Boolean;
{$ENDIF}

{$IFDEF SupportAnsiString}
function  StrMatchA(const S, M: AnsiString; const Index: Integer = 1): Boolean;
{$ENDIF}
function  StrMatchB(const S, M: RawByteString; const Index: Integer = 1): Boolean;
{$IFDEF SupportWideString}
function  StrMatchW(const S, M: WideString; const Index: Integer = 1): Boolean;
function  StrMatchAW(const S: WideString; const M: AnsiString; const Index: Integer = 1): Boolean;
function  StrMatchBW(const S: WideString; const M: RawByteString; const Index: Integer): Boolean;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrMatchU(const S, M: UnicodeString; const Index: Integer = 1): Boolean;
{$ENDIF}
{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function  StrMatchAU(const S: UnicodeString; const M: AnsiString; const Index: Integer = 1): Boolean;
{$ENDIF}
function  StrMatchAS(const S: String; const M: AnsiString; const Index: Integer = 1): Boolean;
{$ENDIF}
function  StrMatch(const S, M: String; const Index: Integer = 1): Boolean;

{$IFDEF SupportAnsiString}
function  StrMatchNoAsciiCaseA(const S, M: AnsiString; const Index: Integer = 1): Boolean;
{$ENDIF}
function  StrMatchNoAsciiCaseB(const S, M: RawByteString; const Index: Integer = 1): Boolean;
{$IFDEF SupportWideString}
function  StrMatchNoAsciiCaseW(const S, M: WideString; const Index: Integer = 1): Boolean;
function  StrMatchNoAsciiCaseAW(const S: WideString; const M: AnsiString; const Index: Integer = 1): Boolean;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrMatchNoAsciiCaseU(const S, M: UnicodeString; const Index: Integer = 1): Boolean;
{$ENDIF}
{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function  StrMatchNoAsciiCaseAU(const S: UnicodeString; const M: AnsiString; const Index: Integer = 1): Boolean;
{$ENDIF}
function  StrMatchNoAsciiCaseAS(const S: String; const M: AnsiString; const Index: Integer = 1): Boolean;
{$ENDIF}
function  StrMatchNoAsciiCase(const S, M: String; const Index: Integer = 1): Boolean;

{$IFDEF SupportAnsiString}
function  StrMatchLeftA(const S, M: AnsiString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
function  StrMatchLeftB(const S, M: RawByteString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$IFDEF SupportWideString}
function  StrMatchLeftW(const S, M: WideString; const AsciiCaseSensitive: Boolean = True): Boolean;
function  StrMatchLeftAW(const S: WideString; const M: AnsiString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrMatchLeftU(const S, M: UnicodeString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function  StrMatchLeftAU(const S: UnicodeString; const M: AnsiString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
{$ENDIF}
function  StrMatchLeft(const S, M: String; const AsciiCaseSensitive: Boolean = True): Boolean;

{$IFDEF SupportAnsiString}
function  StrMatchRightA(const S, M: AnsiString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
function  StrMatchRightB(const S, M: RawByteString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$IFDEF SupportWideString}
function  StrMatchRightW(const S, M: WideString; const AsciiCaseSensitive: Boolean = True): Boolean;
function  StrMatchRightAW(const S: WideString; const M: AnsiString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrMatchRightU(const S, M: UnicodeString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function  StrMatchRightAU(const S: UnicodeString; const M: AnsiString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
{$ENDIF}
function  StrMatchRight(const S, M: String; const AsciiCaseSensitive: Boolean = True): Boolean;

{$IFDEF SupportAnsiString}
function  StrMatchLenA(const S: AnsiString; const M: ByteCharSet; const Index: Integer = 1): Integer;
{$ENDIF}
function  StrMatchLenB(const S: RawByteString; const M: ByteCharSet; const Index: Integer = 1): Integer;
{$IFDEF SupportWideString}
function  StrMatchLenW(const S: WideString; const M: ByteCharSet; const Index: Integer = 1): Integer; overload;
function  StrMatchLenW(const S: WideString; const M: TWideCharMatchFunction; const Index: Integer = 1): Integer; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrMatchLenU(const S: UnicodeString; const M: ByteCharSet; const Index: Integer = 1): Integer; overload;
function  StrMatchLenU(const S: UnicodeString; const M: TWideCharMatchFunction; const Index: Integer = 1): Integer; overload;
{$ENDIF}
function  StrMatchLen(const S: String; const M: ByteCharSet; const Index: Integer = 1): Integer;

{$IFDEF SupportAnsiString}
function  StrMatchCharA(const S: AnsiString; const M: ByteCharSet): Boolean;
{$ENDIF}
function  StrMatchCharB(const S: RawByteString; const M: ByteCharSet): Boolean;
{$IFDEF SupportWideString}
function  StrMatchCharW(const S: WideString; const M: ByteCharSet): Boolean; overload;
function  StrMatchCharW(const S: WideString; const M: TWideCharMatchFunction): Boolean; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrMatchCharU(const S: UnicodeString; const M: ByteCharSet): Boolean; overload;
function  StrMatchCharU(const S: UnicodeString; const M: TWideCharMatchFunction): Boolean; overload;
{$ENDIF}
function  StrMatchChar(const S: String; const M: ByteCharSet): Boolean;



{                                                                              }
{ Equal                                                                        }
{                                                                              }
{$IFNDEF ManagedCode}
function  StrPEqual(const P1, P2: PByteChar; const Len1, Len2: Integer; const AsciiCaseSensitive: Boolean = True): Boolean;
{$IFDEF SupportAnsiString}
function  StrPEqualStr(const P: PAnsiChar; const Len: Integer; const S: AnsiString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportAnsiString}
function  StrEqualA(const A, B: AnsiString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
function  StrEqualB(const A, B: RawByteString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$IFDEF SupportWideString}
function  StrEqualW(const A, B: WideString; const AsciiCaseSensitive: Boolean = True): Boolean;
function  StrEqualAW(const A: WideString; const B: AnsiString; const AsciiCaseSensitive: Boolean = True): Boolean;
function  StrEqualBW(const A: WideString; const B: RawByteString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrEqualU(const A, B: UnicodeString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function  StrEqualAU(const A: UnicodeString; const B: AnsiString; const AsciiCaseSensitive: Boolean = True): Boolean;
{$ENDIF}
{$ENDIF}
function  StrEqual(const A, B: String; const AsciiCaseSensitive: Boolean = True): Boolean;

{$IFDEF SupportAnsiString}
function  StrEqualNoAsciiCaseA(const A, B: AnsiString): Boolean;
{$ENDIF}
function  StrEqualNoAsciiCaseB(const A, B: RawByteString): Boolean;
{$IFDEF SupportWideString}
function  StrEqualNoAsciiCaseW(const A, B: WideString): Boolean;
function  StrEqualNoAsciiCaseAW(const A: WideString; const B: AnsiString): Boolean;
function  StrEqualNoAsciiCaseBW(const A: WideString; const B: RawByteString): Boolean;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrEqualNoAsciiCaseU(const A, B: UnicodeString): Boolean;
{$ENDIF}
{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function  StrEqualNoAsciiCaseAU(const A: UnicodeString; const B: AnsiString): Boolean;
{$ENDIF}
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrEqualNoAsciiCaseBU(const A: UnicodeString; const B: RawByteString): Boolean;
{$ENDIF}
function  StrEqualNoAsciiCase(const A, B: String): Boolean;



{                                                                              }
{ Validation                                                                   }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrIsNumericA(const S: AnsiString): Boolean;
{$ENDIF}
function  StrIsNumericB(const S: RawByteString): Boolean;
{$IFDEF SupportWideString}
function  StrIsNumericW(const S: WideString): Boolean;
{$ENDIF}
function  StrIsNumeric(const S: String): Boolean;

{$IFDEF SupportAnsiString}
function  StrIsHexA(const S: AnsiString): Boolean;
{$ENDIF}
function  StrIsHexB(const S: RawByteString): Boolean;
{$IFDEF SupportWideString}
function  StrIsHexW(const S: WideString): Boolean;
{$ENDIF}
function  StrIsHex(const S: String): Boolean;

{$IFDEF SupportAnsiString}
function  StrIsAlphaA(const S: AnsiString): Boolean;
{$ENDIF}
function  StrIsAlphaB(const S: RawByteString): Boolean;
{$IFDEF SupportWideString}
function  StrIsAlphaW(const S: WideString): Boolean;
{$ENDIF}
function  StrIsAlpha(const S: String): Boolean;

{$IFDEF SupportAnsiString}
function  StrIsAlphaNumericA(const S: AnsiString): Boolean;
{$ENDIF}
function  StrIsAlphaNumericB(const S: RawByteString): Boolean;
{$IFDEF SupportWideString}
function  StrIsAlphaNumericW(const S: WideString): Boolean;
{$ENDIF}
function  StrIsAlphaNumeric(const S: String): Boolean;

{$IFDEF SupportAnsiString}
function  StrIsIntegerA(const S: AnsiString): Boolean;
{$ENDIF}
function  StrIsIntegerB(const S: RawByteString): Boolean;
{$IFDEF SupportWideString}
function  StrIsIntegerW(const S: WideString): Boolean;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrIsIntegerU(const S: UnicodeString): Boolean;
{$ENDIF}
function  StrIsInteger(const S: String): Boolean;



{                                                                              }
{ Pos                                                                          }
{                                                                              }
{$IFNDEF ManagedCode}
function  StrPPosCharA(const F: AnsiChar; const S: PByteChar; const Len: Integer): Integer;
function  StrPPosCharW(const F: WideChar; const S: PWideChar; const Len: Integer): Integer;

function  StrPPosCharSetA(const F: ByteCharSet; const S: PByteChar; const Len: Integer): Integer;
function  StrPPosCharSetW(const F: ByteCharSet; const S: PWideChar; const Len: Integer): Integer;

function  StrPPosA(const F, S: PByteChar; const LenF, LenS: Integer): Integer;
function  StrPPosW(const F, S: PWideChar; const LenF, LenS: Integer): Integer;

{$IFDEF SupportAnsiString}
function  StrPPosStrA(const F: AnsiString; const S: PAnsiChar; const Len: Integer): Integer;
{$ENDIF}
function  StrPPosStrB(const F: RawByteString; const S: PByteChar; const Len: Integer): Integer;
{$ENDIF}

{$IFDEF SupportAnsiString}
function  PosCharA(const F: AnsiChar; const S: AnsiString; const Index: Integer = 1): Integer;
{$ENDIF}
function  PosCharB(const F: AnsiChar; const S: RawByteString; const Index: Integer = 1): Integer;
{$IFDEF SupportWideString}
function  PosCharW(const F: WideChar; const S: WideString; const Index: Integer = 1): Integer;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  PosCharU(const F: WideChar; const S: UnicodeString; const Index: Integer = 1): Integer;
{$ENDIF}
function  PosChar(const F: Char; const S: String; const Index: Integer = 1): Integer;

{$IFDEF SupportAnsiString}
function  PosCharSetA(const F: ByteCharSet; const S: AnsiString; const Index: Integer = 1): Integer;
{$ENDIF}
function  PosCharSetB(const F: ByteCharSet; const S: RawByteString; const Index: Integer = 1): Integer;
{$IFDEF SupportWideString}
function  PosCharSetW(const F: ByteCharSet; const S: WideString; const Index: Integer = 1): Integer; overload;
{$ENDIF}
{$IFDEF SupportWideString}
function  PosCharSetW(const F: TWideCharMatchFunction; const S: WideString; const Index: Integer = 1): Integer; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  PosCharSetU(const F: ByteCharSet; const S: UnicodeString; const Index: Integer = 1): Integer; overload;
function  PosCharSetU(const F: TWideCharMatchFunction; const S: UnicodeString; const Index: Integer = 1): Integer; overload;
{$ENDIF}
function  PosCharSet(const F: ByteCharSet; const S: String; const Index: Integer = 1): Integer;

{$IFDEF SupportAnsiString}
function  PosNotCharA(const F: AnsiChar; const S: AnsiString; const Index: Integer = 1): Integer;
{$ENDIF}
function  PosNotCharB(const F: AnsiChar; const S: RawByteString; const Index: Integer = 1): Integer;
{$IFDEF SupportWideString}
function  PosNotCharW(const F: WideChar; const S: WideString; const Index: Integer = 1): Integer;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  PosNotCharU(const F: WideChar; const S: UnicodeString; const Index: Integer = 1): Integer;
{$ENDIF}
function  PosNotChar(const F: Char; const S: String; const Index: Integer = 1): Integer;

{$IFDEF SupportAnsiString}
function  PosNotCharSetA(const F: ByteCharSet; const S: AnsiString; const Index: Integer = 1): Integer;
{$ENDIF}
function  PosNotCharSetB(const F: ByteCharSet; const S: RawByteString; const Index: Integer = 1): Integer;
{$IFDEF SupportWideString}
function  PosNotCharSetW(const F: ByteCharSet; const S: WideString; const Index: Integer = 1): Integer; overload;
function  PosNotCharSetW(const F: TWideCharMatchFunction; const S: WideString; const Index: Integer = 1): Integer; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  PosNotCharSetU(const F: ByteCharSet; const S: UnicodeString; const Index: Integer = 1): Integer; overload;
function  PosNotCharSetU(const F: TWideCharMatchFunction; const S: UnicodeString; const Index: Integer = 1): Integer; overload;
{$ENDIF}
function  PosNotCharSet(const F: ByteCharSet; const S: String; const Index: Integer = 1): Integer;

{$IFDEF SupportAnsiString}
function  PosCharRevA(const F: AnsiChar; const S: AnsiString; const Index: Integer = 1): Integer;
{$ENDIF}
function  PosCharRevB(const F: AnsiChar; const S: RawByteString; const Index: Integer = 1): Integer;
{$IFDEF SupportWideString}
function  PosCharRevW(const F: WideChar; const S: WideString; const Index: Integer = 1): Integer;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  PosCharRevU(const F: WideChar; const S: UnicodeString; const Index: Integer = 1): Integer;
{$ENDIF}
function  PosCharRev(const F: Char; const S: String; const Index: Integer = 1): Integer;

{$IFDEF SupportAnsiString}
function  PosCharSetRevA(const F: ByteCharSet; const S: AnsiString; const Index: Integer = 1): Integer;
{$ENDIF}
function  PosCharSetRevB(const F: ByteCharSet; const S: RawByteString; const Index: Integer = 1): Integer;
{$IFDEF SupportWideString}
function  PosCharSetRevW(const F: ByteCharSet; const S: WideString; const Index: Integer = 1): Integer; overload;
function  PosCharSetRevW(const F: TWideCharMatchFunction; const S: WideString; const Index: Integer = 1): Integer; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  PosCharSetRevU(const F: ByteCharSet; const S: UnicodeString; const Index: Integer = 1): Integer; overload;
function  PosCharSetRevU(const F: TWideCharMatchFunction; const S: UnicodeString; const Index: Integer = 1): Integer; overload;
{$ENDIF}
function  PosCharSetRev(const F: ByteCharSet; const S: String; const Index: Integer = 1): Integer;

{$IFDEF SupportAnsiString}
function  PosStrA(const F, S: AnsiString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
function  PosStrB(const F, S: RawByteString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$IFDEF SupportWideString}
function  PosStrW(const F, S: WideString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
function  PosStrAW(const F: AnsiString; const S: WideString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  PosStrU(const F, S: UnicodeString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function  PosStrAU(const F: AnsiString; const S: UnicodeString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
{$ENDIF}
function  PosStr(const F, S: String; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;

{$IFDEF SupportAnsiString}
function  PosStrRevA(const F, S: AnsiString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
function  PosStrRevB(const F, S: RawByteString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$IFDEF SupportWideString}
function  PosStrRevW(const F, S: WideString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  PosStrRevU(const F, S: UnicodeString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
function  PosStrRev(const F, S: String; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;

{$IFDEF SupportAnsiString}
function  PosStrRevIdxA(const F, S: AnsiString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
function  PosStrRevIdxB(const F, S: RawByteString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$IFDEF SupportWideString}
function  PosStrRevIdxW(const F, S: WideString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  PosStrRevIdxU(const F, S: UnicodeString; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
function  PosStrRevIdx(const F, S: String; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;

{$IFDEF SupportAnsiString}
function  PosNStrA(const F, S: AnsiString; const N: Integer; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
function  PosNStrB(const F, S: RawByteString; const N: Integer; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$IFDEF SupportWideString}
function  PosNStrW(const F, S: WideString; const N: Integer; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  PosNStrU(const F, S: UnicodeString; const N: Integer; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;
{$ENDIF}
function  PosNStr(const F, S: String; const N: Integer; const Index: Integer = 1; const AsciiCaseSensitive: Boolean = True): Integer;



{                                                                              }
{ Copy                                                                         }
{                                                                              }
{   Out-of-range values of StartIndex, StopIndex and Count are clipped.        }
{   These variants return a reference to the existing string if possible.      }
{                                                                              }
{$IFDEF SupportAnsiString}
function  CopyRangeA(const S: AnsiString; const StartIndex, StopIndex: Integer): AnsiString;
{$ENDIF}
function  CopyRangeB(const S: RawByteString; const StartIndex, StopIndex: Integer): RawByteString;
{$IFDEF SupportWideString}
function  CopyRangeW(const S: WideString; const StartIndex, StopIndex: Integer): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  CopyRangeU(const S: UnicodeString; const StartIndex, StopIndex: Integer): UnicodeString;
{$ENDIF}
function  CopyRange(const S: String; const StartIndex, StopIndex: Integer): String;

{$IFDEF SupportAnsiString}
function  CopyFromA(const S: AnsiString; const Index: Integer): AnsiString;
{$ENDIF}
function  CopyFromB(const S: RawByteString; const Index: Integer): RawByteString;
{$IFDEF SupportWideString}
function  CopyFromW(const S: WideString; const Index: Integer): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  CopyFromU(const S: UnicodeString; const Index: Integer): UnicodeString;
{$ENDIF}
function  CopyFrom(const S: String; const Index: Integer): String;

{$IFDEF SupportAnsiString}
function  CopyLeftA(const S: AnsiString; const Count: Integer): AnsiString;
{$ENDIF}
function  CopyLeftB(const S: RawByteString; const Count: Integer): RawByteString;
{$IFDEF SupportWideString}
function  CopyLeftW(const S: WideString; const Count: Integer): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  CopyLeftU(const S: UnicodeString; const Count: Integer): UnicodeString;
{$ENDIF}
function  CopyLeft(const S: String; const Count: Integer): String;

{$IFDEF SupportAnsiString}
function  CopyRightA(const S: AnsiString; const Count: Integer): AnsiString;
function  CopyRightB(const S: RawByteString; const Count: Integer): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  CopyRightW(const S: WideString; const Count: Integer): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  CopyRightU(const S: UnicodeString; const Count: Integer): UnicodeString;
{$ENDIF}
function  CopyRight(const S: String; const Count: Integer): String;

{$IFDEF SupportAnsiString}
function  CopyLeftEllipsedA(const S: AnsiString; const Count: Integer): AnsiString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  CopyLeftEllipsedU(const S: UnicodeString; const Count: Integer): UnicodeString;
{$ENDIF}



{                                                                              }
{ CopyEx                                                                       }
{                                                                              }
{   CopyEx functions extend Copy so that negative Start/Stop values reference  }
{   indexes from the end of the string, eg. -2 will reference the second last  }
{   character in the string.                                                   }
{                                                                              }
{$IFDEF SupportAnsiString}
function  CopyExA(const S: AnsiString; const Start, Count: Integer): AnsiString;
function  CopyExB(const S: RawByteString; const Start, Count: Integer): RawByteString;
{$ENDIF}
function  CopyExW(const S: String; const Start, Count: Integer): String;
{$IFDEF SupportUnicodeString}
function  CopyExU(const S: UnicodeString; const Start, Count: Integer): UnicodeString;
{$ENDIF}
function  CopyEx(const S: String; const Start, Count: Integer): String;

{$IFDEF SupportAnsiString}
function  CopyRangeExA(const S: AnsiString; const Start, Stop: Integer): AnsiString;
function  CopyRangeExB(const S: RawByteString; const Start, Stop: Integer): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  CopyRangeExW(const S: WideString; const Start, Stop: Integer): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  CopyRangeExU(const S: UnicodeString; const Start, Stop: Integer): UnicodeString;
{$ENDIF}
function  CopyRangeEx(const S: String; const Start, Stop: Integer): String;

{$IFDEF SupportAnsiString}
function  CopyFromExA(const S: AnsiString; const Start: Integer): AnsiString;
function  CopyFromExB(const S: RawByteString; const Start: Integer): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  CopyFromExW(const S: WideString; const Start: Integer): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  CopyFromExU(const S: UnicodeString; const Start: Integer): UnicodeString;
{$ENDIF}
function  CopyFromEx(const S: String; const Start: Integer): String;



{                                                                              }
{ Trim                                                                         }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrTrimLeftA(const S: AnsiString;    const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): AnsiString;
{$ENDIF}
function  StrTrimLeftB(const S: RawByteString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): RawByteString;
{$IFDEF SupportWideString}
function  StrTrimLeftW(const S: WideString;    const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): WideString; overload;
function  StrTrimLeftW(const S: WideString;    const C: TWideCharMatchFunction): WideString; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrTrimLeftU(const S: UnicodeString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): UnicodeString; overload;
function  StrTrimLeftU(const S: UnicodeString; const C: TWideCharMatchFunction): UnicodeString; overload;
{$ENDIF}
function  StrTrimLeft(const S: String;         const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): String;

{$IFDEF SupportAnsiString}
procedure StrTrimLeftInPlaceA(var S: AnsiString;    const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF});
{$ENDIF}
procedure StrTrimLeftInPlaceB(var S: RawByteString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF});
{$IFDEF SupportWideString}
procedure StrTrimLeftInPlaceW(var S: WideString;    const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}); overload;
procedure StrTrimLeftInPlaceW(var S: WideString;    const C: TWideCharMatchFunction); overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
procedure StrTrimLeftInPlaceU(var S: UnicodeString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}); overload;
procedure StrTrimLeftInPlaceU(var S: UnicodeString; const C: TWideCharMatchFunction); overload;
{$ENDIF}
procedure StrTrimLeftInPlace(var S: String;         const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF});

{$IFDEF SupportAnsiString}
function  StrTrimLeftStrNoCaseA(const S: AnsiString; const TrimStr: AnsiString): AnsiString;
function  StrTrimLeftStrNoCaseB(const S: RawByteString; const TrimStr: RawByteString): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrTrimLeftStrNoCaseW(const S: WideString; const TrimStr: WideString): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrTrimLeftStrNoCaseU(const S: UnicodeString; const TrimStr: UnicodeString): UnicodeString;
{$ENDIF}
function  StrTrimLeftStrNoCase(const S: String; const TrimStr: String): String;

{$IFDEF SupportAnsiString}
function  StrTrimRightA(const S: AnsiString;    const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): AnsiString;
{$ENDIF}
function  StrTrimRightB(const S: RawByteString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): RawByteString;
{$IFDEF SupportWideString}
function  StrTrimRightW(const S: WideString;    const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): WideString; overload;
function  StrTrimRightW(const S: WideString;    const C: TWideCharMatchFunction): WideString; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrTrimRightU(const S: UnicodeString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): UnicodeString; overload;
function  StrTrimRightU(const S: UnicodeString; const C: TWideCharMatchFunction): UnicodeString; overload;
{$ENDIF}
function  StrTrimRight(const S: String;         const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): String;

{$IFDEF SupportAnsiString}
procedure StrTrimRightInPlaceA(var S: AnsiString;    const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF});
{$ENDIF}
procedure StrTrimRightInPlaceB(var S: RawByteString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF});
{$IFDEF SupportWideString}
procedure StrTrimRightInPlaceW(var S: WideString;    const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}); overload;
procedure StrTrimRightInPlaceW(var S: WideString;    const C: TWideCharMatchFunction); overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
procedure StrTrimRightInPlaceU(var S: UnicodeString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}); overload;
procedure StrTrimRightInPlaceU(var S: UnicodeString; const C: TWideCharMatchFunction); overload;
{$ENDIF}
procedure StrTrimRightInPlace(var S: String;         const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF});

{$IFDEF SupportAnsiString}
function  StrTrimRightStrNoCaseA(const S: AnsiString; const TrimStr: AnsiString): AnsiString;
function  StrTrimRightStrNoCaseB(const S: RawByteString; const TrimStr: RawByteString): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrTrimRightStrNoCaseW(const S: WideString; const TrimStr: WideString): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrTrimRightStrNoCaseU(const S: UnicodeString; const TrimStr: UnicodeString): UnicodeString;
{$ENDIF}
function  StrTrimRightStrNoCase(const S: String; const TrimStr: String): String;

{$IFDEF SupportAnsiString}
function  StrTrimA(const S: AnsiString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): AnsiString;
{$ENDIF}
function  StrTrimB(const S: RawByteString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): RawByteString;
{$IFDEF SupportWideString}
function  StrTrimW(const S: WideString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): WideString; overload;
function  StrTrimW(const S: WideString; const C: TWideCharMatchFunction): WideString; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrTrimU(const S: UnicodeString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}): UnicodeString; overload;
function  StrTrimU(const S: UnicodeString; const C: TWideCharMatchFunction): UnicodeString; overload;
{$ENDIF}
function  StrTrim(const S: String; const C: ByteCharSet): String; overload;

{$IFDEF SupportAnsiString}
procedure StrTrimInPlaceA(var S: AnsiString;    const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF});
{$ENDIF}
procedure StrTrimInPlaceB(var S: RawByteString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF});
{$IFDEF SupportWideString}
procedure StrTrimInPlaceW(var S: WideString;    const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}); overload;
procedure StrTrimInPlaceW(var S: WideString;    const C: TWideCharMatchFunction); overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
procedure StrTrimInPlaceU(var S: UnicodeString; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}); overload;
procedure StrTrimInPlaceU(var S: UnicodeString; const C: TWideCharMatchFunction); overload;
{$ENDIF}
procedure StrTrimInPlace(var S: String;         const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF});

{$IFDEF SupportAnsiString}
procedure TrimStringsA(var S: AnsiStringArray; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}); overload;
{$ENDIF}
{$IFDEF SupportRawByteString}
procedure TrimStringsB(var S: RawByteStringArray; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}); overload;
{$ENDIF}
{$IFDEF SupportWideString}
procedure TrimStringsW(var S: WideStringArray; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}); overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
procedure TrimStringsU(var S: UnicodeStringArray; const C: ByteCharSet{$IFNDEF CLR} = csWhiteSpace{$ENDIF}); overload;
{$ENDIF}



{                                                                              }
{ Duplicate                                                                    }
{                                                                              }
{$IFNDEF ManagedCode}
{$IFDEF SupportAnsiString}
function  BufToStrA(const Buf; const BufSize: Integer): AnsiString;
{$ENDIF}
function  BufToStrB(const Buf; const BufSize: Integer): RawByteString;
{$IFDEF SupportWideString}
function  BufToStrW(const Buf; const BufSize: Integer): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  BufToStrU(const Buf; const BufSize: Integer): UnicodeString;
{$ENDIF}
function  BufToStr(const Buf; const BufSize: Integer): String;

{$IFDEF SupportAnsiString}
function  DupBufA(const Buf; const BufSize: Integer; const Count: Integer): AnsiString;
{$ENDIF}
function  DupBufB(const Buf; const BufSize: Integer; const Count: Integer): RawByteString;
{$IFDEF SupportWideString}
function  DupBufW(const Buf; const BufSize: Integer; const Count: Integer): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  DupBufU(const Buf; const BufSize: Integer; const Count: Integer): UnicodeString;
{$ENDIF}
function  DupBuf(const Buf; const BufSize: Integer; const Count: Integer): String;
{$ENDIF}

{$IFDEF SupportAnsiString}
function  DupStrA(const S: AnsiString; const Count: Integer): AnsiString;
{$ENDIF}
function  DupStrB(const S: RawByteString; const Count: Integer): RawByteString;
{$IFDEF SupportWideString}
function  DupStrW(const S: WideString; const Count: Integer): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  DupStrU(const S: UnicodeString; const Count: Integer): UnicodeString;
{$ENDIF}
function  DupStr(const S: String; const Count: Integer): String;

{$IFDEF SupportAnsiString}
function  DupCharA(const Ch: AnsiChar; const Count: Integer): AnsiString;
{$ENDIF}
function  DupCharB(const Ch: AnsiChar; const Count: Integer): RawByteString;
{$IFDEF SupportWideString}
function  DupCharW(const Ch: WideChar; const Count: Integer): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  DupCharU(const Ch: WideChar; const Count: Integer): UnicodeString;
{$ENDIF}
function  DupChar(const Ch: Char; const Count: Integer): String;

{$IFDEF SupportAnsiString}
function  DupSpaceA(const Count: Integer): AnsiString;
{$ENDIF}
function  DupSpaceB(const Count: Integer): RawByteString;
{$IFDEF SupportWideString}
function  DupSpaceW(const Count: Integer): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  DupSpaceU(const Count: Integer): UnicodeString;
{$ENDIF}
function  DupSpace(const Count: Integer): String;



{                                                                              }
{ Pad                                                                          }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrPadA(const S: AnsiString; const PadChar: AnsiChar; const Len: Integer;
          const Cut: Boolean = False): AnsiString;
{$ENDIF}
function  StrPadB(const S: RawByteString; const PadChar: AnsiChar; const Len: Integer;
          const Cut: Boolean = False): RawByteString;
{$IFDEF SupportWideString}
function  StrPadW(const S: WideString; const PadChar: WideChar; const Len: Integer;
          const Cut: Boolean = False): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrPadU(const S: UnicodeString; const PadChar: WideChar; const Len: Integer;
          const Cut: Boolean = False): UnicodeString;
{$ENDIF}
function  StrPad(const S: String; const PadChar: Char; const Len: Integer;
          const Cut: Boolean = False): String;

{$IFDEF SupportAnsiString}
function  StrPadLeftA(const S: AnsiString; const PadChar: AnsiChar;
          const Len: Integer; const Cut: Boolean = False): AnsiString;
{$ENDIF}
function  StrPadLeftB(const S: RawByteString; const PadChar: AnsiChar;
          const Len: Integer; const Cut: Boolean = False): RawByteString;
{$IFDEF SupportWideString}
function  StrPadLeftW(const S: WideString; const PadChar: WideChar;
          const Len: Integer; const Cut: Boolean = False): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrPadLeftU(const S: UnicodeString; const PadChar: WideChar;
          const Len: Integer; const Cut: Boolean = False): UnicodeString;
{$ENDIF}
function  StrPadLeft(const S: String; const PadChar: Char;
          const Len: Integer; const Cut: Boolean = False): String;

{$IFDEF SupportAnsiString}
function  StrPadRightA(const S: AnsiString; const PadChar: AnsiChar;
          const Len: Integer; const Cut: Boolean = False): AnsiString;
{$ENDIF}
function  StrPadRightB(const S: RawByteString; const PadChar: AnsiChar;
          const Len: Integer; const Cut: Boolean = False): RawByteString;
{$IFDEF SupportWideString}
function  StrPadRightW(const S: WideString; const PadChar: WideChar;
          const Len: Integer; const Cut: Boolean = False): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrPadRightU(const S: UnicodeString; const PadChar: WideChar;
          const Len: Integer; const Cut: Boolean = False): UnicodeString;
{$ENDIF}
function  StrPadRight(const S: String; const PadChar: Char;
          const Len: Integer; const Cut: Boolean = False): String;



{                                                                              }
{ Delimited                                                                    }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrBetweenCharA(const S: AnsiString;
          const FirstDelim, SecondDelim: AnsiChar;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False): AnsiString; overload;
function  StrBetweenCharA(const S: AnsiString;
          const FirstDelim, SecondDelim: ByteCharSet;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False): AnsiString; overload;

function  StrBetweenCharB(const S: RawByteString;
          const FirstDelim, SecondDelim: AnsiChar;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False): RawByteString; overload;
function  StrBetweenCharB(const S: RawByteString;
          const FirstDelim, SecondDelim: ByteCharSet;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False): RawByteString; overload;
{$ENDIF}

{$IFDEF SupportWideString}
function  StrBetweenCharW(const S: WideString;
          const FirstDelim, SecondDelim: WideChar;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False): WideString; overload;
function  StrBetweenCharW(const S: WideString;
          const FirstDelim, SecondDelim: ByteCharSet;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False): WideString; overload;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function  StrBetweenCharU(const S: UnicodeString;
          const FirstDelim, SecondDelim: WideChar;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False): UnicodeString; overload;
function  StrBetweenCharU(const S: UnicodeString;
          const FirstDelim, SecondDelim: ByteCharSet;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False): UnicodeString; overload;
{$ENDIF}

function  StrBetweenChar(const S: String;
          const FirstDelim, SecondDelim: Char;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False): String; overload;
function  StrBetweenChar(const S: String;
          const FirstDelim, SecondDelim: ByteCharSet;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False): String; overload;

{$IFDEF SupportAnsiString}
function  StrBetweenA(const S: AnsiString;
          const FirstDelim: AnsiString; const SecondDelim: ByteCharSet;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False;
          const FirstDelimAsciiCaseSensitive: Boolean = True): AnsiString; overload;
function  StrBetweenA(const S: AnsiString;
          const FirstDelim, SecondDelim: AnsiString;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False;
          const FirstDelimAsciiCaseSensitive: Boolean = True;
          const SecondDelimAsciiCaseSensitive: Boolean = True): AnsiString; overload;

function  StrBetweenB(const S: RawByteString;
          const FirstDelim: RawByteString; const SecondDelim: ByteCharSet;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False;
          const FirstDelimAsciiCaseSensitive: Boolean = True): RawByteString; overload;
function  StrBetweenB(const S: RawByteString;
          const FirstDelim, SecondDelim: RawByteString;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False;
          const FirstDelimAsciiCaseSensitive: Boolean = True;
          const SecondDelimAsciiCaseSensitive: Boolean = True): RawByteString; overload;
{$ENDIF}

{$IFDEF SupportWideString}
function  StrBetweenW(const S: WideString;
          const FirstDelim: WideString; const SecondDelim: ByteCharSet;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False;
          const FirstDelimAsciiCaseSensitive: Boolean = True): WideString; overload;
function  StrBetweenW(const S: WideString;
          const FirstDelim, SecondDelim: WideString;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False;
          const FirstDelimAsciiCaseSensitive: Boolean = True;
          const SecondDelimAsciiCaseSensitive: Boolean = True): WideString; overload;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function  StrBetweenU(const S: UnicodeString;
          const FirstDelim: UnicodeString; const SecondDelim: ByteCharSet;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False;
          const FirstDelimAsciiCaseSensitive: Boolean = True): UnicodeString; overload;
function  StrBetweenU(const S: UnicodeString;
          const FirstDelim, SecondDelim: UnicodeString;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False;
          const FirstDelimAsciiCaseSensitive: Boolean = True;
          const SecondDelimAsciiCaseSensitive: Boolean = True): UnicodeString; overload;
{$ENDIF}

function  StrBetween(const S: String;
          const FirstDelim: String; const SecondDelim: ByteCharSet;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False;
          const FirstDelimAsciiCaseSensitive: Boolean = True): String; overload;
function  StrBetween(const S: String;
          const FirstDelim, SecondDelim: String;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False;
          const FirstDelimAsciiCaseSensitive: Boolean = True;
          const SecondDelimAsciiCaseSensitive: Boolean = True): String; overload;

{$IFDEF SupportAnsiString}
function  StrBeforeA(const S, D: AnsiString;
          const Optional: Boolean = True;
          const AsciiCaseSensitive: Boolean = True): AnsiString;
function  StrBeforeRevA(const S, D: AnsiString;
          const Optional: Boolean = True;
          const AsciiCaseSensitive: Boolean = True): AnsiString;

function  StrBeforeB(const S, D: RawByteString;
          const Optional: Boolean = True;
          const AsciiCaseSensitive: Boolean = True): RawByteString;
function  StrBeforeRevB(const S, D: RawByteString;
          const Optional: Boolean = True;
          const AsciiCaseSensitive: Boolean = True): RawByteString;
{$ENDIF}

{$IFDEF SupportWideString}
function  StrBeforeW(const S, D: WideString;
          const Optional: Boolean = True;
          const AsciiCaseSensitive: Boolean = True): WideString;
function  StrBeforeRevW(const S, D: WideString;
          const Optional: Boolean = True;
          const AsciiCaseSensitive: Boolean = True): WideString;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function  StrBeforeU(const S, D: UnicodeString;
          const Optional: Boolean = True;
          const AsciiCaseSensitive: Boolean = True): UnicodeString;
function  StrBeforeRevU(const S, D: UnicodeString;
          const Optional: Boolean = True;
          const AsciiCaseSensitive: Boolean = True): UnicodeString;
{$ENDIF}

function  StrBefore(const S, D: String;
          const Optional: Boolean = True;
          const AsciiCaseSensitive: Boolean = True): String;
function  StrBeforeRev(const S, D: String;
          const Optional: Boolean = True;
          const AsciiCaseSensitive: Boolean = True): String;

{$IFDEF SupportAnsiString}
function  StrBeforeCharA(const S: AnsiString; const D: AnsiChar; const Optional: Boolean = True): AnsiString; overload;
function  StrBeforeCharA(const S: AnsiString; const D: ByteCharSet; const Optional: Boolean = True): AnsiString; overload;
function  StrBeforeCharRevA(const S: AnsiString; const D: ByteCharSet; const Optional: Boolean = True): AnsiString;

function  StrBeforeCharB(const S: RawByteString; const D: AnsiChar; const Optional: Boolean = True): RawByteString; overload;
function  StrBeforeCharB(const S: RawByteString; const D: ByteCharSet; const Optional: Boolean = True): RawByteString; overload;
function  StrBeforeCharRevB(const S: RawByteString; const D: ByteCharSet; const Optional: Boolean = True): RawByteString;
{$ENDIF}

{$IFDEF SupportWideString}
function  StrBeforeCharW(const S: WideString; const D: WideChar; const Optional: Boolean = True): WideString; overload;
function  StrBeforeCharW(const S: WideString; const D: ByteCharSet; const Optional: Boolean = True): WideString; overload;
function  StrBeforeCharRevW(const S: WideString; const D: ByteCharSet; const Optional: Boolean = True): WideString;
{$ENDIF}

function  StrBeforeChar(const S: String; const D: Char; const Optional: Boolean = True): String; overload;
function  StrBeforeChar(const S: String; const D: ByteCharSet; const Optional: Boolean = True): String; overload;
function  StrBeforeCharRev(const S: String; const D: ByteCharSet; const Optional: Boolean = True): String;

{$IFDEF SupportAnsiString}
function  StrAfterA(const S, D: AnsiString; const Optional: Boolean = False): AnsiString;
function  StrAfterRevA(const S, D: AnsiString; const Optional: Boolean = False): AnsiString;

function  StrAfterB(const S, D: RawByteString; const Optional: Boolean = False): RawByteString;
function  StrAfterRevB(const S, D: RawByteString; const Optional: Boolean = False): RawByteString;
{$ENDIF}

{$IFDEF SupportWideString}
function  StrAfterW(const S, D: WideString; const Optional: Boolean = False): WideString;
function  StrAfterRevW(const S, D: WideString; const Optional: Boolean = False): WideString;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function  StrAfterU(const S, D: UnicodeString; const Optional: Boolean = False): UnicodeString;
function  StrAfterRevU(const S, D: UnicodeString; const Optional: Boolean = False): UnicodeString;
{$ENDIF}

function  StrAfter(const S, D: String; const Optional: Boolean = False): String;
function  StrAfterRev(const S, D: String; const Optional: Boolean = False): String;

{$IFDEF SupportAnsiString}
function  StrAfterCharA(const S: AnsiString; const D: ByteCharSet): AnsiString; overload;
function  StrAfterCharA(const S: AnsiString; const D: AnsiChar): AnsiString; overload;

function  StrAfterCharB(const S: RawByteString; const D: ByteCharSet): RawByteString; overload;
function  StrAfterCharB(const S: RawByteString; const D: AnsiChar): RawByteString; overload;
{$ENDIF}

{$IFDEF SupportWideString}
function  StrAfterCharW(const S: WideString; const D: ByteCharSet): WideString; overload;
function  StrAfterCharW(const S: WideString; const D: WideChar): WideString; overload;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function  StrAfterCharU(const S: UnicodeString; const D: ByteCharSet): UnicodeString; overload;
function  StrAfterCharU(const S: UnicodeString; const D: WideChar): UnicodeString; overload;
{$ENDIF}

function  StrAfterChar(const S: String; const D: ByteCharSet): String; overload;
function  StrAfterChar(const S: String; const D: Char): String; overload;

{$IFDEF SupportAnsiString}
function  StrCopyToCharA(const S: AnsiString; const D: ByteCharSet;
          const Optional: Boolean = True): AnsiString; overload;
function  StrCopyToCharA(const S: AnsiString; const D: AnsiChar;
          const Optional: Boolean = True): AnsiString; overload;

function  StrCopyToCharB(const S: RawByteString; const D: ByteCharSet;
          const Optional: Boolean = True): RawByteString; overload;
function  StrCopyToCharB(const S: RawByteString; const D: AnsiChar;
          const Optional: Boolean = True): RawByteString; overload;
{$ENDIF}

{$IFDEF SupportWideString}
function  StrCopyToCharW(const S: WideString; const D: ByteCharSet;
          const Optional: Boolean = True): WideString; overload;
function  StrCopyToCharW(const S: WideString; const D: WideChar;
          const Optional: Boolean = True): WideString; overload;
{$ENDIF}

function  StrCopyToChar(const S: String; const D: ByteCharSet;
          const Optional: Boolean = True): String; overload;
function  StrCopyToChar(const S: String; const D: Char;
          const Optional: Boolean = True): String; overload;

{$IFDEF SupportAnsiString}
function  StrCopyFromCharA(const S: AnsiString; const D: ByteCharSet): AnsiString; overload;
function  StrCopyFromCharA(const S: AnsiString; const D: AnsiChar): AnsiString; overload;

function  StrCopyFromCharB(const S: RawByteString; const D: ByteCharSet): RawByteString; overload;
function  StrCopyFromCharB(const S: RawByteString; const D: AnsiChar): RawByteString; overload;
{$ENDIF}

{$IFDEF SupportWideString}
function  StrCopyFromCharW(const S: WideString; const D: ByteCharSet): WideString; overload;
function  StrCopyFromCharW(const S: WideString; const D: WideChar): WideString; overload;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function  StrCopyFromCharU(const S: UnicodeString; const D: ByteCharSet): UnicodeString; overload;
function  StrCopyFromCharU(const S: UnicodeString; const D: WideChar): UnicodeString; overload;
{$ENDIF}

function  StrCopyFromChar(const S: String; const D: ByteCharSet): String; overload;
function  StrCopyFromChar(const S: String; const D: Char): String; overload;

{$IFDEF SupportAnsiString}
function  StrRemoveCharDelimitedA(var S: AnsiString;
          const FirstDelim, SecondDelim: AnsiChar): AnsiString;
function  StrRemoveCharDelimitedB(var S: RawByteString;
          const FirstDelim, SecondDelim: AnsiChar): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrRemoveCharDelimitedW(var S: WideString;
          const FirstDelim, SecondDelim: WideChar): WideString;
function  StrRemoveCharDelimited(var S: String;
          const FirstDelim, SecondDelim: Char): String;
{$ENDIF}



{                                                                              }
{ Count                                                                        }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrCountCharA(const S: AnsiString; const C: AnsiChar): Integer; overload;
function  StrCountCharB(const S: RawByteString; const C: AnsiChar): Integer; overload;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrCountCharW(const S: WideString; const C: WideChar): Integer; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrCountCharU(const S: UnicodeString; const C: WideChar): Integer; overload;
{$ENDIF}
function  StrCountChar(const S: String; const C: Char): Integer; overload;

{$IFDEF SupportAnsiString}
function  StrCountCharA(const S: AnsiString; const C: ByteCharSet): Integer; overload;
function  StrCountCharB(const S: RawByteString; const C: ByteCharSet): Integer; overload;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrCountCharW(const S: WideString; const C: ByteCharSet): Integer; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrCountCharU(const S: UnicodeString; const C: ByteCharSet): Integer; overload;
{$ENDIF}
function  StrCountChar(const S: String; const C: ByteCharSet): Integer; overload;



{                                                                              }
{ Replace                                                                      }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrReplaceCharA(const Find, Replace: AnsiChar; const S: AnsiString): AnsiString; overload;
{$ENDIF}
function  StrReplaceCharB(const Find, Replace: AnsiChar; const S: RawByteString): RawByteString; overload;
{$IFDEF SupportWideString}
function  StrReplaceCharW(const Find, Replace: WideChar; const S: WideString): WideString; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrReplaceCharU(const Find, Replace: WideChar; const S: UnicodeString): UnicodeString; overload;
{$ENDIF}
function  StrReplaceChar(const Find, Replace: Char; const S: String): String; overload;

{$IFDEF SupportAnsiString}
function  StrReplaceCharA(const Find: ByteCharSet; const Replace: AnsiChar; const S: AnsiString): AnsiString; overload;
{$ENDIF}
function  StrReplaceCharB(const Find: ByteCharSet; const Replace: AnsiChar; const S: RawByteString): RawByteString; overload;
{$IFDEF SupportWideString}
function  StrReplaceCharW(const Find: ByteCharSet; const Replace: WideChar; const S: WideString): WideString; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrReplaceCharU(const Find: ByteCharSet; const Replace: WideChar; const S: UnicodeString): UnicodeString; overload;
{$ENDIF}
function  StrReplaceChar(const Find: ByteCharSet; const Replace: Char; const S: String): String; overload;

{$IFDEF SupportAnsiString}
function  StrReplaceA(const Find, Replace, S: AnsiString; const AsciiCaseSensitive: Boolean = True): AnsiString; overload;
{$ENDIF}
function  StrReplaceB(const Find, Replace, S: RawByteString; const AsciiCaseSensitive: Boolean = True): RawByteString; overload;
{$IFDEF SupportWideString}
function  StrReplaceW(const Find, Replace, S: WideString; const AsciiCaseSensitive: Boolean = True): WideString; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrReplaceU(const Find, Replace, S: UnicodeString; const AsciiCaseSensitive: Boolean = True): UnicodeString; overload;
{$ENDIF}
function  StrReplace(const Find, Replace, S: String; const AsciiCaseSensitive: Boolean = True): String; overload;

{$IFNDEF CLR}
{$IFDEF SupportAnsiString}
function  StrReplaceA(const Find: ByteCharSet; const Replace, S: AnsiString): AnsiString; overload;
{$ENDIF}
function  StrReplaceB(const Find: ByteCharSet; const Replace, S: RawByteString): RawByteString; overload;
{$IFDEF SupportWideString}
function  StrReplaceW(const Find: ByteCharSet; const Replace, S: WideString): WideString; overload;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrReplaceU(const Find: ByteCharSet; const Replace, S: UnicodeString): UnicodeString; overload;
{$ENDIF}
function  StrReplace(const Find: ByteCharSet; const Replace, S: String): String; overload;

{$IFDEF SupportAnsiString}
function  StrReplaceCharStrA(const Find: AnsiChar; const Replace, S: AnsiString): AnsiString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrReplaceCharStrW(const Find: WideChar; const Replace, S: WideString): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrReplaceCharStrU(const Find: WideChar; const Replace, S: UnicodeString): UnicodeString;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportAnsiString}
function  StrRemoveDupA(const S: AnsiString; const C: AnsiChar): AnsiString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrRemoveDupW(const S: WideString; const C: WideChar): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrRemoveDupU(const S: UnicodeString; const C: WideChar): UnicodeString;
{$ENDIF}
function  StrRemoveDup(const S: String; const C: Char): String;

{$IFDEF SupportAnsiString}
function  StrRemoveCharA(const S: AnsiString; const C: AnsiChar): AnsiString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrRemoveCharW(const S: WideString; const C: WideChar): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrRemoveCharU(const S: UnicodeString; const C: WideChar): UnicodeString;
{$ENDIF}
function  StrRemoveChar(const S: String; const C: Char): String;

{$IFNDEF CLR}
{$IFDEF SupportAnsiString}
function  StrRemoveCharSetA(const S: AnsiString; const C: ByteCharSet): AnsiString;
{$ENDIF}
function  StrRemoveCharSetB(const S: RawByteString; const C: ByteCharSet): RawByteString;
{$IFDEF SupportWideString}
function  StrRemoveCharSetW(const S: WideString; const C: ByteCharSet): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrRemoveCharSetU(const S: UnicodeString; const C: ByteCharSet): UnicodeString;
{$ENDIF}
function  StrRemoveCharSet(const S: String; const C: ByteCharSet): String;
{$ENDIF}



{                                                                              }
{ Split                                                                        }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrSplitAtA(const S: AnsiString; const C: AnsiString;
          var Left, Right: AnsiString;
          const AsciiCaseSensitive: Boolean = True;
          const Optional: Boolean = True): Boolean;
function  StrSplitAtB(const S: RawByteString; const C: RawByteString;
          var Left, Right: RawByteString;
          const AsciiCaseSensitive: Boolean = True;
          const Optional: Boolean = True): Boolean;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrSplitAtW(const S: WideString; const C: WideString;
          var Left, Right: WideString;
          const AsciiCaseSensitive: Boolean = True;
          const Optional: Boolean = True): Boolean;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrSplitAtU(const S: UnicodeString; const C: UnicodeString;
          var Left, Right: UnicodeString;
          const AsciiCaseSensitive: Boolean = True;
          const Optional: Boolean = True): Boolean;
function  StrSplitAt(const S: String; const C: String;
          var Left, Right: String;
          const AsciiCaseSensitive: Boolean = True;
          const Optional: Boolean = True): Boolean;
{$ENDIF}

{$IFDEF SupportAnsiString}
function  StrSplitAtCharA(const S: AnsiString; const C: AnsiChar;
          var Left, Right: AnsiString;
          const Optional: Boolean = True): Boolean;
{$ENDIF}
function  StrSplitAtCharB(const S: RawByteString; const C: AnsiChar;
          var Left, Right: RawByteString;
          const Optional: Boolean = True): Boolean;
{$IFDEF SupportWideString}
function  StrSplitAtCharW(const S: WideString; const C: WideChar;
          var Left, Right: WideString;
          const Optional: Boolean = True): Boolean;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrSplitAtCharU(const S: UnicodeString; const C: WideChar;
          var Left, Right: UnicodeString;
          const Optional: Boolean = True): Boolean;
{$ENDIF}
function  StrSplitAtChar(const S: String; const C: Char;
          var Left, Right: String;
          const Optional: Boolean = True): Boolean;

{$IFDEF SupportAnsiString}
function  StrSplitAtCharSetA(const S: AnsiString; const C: ByteCharSet;
          var Left, Right: AnsiString;
          const Optional: Boolean = True): Boolean;
{$ENDIF}

{$IFDEF SupportAnsiString}
function  StrSplitA(const S, D: AnsiString): AnsiStringArray;
{$ENDIF}
{$IFDEF SupportRawByteString}
function  StrSplitB(const S, D: RawByteString): RawByteStringArray;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrSplitW(const S, D: WideString): WideStringArray;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrSplitU(const S, D: UnicodeString): UnicodeStringArray;
{$ENDIF}
function  StrSplit(const S, D: String): StringArray;

{$IFDEF SupportAnsiString}
function  StrSplitCharA(const S: AnsiString; const D: AnsiChar): AnsiStringArray;
{$ENDIF}
{$IFDEF SupportRawByteString}
function  StrSplitCharB(const S: RawByteString; const D: AnsiChar): RawByteStringArray;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrSplitCharW(const S: WideString; const D: WideChar): WideStringArray;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrSplitCharU(const S: UnicodeString; const D: WideChar): UnicodeStringArray;
{$ENDIF}
function  StrSplitChar(const S: String; const D: Char): StringArray;

{$IFDEF SupportAnsiString}
function  StrSplitCharSetA(const S: AnsiString; const D: ByteCharSet): AnsiStringArray;
{$ENDIF}
{$IFDEF SupportRawByteString}
function  StrSplitCharSetB(const S: RawByteString; const D: ByteCharSet): RawByteStringArray;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrSplitCharSetW(const S: WideString; const D: ByteCharSet): WideStringArray;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrSplitCharSetU(const S: UnicodeString; const D: ByteCharSet): UnicodeStringArray;
{$ENDIF}
function  StrSplitCharSet(const S: String; const D: ByteCharSet): StringArray;

{$IFNDEF CLR}
{$IFDEF SupportAnsiString}
function  StrSplitWords(const S: AnsiString; const C: ByteCharSet): AnsiStringArray;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportAnsiString}
function  StrJoinA(const S: array of AnsiString; const D: AnsiString): AnsiString;
{$ENDIF}
{$IFDEF SupportRawByteString}
function  StrJoinB(const S: array of RawByteString; const D: RawByteString): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrJoinW(const S: array of WideString; const D: WideString): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrJoinU(const S: array of UnicodeString; const D: UnicodeString): UnicodeString;
{$ENDIF}
function  StrJoin(const S: array of String; const D: String): String;

{$IFDEF SupportAnsiString}
function  StrJoinCharA(const S: array of AnsiString; const D: AnsiChar): AnsiString;
{$ENDIF}
{$IFDEF SupportRawByteString}
function  StrJoinCharB(const S: array of RawByteString; const D: AnsiChar): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrJoinCharW(const S: array of WideString; const D: WideChar): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrJoinCharU(const S: array of UnicodeString; const D: WideChar): UnicodeString;
{$ENDIF}
function  StrJoinChar(const S: array of String; const D: Char): String;



{                                                                              }
{ Quoting                                                                      }
{                                                                              }
{   QuoteText, UnquoteText converts text where the string is enclosed in a     }
{   pair of the same quote characters, and two consequetive occurance of the   }
{   quote character inside the quotes indicate a quote character in the text.  }
{   Examples:                                                                  }
{                                                                              }
{     StrQuote ('abc', '"') = '"abc"'                                          }
{     StrQuote ('a"b"c', '"') = '"a""b""c"'                                    }
{     StrUnquote ('"a""b""c"') = 'a"b"c'                                       }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrHasSurroundingQuotesA(const S: AnsiString;
          const Quotes: ByteCharSet{$IFNDEF CLR} = csQuotes{$ENDIF}): Boolean;
function  StrHasSurroundingQuotesB(const S: RawByteString;
          const Quotes: ByteCharSet{$IFNDEF CLR} = csQuotes{$ENDIF}): Boolean;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrHasSurroundingQuotesW(const S: WideString;
          const Quotes: ByteCharSet{$IFNDEF CLR} = csQuotes{$ENDIF}): Boolean;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrHasSurroundingQuotesU(const S: UnicodeString;
          const Quotes: ByteCharSet{$IFNDEF CLR} = csQuotes{$ENDIF}): Boolean;
{$ENDIF}
function  StrHasSurroundingQuotes(const S: String;
          const Quotes: ByteCharSet{$IFNDEF CLR} = csQuotes{$ENDIF}): Boolean;

{$IFDEF SupportAnsiString}
function  StrRemoveSurroundingQuotesA(const S: AnsiString;
          const Quotes: ByteCharSet{$IFNDEF CLR} = csQuotes{$ENDIF}): AnsiString;
function  StrRemoveSurroundingQuotesB(const S: RawByteString;
          const Quotes: ByteCharSet{$IFNDEF CLR} = csQuotes{$ENDIF}): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrRemoveSurroundingQuotesW(const S: WideString;
          const Quotes: ByteCharSet{$IFNDEF CLR} = csQuotes{$ENDIF}): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrRemoveSurroundingQuotesU(const S: UnicodeString;
          const Quotes: ByteCharSet{$IFNDEF CLR} = csQuotes{$ENDIF}): UnicodeString;
{$ENDIF}
function  StrRemoveSurroundingQuotes(const S: String;
          const Quotes: ByteCharSet{$IFNDEF CLR} = csQuotes{$ENDIF}): String;

{$IFDEF SupportAnsiString}
function  StrQuoteA(const S: AnsiString; const Quote: AnsiChar = AnsiChar('"')): AnsiString;
function  StrQuoteB(const S: RawByteString; const Quote: AnsiChar = AnsiChar('"')): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrQuoteW(const S: WideString; const Quote: WideChar = WideChar('"')): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrQuoteU(const S: UnicodeString; const Quote: WideChar = WideChar('"')): UnicodeString;
{$ENDIF}
function  StrQuote(const S: String; const Quote: Char = '"'): String;

{$IFDEF SupportAnsiString}
function  StrUnquoteA(const S: AnsiString): AnsiString;
function  StrUnquoteB(const S: RawByteString): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrUnquoteW(const S: WideString): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrUnquoteU(const S: UnicodeString): UnicodeString;
{$ENDIF}
function  StrUnquote(const S: String): String;

{$IFDEF SupportAnsiString}
function  StrMatchQuotedStrA(const S: AnsiString;
          const ValidQuotes: ByteCharSet{$IFNDEF CLR} = csQuotes{$ENDIF};
          const Index: Integer = 1): Integer;

function  StrIsQuotedStrA(const S: AnsiString;
          const ValidQuotes: ByteCharSet{$IFNDEF CLR} = csQuotes{$ENDIF}): Boolean;

function  StrFindClosingQuoteA(const S: AnsiString;
          const OpenQuotePos: Integer): Integer;
{$ENDIF}



{                                                                              }
{ Bracketing                                                                   }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrFindClosingBracketA(const S: AnsiString;
          const OpenBracketPos: Integer; const CloseBracket: AnsiChar): Integer;
{$ENDIF}



{                                                                              }
{ Escaping                                                                     }
{                                                                              }
function  StrHexEscapeB(const S: RawByteString; const C: ByteCharSet;
          const EscPrefix: RawByteString = '\x';
          const EscSuffix: RawByteString = '';
          const UpperHex: Boolean = True;
          const TwoDigitHex: Boolean = True): RawByteString;

function  StrHexUnescapeB(const S: RawByteString;
          const EscPrefix: RawByteString = '\x';
          const AsciiCaseSensitive: Boolean = True): RawByteString;

{$IFDEF SupportAnsiString}
function  StrCharEscapeA(const S: AnsiString; const C: array of AnsiChar;
          const EscPrefix: AnsiString;
          const EscSeq: array of AnsiString): AnsiString;

function  StrCharUnescapeA(const S: AnsiString; const EscPrefix: AnsiString;
          const C: array of AnsiChar; const Replace: array of AnsiString;
          const PrefixAsciiCaseSensitive: Boolean = True;
          const AlwaysDropPrefix: Boolean = True): AnsiString;

{$IFDEF SupportUnicodeString}
function  StrCharUnescapeU(const S: UnicodeString; const EscPrefix: UnicodeString;
          const C: array of WideChar; const Replace: array of UnicodeString;
          const PrefixAsciiCaseSensitive: Boolean = True;
          const AlwaysDropPrefix: Boolean = True): UnicodeString;
{$ENDIF}

function  StrCStyleEscapeA(const S: AnsiString): AnsiString;
function  StrCStyleUnescapeA(const S: AnsiString): AnsiString;
{$ENDIF}



{                                                                              }
{ Prefix and Suffix                                                            }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrInclPrefixA(const S: AnsiString; const Prefix: AnsiString; const AsciiCaseSensitive: Boolean = True): AnsiString;
function  StrInclPrefixB(const S: RawByteString; const Prefix: RawByteString; const AsciiCaseSensitive: Boolean = True): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrInclPrefixW(const S: WideString; const Prefix: WideString; const AsciiCaseSensitive: Boolean = True): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrInclPrefixU(const S: UnicodeString; const Prefix: UnicodeString; const AsciiCaseSensitive: Boolean = True): UnicodeString;
{$ENDIF}
function  StrInclPrefix(const S: String; const Prefix: String; const AsciiCaseSensitive: Boolean = True): String;

{$IFDEF SupportAnsiString}
function  StrInclSuffixA(const S: AnsiString; const Suffix: AnsiString; const AsciiCaseSensitive: Boolean = True): AnsiString;
function  StrInclSuffixB(const S: RawByteString; const Suffix: RawByteString; const AsciiCaseSensitive: Boolean = True): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrInclSuffixW(const S: WideString; const Suffix: WideString; const AsciiCaseSensitive: Boolean = True): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrInclSuffixU(const S: UnicodeString; const Suffix: UnicodeString; const AsciiCaseSensitive: Boolean = True): UnicodeString;
{$ENDIF}
function  StrInclSuffix(const S: String; const Suffix: String; const AsciiCaseSensitive: Boolean = True): String;

{$IFDEF SupportAnsiString}
function  StrExclPrefixA(const S: AnsiString; const Prefix: AnsiString; const AsciiCaseSensitive: Boolean = True): AnsiString;
function  StrExclPrefixB(const S: RawByteString; const Prefix: RawByteString; const AsciiCaseSensitive: Boolean = True): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrExclPrefixW(const S: WideString; const Prefix: WideString; const AsciiCaseSensitive: Boolean = True): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrExclPrefixU(const S: UnicodeString; const Prefix: UnicodeString; const AsciiCaseSensitive: Boolean = True): UnicodeString;
{$ENDIF}
function  StrExclPrefix(const S: String; const Prefix: String; const AsciiCaseSensitive: Boolean = True): String;

{$IFDEF SupportAnsiString}
function  StrExclSuffixA(const S: AnsiString; const Suffix: AnsiString; const AsciiCaseSensitive: Boolean = True): AnsiString;
function  StrExclSuffixB(const S: RawByteString; const Suffix: RawByteString; const AsciiCaseSensitive: Boolean = True): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrExclSuffixW(const S: WideString; const Suffix: WideString; const AsciiCaseSensitive: Boolean = True): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrExclSuffixU(const S: UnicodeString; const Suffix: UnicodeString; const AsciiCaseSensitive: Boolean = True): UnicodeString;
{$ENDIF}
function  StrExclSuffix(const S: String; const Suffix: String; const AsciiCaseSensitive: Boolean = True): String;

{$IFDEF SupportAnsiString}
procedure StrEnsurePrefixA(var S: AnsiString; const Prefix: AnsiString; const AsciiCaseSensitive: Boolean = True);
procedure StrEnsurePrefixB(var S: RawByteString; const Prefix: RawByteString; const AsciiCaseSensitive: Boolean = True);
{$ENDIF}
{$IFDEF SupportWideString}
procedure StrEnsurePrefixW(var S: WideString; const Prefix: WideString; const AsciiCaseSensitive: Boolean = True);
{$ENDIF}
{$IFDEF SupportUnicodeString}
procedure StrEnsurePrefixU(var S: UnicodeString; const Prefix: UnicodeString; const AsciiCaseSensitive: Boolean = True);
{$ENDIF}
procedure StrEnsurePrefix(var S: String; const Prefix: String; const AsciiCaseSensitive: Boolean = True);

{$IFDEF SupportAnsiString}
procedure StrEnsureSuffixA(var S: AnsiString; const Suffix: AnsiString; const AsciiCaseSensitive: Boolean = True);
procedure StrEnsureSuffixB(var S: RawByteString; const Suffix: RawByteString; const AsciiCaseSensitive: Boolean = True);
{$ENDIF}
{$IFDEF SupportWideString}
procedure StrEnsureSuffixW(var S: WideString; const Suffix: WideString; const AsciiCaseSensitive: Boolean = True);
{$ENDIF}
{$IFDEF SupportUnicodeString}
procedure StrEnsureSuffixU(var S: UnicodeString; const Suffix: UnicodeString; const AsciiCaseSensitive: Boolean = True);
{$ENDIF}
procedure StrEnsureSuffix(var S: String; const Suffix: String; const AsciiCaseSensitive: Boolean = True);

{$IFDEF SupportAnsiString}
procedure StrEnsureNoPrefixA(var S: AnsiString; const Prefix: AnsiString; const AsciiCaseSensitive: Boolean = True);
procedure StrEnsureNoPrefixB(var S: RawByteString; const Prefix: RawByteString; const AsciiCaseSensitive: Boolean = True);
{$ENDIF}
{$IFDEF SupportWideString}
procedure StrEnsureNoPrefixW(var S: WideString; const Prefix: WideString; const AsciiCaseSensitive: Boolean = True);
{$ENDIF}
{$IFDEF SupportUnicodeString}
procedure StrEnsureNoPrefixU(var S: UnicodeString; const Prefix: UnicodeString; const AsciiCaseSensitive: Boolean = True);
{$ENDIF}
procedure StrEnsureNoPrefix(var S: String; const Prefix: String; const AsciiCaseSensitive: Boolean = True);

{$IFDEF SupportAnsiString}
procedure StrEnsureNoSuffixA(var S: AnsiString; const Suffix: AnsiString; const AsciiCaseSensitive: Boolean = True);
procedure StrEnsureNoSuffixB(var S: RawByteString; const Suffix: RawByteString; const AsciiCaseSensitive: Boolean = True);
{$ENDIF}
{$IFDEF SupportWideString}
procedure StrEnsureNoSuffixW(var S: WideString; const Suffix: WideString; const AsciiCaseSensitive: Boolean = True);
{$ENDIF}
{$IFDEF SupportUnicodeString}
procedure StrEnsureNoSuffixU(var S: UnicodeString; const Suffix: UnicodeString; const AsciiCaseSensitive: Boolean = True);
{$ENDIF}
procedure StrEnsureNoSuffix(var S: String; const Suffix: String; const AsciiCaseSensitive: Boolean = True);



{                                                                              }
{ Reverse                                                                      }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StrReverseA(const S: AnsiString): AnsiString;
function  StrReverseB(const S: RawByteString): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrReverseW(const S: WideString): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrReverseU(const S: UnicodeString): UnicodeString;
{$ENDIF}
function  StrReverse(const S: String): String;



{                                                                              }
{ Base conversion                                                              }
{                                                                              }
{$IFDEF SupportAnsiString}
function  BinToWord32(const S: AnsiString): Word32;
function  OctToWord32(const S: AnsiString): Word32;
function  StrToWord32(const S: AnsiString): Word32;
function  StrToWord32Def(const S: AnsiString; const Default: Word32): Word32;
function  HexToWord32(const S: AnsiString): Word32;
function  HexToWord32Def(const S: AnsiString; const Default: Word32): Word32;
{$ENDIF}



{                                                                              }
{ Type conversion                                                              }
{                                                                              }
function  StrToFloatDef(const S: String; const Default: Extended): Extended;

{$IFDEF SupportAnsiString}
function  BooleanToStrA(const B: Boolean): AnsiString;
function  BooleanToStrB(const B: Boolean): RawByteString;
{$ENDIF}
{$IFDEF SupportWideString}
function  BooleanToStrW(const B: Boolean): WideString;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  BooleanToStrU(const B: Boolean): UnicodeString;
{$ENDIF}
function  BooleanToStr(const B: Boolean): String;

{$IFDEF SupportAnsiString}
function  StrToBooleanA(const S: AnsiString): Boolean;
function  StrToBooleanB(const S: RawByteString): Boolean;
{$ENDIF}
{$IFDEF SupportWideString}
function  StrToBooleanW(const S: WideString): Boolean;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StrToBooleanU(const S: UnicodeString): Boolean;
{$ENDIF}
function  StrToBoolean(const S: String): Boolean;



{                                                                              }
{ Dynamic array functions                                                      }
{                                                                              }
{$IFDEF SupportAnsiString}
function  StringsTotalLengthA(const S: array of AnsiString): Integer;
{$ENDIF}
function  StringsTotalLengthB(const S: array of RawByteString): Integer;
{$IFDEF SupportWideString}
function  StringsTotalLengthW(const S: array of WideString): Integer;
{$ENDIF}
{$IFDEF SupportUnicodeString}
function  StringsTotalLengthU(const S: array of UnicodeString): Integer;
{$ENDIF}
function  StringsTotalLength(const S: array of String): Integer;

{$IFDEF SupportAnsiString}
function  PosNextNoCaseA(const Find: AnsiString; const V: array of AnsiString;
          const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer;
{$ENDIF}
function  PosNextNoCaseB(const Find: RawByteString; const V: array of RawByteString;
          const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer;
{$IFDEF SupportUnicodeString}
function  PosNextNoCaseU(const Find: UnicodeString; const V: array of UnicodeString;
          const PrevPos: Integer = -1;
          const IsSortedAscending: Boolean = False): Integer;
{$ENDIF}



{                                                                              }
{ Natural language                                                             }
{                                                                              }
function  StorageSize(const Bytes: Int64;
          const ShortFormat: Boolean = False): String;
function  TransferRate(const Bytes, MillisecondsElapsed: Int64;
          const ShortFormat: Boolean = False): String;



{                                                                              }
{ Tests                                                                        }
{                                                                              }
{$IFDEF STRINGS_TEST}
procedure Test;
{$ENDIF}



implementation

uses
  { Fundamentals }
  flcUtils;



{                                                                              }
{ String functions                                                             }
{                                                                              }
{$IFDEF SupportAnsiString}
{$IFDEF ManagedCode}
procedure SetLengthAndZeroA(var S: AnsiString; const NewLength: Integer);
var L, I : Integer;
begin
  L := Length(S);
  if L = NewLength then
    exit;
  SetLength(S, NewLength);
  if L > NewLength then
    exit;
  for I := L + 1 to NewLength do
    S[I] := AnsiChar(#0);
end;
{$ELSE}
procedure SetLengthAndZeroA(var S: AnsiString; const NewLength: Integer);
var L : Integer;
    P : PAnsiChar;
begin
  L := Length(S);
  if L = NewLength then
    exit;
  SetLength(S, NewLength);
  if L > NewLength then
    exit;
  P := Pointer(S);
  Inc(P, L);
  ZeroMem(P^, NewLength - L);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF ManagedCode}
procedure SetLengthAndZeroB(var S: RawByteString; const NewLength: Integer);
var L, I : Integer;
begin
  L := Length(S);
  if L = NewLength then
    exit;
  SetLength(S, NewLength);
  if L > NewLength then
    exit;
  for I := L + 1 to NewLength do
    S[I] := AnsiChar(#0);
end;
{$ELSE}
procedure SetLengthAndZeroB(var S: RawByteString; const NewLength: Integer);
var L : Integer;
    P : PByteChar;
begin
  L := Length(S);
  if L = NewLength then
    exit;
  SetLength(S, NewLength);
  if L > NewLength then
    exit;
  P := Pointer(S);
  Inc(P, L);
  ZeroMem(P^, NewLength - L);
end;
{$ENDIF}

{$IFDEF SupportWideString}
procedure SetLengthAndZeroW(var S: WideString; const NewLength: Integer);
var L : Integer;
    P : PWideChar;
begin
  L := Length(S);
  if L = NewLength then
    exit;
  SetLength(S, NewLength);
  if L > NewLength then
    exit;
  P := Pointer(S);
  Inc(P, L);
  ZeroMem(P^, (NewLength - L) * SizeOf(WideChar));
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
procedure SetLengthAndZeroU(var S: UnicodeString; const NewLength: Integer);
var L : Integer;
    P : PWideChar;
begin
  L := Length(S);
  if L = NewLength then
    exit;
  SetLength(S, NewLength);
  if L > NewLength then
    exit;
  P := Pointer(S);
  Inc(P, L);
  ZeroMem(P^, (NewLength - L) * SizeOf(WideChar));
end;
{$ENDIF}

function ToStringChA(const A: AnsiChar): String;
begin
  {$IFDEF StringIsUnicode}
  Result := WideChar(A);
  {$ELSE}
  Result := A;
  {$ENDIF}
end;

function ToStringChW(const A: WideChar): String;
begin
  {$IFDEF StringIsUnicode}
  Result := A;
  {$ELSE}
  if Ord(A) <= $FF then
    Result := AnsiChar(Ord(A))
  else
    raise EConvertError.Create('Invalid character');
  {$ENDIF}
end;

{$IFDEF SupportAnsiString}
function ToStringA(const A: AnsiString): String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(A);
  {$ELSE}
  Result := A;
  {$ENDIF}
end;
{$ENDIF}

function ToStringB(const A: RawByteString): String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(A);
  {$ELSE}
  Result := A;
  {$ENDIF}
end;

{$IFDEF SupportWideString}
function ToStringW(const A: WideString): String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(A);
  {$ELSE}
  Result := AnsiString(A);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function ToStringU(const A: UnicodeString): String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(A);
  {$ELSE}
  Result := AnsiString(A);
  {$ENDIF}
end;
{$ENDIF}



{                                                                              }
{ Match                                                                        }
{                                                                              }
{$IFDEF ASM386_DELPHI}
function CharMatchNoAsciiCaseA(const A, B: AnsiChar): Boolean;
asm
      AND     EAX, $000000FF
      AND     EDX, $000000FF
      MOV     AL, BYTE PTR [AsciiLowCaseLookup + EAX]
      CMP     AL, BYTE PTR [AsciiLowCaseLookup + EDX]
      SETZ    AL
end;
{$ELSE}
function CharMatchNoAsciiCaseA(const A, B: AnsiChar): Boolean;
begin
  Result := AsciiLowCaseLookup[Ord(A)] = AsciiLowCaseLookup[Ord(B)];
end;
{$ENDIF}

function CharMatchNoAsciiCaseW(const A, B: WideChar): Boolean;
begin
  if (Ord(A) <= $7F) and (Ord(B) <= $7F) then
    Result := AsciiLowCaseLookup[Ord(A)] = AsciiLowCaseLookup[Ord(B)]
  else
    Result := Ord(A) = Ord(B);
end;

function CharMatchNoAsciiCaseAW(const A: AnsiChar; const B: WideChar): Boolean;
begin
  if (Ord(A) <= $7F) and (Ord(B) <= $7F) then
    Result := AsciiLowCaseLookup[Ord(A)] = AsciiLowCaseLookup[Ord(B)]
  else
    Result := Ord(A) = Ord(B);
end;

function CharMatchNoAsciiCaseAS(const A: AnsiChar; const B: Char): Boolean;
begin
  if (Ord(A) <= $7F) and (Ord(B) <= $7F) then
    Result := AsciiLowCaseLookup[Ord(A)] = AsciiLowCaseLookup[Ord(B)]
  else
    Result := Ord(A) = Ord(B);
end;

function CharMatchNoAsciiCase(const A, B: Char): Boolean;
begin
  if (Ord(A) <= $7F) and (Ord(B) <= $7F) then
    Result := AsciiLowCaseLookup[Ord(A)] = AsciiLowCaseLookup[Ord(B)]
  else
    Result := Ord(A) = Ord(B);
end;

{$IFDEF ASM386_DELPHI}
function CharMatchA(const A, B: AnsiChar; const AsciiCaseSensitive: Boolean): Boolean;
asm
      OR      CL, CL
      JZ      CharMatchNoAsciiCaseA
      CMP     AL, DL
      SETZ    AL
end;
{$ELSE}
function CharMatchA(const A, B: AnsiChar; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := A = B
  else
    Result := AsciiLowCaseLookup[Ord(A)] = AsciiLowCaseLookup[Ord(B)];
end;
{$ENDIF}

function CharMatchW(const A, B: WideChar; const AsciiCaseSensitive: Boolean = True): Boolean;
begin
  if AsciiCaseSensitive then
    Result := A = B
  else
    if (Ord(A) <= $7F) and (Ord(B) <= $7F) then
      Result := AsciiLowCaseLookup[Ord(A)] = AsciiLowCaseLookup[Ord(B)]
    else
      Result := A = B;
end;

function CharMatchAW(const A: AnsiChar; const B: WideChar; const AsciiCaseSensitive: Boolean = True): Boolean;
begin
  if AsciiCaseSensitive then
    Result := Ord(A) = Ord(B)
  else
    if (Ord(A) <= $7F) and (Ord(B) <= $7F) then
      Result := AsciiLowCaseLookup[Ord(A)] = AsciiLowCaseLookup[Ord(B)]
    else
      Result := Ord(A) = Ord(B);
end;

function CharMatchAS(const A: AnsiChar; const B: Char; const AsciiCaseSensitive: Boolean = True): Boolean;
begin
  if AsciiCaseSensitive then
    Result := Ord(A) = Ord(B)
  else
    if (Ord(A) <= $7F) and (Ord(B) <= $7F) then
      Result := AsciiLowCaseLookup[Ord(A)] = AsciiLowCaseLookup[Ord(B)]
    else
      Result := Ord(A) = Ord(B);
end;

function CharMatch(const A, B: Char; const AsciiCaseSensitive: Boolean = True): Boolean;
begin
  if AsciiCaseSensitive then
    Result := A = B
  else
    if (Ord(A) <= $7F) and (Ord(B) <= $7F) then
      Result := AsciiLowCaseLookup[Ord(A)] = AsciiLowCaseLookup[Ord(B)]
    else
      Result := A = B;
end;

function CharSetMatchCharA(const A: ByteCharSet; const B: AnsiChar; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := B in A
  else
    Result := (AsciiUpCaseB(B) in A) or (AsciiLowCaseB(B) in A);
end;

function CharSetMatchCharW(const A: ByteCharSet; const B: WideChar; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if Ord(B) > $FF then
    Result := False
  else
    if AsciiCaseSensitive then
      Result := AnsiChar(Ord(B)) in A
    else
      Result := (AsciiUpCaseB(AnsiChar(Ord(B))) in A) or
                (AsciiLowCaseB(AnsiChar(Ord(B))) in A);
end;

function CharSetMatchChar(const A: ByteCharSet; const B: Char; const AsciiCaseSensitive: Boolean): Boolean;
begin
  {$IFDEF StringIsUnicode}
  if Ord(B) > $FF then
    Result := False
  else
  {$ENDIF}
    if AsciiCaseSensitive then
      Result := AnsiChar(Ord(B)) in A
    else
      Result := (AsciiUpCaseB(AnsiChar(Ord(B))) in A) or
                (AsciiLowCaseB(AnsiChar(Ord(B))) in A);
end;

{$IFDEF ManagedCode}
function StrPMatchA(const A, B: AnsiString; const Len: Integer): Boolean;
var I : Integer;
begin
  for I := 1 to Len do
    if A[I] <> B[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function StrPMatchA(const A, B: PByteChar; const Len: Integer): Boolean;
var P, Q : PByteChar;
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
        end else
        begin
          Result := False;
          exit;
        end;
  Result := True;
end;

function StrPMatchW(const A, B: PWideChar; const Len: Integer): Boolean;
var P, Q : PWideChar;
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
        end else
        begin
          Result := False;
          exit;
        end;
  Result := True;
end;

function StrPMatchAW(const A: PWideChar; B: PByteChar; const Len: Integer): Boolean;
var P : PWideChar;
    Q : PByteChar;
    I : Integer;
begin
  P := A;
  Q := B;
  for I := 1 to Len do
    if Ord(P^) = Ord(Q^) then
      begin
        Inc(P);
        Inc(Q);
      end else
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function StrPMatchAS(const A: PChar; B: PByteChar; const Len: Integer): Boolean;
var P : PChar;
    Q : PByteChar;
    I : Integer;
begin
  P := A;
  Q := B;
  for I := 1 to Len do
    if Ord(P^) = Ord(Q^) then
      begin
        Inc(P);
        Inc(Q);
      end else
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function StrPMatch(const A, B: PChar; const Len: Integer): Boolean;
var P, Q : PChar;
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
        end else
        begin
          Result := False;
          exit;
        end;
  Result := True;
end;
{$ENDIF}

{$IFNDEF ManagedCode}
function StrPMatchA(const S, M: PByteChar; const LenS, LenM: Integer): Boolean;
var P, Q : PByteChar;
    I    : Integer;
begin
  if LenM = 0 then
    begin
      Result := True;
      exit;
    end;
  if LenM > LenS then
    begin
      Result := False;
      exit;
    end;
  if Pointer(S) = Pointer(M) then
    begin
      Result := True;
      exit;
    end;
  P := S;
  Q := M;
  for I := 1 to LenM do
    if P^ = Q^ then
      begin
        Inc(P);
        Inc(Q);
      end else
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function StrPMatchW(const S, M: PWideChar; const LenS, LenM: Integer): Boolean;
var P, Q : PWideChar;
    I    : Integer;
begin
  if LenM = 0 then
    begin
      Result := True;
      exit;
    end;
  if LenM > LenS then
    begin
      Result := False;
      exit;
    end;
  if Pointer(S) = Pointer(M) then
    begin
      Result := True;
      exit;
    end;
  P := S;
  Q := M;
  for I := 1 to LenM do
    if P^ = Q^ then
      begin
        Inc(P);
        Inc(Q);
      end else
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function StrPMatchAW(const S: PWideChar; const M: PByteChar; const LenS, LenM: Integer): Boolean;
var P : PWideChar;
    Q : PByteChar;
    I : Integer;
begin
  if LenM = 0 then
    begin
      Result := True;
      exit;
    end;
  if LenM > LenS then
    begin
      Result := False;
      exit;
    end;
  P := S;
  Q := M;
  for I := 1 to LenM do
    if Ord(P^) = Ord(Q^) then
      begin
        Inc(P);
        Inc(Q);
      end else
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function StrPMatchAS(const S: PChar; const M: PByteChar; const LenS, LenM: Integer): Boolean;
var P : PChar;
    Q : PByteChar;
    I : Integer;
begin
  if LenM = 0 then
    begin
      Result := True;
      exit;
    end;
  if LenM > LenS then
    begin
      Result := False;
      exit;
    end;
  P := S;
  Q := M;
  for I := 1 to LenM do
    if Ord(P^) = Ord(Q^) then
      begin
        Inc(P);
        Inc(Q);
      end else
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function StrPMatch(const S, M: PChar; const LenS, LenM: Integer): Boolean;
var P, Q : PChar;
    I    : Integer;
begin
  if LenM = 0 then
    begin
      Result := True;
      exit;
    end;
  if LenM > LenS then
    begin
      Result := False;
      exit;
    end;
  if Pointer(S) = Pointer(M) then
    begin
      Result := True;
      exit;
    end;
  P := S;
  Q := M;
  for I := 1 to LenM do
    if P^ = Q^ then
      begin
        Inc(P);
        Inc(Q);
      end else
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function StrPMatchStrPA(const S: PChar; const M: PByteChar; const LenS, LenM: Integer): Boolean;
var P : PChar;
    Q : PByteChar;
    I : Integer;
begin
  if LenM = 0 then
    begin
      Result := True;
      exit;
    end;
  if LenM > LenS then
    begin
      Result := False;
      exit;
    end;
  P := S;
  Q := M;
  for I := 1 to LenM do
    if Ord(P^) = Ord(Q^) then
      begin
        Inc(P);
        Inc(Q);
      end else
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

{$IFDEF SupportAnsiString}
function StrPMatchStrA(const S: PAnsiChar; const Len: Integer; const M: AnsiString): Boolean;
begin
  Result := StrPMatchA(Pointer(S), Pointer(M), Len, Length(M));
end;
{$ENDIF}

function StrPMatchStrB(const S: PByteChar; const Len: Integer; const M: RawByteString): Boolean;
begin
  Result := StrPMatchA(S, Pointer(M), Len, Length(M));
end;

{$IFDEF SupportWideString}
function StrPMatchStrW(const S: PWideChar; const Len: Integer; const M: WideString): Boolean;
begin
  Result := StrPMatchW(S, Pointer(M), Len, Length(M));
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
function StrPMatchStrAW(const S: PWideChar; const Len: Integer; const M: AnsiString): Boolean;
begin
  Result := StrPMatchAW(S, Pointer(M), Len, Length(M));
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
function StrPMatchStrAS(const S: PChar; const Len: Integer; const M: AnsiString): Boolean;
begin
  Result := StrPMatchAS(S, Pointer(M), Len, Length(M));
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrPMatchStrU(const S: PWideChar; const Len: Integer; const M: UnicodeString): Boolean;
begin
  Result := StrPMatchW(S, Pointer(M), Len, Length(M));
end;
{$ENDIF}

function StrPMatchStr(const S: PChar; const Len: Integer; const M: String): Boolean;
begin
  Result := StrPMatch(S, Pointer(M), Len, Length(M));
end;

function StrPMatchNoAsciiCaseA(const A, B: PByteChar; const Len: Integer): Boolean;
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
            Result := False;
            exit;
          end;
      end;
  Result := True;
end;

function StrPMatchNoAsciiCaseW(const A, B: PWideChar; const Len: Integer): Boolean;
var P, Q : PWideChar;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      begin
        if CharMatchNoAsciiCaseW(P^, Q^) then
          begin
            Inc(P);
            Inc(Q);
          end
        else
          begin
            Result := False;
            exit;
          end;
      end;
  Result := True;
end;

function StrPMatchNoAsciiCaseAW(const A: PWideChar; const B: PByteChar; const Len: Integer): Boolean;
var P : PWideChar;
    Q : PByteChar;
    I : Integer;
begin
  P := A;
  Q := B;
  for I := 1 to Len do
    begin
      if CharMatchNoAsciiCaseAW(Q^, P^) then
        begin
          Inc(P);
          Inc(Q);
        end
      else
        begin
          Result := False;
          exit;
        end;
    end;
  Result := True;
end;

function StrPMatchNoAsciiCaseAS(const A: PChar; const B: PByteChar; const Len: Integer): Boolean;
var P : PChar;
    Q : PByteChar;
    I : Integer;
begin
  P := A;
  Q := B;
  for I := 1 to Len do
    begin
      if CharMatchNoAsciiCaseAS(Q^, P^) then
        begin
          Inc(P);
          Inc(Q);
        end
      else
        begin
          Result := False;
          exit;
        end;
    end;
  Result := True;
end;

function StrPMatchNoAsciiCase(const A, B: PChar; const Len: Integer): Boolean;
var P, Q : PChar;
    I    : Integer;
begin
  P := A;
  Q := B;
  if P <> Q then
    for I := 1 to Len do
      begin
        if CharMatchNoAsciiCase(P^, Q^) then
          begin
            Inc(P);
            Inc(Q);
          end else
          begin
            Result := False;
            exit;
          end;
      end;
  Result := True;
end;
{$ENDIF}

{$IFNDEF CLR}
function StrPMatchLenA(const P: PByteChar; const Len: Integer; const M: ByteCharSet): Integer;
var Q : PByteChar;
    L : Integer;
begin
  Q := P;
  L := Len;
  Result := 0;
  if not Assigned(Q) then
    exit;
  while L > 0 do
    if Q^ in M then
      begin
        Inc(Q);
        Dec(L);
        Inc(Result);
      end
    else
      exit;
end;

function WideCharInCharSet(const A: WideChar; const C: ByteCharSet): Boolean;
begin
  if Ord(A) >= $100 then
    Result := False
  else
    Result := AnsiChar(Ord(A)) in C;
end;

function StrPMatchLenW(const P: PWideChar; const Len: Integer; const M: ByteCharSet): Integer;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := Len;
  Result := 0;
  if not Assigned(Q) then
    exit;
  while L > 0 do
    if WideCharInCharSet(Q^, M) then
      begin
        Inc(Q);
        Dec(L);
        Inc(Result);
      end
    else
      exit;
end;

function StrPMatchLenW(const P: PWideChar; const Len: Integer; const M: TWideCharMatchFunction): Integer;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := Len;
  Result := 0;
  if not Assigned(Q) then
    exit;
  while L > 0 do
    if M(Q^) then
      begin
        Inc(Q);
        Dec(L);
        Inc(Result);
      end
    else
      exit;
end;

function StrPMatchLen(const P: PChar; const Len: Integer; const M: ByteCharSet): Integer;
var Q : PChar;
    C : Char;
    L : Integer;
begin
  Q := P;
  L := Len;
  Result := 0;
  if not Assigned(Q) then
    exit;
  while L > 0 do
    begin
      C := Q^;
      {$IFDEF StringIsUnicode}
      if WideCharInCharSet(C, M) then
      {$ELSE}
      if C in M then
      {$ENDIF}
        begin
          Inc(Q);
          Dec(L);
          Inc(Result);
        end
      else
        exit;
    end;
end;

function StrPMatchCountA(const P: PByteChar; const Len: Integer; const M: ByteCharSet): Integer;
var Q : PByteChar;
    L : Integer;
begin
  Q := P;
  L := Len;
  Result := 0;
  if not Assigned(Q) then
    exit;
  while L > 0 do
    begin
      if Q^ in M then
        Inc(Result);
      Inc(Q);
      Dec(L);
    end;
end;

function StrPMatchCountW(const P: PWideChar; const Len: Integer; const M: ByteCharSet): Integer;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := Len;
  Result := 0;
  if not Assigned(Q) then
    exit;
  while L > 0 do
    begin
      if WideCharInCharSet(Q^, M) then
        Inc(Result);
      Inc(Q);
      Dec(L);
    end;
end;

function StrPMatchCountW(const P: PWideChar; const Len: Integer; const M: TWideCharMatchFunction): Integer;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := Len;
  Result := 0;
  if not Assigned(Q) then
    exit;
  while L > 0 do
    begin
      if M(Q^) then
        Inc(Result);
      Inc(Q);
      Dec(L);
    end;
end;

function StrPMatchCharA(const P: PByteChar; const Len: Integer; const M: ByteCharSet): Boolean;
begin
  Result := StrPMatchLenA(P, Len, M) = Len;
end;

function StrPMatchCharW(const P: PWideChar; const Len: Integer; const M: ByteCharSet): Boolean;
begin
  Result := StrPMatchLenW(P, Len, M) = Len;
end;

function StrPMatchCharW(const P: PWideChar; const Len: Integer; const M: TWideCharMatchFunction): Boolean;
begin
  Result := StrPMatchLenW(P, Len, M) = Len;
end;

function StrPMatchChar(const P: PChar; const Len: Integer; const M: ByteCharSet): Boolean;
begin
  Result := StrPMatchLen(P, Len, M) = Len;
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
{$IFDEF CLR}
function StrMatchA(const S, M: AnsiString; const Index: Integer): Boolean;
var N, T, I : Integer;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  for I := 1 to N do
    if M[I] <> S[I + Index - 1] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ELSE}
function StrMatchA(const S, M: AnsiString; const Index: Integer): Boolean;
var N, T : Integer;
    Q    : PByteChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchA(Pointer(M), Q, N);
end;
{$ENDIF}
{$ENDIF}

function StrMatchB(const S, M: RawByteString; const Index: Integer): Boolean;
var N, T : Integer;
    Q    : PByteChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchA(Pointer(M), Q, N);
end;

{$IFDEF SupportWideString}
function StrMatchW(const S, M: WideString; const Index: Integer): Boolean;
var N, T, I : Integer;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  for I := 1 to N do
    if M[I] <> S[I + Index - 1] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ENDIF}

{$IFDEF SupportWideString}
{$IFDEF SupportAnsiString}
function StrMatchAW(const S: WideString; const M: AnsiString; const Index: Integer): Boolean;
var N, T, I : Integer;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  for I := 1 to N do
    if Ord(M[I]) <> Ord(S[I + Index - 1]) then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportWideString}
function StrMatchBW(const S: WideString; const M: RawByteString; const Index: Integer): Boolean;
var N, T, I : Integer;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  for I := 1 to N do
    if Ord(M[I]) <> Ord(S[I + Index - 1]) then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrMatchU(const S, M: UnicodeString; const Index: Integer): Boolean;
var N, T, I : Integer;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  for I := 1 to N do
    if M[I] <> S[I + Index - 1] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function StrMatchAU(const S: UnicodeString; const M: AnsiString; const Index: Integer): Boolean;
var N, T, I : Integer;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  for I := 1 to N do
    if Ord(M[I]) <> Ord(S[I + Index - 1]) then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportAnsiString}
function StrMatchAS(const S: String; const M: AnsiString; const Index: Integer): Boolean;
var N, T, I : Integer;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  for I := 1 to N do
    if Ord(M[I]) <> Ord(S[I + Index - 1]) then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ENDIF}

function StrMatch(const S, M: String; const Index: Integer): Boolean;
var N, T, I : Integer;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  for I := 1 to N do
    if M[I] <> S[I + Index - 1] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function StrMatchNoCase(const S, M: AnsiString; const Index: Integer): Boolean;
var N, T, I : Integer;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  for I := 1 to N do
    if AsciiLowCaseLookup[M[I]] <> AsciiLowCaseLookup[S[I + Index - 1]] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function StrMatchNoAsciiCaseA(const S, M: AnsiString; const Index: Integer): Boolean;
var N, T : Integer;
    Q    : PAnsiChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchNoAsciiCaseA(Pointer(M), Pointer(Q), N);
end;
{$ENDIF}

function StrMatchNoAsciiCaseB(const S, M: RawByteString; const Index: Integer): Boolean;
var N, T : Integer;
    Q    : PByteChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchNoAsciiCaseA(Pointer(M), Q, N);
end;

{$IFDEF SupportWideString}
function StrMatchNoAsciiCaseW(const S, M: WideString; const Index: Integer): Boolean;
var N, T : Integer;
    Q    : PWideChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchNoAsciiCaseW(Pointer(M), Q, N);
end;
{$ENDIF}

{$IFDEF SupportWideString}
{$IFDEF SupportAnsiString}
function StrMatchNoAsciiCaseAW(const S: WideString; const M: AnsiString; const Index: Integer): Boolean;
var N, T : Integer;
    Q    : PWideChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchNoAsciiCaseAW(Q, Pointer(M), N);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrMatchNoAsciiCaseU(const S, M: UnicodeString; const Index: Integer): Boolean;
var N, T : Integer;
    Q    : PWideChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchNoAsciiCaseW(Pointer(M), Q, N);
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function StrMatchNoAsciiCaseAU(const S: UnicodeString; const M: AnsiString; const Index: Integer): Boolean;
var N, T : Integer;
    Q    : PWideChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchNoAsciiCaseAW(Q, Pointer(M), N);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportAnsiString}
function StrMatchNoAsciiCaseAS(const S: String; const M: AnsiString; const Index: Integer): Boolean;
var N, T : Integer;
    Q    : PChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchNoAsciiCaseAS(Q, Pointer(M), N);
end;
{$ENDIF}

function StrMatchNoAsciiCase(const S, M: String; const Index: Integer = 1): Boolean;
var N, T : Integer;
    Q    : PChar;
begin
  N := Length(M);
  T := Length(S);
  if (N = 0) or (T = 0) or (Index < 1) or (Index + N - 1 > T) then
    begin
      Result := False;
      exit;
    end;
  Q := Pointer(S);
  Inc(Q, Index - 1);
  Result := StrPMatchNoAsciiCase(Pointer(M), Q, N);
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
function StrMatchLeftA(const S, M: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrMatchA(S, M, 1)
  else
    Result := StrMatchNoAsciiCaseA(S, M, 1);
end;
{$ENDIF}

function StrMatchLeftB(const S, M: RawByteString; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrMatchB(S, M, 1)
  else
    Result := StrMatchNoAsciiCaseB(S, M, 1);
end;

{$IFDEF SupportWideString}
function StrMatchLeftW(const S, M: WideString; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrMatchW(S, M, 1)
  else
    Result := StrMatchNoAsciiCaseW(S, M, 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
{$IFDEF SupportAnsiString}
function StrMatchLeftAW(const S: WideString; const M: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrMatchAW(S, M, 1)
  else
    Result := StrMatchNoAsciiCaseAW(S, M, 1);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrMatchLeftU(const S, M: UnicodeString; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrMatchU(S, M, 1)
  else
    Result := StrMatchNoAsciiCaseU(S, M, 1);
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function StrMatchLeftAU(const S: UnicodeString; const M: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrMatchAU(S, M, 1)
  else
    Result := StrMatchNoAsciiCaseAU(S, M, 1);
end;
{$ENDIF}
{$ENDIF}

function StrMatchLeft(const S, M: String; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrMatch(S, M, 1)
  else
    Result := StrMatchNoAsciiCase(S, M, 1);
end;

{$IFDEF SupportAnsiString}
function StrMatchRightA(const S, M: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
var I: Integer;
begin
  I := Length(S) - Length(M) + 1;
  if AsciiCaseSensitive then
    Result := StrMatchA(S, M, I)
  else
    Result := StrMatchNoAsciiCaseA(S, M, I);
end;
{$ENDIF}

function StrMatchRightB(const S, M: RawByteString; const AsciiCaseSensitive: Boolean): Boolean;
var I: Integer;
begin
  I := Length(S) - Length(M) + 1;
  if AsciiCaseSensitive then
    Result := StrMatchB(S, M, I)
  else
    Result := StrMatchNoAsciiCaseB(S, M, I);
end;

{$IFDEF SupportWideString}
function StrMatchRightW(const S, M: WideString; const AsciiCaseSensitive: Boolean): Boolean;
var I: Integer;
begin
  I := Length(S) - Length(M) + 1;
  if AsciiCaseSensitive then
    Result := StrMatchW(S, M, I)
  else
    Result := StrMatchNoAsciiCaseW(S, M, I);
end;
{$ENDIF}

{$IFDEF SupportWideString}
{$IFDEF SupportAnsiString}
function StrMatchRightAW(const S: WideString; const M: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
var I: Integer;
begin
  I := Length(S) - Length(M) + 1;
  if AsciiCaseSensitive then
    Result := StrMatchAW(S, M, I)
  else
    Result := StrMatchNoAsciiCaseAW(S, M, I);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrMatchRightU(const S, M: UnicodeString; const AsciiCaseSensitive: Boolean): Boolean;
var I: Integer;
begin
  I := Length(S) - Length(M) + 1;
  if AsciiCaseSensitive then
    Result := StrMatchU(S, M, I)
  else
    Result := StrMatchNoAsciiCaseU(S, M, I);
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function StrMatchRightAU(const S: UnicodeString; const M: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
var I: Integer;
begin
  I := Length(S) - Length(M) + 1;
  if AsciiCaseSensitive then
    Result := StrMatchAU(S, M, I)
  else
    Result := StrMatchNoAsciiCaseAU(S, M, I);
end;
{$ENDIF}
{$ENDIF}

function StrMatchRight(const S, M: String; const AsciiCaseSensitive: Boolean): Boolean;
var I: Integer;
begin
  I := Length(S) - Length(M) + 1;
  if AsciiCaseSensitive then
    Result := StrMatch(S, M, I)
  else
    Result := StrMatchNoAsciiCase(S, M, I);
end;

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function StrMatchLen(const S: AnsiString; const M: CharSet;
    const Index: Integer): Integer;
var L, I : Integer;
    J    : Integer;
begin
  I := Index;
  if I <= 0 then
    I := 1;
  L := Length(S);
  if I > L then
    Result := 0
  else
    begin
      Result := 0;
      for J := 1 to L - I + 1 do
        if S[I + J - 1] in M then
          Inc(Result)
        else
          exit;
    end;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function StrMatchLenA(const S: AnsiString; const M: ByteCharSet; const Index: Integer): Integer;
var P    : PAnsiChar;
    L, I : Integer;
begin
  I := Index;
  if I <= 0 then
    I := 1;
  L := Length(S);
  if I > L then
    Result := 0
  else
    begin
      P := Pointer(S);
      Dec(I);
      Inc(P, I);
      Result := StrPMatchLenA(Pointer(P), L - I, M);
    end;
end;
{$ENDIF}

function StrMatchLenB(const S: RawByteString; const M: ByteCharSet; const Index: Integer): Integer;
var P    : PByteChar;
    L, I : Integer;
begin
  I := Index;
  if I <= 0 then
    I := 1;
  L := Length(S);
  if I > L then
    Result := 0
  else
    begin
      P := Pointer(S);
      Dec(I);
      Inc(P, I);
      Result := StrPMatchLenA(P, L - I, M);
    end;
end;

{$IFDEF SupportWideString}
function StrMatchLenW(const S: WideString; const M: ByteCharSet; const Index: Integer): Integer;
var P    : PWideChar;
    L, I : Integer;
begin
  I := Index;
  if I <= 0 then
    I := 1;
  L := Length(S);
  if I > L then
    Result := 0
  else
    begin
      P := Pointer(S);
      Dec(I);
      Inc(P, I);
      Result := StrPMatchLenW(P, L - I, M);
    end;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrMatchLenW(const S: WideString; const M: TWideCharMatchFunction; const Index: Integer): Integer;
var P    : PWideChar;
    L, I : Integer;
begin
  I := Index;
  if I <= 0 then
    I := 1;
  L := Length(S);
  if I > L then
    Result := 0
  else
    begin
      P := Pointer(S);
      Dec(I);
      Inc(P, I);
      Result := StrPMatchLenW(P, L - I, M);
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrMatchLenU(const S: UnicodeString; const M: ByteCharSet; const Index: Integer): Integer;
var P    : PWideChar;
    L, I : Integer;
begin
  I := Index;
  if I <= 0 then
    I := 1;
  L := Length(S);
  if I > L then
    Result := 0
  else
    begin
      P := Pointer(S);
      Dec(I);
      Inc(P, I);
      Result := StrPMatchLenW(P, L - I, M);
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrMatchLenU(const S: UnicodeString; const M: TWideCharMatchFunction; const Index: Integer = 1): Integer;
var P    : PWideChar;
    L, I : Integer;
begin
  I := Index;
  if I <= 0 then
    I := 1;
  L := Length(S);
  if I > L then
    Result := 0
  else
    begin
      P := Pointer(S);
      Dec(I);
      Inc(P, I);
      Result := StrPMatchLenW(P, L - I, M);
    end;
end;
{$ENDIF}

function StrMatchLen(const S: String; const M: ByteCharSet; const Index: Integer): Integer;
var P    : PChar;
    L, I : Integer;
begin
  I := Index;
  if I <= 0 then
    I := 1;
  L := Length(S);
  if I > L then
    Result := 0
  else
    begin
      P := Pointer(S);
      Dec(I);
      Inc(P, I);
      Result := StrPMatchLen(P, L - I, M);
    end;
end;
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function StrMatchCharA(const S: AnsiString; const M: CharSet): Boolean;
var L: Integer;
begin
  L := Length(S);
  Result := (L > 0) and (StrMatchLen(S, M, 1) = L);
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function StrMatchCharA(const S: AnsiString; const M: ByteCharSet): Boolean;
var L: Integer;
begin
  L := Length(S);
  Result := (L > 0) and (StrPMatchLenA(Pointer(S), L, M) = L);
end;
{$ENDIF}

function StrMatchCharB(const S: RawByteString; const M: ByteCharSet): Boolean;
var L: Integer;
begin
  L := Length(S);
  Result := (L > 0) and (StrPMatchLenA(Pointer(S), L, M) = L);
end;

{$IFDEF SupportWideString}
function StrMatchCharW(const S: WideString; const M: ByteCharSet): Boolean;
var L: Integer;
begin
  L := Length(S);
  Result := (L > 0) and (StrPMatchLenW(Pointer(S), L, M) = L);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrMatchCharW(const S: WideString; const M: TWideCharMatchFunction): Boolean;
var L: Integer;
begin
  L := Length(S);
  Result := (L > 0) and (StrPMatchLenW(Pointer(S), L, M) = L);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrMatchCharU(const S: UnicodeString; const M: ByteCharSet): Boolean;
var L: Integer;
begin
  L := Length(S);
  Result := (L > 0) and (StrPMatchLenW(Pointer(S), L, M) = L);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrMatchCharU(const S: UnicodeString; const M: TWideCharMatchFunction): Boolean;
var L: Integer;
begin
  L := Length(S);
  Result := (L > 0) and (StrPMatchLenW(Pointer(S), L, M) = L);
end;
{$ENDIF}

function StrMatchChar(const S: String; const M: ByteCharSet): Boolean;
var L: Integer;
begin
  L := Length(S);
  Result := (L > 0) and (StrPMatchLen(Pointer(S), L, M) = L);
end;
{$ENDIF}



{                                                                              }
{ Equal                                                                        }
{                                                                              }
{$IFNDEF CLR}
function StrPEqual(const P1, P2: PByteChar; const Len1, Len2: Integer;
         const AsciiCaseSensitive: Boolean): Boolean;
begin
  Result := Len1 = Len2;
  if not Result or (Len1 = 0) then
    exit;
  if AsciiCaseSensitive then
    Result := StrPMatchA(P1, P2, Len1)
  else
    Result := StrPMatchNoAsciiCaseA(P1, P2, Len1);
end;

{$IFDEF SupportAnsiString}
function StrPEqualStr(const P: PAnsiChar; const Len: Integer; const S: AnsiString;
         const AsciiCaseSensitive: Boolean): Boolean;
begin
  Result := Len = Length(S);
  if not Result or (Len = 0) then
    exit;
  if AsciiCaseSensitive then
    Result := StrPMatchA(Pointer(P), Pointer(S), Len)
  else
    Result := StrPMatchNoAsciiCaseA(Pointer(P), Pointer(S), Len);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function StrEqual(const A, B: AnsiString; const CaseSensitive: Boolean): Boolean;
var L1, L2 : Integer;
begin
  L1 := Length(A);
  L2 := Length(B);
  Result := L1 = L2;
  if not Result or (L1 = 0) then
    exit;
  if CaseSensitive then
    Result := StrPMatchA(A, B, L1)
  else
    Result := StrPMatchNoAsciiCaseA(A, B, L1);
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function StrEqualA(const A, B: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
var L1, L2 : Integer;
begin
  L1 := Length(A);
  L2 := Length(B);
  Result := L1 = L2;
  if not Result or (L1 = 0) then
    exit;
  if AsciiCaseSensitive then
    Result := StrPMatchA(Pointer(A), Pointer(B), L1)
  else
    Result := StrPMatchNoAsciiCaseA(Pointer(A), Pointer(B), L1);
end;
{$ENDIF}

function StrEqualB(const A, B: RawByteString; const AsciiCaseSensitive: Boolean): Boolean;
var L1, L2 : Integer;
begin
  L1 := Length(A);
  L2 := Length(B);
  Result := L1 = L2;
  if not Result or (L1 = 0) then
    exit;
  if AsciiCaseSensitive then
    Result := StrPMatchA(Pointer(A), Pointer(B), L1)
  else
    Result := StrPMatchNoAsciiCaseA(Pointer(A), Pointer(B), L1);
end;

{$IFDEF SupportWideString}
function StrEqualW(const A, B: WideString; const AsciiCaseSensitive: Boolean): Boolean;
var L1, L2 : Integer;
begin
  L1 := Length(A);
  L2 := Length(B);
  Result := L1 = L2;
  if not Result or (L1 = 0) then
    exit;
  if AsciiCaseSensitive then
    Result := StrPMatchW(Pointer(A), Pointer(B), L1)
  else
    Result := StrPMatchNoAsciiCaseW(Pointer(A), Pointer(B), L1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
{$IFDEF SupportAnsiString}
function StrEqualAW(const A: WideString; const B: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
var L1, L2 : Integer;
begin
  L1 := Length(A);
  L2 := Length(B);
  Result := L1 = L2;
  if not Result or (L1 = 0) then
    exit;
  if AsciiCaseSensitive then
    Result := StrPMatchAW(Pointer(A), Pointer(B), L1, L1)
  else
    Result := StrPMatchNoAsciiCaseAW(Pointer(A), Pointer(B), L1);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportWideString}
function StrEqualBW(const A: WideString; const B: RawByteString; const AsciiCaseSensitive: Boolean): Boolean;
var L1, L2 : Integer;
begin
  L1 := Length(A);
  L2 := Length(B);
  Result := L1 = L2;
  if not Result or (L1 = 0) then
    exit;
  if AsciiCaseSensitive then
    Result := StrPMatchAW(Pointer(A), Pointer(B), L1, L1)
  else
    Result := StrPMatchNoAsciiCaseAW(Pointer(A), Pointer(B), L1);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrEqualU(const A, B: UnicodeString; const AsciiCaseSensitive: Boolean): Boolean;
var L1, L2 : Integer;
begin
  L1 := Length(A);
  L2 := Length(B);
  Result := L1 = L2;
  if not Result or (L1 = 0) then
    exit;
  if AsciiCaseSensitive then
    Result := StrPMatchW(Pointer(A), Pointer(B), L1)
  else
    Result := StrPMatchNoAsciiCaseW(Pointer(A), Pointer(B), L1);
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function StrEqualAU(const A: UnicodeString; const B: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
var L1, L2 : Integer;
begin
  L1 := Length(A);
  L2 := Length(B);
  Result := L1 = L2;
  if not Result or (L1 = 0) then
    exit;
  if AsciiCaseSensitive then
    Result := StrPMatchAW(Pointer(A), Pointer(B), L1, L1)
  else
    Result := StrPMatchNoAsciiCaseAW(Pointer(A), Pointer(B), L1);
end;
{$ENDIF}
{$ENDIF}

function StrEqual(const A, B: String; const AsciiCaseSensitive: Boolean): Boolean;
var L1, L2 : Integer;
begin
  L1 := Length(A);
  L2 := Length(B);
  Result := L1 = L2;
  if not Result or (L1 = 0) then
    exit;
  if AsciiCaseSensitive then
    Result := StrPMatch(Pointer(A), Pointer(B), L1)
  else
    Result := StrPMatchNoAsciiCase(Pointer(A), Pointer(B), L1);
end;
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function StrEqualNoAsciiCaseA(const A, B: AnsiString): Boolean;
var L : Integer;
begin
  L := Length(A);
  Result := L = Length(B);
  if not Result or (L = 0) then
    exit;
  Result := StrPMatchNoAsciiCaseA(A, B, L);
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function StrEqualNoAsciiCaseA(const A, B: AnsiString): Boolean;
var L, M : Integer;
begin
  L := Length(A);
  M := Length(B);
  Result := L = M;
  if not Result or (L = 0) then
    exit;
  Result := StrPMatchNoAsciiCaseA(Pointer(A), Pointer(B), L);
end;
{$ENDIF}

function StrEqualNoAsciiCaseB(const A, B: RawByteString): Boolean;
var L, M : Integer;
begin
  L := Length(A);
  M := Length(B);
  Result := L = M;
  if not Result or (L = 0) then
    exit;
  Result := StrPMatchNoAsciiCaseA(Pointer(A), Pointer(B), L);
end;

{$IFDEF SupportWideString}
function StrEqualNoAsciiCaseW(const A, B: WideString): Boolean;
var L, M : Integer;
begin
  L := Length(A);
  M := Length(B);
  Result := L = M;
  if not Result or (L = 0) then
    exit;
  Result := StrPMatchNoAsciiCaseW(Pointer(A), Pointer(B), L);
end;
{$ENDIF}

{$IFDEF SupportWideString}
{$IFDEF SupportAnsiString}
function StrEqualNoAsciiCaseAW(const A: WideString; const B: AnsiString): Boolean;
var L, M : Integer;
begin
  L := Length(A);
  M := Length(B);
  Result := L = M;
  if not Result or (L = 0) then
    exit;
  Result := StrPMatchNoAsciiCaseAW(Pointer(A), Pointer(B), L);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportWideString}
function StrEqualNoAsciiCaseBW(const A: WideString; const B: RawByteString): Boolean;
var L, M : Integer;
begin
  L := Length(A);
  M := Length(B);
  Result := L = M;
  if not Result or (L = 0) then
    exit;
  Result := StrPMatchNoAsciiCaseAW(Pointer(A), Pointer(B), L);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrEqualNoAsciiCaseU(const A, B: UnicodeString): Boolean;
var L, M : Integer;
begin
  L := Length(A);
  M := Length(B);
  Result := L = M;
  if not Result or (L = 0) then
    exit;
  Result := StrPMatchNoAsciiCaseW(Pointer(A), Pointer(B), L);
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function StrEqualNoAsciiCaseAU(const A: UnicodeString; const B: AnsiString): Boolean;
var L, M : Integer;
begin
  L := Length(A);
  M := Length(B);
  Result := L = M;
  if not Result or (L = 0) then
    exit;
  Result := StrPMatchNoAsciiCaseAW(Pointer(A), Pointer(B), L);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrEqualNoAsciiCaseBU(const A: UnicodeString; const B: RawByteString): Boolean;
var L, M : Integer;
begin
  L := Length(A);
  M := Length(B);
  Result := L = M;
  if not Result or (L = 0) then
    exit;
  Result := StrPMatchNoAsciiCaseAW(Pointer(A), Pointer(B), L);
end;
{$ENDIF}

function StrEqualNoAsciiCase(const A, B: String): Boolean;
var L, M : Integer;
begin
  L := Length(A);
  M := Length(B);
  Result := L = M;
  if not Result or (L = 0) then
    exit;
  Result := StrPMatchNoAsciiCase(Pointer(A), Pointer(B), L);
end;
{$ENDIF}



{                                                                              }
{ Validation                                                                   }
{                                                                              }
{$IFDEF SupportAnsiString}
function StrIsNumericA(const S: AnsiString): Boolean;
begin
  Result := StrMatchCharA(S, csNumeric);
end;
{$ENDIF}

function StrIsNumericB(const S: RawByteString): Boolean;
begin
  Result := StrMatchCharB(S, csNumeric);
end;

{$IFDEF SupportWideString}
function StrIsNumericW(const S: WideString): Boolean;
begin
  Result := StrMatchCharW(S, csNumeric);
end;
{$ENDIF}

function StrIsNumeric(const S: String): Boolean;
begin
  Result := StrMatchChar(S, csNumeric);
end;

{$IFDEF SupportAnsiString}
function StrIsHexA(const S: AnsiString): Boolean;
begin
  Result := StrMatchCharA(S, csHexDigit);
end;
{$ENDIF}

function StrIsHexB(const S: RawByteString): Boolean;
begin
  Result := StrMatchCharB(S, csHexDigit);
end;

{$IFDEF SupportWideString}
function StrIsHexW(const S: WideString): Boolean;
begin
  Result := StrMatchCharW(S, csHexDigit);
end;
{$ENDIF}

function StrIsHex(const S: String): Boolean;
begin
  Result := StrMatchChar(S, csHexDigit);
end;

{$IFDEF SupportAnsiString}
function StrIsAlphaA(const S: AnsiString): Boolean;
begin
  Result := StrMatchCharA(S, csAlpha);
end;
{$ENDIF}

function StrIsAlphaB(const S: RawByteString): Boolean;
begin
  Result := StrMatchCharB(S, csAlpha);
end;

{$IFDEF SupportWideString}
function StrIsAlphaW(const S: WideString): Boolean;
begin
  Result := StrMatchCharW(S, csAlpha);
end;
{$ENDIF}

function StrIsAlpha(const S: String): Boolean;
begin
  Result := StrMatchChar(S, csAlpha);
end;

{$IFDEF SupportAnsiString}
function StrIsAlphaNumericA(const S: AnsiString): Boolean;
begin
  Result := StrMatchCharA(S, csAlphaNumeric);
end;
{$ENDIF}

function StrIsAlphaNumericB(const S: RawByteString): Boolean;
begin
  Result := StrMatchCharB(S, csAlphaNumeric);
end;

{$IFDEF SupportWideString}
function StrIsAlphaNumericW(const S: WideString): Boolean;
begin
  Result := StrMatchCharW(S, csAlphaNumeric);
end;
{$ENDIF}

function StrIsAlphaNumeric(const S: String): Boolean;
begin
  Result := StrMatchChar(S, csAlphaNumeric);
end;

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function StrIsInteger(const S: AnsiString): Boolean;
var L : Integer;
    P : Integer;
begin
  L := Length(S);
  Result := L > 0;
  if not Result then
    exit;
  P := 1;
  if S[P] in csSign then
    begin
      Inc(P);
      Dec(L);
    end;
  Result := (L > 0) and (StrMatchLen(S, csNumeric, P) = L);
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function StrIsIntegerA(const S: AnsiString): Boolean;
var L: Integer;
    P: PAnsiChar;
begin
  L := Length(S);
  Result := L > 0;
  if not Result then
    exit;
  P := Pointer(S);
  if P^ in csSign then
    begin
      Inc(P);
      Dec(L);
    end;
  Result := (L > 0) and (StrPMatchLenA(Pointer(P), L, csNumeric) = L);
end;
{$ENDIF}

function StrIsIntegerB(const S: RawByteString): Boolean;
var L: Integer;
    P: PByteChar;
begin
  L := Length(S);
  Result := L > 0;
  if not Result then
    exit;
  P := Pointer(S);
  if P^ in csSign then
    begin
      Inc(P);
      Dec(L);
    end;
  Result := (L > 0) and (StrPMatchLenA(P, L, csNumeric) = L);
end;

{$IFDEF SupportWideString}
function StrIsIntegerW(const S: WideString): Boolean;
var L: Integer;
    P: PWideChar;
begin
  L := Length(S);
  Result := L > 0;
  if not Result then
    exit;
  P := Pointer(S);
  case P^ of
    '+', '-' :
      begin
        Inc(P);
        Dec(L);
      end;
  end;
  Result := (L > 0) and (StrPMatchLenW(P, L, csNumeric) = L);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrIsIntegerU(const S: UnicodeString): Boolean;
var L: Integer;
    P: PWideChar;
begin
  L := Length(S);
  Result := L > 0;
  if not Result then
    exit;
  P := Pointer(S);
  case P^ of
    '+', '-' :
      begin
        Inc(P);
        Dec(L);
      end;
  end;
  Result := (L > 0) and (StrPMatchLenW(P, L, csNumeric) = L);
end;
{$ENDIF}

function StrIsInteger(const S: String): Boolean;
var L: Integer;
    P: PChar;
begin
  L := Length(S);
  Result := L > 0;
  if not Result then
    exit;
  P := Pointer(S);
  case P^ of
    '+', '-' :
      begin
        Inc(P);
        Dec(L);
      end;
  end;
  Result := (L > 0) and (StrPMatchLen(P, L, csNumeric) = L);
end;
{$ENDIF}



{                                                                              }
{ Pos                                                                          }
{                                                                              }

{$IFNDEF ManagedCode}
function StrPPosCharA(const F: AnsiChar; const S: PByteChar; const Len: Integer): Integer;
var I : Integer;
    P : PByteChar;
begin
  if Len <= 0 then
    begin
      Result := -1;
      exit;
    end;
  P := S;
  for I := 0 to Len - 1 do
    if P^ = F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(P);
  Result := -1;
end;

function StrPPosCharW(const F: WideChar; const S: PWideChar; const Len: Integer): Integer;
var I : Integer;
    P : PWideChar;
begin
  if Len <= 0 then
    begin
      Result := -1;
      exit;
    end;
  P := S;
  for I := 0 to Len - 1 do
    if P^ = F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(P);
  Result := -1;
end;

function StrPPosCharSetA(const F: ByteCharSet; const S: PByteChar; const Len: Integer): Integer;
var I : Integer;
    P : PByteChar;
begin
  if Len <= 0 then
    begin
      Result := -1;
      exit;
    end;
  P := S;
  for I := 0 to Len - 1 do
    if P^ in F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(P);
  Result := -1;
end;

function StrPPosCharSetW(const F: ByteCharSet; const S: PWideChar; const Len: Integer): Integer;
var I : Integer;
    P : PWideChar;
begin
  if Len <= 0 then
    begin
      Result := -1;
      exit;
    end;
  P := S;
  for I := 0 to Len - 1 do
    if WideCharInCharSet(P^, F) then
      begin
        Result := I;
        exit;
      end
    else
      Inc(P);
  Result := -1;
end;

function StrPPosA(const F, S: PByteChar; const LenF, LenS: Integer): Integer;
var I : Integer;
    P : PByteChar;
begin
  if (LenF <= 0) or (LenS <= 0) or (LenF > LenS) then
    begin
      Result := -1;
      exit;
    end;
  P := S;
  for I := 0 to LenS - LenF do
    if StrPMatchA(P, F, LenF) then
      begin
        Result := I;
        exit;
      end
    else
      Inc(P);
  Result := -1;
end;

function StrPPosW(const F, S: PWideChar; const LenF, LenS: Integer): Integer;
var I : Integer;
    P : PWideChar;
begin
  if (LenF <= 0) or (LenS <= 0) or (LenF > LenS) then
    begin
      Result := -1;
      exit;
    end;
  P := S;
  for I := 0 to LenS - LenF do
    if StrPMatchW(P, F, LenF) then
      begin
        Result := I;
        exit;
      end
    else
      Inc(P);
  Result := -1;
end;

{$IFDEF SupportAnsiString}
function StrPPosStrA(const F: AnsiString; const S: PAnsiChar; const Len: Integer): Integer;
var LenF : Integer;
    I : Integer;
    P : PAnsiChar;
begin
  LenF := Length(F);
  if (LenF <= 0) or (Len <= 0) or (LenF > Len) then
    begin
      Result := -1;
      exit;
    end;
  P := S;
  for I := 0 to Len - LenF do
    if StrPMatchStrA(P, LenF, F) then
      begin
        Result := I;
        exit;
      end
    else
      Inc(P);
  Result := -1;
end;
{$ENDIF}

function StrPPosStrB(const F: RawByteString; const S: PByteChar; const Len: Integer): Integer;
var LenF : Integer;
    I : Integer;
    P : PByteChar;
begin
  LenF := Length(F);
  if (LenF <= 0) or (Len <= 0) or (LenF > Len) then
    begin
      Result := -1;
      exit;
    end;
  P := S;
  for I := 0 to Len - LenF do
    if StrPMatchStrB(P, LenF, F) then
      begin
        Result := I;
        exit;
      end
    else
      Inc(P);
  Result := -1;
end;
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function PosCharA(const F: AnsiChar; const S: AnsiString; const Index: Integer): Integer;
var L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  while I <= L do
    if S[I] = F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(I);
  Result := 0;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function PosCharA(const F: AnsiChar; const S: AnsiString; const Index: Integer): Integer;
var P    : PAnsiChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    if P^ = F then
      begin
        Result := I;
        exit;
      end else
      begin
        Inc(P);
        Inc(I);
      end;
  Result := 0;
end;
{$ENDIF}
{$ENDIF}

function PosCharB(const F: AnsiChar; const S: RawByteString; const Index: Integer): Integer;
var P    : PByteChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    if P^ = F then
      begin
        Result := I;
        exit;
      end else
      begin
        Inc(P);
        Inc(I);
      end;
  Result := 0;
end;

{$IFDEF SupportWideString}
function PosCharW(const F: WideChar; const S: WideString; const Index: Integer): Integer;
var L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  while I <= L do
    if S[I] = F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(I);
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosCharU(const F: WideChar; const S: UnicodeString; const Index: Integer): Integer;
var L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  while I <= L do
    if S[I] = F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(I);
  Result := 0;
end;
{$ENDIF}

function PosChar(const F: Char; const S: String; const Index: Integer): Integer;
var L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  while I <= L do
    if S[I] = F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(I);
  Result := 0;
end;

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function PosCharSetA(const F: CharSet; const S: AnsiString; const Index: Integer): Integer;
var L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  while I <= L do
    if S[I] in F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(I);
  Result := 0;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function PosCharSetA(const F: ByteCharSet; const S: AnsiString; const Index: Integer): Integer;
var P    : PAnsiChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    if P^ in F then
      begin
        Result := I;
        exit;
      end else
      begin
        Inc(P);
        Inc(I);
      end;
  Result := 0;
end;
{$ENDIF}

function PosCharSetB(const F: ByteCharSet; const S: RawByteString; const Index: Integer): Integer;
var P    : PByteChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    if P^ in F then
      begin
        Result := I;
        exit;
      end else
      begin
        Inc(P);
        Inc(I);
      end;
  Result := 0;
end;

{$IFDEF SupportWideString}
function PosCharSetW(const F: ByteCharSet; const S: WideString;
    const Index: Integer): Integer;
var P    : PWideChar;
    C    : WideChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    begin
      C := P^;
      if Ord(C) <= $FF then
        if AnsiChar(Ord(C)) in F then
          begin
            Result := I;
            exit;
          end else
          begin
            Inc(P);
            Inc(I);
          end;
    end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function PosCharSetW(const F: TWideCharMatchFunction; const S: WideString;
    const Index: Integer): Integer;
var P    : PWideChar;
    C    : WideChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    begin
      C := P^;
      if F(C) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
    end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosCharSetU(const F: ByteCharSet; const S: UnicodeString;
    const Index: Integer): Integer;
var P    : PWideChar;
    C    : WideChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    begin
      C := P^;
      if Ord(C) <= $FF then
        if AnsiChar(Ord(C)) in F then
          begin
            Result := I;
            exit;
          end else
          begin
            Inc(P);
            Inc(I);
          end;
    end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosCharSetU(const F: TWideCharMatchFunction; const S: UnicodeString;
    const Index: Integer): Integer;
var P    : PWideChar;
    C    : WideChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    begin
      C := P^;
      if F(C) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
    end;
  Result := 0;
end;
{$ENDIF}

function PosCharSet(const F: ByteCharSet; const S: String;
    const Index: Integer): Integer;
var P    : PChar;
    C    : Char;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    begin
      C := P^;
      {$IFDEF StringIsUnicode}
      if Ord(C) <= $FF then
      {$ENDIF}
        if AnsiChar(Ord(C)) in F then
          begin
            Result := I;
            exit;
          end else
          begin
            Inc(P);
            Inc(I);
          end;
    end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function PosNotCharA(const F: AnsiChar; const S: AnsiString;
    const Index: Integer): Integer;
var L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  while I <= L do
    if S[I] <> F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(I);
  Result := 0;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function PosNotCharA(const F: AnsiChar; const S: AnsiString;
    const Index: Integer): Integer;
var P    : PAnsiChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    if P^ <> F then
      begin
        Result := I;
        exit;
      end else
      begin
        Inc(P);
        Inc(I);
      end;
  Result := 0;
end;
{$ENDIF}
{$ENDIF}

function PosNotCharB(const F: AnsiChar; const S: RawByteString;
    const Index: Integer): Integer;
var P    : PByteChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    if P^ <> F then
      begin
        Result := I;
        exit;
      end else
      begin
        Inc(P);
        Inc(I);
      end;
  Result := 0;
end;

{$IFDEF SupportWideString}
function PosNotCharW(const F: WideChar; const S: WideString; const Index: Integer): Integer;
var L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  while I <= L do
    if S[I] <> F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(I);
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosNotCharU(const F: WideChar; const S: UnicodeString; const Index: Integer): Integer;
var L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  while I <= L do
    if S[I] <> F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(I);
  Result := 0;
end;
{$ENDIF}

function PosNotChar(const F: Char; const S: String; const Index: Integer): Integer;
var L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  while I <= L do
    if S[I] <> F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(I);
  Result := 0;
end;

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function PosNotCharSetA(const F: CharSet; const S: AnsiString;
    const Index: Integer): Integer;
var L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  while I <= L do
    if not (S[I] in F) then
      begin
        Result := I;
        exit;
      end
    else
      Inc(I);
  Result := 0;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function PosNotCharSetA(const F: ByteCharSet; const S: AnsiString;
    const Index: Integer): Integer;
var P    : PAnsiChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    if not (P^ in F) then
      begin
        Result := I;
        exit;
      end else
      begin
        Inc(P);
        Inc(I);
      end;
  Result := 0;
end;
{$ENDIF}

function PosNotCharSetB(const F: ByteCharSet; const S: RawByteString;
    const Index: Integer): Integer;
var P    : PByteChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    if not (P^ in F) then
      begin
        Result := I;
        exit;
      end else
      begin
        Inc(P);
        Inc(I);
      end;
  Result := 0;
end;

{$IFDEF SupportWideString}
function PosNotCharSetW(const F: ByteCharSet; const S: WideString;
    const Index: Integer): Integer;
var P    : PWideChar;
    C    : WideChar;
    L, I : Integer;
    R    : Boolean;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    begin
      C := P^;
      R := Ord(C) > $FF;
      if not R then
        R := not (AnsiChar(Ord(C)) in F);
      if R then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
    end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function PosNotCharSetW(const F: TWideCharMatchFunction; const S: WideString;
    const Index: Integer): Integer;
var P    : PWideChar;
    C    : WideChar;
    L, I : Integer;
    R    : Boolean;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    begin
      C := P^;
      R := not F(C);
      if R then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
    end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosNotCharSetU(const F: ByteCharSet; const S: UnicodeString;
    const Index: Integer): Integer;
var P    : PWideChar;
    C    : WideChar;
    L, I : Integer;
    R    : Boolean;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    begin
      C := P^;
      R := Ord(C) > $FF;
      if not R then
        R := not (AnsiChar(Ord(C)) in F);
      if R then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
    end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosNotCharSetU(const F: TWideCharMatchFunction; const S: UnicodeString;
    const Index: Integer): Integer;
var P    : PWideChar;
    C    : WideChar;
    L, I : Integer;
    R    : Boolean;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    begin
      C := P^;
      R := not F(C);
      if R then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
    end;
  Result := 0;
end;
{$ENDIF}

function PosNotCharSet(const F: ByteCharSet; const S: String;
    const Index: Integer): Integer;
var P    : PChar;
    C    : Char;
    L, I : Integer;
    R    : Boolean;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  while I <= L do
    begin
      C := P^;
      {$IFDEF StringIsUnicode}
      R := Ord(C) > $FF;
      if not R then
      {$ENDIF}
        R := not (AnsiChar(Ord(C)) in F);
      if R then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
    end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function PosCharRev(const F: AnsiChar; const S: AnsiString;
    const Index: Integer): Integer;
var L, I, J : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  J := L;
  while J >= I do
    if S[J] = F then
      begin
        Result := J;
        exit;
      end
    else
      Dec(J);
  Result := 0;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function PosCharRevA(const F: AnsiChar; const S: AnsiString;
    const Index: Integer): Integer;
var P       : PAnsiChar;
    L, I, J : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  J := L;
  Inc(P, J - 1);
  while J >= I do
    if P^ = F then
      begin
        Result := J;
        exit;
      end else
      begin
        Dec(P);
        Dec(J);
      end;
  Result := 0;
end;
{$ENDIF}
{$ENDIF}

function PosCharRevB(const F: AnsiChar; const S: RawByteString;
    const Index: Integer): Integer;
var P       : PByteChar;
    L, I, J : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  J := L;
  Inc(P, J - 1);
  while J >= I do
    if P^ = F then
      begin
        Result := J;
        exit;
      end else
      begin
        Dec(P);
        Dec(J);
      end;
  Result := 0;
end;

{$IFDEF SupportWideString}
function PosCharRevW(const F: WideChar; const S: WideString; const Index: Integer): Integer;
var L, I, J : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  J := L;
  while J >= I do
    if S[J] = F then
      begin
        Result := J;
        exit;
      end
    else
      Dec(J);
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosCharRevU(const F: WideChar; const S: UnicodeString; const Index: Integer): Integer;
var L, I, J : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  J := L;
  while J >= I do
    if S[J] = F then
      begin
        Result := J;
        exit;
      end
    else
      Dec(J);
  Result := 0;
end;
{$ENDIF}

function PosCharRev(const F: Char; const S: String; const Index: Integer): Integer;
var L, I, J : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  J := L;
  while J >= I do
    if S[J] = F then
      begin
        Result := J;
        exit;
      end
    else
      Dec(J);
  Result := 0;
end;

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function PosCharSetRevA(const F: CharSet; const S: AnsiString;
    const Index: Integer): Integer;
var L, I, J : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  J := L;
  while J >= I do
    if S[J] in F then
      begin
        Result := J;
        exit;
      end
    else
      Dec(J);
  Result := 0;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function PosCharSetRevA(const F: ByteCharSet; const S: AnsiString; const Index: Integer): Integer;
var P       : PAnsiChar;
    L, I, J : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  J := L;
  Inc(P, J - 1);
  while J >= I do
    if P^ in F then
      begin
        Result := J;
        exit;
      end
    else
      begin
        Dec(P);
        Dec(J);
      end;
  Result := 0;
end;
{$ENDIF}

function PosCharSetRevB(const F: ByteCharSet; const S: RawByteString; const Index: Integer): Integer;
var P       : PByteChar;
    L, I, J : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  J := L;
  Inc(P, J - 1);
  while J >= I do
    if P^ in F then
      begin
        Result := J;
        exit;
      end
    else
      begin
        Dec(P);
        Dec(J);
      end;
  Result := 0;
end;

{$IFDEF SupportWideString}
function PosCharSetRevW(const F: ByteCharSet; const S: WideString; const Index: Integer): Integer;
var P       : PWideChar;
    L, I, J : Integer;
    C       : WideChar;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  J := L;
  Inc(P, J - 1);
  while J >= I do
    begin
      C := P^;
      if Ord(C) <= $FF then
        if AnsiChar(Ord(C)) in F then
          begin
            Result := J;
            exit;
          end
        else
          begin
            Dec(P);
            Dec(J);
          end;
    end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function PosCharSetRevW(const F: TWideCharMatchFunction; const S: WideString; const Index: Integer): Integer;
var P       : PWideChar;
    L, I, J : Integer;
    C       : WideChar;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  J := L;
  Inc(P, J - 1);
  while J >= I do
    begin
      C := P^;
      if F(C) then
        begin
          Result := J;
          exit;
        end
      else
        begin
          Dec(P);
          Dec(J);
        end;
    end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosCharSetRevU(const F: ByteCharSet; const S: UnicodeString; const Index: Integer): Integer;
var P       : PWideChar;
    L, I, J : Integer;
    C       : WideChar;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  J := L;
  Inc(P, J - 1);
  while J >= I do
    begin
      C := P^;
      if Ord(C) <= $FF then
        if AnsiChar(Ord(C)) in F then
          begin
            Result := J;
            exit;
          end
        else
          begin
            Dec(P);
            Dec(J);
          end;
    end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosCharSetRevU(const F: TWideCharMatchFunction; const S: UnicodeString; const Index: Integer): Integer;
var P       : PWideChar;
    L, I, J : Integer;
    C       : WideChar;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  J := L;
  Inc(P, J - 1);
  while J >= I do
    begin
      C := P^;
      if F(C) then
        begin
          Result := J;
          exit;
        end
      else
        begin
          Dec(P);
          Dec(J);
        end;
    end;
  Result := 0;
end;
{$ENDIF}

function PosCharSetRev(const F: ByteCharSet; const S: String; const Index: Integer): Integer;
var P       : PChar;
    L, I, J : Integer;
    C       : Char;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  J := L;
  Inc(P, J - 1);
  while J >= I do
    begin
      C := P^;
      {$IFDEF StringIsUnicode}
      if Ord(C) <= $FF then
      {$ENDIF}
        if AnsiChar(Ord(C)) in F then
          begin
            Result := J;
            exit;
          end
        else
          begin
            Dec(P);
            Dec(J);
          end;
    end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function PosStrA(const F, S: AnsiString; const Index: Integer;
    const CaseSensitive: Boolean): Integer;
var L, M, I : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  Dec(L, M - 1);
  if CaseSensitive then
    while I <= L do
      if StrMatch(S, F, I) then
        begin
          Result := I;
          exit;
        end
      else
        Inc(I)
  else
    while I <= L do
      if StrMatchNoCase(S, F, I) then
        begin
          Result := I;
          exit;
        end
      else
        Inc(I);
  Result := 0;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function PosStrA(const F, S: AnsiString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q    : PAnsiChar;
    L, M, I : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  Dec(L, M - 1);
  if AsciiCaseSensitive then
    while I <= L do
      if StrPMatchA(Pointer(P), Pointer(Q), M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end
  else
    while I <= L do
      if StrPMatchNoAsciiCaseA(Pointer(P), Pointer(Q), M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
  Result := 0;
end;
{$ENDIF}

function PosStrB(const F, S: RawByteString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q    : PByteChar;
    L, M, I : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  Dec(L, M - 1);
  if AsciiCaseSensitive then
    while I <= L do
      if StrPMatchA(P, Q, M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end
  else
    while I <= L do
      if StrPMatchNoAsciiCaseA(P, Q, M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
  Result := 0;
end;

{$IFDEF SupportWideString}
function PosStrW(const F, S: WideString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q    : PWideChar;
    L, M, I : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  Dec(L, M - 1);
  if AsciiCaseSensitive then
    while I <= L do
      if StrPMatchW(P, Q, M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end
  else
    while I <= L do
      if StrPMatchNoAsciiCaseW(P, Q, M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportWideString}
{$IFDEF SupportAnsiString}
function PosStrAW(const F: AnsiString; const S: WideString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P       : PWideChar;
    Q       : PAnsiChar;
    L, M, I : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  Dec(L, M - 1);
  if AsciiCaseSensitive then
    while I <= L do
      if StrPMatchAW(P, Pointer(Q), M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end
  else
    while I <= L do
      if StrPMatchNoAsciiCaseAW(P, Pointer(Q), M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
  Result := 0;
end;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosStrU(const F, S: UnicodeString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q    : PWideChar;
    L, M, I : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  Dec(L, M - 1);
  if AsciiCaseSensitive then
    while I <= L do
      if StrPMatchW(P, Q, M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end
  else
    while I <= L do
      if StrPMatchNoAsciiCaseW(P, Q, M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
{$IFDEF SupportUnicodeString}
function PosStrAU(const F: AnsiString; const S: UnicodeString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P       : PWideChar;
    Q       : PAnsiChar;
    L, M, I : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  Dec(L, M - 1);
  if AsciiCaseSensitive then
    while I <= L do
      if StrPMatchAW(P, Pointer(Q), M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end
  else
    while I <= L do
      if StrPMatchNoAsciiCaseAW(P, Pointer(Q), M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
  Result := 0;
end;
{$ENDIF}
{$ENDIF}

function PosStr(const F, S: String; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q    : PChar;
    L, M, I : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  Dec(L, M - 1);
  if AsciiCaseSensitive then
    while I <= L do
      if StrPMatch(P, Q, M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end
  else
    while I <= L do
      if StrPMatchNoAsciiCase(P, Q, M) then
        begin
          Result := I;
          exit;
        end else
        begin
          Inc(P);
          Inc(I);
        end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function PosStrRev(const F, S: AnsiString; const Index: Integer;
    const CaseSensitive: Boolean): Integer;
var L, M, I, J : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1
  else
    I := Index;
  Dec(L, M - 1);
  J := L;
  if CaseSensitive then
    while J >= I do
      if StrMatch(S, F, J) then
        begin
          Result := J;
          exit;
        end
      else
        Dec(J)
  else
    while J >= I do
      if StrMatchNoCase(S, F, J) then
        begin
          Result := J;
          exit;
        end
      else
        Dec(J);
  Result := 0;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function PosStrRevA(const F, S: AnsiString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q       : PAnsiChar;
    L, M, I, J : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Dec(L, M - 1);
  Inc(P, L - 1);
  J := L;
  if AsciiCaseSensitive then
    while J >= I do
      if StrPMatchA(Pointer(P), Pointer(Q), M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end
  else
    while J >= I do
      if StrPMatchNoAsciiCaseA(Pointer(P), Pointer(Q), M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end;
  Result := 0;
end;
{$ENDIF}

function PosStrRevB(const F, S: RawByteString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q       : PByteChar;
    L, M, I, J : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Dec(L, M - 1);
  Inc(P, L - 1);
  J := L;
  if AsciiCaseSensitive then
    while J >= I do
      if StrPMatchA(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end
  else
    while J >= I do
      if StrPMatchNoAsciiCaseA(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end;
  Result := 0;
end;

{$IFDEF SupportWideString}
function PosStrRevW(const F, S: WideString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q       : PWideChar;
    L, M, I, J : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Dec(L, M - 1);
  Inc(P, L - 1);
  J := L;
  if AsciiCaseSensitive then
    while J >= I do
      if StrPMatchW(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end
  else
    while J >= I do
      if StrPMatchNoAsciiCaseW(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosStrRevU(const F, S: UnicodeString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q       : PWideChar;
    L, M, I, J : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Dec(L, M - 1);
  Inc(P, L - 1);
  J := L;
  if AsciiCaseSensitive then
    while J >= I do
      if StrPMatchW(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end
  else
    while J >= I do
      if StrPMatchNoAsciiCaseW(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end;
  Result := 0;
end;
{$ENDIF}

function PosStrRev(const F, S: String; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q       : PChar;
    L, M, I, J : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := 1
  else
    I := Index;
  P := Pointer(S);
  Dec(L, M - 1);
  Inc(P, L - 1);
  J := L;
  if AsciiCaseSensitive then
    while J >= I do
      if StrPMatch(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end
  else
    while J >= I do
      if StrPMatchNoAsciiCase(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function PosStrRevIdx(const F, S: AnsiString; const Index: Integer;
    const CaseSensitive: Boolean): Integer;
var L, M, I, J : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := L
  else
    I := Index;
  J := I;
  if CaseSensitive then
    while J >= 1 do
      if StrMatch(S, F, J) then
        begin
          Result := J;
          exit;
        end
      else
        Dec(J)
  else
    while J >= 1 do
      if StrMatchNoCase(S, F, J) then
        begin
          Result := J;
          exit;
        end
      else
        Dec(J);
  Result := 0;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function PosStrRevIdxA(const F, S: AnsiString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q       : PAnsiChar;
    L, M, I, J : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := L
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  J := I;
  if AsciiCaseSensitive then
    while J >= 1 do
      if StrPMatchA(Pointer(P), Pointer(Q), M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end
  else
    while J >= 1 do
      if StrPMatchNoAsciiCaseA(Pointer(P), Pointer(Q), M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end;
  Result := 0;
end;
{$ENDIF}

function PosStrRevIdxB(const F, S: RawByteString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q       : PByteChar;
    L, M, I, J : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := L
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  J := I;
  if AsciiCaseSensitive then
    while J >= 1 do
      if StrPMatchA(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end
  else
    while J >= 1 do
      if StrPMatchNoAsciiCaseA(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end;
  Result := 0;
end;

{$IFDEF SupportWideString}
function PosStrRevIdxW(const F, S: WideString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q       : PWideChar;
    L, M, I, J : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := L
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  J := I;
  if AsciiCaseSensitive then
    while J >= 1 do
      if StrPMatchW(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end
  else
    while J >= 1 do
      if StrPMatchNoAsciiCaseW(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosStrRevIdxU(const F, S: UnicodeString; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q       : PWideChar;
    L, M, I, J : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := L
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  J := I;
  if AsciiCaseSensitive then
    while J >= 1 do
      if StrPMatchW(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end
  else
    while J >= 1 do
      if StrPMatchNoAsciiCaseW(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end;
  Result := 0;
end;
{$ENDIF}

function PosStrRevIdx(const F, S: String; const Index: Integer;
    const AsciiCaseSensitive: Boolean): Integer;
var P, Q       : PChar;
    L, M, I, J : Integer;
begin
  L := Length(S);
  M := Length(F);
  if (L = 0) or (Index > L) or (M = 0) or (M > L) then
    begin
      Result := 0;
      exit;
    end;
  Q := Pointer(F);
  if Index < 1 then
    I := L
  else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  J := I;
  if AsciiCaseSensitive then
    while J >= 1 do
      if StrPMatch(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end
  else
    while J >= 1 do
      if StrPMatchNoAsciiCase(P, Q, M) then
        begin
          Result := J;
          exit;
        end else
        begin
          Dec(P);
          Dec(J);
        end;
  Result := 0;
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
function PosNStrA(const F, S: AnsiString; const N: Integer;
    const Index: Integer; const AsciiCaseSensitive: Boolean): Integer;
var I, J, M: Integer;
begin
  Result := 0;
  if N <= 0 then
    exit;
  M := Length(F);
  if M = 0 then
    exit;
  J := Index;
  for I := 1 to N do
    begin
      Result := PosStrA(F, S, J, AsciiCaseSensitive);
      if Result = 0 then
        exit;
      J := Result + M;
    end;
end;
{$ENDIF}

function PosNStrB(const F, S: RawByteString; const N: Integer;
    const Index: Integer; const AsciiCaseSensitive: Boolean): Integer;
var I, J, M: Integer;
begin
  Result := 0;
  if N <= 0 then
    exit;
  M := Length(F);
  if M = 0 then
    exit;
  J := Index;
  for I := 1 to N do
    begin
      Result := PosStrB(F, S, J, AsciiCaseSensitive);
      if Result = 0 then
        exit;
      J := Result + M;
    end;
end;

{$IFDEF SupportWideString}
function PosNStrW(const F, S: WideString; const N: Integer;
    const Index: Integer; const AsciiCaseSensitive: Boolean): Integer;
var I, J, M: Integer;
begin
  Result := 0;
  if N <= 0 then
    exit;
  M := Length(F);
  if M = 0 then
    exit;
  J := Index;
  for I := 1 to N do
    begin
      Result := PosStrW(F, S, J, AsciiCaseSensitive);
      if Result = 0 then
        exit;
      J := Result + M;
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function PosNStrU(const F, S: UnicodeString; const N: Integer;
    const Index: Integer; const AsciiCaseSensitive: Boolean): Integer;
var I, J, M: Integer;
begin
  Result := 0;
  if N <= 0 then
    exit;
  M := Length(F);
  if M = 0 then
    exit;
  J := Index;
  for I := 1 to N do
    begin
      Result := PosStrU(F, S, J, AsciiCaseSensitive);
      if Result = 0 then
        exit;
      J := Result + M;
    end;
end;
{$ENDIF}

function PosNStr(const F, S: String; const N: Integer;
    const Index: Integer; const AsciiCaseSensitive: Boolean): Integer;
var I, J, M: Integer;
begin
  Result := 0;
  if N <= 0 then
    exit;
  M := Length(F);
  if M = 0 then
    exit;
  J := Index;
  for I := 1 to N do
    begin
      Result := PosStr(F, S, J, AsciiCaseSensitive);
      if Result = 0 then
        exit;
      J := Result + M;
    end;
end;



{                                                                              }
{ Copy variations                                                              }
{                                                                              }
{$IFDEF SupportAnsiString}
function CopyRangeA(const S: AnsiString; const StartIndex, StopIndex: Integer): AnsiString;
var L, I : Integer;
begin
  L := Length(S);
  if (StartIndex > StopIndex) or (StopIndex < 1) or (StartIndex > L) or (L = 0) then
    Result := ''
  else
    begin
      if StartIndex <= 1 then
        if StopIndex >= L then
          begin
            Result := S;
            exit;
          end
        else
          I := 1
      else
        I := StartIndex;
      Result := Copy(S, I, StopIndex - I + 1);
    end;
end;
{$ENDIF}

function CopyRangeB(const S: RawByteString; const StartIndex, StopIndex: Integer): RawByteString;
var L, I : Integer;
begin
  L := Length(S);
  if (StartIndex > StopIndex) or (StopIndex < 1) or (StartIndex > L) or (L = 0) then
    Result := ''
  else
    begin
      if StartIndex <= 1 then
        if StopIndex >= L then
          begin
            Result := S;
            exit;
          end
        else
          I := 1
      else
        I := StartIndex;
      Result := Copy(S, I, StopIndex - I + 1);
    end;
end;

{$IFDEF SupportWideString}
function CopyRangeW(const S: WideString; const StartIndex, StopIndex: Integer): WideString;
var L, I : Integer;
begin
  L := Length(S);
  if (StartIndex > StopIndex) or (StopIndex < 1) or (StartIndex > L) or (L = 0) then
    Result := ''
  else
    begin
      if StartIndex <= 1 then
        if StopIndex >= L then
          begin
            Result := S;
            exit;
          end
        else
          I := 1
      else
        I := StartIndex;
      Result := Copy(S, I, StopIndex - I + 1);
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function CopyRangeU(const S: UnicodeString; const StartIndex, StopIndex: Integer): UnicodeString;
var L, I : Integer;
begin
  L := Length(S);
  if (StartIndex > StopIndex) or (StopIndex < 1) or (StartIndex > L) or (L = 0) then
    Result := ''
  else
    begin
      if StartIndex <= 1 then
        if StopIndex >= L then
          begin
            Result := S;
            exit;
          end
        else
          I := 1
      else
        I := StartIndex;
      Result := Copy(S, I, StopIndex - I + 1);
    end;
end;
{$ENDIF}

function CopyRange(const S: String; const StartIndex, StopIndex: Integer): String;
var L, I : Integer;
begin
  L := Length(S);
  if (StartIndex > StopIndex) or (StopIndex < 1) or (StartIndex > L) or (L = 0) then
    Result := ''
  else
    begin
      if StartIndex <= 1 then
        if StopIndex >= L then
          begin
            Result := S;
            exit;
          end
        else
          I := 1
      else
        I := StartIndex;
      Result := Copy(S, I, StopIndex - I + 1);
    end;
end;

{$IFDEF SupportAnsiString}
function CopyFromA(const S: AnsiString; const Index: Integer): AnsiString;
var L : Integer;
begin
  if Index <= 1 then
    Result := S
  else
    begin
      L := Length(S);
      if (L = 0) or (Index > L) then
        Result := ''
      else
        Result := Copy(S, Index, L - Index + 1);
    end;
end;
{$ENDIF}

function CopyFromB(const S: RawByteString; const Index: Integer): RawByteString;
var L : Integer;
begin
  if Index <= 1 then
    Result := S
  else
    begin
      L := Length(S);
      if (L = 0) or (Index > L) then
        Result := ''
      else
        Result := Copy(S, Index, L - Index + 1);
    end;
end;

{$IFDEF SupportWideString}
function CopyFromW(const S: WideString; const Index: Integer): WideString;
var L : Integer;
begin
  if Index <= 1 then
    Result := S
  else
    begin
      L := Length(S);
      if (L = 0) or (Index > L) then
        Result := ''
      else
        Result := Copy(S, Index, L - Index + 1);
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function CopyFromU(const S: UnicodeString; const Index: Integer): UnicodeString;
var L : Integer;
begin
  if Index <= 1 then
    Result := S
  else
    begin
      L := Length(S);
      if (L = 0) or (Index > L) then
        Result := ''
      else
        Result := Copy(S, Index, L - Index + 1);
    end;
end;
{$ENDIF}

function CopyFrom(const S: String; const Index: Integer): String;
var L : Integer;
begin
  if Index <= 1 then
    Result := S
  else
    begin
      L := Length(S);
      if (L = 0) or (Index > L) then
        Result := ''
      else
        Result := Copy(S, Index, L - Index + 1);
    end;
end;

{$IFDEF SupportAnsiString}
function CopyLeftA(const S: AnsiString; const Count: Integer): AnsiString;
var L : Integer;
begin
  L := Length(S);
  if (L = 0) or (Count <= 0) then
    Result := '' else
    if Count >= L then
      Result := S
    else
      Result := Copy(S, 1, Count);
end;
{$ENDIF}

function CopyLeftB(const S: RawByteString; const Count: Integer): RawByteString;
var L : Integer;
begin
  L := Length(S);
  if (L = 0) or (Count <= 0) then
    Result := '' else
    if Count >= L then
      Result := S
    else
      Result := Copy(S, 1, Count);
end;

{$IFDEF SupportWideString}
function CopyLeftW(const S: WideString; const Count: Integer): WideString;
var L : Integer;
begin
  L := Length(S);
  if (L = 0) or (Count <= 0) then
    Result := '' else
    if Count >= L then
      Result := S
    else
      Result := Copy(S, 1, Count);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function CopyLeftU(const S: UnicodeString; const Count: Integer): UnicodeString;
var L : Integer;
begin
  L := Length(S);
  if (L = 0) or (Count <= 0) then
    Result := '' else
    if Count >= L then
      Result := S
    else
      Result := Copy(S, 1, Count);
end;
{$ENDIF}

function CopyLeft(const S: String; const Count: Integer): String;
var L : Integer;
begin
  L := Length(S);
  if (L = 0) or (Count <= 0) then
    Result := '' else
    if Count >= L then
      Result := S
    else
      Result := Copy(S, 1, Count);
end;

{$IFDEF SupportAnsiString}
function CopyRightA(const S: AnsiString; const Count: Integer): AnsiString;
var L : Integer;
begin
  L := Length(S);
  if (L = 0) or (Count <= 0) then
    Result := '' else
    if Count >= L then
      Result := S
    else
      Result := Copy(S, L - Count + 1, Count);
end;

function CopyRightB(const S: RawByteString; const Count: Integer): RawByteString;
var L : Integer;
begin
  L := Length(S);
  if (L = 0) or (Count <= 0) then
    Result := '' else
    if Count >= L then
      Result := S
    else
      Result := Copy(S, L - Count + 1, Count);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function CopyRightW(const S: WideString; const Count: Integer): WideString;
var L : Integer;
begin
  L := Length(S);
  if (L = 0) or (Count <= 0) then
    Result := '' else
    if Count >= L then
      Result := S
    else
      Result := Copy(S, L - Count + 1, Count);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function CopyRightU(const S: UnicodeString; const Count: Integer): UnicodeString;
var L : Integer;
begin
  L := Length(S);
  if (L = 0) or (Count <= 0) then
    Result := '' else
    if Count >= L then
      Result := S
    else
      Result := Copy(S, L - Count + 1, Count);
end;
{$ENDIF}

function CopyRight(const S: String; const Count: Integer): String;
var L : Integer;
begin
  L := Length(S);
  if (L = 0) or (Count <= 0) then
    Result := '' else
    if Count >= L then
      Result := S
    else
      Result := Copy(S, L - Count + 1, Count);
end;

{$IFDEF SupportAnsiString}
function CopyLeftEllipsedA(const S: AnsiString; const Count: Integer): AnsiString;
var L: Integer;
begin
  if Count < 0 then
    begin
      Result := S;
      exit;
    end;
  if Count = 0 then
    begin
      Result := '';
      exit;
    end;
  L := Length(S);
  if L <= Count then
    begin
      Result := S;
      exit;
    end;
  if Count <= 3 then
    begin
      Result := DupCharA(' ', Count);
      exit;
    end;
  Result := Copy(S, 1, Count - 3) + '...';
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function CopyLeftEllipsedU(const S: UnicodeString; const Count: Integer): UnicodeString;
var L: Integer;
begin
  if Count < 0 then
    begin
      Result := S;
      exit;
    end;
  if Count = 0 then
    begin
      Result := '';
      exit;
    end;
  L := Length(S);
  if L <= Count then
    begin
      Result := S;
      exit;
    end;
  if Count <= 3 then
    begin
      Result := DupCharU(' ', Count);
      exit;
    end;
  Result := Copy(S, 1, Count - 3) + '...';
end;
{$ENDIF}



{                                                                              }
{ CopyEx                                                                       }
{                                                                              }

{ TranslateStartStop translates Start, Stop parameters (negative values are    }
{ indexed from back of string) into StartIdx and StopIdx (relative to start).  }
{ Returns False if the Start, Stop does not specify a valid range.             }
function TranslateStart(const Len, Start: Integer; var StartIndex : Integer): Boolean;
begin
  if Len = 0 then
    Result := False
  else
    begin
      StartIndex := Start;
      if Start < 0 then
        Inc(StartIndex, Len + 1);
      if StartIndex > Len then
        Result := False
      else
        begin
          if StartIndex < 1 then
            StartIndex := 1;
          Result := True;
        end;
    end;
end;

function TranslateStartStop(const Len, Start, Stop: Integer; var StartIndex, StopIndex: Integer): Boolean;
begin
  if Len = 0 then
    Result := False
  else
    begin
      StartIndex := Start;
      if Start < 0 then
        Inc(StartIndex, Len + 1);
      StopIndex := Stop;
      if StopIndex < 0 then
        Inc(StopIndex, Len + 1);
      if (StopIndex < 1) or (StartIndex > Len) or (StopIndex < StartIndex) then
        Result := False
      else
        begin
          if StopIndex > Len then
            StopIndex:= Len;
          if StartIndex < 1 then
            StartIndex := 1;
          Result := True;
        end;
    end;
end;

{$IFDEF SupportAnsiString}
function CopyExA(const S: AnsiString; const Start, Count: Integer): AnsiString;
var I, L : Integer;
begin
  L := Length(S);
  if (Count < 0) or not TranslateStart(L, Start, I) then
    Result := '' else
    if (I = 1) and (Count >= L) then
      Result := S
    else
      Result := Copy(S, I, Count);
end;

function CopyExB(const S: RawByteString; const Start, Count: Integer): RawByteString;
var I, L : Integer;
begin
  L := Length(S);
  if (Count < 0) or not TranslateStart(L, Start, I) then
    Result := '' else
    if (I = 1) and (Count >= L) then
      Result := S
    else
      Result := Copy(S, I, Count);
end;
{$ENDIF}

function CopyExW(const S: String; const Start, Count: Integer): String;
var I, L : Integer;
begin
  L := Length(S);
  if (Count < 0) or not TranslateStart(L, Start, I) then
    Result := '' else
    if (I = 1) and (Count >= L) then
      Result := S
    else
      Result := Copy(S, I, Count);
end;

{$IFDEF SupportUnicodeString}
function CopyExU(const S: UnicodeString; const Start, Count: Integer): UnicodeString;
var I, L : Integer;
begin
  L := Length(S);
  if (Count < 0) or not TranslateStart(L, Start, I) then
    Result := '' else
    if (I = 1) and (Count >= L) then
      Result := S
    else
      Result := Copy(S, I, Count);
end;
{$ENDIF}

function CopyEx(const S: String; const Start, Count: Integer): String;
var I, L : Integer;
begin
  L := Length(S);
  if (Count < 0) or not TranslateStart(L, Start, I) then
    Result := '' else
    if (I = 1) and (Count >= L) then
      Result := S
    else
      Result := Copy(S, I, Count);
end;

{$IFDEF SupportAnsiString}
function CopyRangeExA(const S: AnsiString; const Start, Stop: Integer): AnsiString;
var I, J, L : Integer;
begin
  L := Length(S);
  if not TranslateStartStop(L, Start, Stop, I, J) then
    Result := '' else
    if (I = 1) and (J = L) then
      Result := S
    else
      Result := Copy(S, I, J - I + 1);
end;

function CopyRangeExB(const S: RawByteString; const Start, Stop: Integer): RawByteString;
var I, J, L : Integer;
begin
  L := Length(S);
  if not TranslateStartStop(L, Start, Stop, I, J) then
    Result := '' else
    if (I = 1) and (J = L) then
      Result := S
    else
      Result := Copy(S, I, J - I + 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function CopyRangeExW(const S: WideString; const Start, Stop: Integer): WideString;
var I, J, L : Integer;
begin
  L := Length(S);
  if not TranslateStartStop(L, Start, Stop, I, J) then
    Result := '' else
    if (I = 1) and (J = L) then
      Result := S
    else
      Result := Copy(S, I, J - I + 1);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function CopyRangeExU(const S: UnicodeString; const Start, Stop: Integer): UnicodeString;
var I, J, L : Integer;
begin
  L := Length(S);
  if not TranslateStartStop(L, Start, Stop, I, J) then
    Result := '' else
    if (I = 1) and (J = L) then
      Result := S
    else
      Result := Copy(S, I, J - I + 1);
end;
{$ENDIF}

function CopyRangeEx(const S: String; const Start, Stop: Integer): String;
var I, J, L : Integer;
begin
  L := Length(S);
  if not TranslateStartStop(L, Start, Stop, I, J) then
    Result := '' else
    if (I = 1) and (J = L) then
      Result := S
    else
      Result := Copy(S, I, J - I + 1);
end;

{$IFDEF SupportAnsiString}
function CopyFromExA(const S: AnsiString; const Start: Integer): AnsiString;
var I, L : Integer;
begin
  L := Length(S);
  if not TranslateStart(L, Start, I) then
    Result := '' else
    if I <= 1 then
      Result := S
    else
      Result := Copy(S, I, L - I + 1);
end;

function CopyFromExB(const S: RawByteString; const Start: Integer): RawByteString;
var I, L : Integer;
begin
  L := Length(S);
  if not TranslateStart(L, Start, I) then
    Result := '' else
    if I <= 1 then
      Result := S
    else
      Result := Copy(S, I, L - I + 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function CopyFromExW(const S: WideString; const Start: Integer): WideString;
var I, L : Integer;
begin
  L := Length(S);
  if not TranslateStart(L, Start, I) then
    Result := '' else
    if I <= 1 then
      Result := S
    else
      Result := Copy(S, I, L - I + 1);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function CopyFromExU(const S: UnicodeString; const Start: Integer): UnicodeString;
var I, L : Integer;
begin
  L := Length(S);
  if not TranslateStart(L, Start, I) then
    Result := '' else
    if I <= 1 then
      Result := S
    else
      Result := Copy(S, I, L - I + 1);
end;
{$ENDIF}

function CopyFromEx(const S: String; const Start: Integer): String;
var I, L : Integer;
begin
  L := Length(S);
  if not TranslateStart(L, Start, I) then
    Result := '' else
    if I <= 1 then
      Result := S
    else
      Result := Copy(S, I, L - I + 1);
end;



{                                                                              }
{ Trim                                                                         }
{                                                                              }
{$IFDEF SupportAnsiString}
function StrTrimLeftA(const S: AnsiString; const C: ByteCharSet): AnsiString;
var F, L : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and (S[F] in C) do
    Inc(F);
  Result := CopyFromA(S, F);
end;
{$ENDIF}

function StrTrimLeftB(const S: RawByteString; const C: ByteCharSet): RawByteString;
var F, L : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and (S[F] in C) do
    Inc(F);
  Result := CopyFromB(S, F);
end;

{$IFDEF SupportWideString}
function StrTrimLeftW(const S: WideString; const C: ByteCharSet): WideString;
var F, L : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and WideCharInCharSet(S[F], C) do
    Inc(F);
  Result := CopyFromW(S, F);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrTrimLeftW(const S: WideString; const C: TWideCharMatchFunction): WideString;
var F, L : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and C(S[F]) do
    Inc(F);
  Result := CopyFromW(S, F);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrTrimLeftU(const S: UnicodeString; const C: ByteCharSet): UnicodeString;
var F, L : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and WideCharInCharSet(S[F], C) do
    Inc(F);
  Result := CopyFromU(S, F);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrTrimLeftU(const S: UnicodeString; const C: TWideCharMatchFunction): UnicodeString;
var F, L : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and C(S[F]) do
    Inc(F);
  Result := CopyFromU(S, F);
end;
{$ENDIF}

function StrTrimLeft(const S: String; const C: ByteCharSet): String;
begin
  {$IFDEF StringIsUnicode}
  Result := StrTrimLeftU(S, C);
  {$ELSE}
  Result := StrTrimLeftA(S, C);
  {$ENDIF}
end;

{$IFDEF CLR}
procedure StrTrimLeftInPlace(var S: AnsiString; const C: CharSet);
var F, L, I : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and (S[F] in C) do
    Inc(F);
  if F > L then
    S := '' else
    if F > 1 then
      begin
        L := L - F + 1;
        if L > 0 then
          for I := 1 to L do
            S[I] := S[I + F];
        SetLength(S, L);
      end;
end;
{$ELSE}
{$IFDEF SupportAnsiString}
procedure StrTrimLeftInPlaceA(var S: AnsiString; const C: ByteCharSet);
var F, L : Integer;
    P    : PAnsiChar;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and (S[F] in C) do
    Inc(F);
  if F > L then
    S := '' else
    if F > 1 then
      begin
        L := L - F + 1;
        if L > 0 then
          begin
            P := Pointer(S);
            Inc(P, F - 1);
            MoveMem(P^, Pointer(S)^, L);
          end;
        SetLength(S, L);
      end;
end;
{$ENDIF}

procedure StrTrimLeftInPlaceB(var S: RawByteString; const C: ByteCharSet);
var F, L : Integer;
    P    : PByteChar;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and (S[F] in C) do
    Inc(F);
  if F > L then
    S := '' else
    if F > 1 then
      begin
        L := L - F + 1;
        if L > 0 then
          begin
            P := Pointer(S);
            Inc(P, F - 1);
            MoveMem(P^, Pointer(S)^, L);
          end;
        SetLength(S, L);
      end;
end;

{$IFDEF SupportWideString}
procedure StrTrimLeftInPlaceW(var S: WideString; const C: ByteCharSet);
var F, L : Integer;
    P    : PWideChar;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and CharSetMatchCharW(C, S[F], True) do
    Inc(F);
  if F > L then
    S := '' else
    if F > 1 then
      begin
        L := L - F + 1;
        if L > 0 then
          begin
            P := Pointer(S);
            Inc(P, F - 1);
            MoveMem(P^, Pointer(S)^, L * SizeOf(WideChar));
          end;
        SetLength(S, L);
      end;
end;

procedure StrTrimLeftInPlaceW(var S: WideString; const C: TWideCharMatchFunction);
var F, L : Integer;
    P    : PWideChar;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and C(S[F]) do
    Inc(F);
  if F > L then
    S := '' else
    if F > 1 then
      begin
        L := L - F + 1;
        if L > 0 then
          begin
            P := Pointer(S);
            Inc(P, F - 1);
            MoveMem(P^, Pointer(S)^, L * SizeOf(WideChar));
          end;
        SetLength(S, L);
      end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
procedure StrTrimLeftInPlaceU(var S: UnicodeString; const C: ByteCharSet);
var F, L : Integer;
    P    : PWideChar;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and CharSetMatchCharW(C, S[F], True) do
    Inc(F);
  if F > L then
    S := '' else
    if F > 1 then
      begin
        L := L - F + 1;
        if L > 0 then
          begin
            P := Pointer(S);
            Inc(P, F - 1);
            MoveMem(P^, Pointer(S)^, L * SizeOf(WideChar));
          end;
        SetLength(S, L);
      end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
procedure StrTrimLeftInPlaceU(var S: UnicodeString; const C: TWideCharMatchFunction);
var F, L : Integer;
    P    : PWideChar;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and C(S[F]) do
    Inc(F);
  if F > L then
    S := '' else
    if F > 1 then
      begin
        L := L - F + 1;
        if L > 0 then
          begin
            P := Pointer(S);
            Inc(P, F - 1);
            MoveMem(P^, Pointer(S)^, L * SizeOf(WideChar));
          end;
        SetLength(S, L);
      end;
end;
{$ENDIF}

procedure StrTrimLeftInPlace(var S: String; const C: ByteCharSet);
var F, L : Integer;
    P    : PChar;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and CharSetMatchChar(C, S[F], True) do
    Inc(F);
  if F > L then
    S := '' else
    if F > 1 then
      begin
        L := L - F + 1;
        if L > 0 then
          begin
            P := Pointer(S);
            Inc(P, F - 1);
            MoveMem(P^, Pointer(S)^, L * SizeOf(Char));
          end;
        SetLength(S, L);
      end;
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
function StrTrimLeftStrNoCaseA(const S: AnsiString; const TrimStr: AnsiString): AnsiString;
var F, L, M : Integer;
begin
  L := Length(TrimStr);
  M := Length(S);
  F := 1;
  while (F <= M) and StrMatchNoAsciiCaseA(S, TrimStr, F) do
    Inc(F, L);
  Result := CopyFromA(S, F);
end;

function StrTrimLeftStrNoCaseB(const S: RawByteString; const TrimStr: RawByteString): RawByteString;
var F, L, M : Integer;
begin
  L := Length(TrimStr);
  M := Length(S);
  F := 1;
  while (F <= M) and StrMatchNoAsciiCaseB(S, TrimStr, F) do
    Inc(F, L);
  Result := CopyFromB(S, F);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrTrimLeftStrNoCaseW(const S: WideString; const TrimStr: WideString): WideString;
var F, L, M : Integer;
begin
  L := Length(TrimStr);
  M := Length(S);
  F := 1;
  while (F <= M) and StrMatchNoAsciiCaseW(S, TrimStr, F) do
    Inc(F, L);
  Result := CopyFromW(S, F);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrTrimLeftStrNoCaseU(const S: UnicodeString; const TrimStr: UnicodeString): UnicodeString;
var F, L, M : Integer;
begin
  L := Length(TrimStr);
  M := Length(S);
  F := 1;
  while (F <= M) and StrMatchNoAsciiCaseU(S, TrimStr, F) do
    Inc(F, L);
  Result := CopyFromU(S, F);
end;
{$ENDIF}

function StrTrimLeftStrNoCase(const S: String; const TrimStr: String): String;
var F, L, M : Integer;
begin
  L := Length(TrimStr);
  M := Length(S);
  F := 1;
  while (F <= M) and StrMatchNoAsciiCase(S, TrimStr, F) do
    Inc(F, L);
  Result := CopyFrom(S, F);
end;

{$IFDEF SupportAnsiString}
function StrTrimRightA(const S: AnsiString; const C: ByteCharSet): AnsiString;
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and (S[F] in C) do
    Dec(F);
  Result := CopyLeftA(S, F);
end;
{$ENDIF}

function StrTrimRightB(const S: RawByteString; const C: ByteCharSet): RawByteString;
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and (S[F] in C) do
    Dec(F);
  Result := CopyLeftB(S, F);
end;

{$IFDEF SupportWideString}
function StrTrimRightW(const S: WideString; const C: ByteCharSet): WideString;
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and WideCharInCharSet(S[F], C) do
    Dec(F);
  Result := CopyLeftW(S, F);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrTrimRightW(const S: WideString;    const C: TWideCharMatchFunction): WideString;
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and C(S[F]) do
    Dec(F);
  Result := CopyLeftW(S, F);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrTrimRightU(const S: UnicodeString; const C: ByteCharSet): UnicodeString;
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and WideCharInCharSet(S[F], C) do
    Dec(F);
  Result := CopyLeftU(S, F);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrTrimRightU(const S: UnicodeString; const C: TWideCharMatchFunction): UnicodeString;
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and C(S[F]) do
    Dec(F);
  Result := CopyLeftU(S, F);
end;
{$ENDIF}

function StrTrimRight(const S: String; const C: ByteCharSet): String;
begin
  {$IFDEF StringIsUnicode}
  Result := StrTrimRightU(S, C);
  {$ELSE}
  Result := StrTrimRightA(S, C);
  {$ENDIF}
end;

{$IFDEF SupportAnsiString}
procedure StrTrimRightInPlaceA(var S: AnsiString; const C: ByteCharSet);
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and (S[F] in C) do
    Dec(F);
  if F = 0 then
    S := ''
  else
    SetLength(S, F);
end;
{$ENDIF}

procedure StrTrimRightInPlaceB(var S: RawByteString; const C: ByteCharSet);
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and (S[F] in C) do
    Dec(F);
  if F = 0 then
    S := ''
  else
    SetLength(S, F);
end;

{$IFDEF SupportWideString}
procedure StrTrimRightInPlaceW(var S: WideString; const C: ByteCharSet);
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and CharSetMatchCharW(C, S[F], True) do
    Dec(F);
  if F = 0 then
    S := ''
  else
    SetLength(S, F);
end;
{$ENDIF}

{$IFDEF SupportWideString}
procedure StrTrimRightInPlaceW(var S: WideString; const C: TWideCharMatchFunction);
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and C(S[F]) do
    Dec(F);
  if F = 0 then
    S := ''
  else
    SetLength(S, F);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
procedure StrTrimRightInPlaceU(var S: UnicodeString; const C: ByteCharSet);
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and CharSetMatchCharW(C, S[F], True) do
    Dec(F);
  if F = 0 then
    S := ''
  else
    SetLength(S, F);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
procedure StrTrimRightInPlaceU(var S: UnicodeString; const C: TWideCharMatchFunction);
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and C(S[F]) do
    Dec(F);
  if F = 0 then
    S := ''
  else
    SetLength(S, F);
end;
{$ENDIF}

procedure StrTrimRightInPlace(var S: String; const C: ByteCharSet);
var F : Integer;
begin
  F := Length(S);
  while (F >= 1) and CharSetMatchChar(C, S[F], True) do
    Dec(F);
  if F = 0 then
    S := ''
  else
    SetLength(S, F);
end;

{$IFDEF SupportAnsiString}
function StrTrimRightStrNoCaseA(const S: AnsiString; const TrimStr: AnsiString): AnsiString;
var F, L : Integer;
begin
  L := Length(TrimStr);
  F := Length(S) - L  + 1;
  while (F >= 1) and StrMatchNoAsciiCaseA(S, TrimStr, F) do
    Dec(F, L);
  Result := CopyLeftA(S, F + L - 1);
end;

function StrTrimRightStrNoCaseB(const S: RawByteString; const TrimStr: RawByteString): RawByteString;
var F, L : Integer;
begin
  L := Length(TrimStr);
  F := Length(S) - L  + 1;
  while (F >= 1) and StrMatchNoAsciiCaseB(S, TrimStr, F) do
    Dec(F, L);
  Result := CopyLeftA(S, F + L - 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrTrimRightStrNoCaseW(const S: WideString; const TrimStr: WideString): WideString;
var F, L : Integer;
begin
  L := Length(TrimStr);
  F := Length(S) - L  + 1;
  while (F >= 1) and StrMatchNoAsciiCaseW(S, TrimStr, F) do
    Dec(F, L);
  Result := CopyLeftW(S, F + L - 1);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrTrimRightStrNoCaseU(const S: UnicodeString; const TrimStr: UnicodeString): UnicodeString;
var F, L : Integer;
begin
  L := Length(TrimStr);
  F := Length(S) - L  + 1;
  while (F >= 1) and StrMatchNoAsciiCaseU(S, TrimStr, F) do
    Dec(F, L);
  Result := CopyLeftU(S, F + L - 1);
end;
{$ENDIF}

function StrTrimRightStrNoCase(const S: String; const TrimStr: String): String;
var F, L : Integer;
begin
  L := Length(TrimStr);
  F := Length(S) - L  + 1;
  while (F >= 1) and StrMatchNoAsciiCase(S, TrimStr, F) do
    Dec(F, L);
  Result := CopyLeft(S, F + L - 1);
end;

{$IFDEF SupportAnsiString}
function StrTrimA(const S: AnsiString; const C: ByteCharSet): AnsiString;
var F, G, L : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and (S[F] in C) do
    Inc(F);
  G := L;
  while (G >= F) and (S[G] in C) do
    Dec(G);
  Result := CopyRangeA(S, F, G);
end;
{$ENDIF}

function StrTrimB(const S: RawByteString; const C: ByteCharSet): RawByteString;
var F, G, L : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and (S[F] in C) do
    Inc(F);
  G := L;
  while (G >= F) and (S[G] in C) do
    Dec(G);
  Result := CopyRangeB(S, F, G);
end;

{$IFDEF SupportWideString}
function StrTrimW(const S: WideString; const C: ByteCharSet): WideString;
var F, G, L : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and WideCharInCharSet(S[F], C) do
    Inc(F);
  G := L;
  while (G >= F) and WideCharInCharSet(S[G], C) do
    Dec(G);
  Result := CopyRangeW(S, F, G);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrTrimW(const S: WideString; const C: TWideCharMatchFunction): WideString;
var F, G, L : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and C(S[F]) do
    Inc(F);
  G := L;
  while (G >= F) and C(S[G]) do
    Dec(G);
  Result := CopyRangeW(S, F, G);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrTrimU(const S: UnicodeString; const C: ByteCharSet): UnicodeString;
var F, G, L : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and WideCharInCharSet(S[F], C) do
    Inc(F);
  G := L;
  while (G >= F) and WideCharInCharSet(S[G], C) do
    Dec(G);
  Result := CopyRangeU(S, F, G);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrTrimU(const S: UnicodeString; const C: TWideCharMatchFunction): UnicodeString;
var F, G, L : Integer;
begin
  L := Length(S);
  F := 1;
  while (F <= L) and C(S[F]) do
    Inc(F);
  G := L;
  while (G >= F) and C(S[G]) do
    Dec(G);
  Result := CopyRangeU(S, F, G);
end;
{$ENDIF}

function StrTrim(const S: String; const C: ByteCharSet): String;
begin
  {$IFDEF StringIsUnicode}
  Result := StrTrimU(S, C);
  {$ELSE}
  Result := StrTrimA(S, C);
  {$ENDIF}
end;

{$IFDEF SupportAnsiString}
procedure StrTrimInPlaceA(var S: AnsiString; const C: ByteCharSet);
begin
  StrTrimLeftInPlaceA(S, C);
  StrTrimRightInPlaceA(S, C);
end;
{$ENDIF}

procedure StrTrimInPlaceB(var S: RawByteString; const C: ByteCharSet);
begin
  StrTrimLeftInPlaceB(S, C);
  StrTrimRightInPlaceB(S, C);
end;

{$IFDEF SupportWideString}
procedure StrTrimInPlaceW(var S: WideString; const C: ByteCharSet);
begin
  StrTrimLeftInPlaceW(S, C);
  StrTrimRightInPlaceW(S, C);
end;

procedure StrTrimInPlaceW(var S: WideString;    const C: TWideCharMatchFunction);
begin
  StrTrimLeftInPlaceW(S, C);
  StrTrimRightInPlaceW(S, C);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
procedure StrTrimInPlaceU(var S : UnicodeString; const C: ByteCharSet);
begin
  StrTrimLeftInPlaceU(S, C);
  StrTrimRightInPlaceU(S, C);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
procedure StrTrimInPlaceU(var S: UnicodeString; const C: TWideCharMatchFunction);
begin
  StrTrimLeftInPlaceU(S, C);
  StrTrimRightInPlaceU(S, C);
end;
{$ENDIF}

procedure StrTrimInPlace(var S : String; const C: ByteCharSet);
begin
  StrTrimLeftInPlace(S, C);
  StrTrimRightInPlace(S, C);
end;

{$IFDEF SupportAnsiString}
procedure TrimStringsA(var S : AnsiStringArray; const C: ByteCharSet);
var I : Integer;
begin
  for I := 0 to Length(S) - 1 do
    StrTrimInPlaceA(S[I], C);
end;
{$ENDIF}

{$IFDEF SupportRawByteString}
procedure TrimStringsB(var S : RawByteStringArray; const C: ByteCharSet);
var I : Integer;
begin
  for I := 0 to Length(S) - 1 do
    StrTrimInPlaceB(S[I], C);
end;
{$ENDIF}

{$IFDEF SupportWideString}
procedure TrimStringsW(var S : WideStringArray; const C: ByteCharSet);
var I : Integer;
begin
  for I := 0 to Length(S) - 1 do
    StrTrimInPlaceW(S[I], C);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
procedure TrimStringsU(var S : UnicodeStringArray; const C: ByteCharSet);
var I : Integer;
begin
  for I := 0 to Length(S) - 1 do
    StrTrimInPlaceU(S[I], C);
end;
{$ENDIF}



{                                                                              }
{ Dup                                                                          }
{                                                                              }
{$IFNDEF ManagedCode}
{$IFDEF SupportAnsiString}
function BufToStrA(const Buf; const BufSize: Integer): AnsiString;
begin
  if BufSize <= 0 then
    Result := ''
  else
    begin
      SetLength(Result, BufSize);
      MoveMem(Buf, Pointer(Result)^, BufSize);
    end;
end;
{$ENDIF}

function BufToStrB(const Buf; const BufSize: Integer): RawByteString;
begin
  if BufSize <= 0 then
    Result := ''
  else
    begin
      SetLength(Result, BufSize);
      MoveMem(Buf, Pointer(Result)^, BufSize);
    end;
end;

{$IFDEF SupportWideString}
function BufToStrW(const Buf; const BufSize: Integer): WideString;
var L : Integer;
begin
  if BufSize <= 0 then
    Result := ''
  else
    begin
      L := (BufSize + 1) div SizeOf(WideChar);
      SetLength(Result, L);
      MoveMem(Buf, Pointer(Result)^, BufSize);
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function BufToStrU(const Buf; const BufSize: Integer): UnicodeString;
var L : Integer;
begin
  if BufSize <= 0 then
    Result := ''
  else
    begin
      L := (BufSize + 1) div SizeOf(WideChar);
      SetLength(Result, L);
      MoveMem(Buf, Pointer(Result)^, BufSize);
    end;
end;
{$ENDIF}

function BufToStr(const Buf; const BufSize: Integer): String;
var L : Integer;
begin
  if BufSize <= 0 then
    Result := ''
  else
    begin
      {$IFDEF StringIsUnicode}
      L := (BufSize + 1) div SizeOf(Char);
      {$ELSE}
      L := BufSize;
      {$ENDIF}
      SetLength(Result, L);
      MoveMem(Buf, Pointer(Result)^, BufSize);
    end;
end;

{$IFDEF SupportAnsiString}
function DupBufA(const Buf; const BufSize: Integer; const Count: Integer): AnsiString;
var P : PAnsiChar;
    I : Integer;
begin
  if (Count <= 0) or (BufSize <= 0) then
    Result := ''
  else
    begin
      SetLength(Result, Count * BufSize);
      P := Pointer(Result);
      for I := 1 to Count do
        begin
          MoveMem(Buf, P^, BufSize);
          Inc(P, BufSize);
        end;
    end;
end;
{$ENDIF}

function DupBufB(const Buf; const BufSize: Integer; const Count: Integer): RawByteString;
var P : PByteChar;
    I : Integer;
begin
  if (Count <= 0) or (BufSize <= 0) then
    Result := ''
  else
    begin
      SetLength(Result, Count * BufSize);
      P := Pointer(Result);
      for I := 1 to Count do
        begin
          MoveMem(Buf, P^, BufSize);
          Inc(P, BufSize);
        end;
    end;
end;

{$IFDEF SupportWideString}
function DupBufW(const Buf; const BufSize: Integer; const Count: Integer): WideString;
var P : PWideChar;
    I, L : Integer;
begin
  if (Count <= 0) or (BufSize <= 0) then
    Result := ''
  else
    begin
      Assert(BufSize mod SizeOf(WideChar) = 0);
      L := BufSize div SizeOf(WideChar);
      SetLength(Result, Count * L);
      P := Pointer(Result);
      for I := 1 to Count do
        begin
          MoveMem(Buf, P^, BufSize);
          Inc(P, L);
        end;
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function DupBufU(const Buf; const BufSize: Integer; const Count: Integer): UnicodeString;
var P : PWideChar;
    I, L : Integer;
begin
  if (Count <= 0) or (BufSize <= 0) then
    Result := ''
  else
    begin
      Assert(BufSize mod SizeOf(WideChar) = 0);
      L := BufSize div SizeOf(WideChar);
      SetLength(Result, Count * L);
      P := Pointer(Result);
      for I := 1 to Count do
        begin
          MoveMem(Buf, P^, BufSize);
          Inc(P, L);
        end;
    end;
end;
{$ENDIF}

function DupBuf(const Buf; const BufSize: Integer; const Count: Integer): String;
var P : PChar;
    I, L : Integer;
begin
  if (Count <= 0) or (BufSize <= 0) then
    Result := ''
  else
    begin
      {$IFDEF StringIsUnicode}
      Assert(BufSize mod SizeOf(Char) = 0);
      L := BufSize div SizeOf(WideChar);
      {$ELSE}
      L := BufSize;
      {$ENDIF}
      SetLength(Result, Count * L);
      P := Pointer(Result);
      for I := 1 to Count do
        begin
          MoveMem(Buf, P^, BufSize);
          Inc(P, L);
        end;
    end;
end;
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function DupStrA(const S: AnsiString; const Count: Integer): AnsiString;
var L, I, J : Integer;
begin
  L := Length(S);
  if L = 0 then
    Result := ''
  else
    begin
      SetLength(Result, Count * L);
      for I := 0 to Count - 1 do
        for J := 1 to L do
          Result[I * L + J] := S[J];
    end;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function DupStrA(const S: AnsiString; const Count: Integer): AnsiString;
var L : Integer;
begin
  L := Length(S);
  if L = 0 then
    Result := ''
  else
    Result := DupBufA(Pointer(S)^, L, Count);
end;
{$ENDIF}

function DupStrB(const S: RawByteString; const Count: Integer): RawByteString;
var L : Integer;
begin
  L := Length(S);
  if L = 0 then
    Result := ''
  else
    Result := DupBufB(Pointer(S)^, L, Count);
end;

{$IFDEF SupportWideString}
function DupStrW(const S: WideString; const Count: Integer): WideString;
var L : Integer;
begin
  L := Length(S);
  if L = 0 then
    Result := ''
  else
    Result := DupBufW(Pointer(S)^, L * SizeOf(WideChar), Count);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function DupStrU(const S: UnicodeString; const Count: Integer): UnicodeString;
var L : Integer;
begin
  L := Length(S);
  if L = 0 then
    Result := ''
  else
    Result := DupBufU(Pointer(S)^, L * SizeOf(WideChar), Count);
end;
{$ENDIF}

function DupStr(const S: String; const Count: Integer): String;
var L : Integer;
begin
  L := Length(S);
  if L = 0 then
    Result := ''
  else
    Result := DupBuf(Pointer(S)^, L * SizeOf(Char), Count);
end;
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function DupChar(const Ch: AnsiChar; const Count: Integer): AnsiString;
var I : Integer;
begin
  if Count <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, Count);
  for I := 1 to Count do
    Result[I] := Ch;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function DupCharA(const Ch: AnsiChar; const Count: Integer): AnsiString;
begin
  if Count <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, Count);
  FillMem(Pointer(Result)^, Count, Ord(Ch));
end;
{$ENDIF}
{$ENDIF}

function DupCharB(const Ch: AnsiChar; const Count: Integer): RawByteString;
begin
  if Count <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, Count);
  FillMem(Pointer(Result)^, Count, Ord(Ch));
end;

{$IFDEF SupportWideString}
function DupCharW(const Ch: WideChar; const Count: Integer): WideString;
var I : Integer;
begin
  if Count <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, Count);
  for I := 1 to Count do
    Result[I] := Ch;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function DupCharU(const Ch: WideChar; const Count: Integer): UnicodeString;
var I : Integer;
begin
  if Count <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, Count);
  for I := 1 to Count do
    Result[I] := Ch;
end;
{$ENDIF}

function DupChar(const Ch: Char; const Count: Integer): String;
var I : Integer;
begin
  if Count <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, Count);
  for I := 1 to Count do
    Result[I] := Ch;
end;

{$IFDEF SupportAnsiString}
function DupSpaceA(const Count: Integer): AnsiString;
begin
  Result := DupCharA(AsciiSP, Count);
end;
{$ENDIF}

function DupSpaceB(const Count: Integer): RawByteString;
begin
  Result := DupCharB(AsciiSP, Count);
end;

{$IFDEF SupportWideString}
function DupSpaceW(const Count: Integer): WideString;
begin
  Result := DupCharW(WideSP, Count);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function DupSpaceU(const Count: Integer): UnicodeString;
begin
  Result := DupCharU(WideSP, Count);
end;
{$ENDIF}

function DupSpace(const Count: Integer): String;
begin
  Result := DupChar(' ', Count);
end;



{                                                                              }
{ Pad                                                                          }
{                                                                              }
{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function StrPadLeftA(const S: AnsiString; const PadChar: AnsiChar;
    const Len: Integer; const Cut: Boolean): AnsiString;
var L, P, M, I : Integer;
begin
  if Len = 0 then
    begin
      if Cut then
        Result := ''
      else
        Result := S;
      exit;
    end;
  M := Length(S);
  if Len = M then
    begin
      Result := S;
      exit;
    end;
  if Cut then
    L := Len
  else
    L := MaxI(Len, M);
  P := L - M;
  if P < 0 then
    P := 0;
  SetLength(Result, L);
  for I := 1 to P do
    Result[I] := PadChar;
  if L > P then
    for I := 1 to L - P do
      Result[P + I] := S[I];
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function StrPadLeftA(const S: AnsiString; const PadChar: AnsiChar;
    const Len: Integer; const Cut: Boolean): AnsiString;
var F, L, P, M : Integer;
    I, J       : PAnsiChar;
begin
  if Len = 0 then
    begin
      if Cut then
        Result := ''
      else
        Result := S;
      exit;
    end;
  M := Length(S);
  if Len = M then
    begin
      Result := S;
      exit;
    end;
  if Cut then
    L := Len
  else
    L := MaxInt(Len, M);
  P := L - M;
  if P < 0 then
    P := 0;
  SetLength(Result, L);
  if P > 0 then
    FillMem(Pointer(Result)^, P, Ord(PadChar));
  if L > P then
    begin
      I := Pointer(Result);
      J := Pointer(S);
      Inc(I, P);
      for F := 1 to L - P do
        begin
          I^ := J^;
          Inc(I);
          Inc(J);
        end;
    end;
end;
{$ENDIF}

function StrPadLeftB(const S: RawByteString; const PadChar: AnsiChar;
    const Len: Integer; const Cut: Boolean): RawByteString;
var F, L, P, M : Integer;
    I, J       : PByteChar;
begin
  if Len = 0 then
    begin
      if Cut then
        Result := ''
      else
        Result := S;
      exit;
    end;
  M := Length(S);
  if Len = M then
    begin
      Result := S;
      exit;
    end;
  if Cut then
    L := Len
  else
    L := MaxInt(Len, M);
  P := L - M;
  if P < 0 then
    P := 0;
  SetLength(Result, L);
  if P > 0 then
    FillMem(Pointer(Result)^, P, Ord(PadChar));
  if L > P then
    begin
      I := Pointer(Result);
      J := Pointer(S);
      Inc(I, P);
      for F := 1 to L - P do
        begin
          I^ := J^;
          Inc(I);
          Inc(J);
        end;
    end;
end;

{$IFDEF SupportWideString}
function StrPadLeftW(const S: WideString; const PadChar: WideChar;
    const Len: Integer; const Cut: Boolean): WideString;
var F, L, P, M : Integer;
    I, J       : PWideChar;
begin
  if Len = 0 then
    begin
      if Cut then
        Result := ''
      else
        Result := S;
      exit;
    end;
  M := Length(S);
  if Len = M then
    begin
      Result := S;
      exit;
    end;
  if Cut then
    L := Len
  else
    L := MaxInt(Len, M);
  P := L - M;
  if P < 0 then
    P := 0;
  SetLength(Result, L);
  for F := 1 to P do
    Result[F] := PadChar;
  if L > P then
    begin
      I := Pointer(Result);
      J := Pointer(S);
      Inc(I, P);
      for F := 1 to L - P do
        begin
          I^ := J^;
          Inc(I);
          Inc(J);
        end;
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrPadLeftU(const S: UnicodeString; const PadChar: WideChar;
    const Len: Integer; const Cut: Boolean): UnicodeString;
var F, L, P, M : Integer;
    I, J       : PWideChar;
begin
  if Len = 0 then
    begin
      if Cut then
        Result := ''
      else
        Result := S;
      exit;
    end;
  M := Length(S);
  if Len = M then
    begin
      Result := S;
      exit;
    end;
  if Cut then
    L := Len
  else
    L := MaxInt(Len, M);
  P := L - M;
  if P < 0 then
    P := 0;
  SetLength(Result, L);
  for F := 1 to P do
    Result[F] := PadChar;
  if L > P then
    begin
      I := Pointer(Result);
      J := Pointer(S);
      Inc(I, P);
      for F := 1 to L - P do
        begin
          I^ := J^;
          Inc(I);
          Inc(J);
        end;
    end;
end;
{$ENDIF}

function StrPadLeft(const S: String; const PadChar: Char;
    const Len: Integer; const Cut: Boolean): String;
var F, L, P, M : Integer;
    I, J       : PChar;
begin
  if Len = 0 then
    begin
      if Cut then
        Result := ''
      else
        Result := S;
      exit;
    end;
  M := Length(S);
  if Len = M then
    begin
      Result := S;
      exit;
    end;
  if Cut then
    L := Len
  else
    L := MaxInt(Len, M);
  P := L - M;
  if P < 0 then
    P := 0;
  SetLength(Result, L);
  for F := 1 to P do
    Result[F] := PadChar;
  if L > P then
    begin
      I := Pointer(Result);
      J := Pointer(S);
      Inc(I, P);
      for F := 1 to L - P do
        begin
          I^ := J^;
          Inc(I);
          Inc(J);
        end;
    end;
end;
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function StrPadRightA(const S: AnsiString; const PadChar: AnsiChar;
    const Len: Integer; const Cut: Boolean): AnsiString;
var L, P, M, I : Integer;
begin
  if Len = 0 then
    begin
      if Cut then
        Result := ''
      else
        Result := S;
      exit;
    end;
  M := Length(S);
  if Len = M then
    begin
      Result := S;
      exit;
    end;
  if Cut then
    L := Len
  else
    L := MaxI(Len, M);
  P := L - M;
  if P < 0 then
    P := 0;
  SetLength(Result, L);
  if L > P then
    for I := 1 to L - P do
      Result[I] := S[I];
  if P > 0 then
    for I := 1 to P do
      Result[L - P + I] := PadChar;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function StrPadRightA(const S: AnsiString; const PadChar: AnsiChar;
    const Len: Integer; const Cut: Boolean): AnsiString;
var F, L, P, M : Integer;
    I, J       : PAnsiChar;
begin
  if Len = 0 then
    begin
      if Cut then
        Result := ''
      else
        Result := S;
      exit;
    end;
  M := Length(S);
  if Len = M then
    begin
      Result := S;
      exit;
    end;
  if Cut then
    L := Len
  else
    L := MaxInt(Len, M);
  P := L - M;
  if P < 0 then
    P := 0;
  SetLength(Result, L);
  if L > P then
    begin
      I := Pointer(Result);
      J := Pointer(S);
      for F := 1 to L - P do
        begin
          I^ := J^;
          Inc(I);
          Inc(J);
        end;
    end;
  if P > 0 then
    FillMem(Result[L - P + 1], P, Ord(PadChar));
end;
{$ENDIF}

function StrPadRightB(const S: RawByteString; const PadChar: AnsiChar;
    const Len: Integer; const Cut: Boolean): RawByteString;
var F, L, P, M : Integer;
    I, J       : PByteChar;
begin
  if Len = 0 then
    begin
      if Cut then
        Result := ''
      else
        Result := S;
      exit;
    end;
  M := Length(S);
  if Len = M then
    begin
      Result := S;
      exit;
    end;
  if Cut then
    L := Len
  else
    L := MaxInt(Len, M);
  P := L - M;
  if P < 0 then
    P := 0;
  SetLength(Result, L);
  if L > P then
    begin
      I := Pointer(Result);
      J := Pointer(S);
      for F := 1 to L - P do
        begin
          I^ := J^;
          Inc(I);
          Inc(J);
        end;
    end;
  if P > 0 then
    FillMem(Result[L - P + 1], P, Ord(PadChar));
end;

{$IFDEF SupportWideString}
function StrPadRightW(const S: WideString; const PadChar: WideChar;
    const Len: Integer; const Cut: Boolean): WideString;
var F, L, P, M : Integer;
    I, J       : PWideChar;
begin
  if Len = 0 then
    begin
      if Cut then
        Result := ''
      else
        Result := S;
      exit;
    end;
  M := Length(S);
  if Len = M then
    begin
      Result := S;
      exit;
    end;
  if Cut then
    L := Len
  else
    L := MaxInt(Len, M);
  P := L - M;
  if P < 0 then
    P := 0;
  SetLength(Result, L);
  if L > P then
    begin
      I := Pointer(Result);
      J := Pointer(S);
      for F := 1 to L - P do
        begin
          I^ := J^;
          Inc(I);
          Inc(J);
        end;
    end;
  for F := L - P + 1 to L do
    Result[F] := PadChar;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrPadRightU(const S: UnicodeString; const PadChar: WideChar;
    const Len: Integer; const Cut: Boolean): UnicodeString;
var F, L, P, M : Integer;
    I, J       : PWideChar;
begin
  if Len = 0 then
    begin
      if Cut then
        Result := ''
      else
        Result := S;
      exit;
    end;
  M := Length(S);
  if Len = M then
    begin
      Result := S;
      exit;
    end;
  if Cut then
    L := Len
  else
    L := MaxInt(Len, M);
  P := L - M;
  if P < 0 then
    P := 0;
  SetLength(Result, L);
  if L > P then
    begin
      I := Pointer(Result);
      J := Pointer(S);
      for F := 1 to L - P do
        begin
          I^ := J^;
          Inc(I);
          Inc(J);
        end;
    end;
  for F := L - P + 1 to L do
    Result[F] := PadChar;
end;
{$ENDIF}

function StrPadRight(const S: String; const PadChar: Char;
    const Len: Integer; const Cut: Boolean): String;
var F, L, P, M : Integer;
    I, J       : PChar;
begin
  if Len = 0 then
    begin
      if Cut then
        Result := ''
      else
        Result := S;
      exit;
    end;
  M := Length(S);
  if Len = M then
    begin
      Result := S;
      exit;
    end;
  if Cut then
    L := Len
  else
    L := MaxInt(Len, M);
  P := L - M;
  if P < 0 then
    P := 0;
  SetLength(Result, L);
  if L > P then
    begin
      I := Pointer(Result);
      J := Pointer(S);
      for F := 1 to L - P do
        begin
          I^ := J^;
          Inc(I);
          Inc(J);
        end;
    end;
  for F := L - P + 1 to L do
    Result[F] := PadChar;
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
function StrPadA(const S: AnsiString; const PadChar: AnsiChar; const Len: Integer;
    const Cut: Boolean): AnsiString;
var I : Integer;
begin
  I := Len - Length(S);
  Result := DupCharA(PadChar, I div 2) + S + DupCharA(PadChar, (I + 1) div 2);
  if Cut then
    SetLength(Result, Len);
end;
{$ENDIF}

function StrPadB(const S: RawByteString; const PadChar: AnsiChar; const Len: Integer;
    const Cut: Boolean): RawByteString;
var I : Integer;
begin
  I := Len - Length(S);
  Result := DupCharB(PadChar, I div 2) + S + DupCharB(PadChar, (I + 1) div 2);
  if Cut then
    SetLength(Result, Len);
end;

{$IFDEF SupportWideString}
function StrPadW(const S: WideString; const PadChar: WideChar; const Len: Integer;
    const Cut: Boolean): WideString;
var I : Integer;
begin
  I := Len - Length(S);
  Result := DupCharW(PadChar, I div 2) + S + DupCharW(PadChar, (I + 1) div 2);
  if Cut then
    SetLength(Result, Len);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrPadU(const S: UnicodeString; const PadChar: WideChar; const Len: Integer;
    const Cut: Boolean): UnicodeString;
var I : Integer;
begin
  I := Len - Length(S);
  Result := DupCharU(PadChar, I div 2) + S + DupCharU(PadChar, (I + 1) div 2);
  if Cut then
    SetLength(Result, Len);
end;
{$ENDIF}

function StrPad(const S: String; const PadChar: Char; const Len: Integer;
    const Cut: Boolean): String;
var I : Integer;
begin
  I := Len - Length(S);
  Result := DupChar(PadChar, I div 2) + S + DupChar(PadChar, (I + 1) div 2);
  if Cut then
    SetLength(Result, Len);
end;



{                                                                              }
{ Delimited                                                                    }
{                                                                              }
{$IFDEF SupportAnsiString}
function StrBetweenCharA(const S: AnsiString;
    const FirstDelim, SecondDelim: AnsiChar;
    const FirstOptional: Boolean; const SecondOptional: Boolean): AnsiString;
var I, J : Integer;
begin
  Result := '';
  I := PosCharA(FirstDelim, S);
  if (I = 0) and not FirstOptional then
    exit;
  J := PosCharA(SecondDelim, S, I + 1);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeA(S, I + 1, J - 1);
end;

function StrBetweenCharA(const S: AnsiString;
    const FirstDelim, SecondDelim: ByteCharSet;
    const FirstOptional: Boolean; const SecondOptional: Boolean): AnsiString;
var I, J : Integer;
begin
  Result := '';
  I := PosCharSetA(FirstDelim, S);
  if (I = 0) and not FirstOptional then
    exit;
  J := PosCharSetA(SecondDelim, S, I + 1);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeA(S, I + 1, J - 1);
end;

function StrBetweenCharB(const S: RawByteString;
    const FirstDelim, SecondDelim: AnsiChar;
    const FirstOptional: Boolean; const SecondOptional: Boolean): RawByteString;
var I, J : Integer;
begin
  Result := '';
  I := PosCharB(FirstDelim, S);
  if (I = 0) and not FirstOptional then
    exit;
  J := PosCharB(SecondDelim, S, I + 1);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeB(S, I + 1, J - 1);
end;

function StrBetweenCharB(const S: RawByteString;
    const FirstDelim, SecondDelim: ByteCharSet;
    const FirstOptional: Boolean; const SecondOptional: Boolean): RawByteString;
var I, J : Integer;
begin
  Result := '';
  I := PosCharSetB(FirstDelim, S);
  if (I = 0) and not FirstOptional then
    exit;
  J := PosCharSetB(SecondDelim, S, I + 1);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeB(S, I + 1, J - 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrBetweenCharW(const S: WideString;
    const FirstDelim, SecondDelim: WideChar;
    const FirstOptional: Boolean; const SecondOptional: Boolean): WideString;
var I, J : Integer;
begin
  Result := '';
  I := PosCharW(FirstDelim, S);
  if (I = 0) and not FirstOptional then
    exit;
  J := PosCharW(SecondDelim, S, I + 1);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeW(S, I + 1, J - 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrBetweenCharW(const S: WideString;
    const FirstDelim, SecondDelim: ByteCharSet;
    const FirstOptional: Boolean; const SecondOptional: Boolean): WideString;
var I, J : Integer;
begin
  Result := '';
  I := PosCharSetW(FirstDelim, S);
  if (I = 0) and not FirstOptional then
    exit;
  J := PosCharSetW(SecondDelim, S, I + 1);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeW(S, I + 1, J - 1);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrBetweenCharU(const S: UnicodeString;
    const FirstDelim, SecondDelim: WideChar;
    const FirstOptional: Boolean; const SecondOptional: Boolean): UnicodeString;
var I, J : Integer;
begin
  Result := '';
  I := PosCharU(FirstDelim, S);
  if (I = 0) and not FirstOptional then
    exit;
  J := PosCharU(SecondDelim, S, I + 1);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeU(S, I + 1, J - 1);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrBetweenCharU(const S: UnicodeString;
    const FirstDelim, SecondDelim: ByteCharSet;
    const FirstOptional: Boolean; const SecondOptional: Boolean): UnicodeString;
var I, J : Integer;
begin
  Result := '';
  I := PosCharSetU(FirstDelim, S);
  if (I = 0) and not FirstOptional then
    exit;
  J := PosCharSetU(SecondDelim, S, I + 1);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeU(S, I + 1, J - 1);
end;
{$ENDIF}

function StrBetweenChar(const S: String;
    const FirstDelim, SecondDelim: Char;
    const FirstOptional: Boolean; const SecondOptional: Boolean): String;
var I, J : Integer;
begin
  Result := '';
  I := PosChar(FirstDelim, S);
  if (I = 0) and not FirstOptional then
    exit;
  J := PosChar(SecondDelim, S, I + 1);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRange(S, I + 1, J - 1);
end;

function StrBetweenChar(const S: String;
    const FirstDelim, SecondDelim: ByteCharSet;
    const FirstOptional: Boolean; const SecondOptional: Boolean): String;
var I, J : Integer;
begin
  Result := '';
  I := PosCharSet(FirstDelim, S);
  if (I = 0) and not FirstOptional then
    exit;
  J := PosCharSet(SecondDelim, S, I + 1);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRange(S, I + 1, J - 1);
end;

{$IFDEF SupportAnsiString}
function StrBetweenA(const S: AnsiString; const FirstDelim: AnsiString;
    const SecondDelim: ByteCharSet; const FirstOptional: Boolean;
    const SecondOptional: Boolean;
    const FirstDelimAsciiCaseSensitive: Boolean): AnsiString;
var I, J : Integer;
begin
  Result := '';
  I := PosStrA(FirstDelim, S, 1, FirstDelimAsciiCaseSensitive);
  if (I = 0) and not FirstOptional then
    exit;
  Inc(I, Length(FirstDelim));
  J := PosCharSetA(SecondDelim, S, I);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeA(S, I, J - 1);
end;

function StrBetweenA(const S: AnsiString;
    const FirstDelim, SecondDelim: AnsiString; const FirstOptional: Boolean;
    const SecondOptional: Boolean ; const FirstDelimAsciiCaseSensitive: Boolean;
    const SecondDelimAsciiCaseSensitive: Boolean): AnsiString;
var I, J : Integer;
begin
  Result := '';
  I := PosStrA(FirstDelim, S, 1, FirstDelimAsciiCaseSensitive);
  if (I = 0) and not FirstOptional then
    exit;
  Inc(I, Length(FirstDelim));
  J := PosStrA(SecondDelim, S, I, SecondDelimAsciiCaseSensitive);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeA(S, I, J - 1);
end;

function StrBetweenB(const S: RawByteString; const FirstDelim: RawByteString;
    const SecondDelim: ByteCharSet; const FirstOptional: Boolean;
    const SecondOptional: Boolean;
    const FirstDelimAsciiCaseSensitive: Boolean): RawByteString;
var I, J : Integer;
begin
  Result := '';
  I := PosStrB(FirstDelim, S, 1, FirstDelimAsciiCaseSensitive);
  if (I = 0) and not FirstOptional then
    exit;
  Inc(I, Length(FirstDelim));
  J := PosCharSetB(SecondDelim, S, I);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeB(S, I, J - 1);
end;

function StrBetweenB(const S: RawByteString;
    const FirstDelim, SecondDelim: RawByteString; const FirstOptional: Boolean;
    const SecondOptional: Boolean ; const FirstDelimAsciiCaseSensitive: Boolean;
    const SecondDelimAsciiCaseSensitive: Boolean): RawByteString;
var I, J : Integer;
begin
  Result := '';
  I := PosStrB(FirstDelim, S, 1, FirstDelimAsciiCaseSensitive);
  if (I = 0) and not FirstOptional then
    exit;
  Inc(I, Length(FirstDelim));
  J := PosStrB(SecondDelim, S, I, SecondDelimAsciiCaseSensitive);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeB(S, I, J - 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrBetweenW(const S: WideString; const FirstDelim: WideString;
    const SecondDelim: ByteCharSet; const FirstOptional: Boolean;
    const SecondOptional: Boolean;
    const FirstDelimAsciiCaseSensitive: Boolean): WideString;
var I, J : Integer;
begin
  Result := '';
  I := PosStrW(FirstDelim, S, 1, FirstDelimAsciiCaseSensitive);
  if (I = 0) and not FirstOptional then
    exit;
  Inc(I, Length(FirstDelim));
  J := PosCharSetW(SecondDelim, S, I);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeW(S, I, J - 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrBetweenW(const S: WideString;
    const FirstDelim, SecondDelim: WideString; const FirstOptional: Boolean;
    const SecondOptional: Boolean ; const FirstDelimAsciiCaseSensitive: Boolean;
    const SecondDelimAsciiCaseSensitive: Boolean): WideString;
var I, J : Integer;
begin
  Result := '';
  I := PosStrW(FirstDelim, S, 1, FirstDelimAsciiCaseSensitive);
  if (I = 0) and not FirstOptional then
    exit;
  Inc(I, Length(FirstDelim));
  J := PosStrW(SecondDelim, S, I, SecondDelimAsciiCaseSensitive);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeW(S, I, J - 1);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrBetweenU(const S: UnicodeString; const FirstDelim: UnicodeString;
    const SecondDelim: ByteCharSet; const FirstOptional: Boolean;
    const SecondOptional: Boolean;
    const FirstDelimAsciiCaseSensitive: Boolean): UnicodeString;
var I, J : Integer;
begin
  Result := '';
  I := PosStrU(FirstDelim, S, 1, FirstDelimAsciiCaseSensitive);
  if (I = 0) and not FirstOptional then
    exit;
  Inc(I, Length(FirstDelim));
  J := PosCharSetU(SecondDelim, S, I);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeU(S, I, J - 1);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrBetweenU(const S: UnicodeString;
    const FirstDelim, SecondDelim: UnicodeString; const FirstOptional: Boolean;
    const SecondOptional: Boolean ; const FirstDelimAsciiCaseSensitive: Boolean;
    const SecondDelimAsciiCaseSensitive: Boolean): UnicodeString;
var I, J : Integer;
begin
  Result := '';
  I := PosStrU(FirstDelim, S, 1, FirstDelimAsciiCaseSensitive);
  if (I = 0) and not FirstOptional then
    exit;
  Inc(I, Length(FirstDelim));
  J := PosStrU(SecondDelim, S, I, SecondDelimAsciiCaseSensitive);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRangeU(S, I, J - 1);
end;
{$ENDIF}

function StrBetween(const S: String; const FirstDelim: String;
    const SecondDelim: ByteCharSet; const FirstOptional: Boolean;
    const SecondOptional: Boolean;
    const FirstDelimAsciiCaseSensitive: Boolean): String;
var I, J : Integer;
begin
  Result := '';
  I := PosStr(FirstDelim, S, 1, FirstDelimAsciiCaseSensitive);
  if (I = 0) and not FirstOptional then
    exit;
  Inc(I, Length(FirstDelim));
  J := PosCharSet(SecondDelim, S, I);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRange(S, I, J - 1);
end;

function StrBetween(const S: String;
    const FirstDelim, SecondDelim: String; const FirstOptional: Boolean;
    const SecondOptional: Boolean ; const FirstDelimAsciiCaseSensitive: Boolean;
    const SecondDelimAsciiCaseSensitive: Boolean): String;
var I, J : Integer;
begin
  Result := '';
  I := PosStr(FirstDelim, S, 1, FirstDelimAsciiCaseSensitive);
  if (I = 0) and not FirstOptional then
    exit;
  Inc(I, Length(FirstDelim));
  J := PosStr(SecondDelim, S, I, SecondDelimAsciiCaseSensitive);
  if J = 0 then
    if not SecondOptional then
      exit
    else
      J := Length(S) + 1;
  Result := CopyRange(S, I, J - 1);
end;

{$IFDEF SupportAnsiString}
function StrBeforeA(const S, D: AnsiString; const Optional: Boolean;
    const AsciiCaseSensitive: Boolean): AnsiString;
var I : Integer;
begin
  I := PosStrA(D, S, 1, AsciiCaseSensitive);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftA(S, I - 1);
end;

function StrBeforeRevA(const S, D: AnsiString; const Optional: Boolean;
    const AsciiCaseSensitive: Boolean): AnsiString;
var I : Integer;
begin
  I := PosStrRevA(D, S, 1, AsciiCaseSensitive);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftA(S, I - 1);
end;

function StrBeforeB(const S, D: RawByteString; const Optional: Boolean;
    const AsciiCaseSensitive: Boolean): RawByteString;
var I : Integer;
begin
  I := PosStrB(D, S, 1, AsciiCaseSensitive);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftB(S, I - 1);
end;

function StrBeforeRevB(const S, D: RawByteString; const Optional: Boolean;
    const AsciiCaseSensitive: Boolean): RawByteString;
var I : Integer;
begin
  I := PosStrRevB(D, S, 1, AsciiCaseSensitive);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftB(S, I - 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrBeforeW(const S, D: WideString; const Optional: Boolean;
    const AsciiCaseSensitive: Boolean): WideString;
var I : Integer;
begin
  I := PosStrW(D, S, 1, AsciiCaseSensitive);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftW(S, I - 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrBeforeRevW(const S, D: WideString; const Optional: Boolean;
    const AsciiCaseSensitive: Boolean): WideString;
var I : Integer;
begin
  I := PosStrRevW(D, S, 1, AsciiCaseSensitive);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftW(S, I - 1);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrBeforeU(const S, D: UnicodeString; const Optional: Boolean;
    const AsciiCaseSensitive: Boolean): UnicodeString;
var I : Integer;
begin
  I := PosStrU(D, S, 1, AsciiCaseSensitive);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftU(S, I - 1);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrBeforeRevU(const S, D: UnicodeString; const Optional: Boolean;
    const AsciiCaseSensitive: Boolean): UnicodeString;
var I : Integer;
begin
  I := PosStrRevU(D, S, 1, AsciiCaseSensitive);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftU(S, I - 1);
end;
{$ENDIF}

function StrBefore(const S, D: String; const Optional: Boolean;
    const AsciiCaseSensitive: Boolean): String;
var I : Integer;
begin
  I := PosStr(D, S, 1, AsciiCaseSensitive);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeft(S, I - 1);
end;

function StrBeforeRev(const S, D: String; const Optional: Boolean;
    const AsciiCaseSensitive: Boolean): String;
var I : Integer;
begin
  I := PosStrRev(D, S, 1, AsciiCaseSensitive);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeft(S, I - 1);
end;

{$IFDEF SupportAnsiString}
function StrBeforeCharA(const S: AnsiString; const D: ByteCharSet;
    const Optional: Boolean): AnsiString;
var I : Integer;
begin
  I := PosCharSetA(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftA(S, I - 1);
end;

function StrBeforeCharA(const S: AnsiString; const D: AnsiChar;
    const Optional: Boolean): AnsiString;
var I : Integer;
begin
  I := PosCharA(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftA(S, I - 1);
end;

function StrBeforeCharRevA(const S: AnsiString; const D: ByteCharSet;
    const Optional: Boolean): AnsiString;
var I : Integer;
begin
  I := PosCharSetRevA(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftA(S, I - 1);
end;

function StrBeforeCharB(const S: RawByteString; const D: ByteCharSet;
    const Optional: Boolean): RawByteString;
var I : Integer;
begin
  I := PosCharSetA(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftB(S, I - 1);
end;

function StrBeforeCharB(const S: RawByteString; const D: AnsiChar;
    const Optional: Boolean): RawByteString;
var I : Integer;
begin
  I := PosCharB(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftB(S, I - 1);
end;

function StrBeforeCharRevB(const S: RawByteString; const D: ByteCharSet;
    const Optional: Boolean): RawByteString;
var I : Integer;
begin
  I := PosCharSetRevB(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftB(S, I - 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrBeforeCharW(const S: WideString; const D: ByteCharSet;
    const Optional: Boolean): WideString;
var I : Integer;
begin
  I := PosCharSetW(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftW(S, I - 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrBeforeCharW(const S: WideString; const D: WideChar;
    const Optional: Boolean): WideString;
var I : Integer;
begin
  I := PosCharW(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftW(S, I - 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrBeforeCharRevW(const S: WideString; const D: ByteCharSet;
    const Optional: Boolean): WideString;
var I : Integer;
begin
  I := PosCharSetRevW(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftW(S, I - 1);
end;
{$ENDIF}

function StrBeforeChar(const S: String; const D: ByteCharSet;
    const Optional: Boolean): String;
var I : Integer;
begin
  I := PosCharSet(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeft(S, I - 1);
end;

function StrBeforeChar(const S: String; const D: Char;
    const Optional: Boolean): String;
var I : Integer;
begin
  I := PosChar(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeft(S, I - 1);
end;

function StrBeforeCharRev(const S: String; const D: ByteCharSet;
    const Optional: Boolean): String;
var I : Integer;
begin
  I := PosCharSetRev(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeft(S, I - 1);
end;

{$IFDEF SupportAnsiString}
function StrAfterA(const S, D: AnsiString; const Optional: Boolean): AnsiString;
var I : Integer;
begin
  I := PosStrA(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyFromA(S, I + Length(D));
end;

function StrAfterRevA(const S, D: AnsiString; const Optional: Boolean): AnsiString;
var I : Integer;
begin
  I := PosStrRevA(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyFromA(S, I + Length(D));
end;

function StrAfterB(const S, D: RawByteString; const Optional: Boolean): RawByteString;
var I : Integer;
begin
  I := PosStrB(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyFromB(S, I + Length(D));
end;

function StrAfterRevB(const S, D: RawByteString; const Optional: Boolean): RawByteString;
var I : Integer;
begin
  I := PosStrRevB(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyFromB(S, I + Length(D));
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrAfterW(const S, D: WideString; const Optional: Boolean): WideString;
var I : Integer;
begin
  I := PosStrW(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyFromW(S, I + Length(D));
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrAfterRevW(const S, D: WideString; const Optional: Boolean): WideString;
var I : Integer;
begin
  I := PosStrRevW(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyFromW(S, I + Length(D));
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrAfterU(const S, D: UnicodeString; const Optional: Boolean): UnicodeString;
var I : Integer;
begin
  I := PosStrU(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyFromU(S, I + Length(D));
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrAfterRevU(const S, D: UnicodeString; const Optional: Boolean): UnicodeString;
var I : Integer;
begin
  I := PosStrRevU(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyFromU(S, I + Length(D));
end;
{$ENDIF}

function StrAfter(const S, D: String; const Optional: Boolean): String;
var I : Integer;
begin
  I := PosStr(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyFrom(S, I + Length(D));
end;

function StrAfterRev(const S, D: String; const Optional: Boolean): String;
var I : Integer;
begin
  I := PosStrRev(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyFrom(S, I + Length(D));
end;

{$IFDEF SupportAnsiString}
function StrAfterCharA(const S: AnsiString; const D: ByteCharSet): AnsiString;
var I : Integer;
begin
  I := PosCharSetA(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromA(S, I + 1);
end;

function StrAfterCharA(const S: AnsiString; const D: AnsiChar): AnsiString;
var I : Integer;
begin
  I := PosCharA(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromA(S, I + 1);
end;

function StrAfterCharB(const S: RawByteString; const D: ByteCharSet): RawByteString;
var I : Integer;
begin
  I := PosCharSetB(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromB(S, I + 1);
end;

function StrAfterCharB(const S: RawByteString; const D: AnsiChar): RawByteString;
var I : Integer;
begin
  I := PosCharB(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromB(S, I + 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrAfterCharW(const S: WideString; const D: ByteCharSet): WideString;
var I : Integer;
begin
  I := PosCharSetW(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromW(S, I + 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrAfterCharW(const S: WideString; const D: WideChar): WideString;
var I : Integer;
begin
  I := PosCharW(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromW(S, I + 1);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrAfterCharU(const S: UnicodeString; const D: ByteCharSet): UnicodeString;
var I : Integer;
begin
  I := PosCharSetU(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromU(S, I + 1);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrAfterCharU(const S: UnicodeString; const D: WideChar): UnicodeString;
var I : Integer;
begin
  I := PosCharU(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromU(S, I + 1);
end;
{$ENDIF}

function StrAfterChar(const S: String; const D: ByteCharSet): String;
var I : Integer;
begin
  I := PosCharSet(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFrom(S, I + 1);
end;

function StrAfterChar(const S: String; const D: Char): String;
var I : Integer;
begin
  I := PosChar(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFrom(S, I + 1);
end;

{$IFDEF SupportAnsiString}
function StrCopyToCharA(const S: AnsiString; const D: ByteCharSet;
    const Optional: Boolean): AnsiString;
var I : Integer;
begin
  I := PosCharSetA(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftA(S, I);
end;

function StrCopyToCharA(const S: AnsiString; const D: AnsiChar;
    const Optional: Boolean): AnsiString;
var I : Integer;
begin
  I := PosCharA(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftA(S, I);
end;

function StrCopyToCharB(const S: RawByteString; const D: ByteCharSet;
    const Optional: Boolean): RawByteString;
var I : Integer;
begin
  I := PosCharSetB(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftB(S, I);
end;

function StrCopyToCharB(const S: RawByteString; const D: AnsiChar;
    const Optional: Boolean): RawByteString;
var I : Integer;
begin
  I := PosCharB(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftB(S, I);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrCopyToCharW(const S: WideString; const D: ByteCharSet;
    const Optional: Boolean): WideString;
var I : Integer;
begin
  I := PosCharSetW(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftW(S, I);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrCopyToCharW(const S: WideString; const D: WideChar;
    const Optional: Boolean): WideString;
var I : Integer;
begin
  I := PosCharW(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeftW(S, I);
end;
{$ENDIF}

function StrCopyToChar(const S: String; const D: ByteCharSet;
    const Optional: Boolean): String;
var I : Integer;
begin
  I := PosCharSet(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeft(S, I);
end;

function StrCopyToChar(const S: String; const D: Char;
    const Optional: Boolean): String;
var I : Integer;
begin
  I := PosChar(D, S);
  if I = 0 then
    if Optional then
      Result := S
    else
      Result := ''
  else
    Result := CopyLeft(S, I);
end;

{$IFDEF SupportAnsiString}
function StrCopyFromCharA(const S: AnsiString; const D: ByteCharSet): AnsiString;
var I : Integer;
begin
  I := PosCharSetA(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromA(S, I);
end;

function StrCopyFromCharA(const S: AnsiString; const D: AnsiChar): AnsiString;
var I : Integer;
begin
  I := PosCharB(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromB(S, I);
end;

function StrCopyFromCharB(const S: RawByteString; const D: ByteCharSet): RawByteString;
var I : Integer;
begin
  I := PosCharSetB(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromB(S, I);
end;

function StrCopyFromCharB(const S: RawByteString; const D: AnsiChar): RawByteString;
var I : Integer;
begin
  I := PosCharA(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromA(S, I);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrCopyFromCharW(const S: WideString; const D: ByteCharSet): WideString;
var I : Integer;
begin
  I := PosCharSetW(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromW(S, I);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrCopyFromCharW(const S: WideString; const D: WideChar): WideString;
var I : Integer;
begin
  I := PosCharW(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromW(S, I);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrCopyFromCharU(const S: UnicodeString; const D: ByteCharSet): UnicodeString;
var I : Integer;
begin
  I := PosCharSetU(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromU(S, I);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrCopyFromCharU(const S: UnicodeString; const D: WideChar): UnicodeString;
var I : Integer;
begin
  I := PosCharU(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFromU(S, I);
end;
{$ENDIF}

function StrCopyFromChar(const S: String; const D: ByteCharSet): String;
var I : Integer;
begin
  I := PosCharSet(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFrom(S, I);
end;

function StrCopyFromChar(const S: String; const D: Char): String;
var I : Integer;
begin
  I := PosChar(D, S);
  if I = 0 then
    Result := ''
  else
    Result := CopyFrom(S, I);
end;

{$IFDEF SupportAnsiString}
function StrRemoveCharDelimitedA(var S: AnsiString;
    const FirstDelim, SecondDelim: AnsiChar): AnsiString;
var I, J : Integer;
begin
  Result := '';
  I := PosCharA(FirstDelim, S);
  if I = 0 then
    exit;
  J := PosCharA(SecondDelim, S, I + 1);
  if J = 0 then
    exit;
  Result := CopyRangeA(S, I + 1, J - 1);
  Delete(S, I, J - I + 1);
end;

function StrRemoveCharDelimitedB(var S: RawByteString;
    const FirstDelim, SecondDelim: AnsiChar): RawByteString;
var I, J : Integer;
begin
  Result := '';
  I := PosCharB(FirstDelim, S);
  if I = 0 then
    exit;
  J := PosCharB(SecondDelim, S, I + 1);
  if J = 0 then
    exit;
  Result := CopyRangeB(S, I + 1, J - 1);
  Delete(S, I, J - I + 1);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrRemoveCharDelimitedW(var S: WideString;
    const FirstDelim, SecondDelim: WideChar): WideString;
var I, J : Integer;
begin
  Result := '';
  I := PosCharW(FirstDelim, S);
  if I = 0 then
    exit;
  J := PosCharW(SecondDelim, S, I + 1);
  if J = 0 then
    exit;
  Result := CopyRangeW(S, I + 1, J - 1);
  Delete(S, I, J - I + 1);
end;
{$ENDIF}

function StrRemoveCharDelimited(var S: String;
    const FirstDelim, SecondDelim: Char): String;
var I, J : Integer;
begin
  Result := '';
  I := PosChar(FirstDelim, S);
  if I = 0 then
    exit;
  J := PosChar(SecondDelim, S, I + 1);
  if J = 0 then
    exit;
  Result := CopyRange(S, I + 1, J - 1);
  Delete(S, I, J - I + 1);
end;



{                                                                              }
{ Count                                                                        }
{                                                                              }
{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function StrCountChar(const S: AnsiString; const C: AnsiChar): Integer;
var I : Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
    if S[I] = C then
      Inc(Result);
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function StrCountCharA(const S: AnsiString; const C: AnsiChar): Integer;
var P : PAnsiChar;
    I : Integer;
begin
  Result := 0;
  P := Pointer(S);
  for I := 1 to Length(S) do
    begin
      if P^ = C then
        Inc(Result);
      Inc(P);
    end;
end;
{$ENDIF}

function StrCountCharB(const S: RawByteString; const C: AnsiChar): Integer;
var P : PByteChar;
    I : Integer;
begin
  Result := 0;
  P := Pointer(S);
  for I := 1 to Length(S) do
    begin
      if P^ = C then
        Inc(Result);
      Inc(P);
    end;
end;

{$IFDEF SupportWideString}
function StrCountCharW(const S: WideString; const C: WideChar): Integer;
var P : PWideChar;
    I : Integer;
begin
  Result := 0;
  P := Pointer(S);
  for I := 1 to Length(S) do
    begin
      if P^ = C then
        Inc(Result);
      Inc(P);
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrCountCharU(const S: UnicodeString; const C: WideChar): Integer;
var P : PWideChar;
    I : Integer;
begin
  Result := 0;
  P := Pointer(S);
  for I := 1 to Length(S) do
    begin
      if P^ = C then
        Inc(Result);
      Inc(P);
    end;
end;
{$ENDIF}

function StrCountChar(const S: String; const C: Char): Integer;
var P : PChar;
    I : Integer;
begin
  Result := 0;
  P := Pointer(S);
  for I := 1 to Length(S) do
    begin
      if P^ = C then
        Inc(Result);
      Inc(P);
    end;
end;
{$ENDIF}

{$IFDEF CLR}
function StrCountChar(const S: AnsiString; const C: CharSet): Integer;
var I : Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
    if S[I] in C then
      Inc(Result);
end;
{$ELSE}
{$IFDEF SupportAnsiString}
function StrCountCharA(const S: AnsiString; const C: ByteCharSet): Integer;
var P : PAnsiChar;
    I : Integer;
begin
  Result := 0;
  P := Pointer(S);
  for I := 1 to Length(S) do
    begin
      if P^ in C then
        Inc(Result);
      Inc(P);
    end;
end;

function StrCountCharB(const S: RawByteString; const C: ByteCharSet): Integer;
var P : PByteChar;
    I : Integer;
begin
  Result := 0;
  P := Pointer(S);
  for I := 1 to Length(S) do
    begin
      if P^ in C then
        Inc(Result);
      Inc(P);
    end;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrCountCharW(const S: WideString; const C: ByteCharSet): Integer;
var P : PWideChar;
    D : WideChar;
    I : Integer;
begin
  Result := 0;
  P := Pointer(S);
  for I := 1 to Length(S) do
    begin
      D := P^;
      if WideCharInCharSet(D, C) then
        Inc(Result);
      Inc(P);
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrCountCharU(const S: UnicodeString; const C: ByteCharSet): Integer;
var P : PWideChar;
    D : WideChar;
    I : Integer;
begin
  Result := 0;
  P := Pointer(S);
  for I := 1 to Length(S) do
    begin
      D := P^;
      if WideCharInCharSet(D, C) then
        Inc(Result);
      Inc(P);
    end;
end;
{$ENDIF}

function StrCountChar(const S: String; const C: ByteCharSet): Integer;
var P : PChar;
    D : Char;
    I : Integer;
begin
  Result := 0;
  P := Pointer(S);
  for I := 1 to Length(S) do
    begin
      D := P^;
      {$IFDEF StringIsUnicode}
      if Ord(D) <= $FF then
      {$ENDIF}
        if AnsiChar(Ord(D)) in C then
          Inc(Result);
      Inc(P);
    end;
end;
{$ENDIF}



{                                                                              }
{ Replace                                                                      }
{                                                                              }
{$IFDEF CLR}
function StrReplaceChar(const Find, Replace: AnsiChar;
    const S: AnsiString): AnsiString;
var I, J : Integer;
begin
  Result := S;
  I := PosCharA(Find, S);
  if I = 0 then
    exit;
  for J := I to Length(S) do
    if S[J] = Find then
      Result[J] := Replace;
end;
{$ELSE}
{$IFDEF SupportAnsiString}
function StrReplaceCharA(const Find, Replace: AnsiChar; const S: AnsiString): AnsiString;
var P, Q : PAnsiChar;
    I, J : Integer;
begin
  Result := S;
  I := PosCharA(Find, S);
  if I = 0 then
    exit;
  UniqueString(Result);
  Q := Pointer(Result);
  Inc(Q, I - 1);
  P := Pointer(S);
  Inc(P, I - 1);
  for J := I to Length(S) do
    begin
      if P^ = Find then
        Q^ := Replace;
      Inc(P);
      Inc(Q);
    end;
end;
{$ENDIF}
{$ENDIF}

function StrReplaceCharB(const Find, Replace: AnsiChar; const S: RawByteString): RawByteString;
var I, J : Integer;
begin
  Result := S;
  I := PosCharB(Find, S);
  if I = 0 then
    exit;
  for J := I to Length(S) do
    if S[J] = Find then
      Result[J] := Replace;
end;

{$IFDEF SupportWideString}
function StrReplaceCharW(const Find, Replace: WideChar; const S: WideString): WideString;
var I, J : Integer;
begin
  Result := S;
  I := PosCharW(Find, S);
  if I = 0 then
    exit;
  for J := I to Length(S) do
    if S[J] = Find then
      Result[J] := Replace;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrReplaceCharU(const Find, Replace: WideChar; const S: UnicodeString): UnicodeString;
var I, J : Integer;
begin
  Result := S;
  I := PosCharU(Find, S);
  if I = 0 then
    exit;
  for J := I to Length(S) do
    if S[J] = Find then
      Result[J] := Replace;
end;
{$ENDIF}

function StrReplaceChar(const Find, Replace: Char; const S: String): String;
var I, J : Integer;
begin
  Result := S;
  I := PosChar(Find, S);
  if I = 0 then
    exit;
  for J := I to Length(S) do
    if S[J] = Find then
      Result[J] := Replace;
end;

{$IFDEF CLR}
function StrReplaceChar(const Find: CharSet; const Replace: AnsiChar;
    const S: AnsiString): AnsiString;
var I, J : Integer;
begin
  Result := S;
  I := PosCharSetA(Find, S);
  if I = 0 then
    exit;
  for J := I to Length(S) do
    if S[J] in Find then
      Result[J] := Replace;
end;
{$ELSE}
{$IFDEF SupportAnsiString}
function StrReplaceCharA(const Find: ByteCharSet; const Replace: AnsiChar;
    const S: AnsiString): AnsiString;
var P, Q : PAnsiChar;
    I, J : Integer;
begin
  Result := S;
  I := PosCharSetA(Find, S);
  if I = 0 then
    exit;
  UniqueString(Result);
  Q := Pointer(Result);
  Inc(Q, I - 1);
  P := Pointer(S);
  Inc(P, I - 1);
  for J := I to Length(S) do
    begin
      if P^ in Find then
        Q^ := Replace;
      Inc(P);
      Inc(Q);
    end;
end;
{$ENDIF}

function StrReplaceCharB(const Find: ByteCharSet; const Replace: AnsiChar;
    const S: RawByteString): RawByteString;
var I, J : Integer;
begin
  Result := S;
  I := PosCharSetB(Find, S);
  if I = 0 then
    exit;
  for J := I to Length(S) do
    if S[J] in Find then
      Result[J] := Replace;
end;

{$IFDEF SupportWideString}
function StrReplaceCharW(const Find: ByteCharSet; const Replace: WideChar;
    const S: WideString): WideString;
var P, Q : PWideChar;
    I, J : Integer;
    C    : WideChar;
begin
  Result := S;
  I := PosCharSetW(Find, S);
  if I = 0 then
    exit;
  {$IFNDEF DELPHI5}
  UniqueString(Result);
  {$ENDIF}
  Q := Pointer(Result);
  Inc(Q, I - 1);
  P := Pointer(S);
  Inc(P, I - 1);
  for J := I to Length(S) do
    begin
      C := P^;
      if Ord(C) <= $FF then
        if AnsiChar(Ord(C)) in Find then
          Q^ := Replace;
      Inc(P);
      Inc(Q);
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrReplaceCharU(const Find: ByteCharSet; const Replace: WideChar;
    const S: UnicodeString): UnicodeString;
var P, Q : PWideChar;
    I, J : Integer;
    C    : WideChar;
begin
  Result := S;
  I := PosCharSetU(Find, S);
  if I = 0 then
    exit;
  {$IFNDEF DELPHI5}
  UniqueString(Result);
  {$ENDIF}
  Q := Pointer(Result);
  Inc(Q, I - 1);
  P := Pointer(S);
  Inc(P, I - 1);
  for J := I to Length(S) do
    begin
      C := P^;
      if Ord(C) <= $FF then
        if AnsiChar(Ord(C)) in Find then
          Q^ := Replace;
      Inc(P);
      Inc(Q);
    end;
end;
{$ENDIF}

function StrReplaceChar(const Find: ByteCharSet; const Replace: Char;
    const S: String): String;
var P, Q : PChar;
    I, J : Integer;
    C    : Char;
begin
  Result := S;
  I := PosCharSet(Find, S);
  if I = 0 then
    exit;
  UniqueString(Result);
  Q := Pointer(Result);
  Inc(Q, I - 1);
  P := Pointer(S);
  Inc(P, I - 1);
  for J := I to Length(S) do
    begin
      C := P^;
      {$IFDEF StringIsUnicode}
      if Ord(C) <= $FF then
      {$ENDIF}
        if AnsiChar(Ord(C)) in Find then
          Q^ := Replace;
      Inc(P);
      Inc(Q);
    end;
end;
{$ENDIF}

{                                                                              }
{ StrReplace operates by replacing in 'batches' of 4096 matches. This has the  }
{ advantage of fewer memory allocations and limited stack usage when there is  }
{ a large number of matches.                                                   }
{                                                                              }
type
  StrReplaceMatchArray = Array[0..4095] of Integer;

{$IFNDEF CLR}
{$IFDEF SupportAnsiString}
function StrReplaceBlockA( // used by StrReplaceA
    const FindLen: Integer; const Replace, S: AnsiString;
    const StartIndex, StopIndex: Integer;
    const MatchCount: Integer;
    const Matches: StrReplaceMatchArray): AnsiString;
var StrLen     : Integer;
    ReplaceLen : Integer;
    NewLen     : Integer;
    I, J, F, G : Integer;
    P, Q       : PAnsiChar;
begin
  ReplaceLen := Length(Replace);
  StrLen := StopIndex - StartIndex + 1;
  NewLen := StrLen + (ReplaceLen - FindLen) * MatchCount;
  if NewLen = 0 then
    begin
      Result := '';
      exit;
    end;
  SetString(Result, nil, NewLen);
  P := Pointer(Result);
  Q := Pointer(S);
  F := StartIndex;
  Inc(Q, F - 1);
  for I := 0 to MatchCount - 1 do
    begin
      G := Matches[I];
      J := G - F;
      if J > 0 then
        begin
          MoveMem(Q^, P^, J);
          Inc(P, J);
          Inc(Q, J);
          Inc(F, J);
        end;
      Inc(Q, FindLen);
      Inc(F, FindLen);
      if ReplaceLen > 0 then
        begin
          MoveMem(Pointer(Replace)^, P^, ReplaceLen);
          Inc(P, ReplaceLen);
        end;
    end;
  if F <= StopIndex then
    MoveMem(Q^, P^, StopIndex - F + 1);
end;
{$ENDIF}

function StrReplaceBlockB( // used by StrReplaceB
    const FindLen: Integer; const Replace, S: RawByteString;
    const StartIndex, StopIndex: Integer;
    const MatchCount: Integer;
    const Matches: StrReplaceMatchArray): RawByteString;
var StrLen     : Integer;
    ReplaceLen : Integer;
    NewLen     : Integer;
    I, J, F, G : Integer;
    P, Q       : PByteChar;
begin
  ReplaceLen := Length(Replace);
  StrLen := StopIndex - StartIndex + 1;
  NewLen := StrLen + (ReplaceLen - FindLen) * MatchCount;
  if NewLen = 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, NewLen); // FPC 3.0 has issue with SetString(Result, nil, NewLen) here
  P := PByteChar(Result);
  Q := PByteChar(S);
  F := StartIndex;
  Inc(Q, F - 1);
  for I := 0 to MatchCount - 1 do
    begin
      G := Matches[I];
      J := G - F;
      if J > 0 then
        begin
          MoveMem(Q^, P^, J);
          Inc(P, J);
          Inc(Q, J);
          Inc(F, J);
        end;
      Inc(Q, FindLen);
      Inc(F, FindLen);
      if ReplaceLen > 0 then
        begin
          MoveMem(PByteChar(Replace)^, P^, ReplaceLen);
          Inc(P, ReplaceLen);
        end;
    end;
  if F <= StopIndex then
    MoveMem(Q^, P^, StopIndex - F + 1);
end;

{$IFDEF SupportWideString}
function StrReplaceBlockW( // used by StrReplaceW
    const FindLen: Integer; const Replace, S: WideString;
    const StartIndex, StopIndex: Integer;
    const MatchCount: Integer;
    const Matches: StrReplaceMatchArray): WideString;
var StrLen     : Integer;
    ReplaceLen : Integer;
    NewLen     : Integer;
    I, J, F, G : Integer;
    P, Q       : PWideChar;
begin
  ReplaceLen := Length(Replace);
  StrLen := StopIndex - StartIndex + 1;
  NewLen := StrLen + (ReplaceLen - FindLen) * MatchCount;
  if NewLen = 0 then
    begin
      Result := '';
      exit;
    end;
  SetString(Result, nil, NewLen);
  P := Pointer(Result);
  Q := Pointer(S);
  F := StartIndex;
  Inc(Q, F - 1);
  for I := 0 to MatchCount - 1 do
    begin
      G := Matches[I];
      J := G - F;
      if J > 0 then
        begin
          MoveMem(Q^, P^, J * SizeOf(WideChar));
          Inc(P, J);
          Inc(Q, J);
          Inc(F, J);
        end;
      Inc(Q, FindLen);
      Inc(F, FindLen);
      if ReplaceLen > 0 then
        begin
          MoveMem(Pointer(Replace)^, P^, ReplaceLen * SizeOf(WideChar));
          Inc(P, ReplaceLen);
        end;
    end;
  if F <= StopIndex then
    MoveMem(Q^, P^, (StopIndex - F + 1) * SizeOf(WideChar));
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrReplaceBlockU( // used by StrReplaceU
    const FindLen: Integer; const Replace, S: UnicodeString;
    const StartIndex, StopIndex: Integer;
    const MatchCount: Integer;
    const Matches: StrReplaceMatchArray): UnicodeString;
var StrLen     : Integer;
    ReplaceLen : Integer;
    NewLen     : Integer;
    I, J, F, G : Integer;
    P, Q       : PWideChar;
begin
  ReplaceLen := Length(Replace);
  StrLen := StopIndex - StartIndex + 1;
  NewLen := StrLen + (ReplaceLen - FindLen) * MatchCount;
  if NewLen = 0 then
    begin
      Result := '';
      exit;
    end;
  SetString(Result, nil, NewLen);
  P := Pointer(Result);
  Q := Pointer(S);
  F := StartIndex;
  Inc(Q, F - 1);
  for I := 0 to MatchCount - 1 do
    begin
      G := Matches[I];
      J := G - F;
      if J > 0 then
        begin
          MoveMem(Q^, P^, J * SizeOf(WideChar));
          Inc(P, J);
          Inc(Q, J);
          Inc(F, J);
        end;
      Inc(Q, FindLen);
      Inc(F, FindLen);
      if ReplaceLen > 0 then
        begin
          MoveMem(Pointer(Replace)^, P^, ReplaceLen * SizeOf(WideChar));
          Inc(P, ReplaceLen);
        end;
    end;
  if F <= StopIndex then
    MoveMem(Q^, P^, (StopIndex - F + 1) * SizeOf(WideChar));
end;
{$ENDIF}

function StrReplaceBlock( // used by StrReplace
    const FindLen: Integer; const Replace, S: String;
    const StartIndex, StopIndex: Integer;
    const MatchCount: Integer;
    const Matches: StrReplaceMatchArray): String;
var StrLen     : Integer;
    ReplaceLen : Integer;
    NewLen     : Integer;
    I, J, F, G : Integer;
    P, Q       : PChar;
begin
  ReplaceLen := Length(Replace);
  StrLen := StopIndex - StartIndex + 1;
  NewLen := StrLen + (ReplaceLen - FindLen) * MatchCount;
  if NewLen = 0 then
    begin
      Result := '';
      exit;
    end;
  SetString(Result, nil, NewLen);
  P := Pointer(Result);
  Q := Pointer(S);
  F := StartIndex;
  Inc(Q, F - 1);
  for I := 0 to MatchCount - 1 do
    begin
      G := Matches[I];
      J := G - F;
      if J > 0 then
        begin
          MoveMem(Q^, P^, J * SizeOf(Char));
          Inc(P, J);
          Inc(Q, J);
          Inc(F, J);
        end;
      Inc(Q, FindLen);
      Inc(F, FindLen);
      if ReplaceLen > 0 then
        begin
          MoveMem(Pointer(Replace)^, P^, ReplaceLen * SizeOf(Char));
          Inc(P, ReplaceLen);
        end;
    end;
  if F <= StopIndex then
    MoveMem(Q^, P^, (StopIndex - F + 1) * SizeOf(Char));
end;
{$ENDIF}

{$IFDEF CLR}
function StrReplaceA(const Find, Replace, S: AnsiString;
    const AsciiCaseSensitive: Boolean): AnsiString;
begin
  Result := Borland.Vcl.StrUtils.AnsiReplaceStr(S, Find, Replace);
end;
{$ELSE}
{$IFDEF SupportAnsiString}
function StrReplaceA(const Find, Replace, S: AnsiString; const AsciiCaseSensitive: Boolean): AnsiString;
var FindLen    : Integer;
    Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  FindLen := Length(Find);
  if FindLen = 0 then // nothing to find
    begin
      Result := S;
      exit;
    end;
  I := PosStrA(Find, S, 1, AsciiCaseSensitive);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I, FindLen);
      I := PosStrA(Find, S, I, AsciiCaseSensitive);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlockA(FindLen, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;
{$ENDIF}

function StrReplaceB(const Find, Replace, S: RawByteString; const AsciiCaseSensitive: Boolean): RawByteString;
var FindLen    : Integer;
    Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  FindLen := Length(Find);
  if FindLen = 0 then // nothing to find
    begin
      Result := S;
      exit;
    end;
  I := PosStrB(Find, S, 1, AsciiCaseSensitive);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I, FindLen);
      I := PosStrB(Find, S, I, AsciiCaseSensitive);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlockB(FindLen, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;

{$IFDEF SupportWideString}
function StrReplaceW(const Find, Replace, S: WideString; const AsciiCaseSensitive: Boolean): WideString;
var FindLen    : Integer;
    Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  FindLen := Length(Find);
  if FindLen = 0 then // nothing to find
    begin
      Result := S;
      exit;
    end;
  I := PosStrW(Find, S, 1, AsciiCaseSensitive);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I, FindLen);
      I := PosStrW(Find, S, I, AsciiCaseSensitive);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlockW(FindLen, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrReplaceU(const Find, Replace, S: UnicodeString; const AsciiCaseSensitive: Boolean): UnicodeString;
var FindLen    : Integer;
    Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  FindLen := Length(Find);
  if FindLen = 0 then // nothing to find
    begin
      Result := S;
      exit;
    end;
  I := PosStrU(Find, S, 1, AsciiCaseSensitive);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I, FindLen);
      I := PosStrU(Find, S, I, AsciiCaseSensitive);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlockU(FindLen, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;
{$ENDIF}

function StrReplace(const Find, Replace, S: String; const AsciiCaseSensitive: Boolean): String;
var FindLen    : Integer;
    Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  FindLen := Length(Find);
  if FindLen = 0 then // nothing to find
    begin
      Result := S;
      exit;
    end;
  I := PosStr(Find, S, 1, AsciiCaseSensitive);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I, FindLen);
      I := PosStr(Find, S, I, AsciiCaseSensitive);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlock(FindLen, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;
{$ENDIF}

{$IFNDEF CLR}
{$IFDEF SupportAnsiString}
function StrReplaceA(const Find: ByteCharSet; const Replace, S: AnsiString): AnsiString;
var Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  I := PosCharSetA(Find, S, 1);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I);
      I := PosCharSetA(Find, S, I);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlockA(1, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;
{$ENDIF}

function StrReplaceB(const Find: ByteCharSet; const Replace, S: RawByteString): RawByteString;
var Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  I := PosCharSetB(Find, S, 1);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I);
      I := PosCharSetB(Find, S, I);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlockB(1, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;

{$IFDEF SupportWideString}
function StrReplaceW(const Find: ByteCharSet; const Replace, S: WideString): WideString;
var Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  I := PosCharSetW(Find, S, 1);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I);
      I := PosCharSetW(Find, S, I);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlockW(1, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrReplaceU(const Find: ByteCharSet; const Replace, S: UnicodeString): UnicodeString;
var Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  I := PosCharSetU(Find, S, 1);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I);
      I := PosCharSetU(Find, S, I);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlockU(1, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;
{$ENDIF}

function StrReplace(const Find: ByteCharSet; const Replace, S: String): String;
var Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  I := PosCharSet(Find, S, 1);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I);
      I := PosCharSet(Find, S, I);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlock(1, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;

{$IFDEF SupportAnsiString}
function StrReplaceCharStrA(const Find: AnsiChar; const Replace, S: AnsiString): AnsiString;
var Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  I := PosCharA(Find, S, 1);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I);
      I := PosCharA(Find, S, I);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlockA(1, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrReplaceCharStrW(const Find: WideChar; const Replace, S: WideString): WideString;
var Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  I := PosCharW(Find, S, 1);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I);
      I := PosCharW(Find, S, I);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlockW(1, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrReplaceCharStrU(const Find: WideChar; const Replace, S: UnicodeString): UnicodeString;
var Matches    : StrReplaceMatchArray;
    C, I, J, K : Integer;
begin
  I := PosCharU(Find, S, 1);
  if I = 0 then // not found
    begin
      Result := S;
      exit;
    end;
  J := 1;
  Result := '';
  repeat
    C := 0;
    repeat
      Matches[C] := I;
      Inc(C);
      Inc(I);
      I := PosCharU(Find, S, I);
    until (I = 0) or (C = 4096);
    if I = 0 then
      K := Length(S)
    else
      K := I - 1;
    Result := Result + StrReplaceBlockU(1, Replace, S, J, K, C, Matches);
    J := K + 1;
  until I = 0;
end;
{$ENDIF}
{$ENDIF}

{$IFDEF CLR}
function StrRemoveDupA(const S: AnsiString; const C: AnsiChar): AnsiString;
begin
  Result := StrReplaceA(DupChar(C, 2), C, S);
end;
{$ELSE}
{$IFDEF SupportAnsiString}
function StrRemoveDupA(const S: AnsiString; const C: AnsiChar): AnsiString;
var P, Q    : PAnsiChar;
    D, E    : AnsiChar;
    I, L, M : Integer;
    R       : Boolean;
begin
  L := Length(S);
  if L <= 1 then
    begin
      Result := S;
      exit;
    end;
  // Check for duplicate
  P := Pointer(S);
  D := P^;
  Inc(P);
  R := False;
  for I := 2 to L do
    if (D = C) and (P^ = C) then
      begin
        R := True;
        break;
      end
    else
      begin
        D := P^;
        Inc(P);
      end;
  if not R then
    begin
      Result := S;
      exit;
    end;
  // Remove duplicates
  Result := S;
  UniqueString(Result);
  P := Pointer(S);
  Q := Pointer(Result);
  D := P^;
  Q^ := D;
  Inc(P);
  Inc(Q);
  M := 1;
  for I := 2 to L do
    begin
      E := P^;
      if (D <> C) or (E <> C) then
        begin
          D := E;
          Q^ := E;
          Inc(M);
          Inc(Q);
        end;
      Inc(P);
    end;
  if M < L then
    SetLength(Result, M);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrRemoveDupW(const S: WideString; const C: WideChar): WideString;
var P, Q    : PWideChar;
    D, E    : WideChar;
    I, L, M : Integer;
    R       : Boolean;
begin
  L := Length(S);
  if L <= 1 then
    begin
      Result := S;
      exit;
    end;
  // Check for duplicate
  P := Pointer(S);
  D := P^;
  Inc(P);
  R := False;
  for I := 2 to L do
    if (D = C) and (P^ = C) then
      begin
        R := True;
        break;
      end
    else
      begin
        D := P^;
        Inc(P);
      end;
  if not R then
    begin
      Result := S;
      exit;
    end;
  // Remove duplicates
  Result := S;
  {$IFNDEF DELPHI5}
  UniqueString(Result);
  {$ENDIF}
  P := Pointer(S);
  Q := Pointer(Result);
  D := P^;
  Q^ := D;
  Inc(P);
  Inc(Q);
  M := 1;
  for I := 2 to L do
    begin
      E := P^;
      if (D <> C) or (E <> C) then
        begin
          D := E;
          Q^ := E;
          Inc(M);
          Inc(Q);
        end;
      Inc(P);
    end;
  if M < L then
    SetLength(Result, M);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrRemoveDupU(const S: UnicodeString; const C: WideChar): UnicodeString;
var P, Q    : PWideChar;
    D, E    : WideChar;
    I, L, M : Integer;
    R       : Boolean;
begin
  L := Length(S);
  if L <= 1 then
    begin
      Result := S;
      exit;
    end;
  // Check for duplicate
  P := Pointer(S);
  D := P^;
  Inc(P);
  R := False;
  for I := 2 to L do
    if (D = C) and (P^ = C) then
      begin
        R := True;
        break;
      end
    else
      begin
        D := P^;
        Inc(P);
      end;
  if not R then
    begin
      Result := S;
      exit;
    end;
  // Remove duplicates
  Result := S;
  {$IFNDEF DELPHI5}
  UniqueString(Result);
  {$ENDIF}
  P := Pointer(S);
  Q := Pointer(Result);
  D := P^;
  Q^ := D;
  Inc(P);
  Inc(Q);
  M := 1;
  for I := 2 to L do
    begin
      E := P^;
      if (D <> C) or (E <> C) then
        begin
          D := E;
          Q^ := E;
          Inc(M);
          Inc(Q);
        end;
      Inc(P);
    end;
  if M < L then
    SetLength(Result, M);
end;
{$ENDIF}

function StrRemoveDup(const S: String; const C: Char): String;
var P, Q    : PChar;
    D, E    : Char;
    I, L, M : Integer;
    R       : Boolean;
begin
  L := Length(S);
  if L <= 1 then
    begin
      Result := S;
      exit;
    end;
  // Check for duplicate
  P := Pointer(S);
  D := P^;
  Inc(P);
  R := False;
  for I := 2 to L do
    if (D = C) and (P^ = C) then
      begin
        R := True;
        break;
      end
    else
      begin
        D := P^;
        Inc(P);
      end;
  if not R then
    begin
      Result := S;
      exit;
    end;
  // Remove duplicates
  Result := S;
  UniqueString(Result);
  P := Pointer(S);
  Q := Pointer(Result);
  D := P^;
  Q^ := D;
  Inc(P);
  Inc(Q);
  M := 1;
  for I := 2 to L do
    begin
      E := P^;
      if (D <> C) or (E <> C) then
        begin
          D := E;
          Q^ := E;
          Inc(M);
          Inc(Q);
        end;
      Inc(P);
    end;
  if M < L then
    SetLength(Result, M);
end;
{$ENDIF}

{$IFDEF CLR}
function StrRemoveChar(const S: AnsiString; const C: AnsiChar): AnsiString;
begin
  Result := StrReplaceA(C, '', S);
end;
{$ELSE}
{$IFDEF SupportAnsiString}
function StrRemoveCharA(const S: AnsiString; const C: AnsiChar): AnsiString;
var P, Q    : PAnsiChar;
    I, L, M : Integer;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := 0;
  P := Pointer(S);
  for I := 1 to L do
    begin
      if P^ = C then
        Inc(M);
      Inc(P);
    end;
  if M = 0 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L - M);
  Q := Pointer(Result);
  P := Pointer(S);
  for I := 1 to L do
    begin
      if P^ <> C then
        begin
          Q^ := P^;
          Inc(Q);
        end;
      Inc(P);
    end;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrRemoveCharW(const S: WideString; const C: WideChar): WideString;
var P, Q    : PWideChar;
    I, L, M : Integer;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := 0;
  P := Pointer(S);
  for I := 1 to L do
    begin
      if P^ = C then
        Inc(M);
      Inc(P);
    end;
  if M = 0 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L - M);
  Q := Pointer(Result);
  P := Pointer(S);
  for I := 1 to L do
    begin
      if P^ <> C then
        begin
          Q^ := P^;
          Inc(Q);
        end;
      Inc(P);
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrRemoveCharU(const S: UnicodeString; const C: WideChar): UnicodeString;
var P, Q    : PWideChar;
    I, L, M : Integer;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := 0;
  P := Pointer(S);
  for I := 1 to L do
    begin
      if P^ = C then
        Inc(M);
      Inc(P);
    end;
  if M = 0 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L - M);
  Q := Pointer(Result);
  P := Pointer(S);
  for I := 1 to L do
    begin
      if P^ <> C then
        begin
          Q^ := P^;
          Inc(Q);
        end;
      Inc(P);
    end;
end;
{$ENDIF}

function StrRemoveChar(const S: String; const C: Char): String;
var P, Q    : PChar;
    I, L, M : Integer;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := 0;
  P := Pointer(S);
  for I := 1 to L do
    begin
      if P^ = C then
        Inc(M);
      Inc(P);
    end;
  if M = 0 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L - M);
  Q := Pointer(Result);
  P := Pointer(S);
  for I := 1 to L do
    begin
      if P^ <> C then
        begin
          Q^ := P^;
          Inc(Q);
        end;
      Inc(P);
    end;
end;

{$IFDEF SupportAnsiString}
function StrRemoveCharSetA(const S: AnsiString; const C: ByteCharSet): AnsiString;
var P, Q    : PAnsiChar;
    I, L, M : Integer;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := 0;
  P := Pointer(S);
  for I := 1 to L do
    begin
      if P^ in C then
        Inc(M);
      Inc(P);
    end;
  if M = 0 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L - M);
  Q := Pointer(Result);
  P := Pointer(S);
  for I := 1 to L do
    begin
      if not (P^ in C) then
        begin
          Q^ := P^;
          Inc(Q);
        end;
      Inc(P);
    end;
end;
{$ENDIF}

function StrRemoveCharSetB(const S: RawByteString; const C: ByteCharSet): RawByteString;
var P, Q    : PByteChar;
    I, L, M : Integer;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := 0;
  P := Pointer(S);
  for I := 1 to L do
    begin
      if P^ in C then
        Inc(M);
      Inc(P);
    end;
  if M = 0 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L - M);
  Q := Pointer(Result);
  P := Pointer(S);
  for I := 1 to L do
    begin
      if not (P^ in C) then
        begin
          Q^ := P^;
          Inc(Q);
        end;
      Inc(P);
    end;
end;

{$IFDEF SupportWideString}
function StrRemoveCharSetW(const S: WideString; const C: ByteCharSet): WideString;
var P, Q    : PWideChar;
    D       : WideChar;
    I, L, M : Integer;
    R       : Boolean;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := 0;
  P := Pointer(S);
  for I := 1 to L do
    begin
      D := P^;
      if Ord(D) <= $FF then
        if AnsiChar(Ord(D)) in C then
          Inc(M);
      Inc(P);
    end;
  if M = 0 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L - M);
  Q := Pointer(Result);
  P := Pointer(S);
  for I := 1 to L do
    begin
      D := P^;
      R := Ord(D) > $FF;
      if not R then
        R := not (AnsiChar(Ord(D)) in C);
      if R then
        begin
          Q^ := P^;
          Inc(Q);
        end;
      Inc(P);
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrRemoveCharSetU(const S: UnicodeString; const C: ByteCharSet): UnicodeString;
var P, Q    : PWideChar;
    D       : WideChar;
    I, L, M : Integer;
    R       : Boolean;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := 0;
  P := Pointer(S);
  for I := 1 to L do
    begin
      D := P^;
      if Ord(D) <= $FF then
        if AnsiChar(Ord(D)) in C then
          Inc(M);
      Inc(P);
    end;
  if M = 0 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L - M);
  Q := Pointer(Result);
  P := Pointer(S);
  for I := 1 to L do
    begin
      D := P^;
      R := Ord(D) > $FF;
      if not R then
        R := not (AnsiChar(Ord(D)) in C);
      if R then
        begin
          Q^ := P^;
          Inc(Q);
        end;
      Inc(P);
    end;
end;
{$ENDIF}

function StrRemoveCharSet(const S: String; const C: ByteCharSet): String;
var P, Q    : PChar;
    D       : Char;
    I, L, M : Integer;
    R       : Boolean;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := 0;
  P := Pointer(S);
  for I := 1 to L do
    begin
      D := P^;
      {$IFDEF StringIsUnicode}
      if Ord(D) <= $FF then
      {$ENDIF}
        if AnsiChar(Ord(D)) in C then
          Inc(M);
      Inc(P);
    end;
  if M = 0 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L - M);
  Q := Pointer(Result);
  P := Pointer(S);
  for I := 1 to L do
    begin
      D := P^;
      {$IFDEF StringIsUnicode}
      R := Ord(D) > $FF;
      if not R then
      {$ENDIF}
        R := not (AnsiChar(Ord(D)) in C);
      if R then
        begin
          Q^ := P^;
          Inc(Q);
        end;
      Inc(P);
    end;
end;
{$ENDIF}



{                                                                              }
{ Split                                                                        }
{                                                                              }
{$IFDEF SupportAnsiString}
function StrSplitAtA(const S: AnsiString; const C: AnsiString;
         var Left, Right: AnsiString; const AsciiCaseSensitive: Boolean;
         const Optional: Boolean): Boolean;
var I : Integer;
    T : AnsiString;
begin
  I := PosStrA(C, S, 1, AsciiCaseSensitive);
  Result := I > 0;
  if Result then
    begin
      T := S;
      Left := Copy(T, 1, I - 1);
      Right := CopyFromA(T, I + Length(C));
    end
  else
    begin
      if Optional then
        Left := S
      else
        Left := '';
      Right := '';
    end;
end;

function StrSplitAtB(const S: RawByteString; const C: RawByteString;
         var Left, Right: RawByteString; const AsciiCaseSensitive: Boolean;
         const Optional: Boolean): Boolean;
var I : Integer;
    T : RawByteString;
begin
  I := PosStrB(C, S, 1, AsciiCaseSensitive);
  Result := I > 0;
  if Result then
    begin
      T := S;
      Left := Copy(T, 1, I - 1);
      Right := CopyFromB(T, I + Length(C));
    end
  else
    begin
      if Optional then
        Left := S
      else
        Left := '';
      Right := '';
    end;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrSplitAtW(const S: WideString; const C: WideString;
         var Left, Right: WideString; const AsciiCaseSensitive: Boolean;
         const Optional: Boolean): Boolean;
var I : Integer;
    T : WideString;
begin
  I := PosStrW(C, S, 1, AsciiCaseSensitive);
  Result := I > 0;
  if Result then
    begin
      T := S;
      Left := Copy(T, 1, I - 1);
      Right := CopyFromW(T, I + Length(C));
    end
  else
    begin
      if Optional then
        Left := S
      else
        Left := '';
      Right := '';
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrSplitAtU(const S: UnicodeString; const C: UnicodeString;
         var Left, Right: UnicodeString; const AsciiCaseSensitive: Boolean;
         const Optional: Boolean): Boolean;
var I : Integer;
    T : UnicodeString;
begin
  I := PosStrU(C, S, 1, AsciiCaseSensitive);
  Result := I > 0;
  if Result then
    begin
      T := S;
      Left := Copy(T, 1, I - 1);
      Right := CopyFromU(T, I + Length(C));
    end
  else
    begin
      if Optional then
        Left := S
      else
        Left := '';
      Right := '';
    end;
end;
{$ENDIF}

function StrSplitAt(const S: String; const C: String;
         var Left, Right: String; const AsciiCaseSensitive: Boolean;
         const Optional: Boolean): Boolean;
var I : Integer;
    T : String;
begin
  I := PosStr(C, S, 1, AsciiCaseSensitive);
  Result := I > 0;
  if Result then
    begin
      T := S;
      Left := Copy(T, 1, I - 1);
      Right := CopyFrom(T, I + Length(C));
    end
  else
    begin
      if Optional then
        Left := S
      else
        Left := '';
      Right := '';
    end;
end;

{$IFDEF SupportAnsiString}
function StrSplitAtCharA(const S: AnsiString; const C: AnsiChar;
         var Left, Right: AnsiString; const Optional: Boolean): Boolean;
var I : Integer;
    T : AnsiString;
begin
  I := PosCharA(C, S);
  Result := I > 0;
  if Result then
    begin
      T := S; // add reference to S (in case it is also Left or Right)
      Left := Copy(T, 1, I - 1);
      Right := CopyFromA(T, I + 1);
    end
  else
    begin
      if Optional then
        Left := S
      else
        Left := '';
      Right := '';
    end;
end;
{$ENDIF}

function StrSplitAtCharB(const S: RawByteString; const C: AnsiChar;
         var Left, Right: RawByteString; const Optional: Boolean): Boolean;
var I : Integer;
    T : RawByteString;
begin
  I := PosCharB(C, S);
  Result := I > 0;
  if Result then
    begin
      T := S; // add reference to S (in case it is also Left or Right)
      Left := Copy(T, 1, I - 1);
      Right := CopyFromB(T, I + 1);
    end
  else
    begin
      if Optional then
        Left := S
      else
        Left := '';
      Right := '';
    end;
end;

{$IFDEF SupportWideString}
function StrSplitAtCharW(const S: WideString; const C: WideChar;
         var Left, Right: WideString; const Optional: Boolean): Boolean;
var I : Integer;
    T : WideString;
begin
  I := PosCharW(C, S);
  Result := I > 0;
  if Result then
    begin
      T := S; // add reference to S (in case it is also Left or Right)
      Left := Copy(T, 1, I - 1);
      Right := CopyFromW(T, I + 1);
    end
  else
    begin
      if Optional then
        Left := S
      else
        Left := '';
      Right := '';
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrSplitAtCharU(const S: UnicodeString; const C: WideChar;
         var Left, Right: UnicodeString; const Optional: Boolean): Boolean;
var I : Integer;
    T : UnicodeString;
begin
  I := PosCharU(C, S);
  Result := I > 0;
  if Result then
    begin
      T := S; // add reference to S (in case it is also Left or Right)
      Left := Copy(T, 1, I - 1);
      Right := CopyFromU(T, I + 1);
    end
  else
    begin
      if Optional then
        Left := S
      else
        Left := '';
      Right := '';
    end;
end;
{$ENDIF}

function StrSplitAtChar(const S: String; const C: Char;
         var Left, Right: String; const Optional: Boolean): Boolean;
var I : Integer;
    T : String;
begin
  I := PosChar(C, S);
  Result := I > 0;
  if Result then
    begin
      T := S; // add reference to S (in case it is also Left or Right)
      Left := Copy(T, 1, I - 1);
      Right := CopyFrom(T, I + 1);
    end
  else
    begin
      if Optional then
        Left := S
      else
        Left := '';
      Right := '';
    end;
end;

{$IFDEF SupportAnsiString}
function StrSplitAtCharSetA(const S: AnsiString; const C: ByteCharSet;
         var Left, Right: AnsiString; const Optional: Boolean): Boolean;
var I : Integer;
    T : AnsiString;
begin
  I := PosCharSetA(C, S);
  Result := I > 0;
  if Result then
    begin
      T := S;
      Left := Copy(T, 1, I - 1);
      Right := CopyFromA(T, I + 1);
    end else
    begin
      if Optional then
        Left := S
      else
        Left := '';
      Right := '';
    end;
end;

function StrSplitA(const S, D: AnsiString): AnsiStringArray;
var I, J, L, M : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  M := Length(D);
  if M = 0 then
    begin
      SetLength(Result, 1);
      Result[0] := S;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosStrA(D, S, I, True);
    if I = 0 then
      break;
    Inc(L);
    Inc(I, M);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosStrA(D, S, I, True);
    if J = 0 then
      begin
        Result[L] := CopyFromA(S, I);
        break;
      end;
    Result[L] := CopyRangeA(S, I, J - 1);
    Inc(L);
    I := J + M;
  until False;
end;
{$ENDIF}

{$IFDEF SupportRawByteString}
function StrSplitB(const S, D: RawByteString): RawByteStringArray;
var I, J, L, M : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  M := Length(D);
  if M = 0 then
    begin
      SetLength(Result, 1);
      Result[0] := S;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosStrB(D, S, I, True);
    if I = 0 then
      break;
    Inc(L);
    Inc(I, M);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosStrB(D, S, I, True);
    if J = 0 then
      begin
        Result[L] := CopyFromB(S, I);
        break;
      end;
    Result[L] := CopyRangeB(S, I, J - 1);
    Inc(L);
    I := J + M;
  until False;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrSplitW(const S, D: WideString): WideStringArray;
var I, J, L, M : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  M := Length(D);
  if M = 0 then
    begin
      SetLength(Result, 1);
      Result[0] := S;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosStrW(D, S, I, True);
    if I = 0 then
      break;
    Inc(L);
    Inc(I, M);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosStrW(D, S, I, True);
    if J = 0 then
      begin
        Result[L] := CopyFromW(S, I);
        break;
      end;
    Result[L] := CopyRangeW(S, I, J - 1);
    Inc(L);
    I := J + M;
  until False;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrSplitU(const S, D: UnicodeString): UnicodeStringArray;
var I, J, L, M : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  M := Length(D);
  if M = 0 then
    begin
      SetLength(Result, 1);
      Result[0] := S;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosStrU(D, S, I, True);
    if I = 0 then
      break;
    Inc(L);
    Inc(I, M);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosStrU(D, S, I, True);
    if J = 0 then
      begin
        Result[L] := CopyFromU(S, I);
        break;
      end;
    Result[L] := CopyRangeU(S, I, J - 1);
    Inc(L);
    I := J + M;
  until False;
end;
{$ENDIF}

function StrSplit(const S, D: String): StringArray;
var I, J, L, M : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  M := Length(D);
  if M = 0 then
    begin
      SetLength(Result, 1);
      Result[0] := S;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosStr(D, S, I, True);
    if I = 0 then
      break;
    Inc(L);
    Inc(I, M);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosStr(D, S, I, True);
    if J = 0 then
      begin
        Result[L] := CopyFrom(S, I);
        break;
      end;
    Result[L] := CopyRange(S, I, J - 1);
    Inc(L);
    I := J + M;
  until False;
end;

{$IFDEF SupportAnsiString}
function StrSplitCharA(const S: AnsiString; const D: AnsiChar): AnsiStringArray;
var I, J, L : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosCharA(D, S, I);
    if I = 0 then
      break;
    Inc(L);
    Inc(I);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosCharA(D, S, I);
    if J = 0 then
      begin
        Result[L] := CopyFromA(S, I);
        break;
      end;
    Result[L] := CopyRangeA(S, I, J - 1);
    Inc(L);
    I := J + 1;
  until False;
end;
{$ENDIF}

{$IFDEF SupportRawByteString}
function StrSplitCharB(const S: RawByteString; const D: AnsiChar): RawByteStringArray;
var I, J, L : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosCharB(D, S, I);
    if I = 0 then
      break;
    Inc(L);
    Inc(I);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosCharB(D, S, I);
    if J = 0 then
      begin
        Result[L] := CopyFromB(S, I);
        break;
      end;
    Result[L] := CopyRangeB(S, I, J - 1);
    Inc(L);
    I := J + 1;
  until False;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrSplitCharW(const S: WideString; const D: WideChar): WideStringArray;
var I, J, L : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosCharW(D, S, I);
    if I = 0 then
      break;
    Inc(L);
    Inc(I);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosCharW(D, S, I);
    if J = 0 then
      begin
        Result[L] := CopyFromW(S, I);
        break;
      end;
    Result[L] := CopyRangeW(S, I, J - 1);
    Inc(L);
    I := J + 1;
  until False;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrSplitCharU(const S: UnicodeString; const D: WideChar): UnicodeStringArray;
var I, J, L : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosCharU(D, S, I);
    if I = 0 then
      break;
    Inc(L);
    Inc(I);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosCharU(D, S, I);
    if J = 0 then
      begin
        Result[L] := CopyFromU(S, I);
        break;
      end;
    Result[L] := CopyRangeU(S, I, J - 1);
    Inc(L);
    I := J + 1;
  until False;
end;
{$ENDIF}

function StrSplitChar(const S: String; const D: Char): StringArray;
var I, J, L : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosChar(D, S, I);
    if I = 0 then
      break;
    Inc(L);
    Inc(I);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosChar(D, S, I);
    if J = 0 then
      begin
        Result[L] := CopyFrom(S, I);
        break;
      end;
    Result[L] := CopyRange(S, I, J - 1);
    Inc(L);
    I := J + 1;
  until False;
end;

{$IFDEF SupportAnsiString}
function StrSplitCharSetA(const S: AnsiString; const D: ByteCharSet): AnsiStringArray;
var I, J, L : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosCharSetA(D, S, I);
    if I = 0 then
      break;
    Inc(L);
    Inc(I);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosCharSetA(D, S, I);
    if J = 0 then
      begin
        Result[L] := CopyFromA(S, I);
        break;
      end;
    Result[L] := CopyRangeA(S, I, J - 1);
    Inc(L);
    I := J + 1;
  until False;
end;
{$ENDIF}

{$IFDEF SupportRawByteString}
function StrSplitCharSetB(const S: RawByteString; const D: ByteCharSet): RawByteStringArray;
var I, J, L : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosCharSetB(D, S, I);
    if I = 0 then
      break;
    Inc(L);
    Inc(I);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosCharSetB(D, S, I);
    if J = 0 then
      begin
        Result[L] := CopyFromB(S, I);
        break;
      end;
    Result[L] := CopyRangeB(S, I, J - 1);
    Inc(L);
    I := J + 1;
  until False;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrSplitCharSetW(const S: WideString; const D: ByteCharSet): WideStringArray;
var I, J, L : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosCharSetW(D, S, I);
    if I = 0 then
      break;
    Inc(L);
    Inc(I);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosCharSetW(D, S, I);
    if J = 0 then
      begin
        Result[L] := CopyFromW(S, I);
        break;
      end;
    Result[L] := CopyRangeW(S, I, J - 1);
    Inc(L);
    I := J + 1;
  until False;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrSplitCharSetU(const S: UnicodeString; const D: ByteCharSet): UnicodeStringArray;
var I, J, L : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosCharSetU(D, S, I);
    if I = 0 then
      break;
    Inc(L);
    Inc(I);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosCharSetU(D, S, I);
    if J = 0 then
      begin
        Result[L] := CopyFromU(S, I);
        break;
      end;
    Result[L] := CopyRangeU(S, I, J - 1);
    Inc(L);
    I := J + 1;
  until False;
end;
{$ENDIF}

function StrSplitCharSet(const S: String; const D: ByteCharSet): StringArray;
var I, J, L : Integer;
begin
  // Check valid parameters
  if S = '' then
    begin
      Result := nil;
      exit;
    end;
  // Count
  L := 0;
  I := 1;
  repeat
    I := PosCharSet(D, S, I);
    if I = 0 then
      break;
    Inc(L);
    Inc(I);
  until False;
  SetLength(Result, L + 1);
  if L = 0 then
    begin
      // No split
      Result[0] := S;
      exit;
    end;
  // Split
  L := 0;
  I := 1;
  repeat
    J := PosCharSet(D, S, I);
    if J = 0 then
      begin
        Result[L] := CopyFrom(S, I);
        break;
      end;
    Result[L] := CopyRange(S, I, J - 1);
    Inc(L);
    I := J + 1;
  until False;
end;

{$IFNDEF CLR}
{$IFDEF SupportAnsiString}
function StrSplitWords(const S: AnsiString; const C: ByteCharSet): AnsiStringArray;
var P, Q : PAnsiChar;
    L, M : Integer;
    N    : Integer;
    T    : AnsiString;
begin
  Result := nil;
  L := Length(S);
  P := Pointer(S);
  Q := P;
  M := 0;
  N := 0;
  while L > 0 do
    if P^ in C then
      begin
        Inc(P);
        Dec(L);
        Inc(M);
      end else
      begin
        if M > 0 then
          begin
            SetLength(T, M);
            MoveMem(Q^, Pointer(T)^, M);
            SetLength(Result, N + 1);
            Result[N] := T;
            Inc(N);
          end;
        M := 0;
        Inc(P);
        Dec(L);
        Q := P;
      end;
  if M > 0 then
    begin
      SetLength(T, M);
      MoveMem(Q^, Pointer(T)^, M);
      SetLength(Result, N + 1);
      Result[N] := T;
    end;
end;
{$ENDIF}
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function StrJoin(const S: array of AnsiString; const D: AnsiString): AnsiString;
var L, I : Integer;
begin
  Result := '';
  L := Length(S);
  if L = 0 then
    exit;
  for I := 0 to L - 1 do
    begin
      Result := Result + S[I];
      if I < L - 1 then
        Result := Result + D;
    end;
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
function StrJoinA(const S: array of AnsiString; const D: AnsiString): AnsiString;
var I, L, M, C : Integer;
    P : PAnsiChar;
    T : AnsiString;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := Length(D);
  SetLength(Result, StringsTotalLengthA(S) + (L - 1) * M);
  P := Pointer(Result);
  for I := 0 to L - 1 do
    begin
      if (I > 0) and (M > 0) then
        begin
          MoveMem(Pointer(D)^, P^, M);
          Inc(P, M);
        end;
      T := S[I];
      C := Length(T);
      if C > 0 then
        begin
          MoveMem(Pointer(T)^, P^, C);
          Inc(P, C);
        end;
    end;
end;
{$ENDIF}

{$IFDEF SupportRawByteString}
function StrJoinB(const S: array of RawByteString; const D: RawByteString): RawByteString;
var I, L, M, C : Integer;
    P : PByteChar;
    T : RawByteString;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := Length(D);
  SetLength(Result, StringsTotalLengthB(S) + (L - 1) * M);
  P := Pointer(Result);
  for I := 0 to L - 1 do
    begin
      if (I > 0) and (M > 0) then
        begin
          MoveMem(Pointer(D)^, P^, M);
          Inc(P, M);
        end;
      T := S[I];
      C := Length(T);
      if C > 0 then
        begin
          MoveMem(Pointer(T)^, P^, C);
          Inc(P, C);
        end;
    end;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrJoinW(const S: array of WideString; const D: WideString): WideString;
var I, L, M, C : Integer;
    P : PWideChar;
    T : WideString;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := Length(D);
  SetLength(Result, StringsTotalLengthW(S) + (L - 1) * M);
  P := Pointer(Result);
  for I := 0 to L - 1 do
    begin
      if (I > 0) and (M > 0) then
        begin
          MoveMem(Pointer(D)^, P^, M * SizeOf(WideChar));
          Inc(P, M);
        end;
      T := S[I];
      C := Length(T);
      if C > 0 then
        begin
          MoveMem(Pointer(T)^, P^, C * SizeOf(WideChar));
          Inc(P, C);
        end;
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrJoinU(const S: array of UnicodeString; const D: UnicodeString): UnicodeString;
var I, L, M, C : Integer;
    P : PWideChar;
    T : UnicodeString;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := Length(D);
  SetLength(Result, StringsTotalLengthU(S) + (L - 1) * M);
  P := Pointer(Result);
  for I := 0 to L - 1 do
    begin
      if (I > 0) and (M > 0) then
        begin
          MoveMem(Pointer(D)^, P^, M * SizeOf(WideChar));
          Inc(P, M);
        end;
      T := S[I];
      C := Length(T);
      if C > 0 then
        begin
          MoveMem(Pointer(T)^, P^, C * SizeOf(WideChar));
          Inc(P, C);
        end;
    end;
end;
{$ENDIF}

function StrJoin(const S: array of String; const D: String): String;
var I, L, M, C : Integer;
    P : PChar;
    T : String;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  M := Length(D);
  SetLength(Result, StringsTotalLength(S) + (L - 1) * M);
  P := Pointer(Result);
  for I := 0 to L - 1 do
    begin
      if (I > 0) and (M > 0) then
        begin
          MoveMem(Pointer(D)^, P^, M * SizeOf(Char));
          Inc(P, M);
        end;
      T := S[I];
      C := Length(T);
      if C > 0 then
        begin
          MoveMem(Pointer(T)^, P^, C * SizeOf(Char));
          Inc(P, C);
        end;
    end;
end;
{$ENDIF}

{$IFDEF CLR}
function StrJoinChar(const S: array of AnsiString; const D: AnsiChar): AnsiString;
var L, I : Integer;
begin
  Result := '';
  L := Length(S);
  if L = 0 then
    exit;
  for I := 0 to L - 1 do
    begin
      Result := Result + S[I];
      if I < L - 1 then
        Result := Result + D;
    end;
end;
{$ELSE}
{$IFDEF SupportAnsiString}
function StrJoinCharA(const S: array of AnsiString; const D: AnsiChar): AnsiString;
var I, L, C : Integer;
    P : PAnsiChar;
    T : AnsiString;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, StringsTotalLengthA(S) + L - 1);
  P := Pointer(Result);
  for I := 0 to L - 1 do
    begin
      if I > 0 then
        begin
          P^ := D;
          Inc(P);
        end;
      T := S[I];
      C := Length(T);
      if C > 0 then
        begin
          MoveMem(Pointer(T)^, P^, C);
          Inc(P, C);
        end;
    end;
end;
{$ENDIF}

{$IFDEF SupportRawByteString}
function StrJoinCharB(const S: array of RawByteString; const D: AnsiChar): RawByteString;
var I, L, C : Integer;
    P : PByteChar;
    T : RawByteString;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, StringsTotalLengthB(S) + L - 1);
  P := Pointer(Result);
  for I := 0 to L - 1 do
    begin
      if I > 0 then
        begin
          P^ := D;
          Inc(P);
        end;
      T := S[I];
      C := Length(T);
      if C > 0 then
        begin
          MoveMem(Pointer(T)^, P^, C);
          Inc(P, C);
        end;
    end;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrJoinCharW(const S: array of WideString; const D: WideChar): WideString;
var I, L, C : Integer;
    P : PWideChar;
    T : WideString;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, StringsTotalLengthW(S) + L - 1);
  P := Pointer(Result);
  for I := 0 to L - 1 do
    begin
      if I > 0 then
        begin
          P^ := D;
          Inc(P);
        end;
      T := S[I];
      C := Length(T);
      if C > 0 then
        begin
          MoveMem(Pointer(T)^, P^, C * SizeOf(WideChar));
          Inc(P, C);
        end;
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrJoinCharU(const S: array of UnicodeString; const D: WideChar): UnicodeString;
var I, L, C : Integer;
    P : PWideChar;
    T : UnicodeString;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, StringsTotalLengthU(S) + L - 1);
  P := Pointer(Result);
  for I := 0 to L - 1 do
    begin
      if I > 0 then
        begin
          P^ := D;
          Inc(P);
        end;
      T := S[I];
      C := Length(T);
      if C > 0 then
        begin
          MoveMem(Pointer(T)^, P^, C * SizeOf(WideChar));
          Inc(P, C);
        end;
    end;
end;
{$ENDIF}

function StrJoinChar(const S: array of String; const D: Char): String;
var I, L, C : Integer;
    P : PChar;
    T : String;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, StringsTotalLength(S) + L - 1);
  P := Pointer(Result);
  for I := 0 to L - 1 do
    begin
      if I > 0 then
        begin
          P^ := D;
          Inc(P);
        end;
      T := S[I];
      C := Length(T);
      if C > 0 then
        begin
          MoveMem(Pointer(T)^, P^, C * SizeOf(Char));
          Inc(P, C);
        end;
    end;
end;
{$ENDIF}



{                                                                              }
{ Quoting                                                                      }
{                                                                              }
{$IFDEF CLR}
{$IFDEF SupportAnsiString}
function StrHasSurroundingQuotes(const S: AnsiString; const Quotes: CharSet): Boolean;
var Q : AnsiChar;
    L : Integer;
begin
  Result := False;
  L := Length(S);
  if L >= 2 then
    begin
      Q := S[1];
      if Q in Quotes then
        if S[L] = Q then
          Result := True;
    end;
end;
{$ENDIF}
{$ElSE}
{$IFDEF SupportAnsiString}
function StrHasSurroundingQuotesA(const S: AnsiString; const Quotes: ByteCharSet): Boolean;
var P : PAnsiChar;
    Q : AnsiChar;
    L : Integer;
begin
  Result := False;
  L := Length(S);
  if L >= 2 then
    begin
      P := Pointer(S);
      Q := P^;
      if Q in Quotes then
        begin
          Inc(P, L - 1);
          if P^ = Q then
            Result := True;
        end;
    end;
end;
{$ENDIF}

function StrHasSurroundingQuotesB(const S: RawByteString; const Quotes: ByteCharSet): Boolean;
var P : PByteChar;
    Q : AnsiChar;
    L : Integer;
begin
  Result := False;
  L := Length(S);
  if L >= 2 then
    begin
      P := Pointer(S);
      Q := P^;
      if Q in Quotes then
        begin
          Inc(P, L - 1);
          if P^ = Q then
            Result := True;
        end;
    end;
end;

{$IFDEF SupportWideString}
function StrHasSurroundingQuotesW(const S: WideString; const Quotes: ByteCharSet): Boolean;
var P : PWideChar;
    Q : WideChar;
    L : Integer;
begin
  Result := False;
  L := Length(S);
  if L >= 2 then
    begin
      P := Pointer(S);
      Q := P^;
      if WideCharInCharSet(Q, Quotes) then
        begin
          Inc(P, L - 1);
          if P^ = Q then
            Result := True;
        end;
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrHasSurroundingQuotesU(const S: UnicodeString; const Quotes: ByteCharSet): Boolean;
var P : PWideChar;
    Q : WideChar;
    L : Integer;
begin
  Result := False;
  L := Length(S);
  if L >= 2 then
    begin
      P := Pointer(S);
      Q := P^;
      if WideCharInCharSet(Q, Quotes) then
        begin
          Inc(P, L - 1);
          if P^ = Q then
            Result := True;
        end;
    end;
end;
{$ENDIF}

function StrHasSurroundingQuotes(const S: String; const Quotes: ByteCharSet): Boolean;
var P : PChar;
    Q : Char;
    L : Integer;
begin
  Result := False;
  L := Length(S);
  if L >= 2 then
    begin
      P := Pointer(S);
      Q := P^;
      {$IFDEF CharIsWide}
      if Ord(Q) <= $FF then
      {$ENDIF}
        if AnsiChar(Byte(Q)) in Quotes then
          begin
            Inc(P, L - 1);
            if P^ = Q then
              Result := True;
          end;
    end;
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
function StrRemoveSurroundingQuotesA(const S: AnsiString; const Quotes: ByteCharSet): AnsiString;
begin
  if StrHasSurroundingQuotesA(S, Quotes) then
    Result := Copy(S, 2, Length(S) - 2)
  else
    Result := S;
end;
{$ENDIF}

function StrRemoveSurroundingQuotesB(const S: RawByteString; const Quotes: ByteCharSet): RawByteString;
begin
  if StrHasSurroundingQuotesB(S, Quotes) then
    Result := Copy(S, 2, Length(S) - 2)
  else
    Result := S;
end;

{$IFDEF SupportWideString}
function StrRemoveSurroundingQuotesW(const S: WideString; const Quotes: ByteCharSet): WideString;
begin
  if StrHasSurroundingQuotesW(S, Quotes) then
    Result := Copy(S, 2, Length(S) - 2)
  else
    Result := S;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrRemoveSurroundingQuotesU(const S: UnicodeString; const Quotes: ByteCharSet): UnicodeString;
begin
  if StrHasSurroundingQuotesU(S, Quotes) then
    Result := Copy(S, 2, Length(S) - 2)
  else
    Result := S;
end;
{$ENDIF}

function StrRemoveSurroundingQuotes(const S: String; const Quotes: ByteCharSet): String;
begin
  if StrHasSurroundingQuotes(S, Quotes) then
    Result := Copy(S, 2, Length(S) - 2)
  else
    Result := S;
end;

{$IFDEF SupportAnsiString}
function StrQuoteA(const S: AnsiString; const Quote: AnsiChar): AnsiString;
begin
  Result := Quote + StrReplaceA(Quote, DupCharA(Quote, 2), S) + Quote;
end;

function StrQuoteB(const S: RawByteString; const Quote: AnsiChar): RawByteString;
begin
  Result := Quote + StrReplaceB(Quote, DupCharB(Quote, 2), S) + Quote;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrQuoteW(const S: WideString; const Quote: WideChar): WideString;
begin
  Result := Quote + StrReplaceW(Quote, DupCharW(Quote, 2), S) + Quote;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrQuoteU(const S: UnicodeString; const Quote: WideChar): UnicodeString;
begin
  Result := Quote + StrReplaceU(Quote, DupCharU(Quote, 2), S) + Quote;
end;
{$ENDIF}

function StrQuote(const S: String; const Quote: Char): String;
begin
  Result := Quote + StrReplace(Quote, DupChar(Quote, 2), S) + Quote;
end;

{$IFDEF SupportAnsiString}
function StrUnquoteA(const S: AnsiString): AnsiString;
var Quote : AnsiChar;
begin
  if not StrHasSurroundingQuotesA(S, csQuotes) then
    begin
      Result := S;
      exit;
    end;
  Quote := S[1];
  Result := StrRemoveSurroundingQuotesA(S, csQuotes);
  Result := StrReplaceA(DupCharA(Quote, 2), Quote, Result);
end;

function StrUnquoteB(const S: RawByteString): RawByteString;
var Quote : AnsiChar;
begin
  if not StrHasSurroundingQuotesB(S, csQuotes) then
    begin
      Result := S;
      exit;
    end;
  Quote := S[1];
  Result := StrRemoveSurroundingQuotesB(S, csQuotes);
  Result := StrReplaceB(DupCharB(Quote, 2), Quote, Result);
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrUnquoteW(const S: WideString): WideString;
var Quote : WideChar;
begin
  if not StrHasSurroundingQuotesW(S, csQuotes) then
    begin
      Result := S;
      exit;
    end;
  Quote := S[1];
  Result := StrRemoveSurroundingQuotesW(S, csQuotes);
  Result := StrReplaceW(DupCharW(Quote, 2), Quote, Result);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrUnquoteU(const S: UnicodeString): UnicodeString;
var Quote : WideChar;
begin
  if not StrHasSurroundingQuotesU(S, csQuotes) then
    begin
      Result := S;
      exit;
    end;
  Quote := S[1];
  Result := StrRemoveSurroundingQuotesU(S, csQuotes);
  Result := StrReplaceU(DupCharU(Quote, 2), Quote, Result);
end;
{$ENDIF}

function StrUnquote(const S: String): String;
var Quote : Char;
begin
  if not StrHasSurroundingQuotes(S, csQuotes) then
    begin
      Result := S;
      exit;
    end;
  Quote := S[1];
  Result := StrRemoveSurroundingQuotes(S, csQuotes);
  Result := StrReplace(DupChar(Quote, 2), Quote, Result);
end;

{$IFDEF SupportAnsiString}
function StrMatchQuotedStrA(const S: AnsiString; const ValidQuotes: ByteCharSet;
    const Index: Integer): Integer;
var Quote : AnsiChar;
    I, L  : Integer;
    R     : Boolean;
begin
  L := Length(S);
  if (Index < 1) or (L < Index + 1) or not (S[Index] in ValidQuotes) then
    begin
      Result := 0;
      exit;
    end;
  Quote := S[Index];
  I := Index + 1;
  R := False;
  repeat
    I := PosCharA(Quote, S, I);
    if I = 0 then // no closing quote
      begin
        Result := 0;
        exit;
      end else
      if I = L then // closing quote is last character
        R := True else
        if S[I + 1] <> Quote then // not double quoted
          R := True
        else
          Inc(I, 2);
  until R;
  Result := I - Index + 1;
end;

function StrIsQuotedStrA(const S: AnsiString; const ValidQuotes: ByteCharSet): Boolean;
var L : Integer;
begin
  L := Length(S);
  if (L < 2) or (S[1] <> S[L]) or not (S[1] in ValidQuotes) then
    Result := False
  else
    Result := StrMatchQuotedStrA(S, ValidQuotes) = L;
end;

function StrFindClosingQuoteA(const S: AnsiString; const OpenQuotePos: Integer): Integer;
var I : Integer;
    OpenQuote : AnsiChar;
    R : Boolean;
begin
  if (OpenQuotePos <= 0) or (OpenQuotePos > Length(S)) then
    begin
      Result := 0;
      exit;
    end;
  I := OpenQuotePos;
  OpenQuote := S[I];
  repeat
    I := PosCharA(OpenQuote, S, I + 1);
    if I = 0 then
      begin
        Result := 0;
        exit;
      end;
    R := (I = Length(S)) or (S[I + 1] <> OpenQuote);
    if not R then
      Inc(I);
  until R;
  Result := I;
end;
{$ENDIF}



{                                                                              }
{ Bracketing                                                                   }
{                                                                              }
{$IFDEF SupportAnsiString}
function StrFindClosingBracketA(const S: AnsiString;
    const OpenBracketPos: Integer; const CloseBracket: AnsiChar): Integer;
var OpenBracket : AnsiChar;
    Brackets    : ByteCharSet;
    I, C        : Integer;
begin
  Result := 0;
  I := OpenBracketPos;
  if (I <= 0) or (I > Length(S)) then
    exit;
  OpenBracket := S[OpenBracketPos];
  Brackets := [OpenBracket, CloseBracket];
  C := 1;
  repeat
    I := PosCharSetA(Brackets, S, I + 1);
    if I = 0 then
      exit;
    if S[I] = OpenBracket then
      Inc(C)
    else
      Dec(C);
  until C = 0;
  Result := I;
end;
{$ENDIF}



{                                                                              }
{ Escaping                                                                     }
{                                                                              }
function StrHexEscapeB(const S: RawByteString; const C: ByteCharSet;
    const EscPrefix: RawByteString; const EscSuffix: RawByteString;
    const UpperHex: Boolean; const TwoDigitHex: Boolean): RawByteString;
var I, J   : Integer;
    HexStr : RawByteString;
begin
  Result := '';
  J := 1;
  I := PosCharSetB(C, S);
  while I > 0 do
    begin
      if TwoDigitHex then
        HexStr := Word32ToHexB(Ord(S[I]), 2)
      else
        HexStr := Word32ToHexB(Ord(S[I]), 1);
      if UpperHex then
        AsciiConvertUpperB(HexStr)
      else
        AsciiConvertLowerB(HexStr);
      Result := Result + CopyRangeB(S, J, I - 1) +
                EscPrefix + HexStr + EscSuffix;
      J := I + 1;
      I := PosCharSetB(C, S, J);
    end;
  if J = 1 then
    Result := S
  else
    Result := Result + CopyFromB(S, J);
end;

function StrHexUnescapeB(const S: RawByteString; const EscPrefix: RawByteString;
    const AsciiCaseSensitive: Boolean): RawByteString;
var I, J, L, M : Integer;
    V : Byte;
    R : RawByteString;
    H1, H2 : AnsiChar;
    H2Ch : Boolean;
begin
  R := '';
  L := Length(S);
  if L = 0 then
    exit;
  M := Length(EscPrefix);
  if M = 0 then
    exit;
  // Replace
  J := 1;
  repeat
    I := PosStrB(EscPrefix, S, J, AsciiCaseSensitive);
    if I > 0 then
      begin
        R := R + CopyRangeB(S, J, I - 1);
        Inc(I, M);
        if I <= L then
          begin
            H1 := S[I];
            if IsHexAnsiChar(H1) then
              begin
                H2Ch := False;
                if I < L then
                  begin
                    H2 := S[I + 1];
                    if IsHexAnsiChar(H2) then
                      begin
                        V := HexAnsiCharToInt(H1) * 16 + HexAnsiCharToInt(H2);
                        R := R + AnsiChar(V);
                        Inc(I, 2);
                        H2Ch := True;
                      end;
                  end;
                if not H2Ch then
                  begin
                    V := HexAnsiCharToInt(H1);
                    R := R + AnsiChar(V);
                    Inc(I);
                  end;
              end;
          end;
        J := I;
      end;
  until I = 0;
  if (I = 0) and (J = 0) then
    Result := S
  else
    Result := R + CopyFromB(S, J);
end;

{$IFDEF SupportAnsiString}
function StrCharEscapeA(const S: AnsiString; const C: array of AnsiChar;
    const EscPrefix: AnsiString; const EscSeq: array of AnsiString): AnsiString;
var I, J, L : Integer;
    F       : ByteCharSet;
    T       : AnsiChar;
    Lookup  : Array[AnsiChar] of Integer;
begin
  L := Length(C);
  if L = 0 then
    begin
      Result := S;
      exit;
    end;
  if L <> Length(EscSeq) then
    raise EStrInvalidArgument.Create('Invalid arguments');
  // Initialize lookup
  {$IFDEF CLR}
  for T := #0 to #255 do
    Lookup[T] := 0;
  {$ELSE}
  ZeroMem(Lookup, Sizeof(Lookup));
  {$ENDIF}
  F := [];
  for I := 0 to Length(C) - 1 do
    begin
      T := C[I];
      Include(F, T);
      Lookup[T] := I;
    end;
  // Replace
  Result := '';
  J := 1;
  I := PosCharSetA(F, S);
  while I > 0 do
    begin
      Result := Result + CopyRangeA(S, J, I - 1) +
                EscPrefix + EscSeq[Lookup[S[I]]];
      J := I + 1;
      I := PosCharSetA(F, S, J);
    end;
  if J = 1 then
    Result := S
  else
    Result := Result + CopyFromA(S, J);
end;

function StrCharUnescapeA(const S: AnsiString; const EscPrefix: AnsiString;
    const C: array of AnsiChar; const Replace: array of AnsiString;
    const PrefixAsciiCaseSensitive: Boolean;
    const AlwaysDropPrefix: Boolean): AnsiString;
var I, J, L : Integer;
    F, G, M : Integer;
    D       : AnsiChar;
begin
  if High(C) <> High(Replace) then
    raise EStrInvalidArgument.Create('Invalid arguments');
  L := Length(EscPrefix);
  M := Length(S);
  if (L = 0) or (M <= L) then
    begin
      Result := S;
      exit;
    end;
  // Replace
  Result := '';
  J := 1;
  repeat
    I := PosStrA(EscPrefix, S, J, PrefixAsciiCaseSensitive);
    if I > 0 then
      begin
        G := -1;
        if I < Length(S) then
          begin
            D := S[I + L];
            for F := 0 to High(C) do
              if C[F] = D then
                begin
                  G := F;
                  break;
                end;
          end;
        Result := Result + CopyRangeA(S, J, I - 1);
        if G >= 0 then
          Result := Result + Replace[G] else
          if not AlwaysDropPrefix then
            Result := Result + EscPrefix;
        J := I + L + 1;
      end;
  until I = 0;
  if (I = 0) and (J = 0) then
    Result := S
  else
    Result := Result + CopyFromA(S, J);
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrCharUnescapeU(const S: UnicodeString; const EscPrefix: UnicodeString;
    const C: array of WideChar; const Replace: array of UnicodeString;
    const PrefixAsciiCaseSensitive: Boolean;
    const AlwaysDropPrefix: Boolean): UnicodeString;
var I, J, L : Integer;
    F, G, M : Integer;
    D       : WideChar;
begin
  if High(C) <> High(Replace) then
    raise EStrInvalidArgument.Create('Invalid arguments');
  L := Length(EscPrefix);
  M := Length(S);
  if (L = 0) or (M <= L) then
    begin
      Result := S;
      exit;
    end;
  // Replace
  Result := '';
  J := 1;
  repeat
    I := PosStrU(EscPrefix, S, J, PrefixAsciiCaseSensitive);
    if I > 0 then
      begin
        G := -1;
        if I < Length(S) then
          begin
            D := S[I + L];
            for F := 0 to High(C) do
              if C[F] = D then
                begin
                  G := F;
                  break;
                end;
          end;
        Result := Result + CopyRangeU(S, J, I - 1);
        if G >= 0 then
          Result := Result + Replace[G] else
          if not AlwaysDropPrefix then
            Result := Result + EscPrefix;
        J := I + L + 1;
      end;
  until I = 0;
  if (I = 0) and (J = 0) then
    Result := S
  else
    Result := Result + CopyFromU(S, J);
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
function StrCStyleEscapeA(const S: AnsiString): AnsiString;
begin
  Result := StrCharEscapeA(S,
      [AsciiCR, AsciiLF, AsciiNULL, AsciiBEL, AsciiBS, AsciiESC, AsciiHT,
       AsciiFF, AsciiVT, '\'], '\',
      ['n',     'l',     '0',       'a',      'b',     'e',      't',
       'f',     'v',     '\']);
end;

function StrCStyleUnescapeA(const S: AnsiString): AnsiString;
begin
  Result := StrCharUnescapeA(S, '\',
      ['n',     'l',     '0',       'a',      'b',     'e',      't',
       'f',     'v',     '\',     '''',      '"',      '?'],
      [AsciiCR, AsciiLF, AsciiNULL, AsciiBEL, AsciiBS, AsciiESC, AsciiHT,
       AsciiFF, AsciiVT, '\',     '''',      '"',      '?'], True, False);
  Result := StrHexUnescapeB(Result, '\x', True);
end;
{$ENDIF}



{                                                                              }
{ Prefix and Suffix                                                            }
{                                                                              }
{$IFDEF SupportAnsiString}
function StrInclPrefixA(const S: AnsiString; const Prefix: AnsiString;
  const AsciiCaseSensitive: Boolean): AnsiString;
begin
  if not StrMatchLeftA(S, Prefix, AsciiCaseSensitive) then
    Result := Prefix + S
  else
    Result := S;
end;
{$ENDIF}

function StrInclPrefixB(const S: RawByteString; const Prefix: RawByteString;
  const AsciiCaseSensitive: Boolean): RawByteString;
begin
  if not StrMatchLeftB(S, Prefix, AsciiCaseSensitive) then
    Result := Prefix + S
  else
    Result := S;
end;

{$IFDEF SupportWideString}
function StrInclPrefixW(const S: WideString; const Prefix: WideString;
  const AsciiCaseSensitive: Boolean): WideString;
begin
  if not StrMatchLeftW(S, Prefix, AsciiCaseSensitive) then
    Result := Prefix + S
  else
    Result := S;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrInclPrefixU(const S: UnicodeString; const Prefix: UnicodeString;
  const AsciiCaseSensitive: Boolean): UnicodeString;
begin
  if not StrMatchLeftU(S, Prefix, AsciiCaseSensitive) then
    Result := Prefix + S
  else
    Result := S;
end;
{$ENDIF}

function StrInclPrefix(const S: String; const Prefix: String;
  const AsciiCaseSensitive: Boolean): String;
begin
  if not StrMatchLeft(S, Prefix, AsciiCaseSensitive) then
    Result := Prefix + S
  else
    Result := S;
end;

{$IFDEF SupportAnsiString}
function StrInclSuffixA(const S: AnsiString; const Suffix: AnsiString;
  const AsciiCaseSensitive: Boolean): AnsiString;
begin
  if not StrMatchRightA(S, Suffix, AsciiCaseSensitive) then
    Result := S + Suffix
  else
    Result := S;
end;
{$ENDIF}

function StrInclSuffixB(const S: RawByteString; const Suffix: RawByteString;
  const AsciiCaseSensitive: Boolean): RawByteString;
begin
  if not StrMatchRightB(S, Suffix, AsciiCaseSensitive) then
    Result := S + Suffix
  else
    Result := S;
end;

{$IFDEF SupportWideString}
function StrInclSuffixW(const S: WideString; const Suffix: WideString;
  const AsciiCaseSensitive: Boolean): WideString;
begin
  if not StrMatchRightW(S, Suffix, AsciiCaseSensitive) then
    Result := S + Suffix
  else
    Result := S;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrInclSuffixU(const S: UnicodeString; const Suffix: UnicodeString;
  const AsciiCaseSensitive: Boolean): UnicodeString;
begin
  if not StrMatchRightU(S, Suffix, AsciiCaseSensitive) then
    Result := S + Suffix
  else
    Result := S;
end;
{$ENDIF}

function StrInclSuffix(const S: String; const Suffix: String;
  const AsciiCaseSensitive: Boolean): String;
begin
  if not StrMatchRight(S, Suffix, AsciiCaseSensitive) then
    Result := S + Suffix
  else
    Result := S;
end;

{$IFDEF SupportAnsiString}
function StrExclPrefixA(const S: AnsiString; const Prefix: AnsiString;
  const AsciiCaseSensitive: Boolean): AnsiString;
begin
  if StrMatchLeftA(S, Prefix, AsciiCaseSensitive) then
    Result := CopyFromA(S, Length(Prefix) + 1)
  else
    Result := S;
end;

function StrExclPrefixB(const S: RawByteString; const Prefix: RawByteString;
  const AsciiCaseSensitive: Boolean): RawByteString;
begin
  if StrMatchLeftB(S, Prefix, AsciiCaseSensitive) then
    Result := CopyFromB(S, Length(Prefix) + 1)
  else
    Result := S;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrExclPrefixW(const S: WideString; const Prefix: WideString;
  const AsciiCaseSensitive: Boolean): WideString;
begin
  if StrMatchLeftW(S, Prefix, AsciiCaseSensitive) then
    Result := CopyFromW(S, Length(Prefix) + 1)
  else
    Result := S;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrExclPrefixU(const S: UnicodeString; const Prefix: UnicodeString;
  const AsciiCaseSensitive: Boolean): UnicodeString;
begin
  if StrMatchLeftU(S, Prefix, AsciiCaseSensitive) then
    Result := CopyFromU(S, Length(Prefix) + 1)
  else
    Result := S;
end;
{$ENDIF}

function StrExclPrefix(const S: String; const Prefix: String;
  const AsciiCaseSensitive: Boolean): String;
begin
  if StrMatchLeft(S, Prefix, AsciiCaseSensitive) then
    Result := CopyFrom(S, Length(Prefix) + 1)
  else
    Result := S;
end;

{$IFDEF SupportAnsiString}
function StrExclSuffixA(const S: AnsiString; const Suffix: AnsiString;
  const AsciiCaseSensitive: Boolean): AnsiString;
begin
  if StrMatchRightA(S, Suffix, AsciiCaseSensitive) then
    Result := Copy(S, 1, Length(S) - Length(Suffix))
  else
    Result := S;
end;
{$ENDIF}

function StrExclSuffixB(const S: RawByteString; const Suffix: RawByteString;
  const AsciiCaseSensitive: Boolean): RawByteString;
begin
  if StrMatchRightB(S, Suffix, AsciiCaseSensitive) then
    Result := Copy(S, 1, Length(S) - Length(Suffix))
  else
    Result := S;
end;

{$IFDEF SupportWideString}
function StrExclSuffixW(const S: WideString; const Suffix: WideString;
  const AsciiCaseSensitive: Boolean): WideString;
begin
  if StrMatchRightW(S, Suffix, AsciiCaseSensitive) then
    Result := Copy(S, 1, Length(S) - Length(Suffix))
  else
    Result := S;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrExclSuffixU(const S: UnicodeString; const Suffix: UnicodeString;
  const AsciiCaseSensitive: Boolean): UnicodeString;
begin
  if StrMatchRightU(S, Suffix, AsciiCaseSensitive) then
    Result := Copy(S, 1, Length(S) - Length(Suffix))
  else
    Result := S;
end;
{$ENDIF}

function StrExclSuffix(const S: String; const Suffix: String;
  const AsciiCaseSensitive: Boolean): String;
begin
  if StrMatchRight(S, Suffix, AsciiCaseSensitive) then
    Result := Copy(S, 1, Length(S) - Length(Suffix))
  else
    Result := S;
end;

{$IFDEF CLR}
procedure StrEnsurePrefixA(var S: AnsiString; const Prefix: AnsiString;
  const AsciiCaseSensitive: Boolean);
begin
  if (Prefix <> '') and not StrMatchLeftA(S, Prefix, AsciiCaseSensitive) then
    S := Prefix + S;
end;
{$ELSE}
{$IFDEF SupportAnsiString}
procedure StrEnsurePrefixA(var S: AnsiString; const Prefix: AnsiString;
  const AsciiCaseSensitive: Boolean);
var L, M : Integer;
    P : PAnsiChar;
begin
  if (Prefix <> '') and not StrMatchLeftA(S, Prefix, AsciiCaseSensitive) then
    begin
      L := Length(S);
      M := Length(Prefix);
      SetLength(S, L + M);
      if L > 0 then
        begin
          P := Pointer(S);
          Inc(P, M);
          MoveMem(Pointer(S)^, P^, L);
        end;
      MoveMem(Pointer(Prefix)^, Pointer(S)^, M);
    end;
end;

procedure StrEnsurePrefixB(var S: RawByteString; const Prefix: RawByteString;
  const AsciiCaseSensitive: Boolean);
begin
  if (Prefix <> '') and not StrMatchLeftB(S, Prefix, AsciiCaseSensitive) then
    S := Prefix + S;
end;
{$ENDIF}

{$IFDEF SupportWideString}
procedure StrEnsurePrefixW(var S: WideString; const Prefix: WideString;
  const AsciiCaseSensitive: Boolean);
begin
  if (Prefix <> '') and not StrMatchLeftW(S, Prefix, AsciiCaseSensitive) then
    S := Prefix + S;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
procedure StrEnsurePrefixU(var S: UnicodeString; const Prefix: UnicodeString;
  const AsciiCaseSensitive: Boolean);
begin
  if (Prefix <> '') and not StrMatchLeftU(S, Prefix, AsciiCaseSensitive) then
    S := Prefix + S;
end;
{$ENDIF}

procedure StrEnsurePrefix(var S: String; const Prefix: String;
  const AsciiCaseSensitive: Boolean);
begin
  if (Prefix <> '') and not StrMatchLeft(S, Prefix, AsciiCaseSensitive) then
    S := Prefix + S;
end;
{$ENDIF}

{$IFDEF CLR}
procedure StrEnsureSuffixA(var S: AnsiString; const Suffix: AnsiString;
  const AsciiCaseSensitive: Boolean);
begin
  if (Suffix <> '') and not StrMatchRightA(S, Suffix, AsciiCaseSensitive) then
    S := S + Suffix;
end;
{$ELSE}
{$IFDEF SupportAnsiString}
procedure StrEnsureSuffixA(var S: AnsiString; const Suffix: AnsiString;
  const AsciiCaseSensitive: Boolean);
var L, M : Integer;
    P : PAnsiChar;
begin
  if (Suffix <> '') and not StrMatchRightA(S, Suffix, AsciiCaseSensitive) then
    begin
      L := Length(S);
      M := Length(Suffix);
      SetLength(S, L + M);
      P := Pointer(S);
      Inc(P, L);
      MoveMem(Pointer(Suffix)^, P^, M);
    end;
end;

procedure StrEnsureSuffixB(var S: RawByteString; const Suffix: RawByteString;
  const AsciiCaseSensitive: Boolean);
begin
  if (Suffix <> '') and not StrMatchRightB(S, Suffix, AsciiCaseSensitive) then
    S := S + Suffix;
end;
{$ENDIF}

{$IFDEF SupportWideString}
procedure StrEnsureSuffixW(var S: WideString; const Suffix: WideString;
  const AsciiCaseSensitive: Boolean);
begin
  if (Suffix <> '') and not StrMatchRightW(S, Suffix, AsciiCaseSensitive) then
    S := S + Suffix;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
procedure StrEnsureSuffixU(var S: UnicodeString; const Suffix: UnicodeString;
  const AsciiCaseSensitive: Boolean);
begin
  if (Suffix <> '') and not StrMatchRightU(S, Suffix, AsciiCaseSensitive) then
    S := S + Suffix;
end;
{$ENDIF}

procedure StrEnsureSuffix(var S: String; const Suffix: String;
  const AsciiCaseSensitive: Boolean);
begin
  if (Suffix <> '') and not StrMatchRight(S, Suffix, AsciiCaseSensitive) then
    S := S + Suffix;
end;
{$ENDIF}

{$IFDEF CLR}
{$IFDEF SupportAnsiString}
procedure StrEnsureNoPrefixA(var S: AnsiString; const Prefix: AnsiString;
  const AsciiCaseSensitive: Boolean);
begin
  if StrMatchLeftA(S, Prefix, AsciiCaseSensitive) then
    Delete(S, 1, Length(Prefix));
end;
{$ENDIF}
{$ELSE}
{$IFDEF SupportAnsiString}
procedure StrEnsureNoPrefixA(var S: AnsiString; const Prefix: AnsiString;
  const AsciiCaseSensitive: Boolean);
var L, M : Integer;
    P : PAnsiChar;
begin
  if StrMatchLeftA(S, Prefix, AsciiCaseSensitive) then
    begin
      L := Length(S);
      M := Length(Prefix);
      P := Pointer(S);
      Inc(P, M);
      MoveMem(P^, Pointer(S)^, L - M);
      SetLength(S, L - M);
    end;
end;
{$ENDIF}

procedure StrEnsureNoPrefixB(var S: RawByteString; const Prefix: RawByteString;
  const AsciiCaseSensitive: Boolean);
begin
  if StrMatchLeftB(S, Prefix, AsciiCaseSensitive) then
    Delete(S, 1, Length(Prefix));
end;

{$IFDEF SupportWideString}
procedure StrEnsureNoPrefixW(var S: WideString; const Prefix: WideString;
  const AsciiCaseSensitive: Boolean);
begin
  if StrMatchLeftW(S, Prefix, AsciiCaseSensitive) then
    Delete(S, 1, Length(Prefix));
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
procedure StrEnsureNoPrefixU(var S: UnicodeString; const Prefix: UnicodeString;
  const AsciiCaseSensitive: Boolean);
begin
  if StrMatchLeftU(S, Prefix, AsciiCaseSensitive) then
    Delete(S, 1, Length(Prefix));
end;
{$ENDIF}

procedure StrEnsureNoPrefix(var S: String; const Prefix: String;
  const AsciiCaseSensitive: Boolean);
begin
  if StrMatchLeft(S, Prefix, AsciiCaseSensitive) then
    Delete(S, 1, Length(Prefix));
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
procedure StrEnsureNoSuffixA(var S: AnsiString; const Suffix: AnsiString;
  const AsciiCaseSensitive: Boolean);
begin
  if StrMatchRightA(S, Suffix, AsciiCaseSensitive) then
    SetLength(S, Length(S) - Length(Suffix));
end;
{$ENDIF}

procedure StrEnsureNoSuffixB(var S: RawByteString; const Suffix: RawByteString;
  const AsciiCaseSensitive: Boolean);
begin
  if StrMatchRightB(S, Suffix, AsciiCaseSensitive) then
    SetLength(S, Length(S) - Length(Suffix));
end;

{$IFDEF SupportWideString}
procedure StrEnsureNoSuffixW(var S: WideString; const Suffix: WideString;
  const AsciiCaseSensitive: Boolean);
begin
  if StrMatchRightW(S, Suffix, AsciiCaseSensitive) then
    SetLength(S, Length(S) - Length(Suffix));
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
procedure StrEnsureNoSuffixU(var S: UnicodeString; const Suffix: UnicodeString;
  const AsciiCaseSensitive: Boolean);
begin
  if StrMatchRightU(S, Suffix, AsciiCaseSensitive) then
    SetLength(S, Length(S) - Length(Suffix));
end;
{$ENDIF}

procedure StrEnsureNoSuffix(var S: String; const Suffix: String;
  const AsciiCaseSensitive: Boolean);
begin
  if StrMatchRight(S, Suffix, AsciiCaseSensitive) then
    SetLength(S, Length(S) - Length(Suffix));
end;



{                                                                              }
{ Reverse                                                                      }
{                                                                              }
{$IFDEF CLR}
function StrReverse(const S: AnsiString): AnsiString;
var I, L : Integer;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  if L = 1 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L);
  for I := 1 to L do
    Result[I] := S[L - I + 1];
end;
{$ELSE}
{$IFDEF SupportAnsiString}
function StrReverseA(const S: AnsiString): AnsiString;
var I, L : Integer;
    P, Q : PAnsiChar;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  if L = 1 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L);
  P := Pointer(S);
  Q := Pointer(Result);
  Inc(Q, L - 1);
  for I := 1 to L do
    begin
      Q^ := P^;
      Dec(Q);
      Inc(P);
    end;
end;

function StrReverseB(const S: RawByteString): RawByteString;
var I, L : Integer;
    P, Q : PByteChar;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  if L = 1 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L);
  P := Pointer(S);
  Q := Pointer(Result);
  Inc(Q, L - 1);
  for I := 1 to L do
    begin
      Q^ := P^;
      Dec(Q);
      Inc(P);
    end;
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrReverseW(const S: WideString): WideString;
var I, L : Integer;
    P, Q : PWideChar;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  if L = 1 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L);
  P := Pointer(S);
  Q := Pointer(Result);
  Inc(Q, L - 1);
  for I := 1 to L do
    begin
      Q^ := P^;
      Dec(Q);
      Inc(P);
    end;
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrReverseU(const S: UnicodeString): UnicodeString;
var I, L : Integer;
    P, Q : PWideChar;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  if L = 1 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L);
  P := Pointer(S);
  Q := Pointer(Result);
  Inc(Q, L - 1);
  for I := 1 to L do
    begin
      Q^ := P^;
      Dec(Q);
      Inc(P);
    end;
end;
{$ENDIF}

function StrReverse(const S: String): String;
var I, L : Integer;
    P, Q : PChar;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  if L = 1 then
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, L);
  P := Pointer(S);
  Q := Pointer(Result);
  Inc(Q, L - 1);
  for I := 1 to L do
    begin
      Q^ := P^;
      Dec(Q);
      Inc(P);
    end;
end;
{$ENDIF}



{                                                                              }
{ Base conversion                                                              }
{                                                                              }
{$IFDEF SupportAnsiString}
function BinToWord32(const S: AnsiString): Word32;
var Valid : Boolean;
begin
  Valid := TryBinToWord32A(S, Result);
  if not Valid then
    raise EConvertError.Create('Invalid binary string');
end;

function OctToWord32(const S: AnsiString): Word32;
var Valid : Boolean;
begin
  Valid := TryOctToWord32A(S, Result);
  if not Valid then
    raise EConvertError.Create('Invalid octal string');
end;

function StrToWord32(const S: AnsiString): Word32;
var Valid : Boolean;
begin
  Valid := TryStringToWord32A(S, Result);
  if not Valid then
    raise EConvertError.Create('Invalid decimal string');
end;

function StrToWord32Def(const S: AnsiString; const Default: Word32): Word32;
var Valid : Boolean;
begin
  Valid := TryStringToWord32A(S, Result);
  if not Valid then
    Result := Default;
end;

function HexToWord32(const S: AnsiString): Word32;
var Valid : Boolean;
begin
  Valid := TryHexToWord32A(S, Result);
  if not Valid then
    raise EConvertError.Create('Invalid hexadecimal string');
end;

function HexToWord32Def(const S: AnsiString; const Default: Word32): Word32;
var Valid : Boolean;
begin
  Valid := TryHexToWord32A(S, Result);
  if not Valid then
    Result := Default;
end;
{$ENDIF}



{                                                                              }
{ Type conversion                                                              }
{                                                                              }
{$IFDEF DELPHI5}
function StrToFloatDef(const S: String; const Default: Extended): Extended;
begin
  try
    Result := StrToFloat(S);
  except
    Result := Default;
  end;
end;
{$ELSE}
function StrToFloatDef(const S: String; const Default: Extended): Extended;
begin
  if not TryStrToFloat(S, Result) then
    Result := Default;
end;
{$ENDIF}

{$IFDEF SupportAnsiString}
function BooleanToStrA(const B: Boolean): AnsiString;
begin
  if B then
    Result := 'True'
  else
    Result := 'False';
end;

function BooleanToStrB(const B: Boolean): RawByteString;
begin
  if B then
    Result := 'True'
  else
    Result := 'False';
end;
{$ENDIF}

{$IFDEF SupportWideString}
function BooleanToStrW(const B: Boolean): WideString;
begin
  if B then
    Result := 'True'
  else
    Result := 'False';
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function BooleanToStrU(const B: Boolean): UnicodeString;
begin
  if B then
    Result := 'True'
  else
    Result := 'False';
end;
{$ENDIF}

function BooleanToStr(const B: Boolean): String;
begin
  if B then
    Result := 'True'
  else
    Result := 'False';
end;

{$IFDEF SupportAnsiString}
function StrToBooleanA(const S: AnsiString): Boolean;
begin
  Result := StrEqualNoAsciiCaseA(S, 'True');
end;

function StrToBooleanB(const S: RawByteString): Boolean;
begin
  Result := StrEqualNoAsciiCaseB(S, 'True');
end;
{$ENDIF}

{$IFDEF SupportWideString}
function StrToBooleanW(const S: WideString): Boolean;
begin
  Result := StrEqualNoAsciiCaseW(S, 'True');
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StrToBooleanU(const S: UnicodeString): Boolean;
begin
  Result := StrEqualNoAsciiCaseU(S, 'True');
end;
{$ENDIF}

function StrToBoolean(const S: String): Boolean;
begin
  Result := StrEqualNoAsciiCase(S, 'True');
end;



{                                                                              }
{ Dynamic array functions                                                      }
{                                                                              }
{$IFDEF SupportAnsiString}
function StringsTotalLengthA(const S: array of AnsiString): Integer;
var I : Integer;
begin
  Result := 0;
  for I := 0 to Length(S) - 1 do
    Inc(Result, Length(S[I]));
end;
{$ENDIF}

function StringsTotalLengthB(const S: array of RawByteString): Integer;
var I : Integer;
begin
  Result := 0;
  for I := 0 to Length(S) - 1 do
    Inc(Result, Length(S[I]));
end;

{$IFDEF SupportWideString}
function StringsTotalLengthW(const S: array of WideString): Integer;
var I : Integer;
begin
  Result := 0;
  for I := 0 to Length(S) - 1 do
    Inc(Result, Length(S[I]));
end;
{$ENDIF}

{$IFDEF SupportUnicodeString}
function StringsTotalLengthU(const S: array of UnicodeString): Integer;
var I : Integer;
begin
  Result := 0;
  for I := 0 to Length(S) - 1 do
    Inc(Result, Length(S[I]));
end;
{$ENDIF}

function StringsTotalLength(const S: array of String): Integer;
var I : Integer;
begin
  Result := 0;
  for I := 0 to Length(S) - 1 do
    Inc(Result, Length(S[I]));
end;

{$IFDEF SupportAnsiString}
function PosNextNoCaseA(const Find: AnsiString; const V: array of AnsiString;
    const PrevPos: Integer; const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxInt(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          repeat
            I := (L + H) div 2;
            if StrEqualNoAsciiCaseA(V[I], Find) then
              begin
                while (I > 0) and StrEqualNoAsciiCaseA(V[I - 1], Find) do
                  Dec(I);
                Result := I;
                exit;
              end else
            if StrCompareNoAsciiCaseA(V[I], Find) = 1 then
              H := I - 1 else
              L := I + 1;
          until L > H;
          Result := -1;
        end else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1 else
          if StrEqualNoAsciiCaseA(V[PrevPos + 1], Find) then
            Result := PrevPos + 1 else
            Result := -1;
    end else
    begin // linear search
      for I := MaxInt(PrevPos + 1, 0) to Length(V) - 1 do
        if StrEqualNoAsciiCaseA(V[I], Find) then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;
{$ENDIF}

function PosNextNoCaseB(const Find: RawByteString; const V: array of RawByteString;
    const PrevPos: Integer; const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxInt(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          repeat
            I := (L + H) div 2;
            if StrEqualNoAsciiCaseB(V[I], Find) then
              begin
                while (I > 0) and StrEqualNoAsciiCaseB(V[I - 1], Find) do
                  Dec(I);
                Result := I;
                exit;
              end else
            if StrCompareNoAsciiCaseB(V[I], Find) = 1 then
              H := I - 1 else
              L := I + 1;
          until L > H;
          Result := -1;
        end else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1 else
          if StrEqualNoAsciiCaseB(V[PrevPos + 1], Find) then
            Result := PrevPos + 1 else
            Result := -1;
    end else
    begin // linear search
      for I := MaxInt(PrevPos + 1, 0) to Length(V) - 1 do
        if StrEqualNoAsciiCaseB(V[I], Find) then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

{$IFDEF SupportUnicodeString}
function PosNextNoCaseU(const Find: UnicodeString; const V: array of UnicodeString;
    const PrevPos: Integer; const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxInt(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Length(V) - 1;
          repeat
            I := (L + H) div 2;
            if StrEqualNoAsciiCaseU(V[I], Find) then
              begin
                while (I > 0) and StrEqualNoAsciiCaseU(V[I - 1], Find) do
                  Dec(I);
                Result := I;
                exit;
              end else
            if StrCompareNoAsciiCaseU(V[I], Find) = 1 then
              H := I - 1 else
              L := I + 1;
          until L > H;
          Result := -1;
        end else // find next
        if PrevPos >= Length(V) - 1 then
          Result := -1 else
          if StrEqualNoAsciiCaseU(V[PrevPos + 1], Find) then
            Result := PrevPos + 1 else
            Result := -1;
    end else
    begin // linear search
      for I := MaxInt(PrevPos + 1, 0) to Length(V) - 1 do
        if StrEqualNoAsciiCaseU(V[I], Find) then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;
{$ENDIF}



{                                                                              }
{ Natural language                                                             }
{                                                                              }
function StorageSize(const Bytes: Int64; const ShortFormat: Boolean): String;
var Size, Suffix : String;
    Fmt          : String;
    Len          : Integer;
begin
  Fmt := iif(ShortFormat, '%1.0f', '%0.1f');
  if Bytes < 1024 then
    begin
      Size := IntToStr(Bytes);
      Suffix := iif(ShortFormat, 'B', 'bytes');
    end else
  if Bytes < 1024 * 1024 then
    begin
      Size := Format(Fmt, [Bytes / 1024.0]);
      Suffix := iif(ShortFormat, 'K', 'KB');
    end else
  if Bytes < 1024 * 1024 * 1024 then
    begin
      Size := Format(Fmt, [Bytes / (1024.0 * 1024.0)]);
      Suffix := iif(ShortFormat, 'M', 'MB');
    end else
  if Bytes < Int64(1024) * 1024 * 1024 * 1024 then
    begin
      Size := Format(Fmt, [Bytes / (1024.0 * 1024.0 * 1024.0)]);
      Suffix := iif(ShortFormat, 'G', 'GB');
    end else
  if Bytes < Int64(1024) * 1024 * 1024 * 1024 * 1024 then
    begin
      Size := Format(Fmt, [Bytes / (1024.0 * 1024.0 * 1024.0 * 1024.0)]);
      Suffix := iif(ShortFormat, 'T', 'TB');
    end
  else
    begin
      Size := Format(Fmt, [Bytes / (1024.0 * 1024.0 * 1024.0 * 1024.0 * 1024.0)]);
      Suffix := iif(ShortFormat, 'P', 'PB');
    end;
  Len := Length(Size);
  if Copy(Size, Len - 1, 2) = '.0' then
    SetLength(Size, Len - 2);
  Result := Size + ' ' + Suffix;
end;

function TransferRate(const Bytes, MillisecondsElapsed: Int64;
    const ShortFormat: Boolean): String;
begin
  if MillisecondsElapsed <= 0 then
    Result := ''
  else
    Result := StorageSize(Trunc(Bytes / (MillisecondsElapsed / 1000.0)), ShortFormat) + '/s';
end;




{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF STRINGS_TEST}
{$ASSERTIONS ON}
procedure Test;
var {$IFDEF SupportAnsiString}
    C    : AnsiChar;
    {$ENDIF}
    D    : WideChar;
    E    : Char;
    {$IFDEF SupportAnsiString}
    S, T : AnsiString;
    {$ENDIF}
    {$IFDEF SupportUnicodeString}
    W, X : UnicodeString;
    {$ENDIF}
    Y, Z : String;
    {$IFDEF SupportAnsiString}
    L    : AnsiStringArray;
    I    : Integer;
    {$ENDIF}
begin
  { CharMatch                                                                  }
  Assert(CharMatchA(AnsiChar('A'), AnsiChar('a'), False));
  Assert(CharMatchA(AnsiChar('a'), AnsiChar('A'), False));
  Assert(CharMatchA(AnsiChar('A'), AnsiChar('A'), False));

  { CharMatchNoAsciiCase                                                       }
  Assert(CharMatchNoAsciiCaseAW(AnsiChar('A'), 'a'), 'CharMatchNoAsciiCase');
  Assert(CharMatchNoAsciiCaseAW(AnsiChar('z'), 'Z'), 'CharMatchNoAsciiCase');
  Assert(CharMatchNoAsciiCaseAW(AnsiChar('1'), '1'), 'CharMatchNoAsciiCase');
  Assert(not CharMatchNoAsciiCaseAW(AnsiChar('A'), 'B'), 'CharMatchNoAsciiCase');
  Assert(not CharMatchNoAsciiCaseAW(AnsiChar('0'), 'A'), 'CharMatchNoAsciiCase');

  { CharSetMatchChar                                                           }
  Assert(CharSetMatchCharA([AnsiChar('a')..AnsiChar('z')], AnsiChar('a'), False));
  Assert(CharSetMatchCharA([AnsiChar('a')..AnsiChar('z')], AnsiChar('A'), False));
  Assert(not CharSetMatchCharA([AnsiChar('a')..AnsiChar('z')], AnsiChar('-'), False));
  Assert(not CharSetMatchCharA([AnsiChar('a')..AnsiChar('z')], AnsiChar('A'), True));
  Assert(not CharSetMatchCharA([], AnsiChar('A')));

  { Type matching                                                              }
  {$IFDEF SupportAnsiChar}
  Assert(StrIsNumericA('1234567890'), 'StrIsNumeric');
  Assert(not StrIsNumericA('1234567890X'), 'StrIsNumeric');
  Assert(not StrIsNumericA(''), 'StrIsNumeric');
  Assert(StrIsIntegerA('-1234567890'), 'StrIsInteger');
  Assert(StrIsIntegerA('0'), 'StrIsInteger');
  Assert(not StrIsIntegerA('-1234567890X'), 'StrIsInteger');
  Assert(not StrIsIntegerA('-'), 'StrIsInteger');

  Assert(StrIsNumericB('1234567890'), 'StrIsNumeric');
  Assert(not StrIsNumericB('1234567890X'), 'StrIsNumeric');
  Assert(not StrIsNumericB(''), 'StrIsNumeric');
  Assert(StrIsIntegerB('-1234567890'), 'StrIsInteger');
  Assert(StrIsIntegerB('0'), 'StrIsInteger');
  Assert(not StrIsIntegerB('-1234567890X'), 'StrIsInteger');
  Assert(not StrIsIntegerB('-'), 'StrIsInteger');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(StrIsNumericW('1234567890'), 'StrIsNumeric');
  Assert(not StrIsNumericW('1234567890X'), 'StrIsNumeric');
  Assert(not StrIsNumericW(''), 'StrIsNumeric');
  Assert(StrIsIntegerW('-1234567890'), 'StrIsInteger');
  Assert(StrIsIntegerW('0'), 'StrIsInteger');
  Assert(not StrIsIntegerW('-1234567890X'), 'StrIsInteger');
  Assert(not StrIsIntegerW('-'), 'StrIsInteger');
  {$ENDIF}

  Assert(StrIsNumeric('1234567890'), 'StrIsNumeric');
  Assert(not StrIsNumeric('1234567890X'), 'StrIsNumeric');
  Assert(not StrIsNumeric(''), 'StrIsNumeric');
  Assert(StrIsInteger('-1234567890'), 'StrIsInteger');
  Assert(StrIsInteger('0'), 'StrIsInteger');
  Assert(not StrIsInteger('-1234567890X'), 'StrIsInteger');
  Assert(not StrIsInteger('-'), 'StrIsInteger');

  { CopyRange                                                                  }
  {$IFDEF SupportAnsiChar}
  Assert(CopyRangeA('', 1, 2) =  '', 'CopyRange');
  Assert(CopyRangeA('', -1, -2) = '', 'CopyRange');
  Assert(CopyRangeA('1234567890', 5, 7) = '567', 'CopyRange');
  Assert(CopyRangeA('1234567890', 1, 1) = '1', 'CopyRange');
  Assert(CopyRangeA('1234567890', 0, 11) = '1234567890', 'CopyRange');
  Assert(CopyRangeA('1234567890', 7, 4) = '', 'CopyRange');
  Assert(CopyRangeA('1234567890', 1, 0) = '', 'CopyRange');
  Assert(CopyRangeA('1234567890', -2, 3) = '123', 'CopyRange');
  Assert(CopyRangeA('1234567890', 2, -1) = '', 'CopyRange');
  Assert(CopyRangeA('1234567890', -4, -2) = '', 'CopyRange');

  Assert(CopyRangeB('', 1, 2) =  '', 'CopyRange');
  Assert(CopyRangeB('', -1, -2) = '', 'CopyRange');
  Assert(CopyRangeB('1234567890', 5, 7) = '567', 'CopyRange');
  Assert(CopyRangeB('1234567890', 1, 1) = '1', 'CopyRange');
  Assert(CopyRangeB('1234567890', 0, 11) = '1234567890', 'CopyRange');
  Assert(CopyRangeB('1234567890', 7, 4) = '', 'CopyRange');
  Assert(CopyRangeB('1234567890', 1, 0) = '', 'CopyRange');
  Assert(CopyRangeB('1234567890', -2, 3) = '123', 'CopyRange');
  Assert(CopyRangeB('1234567890', 2, -1) = '', 'CopyRange');
  Assert(CopyRangeB('1234567890', -4, -2) = '', 'CopyRange');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(CopyRangeW('', 1, 2) =  '', 'CopyRange');
  Assert(CopyRangeW('', -1, -2) = '', 'CopyRange');
  Assert(CopyRangeW('1234567890', 5, 7) = '567', 'CopyRange');
  Assert(CopyRangeW('1234567890', 1, 1) = '1', 'CopyRange');
  Assert(CopyRangeW('1234567890', 0, 11) = '1234567890', 'CopyRange');
  Assert(CopyRangeW('1234567890', 7, 4) = '', 'CopyRange');
  Assert(CopyRangeW('1234567890', 1, 0) = '', 'CopyRange');
  Assert(CopyRangeW('1234567890', -2, 3) = '123', 'CopyRange');
  Assert(CopyRangeW('1234567890', 2, -1) = '', 'CopyRange');
  Assert(CopyRangeW('1234567890', -4, -2) = '', 'CopyRange');
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(CopyRangeU('', 1, 2) =  '', 'CopyRange');
  Assert(CopyRangeU('', -1, -2) = '', 'CopyRange');
  Assert(CopyRangeU('1234567890', 5, 7) = '567', 'CopyRange');
  Assert(CopyRangeU('1234567890', 1, 1) = '1', 'CopyRange');
  Assert(CopyRangeU('1234567890', 0, 11) = '1234567890', 'CopyRange');
  Assert(CopyRangeU('1234567890', 7, 4) = '', 'CopyRange');
  Assert(CopyRangeU('1234567890', 1, 0) = '', 'CopyRange');
  Assert(CopyRangeU('1234567890', -2, 3) = '123', 'CopyRange');
  Assert(CopyRangeU('1234567890', 2, -1) = '', 'CopyRange');
  Assert(CopyRangeU('1234567890', -4, -2) = '', 'CopyRange');
  {$ENDIF}

  Assert(CopyRange('', 1, 2) =  '', 'CopyRange');
  Assert(CopyRange('', -1, -2) = '', 'CopyRange');
  Assert(CopyRange('1234567890', 5, 7) = '567', 'CopyRange');
  Assert(CopyRange('1234567890', 1, 1) = '1', 'CopyRange');
  Assert(CopyRange('1234567890', 0, 11) = '1234567890', 'CopyRange');
  Assert(CopyRange('1234567890', 7, 4) = '', 'CopyRange');
  Assert(CopyRange('1234567890', 1, 0) = '', 'CopyRange');
  Assert(CopyRange('1234567890', -2, 3) = '123', 'CopyRange');
  Assert(CopyRange('1234567890', 2, -1) = '', 'CopyRange');
  Assert(CopyRange('1234567890', -4, -2) = '', 'CopyRange');

  { CopyFrom                                                                   }
  {$IFDEF SupportAnsiChar}
  Assert(CopyFromA('a', 0) = 'a', 'CopyFrom');
  Assert(CopyFromA('a', -1) = 'a', 'CopyFrom');
  Assert(CopyFromA('', 1) = '', 'CopyFrom');
  Assert(CopyFromA('', -2) = '', 'CopyFrom');
  Assert(CopyFromA('1234567890', 8) = '890', 'CopyFrom');
  Assert(CopyFromA('1234567890', 11) = '', 'CopyFrom');
  Assert(CopyFromA('1234567890', 0) = '1234567890', 'CopyFrom');
  Assert(CopyFromA('1234567890', -2) = '1234567890', 'CopyFrom');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(CopyFromW('a', 0) = 'a', 'CopyFrom');
  Assert(CopyFromW('a', -1) = 'a', 'CopyFrom');
  Assert(CopyFromW('', 1) = '', 'CopyFrom');
  Assert(CopyFromW('', -2) = '', 'CopyFrom');
  Assert(CopyFromW('1234567890', 8) = '890', 'CopyFrom');
  Assert(CopyFromW('1234567890', 11) = '', 'CopyFrom');
  Assert(CopyFromW('1234567890', 0) = '1234567890', 'CopyFrom');
  Assert(CopyFromW('1234567890', -2) = '1234567890', 'CopyFrom');
  {$ENDIF}

  Assert(CopyFrom('a', 0) = 'a', 'CopyFrom');
  Assert(CopyFrom('a', -1) = 'a', 'CopyFrom');
  Assert(CopyFrom('', 1) = '', 'CopyFrom');
  Assert(CopyFrom('', -2) = '', 'CopyFrom');
  Assert(CopyFrom('1234567890', 8) = '890', 'CopyFrom');
  Assert(CopyFrom('1234567890', 11) = '', 'CopyFrom');
  Assert(CopyFrom('1234567890', 0) = '1234567890', 'CopyFrom');
  Assert(CopyFrom('1234567890', -2) = '1234567890', 'CopyFrom');

  { CopyLeft                                                                   }
  {$IFDEF SupportAnsiChar}
  Assert(CopyLeftA('a', 0) = '', 'CopyLeft');
  Assert(CopyLeftA('a', -1) = '', 'CopyLeft');
  Assert(CopyLeftA('', 1) = '', 'CopyLeft');
  Assert(CopyLeftA('b', 1) = 'b', 'CopyLeft');
  Assert(CopyLeftA('', -1) = '', 'CopyLeft');
  Assert(CopyLeftA('1234567890', 3) = '123', 'CopyLeft');
  Assert(CopyLeftA('1234567890', 11) = '1234567890', 'CopyLeft');
  Assert(CopyLeftA('1234567890', 0) = '', 'CopyLeft');
  Assert(CopyLeftA('1234567890', -2) = '', 'CopyLeft');

  Assert(CopyLeftB('a', 0) = '', 'CopyLeft');
  Assert(CopyLeftB('a', -1) = '', 'CopyLeft');
  Assert(CopyLeftB('', 1) = '', 'CopyLeft');
  Assert(CopyLeftB('b', 1) = 'b', 'CopyLeft');
  Assert(CopyLeftB('', -1) = '', 'CopyLeft');
  Assert(CopyLeftB('1234567890', 3) = '123', 'CopyLeft');
  Assert(CopyLeftB('1234567890', 11) = '1234567890', 'CopyLeft');
  Assert(CopyLeftB('1234567890', 0) = '', 'CopyLeft');
  Assert(CopyLeftB('1234567890', -2) = '', 'CopyLeft');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(CopyLeftW('a', 0) = '', 'CopyLeft');
  Assert(CopyLeftW('a', -1) = '', 'CopyLeft');
  Assert(CopyLeftW('', 1) = '', 'CopyLeft');
  Assert(CopyLeftW('b', 1) = 'b', 'CopyLeft');
  Assert(CopyLeftW('', -1) = '', 'CopyLeft');
  Assert(CopyLeftW('1234567890', 3) = '123', 'CopyLeft');
  Assert(CopyLeftW('1234567890', 11) = '1234567890', 'CopyLeft');
  Assert(CopyLeftW('1234567890', 0) = '', 'CopyLeft');
  Assert(CopyLeftW('1234567890', -2) = '', 'CopyLeft');
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(CopyLeftU('a', 0) = '', 'CopyLeft');
  Assert(CopyLeftU('a', -1) = '', 'CopyLeft');
  Assert(CopyLeftU('', 1) = '', 'CopyLeft');
  Assert(CopyLeftU('b', 1) = 'b', 'CopyLeft');
  Assert(CopyLeftU('', -1) = '', 'CopyLeft');
  Assert(CopyLeftU('1234567890', 3) = '123', 'CopyLeft');
  Assert(CopyLeftU('1234567890', 11) = '1234567890', 'CopyLeft');
  Assert(CopyLeftU('1234567890', 0) = '', 'CopyLeft');
  Assert(CopyLeftU('1234567890', -2) = '', 'CopyLeft');
  {$ENDIF}

  Assert(CopyLeft('a', 0) = '', 'CopyLeft');
  Assert(CopyLeft('a', -1) = '', 'CopyLeft');
  Assert(CopyLeft('', 1) = '', 'CopyLeft');
  Assert(CopyLeft('b', 1) = 'b', 'CopyLeft');
  Assert(CopyLeft('', -1) = '', 'CopyLeft');
  Assert(CopyLeft('1234567890', 3) = '123', 'CopyLeft');
  Assert(CopyLeft('1234567890', 11) = '1234567890', 'CopyLeft');
  Assert(CopyLeft('1234567890', 0) = '', 'CopyLeft');
  Assert(CopyLeft('1234567890', -2) = '', 'CopyLeft');

  { CopyRight                                                                  }
  {$IFDEF SupportAnsiChar}
  Assert(CopyRightA('a', 0) = '', 'CopyRight');
  Assert(CopyRightA('a', -1) = '', 'CopyRight');
  Assert(CopyRightA('', 1) = '', 'CopyRight');
  Assert(CopyRightA('', -2) = '', 'CopyRight');
  Assert(CopyRightA('1234567890', 3) = '890', 'CopyRight');
  Assert(CopyRightA('1234567890', 11) = '1234567890', 'CopyRight');
  Assert(CopyRightA('1234567890', 0) = '', 'CopyRight');
  Assert(CopyRightA('1234567890', -2) = '', 'CopyRight');

  Assert(CopyRightB('a', 0) = '', 'CopyRight');
  Assert(CopyRightB('a', -1) = '', 'CopyRight');
  Assert(CopyRightB('', 1) = '', 'CopyRight');
  Assert(CopyRightB('', -2) = '', 'CopyRight');
  Assert(CopyRightB('1234567890', 3) = '890', 'CopyRight');
  Assert(CopyRightB('1234567890', 11) = '1234567890', 'CopyRight');
  Assert(CopyRightB('1234567890', 0) = '', 'CopyRight');
  Assert(CopyRightB('1234567890', -2) = '', 'CopyRight');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(CopyRightW('a', 0) = '', 'CopyRight');
  Assert(CopyRightW('a', -1) = '', 'CopyRight');
  Assert(CopyRightW('', 1) = '', 'CopyRight');
  Assert(CopyRightW('', -2) = '', 'CopyRight');
  Assert(CopyRightW('1234567890', 3) = '890', 'CopyRight');
  Assert(CopyRightW('1234567890', 11) = '1234567890', 'CopyRight');
  Assert(CopyRightW('1234567890', 0) = '', 'CopyRight');
  Assert(CopyRightW('1234567890', -2) = '', 'CopyRight');
  {$ENDIF}

  Assert(CopyRight('a', 0) = '', 'CopyRight');
  Assert(CopyRight('a', -1) = '', 'CopyRight');
  Assert(CopyRight('', 1) = '', 'CopyRight');
  Assert(CopyRight('', -2) = '', 'CopyRight');
  Assert(CopyRight('1234567890', 3) = '890', 'CopyRight');
  Assert(CopyRight('1234567890', 11) = '1234567890', 'CopyRight');
  Assert(CopyRight('1234567890', 0) = '', 'CopyRight');
  Assert(CopyRight('1234567890', -2) = '', 'CopyRight');

  { CopyEx                                                               }
  {$IFDEF SupportAnsiChar}
  Assert(CopyExA('', 1, 1) = '');
  Assert(CopyExA('', -2, -1) = '');
  Assert(CopyExA('12345', -2, 2) = '45');
  Assert(CopyExA('12345', -1, 2) = '5');
  Assert(CopyExA('12345', -7, 2) = '12');
  Assert(CopyExA('12345', -5, 2) = '12');
  Assert(CopyExA('12345', 2, -2) = '');
  Assert(CopyExA('12345', -4, 0) = '');
  Assert(CopyExA('12345', -4, 7) = '2345');
  Assert(CopyExA('12345', 2, 2) = '23');
  Assert(CopyExA('12345', -7, -6) = '');
  Assert(CopyExA('12345', 0, 2) = '12');
  Assert(CopyExA('12345', 0, 7) = '12345');
  {$ENDIF}

  Assert(CopyExW('', 1, 1) = '');
  Assert(CopyExW('', -2, -1) = '');
  Assert(CopyExW('12345', -2, 2) = '45');
  Assert(CopyExW('12345', -1, 2) = '5');
  Assert(CopyExW('12345', -7, 2) = '12');
  Assert(CopyExW('12345', -5, 2) = '12');
  Assert(CopyExW('12345', 2, -2) = '');
  Assert(CopyExW('12345', -4, 0) = '');
  Assert(CopyExW('12345', -4, 7) = '2345');
  Assert(CopyExW('12345', 2, 2) = '23');
  Assert(CopyExW('12345', -7, -6) = '');
  Assert(CopyExW('12345', 0, 2) = '12');
  Assert(CopyExW('12345', 0, 7) = '12345');

  Assert(CopyEx('', 1, 1) = '');
  Assert(CopyEx('', -2, -1) = '');
  Assert(CopyEx('12345', -2, 2) = '45');
  Assert(CopyEx('12345', -1, 2) = '5');
  Assert(CopyEx('12345', -7, 2) = '12');
  Assert(CopyEx('12345', -5, 2) = '12');
  Assert(CopyEx('12345', 2, -2) = '');
  Assert(CopyEx('12345', -4, 0) = '');
  Assert(CopyEx('12345', -4, 7) = '2345');
  Assert(CopyEx('12345', 2, 2) = '23');
  Assert(CopyEx('12345', -7, -6) = '');
  Assert(CopyEx('12345', 0, 2) = '12');
  Assert(CopyEx('12345', 0, 7) = '12345');

  { CopyRangeEx                                                          }
  Assert(CopyRangeEx('', -2, -1) = '');
  Assert(CopyRangeEx('', 0, 0) = '');
  Assert(CopyRangeEx('12345', -2, -1) = '45');
  Assert(CopyRangeEx('12345', -2, -1) = '45');
  Assert(CopyRangeEx('12345', -2, 5) = '45');
  Assert(CopyRangeEx('12345', 2, -2) = '234');
  Assert(CopyRangeEx('12345', 0, -2) = '1234');
  Assert(CopyRangeEx('12345', 1, -7) = '');
  Assert(CopyRangeEx('12345', 7, -1) = '');
  Assert(CopyRangeEx('12345', -10, 2) = '12');
  Assert(CopyRangeEx('12345', -10, -7) = '');
  Assert(CopyRangeEx('12345', 2, -6) = '');
  Assert(CopyRangeEx('12345', 0, -2) = '1234');
  Assert(CopyRangeEx('12345', 2, 0) = '');
  Assert(CopyRangeEx('', -1, 2) = '');

  { CopyFromEx                                                           }
  Assert(CopyFromEx('', 0) = '');
  Assert(CopyFromEx('', -1) = '');
  Assert(CopyFromEx('12345', 0) = '12345');
  Assert(CopyFromEx('12345', 1) = '12345');
  Assert(CopyFromEx('12345', -5) = '12345');
  Assert(CopyFromEx('12345', -6) = '12345');
  Assert(CopyFromEx('12345', 2) = '2345');
  Assert(CopyFromEx('12345', -4) =  '2345');
  Assert(CopyFromEx('12345', 6) = '');

  { StrEqualNoCase                                                             }
  {$IFDEF SupportAnsiChar}
  Assert(StrEqualNoAsciiCaseA('A', 'a'), 'StrEqualNoCase');
  Assert(not StrEqualNoAsciiCaseA('A', 'B'), 'StrEqualNoCase');
  Assert(StrEqualNoAsciiCaseA('@ABCDEFGHIJKLMNOPQRSTUVWXYZ` ', '@abcdefghijklmnopqrstuvwxyz` '), 'StrEqualNoCase');
  Assert(not StrEqualNoAsciiCaseA('@ABCDEFGHIJKLMNOPQRSTUVWXY-` ', '@abcdefghijklmnopqrstuvwxyz` '), 'StrEqualNoCase');

  Assert(StrEqualNoAsciiCaseB('A', 'a'), 'StrEqualNoCase');
  Assert(not StrEqualNoAsciiCaseB('A', 'B'), 'StrEqualNoCase');
  Assert(StrEqualNoAsciiCaseB('@ABCDEFGHIJKLMNOPQRSTUVWXYZ` ', '@abcdefghijklmnopqrstuvwxyz` '), 'StrEqualNoCase');
  Assert(not StrEqualNoAsciiCaseB('@ABCDEFGHIJKLMNOPQRSTUVWXY-` ', '@abcdefghijklmnopqrstuvwxyz` '), 'StrEqualNoCase');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(StrEqualNoAsciiCaseW('A', 'a'), 'StrEqualNoCase');
  Assert(not StrEqualNoAsciiCaseW('A', 'B'), 'StrEqualNoCase');
  Assert(StrEqualNoAsciiCaseW('@ABCDEFGHIJKLMNOPQRSTUVWXYZ` ', '@abcdefghijklmnopqrstuvwxyz` '), 'StrEqualNoCase');
  Assert(not StrEqualNoAsciiCaseW('@ABCDEFGHIJKLMNOPQRSTUVWXY-` ', '@abcdefghijklmnopqrstuvwxyz` '), 'StrEqualNoCase');
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(StrEqualNoAsciiCaseU('A', 'a'), 'StrEqualNoCase');
  Assert(not StrEqualNoAsciiCaseU('A', 'B'), 'StrEqualNoCase');
  Assert(StrEqualNoAsciiCaseU('@ABCDEFGHIJKLMNOPQRSTUVWXYZ` ', '@abcdefghijklmnopqrstuvwxyz` '), 'StrEqualNoCase');
  Assert(not StrEqualNoAsciiCaseU('@ABCDEFGHIJKLMNOPQRSTUVWXY-` ', '@abcdefghijklmnopqrstuvwxyz` '), 'StrEqualNoCase');
  {$ENDIF}

  Assert(StrEqualNoAsciiCase('A', 'a'), 'StrEqualNoCase');
  Assert(not StrEqualNoAsciiCase('A', 'B'), 'StrEqualNoCase');
  Assert(StrEqualNoAsciiCase('@ABCDEFGHIJKLMNOPQRSTUVWXYZ` ', '@abcdefghijklmnopqrstuvwxyz` '), 'StrEqualNoCase');
  Assert(not StrEqualNoAsciiCase('@ABCDEFGHIJKLMNOPQRSTUVWXY-` ', '@abcdefghijklmnopqrstuvwxyz` '), 'StrEqualNoCase');

  { StrReverse                                                                 }
  {$IFDEF SupportAnsiChar}
  Assert(StrReverseA('12345') = '54321', 'StrReverse');
  Assert(StrReverseA('1234') = '4321', 'StrReverse');

  Assert(StrReverseB('12345') = '54321', 'StrReverse');
  Assert(StrReverseB('1234') = '4321', 'StrReverse');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(StrReverseW('12345') = '54321', 'StrReverse');
  Assert(StrReverseW('1234') = '4321', 'StrReverse');
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(StrReverseU('12345') = '54321', 'StrReverse');
  Assert(StrReverseU('1234') = '4321', 'StrReverse');
  {$ENDIF}

  Assert(StrReverse('12345') = '54321', 'StrReverse');
  Assert(StrReverse('1234') = '4321', 'StrReverse');

  { Compare                                                                    }
  {$IFDEF SupportAnsiChar}
  Assert(StrCompareNoAsciiCaseA('a', 'a') = 0, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseA('a', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseA('b', 'a') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseA('A', 'a') = 0, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseA('A', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseA('b', 'A') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseA('aa', 'a') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseA('a', 'aa') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseA('AA', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseA('B', 'aa') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseA('aa', 'Aa') = 0, 'StrCompareNoCase');
  Assert(StrCompareA('A', 'a') = -1, 'StrCompareNoCase');
  Assert(StrCompareA('a', 'A') = 1, 'StrCompareNoCase');
  Assert(StrCompareA('a', 'aa') = -1, 'StrCompareNoCase');
  Assert(StrCompareA('', '') = 0, 'StrCompareNoCase');
  Assert(StrCompareA('', 'a') = -1, 'StrCompareNoCase');
  Assert(StrCompareA('a', '') = 1, 'StrCompareNoCase');

  Assert(StrCompareNoAsciiCaseB('a', 'a') = 0, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseB('a', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseB('b', 'a') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseB('A', 'a') = 0, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseB('A', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseB('b', 'A') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseB('aa', 'a') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseB('a', 'aa') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseB('AA', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseB('B', 'aa') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseB('aa', 'Aa') = 0, 'StrCompareNoCase');
  Assert(StrCompareB('A', 'a') = -1, 'StrCompareNoCase');
  Assert(StrCompareB('a', 'A') = 1, 'StrCompareNoCase');
  Assert(StrCompareB('a', 'aa') = -1, 'StrCompareNoCase');
  Assert(StrCompareB('', '') = 0, 'StrCompareNoCase');
  Assert(StrCompareB('', 'a') = -1, 'StrCompareNoCase');
  Assert(StrCompareB('a', '') = 1, 'StrCompareNoCase');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(StrCompareNoAsciiCaseW('a', 'a') = 0, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseW('a', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseW('b', 'a') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseW('A', 'a') = 0, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseW('A', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseW('b', 'A') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseW('aa', 'a') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseW('a', 'aa') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseW('AA', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseW('B', 'aa') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseW('aa', 'Aa') = 0, 'StrCompareNoCase');
  Assert(StrCompareW('A', 'a') = -1, 'StrCompareNoCase');
  Assert(StrCompareW('a', 'A') = 1, 'StrCompareNoCase');
  Assert(StrCompareW('a', 'aa') = -1, 'StrCompareNoCase');
  Assert(StrCompareW('', '') = 0, 'StrCompareNoCase');
  Assert(StrCompareW('', 'a') = -1, 'StrCompareNoCase');
  Assert(StrCompareW('a', '') = 1, 'StrCompareNoCase');
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(StrCompareNoAsciiCaseU('a', 'a') = 0, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseU('a', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseU('b', 'a') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseU('A', 'a') = 0, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseU('A', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseU('b', 'A') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseU('aa', 'a') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseU('a', 'aa') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseU('AA', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseU('B', 'aa') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCaseU('aa', 'Aa') = 0, 'StrCompareNoCase');
  Assert(StrCompareU('A', 'a') = -1, 'StrCompareNoCase');
  Assert(StrCompareU('a', 'A') = 1, 'StrCompareNoCase');
  Assert(StrCompareU('a', 'aa') = -1, 'StrCompareNoCase');
  Assert(StrCompareU('', '') = 0, 'StrCompareNoCase');
  Assert(StrCompareU('', 'a') = -1, 'StrCompareNoCase');
  Assert(StrCompareU('a', '') = 1, 'StrCompareNoCase');
  {$ENDIF}

  Assert(StrCompareNoAsciiCase('a', 'a') = 0, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCase('a', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCase('b', 'a') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCase('A', 'a') = 0, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCase('A', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCase('b', 'A') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCase('aa', 'a') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCase('a', 'aa') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCase('AA', 'b') = -1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCase('B', 'aa') = 1, 'StrCompareNoCase');
  Assert(StrCompareNoAsciiCase('aa', 'Aa') = 0, 'StrCompareNoCase');
  Assert(StrCompare('A', 'a') = -1, 'StrCompareNoCase');
  Assert(StrCompare('a', 'A') = 1, 'StrCompareNoCase');
  Assert(StrCompare('a', 'aa') = -1, 'StrCompareNoCase');
  Assert(StrCompare('', '') = 0, 'StrCompareNoCase');
  Assert(StrCompare('', 'a') = -1, 'StrCompareNoCase');
  Assert(StrCompare('a', '') = 1, 'StrCompareNoCase');

  { Match                                                                      }
  {$IFDEF SupportAnsiChar}
  Assert(not StrMatchA('', '', 1), 'StrMatch');
  Assert(not StrMatchA('', 'a', 1), 'StrMatch');
  Assert(not StrMatchA('a', '', 1), 'StrMatch');
  Assert(not StrMatchA('a', 'A', 1), 'StrMatch');
  Assert(StrMatchA('A', 'A', 1), 'StrMatch');
  Assert(not StrMatchA('abcdef', 'xx', 1), 'StrMatch');
  Assert(StrMatchA('xbcdef', 'x', 1), 'StrMatch');
  Assert(StrMatchA('abcdxxxxx', 'xxxxx', 5), 'StrMatch');
  Assert(StrMatchA('abcdef', 'abcdef', 1), 'StrMatch');
  Assert(not StrMatchNoAsciiCaseA('abcdef', 'xx', 1), 'StrMatchNoCase');
  Assert(StrMatchNoAsciiCaseA('xbCDef', 'xBCd', 1), 'StrMatchNoCase');
  Assert(StrMatchNoAsciiCaseA('abcdxxX-xx', 'Xxx-xX', 5), 'StrMatchNoCase');
  Assert(StrMatchA('abcde', 'abcd', 1), 'StrMatch');
  Assert(StrMatchA('abcde', 'abc', 1), 'StrMatch');
  Assert(StrMatchA('abcde', 'ab', 1), 'StrMatch');
  Assert(StrMatchA('abcde', 'a', 1), 'StrMatch');
  Assert(StrMatchNoAsciiCaseA(' abC-Def{', ' AbC-def{', 1), 'StrMatchNoCase');
  Assert(StrMatchLeftA('ABC1D', 'aBc1', False), 'StrMatchLeft');
  Assert(StrMatchLeftA('aBc1D', 'aBc1', True), 'StrMatchLeft');
  Assert(not StrMatchLeftA('AB1D', 'ABc1', False), 'StrMatchLeft');
  Assert(not StrMatchLeftA('aBC1D', 'aBc1', True), 'StrMatchLeft');
  Assert(not StrMatchCharA('', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchCharA('a', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(not StrMatchCharA('d', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchCharA('acbba', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(not StrMatchCharA('acbd', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchLenA('abcd', ['a', 'b', 'c'], 1) = 3, 'StrMatchLen');
  Assert(StrMatchLenA('abcd', ['a', 'b', 'c'], 3) = 1, 'StrMatchLen');
  Assert(StrMatchLenA('abcd', ['a', 'b', 'c'], 4) = 0, 'StrMatchLen');
  Assert(StrMatchLenA('', ['a', 'b', 'c'], 1) = 0, 'StrMatchLen');
  Assert(StrMatchLenA('dcba', ['a', 'b', 'c'], 2) = 3, 'StrMatchLen');
  Assert(StrMatchLenA('dcba', ['a', 'b', 'c'], 1) = 0, 'StrMatchLen');

  Assert(not StrMatchB('', '', 1), 'StrMatch');
  Assert(not StrMatchB('', 'a', 1), 'StrMatch');
  Assert(not StrMatchB('a', '', 1), 'StrMatch');
  Assert(not StrMatchB('a', 'A', 1), 'StrMatch');
  Assert(StrMatchB('A', 'A', 1), 'StrMatch');
  Assert(not StrMatchB('abcdef', 'xx', 1), 'StrMatch');
  Assert(StrMatchB('xbcdef', 'x', 1), 'StrMatch');
  Assert(StrMatchB('abcdxxxxx', 'xxxxx', 5), 'StrMatch');
  Assert(StrMatchB('abcdef', 'abcdef', 1), 'StrMatch');
  Assert(not StrMatchNoAsciiCaseB('abcdef', 'xx', 1), 'StrMatchNoCase');
  Assert(StrMatchNoAsciiCaseB('xbCDef', 'xBCd', 1), 'StrMatchNoCase');
  Assert(StrMatchNoAsciiCaseB('abcdxxX-xx', 'Xxx-xX', 5), 'StrMatchNoCase');
  Assert(StrMatchB('abcde', 'abcd', 1), 'StrMatch');
  Assert(StrMatchB('abcde', 'abc', 1), 'StrMatch');
  Assert(StrMatchB('abcde', 'ab', 1), 'StrMatch');
  Assert(StrMatchB('abcde', 'a', 1), 'StrMatch');
  Assert(StrMatchNoAsciiCaseB(' abC-Def{', ' AbC-def{', 1), 'StrMatchNoCase');
  Assert(StrMatchLeftB('ABC1D', 'aBc1', False), 'StrMatchLeft');
  Assert(StrMatchLeftB('aBc1D', 'aBc1', True), 'StrMatchLeft');
  Assert(not StrMatchLeftB('AB1D', 'ABc1', False), 'StrMatchLeft');
  Assert(not StrMatchLeftB('aBC1D', 'aBc1', True), 'StrMatchLeft');
  Assert(not StrMatchCharB('', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchCharB('a', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(not StrMatchCharB('d', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchCharB('acbba', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(not StrMatchCharB('acbd', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchLenB('abcd', ['a', 'b', 'c'], 1) = 3, 'StrMatchLen');
  Assert(StrMatchLenB('abcd', ['a', 'b', 'c'], 3) = 1, 'StrMatchLen');
  Assert(StrMatchLenB('abcd', ['a', 'b', 'c'], 4) = 0, 'StrMatchLen');
  Assert(StrMatchLenB('', ['a', 'b', 'c'], 1) = 0, 'StrMatchLen');
  Assert(StrMatchLenB('dcba', ['a', 'b', 'c'], 2) = 3, 'StrMatchLen');
  Assert(StrMatchLenB('dcba', ['a', 'b', 'c'], 1) = 0, 'StrMatchLen');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(not StrMatchW('', '', 1), 'StrMatch');
  Assert(not StrMatchW('', 'a', 1), 'StrMatch');
  Assert(not StrMatchW('a', '', 1), 'StrMatch');
  Assert(not StrMatchW('a', 'A', 1), 'StrMatch');
  Assert(StrMatchW('A', 'A', 1), 'StrMatch');
  Assert(not StrMatchW('abcdef', 'xx', 1), 'StrMatch');
  Assert(StrMatchW('xbcdef', 'x', 1), 'StrMatch');
  Assert(StrMatchW('abcdxxxxx', 'xxxxx', 5), 'StrMatch');
  Assert(StrMatchW('abcdef', 'abcdef', 1), 'StrMatch');
  Assert(not StrMatchNoAsciiCaseW('abcdef', 'xx', 1), 'StrMatchNoCase');
  Assert(StrMatchNoAsciiCaseW('xbCDef', 'xBCd', 1), 'StrMatchNoCase');
  Assert(StrMatchNoAsciiCaseW('abcdxxX-xx', 'Xxx-xX', 5), 'StrMatchNoCase');
  Assert(StrMatchW('abcde', 'abcd', 1), 'StrMatch');
  Assert(StrMatchW('abcde', 'abc', 1), 'StrMatch');
  Assert(StrMatchW('abcde', 'ab', 1), 'StrMatch');
  Assert(StrMatchW('abcde', 'a', 1), 'StrMatch');
  Assert(StrMatchNoAsciiCaseW(' abC-Def{', ' AbC-def{', 1), 'StrMatchNoCase');
  Assert(StrMatchLeftW('ABC1D', 'aBc1', False), 'StrMatchLeft');
  Assert(StrMatchLeftW('aBc1D', 'aBc1', True), 'StrMatchLeft');
  Assert(not StrMatchLeftW('AB1D', 'ABc1', False), 'StrMatchLeft');
  Assert(not StrMatchLeftW('aBC1D', 'aBc1', True), 'StrMatchLeft');
  Assert(not StrMatchCharW('', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchCharW('a', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(not StrMatchCharW('d', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchCharW('acbba', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(not StrMatchCharW('acbd', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchLenW('abcd', ['a', 'b', 'c'], 1) = 3, 'StrMatchLen');
  Assert(StrMatchLenW('abcd', ['a', 'b', 'c'], 3) = 1, 'StrMatchLen');
  Assert(StrMatchLenW('abcd', ['a', 'b', 'c'], 4) = 0, 'StrMatchLen');
  Assert(StrMatchLenW('', ['a', 'b', 'c'], 1) = 0, 'StrMatchLen');
  Assert(StrMatchLenW('dcba', ['a', 'b', 'c'], 2) = 3, 'StrMatchLen');
  Assert(StrMatchLenW('dcba', ['a', 'b', 'c'], 1) = 0, 'StrMatchLen');
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(not StrMatchU('', '', 1), 'StrMatch');
  Assert(not StrMatchU('', 'a', 1), 'StrMatch');
  Assert(not StrMatchU('a', '', 1), 'StrMatch');
  Assert(not StrMatchU('a', 'A', 1), 'StrMatch');
  Assert(StrMatchU('A', 'A', 1), 'StrMatch');
  Assert(not StrMatchU('abcdef', 'xx', 1), 'StrMatch');
  Assert(StrMatchU('xbcdef', 'x', 1), 'StrMatch');
  Assert(StrMatchU('abcdxxxxx', 'xxxxx', 5), 'StrMatch');
  Assert(StrMatchU('abcdef', 'abcdef', 1), 'StrMatch');
  Assert(not StrMatchNoAsciiCaseU('abcdef', 'xx', 1), 'StrMatchNoCase');
  Assert(StrMatchNoAsciiCaseU('xbCDef', 'xBCd', 1), 'StrMatchNoCase');
  Assert(StrMatchNoAsciiCaseU('abcdxxX-xx', 'Xxx-xX', 5), 'StrMatchNoCase');
  Assert(StrMatchU('abcde', 'abcd', 1), 'StrMatch');
  Assert(StrMatchU('abcde', 'abc', 1), 'StrMatch');
  Assert(StrMatchU('abcde', 'ab', 1), 'StrMatch');
  Assert(StrMatchU('abcde', 'a', 1), 'StrMatch');
  Assert(StrMatchNoAsciiCaseU(' abC-Def{', ' AbC-def{', 1), 'StrMatchNoCase');
  Assert(StrMatchLeftU('ABC1D', 'aBc1', False), 'StrMatchLeft');
  Assert(StrMatchLeftU('aBc1D', 'aBc1', True), 'StrMatchLeft');
  Assert(not StrMatchLeftU('AB1D', 'ABc1', False), 'StrMatchLeft');
  Assert(not StrMatchLeftU('aBC1D', 'aBc1', True), 'StrMatchLeft');
  {$IFDEF SupportAnsiChar}
  Assert(not StrMatchCharU('', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchCharU('a', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(not StrMatchCharU('d', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchCharU('acbba', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(not StrMatchCharU('acbd', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchLenU('abcd', ['a', 'b', 'c'], 1) = 3, 'StrMatchLen');
  Assert(StrMatchLenU('abcd', ['a', 'b', 'c'], 3) = 1, 'StrMatchLen');
  Assert(StrMatchLenU('abcd', ['a', 'b', 'c'], 4) = 0, 'StrMatchLen');
  Assert(StrMatchLenU('', ['a', 'b', 'c'], 1) = 0, 'StrMatchLen');
  Assert(StrMatchLenU('dcba', ['a', 'b', 'c'], 2) = 3, 'StrMatchLen');
  Assert(StrMatchLenU('dcba', ['a', 'b', 'c'], 1) = 0, 'StrMatchLen');
  {$ENDIF}
  {$ENDIF}

  Assert(not StrMatch('', '', 1), 'StrMatch');
  Assert(not StrMatch('', 'a', 1), 'StrMatch');
  Assert(not StrMatch('a', '', 1), 'StrMatch');
  Assert(not StrMatch('a', 'A', 1), 'StrMatch');
  Assert(StrMatch('A', 'A', 1), 'StrMatch');
  Assert(not StrMatch('abcdef', 'xx', 1), 'StrMatch');
  Assert(StrMatch('xbcdef', 'x', 1), 'StrMatch');
  Assert(StrMatch('abcdxxxxx', 'xxxxx', 5), 'StrMatch');
  Assert(StrMatch('abcdef', 'abcdef', 1), 'StrMatch');
  Assert(not StrMatchNoAsciiCase('abcdef', 'xx', 1), 'StrMatchNoCase');
  Assert(StrMatchNoAsciiCase('xbCDef', 'xBCd', 1), 'StrMatchNoCase');
  Assert(StrMatchNoAsciiCase('abcdxxX-xx', 'Xxx-xX', 5), 'StrMatchNoCase');
  Assert(StrMatch('abcde', 'abcd', 1), 'StrMatch');
  Assert(StrMatch('abcde', 'abc', 1), 'StrMatch');
  Assert(StrMatch('abcde', 'ab', 1), 'StrMatch');
  Assert(StrMatch('abcde', 'a', 1), 'StrMatch');
  Assert(StrMatchNoAsciiCase(' abC-Def{', ' AbC-def{', 1), 'StrMatchNoCase');
  Assert(StrMatchLeft('ABC1D', 'aBc1', False), 'StrMatchLeft');
  Assert(StrMatchLeft('aBc1D', 'aBc1', True), 'StrMatchLeft');
  Assert(not StrMatchLeft('AB1D', 'ABc1', False), 'StrMatchLeft');
  Assert(not StrMatchLeft('aBC1D', 'aBc1', True), 'StrMatchLeft');
  {$IFDEF SupportAnsiChar}
  Assert(not StrMatchChar('', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchChar('a', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(not StrMatchChar('d', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchChar('acbba', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(not StrMatchChar('acbd', ['a', 'b', 'c']), 'StrMatchChar');
  Assert(StrMatchLen('abcd', ['a', 'b', 'c'], 1) = 3, 'StrMatchLen');
  Assert(StrMatchLen('abcd', ['a', 'b', 'c'], 3) = 1, 'StrMatchLen');
  Assert(StrMatchLen('abcd', ['a', 'b', 'c'], 4) = 0, 'StrMatchLen');
  Assert(StrMatchLen('', ['a', 'b', 'c'], 1) = 0, 'StrMatchLen');
  Assert(StrMatchLen('dcba', ['a', 'b', 'c'], 2) = 3, 'StrMatchLen');
  Assert(StrMatchLen('dcba', ['a', 'b', 'c'], 1) = 0, 'StrMatchLen');
  {$ENDIF}

  { Pos                                                                        }
  {$IFDEF SupportAnsiString}
  Assert(PosStrA('', 'ABCABC') = 0, 'PosStr');
  Assert(PosStrA('', 'a') = 0, 'PosStr');
  Assert(PosStrA('A', '') = 0, 'PosStr');
  Assert(PosStrA('A', 'ABCABC') = 1, 'PosStr');
  Assert(PosStrA('A', 'ABCABC', 2) = 4, 'PosStr');
  Assert(PosStrA('ab', 'a') = 0, 'PosStr');
  Assert(PosStrA('ab', 'ab') = 1, 'PosStr');
  Assert(PosStrA('ab', 'zxab') = 3, 'PosStr');
  Assert(PosStrA('ab', '') = 0, 'PosStr');
  Assert(PosStrA('ab', 'axdba') = 0, 'PosStr');
  Assert(PosStrA('a', 'AbAc', 1, False) = 1, 'PosStr');
  Assert(PosStrA('ba', 'ABAcabac', 1, False) = 2, 'PosStr');
  Assert(PosStrA('a', 'abac', 2) = 3, 'PosStr');
  Assert(PosStrA('ab', 'abacabac', 2) = 5, 'PosStr');
  Assert(PosStrRevA('A', 'ABCABC') = 4, 'PosStrRev');
  Assert(PosStrRevA('A', 'ABCABCA') = 7, 'PosStrRev');
  Assert(PosStrRevA('CA', 'ABCABCA') = 6, 'PosStrRev');
  Assert(PosStrRevA('ab', 'abacabac') = 5, 'PosStrRev');
  Assert(PosNStrA('AB', 'ABCABCDAB', 3) = 8, 'PosNStr');
  Assert(PosCharSetA([], 'a') = 0, 'PosChar');
  Assert(PosCharSetA(['a'], 'a') = 1, 'PosChar');
  Assert(PosCharSetA(['a'], '') = 0, 'PosChar');
  Assert(PosCharSetA(['a'], 'aa') = 1, 'PosChar');
  Assert(PosCharSetA(['a'], 'ba') = 2, 'PosChar');
  Assert(PosCharSetA(['a'], 'zx') = 0, 'PosChar');
  Assert(PosCharA(AnsiChar('a'), 'a') = 1, 'PosChar');
  Assert(PosCharA(AnsiChar('a'), '') = 0, 'PosChar');
  Assert(PosCharA(AnsiChar('a'), 'aa') = 1, 'PosChar');
  Assert(PosCharA(AnsiChar('a'), 'ba') = 2, 'PosChar');
  Assert(PosCharA(AnsiChar('a'), 'zx') = 0, 'PosChar');
  Assert(PosCharSetA(['a'], 'abac', 2) = 3, 'PosChar');
  Assert(PosCharRevA(AnsiChar('a'), 'abac') = 3, 'PosCharRev');
  Assert(PosCharSetRevA(['a'..'z'], 'abac') = 4, 'PosCharRev');
  Assert(PosNotCharA(AnsiChar('a'), 'abac') = 2, 'PosNotChar');
  Assert(PosNotCharSetA(['a'..'z'], 'abac1a') = 5, 'PosNotChar');

  Assert(PosStrB('', 'ABCABC') = 0, 'PosStr');
  Assert(PosStrB('', 'a') = 0, 'PosStr');
  Assert(PosStrB('A', '') = 0, 'PosStr');
  Assert(PosStrB('A', 'ABCABC') = 1, 'PosStr');
  Assert(PosStrB('A', 'ABCABC', 2) = 4, 'PosStr');
  Assert(PosStrB('ab', 'a') = 0, 'PosStr');
  Assert(PosStrB('ab', 'ab') = 1, 'PosStr');
  Assert(PosStrB('ab', 'zxab') = 3, 'PosStr');
  Assert(PosStrB('ab', '') = 0, 'PosStr');
  Assert(PosStrB('ab', 'axdba') = 0, 'PosStr');
  Assert(PosStrB('a', 'AbAc', 1, False) = 1, 'PosStr');
  Assert(PosStrB('ba', 'ABAcabac', 1, False) = 2, 'PosStr');
  Assert(PosStrB('a', 'abac', 2) = 3, 'PosStr');
  Assert(PosStrB('ab', 'abacabac', 2) = 5, 'PosStr');
  Assert(PosStrRevB('A', 'ABCABC') = 4, 'PosStrRev');
  Assert(PosStrRevB('A', 'ABCABCA') = 7, 'PosStrRev');
  Assert(PosStrRevB('CA', 'ABCABCA') = 6, 'PosStrRev');
  Assert(PosStrRevB('ab', 'abacabac') = 5, 'PosStrRev');
  Assert(PosNStrB('AB', 'ABCABCDAB', 3) = 8, 'PosNStr');
  Assert(PosCharSetB([], 'a') = 0, 'PosChar');
  Assert(PosCharSetB(['a'], 'a') = 1, 'PosChar');
  Assert(PosCharSetB(['a'], '') = 0, 'PosChar');
  Assert(PosCharSetB(['a'], 'aa') = 1, 'PosChar');
  Assert(PosCharSetB(['a'], 'ba') = 2, 'PosChar');
  Assert(PosCharSetB(['a'], 'zx') = 0, 'PosChar');
  Assert(PosCharB(AnsiChar('a'), 'a') = 1, 'PosChar');
  Assert(PosCharB(AnsiChar('a'), '') = 0, 'PosChar');
  Assert(PosCharB(AnsiChar('a'), 'aa') = 1, 'PosChar');
  Assert(PosCharB(AnsiChar('a'), 'ba') = 2, 'PosChar');
  Assert(PosCharB(AnsiChar('a'), 'zx') = 0, 'PosChar');
  Assert(PosCharSetB(['a'], 'abac', 2) = 3, 'PosChar');
  Assert(PosCharRevB(AnsiChar('a'), 'abac') = 3, 'PosCharRev');
  Assert(PosCharSetRevB(['a'..'z'], 'abac') = 4, 'PosCharRev');
  Assert(PosNotCharB(AnsiChar('a'), 'abac') = 2, 'PosNotChar');
  Assert(PosNotCharSetB(['a'..'z'], 'abac1a') = 5, 'PosNotChar');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(PosStrW('', 'ABCABC') = 0, 'PosStr');
  Assert(PosStrW('', 'a') = 0, 'PosStr');
  Assert(PosStrW('A', '') = 0, 'PosStr');
  Assert(PosStrW('A', 'ABCABC') = 1, 'PosStr');
  Assert(PosStrW('A', 'ABCABC', 2) = 4, 'PosStr');
  Assert(PosStrW('ab', 'a') = 0, 'PosStr');
  Assert(PosStrW('ab', 'ab') = 1, 'PosStr');
  Assert(PosStrW('ab', 'zxab') = 3, 'PosStr');
  Assert(PosStrW('ab', '') = 0, 'PosStr');
  Assert(PosStrW('ab', 'axdba') = 0, 'PosStr');
  Assert(PosStrW('a', 'AbAc', 1, False) = 1, 'PosStr');
  Assert(PosStrW('ba', 'ABAcabac', 1, False) = 2, 'PosStr');
  Assert(PosStrW('a', 'abac', 2) = 3, 'PosStr');
  Assert(PosStrW('ab', 'abacabac', 2) = 5, 'PosStr');
  Assert(PosStrRevW('A', 'ABCABC') = 4, 'PosStrRev');
  Assert(PosStrRevW('A', 'ABCABCA') = 7, 'PosStrRev');
  Assert(PosStrRevW('CA', 'ABCABCA') = 6, 'PosStrRev');
  Assert(PosStrRevW('ab', 'abacabac') = 5, 'PosStrRev');
  Assert(PosNStrW('AB', 'ABCABCDAB', 3) = 8, 'PosNStr');
  Assert(PosCharSetW([], 'a') = 0, 'PosChar');
  {$IFDEF SupportAnsiChar}
  Assert(PosCharSetW(['a'], 'a') = 1, 'PosChar');
  Assert(PosCharSetW(['a'], '') = 0, 'PosChar');
  Assert(PosCharSetW(['a'], 'aa') = 1, 'PosChar');
  Assert(PosCharSetW(['a'], 'ba') = 2, 'PosChar');
  Assert(PosCharSetW(['a'], 'zx') = 0, 'PosChar');
  Assert(PosCharW(AnsiChar('a'), 'a') = 1, 'PosChar');
  Assert(PosCharW(AnsiChar('a'), '') = 0, 'PosChar');
  Assert(PosCharW(AnsiChar('a'), 'aa') = 1, 'PosChar');
  Assert(PosCharW(AnsiChar('a'), 'ba') = 2, 'PosChar');
  Assert(PosCharW(AnsiChar('a'), 'zx') = 0, 'PosChar');
  Assert(PosCharSetW(['a'], 'abac', 2) = 3, 'PosChar');
  Assert(PosCharRevW(AnsiChar('a'), 'abac') = 3, 'PosCharRev');
  Assert(PosCharSetRevW(['a'..'z'], 'abac') = 4, 'PosCharRev');
  Assert(PosNotCharW(AnsiChar('a'), 'abac') = 2, 'PosNotChar');
  Assert(PosNotCharSetW(['a'..'z'], 'abac1a') = 5, 'PosNotChar');
  {$ENDIF}
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(PosStrU('', 'ABCABC') = 0, 'PosStr');
  Assert(PosStrU('', 'a') = 0, 'PosStr');
  Assert(PosStrU('A', '') = 0, 'PosStr');
  Assert(PosStrU('A', 'ABCABC') = 1, 'PosStr');
  Assert(PosStrU('A', 'ABCABC', 2) = 4, 'PosStr');
  Assert(PosStrU('ab', 'a') = 0, 'PosStr');
  Assert(PosStrU('ab', 'ab') = 1, 'PosStr');
  Assert(PosStrU('ab', 'zxab') = 3, 'PosStr');
  Assert(PosStrU('ab', '') = 0, 'PosStr');
  Assert(PosStrU('ab', 'axdba') = 0, 'PosStr');
  Assert(PosStrU('a', 'AbAc', 1, False) = 1, 'PosStr');
  Assert(PosStrU('ba', 'ABAcabac', 1, False) = 2, 'PosStr');
  Assert(PosStrU('a', 'abac', 2) = 3, 'PosStr');
  Assert(PosStrU('ab', 'abacabac', 2) = 5, 'PosStr');
  Assert(PosStrRevU('A', 'ABCABC') = 4, 'PosStrRev');
  Assert(PosStrRevU('A', 'ABCABCA') = 7, 'PosStrRev');
  Assert(PosStrRevU('CA', 'ABCABCA') = 6, 'PosStrRev');
  Assert(PosStrRevU('ab', 'abacabac') = 5, 'PosStrRev');
  Assert(PosNStrU('AB', 'ABCABCDAB', 3) = 8, 'PosNStr');
  Assert(PosCharSetU([], 'a') = 0, 'PosChar');
  {$IFDEF SupportAnsiChar}
  Assert(PosCharSetU(['a'], 'a') = 1, 'PosChar');
  Assert(PosCharSetU(['a'], '') = 0, 'PosChar');
  Assert(PosCharSetU(['a'], 'aa') = 1, 'PosChar');
  Assert(PosCharSetU(['a'], 'ba') = 2, 'PosChar');
  Assert(PosCharSetU(['a'], 'zx') = 0, 'PosChar');
  Assert(PosCharU(AnsiChar('a'), 'a') = 1, 'PosChar');
  Assert(PosCharU(AnsiChar('a'), '') = 0, 'PosChar');
  Assert(PosCharU(AnsiChar('a'), 'aa') = 1, 'PosChar');
  Assert(PosCharU(AnsiChar('a'), 'ba') = 2, 'PosChar');
  Assert(PosCharU(AnsiChar('a'), 'zx') = 0, 'PosChar');
  Assert(PosCharSetU(['a'], 'abac', 2) = 3, 'PosChar');
  Assert(PosCharRevU(AnsiChar('a'), 'abac') = 3, 'PosCharRev');
  Assert(PosCharSetRevU(['a'..'z'], 'abac') = 4, 'PosCharRev');
  Assert(PosNotCharU(AnsiChar('a'), 'abac') = 2, 'PosNotChar');
  Assert(PosNotCharSetU(['a'..'z'], 'abac1a') = 5, 'PosNotChar');
  {$ENDIF}
  {$ENDIF}

  Assert(PosStr('', 'ABCABC') = 0, 'PosStr');
  Assert(PosStr('', 'a') = 0, 'PosStr');
  Assert(PosStr('A', '') = 0, 'PosStr');
  Assert(PosStr('A', 'ABCABC') = 1, 'PosStr');
  Assert(PosStr('A', 'ABCABC', 2) = 4, 'PosStr');
  Assert(PosStr('ab', 'a') = 0, 'PosStr');
  Assert(PosStr('ab', 'ab') = 1, 'PosStr');
  Assert(PosStr('ab', 'zxab') = 3, 'PosStr');
  Assert(PosStr('ab', '') = 0, 'PosStr');
  Assert(PosStr('ab', 'axdba') = 0, 'PosStr');
  Assert(PosStr('a', 'AbAc', 1, False) = 1, 'PosStr');
  Assert(PosStr('ba', 'ABAcabac', 1, False) = 2, 'PosStr');
  Assert(PosStr('a', 'abac', 2) = 3, 'PosStr');
  Assert(PosStr('ab', 'abacabac', 2) = 5, 'PosStr');
  Assert(PosStrRev('A', 'ABCABC') = 4, 'PosStrRev');
  Assert(PosStrRev('A', 'ABCABCA') = 7, 'PosStrRev');
  Assert(PosStrRev('CA', 'ABCABCA') = 6, 'PosStrRev');
  Assert(PosStrRev('ab', 'abacabac') = 5, 'PosStrRev');
  Assert(PosNStr('AB', 'ABCABCDAB', 3) = 8, 'PosNStr');
  Assert(PosCharSet([], 'a') = 0, 'PosChar');
  {$IFDEF SupportAnsiChar}
  Assert(PosCharSet(['a'], 'a') = 1, 'PosChar');
  Assert(PosCharSet(['a'], '') = 0, 'PosChar');
  Assert(PosCharSet(['a'], 'aa') = 1, 'PosChar');
  Assert(PosCharSet(['a'], 'ba') = 2, 'PosChar');
  Assert(PosCharSet(['a'], 'zx') = 0, 'PosChar');
  Assert(PosChar(AnsiChar('a'), 'a') = 1, 'PosChar');
  Assert(PosChar(AnsiChar('a'), '') = 0, 'PosChar');
  Assert(PosChar(AnsiChar('a'), 'aa') = 1, 'PosChar');
  Assert(PosChar(AnsiChar('a'), 'ba') = 2, 'PosChar');
  Assert(PosChar(AnsiChar('a'), 'zx') = 0, 'PosChar');
  Assert(PosCharSet(['a'], 'abac', 2) = 3, 'PosChar');
  Assert(PosCharRev(AnsiChar('a'), 'abac') = 3, 'PosCharRev');
  Assert(PosCharSetRev(['a'..'z'], 'abac') = 4, 'PosCharRev');
  Assert(PosNotChar(AnsiChar('a'), 'abac') = 2, 'PosNotChar');
  Assert(PosNotCharSet(['a'..'z'], 'abac1a') = 5, 'PosNotChar');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(PosStrW('AB', 'XYZABCAACDEF', 1) = 4, 'PosStrW');
  Assert(PosStrW('AA', 'XYZABCAACDEF', 1) = 7, 'PosStrW');
  Assert(PosStrW('A', 'XYZABCAACDEF', 8) = 8, 'PosStrW');
  Assert(PosStrW('AA', 'XYZABCAACDEF', 8) = 0, 'PosStrW');
  Assert(PosStrW('AAQ', 'XYZABCAACDEF', 1) = 0, 'PosStrW');

  Assert(PosCharW(WideChar('A'), 'XYZABCAACDEF', 1) = 4, 'PosCharW');
  Assert(PosCharW(WideChar('A'), 'XYZABCAACDEF', 5) = 7, 'PosCharW');
  Assert(PosCharW(WideChar('A'), 'XYZABCAACDEF', 8) = 8, 'PosCharW');
  Assert(PosCharW(WideChar('A'), 'XYZABCAACDEF', 9) = 0, 'PosCharW');
  Assert(PosCharW(WideChar('Q'), 'XYZABCAACDEF', 1) = 0, 'PosCharW');
  {$ENDIF}

  { Trim                                                                       }
  {$IFNDEF CLR}
  {$IFDEF SupportAnsiString}
  Assert(StrTrimLeftA('   123   ') = '123   ', 'TrimLeft');
  Assert(StrTrimLeftStrNoCaseA('   123   ', '  ') = ' 123   ', 'TrimLeftStrNoCase');
  Assert(StrTrimRightA('   123   ') = '   123', 'TrimRight');
  Assert(StrTrimRightStrNoCaseA('   123   ', '  ') = '   123 ', 'TrimRightStrNoCase');
  Assert(StrTrimA('   123   ', [' ']) = '123', 'Trim');
  Assert(StrTrimA('', [' ']) = '', 'Trim');
  Assert(StrTrimA('X', [' ']) = 'X', 'Trim');

  Assert(StrTrimLeftB('   123   ') = '123   ', 'TrimLeft');
  Assert(StrTrimLeftStrNoCaseB('   123   ', '  ') = ' 123   ', 'TrimLeftStrNoCase');
  Assert(StrTrimRightB('   123   ') = '   123', 'TrimRight');
  Assert(StrTrimRightStrNoCaseB('   123   ', '  ') = '   123 ', 'TrimRightStrNoCase');
  Assert(StrTrimB('   123   ', [' ']) = '123', 'Trim');
  Assert(StrTrimB('', [' ']) = '', 'Trim');
  Assert(StrTrimB('X', [' ']) = 'X', 'Trim');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(StrTrimLeftW('   123   ') = '123   ', 'TrimLeft');
  Assert(StrTrimLeftStrNoCaseW('   123   ', '  ') = ' 123   ', 'TrimLeftStrNoCase');
  Assert(StrTrimRightW('   123   ') = '   123', 'TrimRight');
  Assert(StrTrimRightStrNoCaseW('   123   ', '  ') = '   123 ', 'TrimRightStrNoCase');
  Assert(StrTrimW('   123   ', [' ']) = '123', 'Trim');
  Assert(StrTrimW('', [' ']) = '', 'Trim');
  Assert(StrTrimW('X', [' ']) = 'X', 'Trim');
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(StrTrimLeftU('   123   ') = '123   ', 'TrimLeft');
  Assert(StrTrimLeftStrNoCaseU('   123   ', '  ') = ' 123   ', 'TrimLeftStrNoCase');
  Assert(StrTrimRightU('   123   ') = '   123', 'TrimRight');
  Assert(StrTrimRightStrNoCaseU('   123   ', '  ') = '   123 ', 'TrimRightStrNoCase');
  Assert(StrTrimU('   123   ', [' ']) = '123', 'Trim');
  Assert(StrTrimU('', [' ']) = '', 'Trim');
  Assert(StrTrimU('X', [' ']) = 'X', 'Trim');
  {$ENDIF}

  Assert(StrTrimLeft('   123   ') = '123   ', 'TrimLeft');
  Assert(StrTrimLeftStrNoCase('   123   ', '  ') = ' 123   ', 'TrimLeftStrNoCase');
  Assert(StrTrimRight('   123   ') = '   123', 'TrimRight');
  Assert(StrTrimRightStrNoCase('   123   ', '  ') = '   123 ', 'TrimRightStrNoCase');
  Assert(StrTrim('   123   ', [' ']) = '123', 'Trim');
  Assert(StrTrim('', [' ']) = '', 'Trim');
  Assert(StrTrim('X', [' ']) = 'X', 'Trim');

  {$IFDEF SupportUnicodeString}
  Assert(StrTrimLeftU(' X ') = 'X ', 'StrTrimLeft');
  Assert(StrTrimRightU(' X ') = ' X', 'StrTrimRight');
  Assert(StrTrimU(' X ') = 'X', 'StrTrim');
  {$ENDIF}
  {$ENDIF}

  { Dup                                                                        }
  {$IFDEF SupportAnsiString}
  Assert(DupStrA('xy', 3) = 'xyxyxy', 'Dup');
  Assert(DupStrA('', 3) = '', 'Dup');
  Assert(DupStrA('a', 0) = '', 'Dup');
  Assert(DupStrA('a', -1) = '', 'Dup');
  C := 'x';
  Assert(DupCharA(C, 6) = 'xxxxxx', 'Dup');
  Assert(DupCharA(C, 0) = '', 'Dup');
  Assert(DupCharA(C, -1) = '', 'Dup');

  Assert(DupStrB('xy', 3) = 'xyxyxy', 'Dup');
  Assert(DupStrB('', 3) = '', 'Dup');
  Assert(DupStrB('a', 0) = '', 'Dup');
  Assert(DupStrB('a', -1) = '', 'Dup');
  C := 'x';
  Assert(DupCharB(C, 6) = 'xxxxxx', 'Dup');
  Assert(DupCharB(C, 0) = '', 'Dup');
  Assert(DupCharB(C, -1) = '', 'Dup');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(DupStrW('xy', 3) = 'xyxyxy', 'Dup');
  Assert(DupStrW('', 3) = '', 'Dup');
  Assert(DupStrW('a', 0) = '', 'Dup');
  Assert(DupStrW('a', -1) = '', 'Dup');
  D := 'x';
  Assert(DupCharW(D, 6) = 'xxxxxx', 'Dup');
  Assert(DupCharW(D, 0) = '', 'Dup');
  Assert(DupCharW(D, -1) = '', 'Dup');
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(DupStrU('xy', 3) = 'xyxyxy', 'Dup');
  Assert(DupStrU('', 3) = '', 'Dup');
  Assert(DupStrU('a', 0) = '', 'Dup');
  Assert(DupStrU('a', -1) = '', 'Dup');
  D := 'x';
  Assert(DupCharU(D, 6) = 'xxxxxx', 'Dup');
  Assert(DupCharU(D, 0) = '', 'Dup');
  Assert(DupCharU(D, -1) = '', 'Dup');
  {$ENDIF}

  Assert(DupStr('xy', 3) = 'xyxyxy', 'Dup');
  Assert(DupStr('', 3) = '', 'Dup');
  Assert(DupStr('a', 0) = '', 'Dup');
  Assert(DupStr('a', -1) = '', 'Dup');
  E := 'x';
  Assert(DupChar(E, 6) = 'xxxxxx', 'Dup');
  Assert(DupChar(E, 0) = '', 'Dup');
  Assert(DupChar(E, -1) = '', 'Dup');

  { Pad                                                                        }
  {$IFDEF SupportAnsiString}
  Assert(StrPadLeftA('xxx', 'y', 6) = 'yyyxxx', 'PadLeft');
  Assert(StrPadLeftA('xxx', 'y', 2, True) = 'xx', 'PadLeft');
  Assert(StrPadLeftA('x', ' ', 3, True) = '  x', 'PadLeft');
  Assert(StrPadLeftA('xabc', ' ', 3, True) = 'xab', 'PadLeft');
  Assert(StrPadRightA('xxx', 'y', 6) = 'xxxyyy', 'PadRight');
  Assert(StrPadRightA('xxx', 'y', 2, True) = 'xx', 'PadRight');
  Assert(StrPadA('xxx', 'y', 7) = 'yyxxxyy', 'Pad');

  Assert(StrPadLeftB('xxx', 'y', 6) = 'yyyxxx', 'PadLeft');
  Assert(StrPadLeftB('xxx', 'y', 2, True) = 'xx', 'PadLeft');
  Assert(StrPadLeftB('x', ' ', 3, True) = '  x', 'PadLeft');
  Assert(StrPadLeftB('xabc', ' ', 3, True) = 'xab', 'PadLeft');
  Assert(StrPadRightB('xxx', 'y', 6) = 'xxxyyy', 'PadRight');
  Assert(StrPadRightB('xxx', 'y', 2, True) = 'xx', 'PadRight');
  Assert(StrPadB('xxx', 'y', 7) = 'yyxxxyy', 'Pad');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(StrPadLeftW('xxx', 'y', 6) = 'yyyxxx', 'PadLeft');
  Assert(StrPadLeftW('xxx', 'y', 2, True) = 'xx', 'PadLeft');
  Assert(StrPadLeftW('x', ' ', 3, True) = '  x', 'PadLeft');
  Assert(StrPadLeftW('xabc', ' ', 3, True) = 'xab', 'PadLeft');
  Assert(StrPadRightW('xxx', 'y', 6) = 'xxxyyy', 'PadRight');
  Assert(StrPadRightW('xxx', 'y', 2, True) = 'xx', 'PadRight');
  Assert(StrPadW('xxx', 'y', 7) = 'yyxxxyy', 'Pad');
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(StrPadLeftU('xxx', 'y', 6) = 'yyyxxx', 'PadLeft');
  Assert(StrPadLeftU('xxx', 'y', 2, True) = 'xx', 'PadLeft');
  Assert(StrPadLeftU('x', ' ', 3, True) = '  x', 'PadLeft');
  Assert(StrPadLeftU('xabc', ' ', 3, True) = 'xab', 'PadLeft');
  Assert(StrPadRightU('xxx', 'y', 6) = 'xxxyyy', 'PadRight');
  Assert(StrPadRightU('xxx', 'y', 2, True) = 'xx', 'PadRight');
  Assert(StrPadU('xxx', 'y', 7) = 'yyxxxyy', 'Pad');
  {$ENDIF}

  Assert(StrPadLeft('xxx', 'y', 6) = 'yyyxxx', 'PadLeft');
  Assert(StrPadLeft('xxx', 'y', 2, True) = 'xx', 'PadLeft');
  Assert(StrPadLeft('x', ' ', 3, True) = '  x', 'PadLeft');
  Assert(StrPadLeft('xabc', ' ', 3, True) = 'xab', 'PadLeft');
  Assert(StrPadRight('xxx', 'y', 6) = 'xxxyyy', 'PadRight');
  Assert(StrPadRight('xxx', 'y', 2, True) = 'xx', 'PadRight');
  Assert(StrPad('xxx', 'y', 7) = 'yyxxxyy', 'Pad');

  { Prefix/Suffix                                                              }
  {$IFDEF SupportAnsiString}
  S := 'ABC';
  StrEnsurePrefixA(S, '\');
  Assert(S = '\ABC', 'StrEnsurePrefix');
  StrEnsureSuffixA(S, '\');
  Assert(S = '\ABC\', 'StrEnsureSuffix');
  StrEnsureNoPrefixA(S, '\');
  Assert(S = 'ABC\', 'StrEnsureNoPrefix');
  StrEnsureNoSuffixA(S, '\');
  Assert(S = 'ABC', 'StrEnsureNoSuffix');
  for I := 0 to 256 do
    begin
      T := DupCharA('A', I);
      S := T;
      StrEnsurePrefixA(S, '\');
      Assert(S = '\' + T, 'StrEnsurePrefix');
      StrEnsureNoPrefixA(S, '\');
      Assert(S = T, 'StrEnsureNoPrefix');
      StrEnsureSuffixA(S, '\');
      Assert(S = T + '\', 'StrEnsureSuffix');
      StrEnsureNoSuffixA(S, '\');
      Assert(S = T, 'StrEnsureSuffix');
    end;
  {$ENDIF}

  { Split                                                                      }
  {$IFDEF SupportAnsiString}
  Assert(StrSplitAtCharA('ABC:X', AnsiChar(':'), S, T), 'StrSplitAtChar');
  Assert(S = 'ABC', 'StrSplitAtChar');
  Assert(T = 'X', 'StrSplitAtChar');
  Assert(not StrSplitAtCharA('ABC:X', AnsiChar(','), S, T), 'StrSplitAtChar');
  Assert(S = 'ABC:X', 'StrSplitAtChar');
  Assert(T = '', 'StrSplitAtChar');

  L := StrSplitA('', ',');
  Assert(Length(L) = 0, 'StrSplit');
  L := StrSplitA('ABC', ',');
  Assert(Length(L) = 1, 'StrSplit');
  Assert(L[0] = 'ABC', 'StrSplit');
  L := StrSplitA('ABC', '');
  Assert(Length(L) = 1, 'StrSplit');
  Assert(L[0] = 'ABC', 'StrSplit');
  L := StrSplitA('A,B,C', ',');
  Assert(Length(L) = 3, 'StrSplit');
  Assert(L[0] = 'A', 'StrSplit');
  Assert(L[1] = 'B', 'StrSplit');
  Assert(L[2] = 'C', 'StrSplit');
  L := StrSplitA('1,23,456', ',');
  Assert(Length(L) = 3, 'StrSplit');
  Assert(L[0] = '1', 'StrSplit');
  Assert(L[1] = '23', 'StrSplit');
  Assert(L[2] = '456', 'StrSplit');
  L := StrSplitA(',1,2,,3,', ',');
  Assert(Length(L) = 6, 'StrSplit');
  Assert(L[0] = '', 'StrSplit');
  Assert(L[1] = '1', 'StrSplit');
  Assert(L[2] = '2', 'StrSplit');
  Assert(L[3] = '', 'StrSplit');
  Assert(L[4] = '3', 'StrSplit');
  Assert(L[5] = '', 'StrSplit');
  L := StrSplitA('1..23..456', '..');
  Assert(Length(L) = 3, 'StrSplit');
  Assert(L[0] = '1', 'StrSplit');
  Assert(L[1] = '23', 'StrSplit');
  Assert(L[2] = '456', 'StrSplit');
  {$ENDIF}

  { Count                                                                      }
  {$IFDEF SupportAnsiString}
  Assert(StrCountCharA('abcxyzdexxyxyz', AnsiChar('x')) = 4);
  Assert(StrCountCharA('abcxyzdexxyxyz', AnsiChar('q')) = 0);
  Assert(StrCountCharA('abcxyzdexxyxyz', ['a'..'z']) = 14);

  Assert(StrCountCharB('abcxyzdexxyxyz', AnsiChar('x')) = 4);
  Assert(StrCountCharB('abcxyzdexxyxyz', AnsiChar('q')) = 0);
  Assert(StrCountCharB('abcxyzdexxyxyz', ['a'..'z']) = 14);
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(StrCountCharW('abcxyzdexxyxyz', WideChar('x')) = 4);
  Assert(StrCountCharW('abcxyzdexxyxyz', WideChar('q')) = 0);
  {$IFDEF SupportAnsiChar}
  Assert(StrCountCharW('abcxyzdexxyxyz', ['a'..'z']) = 14);
  {$ENDIF}
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(StrCountCharU('abcxyzdexxyxyz', WideChar('x')) = 4);
  Assert(StrCountCharU('abcxyzdexxyxyz', WideChar('q')) = 0);
  {$IFDEF SupportAnsiChar}
  Assert(StrCountCharU('abcxyzdexxyxyz', ['a'..'z']) = 14);
  {$ENDIF}
  {$ENDIF}

  Assert(StrCountChar('abcxyzdexxyxyz', Char('x')) = 4);
  Assert(StrCountChar('abcxyzdexxyxyz', Char('q')) = 0);
  {$IFDEF SupportAnsiChar}
  Assert(StrCountChar('abcxyzdexxyxyz', ['a'..'z']) = 14);
  {$ENDIF}

  { Quoting                                                                    }
  {$IFNDEF CLR}
  {$IFDEF SupportAnsiString}
  Assert(StrRemoveSurroundingQuotesA('"123"') = '123', 'StrRemoveSurroundingQuotes');
  Assert(StrRemoveSurroundingQuotesA('"1""23"') = '1""23', 'StrRemoveSurroundingQuotes');
  Assert(StrQuoteA('Abe''s', '''') = '''Abe''''s''', 'StrQuote');
  Assert(StrUnquoteA('"123"') = '123', 'StrUnQuote');
  Assert(StrUnquoteA('"1""23"') = '1"23', 'StrUnQuote');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(StrRemoveSurroundingQuotesW('"123"') = '123', 'StrRemoveSurroundingQuotes');
  Assert(StrRemoveSurroundingQuotesW('"1""23"') = '1""23', 'StrRemoveSurroundingQuotes');
  Assert(StrQuoteW('Abe''s', '''') = '''Abe''''s''', 'StrQuote');
  Assert(StrUnquoteW('"123"') = '123', 'StrUnQuote');
  Assert(StrUnquoteW('"1""23"') = '1"23', 'StrUnQuote');
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(StrRemoveSurroundingQuotesU('"123"') = '123', 'StrRemoveSurroundingQuotes');
  Assert(StrRemoveSurroundingQuotesU('"1""23"') = '1""23', 'StrRemoveSurroundingQuotes');
  Assert(StrQuoteU('Abe''s', '''') = '''Abe''''s''', 'StrQuote');
  Assert(StrUnquoteU('"123"') = '123', 'StrUnQuote');
  Assert(StrUnquoteU('"1""23"') = '1"23', 'StrUnQuote');
  {$ENDIF}

  Assert(StrRemoveSurroundingQuotes('"123"') = '123', 'StrRemoveSurroundingQuotes');
  Assert(StrRemoveSurroundingQuotes('"1""23"') = '1""23', 'StrRemoveSurroundingQuotes');
  Assert(StrQuote('Abe''s', '''') = '''Abe''''s''', 'StrQuote');
  Assert(StrUnquote('"123"') = '123', 'StrUnQuote');
  Assert(StrUnquote('"1""23"') = '1"23', 'StrUnQuote');

  {$IFDEF SupportAnsiString}
  Assert(StrIsQuotedStrA('"ABC""D"'), 'StrIsQuotedStr');
  Assert(StrIsQuotedStrA('"A"'), 'StrIsQuotedStr');
  Assert(not StrIsQuotedStrA('"ABC""D'''), 'StrIsQuotedStr');
  Assert(not StrIsQuotedStrA('"ABC""D'), 'StrIsQuotedStr');
  Assert(not StrIsQuotedStrA('"'), 'StrIsQuotedStr');
  Assert(not StrIsQuotedStrA(''), 'StrIsQuotedStr');
  Assert(StrIsQuotedStrA(''''''), 'StrIsQuotedStr');
  Assert(not StrIsQuotedStrA('''a'''''), 'StrIsQuotedStr');
  {$ENDIF}
  {$ENDIF}

  { Delimited                                                                  }
  {$IFDEF SupportAnsiString}
  Assert(StrAfterA('ABCDEF', 'CD') = 'EF', 'StrAfter');
  Assert(StrAfterA('ABCDEF', 'CE') = '', 'StrAfter');
  Assert(StrAfterA('ABCDEF', 'CE', True) = 'ABCDEF', 'StrAfter');
  Assert(StrAfterRevA('ABCABCABC', 'CA') = 'BC', 'StrAfterRev');
  Assert(StrAfterRevA('ABCABCABC', 'CD') = '', 'StrAfterRev');
  Assert(StrAfterRevA('ABCABCABC', 'CD', True) = 'ABCABCABC', 'StrAfterRev');

  Assert(StrBetweenCharA('ABC', AnsiChar('<'), AnsiChar('>')) = '', 'StrBetweenChar');
  Assert(StrBetweenCharA('ABC<D>', AnsiChar('<'), AnsiChar('>')) = 'D', 'StrBetweenChar');
  Assert(StrBetweenCharA('A*BC*D', AnsiChar('*'), AnsiChar('*')) = 'BC', 'StrBetweenChar');
  Assert(StrBetweenCharA('(ABC)', AnsiChar('('), AnsiChar(')')) = 'ABC', 'StrBetweenChar');
  Assert(StrBetweenCharA('XYZ(ABC)(DEF)', AnsiChar('('), AnsiChar(')')) = 'ABC', 'StrBetweenChar');
  Assert(StrBetweenCharA('XYZ"ABC', AnsiChar('"'), AnsiChar('"')) = '', 'StrBetweenChar');
  Assert(StrBetweenCharA('1234543210', AnsiChar('3'), AnsiChar('3'), False, False) = '454', 'StrBetweenChar');
  Assert(StrBetweenCharA('1234543210', AnsiChar('3'), AnsiChar('4'), False, False) = '', 'StrBetweenChar');
  Assert(StrBetweenCharA('1234543210', AnsiChar('4'), AnsiChar('3'), False, False) = '54', 'StrBetweenChar');
  Assert(StrBetweenCharA('1234543210', AnsiChar('4'), AnsiChar('6'), False, False) = '', 'StrBetweenChar');
  Assert(StrBetweenCharA('1234543210', AnsiChar('4'), AnsiChar('6'), False, True) = '543210', 'StrBetweenChar');
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(StrBetweenCharW('ABC', WideChar('<'), WideChar('>')) = '', 'StrBetweenChar');
  Assert(StrBetweenCharW('ABC<D>', WideChar('<'), WideChar('>')) = 'D', 'StrBetweenChar');
  {$ENDIF}

  Assert(StrBetweenChar('ABC', Char('<'), Char('>')) = '', 'StrBetweenChar');
  Assert(StrBetweenChar('ABC<D>', Char('<'), Char('>')) = 'D', 'StrBetweenChar');

  {$IFDEF SupportAnsiString}
  Assert(StrBetweenA('XYZ(ABC)(DEF)', '(', [')']) = 'ABC', 'StrBetween');
  Assert(StrBetweenA('XYZ(ABC)(DEF)', 'Z(', [')']) = 'ABC', 'StrBetween');

  S := 'XYZ(ABC)<DEF>G"H"IJ"KLM"<N';
  Assert(StrRemoveCharDelimitedA(S, '<', '>') = 'DEF', 'StrRemoveCharDelimited');
  Assert(S = 'XYZ(ABC)G"H"IJ"KLM"<N', 'StrRemoveCharDelimited');
  Assert(StrRemoveCharDelimitedA(S, '<', '>') = '', 'StrRemoveCharDelimited');
  Assert(S = 'XYZ(ABC)G"H"IJ"KLM"<N', 'StrRemoveCharDelimited');
  Assert(StrRemoveCharDelimitedA(S, '(', ')') = 'ABC', 'StrRemoveCharDelimited');
  Assert(S = 'XYZG"H"IJ"KLM"<N', 'StrRemoveCharDelimited');
  Assert(StrRemoveCharDelimitedA(S, '"', '"') = 'H', 'StrRemoveCharDelimited');
  Assert(S = 'XYZGIJ"KLM"<N', 'StrRemoveCharDelimited');
  Assert(StrRemoveCharDelimitedA(S, '"', '"') = 'KLM', 'StrRemoveCharDelimited');
  Assert(S = 'XYZGIJ<N', 'StrRemoveCharDelimited');
  {$ENDIF}

  { Replace                                                                    }
  {$IFDEF SupportAnsiString}
  Assert(StrReplaceCharA(AnsiChar('X'), AnsiChar('A'), '') = '', 'StrReplaceChar');
  Assert(StrReplaceCharA(AnsiChar('X'), AnsiChar('A'), 'XXX') = 'AAA', 'StrReplaceChar');
  Assert(StrReplaceCharA(AnsiChar('X'), AnsiChar('A'), 'X') = 'A', 'StrReplaceChar');
  Assert(StrReplaceCharA(AnsiChar('X'), AnsiChar('!'), 'ABCXXBXAC') = 'ABC!!B!AC', 'StrReplaceChar');
  Assert(StrReplaceCharA(['A', 'B'], AnsiChar('C'), 'ABCDABCD') = 'CCCDCCCD', 'StrReplaceChar');
  Assert(StrReplaceA('', 'A', 'ABCDEF') = 'ABCDEF', 'StrReplace');
  Assert(StrReplaceA('B', 'A', 'ABCDEFEDCBA') = 'AACDEFEDCAA', 'StrReplace');
  Assert(StrReplaceA('BC', '', 'ABCDEFEDCBA') = 'ADEFEDCBA', 'StrReplace');
  Assert(StrReplaceA('A', '', 'ABAABAA') = 'BB', 'StrReplace');
  Assert(StrReplaceA('C', 'D', 'ABAABAA') = 'ABAABAA', 'StrReplace');
  Assert(StrReplaceA('B', 'CC', 'ABAABAA') = 'ACCAACCAA', 'StrReplace');
  Assert(StrReplaceA('a', 'b', 'bababa') = 'bbbbbb', 'StrReplace');
  Assert(StrReplaceA('a', '', 'bababa') = 'bbb', 'StrReplace');
  Assert(StrReplaceA('a', '', 'aaa') = '', 'StrReplace');
  Assert(StrReplaceA('aba', 'x', 'bababa') = 'bxba', 'StrReplace');
  Assert(StrReplaceA('b', 'bb', 'bababa') = 'bbabbabba', 'StrReplace');
  Assert(StrReplaceA('c', 'aa', 'bababa') = 'bababa', 'StrReplace');
  Assert(StrReplaceA('ba', '', 'bababa') = '', 'StrReplace');
  Assert(StrReplaceA('BA', '', 'bababa', False) = '', 'StrReplace');
  Assert(StrReplaceA('BA', 'X', 'bababa', False) = 'XXX', 'StrReplace');
  Assert(StrReplaceA('aa', '12', 'aaaaa') = '1212a', 'StrReplace');
  Assert(StrReplaceA('aa', 'a', 'aaaaa') = 'aaa', 'StrReplace');
  {$IFNDEF CLR}
  Assert(StrReplaceA(['b'], 'z', 'bababa') = 'zazaza', 'StrReplace');
  Assert(StrReplaceA(['b', 'a'], 'z', 'bababa') = 'zzzzzz', 'StrReplace');
  {$ENDIF}
  Assert(StrReplaceA('a', 'b', 'bababa') = 'bbbbbb', 'StrReplace');
  Assert(StrReplaceA('a', '', 'bababa') = 'bbb', 'StrReplace');
  Assert(StrReplaceA('a', '', 'aaa') = '', 'StrReplace');
  S := DupStrA('ABCDEFGH', 100000);
  S := StrReplaceA('BC', 'X', S);
  Assert(S = DupStrA('AXDEFGH', 100000), 'StrReplace');
  Assert(StrRemoveDupA('BBBAABABBA', 'B') = 'BAABABA', 'StrRemoveDup');
  Assert(StrRemoveDupA('azaazzel', 'a') = 'azazzel', 'StrRemoveDup');
  Assert(StrRemoveDupA('BBBAABABBA', 'A') = 'BBBABABBA', 'StrRemoveDup');
  {$IFNDEF CLR}
  Assert(StrRemoveCharSetA('BBBAABABBA', ['B']) = 'AAAA', 'StrRemoveChar');
  {$ENDIF}

  Assert(StrReplaceCharB(AnsiChar('X'), AnsiChar('A'), '') = '', 'StrReplaceChar');
  Assert(StrReplaceCharB(AnsiChar('X'), AnsiChar('A'), 'XXX') = 'AAA', 'StrReplaceChar');
  Assert(StrReplaceCharB(AnsiChar('X'), AnsiChar('A'), 'X') = 'A', 'StrReplaceChar');
  Assert(StrReplaceCharB(AnsiChar('X'), AnsiChar('!'), 'ABCXXBXAC') = 'ABC!!B!AC', 'StrReplaceChar');
  Assert(StrReplaceCharB(['A', 'B'], AnsiChar('C'), 'ABCDABCD') = 'CCCDCCCD', 'StrReplaceChar');
  Assert(StrReplaceB('', 'A', 'ABCDEF') = 'ABCDEF', 'StrReplace');
  Assert(StrReplaceB('B', 'A', 'ABCDEFEDCBA') = 'AACDEFEDCAA', 'StrReplace');
  Assert(StrReplaceB('BC', '', 'ABCDEFEDCBA') = 'ADEFEDCBA', 'StrReplace');
  Assert(StrReplaceB('A', '', 'ABAABAA') = 'BB', 'StrReplace');
  Assert(StrReplaceB('C', 'D', 'ABAABAA') = 'ABAABAA', 'StrReplace');
  Assert(StrReplaceB('B', 'CC', 'ABAABAA') = 'ACCAACCAA', 'StrReplace');
  Assert(StrReplaceB('a', 'b', 'bababa') = 'bbbbbb', 'StrReplace');
  Assert(StrReplaceB('a', '', 'bababa') = 'bbb', 'StrReplace');
  Assert(StrReplaceB('a', '', 'aaa') = '', 'StrReplace');
  Assert(StrReplaceB('aba', 'x', 'bababa') = 'bxba', 'StrReplace');
  Assert(StrReplaceB('b', 'bb', 'bababa') = 'bbabbabba', 'StrReplace');
  Assert(StrReplaceB('c', 'aa', 'bababa') = 'bababa', 'StrReplace');
  Assert(StrReplaceB('ba', '', 'bababa') = '', 'StrReplace');
  Assert(StrReplaceB('BA', '', 'bababa', False) = '', 'StrReplace');
  Assert(StrReplaceB('BA', 'X', 'bababa', False) = 'XXX', 'StrReplace');
  Assert(StrReplaceB('aa', '12', 'aaaaa') = '1212a', 'StrReplace');
  Assert(StrReplaceB('aa', 'a', 'aaaaa') = 'aaa', 'StrReplace');
  {$IFNDEF CLR}
  Assert(StrReplaceB(['b'], 'z', 'bababa') = 'zazaza', 'StrReplace');
  Assert(StrReplaceB(['b', 'a'], 'z', 'bababa') = 'zzzzzz', 'StrReplace');
  {$ENDIF}
  Assert(StrReplaceB('a', 'b', 'bababa') = 'bbbbbb', 'StrReplace');
  Assert(StrReplaceB('a', '', 'bababa') = 'bbb', 'StrReplace');
  Assert(StrReplaceB('a', '', 'aaa') = '', 'StrReplace');
  S := DupStrB('ABCDEFGH', 100000);
  S := StrReplaceB('BC', 'X', S);
  Assert(S = DupStrB('AXDEFGH', 100000), 'StrReplace');
  // Assert(StrRemoveDupB('BBBAABABBA', 'B') = 'BAABABA', 'StrRemoveDup');
  // Assert(StrRemoveDupB('azaazzel', 'a') = 'azazzel', 'StrRemoveDup');
  // Assert(StrRemoveDupB('BBBAABABBA', 'A') = 'BBBABABBA', 'StrRemoveDup');
  {$IFNDEF CLR}
  Assert(StrRemoveCharSetB('BBBAABABBA', ['B']) = 'AAAA', 'StrRemoveChar');
  {$ENDIF}
  {$ENDIF}

  {$IFDEF SupportWideString}
  Assert(StrReplaceCharW(WideChar('X'), WideChar('A'), '') = '', 'StrReplaceChar');
  Assert(StrReplaceCharW(WideChar('X'), WideChar('A'), 'XXX') = 'AAA', 'StrReplaceChar');
  Assert(StrReplaceCharW(WideChar('X'), WideChar('A'), 'X') = 'A', 'StrReplaceChar');
  Assert(StrReplaceCharW(WideChar('X'), WideChar('!'), 'ABCXXBXAC') = 'ABC!!B!AC', 'StrReplaceChar');
  {$IFDEF SupportAnsiString}
  Assert(StrReplaceCharW(['A', 'B'], WideChar('C'), 'ABCDABCD') = 'CCCDCCCD', 'StrReplaceChar');
  {$ENDIF}
  Assert(StrReplaceW('', 'A', 'ABCDEF') = 'ABCDEF', 'StrReplace');
  Assert(StrReplaceW('B', 'A', 'ABCDEFEDCBA') = 'AACDEFEDCAA', 'StrReplace');
  Assert(StrReplaceW('BC', '', 'ABCDEFEDCBA') = 'ADEFEDCBA', 'StrReplace');
  Assert(StrReplaceW('A', '', 'ABAABAA') = 'BB', 'StrReplace');
  Assert(StrReplaceW('C', 'D', 'ABAABAA') = 'ABAABAA', 'StrReplace');
  Assert(StrReplaceW('B', 'CC', 'ABAABAA') = 'ACCAACCAA', 'StrReplace');
  Assert(StrReplaceW('a', 'b', 'bababa') = 'bbbbbb', 'StrReplace');
  Assert(StrReplaceW('a', '', 'bababa') = 'bbb', 'StrReplace');
  Assert(StrReplaceW('a', '', 'aaa') = '', 'StrReplace');
  Assert(StrReplaceW('aba', 'x', 'bababa') = 'bxba', 'StrReplace');
  Assert(StrReplaceW('b', 'bb', 'bababa') = 'bbabbabba', 'StrReplace');
  Assert(StrReplaceW('c', 'aa', 'bababa') = 'bababa', 'StrReplace');
  Assert(StrReplaceW('ba', '', 'bababa') = '', 'StrReplace');
  Assert(StrReplaceW('BA', '', 'bababa', False) = '', 'StrReplace');
  Assert(StrReplaceW('BA', 'X', 'bababa', False) = 'XXX', 'StrReplace');
  Assert(StrReplaceW('aa', '12', 'aaaaa') = '1212a', 'StrReplace');
  Assert(StrReplaceW('aa', 'a', 'aaaaa') = 'aaa', 'StrReplace');
  {$IFNDEF CLR}
  {$IFDEF SupportAnsiString}
  Assert(StrReplaceW(['b'], 'z', 'bababa') = 'zazaza', 'StrReplace');
  Assert(StrReplaceW(['b', 'a'], 'z', 'bababa') = 'zzzzzz', 'StrReplace');
  {$ENDIF}
  {$ENDIF}
  Assert(StrReplaceW('a', 'b', 'bababa') = 'bbbbbb', 'StrReplace');
  Assert(StrReplaceW('a', '', 'bababa') = 'bbb', 'StrReplace');
  Assert(StrReplaceW('a', '', 'aaa') = '', 'StrReplace');
  W := DupStrW('ABCDEFGH', 100000);
  X := StrReplaceW('BC', 'X', W);
  Assert(X = DupStrW('AXDEFGH', 100000), 'StrReplace');
  Assert(StrRemoveDupW('BBBAABABBA', 'B') = 'BAABABA', 'StrRemoveDup');
  Assert(StrRemoveDupW('azaazzel', 'a') = 'azazzel', 'StrRemoveDup');
  Assert(StrRemoveDupW('BBBAABABBA', 'A') = 'BBBABABBA', 'StrRemoveDup');
  {$IFNDEF CLR}
  {$IFDEF SupportAnsiString}
  Assert(StrRemoveCharSetW('BBBAABABBA', ['B']) = 'AAAA', 'StrRemoveChar');
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}

  {$IFDEF SupportUnicodeString}
  Assert(StrReplaceCharU(WideChar('X'), WideChar('A'), '') = '', 'StrReplaceChar');
  Assert(StrReplaceCharU(WideChar('X'), WideChar('A'), 'XXX') = 'AAA', 'StrReplaceChar');
  Assert(StrReplaceCharU(WideChar('X'), WideChar('A'), 'X') = 'A', 'StrReplaceChar');
  Assert(StrReplaceCharU(WideChar('X'), WideChar('!'), 'ABCXXBXAC') = 'ABC!!B!AC', 'StrReplaceChar');
  {$IFDEF SupportAnsiChar}
  Assert(StrReplaceCharU(['A', 'B'], WideChar('C'), 'ABCDABCD') = 'CCCDCCCD', 'StrReplaceChar');
  {$ENDIF}
  Assert(StrReplaceU('', 'A', 'ABCDEF') = 'ABCDEF', 'StrReplace');
  Assert(StrReplaceU('B', 'A', 'ABCDEFEDCBA') = 'AACDEFEDCAA', 'StrReplace');
  Assert(StrReplaceU('BC', '', 'ABCDEFEDCBA') = 'ADEFEDCBA', 'StrReplace');
  Assert(StrReplaceU('A', '', 'ABAABAA') = 'BB', 'StrReplace');
  Assert(StrReplaceU('C', 'D', 'ABAABAA') = 'ABAABAA', 'StrReplace');
  Assert(StrReplaceU('B', 'CC', 'ABAABAA') = 'ACCAACCAA', 'StrReplace');
  Assert(StrReplaceU('a', 'b', 'bababa') = 'bbbbbb', 'StrReplace');
  Assert(StrReplaceU('a', '', 'bababa') = 'bbb', 'StrReplace');
  Assert(StrReplaceU('a', '', 'aaa') = '', 'StrReplace');
  Assert(StrReplaceU('aba', 'x', 'bababa') = 'bxba', 'StrReplace');
  Assert(StrReplaceU('b', 'bb', 'bababa') = 'bbabbabba', 'StrReplace');
  Assert(StrReplaceU('c', 'aa', 'bababa') = 'bababa', 'StrReplace');
  Assert(StrReplaceU('ba', '', 'bababa') = '', 'StrReplace');
  Assert(StrReplaceU('BA', '', 'bababa', False) = '', 'StrReplace');
  Assert(StrReplaceU('BA', 'X', 'bababa', False) = 'XXX', 'StrReplace');
  Assert(StrReplaceU('aa', '12', 'aaaaa') = '1212a', 'StrReplace');
  Assert(StrReplaceU('aa', 'a', 'aaaaa') = 'aaa', 'StrReplace');
  {$IFNDEF CLR}
  {$IFDEF SupportAnsiChar}
  Assert(StrReplaceU(['b'], 'z', 'bababa') = 'zazaza', 'StrReplace');
  Assert(StrReplaceU(['b', 'a'], 'z', 'bababa') = 'zzzzzz', 'StrReplace');
  {$ENDIF}
  {$ENDIF}
  Assert(StrReplaceU('a', 'b', 'bababa') = 'bbbbbb', 'StrReplace');
  Assert(StrReplaceU('a', '', 'bababa') = 'bbb', 'StrReplace');
  Assert(StrReplaceU('a', '', 'aaa') = '', 'StrReplace');
  W := DupStrU('ABCDEFGH', 100000);
  X := StrReplaceU('BC', 'X', W);
  Assert(X = DupStrU('AXDEFGH', 100000), 'StrReplace');
  Assert(StrRemoveDupU('BBBAABABBA', 'B') = 'BAABABA', 'StrRemoveDup');
  Assert(StrRemoveDupU('azaazzel', 'a') = 'azazzel', 'StrRemoveDup');
  Assert(StrRemoveDupU('BBBAABABBA', 'A') = 'BBBABABBA', 'StrRemoveDup');
  {$IFNDEF CLR}
  {$IFDEF SupportAnsiChar}
  Assert(StrRemoveCharSetU('BBBAABABBA', ['B']) = 'AAAA', 'StrRemoveChar');
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}

  Assert(StrReplaceChar(Char('X'), Char('A'), '') = '', 'StrReplaceChar');
  Assert(StrReplaceChar(Char('X'), Char('A'), 'XXX') = 'AAA', 'StrReplaceChar');
  Assert(StrReplaceChar(Char('X'), Char('A'), 'X') = 'A', 'StrReplaceChar');
  Assert(StrReplaceChar(Char('X'), Char('!'), 'ABCXXBXAC') = 'ABC!!B!AC', 'StrReplaceChar');
  {$IFDEF SupportAnsiChar}
  Assert(StrReplaceChar(['A', 'B'], Char('C'), 'ABCDABCD') = 'CCCDCCCD', 'StrReplaceChar');
  {$ENDIF}
  Assert(StrReplace('', 'A', 'ABCDEF') = 'ABCDEF', 'StrReplace');
  Assert(StrReplace('B', 'A', 'ABCDEFEDCBA') = 'AACDEFEDCAA', 'StrReplace');
  Assert(StrReplace('BC', '', 'ABCDEFEDCBA') = 'ADEFEDCBA', 'StrReplace');
  Assert(StrReplace('A', '', 'ABAABAA') = 'BB', 'StrReplace');
  Assert(StrReplace('C', 'D', 'ABAABAA') = 'ABAABAA', 'StrReplace');
  Assert(StrReplace('B', 'CC', 'ABAABAA') = 'ACCAACCAA', 'StrReplace');
  Assert(StrReplace('a', 'b', 'bababa') = 'bbbbbb', 'StrReplace');
  Assert(StrReplace('a', '', 'bababa') = 'bbb', 'StrReplace');
  Assert(StrReplace('a', '', 'aaa') = '', 'StrReplace');
  Assert(StrReplace('aba', 'x', 'bababa') = 'bxba', 'StrReplace');
  Assert(StrReplace('b', 'bb', 'bababa') = 'bbabbabba', 'StrReplace');
  Assert(StrReplace('c', 'aa', 'bababa') = 'bababa', 'StrReplace');
  Assert(StrReplace('ba', '', 'bababa') = '', 'StrReplace');
  Assert(StrReplace('BA', '', 'bababa', False) = '', 'StrReplace');
  Assert(StrReplace('BA', 'X', 'bababa', False) = 'XXX', 'StrReplace');
  Assert(StrReplace('aa', '12', 'aaaaa') = '1212a', 'StrReplace');
  Assert(StrReplace('aa', 'a', 'aaaaa') = 'aaa', 'StrReplace');
  {$IFNDEF CLR}
  {$IFDEF SupportAnsiChar}
  Assert(StrReplace(['b'], 'z', 'bababa') = 'zazaza', 'StrReplace');
  Assert(StrReplace(['b', 'a'], 'z', 'bababa') = 'zzzzzz', 'StrReplace');
  {$ENDIF}
  {$ENDIF}
  Assert(StrReplace('a', 'b', 'bababa') = 'bbbbbb', 'StrReplace');
  Assert(StrReplace('a', '', 'bababa') = 'bbb', 'StrReplace');
  Assert(StrReplace('a', '', 'aaa') = '', 'StrReplace');
  Y := DupStr('ABCDEFGH', 100000);
  Z := StrReplace('BC', 'X', Y);
  Assert(Z = DupStr('AXDEFGH', 100000), 'StrReplace');
  Assert(StrRemoveDup('BBBAABABBA', 'B') = 'BAABABA', 'StrRemoveDup');
  Assert(StrRemoveDup('azaazzel', 'a') = 'azazzel', 'StrRemoveDup');
  Assert(StrRemoveDup('BBBAABABBA', 'A') = 'BBBABABBA', 'StrRemoveDup');
  {$IFNDEF CLR}
  {$IFDEF SupportAnsiChar}
  Assert(StrRemoveCharSet('BBBAABABBA', ['B']) = 'AAAA', 'StrRemoveChar');
  {$ENDIF}
  {$ENDIF}

  {$IFDEF SupportAnsiString}
  Assert(StrReplaceCharStrA('A', '', 'AXAYAA') = 'XY');
  Assert(StrReplaceCharStrA('A', 'B', 'AXAYAA') = 'BXBYBB');
  Assert(StrReplaceCharStrA('A', 'CC', 'AXAYAA') = 'CCXCCYCCCC');
  Assert(StrReplaceCharStrA('A', 'AIJK', 'AXAYAA') = 'AIJKXAIJKYAIJKAIJK');
  {$ENDIF}


  { Escaping                                                                   }
  {$IFDEF SupportAnsiString}
  Assert(StrHexEscapeB('ABCDE', ['C', 'D'], '\\', '//', False, True) =
         'AB\\43//\\44//E', 'StrHexEscape');
  Assert(StrHexEscapeB('ABCDE', ['C', 'E'], '\', '', False, True) =
         'AB\43D\45', 'StrHexEscape');
  Assert(StrHexEscapeB('ABCDE', ['F'], '\', '', False, True) =
         'ABCDE', 'StrHexEscape');
  Assert(StrHexUnescapeB('AB\\43\\44XYZ', '\\') = 'ABCDXYZ', 'StrHexUnescape');
  Assert(StrHexUnescapeB('ABC', '\') = 'ABC', 'StrHexUnescape');
  Assert(StrHexUnescapeB('ABC\44', '\') = 'ABCD', 'StrHexUnescape');
  Assert(StrHexUnescapeB('AB\\43\\44XYZ', '\\') = 'ABCDXYZ', 'StrHexUnescape');
  Assert(StrHexUnescapeB('AB%43%44XYZ', '%') = 'ABCDXYZ', 'StrHexUnescape');
  Assert(StrHexUnescapeB('AB%XYZ', '%') = 'ABXYZ', 'StrHexUnescape');

  Assert(StrCharEscapeA('ABCDE', ['C', 'D'], '\\', ['c', 'd']) =
         'AB\\c\\dE', 'StrCharEscape');
  Assert(StrCharEscapeA('ABCDE', ['C', 'E'], '\', ['c', 'e']) =
         'AB\cD\e', 'StrCharEscape');
  Assert(StrCharEscapeA('ABCDE', ['F'], '\', ['f']) =
         'ABCDE', 'StrCharEscape');
  Assert(StrCharUnescapeA('AB\\c\\dE', '\\', ['c', 'd'], ['C', 'D'], True, True) =
         'ABCDE', 'StrCharUnescape');
  {$ENDIF}
end;
{$ENDIF}



end.

