{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcTimers.pas                                            }
{   File version:     5.18                                                     }
{   Description:      Timer functions                                          }
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
{   1999/11/10  0.01  Initial version.                                         }
{   2005/08/19  4.02  Compilable with FreePascal 2.0.1                         }
{   2005/08/26  4.03  Improvements to timer functions.                         }
{   2005/08/27  4.04  Revised for Fundamentals 4.                              }
{   2007/06/08  4.05  Compilable with FreePascal 2.04 Win32 i386               }
{   2009/10/09  4.06  Compilable with Delphi 2009 Win32/.NET.                  }
{   2010/06/27  4.07  Compilable with FreePascal 2.4.0 OSX x86-64              }
{   2011/05/04  4.08  Split from cDateTime unit.                               }
{   2015/01/16  4.09  Added GetTickAccuracy.                                   }
{   2015/01/17  5.10  Revised for Fundamentals 5.                              }
{   2018/07/17  5.11  Word32 changes.                                          }
{   2019/04/02  5.12  Compilable with Delphi 10.2 Linux64.                     }
{   2019/06/08  5.13  Use CLOCK_MONOTONIC on Delphi Posix.                     }
{   2019/06/08  5.14  Add GetTick64.                                           }
{   2019/10/06  5.15  MicroTick functions.                                     }
{   2020/01/28  5.16  MilliTick and MicroDateTime functions.                   }
{   2020/01/31  5.17  Use DateTime implementations on iOS.                     }
{   2020/03/10  5.18  Use MachAbsoluteTime on OSX.                             }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 5/6/2005/2006/2007 Win32                                            }
{   Delphi 2009 .NET                                                           }
{   Delphi 7 Win32                      5.11  2019/02/24                       }
{   Delphi XE7 Win32                    5.10  2016/01/17                       }
{   Delphi XE7 Win64                    5.10  2016/01/17                       }
{   Delphi 10.2 Linux64                 5.12  2019/04/02                       }
{   FreePascal 3.0.4 Win32              5.11  2019/02/24                       }
{   FreePascal 2.6.2 Linux i386                                                }
{   FreePascal 2.4.0 OSX x86-64                                                }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF DEBUG}
{$IFDEF TEST}
  {$DEFINE TIMERS_TEST}
{$ENDIF}
{$ENDIF}

unit flcTimers;

interface

uses
  { System }
  SysUtils,

  { Fundamentals }
  flcStdTypes;



{                                                                              }
{ Errors                                                                       }
{                                                                              }
type
  ETimers = class(Exception);



{                                                                              }
{ Tick timer                                                                   }
{                                                                              }
{   The tick timer returns millisecond units.                                  }
{   On some systems the tick is only accurate to 10-20ms.                      }
{   TickDelta calculates the elapsed ticks between D1 to D2.                   }
{   EstimateTickAccuracy estimates the tick accuracy.                          }
{                                                                              }
const
  TickFrequency = 1000;

function  GetTick: Word32;
function  GetTick64: Word64;

function  TickDelta(const D1, D2: Word32): Int32;
function  TickDeltaW(const D1, D2: Word32): Word32;

function  TickDelta64(const D1, D2: Word64): Int64;
function  TickDelta64W(const D1, D2: Word64): Word64;

function  EstimateTickAccuracy(const ReTest: Boolean = False): Word32;



{                                                                              }
{ High-precision timer                                                         }
{                                                                              }
{   StartTimer returns an encoded time (running timer).                        }
{   StopTimer returns an encoded elapsed time (stopped timer).                 }
{   ResumeTimer returns an encoded time (running timer), given an encoded      }
{     elapsed time (stopped timer).                                            }
{   StoppedTimer returns an encoded elapsed time of zero, ie a stopped timer   }
{     with no time elapsed.                                                    }
{   MillisecondsElapsed returns elapsed time for a timer in milliseconds.      }
{   MicrosecondsElapsed returns elapsed time for a timer in microseconds.      }
{   DelayMicroSeconds goes into a tight loop for the specified duration. It    }
{     should be used where short and accurate delays are required.             }
{   GetHighPrecisionFrequency returns the resolution of the high-precision     }
{     timer in units per second.                                               }
{   GetHighPrecisionTimerOverhead calculates the overhead associated with      }
{     calling both StartTimer and StopTimer. Use this value as Overhead when   }
{     calling AdjustTimerForOverhead.                                          }
{                                                                              }
type
  THPTimer = Int64;

