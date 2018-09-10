{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcTCPConnection.pas                                     }
{   File version:     5.27                                                     }
{   Description:      TCP connection.                                          }
{                                                                              }
{   Copyright:        Copyright (c) 2007-2018, David J Butler                  }
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
{   2008/12/23  0.01  Initial development.                                     }
{   2010/11/07  0.02  Revision.                                                }
{   2010/11/12  0.03  Refactor for asynchronous operation.                     }
{   2010/12/03  0.04  Connection proxies.                                      }
{   2010/12/17  0.05  Throttling.                                              }
{   2010/12/19  0.06  Multiple connection proxies.                             }
{   2010/12/29  0.07  Report read/write rates.                                 }
{   2011/01/02  0.08  Bug fix in PollSocket routine.                           }
{   2011/06/16  0.09  Fix TriggerRead with proxies.                            }
{   2011/06/18  0.10  Fix Read error in PollSocket when closed by proxies.     }
{   2011/06/25  0.11  Improve Write notifications.                             }
{   2011/06/26  0.12  Implement defered shutdown if write buffer not empty.    }
{   2011/07/03  0.13  WriteBufferEmpty event.                                  }
{   2011/07/04  0.14  Trigger read events outside lock.                        }
{   2011/07/24  0.15  Discard method.                                          }
{   2011/07/31  0.16  Defer close from proxy until after read.                 }
{   2011/09/03  4.17  Revise for Fundamentals 4.                               }
{   2011/09/10  4.18  Improve locking granularity.                             }
{   2011/09/15  4.19  Improve polling efficiency.                              }
{   2011/10/06  4.20  Fix TCPTick frequency.                                   }
{   2015/03/14  4.21  RawByteString changes.                                   }
{   2015/04/09  4.22  TBytes functions.                                        }
{   2015/04/26  4.23  Blocking interface and worker thread.                    }
{   2016/01/09  5.24  Revised for Fundamentals 5.                              }
{   2018/08/30  5.25  PollSocket returns Terminated on exception.              }
{   2018/09/08  5.26  PollSocket remove use of Select.                         }
{   2018/09/10  5.27  PollSocket change to ProcessSocket.                      }
{                                                                              }
{******************************************************************************}

{$INCLUDE flcTCP.inc}

unit flcTCPConnection;

interface

uses
  { System }
  SysUtils,
  {$IFDEF WindowsPlatform}
  Windows,
  {$ENDIF}
  SyncObjs,
  Classes,

  { Fundamentals }
  flcStdTypes,
  flcSocket,
  flcTCPBuffer;



