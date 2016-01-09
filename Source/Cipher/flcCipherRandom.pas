{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcCipherRandom.pas                                      }
{   File version:     5.04                                                     }
{   Description:      Cipher random                                            }
{                                                                              }
{   Copyright:        Copyright (c) 2010-2016, David J Butler                  }
{                     All rights reserved.                                     }
{                     This file is licensed under the BSD License.             }
{                     See http://www.opensource.org/licenses/bsd-license.php   }
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
{   2010/12/17  4.01  Initial version                                          }
{   2013/09/25  4.02  UnicodeString version                                    }
{   2015/05/05  4.03  Multiple PRNGs and PRSS and SHA512 hash in random block  }
{                     generator.                                               }
{   2016/01/09  5.04  Revised for Fundamentals 5.                              }
{                                                                              }
{******************************************************************************}

{$INCLUDE flcCipher.inc}

unit flcCipherRandom;

interface

uses
  { Fundamentals }
  flcUtils;



procedure SecureRandomBuf(var Buf; const Size: Integer);

function  SecureRandomStrA(const Size: Integer): RawByteString;

function  SecureRandomHexStr(const Digits: Integer; const UpperCase: Boolean = True): String;
function  SecureRandomHexStrA(const Digits: Integer; const UpperCase: Boolean = True): RawByteString;
function  SecureRandomHexStrU(const Digits: Integer; const UpperCase: Boolean = True): UnicodeString;

function  SecureRandomLongWord: LongWord;



implementation

uses
  { Fundamentals }
  flcRandom,
  flcHash;



const
  SecureRandomBlockBits = 128;
  SecureRandomBlockSize = SecureRandomBlockBits div 8; // 16 bytes

type
  TSecureRandomBlock = array[0..SecureRandomBlockSize - 1] of Byte;
  PSecureRandomBlock = ^TSecureRandomBlock;

// produces a block of SecureRandomBlockSize bytes of secure random material
procedure SecureRandomBlockGenerator(var Block: TSecureRandomBlock);
const
  RandomSeedDataLen = 512 div 32;
var I : Integer;
    R512 : array[0..RandomSeedDataLen - 1] of LongWord;
    H512 : T512BitDigest;
    H256 : T256BitDigest;
    H128 : T128BitDigest;
begin
  try
    // initialise 512 bits with multiple Pseudo Random Numbers Generators (PRNG)
    // and Pseudo Random System State (PRSS)
    FillChar(R512, SizeOf(R512), $FF);
    R512[0] := R512[0] xor RandomSeed32;
    for I := 0 to RandomSeedDataLen - 1 do
      R512[I] := R512[I] xor RandomUniform32;
    R512[0] := R512[0] xor RandomSeed32;
    for I := 0 to RandomSeedDataLen - 1 do
      R512[I] := R512[I] xor urnRandom32;
    R512[0] := R512[0] xor RandomSeed32;
    // hash 512 bits using SHA512
    H512 := CalcSHA512(R512, SizeOf(R512));
    // hash 512 bits using SHA256
    H256 := CalcSHA256(H512, SizeOf(T512BitDigest));
    // hash 256 bits using MD5
    H128 := CalcMD5(H256, SizeOf(T256BitDigest));
    // result is 128 bits of secure pseudo random data
    Assert(SizeOf(H128) >= SecureRandomBlockSize);
    Move(H128, Block, SecureRandomBlockSize);
  finally
    SecureClear(H128, SizeOf(T128BitDigest));
    SecureClear(H256, SizeOf(T256BitDigest));
    SecureClear(H512, SizeOf(T512BitDigest));
    SecureClear(R512, SizeOf(R512));
  end;
end;

procedure SecureRandomBuf(var Buf; const Size: Integer);
var P : PSecureRandomBlock;
    L : Integer;
    B : TSecureRandomBlock;
begin
  P := @Buf;
  L := Size;
  while L >= SecureRandomBlockSize do
    begin
      SecureRandomBlockGenerator(P^);
      Inc(P);
      Dec(L, SecureRandomBlockSize);
    end;
  if L > 0 then
    begin
      SecureRandomBlockGenerator(B);
      Move(B, P^, L);
      SecureClear(B, SecureRandomBlockSize);
    end;
end;

function SecureRandomStrA(const Size: Integer): RawByteString;
begin
  SetLength(Result, Size);
  if Size <= 0 then
    exit;
  SecureRandomBuf(Result[1], Size);
end;

function SecureRandomHexStr(const Digits: Integer; const UpperCase: Boolean = True): String;
var B    : TSecureRandomBlock;
    S, T : String;
    L, N : Integer;
    P    : PLongWord;
    Q    : PChar;
begin
  if Digits <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(S, Digits);
  Q := PChar(S);
  L := Digits;
  while L >= 8 do
    begin
      SecureRandomBlockGenerator(B);
      P := @B;
      N := SecureRandomBlockSize div 4;
      while (L >= 8) and (N > 0) do
        begin
          T := LongWordToHex(P^, 8, UpperCase);
          Move(PChar(T)^, Q^, 8 * SizeOf(Char));
          SecureClearStr(T);
          Inc(Q, 8);
          Dec(N);
          Inc(P);
          Dec(L, 8);
        end;
    end;
  if L > 0 then
    begin
      SecureRandomBlockGenerator(B);
      P := @B;
      T := LongWordToHex(P^, L, UpperCase);
      Move(PChar(T)^, Q^, L * SizeOf(Char));
      SecureClearStr(T);
    end;
  SecureClear(B, SecureRandomBlockSize);
  Result := S;
end;

function SecureRandomHexStrA(const Digits: Integer; const UpperCase: Boolean): RawByteString;
var B    : TSecureRandomBlock;
    S, T : RawByteString;
    L, N : Integer;
    P    : PLongWord;
    Q    : PAnsiChar;
begin
  if Digits <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(S, Digits);
  Q := PAnsiChar(S);
  L := Digits;
  while L >= 8 do
    begin
      SecureRandomBlockGenerator(B);
      P := @B;
      N := SecureRandomBlockSize div 4;
      while (L >= 8) and (N > 0) do
        begin
          T := LongWordToHexA(P^, 8, UpperCase);
          Move(PAnsiChar(T)^, Q^, 8);
          SecureClearStrA(T);
          Inc(Q, 8);
          Dec(N);
          Inc(P);
          Dec(L, 8);
        end;
    end;
  if L > 0 then
    begin
      SecureRandomBlockGenerator(B);
      P := @B;
      T := LongWordToHexA(P^, L, UpperCase);
      Move(PAnsiChar(T)^, Q^, L);
      SecureClearStrA(T);
    end;
  SecureClear(B, SecureRandomBlockSize);
  Result := S;
end;

function SecureRandomHexStrU(const Digits: Integer; const UpperCase: Boolean): UnicodeString;
var B    : TSecureRandomBlock;
    S, T : UnicodeString;
    L, N : Integer;
    P    : PLongWord;
    Q    : PWideChar;
begin
  if Digits <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(S, Digits);
  Q := PWideChar(S);
  L := Digits;
  while L >= 8 do
    begin
      SecureRandomBlockGenerator(B);
      P := @B;
      N := SecureRandomBlockSize div 4;
      while (L >= 8) and (N > 0) do
        begin
          T := LongWordToHexU(P^, 8, UpperCase);
          Move(PWideChar(T)^, Q^, 8 * SizeOf(WideChar));
          SecureClear(T[1], 8 * SizeOf(WideChar));
          Inc(Q, 8);
          Dec(N);
          Inc(P);
          Dec(L, 8);
        end;
    end;
  if L > 0 then
    begin
      SecureRandomBlockGenerator(B);
      P := @B;
      T := LongWordToHexU(P^, L, UpperCase);
      Move(PWideChar(T)^, Q^, L * SizeOf(WideChar));
      SecureClear(T[1], 8 * SizeOf(WideChar));
    end;
  SecureClear(B, SecureRandomBlockSize);
  Result := S;
end;

function SecureRandomLongWord: LongWord;
var L : LongWord;
begin
  SecureRandomBuf(L, SizeOf(LongWord));
  Result := L;
  SecureClear(L, SizeOf(LongWord));
end;



end.