function  GetHighPrecisionTimer: Int64;
function  GetHighPrecisionFrequency: Int64;

procedure StartTimer(out Timer: THPTimer);
procedure StopTimer(var Timer: THPTimer);
procedure ResumeTimer(var StoppedTimer: THPTimer);

procedure InitStoppedTimer(var Timer: THPTimer);
procedure InitElapsedTimer(var Timer: THPTimer; const Milliseconds: Integer);

function  MillisecondsElapsed(const Timer: THPTimer;
          const TimerRunning: Boolean = True): Integer;
function  MicrosecondsElapsed(const Timer: THPTimer;
          const TimerRunning: Boolean = True): Int64;

procedure WaitMicroseconds(const MicroSeconds: Integer);

function  EstimateHighPrecisionTimerOverhead: Int64;
procedure AdjustTimerForOverhead(var StoppedTimer: THPTimer;
          const Overhead: Int64 = 0);



{                                                                              }
{ MicroTick                                                                    }
{  Timer in microsecond units, based on HighPrecisionTimer.                    }
{                                                                              }
function  GetMicroTick: Word64;
function  GetMicroTick32: Word32;
function  MicroTickDelta(const T1, T2: Word64): Int64;
function  MicroTickDeltaW(const T1, T2: Word64): Word64;
function  MicroTick32Delta(const T1, T2: Word32): Int32;
function  MicroTick32DeltaW(const T1, T2: Word32): Word32;



{                                                                              }
{ MilliTick                                                                    }
{  Timer in millisecond units, based on HighPrecisionTimer.                    }
{                                                                              }
function  GetMilliTick: Word64;
function  GetMilliTick32: Word32;
function  MilliTickDelta(const T1, T2: Word64): Int64;
function  MilliTickDeltaW(const T1, T2: Word64): Word64;
function  MilliTick32Delta(const T1, T2: Word32): Int32;
function  MilliTick32DeltaW(const T1, T2: Word32): Word32;



{                                                                              }
{ MicroDateTime                                                                }
{   Represents DateTime as microseconds.                                       }
{                                                                              }
function  DateTimeToMicroDateTime(const DT: TDateTime): Word64;
function  GetMicroNow: Word64;
function  GetMicroNowUT: Word64;



{                                                                              }
{ Tests                                                                        }
{                                                                              }
{$IFDEF TIMERS_TEST}
procedure Test;
{$ENDIF}



implementation

{$IFDEF WindowsPlatform}
uses
  Windows,
  DateUtils;
{$ENDIF}

{$IFDEF UNIX}
{$IFDEF FREEPASCAL}
uses
  BaseUnix,
  Unix,
  System.DateUtils;
{$ENDIF}
{$ENDIF}

{$IFDEF POSIX}
{$IFDEF DELPHI}
uses
  Posix.Time,
  {$IFDEF MACOS}
  Macapi.CoreServices,
  {$ENDIF}
  System.DateUtils;
{$ENDIF}
{$ENDIF}



{                                                                              }
{ Tick timer                                                                   }
{                                                                              }

{$IFDEF WindowsPlatform}
  {$DEFINE WinGetTick}
  {$IFDEF DELPHI}
  {$IFNDEF DELPHIXE2_UP}
    {$UNDEF WinGetTick}
  {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF WinGetTick}
{$DEFINE Defined_GetTick}
function GetTick: Word32;
begin
  Result := Word32(GetTickCount);