{                                                                              }
{ TCP Connection                                                               }
{                                                                              }
type
  ETCPConnection = class(Exception);

  TTCPConnection = class;

  TTCPLogType = (
    tlDebug,
    tlInfo,
    tlError);

  TTCPConnectionProxyState = (
    prsInit,        // proxy is initialising
    prsNegotiating, // proxy is negotiating, connection data is not yet being transferred
    prsFiltering,   // proxy has successfully completed negotiation and is actively filtering connection data
    prsFinished,    // proxy has successfully completed operation and can be bypassed
    prsError,       // proxy has failed and connection is invalid
    prsClosed);     // proxy has closed the connection

  TTCPConnectionProxy = class
  private
    FConnection : TTCPConnection;
    FNextProxy  : TTCPConnectionProxy;
    FState      : TTCPConnectionProxyState;

  protected
    procedure Log(const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer = 0); overload;
    procedure Log(const LogType: TTCPLogType; const LogMsg: String; const LogArgs: array of const; const LogLevel: Integer = 0); overload;
    function  GetStateStr: RawByteString;
    procedure SetState(const State: TTCPConnectionProxyState);
    procedure ConnectionClose;
    procedure ConnectionPutReadData(const Buf; const BufSize: Integer);
    procedure ConnectionPutWriteData(const Buf; const BufSize: Integer);
    procedure ProxyStart; virtual; abstract;

  public
    class function ProxyName: String; virtual;

    constructor Create(const Connection: TTCPConnection);
    procedure Finalise;

    property  State: TTCPConnectionProxyState read FState;
    property  StateStr: RawByteString read GetStateStr;
    procedure Start;
    procedure ProcessReadData(const Buf; const BufSize: Integer); virtual; abstract;
    procedure ProcessWriteData(const Buf; const BufSize: Integer); virtual; abstract;
  end;

  TTCPConnectionProxyList = class
  private
    FList : array of TTCPConnectionProxy;

    function  GetCount: Integer;
    function  GetItem(const Idx: Integer): TTCPConnectionProxy;
    function  GetLastItem: TTCPConnectionProxy;

  public
    destructor Destroy; override;
    procedure Finalise;

    property  Count: Integer read GetCount;
    property  Item[const Idx: Integer]: TTCPConnectionProxy read GetItem; default;
    procedure Add(const Proxy: TTCPConnectionProxy);
    property  LastItem: TTCPConnectionProxy read GetLastItem;
  end;

  TTCPConnectionState = (
    cnsInit,               // Initialising
    cnsProxyNegotiation,   // Proxy busy with negotiation
    cnsConnected,          // Connected
    cnsClosed);            // Closed
  TTCPConnectionStates = set of TTCPConnectionState;

  TTCPConnectionTransferState = record
    LastUpdate   : Word32;
    ByteCount    : Int64;
    TransferRate : Word32;
  end;

  TRawByteCharSet = set of AnsiChar;

  TTCPBlockingConnection = class;

  TTCPConnectionNotifyEvent = procedure (Sender: TTCPConnection) of object;
  TTCPConnectionStateChangeEvent = procedure (Sender: TTCPConnection; State: TTCPConnectionState) of object;
  TTCPConnectionLogEvent = procedure (Sender: TTCPConnection; LogType: TTCPLogType; LogMsg: String; LogLevel: Integer) of object;
  TTCPConnectionWorkerExecuteEvent = procedure (Sender: TTCPConnection;
      Connection: TTCPBlockingConnection; var CloseOnExit: Boolean) of object;

  TTCPConnection = class
  protected
    // parameters
    FSocket             : TSysSocket;

    FReadBufferMaxSize  : Integer;
    FWriteBufferMaxSize : Integer;

    FReadThrottle       : Boolean;
    FReadThrottleRate   : Integer;
    FWriteThrottle      : Boolean;
    FWriteThrottleRate  : Integer;

    FUseWorkerThread    : Boolean;

    FUserTag            : NativeInt;
    FUserObject         : TObject;

    FOnLog              : TTCPConnectionLogEvent;
    FOnStateChange      : TTCPConnectionStateChangeEvent;
    FOnReady            : TTCPConnectionNotifyEvent;
    FOnRead             : TTCPConnectionNotifyEvent;
    FOnWrite            : TTCPConnectionNotifyEvent;
    FOnClose            : TTCPConnectionNotifyEvent;
    FOnReadBufferFull   : TTCPConnectionNotifyEvent;
    FOnWriteBufferEmpty : TTCPConnectionNotifyEvent;

    FOnWait             : TTCPConnectionNotifyEvent;

    FOnWorkerExecute    : TTCPConnectionWorkerExecuteEvent;
    FOnWorkerFinished   : TTCPConnectionNotifyEvent;

    // state
    FLock                : TCriticalSection;
    FState               : TTCPConnectionState;

    FProxyList           : TTCPConnectionProxyList;
    FProxyConnection     : Boolean;

    FReadBuffer          : TTCPBuffer;
    FWriteBuffer         : TTCPBuffer;

    FReadTransferState   : TTCPConnectionTransferState;
    FWriteTransferState  : TTCPConnectionTransferState;

    FReadEventPending    : Boolean;
    FReadBufferFull      : Boolean;
    FReadProcessPending  : Boolean;
    FWriteEventPending   : Boolean;
    FShutdownPending     : Boolean;
    FClosePending        : Boolean;
    FReadyNotified       : Boolean;

    FBlockingConnection  : TTCPBlockingConnection;

    // worker thread
    FWorkerThread        : TThread;
    FWorkerErrorMsg      : String;
    FWorkerErrorClass    : String;

    procedure Init; virtual;

    procedure Lock;
    procedure Unlock;

    procedure Log(const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer = 0); overload;
    procedure Log(const LogType: TTCPLogType; const LogMsg: String; const LogArgs: array of const; const LogLevel: Integer = 0); overload;

    function  GetState: TTCPConnectionState;
    function  GetStateStr: RawByteString;
    procedure SetState(const State: TTCPConnectionState);

    procedure SetStateProxyNegotiation;
    procedure SetStateConnected;
    procedure SetStateClosed;

    procedure SetReady;

    procedure SetReadBufferMaxSize(const ReadBufferMaxSize: Integer);
    procedure SetWriteBufferMaxSize(const WriteBufferMaxSize: Integer);

    function  GetReadBufferUsed: Integer;
    function  GetWriteBufferUsed: Integer;

    procedure SetReadThrottle(const ReadThrottle: Boolean);
    procedure SetWriteThrottle(const WriteThrottle: Boolean);

    function  GetReadRate: Integer;
    function  GetWriteRate: Integer;

    procedure TriggerReady;
    procedure TriggerRead;
    procedure TriggerWrite;
    procedure TriggerClose;
    procedure TriggerReadBufferFull;
    procedure TriggerWriteBufferEmpty;

    procedure TriggerWait;
    procedure TriggerWorkerFinished;

    function  GetFirstActiveProxy: TTCPConnectionProxy;

    procedure ProxyProcessReadData(const Buf; const BufSize: Integer; out ReadEventPending: Boolean);
    procedure ProxyProcessWriteData(const Buf; const BufSize: Integer);

    procedure ProxyConnectionClose(const Proxy: TTCPConnectionProxy);
    procedure ProxyConnectionPutReadData(const Proxy: TTCPConnectionProxy; const Buf; const BufSize: Integer);
    procedure ProxyConnectionPutWriteData(const Proxy: TTCPConnectionProxy; const Buf; const BufSize: Integer);

    procedure ProxyLog(const Proxy: TTCPConnectionProxy; const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer);
    procedure ProxyStateChange(const Proxy: TTCPConnectionProxy; const State: TTCPConnectionProxyState);

    procedure StartProxies(out ProxiesFinished: Boolean);

    function  FillBufferFromSocket(out RecvClosed, ReadEventPending, ReadBufFullEvent: Boolean): Integer;
    function  EmptyBufferToSocket(out BufferEmptyBefore, BufferEmptied: Boolean): Integer;

    function  LocateChrInBuffer(const Delimiter: TRawByteCharSet; const MaxSize: Integer): Integer;
    function  LocateStrInBuffer(const Delimiter: RawByteString; const MaxSize: Integer): Integer;

    function  ReadFromBuffer(var Buf; const BufSize: Integer): Integer;
    function  ReadFromSocket(var Buf; const BufSize: Integer): Integer;

    function  DiscardFromBuffer(const Size: Integer): Integer;

    function  WriteToBuffer(const Buf; const BufSize: Integer): Integer;
    function  WriteToSocket(const Buf; const BufSize: Integer): Integer;
    function  WriteToTransport(const Buf; const BufSize: Integer): Integer;

    procedure DoShutdown;

    procedure Wait;

    function  GetBlockingConnection: TTCPBlockingConnection;

    procedure StartWorkerThread;
    procedure WorkerThreadExecute(const Thread: TThread);

  public
    constructor Create(const Socket: TSysSocket);
    destructor Destroy; override;
    procedure Finalise;

    // Parameters
    property  Socket: TSysSocket read FSocket;

    // Events
    property  OnLog: TTCPConnectionLogEvent read FOnLog write FOnLog;
    property  OnStateChange: TTCPConnectionStateChangeEvent read FOnStateChange write FOnStateChange;
    property  OnReady: TTCPConnectionNotifyEvent read FOnReady write FOnReady;
    property  OnRead: TTCPConnectionNotifyEvent read FOnRead write FOnRead;
    property  OnWrite: TTCPConnectionNotifyEvent read FOnWrite write FOnWrite;
    property  OnClose: TTCPConnectionNotifyEvent read FOnClose write FOnClose;
    property  OnReadBufferFull: TTCPConnectionNotifyEvent read FOnReadBufferFull write FOnReadBufferFull;
    property  OnWriteBufferEmpty: TTCPConnectionNotifyEvent read FOnWriteBufferEmpty write FOnWriteBufferEmpty;

    // Proxies
    procedure AddProxy(const Proxy: TTCPConnectionProxy);

    // State
    property  State: TTCPConnectionState read GetState;
    property  StateStr: RawByteString read GetStateStr;
    procedure Start;

    // Buffers
    property  ReadBufferMaxSize: Integer read FReadBufferMaxSize write SetReadBufferMaxSize;
    property  WriteBufferMaxSize: Integer read FWriteBufferMaxSize write SetWriteBufferMaxSize;

    property  ReadBufferUsed: Integer read GetReadBufferUsed;
    property  WriteBufferUsed: Integer read GetWriteBufferUsed;

    // Throttling
    property  ReadThrottle: Boolean read FReadThrottle write SetReadThrottle;
    property  ReadThrottleRate: Integer read FReadThrottleRate write FReadThrottleRate;
    property  WriteThrottle: Boolean read FWriteThrottle write SetWriteThrottle;
    property  WriteThrottleRate: Integer read FWriteThrottleRate write FWriteThrottleRate;

    property  ReadRate: Integer read GetReadRate;
    property  WriteRate: Integer read GetWriteRate;

    // Poll routine
    procedure GetEventsToPoll(out WritePoll: Boolean);
    procedure ProcessSocket(const ProcessRead, ProcessWrite: Boolean;
              out Idle, Terminated: Boolean);

    // Read
    function  Read(var Buf; const BufSize: Integer): Integer;
    function  ReadStrB(const StrLen: Integer): RawByteString;
    function  ReadBytes(const Len: Integer): TBytes;

    // Discard
    function  Discard(const Size: Integer): Integer;

    // Peek
    function  Peek(var Buf; const BufSize: Integer): Integer;
    function  PeekByte(out B: Byte): Boolean;
    function  PeekStrB(const StrLen: Integer): RawByteString;
    function  PeekBytes(const Len: Integer): TBytes;

    function  PeekDelimited(var Buf; const BufSize: Integer; const Delimiter: TRawByteCharSet; const MaxSize: Integer = -1): Integer; overload;
    function  PeekDelimited(var Buf; const BufSize: Integer; const Delimiter: RawByteString; const MaxSize: Integer = -1): Integer; overload;

    // ReadLine
    function  ReadLine(var Line: RawByteString; const Delimiter: RawByteString; const MaxLineLength: Integer = -1): Boolean;

    // Write
    function  Write(const Buf; const BufSize: Integer): Integer;
    function  WriteStrB(const Str: RawByteString): Integer;
    function  WriteBytes(const B: TBytes): Integer;

    // Shutdown/Close
    // Shutdown initiates a graceful shutdown.
    // Close closes connection immediately.
    procedure Shutdown;
    procedure Close;

    // Worker thread
    // Set UseWorkerThread to True and set OnWorkerExecute to execute
    // OnWorkerExecute in a separate thread.
    // The thread is launched when the connection state is Connected.
    // WorkerErrorClass and WorkerErrorMsg is set to the exception details if an
    // unhandled exception is raised in OnWorkerExecute.
    property  UseWorkerThread: Boolean read FUseWorkerThread write FUseWorkerThread;
    property  OnWorkerExecute: TTCPConnectionWorkerExecuteEvent read FOnWorkerExecute write FOnWorkerExecute;
    property  WorkerErrorClass: String read FWorkerErrorClass;
    property  WorkerErrorMsg: String read FWorkerErrorMsg;
    procedure TerminateWorkerThread;

    // Blocking
    // The blocking interface is available from the worker thread.
    // OnWait is called when blocking occurs.
    property  BlockingConnection: TTCPBlockingConnection read GetBlockingConnection;
    property  OnWait: TTCPConnectionNotifyEvent read FOnWait write FOnWait;

    // User defined values
    property  UserTag: NativeInt read FUserTag write FUserTag;
    property  UserObject: TObject read FUserObject write FUserObject;
  end;

  TTCPConnectionClass = class of TTCPConnection;

  // Blocking connection
  // These methods will block until a result is available or timeout expires.
  // If TimeOut is set to -1 then method may wait indefinetely for a result.
  // Note: These functions should not be called from this object's event handlers
  // or from the main thread.
  // These functions can only be called from the worker thread or any other user thread.
  TTCPBlockingConnection = class
  private
    FConnection : TTCPConnection;

    procedure Wait;

  public
    constructor Create(const Connection : TTCPConnection);
    destructor Destroy; override;
    procedure Finalise;

    property  Connection: TTCPConnection read FConnection;

    function  WaitForState(const States: TTCPConnectionStates; const TimeOutMs: Integer): TTCPConnectionState;
    function  WaitForReceiveData(const BufferSize: Integer; const TimeOutMs: Integer): Boolean;
    function  WaitForTransmitFin(const TimeOutMs: Integer): Boolean;
    function  WaitForClose(const TimeOutMs: Integer): Boolean;

    function  Read(var Buf; const BufferSize: Integer; const TimeOutMs: Integer = -1): Integer;
    function  Write(const Buf; const BufferSize: Integer; const TimeOutMs: Integer = -1): Integer;
    procedure Shutdown(
              const SettleTimeMs: Integer = 2000;
              const TransmitTimeOutMs: Integer = 15000;
              const CloseTimeOutMs: Integer = 45000);
    procedure Close(const TimeOutMs: Integer = 10000);
  end;



