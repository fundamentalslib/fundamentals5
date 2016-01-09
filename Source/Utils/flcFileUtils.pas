{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcFileUtils.pas                                         }
{   File version:     5.14                                                     }
{   Description:      File name and file system functions                      }
{                                                                              }
{   Copyright:        Copyright (c) 2002-2016, David J Butler                  }
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
{   2002/06/01  3.01  Created cFileUtils from cSysUtils.                       }
{   2002/12/12  3.02  Revision.                                                }
{   2005/07/22  4.03  Compilable with FreePascal 2 Win32 i386.                 }
{   2005/08/21  4.04  Compilable with FreePascal 2 Linux i386.                 }
{   2005/09/20  4.05  Improved error handling.                                 }
{   2005/09/21  4.06  Revised for Fundamentals 4.                              }
{   2008/12/30  4.07  Revision.                                                }
{   2009/06/05  4.08  File access functions.                                   }
{   2009/07/30  4.09  File access functions.                                   }
{   2010/06/27  4.10  Compilable with FreePascal 2.4.0 OSX x86-64              }
{   2012/03/26  4.11  Unicode update.                                          }
{   2013/11/15  4.12  Unicode update.                                          }
{   2015/03/13  4.13  RawByteString functions.                                 }
{   2016/01/09  5.14  Revised for Fundamentals 5.                              }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 7 Win32                      5.14  2016/01/09                       }
{   Delphi XE7 Win32                    5.14  2016/01/09                       }
{   Delphi XE7 Win64                    5.14  2016/01/09                       }
{   Delphi 10 Win32                     5.14  2016/01/09                       }
{   Delphi 10 Win64                     5.14  2016/01/09                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}{$HINTS OFF}
{$ENDIF}
{$IFDEF DELPHI6_UP}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

unit flcFileUtils;

interface

uses
  { System }
  {$IFDEF MSWIN}
  Windows,
  {$ENDIF}
  SysUtils,

  { Fundamentals }
  flcUtils;



{                                                                              }
{ Path functions                                                               }
{                                                                              }
const
  UnixPathSeparator = '/';
  WinPathSeparator  = '\';
  PathSeparator = {$IFDEF UNIX}  UnixPathSeparator {$ENDIF}
                  {$IFDEF MSWIN} WinPathSeparator  {$ENDIF};

function  WinPathHasDriveLetterA(const Path: AnsiString): Boolean;
function  WinPathHasDriveLetterB(const Path: RawByteString): Boolean;
function  WinPathHasDriveLetterU(const Path: UnicodeString): Boolean;
function  WinPathHasDriveLetter(const Path: String): Boolean;

function  WinPathIsDriveLetterA(const Path: AnsiString): Boolean;
function  WinPathIsDriveLetterB(const Path: RawByteString): Boolean;
function  WinPathIsDriveLetterU(const Path: UnicodeString): Boolean;
function  WinPathIsDriveLetter(const Path: String): Boolean;

function  WinPathIsDriveRootA(const Path: AnsiString): Boolean;
function  WinPathIsDriveRootB(const Path: RawByteString): Boolean;
function  WinPathIsDriveRootU(const Path: UnicodeString): Boolean;
function  WinPathIsDriveRoot(const Path: String): Boolean;

function  PathIsRootA(const Path: AnsiString): Boolean;
function  PathIsRootB(const Path: RawByteString): Boolean;
function  PathIsRootU(const Path: UnicodeString): Boolean;
function  PathIsRoot(const Path: String): Boolean;

function  PathIsUNCPathA(const Path: AnsiString): Boolean;
function  PathIsUNCPathB(const Path: RawByteString): Boolean;
function  PathIsUNCPathU(const Path: UnicodeString): Boolean;
function  PathIsUNCPath(const Path: String): Boolean;

function  PathIsAbsoluteA(const Path: AnsiString): Boolean;
function  PathIsAbsoluteB(const Path: RawByteString): Boolean;
function  PathIsAbsoluteU(const Path: UnicodeString): Boolean;
function  PathIsAbsolute(const Path: String): Boolean;

function  PathIsDirectoryA(const Path: AnsiString): Boolean;
function  PathIsDirectoryB(const Path: RawByteString): Boolean;
function  PathIsDirectoryU(const Path: UnicodeString): Boolean;
function  PathIsDirectory(const Path: String): Boolean;

function  PathInclSuffixA(const Path: AnsiString;
          const PathSep: AnsiChar = PathSeparator): AnsiString;
function  PathInclSuffixB(const Path: RawByteString;
          const PathSep: AnsiChar = PathSeparator): RawByteString;
function  PathInclSuffixU(const Path: UnicodeString;
          const PathSep: WideChar = PathSeparator): UnicodeString;
function  PathInclSuffix(const Path: String;
          const PathSep: Char = PathSeparator): String;

function  PathExclSuffixA(const Path: AnsiString;
          const PathSep: AnsiChar = PathSeparator): AnsiString;
function  PathExclSuffixB(const Path: RawByteString;
          const PathSep: AnsiChar = PathSeparator): RawByteString;
function  PathExclSuffixU(const Path: UnicodeString;
          const PathSep: WideChar = PathSeparator): UnicodeString;
function  PathExclSuffix(const Path: String;
          const PathSep: Char = PathSeparator): String;

procedure PathEnsureSuffixA(var Path: AnsiString;
          const PathSep: AnsiChar = PathSeparator);
procedure PathEnsureSuffixB(var Path: RawByteString;
          const PathSep: AnsiChar = PathSeparator);
procedure PathEnsureSuffixU(var Path: UnicodeString;
          const PathSep: WideChar = PathSeparator);
procedure PathEnsureSuffix(var Path: String;
          const PathSep: Char = PathSeparator);

procedure PathEnsureNoSuffixA(var Path: AnsiString;
          const PathSep: AnsiChar = PathSeparator);
procedure PathEnsureNoSuffixB(var Path: RawByteString;
          const PathSep: AnsiChar = PathSeparator);
procedure PathEnsureNoSuffixU(var Path: UnicodeString;
          const PathSep: WideChar = PathSeparator);
procedure PathEnsureNoSuffix(var Path: String;
          const PathSep: Char = PathSeparator);

function  PathCanonicalA(const Path: AnsiString;
          const PathSep: AnsiChar = PathSeparator): AnsiString;
function  PathCanonicalB(const Path: RawByteString;
          const PathSep: AnsiChar = PathSeparator): RawByteString;
function  PathCanonicalU(const Path: UnicodeString;
          const PathSep: WideChar = PathSeparator): UnicodeString;
function  PathCanonical(const Path: String;
          const PathSep: Char = PathSeparator): String;

function  PathExpandA(const Path: AnsiString; const BasePath: AnsiString = '';
          const PathSep: AnsiChar = PathSeparator): AnsiString;
function  PathExpandB(const Path: RawByteString; const BasePath: RawByteString = '';
          const PathSep: AnsiChar = PathSeparator): RawByteString;
function  PathExpandU(const Path: UnicodeString; const BasePath: UnicodeString = '';
          const PathSep: WideChar = PathSeparator): UnicodeString;
function  PathExpand(const Path: String; const BasePath: String = '';
          const PathSep: Char = PathSeparator): String;

function  PathLeftElementA(const Path: AnsiString;
          const PathSep: AnsiChar = PathSeparator): AnsiString;
function  PathLeftElementB(const Path: RawByteString;
          const PathSep: AnsiChar = PathSeparator): RawByteString;
function  PathLeftElementU(const Path: UnicodeString;
          const PathSep: WideChar = PathSeparator): UnicodeString;
function  PathLeftElement(const Path: String;
          const PathSep: Char = PathSeparator): String;

procedure PathSplitLeftElementA(const Path: AnsiString;
          var LeftElement, RightPath: AnsiString;
          const PathSep: AnsiChar = PathSeparator);
procedure PathSplitLeftElementB(const Path: RawByteString;
          var LeftElement, RightPath: RawByteString;
          const PathSep: AnsiChar = PathSeparator);
procedure PathSplitLeftElementU(const Path: UnicodeString;
          var LeftElement, RightPath: UnicodeString;
          const PathSep: WideChar = PathSeparator);
procedure PathSplitLeftElement(const Path: String;
          var LeftElement, RightPath: String;
          const PathSep: Char = PathSeparator);

procedure DecodeFilePathA(const FilePath: AnsiString;
          var Path, FileName: AnsiString;
          const PathSep: AnsiChar = PathSeparator);
procedure DecodeFilePathB(const FilePath: RawByteString;
          var Path, FileName: RawByteString;
          const PathSep: AnsiChar = PathSeparator);
procedure DecodeFilePathU(const FilePath: UnicodeString;
          var Path, FileName: UnicodeString;
          const PathSep: WideChar = PathSeparator);
procedure DecodeFilePath(const FilePath: String;
          var Path, FileName: String;
          const PathSep: Char = PathSeparator);

function  PathExtractFileNameA(const FilePath: AnsiString;
          const PathSep: AnsiChar = PathSeparator): AnsiString;
function  PathExtractFileNameB(const FilePath: RawByteString;
          const PathSep: AnsiChar = PathSeparator): RawByteString;
function  PathExtractFileNameU(const FilePath: UnicodeString;
          const PathSep: WideChar = PathSeparator): UnicodeString;
function  PathExtractFileName(const FilePath: String;
          const PathSep: Char = PathSeparator): String;

function  PathExtractFileExtA(const FilePath: AnsiString;
          const PathSep: AnsiChar = PathSeparator): AnsiString;
function  PathExtractFileExtB(const FilePath: RawByteString;
          const PathSep: AnsiChar = PathSeparator): RawByteString;
function  PathExtractFileExtU(const FilePath: UnicodeString;
          const PathSep: WideChar = PathSeparator): UnicodeString;
function  PathExtractFileExt(const FilePath: String;
          const PathSep: Char = PathSeparator): String;

function  FileNameCleanA(const FileName: AnsiString): AnsiString;
function  FileNameCleanB(const FileName: RawByteString): RawByteString;
function  FileNameCleanU(const FileName: UnicodeString): UnicodeString;
function  FileNameClean(const FileName: String): String;

function  FilePathA(const FileName, Path: AnsiString; const BasePath: AnsiString = '';
          const PathSep: AnsiChar = PathSeparator): AnsiString;
function  FilePathB(const FileName, Path: RawByteString; const BasePath: RawByteString = '';
          const PathSep: AnsiChar = PathSeparator): RawByteString;
function  FilePathU(const FileName, Path: UnicodeString; const BasePath: UnicodeString = '';
          const PathSep: WideChar = PathSeparator): UnicodeString;
function  FilePath(const FileName, Path: String; const BasePath: String = '';
          const PathSep: Char = PathSeparator): String;

function  DirectoryExpandA(const Path: AnsiString; const BasePath: AnsiString = '';
          const PathSep: AnsiChar = PathSeparator): AnsiString;
function  DirectoryExpandB(const Path: RawByteString; const BasePath: RawByteString = '';
          const PathSep: AnsiChar = PathSeparator): RawByteString;
function  DirectoryExpandU(const Path: UnicodeString; const BasePath: UnicodeString = '';
          const PathSep: WideChar = PathSeparator): UnicodeString;
function  DirectoryExpand(const Path: String; const BasePath: String = '';
          const PathSep: Char = PathSeparator): String;

function  UnixPathToWinPath(const Path: AnsiString): AnsiString;
function  WinPathToUnixPath(const Path: AnsiString): AnsiString;



{                                                                              }
{ File errors                                                                  }
{                                                                              }
type
  TFileError = (
    feNone             {$IFDEF SupportEnumValue} = $00 {$ENDIF},
    feInvalidParameter {$IFDEF SupportEnumValue} = $01 {$ENDIF},

    feFileError        {$IFDEF SupportEnumValue} = $10 {$ENDIF},
    feFileOpenError    {$IFDEF SupportEnumValue} = $11 {$ENDIF},
    feFileCreateError  {$IFDEF SupportEnumValue} = $12 {$ENDIF},
    feFileSharingError {$IFDEF SupportEnumValue} = $13 {$ENDIF},
    feFileSeekError    {$IFDEF SupportEnumValue} = $14 {$ENDIF},
    feFileReadError    {$IFDEF SupportEnumValue} = $15 {$ENDIF},
    feFileWriteError   {$IFDEF SupportEnumValue} = $16 {$ENDIF},
    feFileSizeError    {$IFDEF SupportEnumValue} = $17 {$ENDIF},
    feFileExists       {$IFDEF SupportEnumValue} = $18 {$ENDIF},
    feFileDoesNotExist {$IFDEF SupportEnumValue} = $19 {$ENDIF},
    feFileMoveError    {$IFDEF SupportEnumValue} = $1A {$ENDIF},
    feFileDeleteError  {$IFDEF SupportEnumValue} = $1B {$ENDIF},

    feOutOfSpace       {$IFDEF SupportEnumValue} = $20 {$ENDIF},
    feOutOfResources   {$IFDEF SupportEnumValue} = $21 {$ENDIF},
    feInvalidFilePath  {$IFDEF SupportEnumValue} = $22 {$ENDIF},
    feInvalidFileName  {$IFDEF SupportEnumValue} = $23 {$ENDIF},
    feAccessDenied     {$IFDEF SupportEnumValue} = $24 {$ENDIF},
    feDeviceFailure    {$IFDEF SupportEnumValue} = $25 {$ENDIF}
  );

  EFileError = class(Exception)
  private
    FFileError : TFileError;

  public
    constructor Create(const FileError: TFileError; const Msg: string);
    constructor CreateFmt(const FileError: TFileError; const Msg: string; const Args: array of const);

    property FileError: TFileError read FFileError;
  end;



{                                                                              }
{ File operations                                                              }
{                                                                              }
type
  TFileHandle = Integer;

  TFileAccess = (
    faRead,
    faWrite,
    faReadWrite);

  TFileSharing = (
    fsDenyNone,
    fsDenyRead,
    fsDenyWrite,
    fsDenyReadWrite,
    fsExclusive);

  TFileOpenFlags = set of (
    foDeleteOnClose,
    foNoBuffering,
    foWriteThrough,
    foRandomAccessHint,
    foSequentialScanHint,
    foSeekToEndOfFile);

  TFileCreationMode = (
    fcCreateNew,
    fcCreateAlways,
    fcOpenExisting,
    fcOpenAlways,
    fcTruncateExisting);

  TFileSeekPosition = (
    fpOffsetFromStart,
    fpOffsetFromCurrent,
    fpOffsetFromEnd);

  PFileOpenWait = ^TFileOpenWait;
  TFileOpenWaitProcedure = procedure (const FileOpenWait: PFileOpenWait);
  TFileOpenWait = packed record
    Wait           : Boolean;
    UserData       : LongWord;
    Timeout        : Integer;
    RetryInterval  : Integer;
    RetryRandomise : Boolean;
    Callback       : TFileOpenWaitProcedure;
    Aborted        : Boolean;
    {$IFDEF MSWIN}
    Signal         : THandle;
    {$ENDIF}
  end;

function  FileOpenExA(
          const FileName: AnsiString;
          const FileAccess: TFileAccess = faRead;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileOpenFlags: TFileOpenFlags = [];
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): TFileHandle;
function  FileOpenExU(
          const FileName: UnicodeString;
          const FileAccess: TFileAccess;
          const FileSharing: TFileSharing;
          const FileOpenFlags: TFileOpenFlags;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait): TFileHandle;
function  FileOpenEx(
          const FileName: String;
          const FileAccess: TFileAccess;
          const FileSharing: TFileSharing;
          const FileOpenFlags: TFileOpenFlags = [];
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): TFileHandle;

function  FileSeekEx(
          const FileHandle: TFileHandle;
          const FileOffset: Int64;
          const FilePosition: TFileSeekPosition = fpOffsetFromStart): Int64;

function  FileReadEx(
          const FileHandle: TFileHandle;
          var Buf; const BufSize: Integer): Integer;

function  FileWriteEx(
          const FileHandle: TFileHandle;
          const Buf; const BufSize: Integer): Integer;

procedure FileCloseEx(
          const FileHandle: TFileHandle);

function  FindFirstA(const Path: AnsiString; Attr: Integer; var F: TSearchRec): Integer;
function  FindFirstU(const Path: UnicodeString; Attr: Integer; var F: TSearchRec): Integer;

function  FileExistsA(const FileName: AnsiString): Boolean;
function  FileExistsU(const FileName: UnicodeString): Boolean;
function  FileExists(const FileName: String): Boolean;

function  FileGetSizeA(const FileName: AnsiString): Int64;
function  FileGetSizeU(const FileName: UnicodeString): Int64;
function  FileGetSize(const FileName: String): Int64;

function  FileGetDateTimeA(const FileName: AnsiString): TDateTime;
function  FileGetDateTime(const FileName: String): TDateTime;

function  FileGetDateTime2(const FileName: String): TDateTime;
function  FileIsReadOnly(const FileName: String): Boolean;

procedure FileDeleteEx(const FileName: String);
procedure FileRenameEx(const OldFileName, NewFileName: String);