end;

function GetTick64: Word64;
begin
  Result := Word64(GetTickCount64);
end;
{$ENDIF}

{$IFDEF POSIX}
{$IFDEF DELPHI}
{$IFNDEF IOS}
{$IFNDEF MACOS}
{$DEFINE Defined_GetTick}
function GetTick: Word32;
var
  TimeVal : timespec;
  Ticks64 : Word64;
  Ticks32 : Word32;
begin
  clock_gettime(CLOCK_MONOTONIC, @TimeVal);
  Ticks64 := Word64(Word64(TimeVal.tv_sec) * 1000);
  Ticks64 := Word64(Ticks64 + Word64(TimeVal.tv_nsec) div 1000000);
  Ticks32 := Word32(Ticks64 and $FFFFFFFF);
  Result := Ticks32;
end;

function GetTick64: Word64;
var
  TimeVal : timespec;
  Ticks64 : Word64;
begin
  clock_gettime(CLOCK_MONOTONIC, @TimeVal);
  Ticks64 := Word64(Word64(TimeVal.tv_sec) * 1000);
  Ticks64 := Word64(Ticks64 + Word64(TimeVal.tv_nsec) div 1000000);
  Result := Ticks64;
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}


{$IFDEF DELPHI}
{$IFNDEF IOS}
{$IFDEF MACOS}
const
{$IFDEF UNDERSCOREIMPORTNAME}
  _PU = '_';
{$ELSE}
  _PU = '';
{$ENDIF}

const
  LibcLib = '/usr/lib/libc.dylib';

function MachAbsoluteTime: UInt64; cdecl external LibcLib name _PU + 'mach_absolute_time';
{$ENDIF}
{$ENDIF}
{$ENDIF}

{$IFDEF DELPHI}
{$IFNDEF IOS}
{$IFDEF MACOS}
{$DEFINE Defined_GetTick}
function GetTick: Word32;
var
  Ticks64 : Word64;
  Ticks32 : Word32;
begin
  Ticks64 := Word64(AbsoluteToNanoseconds(MachAbsoluteTime));
  Ticks64 := Word64(Ticks64 div 1000000);
  Ticks32 := Word32(Ticks64 and $FFFFFFFF);
  Result := Ticks32;
end;

function GetTick64: Word64;
var
  Ticks64 : Word64;
begin
  Ticks64 := Word64(AbsoluteToNanoseconds(MachAbsoluteTime));
  Ticks64 := Word64(Ticks64 div 1000000);
  Result := Ticks64;
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}



{$IFNDEF Defined_GetTick}
function GetTick: Word32;
const
  MilliSecPerDay = 24 * 60 * 60 * 1000;
var
  N : Double;
  T : Int64;
begin
  N := Now;
  N := N * MilliSecPerDay;
  T := Trunc(N);
  Result := Word32(T and $FFFFFFFF);
end;

function GetTick64: Word64;
const
  MilliSecPerDay = 24 * 60 * 60 * 1000;
var
  N : Double;
  T : Word64;
begin
  N := Now;
  N := N * MilliSecPerDay;
  T := Word64(Trunc(N));
  Result := T;
end;
{$ENDIF}

{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
// Overflow checking needs to be off here to correctly handle tick values that
// wrap around the maximum value.
function TickDelta(const D1, D2: Word32): Int32;
begin
  Result := Int32(D2 - D1);
end;

function TickDeltaW(const D1, D2: Word32): Word32;
begin
  Result := Word32(D2 - D1)
end;

function TickDelta64(const D1, D2: Word64): Int64;
begin
  Result := Int64(D2 - D1);
end;

function TickDelta64W(const D1, D2: Word64): Word64;
begin
  Result := Word64(D2 - D1);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}

var
  TickAccuracyCached : Boolean = False;
  TickAccuracy       : Word32 = 0;

