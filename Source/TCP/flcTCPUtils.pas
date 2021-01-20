{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcTCPUtils.pas                                          }
{   File version:     5.01                                                     }
{   Description:      TCP utilities.                                           }
{                                                                              }
{   Copyright:        Copyright (c) 2007-2021, David J Butler                  }
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
{   2020/05/20  0.01  Initial version from unit flcTCPConnection.              }
{                     TCP timers helpers. TCP CompareMem helper.               }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}
{$INCLUDE flcTCP.inc}

unit flcTCPUtils;

interface

uses
  SysUtils,
  SyncObjs,
  Classes,

  { Fundamentals }
  flcStdTypes;



{                                                                              }
{ TCP timer helpers                                                            }
{                                                                              }
function  TCPGetTick: Word64;
function  TCPTickDelta(const D1, D2: Word64): Int64;
function  TCPTickDeltaU(const D1, D2: Word64): Word64;


{                                                                              }
{ TCP CompareMem helper                                                        }
{                                                                              }
function  TCPCompareMem(const Buf1; const Buf2; const Count: Integer): Boolean;



{ TCP Log Type }

type
  TTCPLogType = (
      tlDebug,
      tlParameter,
      tlInfo,
      tlWarning,
      tlError
    );



{ TCP Thread }

type
  TTCPThread = class(TThread)
  public
    constructor Create;
    destructor Destroy; override;
    procedure Finalise; virtual;
    property  Terminated;
    function  SleepUnterminated(const ATimeMs: Int32): Boolean;
  end;

procedure TCPThreadTerminate(const AThread: TTCPThread);
procedure TCPThreadFinalise(const AThread: TTCPThread);



type
  ETAbortableMultiWaitEventError = class(Exception);

  TAbortableMultiWaitEvent = class
    FLock       : TCriticalSection;
    FEvent      : TSimpleEvent;
    FWaitCount  : Int32;
    FTerminated : Boolean;

    procedure Lock;
    procedure Unlock;

  public
    constructor Create;
    destructor Destroy; override;

    procedure SetEvent;
    procedure ResetEvent;
    function  WaitEvent(const ATimeout: UInt32): TWaitResult;

    procedure SetTerminated;
    procedure WaitTerminated(const ATimeout: UInt32);
  end;



implementation

uses
  { Fundamentals }
  flcTimers;



{                                                                              }
{ TCP timer helpers                                                            }
{                                                                              }
function TCPGetTick: Word64;
begin
  Result := GetMilliTick;
end;

function TCPTickDelta(const D1, D2: Word64): Int64;
begin
  Result := MilliTickDelta(D1, D2);
end;

function TCPTickDeltaU(const D1, D2: Word64): Word64;
begin
  Result := MilliTickDeltaU(D1, D2);
end;



{                                                                              }
{ TCP CompareMem helper                                                        }
{                                                                              }
{$IFDEF ASM386_DELPHI}
function TCPCompareMem(const Buf1; const Buf2; const Count: Integer): Boolean;
asm
      // EAX = Buf1, EDX = Buf2, ECX = Count
      OR      ECX, ECX
      JLE     @Fin1
      CMP     EAX, EDX
      JE      @Fin1
      PUSH    ESI
      PUSH    EDI
      MOV     ESI, EAX
      MOV     EDI, EDX
      MOV     EDX, ECX
      SHR     ECX, 2
      XOR     EAX, EAX
      REPE    CMPSD
      JNE     @Fin0
      MOV     ECX, EDX
      AND     ECX, 3
      REPE    CMPSB
      JNE     @Fin0
      INC     EAX
@Fin0:
      POP     EDI
      POP     ESI
      RET
@Fin1:
      MOV     AL, 1
end;
{$ELSE}
function TCPCompareMem(const Buf1; const Buf2; const Count: Integer): Boolean;
var P, Q : Pointer;
    D, I : Integer;
begin
  P := @Buf1;
  Q := @Buf2;
  if (Count <= 0) or (P = Q) then
    begin
      Result := True;
      exit;
    end;
  D := Word32(Count) div 4;
  for I := 1 to D do
    if PWord32(P)^ = PWord32(Q)^ then
      begin
        Inc(PWord32(P));
        Inc(PWord32(Q));
      end
    else
      begin
        Result := False;
        exit;
      end;
  D := Word32(Count) and 3;
  for I := 1 to D do
    if PByte(P)^ = PByte(Q)^ then
      begin
        Inc(PByte(P));
        Inc(PByte(Q));
      end
    else
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;
{$ENDIF}



