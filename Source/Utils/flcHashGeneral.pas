{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcHashGeneral.pas                                       }
{   File version:     5.20                                                     }
{   Description:      General hashing functions                                }
{                                                                              }
{   Copyright:        Copyright (c) 1999-2021, David J Butler                  }
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
{   2002/04/02  0.01  Initial version from cUtils unit.                        }
{                     Hash: Checksum, XOR, CRC.                                }
{   2002/04/19  0.02  Added ISBN checksum.                                     }
{   2003/07/26  0.03  Added ELF hashing.                                       }
{   2003/09/08  3.04  Revised for Fundamentals 3.                              }
{   2005/07/22  4.05  Compilable with FreePascal 2.0 Win32 i386.               }
{   2005/08/27  4.06  Revised for Fundamentals 4.                              }
{   2008/04/28  4.07  Added Adler hashing.                                     }
{   2010/06/27  4.08  Compilable with FreePascal 2.4.0 OSX x86-64              }
{   2011/04/02  4.09  Compilable with Delphi 5.                                }
{   2011/10/14  4.10  Compilable with Delphi XE.                               }
{   2016/01/09  5.11  Revised for Fundamentals 5.                              }
{   2018/07/11  5.12  Word32 type changes.                                     }
{   2018/08/12  5.13  String type changes.                                     }
{   2020/05/16  5.14  NativeInt changes.                                       }
{   2020/07/20  5.15  Move generic hash functions to unit flcHashGeneral.      }
{   2020/07/20  5.16  Add Knuth's multiplicative hash.                         }
{   2020/07/20  5.17  Add Fowler–Noll–Vo hash 1a.                              }
{   2020/07/20  5.18  Add fclHash1 functions based on Fowler–Noll–Vo hash 1a.  }
{   2020/07/20  5.19  Add fclHash2 functions based on KeyVast.                 }
{   2020/07/20  5.20  Add fclHash3 functions based on CRC32.                   }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi XE2-10.4 Win32/Win64         5.20  2020/09/21                       }
{   Delphi XE2-10.4 Linux64             5.20  2020/09/21                       }
{   FreePascal 3.0.4 Win64              5.14  2020/06/02                       }
{                                                                              }
{ Definitions:                                                                 }
{                                                                              }
{   Hashes are algorithms for computing condensed representations of           }
{   messages.                                                                  }
{   The condensed representation is called the message digest.                 }
{                                                                              }
{ Hash algorithms:                                                             }
{                                                                              }
{   Algorithm                Digest size (bits)  Uses                          }
{   ------------------------ ------------------  -------------------------     }
{   Checksum                 32                  General                       }
{   XOR8                     8                   General                       }
{   XOR16                    16                  General                       }
{   XOR32                    32                  General                       }
{   CRC16                    16                  General / Error detection     }
{   CRC32                    32                  General / Error detection     }
{   Adler32                  32                  General                       }
{   ELF                      32                  General                       }
{   Knuth                    8/16/24/32          General                       }
{   Fowler–Noll–Vo hash 1a   32/64               General                       }
{   KeyVast                  32/64               General                       }
{                                                                              }
{ Other:                                                                       }
{                                                                              }
{   Algorithm    Type                                                          }
{   ------------ --------------------------------------------------            }
{   ISBN         Check-digit for International Standard Book Number            }
{   LUHN         Check-digit for credit card numbers                           }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

unit flcHashGeneral;

interface

uses
  SysUtils,

  flcStdTypes;



{                                                                              }
{ Checksum hashing                                                             }
{                                                                              }
function  CalcChecksum32(const Buf; const BufSize: NativeInt): Word32; overload;
function  CalcChecksum32B(const Buf: RawByteString): Word32;
function  CalcChecksum32(const Buf: TBytes): Word32; overload;



{                                                                              }
{ XOR hashing                                                                  }
{                                                                              }
function  CalcXOR8(const Buf; const BufSize: NativeInt): Byte; overload;
function  CalcXOR8(const Buf: RawByteString): Byte; overload;

function  CalcXOR16(const Buf; const BufSize: NativeInt): Word16; overload;
function  CalcXOR16(const Buf: RawByteString): Word16; overload;

function  CalcXOR32(const Buf; const BufSize: NativeInt): Word32; overload;
function  CalcXOR32(const Buf: RawByteString): Word32; overload;



{                                                                              }
{ CRC 16 hashing                                                               }
{                                                                              }
{   The theory behind CCITT V.41 CRCs:                                         }
{                                                                              }
{      1. Select the magnitude of the CRC to be used (typically 16 or 32       }
{         bits) and choose the polynomial to use. In the case of 16 bit        }
{         CRCs, the CCITT polynomial is recommended and is                     }
{                                                                              }
{                       16    12    5                                          }
{               G(x) = x   + x   + x  + 1                                      }
{                                                                              }
{         This polynomial traps 100% of 1 bit, 2 bit, odd numbers of bit       }
{         errors, 100% of <= 16 bit burst errors and over 99% of all           }
{         other errors.                                                        }
{                                                                              }
{      2. The CRC is calculated as                                             }
{                               r                                              }
{               D(x) = (M(x) * 2 )  mod G(x)                                   }
{                                                                              }
{         This may be better described as : Add r bits (0 content) to          }
{         the end of M(x). Divide this by G(x) and the remainder is the        }
{         CRC.                                                                 }
{                                                                              }
{      3. Tag the CRC onto the end of M(x).                                    }
{                                                                              }
{      4. To check it, calculate the CRC of the new message D(x), using        }
{         the same process as in 2. above. The newly calculated CRC            }
{         should be zero.                                                      }
{                                                                              }
{   This effectively means that using CRCs, it is possible to calculate a      }
{   series of bits to tag onto the data which makes the data an exact          }
{   multiple of the polynomial.                                                }
{                                                                              }
procedure CRC16Init(var CRC16: Word);
function  CRC16Byte(const CRC16: Word16; const Octet: Byte): Word16;
function  CRC16Buf(const CRC16: Word16; const Buf; const BufSize: NativeInt): Word16;

function  CalcCRC16(const Buf; const BufSize: NativeInt): Word16; overload;
function  CalcCRC16(const Buf: RawByteString): Word16; overload;



{                                                                              }
{ CRC 32 hashing                                                               }
{                                                                              }
procedure SetCRC32Poly(const Poly: Word32);

procedure CRC32Init(var CRC32: Word32);
function  CRC32Byte(const CRC32: Word32; const Octet: Byte): Word32;
function  CRC32Buf(const CRC32: Word32; const Buf; const BufSize: NativeInt): Word32;
function  CRC32BufNoCase(const CRC32: Word32; const Buf; const BufSize: NativeInt): Word32;