function EstimateTickAccuracy(const ReTest: Boolean): Word32;
const
  SecondAsDateTime = 1.0 / (24.0 * 60.0 * 60.0);
  MaxLoopCount = 1000000000;
  MaxWaitSeconds = 2;
var
  TickStart, TickStop : Word32;
  TimeStart, TimeStop : TDateTime;
  LoopCount           : Word32;
  Accuracy            : Word32;
begin
  // return cached test result
  if not ReTest and TickAccuracyCached then
    begin
      Result := TickAccuracy;
      exit;
    end;

  // wait for tick to change
  LoopCount := 1;
  TickStart := GetTick;
  TimeStart := Now;
  repeat
    Inc(LoopCount);
    TickStop := GetTick;
    TimeStop := Now;
  until (LoopCount = MaxLoopCount) or
        (TickStop <> TickStart) or
        (TimeStop >= TimeStart + MaxWaitSeconds * SecondAsDateTime);
  if TickStop = TickStart then
    raise ETimers.Create('Tick accuracy test failed');

  // wait for tick to change
  LoopCount := 1;
  TickStart := GetTick;
  TimeStart := Now;
  repeat
    Inc(LoopCount);
    TickStop := GetTick;
    TimeStop := Now;
  until (LoopCount = MaxLoopCount) or
        (TickStop <> TickStart) or
        (TimeStop >= TimeStart + MaxWaitSeconds * SecondAsDateTime);
  if TickStop = TickStart then
    raise ETimers.Create('Tick accuracy test failed');

  // calculate accuracy
  Accuracy := TickDelta(TickStart, TickStop);
  if (Accuracy <= 0) or (Accuracy > MaxWaitSeconds * TickFrequency * 2) then
    raise ETimers.Create('Tick accuracy test failed');

  // cache result
  TickAccuracyCached := True;
  TickAccuracy := Accuracy;

  Result := Accuracy;
end;



{                                                                              }
{ High-precision timing                                                        }
{                                                                              }
{$IFDEF WindowsPlatform}
{$DEFINE Defined_GetHighPrecisionCounter}
const
  SHighResTimerError = 'High resolution timer error';

var
  HighPrecisionTimerInit         : Boolean = False;
  HighPrecisionMillisecondFactor : Int64;
  HighPrecisionMicrosecondFactor : Int64;

function CPUClockFrequency: Int64;
var
  Freq : Windows.TLargeInteger;
begin
  Freq := 0;
  if not QueryPerformanceFrequency(Freq) then
    raise ETimers.Create(SHighResTimerError);
  if Freq = 0 then
    raise ETimers.Create(SHighResTimerError);
  Result := Int64(Freq);
end;

procedure InitHighPrecisionTimer;
var F : Int64;
begin
  F := CPUClockFrequency;
  HighPrecisionMillisecondFactor := F div 1000;
  HighPrecisionMicrosecondFactor := F div 1000000;
  HighPrecisionTimerInit := True;
end;

function GetHighPrecisionCounter: Int64;
var
  Ctr : Windows.TLargeInteger;
begin
  if not HighPrecisionTimerInit then
    InitHighPrecisionTimer;
  QueryPerformanceCounter(Ctr);
  Result := Int64(Ctr);
end;
{$ENDIF}

{$IFDEF POSIX}
{$IFDEF DELPHI}
{$IFNDEF IOS}
{$IFNDEF MACOS}
{$DEFINE Defined_GetHighPrecisionCounter}
const
  HighPrecisionMillisecondFactor = 1000;
  HighPrecisionMicrosecondFactor = 1;

function GetHighPrecisionCounter: Int64;
var
  TimeVal : timespec;
  Ticks64 : Int64;
begin
  clock_gettime(CLOCK_MONOTONIC, @TimeVal);
  Ticks64 := Int64(Int64(TimeVal.tv_sec) * 1000000);
  Ticks64 := Int64(Ticks64 + Int64(TimeVal.tv_nsec) div 1000);
  Result := Ticks64;
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}