{                                                                              }
{ TCP timer helpers                                                            }
{                                                                              }
function  TCPGetTick: Word32;
function  TCPTickDelta(const D1, D2: Word32): Integer;
function  TCPTickDeltaU(const D1, D2: Word32): Word32;



implementation

uses
  { Fundamentals }
  flcSocketLib;



{                                                                              }
{ Error and debug strings                                                      }
{                                                                              }
const
  SError_InvalidParameter = 'Invalid parameter';
  SError_TimedOut         = 'Timed out';

  SConnectionProxyState : array[TTCPConnectionProxyState] of RawByteString = (
    'Init',
    'Negotiating',
    'Filtering',
    'Finished',
    'Error',
    'Closed'
    );

  SConnectionState : array[TTCPConnectionState] of RawByteString = (
    'Init',
    'ProxyNegotiation',
    'Connected',
    'Closed'
    );



{                                                                              }
{ TCP Connection Proxy                                                         }
{                                                                              }
class function TTCPConnectionProxy.ProxyName: String;
begin
  Result := ClassName;
end;

constructor TTCPConnectionProxy.Create(const Connection: TTCPConnection);
begin
  Assert(Assigned(Connection));
  inherited Create;
  FState := prsInit;
  FConnection := Connection;
end;

procedure TTCPConnectionProxy.Finalise;
begin
  FConnection := nil;
end;

procedure TTCPConnectionProxy.Log(const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer);
begin
  FConnection.ProxyLog(self, LogType, LogMsg, LogLevel);
end;

procedure TTCPConnectionProxy.Log(const LogType: TTCPLogType; const LogMsg: String; const LogArgs: array of const; const LogLevel: Integer);
begin
  Log(LogType, Format(LogMsg, LogArgs), LogLevel);
end;

function TTCPConnectionProxy.GetStateStr: RawByteString;
begin
  Result := SConnectionProxyState[FState];
end;

procedure TTCPConnectionProxy.SetState(const State: TTCPConnectionProxyState);
begin
  if State = FState then
    exit;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'State:%s', [SConnectionProxyState[State]]);
  {$ENDIF}
  FState := State;
  FConnection.ProxyStateChange(self, State);
end;

procedure TTCPConnectionProxy.ConnectionClose;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Close');
  {$ENDIF}
  FConnection.ProxyConnectionClose(self);
end;

procedure TTCPConnectionProxy.ConnectionPutReadData(const Buf; const BufSize: Integer);
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(tlDebug, 'PutRead:%db', [BufSize]);
  {$ENDIF}
  FConnection.ProxyConnectionPutReadData(self, Buf, BufSize);
end;

procedure TTCPConnectionProxy.ConnectionPutWriteData(const Buf; const BufSize: Integer);
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(tlDebug, 'PutWrite:%db', [BufSize]);
  {$ENDIF}
  FConnection.ProxyConnectionPutWriteData(self, Buf, BufSize);
end;

procedure TTCPConnectionProxy.Start;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Start');
  {$ENDIF}
  ProxyStart;
end;



{                                                                              }
{ TCP Connection Proxy List                                                    }
{                                                                              }
destructor TTCPConnectionProxyList.Destroy;
begin
  Finalise;
  inherited Destroy;
end;

procedure TTCPConnectionProxyList.Finalise;
var I : Integer;
begin
  for I := Length(FList) - 1 downto 0 do
    begin
      FList[I].Finalise;
      FreeAndNil(FList[I]);
    end;
  FList := nil;
end;

function TTCPConnectionProxyList.GetCount: Integer;
begin
  Result := Length(FList);
end;

function TTCPConnectionProxyList.GetItem(const Idx: Integer): TTCPConnectionProxy;
begin
  Assert((Idx >= 0) and (Idx < Length(FList)));
  Result := FList[Idx];
end;

function TTCPConnectionProxyList.GetLastItem: TTCPConnectionProxy;
var L : Integer;
begin
  L := Length(FList);
  if L = 0 then
    Result := nil
  else
    Result := FList[L - 1];
end;

procedure TTCPConnectionProxyList.Add(const Proxy: TTCPConnectionProxy);
var L : Integer;
begin
  Assert(Assigned(Proxy));
  L := Length(FList);
  SetLength(FList, L + 1);
  FList[L] := Proxy;
end;



{                                                                              }
{ TCP timer helpers                                                            }
{                                                                              }
function TCPGetTick: Word32;
begin
  Result := Trunc(Frac(Now) * $5265C00);
end;

{$IFOPT Q+}{$DEFINE QOn}{$ELSE}{$UNDEF QOn}{$ENDIF}{$Q-}
function TCPTickDelta(const D1, D2: Word32): Integer; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := Integer(D2 - D1);
end;

function TCPTickDeltaU(const D1, D2: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := Word32(D2 - D1);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}



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



{                                                                              }
{ TCP Connection Transfer Statistics                                           }
{                                                                              }

// Reset transfer statistics
procedure TCPConnectionTransferReset(var State: TTCPConnectionTransferState);
begin
  State.LastUpdate := TCPGetTick;
  State.ByteCount := 0;
  State.TransferRate := 0;
end;

// Update the transfer's internal state for elapsed time
procedure TCPConnectionTransferUpdate(var State: TTCPConnectionTransferState;
          const CurrentTick: Word32;
          out Elapsed: Integer);
begin
  Elapsed := TCPTickDelta(State.LastUpdate, CurrentTick);
  Assert(Elapsed >= 0);
  // wait at least 1000ms between updates
  if Elapsed < 1000 then
    exit;
  // update transfer rate
  State.TransferRate := (State.ByteCount * 1000) div Elapsed; // bytes per second
  // scale down
  while Elapsed > 60 do
    begin
      Elapsed := Elapsed div 2;
      State.ByteCount := State.ByteCount div 2;
    end;
  State.LastUpdate := TCPTickDeltaU(Word32(Elapsed), CurrentTick);
end;

// Returns the number of bytes that can be transferred with this throttle in place
function TCPConnectionTransferThrottledSize(var State: TTCPConnectionTransferState;
         const CurrentTick: Word32;
         const MaxTransferRate: Integer;
         const BufferSize: Integer): Integer;
var Elapsed, Quota, QuotaFree : Integer;
begin
  Assert(MaxTransferRate > 0);
  TCPConnectionTransferUpdate(State, CurrentTick, Elapsed);
  Quota := ((Elapsed + 30) * MaxTransferRate) div 1000; // quota allowed over Elapsed period
  QuotaFree := Quota - State.ByteCount;                 // quota remaining
  if QuotaFree >= BufferSize then
    Result := BufferSize else
  if QuotaFree <= 0 then
    Result := 0
  else
    Result := QuotaFree;
end;

// Updates transfer statistics for a number of bytes transferred
procedure TCPConnectionTransferredBytes(var State: TTCPConnectionTransferState;
          const ByteCount: Integer); {$IFDEF UseInline}inline;{$ENDIF}
begin
  Inc(State.ByteCount, ByteCount);
end;



{                                                                              }
{ TCP Connection Worker Thread                                                 }
{                                                                              }
type
  TTCPConnectionWorkerThread = class(TThread)
  private
    FConnection: TTCPConnection;
  protected
    procedure Execute; override;
  public
    constructor Create(const Connection: TTCPConnection);
    property Terminated;
  end;

constructor TTCPConnectionWorkerThread.Create(const Connection: TTCPConnection);
begin
  Assert(Assigned(Connection));
  FConnection := Connection;
  FreeOnTerminate := False;
  inherited Create(False);
end;

procedure TTCPConnectionWorkerThread.Execute;
begin
  FConnection.WorkerThreadExecute(self);
end;



{                                                                              }
{ TCP Connection                                                               }
{                                                                              }
constructor TTCPConnection.Create(const Socket: TSysSocket);
begin
  Assert(Assigned(Socket));
  inherited Create;
  FSocket := Socket;
  Init;
end;

destructor TTCPConnection.Destroy;
begin
  Finalise;
  inherited Destroy;
end;

