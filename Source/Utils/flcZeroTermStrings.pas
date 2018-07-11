{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcZeroTermStrings.pas                                   }
{   File version:     5.65                                                     }
{   Description:      Zero terminated string utility functions                 }
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
{   1999/10/19  0.01  Initial version.                                         }
{   2017/10/07  5.65  Split from flcStrings unit.                              }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 10 Win32                     5.62  2016/01/09                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

{$IFDEF DEBUG}
{$IFDEF TEST}
  {$DEFINE ZERO_TERM_STRINGS_TEST}
{$ENDIF}
{$ENDIF}

unit flcZeroTermStrings;

interface

uses
  { Fundamentals }
  flcUtils;



{                                                                              }
{ Zero terminated string pointer                                               }
{                                                                              }
type
  PStrZA = PAnsiChar;
  PStrZW = PWideChar;
  PStrZ = PChar;



{                                                                              }
{ Length                                                                       }
{                                                                              }
function  StrZLenA(const S: PAnsiChar): Integer;
function  StrZLenW(const S: PWideChar): Integer;
function  StrZLen(const S: PChar): Integer;



{                                                                              }
{ Conversion                                                                   }
{                                                                              }
function  StrZPasA(const A: PAnsiChar): AnsiString;
function  StrZPasB(const A: PAnsiChar): RawByteString;
function  StrZPasW(const A: PWideChar): WideString;
function  StrZPasU(const A: PWideChar): UnicodeString;
function  StrZPas(const A: PChar): String;



{                                                                              }
{ Match                                                                        }
{                                                                              }
function  StrZMatchLenA(const P: PAnsiChar; const M: CharSet; const MaxLen: Integer = -1): Integer;
function  StrZMatchLenW(const P: PWideChar; const M: CharSet; const MaxLen: Integer = -1): Integer; overload;
function  StrZMatchLenW(const P: PWideChar; const M: TWideCharMatchFunction; const MaxLen: Integer = -1): Integer; overload;

function  StrZMatchStrA(const P: PAnsiChar; const M: AnsiString): Boolean;
function  StrZMatchStrB(const P: PAnsiChar; const M: RawByteString): Boolean;
function  StrZMatchStrW(const P: PWideChar; const M: WideString): Boolean;
function  StrZMatchStrAW(const P: PWideChar; const M: AnsiString): Boolean;
function  StrZMatchStrBW(const P: PWideChar; const M: RawByteString): Boolean;
function  StrZMatchStrU(const P: PWideChar; const M: UnicodeString): Boolean;
function  StrZMatchStr(const P: PChar; const M: String): Boolean;

function  StrZMatchStrNoAsciiCaseA(const P: PAnsiChar; const M: AnsiString): Boolean;
function  StrZMatchStrNoAsciiCaseB(const P: PAnsiChar; const M: RawByteString): Boolean;
function  StrZMatchStrNoAsciiCaseW(const P: PWideChar; const M: WideString): Boolean;
function  StrZMatchStrNoAsciiCaseAW(const P: PWideChar; const M: AnsiString): Boolean;
function  StrZMatchStrNoAsciiCaseBW(const P: PWideChar; const M: RawByteString): Boolean;
function  StrZMatchStrNoAsciiCaseU(const P: PWideChar; const M: UnicodeString): Boolean;
function  StrZMatchStrNoAsciiCase(const P: PChar; const M: String): Boolean;

function  StrZMatchStrNoUnicodeCaseW(const P: PWideChar; const M: WideString): Boolean;
function  StrZMatchStrNoUnicodeCaseU(const P: PWideChar; const M: UnicodeString): Boolean;