function  CalcCRC32(const Buf; const BufSize: NativeInt): Word32; overload;
function  CalcCRC32(const Buf: RawByteString): Word32; overload;



{                                                                              }
{ Adler 32 hashing                                                             }
{                                                                              }
procedure Adler32Init(var Adler32: Word32);
function  Adler32Byte(const Adler32: Word32; const Octet: Byte): Word32;
function  Adler32Buf(const Adler32: Word32; const Buf; const BufSize: NativeInt): Word32;

function  CalcAdler32(const Buf; const BufSize: NativeInt): Word32; overload;
function  CalcAdler32(const Buf: RawByteString): Word32; overload;



{                                                                              }
{ ELF hashing                                                                  }
{                                                                              }
procedure ELFInit(var Digest: Word32);
function  ELFBuf(const Digest: Word32; const Buf; const BufSize: NativeInt): Word32;

function  CalcELF(const Buf; const BufSize: NativeInt): Word32; overload;
function  CalcELF(const Buf: RawByteString): Word32; overload;



{                                                                              }
{ ISBN checksum                                                                }
{                                                                              }
function  IsValidISBN(const S: RawByteString): Boolean;



{                                                                              }
{ LUHN checksum                                                                }
{                                                                              }
{   The LUHN forumula (also known as mod-10) is used in major credit card      }
{   account numbers for validity checking.                                     }
{                                                                              }
function  IsValidLUHN(const S: RawByteString): Boolean;