procedure TTCPConnection.Finalise;
begin
  if Assigned(FWorkerThread) then
    begin
      FWorkerThread.Terminate;
      FWorkerThread.WaitFor;
      FreeAndNil(FWorkerThread);
    end;
  if Assigned(FBlockingConnection) then
    begin
      FBlockingConnection.Finalise;
      FreeAndNil(FBlockingConnection);
    end;
  FUserObject := nil;
  TCPBufferFinalise(FWriteBuffer);
  TCPBufferFinalise(FReadBuffer);
  if Assigned(FProxyList) then
    begin
      FProxyList.Finalise;
      FreeAndNil(FProxyList);
    end;
  FreeAndNil(FLock);
end;

procedure TTCPConnection.Init;
begin
  FState := cnsInit;
  FReadBufferMaxSize  := TCP_BUFFER_DEFAULTMAXSIZE;
  FWriteBufferMaxSize := TCP_BUFFER_DEFAULTMAXSIZE;
  FReadThrottle  := False;
  FWriteThrottle := False;
  FLock := TCriticalSection.Create;
  FProxyList := TTCPConnectionProxyList.Create;
  FProxyConnection := False;
  TCPBufferInitialise(FReadBuffer,  FReadBufferMaxSize,  TCP_BUFFER_DEFAULTBUFSIZE);
  TCPBufferInitialise(FWriteBuffer, FWriteBufferMaxSize, TCP_BUFFER_DEFAULTBUFSIZE);
end;

procedure TTCPConnection.Lock;
begin
  if Assigned(FLock) then
    FLock.Acquire;
end;

procedure TTCPConnection.Unlock;
begin
  if Assigned(FLock) then
    FLock.Release;
end;

procedure TTCPConnection.Log(const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer);
begin
  if Assigned(FOnLog) then
    FOnLog(self, LogType, LogMsg, LogLevel);
end;

procedure TTCPConnection.Log(const LogType: TTCPLogType; const LogMsg: String; const LogArgs: array of const; const LogLevel: Integer);
begin
  Log(LogType, Format(LogMsg, LogArgs), LogLevel);
end;

function TTCPConnection.GetState: TTCPConnectionState;
begin
  Lock;
  try
    Result := FState;
  finally
    Unlock;
  end;
end;

function TTCPConnection.GetStateStr: RawByteString;
begin
  Result := SConnectionState[GetState];
end;

procedure TTCPConnection.SetState(const State: TTCPConnectionState);
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'State:%s', [SConnectionState[State]]);
  {$ENDIF}
  Lock;
  try
    Assert(State <> FState);
    FState := State;
  finally
    Unlock;
  end;
  if Assigned(FOnStateChange) then
    FOnStateChange(self, State);
end;

procedure TTCPConnection.SetStateProxyNegotiation;
begin
  SetState(cnsProxyNegotiation);
end;

procedure TTCPConnection.SetStateConnected;
begin
  Assert(FState in [cnsInit, cnsProxyNegotiation, cnsClosed]);
  SetState(cnsConnected);
  Lock;
  try
    // Connection state can change from 'connected' back to 'proxy negotiation'
    // and then back to 'connected' again.
    // Trigger the ready event on the first change to 'connected'.
    if not FReadyNotified then
      begin
        FReadyNotified := True;
        SetReady;
      end;
  finally
    Unlock;
  end;
end;

procedure TTCPConnection.SetStateClosed;
begin
  if FState = cnsClosed then
    exit;
  SetState(cnsClosed);
  TriggerClose;
end;

procedure TTCPConnection.SetReady;
begin
  if FUseWorkerThread and Assigned(FOnWorkerExecute) then
    StartWorkerThread;
  TriggerReady;
end;

procedure TTCPConnection.AddProxy(const Proxy: TTCPConnectionProxy);
var P : TTCPConnectionProxy;
    DoNeg : Boolean;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'AddProxy:%s', [Proxy.ProxyName]);
  {$ENDIF}

  if not Assigned(Proxy) then
    raise ETCPConnection.Create(SError_InvalidParameter);
  Lock;
  try
    // add to list
    P := FProxyList.LastItem;
    FProxyList.Add(Proxy);
    if Assigned(P) then
      P.FNextProxy := Proxy;
    Proxy.FNextProxy := nil;
    FProxyConnection := True;
    // restart negotiation if connected
    DoNeg := (FState = cnsConnected);
  finally
    Unlock;
  end;
  if DoNeg then
    begin
      SetStateProxyNegotiation;
      Proxy.Start;
    end;
end;

procedure TTCPConnection.SetReadBufferMaxSize(const ReadBufferMaxSize: Integer);
begin
  Lock;
  try
    FReadBufferMaxSize := ReadBufferMaxSize;
    TCPBufferSetMaxSize(FReadBuffer, ReadBufferMaxSize);
  finally
    Unlock;
  end;
end;

procedure TTCPConnection.SetWriteBufferMaxSize(const WriteBufferMaxSize: Integer);
begin
  Lock;
  try
    FWriteBufferMaxSize := WriteBufferMaxSize;
    TCPBufferSetMaxSize(FWriteBuffer, WriteBufferMaxSize);
  finally
    Unlock;
  end;
end;

function TTCPConnection.GetReadBufferUsed: Integer;
begin
  Lock;
  try
    Result := FReadBuffer.Used;
  finally
    Unlock;
  end;
end;

function TTCPConnection.GetWriteBufferUsed: Integer;
begin
  Lock;
  try
    Result := FWriteBuffer.Used;
  finally
    Unlock;
  end;
end;

procedure TTCPConnection.SetReadThrottle(const ReadThrottle: Boolean);
begin
  if FReadThrottle = ReadThrottle then
    exit;
  FReadThrottle := ReadThrottle;
end;

procedure TTCPConnection.SetWriteThrottle(const WriteThrottle: Boolean);
begin
  if FWriteThrottle = WriteThrottle then
    exit;
  FWriteThrottle := WriteThrottle;
end;

function TTCPConnection.GetReadRate: Integer;
var E : Integer;
begin
  Lock;
  try
    if not FReadThrottle then
      TCPConnectionTransferUpdate(FReadTransferState, TCPGetTick, E);
    Result := FReadTransferState.TransferRate;
  finally
    Unlock;
  end;
end;

function TTCPConnection.GetWriteRate: Integer;
var E : Integer;
begin
  Lock;
  try
    if not FWriteThrottle then
      TCPConnectionTransferUpdate(FWriteTransferState, TCPGetTick, E);
    Result := FWriteTransferState.TransferRate;
  finally
    Unlock;
  end;
end;

procedure TTCPConnection.TriggerReady;
begin
  if Assigned(FOnReady) then
    FOnReady(self);
end;

procedure TTCPConnection.TriggerRead;
begin
  if Assigned(FOnRead) then
    FOnRead(self);
end;

procedure TTCPConnection.TriggerWrite;
begin
  if Assigned(FOnWrite) then
    FOnWrite(self);
end;

procedure TTCPConnection.TriggerClose;
begin
  if Assigned(FOnClose) then
    FOnClose(self);
end;

procedure TTCPConnection.TriggerReadBufferFull;
begin
  if Assigned(FOnReadBufferFull) then
    FOnReadBufferFull(self);
end;

procedure TTCPConnection.TriggerWriteBufferEmpty;
begin
  if Assigned(FOnWriteBufferEmpty) then
    FOnWriteBufferEmpty(self);
end;

procedure TTCPConnection.TriggerWait;
begin
  if Assigned(FOnWait) then
    FOnWait(self);
end;

procedure TTCPConnection.TriggerWorkerFinished;
begin
  if Assigned(FOnWorkerFinished) then
    FOnWorkerFinished(self);
end;

procedure TTCPConnection.ProxyConnectionClose(const Proxy: TTCPConnectionProxy);
begin
  Assert(FProxyConnection);
  // flag close pending; handled outside lock, after read pending
  Lock;
  try
    FClosePending := True;
  finally
    Unlock;
  end;
end;

function TTCPConnection.GetFirstActiveProxy: TTCPConnectionProxy;
var P : TTCPConnectionProxy;
begin
  Lock;
  try
    if FProxyList.Count = 0 then
      P := nil
    else
      P := FProxyList[0];
    while Assigned(P) and not (P.State in [prsNegotiating, prsFiltering]) do
      P := P.FNextProxy;
  finally
    Unlock;
  end;
  Result := P;
end;

procedure TTCPConnection.ProxyProcessReadData(const Buf; const BufSize: Integer; out ReadEventPending: Boolean);
var P : TTCPConnectionProxy;
begin
  Assert(FProxyConnection);
  Assert(FProxyList.Count > 0);

  ReadEventPending := False;
  P := GetFirstActiveProxy;
  if Assigned(P) then
    // pass to first active proxy
    P.ProcessReadData(Buf, BufSize)
  else
    begin
      // no active proxies, add data to read buffer
      Lock;
      try
        FProxyConnection := False;
        TCPBufferAddBuf(FReadBuffer, Buf, BufSize);
      finally
        Unlock;
      end;
      // allow user to read buffered data; flag pending event
      ReadEventPending := True;
    end;
