{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcCharSet.pas                                           }
{   File version:     5.02                                                     }
{   Description:      Character/Byte set functions.                            }
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
{   2017/10/07  5.02  Moved functions from unit flcUtils.                      }
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
  {$DEFINE CHARSET_TEST}
{$ENDIF}
{$ENDIF}

unit flcCharSet;

interface

uses
  { Fundamentals }
  flcStdTypes;



{                                                                              }
{ Sets                                                                         }
{   Operations on byte and character sets.                                     }
{                                                                              }
const
  CompleteCharSet = [AnsiChar(#0)..AnsiChar(#255)];
  CompleteByteSet = [0..255];

function  WideCharInCharSet(const A: WideChar; const C: CharSet): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
function  CharInCharSet(const A: Char; const C: CharSet): Boolean;         {$IFDEF UseInline}inline;{$ENDIF}
function  AsCharSet(const C: array of AnsiChar): CharSet;
function  AsByteSet(const C: array of Byte): ByteSet;
procedure ComplementChar(var C: CharSet; const Ch: AnsiChar);
procedure ClearCharSet(var C: CharSet);
procedure FillCharSet(var C: CharSet);
procedure ComplementCharSet(var C: CharSet);
procedure AssignCharSet(var DestSet: CharSet; const SourceSet: CharSet); overload;
procedure Union(var DestSet: CharSet; const SourceSet: CharSet); overload;
procedure Difference(var DestSet: CharSet; const SourceSet: CharSet); overload;
procedure Intersection(var DestSet: CharSet; const SourceSet: CharSet); overload;
procedure XORCharSet(var DestSet: CharSet; const SourceSet: CharSet);
function  IsSubSet(const A, B: CharSet): Boolean;
function  IsEqual(const A, B: CharSet): Boolean; overload;
function  IsEmpty(const C: CharSet): Boolean;
function  IsComplete(const C: CharSet): Boolean;
function  CharCount(const C: CharSet): Integer; overload;
procedure ConvertCaseInsensitive(var C: CharSet);
function  CaseInsensitiveCharSet(const C: CharSet): CharSet;
{$IFDEF SupportAnsiString}
function  CharSetToStrA(const C: CharSet): AnsiString;
function  StrToCharSetA(const S: AnsiString): CharSet;
{$ENDIF}



{                                                                              }
{ Tests                                                                        }
{                                                                              }
{$IFDEF CHARSET_TEST}
procedure Test;
{$ENDIF}



implementation



{                                                                              }
{ Sets                                                                         }
{                                                                              }
function WideCharInCharSet(const A: WideChar; const C: CharSet): Boolean;
begin
  if Ord(A) >= $100 then
    Result := False
  else
    Result := AnsiChar(Ord(A)) in C;
end;

function CharInCharSet(const A: Char; const C: CharSet): Boolean;
begin
  {$IFDEF CharIsWide}
  if Ord(A) >= $100 then
    Result := False
  else
    Result := AnsiChar(Ord(A)) in C;
  {$ELSE}
  Result := A in C;
  {$ENDIF}
end;

function AsCharSet(const C: array of AnsiChar): CharSet;
var I: Integer;
begin
  Result := [];
  for I := 0 to High(C) do
    Include(Result, C[I]);
end;

function AsByteSet(const C: array of Byte): ByteSet;
var I: Integer;
begin
  Result := [];
  for I := 0 to High(C) do
    Include(Result, C[I]);
end;

{$IFDEF ASM386_DELPHI}
procedure ComplementChar(var C: CharSet; const Ch: AnsiChar);
asm
      MOVZX   ECX, DL
      BTC     [EAX], ECX
end;
{$ELSE}
procedure ComplementChar(var C: CharSet; const Ch: AnsiChar);
begin
  if Ch in C then
    Exclude(C, Ch)
  else
    Include(C, Ch);
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure ClearCharSet(var C: CharSet);
asm
      XOR     EDX, EDX
      MOV     [EAX], EDX
      MOV     [EAX + 4], EDX
      MOV     [EAX + 8], EDX
      MOV     [EAX + 12], EDX
      MOV     [EAX + 16], EDX
      MOV     [EAX + 20], EDX
      MOV     [EAX + 24], EDX
      MOV     [EAX + 28], EDX
end;
{$ELSE}
procedure ClearCharSet(var C: CharSet);
begin
  C := [];
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure FillCharSet(var C: CharSet);
asm
      MOV     EDX, $FFFFFFFF
      MOV     [EAX], EDX
      MOV     [EAX + 4], EDX
      MOV     [EAX + 8], EDX
      MOV     [EAX + 12], EDX
      MOV     [EAX + 16], EDX
      MOV     [EAX + 20], EDX
      MOV     [EAX + 24], EDX
      MOV     [EAX + 28], EDX
end;
{$ELSE}
procedure FillCharSet(var C: CharSet);
begin
  C := [AnsiChar(0)..AnsiChar(255)];
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure ComplementCharSet(var C: CharSet);
asm
      NOT     DWORD PTR [EAX]
      NOT     DWORD PTR [EAX + 4]
      NOT     DWORD PTR [EAX + 8]
      NOT     DWORD PTR [EAX + 12]
      NOT     DWORD PTR [EAX + 16]
      NOT     DWORD PTR [EAX + 20]
      NOT     DWORD PTR [EAX + 24]
      NOT     DWORD PTR [EAX + 28]
end;
{$ELSE}
procedure ComplementCharSet(var C: CharSet);
begin
  C := [AnsiChar(0)..AnsiChar(255)] - C;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure AssignCharSet(var DestSet: CharSet; const SourceSet: CharSet);
asm
      MOV     ECX, [EDX]
      MOV     [EAX], ECX
      MOV     ECX, [EDX + 4]
      MOV     [EAX + 4], ECX
      MOV     ECX, [EDX + 8]
      MOV     [EAX + 8], ECX
      MOV     ECX, [EDX + 12]
      MOV     [EAX + 12], ECX
      MOV     ECX, [EDX + 16]
      MOV     [EAX + 16], ECX
      MOV     ECX, [EDX + 20]
      MOV     [EAX + 20], ECX
      MOV     ECX, [EDX + 24]
      MOV     [EAX + 24], ECX
      MOV     ECX, [EDX + 28]
      MOV     [EAX + 28], ECX
end;
{$ELSE}
procedure AssignCharSet(var DestSet: CharSet; const SourceSet: CharSet);
begin
  DestSet := SourceSet;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure Union(var DestSet: CharSet; const SourceSet: CharSet);
asm
      MOV     ECX, [EDX]
      OR      [EAX], ECX
      MOV     ECX, [EDX + 4]
      OR      [EAX + 4], ECX
      MOV     ECX, [EDX + 8]
      OR      [EAX + 8], ECX
      MOV     ECX, [EDX + 12]
      OR      [EAX + 12], ECX
      MOV     ECX, [EDX + 16]
      OR      [EAX + 16], ECX
      MOV     ECX, [EDX + 20]
      OR      [EAX + 20], ECX
      MOV     ECX, [EDX + 24]
      OR      [EAX + 24], ECX
      MOV     ECX, [EDX + 28]
      OR      [EAX + 28], ECX
end;
{$ELSE}
procedure Union(var DestSet: CharSet; const SourceSet: CharSet);
begin
  DestSet := DestSet + SourceSet;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure Difference(var DestSet: CharSet; const SourceSet: CharSet);
asm
      MOV     ECX, [EDX]
      NOT     ECX
      AND     [EAX], ECX
      MOV     ECX, [EDX + 4]
      NOT     ECX
      AND     [EAX + 4], ECX
      MOV     ECX, [EDX + 8]
      NOT     ECX
      AND     [EAX + 8],ECX
      MOV     ECX, [EDX + 12]
      NOT     ECX
      AND     [EAX + 12], ECX
      MOV     ECX, [EDX + 16]
      NOT     ECX
      AND     [EAX + 16], ECX
      MOV     ECX, [EDX + 20]
      NOT     ECX
      AND     [EAX + 20], ECX
      MOV     ECX, [EDX + 24]
      NOT     ECX
      AND     [EAX + 24], ECX
      MOV     ECX, [EDX + 28]
      NOT     ECX
      AND     [EAX + 28], ECX
end;
{$ELSE}
procedure Difference(var DestSet: CharSet; const SourceSet: CharSet);
begin
  DestSet := DestSet - SourceSet;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure Intersection(var DestSet: CharSet; const SourceSet: CharSet);
asm
      MOV     ECX, [EDX]
      AND     [EAX], ECX
      MOV     ECX, [EDX + 4]
      AND     [EAX + 4], ECX
      MOV     ECX, [EDX + 8]
      AND     [EAX + 8], ECX
      MOV     ECX, [EDX + 12]
      AND     [EAX + 12], ECX
      MOV     ECX, [EDX + 16]
      AND     [EAX + 16], ECX
      MOV     ECX, [EDX + 20]
      AND     [EAX + 20], ECX
      MOV     ECX, [EDX + 24]
      AND     [EAX + 24], ECX
      MOV     ECX, [EDX + 28]
      AND     [EAX + 28], ECX
end;
{$ELSE}
procedure Intersection(var DestSet: CharSet; const SourceSet: CharSet);
begin
  DestSet := DestSet * SourceSet;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure XORCharSet(var DestSet: CharSet; const SourceSet: CharSet);
asm
      MOV     ECX, [EDX]
      XOR     [EAX], ECX
      MOV     ECX, [EDX + 4]
      XOR     [EAX + 4], ECX
      MOV     ECX, [EDX + 8]
      XOR     [EAX + 8], ECX
      MOV     ECX, [EDX + 12]
      XOR     [EAX + 12], ECX
      MOV     ECX, [EDX + 16]
      XOR     [EAX + 16], ECX
      MOV     ECX, [EDX + 20]
      XOR     [EAX + 20], ECX
      MOV     ECX, [EDX + 24]
      XOR     [EAX + 24], ECX
      MOV     ECX, [EDX + 28]
      XOR     [EAX + 28], ECX
end;
{$ELSE}
procedure XORCharSet(var DestSet: CharSet; const SourceSet: CharSet);
var Ch: AnsiChar;
begin
  for Ch := AnsiChar(0) to AnsiChar(255) do
    if Ch in DestSet then
      begin
        if Ch in SourceSet then
          Exclude(DestSet, Ch);
      end else
      if Ch in SourceSet then
        Include(DestSet, Ch);
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
function IsSubSet(const A, B: CharSet): Boolean;
asm
      MOV     ECX, [EDX]
      NOT     ECX
      AND     ECX, [EAX]
      JNE     @Fin0
      MOV     ECX, [EDX + 4]
      NOT     ECX
      AND     ECX, [EAX + 4]
      JNE     @Fin0
      MOV     ECX, [EDX + 8]
      NOT     ECX
      AND     ECX, [EAX + 8]
      JNE     @Fin0
      MOV     ECX, [EDX + 12]
      NOT     ECX
      AND     ECX, [EAX + 12]
      JNE     @Fin0
      MOV     ECX, [EDX + 16]
      NOT     ECX
      AND     ECX, [EAX + 16]
      JNE     @Fin0
      MOV     ECX, [EDX + 20]
      NOT     ECX
      AND     ECX, [EAX + 20]
      JNE     @Fin0
      MOV     ECX, [EDX + 24]
      NOT     ECX
      AND     ECX, [EAX + 24]
      JNE     @Fin0
      MOV     ECX, [EDX + 28]
      NOT     ECX
      AND     ECX, [EAX + 28]
      JNE     @Fin0
      MOV     EAX, 1
      RET
@Fin0:
      XOR     EAX, EAX
end;
{$ELSE}
function IsSubSet(const A, B: CharSet): Boolean;
begin
  Result := A <= B;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
function IsEqual(const A, B: CharSet): Boolean;
asm
      MOV     ECX, [EDX]
      XOR     ECX, [EAX]
      JNE     @Fin0
      MOV     ECX, [EDX + 4]
      XOR     ECX, [EAX + 4]
      JNE     @Fin0
      MOV     ECX, [EDX + 8]
      XOR     ECX, [EAX + 8]
      JNE     @Fin0
      MOV     ECX, [EDX + 12]
      XOR     ECX, [EAX + 12]
      JNE     @Fin0
      MOV     ECX, [EDX + 16]
      XOR     ECX, [EAX + 16]
      JNE     @Fin0
      MOV     ECX, [EDX + 20]
      XOR     ECX, [EAX + 20]
      JNE     @Fin0
      MOV     ECX, [EDX + 24]
      XOR     ECX, [EAX + 24]
      JNE     @Fin0
      MOV     ECX, [EDX + 28]
      XOR     ECX, [EAX + 28]
      JNE     @Fin0
      MOV     EAX, 1
      RET
@Fin0:
      XOR     EAX, EAX
end;
{$ELSE}
function IsEqual(const A, B: CharSet): Boolean;
begin
  Result := A = B;
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
function IsEmpty(const C: CharSet): Boolean;
asm
      MOV     EDX, [EAX]
      OR      EDX, [EAX + 4]
      OR      EDX, [EAX + 8]
      OR      EDX, [EAX + 12]
      OR      EDX, [EAX + 16]
      OR      EDX, [EAX + 20]
      OR      EDX, [EAX + 24]
      OR      EDX, [EAX + 28]
      JNE     @Fin0
      MOV     EAX, 1
      RET
@Fin0:
      XOR     EAX,EAX
end;
{$ELSE}
function IsEmpty(const C: CharSet): Boolean;
begin
  Result := C = [];
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
function IsComplete(const C: CharSet): Boolean;
asm
      MOV     EDX, [EAX]
      AND     EDX, [EAX + 4]
      AND     EDX, [EAX + 8]
      AND     EDX, [EAX + 12]
      AND     EDX, [EAX + 16]
      AND     EDX, [EAX + 20]
      AND     EDX, [EAX + 24]
      AND     EDX, [EAX + 28]
      CMP     EDX, $FFFFFFFF
      JNE     @Fin0
      MOV     EAX, 1
      RET
@Fin0:
      XOR     EAX, EAX
end;
{$ELSE}
function IsComplete(const C: CharSet): Boolean;
begin
  Result := C = CompleteCharSet;
end;
{$ENDIF}

{$IFDEF __ASM386_DELPHI}
function CharCount(const C: CharSet): Integer;
asm
      PUSH    EBX
      PUSH    ESI
      MOV     EBX, EAX
      XOR     ESI, ESI
      MOV     EAX, [EBX]
      CALL    BitCount32
      ADD     ESI, EAX
      MOV     EAX, [EBX + 4]
      CALL    BitCount32
      ADD     ESI, EAX
      MOV     EAX, [EBX + 8]
      CALL    BitCount32
      ADD     ESI, EAX
      MOV     EAX, [EBX + 12]
      CALL    BitCount32
      ADD     ESI, EAX
      MOV     EAX, [EBX + 16]
      CALL    BitCount32
      ADD     ESI, EAX
      MOV     EAX, [EBX + 20]
      CALL    BitCount32
      ADD     ESI, EAX
      MOV     EAX, [EBX + 24]
      CALL    BitCount32
      ADD     ESI, EAX
      MOV     EAX, [EBX + 28]
      CALL    BitCount32
      ADD     EAX, ESI
      POP     ESI
      POP     EBX
end;
{$ELSE}
function CharCount(const C: CharSet): Integer;
var I : AnsiChar;
begin
  Result := 0;
  for I := AnsiChar(0) to AnsiChar(255) do
    if I in C then
      Inc(Result);
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
procedure ConvertCaseInsensitive(var C: CharSet);
asm
      MOV     ECX, [EAX + 12]
      AND     ECX, $3FFFFFF
      OR      [EAX + 8], ECX
      MOV     ECX, [EAX + 8]
      AND     ECX, $3FFFFFF
      OR      [EAX + 12], ECX
end;
{$ELSE}
procedure ConvertCaseInsensitive(var C: CharSet);
var Ch : AnsiChar;
begin
  for Ch := AnsiChar(Ord('A')) to AnsiChar(Ord('Z')) do
    if Ch in C then
      Include(C, AnsiChar(Ord(Ch) + 32));
  for Ch := AnsiChar(Ord('a')) to AnsiChar(Ord('z')) do
    if Ch in C then
      Include(C, AnsiChar(Ord(Ch) - 32));
end;
{$ENDIF}

function CaseInsensitiveCharSet(const C: CharSet): CharSet;
begin
  AssignCharSet(Result, C);
  ConvertCaseInsensitive(Result);
end;

{$IFDEF SupportAnsiString}
{$IFDEF ASM386_DELPHI}
function CharSetToStrA(const C: CharSet): AnsiString; // Andrew N. Driazgov
asm
      PUSH    EBX
      MOV     ECX, $100
      MOV     EBX, EAX
      PUSH    ESI
      MOV     EAX, EDX
      SUB     ESP, ECX
      XOR     ESI, ESI
      XOR     EDX, EDX
@@lp: BT      [EBX], EDX
      JC      @@mm
@@nx: INC     EDX
      DEC     ECX
      JNE     @@lp
      MOV     ECX, ESI
      MOV     EDX, ESP
      CALL    System.@LStrFromPCharLen
      ADD     ESP, $100
      POP     ESI
      POP     EBX
      RET
@@mm: MOV     [ESP + ESI], DL
      INC     ESI
      JMP     @@nx
end;
{$ELSE}
function CharSetToStrA(const C: CharSet): AnsiString;
// Implemented recursively to avoid multiple memory allocations
  procedure CharMatch(const Start: AnsiChar; const Count: Integer);
  var Ch : AnsiChar;
  begin
    for Ch := Start to AnsiChar(255) do
      if Ch in C then
        begin
          if Ch = AnsiChar(255) then
            SetLength(Result, Count + 1)
          else
            CharMatch(AnsiChar(Byte(Ch) + 1), Count + 1);
          Result[Count + 1] := Ch;
          exit;
        end;
    SetLength(Result, Count);
  end;
begin
  CharMatch(AnsiChar(0), 0);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF SupportAnsiString}
{$IFDEF ASM386_DELPHI}
function StrToCharSetA(const S: AnsiString): CharSet; // Andrew N. Driazgov
asm
      XOR     ECX, ECX
      MOV     [EDX], ECX
      MOV     [EDX + 4], ECX
      MOV     [EDX + 8], ECX
      MOV     [EDX + 12], ECX
      MOV     [EDX + 16], ECX
      MOV     [EDX + 20], ECX
      MOV     [EDX + 24], ECX
      MOV     [EDX + 28], ECX
      TEST    EAX, EAX
      JE      @@qt
      MOV     ECX, [EAX - 4]
      PUSH    EBX
      SUB     ECX, 8
      JS      @@nx
@@lp: MOVZX   EBX, BYTE PTR [EAX]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 1]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 2]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 3]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 4]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 5]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 6]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 7]
      BTS     [EDX], EBX
      ADD     EAX, 8
      SUB     ECX, 8
      JNS     @@lp