{$IFDEF DELPHI}
{$IFNDEF IOS}
{$IFDEF MACOS}
{$DEFINE Defined_GetHighPrecisionCounter}
const
  HighPrecisionMillisecondFactor = 1000;
  HighPrecisionMicrosecondFactor = 1;

function GetHighPrecisionCounter: Int64;
var
  Ticks64 : Word64;
begin
  Ticks64 := Word64(AbsoluteToNanoseconds(MachAbsoluteTime));
  Ticks64 := Word64(Ticks64 div 1000);
  Result := Ticks64;
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}

{$IFDEF UNIX}
{$IFDEF FREEPASCAL}
{$DEFINE Defined_GetHighPrecisionCounter}
const
  HighPrecisionMillisecondFactor = 1000;
  HighPrecisionMicrosecondFactor = 1;

function GetHighPrecisionCounter: Int64;
var
  TV : TTimeVal;
  TZ : PTimeZone;
  Ticks64 : Int64;
begin
  TZ := nil;
  fpGetTimeOfDay(@TV, TZ);
  Ticks64 := Int64(Int64(TV.tv_sec) * 1000000);
  Ticks64 := Int64(Ticks64 + Int64(TV.tv_usec));
  Result := Ticks64;
end;
{$ENDIF}
{$ENDIF}

{$IFNDEF Defined_GetHighPrecisionCounter}
{$DEFINE Defined_GetHighPrecisionCounter}
const
  HighPrecisionMillisecondFactor = 1000;
  HighPrecisionMicrosecondFactor = 1;

function GetHighPrecisionCounter: Int64;
const
  MicroSecPerDay = Int64(24) * 60 * 60 * 1000 * 1000;
var
  N : Double;
  T : Int64;
begin
  N := Now;
  N := N * MicroSecPerDay;
  T := Trunc(N);
  Result := T;
end;
{$ENDIF}

function GetHighPrecisionTimer: Int64;
begin
  Result := GetHighPrecisionCounter;
end;

{$IFDEF WindowsPlatform}
function GetHighPrecisionFrequency: Int64;
begin
  Result := CPUClockFrequency;
end;
{$ELSE}
function GetHighPrecisionFrequency: Int64;
begin
  Result := 1000000;
end;
{$ENDIF}

procedure StartTimer(out Timer: THPTimer);
begin
  Timer := GetHighPrecisionCounter;
end;

{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
procedure StopTimer(var Timer: THPTimer);
begin
  Timer := Int64(GetHighPrecisionCounter - Timer);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}