end;

procedure TTCPConnection.ProxyProcessWriteData(const Buf; const BufSize: Integer);
var P : TTCPConnectionProxy;
begin
  Assert(FProxyConnection);
  Assert(FProxyList.Count > 0);

  P := GetFirstActiveProxy;
  if Assigned(P) then
    // pass to first active proxy
    P.ProcessWriteData(Buf, BufSize)
  else
    begin
      // no active proxies, send data
      Lock;      
      try
        FProxyConnection := False;
      finally
        Unlock;
      end;
      WriteToTransport(Buf, BufSize);
    end;
end;

function GetNextFilteringProxy(const Proxy: TTCPConnectionProxy): TTCPConnectionProxy;
var P : TTCPConnectionProxy;
begin
  Assert(Assigned(Proxy));

  P := Proxy.FNextProxy;
  while Assigned(P) and not (P.State = prsFiltering) do
    P := P.FNextProxy;
  Result := P;
end;

procedure TTCPConnection.ProxyConnectionPutReadData(const Proxy: TTCPConnectionProxy; const Buf; const BufSize: Integer);
var P : TTCPConnectionProxy;
begin
  P := GetNextFilteringProxy(Proxy);
  if Assigned(P) then
    // pass along proxy chain
    P.ProcessReadData(Buf, BufSize)
  else
    // last proxy, add to read buffer, regardless of available size
    // reading from socket is throttled in FillBufferFromSocket when read buffer fills up
    begin
      TCPBufferAddBuf(FReadBuffer, Buf, BufSize);
      // allow user to read buffered data; flag pending event
      FReadEventPending := True;
    end;
end;

procedure TTCPConnection.ProxyConnectionPutWriteData(const Proxy: TTCPConnectionProxy; const Buf; const BufSize: Integer);
var P : TTCPConnectionProxy;
begin
  P := GetNextFilteringProxy(Proxy);
  if Assigned(P) then
    // pass along proxy chain
    P.ProcessWriteData(Buf, BufSize)
  else
    // last proxy, add to write buffer, regardless of available size
    WriteToTransport(Buf, BufSize);
end;

procedure TTCPConnection.ProxyLog(const Proxy: TTCPConnectionProxy; const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer);
begin
  Assert(Assigned(Proxy));
  {$IFDEF TCP_DEBUG}
  Log(LogType, 'Proxy[%s]:%s', [Proxy.ProxyName, LogMsg], LogLevel + 1);
  {$ENDIF}
end;

// called when a proxy changes state
procedure TTCPConnection.ProxyStateChange(const Proxy: TTCPConnectionProxy; const State: TTCPConnectionProxyState);
var P : TTCPConnectionProxy;
begin
  case State of
    prsFiltering,
    prsFinished :
      begin
        Assert(FState = cnsProxyNegotiation);
        Lock;
        try
          P := Proxy.FNextProxy;
        finally
          Unlock;
        end;
        if Assigned(P) then
          P.Start
        else
          SetStateConnected;
      end;
    prsNegotiating : ;
    prsError  : ;
    prsClosed : ;
  end;
end;

procedure TTCPConnection.StartProxies(out ProxiesFinished: Boolean);
var L : Integer;
    P : TTCPConnectionProxy;
begin
  Lock;
  try
    L := FProxyList.Count;
    if L = 0 then
      begin
        // no proxies
        ProxiesFinished := True;
        exit;
      end;
    P := FProxyList.Item[0];
  finally
    Unlock;
  end;
  // start proxy negotiation
  SetStateProxyNegotiation;
  P.Start;
  ProxiesFinished := False;
end;

procedure TTCPConnection.Start;
var ProxiesFin : Boolean;
begin
  Assert(FState in [cnsInit, cnsClosed]);
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Start');
  {$ENDIF}
  Lock;
  try
    TCPConnectionTransferReset(FReadTransferState);
    TCPConnectionTransferReset(FWriteTransferState);
  finally
    Unlock;
  end;
  StartProxies(ProxiesFin);
  if ProxiesFin then
    SetStateConnected;
end;

// Pre: Socket is non-blocking
function TTCPConnection.FillBufferFromSocket(out RecvClosed, ReadEventPending, ReadBufFullEvent: Boolean): Integer;
const
  BufferSize = TCP_BUFFER_DEFAULTMAXSIZE;
var
  Buffer : array[0..BufferSize - 1] of Byte;
  Avail, Size : Integer;
  IsHandleInvalid : Boolean;
begin
  Result := 0;
  RecvClosed := False;
  ReadEventPending := False;
  ReadBufFullEvent := False;
  Lock;
  try
    // check space available in read buffer
    Avail := TCPBufferAvailable(FReadBuffer);
    if Avail > BufferSize then
      Avail := BufferSize;
    if Avail <= 0 then
      // no space in buffer, don't read any more from socket
      // this will eventually throttle the actual TCP connection when the system's TCP receive buffer fills up
      // Set FReadBufferFull flag, since read event won't trigger again, this function must be called manually
      // next time there's space in the receive buffer
      begin
        if not FReadBufferFull then
          begin
            ReadBufFullEvent := True;
            FReadBufferFull := True;
          end;
        exit;
      end;
    IsHandleInvalid := FSocket.SocketHandleInvalid;
  finally
    Unlock;
  end;
  // receive from socket into local buffer
  if IsHandleInvalid then // socket may have been closed by a proxy
    begin
      {$IFDEF TCP_DEBUG}
      Log(tlDebug, 'FillBufferFromSocket:SocketHandleInvalid');
      {$ENDIF}
      RecvClosed := True;
      exit;
    end;
  Size := FSocket.Recv(Buffer, Avail);
  if Size = 0 then
    begin
      {$IFDEF TCP_DEBUG}
      Log(tlDebug, 'FillBufferFromSocket:Close');
      {$ENDIF}
      // socket closed
      RecvClosed := True;
      exit;
    end;
  if Size < 0 then
    // nothing more to receive from socket
    exit;
  {$IFDEF TCP_DEBUG_DATA}
  Log(tlDebug, 'FillBufferFromSocket:Received:%db', [Size]);
  {$ENDIF}
  // data received
  Result := Size;
  if FProxyConnection then
    // pass local buffer to proxies to process
    ProxyProcessReadData(Buffer, Size, ReadEventPending)
  else
    // move from local buffer to read buffer
    begin
      Lock;
      try
        TCPBufferAddBuf(FReadBuffer, Buffer, Size);
      finally
        Unlock;
      end;
      // allow user to read buffered data; flag pending event
      ReadEventPending := True;
    end;
end;

// Returns number of bytes written to socket
// Pre: Socket is non-blocking
function TTCPConnection.EmptyBufferToSocket(out BufferEmptyBefore, BufferEmptied: Boolean): Integer;
var P : Pointer;
    SizeBuf, SizeWrite, SizeWritten : Integer;
    E : Boolean;
begin
  BufferEmptied := False;
  Lock;
  try
    SizeBuf := TCPBufferUsed(FWriteBuffer);
    // get write size
    E := SizeBuf <= 0;
    BufferEmptyBefore := E;
    if E then
      SizeWrite := 0
    else
    if FWriteThrottle and (FWriteThrottleRate > 0) then // throttled writing
      SizeWrite := TCPConnectionTransferThrottledSize(FWriteTransferState, TCPGetTick, FWriteThrottleRate, SizeBuf)
    else
      SizeWrite := SizeBuf;
    // handle nothing to send
    if SizeWrite = 0 then
      begin
        Result := 0;
        exit;
      end;
    // get buffer pointer
    P := TCPBufferPtr(FWriteBuffer);
    // send to socket
    Assert(Assigned(P));
    SizeWritten := FSocket.Send(P^, SizeWrite);
    // handle nothing sent
    if SizeWritten = 0 then
      begin
        Result := 0;
        exit;
      end;
    Assert(SizeWritten >= 0);
    // update transfer statistics
    TCPConnectionTransferredBytes(FWriteTransferState, SizeWritten);
    // discard successfully sent bytes from connection buffer
    TCPBufferDiscard(FWriteBuffer, SizeWritten);
  finally
    Unlock;
  end;
  // check if buffer emptied
  if SizeWritten = SizeBuf then
    BufferEmptied := True;
  {$IFDEF TCP_DEBUG_DATA}
  Log(tlDebug, 'EmptyBufferToSocket:Fin:%d:%db:%db:%db',
      [Ord(BufferEmptied), SizeBuf, SizeWrite, SizeWritten]);
  {$ENDIF}
  Result := SizeWritten;