{ TTCPThread }

constructor TTCPThread.Create;
begin
  FreeOnTerminate := False;
  inherited Create(False);
end;

destructor TTCPThread.Destroy;
begin
  if not Terminated then
    Terminate;
  inherited Destroy;
end;

procedure TTCPThread.Finalise;
begin
  if not Terminated then
    Terminate;
  try
    {$IFNDEF DELPHI7}
    if not Finished then
    {$ENDIF}
      WaitFor;
  except
  end;
end;

function TTCPThread.SleepUnterminated(const ATimeMs: Int32): Boolean;
var
  LTime : Int32;
begin
  if Terminated then
    begin
      Result := False;
      exit;
    end;
  if ATimeMs < 0 then
    begin
      Result := True;
      exit;
    end;
  if ATimeMs = 0 then
    Sleep(0)
  else
    begin
      LTime := ATimeMs;
      while LTime >= 100 do
        begin
          Sleep(100);
          if Terminated then
            begin
              Result := False;
              exit;
            end;
          Dec(LTime, 100);
        end;
      if LTime > 0 then
        Sleep(LTime);
    end;
  Result := not Terminated;
end;



procedure TCPThreadTerminate(const AThread: TTCPThread);
begin
  if Assigned(AThread) then
    if not AThread.Terminated then
      AThread.Terminate;
end;

procedure TCPThreadFinalise(const AThread: TTCPThread);
begin
  if Assigned(AThread) then
    AThread.Finalise;
end;


{ TAbortableMultiWaitEvent }

constructor TAbortableMultiWaitEvent.Create;
begin
  inherited Create;
  FLock := TCriticalSection.Create;
  FEvent := TSimpleEvent.Create;
  FTerminated := False;
end;

destructor TAbortableMultiWaitEvent.Destroy;
begin
  if Assigned(FEvent) and Assigned(FLock) and not FTerminated then
    try
      WaitTerminated(20);
    except
    end;
  FreeAndNil(FEvent);
  FreeAndNil(FLock);
  inherited Destroy;
end;

procedure TAbortableMultiWaitEvent.Lock;
begin
  FLock.Acquire;
end;

procedure TAbortableMultiWaitEvent.Unlock;
begin
  FLock.Release;
end;

function TAbortableMultiWaitEvent.WaitEvent(const ATimeout: UInt32): TWaitResult;

  procedure CheckTerminated;
  begin
    if FTerminated then
      raise ETAbortableMultiWaitEventError.Create('Terminated');
  end;

var
  LEvent : TSimpleEvent;

begin
  LEvent := FEvent;

  Lock;
  try
    CheckTerminated;
    Inc(FWaitCount);
  finally
    Unlock;
  end;
  try
    Result := LEvent.WaitFor(ATimeout);
    case Result of
      wrAbandoned : raise ETAbortableMultiWaitEventError.Create('Abandoned');
      wrError     : raise ETAbortableMultiWaitEventError.Create('Wait error');
    end;
    CheckTerminated;
  finally
    Lock;
    try
      CheckTerminated;
      Dec(FWaitCount);
    finally
      Unlock;
    end;
  end;
end;

procedure TAbortableMultiWaitEvent.SetEvent;
begin
  FEvent.SetEvent;
end;

procedure TAbortableMultiWaitEvent.ResetEvent;
begin
  if not FTerminated then
    FEvent.ResetEvent;
end;

procedure TAbortableMultiWaitEvent.SetTerminated;
begin
  Lock;
  try
    if FTerminated then
      exit;
    FTerminated := True;
    FEvent.SetEvent;
  finally
    Unlock;
  end;
end;

{$IFDEF DELPHI7}
const
  INFINITE = -1;
{$ENDIF}

procedure TAbortableMultiWaitEvent.WaitTerminated(const ATimeout: UInt32);
var
  L : UInt32;
begin
  SetTerminated;
  L := ATimeout;
  while L <> 0 do
    begin
      Lock;
      try
        if FWaitCount <= 0 then
          exit;
      finally
        Unlock;
      end;
      Sleep(1);
      if L <> INFINITE then
        if L >= 1 then
          Dec(L, 1)
        else
          L := 0;
    end;
  if ATimeout > 0 then
    raise ETAbortableMultiWaitEventError.Create('Timeout waiting for termination');
end;

end.