{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
procedure ResumeTimer(var StoppedTimer: THPTimer);
var
  T : THPTimer;
begin
  StartTimer(T);
  {$IFDEF DELPHI5}
  StoppedTimer := T - StoppedTimer;
  {$ELSE}
  StoppedTimer := Int64(T - StoppedTimer);
  {$ENDIF}
end;
{$IFDEF QOn}{$Q+}{$ENDIF}

procedure InitStoppedTimer(var Timer: THPTimer);
begin
  Timer := 0;
end;

{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
procedure InitElapsedTimer(var Timer: THPTimer; const Milliseconds: Integer);
begin
  {$IFDEF DELPHI5}
  Timer := GetHighPrecisionCounter - (Milliseconds * HighPrecisionMillisecondFactor);
  {$ELSE}
  Timer := Int64(GetHighPrecisionCounter - (Milliseconds * HighPrecisionMillisecondFactor));
  {$ENDIF}
end;
{$IFDEF QOn}{$Q+}{$ENDIF}

{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
function MillisecondsElapsed(const Timer: THPTimer; const TimerRunning: Boolean = True): Integer;
begin
  if not TimerRunning then
    Result := Timer div HighPrecisionMillisecondFactor
  else
    {$IFDEF DELPHI5}
    Result := Integer((GetHighPrecisionCounter - Timer) div HighPrecisionMillisecondFactor);
    {$ELSE}
    Result := Integer(Int64(GetHighPrecisionCounter - Timer) div HighPrecisionMillisecondFactor);
    {$ENDIF}
end;
{$IFDEF QOn}{$Q+}{$ENDIF}

{$IFDEF WindowsPlatform}
{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
function MicrosecondsElapsed(const Timer: THPTimer; const TimerRunning: Boolean = True): Int64;
begin
  if not TimerRunning then
    Result := Timer div HighPrecisionMicrosecondFactor
  else
    {$IFDEF DELPHI5}
    Result := Int64((GetHighPrecisionCounter - Timer) div HighPrecisionMicrosecondFactor);
    {$ELSE}
    Result := Int64(Int64(GetHighPrecisionCounter - Timer) div HighPrecisionMicrosecondFactor);
    {$ENDIF}
end;
{$IFDEF QOn}{$Q+}{$ENDIF}
{$ELSE}
{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
function MicrosecondsElapsed(const Timer: THPTimer; const TimerRunning: Boolean = True): Int64;
begin
  if not TimerRunning then
    Result := Timer
  else
    Result := Int64(GetHighPrecisionCounter - Timer);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}
{$ENDIF}

{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
{$IFDEF DELPHI5}{$IFOPT O+}{$DEFINE OOn}{$ELSE}{$UNDEF OOn}{$ENDIF}{$OPTIMIZATION OFF}{$ENDIF}
procedure WaitMicroseconds(const Microseconds: Integer);
var
  I : Int64;
  N : Integer;
  F : Int64;
  J : Int64;
begin
  if Microseconds <= 0 then
    exit;
  // start high precision timer as early as possible in procedure for minimal
  // overhead
  I := GetHighPrecisionCounter;
  // sleep milliseconds
  N := (MicroSeconds - 100) div 1000; // number of ms with at least 900us
  N := N - 2; // last 2ms in tight loop
  if N > 0 then
    Sleep(N);
  // tight loop remaining time
  {$IFDEF DELPHI5}
  F := Microseconds * HighPrecisionMicrosecondFactor;
  {$ELSE}
  F := Int64(Microseconds * HighPrecisionMicrosecondFactor);
  {$ENDIF}
  repeat
    J := GetHighPrecisionCounter;
  {$IFDEF DELPHI5}
  until J - I >= F;
  {$ELSE}
  until Int64(J - I) >= F;
  {$ENDIF}
end;
{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF DELPHI5}{$IFDEF OOn}{$OPTIMIZATION ON}{$ENDIF}{$ENDIF}

function EstimateHighPrecisionTimerOverhead: Int64;
var T : THPTimer;
    I : Integer;
    H : Int64;
begin
  // start and stop timer a thousand times and find smallest overhead
  StartTimer(T);
  StopTimer(T);
  H := T;
  for I := 1 to 1000 do
    begin
      StartTimer(T);
      StopTimer(T);
      if T < H then
        H := T;
    end;
  Result := H;
end;

{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
{$IFDEF DELPHI5}{$IFOPT O+}{$DEFINE OOn}{$ELSE}{$UNDEF OOn}{$ENDIF}{$OPTIMIZATION OFF}{$ENDIF}
procedure AdjustTimerForOverhead(var StoppedTimer: THPTimer;
          const Overhead: Int64);
begin
  if Overhead <= 0 then
    {$IFDEF DELPHI5}
    StoppedTimer := StoppedTimer - GetHighPrecisionTimerOverhead
    {$ELSE}
    StoppedTimer := Int64(StoppedTimer - EstimateHighPrecisionTimerOverhead)
    {$ENDIF}
  else
    {$IFDEF DELPHI5}
    StoppedTimer := StoppedTimer - Overhead;
    {$ELSE}
    StoppedTimer := Int64(StoppedTimer - Overhead);
    {$ENDIF}
  if StoppedTimer < 0 then
    StoppedTimer :=0;
end;
{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF DELPHI5}{$IFDEF OOn}{$OPTIMIZATION ON}{$ENDIF}{$ENDIF}



{                                                                              }
{ MicroTick                                                                    }
{                                                                              }
{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
// 64 bits = 45964 year interval
function GetMicroTick: Word64;
var
  T : Word64;
begin
  T := Word64(GetHighPrecisionCounter);
  T := T div Word64(HighPrecisionMicrosecondFactor);
  Result := T;
end;

function GetMicroTick32: Word32;
var
  T : Word64;
begin
  T := Word64(GetHighPrecisionCounter);
  T := T div Word64(HighPrecisionMicrosecondFactor);
  Result := Word32(T);
end;

function MicroTickDelta(const T1, T2: Word64): Int64;
begin
  Result := Int64(T2 - T1);
end;

function MicroTickDeltaW(const T1, T2: Word64): Word64;
begin
  Result := Word64(T2 - T1);
end;

function MicroTick32Delta(const T1, T2: Word32): Int32;
begin
  Result := Int32(T2 - T1);
end;

function MicroTick32DeltaW(const T1, T2: Word32): Word32;
begin
  Result := Word32(T2 - T1);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}



{                                                                              }
{ MilliTick                                                                    }
{                                                                              }
{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
function GetMilliTick: Word64;
var
  T : Word64;
begin
  T := Word64(GetHighPrecisionCounter);
  T := T div Word64(HighPrecisionMillisecondFactor);
  Result := T;
end;

function GetMilliTick32: Word32;
var
  T : Word64;
begin
  T := Word64(GetHighPrecisionCounter);
  T := T div Word64(HighPrecisionMillisecondFactor);
  Result := Word32(T);
end;

function MilliTickDelta(const T1, T2: Word64): Int64;
begin
  Result := Int64(T2 - T1);
end;

function MilliTickDeltaW(const T1, T2: Word64): Word64;
begin
  Result := Word64(T2 - T1);
end;

function MilliTick32Delta(const T1, T2: Word32): Int32;
begin
  Result := Int32(T2 - T1);
end;

function MilliTick32DeltaW(const T1, T2: Word32): Word32;
begin
  Result := Word32(T2 - T1);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}



{                                                                              }
{ MicroDateTime                                                                }
{                                                                              }
const
  MicroDateTimeFactor = Word64(86400000000); // Microseconds per day: 24 * 60 * 60 * 1000 * 1000;

function DateTimeToMicroDateTime(const DT: TDateTime): Word64;
var
  F : Double;
  D : Word64;
  FT : Double;
  T : Word64;
begin
  F := DT;
  if (F < -1.0e-12) or (F >= 106751990.0) then
    raise ETimers.Create('Invalid date');
  D := Trunc(F);
  D := D * MicroDateTimeFactor;
  FT := Frac(F);
  FT := FT * MicroDateTimeFactor;
  T := Trunc(FT);
  Result := D + T;
end;

function GetMicroNow: Word64;
begin
  Result := DateTimeToMicroDateTime(Now);
end;

{$IFDEF DELPHIXE2_UP}
  {$DEFINE SupportTimeZone}
{$ENDIF}

function GetMicroNowUT: Word64;
var
  DT : TDateTime;
begin
  {$IFDEF SupportTimeZone}
  DT := System.DateUtils.TTimeZone.Local.ToUniversalTime(Now);
  {$ELSE}
  DT := Now;
  {$ENDIF}
  Result := DateTimeToMicroDateTime(DT);
end;



{                                                                              }
{ Tests                                                                        }
{                                                                              }
{$IFDEF TIMERS_TEST}
{$ASSERTIONS ON}
{$WARNINGS OFF}
procedure Test_TickDelta;
begin
  Assert(TickDelta(0, 10) = 10);
  Assert(TickDelta($FFFFFFFF, 10) = 11);
  Assert(TickDelta(10, 0) = -10);
  Assert(TickDelta($FFFFFFF6, 0) = 10);
  Assert(TickDeltaW(0, 10) = 10);
  Assert(TickDeltaW($FFFFFFFF, 10) = 11);
  Assert(TickDeltaW(10, 0) = $FFFFFFF6);
  Assert(TickDeltaW($FFFFFFF6, 0) = 10);

  Assert(TickDelta64(0, 10) = 10);
  Assert(TickDelta64($FFFFFFFFFFFFFFFF, 10) = 11);
  Assert(TickDelta64(10, 0) = -10);
  Assert(TickDelta64($FFFFFFFFFFFFFFF6, 0) = 10);
  Assert(TickDelta64W(0, 10) = 10);
  Assert(TickDelta64W($FFFFFFFFFFFFFFFF, 10) = 11);
  Assert(TickDelta64W(10, 0) = $FFFFFFFFFFFFFFF6);
  Assert(TickDelta64W($FFFFFFFFFFFFFFF6, 0) = 10);
end;

procedure Test_TickTimer;
var A, B : Word32;
    I : Integer;
begin
  // estimate tick accuracy
  A := EstimateTickAccuracy;
  Assert(A > 0);
  Assert(A < 500);

  // test tick timer using sleep
  A := GetTick;
  I := 1;
  repeat
    Sleep(1);
    Inc(I);
    B := GetTick;
  until (I = 2000) or (B <> A);
  Assert(B <> A);
  Assert(I < 500);
  Assert(TickDelta(A, B) > 0);
  Assert(TickDelta(A, B) < 100);
end;

procedure Test_TickTimer2;
var A, B : Word32;
    P, Q : TDateTime;
    I : Integer;
begin
  // test tick timer using clock
  A := GetTick;
  I := 1;
  P := Now;
  repeat
    Inc(I);
    Q := Now;
    B := GetTick;
  until (I = 100000000) or (B <> A) or
        (Q >= P + 2.0 / (24.0 * 60.0 * 60.0)); // two seconds
  Assert(B <> A);
  Assert(TickDelta(A, B) > 0);
  Assert(TickDelta(A, B) < 5000);
end;

procedure Test_TickTimer3;
var A, B : Word32;
    T : THPTimer;
begin
  // test timer using WaitMicroseconds
  StartTimer(T);
  A := GetTick;
  WaitMicroseconds(50000); // 50ms wait, sometimes fails for less than 20ms wait under Windows
  B := GetTick;
  StopTimer(T);
  Assert(TickDelta(A, B) > 0);
  Assert(TickDeltaW(A, B) > 0);
  Assert(TickDelta(A, B) = TickDeltaW(A, B));
  Assert(MillisecondsElapsed(T, False) >= 45);
  Assert(TickDelta(A, B) >= 15);
end;

procedure Test_HighPrecisionTimer;
var T : THPTimer;
    E : Integer;
begin
  Assert(GetHighPrecisionFrequency > 0);

  // test timer using Sleep
  StartTimer(T);
  Sleep(20);
  StopTimer(T);
  E := MillisecondsElapsed(T, False);
  Assert(E >= 18);
  Assert(E < 2000);
end;

procedure Test_HighPrecisionTimer2;
var T : THPTimer;
    A, B : Word32;
    I : Integer;
begin
  // test timer using TickTimer
  StartTimer(T);
  for I := 1 to 4 do
    begin
      A := GetTick;
      repeat
        B := GetTick;
      until B <> A;
    end;
  StopTimer(T);
  Assert(TickDelta(A, B) > 0);
  Assert(TickDelta(A, B) = TickDeltaW(A, B));
  Assert(MillisecondsElapsed(T, False) >= 2);
end;

procedure Test;
begin
  Test_TickDelta;
  Test_TickTimer;
  Test_TickTimer2;
  Test_TickTimer3;
  Test_HighPrecisionTimer;
  Test_HighPrecisionTimer2;
end;
{$ENDIF}



end.

