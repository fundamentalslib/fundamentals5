{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcDateTimeZone.pas                                      }
{   File version:     5.09                                                     }
{   Description:      Date/Time Zone functions                                 }
{                                                                              }
{   Copyright:        Copyright (c) 2000-2021, David J Butler                  }
{                                                                              }
{ Revision history:                                                            }
{                                                                              }
{   2000/03/05  1.01  Added Time Zone functions from cInternetStandards.       }
{   2000/08/16  1.02  Fixed bug in UTBias reported by Gerhard Steinwedel.      }
{   2005/08/19  4.03  Compilable with FreePascal 2.0.1 Win32 i386.             }
{   2005/08/21  4.04  Compilable with FreePascal 2.0.1 Linux i386.             }
{   2009/10/09  4.05  Compilable with Delphi 2009 Win32/.NET.                  }
{   2010/06/27  4.06  Compilable with FreePascal 2.4.0 OSX x86-64              }
{   2018/08/13  5.07  String type changes.                                     }
{   2020/10/27  5.08  Move Time zone function into unit.                       }
{   2021/10/19  5.09  Add conditional defines for tests.                       }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 10.2 Win32/Win64             5.08  2021/08/06                       }
{   Delphi 10.2 Linux64                 5.08  2021/08/06                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF TEST}
{$DEFINE DATETIME_TEST}
{$ENDIF}

unit flcDateTimeZone;

interface



{                                                                              }
{ Universal Time (UT) Bias                                                     }
{                                                                              }

{ Returns the UT bias (in minutes) }
function  UTBias: Integer;



{                                                                              }
{ Universal Time (UT)                                                          }
{                                                                              }

{ Returns Universal Time (UT) in local date/time }
function  UTToLocalDateTime(const AValue: TDateTime): TDateTime;

{ Returns a date/time in Universal Time (UT) }
function  LocalDateTimeToUT(const AValue: TDateTime): TDateTime;

{ Returns the current time in Universal Time (UT) }
function  NowUT: TDateTime;



{                                                                              }
{ Test                                                                         }
{                                                                              }
{$IFDEF DATETIME_TEST}
procedure Test;
{$ENDIF}



implementation



uses
  {$IFDEF MSWIN}
  Windows,
  {$ENDIF}
  SysUtils,

  {$IFDEF DATETIME_TEST}
  flcTimers,
  {$ENDIF}

  {$IFDEF DELPHI}
  {$IFDEF POSIX}
  Posix.SysTime,
  {$ENDIF}
  {$ENDIF}

  {$IFDEF DELPHI}
  {$IFDEF DELPHI6_UP}
  DateUtils;
  {$ENDIF}
  {$ENDIF}

  {$IFDEF UNIX}
  {$IFDEF FREEPASCAL}
  BaseUnix,
  Unix;
  {$ENDIF}
  {$ENDIF}






{                                                                              }
{ UTBias                                                                       }
{ Returns the UT bias (in minutes) from the operating system's regional        }
{ settings.                                                                    }
{                                                                              }
{$UNDEF UTBiasDefined}

{$IFDEF DELPHIXE2_UP}
{$IFNDEF UTBiasDefined}
{$DEFINE UTBiasDefined}
function UTBias: Integer;
var
  N : TDateTime;
begin
  N := Now;
  Result := Round((TTimeZone.Local.ToUniversalTime(N) - N) * 24 * 60);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF WindowsPlatform}
{$IFNDEF UTBiasDefined}
{$DEFINE UTBiasDefined}
function UTBias: Integer;
var
  TZI : TTimeZoneInformation;
begin
  case GetTimeZoneInformation(TZI) of
    TIME_ZONE_ID_STANDARD : Result := TZI.StandardBias;
    TIME_ZONE_ID_DAYLIGHT : Result := TZI.DaylightBias
  else
    Result := 0;
  end;
  Result := Result + TZI.Bias;
end;
{$ENDIF}
{$ENDIF}

{$IFDEF FREEPASCAL}
{$IFDEF POSIX}
{$IFNDEF UTBiasDefined}
{$DEFINE UTBiasDefined}
function UTBias: Integer;
var
  TV : TTimeVal;
  TZ : PTimeZone;
begin
  TZ := nil;
  fpGetTimeOfDay(@TV, TZ);
  if Assigned(TZ) then
    Result := TZ^.tz_minuteswest
  else
    Result := 0;
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}

{$IFNDEF UTBiasDefined}
{$DEFINE UTBiasDefined}
function UTBias: Integer;
begin
  Result := 0;
end;
{$ENDIF}



{                                                                              }
{ Universal Time (UT)                                                          }
{                                                                              }
function UTToLocalDateTime(const AValue: TDateTime): TDateTime;
begin
  Result := AValue - UTBias / (24 * 60)
end;

function LocalDateTimeToUT(const AValue: TDateTime): TDateTime;
begin
  Result := AValue + UTBias / (24 * 60)
end;

function NowUT: TDateTime;
begin
  Result := LocalDateTimeToUT(Now);
end;



{                                                                              }
{ Test                                                                         }
{                                                                              }
{$IFDEF DATETIME_TEST}
procedure Test;
const
  MiDa = 12 * 60;
var
  D, E : TDateTime;
begin
  Assert(UTBias <= MiDa);
  Assert(UTBias >= -MiDa);

  D := NowUT;
  E := UTToLocalDateTime(D);
  Assert(LocalDateTimeToUT(E) = D);

  D := Now;
  E := LocalDateTimeToUT(D);
  Assert(UTToLocalDateTime(E) = D);
end;
{$ENDIF}



end.