end;

procedure TTCPConnection.GetEventsToPoll(out WritePoll: Boolean);
begin
  Lock;
  try
    WritePoll :=
        FWriteEventPending or
        FShutdownPending or
        not TCPBufferEmpty(FWriteBuffer);
  finally
    Unlock;
  end;
end;

// Processes socket by reading/writing
// Pre: Socket is non-blocking
procedure TTCPConnection.ProcessSocket(const ProcessRead, ProcessWrite: Boolean;
          out Idle, Terminated: Boolean);
var Len : Integer;
    WriteDoProcess, Error, Fin : Boolean;
    ReadProcessPending, ReadDoProcess : Boolean;
    RecvClosed, RecvReadEvent, RecvReadBufFullEvent, RecvCloseNow : Boolean;
    WriteBufEmptyBefore, WriteBufEmptied : Boolean;
    WriteEvent, WriteBufEmptyEvent, WriteShutdownNow : Boolean;
begin
  try
    Assert(FState <> cnsInit);
    Idle := True;
    // handle closed socket
    if FSocket.SocketHandleInvalid then
      begin
        Terminated := True;
        exit;
      end;
    // check if read/write should process
    Lock;
    try
      ReadProcessPending := FReadProcessPending;
      if ReadProcessPending then
        FReadProcessPending := False;
      ReadDoProcess := ReadProcessPending or ProcessRead;
      WriteDoProcess :=
          FWriteEventPending or
          FShutdownPending or
          (ProcessWrite and not TCPBufferEmpty(FWriteBuffer));
    finally
      Unlock;
    end;
    Terminated := False;
    // process read
    if ReadDoProcess then
      begin
        Fin := False;
        repeat
          // receive data from socket into buffer
          Len := FillBufferFromSocket(RecvClosed, RecvReadEvent, RecvReadBufFullEvent);
          Lock;
          try
            // check pending flags
            if FReadEventPending then
              begin
                RecvReadEvent := True;
                FReadEventPending := False;
              end;
            RecvCloseNow := FClosePending;
            if RecvCloseNow then
              FClosePending := False;
          finally
            Unlock;
          end;
          if Len > 0 then
            begin
              // data received
              Idle := False;
            end else
            begin
              // nothing received
              Fin := True;
            end;
          // perform pending actions
          if RecvReadBufFullEvent then
            TriggerReadBufferFull;
          if RecvReadEvent then
            TriggerRead;
          if RecvCloseNow then
            begin
              Close;
              Fin := True;
            end
          else
            if RecvClosed then
              begin
                // socket closed
                SetStateClosed;
                Terminated := True;
                Fin := True;
              end;
        until Fin;
      end;
    // process write
    if WriteDoProcess then
      begin
        WriteEvent := False;
        WriteBufEmptyEvent := False;
        WriteShutdownNow := False;
        Error := False;
        try
          Len := EmptyBufferToSocket(WriteBufEmptyBefore, WriteBufEmptied);
        except
          Len := 0;
          Error := True;
        end;
        Lock;
        try
          // check write state
          if FWriteEventPending then
            begin
              WriteEvent := True;
              WriteBufEmptyEvent := True;
              FWriteEventPending := False;
            end;
          if WriteBufEmptied then
            WriteBufEmptyEvent := True;
          if WriteBufEmptyBefore and FShutdownPending then
            begin
              WriteShutdownNow := True;
              FShutdownPending := False;
            end;
        finally
          Unlock;
        end;
        if Len > 0 then
          begin
            // data sent
            Idle := False;
            WriteEvent := True;
          end else
          begin
            if Error then
              // socket send error
              Terminated := True;
            // nothing sent
          end;
        // trigger write
        if WriteEvent then
          TriggerWrite;
        // triger write buffer empty
        if WriteBufEmptyEvent then
          TriggerWriteBufferEmpty;
        // pending shutdown
        if WriteShutdownNow then
          DoShutdown;
      end;
  except
    on E : Exception do
      begin
        Idle := False;
        Terminated := True;
        {$IFDEF TCP_DEBUG}
        Log(tlDebug, 'ProcessSocket:Terminated:%s', [E.Message]);
        {$ENDIF}
      end;
  end;
end;

// LocateChrInBuffer
// Returns position of Delimiter in buffer
// Returns >= 0 if found in buffer
// Returns -1 if not found in buffer
// MaxSize specifies maximum bytes before delimiter, of -1 for no limit
function TTCPConnection.LocateChrInBuffer(const Delimiter: TRawByteCharSet; const MaxSize: Integer): Integer;
var BufSize : Integer;
    LocLen  : Integer;
    BufPtr  : PByteChar;
    I       : Integer;
begin
  if MaxSize = 0 then
    begin
      Result := -1;
      exit;
    end;
  BufSize := FReadBuffer.Used;
  if BufSize <= 0 then
    begin
      Result := -1;
      exit;
    end;
  if MaxSize < 0 then
    LocLen := BufSize
  else
    if BufSize < MaxSize then
      LocLen := BufSize
    else
      LocLen := MaxSize;
  BufPtr := TCPBufferPtr(FReadBuffer);
  for I := 0 to LocLen - 1 do
    if BufPtr^ in Delimiter then
      begin
        Result := I;
        exit;
      end
    else
      Inc(BufPtr);
  Result := -1;
end;

// LocateStrInBuffer
// Returns position of Delimiter in buffer
// Returns >= 0 if found in buffer
// Returns -1 if not found in buffer
// MaxSize specifies maximum bytes before delimiter, of -1 for no limit
function TTCPConnection.LocateStrInBuffer(const Delimiter: RawByteString; const MaxSize: Integer): Integer;
var DelLen  : Integer;
    BufSize : Integer;
    LocLen  : Integer;
    BufPtr  : PByteChar;
    DelPtr  : PByteChar;
    I       : Integer;
begin
  if MaxSize = 0 then
    begin
      Result := -1;
      exit;
    end;
  DelLen := Length(Delimiter);
  if DelLen = 0 then
    begin
      Result := -1;
      exit;
    end;
  BufSize := FReadBuffer.Used;
  if BufSize < DelLen then
    begin
      Result := -1;
      exit;
    end;
  if MaxSize < 0 then
    LocLen := BufSize
  else
    if BufSize < MaxSize then
      LocLen := BufSize
    else
      LocLen := MaxSize;
  BufPtr := TCPBufferPtr(FReadBuffer);
  DelPtr := PByteChar(Delimiter);
  for I := 0 to LocLen - DelLen do
    if TCPCompareMem(BufPtr^, DelPtr^, DelLen) then
      begin
        Result := I;
        exit;
      end
    else
      Inc(BufPtr);
  Result := -1;
end;

// PeekDelimited
// Returns number of bytes transferred to buffer, including delimiter
// Returns -1 if not found in buffer
// Returns >= 0 if found.
// MaxSize specifies maximum bytes before delimiter, of -1 for no limit
function TTCPConnection.PeekDelimited(var Buf; const BufSize: Integer;
         const Delimiter: TRawByteCharSet; const MaxSize: Integer): Integer;
var DelPos : Integer;
    BufPtr : PByteChar;
    BufLen : Integer;
begin
  Lock;
  try
    DelPos := LocateChrInBuffer(Delimiter, MaxSize);
    if DelPos >= 0 then
      begin
        // found
        BufPtr := TCPBufferPtr(FReadBuffer);
        BufLen := DelPos + 1;
        if BufLen > BufSize then
          BufLen := BufSize;
        Move(BufPtr^, Buf, BufLen);
        Result := BufLen;
      end
    else
      Result := -1;
  finally
    Unlock;
  end;
end;

// PeekDelimited
// Returns number of bytes transferred to buffer, including delimiter
// Returns -1 if not found in buffer
// Returns >= 0 if found.
// MaxSize specifies maximum bytes before delimiter, of -1 for no limit
function TTCPConnection.PeekDelimited(var Buf; const BufSize: Integer;
         const Delimiter: RawByteString; const MaxSize: Integer): Integer;
var DelPos : Integer;
    BufPtr : PByteChar;
    BufLen : Integer;
begin
  Assert(Delimiter <> '');
  Lock;
  try
    DelPos := LocateStrInBuffer(Delimiter, MaxSize);
    if DelPos >= 0 then
      begin
        // found
        BufPtr := TCPBufferPtr(FReadBuffer);
        BufLen := DelPos + Length(Delimiter);
        if BufLen > BufSize then
          BufLen := BufSize;
        Move(BufPtr^, Buf, BufLen);
        Result := BufLen;
      end
    else
      Result := -1;
  finally
    Unlock;
  end;
