{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcUTF.pas                                               }
{   File version:     5.07                                                     }
{   Description:      UTF encoding and decoing functions.                      }
{                                                                              }
{   Copyright:        Copyright (c) 2015-2021, David J Butler                  }
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
{   2015/05/06  4.01  Add UTF functions from unit cUnicodeCodecs.              }
{   2017/10/07  5.02  Move to flcUTF unit.                                     }
{   2018/08/12  5.03  String type changes.                                     }
{   2019/10/03  5.04  UTF16LEToUCS4Char.                                       }
{   2020/03/12  5.05  NativeInt changes.                                       }
{                     Remove dependencies on flcUtils and flcAscii.            }
{   2020/06/30  5.06  UTF16LE/UTF16BE encoding/decoding functions.             }
{                     UTF detection functions.                                 }
{   2020/12/12  5.07  Compilable with Delphi 2007 Win32.                       }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 2010-10.4 Win32/Win64        5.05  2020/06/02                       }
{   Delphi 10.2-10.4 Linux64            5.05  2020/06/02                       }
{   FreePascal 3.0.4 Win64              5.05  2020/06/02                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

{$IFDEF DEBUG}
{$IFDEF TEST}
  {$DEFINE UTF_TEST}
{$ENDIF}
{$ENDIF}

unit flcUTF;

interface

uses
  { System }
  SysUtils,

  { Fundamentals }
  flcStdTypes;



{                                                                              }
{ UTF-8 character conversion functions                                         }
{                                                                              }
type
  TUTF8Error = (
      UTF8ErrorNone,
      UTF8ErrorInvalidEncoding,
      UTF8ErrorIncompleteEncoding,
      UTF8ErrorInvalidBuffer,
      UTF8ErrorOutOfRange
    );

function  UTF8ToUCS4Char(
          const Buf: Pointer;
          const Size: NativeInt;
          out SeqSize: Integer;
          out Ch: UCS4Char): TUTF8Error;

function  UTF8ToWideChar(
          const Buf: Pointer;
          const Size: NativeInt;
          out SeqSize: Integer;
          out Ch: WideChar): TUTF8Error;

procedure UCS4CharToUTF8(
          const Ch: UCS4Char;
          const DestBuf: Pointer;
          const DestSize: NativeInt;
          out SeqSize: Integer);

procedure WideCharToUTF8(
          const Ch: WideChar;
          const DestBuf: Pointer;
          const DestSize: NativeInt;
          out SeqSize: Integer);



{                                                                              }
{ UTF-8 string functions                                                       }
{                                                                              }
const
  UTF8BOMSize = 3;

function  DetectUTF8BOM(const Buf: Pointer; const Size: NativeInt): Boolean;

function  UTF8CharSize(const Buf: Pointer; const Size: NativeInt): Integer;
function  UTF8BufLength(const Buf: Pointer; const Size: NativeInt): NativeInt;
function  UTF8StringLength(const S: RawByteString): NativeInt;
function  UTF8StringToUnicodeString(const S: RawByteString): UnicodeString;
function  UTF8StringToUnicodeStringP(const S: Pointer; const Size: NativeInt): UnicodeString;
function  UTF8StringToLongString(const S: RawByteString): RawByteString;
function  UTF8StringToString(const S: RawByteString): String;

function  UCS4CharToUTF8CharSize(const Ch: UCS4Char): Integer;
function  WideBufToUTF8Size(const Buf: PWideChar; const Len: NativeInt): NativeInt;
function  UnicodeStringToUTF8Size(const S: UnicodeString): NativeInt;
function  WideBufToUTF8String(const Buf: PWideChar; const Len: NativeInt): RawByteString;
function  UnicodeStringToUTF8String(const S: UnicodeString): RawByteString;
function  RawByteBufToUTF8Size(const Buf: Pointer; const Len: NativeInt): NativeInt;
function  RawByteStringToUTF8Size(const S: RawByteString): NativeInt;
function  RawByteStringToUTF8String(const S: RawByteString): RawByteString;
function  UCS4CharToUTF8String(const Ch: UCS4Char): RawByteString;
function  ISO8859_1StringToUTF8String(const S: RawByteString): RawByteString;
function  StringToUTF8String(const S: String): RawByteString;



{                                                                              }
{ UTF-16 character conversion functions                                        }
{                                                                              }
procedure UCS4CharToUTF16BE(
          const Ch: UCS4Char;
          const DestBuf: Pointer;
          const DestSize: NativeInt;
          out SeqSize: Integer);

procedure UCS4CharToUTF16LE(
          const Ch: UCS4Char;
          const DestBuf: Pointer;
          const DestSize: NativeInt;
          out SeqSize: Integer);

function  UTF16LEToUCS4Char(
          const Buf: Pointer;
          const Size: NativeInt;
          out Ch: UCS4Char;
          out SeqSize: Integer): Boolean;



{                                                                              }
{ UTF-16 functions                                                             }
{                                                                              }
const
  UTF16BOMSize = 2;

function  DetectUTF16BEBOM(const Buf: Pointer; const Size: NativeInt): Boolean;
function  DetectUTF16LEBOM(const Buf: Pointer; const Size: NativeInt): Boolean;
function  DetectUTF16BOM(
          const Buf: Pointer;
          const Size: NativeInt;
          out SwapEndian: Boolean): Boolean;

function  SwapUTF16Endian(const P: WideChar): WideChar;

function  UTF16LEDecode(
          const SrcBuf: Pointer; const SrcBufSize: NativeInt;
          out ProcessedBytes, DstLength: NativeInt): UnicodeString;
function  UTF16LEEncode(
          const SrcP: PWideChar; const SrcLength: NativeInt;
          out ProcessedChars: NativeInt): TBytes;

function  UTF16BEDecode(
          const SrcBuf: Pointer; const SrcBufSize: NativeInt;
          out ProcessedBytes, DstLength: NativeInt): UnicodeString;
function  UTF16BEEncode(
          const SrcP: PWideChar; const SrcLength: NativeInt;
          out ProcessedChars: NativeInt): TBytes;




{                                                                              }
{ UTF detection                                                                }
{                                                                              }
type
  TUTFEncoding = (
      utfeNone,
      utfeUTF8,
      utfeUTF16LE,
      utfeUTF16BE
    );

// Detect from Byte-Order-Mark
function  DetectUTFFromBOM(const Buf: Pointer; const Size: NativeInt): TUTFEncoding;

// Detect from text content
function  DetectUTFFromText(const Buf: Pointer; const Size: NativeInt): TUTFEncoding;

// Use above methods to detect UTF encoding
function  DetectUTF(const Buf: Pointer; const Size: NativeInt): TUTFEncoding;



{                                                                              }
{ Tests                                                                        }
{                                                                              }
{$IFDEF UTF_TEST}
procedure Test;
{$ENDIF}



implementation



{                                                                              }
{ UTF-8 character conversion functions                                         }
{                                                                              }

resourcestring
  SInvalidCodePoint = '$%x is not a valid %s code point';
  SUTFStringConvertError = 'UTF string conversion error';


{ UTF8ToUCS4Char returns UTF8ErrorNone if a valid UTF-8 sequence was decoded   }
{ (and Ch contains the decoded UCS4 character and SeqSize contains the size    }
{ of the UTF-8 sequence). If an incomplete UTF-8 sequence is encountered, the  }
{ function returns UTF8ErrorIncompleteEncoding and SeqSize > Size. If an       }
{ invalid UTF-8 sequence is encountered, the function returns                  }
{ UTF8ErrorInvalidEncoding and SeqSize (<= Size) is the size of the            }
{ invalid sequence, and Ch may be the intended character.                      }
function UTF8ToUCS4Char(
         const Buf: Pointer;
         const Size: NativeInt;
         out SeqSize: Integer;
         out Ch: UCS4Char): TUTF8Error;
var
  C : Byte;
  D : Byte;
  V : Word32;
  I : Integer;
  Q : PByte;
begin
  if not Assigned(Buf) or (Size <= 0) then
    begin
      SeqSize := 0;
      Ch := 0;
      Result := UTF8ErrorInvalidBuffer;
      exit;
    end;
  C := PByte(Buf)^;
  if C < $80 then
    begin
      SeqSize := 1;
      Ch := C;
      Result := UTF8ErrorNone;
      exit;
    end;
  // multi-byte characters always start with 11xxxxxx ($C0)
  // following bytes always start with 10xxxxxx ($80)
  if C and $C0 = $80 then
    begin
      SeqSize := 1;
      Ch := C;
      Result := UTF8ErrorInvalidEncoding;
      exit;
    end;
  if C and $20 = 0 then // 2-byte sequence
    begin
      SeqSize := 2;
      V := C and $1F;
    end
  else
  if C and $10 = 0 then // 3-byte sequence
    begin
      SeqSize := 3;
      V := C and $0F;
    end
  else
  if C and $08 = 0 then // 4-byte sequence (max needed for Unicode $0-$1FFFFF)
    begin
      SeqSize := 4;
      V := C and $07;
    end
  else
    begin
      SeqSize := 1;
      Ch := C;
      Result := UTF8ErrorInvalidEncoding;
      exit;
    end;
  if Size < SeqSize then // incomplete
    begin
      Ch := C;
      Result := UTF8ErrorIncompleteEncoding;
      exit;
    end;
  Q := Buf;
  for I := 1 to SeqSize - 1 do
    begin
      Inc(Q);
      D := Ord(Q^);
      if D and $C0 <> $80 then // following byte must start with 10xxxxxx
        begin
          SeqSize := 1;
          Ch := C;
          Result := UTF8ErrorInvalidEncoding;
          exit;
        end;
      V := (V shl 6) or (D and $3F); // decode 6 bits
    end;
  Ch := V;
  Result := UTF8ErrorNone;
end;

function UTF8ToWideChar(
         const Buf: Pointer;
         const Size: NativeInt;
         out SeqSize: Integer;
         out Ch: WideChar): TUTF8Error;
var Ch4 : UCS4Char;
begin
  Result := UTF8ToUCS4Char(Buf, Size, SeqSize, Ch4);
  if Ch4 > $FFFF then
    begin
      Result := UTF8ErrorOutOfRange;
      Ch := #$0000;
    end
  else
    Ch := WideChar(Ch4);
end;

{ UCS4CharToUTF8 transforms the UCS4 char Ch to UTF-8 encoding. SeqSize        }
{ returns the number of bytes needed to transform Ch. Up to DestSize           }
{ bytes of the UTF-8 encoding will be placed in Dest.                          }
procedure UCS4CharToUTF8(
          const Ch: UCS4Char;
          const DestBuf: Pointer;
          const DestSize: NativeInt;
          out SeqSize: Integer);
var P : PByte;
begin
  P := DestBuf;
  if Ch < $80 then // US-ASCII (1-byte sequence)
    begin
      SeqSize := 1;
      if not Assigned(P) or (DestSize <= 0) then
        exit;
      P^ := Byte(Ch);
    end else
  if Ch < $800 then // 2-byte sequence
    begin
      SeqSize := 2;
      if not Assigned(P) or (DestSize <= 0) then
        exit;
      P^ := $C0 or Byte(Ch shr 6);
      if DestSize = 1 then
        exit;
      Inc(P);
      P^ := $80 or (Ch and $3F);
    end else
  if Ch < $10000 then // 3-byte sequence
    begin
      SeqSize := 3;
      if not Assigned(P) or (DestSize <= 0) then
        exit;
      P^ := $E0 or Byte(Ch shr 12);
      if DestSize = 1 then
        exit;
      Inc(P);
      P^ := $80 or ((Ch shr 6) and $3F);
      if DestSize = 2 then
        exit;
      Inc(P);
      P^ := $80 or (Ch and $3F);
    end else
  if Ch < $200000 then // 4-byte sequence
    begin
      SeqSize := 4;
      if not Assigned(P) or (DestSize <= 0) then
        exit;
      P^ := $F0 or Byte(Ch shr 18);
      if DestSize = 1 then
        exit;
      Inc(P);
      P^ := $80 or ((Ch shr 12) and $3F);
      if DestSize = 2 then
        exit;
      Inc(P);
      P^ := $80 or ((Ch shr 6) and $3F);
      if DestSize = 3 then
        exit;
      Inc(P);
      P^ := $80 or (Ch and $3F);
    end
  else
    raise EConvertError.CreateFmt(SInvalidCodePoint, [Ord(Ch), 'Unicode']);
end;

procedure WideCharToUTF8(
          const Ch: WideChar;
          const DestBuf: Pointer;
          const DestSize: NativeInt;
          out SeqSize: Integer);
begin
  UCS4CharToUTF8(Ord(Ch), DestBuf, DestSize, SeqSize);
end;



{                                                                              }
{ UTF-8 string functions                                                       }
{                                                                              }
function DetectUTF8BOM(const Buf: Pointer; const Size: NativeInt): Boolean;
var
  Q : PByte;
begin
  Result := False;
  if Assigned(Buf) and (Size >= 3) and (PByte(Buf)^ = $EF) then
    begin
      Q := Buf;
      Inc(Q);
      if Q^ = $BB then
        begin
          Inc(Q);
          if Q^ = $BF then
            Result := True;
        end;
    end;
end;

function UTF8CharSize(const Buf: Pointer; const Size: NativeInt): Integer;
var
  C : Byte;
  I : Integer;
  Q : PByte;
begin
  if not Assigned(Buf) or (Size <= 0) then
    begin
      Result := 0;
      exit;
    end;
  C := PByte(Buf)^;
  if C < $80 then // 1-byte (US-ASCII value)
    Result := 1
  else
  if C and $C0 = $80 then // invalid encoding
    Result := 1
  else
    begin
      // multi-byte character
      if C and $20 = 0 then
        Result := 2
      else
      if C and $10 = 0 then
        Result := 3
      else
      if C and $08 = 0 then
        Result := 4
      else
        begin
          Result := 1; // invalid encoding
          exit;
        end;
      if Size < Result then // incomplete encoding
        exit;
      Q := Buf;
      Inc(Q);
      for I := 1 to Result - 1 do
        if Ord(Q^) and $C0 <> $80 then
          begin
            Result := 1; // invalid encoding
            exit;
          end
        else
          Inc(Q);
    end;
end;

function UTF8BufLength(const Buf: Pointer; const Size: NativeInt): NativeInt;
var
  Q : PByte;
  L : NativeInt;
  C : Integer;
begin
  Q := Buf;
  L := Size;
  Result := 0;
  while L > 0 do
    begin
      C := UTF8CharSize(Q, L);
      Dec(L, C);
      Inc(Q, C);
      Inc(Result);
    end;
end;

function UTF8StringLength(const S: RawByteString): NativeInt;
begin
  Result := UTF8BufLength(Pointer(S), Length(S));
end;

function UCS4CharToUTF8CharSize(const Ch: UCS4Char): Integer;
begin
  if Ch < $80 then
    Result := 1 else
  if Ch < $800 then
    Result := 2 else
  if Ch < $10000 then
    Result := 3 else
  if Ch < $200000 then
    Result := 4
  else
    raise EConvertError.CreateFmt(SInvalidCodePoint, [Ord(Ch), 'Unicode']);
end;

function WideBufToUTF8Size(const Buf: PWideChar; const Len: NativeInt): NativeInt;
var
  P : PWideChar;
  I : NativeInt;
  C : UCS4Char;
begin
  P := Buf;
  Result := 0;
  for I := 1 to Len do
    begin
      C := UCS4Char(P^);
      Inc(Result);
      if C >= $80 then
        if C >= $800 then
          Inc(Result, 2) else
          Inc(Result);
      Inc(P);
    end;
end;

function RawByteBufToUTF8Size(const Buf: Pointer; const Len: NativeInt): NativeInt;
var
  P : PByte;
  I : NativeInt;
begin
  P := Buf;
  Result := 0;
  for I := 1 to Len do
    begin
      Inc(Result);
      if P^ >= $80 then
        Inc(Result);
      Inc(P);
    end;
end;

function UnicodeStringToUTF8Size(const S: UnicodeString): NativeInt;
begin
  Result := WideBufToUTF8Size(Pointer(S), Length(S));
end;

function RawByteStringToUTF8Size(const S: RawByteString): NativeInt;
begin
  Result := RawByteBufToUTF8Size(Pointer(S), Length(S));
end;

procedure RawByteBufToWideBuf(
          const Buf: Pointer;
          const BufSize: NativeInt;
          const DestBuf: Pointer);
var
  I : NativeInt;
  P : PWord32;
  Q : PWord32;
  V : Word32;
  N : Integer;
  E : PByte;
  F : PWord16;
begin
  if BufSize <= 0 then
    exit;
  P := Buf;
  Q := DestBuf;
  for I := 1 to BufSize div 4 do
    begin
      // convert 4 characters per iteration
      V := P^;
      Inc(P);
      Q^ := (V and $FF) or ((V and $FF00) shl 8);
      Inc(Q);
      V := V shr 16;
      Q^ := (V and $FF) or ((V and $FF00) shl 8);
      Inc(Q);
    end;
  // convert remaining (<4)
  N := BufSize mod 4;
  if N > 0 then
    begin
      E := Pointer(P);
      F := Pointer(Q);
      for I := 1 to N do
        begin
          F^ := E^;
          Inc(E);
          Inc(F);
        end;
    end;
end;

function RawByteStrPtrToUnicodeString(const S: Pointer; const Len: NativeInt): UnicodeString; {$IFDEF UseInline}inline;{$ENDIF}
begin
  if Len <= 0 then
    Result := ''
  else
    begin
      SetLength(Result, Len);
      RawByteBufToWideBuf(S, Len, PWideChar(Result));
    end;
end;

function IsAsciiBufB(const Buf: Pointer; const Len: NativeInt): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
var
  P : PByte;
  I : NativeInt;
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

function IsAsciiStringB(const S: RawByteString): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := IsAsciiBufB(Pointer(S), Length(S));
end;

function UTF8StringToUnicodeStringP(const S: Pointer; const Size: NativeInt): UnicodeString;
var
  P : PByte;
  Q : PWideChar;
  L : NativeInt;
  M : NativeInt;
  I : Integer;
  C : WideChar;
begin
  if Size = 0 then
    begin
      Result := '';
      exit;
    end;
  if IsAsciiBufB(S, Size) then // optimize for US-ASCII strings
    begin
      Result := RawByteStrPtrToUnicodeString(S, Size);
      exit;
    end;
  // Decode UTF-8
  L := Size;
  P := S;
  SetLength(Result, L); // maximum size
  Q := Pointer(Result);
  M := 0;
  repeat
    UTF8ToWideChar(P, Size, I, C);
    Assert(I > 0);
    Q^ := C;
    Inc(Q);
    Inc(M);
    Inc(P, I);
    Dec(L, I);
  until L <= 0;
  if M < Size then
    SetLength(Result, M); // actual size
end;

function UTF8StringToUnicodeString(const S: RawByteString): UnicodeString;
begin
  Result := UTF8StringToUnicodeStringP(Pointer(S), Length(S));
end;

function UTF8StringToLongString(const S: RawByteString): RawByteString;
var
  N : NativeInt;
  L : NativeInt;
  P : PByte;
  Q : PByte;
  M : NativeInt;
  I : Integer;
  C : WideChar;
begin
  N := Length(S);
  if N = 0 then
    begin
      Result := '';
      exit;
    end;
  if IsAsciiStringB(S) then // optimize for US-ASCII strings
    begin
      Result := S;
      exit;
    end;
  // Decode UTF-8
  L := N;
  P := Pointer(S);
  SetLength(Result, L); // maximum size
  Q := Pointer(Result);
  M := 0;
  repeat
    UTF8ToWideChar(P, L, I, C);
    Assert(I > 0, 'I > 0');
    if Ord(C) > $FF then
      raise EConvertError.Create(SUTFStringConvertError);
    Q^ := Byte(Ord(C));
    Inc(Q);
    Inc(M);
    Inc(P, I);
    Dec(L, I);
  until L <= 0;
  if M < N then
    SetLength(Result, M); // actual size
end;

function UTF8StringToString(const S: RawByteString): String;
begin
  {$IFDEF StringIsUnicode}
  Result := UTF8StringToUnicodeString(S);
  {$ELSE}
  Result := S;
  {$ENDIF}
end;

function WideBufToRawByteString(const P: PWideChar; const Len: NativeInt): RawByteString; {$IFDEF UseInline}inline;{$ENDIF}
var
  S : PWideChar;
  Q : PByte;
  I : NativeInt;
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
        raise EConvertError.Create(SUTFStringConvertError);
      Q^ := Byte(V);
      Inc(S);
      Inc(Q);
    end;
end;

function WideBufToUTF8String(const Buf: PWideChar; const Len: NativeInt): RawByteString;
var
  N : NativeInt;
  P : PWideChar;
  Q : PByte;
  M : NativeInt;
  I : NativeInt;
  J : Integer;
begin
  if Len = 0 then
    begin
      Result := '';
      exit;
    end;
  N := WideBufToUTF8Size(Buf, Len);
  if N = Len then // optimize for US-ASCII strings
    begin
      Result := WideBufToRawByteString(Buf, Len);
      exit;
    end;
  SetLength(Result, N);
  P := Buf;
  Q := Pointer(Result);
  M := 0;
  for I := 1 to Len do
    begin
      UCS4CharToUTF8(UCS4Char(P^), Q, N, J);
      Inc(P);
      Inc(Q, J);
      Dec(N, J);
      Inc(M, J);
    end;
  if M < N then
    SetLength(Result, M); // actual size
end;

function RawByteStringToUTF8String(const S: RawByteString): RawByteString;
var
  P       : PByte;
  L       : NativeInt;
  N       : NativeInt;
  Q       : PByte;
  M       : NativeInt;
  I       : NativeInt;
  J       : Integer;
begin
  P := Pointer(S);
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  N := RawByteBufToUTF8Size(P, L);
  if N = L then // optimize for US-ASCII strings
    begin
      Result := S;
      exit;
    end;
  SetLength(Result, N);
  Q := Pointer(Result);
  M := 0;
  for I := 1 to L do
    begin
      UCS4CharToUTF8(UCS4Char(Ord(P^)), Q, N, J);
      Inc(P);
      Inc(Q, J);
      Dec(N, J);
      Inc(M, J);
    end;
  if M < N then
    SetLength(Result, M); // actual size
end;

function UnicodeStringToUTF8String(const S: UnicodeString): RawByteString;
begin
  Result := WideBufToUTF8String(Pointer(S), Length(S));
end;

const
  MaxUTF8SequenceSize = 4;

function UCS4CharToUTF8String(const Ch: UCS4Char): RawByteString;
var
  Buf  : array[0..MaxUTF8SequenceSize - 1] of Byte;
  Size : Integer;
  I    : Integer;
  P, Q : PByte;
begin
  Size := 0;
  UCS4CharToUTF8(Ch, @Buf, Sizeof(Buf), Size);
  SetLength(Result, Size);
  if Size > 0 then
    begin
      P := Pointer(Result);
      Q := @Buf;
      for I := 0 to Size - 1 do
        begin
          P^ := Q^;
          Inc(P);
          Inc(Q);
        end;
    end;
end;

function ISO8859_1StringToUTF8String(const S: RawByteString): RawByteString;
var
  P, Q : PByte;
  L, I : NativeInt;
  M    : NativeInt;
  J    : Integer;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  // Calculate size
  M := L;
  P := Pointer(S);
  for I := 1 to L do
    begin
      if Ord(P^) >= $80 then
        Inc(M); // 2 bytes required for #$80-#$FF
      Inc(P);
    end;
  // Check if conversion is required
  if M = L then
    begin
      // All characters are US-ASCII, return reference to same string
      Result := S;
      exit;
    end;
  // Convert
  SetLength(Result, M);
  Q := Pointer(Result);
  P := Pointer(S);
  for I := 1 to L do
    begin
      WideCharToUTF8(WideChar(P^), Q, M, J);
      Inc(P);
      Inc(Q, J);
      Dec(M, J);
    end;
end;

function StringToUTF8String(const S: String): RawByteString;
begin
  {$IFDEF StringIsUnicode}
  Result := UnicodeStringToUTF8String(S);
  {$ELSE}
  Result := S;
  {$ENDIF}
end;



{                                                                              }
{ UTF-16 character conversion functions                                        }
{                                                                              }

resourcestring
  SCannotConvertUCS4 = 'Cannot convert $%8.8X to %s';

{ UCS4CharToUTF16BE transforms the UCS4 char Ch to UTF-16BE encoding. SeqSize  }
{ returns the number of bytes needed to transform Ch. Up to DestSize           }
{ bytes of the UTF-16BE encoding will be placed in Dest.                       }
procedure UCS4CharToUTF16BE(
          const Ch: UCS4Char;
          const DestBuf: Pointer;
          const DestSize: NativeInt;
          out SeqSize: Integer);
var
  P : PByte;
  HighSurrogate : Word16;
  LowSurrogate : Word16;
begin
  P := DestBuf;
  case Ch of
    $00000000..$0000D7FF, $0000E000..$0000FFFF :
      begin
        SeqSize := 2;
        if not Assigned(P) or (DestSize <= 0) then
          exit;
        {$IFDEF FREEPASCAL}
        P^ := Byte((Ch and $FF00) shr 8);
        {$ELSE}
        P^ := Hi(Ch);
        {$ENDIF}
        if DestSize <= 1 then
          exit;
        Inc(P);
        {$IFDEF FREEPASCAL}
        P^ := Byte(Ch and $FF);
        {$ELSE}
        P^ := Lo(Ch);
        {$ENDIF}
      end;
    $0000D800..$0000DFFF :
      raise EConvertError.CreateFmt(SInvalidCodePoint, [Ch, 'UCS-4']);
    $00010000..$0010FFFF :
      begin
        SeqSize := 4;
        if not Assigned(P) or (DestSize <= 0) then
          exit;
        HighSurrogate := $D7C0 + (Ch shr 10);
        P^ := Hi(HighSurrogate);
        if DestSize <= 1 then
          exit;
        Inc(P);
        P^ := Lo(HighSurrogate);
        if DestSize <= 2 then
          exit;
        LowSurrogate := $DC00 xor (Ch and $3FF);
        Inc(P);
        P^ := Hi(LowSurrogate);
        if DestSize <= 3 then
          exit;
        Inc(P);
        P^ := Lo(LowSurrogate);
      end;
  else // out of UTF-16 range
    raise EConvertError.CreateFmt(SCannotConvertUCS4, [Ch, 'UTF-16BE']);
  end;
end;

{ UCS4CharToUTF16LE transforms the UCS4 char Ch to UTF-16LE encoding. SeqSize  }
{ returns the number of bytes needed to transform Ch. Up to DestSize           }
{ bytes of the UTF-16LE encoding will be placed in Dest.                       }
procedure UCS4CharToUTF16LE(
          const Ch: UCS4Char;
          const DestBuf: Pointer;
          const DestSize: NativeInt;
          out SeqSize: Integer);
var
  P : PByte;
  HighSurrogate : Word16;
  LowSurrogate : Word16;
begin
  P := DestBuf;
  case Ch of
    $00000000..$0000D7FF, $0000E000..$0000FFFF :
      begin
        SeqSize := 2;
        if not Assigned(P) or (DestSize <= 0) then
          exit;
        {$IFDEF FREEPASCAL}
        P^ := Byte(Ch and $FF);
        {$ELSE}
        P^ := Lo(Ch);
        {$ENDIF}
        if DestSize <= 1 then
          exit;
        Inc(P);
        {$IFDEF FREEPASCAL}
        P^ := Byte((Ch and $FF00) shr 8);
        {$ELSE}
        P^ := Hi(Ch);
        {$ENDIF}
      end;
    $0000D800..$0000DFFF :
      raise EConvertError.CreateFmt(SInvalidCodePoint, [Ch, 'UCS-4']);
    $00010000..$0010FFFF:
      begin
        SeqSize := 4;
        if not Assigned(P) or (DestSize <= 0) then
          exit;
        HighSurrogate := $D7C0 + (Ch shr 10);
        P^ := Lo(HighSurrogate);
        if DestSize <= 1 then
          exit;
        Inc(P);
        P^ := Hi(HighSurrogate);
        if DestSize <= 2 then
          exit;
        LowSurrogate := $DC00 xor (Ch and $3FF);
        Inc(P);
        P^ := Lo(LowSurrogate);
        if DestSize <= 3 then
          exit;
        Inc(P);
        P^ := Hi(LowSurrogate);
      end;
  else // out of UTF-16 range
    raise EConvertError.CreateFmt(SCannotConvertUCS4, [Ch, 'UTF-16LE']);
  end;
end;

// Returns True if valid encoding
// If invalid, Returns False with Ch the invalid character and SeqSize the
// size of a valid encoding
function UTF16LEToUCS4Char(
         const Buf: Pointer;
         const Size: NativeInt;
         out Ch: UCS4Char;
         out SeqSize: Integer): Boolean;
var
  ChP : PWideChar;
  C : Word16;
  LowSurrogate : Word16;
begin
  if Size < 2 then
    begin
      // Too few bytes in Source
      Ch := 0;
      SeqSize := 2;
      Result := False;
      exit;
    end;
  ChP := Buf;
  C := Ord(ChP^); // UCS4Chars are stored in Little Endian mode
  case C of
    $D800..$DBFF: // High surrogate of Unicode character [$10000..$10FFFF]
      begin
        if Size < 4 then
          begin
            // Too few bytes in Source
            Ch := C;
            SeqSize := 4;
            Result := False;
            exit;
          end;
        Inc(ChP);
        LowSurrogate := Ord(ChP^);
        case LowSurrogate shr 8 of
          $DC..$DF :
            begin
              Ch := ((C - $D7C0) shl 10) + (((LowSurrogate shr 8) xor $DC) shl 8) + (LowSurrogate and $FF);
              SeqSize := 4;
              Result := True;
            end;
          else
            begin
              // Invalid encoding
              Ch := C;
              SeqSize := 4;
              Result := False;
            end;
        end;
      end;
    $DC00..$DFFF: // Low surrogate of Unicode character [$10000..$10FFFF]
      begin
        // Invalid encoding
        Ch := C;
        SeqSize := 2;
        Result := False;
      end
    else
      begin
        // 2 byte character
        Ch := C;
        SeqSize := 2;
        Result := True;
      end;
  end;
end;



{                                                                              }
{ UTF-16 functions                                                             }
{                                                                              }
function DetectUTF16BEBOM(const Buf: Pointer; const Size: NativeInt): Boolean;
begin
  Result := Assigned(Buf) and (Size >= Sizeof(WideChar)) and
            (PWideChar(Buf)^ = WideChar($FFFE));
end;

function DetectUTF16LEBOM(const Buf: Pointer; const Size: NativeInt): Boolean;
begin
  Result := Assigned(Buf) and (Size >= Sizeof(WideChar)) and
            (PWideChar(Buf)^ = WideChar($FEFF));
end;

{ DetectUTF16Encoding returns True if the encoding was confirmed to be UTF-16. }
{ SwapEndian is True if it was detected that the UTF-16 data is in reverse     }
{ endian from that used by the cpu.                                            }
function DetectUTF16BOM(
         const Buf: Pointer;
         const Size: NativeInt;
         out SwapEndian: Boolean): Boolean;
begin
  if not Assigned(Buf) or (Size < Sizeof(WideChar)) then
    begin
      SwapEndian := False;
      Result := False;
    end else
  if PWideChar(Buf)^ = WideChar($FEFF) then
    begin
      SwapEndian := False;
      Result := True;
    end else
  if PWideChar(Buf)^ = WideChar($FFFE) then
    begin
      SwapEndian := True;
      Result := True;
    end
  else
    begin
      SwapEndian := False;
      Result := False;
    end;
end;

function SwapUTF16Endian(const P: WideChar): WideChar;
begin
  Result := WideChar(((Ord(P) and $FF) shl 8) or (Ord(P) shr 8));
end;

function UTF16LEDecode(
         const SrcBuf: Pointer; const SrcBufSize: NativeInt;
         out ProcessedBytes, DstLength: NativeInt): UnicodeString;
var
  L, M : NativeInt;
  P, Q : PWideChar;
  Res  : UnicodeString;
begin
  L := SrcBufSize;
  if L <= 1 then
    begin
      ProcessedBytes := 0;
      DstLength := 0;
      exit;
    end;
  Dec(L, L mod Sizeof(WideChar));
  M := L div Sizeof(WideChar);
  SetLength(Res, M);
  P := SrcBuf;
  Q := Pointer(Res);
  Move(P^, Q^, L);
  ProcessedBytes := L;
  DstLength := M;
  Result := Res;
end;

function UTF16LEEncode(
         const SrcP: PWideChar; const SrcLength: NativeInt;
         out ProcessedChars: NativeInt): TBytes;
var
  L : NativeInt;
begin
  if SrcLength <= 0 then
    begin
      ProcessedChars := 0;
      SetLength(Result, 0);
      exit;
    end;
  L := SrcLength * SizeOf(WideChar);
  SetLength(Result, L);
  Move(SrcP^, Pointer(Result)^, L);
  ProcessedChars := SrcLength;
end;

function UTF16BEDecode(
         const SrcBuf: Pointer; const SrcBufSize: NativeInt;
         out ProcessedBytes, DstLength: NativeInt): UnicodeString;
var
  L, M : NativeInt;
  I    : NativeInt;
  P, Q : PWideChar;
  Res  : UnicodeString;
begin
  L := SrcBufSize;
  if L <= 1 then
    begin
      ProcessedBytes := 0;
      DstLength := 0;
      exit;
    end;
  Dec(L, L mod Sizeof(WideChar));
  M := L div Sizeof(WideChar);
  SetLength(Res, M);
  P := SrcBuf;
  Q := Pointer(Res);
  for I := 1 to M do
    begin
      Q^ := SwapUTF16Endian(P^);
      Inc(P);
      Inc(Q);
    end;
  ProcessedBytes := L;
  DstLength := M;
  Result := Res;
end;

function UTF16BEEncode(
         const SrcP: PWideChar; const SrcLength: NativeInt;
         out ProcessedChars: NativeInt): TBytes;
var I, L : NativeInt;
    P, Q : PWideChar;
    Res  : TBytes;
begin
  if SrcLength <= 0 then
    begin
      ProcessedChars := 0;
      SetLength(Result, 0);
      exit;
    end;
  L := SrcLength * 2;
  SetLength(Res, L);
  P := SrcP;
  Q := Pointer(Res);
  for I := 1 to SrcLength do
    begin
      Q^ := SwapUTF16Endian(P^);
      Inc(P);
      Inc(Q);
    end;
  ProcessedChars := SrcLength;
  Result := Res;
end;




{                                                                              }
{ UTF detection                                                                }
{                                                                              }
function DetectUTFFromBOM(const Buf: Pointer; const Size: NativeInt): TUTFEncoding;
var
  BE : Boolean;
begin
  if not Assigned(Buf) or (Size <= 0) then
    Result := utfeNone
  else
  if DetectUTF16BOM(Buf, Size, BE) then
    if BE then
      Result := utfeUTF16BE
    else
      Result := utfeUTF16LE
  else
  if DetectUTF8BOM(Buf, Size) then
    Result := utfeUTF8
  else
    Result := utfeNone;
end;

// Scans the text for sequences likely in an encoding and uses a heuristic scoring method
// to determine a likely encoding.
function DetectUTFFromText(const Buf: Pointer; const Size: NativeInt): TUTFEncoding;
var
  P : Pointer;
  L : NativeInt;

type
  TScoreFeature = (
      sfNone,
      sfUTF8Spacing,
      sfUTF16LESpacing,
      sfUTF16BESpacing,
      sfUTF8AsciiCommon,
      sfUTF16LEAsciiCommon,
      sfUTF16BEAsciiCommon
  );

var
  Score : array[TScoreFeature] of Int32;

const
  ScoreLimit = 8;

  function AddScore(AFeature: TScoreFeature): Boolean;
  var
    LScore : Int32;
  begin
    Inc(Score[AFeature]);
    LScore := Score[AFeature];
    if LScore >= ScoreLimit then
      Result := True
    else
      Result := False;
  end;

  function MaxScore: TScoreFeature;
  var
    LEnc : TScoreFeature;
    LEncMax : TScoreFeature;
    LEncScore : Int32;
  begin
    LEncMax := sfNone;
    LEncScore := 0;
    for LEnc := Low(LEnc) to High(LEnc) do
      if Score[LEnc] > LEncScore then
        begin
          LEncMax := LEnc;
          LEncScore := Score[LEnc];
        end;
    Result := LEncMax;
  end;

  function ByteIsAsciiCommon(const B: Byte): Boolean;
  begin
    Result := B in [
        Ord('A')..Ord('Z'),
        Ord('a')..Ord('z'),
        Ord('0')..Ord('9'),
        Ord('.'), Ord(','), Ord('!'), Ord(':'), Ord(';'),
        Ord('<'), Ord('>'),
        Ord('('), Ord(')'),
        Ord('{'), Ord('}'),
        Ord('='), Ord('+'), Ord('-'),
        Ord('#'), Ord('$'),
        Ord('"'), Ord(''''),
        Ord('@'),
        Ord('/'), Ord('\'),
        Ord(' '),
        9, 10, 13
      ];
  end;

  function WideIsAsciiCommonLE(const B: WideChar): Boolean;
  begin
    Result := (Ord(B) <= $7F) and
              ByteIsAsciiCommon(Byte(Ord(B)));
  end;

  function WideIsAsciiCommonBE(const B: WideChar): Boolean;
  var
    BSwap : WideChar;
  begin
    BSwap := SwapUTF16Endian(B);
    Result := WideIsAsciiCommonLE(BSwap);
  end;

const
  MaxScanSize = 16384;

var
  Q : PByte;

begin
  if not Assigned(Buf) or (Size <= 0) then
    begin
      Result := utfeNone;
      exit;
    end;
  FillChar(Score, SizeOf(Score), 0);
  P := Buf;
  L := Size;
  if L > MaxScanSize then
    L := MaxScanSize;
  while L >= SizeOf(WideChar) * 4 do
    begin
      case PWord32(P)^ of
        $000A000D,
        $000D000A,
        $000D000D,
        $000A000A,
        $000A0020,
        $000D0020,
        $00090009 :
          if AddScore(sfUTF16LESpacing) and (Score[sfUTF16LEAsciiCommon] >= ScoreLimit div 2) then
            begin
              Result := utfeUTF16LE;
              exit;
            end;
        $0A000D00,
        $0D000A00,
        $0D000D00,
        $0A000A00,
        $0A002000,
        $0D002000,
        $09000900 :
          if AddScore(sfUTF16BESpacing) and (Score[sfUTF16BEAsciiCommon] >= ScoreLimit div 2) then
            begin
              Result := utfeUTF16BE;
              exit;
            end;
        $0D0A0D0A,
        $0D0A2020,
        $0D0D0D0D,
        $0D0D2020,
        $0A0A0A0A,
        $0A0A2020,
        $09090909 :
          if AddScore(sfUTF8Spacing) and (Score[sfUTF8AsciiCommon] >= ScoreLimit div 2) then
            begin
              Result := utfeUTF8;
              exit;
            end;
      end;
      if WideIsAsciiCommonLE(PWideChar(P)[0]) and
         WideIsAsciiCommonLE(PWideChar(P)[1]) and
         WideIsAsciiCommonLE(PWideChar(P)[2]) and
         WideIsAsciiCommonLE(PWideChar(P)[3]) then
        if AddScore(sfUTF16LEAsciiCommon) and (Score[sfUTF16LESpacing] > 0) then
          begin
            Result := utfeUTF16LE;
            exit;
          end;
      if WideIsAsciiCommonBE(PWideChar(P)[0]) and
         WideIsAsciiCommonBE(PWideChar(P)[1]) and
         WideIsAsciiCommonBE(PWideChar(P)[2]) and
         WideIsAsciiCommonBE(PWideChar(P)[3]) then
        if AddScore(sfUTF16BEAsciiCommon) and (Score[sfUTF16BESpacing] > 0) then
          begin
            Result := utfeUTF16BE;
            exit;
          end;
      Q := PByte(P);
      if ByteIsAsciiCommon(Q^) then
        begin
          Inc(Q);
          if ByteIsAsciiCommon(Q^) then
            begin
              Inc(Q);
              if ByteIsAsciiCommon(Q^) then
                begin
                  Inc(Q);
                  if ByteIsAsciiCommon(Q^) then
                    begin
                      if AddScore(sfUTF8AsciiCommon) and (Score[sfUTF8Spacing] > 0) then
                        begin
                          Result := utfeUTF8;
                          exit;
                        end;
                    end;
                end;
            end;
        end;
      Inc(PWideChar(P));
      Dec(L, SizeOf(WideChar));
    end;
  case MaxScore of
    sfNone               : Result := utfeNone;
    sfUTF8Spacing        : Result := utfeUTF8;
    sfUTF16LESpacing     : Result := utfeUTF16LE;
    sfUTF16BESpacing     : Result := utfeUTF16BE;
    sfUTF8AsciiCommon    : Result := utfeUTF8;
    sfUTF16LEAsciiCommon : Result := utfeUTF16LE;
    sfUTF16BEAsciiCommon : Result := utfeUTF16BE;
  else
    Result := utfeNone;
  end;
end;

function DetectUTF(const Buf: Pointer; const Size: NativeInt): TUTFEncoding;
var
  R : TUTFEncoding;
begin
  R := DetectUTFFromBOM(Buf, Size);
  if R = utfeNone then
    R := DetectUTFFromText(Buf, Size);
  Result := R;
end;



{                                                                              }
{ Tests                                                                        }
{                                                                              }
{$IFDEF UTF_TEST}
{$ASSERTIONS ON}
procedure Test_UTF8;
const
  W1 : array[0..3] of WideChar = (#$0041, #$2262, #$0391, #$002E);
  W2 : array[0..2] of WideChar = (#$D55C, #$AD6D, #$C5B4);
  W3 : array[0..2] of WideChar = (#$65E5, #$672C, #$8A9E);
  S1 = RawByteString(#$41#$E2#$89#$A2#$CE#$91#$2E);
  S2 = RawByteString(#$ED#$95#$9C#$EA#$B5#$AD#$EC#$96#$B4);
  S3 = RawByteString(#$E6#$97#$A5#$E6#$9C#$AC#$E8#$AA#$9E);
begin
  // UTF-8 test cases from RFC 2279
  Assert(UnicodeStringToUTF8String(W1) = #$41#$E2#$89#$A2#$CE#$91#$2E, 'UnicodeStringToUTF8String');
  Assert(UnicodeStringToUTF8String(W2) = #$ED#$95#$9C#$EA#$B5#$AD#$EC#$96#$B4, 'UnicodeStringToUTF8String');
  Assert(UnicodeStringToUTF8String(W3) = #$E6#$97#$A5#$E6#$9C#$AC#$E8#$AA#$9E, 'UnicodeStringToUTF8String');
  Assert(UTF8StringToUnicodeString(S1) = W1, 'UTF8StringToUnicodeString');
  Assert(UTF8StringToUnicodeString(S2) = W2, 'UTF8StringToUnicodeString');
  Assert(UTF8StringToUnicodeString(S3) = W3, 'UTF8StringToUnicodeString');
  Assert(UTF8StringLength(S1) = 4, 'UTF8StringLength');
  Assert(UTF8StringLength(S2) = 3, 'UTF8StringLength');
  Assert(UTF8StringLength(S3) = 3, 'UTF8StringLength');
end;

procedure Test_UTF16;
const
  W1 : array[0..1] of WideChar = (#$D83D, #$DE00);
  W2 : array[0..1] of WideChar = (#$D83D, #$0000);
var
  Ch : UCS4Char;
  Size : Integer;
  D1 : array[0..1] of WideChar;
begin
  UCS4CharToUTF16LE($00, @D1[0], 4, Size);
  Assert(Size = 2);
  Assert(D1[0] = #$0000);

  UCS4CharToUTF16LE($41, @D1[0], 4, Size);
  Assert(Size = 2);
  Assert(D1[0] = #$0041);

  UCS4CharToUTF16LE($1234, @D1[0], 4, Size);
  Assert(Size = 2);
  Assert(D1[0] = #$1234);

  UCS4CharToUTF16LE($1F600, @D1[0], 4, Size);
  Assert(Size = 4);
  Assert(D1[0] = #$D83D);
  Assert(D1[1] = #$DE00);

  Assert(UTF16LEToUCS4Char(@W1[0], 4, Ch, Size));
  Assert(Size = 4);
  Assert(Ch = $1F600);

  Assert(not UTF16LEToUCS4Char(@W1[0], 2, Ch, Size));
  Assert(Size = 4);
  Assert(Ch = $D83D);

  Assert(not UTF16LEToUCS4Char(@W1[1], 2, Ch, Size));
  Assert(Size = 2);
  Assert(Ch = $DE00);

  Assert(not UTF16LEToUCS4Char(@W2[0], 4, Ch, Size));
  Assert(Size = 4);
  Assert(Ch = $D83D);

  Assert(UTF16LEToUCS4Char(@W2[1], 2, Ch, Size));
  Assert(Size = 2);
  Assert(Ch = $0000);
end;

procedure Test;
begin
  Test_UTF8;
  Test_UTF16;
end;
{$ENDIF}



end.