function  ReadFileBufA(
          const FileName: AnsiString;
          var Buf; const BufSize: Integer;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): Integer;
function  ReadFileBufU(
          const FileName: UnicodeString;
          var Buf; const BufSize: Integer;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): Integer;
function  ReadFileBuf(
          const FileName: String;
          var Buf; const BufSize: Integer;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): Integer;

function  ReadFileStrA(
          const FileName: AnsiString;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): RawByteString;
function  ReadFileStrU(
          const FileName: UnicodeString;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): RawByteString;
function  ReadFileStr(
          const FileName: String;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): RawByteString;

function  ReadFileBytesA(
          const FileName: AnsiString;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): TBytes;
function  ReadFileBytesU(
          const FileName: UnicodeString;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): TBytes;
function  ReadFileBytes(
          const FileName: String;
          const FileSharing: TFileSharing = fsDenyNone;
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil): TBytes;

procedure WriteFileBufA(
          const FileName: AnsiString;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing = fsDenyReadWrite;
          const FileCreationMode: TFileCreationMode = fcCreateAlways;
          const FileOpenWait: PFileOpenWait = nil);
procedure WriteFileBufU(
          const FileName: UnicodeString;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing = fsDenyReadWrite;
          const FileCreationMode: TFileCreationMode = fcCreateAlways;
          const FileOpenWait: PFileOpenWait = nil);
procedure WriteFileBuf(
          const FileName: String;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing = fsDenyReadWrite;
          const FileCreationMode: TFileCreationMode = fcCreateAlways;
          const FileOpenWait: PFileOpenWait = nil);

procedure WriteFileStrA(
          const FileName: AnsiString;
          const Buf: RawByteString;
          const FileSharing: TFileSharing = fsDenyReadWrite;
          const FileCreationMode: TFileCreationMode = fcCreateAlways;
          const FileOpenWait: PFileOpenWait = nil);
procedure WriteFileStrU(
          const FileName: UnicodeString;
          const Buf: RawByteString;
          const FileSharing: TFileSharing = fsDenyReadWrite;
          const FileCreationMode: TFileCreationMode = fcCreateAlways;
          const FileOpenWait: PFileOpenWait = nil);
procedure WriteFileStr(
          const FileName: String;
          const Buf: RawByteString;
          const FileSharing: TFileSharing = fsDenyReadWrite;
          const FileCreationMode: TFileCreationMode = fcCreateAlways;
          const FileOpenWait: PFileOpenWait = nil);

procedure WriteFileBytesA(
          const FileName: AnsiString;
          const Buf: TBytes;
          const FileSharing: TFileSharing = fsDenyReadWrite;
          const FileCreationMode: TFileCreationMode = fcCreateAlways;
          const FileOpenWait: PFileOpenWait = nil);
procedure WriteFileBytesU(
          const FileName: UnicodeString;
          const Buf: TBytes;
          const FileSharing: TFileSharing = fsDenyReadWrite;
          const FileCreationMode: TFileCreationMode = fcCreateAlways;
          const FileOpenWait: PFileOpenWait = nil);
procedure WriteFileBytes(
          const FileName: String;
          const Buf: TBytes;
          const FileSharing: TFileSharing = fsDenyReadWrite;
          const FileCreationMode: TFileCreationMode = fcCreateAlways;
          const FileOpenWait: PFileOpenWait = nil);

procedure AppendFileA(
          const FileName: AnsiString;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing = fsDenyWrite;
          const FileCreationMode: TFileCreationMode = fcOpenExisting;
          const FileOpenWait: PFileOpenWait = nil);
procedure AppendFileU(
          const FileName: UnicodeString;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing = fsDenyWrite;
          const FileCreationMode: TFileCreationMode = fcOpenAlways;
          const FileOpenWait: PFileOpenWait = nil);
procedure AppendFile(
          const FileName: String;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing = fsDenyWrite;
          const FileCreationMode: TFileCreationMode = fcOpenAlways;
          const FileOpenWait: PFileOpenWait = nil);

procedure AppendFileStrA(
          const FileName: AnsiString;
          const Buf: RawByteString;
          const FileSharing: TFileSharing = fsDenyWrite;
          const FileCreationMode: TFileCreationMode = fcOpenAlways;
          const FileOpenWait: PFileOpenWait = nil);
procedure AppendFileStrU(
          const FileName: UnicodeString;
          const Buf: RawByteString;
          const FileSharing: TFileSharing = fsDenyWrite;
          const FileCreationMode: TFileCreationMode = fcOpenAlways;
          const FileOpenWait: PFileOpenWait = nil);
procedure AppendFileStr(
          const FileName: String;
          const Buf: RawByteString;
          const FileSharing: TFileSharing = fsDenyWrite;
          const FileCreationMode: TFileCreationMode = fcOpenAlways;
          const FileOpenWait: PFileOpenWait = nil);

function  DirectoryEntryExistsA(const Name: AnsiString): Boolean;
function  DirectoryEntryExistsU(const Name: UnicodeString): Boolean;
function  DirectoryEntryExists(const Name: String): Boolean;

function  DirectoryEntrySizeA(const Name: AnsiString): Int64;
function  DirectoryEntrySizeU(const Name: UnicodeString): Int64;
function  DirectoryEntrySize(const Name: String): Int64;

function  DirectoryExistsA(const DirectoryName: AnsiString): Boolean;
function  DirectoryExistsU(const DirectoryName: UnicodeString): Boolean;
function  DirectoryExists(const DirectoryName: String): Boolean;

function  DirectoryGetDateTimeA(const DirectoryName: AnsiString): TDateTime;
function  DirectoryGetDateTimeU(const DirectoryName: UnicodeString): TDateTime;
function  DirectoryGetDateTime(const DirectoryName: String): TDateTime;

procedure DirectoryCreate(const DirectoryName: String);


{                                                                              }
{ File / Directory operations                                                  }
{   MoveFile first attempts a rename, then a copy and delete.                  }
{                                                                              }
function  GetFirstFileNameMatching(const FileMask: String): String;
function  DirEntryGetAttr(const FileName: AnsiString): Integer;
function  DirEntryIsDirectory(const FileName: AnsiString): Boolean;
function  FileHasAttr(const FileName: String; const Attr: Word): Boolean;

procedure CopyFile(const FileName, DestName: String);
procedure MoveFile(const FileName, DestName: String);
function  DeleteFiles(const FileMask: String): Boolean;



{$IFDEF MSWIN}
{                                                                              }
{ Logical Drive functions                                                      }
{                                                                              }
type
  TLogicalDriveType = (
      DriveRemovable,
      DriveFixed,
      DriveRemote,
      DriveCDRom,
      DriveRamDisk,
      DriveTypeUnknown);

function  DriveIsValid(const Drive: AnsiChar): Boolean;
function  DriveGetType(const Path: AnsiString): TLogicalDriveType;
function  DriveFreeSpace(const Path: AnsiString): Int64;
{$ENDIF}



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF DEBUG}
{$IFDEF TEST}
procedure Test;
{$ENDIF}
{$ENDIF}



implementation

uses
  { Fundamentals }
  flcBits32,
  flcDynArrays,
  flcStrings
  {$IFDEF UNIX}
  , BaseUnix
  {$IFDEF FREEPASCAL}
  , Unix
  {$ELSE}
  , libc
  {$ENDIF}
  {$ENDIF};



{$IFDEF DELPHI6_UP}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}


resourcestring
  SCannotOpenFile          = 'Cannot open file: %s: %s';
  SCannotCreateFile        = 'Cannot create file: %s: %s';
  SCannotMoveFile          = 'Cannot move file: %s: %s';
  SFileSizeError           = 'File size error: %s';
  SFileReadError           = 'File read error: %s';
  SFileWriteError          = 'File write error: %s: %s';
  SInvalidFileCreationMode = 'Invalid file creation mode';
  SFileExists              = 'File exists: %s';
  SFileDoesNotExist        = 'File does not exist: %s';
  SInvalidFileHandle       = 'Invalid file handle';
  SInvalidFilePosition     = 'Invalid file position';
  SFileSeekError           = 'File seek error: %s';
  SInvalidFileName         = 'Invalid file name';
  SInvalidPath             = 'Invalid path';
  SFileDeleteError         = 'File delete error: %s';
  SInvalidFileAccess       = 'Invalid file access';
  SInvalidFileSharing      = 'Invalid file sharing';



{                                                                              }
{ Path functions                                                               }
{                                                                              }
function WinPathHasDriveLetterA(const Path: AnsiString): Boolean;
begin
  Result := False;
  if Length(Path) < 2 then
    exit;
  case Path[1] of
    'A'..'Z', 'a'..'z' : ;
  else
    exit;
  end;
  if Path[2] <> ':' then
    exit;
  Result := True;
end;

function WinPathHasDriveLetterB(const Path: RawByteString): Boolean;
begin
  Result := False;
  if Length(Path) < 2 then
    exit;
  case Path[1] of
    'A'..'Z', 'a'..'z' : ;
  else
    exit;
  end;
  if Path[2] <> ':' then
    exit;
  Result := True;
end;

function WinPathHasDriveLetterU(const Path: UnicodeString): Boolean;
begin
  Result := False;
  if Length(Path) < 2 then
    exit;
  case Path[1] of
    'A'..'Z', 'a'..'z' : ;
  else
    exit;
  end;
  if Path[2] <> ':' then
    exit;
  Result := True;
end;

function WinPathHasDriveLetter(const Path: String): Boolean;
begin
  Result := False;
  if Length(Path) < 2 then
    exit;
  case Path[1] of
    'A'..'Z', 'a'..'z' : ;
  else
    exit;
  end;
  if Path[2] <> ':' then
    exit;
  Result := True;
end;

function WinPathIsDriveLetterA(const Path: AnsiString): Boolean;
begin
  Result := (Length(Path) = 2) and WinPathHasDriveLetterA(Path);
end;

function WinPathIsDriveLetterB(const Path: RawByteString): Boolean;
begin
  Result := (Length(Path) = 2) and WinPathHasDriveLetterB(Path);
end;

function WinPathIsDriveLetterU(const Path: UnicodeString): Boolean;
begin
  Result := (Length(Path) = 2) and WinPathHasDriveLetterU(Path);
end;

function WinPathIsDriveLetter(const Path: String): Boolean;
begin
  Result := (Length(Path) = 2) and WinPathHasDriveLetter(Path);
end;