{                                                                              }
{ Knuth's Multiplicative Hashing                                               }
{                                                                              }
{   int KnuthMultHash(int v, int p)   // p = number of bits in hash            }
{       v *= 2654435761;                                                       }
{       return v >> (32 - p);                                                  }
{                                                                              }
function  KnuthMultHash8(const V: Word32): Byte;
function  KnuthMultHash16(const V: Word32): Word16;
function  KnuthMultHash24(const V: Word32): Word32;
function  KnuthMultHash32(const V: Word32): Word32;



{                                                                              }
{ Fowler–Noll–Vo hash 1a                                                       }
{                                                                              }
{     hash := FNV_offset_basis                                                 }
{     for each byte_of_data to be hashed do                                    }
{         hash := hash XOR byte_of_data                                        }
{         hash := hash × FNV_prime                                             }
{                                                                              }
function  FowlerNollVoHash1a32Buf(const Buf; const BufSize: NativeInt): Word32;
function  FowlerNollVoHash1a64Buf(const Buf; const BufSize: NativeInt): Word64;

function  FowlerNollVoHash1a32Int32(const Value: Int32): Word32;          {$IFDEF UseInline}inline;{$ENDIF}
function  FowlerNollVoHash1a32Int64(const Value: Int64): Word32;          {$IFDEF UseInline}inline;{$ENDIF}
function  FowlerNollVoHash1a64Int64(const Value: Int64): Word64;          {$IFDEF UseInline}inline;{$ENDIF}
function  FowlerNollVoHash1a32NativeInt(const Value: NativeInt): Word32;  {$IFDEF UseInline}inline;{$ENDIF}
function  FowlerNollVoHash1a64NativeInt(const Value: NativeInt): Word64;  {$IFDEF UseInline}inline;{$ENDIF}



{                                                                              }
{ Fundamentals Hash functions                                                  }
{                                                                              }
{   fclHash1 is implemented using Fowler–Noll–Vo hash 1a.                      }
{   fclHash2 is based on the KeyVast hash routines by DJ Butler.               }
{   fclHash3 is based on CRC32 hash.                                           }
{                                                                              }
{   fclHashXString32 is used for Strings and produces a 32 bit hash.           }
{   fclHashXString64 is used for Strings and produces a 64 bit hash.           }
{   fclHashXInteger32 is used for Integers and produces a 32 bit hash.         }
{   fclHashXInteger64 is used for Integers and produces a 64 bit hash.         }
{                                                                              }
function  fclHash1String32(const AStr: String): Word32;                {$IFDEF UseInline}inline;{$ENDIF}
function  fclHash1String32B(const AStr: RawByteString): Word32;        {$IFDEF UseInline}inline;{$ENDIF}
function  fclHash1String64(const AStr: String): Word64;                {$IFDEF UseInline}inline;{$ENDIF}
function  fclHash1String64B(const AStr: RawByteString): Word64;        {$IFDEF UseInline}inline;{$ENDIF}

function  fclHash1Integer32Int32(const Value: Int32): Word32;          {$IFDEF UseInline}inline;{$ENDIF}
function  fclHash1Integer32Int64(const Value: Int64): Word32;          {$IFDEF UseInline}inline;{$ENDIF}
function  fclHash1Integer64Int64(const Value: Int64): Word64;          {$IFDEF UseInline}inline;{$ENDIF}
function  fclHash1Integer32NativeInt(const Value: NativeInt): Word32;  {$IFDEF UseInline}inline;{$ENDIF}
function  fclHash1Integer64NativeInt(const Value: NativeInt): Word64;  {$IFDEF UseInline}inline;{$ENDIF}

function  fclHash1Pointer(const Value: Pointer): NativeInt;            {$IFDEF UseInline}inline;{$ENDIF}

function  fclHash1Buf32(const Buf; const BufSize: NativeInt): Word32;  {$IFDEF UseInline}inline;{$ENDIF}
function  fclHash1Buf64(const Buf; const BufSize: NativeInt): Word64;  {$IFDEF UseInline}inline;{$ENDIF}

function  fclHash2String32(const AStr: String; const AAsciiCaseSensitive: Boolean = True): Word32;
function  fclHash2String32B(const AStr: RawByteString; const AAsciiCaseSensitive: Boolean = True): Word32;
function  fclHash2String64(const AStr: String; const AAsciiCaseSensitive: Boolean = True): Word64;
function  fclHash2String64B(const AStr: RawByteString; const AAsciiCaseSensitive: Boolean = True): Word64;

function  fclHash3HashBuf32(const Buf; const BufSize: NativeInt): Word32;

function  fclHash3String32(const AStr: String; const AAsciiCaseSensitive: Boolean = True): Word32;
function  fclHash3String32B(const AStr: RawByteString; const AAsciiCaseSensitive: Boolean = True): Word32;

function  fclHash3Integer32Int32(const Value: Int32): Word32;
function  fclHash3Integer32Int64(const Value: Int64): Word32;
function  fclHash3Integer32NativeInt(const Value: NativeInt): Word32;  {$IFDEF UseInline}inline;{$ENDIF}

function  fclHash3Pointer32(const Value: Pointer): Word32;             {$IFDEF UseInline}inline;{$ENDIF}

function  fclHash3HashBuf64(const Buf; const BufSize: NativeInt): Word64;

function  fclHash3String64(const AStr: String; const AAsciiCaseSensitive: Boolean = True): Word64;
function  fclHash3String64B(const AStr: RawByteString; const AAsciiCaseSensitive: Boolean = True): Word64;

function  fclHash3Integer64Int64(const Value: Int64): Word64;          {$IFDEF UseInline}inline;{$ENDIF}
function  fclHash3Integer64NativeInt(const Value: NativeInt): Word64;  {$IFDEF UseInline}inline;{$ENDIF}

function  fclHash3Pointer64(const Value: Pointer): Word64;             {$IFDEF UseInline}inline;{$ENDIF}



implementation



{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

{                                                                              }
{ Checksum hashing                                                             }
{                                                                              }
{$IFDEF ASM386_DELPHI}
function CalcChecksum32(const Buf; const BufSize: NativeInt): Word32;
asm
      or eax, eax              // eax = Buf
      jz @fin
      or edx, edx              // edx = BufSize
      jbe @finz
      push esi
      mov esi, eax
      add esi, edx
      xor eax, eax
      xor ecx, ecx
    @l1:
      dec esi
      mov cl, [esi]
      add eax, ecx
      dec edx
      jnz @l1
      pop esi
    @fin:
      ret
    @finz:
      xor eax, eax
end;
{$ELSE}
function CalcChecksum32(const Buf; const BufSize: NativeInt): Word32;
var
  Idx : NativeInt;
  Ptr : PByte;
begin
  Result := 0;
  Ptr := @Buf;
  for Idx := 1 to BufSize do
    begin
      Inc(Result, Ptr^);
      Inc(Ptr);
    end;
end;
{$ENDIF}

function CalcChecksum32B(const Buf: RawByteString): Word32;
begin
  Result := CalcChecksum32(Pointer(Buf)^, Length(Buf));
end;

function CalcChecksum32(const Buf: TBytes): Word32; overload;
begin
  Result := CalcChecksum32(Pointer(Buf)^, Length(Buf));
end;



{                                                                              }
{ XOR hashing                                                                  }
{                                                                              }
{$IFDEF ASM386_DELPHI}
function XOR32Buf(const Buf; const BufSize: NativeInt): Word32;
Asm
      or eax, eax
      jz @fin
      or edx, edx
      jz @finz

      push esi
      mov esi, eax
      xor eax, eax

      mov ecx, edx
      shr ecx, 2
      jz @rest

    @l1:
      xor eax, [esi]
      add esi, 4
      dec ecx
      jnz @l1

    @rest:
      and edx, 3
      jz @finp
      xor al, [esi]
      dec edx
      jz @finp
      inc esi
      xor ah, [esi]
      dec edx
      jz @finp
      inc esi
      mov dl, [esi]
      shl edx, 16
      xor eax, edx

    @finp:
      pop esi
      ret
    @finz:
      xor eax, eax
    @fin:
      ret
end;
{$ELSE}
function XOR32Buf(const Buf; const BufSize: NativeInt): Word32;
var
  Idx  : NativeInt;
  Bits : Byte;
  Ptr  : PByte;
begin
  Result := 0;
  Bits := 0;
  Ptr := @Buf;
  for Idx := 1 to BufSize do
    begin
      Result := Result xor (Byte(Ptr^) shl Bits);
      Inc(Bits, 8);
      if Bits = 32 then
        Bits := 0;
      Inc(Ptr);
    end;
end;
{$ENDIF}

function CalcXOR8(const Buf; const BufSize: NativeInt): Byte;
var
  Hash : Word32;
begin
  Hash := XOR32Buf(Buf, BufSize);
  Result := Byte(Hash) xor
            Byte(Hash shr 8) xor
            Byte(Hash shr 16) xor
            Byte(Hash shr 24);
end;

function CalcXOR8(const Buf: RawByteString): Byte;
begin
  Result := CalcXOR8(Pointer(Buf)^, Length(Buf));
end;

function CalcXOR16(const Buf; const BufSize: NativeInt): Word16;
var
  Hash : Word32;
begin
  Hash := XOR32Buf(Buf, BufSize);
  Result := Word16(Hash) xor
            Word16(Hash shr 16);
end;

function CalcXOR16(const Buf: RawByteString): Word16;
begin
  Result := CalcXOR16(Pointer(Buf)^, Length(Buf));
end;

function CalcXOR32(const Buf; const BufSize: NativeInt): Word32;
begin
  Result := XOR32Buf(Buf, BufSize);
end;

function CalcXOR32(const Buf: RawByteString): Word32;
begin
  Result := XOR32Buf(Pointer(Buf)^, Length(Buf));
end;



{                                                                              }
{ CRC 16 hashing                                                               }
{                                                                              }
const
  CRC16Table : array[Byte] of Word16 = (
    $0000, $1021, $2042, $3063, $4084, $50a5, $60c6, $70e7,
    $8108, $9129, $a14a, $b16b, $c18c, $d1ad, $e1ce, $f1ef,
    $1231, $0210, $3273, $2252, $52b5, $4294, $72f7, $62d6,
    $9339, $8318, $b37b, $a35a, $d3bd, $c39c, $f3ff, $e3de,
    $2462, $3443, $0420, $1401, $64e6, $74c7, $44a4, $5485,
    $a56a, $b54b, $8528, $9509, $e5ee, $f5cf, $c5ac, $d58d,
    $3653, $2672, $1611, $0630, $76d7, $66f6, $5695, $46b4,
    $b75b, $a77a, $9719, $8738, $f7df, $e7fe, $d79d, $c7bc,
    $48c4, $58e5, $6886, $78a7, $0840, $1861, $2802, $3823,
    $c9cc, $d9ed, $e98e, $f9af, $8948, $9969, $a90a, $b92b,
    $5af5, $4ad4, $7ab7, $6a96, $1a71, $0a50, $3a33, $2a12,
    $dbfd, $cbdc, $fbbf, $eb9e, $9b79, $8b58, $bb3b, $ab1a,
    $6ca6, $7c87, $4ce4, $5cc5, $2c22, $3c03, $0c60, $1c41,
    $edae, $fd8f, $cdec, $ddcd, $ad2a, $bd0b, $8d68, $9d49,
    $7e97, $6eb6, $5ed5, $4ef4, $3e13, $2e32, $1e51, $0e70,
    $ff9f, $efbe, $dfdd, $cffc, $bf1b, $af3a, $9f59, $8f78,
    $9188, $81a9, $b1ca, $a1eb, $d10c, $c12d, $f14e, $e16f,
    $1080, $00a1, $30c2, $20e3, $5004, $4025, $7046, $6067,
    $83b9, $9398, $a3fb, $b3da, $c33d, $d31c, $e37f, $f35e,
    $02b1, $1290, $22f3, $32d2, $4235, $5214, $6277, $7256,
    $b5ea, $a5cb, $95a8, $8589, $f56e, $e54f, $d52c, $c50d,
    $34e2, $24c3, $14a0, $0481, $7466, $6447, $5424, $4405,
    $a7db, $b7fa, $8799, $97b8, $e75f, $f77e, $c71d, $d73c,
    $26d3, $36f2, $0691, $16b0, $6657, $7676, $4615, $5634,
    $d94c, $c96d, $f90e, $e92f, $99c8, $89e9, $b98a, $a9ab,
    $5844, $4865, $7806, $6827, $18c0, $08e1, $3882, $28a3,
    $cb7d, $db5c, $eb3f, $fb1e, $8bf9, $9bd8, $abbb, $bb9a,
    $4a75, $5a54, $6a37, $7a16, $0af1, $1ad0, $2ab3, $3a92,
    $fd2e, $ed0f, $dd6c, $cd4d, $bdaa, $ad8b, $9de8, $8dc9,
    $7c26, $6c07, $5c64, $4c45, $3ca2, $2c83, $1ce0, $0cc1,
    $ef1f, $ff3e, $cf5d, $df7c, $af9b, $bfba, $8fd9, $9ff8,
    $6e17, $7e36, $4e55, $5e74, $2e93, $3eb2, $0ed1, $1ef0);

function CRC16Byte(const CRC16: Word16; const Octet: Byte): Word16;
begin
  Result := CRC16Table[Byte(Hi(CRC16) xor Octet)] xor Word16(CRC16 shl 8);
end;

function CRC16Buf(const CRC16: Word16; const Buf; const BufSize: NativeInt): Word16;
var
  Idx : NativeInt;
  Ptr : PByte;
begin
  Result := CRC16;
  Ptr := @Buf;
  for Idx := 1 to BufSize do
    begin
      Result := CRC16Byte(Result, Ptr^);
      Inc(Ptr);
    end;
end;

procedure CRC16Init(var CRC16: Word16);
begin
  CRC16 := $FFFF;
end;

function CalcCRC16(const Buf; const BufSize: NativeInt): Word16;
begin
  CRC16Init(Result);
  Result := CRC16Buf(Result, Buf, BufSize);
end;

function CalcCRC16(const Buf: RawByteString): Word16;
begin
  Result := CalcCRC16(Pointer(Buf)^, Length(Buf));
end;



{                                                                              }
{ CRC 32 hashing                                                               }
{                                                                              }
var
  CRC32TableInit : Boolean = False;
  CRC32Table     : array[Byte] of Word32;
  CRC32Poly      : Word32 = $EDB88320;

procedure InitCRC32Table;
var
  I, J : Byte;
  R    : Word32;
begin
  for I := $00 to $FF do
    begin
      R := I;
      for J := 8 downto 1 do
        if R and 1 <> 0 then
          R := (R shr 1) xor CRC32Poly
        else
          R := R shr 1;
      CRC32Table[I] := R;
    end;
  CRC32TableInit := True;
end;

procedure SetCRC32Poly(const Poly: Word32);
begin
  CRC32Poly := Poly;
  CRC32TableInit := False;
end;

function CalcCRC32Byte(const CRC32: Word32; const Octet: Byte): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := CRC32Table[Byte(CRC32) xor Octet] xor (CRC32 shr 8);
end;

function CRC32Byte(const CRC32: Word32; const Octet: Byte): Word32;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  Result := CalcCRC32Byte(CRC32, Octet);
end;

function CRC32Buf(const CRC32: Word32; const Buf; const BufSize: NativeInt): Word32;
var
  Ptr : PByte;
  Idx : NativeInt;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  Ptr := @Buf;
  Result := CRC32;
  for Idx := 1 to BufSize do
    begin
      Result := CalcCRC32Byte(Result, Ptr^);
      Inc(Ptr);
    end;
end;

function CRC32BufNoCase(const CRC32: Word32; const Buf; const BufSize: NativeInt): Word32;
var
  Ptr : PByte;
  Idx : NativeInt;
  C   : Byte;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  Ptr := @Buf;
  Result := CRC32;
  for Idx := 1 to BufSize do
    begin
      C := Ptr^;
      if C in [Ord('A')..Ord('Z')] then
        C := C or 32;
      Result := CalcCRC32Byte(Result, C);
      Inc(Ptr);
    end;
end;

procedure CRC32Init(var CRC32: Word32);
begin
  CRC32 := $FFFFFFFF;
end;

function CalcCRC32(const Buf; const BufSize: NativeInt): Word32;
begin
  CRC32Init(Result);
  Result := not CRC32Buf(Result, Buf, BufSize);
end;

function CalcCRC32(const Buf: RawByteString): Word32;
begin
  Result := CalcCRC32(Pointer(Buf)^, Length(Buf));
end;



{                                                                              }
{ Adler 32 hashing                                                             }
{                                                                              }
procedure Adler32Init(var Adler32: Word32);
begin
  Adler32 := $00000001;
end;

const
  Adler32Mod = 65521; // largest prime smaller than 65536

function Adler32Byte(const Adler32: Word32; const Octet: Byte): Word32;
var
  A, B : Word32;
begin
  A := Adler32 and $0000FFFF;
  B := Adler32 shr 16;
  Inc(A, Octet);
  Inc(B, A);
  if A >= Adler32Mod then
    Dec(A, Adler32Mod);
  if B >= Adler32Mod then
    Dec(B, Adler32Mod);
  Result := A or (B shl 16);
end;

function Adler32Buf(const Adler32: Word32; const Buf; const BufSize: NativeInt): Word32;
var
  A, B : Word32;
  Ptr  : PByte;
  Idx  : NativeInt;
begin
  A := Adler32 and $0000FFFF;
  B := Adler32 shr 16;
  Ptr := @Buf;
  for Idx := 1 to BufSize do
  begin
    Inc(A, Ptr^);
    Inc(B, A);
    if A >= Adler32Mod then
      Dec(A, Adler32Mod);
    if B >= Adler32Mod then
      Dec(B, Adler32Mod);
    Inc(Ptr);
  end;
  Result := A or (B shl 16);
end;

function CalcAdler32(const Buf; const BufSize: NativeInt): Word32;
begin
  Adler32Init(Result);
  Result := Adler32Buf(Result, Buf, BufSize);
end;

function CalcAdler32(const Buf: RawByteString): Word32;
begin
  Result := CalcAdler32(Pointer(Buf)^, Length(Buf));
end;



{                                                                              }
{ ELF hashing                                                                  }
{                                                                              }
procedure ELFInit(var Digest: Word32);
begin
  Digest := 0;
end;

function ELFBuf(const Digest: Word32; const Buf; const BufSize: NativeInt): Word32;
var
  Idx : NativeInt;
  Ptr : PByte;
  X   : Word32;
begin
  Result := Digest;
  Ptr := @Buf;
  for Idx := 1 to BufSize do
    begin
      Result := (Result shl 4) + Ptr^;
      Inc(Ptr);
      X := Result and $F0000000;
      if X <> 0 then
        Result := Result xor (X shr 24);
      Result := Result and (not X);
    end;
end;

function CalcELF(const Buf; const BufSize: NativeInt): Word32;
begin
  Result := ELFBuf(0, Buf, BufSize);
end;

function CalcELF(const Buf: RawByteString): Word32;
begin
  Result := CalcELF(Pointer(Buf)^, Length(Buf));
end;



{                                                                              }
{ ISBN checksum                                                                }
{                                                                              }
function IsValidISBN(const S: RawByteString): Boolean;
var
  Idx, Len, M, D, C : Integer;
  Ptr : PByte;
begin
  Len := Length(S);
  if Len < 10 then // too few digits
    begin
      Result := False;
      exit;
    end;
  M := 10;
  C := 0;
  Ptr := Pointer(S);
  for Idx := 1 to Len do
    begin
      if (Ptr^ in [Ord('0')..Ord('9')]) or ((M = 1) and (Ptr^ in [Ord('x'), Ord('X')])) then
        begin
          if M = 0 then // too many digits
            begin
              Result := False;
              exit;
            end;
          if Ptr^ in [Ord('x'), Ord('X')] then
            D := 10 else
            D := Ptr^ - Ord('0');
          Inc(C, M * D);
          Dec(M);
        end;
      Inc(Ptr);
    end;
  if M > 0 then // too few digits
    begin
      Result := False;
      exit;
    end;
  Result := C mod 11 = 0;
end;



{                                                                              }
{ LUHN checksum                                                                }
{                                                                              }
function IsValidLUHN(const S: RawByteString): Boolean;
var
  Ptr : PByte;
  Idx, Len, M, C, D : Integer;
  R : Boolean;
begin
  Len := Length(S);
  if Len = 0 then
    begin
      Result := False;
      exit;
    end;
  Ptr := Pointer(S);
  Inc(Ptr, Len - 1);
  C := 0;
  M := 0;
  R := False;
  for Idx := 1 to Len do
    begin
      if Ptr^ in [Ord('0')..Ord('9')] then
        begin
          D := Ptr^ - Ord('0');
          if R then
            begin
              D := D * 2;
              D := (D div 10) + (D mod 10);
            end;
          Inc(C, D);
          Inc(M);
          R := not R;
        end;
      Dec(Ptr);
    end;
  Result := (M >= 1) and (C mod 10 = 0);
end;



{                                                                              }
{ Knuth's Multiplicative Hashing                                               }
{                                                                              }
function KnuthMultHash8(const V: Word32): Byte;
var
  Hash : Word64;
begin
  Hash := Word64(V) * 2654435761;
  Result := Byte(Hash shr 24);
end;

function KnuthMultHash16(const V: Word32): Word16;
var
  Hash : Word64;
begin
  Hash := Word64(V) * 2654435761;
  Result := Word16(Hash shr 16);
end;

function KnuthMultHash24(const V: Word32): Word32;
var
  Hash : Word64;
begin
  Hash := Word64(V) * 2654435761;
  Result := Word16(Hash shr 8);
end;

function KnuthMultHash32(const V: Word32): Word32;
var
  Hash : Word64;
begin
  Hash := Word64(V) * 2654435761;
  Result := Word32(Hash);
end;



{                                                                              }
{ Fowler–Noll–Vo hash 1a                                                       }
{                                                                              }
function FowlerNollVoHash1a32Buf(const Buf; const BufSize: NativeInt): Word32;
var
  Ptr : PByte;
  Idx : NativeInt;
  Hsh : Word32;
  M   : Word64;
begin
  Ptr := @Buf;
  Hsh := 2166136261;
  for Idx := 1 to BufSize do
    begin
      Hsh := Hsh xor Ptr^;
      M := Hsh * 16777619;
      Hsh := Word32(M);
      Inc(Ptr);
    end;
  Result := Hsh;
end;

function FowlerNollVoHash1a64Buf(const Buf; const BufSize: NativeInt): Word64;
var
  Ptr : PByte;
  Idx : NativeInt;
  Hsh : Word64;
begin
  Ptr := @Buf;
  {$IFDEF DELPHI7}
  Int64Rec(Hsh).Lo := $84222325;
  Int64Rec(Hsh).Hi := $CBF29CE4;
  {$ELSE}
  Hsh := 14695981039346656037;
  {$ENDIF}
  for Idx := 1 to BufSize do
    begin
      Hsh := Hsh xor Ptr^;
      Hsh := Word64(Hsh * Word64(1099511628211));
      Inc(Ptr);
    end;
  Result := Hsh;
end;

function FowlerNollVoHash1a32Int32(const Value: Int32): Word32;
begin
  Result := FowlerNollVoHash1a32Buf(Value, SizeOf(Value));
end;

function FowlerNollVoHash1a32Int64(const Value: Int64): Word32;
begin
  Result := FowlerNollVoHash1a32Buf(Value, SizeOf(Value));
end;

function FowlerNollVoHash1a64Int64(const Value: Int64): Word64;
begin
  Result := FowlerNollVoHash1a64Buf(Value, SizeOf(Value));
end;

function FowlerNollVoHash1a32NativeInt(const Value: NativeInt): Word32;
begin
  Result := FowlerNollVoHash1a32Buf(Value, SizeOf(Value));
end;

function FowlerNollVoHash1a64NativeInt(const Value: NativeInt): Word64;
begin
  Result := FowlerNollVoHash1a64Buf(Value, SizeOf(Value));
end;



{                                                                              }
{ Fundamentals Hash functions                                                  }
{                                                                              }

{ FCL Hash1 }

function fclHash1String32(const AStr: String): Word32;
begin
  Result := FowlerNollVoHash1a32Buf(Pointer(AStr)^, Length(AStr) * SizeOf(Char));
end;

function fclHash1String32B(const AStr: RawByteString): Word32;
begin
  Result := FowlerNollVoHash1a32Buf(Pointer(AStr)^, Length(AStr));
end;

function fclHash1String64(const AStr: String): Word64;
begin
  Result := FowlerNollVoHash1a64Buf(Pointer(AStr)^, Length(AStr) * SizeOf(Char));
end;

function fclHash1String64B(const AStr: RawByteString): Word64;
begin
  Result := FowlerNollVoHash1a64Buf(Pointer(AStr)^, Length(AStr));
end;

function fclHash1Integer32Int32(const Value: Int32): Word32;
begin
  Result := FowlerNollVoHash1a32Int32(Value);
end;

function fclHash1Integer32Int64(const Value: Int64): Word32;
begin
  Result := FowlerNollVoHash1a32Int64(Value);
end;

function fclHash1Integer64Int64(const Value: Int64): Word64;
begin
  Result := FowlerNollVoHash1a64Int64(Value);
end;

function fclHash1Integer32NativeInt(const Value: NativeInt): Word32;
begin
  Result := FowlerNollVoHash1a32NativeInt(Value);
end;

function fclHash1Integer64NativeInt(const Value: NativeInt): Word64;
begin
  Result := FowlerNollVoHash1a64NativeInt(Value);
end;

function fclHash1Pointer(const Value: Pointer): NativeInt;
begin
  {$IFDEF NativeIntIs32Bits}
  Result := fclHash1Integer32NativeInt(NativeInt(Value));
  {$ELSE}
  Result := fclHash1Integer64NativeInt(NativeInt(Value));
  {$ENDIF}
end;

function fclHash1Buf32(const Buf; const BufSize: NativeInt): Word32;
begin
  Result := FowlerNollVoHash1a32Buf(Buf, BufSize);
end;

function fclHash1Buf64(const Buf; const BufSize: NativeInt): Word64;
begin
  Result := FowlerNollVoHash1a64Buf(Buf, BufSize);
end;

{ FCL Hash2 }

function fclHash2String32(const AStr: String; const AAsciiCaseSensitive: Boolean): Word32;
var
  Hash : Word32;
  PtrS : PChar;
  Len  : NativeInt;
  Idx  : NativeInt;
  A    : Word32;
  F    : Word32;
  G    : Word32;
begin
  Hash := $5A1F7304;
  Len := Length(AStr);
  A := Word32(Len);
  Hash := Hash xor Word32(A shl 4)
         xor Word32(A shl 11)
         xor Word32(A shl 21)
         xor Word32(A shl 26);
  PtrS := Pointer(AStr);
  for Idx := 1 to Len do
    begin
      F := Ord(PtrS^);
      if not AAsciiCaseSensitive then
        if (F >= Ord('a')) and (F <= Ord('z')) then
          Dec(F, 32);
      A := Word32(Idx);
      F := F xor (F shl 7)
             xor Word32(A shl 5)
             xor Word32(A shl 12);
      F := F xor (F shl 19)
             xor (F shr 13);
      G := Word32(Word32(F * 69069) + 1);
      Hash := Hash xor G;
      Hash := Word32(Word32(Hash shl 5) xor (Hash shr 27));
      Inc(PtrS);
    end;
  Result := Hash;
end;

function fclHash2String32B(const AStr: RawByteString; const AAsciiCaseSensitive: Boolean): Word32;
var
  Hash : Word32;
  PtrS : PByteChar;
  Len  : NativeInt;
  A    : Word32;
  Idx  : NativeInt;
  F    : Word32;
  G    : Word32;
begin
  Hash := $5A1F7304;
  Len := Length(AStr);
  A := Word32(Len);
  Hash := Hash xor Word32(A shl 4)
         xor Word32(A shl 11)
         xor Word32(A shl 21)
         xor Word32(A shl 26);
  PtrS := Pointer(AStr);
  for Idx := 1 to Len do
    begin
      F := Ord(PtrS^);
      if not AAsciiCaseSensitive then
        if (F >= Ord('a')) and (F <= Ord('z')) then
          Dec(F, 32);
      A := Word32(Idx);
      F := F xor (F shl 7)
             xor Word32(A shl 5)
             xor Word32(A shl 12);
      F := F xor (F shl 19)
             xor (F shr 13);
      G := Word32(Word32(F * 69069) + 1);
      Hash := Hash xor G;
      Hash := Word32(Word32(Hash shl 5) xor (Hash shr 27));
      Inc(PtrS);
    end;
  Result := Hash;
end;

const
  RC2Table: array[Byte] of Byte = (
    $D9, $78, $F9, $C4, $19, $DD, $B5, $ED, $28, $E9, $FD, $79, $4A, $A0, $D8, $9D,
    $C6, $7E, $37, $83, $2B, $76, $53, $8E, $62, $4C, $64, $88, $44, $8B, $FB, $A2,
    $17, $9A, $59, $F5, $87, $B3, $4F, $13, $61, $45, $6D, $8D, $09, $81, $7D, $32,
    $BD, $8F, $40, $EB, $86, $B7, $7B, $0B, $F0, $95, $21, $22, $5C, $6B, $4E, $82,
    $54, $D6, $65, $93, $CE, $60, $B2, $1C, $73, $56, $C0, $14, $A7, $8C, $F1, $DC,
    $12, $75, $CA, $1F, $3B, $BE, $E4, $D1, $42, $3D, $D4, $30, $A3, $3C, $B6, $26,
    $6F, $BF, $0E, $DA, $46, $69, $07, $57, $27, $F2, $1D, $9B, $BC, $94, $43, $03,
    $F8, $11, $C7, $F6, $90, $EF, $3E, $E7, $06, $C3, $D5, $2F, $C8, $66, $1E, $D7,
    $08, $E8, $EA, $DE, $80, $52, $EE, $F7, $84, $AA, $72, $AC, $35, $4D, $6A, $2A,
    $96, $1A, $D2, $71, $5A, $15, $49, $74, $4B, $9F, $D0, $5E, $04, $18, $A4, $EC,
    $C2, $E0, $41, $6E, $0F, $51, $CB, $CC, $24, $91, $AF, $50, $A1, $F4, $70, $39,
    $99, $7C, $3A, $85, $23, $B8, $B4, $7A, $FC, $02, $36, $5B, $25, $55, $97, $31,
    $2D, $5D, $FA, $98, $E3, $8A, $92, $AE, $05, $DF, $29, $10, $67, $6C, $BA, $C9,
    $D3, $00, $E6, $CF, $E1, $9E, $A8, $2C, $63, $16, $01, $3F, $58, $E2, $89, $A9,
    $0D, $38, $34, $1B, $AB, $33, $FF, $B0, $BB, $48, $0C, $5F, $B9, $B1, $CD, $2E,
    $C5, $F3, $DB, $47, $E5, $A5, $9C, $77, $0A, $A6, $20, $68, $FE, $7F, $C1, $AD);

// Collision free transformation: Each 64 bit input produces unique 64 bit output.
function TransformHash(const Hash: Word64): Word64;
var
  H   : Word64;
  Ptr : PByte;
  Idx : Integer;
begin
  H := Hash;
  Ptr := @H;
  for Idx := 0 to SizeOf(Word64) - 1 do
    begin
      Ptr^ := RC2Table[Ptr^];
      Inc(Ptr);
    end;
  Result := H;
end;

function fclHash2String64(const AStr: String; const AAsciiCaseSensitive: Boolean): Word64;
var
  Hash   : Word64;
  Len    : NativeInt;
  Idx    : NativeInt;
  Ch     : Char;
  D      : Word64;
  F      : Word64;
  H1, H2 : Word32;
  T1, T2 : Word32;
begin
  Hash := $5A1F7301B3E05962;
  Len := Length(AStr);
  for Idx := 1 to Len do
    begin
      Ch := AStr[Idx];
      D := Ord(Ch);
      if not AAsciiCaseSensitive then
        if (D >= Ord('a')) and (D <= Ord('z')) then
          Dec(D, 32);

      F := D xor (D shl 16) xor (D shl 32) xor (D shl 48);
      Hash := Hash xor F;

      F := Len xor (Word64(Idx) shl 18) xor (Word64(Len) shl 28) xor (Word64(Idx) shl 31);
      Hash := Hash xor F;

      Hash := TransformHash(Hash);

      H1 := Word32(Hash shr 32);
      H2 := Word32(Hash and $FFFFFFFF);

      H1 := Word32(H1 + Word32(Idx) + Word32(D));
      H2 := Word32(H2 + Word32(Idx) + Word32(Len));

      H1 := Word32(H1 * 73 + 1);
      H2 := Word32(H2 * 5 + 79);

      T1 := Word32(H1 shl 11) xor (H1 shr 5) xor Word32(H2 shl 17) xor (H2 shr 19);
      T2 := Word32(H2 shl 7)  xor (H2 shr 3) xor Word32(H1 shl 15) xor (H1 shr 17);

      Hash := (Word64(T1) shl 32) or T2;
    end;

  Result := Hash;
end;

function fclHash2String64B(const AStr: RawByteString; const AAsciiCaseSensitive: Boolean): Word64;
var
  Hash   : Word64;
  Len    : NativeInt;
  Idx    : NativeInt;
  C      : ByteChar;
  D      : Word64;
  F      : Word64;
  H1, H2 : Word32;
  T1, T2 : Word32;
begin
  Hash := $5A1F7301B3E05962;
  Len := Length(AStr);
  for Idx := 1 to Len do
    begin
      C := AStr[Idx];
      D := Ord(C);
      if not AAsciiCaseSensitive then
        if (D >= Ord('a')) and (D <= Ord('z')) then
          Dec(D, 32);

      F := D xor (D shl 16) xor (D shl 32) xor (D shl 48);
      Hash := Hash xor F;

      F := Len xor (Word64(Idx) shl 18) xor (Word64(Len) shl 28) xor (Word64(Idx) shl 31);
      Hash := Hash xor F;

      Hash := TransformHash(Hash);

      H1 := Word32(Hash shr 32);
      H2 := Word32(Hash and $FFFFFFFF);

      H1 := Word32(H1 + Word32(Idx) + Word32(D));
      H2 := Word32(H2 + Word32(Idx) + Word32(Len));

      H1 := Word32(H1 * 73 + 1);
      H2 := Word32(H2 * 5 + 79);

      T1 := Word32(H1 shl 11) xor (H1 shr 5) xor Word32(H2 shl 17) xor (H2 shr 19);
      T2 := Word32(H2 shl 7)  xor (H2 shr 3) xor Word32(H1 shl 15) xor (H1 shr 17);

      Hash := (Word64(T1) shl 32) or T2;
    end;

  Result := Hash;
end;

{ FCL Hash3 }

function fclHash3HashBuf32(const Buf; const BufSize: NativeInt): Word32;
var
  Hash : Word32;
  Ptr  : PByte;
  Idx  : NativeInt;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  Hash := $FFFFFFFF;
  Ptr := @Buf;
  for Idx := 0 to BufSize - 1 do
    begin
      Hash := CRC32Table[Byte(Hash) xor Ptr^] xor (Hash shr 8);
      Inc(Ptr);
    end;
  Result := Hash;
end;

function fclHash3HashBufNoAsciiCase32B(const Buf; const BufSize: NativeInt): Word32;
var
  Hash : Word32;
  Ptr  : PByte;
  C    : Byte;
  Idx  : NativeInt;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  Hash := $FFFFFFFF;
  Ptr := @Buf;
  for Idx := 0 to BufSize - 1 do
    begin
      C := Ptr^;
      if (C >= Ord('a')) and (C <= Ord('z')) then
        Dec(C, 32);
      Hash := CRC32Table[Byte(Hash) xor C] xor (Hash shr 8);
      Inc(Ptr);
    end;
  Result := Hash;
end;

function fclHash3HashBufNoAsciiCase32W(const Buf; const BufLength: NativeInt): Word32;
var
  Hash : Word32;
  Ptr  : PWideChar;
  Ch   : Word16;
  Idx  : NativeInt;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  Hash := $FFFFFFFF;
  Ptr := @Buf;
  for Idx := 0 to BufLength - 1 do
    begin
      Ch := Ord(Ptr^);
      if (Ch >= Ord('a')) and (Ch <= Ord('z')) then
        Dec(Ch, 32);
      Hash := CRC32Table[Byte(Hash) xor Byte(Ch)] xor (Hash shr 8);
      Hash := CRC32Table[Byte(Hash) xor Byte(Ch shr 8)] xor (Hash shr 8);
      Inc(Ptr);
    end;
  Result := Hash;
end;

function fclHash3String32(const AStr: String; const AAsciiCaseSensitive: Boolean): Word32;
begin
  if AAsciiCaseSensitive then
    Result := fclHash3HashBuf32(Pointer(AStr)^, Length(AStr) * SizeOf(Char))
  else
    Result := fclHash3HashBufNoAsciiCase32W(Pointer(AStr)^, Length(AStr));
end;

function fclHash3String32B(const AStr: RawByteString; const AAsciiCaseSensitive: Boolean): Word32;
begin
  if AAsciiCaseSensitive then
    Result := fclHash3HashBuf32(Pointer(AStr)^, Length(AStr) * SizeOf(Char))
  else
    Result := fclHash3HashBufNoAsciiCase32B(Pointer(AStr)^, Length(AStr));
end;

function fclHash3Integer32Int32(const Value: Int32): Word32;
var
  Hash : Word32;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  Hash := $FFFFFFFF;
  Hash := CRC32Table[Byte(Hash) xor Byte(Word32(Value))] xor (Hash shr 8);
  Hash := CRC32Table[Byte(Hash) xor Byte(Word32(Value) shr 8)] xor (Hash shr 8);
  Hash := CRC32Table[Byte(Hash) xor Byte(Word32(Value) shr 16)] xor (Hash shr 8);
  Hash := CRC32Table[Byte(Hash) xor Byte(Word32(Value) shr 24)] xor (Hash shr 8);
  Result := Hash;
end;

function fclHash3Integer32Int64(const Value: Int64): Word32;
var
  Hash : Word32;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  Hash := $FFFFFFFF;
  Hash := CRC32Table[Byte(Hash) xor Byte(Word64(Value))] xor (Hash shr 8);
  Hash := CRC32Table[Byte(Hash) xor Byte(Word64(Value) shr 8)] xor (Hash shr 8);
  Hash := CRC32Table[Byte(Hash) xor Byte(Word64(Value) shr 16)] xor (Hash shr 8);
  Hash := CRC32Table[Byte(Hash) xor Byte(Word64(Value) shr 24)] xor (Hash shr 8);
  Hash := CRC32Table[Byte(Hash) xor Byte(Word64(Value) shr 32)] xor (Hash shr 8);
  Hash := CRC32Table[Byte(Hash) xor Byte(Word64(Value) shr 40)] xor (Hash shr 8);
  Hash := CRC32Table[Byte(Hash) xor Byte(Word64(Value) shr 48)] xor (Hash shr 8);
  Hash := CRC32Table[Byte(Hash) xor Byte(Word64(Value) shr 56)] xor (Hash shr 8);
  Result := Hash;
end;

function fclHash3Integer32NativeInt(const Value: NativeInt): Word32;
begin
  {$IFDEF NativeIntIs32Bits}
  Result := fclHash3Integer32Int32(Value);
  {$ELSE}
  {$IFDEF NativeIntIs64Bits}
  Result := fclHash3Integer32Int64(Value);
  {$ENDIF}
  {$ENDIF}
end;

function fclHash3Pointer32(const Value: Pointer): Word32;
begin
  Result := fclHash3Integer32NativeInt(NativeInt(Value));
end;

function fclHash3HashBuf64(const Buf; const BufSize: NativeInt): Word64;
var
  H1   : Word32;
  H2   : Word32;
  Ptr  : PByte;
  C    : Byte;
  D    : Byte;
  Idx  : NativeInt;
  T1   : Word32;
  T2   : Word32;
  Hash : Word64;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  H1 := $FFFFFFFF;
  H2 := $FFFFFFFF;
  Ptr := @Buf;
  for Idx := 0 to BufSize - 1 do
    begin
      C := Ptr^;
      H1 := CRC32Table[Byte(H1) xor C] xor (H1 shr 8);
      D := not Byte(NativeInt(C) + Idx + BufSize);
      H2 := CRC32Table[Byte(H2) xor D] xor (H2 shr 8);
      Inc(Ptr);
    end;
  T1 := Word32(H1 shl 11) xor (H1 shr 5) xor Word32(H2 shl 17) xor (H2 shr 19);
  T2 := Word32(H2 shl 7)  xor (H2 shr 3) xor Word32(H1 shl 15) xor (H1 shr 17);
  Hash := (Word64(T1) shl 32) or T2;
  Result := Hash;
end;

function fclHash3HashBufNoAsciiCase64B(const Buf; const BufSize: NativeInt): Word64;
var
  H1   : Word32;
  H2   : Word32;
  Ptr  : PByte;
  C    : Byte;
  D    : Byte;
  Idx  : NativeInt;
  T1   : Word32;
  T2   : Word32;
  Hash : Word64;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  H1 := $FFFFFFFF;
  H2 := $FFFFFFFF;
  Ptr := @Buf;
  for Idx := 0 to BufSize - 1 do
    begin
      C := Ptr^;
      if (C >= Ord('a')) and (C <= Ord('z')) then
        Dec(C, 32);
      H1 := CRC32Table[Byte(H1) xor C] xor (H1 shr 8);
      D := not Byte(NativeInt(C) + Idx + BufSize);
      H2 := CRC32Table[Byte(H2) xor D] xor (H2 shr 8);
      Inc(Ptr);
    end;
  T1 := Word32(H1 shl 11) xor (H1 shr 5) xor Word32(H2 shl 17) xor (H2 shr 19);
  T2 := Word32(H2 shl 7)  xor (H2 shr 3) xor Word32(H1 shl 15) xor (H1 shr 17);
  Hash := (Word64(T1) shl 32) or T2;
  Result := Hash;
end;

function fclHash3HashBufNoAsciiCase64W(const Buf; const BufSize: NativeInt): Word64;
var
  H1   : Word32;
  H2   : Word32;
  Ptr  : PWideChar;
  C    : Word16;
  D    : Word16;
  Idx  : NativeInt;
  T1   : Word32;
  T2   : Word32;
  Hash : Word64;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  H1 := $FFFFFFFF;
  H2 := $FFFFFFFF;
  Ptr := @Buf;
  for Idx := 0 to BufSize - 1 do
    begin
      C := Ord(Ptr^);
      if (C >= Ord('a')) and (C <= Ord('z')) then
        Dec(C, 32);
      H1 := CRC32Table[Byte(H1) xor Byte(C)] xor (H1 shr 8);
      H1 := CRC32Table[Byte(H1) xor Byte(C shr 8)] xor (H1 shr 8);
      D := not Byte(NativeInt(C) + Idx + BufSize);
      H2 := CRC32Table[Byte(H2) xor Byte(D)] xor (H2 shr 8);
      H2 := CRC32Table[Byte(H2) xor Byte(D shr 8)] xor (H2 shr 8);
      Inc(Ptr);
    end;
  T1 := Word32(H1 shl 11) xor (H1 shr 5) xor Word32(H2 shl 17) xor (H2 shr 19);
  T2 := Word32(H2 shl 7)  xor (H2 shr 3) xor Word32(H1 shl 15) xor (H1 shr 17);
  Hash := (Word64(T1) shl 32) or T2;
  Result := Hash;
end;

function fclHash3String64(const AStr: String; const AAsciiCaseSensitive: Boolean): Word64;
begin
  if AAsciiCaseSensitive then
    Result := fclHash3HashBuf64(Pointer(AStr)^, Length(AStr) * SizeOf(Char))
  else
    Result := fclHash3HashBufNoAsciiCase64W(Pointer(AStr)^, Length(AStr));
end;

function fclHash3String64B(const AStr: RawByteString; const AAsciiCaseSensitive: Boolean): Word64;
begin
  if AAsciiCaseSensitive then
    Result := fclHash3HashBuf64(Pointer(AStr)^, Length(AStr) * SizeOf(Char))
  else
    Result := fclHash3HashBufNoAsciiCase64B(Pointer(AStr)^, Length(AStr));
end;

function fclHash3Integer64Int64(const Value: Int64): Word64;
begin
  Result := fclHash3HashBuf64(Value, SizeOf(Value));
end;

function fclHash3Integer64NativeInt(const Value: NativeInt): Word64;
begin
  Result := fclHash3HashBuf64(Value, SizeOf(Value));
end;

function fclHash3Pointer64(const Value: Pointer): Word64;
begin
  Result := fclHash3Integer64NativeInt(NativeInt(Value));
end;
{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



end.