end;

function TTCPConnection.ReadFromBuffer(var Buf; const BufSize: Integer): Integer;
begin
  Result := TCPBufferRemove(FReadBuffer, Buf, BufSize);
  if Result > 0 then
    if FReadBufferFull then
      begin
        FReadBufferFull := False;
        FReadProcessPending := True;
      end;
end;

function TTCPConnection.ReadFromSocket(var Buf; const BufSize: Integer): Integer;
begin
  Assert(BufSize > 0);

  if FSocket.SocketHandleInvalid then
    begin
      Result := 0;
      exit;
    end;
  Result := FSocket.Recv(Buf, BufSize);
  if Result = 0 then
    SetStateClosed else
  if Result < 0 then
    Result := 0;
end;

function TTCPConnection.DiscardFromBuffer(const Size: Integer): Integer;
begin
  Result := TCPBufferDiscard(FReadBuffer, Size);
  if Result > 0 then
    if FReadBufferFull then
      begin
        FReadBufferFull := False;
        FReadProcessPending := True;
      end;
end;

// Read a number of bytes from read buffer and transport.
// Return the number of bytes actually read.
// Throttles reading.
function TTCPConnection.Read(var Buf; const BufSize: Integer): Integer;
var
  BufPtr : PByteChar;
  SizeRead, SizeReadBuf, SizeReadSocket, SizeRemain, SizeTotal : Integer;
begin
  Lock;
  try
    // get read size
    if BufSize <= 0 then
      SizeRead := 0
    else
    if FReadThrottle then // throttled reading
      SizeRead := TCPConnectionTransferThrottledSize(FReadTransferState, TCPGetTick, FReadThrottleRate, BufSize)
    else
      SizeRead := BufSize;
    // handle nothing to read
    if SizeRead <= 0 then
      begin
        Result := 0;
        exit;
      end;
    // read from buffer
    SizeReadBuf := ReadFromBuffer(Buf, SizeRead);
    if SizeReadBuf = SizeRead then
      // required number of bytes was in buffer
      SizeReadSocket := 0
    else
    if FProxyConnection then
      // don't read directly from socket if this connection has proxies
      SizeReadSocket := 0
    else
      begin
        // calculate remaining bytes to read
        SizeRemain := SizeRead - SizeReadBuf;
        // read from socket
        BufPtr := @Buf;
        Inc(BufPtr, SizeReadBuf);
        SizeReadSocket := ReadFromSocket(BufPtr^, SizeRemain);
      end;
    SizeTotal := SizeReadBuf + SizeReadSocket;
    // update transfer statistics
    TCPConnectionTransferredBytes(FReadTransferState, SizeTotal);
  finally
    Unlock;
  end;
  {$IFDEF TCP_DEBUG_DATA}
  Log(tlDebug, 'Read:Fin:%db:%db:%db:%db',
      [BufSize, SizeRead, SizeReadBuf, SizeReadSocket]);
  {$ENDIF}
  // return number of bytes read
  Result := SizeTotal;
end;

function TTCPConnection.ReadStrB(const StrLen: Integer): RawByteString;
var ReadLen : Integer;
begin
  if StrLen <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, StrLen);
  ReadLen := Read(Result[1], StrLen);
  if ReadLen < StrLen then
    SetLength(Result, ReadLen);
end;

function TTCPConnection.ReadBytes(const Len: Integer): TBytes;
var ReadLen : Integer;
begin
  if Len <= 0 then
    begin
      Result := nil;
      exit;
    end;
  SetLength(Result, Len);
  ReadLen := Read(Result[0], Len);
  if ReadLen < Len then
    SetLength(Result, ReadLen);
end;

// Discard a number of bytes from the read buffer.
// Returns the number of bytes actually discarded.
// No throttling and no reading from transport.
function TTCPConnection.Discard(const Size: Integer): Integer;
var SizeDiscarded : Integer;
begin
  // handle nothing to discard
  if Size <= 0 then
    begin
      Result := 0;
      exit;
    end;
  Lock;
  try
    // discard from buffer
    SizeDiscarded := DiscardFromBuffer(Size);
    // update transfer statistics
    TCPConnectionTransferredBytes(FReadTransferState, SizeDiscarded);
  finally
    Unlock;
  end;
  {$IFDEF TCP_DEBUG_DATA}
  Log(tlDebug, 'DiscardedFromBuffer:%db:%db', [Size, SizeDiscarded]);
  {$ENDIF}
  // return number of bytes discarded
  Result := SizeDiscarded;
end;

function TTCPConnection.WriteToBuffer(const Buf; const BufSize: Integer): Integer;
begin
  TCPBufferAddBuf(FWriteBuffer, Buf, BufSize);
  Result := BufSize;
end;

function TTCPConnection.WriteToSocket(const Buf; const BufSize: Integer): Integer;
var L : Integer;
begin
  Assert(BufSize > 0);
  L := FSocket.Send(Buf, BufSize);
  // update transfer statistics
  TCPConnectionTransferredBytes(FWriteTransferState, L);
  // return number of bytes sent to socket
  Result := L;
end;

function TTCPConnection.WriteToTransport(const Buf; const BufSize: Integer): Integer;
var L : Integer;
    P : PByteChar;
    B : Boolean;
begin
  Result := 0;
  if BufSize <= 0 then
    exit;
  // if there is already data in the write buffer then add to the write buffer; or
  // if write is being throttled then add to the write buffer
  Lock;
  try
    B := (TCPBufferUsed(FWriteBuffer) > 0) or FWriteThrottle;
    if B then
      Result := WriteToBuffer(Buf, BufSize);
  finally
    Unlock;
  end;
  if B then
    begin
      {$IFDEF TCP_DEBUG_DATA}
      Log(tlDebug, 'WriteToTransport:WrittenToBuffer:%db:%db', [BufSize, Result]);
      {$ENDIF}
    end
  else
    begin
      // send the data directly to the socket
      Lock;
      try
        L := WriteToSocket(Buf, BufSize);
        if L < BufSize then
          begin
            // add the data not sent to the socket to the write buffer
            P := @Buf;
            Inc(P, L);
            WriteToBuffer(P^, BufSize - L);
          end
        else
          FWriteEventPending := True; // all data sent directly to socket
      finally
        Unlock;
      end;
      {$IFDEF TCP_DEBUG_DATA}
      Log(tlDebug, 'WriteToTransport:WrittenToSocketAndBuffer:%db:%db:%db', [BufSize, L, BufSize - L]);
      {$ENDIF}
      Result := BufSize;
    end;
end;

// Write a number of bytes to transport
// No throtling
function TTCPConnection.Write(const Buf; const BufSize: Integer): Integer;
var IsProxy : Boolean;
begin
  if BufSize <= 0 then
    begin
      Result := 0;
      exit;
    end;
  Lock;
  try
    // if this connection has proxies then pass the data to the proxies
    IsProxy := FProxyConnection;
  finally
    Unlock;
  end;
  if IsProxy then
    begin
      ProxyProcessWriteData(Buf, BufSize);
      Result := BufSize;
    end
  else
    // send data to socket
    Result := WriteToTransport(Buf, BufSize);
  Assert(Result = BufSize);
end;

function TTCPConnection.WriteStrB(const Str: RawByteString): Integer;
var Len : Integer;
begin
  Len := Length(Str);
  if Len <= 0 then
    begin
      Result := 0;
      exit;
    end;
  Result := Write(Str[1], Len);
end;

function TTCPConnection.WriteBytes(const B: TBytes): Integer;
var Len : Integer;
begin
  Len := Length(B);
  if Len <= 0 then
    begin
      Result := 0;
      exit;
    end;
  Result := Write(B[0], Len);
end;

// Peek a number of bytes from buffer.
// No throttling; no reading from transport
function TTCPConnection.Peek(var Buf; const BufSize: Integer): Integer;
begin
  Lock;
  try
    Result := TCPBufferPeek(FReadBuffer, Buf, BufSize);
  finally
    Unlock;
  end;
end;

function TTCPConnection.PeekByte(out B: Byte): Boolean;
begin
  Lock;
  try
    Result := TCPBufferPeekByte(FReadBuffer, B);
  finally
    Unlock;
  end;
end;

function TTCPConnection.PeekStrB(const StrLen: Integer): RawByteString;
var PeekLen : Integer;
begin
  if StrLen <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, StrLen);
  PeekLen := Peek(Result[1], StrLen);
  if PeekLen < StrLen then
    SetLength(Result, PeekLen);
end;