function  StrZMatchStrAsciiA(const P: PAnsiChar; const M: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
function  StrZMatchStrAsciiB(const P: PAnsiChar; const M: RawByteString; const AsciiCaseSensitive: Boolean): Boolean;
function  StrZMatchStrAsciiW(const P: PWideChar; const M: WideString; const AsciiCaseSensitive: Boolean): Boolean;
function  StrZMatchStrAsciiAW(const P: PWideChar; const M: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
function  StrZMatchStrAsciiBW(const P: PWideChar; const M: RawByteString; const AsciiCaseSensitive: Boolean): Boolean;
function  StrZMatchStrAsciiU(const P: PWideChar; const M: UnicodeString; const AsciiCaseSensitive: Boolean): Boolean;
function  StrZMatchStrAscii(const P: PChar; const M: String; const AsciiCaseSensitive: Boolean): Boolean;

function  StrZMatchStrUnicodeW(const P: PWideChar; const M: WideString; const UnicodeCaseSensitive: Boolean): Boolean;
function  StrZMatchStrUnicodeU(const P: PWideChar; const M: UnicodeString; const UnicodeCaseSensitive: Boolean): Boolean;



{                                                                              }
{ Pos                                                                          }
{                                                                              }
function  StrZPosCharA(const F: AnsiChar; const S: PAnsiChar): Integer;
function  StrZPosCharW(const F: WideChar; const S: PWideChar): Integer;
function  StrZPosChar(const F: Char; const S: PChar): Integer;

function  StrZPosCharSetA(const F: CharSet; const S: PAnsiChar): Integer;
function  StrZPosCharSetW(const F: CharSet; const S: PWideChar): Integer; overload;
function  StrZPosCharSetW(const F: TWideCharMatchFunction; const S: PWideChar): Integer; overload;
function  StrZPosCharSet(const F: CharSet; const S: PChar): Integer;

function  StrZPosNotCharSetA(const F: CharSet; const S: PAnsiChar): Integer;
function  StrZPosNotCharSetW(const F: CharSet; const S: PWideChar): Integer; overload;
function  StrZPosNotCharSetW(const F: TWideCharMatchFunction; const S: PWideChar): Integer; overload;
function  StrZPosNotCharSet(const F: CharSet; const S: PChar): Integer;

function  StrZPosA(const F: AnsiString; const S: PAnsiChar): Integer;
function  StrZPosB(const F: RawByteString; const S: PAnsiChar): Integer;
function  StrZPosW(const F: WideString; const S: PWideChar): Integer;
function  StrZPosAW(const F: AnsiString; const S: PWideChar): Integer;



{                                                                              }
{ Skip                                                                         }
{                                                                              }
function  StrZSkipCharA(var P: PAnsiChar; const C: AnsiChar): Boolean; overload;
function  StrZSkipCharA(var P: PAnsiChar; const C: CharSet): Boolean; overload;

function  StrZSkipCharW(var P: PWideChar; const C: WideChar): Boolean; overload;
function  StrZSkipCharW(var P: PWideChar; const C: CharSet): Boolean; overload;
function  StrZSkipCharW(var P: PWideChar; const C: TWideCharMatchFunction): Boolean; overload;

function  StrZSkipChar(var P: PChar; const C: Char): Boolean; overload;
function  StrZSkipChar(var P: PChar; const C: CharSet): Boolean; overload;

function  StrZSkipAllA(var P: PAnsiChar; const C: AnsiChar): Integer; overload;
function  StrZSkipAllA(var P: PAnsiChar; const C: CharSet): Integer; overload;

function  StrZSkipAllW(var P: PWideChar; const C: WideChar): Integer; overload;
function  StrZSkipAllW(var P: PWideChar; const C: CharSet): Integer; overload;
function  StrZSkipAllW(var P: PWideChar; const C: TWideCharMatchFunction): Integer; overload;

function  StrZSkipAll(var P: PChar; const C: Char): Integer; overload;
function  StrZSkipAll(var P: PChar; const C: CharSet): Integer; overload;

function  StrZSkipToCharA(var P: PAnsiChar; const C: AnsiChar): Integer; overload;
function  StrZSkipToCharA(var P: PAnsiChar; const C: CharSet): Integer; overload;
function  StrZSkipToCharW(var P: PWideChar; const C: WideChar): Integer; overload;
function  StrZSkipToCharW(var P: PWideChar; const C: CharSet): Integer; overload;
function  StrZSkipToCharW(var P: PWideChar; const C: TWideCharMatchFunction): Integer; overload;
function  StrZSkipToChar(var P: PChar; const C: CharSet): Integer;

function  StrZSkipToStrA(var P: PAnsiChar; const S: AnsiString; const AsciiCaseSensitive: Boolean = True): Integer;
function  StrZSkipToStrB(var P: PAnsiChar; const S: RawByteString; const AsciiCaseSensitive: Boolean = True): Integer;
function  StrZSkipToStrW(var P: PWideChar; const S: WideString; const AsciiCaseSensitive: Boolean = True): Integer;
function  StrZSkipToStrAW(var P: PWideChar; const S: AnsiString; const AsciiCaseSensitive: Boolean = True): Integer;
function  StrZSkipToStr(var P: PChar; const S: String; const AsciiCaseSensitive: Boolean = True): Integer;

function  StrZSkip2CharSeq(var P: PAnsiChar; const S1, S2: CharSet): Boolean;
function  StrZSkip3CharSeq(var P: PAnsiChar; const S1, S2, S3: CharSet): Boolean;

function  StrZSkipStrA(var P: PAnsiChar; const S: AnsiString; const AsciiCaseSensitive: Boolean = True): Boolean;
function  StrZSkipStrB(var P: PAnsiChar; const S: RawByteString; const AsciiCaseSensitive: Boolean = True): Boolean;
function  StrZSkipStrW(var P: PWideChar; const S: WideString; const AsciiCaseSensitive: Boolean = True): Boolean;
function  StrZSkipStrAW(var P: PWideChar; const S: AnsiString; const AsciiCaseSensitive: Boolean = True): Boolean;
function  StrZSkipStr(var P: PChar; const S: String; const AsciiCaseSensitive: Boolean = True): Boolean;



{                                                                              }
{ Extract                                                                      }
{                                                                              }
function  StrZExtractAllA(var P: PAnsiChar; const C: AnsiChar): AnsiString; overload;
function  StrZExtractAllA(var P: PAnsiChar; const C: CharSet): AnsiString; overload;

function  StrZExtractAllW(var P: PWideChar; const C: WideChar): WideString; overload;
function  StrZExtractAllW(var P: PWideChar; const C: CharSet): WideString; overload;
function  StrZExtractAllW(var P: PWideChar; const C: TWideCharMatchFunction): WideString; overload;

function  StrZExtractAllU(var P: PWideChar; const C: WideChar): UnicodeString; overload;
function  StrZExtractAllU(var P: PWideChar; const C: CharSet): UnicodeString; overload;
function  StrZExtractAllU(var P: PWideChar; const C: TWideCharMatchFunction): UnicodeString; overload;

function  StrZExtractAll(var P: PChar; const C: Char): String; overload;
function  StrZExtractAll(var P: PChar; const C: CharSet): String; overload;

function  StrZExtractToA(var P: PAnsiChar; const C: AnsiChar): AnsiString; overload;
function  StrZExtractToA(var P: PAnsiChar; const C: CharSet): AnsiString; overload;
function  StrZExtractToW(var P: PWideChar; const C: WideChar): WideString; overload;
function  StrZExtractToW(var P: PWideChar; const C: CharSet): WideString; overload;
function  StrZExtractToW(var P: PWideChar; const C: TWideCharMatchFunction): WideString; overload;
function  StrZExtractToU(var P: PWideChar; const C: WideChar): UnicodeString; overload;
function  StrZExtractToU(var P: PWideChar; const C: CharSet): UnicodeString; overload;
function  StrZExtractToU(var P: PWideChar; const C: TWideCharMatchFunction): UnicodeString; overload;
function  StrZExtractTo(var P: PChar; const C: CharSet): String;

function  StrZExtractToStrA(var P: PAnsiChar; const S: AnsiString; const CaseSensitive: Boolean = True): AnsiString;
function  StrZExtractToStrB(var P: PAnsiChar; const S: RawByteString; const CaseSensitive: Boolean = True): RawByteString;
function  StrZExtractToStrW(var P: PWideChar; const S: WideString; const CaseSensitive: Boolean = True): WideString;
function  StrZExtractToStrAW(var P: PWideChar; const S: AnsiString; const CaseSensitive: Boolean = True): WideString;
function  StrZExtractToStrU(var P: PWideChar; const S: UnicodeString; const CaseSensitive: Boolean = True): UnicodeString;
function  StrZExtractToStrAU(var P: PWideChar; const S: AnsiString; const CaseSensitive: Boolean = True): UnicodeString;
function  StrZExtractToStr(var P: PChar; const S: String; const CaseSensitive: Boolean = True): String;

const
  zchSingleQuote  = AnsiChar('''');
  zchDoubleQuote  = AnsiChar('"');
  zcsQuotes       = [zchSingleQuote, zchDoubleQuote];

function  StrZExtractQuotedA(var P: PAnsiChar; var S: AnsiString; const Quote: CharSet = zcsQuotes): Boolean;
function  StrZExtractQuotedB(var P: PAnsiChar; var S: RawByteString; const Quote: CharSet = zcsQuotes): Boolean;
function  StrZExtractQuotedW(var P: PWideChar; var S: WideString; const Quote: CharSet = zcsQuotes): Boolean;
function  StrZExtractQuotedU(var P: PWideChar; var S: UnicodeString; const Quote: CharSet = zcsQuotes): Boolean;
function  StrZExtractQuoted(var P: PChar; var S: String; const Quote: CharSet = zcsQuotes): Boolean;



implementation

uses
  { Fundamentals }
  flcASCII,
  flcCharSet,
  flcUnicodeChar;



{                                                                              }
{ Length                                                                       }
{                                                                              }
function StrZLenA(const S: PAnsiChar): Integer;
var P : PAnsiChar;
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



{                                                                              }
{ Conversion                                                                   }
{                                                                              }
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

function StrZPasB(const A: PAnsiChar): RawByteString;
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

function StrZPasW(const A: PWideChar): WideString;
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
{ Match                                                                        }
{                                                                              }
function StrZMatchLenA(const P: PAnsiChar; const M: CharSet; const MaxLen: Integer): Integer;
var Q : PAnsiChar;
    L : Integer;
    C : AnsiChar;
begin
  Q := P;
  L := MaxLen;
  Result := 0;
  if not Assigned(Q) then
    exit;
  while L <> 0 do
    begin
      C := Q^;
      if Ord(C) = 0 then
        exit;
      if C in M then
        begin
          Inc(Q);
          if L > 0 then
            Dec(L);
          Inc(Result);
        end
      else
        exit;
    end;
end;

function StrZMatchLenW(const P: PWideChar; const M: CharSet; const MaxLen: Integer): Integer;
var Q : PWideChar;
    L : Integer;
    C : WideChar;
begin
  Q := P;
  L := MaxLen;
  Result := 0;
  if not Assigned(Q) then
    exit;
  while L <> 0 do
    begin
      C := Q^;
      if C = #0 then
        exit;
      if WideCharInCharSet(C, M) then
        begin
          Inc(Q);
          if L > 0 then
            Dec(L);
          Inc(Result);
        end
      else
        exit;
    end;
end;

function StrZMatchLenW(const P: PWideChar; const M: TWideCharMatchFunction; const MaxLen: Integer): Integer;
var Q : PWideChar;
    L : Integer;
    C : WideChar;
begin
  Q := P;
  L := MaxLen;
  Result := 0;
  if not Assigned(Q) then
    exit;
  while L <> 0 do
    begin
      C := Q^;
      if C = #0 then
        exit;
      if M(C) then
        begin
          Inc(Q);
          if L > 0 then
            Dec(L);
          Inc(Result);
        end
      else
        exit;
    end;
end;

function StrZMatchStrA(const P: PAnsiChar; const M: AnsiString): Boolean;
var T, Q : PAnsiChar;
    I, L : Integer;
    C    : AnsiChar;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if (Ord(C) = 0) or (C <> Q^) then
        begin
          Result := False;
          exit;
        end else
        begin
          Inc(T);
          Inc(Q);
        end;
    end;
  Result := True;
end;

function StrZMatchStrB(const P: PAnsiChar; const M: RawByteString): Boolean;
var T, Q : PAnsiChar;
    I, L : Integer;
    C    : AnsiChar;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if (Ord(C) = 0) or (C <> Q^) then
        begin
          Result := False;
          exit;
        end else
        begin
          Inc(T);
          Inc(Q);
        end;
    end;
  Result := True;
end;

function StrZMatchStrW(const P: PWideChar; const M: WideString): Boolean;
var T, Q : PWideChar;
    I, L : Integer;
    C    : WideChar;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if (C = #0) or (C <> Q^) then
        begin
          Result := False;
          exit;
        end else
        begin
          Inc(T);
          Inc(Q);
        end;
    end;
  Result := True;
end;

function StrZMatchStrAW(const P: PWideChar; const M: AnsiString): Boolean;
var T    : PWideChar;
    Q    : PAnsiChar;
    I, L : Integer;
    C    : WideChar;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if (C = #0) or (Ord(C) <> Ord(Q^)) then
        begin
          Result := False;
          exit;
        end else
        begin
          Inc(T);
          Inc(Q);
        end;
    end;
  Result := True;
end;

function StrZMatchStrBW(const P: PWideChar; const M: RawByteString): Boolean;
var T    : PWideChar;
    Q    : PAnsiChar;
    I, L : Integer;
    C    : WideChar;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if (C = #0) or (Ord(C) <> Ord(Q^)) then
        begin
          Result := False;
          exit;
        end else
        begin
          Inc(T);
          Inc(Q);
        end;
    end;
  Result := True;
end;

function StrZMatchStrU(const P: PWideChar; const M: UnicodeString): Boolean;
var T, Q : PWideChar;
    I, L : Integer;
    C    : WideChar;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if (C = #0) or (C <> Q^) then
        begin
          Result := False;
          exit;
        end else
        begin
          Inc(T);
          Inc(Q);
        end;
    end;
  Result := True;
end;

function StrZMatchStr(const P: PChar; const M: String): Boolean;
var T, Q : PChar;
    I, L : Integer;
    C    : Char;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if (C = #0) or (C <> Q^) then
        begin
          Result := False;
          exit;
        end else
        begin
          Inc(T);
          Inc(Q);
        end;
    end;
  Result := True;
end;

function StrZMatchStrNoAsciiCaseA(const P: PAnsiChar; const M: AnsiString): Boolean;
var T, Q : PByte;
    I, L : Integer;
    C, D : Byte;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := Pointer(P);
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if C = 0 then
        begin
          Result := False;
          exit;
        end;
      D := Q^;
      if C <> D then
        begin
          C := AsciiLowCaseLookup[C];
          D := AsciiLowCaseLookup[D];
          if C <> D then
            begin
              Result := False;
              exit;
            end;
        end;
      Inc(T);
      Inc(Q);
    end;
  Result := True;
end;

function StrZMatchStrNoAsciiCaseB(const P: PAnsiChar; const M: RawByteString): Boolean;
var T, Q : PByte;
    I, L : Integer;
    C, D : Byte;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := Pointer(P);
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if C = 0 then
        begin
          Result := False;
          exit;
        end;
      D := Q^;
      if C <> D then
        begin
          C := AsciiLowCaseLookup[C];
          D := AsciiLowCaseLookup[D];
          if C <> D then
            begin
              Result := False;
              exit;
            end;
        end;
      Inc(T);
      Inc(Q);
    end;
  Result := True;
end;

function StrZMatchStrNoAsciiCaseW(const P: PWideChar; const M: WideString): Boolean;
var T, Q : PWideChar;
    I, L : Integer;
    C, D : WideChar;
    E, F : Byte;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if C = #0 then
        begin
          Result := False;
          exit;
        end;
      D := Q^;
      if C <> D then
        begin
          if (Ord(C) >= $80) or (Ord(D) >= $80) then
            begin
              Result := False;
              exit;
            end;
          E := AsciiLowCaseLookup[Ord(C)];
          F := AsciiLowCaseLookup[Ord(D)];
          if E <> F then
            begin
              Result := False;
              exit;
            end;
        end;
      Inc(T);
      Inc(Q);
    end;
  Result := True;
end;

function StrZMatchStrNoAsciiCaseAW(const P: PWideChar; const M: AnsiString): Boolean;
var T    : PWideChar;
    Q    : PAnsiChar;
    I, L : Integer;
    C    : WideChar;
    D    : AnsiChar;
    E, F : Byte;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if C = #0 then
        begin
          Result := False;
          exit;
        end;
      D := Q^;
      if Ord(C) <> Ord(D) then
        begin
          if (Ord(C) >= $80) or (Ord(D) >= $80) then
            begin
              Result := False;
              exit;
            end;
          E := AsciiLowCaseLookup[Ord(C)];
          F := AsciiLowCaseLookup[Ord(D)];
          if E <> F then
            begin
              Result := False;
              exit;
            end;
        end;
      Inc(T);
      Inc(Q);
    end;
  Result := True;
end;

function StrZMatchStrNoAsciiCaseBW(const P: PWideChar; const M: RawByteString): Boolean;
var T    : PWideChar;
    Q    : PAnsiChar;
    I, L : Integer;
    C    : WideChar;
    D    : AnsiChar;
    E, F : Byte;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if C = #0 then
        begin
          Result := False;
          exit;
        end;
      D := Q^;
      if Ord(C) <> Ord(D) then
        begin
          if (Ord(C) >= $80) or (Ord(D) >= $80) then
            begin
              Result := False;
              exit;
            end;
          E := AsciiLowCaseLookup[Ord(C)];
          F := AsciiLowCaseLookup[Ord(D)];
          if E <> F then
            begin
              Result := False;
              exit;
            end;
        end;
      Inc(T);
      Inc(Q);
    end;
  Result := True;
end;

function StrZMatchStrNoAsciiCaseU(const P: PWideChar; const M: UnicodeString): Boolean;
var T, Q : PWideChar;
    I, L : Integer;
    C, D : WideChar;
    E, F : Byte;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if C = #0 then
        begin
          Result := False;
          exit;
        end;
      D := Q^;
      if C <> D then
        begin
          if (Ord(C) >= $80) or (Ord(D) >= $80) then
            begin
              Result := False;
              exit;
            end;
          E := AsciiLowCaseLookup[Ord(C)];
          F := AsciiLowCaseLookup[Ord(D)];
          if E <> F then
            begin
              Result := False;
              exit;
            end;
        end;
      Inc(T);
      Inc(Q);
    end;
  Result := True;
end;

function StrZMatchStrNoAsciiCase(const P: PChar; const M: String): Boolean;
var T, Q : PChar;
    I, L : Integer;
    C, D : Char;
    E, F : Byte;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if C = #0 then
        begin
          Result := False;
          exit;
        end;
      D := Q^;
      if C <> D then
        begin
          {$IFDEF StringIsUnicode}
          if (Ord(C) >= $80) or (Ord(D) >= $80) then
            begin
              Result := False;
              exit;
            end;
          {$ENDIF}
          E := AsciiLowCaseLookup[Ord(C)];
          F := AsciiLowCaseLookup[Ord(D)];
          if E <> F then
            begin
              Result := False;
              exit;
            end;
        end;
      Inc(T);
      Inc(Q);
    end;
  Result := True;
end;

function StrZMatchStrNoUnicodeCaseW(const P: PWideChar; const M: WideString): Boolean;
var T, Q : PWideChar;
    I, L : Integer;
    C, D : WideChar;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if C = #0 then
        begin
          Result := False;
          exit;
        end;
      D := Q^;
      if not UnicodeCharIsEqualNoCase(C, D) then
        begin
          Result := False;
          exit;
        end;
      Inc(T);
      Inc(Q);
    end;
  Result := True;
end;

function StrZMatchStrNoUnicodeCaseU(const P: PWideChar; const M: UnicodeString): Boolean;
var T, Q : PWideChar;
    I, L : Integer;
    C, D : WideChar;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  T := P;
  Q := Pointer(M);
  for I := 1 to L do
    begin
      C := T^;
      if C = #0 then
        begin
          Result := False;
          exit;
        end;
      D := Q^;
      if not UnicodeCharIsEqualNoCase(C, D) then
        begin
          Result := False;
          exit;
        end;
      Inc(T);
      Inc(Q);
    end;
  Result := True;
end;

function StrZMatchStrAsciiA(const P: PAnsiChar; const M: AnsiString;
    const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrZMatchStrA(P, M)
  else
    Result := StrZMatchStrNoAsciiCaseA(P, M);
end;

function StrZMatchStrAsciiB(const P: PAnsiChar; const M: RawByteString;
    const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrZMatchStrB(P, M)
  else
    Result := StrZMatchStrNoAsciiCaseB(P, M);
end;

function StrZMatchStrAsciiW(const P: PWideChar; const M: WideString;
    const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrZMatchStrW(P, M)
  else
    Result := StrZMatchStrNoAsciiCaseW(P, M);
end;

function StrZMatchStrAsciiAW(const P: PWideChar; const M: AnsiString;
    const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrZMatchStrAW(P, M)
  else
    Result := StrZMatchStrNoAsciiCaseAW(P, M);
end;

function StrZMatchStrAsciiBW(const P: PWideChar; const M: RawByteString;
    const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrZMatchStrBW(P, M)
  else
    Result := StrZMatchStrNoAsciiCaseBW(P, M);
end;

function StrZMatchStrAsciiU(const P: PWideChar; const M: UnicodeString;
    const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrZMatchStrU(P, M)
  else
    Result := StrZMatchStrNoAsciiCaseU(P, M);
end;

function StrZMatchStrAscii(const P: PChar; const M: String; const AsciiCaseSensitive: Boolean): Boolean;
begin
  if AsciiCaseSensitive then
    Result := StrZMatchStr(P, M)
  else
    Result := StrZMatchStrNoAsciiCase(P, M);
end;

function StrZMatchStrUnicodeW(const P: PWideChar; const M: WideString; const UnicodeCaseSensitive: Boolean): Boolean;
begin
  if UnicodeCaseSensitive then
    Result := StrZMatchStrW(P, M)
  else
    Result := StrZMatchStrNoUnicodeCaseW(P, M);
end;

function StrZMatchStrUnicodeU(const P: PWideChar; const M: UnicodeString; const UnicodeCaseSensitive: Boolean): Boolean;
begin
  if UnicodeCaseSensitive then
    Result := StrZMatchStrU(P, M)
  else
    Result := StrZMatchStrNoUnicodeCaseU(P, M);
end;



{                                                                              }
{ Pos                                                                          }
{                                                                              }
function StrZPosCharA(const F: AnsiChar; const S: PAnsiChar): Integer;
var C : AnsiChar;
    P : PAnsiChar;
begin
  if not Assigned(S) or (Ord(F) = 0) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      C := P^;
      while C <> F do
        if Ord(C) = 0 then
          begin
            Result := -1;
            exit;
          end
        else
          begin
            Inc(Result);
            Inc(P);
            C := P^;
          end;
    end;
end;

function StrZPosCharW(const F: WideChar; const S: PWideChar): Integer;
var C : WideChar;
    P : PWideChar;
begin
  if not Assigned(S) or (F = #0) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      C := P^;
      while C <> F do
        if C = #0 then
          begin
            Result := -1;
            exit;
          end
        else
          begin
            Inc(Result);
            Inc(P);
            C := P^;
          end;
    end;
end;

function StrZPosChar(const F: Char; const S: PChar): Integer;
var C : Char;
    P : PChar;
begin
  if not Assigned(S) or (F = #0) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      C := P^;
      while C <> F do
        if C = #0 then
          begin
            Result := -1;
            exit;
          end
        else
          begin
            Inc(Result);
            Inc(P);
            C := P^;
          end;
    end;
end;

function StrZPosCharSetA(const F: CharSet; const S: PAnsiChar): Integer;
var C : AnsiChar;
    P : PAnsiChar;
begin
  if not Assigned(S) or (F = []) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      repeat
        C := P^;
        if Ord(C) = 0 then
          begin
            Result := -1;
            exit;
          end;
        if C in F then
          break;
        Inc(Result);
        Inc(P);
      until False;
    end;
end;

function StrZPosCharSetW(const F: CharSet; const S: PWideChar): Integer;
var C : WideChar;
    P : PWideChar;
begin
  if not Assigned(S) or (F = []) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      repeat
        C := P^;
        if C = #0 then
          begin
            Result := -1;
            exit;
          end;
        if Ord(C) <= $FF then
          if AnsiChar(Ord(C)) in F then
            break;
        Inc(Result);
        Inc(P);
      until False;
    end;
end;

function StrZPosCharSetW(const F: TWideCharMatchFunction; const S: PWideChar): Integer;
var C : WideChar;
    P : PWideChar;
begin
  if not Assigned(S) or not Assigned(F) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      repeat
        C := P^;
        if C = #0 then
          begin
            Result := -1;
            exit;
          end;
        if F(C) then
          break;
        Inc(Result);
        Inc(P);
      until False;
    end;
end;

function StrZPosCharSet(const F: CharSet; const S: PChar): Integer;
var C : Char;
    P : PChar;
begin
  if not Assigned(S) or (F = []) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      repeat
        C := P^;
        if C = #0 then
          begin
            Result := -1;
            exit;
          end;
        {$IFDEF StringIsUnicode}
        if Ord(C) <= $FF then
          if AnsiChar(Ord(C)) in F then
            break;
        {$ELSE}
        if C in F then
          break;
        {$ENDIF}
        Inc(Result);
        Inc(P);
      until False;
    end;
end;

function StrZPosNotCharSetA(const F: CharSet; const S: PAnsiChar): Integer;
var C : AnsiChar;
    P : PAnsiChar;
begin
  if not Assigned(S) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      repeat
        C := P^;
        if Ord(C) = 0 then
          begin
            Result := -1;
            exit;
          end;
        if not (C in F) then
          break;
        Inc(Result);
        Inc(P);
      until False;
    end;
end;

function StrZPosNotCharSetW(const F: CharSet; const S: PWideChar): Integer;
var C : WideChar;
    P : PWideChar;
begin
  if not Assigned(S) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      repeat
        C := P^;
        if C = #0 then
          begin
            Result := -1;
            exit;
          end;
        if Ord(C) >= $100 then
          break;
        if not (AnsiChar(Ord(C)) in F) then
          break;
        Inc(Result);
        Inc(P);
      until False;
    end;
end;

function StrZPosNotCharSetW(const F: TWideCharMatchFunction; const S: PWideChar): Integer;
var C : WideChar;
    P : PWideChar;
begin
  if not Assigned(S) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      repeat
        C := P^;
        if C = #0 then
          begin
            Result := -1;
            exit;
          end;
        if not F(C) then
          break;
        Inc(Result);
        Inc(P);
      until False;
    end;
end;

function StrZPosNotCharSet(const F: CharSet; const S: PChar): Integer;
var C : Char;
    P : PChar;
begin
  if not Assigned(S) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      repeat
        C := P^;
        if C = #0 then
          begin
            Result := -1;
            exit;
          end;
        {$IFDEF StringIsUnicode}
        if Ord(C) >= $100 then
          break;
        if not (AnsiChar(Ord(C)) in F) then
          break;
        {$ELSE}
        if not (C in F) then
          break;
        {$ENDIF}
        Inc(Result);
        Inc(P);
      until False;
    end;
end;

function StrZPosA(const F: AnsiString; const S: PAnsiChar): Integer;
var C : AnsiChar;
    P : PAnsiChar;
begin
  if not Assigned(S) or (Length(F) = 0) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      repeat
        C := P^;
        if Ord(C) = 0 then
          begin
            Result := -1;
            exit;
          end;
        if StrZMatchStrA(P, F) then
          break;
        Inc(Result);
        Inc(P);
      until False;
    end;
end;

function StrZPosB(const F: RawByteString; const S: PAnsiChar): Integer;
var C : AnsiChar;
    P : PAnsiChar;
begin
  if not Assigned(S) or (Length(F) = 0) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      repeat
        C := P^;
        if Ord(C) = 0 then
          begin
            Result := -1;
            exit;
          end;
        if StrZMatchStrB(P, F) then
          break;
        Inc(Result);
        Inc(P);
      until False;
    end;
end;

function StrZPosW(const F: WideString; const S: PWideChar): Integer;
var C : WideChar;
    P : PWideChar;
begin
  if not Assigned(S) or (F = '') then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      repeat
        C := P^;
        if C = #0 then
          begin
            Result := -1;
            exit;
          end;
        if StrZMatchStrW(P, F) then
          break;
        Inc(Result);
        Inc(P);
      until False;
    end;
end;

function StrZPosAW(const F: AnsiString; const S: PWideChar): Integer;
var C : WideChar;
    P : PWideChar;
begin
  if not Assigned(S) or (Length(F) = 0) then
    Result := -1
  else
    begin
      Result := 0;
      P := S;
      repeat
        C := P^;
        if C = #0 then
          begin
            Result := -1;
            exit;
          end;
        if StrZMatchStrAW(P, F) then
          break;
        Inc(Result);
        Inc(P);
      until False;
    end;
end;



{                                                                              }
{ Skip                                                                         }
{                                                                              }
function StrZSkipCharA(var P: PAnsiChar; const C: AnsiChar): Boolean;
var Q : PAnsiChar;
    D : AnsiChar;
begin
  Q := P;
  if not Assigned(Q) or (Ord(C) = 0) then
    Result := False
  else
    begin
      D := Q^;
      if Ord(D) = 0 then
        Result := False else
        if D = C then
          begin
            Inc(P);
            Result := True;
          end
        else
          Result := False;
    end;
end;

function StrZSkipCharA(var P: PAnsiChar; const C: CharSet): Boolean;
var Q : PAnsiChar;
    D : AnsiChar;
begin
  Q := P;
  if not Assigned(Q) then
    Result := False
  else
    begin
      D := Q^;
      if Ord(D) = 0 then
        Result := False else
        if D in C then
          begin
            Inc(P);
            Result := True;
          end
        else
          Result := False;
    end;
end;

function StrZSkipCharW(var P: PWideChar; const C: WideChar): Boolean;
var Q : PWideChar;
    D : WideChar;
begin
  Q := P;
  if not Assigned(Q) or (Ord(C) = 0) then
    Result := False
  else
    begin
      D := Q^;
      if D = #0 then
        Result := False else
        if D = C then
          begin
            Inc(P);
            Result := True;
          end
        else
          Result := False;
    end;
end;

function StrZSkipCharW(var P: PWideChar; const C: CharSet): Boolean;
var Q : PWideChar;
    D : WideChar;
begin
  Q := P;
  if not Assigned(Q) then
    Result := False
  else
    begin
      D := Q^;
      if D = #0 then
        Result := False else
      if Ord(D) >= $100 then
        Result := False
      else
        if AnsiChar(Ord(D)) in C then
          begin
            Inc(P);
            Result := True;
          end
        else
          Result := False;
    end;
end;

function StrZSkipCharW(var P: PWideChar; const C: TWideCharMatchFunction): Boolean;
var Q : PWideChar;
    D : WideChar;
begin
  Q := P;
  if not Assigned(Q) then
    Result := False
  else
    begin
      D := Q^;
      if D = #0 then
        Result := False else
      if C(D) then
        begin
          Inc(P);
          Result := True;
        end
      else
        Result := False;
    end;
end;

function StrZSkipChar(var P: PChar; const C: Char): Boolean;
var Q : PChar;
    D : Char;
begin
  Q := P;
  if not Assigned(Q) or (C = #0) then
    Result := False
  else
    begin
      D := Q^;
      if D = #0 then
        Result := False else
        if D = C then
          begin
            Inc(P);
            Result := True;
          end
        else
          Result := False;
    end;
end;

function StrZSkipChar(var P: PChar; const C: CharSet): Boolean;
var Q : PChar;
    D : Char;
begin
  Q := P;
  if not Assigned(Q) then
    Result := False
  else
    begin
      D := Q^;
      if D = #0 then
        Result := False else
      {$IFDEF StringIsUnicode}
      if Ord(D) >= $100 then
        Result := False
      else
        if AnsiChar(Ord(D)) in C then
          begin
            Inc(P);
            Result := True;
          end
      {$ELSE}
      if D in C then
        begin
          Inc(P);
          Result := True;
        end
      {$ENDIF}
        else
          Result := False;
    end;
end;

function StrZSkipAllA(var P: PAnsiChar; const C: AnsiChar): Integer;
var Q : PAnsiChar;
    D : AnsiChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) or (Ord(C) = 0) then
    exit;
  repeat
    D := Q^;
    if (Ord(D) = 0) or (D <> C) then
      break;
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipAllA(var P: PAnsiChar; const C: CharSet): Integer;
var Q : PAnsiChar;
    D : AnsiChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  repeat
    D := Q^;
    if (Ord(D) = 0) or not (D in C) then
      break;
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipAllW(var P: PWideChar; const C: WideChar): Integer;
var Q : PWideChar;
    D : WideChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) or (C = #0) then
    exit;
  repeat
    D := Q^;
    if (D = #0) or (D <> C) then
      break;
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipAllW(var P: PWideChar; const C: CharSet): Integer;
var Q : PWideChar;
    D : WideChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  repeat
    D := Q^;
    if (D = #0) or (Ord(D) >= $100) then
      break;
    if not (AnsiChar(Ord(D)) in C) then
      break;
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipAllW(var P: PWideChar; const C: TWideCharMatchFunction): Integer;
var Q : PWideChar;
    D : WideChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  repeat
    D := Q^;
    if D = #0 then
      break;
    if not C(D) then
      break;
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipAll(var P: PChar; const C: Char): Integer;
var Q : PChar;
    D : Char;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) or (C = #0) then
    exit;
  repeat
    D := Q^;
    if (D = #0) or (D <> C) then
      break;
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipAll(var P: PChar; const C: CharSet): Integer;
var Q : PChar;
    D : Char;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  repeat
    D := Q^;
    {$IFDEF StringIsUnicode}
    if (D = #0) or (Ord(D) >= $100) then
      break;
    if not (AnsiChar(Ord(D)) in C) then
      break;
    {$ELSE}
    if (D = #0) or not (D in C) then
      break;
    {$ENDIF}
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipToCharA(var P: PAnsiChar; const C: AnsiChar): Integer;
var Q : PAnsiChar;
    D : AnsiChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  repeat
    D := Q^;
    if (Ord(D) = 0) or (D = C) then
      break;
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipToCharA(var P: PAnsiChar; const C: CharSet): Integer;
var Q : PAnsiChar;
    D : AnsiChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  repeat
    D := Q^;
    if (Ord(D) = 0) or (D in C) then
      break;
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipToCharW(var P: PWideChar; const C: WideChar): Integer;
var Q : PWideChar;
    D : WideChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  repeat
    D := Q^;
    if (D = #0) or (D = C) then
      break;
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipToCharW(var P: PWideChar; const C: CharSet): Integer;
var Q : PWideChar;
    D : WideChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  repeat
    D := Q^;
    if (D = #0) or (Ord(D) >= $100) then
      break;
    if AnsiChar(Ord(D)) in C then
      break;
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipToCharW(var P: PWideChar; const C: TWideCharMatchFunction): Integer;
var Q : PWideChar;
    D : WideChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  repeat
    D := Q^;
    if D = #0 then
      break;
    if C(D) then
      break;
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipToChar(var P: PChar; const C: CharSet): Integer;
var Q : PChar;
    D : Char;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  repeat
    D := Q^;
    if D = #0 then
      break;
    {$IFDEF StringIsUnicode}
    if Ord(D) >= $100 then
      break;
    if AnsiChar(Ord(D)) in C then
      break;
    {$ELSE}
    if D in C then
      break;
    {$ENDIF}
    Inc(Q);
    Inc(Result);
  until False;
  P := Q;
end;

function StrZSkipToStrA(var P: PAnsiChar; const S: AnsiString; const AsciiCaseSensitive: Boolean): Integer;
var Q : PAnsiChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  while (Ord(Q^) <> 0) and not StrZMatchStrAsciiA(Q, S, AsciiCaseSensitive) do
    begin
      Inc(Q);
      Inc(Result);
    end;
  P := Q;
end;

function StrZSkipToStrB(var P: PAnsiChar; const S: RawByteString; const AsciiCaseSensitive: Boolean): Integer;
var Q : PAnsiChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  while (Ord(Q^) <> 0) and not StrZMatchStrAsciiB(Q, S, AsciiCaseSensitive) do
    begin
      Inc(Q);
      Inc(Result);
    end;
  P := Q;
end;

function StrZSkipToStrW(var P: PWideChar; const S: WideString; const AsciiCaseSensitive: Boolean): Integer;
var Q : PWideChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  while (Q^ <> #0) and not StrZMatchStrAsciiW(Q, S, AsciiCaseSensitive) do
    begin
      Inc(Q);
      Inc(Result);
    end;
  P := Q;
end;

function StrZSkipToStrAW(var P: PWideChar; const S: AnsiString; const AsciiCaseSensitive: Boolean): Integer;
var Q : PWideChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  while (Q^ <> #0) and not StrZMatchStrAsciiAW(Q, S, AsciiCaseSensitive) do
    begin
      Inc(Q);
      Inc(Result);
    end;
  P := Q;
end;

function StrZSkipToStr(var P: PChar; const S: String; const AsciiCaseSensitive: Boolean): Integer;
var Q : PChar;
begin
  Result := 0;
  Q := P;
  if not Assigned(Q) then
    exit;
  while (Q^ <> #0) and not StrZMatchStrAscii(Q, S, AsciiCaseSensitive) do
    begin
      Inc(Q);
      Inc(Result);
    end;
  P := Q;
end;

function StrZSkip2CharSeq(var P: PAnsiChar; const S1, S2: CharSet): Boolean;
var Q : PAnsiChar;
    C : AnsiChar;
begin
  Q := P;
  if not Assigned(Q) then
    begin
      Result := False;
      exit;
    end;
  C := Q^;
  if (Ord(C) = 0) or not (C in S1) then
    begin
      Result := False;
      exit;
    end;
  Inc(Q);
  C := Q^;
  if (Ord(C) = 0) or not (C in S2) then
    Result := False
  else
    begin
      Inc(P, 2);
      Result := True;
    end;
end;

function StrZSkip3CharSeq(var P: PAnsiChar; const S1, S2, S3: CharSet): Boolean;
var Q : PAnsiChar;
    C : AnsiChar;
begin
  Q := P;
  if not Assigned(Q) then
    begin
      Result := False;
      exit;
    end;
  C := Q^;
  if (Ord(C) = 0) or not (C in S1) then
    begin
      Result := False;
      exit;
    end;
  Inc(Q);
  C := Q^;
  if (Ord(C) = 0) or not (C in S2) then
    begin
      Result := False;
      exit;
    end;
  Inc(Q);
  C := Q^;
  if (Ord(C) = 0) or not (C in S3) then
    Result := False
  else
    begin
      Inc(P, 3);
      Result := True;
    end;
end;

function StrZSkipStrA(var P: PAnsiChar; const S: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
begin
  Result := StrZMatchStrAsciiA(P, S, AsciiCaseSensitive);
  if Result then
    Inc(P, Length(S));
end;

function StrZSkipStrB(var P: PAnsiChar; const S: RawByteString; const AsciiCaseSensitive: Boolean): Boolean;
begin
  Result := StrZMatchStrAsciiB(P, S, AsciiCaseSensitive);
  if Result then
    Inc(P, Length(S));
end;

function StrZSkipStrW(var P: PWideChar; const S: WideString; const AsciiCaseSensitive: Boolean): Boolean;
begin
  Result := StrZMatchStrAsciiW(P, S, AsciiCaseSensitive);
  if Result then
    Inc(P, Length(S));
end;

function StrZSkipStrAW(var P: PWideChar; const S: AnsiString; const AsciiCaseSensitive: Boolean): Boolean;
begin
  Result := StrZMatchStrAsciiAW(P, S, AsciiCaseSensitive);
  if Result then
    Inc(P, Length(S));
end;

function StrZSkipStr(var P: PChar; const S: String; const AsciiCaseSensitive: Boolean): Boolean;
begin
  Result := StrZMatchStrAscii(P, S, AsciiCaseSensitive);
  if Result then
    Inc(P, Length(S));
end;



{                                                                              }
{ Extract                                                                      }
{                                                                              }
function StrZExtractAllA(var P: PAnsiChar; const C: AnsiChar): AnsiString;
var Q : PAnsiChar;
    I : Integer;
begin
  Q := P;
  I := StrZSkipAllA(P, C);
  Result := StrPToStrA(Q, I);
end;

function StrZExtractAllA(var P: PAnsiChar; const C: CharSet): AnsiString;
var Q : PAnsiChar;
    I : Integer;
begin
  Q := P;
  I := StrZSkipAllA(P, C);
  Result := StrPToStrA(Q, I);
end;

function StrZExtractAllW(var P: PWideChar; const C: WideChar): WideString;
var Q : PWideChar;
    I : Integer;
begin
  Q := P;
  I := StrZSkipAllW(P, C);
  Result := StrPToStrW(Q, I);
end;

function StrZExtractAllW(var P: PWideChar; const C: CharSet): WideString;
var Q : PWideChar;
    I : Integer;
begin
  Q := P;
  I := StrZSkipAllW(P, C);
  Result := StrPToStrW(Q, I);
end;

function StrZExtractAllW(var P: PWideChar; const C: TWideCharMatchFunction): WideString;
var Q : PWideChar;
    I : Integer;
begin
  Q := P;
  I := StrZSkipAllW(P, C);
  Result := StrPToStrW(Q, I);
end;

function StrZExtractAllU(var P: PWideChar; const C: WideChar): UnicodeString;
var Q : PWideChar;
    I : Integer;
begin
  Q := P;
  I := StrZSkipAllW(P, C);
  Result := StrPToStrU(Q, I);
end;

function StrZExtractAllU(var P: PWideChar; const C: CharSet): UnicodeString;
var Q : PWideChar;
    I : Integer;
begin
  Q := P;
  I := StrZSkipAllW(P, C);
  Result := StrPToStrU(Q, I);
end;

function StrZExtractAllU(var P: PWideChar; const C: TWideCharMatchFunction): UnicodeString;
var Q : PWideChar;
    I : Integer;
begin
  Q := P;
  I := StrZSkipAllW(P, C);
  Result := StrPToStrU(Q, I);
end;

function StrZExtractAll(var P: PChar; const C: Char): String;
var Q : PChar;
    I : Integer;
begin
  Q := P;
  I := StrZSkipAll(P, C);
  Result := StrPToStr(Q, I);
end;

function StrZExtractAll(var P: PChar; const C: CharSet): String;
var Q : PChar;
    I : Integer;
begin
  Q := P;
  I := StrZSkipAll(P, C);
  Result := StrPToStr(Q, I);
end;

function StrZExtractToA(var P: PAnsiChar; const C: AnsiChar): AnsiString;
var Q : PAnsiChar;
    L : Integer;
begin
  Q := P;
  L := StrZSkipToCharA(P, C);
  Result := StrPToStrA(Q, L);
end;

function StrZExtractToA(var P: PAnsiChar; const C: CharSet): AnsiString;
var Q : PAnsiChar;
    L : Integer;
begin
  Q := P;
  L := StrZSkipToCharA(P, C);
  Result := StrPToStrA(Q, L);
end;

function StrZExtractToW(var P: PWideChar; const C: WideChar): WideString;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := StrZSkipToCharW(P, C);
  Result := StrPToStrW(Q, L);
end;

function StrZExtractToW(var P: PWideChar; const C: CharSet): WideString;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := StrZSkipToCharW(P, C);
  Result := StrPToStrW(Q, L);
end;

function StrZExtractToW(var P: PWideChar; const C: TWideCharMatchFunction): WideString;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := StrZSkipToCharW(P, C);
  Result := StrPToStrW(Q, L);
end;

function StrZExtractToU(var P: PWideChar; const C: WideChar): UnicodeString;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := StrZSkipToCharW(P, C);
  Result := StrPToStrU(Q, L);
end;

function StrZExtractToU(var P: PWideChar; const C: CharSet): UnicodeString;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := StrZSkipToCharW(P, C);
  Result := StrPToStrU(Q, L);
end;

function StrZExtractToU(var P: PWideChar; const C: TWideCharMatchFunction): UnicodeString;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := StrZSkipToCharW(P, C);
  Result := StrPToStrU(Q, L);
end;

function StrZExtractTo(var P: PChar; const C: CharSet): String;
var Q : PChar;
    L : Integer;
begin
  Q := P;
  L := StrZSkipToChar(P, C);
  Result := StrPToStr(Q, L);
end;

function StrZExtractToStrA(var P: PAnsiChar; const S: AnsiString;
    const CaseSensitive: Boolean): AnsiString;
var Q : PAnsiChar;
    L : Integer;
begin
  Q := P;
  L := 0;
  while (Ord(P^) <> 0) and not StrZMatchStrAsciiA(P, S, CaseSensitive) do
    begin
      Inc(P);
      Inc(L);
    end;
  Result := StrPToStrA(Q, L);
end;

function StrZExtractToStrB(var P: PAnsiChar; const S: RawByteString;
    const CaseSensitive: Boolean): RawByteString;
var Q : PAnsiChar;
    L : Integer;
begin
  Q := P;
  L := 0;
  while (Ord(P^) <> 0) and not StrZMatchStrAsciiB(P, S, CaseSensitive) do
    begin
      Inc(P);
      Inc(L);
    end;
  Result := StrPToStrB(Q, L);
end;

function StrZExtractToStrW(var P: PWideChar; const S: WideString;
    const CaseSensitive: Boolean): WideString;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := 0;
  while (P^ <> #0) and not StrZMatchStrAsciiW(P, S, CaseSensitive) do
    begin
      Inc(P);
      Inc(L);
    end;
  Result := StrPToStrW(Q, L);
end;

function StrZExtractToStrAW(var P: PWideChar; const S: AnsiString;
    const CaseSensitive: Boolean): WideString;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := 0;
  while (P^ <> #0) and not StrZMatchStrAsciiAW(P, S, CaseSensitive) do
    begin
      Inc(P);
      Inc(L);
    end;
  Result := StrPToStrW(Q, L);
end;

function StrZExtractToStrU(var P: PWideChar; const S: UnicodeString;
    const CaseSensitive: Boolean): UnicodeString;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := 0;
  while (P^ <> #0) and not StrZMatchStrAsciiU(P, S, CaseSensitive) do
    begin
      Inc(P);
      Inc(L);
    end;
  Result := StrPToStrU(Q, L);
end;

function StrZExtractToStrAU(var P: PWideChar; const S: AnsiString;
    const CaseSensitive: Boolean): UnicodeString;
var Q : PWideChar;
    L : Integer;
begin
  Q := P;
  L := 0;
  while (P^ <> #0) and not StrZMatchStrAsciiAW(P, S, CaseSensitive) do
    begin
      Inc(P);
      Inc(L);
    end;
  Result := StrPToStrU(Q, L);
end;

function StrZExtractToStr(var P: PChar; const S: String;
    const CaseSensitive: Boolean): String;
var Q : PChar;
    L : Integer;
begin
  Q := P;
  L := 0;
  while (P^ <> #0) and not StrZMatchStrAscii(P, S, CaseSensitive) do
    begin
      Inc(P);
      Inc(L);
    end;
  Result := StrPToStr(Q, L);
end;

function StrZExtractQuotedA(var P: PAnsiChar; var S: AnsiString; const Quote: CharSet): Boolean;
var Q    : PAnsiChar;
    C, D : AnsiChar;
    L    : Integer;
begin
  C := P^;
  if not (C in Quote) then
    begin
      Result := False;
      exit;
    end;
  Inc(P);
  Q := P;
  L := 0;
  repeat
    D := P^;
    if Ord(D) = 0 then
      break;
    if D = C then
      begin
        Inc(P);
        break;
      end;
    Inc(P);
    Inc(L);
  until False;
  S := StrPToStrA(Q, L);
  Result := True;
end;

function StrZExtractQuotedB(var P: PAnsiChar; var S: RawByteString; const Quote: CharSet): Boolean;
var Q    : PAnsiChar;
    C, D : AnsiChar;
    L    : Integer;
begin
  C := P^;
  if not (C in Quote) then
    begin
      Result := False;
      exit;
    end;
  Inc(P);
  Q := P;
  L := 0;
  repeat
    D := P^;
    if Ord(D) = 0 then
      break;
    if D = C then
      begin
        Inc(P);
        break;
      end;
    Inc(P);
    Inc(L);
  until False;
  S := StrPToStrB(Q, L);
  Result := True;
end;

function StrZExtractQuotedW(var P: PWideChar; var S: WideString; const Quote: CharSet): Boolean;
var Q    : PWideChar;
    C, D : WideChar;
    L    : Integer;
begin
  C := P^;
  if not WideCharInCharSet(C, Quote) then
    begin
      Result := False;
      exit;
    end;
  Inc(P);
  Q := P;
  L := 0;
  repeat
    D := P^;
    if D = #0 then
      break;
    if D = C then
      begin
        Inc(P);
        break;
      end;
    Inc(P);
    Inc(L);
  until False;
  S := StrPToStrW(Q, L);
  Result := True;
end;

function StrZExtractQuotedU(var P: PWideChar; var S: UnicodeString; const Quote: CharSet): Boolean;
var Q    : PWideChar;
    C, D : WideChar;
    L    : Integer;
begin
  C := P^;
  if not WideCharInCharSet(C, Quote) then
    begin
      Result := False;
      exit;
    end;
  Inc(P);
  Q := P;
  L := 0;
  repeat
    D := P^;
    if D = #0 then
      break;
    if D = C then
      begin
        Inc(P);
        break;
      end;
    Inc(P);
    Inc(L);
  until False;
  S := StrPToStrU(Q, L);
  Result := True;
end;

function StrZExtractQuoted(var P: PChar; var S: String; const Quote: CharSet): Boolean;
var Q    : PChar;
    C, D : Char;
    L    : Integer;
begin
  C := P^;
  if not CharInCharSet(C, Quote) then
    begin
      Result := False;
      exit;
    end;
  Inc(P);
  Q := P;
  L := 0;
  repeat
    D := P^;
    if D = #0 then
      break;
    if D = C then
      begin
        Inc(P);
        break;
      end;
    Inc(P);
    Inc(L);
  until False;
  S := StrPToStr(Q, L);
  Result := True;
end;



end.