function WinPathIsDriveRootA(const Path: AnsiString): Boolean;
begin
  Result := (Length(Path) = 3) and WinPathHasDriveLetterA(Path) and
            (Path[3] = '\');
end;

function WinPathIsDriveRootB(const Path: RawByteString): Boolean;
begin
  Result := (Length(Path) = 3) and WinPathHasDriveLetterB(Path) and
            (Path[3] = '\');
end;

function WinPathIsDriveRootU(const Path: UnicodeString): Boolean;
begin
  Result := (Length(Path) = 3) and WinPathHasDriveLetterU(Path) and
            (Path[3] = '\');
end;

function WinPathIsDriveRoot(const Path: String): Boolean;
begin
  Result := (Length(Path) = 3) and WinPathHasDriveLetter(Path) and
            (Path[3] = '\');
end;

function PathIsRootA(const Path: AnsiString): Boolean;
begin
  Result := ((Length(Path) = 1) and (Path[1] in csSlash)) or
            WinPathIsDriveRootA(Path);
end;

function PathIsRootB(const Path: RawByteString): Boolean;
begin
  Result := ((Length(Path) = 1) and (Path[1] in csSlash)) or
            WinPathIsDriveRootB(Path);
end;

function PathIsRootU(const Path: UnicodeString): Boolean;
begin
  Result := WinPathIsDriveRootU(Path);
  if Result then
    exit;
  if Length(Path) = 1 then
    case Path[1] of
      '/', '\' : Result := True;
    end;
end;

function PathIsRoot(const Path: String): Boolean;
begin
  Result := WinPathIsDriveRoot(Path);
  if Result then
    exit;
  if Length(Path) = 1 then
    case Path[1] of
      '/', '\' : Result := True;
    end;
end;

function PathIsUNCPathA(const Path: AnsiString): Boolean;
var P: PAnsiChar;
begin
  Result := False;
  if Length(Path) < 2 then
    exit;
  P := Pointer(Path);
  if P^ <> '\' then
    exit;
  Inc(P);
  if P^ <> '\' then
    exit;
  Result := True;
end;

function PathIsUNCPathB(const Path: RawByteString): Boolean;
var P: PAnsiChar;
begin
  Result := False;
  if Length(Path) < 2 then
    exit;
  P := Pointer(Path);
  if P^ <> '\' then
    exit;
  Inc(P);
  if P^ <> '\' then
    exit;
  Result := True;
end;

function PathIsUNCPathU(const Path: UnicodeString): Boolean;
begin
  Result := False;
  if Length(Path) < 2 then
    exit;
  if Path[1] <> '\' then
    exit;
  if Path[2] <> '\' then
    exit;
  Result := True;
end;

function PathIsUNCPath(const Path: String): Boolean;
begin
  Result := False;
  if Length(Path) < 2 then
    exit;
  if Path[1] <> '\' then
    exit;
  if Path[2] <> '\' then
    exit;
  Result := True;
end;

function PathIsAbsoluteA(const Path: AnsiString): Boolean;
begin
  if Path = '' then
    Result := False else
  if WinPathHasDriveLetterA(Path) then
    Result := True else
  if PAnsiChar(Pointer(Path))^ in ['\', '/'] then
    Result := True
  else
    Result := False;
end;

function PathIsAbsoluteB(const Path: RawByteString): Boolean;
begin
  if Path = '' then
    Result := False else
  if WinPathHasDriveLetterB(Path) then
    Result := True else
  if PAnsiChar(Pointer(Path))^ in ['\', '/'] then
    Result := True
  else
    Result := False;
end;

function PathIsAbsoluteU(const Path: UnicodeString): Boolean;
begin
  if Path = '' then
    Result := False else
  if WinPathHasDriveLetterU(Path) then
    Result := True
  else
    case Path[1] of
      '\', '/' : Result := True;
    else
      Result := False;
    end;
end;

function PathIsAbsolute(const Path: String): Boolean;
begin
  if Path = '' then
    Result := False else
  if WinPathHasDriveLetter(Path) then
    Result := True
  else
    case Path[1] of
      '\', '/' : Result := True;
    else
      Result := False;
    end;
end;

function PathIsDirectoryA(const Path: AnsiString): Boolean;
var L: Integer;
    P: PAnsiChar;
begin
  L := Length(Path);
  if L = 0 then
    Result := False else
  if (L = 2) and WinPathHasDriveLetterA(Path) then
    Result := True else
    begin
      P := Pointer(Path);
      Inc(P, L - 1);
      Result := P^ in csSlash;
    end;
end;

function PathIsDirectoryB(const Path: RawByteString): Boolean;
var L: Integer;
    P: PAnsiChar;
begin
  L := Length(Path);
  if L = 0 then
    Result := False else
  if (L = 2) and WinPathHasDriveLetterB(Path) then
    Result := True else
    begin
      P := Pointer(Path);
      Inc(P, L - 1);
      Result := P^ in csSlash;
    end;
end;

function PathIsDirectoryU(const Path: UnicodeString): Boolean;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := False else
  if (L = 2) and WinPathHasDriveLetterU(Path) then
    Result := True
  else
    case Path[L] of
      '/', '\' : Result := True;
    else
      Result := False;
    end;
end;

function PathIsDirectory(const Path: String): Boolean;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := False else
  if (L = 2) and WinPathHasDriveLetter(Path) then
    Result := True
  else
    case Path[L] of
      '/', '\' : Result := True;
    else
      Result := False;
    end;
end;

function PathInclSuffixA(const Path: AnsiString; const PathSep: AnsiChar): AnsiString;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := ''
  else
    begin
      if Path[L] = PathSep then
        Result := Path
      else
        Result := Path + PathSep;
    end;
end;

function PathInclSuffixB(const Path: RawByteString; const PathSep: AnsiChar): RawByteString;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := ''
  else
    begin
      if Path[L] = PathSep then
        Result := Path
      else
        Result := Path + PathSep;
    end;
end;

function PathInclSuffixU(const Path: UnicodeString; const PathSep: WideChar): UnicodeString;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := ''
  else
    begin
      if Path[L] = PathSep then
        Result := Path
      else
        Result := Path + PathSep;
    end;
end;

function PathInclSuffix(const Path: String; const PathSep: Char): String;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := ''
  else
    begin
      if Path[L] = PathSep then
        Result := Path
      else
        Result := Path + PathSep;
    end;
end;

procedure PathEnsureSuffixA(var Path: AnsiString; const PathSep: AnsiChar);
begin
  Path := PathInclSuffixA(Path, PathSep);
end;

procedure PathEnsureSuffixB(var Path: RawByteString; const PathSep: AnsiChar);
begin
  Path := PathInclSuffixB(Path, PathSep);
end;

procedure PathEnsureSuffixU(var Path: UnicodeString; const PathSep: WideChar);
begin
  Path := PathInclSuffixU(Path, PathSep);
end;

procedure PathEnsureSuffix(var Path: String; const PathSep: Char);
begin
  Path := PathInclSuffix(Path, PathSep);
end;

procedure PathEnsureNoSuffixA(var Path: AnsiString; const PathSep: AnsiChar);
begin
  Path := PathExclSuffixA(Path, PathSep);
end;

procedure PathEnsureNoSuffixB(var Path: RawByteString; const PathSep: AnsiChar);
begin
  Path := PathExclSuffixB(Path, PathSep);
end;

procedure PathEnsureNoSuffixU(var Path: UnicodeString; const PathSep: WideChar);
begin
  Path := PathExclSuffixU(Path, PathSep);
end;

procedure PathEnsureNoSuffix(var Path: String; const PathSep: Char);
begin
  Path := PathExclSuffix(Path, PathSep);
end;

function PathExclSuffixA(const Path: AnsiString; const PathSep: AnsiChar): AnsiString;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := '' else
    begin
      if Path[L] = PathSep then
        Result := Copy(Path, 1, L - 1)
      else
        Result := Path;
    end;
end;

function PathExclSuffixB(const Path: RawByteString; const PathSep: AnsiChar): RawByteString;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := '' else
    begin
      if Path[L] = PathSep then
        Result := Copy(Path, 1, L - 1)
      else
        Result := Path;
    end;
end;

function PathExclSuffixU(const Path: UnicodeString; const PathSep: WideChar): UnicodeString;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := '' else
    begin
      if Path[L] = PathSep then
        Result := Copy(Path, 1, L - 1)
      else
        Result := Path;
    end;
end;

function PathExclSuffix(const Path: String; const PathSep: Char): String;
var L: Integer;
begin
  L := Length(Path);
  if L = 0 then
    Result := '' else
    begin
      if Path[L] = PathSep then
        Result := Copy(Path, 1, L - 1)
      else
        Result := Path;
    end;
end;

function PathCanonicalA(const Path: AnsiString; const PathSep: AnsiChar): AnsiString;
var L, M : Integer;
    I, J : Integer;
    P    : AnsiStringArray;
    Q    : PAnsiChar;
begin
  Result := Path;
  // \.\ references
  M := Length(Result);
  repeat
    L := M;
    if L = 0 then
      exit;
    Result := StrReplaceA('\.\', '\', Result);
    Result := StrReplaceA('/./', '/', Result);
    M := Length(Result);
  until L = M;
  // .\ prefix
  StrEnsureNoPrefixA(Result, '.\');
  StrEnsureNoPrefixA(Result, './');
  // \. suffix
  StrEnsureNoSuffixA(Result, '\.');
  StrEnsureNoSuffixA(Result, '/.');
  // ..
  if PosStrA('..', Result) > 0 then
    begin
      P := StrSplitCharA(Result, PathSep);
      repeat
        J := -1;
        For I := Length(P) - 1 downto 0 do
          if P[I] = '..' then
            begin
              J := I;
              break;
            end;
        if J = -1 then
          break;
        M := -1;
        For I := J - 1 downto 0 do
          if (P[I] = '') or ((I = 0) and WinPathHasDriveLetterA(P[I])) then
            break else
          if P[I] <> '..' then
            begin
              M := I;
              break;
            end;
        if M = -1 then
          break;
        DynArrayRemoveA(P, J, 1);
        DynArrayRemoveA(P, M, 1);
      until False;
      Result := StrJoinCharA(P, PathSep);
    end;
  // \..\ prefix
  while StrMatchLeftA(Result, '\..\') do
    Delete(Result, 1, 3);
  while StrMatchLeftA(Result, '/../') do
    Delete(Result, 1, 3);
  if (Result = '\..') or (Result = '/..') then
    Result := '';
  L := Length(Result);
  if L = 0 then
    exit;
  // X:\..\ prefix
  Q := Pointer(Result);
  if Q^ in ['A'..'Z', 'a'..'z'] then
    begin
      if StrMatchA(Result, ':\..\', 2) then
        Delete(Result, 4, 3) else
      if (L = 5) and StrMatchA(Result, ':\..', 2) then
        begin
          SetLength(Result, 2);
          exit;
        end;
      L := Length(Result);
    end;
  // single dot
  Q := Pointer(Result);
  if L = 1 then
    begin
      if Q^ = '.' then
        Result := '';
      exit;
    end;
  // final dot
  Inc(Q, L - 2);
  if not (Q^ in ['.', '\', '/', ':']) then
    begin
      Inc(Q);
      if Q^ = '.' then
        Delete(Result, L, 1);
    end;
end;

function PathCanonicalB(const Path: RawByteString; const PathSep: AnsiChar): RawByteString;
var L, M : Integer;
    I, J : Integer;
    P    : RawByteStringArray;
    Q    : PAnsiChar;
begin
  Result := Path;
  // \.\ references
  M := Length(Result);
  repeat
    L := M;
    if L = 0 then
      exit;
    Result := StrReplaceB('\.\', '\', Result);
    Result := StrReplaceB('/./', '/', Result);
    M := Length(Result);
  until L = M;
  // .\ prefix
  StrEnsureNoPrefixB(Result, '.\');
  StrEnsureNoPrefixB(Result, './');
  // \. suffix
  StrEnsureNoSuffixB(Result, '\.');
  StrEnsureNoSuffixB(Result, '/.');
  // ..
  if PosStrB('..', Result) > 0 then
    begin
      P := StrSplitCharB(Result, PathSep);
      repeat
        J := -1;
        For I := Length(P) - 1 downto 0 do
          if P[I] = '..' then
            begin
              J := I;
              break;
            end;
        if J = -1 then
          break;
        M := -1;
        For I := J - 1 downto 0 do
          if (P[I] = '') or ((I = 0) and WinPathHasDriveLetterB(P[I])) then
            break else
          if P[I] <> '..' then
            begin
              M := I;
              break;
            end;
        if M = -1 then
          break;
        DynArrayRemoveB(P, J, 1);
        DynArrayRemoveB(P, M, 1);
      until False;
      Result := StrJoinCharB(P, PathSep);
    end;
  // \..\ prefix
  while StrMatchLeftB(Result, '\..\') do
    Delete(Result, 1, 3);
  while StrMatchLeftB(Result, '/../') do
    Delete(Result, 1, 3);
  if (Result = '\..') or (Result = '/..') then
    Result := '';
  L := Length(Result);
  if L = 0 then
    exit;
  // X:\..\ prefix
  Q := Pointer(Result);
  if Q^ in ['A'..'Z', 'a'..'z'] then
    begin
      if StrMatchB(Result, ':\..\', 2) then
        Delete(Result, 4, 3) else
      if (L = 5) and StrMatchB(Result, ':\..', 2) then
        begin
          SetLength(Result, 2);
          exit;
        end;
      L := Length(Result);
    end;
  // single dot
  Q := Pointer(Result);
  if L = 1 then
    begin
      if Q^ = '.' then
        Result := '';
      exit;
    end;
  // final dot
  Inc(Q, L - 2);
  if not (Q^ in ['.', '\', '/', ':']) then
    begin
      Inc(Q);
      if Q^ = '.' then
        Delete(Result, L, 1);
    end;
end;

function PathCanonicalU(const Path: UnicodeString; const PathSep: WideChar): UnicodeString;
var L, M : Integer;
    I, J : Integer;
    P    : UnicodeStringArray;
    Q    : PWideChar;
    C    : WideChar;
begin
  Result := Path;
  // \.\ references
  M := Length(Result);
  repeat
    L := M;
    if L = 0 then
      exit;
    Result := StrReplaceU('\.\', '\', Result);
    Result := StrReplaceU('/./', '/', Result);
    M := Length(Result);
  until L = M;
  // .\ prefix
  StrEnsureNoPrefixU(Result, '.\');
  StrEnsureNoPrefixU(Result, './');
  // \. suffix
  StrEnsureNoSuffixU(Result, '\.');
  StrEnsureNoSuffixU(Result, '/.');
  // ..
  if PosStrU('..', Result) > 0 then
    begin
      P := StrSplitCharU(Result, PathSep);
      repeat
        J := -1;
        For I := Length(P) - 1 downto 0 do
          if P[I] = '..' then
            begin
              J := I;
              break;
            end;
        if J = -1 then
          break;
        M := -1;
        For I := J - 1 downto 0 do
          if (P[I] = '') or ((I = 0) and WinPathHasDriveLetterU(P[I])) then
            break else
          if P[I] <> '..' then
            begin
              M := I;
              break;
            end;
        if M = -1 then
          break;
        DynArrayRemoveU(P, J, 1);
        DynArrayRemoveU(P, M, 1);
      until False;
      Result := StrJoinCharU(P, PathSep);
    end;
  // \..\ prefix
  while StrMatchLeftU(Result, '\..\') do
    Delete(Result, 1, 3);
  while StrMatchLeftU(Result, '/../') do
    Delete(Result, 1, 3);
  if (Result = '\..') or (Result = '/..') then
    Result := '';
  L := Length(Result);
  if L = 0 then
    exit;
  // X:\..\ prefix
  Q := Pointer(Result);
  case Q^ of
    'A'..'Z',
    'a'..'z' :
      begin
        if StrMatchU(Result, ':\..\', 2) then
          Delete(Result, 4, 3) else
        if (L = 5) and StrMatchU(Result, ':\..', 2) then
          begin
            SetLength(Result, 2);
            exit;
          end;
        L := Length(Result);
      end;
  end;
  // single dot
  Q := Pointer(Result);
  if L = 1 then
    begin
      if Q^ = '.' then
        Result := '';
      exit;
    end;
  // final dot
  Inc(Q, L - 2);
  C := Q^;
  if not ((C = '.') or (C = '\') or (C = '/') or (C = ':')) then
    begin
      Inc(Q);
      if Q^ = '.' then
        Delete(Result, L, 1);
    end;
end;

function PathCanonical(const Path: String; const PathSep: Char): String;
var L, M : Integer;
    I, J : Integer;
    P    : StringArray;
    Q    : PChar;
    C    : Char;
begin
  Result := Path;
  // \.\ references
  M := Length(Result);
  repeat
    L := M;
    if L = 0 then
      exit;
    Result := StrReplace('\.\', '\', Result);
    Result := StrReplace('/./', '/', Result);
    M := Length(Result);
  until L = M;
  // .\ prefix
  StrEnsureNoPrefix(Result, '.\');
  StrEnsureNoPrefix(Result, './');
  // \. suffix
  StrEnsureNoSuffix(Result, '\.');
  StrEnsureNoSuffix(Result, '/.');
  // ..
  if PosStr('..', Result) > 0 then
    begin
      P := StrSplitChar(Result, PathSep);
      repeat
        J := -1;
        For I := Length(P) - 1 downto 0 do
          if P[I] = '..' then
            begin
              J := I;
              break;
            end;
        if J = -1 then
          break;
        M := -1;
        For I := J - 1 downto 0 do
          if (P[I] = '') or ((I = 0) and WinPathHasDriveLetter(P[I])) then
            break else
          if P[I] <> '..' then
            begin
              M := I;
              break;
            end;
        if M = -1 then
          break;
        DynArrayRemove(P, J, 1);
        DynArrayRemove(P, M, 1);
      until False;
      Result := StrJoinChar(P, PathSep);
    end;
  // \..\ prefix
  while StrMatchLeft(Result, '\..\') do
    Delete(Result, 1, 3);
  while StrMatchLeft(Result, '/../') do
    Delete(Result, 1, 3);
  if (Result = '\..') or (Result = '/..') then
    Result := '';
  L := Length(Result);
  if L = 0 then
    exit;
  // X:\..\ prefix
  Q := Pointer(Result);
  C := Q^;
  if ((C >= 'A') and (C <= 'Z')) or
     ((C >= 'a') and (C <= 'z')) then
    begin
      if StrMatch(Result, ':\..\', 2) then
        Delete(Result, 4, 3) else
      if (L = 5) and StrMatch(Result, ':\..', 2) then
        begin
          SetLength(Result, 2);
          exit;
        end;
      L := Length(Result);
    end;
  // single dot
  Q := Pointer(Result);
  if L = 1 then
    begin
      if Q^ = '.' then
        Result := '';
      exit;
    end;
  // final dot
  Inc(Q, L - 2);
  C := Q^;
  if not ((C = '.') or (C = '\') or (C = '/') or (C = ':')) then
    begin
      Inc(Q);
      if Q^ = '.' then
        Delete(Result, L, 1);
    end;
end;

function PathExpandA(const Path: AnsiString; const BasePath: AnsiString;
    const PathSep: AnsiChar): AnsiString;
begin
  if Path = '' then
    Result := BasePath else
  if PathIsAbsoluteA(Path) then
    Result := Path else
    Result := PathInclSuffixA(BasePath, PathSep) + Path;
  Result := PathCanonicalA(Result, PathSep);
end;

function PathExpandB(const Path: RawByteString; const BasePath: RawByteString;
    const PathSep: AnsiChar): RawByteString;
begin
  if Path = '' then
    Result := BasePath else
  if PathIsAbsoluteB(Path) then
    Result := Path else
    Result := PathInclSuffixB(BasePath, PathSep) + Path;
  Result := PathCanonicalB(Result, PathSep);
end;

function PathExpandU(const Path: UnicodeString; const BasePath: UnicodeString;
    const PathSep: WideChar): UnicodeString;
begin
  if Path = '' then
    Result := BasePath else
  if PathIsAbsoluteU(Path) then
    Result := Path else
    Result := PathInclSuffixU(BasePath, PathSep) + Path;
  Result := PathCanonicalU(Result, PathSep);
end;

function PathExpand(const Path: String; const BasePath: String;
    const PathSep: Char): String;
begin
  if Path = '' then
    Result := BasePath else
  if PathIsAbsolute(Path) then
    Result := Path else
    Result := PathInclSuffix(BasePath, PathSep) + Path;
  Result := PathCanonical(Result, PathSep);
end;

function PathLeftElementA(const Path: AnsiString; const PathSep: AnsiChar): AnsiString;
var I: Integer;
begin
  I := PosCharA(PathSep, Path);
  if I <= 0 then
    Result := Path
  else
    Result := Copy(Path, 1, I - 1);
end;

function PathLeftElementB(const Path: RawByteString; const PathSep: AnsiChar): RawByteString;
var I: Integer;
begin
  I := PosCharB(PathSep, Path);
  if I <= 0 then
    Result := Path
  else
    Result := Copy(Path, 1, I - 1);
end;

function PathLeftElementU(const Path: UnicodeString; const PathSep: WideChar): UnicodeString;
var I: Integer;
begin
  I := PosCharU(PathSep, Path);
  if I <= 0 then
    Result := Path
  else
    Result := Copy(Path, 1, I - 1);
end;

function PathLeftElement(const Path: String; const PathSep: Char): String;
var I: Integer;
begin
  I := PosChar(PathSep, Path);
  if I <= 0 then
    Result := Path
  else
    Result := Copy(Path, 1, I - 1);
end;

procedure PathSplitLeftElementA(const Path: AnsiString;
    var LeftElement, RightPath: AnsiString; const PathSep: AnsiChar);
var I: Integer;
begin
  I := PosCharA(PathSep, Path);
  if I <= 0 then
    begin
      LeftElement := Path;
      RightPath := '';
    end
  else
    begin
      LeftElement := Copy(Path, 1, I - 1);
      RightPath := CopyFromA(Path, I + 1);
    end;
end;

procedure PathSplitLeftElementB(const Path: RawByteString;
    var LeftElement, RightPath: RawByteString; const PathSep: AnsiChar);
var I: Integer;
begin
  I := PosCharB(PathSep, Path);
  if I <= 0 then
    begin
      LeftElement := Path;
      RightPath := '';
    end
  else
    begin
      LeftElement := Copy(Path, 1, I - 1);
      RightPath := CopyFromB(Path, I + 1);
    end;
end;

procedure PathSplitLeftElementU(const Path: UnicodeString;
          var LeftElement, RightPath: UnicodeString; const PathSep: WideChar);
var I: Integer;
begin
  I := PosCharU(PathSep, Path);
  if I <= 0 then
    begin
      LeftElement := Path;
      RightPath := '';
    end
  else
    begin
      LeftElement := Copy(Path, 1, I - 1);
      RightPath := CopyFromU(Path, I + 1);
    end;
end;

procedure PathSplitLeftElement(const Path: String;
    var LeftElement, RightPath: String; const PathSep: Char);
var I: Integer;
begin
  I := PosChar(PathSep, Path);
  if I <= 0 then
    begin
      LeftElement := Path;
      RightPath := '';
    end
  else
    begin
      LeftElement := Copy(Path, 1, I - 1);
      RightPath := CopyFrom(Path, I + 1);
    end;
end;

procedure DecodeFilePathA(const FilePath: AnsiString; var Path, FileName: AnsiString;
    const PathSep: AnsiChar);
var I: Integer;
begin
  I := PosCharRevA(PathSep, FilePath);
  if I <= 0 then
    begin
      Path := '';
      FileName := FilePath;
    end
  else
    begin
      Path := Copy(FilePath, 1, I);
      FileName := CopyFromA(FilePath, I + 1);
    end;
end;

procedure DecodeFilePathB(const FilePath: RawByteString; var Path, FileName: RawByteString;
    const PathSep: AnsiChar);
var I: Integer;
begin
  I := PosCharRevB(PathSep, FilePath);
  if I <= 0 then
    begin
      Path := '';
      FileName := FilePath;
    end
  else
    begin
      Path := Copy(FilePath, 1, I);
      FileName := CopyFromB(FilePath, I + 1);
    end;
end;

procedure DecodeFilePathU(const FilePath: UnicodeString; var Path, FileName: UnicodeString;
    const PathSep: WideChar);
var I: Integer;
begin
  I := PosCharRevU(PathSep, FilePath);
  if I <= 0 then
    begin
      Path := '';
      FileName := FilePath;
    end
  else
    begin
      Path := Copy(FilePath, 1, I);
      FileName := CopyFromU(FilePath, I + 1);
    end;
end;

procedure DecodeFilePath(const FilePath: String; var Path, FileName: String;
    const PathSep: Char);
var I: Integer;
begin
  I := PosCharRev(PathSep, FilePath);
  if I <= 0 then
    begin
      Path := '';
      FileName := FilePath;
    end
  else
    begin
      Path := Copy(FilePath, 1, I);
      FileName := CopyFrom(FilePath, I + 1);
    end;
end;

function PathExtractFileNameA(const FilePath: AnsiString;
         const PathSep: AnsiChar): AnsiString;
var Path : AnsiString;
begin
  DecodeFilePathA(FilePath, Path, Result, PathSep);
end;

function PathExtractFileNameB(const FilePath: RawByteString;
         const PathSep: AnsiChar): RawByteString;
var Path : RawByteString;
begin
  DecodeFilePathB(FilePath, Path, Result, PathSep);
end;

function PathExtractFileNameU(const FilePath: UnicodeString;
         const PathSep: WideChar): UnicodeString;
var Path : UnicodeString;
begin
  DecodeFilePathU(FilePath, Path, Result, PathSep);
end;

function PathExtractFileName(const FilePath: String;
         const PathSep: Char): String;
var Path : String;
begin
  DecodeFilePath(FilePath, Path, Result, PathSep);
end;

function PathExtractFileExtA(const FilePath: AnsiString;
         const PathSep: AnsiChar): AnsiString;
var FileName : AnsiString;
    I : Integer;
begin
  FileName := PathExtractFileNameA(FilePath, PathSep);
  I := PosCharRevA('.', FileName);
  if I <= 0 then
    begin
      Result := '';
      exit;
    end;
  Result := CopyFromA(FileName, I);
end;

function PathExtractFileExtB(const FilePath: RawByteString;
         const PathSep: AnsiChar): RawByteString;
var FileName : RawByteString;
    I : Integer;
begin
  FileName := PathExtractFileNameB(FilePath, PathSep);
  I := PosCharRevB('.', FileName);
  if I <= 0 then
    begin
      Result := '';
      exit;
    end;
  Result := CopyFromB(FileName, I);
end;

function PathExtractFileExtU(const FilePath: UnicodeString;
         const PathSep: WideChar): UnicodeString;
var FileName : UnicodeString;
    I : Integer;
begin
  FileName := PathExtractFileNameU(FilePath, PathSep);
  I := PosCharRevU('.', FileName);
  if I <= 0 then
    begin
      Result := '';
      exit;
    end;
  Result := CopyFromU(FileName, I);
end;

function PathExtractFileExt(const FilePath: String;
         const PathSep: Char): String;
var FileName : String;
    I : Integer;
begin
  FileName := PathExtractFileName(FilePath, PathSep);
  I := PosCharRev('.', FileName);
  if I <= 0 then
    begin
      Result := '';
      exit;
    end;
  Result := CopyFrom(FileName, I);
end;

function FileNameCleanA(const FileName: AnsiString): AnsiString;
begin
  Result := StrReplaceCharA(['\', '/', ':', '>', '<', '*', '?'], '_', FileName);
  if Result = '.' then
    Result := '_' else
  if Result = '..' then
    Result := '__';
end;

function FileNameCleanB(const FileName: RawByteString): RawByteString;
begin
  Result := StrReplaceCharB(['\', '/', ':', '>', '<', '*', '?'], '_', FileName);
  if Result = '.' then
    Result := '_' else
  if Result = '..' then
    Result := '__';
end;

function FileNameCleanU(const FileName: UnicodeString): UnicodeString;
begin
  Result := StrReplaceCharU(['\', '/', ':', '>', '<', '*', '?'], WideChar('_'), FileName);
  if Result = '.' then
    Result := '_' else
  if Result = '..' then
    Result := '__';
end;

function FileNameClean(const FileName: String): String;
begin
  Result := StrReplaceChar(['\', '/', ':', '>', '<', '*', '?'], '_', FileName);
  if Result = '.' then
    Result := '_' else
  if Result = '..' then
    Result := '__';
end;

function FilePathA(const FileName, Path: AnsiString; const BasePath: AnsiString;
    const PathSep: AnsiChar): AnsiString;
var P, F: AnsiString;
begin
  F := FileNameCleanA(FileName);
  if F = '' then
    begin
      Result := '';
      exit;
    end;
  P := PathExpandA(Path, BasePath, PathSep);
  if P = '' then
    Result := F
  else
    Result := PathInclSuffixA(P, PathSep) + F;
end;

function FilePathB(const FileName, Path: RawByteString; const BasePath: RawByteString;
    const PathSep: AnsiChar): RawByteString;
var P, F: RawByteString;
begin
  F := FileNameCleanB(FileName);
  if F = '' then
    begin
      Result := '';
      exit;
    end;
  P := PathExpandB(Path, BasePath, PathSep);
  if P = '' then
    Result := F
  else
    Result := PathInclSuffixB(P, PathSep) + F;
end;

function FilePathU(const FileName, Path: UnicodeString; const BasePath: UnicodeString;
    const PathSep: WideChar): UnicodeString;
var P, F: UnicodeString;
begin
  F := FileNameCleanU(FileName);
  if F = '' then
    begin
      Result := '';
      exit;
    end;
  P := PathExpandU(Path, BasePath, PathSep);
  if P = '' then
    Result := F
  else
    Result := PathInclSuffixU(P, PathSep) + F;
end;

function FilePath(const FileName, Path: String; const BasePath: String;
    const PathSep: Char): String;
var P, F: String;
begin
  F := FileNameClean(FileName);
  if F = '' then
    begin
      Result := '';
      exit;
    end;
  P := PathExpand(Path, BasePath, PathSep);
  if P = '' then
    Result := F
  else
    Result := PathInclSuffix(P, PathSep) + F;
end;

function DirectoryExpandA(const Path: AnsiString; const BasePath: AnsiString;
    const PathSep: AnsiChar): AnsiString;
begin
  Result := PathExpandA(PathInclSuffixA(Path, PathSep),
      PathInclSuffixA(BasePath, PathSep), PathSep);
end;

function DirectoryExpandB(const Path: RawByteString; const BasePath: RawByteString;
    const PathSep: AnsiChar): RawByteString;
begin
  Result := PathExpandB(PathInclSuffixB(Path, PathSep),
      PathInclSuffixB(BasePath, PathSep), PathSep);
end;

function DirectoryExpandU(const Path: UnicodeString; const BasePath: UnicodeString;
    const PathSep: WideChar): UnicodeString;
begin
  Result := PathExpandU(PathInclSuffixU(Path, PathSep),
      PathInclSuffixU(BasePath, PathSep), PathSep);
end;

function DirectoryExpand(const Path: String; const BasePath: String;
    const PathSep: Char): String;
begin
  Result := PathExpand(PathInclSuffix(Path, PathSep),
      PathInclSuffix(BasePath, PathSep), PathSep);
end;

function UnixPathToWinPath(const Path: AnsiString): AnsiString;
begin
  Result := StrReplaceCharA('/', '\',
            StrReplaceCharA(['\', ':', '<', '>', '|'], '_', Path));
end;

function WinPathToUnixPath(const Path: AnsiString): AnsiString;
begin
  Result := Path;
  if WinPathHasDriveLetterA(Path) then
    begin
      // X: -> \X
      Result[2] := Result[1];
      Result[1] := '\';
    end else
  if StrMatchLeftA(Path, '\\.\') then
    // \\.\ -> \
    Delete(Result, 1, 3) else
  if PathIsUNCPathA(Path) then
    // \\ -> \
    Delete(Result, 1, 1);
  Result := StrReplaceCharA('\', '/',
            StrReplaceCharA(['/', ':', '<', '>', '|'], '_', Result));
end;



{                                                                              }
{ System helper functions                                                      }
{                                                                              }
resourcestring
  SSystemError = 'System error #%s';

{$IFDEF MSWIN}
{$IFDEF StringIsUnicode}
function GetLastOSErrorMessage: String;
const MAX_ERRORMESSAGE_LENGTH = 256;
var Err: LongWord;
    Buf: array[0..MAX_ERRORMESSAGE_LENGTH - 1] of Word;
    Len: LongWord;
begin
  Err := Windows.GetLastError;
  FillChar(Buf, Sizeof(Buf), #0);
  Len := Windows.FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM, nil, Err, 0,
      @Buf, MAX_ERRORMESSAGE_LENGTH, nil);
  if Len = 0 then
    Result := Format(SSystemError, [IntToStr(Err)])
  else
    Result := StrPas(PWideChar(@Buf));
end;
{$ELSE}
function GetLastOSErrorMessage: String;
const MAX_ERRORMESSAGE_LENGTH = 256;
var Err: LongWord;
    Buf: array[0..MAX_ERRORMESSAGE_LENGTH - 1] of Byte;
    Len: LongWord;
begin
  Err := Windows.GetLastError;
  FillChar(Buf, Sizeof(Buf), #0);
  Len := Windows.FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM, nil, Err, 0,
      @Buf, MAX_ERRORMESSAGE_LENGTH, nil);
  if Len = 0 then
    Result := Format(SSystemError, [IntToStr(Err)])
  else
    Result := StrPas(PAnsiChar(@Buf));
end;
{$ENDIF}
{$ELSE}
{$IFDEF UNIX}
{$IFDEF FREEPASCAL}
function GetLastOSErrorMessage: String;
begin
  Result := SysErrorMessage(GetLastOSError);
end;
{$ELSE}
function GetLastOSErrorMessage: String;
var Err: LongWord;
    Buf: Array[0..1023] of AnsiChar;
begin
  Err := BaseUnix.fpgeterrno;
  FillChar(Buf, Sizeof(Buf), #0);
  libc.strerror_r(Err, @Buf, SizeOf(Buf));
  if Buf[0] = #0 then
    Result := Format(SSystemError, [IntToStr(Err)])
  else
    Result := StrPas(@Buf);
end;
{$ENDIF}{$ENDIF}{$ENDIF}

{$IFDEF WindowsPlatform}
function GetTick: LongWord;
begin
  Result := GetTickCount;
end;
{$ELSE}{$IFDEF UNIX}
function GetTick: LongWord;
begin
  Result := LongWord(DateTimeToTimeStamp(Now).Time);
end;
{$ENDIF}{$ENDIF}



{                                                                              }
{ File errors                                                                  }
{                                                                              }
constructor EFileError.Create(const FileError: TFileError; const Msg: string);
begin
  FFileError := FileError;
  inherited Create(Msg);
end;

constructor EFileError.CreateFmt(const FileError: TFileError; const Msg: string; const Args: array of const);
begin
  FFileError := FileError;
  inherited CreateFmt(Msg, Args);
end;

{$IFDEF MSWIN}
function WinErrorCodeToFileError(const ErrorCode: LongWord): TFileError;
begin
  case ErrorCode of
    0                             : Result := feNone;
    ERROR_INVALID_HANDLE          : Result := feInvalidParameter;
    ERROR_FILE_NOT_FOUND,
    ERROR_PATH_NOT_FOUND          : Result := feFileDoesNotExist;
    ERROR_ALREADY_EXISTS,
    ERROR_FILE_EXISTS             : Result := feFileExists;
    ERROR_WRITE_PROTECT,
    ERROR_OPEN_FAILED             : Result := feFileOpenError;
    ERROR_CANNOT_MAKE             : Result := feFileCreateError;
    ERROR_NEGATIVE_SEEK           : Result := feFileSeekError;
    ERROR_ACCESS_DENIED,
    ERROR_NETWORK_ACCESS_DENIED   : Result := feAccessDenied;
    ERROR_SHARING_VIOLATION,
    ERROR_LOCK_VIOLATION,
    ERROR_SHARING_PAUSED,
    ERROR_LOCK_FAILED             : Result := feFileSharingError;
    ERROR_HANDLE_DISK_FULL,
    ERROR_DISK_FULL               : Result := feOutOfSpace;
    ERROR_BAD_NETPATH,
    ERROR_DIRECTORY,
    ERROR_INVALID_DRIVE           : Result := feInvalidFilePath;
    ERROR_INVALID_NAME,
    ERROR_FILENAME_EXCED_RANGE,
    ERROR_BAD_NET_NAME,
    ERROR_BUFFER_OVERFLOW         : Result := feInvalidFileName;
    ERROR_OUTOFMEMORY,
    ERROR_NOT_ENOUGH_MEMORY,
    ERROR_TOO_MANY_OPEN_FILES,
    ERROR_SHARING_BUFFER_EXCEEDED : Result := feOutOfResources;
    ERROR_SEEK,
    ERROR_READ_FAULT,
    ERROR_WRITE_FAULT,
    ERROR_GEN_FAILURE,
    ERROR_CRC,
    ERROR_NETWORK_BUSY,
    ERROR_NET_WRITE_FAULT,
    ERROR_REM_NOT_LIST,
    ERROR_DEV_NOT_EXIST,
    ERROR_NETNAME_DELETED         : Result := feDeviceFailure;
  else
    Result := feFileError;
  end;
end;
{$ENDIF}



{                                                                              }
{ File operations                                                              }
{                                                                              }

{$IFDEF MSWIN}
function FileOpenFlagsToWinFileFlags(const FileOpenFlags: TFileOpenFlags): LongWord;
var
  FileFlags : LongWord;
begin
  FileFlags := 0;
  if foDeleteOnClose in FileOpenFlags then
    FileFlags := FileFlags or FILE_FLAG_DELETE_ON_CLOSE;
  if foNoBuffering in FileOpenFlags then
    FileFlags := FileFlags or FILE_FLAG_NO_BUFFERING;
  if foWriteThrough in FileOpenFlags then
    FileFlags := FileFlags or FILE_FLAG_WRITE_THROUGH;
  if foRandomAccessHint in FileOpenFlags then
    FileFlags := FileFlags or FILE_FLAG_RANDOM_ACCESS;
  if foSequentialScanHint in FileOpenFlags then
    FileFlags := FileFlags or FILE_FLAG_SEQUENTIAL_SCAN;
  Result := FileFlags;
end;

function FileCreationModeToWinFileCreateDisp(const FileCreationMode: TFileCreationMode): LongWord;
var
  FileCreateDisp : LongWord;
begin
  case FileCreationMode of
    fcCreateNew        : FileCreateDisp := CREATE_NEW;
    fcCreateAlways     : FileCreateDisp := CREATE_ALWAYS;
    fcOpenExisting     : FileCreateDisp := OPEN_EXISTING;
    fcOpenAlways       : FileCreateDisp := OPEN_ALWAYS;
    fcTruncateExisting : FileCreateDisp := TRUNCATE_EXISTING;
  else
    raise EFileError.Create(feInvalidParameter, SInvalidFileCreationMode);
  end;
  Result := FileCreateDisp;
end;

function FileSharingToWinFileShareMode(const FileSharing: TFileSharing): LongWord;
var
  FileShareMode : LongWord;
begin
  case FileSharing of
    fsDenyNone      : FileShareMode := FILE_SHARE_READ or FILE_SHARE_WRITE or FILE_SHARE_DELETE;
    fsDenyRead      : FileShareMode := FILE_SHARE_WRITE;
    fsDenyWrite     : FileShareMode := FILE_SHARE_READ;
    fsDenyReadWrite : FileShareMode := 0;
    fsExclusive     : FileShareMode := 0;
  else
    raise EFileError.Create(feInvalidParameter, SInvalidFileSharing);
  end;
  Result := FileShareMode;
end;

function FileAccessToWinFileOpenAccess(const FileAccess: TFileAccess): LongWord;
var
  FileOpenAccess : LongWord;
begin
  case FileAccess of
    faRead      : FileOpenAccess := GENERIC_READ;
    faWrite     : FileOpenAccess := GENERIC_WRITE;
    faReadWrite : FileOpenAccess := GENERIC_READ or GENERIC_WRITE;
  else
    raise EFileError.Create(feInvalidParameter, SInvalidFileAccess);
  end;
  Result := FileOpenAccess;
end;
{$ELSE}
function FileOpenShareMode(
         const FileAccess: TFileAccess;
         const FileSharing: TFileSharing): LongWord;
var FileShareMode : LongWord;
begin
  case FileAccess of
    faRead      : FileShareMode := fmOpenRead;
    faWrite     : FileShareMode := fmOpenWrite;
    faReadWrite : FileShareMode := fmOpenReadWrite;
  else
    raise EFileError.Create(feInvalidParameter, SInvalidFileAccess);
  end;
  case FileSharing of
    fsDenyNone      : FileShareMode := FileShareMode or fmShareDenyNone;
    fsDenyRead      : FileShareMode := FileShareMode or fmShareDenyRead;
    fsDenyWrite     : FileShareMode := FileShareMode or fmShareDenyWrite;
    fsDenyReadWrite : FileShareMode := FileShareMode or fmShareDenyRead or fmShareDenyWrite;
    fsExclusive     : FileShareMode := FileShareMode or fmShareExclusive;
  else
    raise EFileError.Create(feInvalidParameter, SInvalidFileSharing);
  end;
  Result := FileShareMode;
end;

function FileCreateWithShareMode(
         const FileName: AnsiString;
         const FileShareMode: LongWord): Integer;
var FileHandle : Integer;
begin
  FileHandle := FileCreate(FileName);
  if FileHandle < 0 then
    exit;
  FileClose(FileHandle);
  FileHandle := FileOpen(FileName, FileShareMode);
  Result := FileHandle;
end;
{$ENDIF}

{$IFDEF MSWIN}
procedure DoFileOpenWait(const FileOpenWait: PFileOpenWait; const WaitStart: LongWord; var Retry: Boolean);

  function GetRandomRetryWait: Integer;
  var Seed : Integer;
      ExtraWaitTime : Integer;
  begin
    if not FileOpenWait^.RetryRandomise then
      ExtraWaitTime := 0
    else
    if FileOpenWait^.RetryInterval < 0 then
      ExtraWaitTime := 0
    else
      begin
        ExtraWaitTime := FileOpenWait^.RetryInterval div 8;
        Seed := Integer(GetTick) xor Integer(FileOpenWait);
        ExtraWaitTime := Seed mod ExtraWaitTime;
      end;
    Result := ExtraWaitTime;
  end;

var
  WaitTime : LongWord;
  WaitResult : LongInt;
begin
  Assert(Assigned(FileOpenWait));

  Retry := False;
  if FileOpenWait^.Signal <> 0 then
    begin
      if FileOpenWait^.RetryInterval < 0 then
        WaitTime := INFINITE
      else
        WaitTime := FileOpenWait^.RetryInterval + GetRandomRetryWait;
      WaitResult := WaitForSingleObject(FileOpenWait^.Signal, WaitTime);
      if WaitResult = WAIT_TIMEOUT then
        Retry := True;
    end
  else
  if Assigned(FileOpenWait^.Callback) then
    begin
      FileOpenWait^.Aborted := False;
      FileOpenWait^.Callback(FileOpenWait);
      if not FileOpenWait^.Aborted then
        Retry := True;
    end
  else
    begin
      Sleep(MaxInt(0, FileOpenWait^.RetryInterval) + GetRandomRetryWait);
      Retry := True;
    end;
  if Retry then
    if LongInt(Int64(GetTick) - Int64(WaitStart)) >= FileOpenWait^.Timeout then
      Retry := False;
end;
{$ENDIF}

function FileOpenExA(
         const FileName: AnsiString;
         const FileAccess: TFileAccess;
         const FileSharing: TFileSharing;
         const FileOpenFlags: TFileOpenFlags;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): TFileHandle;
var FileHandle     : Integer;
    FileShareMode  : LongWord;
    {$IFDEF MSWIN}
    FileOpenAccess : LongWord;
    FileFlags      : LongWord;
    FileCreateDisp : LongWord;
    ErrorCode      : LongWord;
    ErrorSharing   : Boolean;
    Retry          : Boolean;
    WaitStart      : LongWord;
    WaitOpen       : Boolean;
    {$ENDIF}
begin
  {$IFDEF MSWIN}
  FileFlags := FileOpenFlagsToWinFileFlags(FileOpenFlags);
  FileCreateDisp := FileCreationModeToWinFileCreateDisp(FileCreationMode);
  FileShareMode := FileSharingToWinFileShareMode(FileSharing);
  FileOpenAccess := FileAccessToWinFileOpenAccess(FileAccess);
  WaitOpen := False;
  WaitStart := 0;
  if Assigned(FileOpenWait) then
    if FileOpenWait^.Wait and (FileOpenWait^.Timeout > 0) then
      begin
        WaitOpen := True;
        WaitStart := GetTick;
      end;
  Retry := False;
  repeat
    FileHandle := Integer(Windows.CreateFileA(
        PAnsiChar(FileName),
        FileOpenAccess,
        FileShareMode,
        nil,
        FileCreateDisp,
        FileFlags,
        0));
    if FileHandle < 0 then
      begin
        ErrorCode := GetLastError;
        ErrorSharing :=
            (ErrorCode = ERROR_SHARING_VIOLATION) or
            (ErrorCode = ERROR_LOCK_VIOLATION);
      end
    else
      begin
        ErrorCode := 0;
        ErrorSharing := False;
      end;
    if WaitOpen and ErrorSharing then
      DoFileOpenWait(FileOpenWait, WaitStart, Retry);
  until not Retry;
  if FileHandle < 0 then
    raise EFileError.CreateFmt(WinErrorCodeToFileError(ErrorCode), SCannotOpenFile,
        [GetLastOSErrorMessage, FileName]);
  {$ELSE}
  FileShareMode := FileOpenShareMode(FileAccess, FileSharing);
  case FileCreationMode of
    fcCreateNew :
      if FileExists(FileName) then
        raise EFileError.CreateFmt(feFileExists, SFileExists, [FileName])
      else
        FileHandle := FileCreateWithShareMode(FileName, FileShareMode);
    fcCreateAlways :
      FileHandle := FileCreateWithShareMode(FileName, FileShareMode);
    fcOpenExisting :
      FileHandle := FileOpen(FileName, FileShareMode);
    fcOpenAlways :
      if not FileExists(FileName) then
        FileHandle := FileCreateWithShareMode(FileName, FileShareMode)
      else
        FileHandle := FileOpen(FileName, FileShareMode);
    fcTruncateExisting :
      if not FileExists(FileName) then
        raise EFileError.CreateFmt(feFileDoesNotExist, SFileDoesNotExist, [FileName])
      else
        FileHandle := FileCreateWithShareMode(FileName, FileShareMode)
  else
    raise EFileError.CreateFmt(feInvalidParameter, SInvalidFileCreationMode, []);
  end;
  if FileHandle < 0 then
    raise EFileError.CreateFmt(feFileOpenError, SCannotOpenFile, [GetLastOSErrorMessage, FileName]);
  {$ENDIF}
  if foSeekToEndOfFile in FileOpenFlags then
    FileSeekEx(FileHandle, 0, fpOffsetFromEnd);
  Result := FileHandle;
end;

function FileOpenExU(
         const FileName: UnicodeString;
         const FileAccess: TFileAccess;
         const FileSharing: TFileSharing;
         const FileOpenFlags: TFileOpenFlags;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): TFileHandle;
var FileHandle     : Integer;
    FileShareMode  : LongWord;
    {$IFDEF MSWIN}
    FileOpenAccess : LongWord;
    FileFlags      : LongWord;
    FileCreateDisp : LongWord;
    ErrorCode      : LongWord;
    ErrorSharing   : Boolean;
    Retry          : Boolean;
    WaitStart      : LongWord;
    WaitOpen       : Boolean;
    {$ENDIF}
begin
  {$IFDEF MSWIN}
  FileFlags := FileOpenFlagsToWinFileFlags(FileOpenFlags);
  FileCreateDisp := FileCreationModeToWinFileCreateDisp(FileCreationMode);
  FileShareMode := FileSharingToWinFileShareMode(FileSharing);
  FileOpenAccess := FileAccessToWinFileOpenAccess(FileAccess);
  WaitOpen := False;
  WaitStart := 0;
  if Assigned(FileOpenWait) then
    if FileOpenWait^.Wait and (FileOpenWait^.Timeout > 0) then
      begin
        WaitOpen := True;
        WaitStart := GetTick;
      end;
  Retry := False;
  repeat
    FileHandle := Integer(Windows.CreateFileW(
        PWideChar(FileName),
        FileOpenAccess,
        FileShareMode,
        nil,
        FileCreateDisp,
        FileFlags,
        0));
    if FileHandle < 0 then
      begin
        ErrorCode := GetLastError;
        ErrorSharing :=
            (ErrorCode = ERROR_SHARING_VIOLATION) or
            (ErrorCode = ERROR_LOCK_VIOLATION);
      end
    else
      begin
        ErrorCode := 0;
        ErrorSharing := False;
      end;
    if WaitOpen and ErrorSharing then
      DoFileOpenWait(FileOpenWait, WaitStart, Retry);
  until not Retry;
  if FileHandle < 0 then
    raise EFileError.CreateFmt(WinErrorCodeToFileError(ErrorCode), SCannotOpenFile,
        [GetLastOSErrorMessage, FileName]);
  {$ELSE}
  FileShareMode := FileOpenShareMode(FileAccess, FileSharing);
  case FileCreationMode of
    fcCreateNew :
      if FileExists(FileName) then
        raise EFileError.CreateFmt(feFileExists, SFileExists, [FileName])
      else
        FileHandle := FileCreateWithShareMode(FileName, FileShareMode);
    fcCreateAlways :
      FileHandle := FileCreateWithShareMode(FileName, FileShareMode);
    fcOpenExisting :
      FileHandle := FileOpen(FileName, FileShareMode);
    fcOpenAlways :
      if not FileExists(FileName) then
        FileHandle := FileCreateWithShareMode(FileName, FileShareMode)
      else
        FileHandle := FileOpen(FileName, FileShareMode);
    fcTruncateExisting :
      if not FileExists(FileName) then
        raise EFileError.CreateFmt(feFileDoesNotExist, SFileDoesNotExist, [FileName])
      else
        FileHandle := FileCreateWithShareMode(FileName, FileShareMode)
  else
    raise EFileError.CreateFmt(feInvalidParameter, SInvalidFileCreationMode, []);
  end;
  if FileHandle < 0 then
    raise EFileError.CreateFmt(feFileOpenError, SCannotOpenFile, [GetLastOSErrorMessage, FileName]);
  {$ENDIF}
  if foSeekToEndOfFile in FileOpenFlags then
    FileSeekEx(FileHandle, 0, fpOffsetFromEnd);
  Result := FileHandle;
end;

function FileOpenEx(
         const FileName: String;
         const FileAccess: TFileAccess;
         const FileSharing: TFileSharing;
         const FileOpenFlags: TFileOpenFlags;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): TFileHandle;
var FileHandle     : Integer;
    FileShareMode  : LongWord;
    {$IFDEF MSWIN}
    FileOpenAccess : LongWord;
    FileFlags      : LongWord;
    FileCreateDisp : LongWord;
    ErrorCode      : LongWord;
    ErrorSharing   : Boolean;
    Retry          : Boolean;
    WaitStart      : LongWord;
    WaitOpen       : Boolean;
    {$ENDIF}
begin
  {$IFDEF MSWIN}
  FileFlags := FileOpenFlagsToWinFileFlags(FileOpenFlags);
  FileCreateDisp := FileCreationModeToWinFileCreateDisp(FileCreationMode);
  FileShareMode := FileSharingToWinFileShareMode(FileSharing);
  FileOpenAccess := FileAccessToWinFileOpenAccess(FileAccess);
  WaitOpen := False;
  WaitStart := 0;
  if Assigned(FileOpenWait) then
    if FileOpenWait^.Wait and (FileOpenWait^.Timeout > 0) then
      begin
        WaitOpen := True;
        WaitStart := GetTick;
      end;
  Retry := False;
  repeat
    {$IFDEF CharIsWide}
    FileHandle := Integer(Windows.CreateFileW(
        PWideChar(FileName),
        FileOpenAccess,
        FileShareMode,
        nil,
        FileCreateDisp,
        FileFlags,
        0));
    {$ELSE}
    FileHandle := Integer(Windows.CreateFileA(
        PAnsiChar(FileName),
        FileOpenAccess,
        FileShareMode,
        nil,
        FileCreateDisp,
        FileFlags,
        0));
    {$ENDIF}
    if FileHandle < 0 then
      begin
        ErrorCode := GetLastError;
        ErrorSharing :=
            (ErrorCode = ERROR_SHARING_VIOLATION) or
            (ErrorCode = ERROR_LOCK_VIOLATION);
      end
    else
      begin
        ErrorCode := 0;
        ErrorSharing := False;
      end;
    if WaitOpen and ErrorSharing then
      DoFileOpenWait(FileOpenWait, WaitStart, Retry);
  until not Retry;
  if FileHandle < 0 then
    raise EFileError.CreateFmt(WinErrorCodeToFileError(ErrorCode), SCannotOpenFile,
        [GetLastOSErrorMessage, FileName]);
  {$ELSE}
  FileShareMode := FileOpenShareMode(FileAccess, FileSharing);
  case FileCreationMode of
    fcCreateNew :
      if FileExists(FileName) then
        raise EFileError.CreateFmt(feFileExists, SFileExists, [FileName])
      else
        FileHandle := FileCreateWithShareMode(FileName, FileShareMode);
    fcCreateAlways :
      FileHandle := FileCreateWithShareMode(FileName, FileShareMode);
    fcOpenExisting :
      FileHandle := FileOpen(FileName, FileShareMode);
    fcOpenAlways :
      if not FileExists(FileName) then
        FileHandle := FileCreateWithShareMode(FileName, FileShareMode)
      else
        FileHandle := FileOpen(FileName, FileShareMode);
    fcTruncateExisting :
      if not FileExists(FileName) then
        raise EFileError.CreateFmt(feFileDoesNotExist, SFileDoesNotExist, [FileName])
      else
        FileHandle := FileCreateWithShareMode(FileName, FileShareMode)
  else
    raise EFileError.CreateFmt(feInvalidParameter, SInvalidFileCreationMode, []);
  end;
  if FileHandle < 0 then
    raise EFileError.CreateFmt(feFileOpenError, SCannotOpenFile, [GetLastOSErrorMessage, FileName]);
  {$ENDIF}
  if foSeekToEndOfFile in FileOpenFlags then
    FileSeekEx(FileHandle, 0, fpOffsetFromEnd);
  Result := FileHandle;
end;

function FileSeekEx(
         const FileHandle: TFileHandle;
         const FileOffset: Int64;
         const FilePosition: TFileSeekPosition): Int64;
begin
  if FileHandle = 0 then
    raise EFileError.CreateFmt(feInvalidParameter, SInvalidFileHandle, []);
  case FilePosition of
    fpOffsetFromStart   : Result := FileSeek(FileHandle, FileOffset, 0);
    fpOffsetFromCurrent : Result := FileSeek(FileHandle, FileOffset, 1);
    fpOffsetFromEnd     : Result := FileSeek(FileHandle, FileOffset, 2);
  else
    raise EFileError.CreateFmt(feInvalidParameter, SInvalidFilePosition, []);
  end;
  if Result < 0 then
    raise EFileError.CreateFmt(feFileSeekError, SFileSeekError, [GetLastOSErrorMessage]);
end;

function FileReadEx(
         const FileHandle: TFileHandle;
         var Buf; const BufSize: Integer): Integer;
begin
  {$IFDEF MSWIN}
  if not ReadFile(FileHandle, Buf, BufSize, LongWord(Result), nil) then
    raise EFileError.CreateFmt(feFileReadError, SFileReadError, [GetLastOSErrorMessage]);
  {$ELSE}
  Result := FileRead(FileHandle, Buf, BufSize);
  if Result < 0 then
    raise EFileError.Create(feFileReadError, SFileReadError);
  {$ENDIF}
end;

function FileWriteEx(
         const FileHandle: TFileHandle;
         const Buf; const BufSize: Integer): Integer;
begin
  {$IFDEF MSWIN}
  if not WriteFile(FileHandle, Buf, BufSize, LongWord(Result), nil) then
    raise EFileError.CreateFmt(feFileWriteError, SFileWriteError, [GetLastOSErrorMessage, IntToStr(Ord(FileHandle))]);
  {$ELSE}
  Result := FileWrite(FileHandle, Buf, BufSize);
  if Result < 0 then
    raise EFileError.CreateFmt(feFileWriteError, SFileWriteError, [GetLastOSErrorMessage, IntToStr(Ord(FileHandle))]);
  {$ENDIF}
end;

procedure FileCloseEx(const FileHandle: TFileHandle);
begin
  FileClose(FileHandle);
end;

function FindFirstA(const Path: AnsiString; Attr: Integer; var F: TSearchRec): Integer;
begin
  Result := FindFirst(ToStringA(Path), Attr, F);
end;

function FindFirstU(const Path: UnicodeString; Attr: Integer; var F: TSearchRec): Integer;
begin
  Result := FindFirst(ToStringU(Path), Attr, F);
end;

function FileExistsA(const FileName: AnsiString): Boolean;
{$IFDEF MSWIN}
var Attr : LongWord;
{$ELSE}
var SRec : TSearchRec;
{$ENDIF}
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  {$IFDEF MSWIN}
  Attr := GetFileAttributesA(PAnsiChar(FileName));
  if Attr = $FFFFFFFF then
    Result := False
  else
    Result := Attr and FILE_ATTRIBUTE_DIRECTORY = 0;
  {$ELSE}
  if FindFirstA(FileName, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := SRec.Attr and faDirectory = 0;
      FindClose(SRec);
    end;
  {$ENDIF}
end;

function FileExistsU(const FileName: UnicodeString): Boolean;
{$IFDEF MSWIN}
var Attr : LongWord;
{$ELSE}
var SRec : TSearchRec;
{$ENDIF}
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  {$IFDEF MSWIN}
  Attr := GetFileAttributesW(PWideChar(FileName));
  if Attr = $FFFFFFFF then
    Result := False
  else
    Result := Attr and FILE_ATTRIBUTE_DIRECTORY = 0;
  {$ELSE}
  if FindFirstU(FileName, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := SRec.Attr and faDirectory = 0;
      FindClose(SRec);
    end;
  {$ENDIF}
end;

function FileExists(const FileName: String): Boolean;
{$IFDEF MSWIN}
var Attr : LongWord;
{$ELSE}
var SRec : TSearchRec;
{$ENDIF}
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  {$IFDEF MSWIN}
  {$IFDEF StringIsUnicode}
  Attr := GetFileAttributesW(PWideChar(FileName));
  {$ELSE}
  Attr := GetFileAttributesA(PAnsiChar(FileName));
  {$ENDIF}
  if Attr = $FFFFFFFF then
    Result := False
  else
    Result := Attr and FILE_ATTRIBUTE_DIRECTORY = 0;
  {$ELSE}
  if FindFirst(FileName, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := SRec.Attr and faDirectory = 0;
      FindClose(SRec);
    end;
  {$ENDIF}
end;

function FileGetSizeA(const FileName: AnsiString): Int64;
var SRec : TSearchRec;
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  if FindFirstA(FileName, faAnyFile, SRec) <> 0 then
    Result := -1
  else
  begin
    if SRec.Attr and faDirectory <> 0 then
      Result := -1
    else
      begin
        {$IFDEF MSWIN}
        Int64Rec(Result).Lo := SRec.FindData.nFileSizeLow;
        Int64Rec(Result).Hi := SRec.FindData.nFileSizeHigh;
        {$ELSE}
        Result := SRec.Size;
        {$ENDIF}
      end;
    FindClose(SRec);
  end;
end;

function FileGetSizeU(const FileName: UnicodeString): Int64;
var SRec : TSearchRec;
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  if FindFirstU(FileName, faAnyFile, SRec) <> 0 then
    Result := -1
  else
  begin
    if SRec.Attr and faDirectory <> 0 then
      Result := -1
    else
      begin
        {$IFDEF MSWIN}
        Int64Rec(Result).Lo := SRec.FindData.nFileSizeLow;
        Int64Rec(Result).Hi := SRec.FindData.nFileSizeHigh;
        {$ELSE}
        Result := SRec.Size;
        {$ENDIF}
      end;
    FindClose(SRec);
  end;
end;

function FileGetSize(const FileName: String): Int64;
var SRec : TSearchRec;
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  if FindFirst(FileName, faAnyFile, SRec) <> 0 then
    Result := -1
  else
  begin
    if SRec.Attr and faDirectory <> 0 then
      Result := -1
    else
      begin
        {$IFDEF MSWIN}
        Int64Rec(Result).Lo := SRec.FindData.nFileSizeLow;
        Int64Rec(Result).Hi := SRec.FindData.nFileSizeHigh;
        {$ELSE}
        Result := SRec.Size;
        {$ENDIF}
      end;
    FindClose(SRec);
  end;
end;

function FileGetDateTimeA(const FileName: AnsiString): TDateTime;
var SRec : TSearchRec;
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  if FindFirstA(FileName, faAnyFile, SRec) <> 0 then
    Result := 0.0
  else
    begin
      if SRec.Attr and faDirectory <> 0 then
        Result := 0.0
      else
        Result := FileDateToDateTime(SRec.Time);
      FindClose(SRec);
    end;
end;

function FileGetDateTime(const FileName: String): TDateTime;
var SRec : TSearchRec;
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  if FindFirst(FileName, faAnyFile, SRec) <> 0 then
    Result := 0.0
  else
    begin
      if SRec.Attr and faDirectory <> 0 then
        Result := 0.0
      else
        Result := FileDateToDateTime(SRec.Time);
      FindClose(SRec);
    end;
end;

function FileGetDateTime2(const FileName: String): TDateTime;
var Age : LongInt;
begin
  Age := FileAge(FileName);
  if Age = -1 then
    Result := 0.0
  else
    Result := FileDateToDateTime(Age);
end;

function FileIsReadOnly(const FileName: String): Boolean;
var SRec : TSearchRec;
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  if FindFirst(FileName, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := SRec.Attr and (faReadOnly or faDirectory) = faReadOnly;
      FindClose(SRec);
    end;
end;

procedure FileDeleteEx(const FileName: String);
begin
  if FileName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidFileName);
  if not DeleteFile(FileName) then
    raise EFileError.CreateFmt(feFileDeleteError, SFileDeleteError, [GetLastOSErrorMessage]);
end;

procedure FileRenameEx(const OldFileName, NewFileName: String);
begin
  RenameFile(OldFileName, NewFileName);
end;

{ ReadFileBuf }

function ReadFileBufA(
         const FileName: AnsiString;
         var Buf; const BufSize: Integer;
         const FileSharing: TFileSharing;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): Integer;
var FileHandle : Integer;
    FileSize   : Int64;
begin
  Result := 0;
  FileHandle := FileOpenExA(FileName, faRead, FileSharing,
      [foSequentialScanHint], FileCreationMode, FileOpenWait);
  try
    FileSize := FileGetSize(ToStringA(FileName));
    if FileSize = 0 then
      exit;
    if FileSize < 0 then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > MaxInteger then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > BufSize then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    Result := FileReadEx(FileHandle, Buf, FileSize);
  finally
    FileClose(FileHandle);
  end;
end;

function ReadFileBufU(
         const FileName: UnicodeString;
         var Buf; const BufSize: Integer;
         const FileSharing: TFileSharing = fsDenyNone;
         const FileCreationMode: TFileCreationMode = fcOpenExisting;
         const FileOpenWait: PFileOpenWait = nil): Integer;
var FileHandle : Integer;
    FileSize   : Int64;
begin
  Result := 0;
  FileHandle := FileOpenExU(FileName, faRead, FileSharing,
      [foSequentialScanHint], FileCreationMode, FileOpenWait);
  try
    FileSize := FileGetSizeU(FileName);
    if FileSize = 0 then
      exit;
    if FileSize < 0 then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > MaxInteger then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > BufSize then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    Result := FileReadEx(FileHandle, Buf, FileSize);
  finally
    FileClose(FileHandle);
  end;
end;

function ReadFileBuf(
         const FileName: String;
         var Buf; const BufSize: Integer;
         const FileSharing: TFileSharing = fsDenyNone;
         const FileCreationMode: TFileCreationMode = fcOpenExisting;
         const FileOpenWait: PFileOpenWait = nil): Integer;
var FileHandle : Integer;
    FileSize   : Int64;
begin
  Result := 0;
  FileHandle := FileOpenEx(FileName, faRead, FileSharing,
      [foSequentialScanHint], FileCreationMode, FileOpenWait);
  try
    FileSize := FileGetSize(FileName);
    if FileSize = 0 then
      exit;
    if FileSize < 0 then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > MaxInteger then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > BufSize then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    Result := FileReadEx(FileHandle, Buf, FileSize);
  finally
    FileClose(FileHandle);
  end;
end;

{ ReadFileStr }

function ReadFileStrA(
         const FileName: AnsiString;
         const FileSharing: TFileSharing;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): RawByteString;
var FileHandle : Integer;
    FileSize   : Int64;
    ReadBytes  : Integer;
begin
  FileHandle := FileOpenExA(FileName, faRead, FileSharing,
      [foSequentialScanHint], FileCreationMode, FileOpenWait);
  try
    FileSize := FileGetSize(ToStringA(FileName));
    if FileSize < 0 then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > MaxInteger then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    SetLength(Result, FileSize);
    if FileSize = 0 then
      exit;
    ReadBytes := FileReadEx(FileHandle, Result[1], FileSize);
    if ReadBytes < FileSize then
      SetLength(Result, ReadBytes);
  finally
    FileClose(FileHandle);
  end;
end;

function ReadFileStrU(
         const FileName: UnicodeString;
         const FileSharing: TFileSharing;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): RawByteString;
var FileHandle : Integer;
    FileSize   : Int64;
    ReadBytes  : Integer;
begin
  FileHandle := FileOpenExU(FileName, faRead, FileSharing,
      [foSequentialScanHint], FileCreationMode, FileOpenWait);
  try
    FileSize := FileGetSizeU(FileName);
    if FileSize < 0 then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > MaxInteger then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    SetLength(Result, FileSize);
    if FileSize = 0 then
      exit;
    ReadBytes := FileReadEx(FileHandle, Result[1], FileSize);
    if ReadBytes < FileSize then
      SetLength(Result, ReadBytes);
  finally
    FileClose(FileHandle);
  end;
end;

function ReadFileStr(
         const FileName: String;
         const FileSharing: TFileSharing;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): RawByteString;
var FileHandle : Integer;
    FileSize   : Int64;
    ReadBytes  : Integer;
begin
  FileHandle := FileOpenEx(FileName, faRead, FileSharing,
      [foSequentialScanHint], FileCreationMode, FileOpenWait);
  try
    FileSize := FileGetSize(FileName);
    if FileSize < 0 then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > MaxInteger then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    SetLength(Result, FileSize);
    if FileSize = 0 then
      exit;
    ReadBytes := FileReadEx(FileHandle, Result[1], FileSize);
    if ReadBytes < FileSize then
      SetLength(Result, ReadBytes);
  finally
    FileClose(FileHandle);
  end;
end;

{ ReadFileBytes }

function ReadFileBytesA(
         const FileName: AnsiString;
         const FileSharing: TFileSharing;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): TBytes;
var FileHandle : Integer;
    FileSize   : Int64;
    ReadBytes  : Integer;
begin
  FileHandle := FileOpenExA(FileName, faRead, FileSharing,
      [foSequentialScanHint], FileCreationMode, FileOpenWait);
  try
    FileSize := FileGetSize(ToStringA(FileName));
    if FileSize < 0 then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > MaxInteger then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    SetLength(Result, FileSize);
    if FileSize = 0 then
      exit;
    ReadBytes := FileReadEx(FileHandle, Result[0], FileSize);
    if ReadBytes < FileSize then
      SetLength(Result, ReadBytes);
  finally
    FileClose(FileHandle);
  end;
end;

function ReadFileBytesU(
         const FileName: UnicodeString;
         const FileSharing: TFileSharing;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): TBytes;
var FileHandle : Integer;
    FileSize   : Int64;
    ReadBytes  : Integer;
begin
  FileHandle := FileOpenExU(FileName, faRead, FileSharing,
      [foSequentialScanHint], FileCreationMode, FileOpenWait);
  try
    FileSize := FileGetSizeU(FileName);
    if FileSize < 0 then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > MaxInteger then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    SetLength(Result, FileSize);
    if FileSize = 0 then
      exit;
    ReadBytes := FileReadEx(FileHandle, Result[0], FileSize);
    if ReadBytes < FileSize then
      SetLength(Result, ReadBytes);
  finally
    FileClose(FileHandle);
  end;
end;

function ReadFileBytes(
         const FileName: String;
         const FileSharing: TFileSharing;
         const FileCreationMode: TFileCreationMode;
         const FileOpenWait: PFileOpenWait): TBytes;
var FileHandle : Integer;
    FileSize   : Int64;
    ReadBytes  : Integer;
begin
  FileHandle := FileOpenEx(FileName, faRead, FileSharing,
      [foSequentialScanHint], FileCreationMode, FileOpenWait);
  try
    FileSize := FileGetSize(FileName);
    if FileSize < 0 then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    if FileSize > MaxInteger then
      raise EFileError.CreateFmt(feFileSizeError, SFileSizeError, [FileName]);
    SetLength(Result, FileSize);
    if FileSize = 0 then
      exit;
    ReadBytes := FileReadEx(FileHandle, Result[0], FileSize);
    if ReadBytes < FileSize then
      SetLength(Result, ReadBytes);
  finally
    FileClose(FileHandle);
  end;
end;

{ WtiteFileBuf }

procedure WriteFileBufA(
          const FileName: AnsiString;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var FileHandle : Integer;
begin
  if BufSize <= 0 then
    exit;
  FileHandle := FileOpenExA(FileName, faWrite, FileSharing, [],
      FileCreationMode, FileOpenWait);
  try
    if FileWriteEx(FileHandle, Buf, BufSize) <> BufSize then
      raise EFileError.CreateFmt(feFileWriteError, SFileWriteError, [GetLastOSErrorMessage, FileName]);
  finally
    FileClose(FileHandle);
  end;
end;

procedure WriteFileBufU(
          const FileName: UnicodeString;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var FileHandle : Integer;
begin
  if BufSize <= 0 then
    exit;
  FileHandle := FileOpenExU(FileName, faWrite, FileSharing, [],
      FileCreationMode, FileOpenWait);
  try
    if FileWriteEx(FileHandle, Buf, BufSize) <> BufSize then
      raise EFileError.CreateFmt(feFileWriteError, SFileWriteError, [GetLastOSErrorMessage, FileName]);
  finally
    FileClose(FileHandle);
  end;
end;

procedure WriteFileBuf(
          const FileName: String;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var FileHandle : Integer;
begin
  if BufSize <= 0 then
    exit;
  FileHandle := FileOpenEx(FileName, faWrite, FileSharing, [],
      FileCreationMode, FileOpenWait);
  try
    if FileWriteEx(FileHandle, Buf, BufSize) <> BufSize then
      raise EFileError.CreateFmt(feFileWriteError, SFileWriteError, [GetLastOSErrorMessage, FileName]);
  finally
    FileClose(FileHandle);
  end;
end;

{ WriteFileStr }

procedure WriteFileStrA(
          const FileName: AnsiString;
          const Buf: RawByteString;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var BufSize    : Integer;
begin
  BufSize := Length(Buf);
  if BufSize <= 0 then
    exit;
  WriteFileBufA(FileName, Buf[1], BufSize, FileSharing, FileCreationMode, FileOpenWait);
end;

procedure WriteFileStrU(
          const FileName: UnicodeString;
          const Buf: RawByteString;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var BufSize    : Integer;
begin
  BufSize := Length(Buf);
  if BufSize <= 0 then
    exit;
  WriteFileBufU(FileName, Buf[1], BufSize, FileSharing, FileCreationMode, FileOpenWait);
end;

procedure WriteFileStr(
          const FileName: String;
          const Buf: RawByteString;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var BufSize    : Integer;
begin
  BufSize := Length(Buf);
  if BufSize <= 0 then
    exit;
  WriteFileBuf(FileName, Buf[1], BufSize, FileSharing, FileCreationMode, FileOpenWait);
end;

{ WriteFileBytes }

procedure WriteFileBytesA(
          const FileName: AnsiString;
          const Buf: TBytes;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var BufSize    : Integer;
begin
  BufSize := Length(Buf);
  if BufSize <= 0 then
    exit;
  WriteFileBufA(FileName, Buf[0], BufSize, FileSharing, FileCreationMode, FileOpenWait);
end;

procedure WriteFileBytesU(
          const FileName: UnicodeString;
          const Buf: TBytes;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var BufSize    : Integer;
begin
  BufSize := Length(Buf);
  if BufSize <= 0 then
    exit;
  WriteFileBufU(FileName, Buf[0], BufSize, FileSharing, FileCreationMode, FileOpenWait);
end;

procedure WriteFileBytes(
          const FileName: String;
          const Buf: TBytes;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var BufSize    : Integer;
begin
  BufSize := Length(Buf);
  if BufSize <= 0 then
    exit;
  WriteFileBuf(FileName, Buf[0], BufSize, FileSharing, FileCreationMode, FileOpenWait);
end;

{ AppendFile }

procedure AppendFileA(
          const FileName: AnsiString;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var FileHandle : Integer;
begin
  if BufSize <= 0 then
    exit;
  FileHandle := FileOpenExA(FileName, faWrite, FileSharing, [foSeekToEndOfFile],
      FileCreationMode, FileOpenWait);
  try
    if FileWriteEx(FileHandle, Buf, BufSize) <> BufSize then
      raise EFileError.CreateFmt(feFileWriteError, SFileWriteError, [GetLastOSErrorMessage, FileName]);
  finally
    FileClose(FileHandle);
  end;
end;

procedure AppendFileU(
          const FileName: UnicodeString;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var FileHandle : Integer;
begin
  if BufSize <= 0 then
    exit;
  FileHandle := FileOpenExU(FileName, faWrite, FileSharing, [foSeekToEndOfFile],
      FileCreationMode, FileOpenWait);
  try
    if FileWriteEx(FileHandle, Buf, BufSize) <> BufSize then
      raise EFileError.CreateFmt(feFileWriteError, SFileWriteError, [GetLastOSErrorMessage, FileName]);
  finally
    FileClose(FileHandle);
  end;
end;

procedure AppendFile(
          const FileName: String;
          const Buf; const BufSize: Integer;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var FileHandle : Integer;
begin
  if BufSize <= 0 then
    exit;
  FileHandle := FileOpenEx(FileName, faWrite, FileSharing, [foSeekToEndOfFile],
      FileCreationMode, FileOpenWait);
  try
    if FileWriteEx(FileHandle, Buf, BufSize) <> BufSize then
      raise EFileError.CreateFmt(feFileWriteError, SFileWriteError, [GetLastOSErrorMessage, FileName]);
  finally
    FileClose(FileHandle);
  end;
end;

{ AppendFileStr }

procedure AppendFileStrA(
          const FileName: AnsiString;
          const Buf: RawByteString;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var BufSize    : Integer;
begin
  BufSize := Length(Buf);
  if BufSize <= 0 then
    exit;
  AppendFileA(FileName, Buf[1], BufSize, FileSharing, FileCreationMode, FileOpenWait);
end;

procedure AppendFileStrU(
          const FileName: UnicodeString;
          const Buf: RawByteString;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var BufSize    : Integer;
begin
  BufSize := Length(Buf);
  if BufSize <= 0 then
    exit;
  AppendFileU(FileName, Buf[1], BufSize, FileSharing, FileCreationMode, FileOpenWait);
end;

procedure AppendFileStr(
          const FileName: String;
          const Buf: RawByteString;
          const FileSharing: TFileSharing;
          const FileCreationMode: TFileCreationMode;
          const FileOpenWait: PFileOpenWait);
var BufSize    : Integer;
begin
  BufSize := Length(Buf);
  if BufSize <= 0 then
    exit;
  AppendFile(FileName, Buf[1], BufSize, FileSharing, FileCreationMode, FileOpenWait);
end;

function DirectoryEntryExistsA(const Name: AnsiString): Boolean;
var SRec : TSearchRec;
begin
  if FindFirstA(Name, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := True;
      FindClose(SRec);
    end;
end;

function DirectoryEntryExistsU(const Name: UnicodeString): Boolean;
var SRec : TSearchRec;
begin
  if FindFirstU(Name, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := True;
      FindClose(SRec);
    end;
end;

function DirectoryEntryExists(const Name: String): Boolean;
var SRec : TSearchRec;
begin
  if FindFirst(Name, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := True;
      FindClose(SRec);
    end;
end;

function DirectoryEntrySizeA(const Name: AnsiString): Int64;
var SRec : TSearchRec;
begin
  if FindFirstA(Name, faAnyFile, SRec) <> 0 then
    Result := -1
  else
    begin
      if SRec.Attr and faDirectory <> 0 then
        Result := 0
      else
        begin
          {$IFDEF MSWIN}
          {$WARNINGS OFF}
          Int64Rec(Result).Lo := SRec.FindData.nFileSizeLow;
          Int64Rec(Result).Hi := SRec.FindData.nFileSizeHigh;
          {$IFDEF DEBUG}{$IFNDEF FREEPASCAL}{$WARNINGS ON}{$ENDIF}{$ENDIF}
          {$ELSE}
          Result := SRec.Size;
          {$ENDIF}
        end;
      FindClose(SRec);
    end;
end;

function DirectoryEntrySizeU(const Name: UnicodeString): Int64;
var SRec : TSearchRec;
begin
  if FindFirstU(Name, faAnyFile, SRec) <> 0 then
    Result := -1
  else
    begin
      if SRec.Attr and faDirectory <> 0 then
        Result := 0
      else
        begin
          {$IFDEF MSWIN}
          {$WARNINGS OFF}
          Int64Rec(Result).Lo := SRec.FindData.nFileSizeLow;
          Int64Rec(Result).Hi := SRec.FindData.nFileSizeHigh;
          {$IFDEF DEBUG}{$IFNDEF FREEPASCAL}{$WARNINGS ON}{$ENDIF}{$ENDIF}
          {$ELSE}
          Result := SRec.Size;
          {$ENDIF}
        end;
      FindClose(SRec);
    end;
end;

function DirectoryEntrySize(const Name: String): Int64;
var SRec : TSearchRec;
begin
  if FindFirst(Name, faAnyFile, SRec) <> 0 then
    Result := -1
  else
    begin
      if SRec.Attr and faDirectory <> 0 then
        Result := 0
      else
        begin
          {$IFDEF MSWIN}
          {$WARNINGS OFF}
          Int64Rec(Result).Lo := SRec.FindData.nFileSizeLow;
          Int64Rec(Result).Hi := SRec.FindData.nFileSizeHigh;
          {$IFDEF DEBUG}{$IFNDEF FREEPASCAL}{$WARNINGS ON}{$ENDIF}{$ENDIF}
          {$ELSE}
          Result := SRec.Size;
          {$ENDIF}
        end;
      FindClose(SRec);
    end;
end;

function DirectoryExistsA(const DirectoryName: AnsiString): Boolean;
{$IFDEF MSWIN}
var Attr : LongWord;
{$ELSE}
var SRec : TSearchRec;
{$ENDIF}
begin
  if DirectoryName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidPath);
  {$IFDEF MSWIN}
  Attr := GetFileAttributesA(PAnsiChar(DirectoryName));
  if Attr = $FFFFFFFF then
    Result := False
  else
    Result := Attr and FILE_ATTRIBUTE_DIRECTORY <> 0;
  {$ELSE}
  if FindFirstA(DirectoryName, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := SRec.Attr and faDirectory <> 0;
      FindClose(SRec);
    end;
  {$ENDIF}
end;

function DirectoryExistsU(const DirectoryName: UnicodeString): Boolean;
{$IFDEF MSWIN}
var Attr : LongWord;
{$ELSE}
var SRec : TSearchRec;
{$ENDIF}
begin
  if DirectoryName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidPath);
  {$IFDEF MSWIN}
  Attr := GetFileAttributesW(PWideChar(DirectoryName));
  if Attr = $FFFFFFFF then
    Result := False
  else
    Result := Attr and FILE_ATTRIBUTE_DIRECTORY <> 0;
  {$ELSE}
  if FindFirstU(DirectoryName, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := SRec.Attr and faDirectory <> 0;
      FindClose(SRec);
    end;
  {$ENDIF}
end;

function DirectoryExists(const DirectoryName: String): Boolean;
{$IFDEF MSWIN}
var Attr : LongWord;
{$ELSE}
var SRec : TSearchRec;
{$ENDIF}
begin
  if DirectoryName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidPath);
  {$IFDEF MSWIN}
  {$IFDEF StringIsUnicode}
  Attr := GetFileAttributesW(PWideChar(DirectoryName));
  {$ELSE}
  Attr := GetFileAttributesA(PAnsiChar(DirectoryName));
  {$ENDIF}
  if Attr = $FFFFFFFF then
    Result := False
  else
    Result := Attr and FILE_ATTRIBUTE_DIRECTORY <> 0;
  {$ELSE}
  if FindFirst(DirectoryName, faAnyFile, SRec) <> 0 then
    Result := False
  else
    begin
      Result := SRec.Attr and faDirectory <> 0;
      FindClose(SRec);
    end;
  {$ENDIF}
end;

function DirectoryGetDateTimeA(const DirectoryName: AnsiString): TDateTime;
var SRec : TSearchRec;
begin
  if DirectoryName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidPath);
  if FindFirstA(DirectoryName, faAnyFile, SRec) <> 0 then
    Result := 0.0
  else
    begin
      if SRec.Attr and faDirectory = 0 then
        Result := 0.0
      else
        Result := FileDateToDateTime(SRec.Time);
      FindClose(SRec);
    end;
end;

function DirectoryGetDateTimeU(const DirectoryName: UnicodeString): TDateTime;
var SRec : TSearchRec;
begin
  if DirectoryName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidPath);
  if FindFirstU(DirectoryName, faAnyFile, SRec) <> 0 then
    Result := 0.0
  else
    begin
      if SRec.Attr and faDirectory = 0 then
        Result := 0.0
      else
        Result := FileDateToDateTime(SRec.Time);
      FindClose(SRec);
    end;
end;

function DirectoryGetDateTime(const DirectoryName: String): TDateTime;
var SRec : TSearchRec;
begin
  if DirectoryName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidPath);
  if FindFirst(DirectoryName, faAnyFile, SRec) <> 0 then
    Result := 0.0
  else
    begin
      if SRec.Attr and faDirectory = 0 then
        Result := 0.0
      else
        Result := FileDateToDateTime(SRec.Time);
      FindClose(SRec);
    end;
end;

procedure DirectoryCreate(const DirectoryName: String);
begin
  if DirectoryName = '' then
    raise EFileError.Create(feInvalidParameter, SInvalidPath);
  if not CreateDir(DirectoryName) then
    raise EFileError.Create(feFileError, SCannotCreateFile);
end;



{                                                                              }
{ File operations                                                              }
{                                                                              }
function GetFirstFileNameMatching(const FileMask: String): String;
var SRec : TSearchRec;
begin
  Result := '';
  if FindFirst(FileMask, faAnyFile, SRec) = 0 then
    try
      repeat
        if SRec.Attr and faDirectory = 0 then
          begin
            Result := ExtractFilePath(FileMask) + SRec.Name;
            exit;
          end;
      until FindNext(SRec) <> 0;
    finally
      FindClose(SRec);
    end;
end;

function DirEntryGetAttr(const FileName: AnsiString): Integer;
var SRec : TSearchRec;
begin
  if (FileName = '') or WinPathIsDriveLetterA(FileName) then
    Result := -1 else
  if PathIsRootA(FileName) then
    Result := $0800 or faDirectory else
  if FindFirst(ToStringA(PathExclSuffixA(FileName)), faAnyFile, SRec) = 0 then
    begin
      Result := SRec.Attr;
      FindClose(SRec);
    end
  else
    Result := -1;
end;

function DirEntryIsDirectory(const FileName: AnsiString): Boolean;
var SRec : TSearchRec;
begin
  if (FileName = '') or WinPathIsDriveLetterA(FileName) then
    Result := False else
  if PathIsRootA(FileName) then
    Result := True else
  if FindFirst(ToStringA(PathExclSuffixA(FileName)), faDirectory, SRec) = 0 then
    begin
      Result := SRec.Attr and faDirectory <> 0;
      FindClose(SRec);
    end
  else
    Result := False;
end;

{$IFDEF DELPHI6_UP}{$WARN SYMBOL_PLATFORM OFF}{$ENDIF}
function FileHasAttr(const FileName: String; const Attr: Word): Boolean;
var A : Integer;
begin
  A := FileGetAttr(FileName);
  Result := (A >= 0) and (A and Attr <> 0);
end;

procedure CopyFile(const FileName, DestName: String);
const
  BufferSize = 16384;
var DestFileName : String;
    SourceHandle : Integer;
    DestHandle   : Integer;
    Buffer       : Array[0..BufferSize - 1] of Byte;
    BufferUsed   : Integer;
begin
  DestFileName := ExpandFileName(DestName);
  if FileHasAttr(DestFileName, faDirectory) then // if destination is a directory, append file name
    DestFileName := DestFileName + '\' + ExtractFileName(FileName);
  SourceHandle := FileOpen(FileName, fmShareDenyWrite);
  if SourceHandle < 0 then
    raise EFileError.CreateFmt(feFileOpenError, SCannotOpenFile, [GetLastOSErrorMessage,
        FileName]);
  try
    DestHandle := FileCreate(DestFileName);
    if DestHandle < 0 then
      raise EFileError.CreateFmt(feFileCreateError, SCannotCreateFile, [GetLastOSErrorMessage,
          DestFileName]);
    try
      repeat
        BufferUsed := FileRead(SourceHandle, Buffer[0], BufferSize);
        if BufferUsed > 0 then
          FileWrite(DestHandle, Buffer[0], BufferUsed);
      until BufferUsed < BufferSize;
    finally
      FileClose(DestHandle);
    end;
  finally
    FileClose(SourceHandle);
  end;
end;

procedure MoveFile(const FileName, DestName: String);
var Destination : String;
    Attr        : Integer;
begin
  Destination := ExpandFileName(DestName);
  if not RenameFile(FileName, Destination) then
    begin
      Attr := FileGetAttr(FileName);
      if (Attr < 0) or (Attr and faReadOnly <> 0) then
        raise EFileError.CreateFmt(feFileMoveError, SCannotMoveFile, [GetLastOSErrorMessage,
            FileName]);
      CopyFile(FileName, Destination);
      DeleteFile(FileName);
    end;
end;

function DeleteFiles(const FileMask: String): Boolean;
var SRec : TSearchRec;
    Path : String;
begin
  Result := FindFirst(FileMask, faAnyFile, SRec) = 0;
  if not Result then
    exit;
  try
    Path := ExtractFilePath(FileMask);
    repeat
      if (SRec.Name <> '') and (SRec.Name  <> '.') and (SRec.Name <> '..') and
         (SRec.Attr and (faVolumeID + faDirectory) = 0) then
        begin
          Result := DeleteFile(Path + SRec.Name);
          if not Result then
            break;
        end;
    until FindNext(SRec) <> 0;
  finally
    FindClose(SRec);
  end;
end;
{$IFDEF DELPHI6_UP}{$WARN SYMBOL_PLATFORM ON}{$ENDIF}



{$IFDEF MSWIN}
{                                                                              }
{ Logical Drive functions                                                      }
{                                                                              }
function DriveIsValid(const Drive: AnsiChar): Boolean;
var D : AnsiChar;
begin
  D := UpCase(Drive);
  Result := D in ['A'..'Z'];
  if not Result then
    exit;
  Result := IsBitSet32(GetLogicalDrives, Ord(D) - Ord('A'));
end;

function DriveGetType(const Path: AnsiString): TLogicalDriveType;
begin
  Case GetDriveTypeA(PAnsiChar(Path)) of
    DRIVE_REMOVABLE : Result := DriveRemovable;
    DRIVE_FIXED     : Result := DriveFixed;
    DRIVE_REMOTE    : Result := DriveRemote;
    DRIVE_CDROM     : Result := DriveCDRom;
    DRIVE_RAMDISK   : Result := DriveRamDisk;
  else
    Result := DriveTypeUnknown;
  end;
end;

function DriveFreeSpace(const Path: AnsiString): Int64;
var D: Byte;
begin
  if WinPathHasDriveLetterA(Path) then
    D := Ord(UpCase(PAnsiChar(Path)^)) - Ord('A') + 1 else
  if PathIsUNCPathA(Path) then
    begin
      Result := -1;
      exit;
    end
  else
    D := 0;
  Result := DiskFree(D);
end;
{$ENDIF}



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF DEBUG}
{$IFDEF TEST}
{$ASSERTIONS ON}
procedure Test;
const
  TempPath = 'c:\temp';
  TempFilename = 'c:\temp\cFileUtilsTest.txt';
begin
  // PathHasDriveLetter
  Assert(WinPathHasDriveLetterA('A:'), 'PathHasDriveLetter');
  Assert(WinPathHasDriveLetterA('a:'), 'PathHasDriveLetter');
  Assert(WinPathHasDriveLetterA('A:\'), 'PathHasDriveLetter');
  Assert(not WinPathHasDriveLetterA('a\'), 'PathHasDriveLetter');
  Assert(not WinPathHasDriveLetterA('\a\'), 'PathHasDriveLetter');
  Assert(not WinPathHasDriveLetterA('::'), 'PathHasDriveLetter');

  Assert(WinPathHasDriveLetter('A:'), 'PathHasDriveLetter');
  Assert(WinPathHasDriveLetter('a:'), 'PathHasDriveLetter');
  Assert(WinPathHasDriveLetter('A:\'), 'PathHasDriveLetter');
  Assert(not WinPathHasDriveLetter('a\'), 'PathHasDriveLetter');
  Assert(not WinPathHasDriveLetter('\a\'), 'PathHasDriveLetter');
  Assert(not WinPathHasDriveLetter('::'), 'PathHasDriveLetter');

  // PathIsDriveLetter
  Assert(WinPathIsDriveLetterA('B:'), 'PathIsDriveLetter');
  Assert(not WinPathIsDriveLetterA('B:\'), 'PathIsDriveLetter');

  Assert(WinPathIsDriveLetter('B:'), 'PathIsDriveLetter');
  Assert(not WinPathIsDriveLetter('B:\'), 'PathIsDriveLetter');

  // PathIsDriveRoot
  Assert(WinPathIsDriveRootA('C:\'), 'PathIsDriveRoot');
  Assert(not WinPathIsDriveRootA('C:'), 'PathIsDriveRoot');
  Assert(not WinPathIsDriveRootA('C:\A'), 'PathIsDriveRoot');

  Assert(WinPathIsDriveRoot('C:\'), 'PathIsDriveRoot');
  Assert(not WinPathIsDriveRoot('C:'), 'PathIsDriveRoot');
  Assert(not WinPathIsDriveRoot('C:\A'), 'PathIsDriveRoot');

  // PathIsAbsolute
  Assert(PathIsAbsoluteA('\'), 'PathIsAbsolute');
  Assert(PathIsAbsoluteA('\C'), 'PathIsAbsolute');
  Assert(PathIsAbsoluteA('\C\'), 'PathIsAbsolute');
  Assert(PathIsAbsoluteA('C:\'), 'PathIsAbsolute');
  Assert(PathIsAbsoluteA('C:'), 'PathIsAbsolute');
  Assert(PathIsAbsoluteA('\C\..\'), 'PathIsAbsolute');
  Assert(not PathIsAbsoluteA(''), 'PathIsAbsolute');
  Assert(not PathIsAbsoluteA('C'), 'PathIsAbsolute');
  Assert(not PathIsAbsoluteA('C\'), 'PathIsAbsolute');
  Assert(not PathIsAbsoluteA('C\D'), 'PathIsAbsolute');
  Assert(not PathIsAbsoluteA('C\D\'), 'PathIsAbsolute');
  Assert(not PathIsAbsoluteA('..\'), 'PathIsAbsolute');

  Assert(PathIsAbsolute('\'), 'PathIsAbsolute');
  Assert(PathIsAbsolute('\C'), 'PathIsAbsolute');
  Assert(PathIsAbsolute('\C\'), 'PathIsAbsolute');
  Assert(PathIsAbsolute('C:\'), 'PathIsAbsolute');
  Assert(PathIsAbsolute('C:'), 'PathIsAbsolute');
  Assert(PathIsAbsolute('\C\..\'), 'PathIsAbsolute');
  Assert(not PathIsAbsolute(''), 'PathIsAbsolute');
  Assert(not PathIsAbsolute('C'), 'PathIsAbsolute');
  Assert(not PathIsAbsolute('C\'), 'PathIsAbsolute');
  Assert(not PathIsAbsolute('C\D'), 'PathIsAbsolute');
  Assert(not PathIsAbsolute('C\D\'), 'PathIsAbsolute');
  Assert(not PathIsAbsolute('..\'), 'PathIsAbsolute');

  // PathIsDirectory
  Assert(PathIsDirectoryA('\'), 'PathIsDirectory');
  Assert(PathIsDirectoryA('\C\'), 'PathIsDirectory');
  Assert(PathIsDirectoryA('C:'), 'PathIsDirectory');
  Assert(PathIsDirectoryA('C:\'), 'PathIsDirectory');
  Assert(PathIsDirectoryA('C:\D\'), 'PathIsDirectory');
  Assert(not PathIsDirectoryA(''), 'PathIsDirectory');
  Assert(not PathIsDirectoryA('D'), 'PathIsDirectory');
  Assert(not PathIsDirectoryA('C\D'), 'PathIsDirectory');

  Assert(PathIsDirectory('\'), 'PathIsDirectory');
  Assert(PathIsDirectory('\C\'), 'PathIsDirectory');
  Assert(PathIsDirectory('C:'), 'PathIsDirectory');
  Assert(PathIsDirectory('C:\'), 'PathIsDirectory');
  Assert(PathIsDirectory('C:\D\'), 'PathIsDirectory');
  Assert(not PathIsDirectory(''), 'PathIsDirectory');
  Assert(not PathIsDirectory('D'), 'PathIsDirectory');
  Assert(not PathIsDirectory('C\D'), 'PathIsDirectory');

  // PathInclSuffix
  Assert(PathInclSuffixA('', '\') = '', 'PathInclSuffix');
  Assert(PathInclSuffixA('C', '\') = 'C\', 'PathInclSuffix');
  Assert(PathInclSuffixA('C\', '\') = 'C\', 'PathInclSuffix');
  Assert(PathInclSuffixA('C\D', '\') = 'C\D\', 'PathInclSuffix');
  Assert(PathInclSuffixA('C\D\', '\') = 'C\D\', 'PathInclSuffix');
  Assert(PathInclSuffixA('C:', '\') = 'C:\', 'PathInclSuffix');
  Assert(PathInclSuffixA('C:\', '\') = 'C:\', 'PathInclSuffix');

  Assert(PathInclSuffix('', '\') = '', 'PathInclSuffix');
  Assert(PathInclSuffix('C', '\') = 'C\', 'PathInclSuffix');
  Assert(PathInclSuffix('C\', '\') = 'C\', 'PathInclSuffix');
  Assert(PathInclSuffix('C\D', '\') = 'C\D\', 'PathInclSuffix');
  Assert(PathInclSuffix('C\D\', '\') = 'C\D\', 'PathInclSuffix');
  Assert(PathInclSuffix('C:', '\') = 'C:\', 'PathInclSuffix');
  Assert(PathInclSuffix('C:\', '\') = 'C:\', 'PathInclSuffix');

  // PathExclSuffix
  Assert(PathExclSuffixA('', '\') = '', 'PathExclSuffix');
  Assert(PathExclSuffixA('C', '\') = 'C', 'PathExclSuffix');
  Assert(PathExclSuffixA('C\', '\') = 'C', 'PathExclSuffix');
  Assert(PathExclSuffixA('C\D', '\') = 'C\D', 'PathExclSuffix');
  Assert(PathExclSuffixA('C\D\', '\') = 'C\D', 'PathExclSuffix');
  Assert(PathExclSuffixA('C:', '\') = 'C:', 'PathExclSuffix');
  Assert(PathExclSuffixA('C:\', '\') = 'C:', 'PathExclSuffix');

  Assert(PathExclSuffix('', '\') = '', 'PathExclSuffix');
  Assert(PathExclSuffix('C', '\') = 'C', 'PathExclSuffix');
  Assert(PathExclSuffix('C\', '\') = 'C', 'PathExclSuffix');
  Assert(PathExclSuffix('C\D', '\') = 'C\D', 'PathExclSuffix');
  Assert(PathExclSuffix('C\D\', '\') = 'C\D', 'PathExclSuffix');
  Assert(PathExclSuffix('C:', '\') = 'C:', 'PathExclSuffix');
  Assert(PathExclSuffix('C:\', '\') = 'C:', 'PathExclSuffix');

  // PathCanonical
  Assert(PathCanonicalA('', '\') = '', 'PathCanonical');
  Assert(PathCanonicalA('.', '\') = '', 'PathCanonical');
  Assert(PathCanonicalA('.\', '\') = '', 'PathCanonical');
  Assert(PathCanonicalA('..\', '\') = '..\', 'PathCanonical');
  Assert(PathCanonicalA('\..\', '\') = '\', 'PathCanonical');
  Assert(PathCanonicalA('\X\..\..\', '\') = '\', 'PathCanonical');
  Assert(PathCanonicalA('\..', '\') = '', 'PathCanonical');
  Assert(PathCanonicalA('X', '\') = 'X', 'PathCanonical');
  Assert(PathCanonicalA('\X', '\') = '\X', 'PathCanonical');
  Assert(PathCanonicalA('X.', '\') = 'X', 'PathCanonical');
  Assert(PathCanonicalA('.', '\') = '', 'PathCanonical');
  Assert(PathCanonicalA('\X.', '\') = '\X', 'PathCanonical');
  Assert(PathCanonicalA('\X.Y', '\') = '\X.Y', 'PathCanonical');
  Assert(PathCanonicalA('\X.Y\', '\') = '\X.Y\', 'PathCanonical');
  Assert(PathCanonicalA('\A\X..Y\', '\') = '\A\X..Y\', 'PathCanonical');
  Assert(PathCanonicalA('\A\.Y\', '\') = '\A\.Y\', 'PathCanonical');
  Assert(PathCanonicalA('\A\..Y\', '\') = '\A\..Y\', 'PathCanonical');
  Assert(PathCanonicalA('\A\Y..\', '\') = '\A\Y..\', 'PathCanonical');
  Assert(PathCanonicalA('\A\Y..', '\') = '\A\Y..', 'PathCanonical');
  Assert(PathCanonicalA('X', '\') = 'X', 'PathCanonical');
  Assert(PathCanonicalA('X\', '\') = 'X\', 'PathCanonical');
  Assert(PathCanonicalA('X\Y\..', '\') = 'X', 'PathCanonical');
  Assert(PathCanonicalA('X\Y\..\', '\') = 'X\', 'PathCanonical');
  Assert(PathCanonicalA('\X\Y\..', '\') = '\X', 'PathCanonical');
  Assert(PathCanonicalA('\X\Y\..\', '\') = '\X\', 'PathCanonical');
  Assert(PathCanonicalA('\X\Y\..\..', '\') = '', 'PathCanonical');
  Assert(PathCanonicalA('\X\Y\..\..\', '\') = '\', 'PathCanonical');
  Assert(PathCanonicalA('\A\.\.\X\.\Y\..\.\..\.\', '\') = '\A\', 'PathCanonical');
  Assert(PathCanonicalA('C:', '\') = 'C:', 'PathCanonical');
  Assert(PathCanonicalA('C:\', '\') = 'C:\', 'PathCanonical');
  Assert(PathCanonicalA('C:\A\..', '\') = 'C:', 'PathCanonical');
  Assert(PathCanonicalA('C:\A\..\', '\') = 'C:\', 'PathCanonical');
  Assert(PathCanonicalA('C:\..\', '\') = 'C:\', 'PathCanonical');
  Assert(PathCanonicalA('C:\..', '\') = 'C:', 'PathCanonical');
  Assert(PathCanonicalA('C:\A\..\..', '\') = 'C:', 'PathCanonical');
  Assert(PathCanonicalA('C:\A\..\..\', '\') = 'C:\', 'PathCanonical');
  Assert(PathCanonicalA('\A\B\..\C\D\..\', '\') = '\A\C\', 'PathCanonical');
  Assert(PathCanonicalA('\A\B\..\C\D\..\..\', '\') = '\A\', 'PathCanonical');
  Assert(PathCanonicalA('\A\B\..\C\D\..\..\..\', '\') = '\', 'PathCanonical');
  Assert(PathCanonicalA('\A\B\..\C\D\..\..\..\..\', '\') = '\', 'PathCanonical');

  Assert(PathExpandA('', '', '\') = '', 'PathExpand');
  Assert(PathExpandA('', '\', '\') = '\', 'PathExpand');
  Assert(PathExpandA('', '\C', '\') = '\C', 'PathExpand');
  Assert(PathExpandA('', '\C\', '\') = '\C\', 'PathExpand');
  Assert(PathExpandA('..\', '\C\', '\') = '\', 'PathExpand');
  Assert(PathExpandA('..', '\C\', '\') = '', 'PathExpand');
  Assert(PathExpandA('\..', '\C\', '\') = '', 'PathExpand');
  Assert(PathExpandA('\..\', '\C\', '\') = '\', 'PathExpand');
  Assert(PathExpandA('A', '..\', '\') = '..\A', 'PathExpand');
  Assert(PathExpandA('..\', '..\', '\') = '..\..\', 'PathExpand');
  Assert(PathExpandA('\', '', '\') = '\', 'PathExpand');
  Assert(PathExpandA('\', '\C', '\') = '\', 'PathExpand');
  Assert(PathExpandA('\A', '\C\', '\') = '\A', 'PathExpand');
  Assert(PathExpandA('\A\', '\C\', '\') = '\A\', 'PathExpand');
  Assert(PathExpandA('\A\B', '\C', '\') = '\A\B', 'PathExpand');
  Assert(PathExpandA('A\B', '\C', '\') = '\C\A\B', 'PathExpand');
  Assert(PathExpandA('A\B', '\C', '\') = '\C\A\B', 'PathExpand');
  Assert(PathExpandA('A\B', '\C\', '\') = '\C\A\B', 'PathExpand');
  Assert(PathExpandA('A\B', '\C\', '\') = '\C\A\B', 'PathExpand');
  Assert(PathExpandA('A\B', 'C\D', '\') = 'C\D\A\B', 'PathExpand');
  Assert(PathExpandA('..\A\B', 'C\D', '\') = 'C\A\B', 'PathExpand');
  Assert(PathExpandA('..\A\B', '\C\D', '\') = '\C\A\B', 'PathExpand');
  Assert(PathExpandA('..\..\A\B', 'C\D', '\') = 'A\B', 'PathExpand');
  Assert(PathExpandA('..\..\A\B', '\C\D', '\') = '\A\B', 'PathExpand');
  Assert(PathExpandA('..\..\..\A\B', '\C\D', '\') = '\A\B', 'PathExpand');
  Assert(PathExpandA('\..\A\B', '\C\D', '\') = '\A\B', 'PathExpand');
  Assert(PathExpandA('..\A\B', '\..\C\D', '\') = '\C\A\B', 'PathExpand');
  Assert(PathExpandA('..\A\B', '..\C\D', '\') = '..\C\A\B', 'PathExpand');
  Assert(PathExpandA('..\A\B', 'C:\C\D', '\') = 'C:\C\A\B', 'PathExpand');
  Assert(PathExpandA('..\A\B\', 'C:\C\D', '\') = 'C:\C\A\B\', 'PathExpand');

  Assert(FilePathA('C', '..\X\Y', 'A\B', '\') = 'A\X\Y\C', 'FilePath');
  Assert(FilePathA('C', '\X\Y', 'A\B', '\') = '\X\Y\C', 'FilePath');
  Assert(FilePathA('C', '', 'A\B', '\') = 'A\B\C', 'FilePath');
  Assert(FilePathA('', '\X\Y', 'A\B', '\') = '', 'FilePath');
  Assert(FilePathA('C', 'X\Y', 'A\B', '\') = 'A\B\X\Y\C', 'FilePath');
  Assert(FilePathA('C', 'X\Y', '', '\') = 'X\Y\C', 'FilePath');

  Assert(FilePath('C', '..\X\Y', 'A\B', '\') = 'A\X\Y\C', 'FilePath');
  Assert(FilePath('C', '\X\Y', 'A\B', '\') = '\X\Y\C', 'FilePath');
  Assert(FilePath('C', '', 'A\B', '\') = 'A\B\C', 'FilePath');
  Assert(FilePath('', '\X\Y', 'A\B', '\') = '', 'FilePath');
  Assert(FilePath('C', 'X\Y', 'A\B', '\') = 'A\B\X\Y\C', 'FilePath');
  Assert(FilePath('C', 'X\Y', '', '\') = 'X\Y\C', 'FilePath');
  Assert(DirectoryExpandA('', '', '\') = '', 'DirectoryExpand');
  Assert(DirectoryExpandA('', '\X', '\') = '\X\', 'DirectoryExpand');
  Assert(DirectoryExpandA('\', '\X', '\') = '\', 'DirectoryExpand');
  Assert(DirectoryExpandA('\A', '\X', '\') = '\A\', 'DirectoryExpand');
  Assert(DirectoryExpandA('\A\', '\X', '\') = '\A\', 'DirectoryExpand');
  Assert(DirectoryExpandA('\A\B', '\X', '\') = '\A\B\', 'DirectoryExpand');
  Assert(DirectoryExpandA('A', '\X', '\') = '\X\A\', 'DirectoryExpand');
  Assert(DirectoryExpandA('A\', '\X', '\') = '\X\A\', 'DirectoryExpand');
  Assert(DirectoryExpandA('C:', '\X', '\') = 'C:\', 'DirectoryExpand');
  Assert(DirectoryExpandA('C:\', '\X', '\') = 'C:\', 'DirectoryExpand');

  Assert(UnixPathToWinPath('/c/d.f') = '\c\d.f', 'UnixPathToWinPath');
  Assert(WinPathToUnixPath('\c\d.f') = '/c/d.f', 'WinPathToUnixPath');

  {$IFDEF MSWIN}
  Assert(PathExtractFileNameA('c:\test\abc\file.txt') = 'file.txt');
  Assert(PathExtractFileNameU('c:\test\abc\file.txt') = 'file.txt');
  {$ENDIF}

  if not DirectoryExists(TempPath) then
    DirectoryCreate(TempPath);
  Assert(DirectoryExists(TempPath));

  WriteFileStr(TempFilename, 'FileUtilsTest', fsExclusive, fcCreateAlways, nil);
  Assert(FileExists(TempFilename));
  Assert(FileGetSize(TempFilename) = 13);
  Assert(ReadFileStr(TempFilename, fsDenyNone, fcOpenExisting, nil) = 'FileUtilsTest');

  AppendFileStr(TempFilename, '123', fsExclusive, fcOpenExisting, nil);
  Assert(FileGetSize(TempFilename) = 16);
  Assert(ReadFileStr(TempFilename, fsDenyNone, fcOpenExisting, nil) = 'FileUtilsTest123');

  FileDeleteEx(TempFilename);
  Assert(not FileExists(TempFilename));
end;
{$ENDIF}
{$ENDIF}



end.