@@nx: JMP     DWORD PTR @@tV[ECX * 4 + 32]
@@tV: DD      @@ex, @@t1, @@t2, @@t3
      DD      @@t4, @@t5, @@t6, @@t7
@@t7: MOVZX   EBX, BYTE PTR [EAX + 6]
      BTS     [EDX], EBX
@@t6: MOVZX   EBX, BYTE PTR [EAX + 5]
      BTS     [EDX], EBX
@@t5: MOVZX   EBX, BYTE PTR [EAX + 4]
      BTS     [EDX], EBX
@@t4: MOVZX   EBX, BYTE PTR [EAX + 3]
      BTS     [EDX], EBX
@@t3: MOVZX   EBX, BYTE PTR [EAX + 2]
      BTS     [EDX], EBX
@@t2: MOVZX   EBX, BYTE PTR [EAX + 1]
      BTS     [EDX], EBX
@@t1: MOVZX   EBX, BYTE PTR [EAX]
      BTS     [EDX], EBX
@@ex: POP     EBX
@@qt:
end;
{$ELSE}
function StrToCharSetA(const S: AnsiString): CharSet;
var I : Integer;
begin
  ClearCharSet(Result);
  for I := 1 to Length(S) do
    Include(Result, S[I]);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF CHARSET_TEST}
procedure Test;
begin
  // CharSet
  Assert(CharCount([]) = 0, 'CharCount');
  Assert(CharCount([AnsiChar(Ord('a'))..AnsiChar(Ord('z'))]) = 26, 'CharCount');
  Assert(CharCount([AnsiChar(0), AnsiChar(255)]) = 2, 'CharCount');
end;
{$ENDIF}



end.