function TTCPConnection.PeekBytes(const Len: Integer): TBytes;
var PeekLen : Integer;
begin
  if Len <= 0 then
    begin
      Result := nil;
      exit;
    end;
  SetLength(Result, Len);
  PeekLen := Peek(Result[0], Len);
  if PeekLen < Len then
    SetLength(Result, PeekLen);
end;

// Reads a line delimited by specified Delimiter
// MaxLineLength is maximum line length excluding the delimiter
// Returns False if line not available
// Returns True if line read
function TTCPConnection.ReadLine(var Line: RawByteString; const Delimiter: RawByteString; const MaxLineLength: Integer): Boolean;
var
  DelPos : Integer;
  DelLen : Integer;
begin
  Assert(Delimiter <> '');
  Lock;
  try
    DelPos := LocateStrInBuffer(Delimiter, MaxLineLength);
    Result := DelPos >= 0;
    if not Result then
      exit;
    SetLength(Line, DelPos);
    if DelPos > 0 then
      Read(PByteChar(Line)^, DelPos);
    DelLen := Length(Delimiter);
    Discard(DelLen);
  finally
    Unlock;
  end;
end;

procedure TTCPConnection.DoShutdown;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'DoShutDown:%db:%db', [GetReadBufferUsed, GetWriteBufferUsed]);
  {$ENDIF}
  // Sends TCP FIN message to close connection and
  // disallow any further sending on the socket
  FSocket.Shutdown(ssSend);
end;

procedure TTCPConnection.Shutdown;
var ShutdownNow : Boolean;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'ShutDown:%db:%db', [GetReadBufferUsed, GetWriteBufferUsed]);
  {$ENDIF}
  Lock;
  try
    ShutdownNow := False;
    if TCPBufferUsed(FWriteBuffer) > 0 then
      // defer shutdown until write buffer is emptied to socket
      FShutdownPending := True
    else
      ShutdownNow := True;
  finally
    Unlock;
  end;
  if ShutdownNow then
    DoShutDown;
end;

procedure TTCPConnection.Close;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Close:%db:%db', [GetReadBufferUsed, GetWriteBufferUsed]);
  {$ENDIF}
  if GetState = cnsClosed then
    exit;
  SetStateClosed;
  FSocket.Close;
end;

procedure TTCPConnection.TerminateWorkerThread;
begin
  Lock;
  try
    if Assigned(FWorkerThread) then
      FWorkerThread.Terminate;
  finally
    Unlock;
  end;
end;

procedure TTCPConnection.Wait;
begin
  TriggerWait;
  Sleep(5);
end;

function TTCPConnection.GetBlockingConnection: TTCPBlockingConnection;
begin
  Lock;
  try
    if not Assigned(FBlockingConnection) then
      FBlockingConnection := TTCPBlockingConnection.Create(self);
    Result := FBlockingConnection;
  finally
    Unlock;
  end;
end;

procedure TTCPConnection.StartWorkerThread;
begin
  Assert(not Assigned(FWorkerThread));

  FWorkerThread := TTCPConnectionWorkerThread.Create(self);
end;

procedure TTCPConnection.WorkerThreadExecute(const Thread: TThread);
var
  WorkerThread : TTCPConnectionWorkerThread;
  Event : TTCPConnectionWorkerExecuteEvent;
  CloseOnExit : Boolean;

  function IsTerminated: Boolean;
  begin
    Result := WorkerThread.Terminated;
  end;

begin
  try
    WorkerThread := Thread as TTCPConnectionWorkerThread;
    CloseOnExit := False;
    try
      try
        Event := FOnWorkerExecute;
        if Assigned(Event) then
          Event(self, GetBlockingConnection, CloseOnExit);
      finally
        TriggerWorkerFinished;
      end;
    finally
      if not IsTerminated then
        if CloseOnExit then
          Close;
    end;
  except
    on E : Exception do
      if not IsTerminated then
        begin
          Lock;
          try
            FWorkerErrorMsg := E.Message;
            FWorkerErrorClass := E.ClassName;
          finally
            Unlock;
          end;
        end;
  end;
end;



{                                                                              }
{ TCP Blocking Connection                                                      }
{                                                                              }
constructor TTCPBlockingConnection.Create(const Connection: TTCPConnection);
begin
  Assert(Assigned(Connection));
  inherited Create;
  FConnection := Connection;
end;

destructor TTCPBlockingConnection.Destroy;
begin
  Finalise;
  inherited Destroy;
end;

procedure TTCPBlockingConnection.Finalise;
begin
  FConnection := nil;
end;

procedure TTCPBlockingConnection.Wait;
begin
  FConnection.Wait;
end;

// Wait until one of the States or time out.
function TTCPBlockingConnection.WaitForState(const States: TTCPConnectionStates; const TimeOutMs: Integer): TTCPConnectionState;
var T : Word32;
    S : TTCPConnectionState;
    C : TTCPConnection;
begin
  T := TCPGetTick;
  C := FConnection;
  repeat
    S := C.GetState;
    if S in States then
      break;
    if TimeOutMs >= 0 then
      if TCPTickDelta(T, TCPGetTick) >= TimeOutMs then
        break;
    Wait;
  until False;
  Result := S;
end;

// Wait until amount of data received, closed or time out.
function TTCPBlockingConnection.WaitForReceiveData(const BufferSize: Integer; const TimeOutMs: Integer): Boolean;
var T : Word32;
    L : Integer;
    C : TTCPConnection;
begin
  Assert(Assigned(FConnection));
  T := TCPGetTick;
  C := FConnection;
  repeat
    L := C.ReadBufferUsed;
    if L >= BufferSize then
      break;
    if TimeOutMs >= 0 then
      if TCPTickDelta(T, TCPGetTick) >= TimeOutMs then
        break;
    if C.GetState = cnsClosed then
      break;
    Wait;
  until False;
  Result := L >= BufferSize;
end;

// Wait until send buffer is cleared to socket, closed or time out.
function TTCPBlockingConnection.WaitForTransmitFin(const TimeOutMs: Integer): Boolean;
var T : Word32;
    L : Integer;
    C : TTCPConnection;
begin
  Assert(Assigned(FConnection));
  T := TCPGetTick;
  C := FConnection;
  repeat
    L := C.WriteBufferUsed;
    if L = 0 then
      break;
    if TimeOutMs >= 0 then
      if TCPTickDelta(T, TCPGetTick) >= TimeOutMs then
        break;
    if C.GetState = cnsClosed then
      break;
    Wait;
  until False;
  Result := L = 0;
end;

// Wait until socket is closed or timeout.
function TTCPBlockingConnection.WaitForClose(const TimeOutMs: Integer): Boolean;
begin
  Result := WaitForState([cnsClosed], TimeOutMs) = cnsClosed;
end;

// Wait for read data until required size is available or timeout.
function TTCPBlockingConnection.Read(var Buf; const BufferSize: Integer; const TimeOutMs: Integer): Integer;
begin
  if not WaitForReceiveData(BufferSize, TimeOutMs) then
    raise ETCPConnection.Create(SError_TimedOut);
  Result := FConnection.Read(Buf, BufferSize);
end;

// Write and wait for write buffers to empty or timeout.
function TTCPBlockingConnection.Write(const Buf; const BufferSize: Integer; const TimeOutMs: Integer): Integer;
begin
  Assert(Assigned(FConnection));
  Result := FConnection.Write(Buf, BufferSize);
  if Result > 0 then
    WaitForTransmitFin(TimeOutMs);
end;

// Does a graceful shutdown and waits for connection to close or timeout.
// Data received during shutdown is available after connection close.
//   SettleTimeMs is the maximum time to wait for output buffer to clear before initiating Shutdown.
//   TransmitTimeOutMs is the maximum time to wait for output buffers to clear after Shutdown.
//   CloseTimeOutMs is the maximum time to wait for the graceful close after output buffers cleared.
procedure TTCPBlockingConnection.Shutdown(
          const SettleTimeMs: Integer;
          const TransmitTimeOutMs: Integer;
          const CloseTimeOutMs: Integer);
begin
  Assert(Assigned(FConnection));
  if SettleTimeMs > 0 then
    WaitForTransmitFin(SettleTimeMs);
  FConnection.Shutdown;
  if not WaitForTransmitFin(TransmitTimeOutMs) then
    raise ETCPConnection.Create(SError_TimedOut);
  if not WaitForClose(CloseTimeOutMs) then
    raise ETCPConnection.Create(SError_TimedOut);
end;

// Closes immediately and waits for connection to close or timeout.
procedure TTCPBlockingConnection.Close(const TimeOutMs: Integer);
begin
  Assert(Assigned(FConnection));
  FConnection.Close;
  if not WaitForClose(TimeOutMs) then
    raise ETCPConnection.Create(SError_TimedOut);
end;



end.

