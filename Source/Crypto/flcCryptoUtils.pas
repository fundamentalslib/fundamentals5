{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcCryptoUtils.pas                                       }
{   File version:     5.01                                                     }
{   Description:      Crypto utils                                             }
{                                                                              }
{   Copyright:        Copyright (c) 2008-2021, David J Butler                  }
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
{   2020/12/29  5.01  Create flcCryptoUtils from Cipher units.                 }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}
{$INCLUDE flcCrypto.inc}

unit flcCryptoUtils;

interface

uses
  SysUtils,

  flcStdTypes;



{                                                                              }
{ Secure memory clear                                                          }
{   Used to clear keys and other sensitive data from memory.                   }
{   Memory is overwritten with zeros before releasing reference.               }
{                                                                              }
procedure SecureClearBuf(var Buf; const BufSize: NativeInt);
procedure SecureClearBytes(var B: TBytes);
procedure SecureClearStrB(var S: RawByteString);
procedure SecureClearStrU(var S: UnicodeString);
procedure SecureClearStr(var S: String);



implementation

{$IFNDEF SupportStringRefCount}
uses
  flcUtils;
{$ENDIF}



{                                                                              }
{ Secure memory clear                                                          }
{                                                                              }
procedure SecureClearBuf(var Buf; const BufSize: NativeInt);
begin
  if BufSize <= 0 then
    exit;
  FillChar(Buf, BufSize, #$00);
end;

procedure SecureClearBytes(var B: TBytes);
var
  L : NativeInt;
begin
  L := Length(B);
  if L = 0 then
    exit;
  SecureClearBuf(Pointer(B)^, L);
  SetLength(B, 0);
end;

procedure SecureClearStrB(var S: RawByteString);
var
  L : NativeInt;
begin
  L := Length(S);
  if L = 0 then
    exit;
  if StringRefCount(S) > 0 then
    SecureClearBuf(PByteChar(S)^, L);
  SetLength(S, 0);
end;

procedure SecureClearStrU(var S: UnicodeString);
var
  L : NativeInt;
begin
  L := Length(S);
  if L = 0 then
    exit;
  if StringRefCount(S) > 0 then
    SecureClearBuf(PWideChar(S)^, L * SizeOf(WideChar));
  S := '';
end;

procedure SecureClearStr(var S: String);
var
  L : NativeInt;
begin
  L := Length(S);
  if L = 0 then
    exit;
  if StringRefCount(S) > 0 then
    SecureClearBuf(PChar(S)^, L * SizeOf(Char));
  S := '';
end;



end.

