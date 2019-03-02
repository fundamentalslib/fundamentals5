{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcTimers.pas                                            }
{   File version:     5.11                                                     }
{   Description:      Timer functions                                          }
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
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 5/6/2005/2006/2007 Win32                                            }
{   Delphi 2009 .NET                                                           }
{   Delphi 7 Win32                      5.11  2019/02/24                       }
{   Delphi XE7 Win32                    5.10  2016/01/17                       }
{   Delphi XE7 Win64                    5.10  2016/01/17                       }
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

// Define TIMERS_TICK_USE_DATETIME to give higher precision to Tick timer on
// some Windows platforms
//
{.DEFINE TIMERS_TICK_USE_DATETIME}

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
{   The tick timer returns millisecond units from 00000000 to FFFFFFFF.        }
{   On some systems the tick is only accurate to 10-20ms.                      }
{   Use TickDelta to calculate the elapsed ticks between D1 to D2.             }
{   GetTickAccuracy estimates the tick accuracy.                               }
{                                                                              }
const
  TickFrequency = 1000;

function  GetTick: Word32;

function  TickDelta(const D1, D2: Word32): Integer;
function  TickDeltaW(const D1, D2: Word32): Word32;

function  GetTickAccuracy(const ReTest: Boolean = False): Word32;



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

function  GetHighPrecisionFrequency: Int64;

function  GetHighPrecisionTimerOverhead: Int64;
procedure AdjustTimerForOverhead(var StoppedTimer: THPTimer;
          const Overhead: Int64 = 0);



{                                                                              }
{ Tests                                                                        }
{                                                                              }
{$IFDEF TIMERS_TEST}
procedure Test;
{$ENDIF}



implementation

{$IFDEF WindowsPlatform}
uses
  Windows;
{$ENDIF}

{$IFDEF OS_UNIX}
{$IFDEF FREEPASCAL}
uses
  BaseUnix,
  Unix;
{$ENDIF}
{$ENDIF}



{                                                                              }
{ Tick timer                                                                   }
{                                                                              }

{$IFDEF TIMERS_TICK_USE_DATETIME}
  {$DEFINE GetTickDateTime}
{$ELSE}
  {$IFDEF WindowsPlatform}
    {$DEFINE GetTickWindows}
  {$ELSE}
    {$IFDEF UNIX}
      {$DEFINE GetTickUnix}
    {$ELSE}
      {$DEFINE GetTickDateTime}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF GetTickWindows}
function GetTick: Word32;
begin
  Result := GetTickCount;
end;
{$ELSE}
{$IFDEF GetTickUnix}
function GetTick: Word32;
begin
  Result := Word32(DateTimeToTimeStamp(Now).Time);
end;
{$ELSE}
function GetTick: Word32;
const MsPerDay = 24 * 60 * 60 * 1000;
var N : Double;
    T : Int64;
begin
  N := Now;
  N := N * MsPerDay;
  T := Trunc(N);
  Result := Word32(T and $FFFFFFFF);
end;
{$ENDIF}
{$ENDIF}

{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
function TickDelta(const D1, D2: Word32): Integer;
begin
  Result := Integer(D2 - D1);
end;

function TickDeltaW(const D1, D2: Word32): Word32;
begin
  Result := Word32(D2 - D1);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}

var
  TickAccuracyCached : Boolean = False;
  TickAccuracy       : Word32 = 0;

function GetTickAccuracy(const ReTest: Boolean): Word32;
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
begin
  if not QueryPerformanceFrequency(Result) then
    raise ETimers.Create(SHighResTimerError);
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
begin
  if not HighPrecisionTimerInit then
    InitHighPrecisionTimer;
  QueryPerformanceCounter(Result);
end;
{$ENDIF}

{$IFDEF UNIX}
{$DEFINE Defined_GetHighPrecisionCounter}
{$IFDEF FREEPASCAL}
const
  HighPrecisionMillisecondFactor = 1000;
  HighPrecisionMicrosecondFactor = 1;

function GetHighPrecisionCounter: Int64;
var TV : TTimeVal;
    TZ : PTimeZone;
begin
  TZ := nil;
  fpGetTimeOfDay(@TV, TZ);
  Result := Int64(TV.tv_sec) * 1000000 + Int64(TV.tv_usec);
end;
{$ELSE}
function GetHighPrecisionCounter: Int64;
var T : Ttimeval;
begin
  GetTimeOfDay(T, nil);
  Result := Int64(T.tv_sec) * 1000000 + Int64(T.tv_usec);
end;
{$ENDIF}
{$ENDIF}

{$IFNDEF Defined_GetHighPrecisionCounter}
{$DEFINE Defined_GetHighPrecisionCounter}
const
  HighPrecisionMillisecondFactor = 1000;
  HighPrecisionMicrosecondFactor = 1;

function GetHighPrecisionCounter: Int64;
begin
  Result := Trunc(Frac(Now) * 24.0 * 60.0 * 60.0 * 1000.0 * 1000.0);
end;
{$ENDIF}

{$IFNDEF Defined_GetHighPrecisionCounter}
const
  SHighResTimerNotAvailable = 'High resolution timer not available';

function GetHighPrecisionCounter: Int64;
begin
  raise ETimers.Create(SHighResTimerNotAvailable);
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
var T : THPTimer;
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
var I : Int64;
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

function GetHighPrecisionTimerOverhead: Int64;
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
    StoppedTimer := Int64(StoppedTimer - GetHighPrecisionTimerOverhead)
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
end;

procedure Test_TickTimer;
var A, B : Word32;
    I : Integer;
begin
  // estimate tick accuracy
  A := GetTickAccuracy;
  Assert(A > 0);
  Assert(A < 2000);

  // test tick timer using sleep
  A := GetTick;
  I := 1;
  repeat
    Sleep(1);
    Inc(I);
    B := GetTick;
  until (I = 2000) or (B <> A);
  Assert(B <> A);
  Assert(TickDelta(A, B) > 0);
  Assert(TickDelta(A, B) < 5000);
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

