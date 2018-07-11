{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcASCII.pas                                             }
{   File version:     5.02                                                     }
{   Description:      Ascii utility functions.                                 }
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
{   2000-2017   1.01  Initial versions.                                        }
{   2018/07/11  5.02  Move to flcASCII unit from flcUtils.                     }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 10 Win32                     5.02  2016/01/09                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

{$IFDEF DEBUG}
{$IFDEF TEST}
  {$DEFINE ASCII_TEST}
{$ENDIF}
{$ENDIF}

unit flcASCII;

interface

uses
  flcUtils;



{                                                                              }
{ ASCII constants                                                              }
{                                                                              }
const
  AsciiNULL = AnsiChar(#0);
  AsciiSOH  = AnsiChar(#1);
  AsciiSTX  = AnsiChar(#2);
  AsciiETX  = AnsiChar(#3);
  AsciiEOT  = AnsiChar(#4);
  AsciiENQ  = AnsiChar(#5);
  AsciiACK  = AnsiChar(#6);
  AsciiBEL  = AnsiChar(#7);
  AsciiBS   = AnsiChar(#8);
  AsciiHT   = AnsiChar(#9);
  AsciiLF   = AnsiChar(#10);
  AsciiVT   = AnsiChar(#11);
  AsciiFF   = AnsiChar(#12);
  AsciiCR   = AnsiChar(#13);
  AsciiSO   = AnsiChar(#14);
  AsciiSI   = AnsiChar(#15);
  AsciiDLE  = AnsiChar(#16);
  AsciiDC1  = AnsiChar(#17);
  AsciiDC2  = AnsiChar(#18);
  AsciiDC3  = AnsiChar(#19);
  AsciiDC4  = AnsiChar(#20);
  AsciiNAK  = AnsiChar(#21);
  AsciiSYN  = AnsiChar(#22);
  AsciiETB  = AnsiChar(#23);
  AsciiCAN  = AnsiChar(#24);
  AsciiEM   = AnsiChar(#25);
  AsciiEOF  = AnsiChar(#26);
  AsciiESC  = AnsiChar(#27);
  AsciiFS   = AnsiChar(#28);
  AsciiGS   = AnsiChar(#29);
  AsciiRS   = AnsiChar(#30);
  AsciiUS   = AnsiChar(#31);
  AsciiSP   = AnsiChar(#32);
  AsciiDEL  = AnsiChar(#127);
  AsciiXON  = AsciiDC1;
  AsciiXOFF = AsciiDC3;

  AsciiCRLF = AsciiCR + AsciiLF;

  AsciiDecimalPoint = AnsiChar(#46);
  AsciiComma        = AnsiChar(#44);
  AsciiBackSlash    = AnsiChar(#92);
  AsciiForwardSlash = AnsiChar(#47);
  AsciiPercent      = AnsiChar(#37);
  AsciiAmpersand    = AnsiChar(#38);
  AsciiPlus         = AnsiChar(#43);
  AsciiMinus        = AnsiChar(#45);
  AsciiEqualSign    = AnsiChar(#61);
  AsciiSingleQuote  = AnsiChar(#39);
  AsciiDoubleQuote  = AnsiChar(#34);

  AsciiDigit0 = AnsiChar(#48);
  AsciiDigit9 = AnsiChar(#57);
  AsciiUpperA = AnsiChar(#65);
  AsciiUpperZ = AnsiChar(#90);
  AsciiLowerA = AnsiChar(#97);
  AsciiLowerZ = AnsiChar(#122);



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
{ String compare functions                                                     }
{                                                                              }
{   Returns  -1  if A < B                                                      }
{             0  if A = B                                                      }
{             1  if A > B                                                      }
{                                                                              }
function  CharCompareNoAsciiCaseA(const A, B: AnsiChar): Integer; {$IFDEF UseInline}inline;{$ENDIF}
function  CharCompareNoAsciiCaseW(const A, B: WideChar): Integer; {$IFDEF UseInline}inline;{$ENDIF}
function  CharCompareNoAsciiCase(const A, B: Char): Integer;      {$IFDEF UseInline}inline;{$ENDIF}

function  CharEqualNoAsciiCaseA(const A, B: AnsiChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharEqualNoAsciiCaseW(const A, B: WideChar): Boolean;  {$IFDEF UseInline}inline;{$ENDIF}
function  CharEqualNoAsciiCase(const A, B: Char): Boolean;       {$IFDEF UseInline}inline;{$ENDIF}

function  StrPCompareNoAsciiCaseA(const A, B: PAnsiChar; const Len: Integer): Integer;
function  StrPCompareNoAsciiCaseW(const A, B: PWideChar; const Len: Integer): Integer;
function  StrPCompareNoAsciiCase(const A, B: PChar; const Len: Integer): Integer;

function  StrCompareNoAsciiCaseA(const A, B: AnsiString): Integer;
function  StrCompareNoAsciiCaseB(const A, B: RawByteString): Integer;
function  StrCompareNoAsciiCaseW(const A, B: WideString): Integer;
function  StrCompareNoAsciiCaseU(const A, B: UnicodeString): Integer;
function  StrCompareNoAsciiCase(const A, B: String): Integer;



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

procedure AsciiConvertArrayUpper(var S: AnsiStringArray);
procedure AsciiConvertArrayLower(var S: AnsiStringArray);



{                                                                              }
{ Tests                                                                        }
{                                                                              }
{$IFDEF ASCII_TEST}
procedure Test;
{$ENDIF}



implementation



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
{ Compare                                                                      }
{                                                                              }
function CharCompareNoAsciiCaseA(const A, B: AnsiChar): Integer;
var C, D : AnsiChar;
begin
  C := AnsiChar(AsciiLowCaseLookup[Ord(A)]);
  D := AnsiChar(AsciiLowCaseLookup[Ord(B)]);
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
    Result := AnsiChar(Byte(C) + AsciiCaseDiff)
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
    Result := AnsiChar(Byte(C) - AsciiCaseDiff)
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

procedure AsciiConvertArrayUpper(var S: AnsiStringArray);
var I : Integer;
begin
  for I := 0 to Length(S) - 1 do
    AsciiConvertUpperA(S[I]);
end;

procedure AsciiConvertArrayLower(var S: AnsiStringArray);
var I : Integer;
begin
  for I := 0 to Length(S) - 1 do
    AsciiConvertLowerA(S[I]);
end;



{$IFDEF ASCII_TEST}
{$ASSERTIONS ON}
procedure Test;
var
  W : WideChar;
begin
  Assert(IsAsciiStringA(ToAnsiString('012XYZabc{}_ ')), 'IsUSASCIIString');
  Assert(not IsAsciiStringA(ToAnsiString(#$80)), 'IsUSASCIIString');
  Assert(IsAsciiStringA(ToAnsiString('')), 'IsUSASCIIString');
  Assert(IsAsciiStringW(ToWideString('012XYZabc{}_ ')), 'IsUSASCIIWideString');
  W := WideChar(#$0080);
  Assert(not IsAsciiStringW(W), 'IsUSASCIIWideString');
  W := WideChar($2262);
  Assert(not IsAsciiStringW(W), 'IsUSASCIIWideString');
  Assert(IsAsciiStringW(StrEmptyW), 'IsUSASCIIWideString');

  Assert(IsAsciiCharA(AnsiChar(32)));
  Assert(IsAsciiCharW(#32));
  Assert(IsAsciiChar(#32));

  Assert(not IsAsciiCharA(AnsiChar(128)));
  Assert(not IsAsciiCharW(#128));
  Assert(not IsAsciiChar(#128));
end;
{$ENDIF}



end.
