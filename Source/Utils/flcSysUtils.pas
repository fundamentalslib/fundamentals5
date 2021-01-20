{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcSysUtils.pas                                          }
{   File version:     5.04                                                     }
{   Description:      System utility functions                                 }
{                                                                              }
{   Copyright:        Copyright (c) 1999-2020, David J Butler                  }
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
{   2018/08/13  5.01  Initial version from other units.                        }
{   2019/07/29  5.02  FPC/Linux fixes.                                         }
{   2020/06/08  5.03  Ensure zero terminated string has terminating zero.      }
{   2020/07/07  5.04  GetOSHomePath. EnsureOSPathSuffix.                       }
{                     GetApplicationFilename.                                  }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

unit flcSysUtils;

interface



{ OS Errors }

function  GetLastOSErrorCode: NativeInt;
function  GetLastOSErrorMessage: String;



{ Path utilities }

{$IFDEF MSWINDOWS}
const
  OSDirectorySeparatorChar = '\';
{$ENDIF}
{$IFDEF POSIX}
const
  OSDirectorySeparatorChar = '/';
{$ENDIF}

procedure EnsureOSPathSuffix(var APath: String);



{ System paths }

function  GetOSHomePath: String;



{ Application path }

function  GetFullApplicationFilename: String;



implementation

{$IFNDEF DELPHIXE2_UP}
{$IFDEF MSWINDOWS}
  {$DEFINE GetHomePath_WinAPI}
  {$DEFINE UseSHFolder}
{$ENDIF}
{$ENDIF}

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$IFDEF UseSHFolder}
  SHFolder, 
  {$ENDIF}
  {$ENDIF}

  {$IFDEF POSIX}
  {$IFDEF DELPHI}
  Posix.Errno,
  Posix.Unistd,
  {$ENDIF}
  {$ENDIF}

  {$IFDEF FREEPASCAL}
  {$IFDEF UNIX}
  BaseUnix,
  Unix,
  {$ENDIF}
  {$ENDIF}

  SysUtils;



{$IFDEF MSWINDOWS}
function GetLastOSErrorCode: NativeInt;
begin
  Result := NativeInt(Windows.GetLastError);
end;
{$ENDIF}

{$IFDEF DELPHI}
{$IFDEF POSIX}
function GetLastOSErrorCode: NativeInt;
begin
  Result := NativeInt(GetLastError);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF FREEPASCAL}
{$IFDEF UNIX}
function GetLastOSErrorCode: NativeInt;
begin
  Result := NativeInt(GetLastOSError);
end;
{$ENDIF}
{$ENDIF}



resourcestring
  SSystemError = 'System error #%d';

{$IFDEF MSWINDOWS}
{$IFDEF StringIsUnicode}
function GetLastOSErrorMessage: String;
const
  MAX_ERRORMESSAGE_LENGTH = 256;
var
  Err : Windows.DWORD;
  Buf : array[0..MAX_ERRORMESSAGE_LENGTH] of Word;
  Len : Windows.DWORD;
begin
  Err := Windows.GetLastError;
  FillChar(Buf, Sizeof(Buf), #0);
  Len := Windows.FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM, nil, Err, 0,
      @Buf, MAX_ERRORMESSAGE_LENGTH, nil);
  if Len <= 0 then
    Result := Format(SSystemError, [Err])
  else
    begin
      Buf[MAX_ERRORMESSAGE_LENGTH] := 0;
      Result := StrPas(PWideChar(@Buf));
    end;
end;
{$ELSE}
function GetLastOSErrorMessage: String;
const
  MAX_ERRORMESSAGE_LENGTH = 256;
var
  Err : Windows.DWORD;
  Buf : array[0..MAX_ERRORMESSAGE_LENGTH] of Byte;
  Len : Windows.DWORD;
begin
  Err := Windows.GetLastError;
  FillChar(Buf, Sizeof(Buf), #0);
  Len := Windows.FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM, nil, Err, 0,
      @Buf, MAX_ERRORMESSAGE_LENGTH, nil);
  if Len <= 0 then
    Result := Format(SSystemError, [Err])
  else
    begin
      Buf[MAX_ERRORMESSAGE_LENGTH] := 0;
      Result := StrPas(PAnsiChar(@Buf));
    end;
end;
{$ENDIF}
{$ENDIF}

{$IFDEF DELPHI}
{$IFDEF POSIX}
function GetLastOSErrorMessage: String;
begin
  Result := SysErrorMessage(GetLastError);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF FREEPASCAL}
{$IFDEF UNIX}
function GetLastOSErrorMessage: String;
begin
  Result := SysErrorMessage(GetLastOSError);
end;
{$ENDIF}
{$ENDIF}



{ Path utilities }

procedure EnsureOSPathSuffix(var APath: String);
var
  L : NativeInt;
begin
  L := Length(APath);
  if L = 0 then
    exit;
  if APath[L] = OSDirectorySeparatorChar then
    exit;
  Inc(L);
  SetLength(APath, L);
  APath[L] := OSDirectorySeparatorChar;
end;



{ System paths }

{$IFDEF GetHomePath_WinAPI}
function GetOSHomePath: String;
var
  Buf : array[0..MAX_PATH] of AnsiChar;
begin
  SetLastError(ERROR_SUCCESS);
  if SHGetFolderPath(0, CSIDL_APPDATA, 0, 0, @Buf) = S_OK then
    Result := StrPas(PAnsiChar(@Buf))
  else
    Result := '';
end;
{$ELSE}
function GetOSHomePath: String;
var
  Path : String;
begin
  Path := SysUtils.GetHomePath;
  Result := Path;
end;
{$ENDIF}



{ Application path }

function GetFullApplicationFilename: String;
var
  Filename : String;
begin
  Filename := ParamStr(0);
  if Filename <> '' then
    Filename := ExpandFileName(Filename);
  Result := Filename;
end;



end.

