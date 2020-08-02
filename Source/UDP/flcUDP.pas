{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcUDP.pas                                               }
{   File version:     5.05                                                     }
{   Description:      UDP class.                                               }
{                                                                              }
{   Copyright:        Copyright (c) 2015-2020, David J Butler                  }
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
{  2015/09/06  0.01  Initial version.                                          }
{  2016/05/31  0.02  Read buffer.                                              }
{  2017/03/05  0.03  Minor Fixes.                                              }
{  2020/02/02  0.04  Start waits for thread ready state.                       }
{                    Trigger OnWrite event.                                    }
{                    Use write buffer when socket buffer is full.              }
{                    Process thread waits using Select wait period.            }
{                    Simple test: Bind, Write and Read.                        }
{  2020/08/02  5.05  Revise for Fundamentals 5.                                }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF DEBUG}
  {.DEFINE UDP_DEBUG}
  {.DEFINE UDP_DEBUG_THREAD}
  {$IFDEF TEST}
    {$DEFINE UDP_TEST}
  {$ENDIF}
{$ENDIF}

unit flcUDP;

interface

uses
  { System }

  SysUtils,
  SyncObjs,
  Classes,

  { Fundamentals }

  flcStdTypes,
  flcSocketLib,
  flcSocket;



type
  { Error }

  EUDPError = class(Exception);



  { UDP Buffer }

  PUDPPacket = ^TUDPPacket;
  TUDPPacket = record
    Next      : PUDPPacket;
    BufPtr    : Pointer;
    BufSize   : Int32;
    Addr      : TSocketAddr;
    Truncated : Boolean;
    TimeStamp : TDateTime;
  end;

  TUDPBuffer = record
    First : PUDPPacket;
    Last  : PUDPPacket;
    Count : Integer;
  end;
  PUDPBuffer = ^TUDPBuffer;



  { TF5UDP }

  TF5UDP = class;

  TUDPThread = class(TThread)
  protected
    FUDP : TF5UDP;
    procedure Execute; override;
  public
    constructor Create(const AUDP: TF5UDP);
    property Terminated;
  end;

  TUDPLogType = (
    ultDebug,
    ultInfo,
    ultError
    );

  TUDPState = (
    usInit,
    usStarting,
    usReady,
    usFailure,
    usClosed
    );

  TUDPNotifyEvent = procedure (const UDP: TF5UDP) of object;

  TUDPLogEvent = procedure (const UDP: TF5UDP; const LogType: TUDPLogType;
      const LogMessage: String; const LogLevel: Integer) of object;

  TUDPStateEvent = procedure (const UDP: TF5UDP; const State: TUDPState) of object;

  TUDPIdleEvent = procedure (const UDP: TF5UDP; const Thread: TUDPThread) of object;

  TF5UDP = class(TComponent)
  private
    // parameters
    FAddressFamily        : TIPAddressFamily;
    FBindAddressStr       : String;
    FServerPort           : Int32;
    FMaxReadBufferPackets : Integer;
    FUserTag              : NativeInt;
    FUserObject           : TObject;

    // events
    FOnLog          : TUDPLogEvent;
    FOnStateChanged : TUDPStateEvent;
    FOnStart        : TUDPNotifyEvent;
    FOnStop         : TUDPNotifyEvent;
    FOnReady        : TUDPNotifyEvent;
    FOnThreadIdle   : TUDPIdleEvent;
    FOnRead         : TUDPNotifyEvent;
    FOnWrite        : TUDPNotifyEvent;

    // state
    FLock               : TCriticalSection;
    FActive             : Boolean;
    FActiveOnLoaded     : Boolean;
    FState              : TUDPState;
    FErrorStr           : String;
    FReadyEvent         : TSimpleEvent;
    FProcessThread      : TUDPThread;
    FSocket             : TSysSocket;
    FBindAddress        : TSocketAddr;
    FReadBuffer         : TUDPBuffer;
    FWriteBuffer        : TUDPBuffer;
    FWriteEventPending  : Boolean;
    FWriteSelectPending : Boolean;

  protected
    procedure Init; virtual;
    procedure InitDefaults; virtual;

    procedure Lock;
    procedure Unlock;

    procedure Log(const LogType: TUDPLogType; const Msg: String; const LogLevel: Integer = 0); overload;
    procedure Log(const LogType: TUDPLogType; const Msg: String; const Args: array of const; const LogLevel: Integer = 0); overload;
    procedure LogException(const Msg: String; const E: Exception);

    procedure CheckNotActive;
    procedure CheckActive;
    procedure CheckReady;

    procedure SetAddressFamily(const AddressFamily: TIPAddressFamily);
    procedure SetBindAddress(const BindAddressStr: String);
    procedure SetServerPort(const ServerPort: Int32);

    procedure SetMaxReadBufferPackets(const ReadBufferSize: Integer);

    function  GetState: TUDPState;
    function  GetStateStr: String;
    procedure SetState(const AState: TUDPState);

    procedure SetReady; virtual;
    procedure SetClosed; virtual;

    procedure SetActive(const Active: Boolean);
    procedure Loaded; override;

    procedure TriggerStart; virtual;
    procedure TriggerStop; virtual;
    procedure TriggerRead;
    procedure TriggerWrite;

    procedure StartProcessThread;
    procedure StopThread;

    procedure CreateSocket;
    procedure BindSocket;

    procedure CloseSocket;

    procedure FillBufferFromSocket;
    procedure WriteBufferToSocket;

    procedure ProcessSocket(out IsError, IsTerminated: Boolean);

    procedure ProcessThreadExecute(const AThread: TUDPThread);

    procedure ThreadError(const Thread: TUDPThread; const Error: Exception);
    procedure ThreadTerminate(const Thread: TUDPThread);

    procedure Close;

    procedure InternalStart;
    procedure InternalStop;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property  AddressFamily: TIPAddressFamily read FAddressFamily write SetAddressFamily default iaIP4;
    property  BindAddress: String read FBindAddressStr write SetBindAddress;
    property  ServerPort: Int32 read FServerPort write SetServerPort;
    property  MaxReadBufferPackets: Integer read FMaxReadBufferPackets write SetMaxReadBufferPackets;

    property  OnLog: TUDPLogEvent read FOnLog write FOnLog;
    property  OnStateChanged: TUDPStateEvent read FOnStateChanged write FOnStateChanged;
    property  OnStart: TUDPNotifyEvent read FOnStart write FOnStart;
    property  OnStop: TUDPNotifyEvent read FOnStop write FOnStop;
    property  OnReady: TUDPNotifyEvent read FOnReady write FOnReady;
    property  OnThreadIdle: TUDPIdleEvent read FOnThreadIdle write FOnThreadIdle;
    property  OnRead: TUDPNotifyEvent read FOnRead write FOnRead;
    property  OnWrite: TUDPNotifyEvent read FOnWrite write FOnWrite;

    property  State: TUDPState read GetState;
    property  StateStr: String read GetStateStr;

    property  Active: Boolean read FActive write SetActive default False;
    procedure Start;
    procedure Stop;

    function  Read(
              var Buf;
              const BufSize: Int32;
              out FromAddr: TSocketAddr;
              out Truncated: Boolean): Integer;

    procedure Write(
              const ToAddr: TSocketAddr;
              const Buf;
              const BufSize: Int32);

    property  UserTag: NativeInt read FUserTag write FUserTag;
    property  UserObject: TObject read FUserObject write FUserObject;
  end;



{                                                                              }
{ Tests                                                                        }
{                                                                              }

{$IFDEF UDP_TEST}
procedure Test;
{$ENDIF}



implementation



{                                                                              }
{ UDP Buffer                                                                   }
{                                                                              }

procedure UDPPacketInitialise(out Packet: TUDPPacket);
begin
  FillChar(Packet, SizeOf(Packet), 0);
end;

procedure UDPPacketFinalise(var Packet: TUDPPacket);
var
  P : Pointer;
begin
  P := Packet.BufPtr;
  if Assigned(P) then
    begin
      Packet.BufPtr := nil;
      FreeMem(P);
    end;
end;

procedure UDPPacketFree(const Packet: PUDPPacket);
begin
  if Assigned(Packet) then
    begin
      UDPPacketFinalise(Packet^);
      Dispose(Packet);
    end;
end;

procedure UDPBufferInit(var Buf: TUDPBuffer);
begin
  Buf.First := nil;
  Buf.Last := nil;
  Buf.Count := 0;
end;

procedure UDPBufferAdd(var Buf: TUDPBuffer; const Packet: PUDPPacket);
begin
  Assert(Assigned(Packet));
  Packet^.Next := nil;
  if not Assigned(Buf.First) then
    begin
      Buf.First := Packet;
      Buf.Last := Packet;
      Buf.Count := 1;
      exit;
    end;
  Assert(Assigned(Buf.Last));
  Buf.Last^.Next := Packet;
  Buf.Last := Packet;
  Inc(Buf.Count);
end;

function UDPBufferIsEmpty(const Buf: TUDPBuffer): Boolean;
begin
  Result := not Assigned(Buf.First);
end;

function UDPBufferPeek(var Buf: TUDPBuffer; var Packet: PUDPPacket): Boolean;
begin
  Packet := Buf.First;
  Result := Assigned(Packet);
end;

procedure UDPBufferRemove(var Buf: TUDPBuffer; var Packet: PUDPPacket);
var
  N : PUDPPacket;
begin
  if not Assigned(Buf.First) then
    begin
      Packet := nil;
      exit;
    end;
  Packet := Buf.First;
  N := Packet^.Next;
  Buf.First := N;
  if not Assigned(N) then
    Buf.Last := nil;
  Packet^.Next := nil;
  Dec(Buf.Count);
end;

procedure UDPBufferDiscardPacket(var Buf: TUDPBuffer);
var
  Packet, N : PUDPPacket;
begin
  if not Assigned(Buf.First) then
    exit;
  Packet := Buf.First;
  N := Packet^.Next;
  Buf.First := N;
  if not Assigned(N) then
    Buf.Last := nil;
  Dec(Buf.Count);
  UDPPacketFree(Packet);
end;

procedure UDPBufferFinalise(var Buffer: TUDPBuffer);
var
  P, N : PUDPPacket;
begin
  P := Buffer.First;
  while Assigned(P) do
    begin
      N := P^.Next;
      UDPPacketFree(P);
      P := N;
    end;
  Buffer.First := nil;
  Buffer.Last := nil;
end;



{                                                                              }
{ Error and debug strings                                                      }
{                                                                              }

const
  SError_NotAllowedWhileActive   = 'Operation not allowed while socket is active';
  SError_NotAllowedWhileInactive = 'Operation not allowed while socket is inactive';
  SError_InvalidServerPort       = 'Invalid server port';
  SError_NotReady                = 'Socket not ready';
  SError_StartFailed             = 'Start failed';

  UDPStateStr : array[TUDPState] of String = (
      'Initialise',
      'Starting',
      'Ready',
      'Failure',
      'Closed');



{                                                                              }
{ UDP Thread                                                                   }
{                                                                              }

constructor TUDPThread.Create(const AUDP: TF5UDP);
begin
  Assert(Assigned(AUDP));
  FUDP := AUDP;
  FreeOnTerminate := False;
  inherited Create(False);
end;

procedure TUDPThread.Execute;
begin
  Assert(Assigned(FUDP));
  try
    try
      FUDP.ProcessThreadExecute(self);
    except
      on E : Exception do
        if not Terminated then
          FUDP.ThreadError(self, E);
    end;
  finally
    if not Terminated then
      FUDP.ThreadTerminate(self);
    FUDP := nil;
  end;
end;



{                                                                              }
{ TF5UDP                                                                       }
{                                                                              }

constructor TF5UDP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Init;
end;

procedure TF5UDP.Init;
begin
  FState := usInit;
  FActiveOnLoaded := False;
  FLock := TCriticalSection.Create;
  UDPBufferInit(FReadBuffer);
  UDPBufferInit(FWriteBuffer);
  FReadyEvent := TSimpleEvent.Create;
  InitDefaults;
end;

procedure TF5UDP.InitDefaults;
begin
  FActive := False;
  FAddressFamily := iaIP4;
  FBindAddressStr := '0.0.0.0';
  FMaxReadBufferPackets := 1024;
end;

destructor TF5UDP.Destroy;
begin
  StopThread;
  FreeAndNil(FSocket);
  FreeAndNil(FReadyEvent);
  UDPBufferFinalise(FWriteBuffer);
  UDPBufferFinalise(FReadBuffer);
  FreeAndNil(FLock);
  inherited Destroy;
end;

procedure TF5UDP.Lock;
begin
  FLock.Acquire;
end;

procedure TF5UDP.Unlock;
begin
  FLock.Release;
end;

procedure TF5UDP.Log(const LogType: TUDPLogType; const Msg: String; const LogLevel: Integer);
begin
  if Assigned(FOnLog) then
    FOnLog(self, LogType, Msg, LogLevel);
end;

procedure TF5UDP.Log(const LogType: TUDPLogType; const Msg: String; const Args: array of const; const LogLevel: Integer);
begin
  Log(LogType, Format(Msg, Args), LogLevel);
end;

procedure TF5UDP.LogException(const Msg: String; const E: Exception);
begin
  Log(ultError, Msg, [E.Message]);
end;

procedure TF5UDP.CheckNotActive;
begin
  if not (csDesigning in ComponentState) then
    if FActive then
      raise EUDPError.Create(SError_NotAllowedWhileActive);
end;

procedure TF5UDP.CheckActive;
begin
  if not (csDesigning in ComponentState) then
    if not FActive then
      raise EUDPError.Create(SError_NotAllowedWhileInactive);
end;

procedure TF5UDP.CheckReady;
begin
  if GetState <> usReady then
    raise EUDPError.Create(SError_NotReady);
end;

procedure TF5UDP.SetAddressFamily(const AddressFamily: TIPAddressFamily);
begin
  if AddressFamily = FAddressFamily then
    exit;
  CheckNotActive;
  FAddressFamily := AddressFamily;
end;

procedure TF5UDP.SetBindAddress(const BindAddressStr: String);
begin
  if BindAddressStr = FBindAddressStr then
    exit;
  CheckNotActive;
  FBindAddressStr := BindAddressStr;
  {$IFDEF UDP_DEBUG}
  Log(ultDebug, 'BindAddress:%s', [BindAddressStr]);
  {$ENDIF}
end;

procedure TF5UDP.SetServerPort(const ServerPort: Int32);
begin
  if ServerPort = FServerPort then
    exit;
  CheckNotActive;
  if (ServerPort <= 0) or (ServerPort > $FFFF) then
    raise EUDPError.Create(SError_InvalidServerPort);
  FServerPort := ServerPort;
  {$IFDEF UDP_DEBUG}
  Log(ultDebug, 'ServerPort:%d', [ServerPort]);
  {$ENDIF}
end;

procedure TF5UDP.SetMaxReadBufferPackets(const ReadBufferSize: Integer);
begin
  if ReadBufferSize = FMaxReadBufferPackets then
    exit;
  CheckNotActive;
  FMaxReadBufferPackets := ReadBufferSize;
end;

function TF5UDP.GetState: TUDPState;
begin
  Lock;
  try
    Result := FState;
  finally
    Unlock;
  end;
end;

function TF5UDP.GetStateStr: String;
begin
  Result := UDPStateStr[GetState];
end;

procedure TF5UDP.SetState(const AState: TUDPState);
begin
  Lock;
  try
    Assert(FState <> AState);
    FState := AState;
  finally
    Unlock;
  end;
  if Assigned(FOnStateChanged) then
    FOnStateChanged(self, AState);
  {$IFDEF UDP_DEBUG}
  Log(ultDebug, 'State:%s', [GetStateStr]);
  {$ENDIF}
end;

procedure TF5UDP.SetReady;
begin
  SetState(usReady);
  if Assigned(FOnReady) then
    FOnReady(self);
end;

procedure TF5UDP.SetClosed;
begin
  SetState(usClosed);
end;

procedure TF5UDP.SetActive(const Active: Boolean);
begin
  if Active = FActive then
    exit;
  if csDesigning in ComponentState then
    FActive := Active else
  if csLoading in ComponentState then
    FActiveOnLoaded := Active
  else
    if Active then
      InternalStart
    else
      InternalStop;
end;

procedure TF5UDP.Loaded;
begin
  inherited Loaded;
  if FActiveOnLoaded then
    InternalStart;
end;

procedure TF5UDP.TriggerStart;
begin
  if Assigned(FOnStart) then
    FOnStart(self);
end;

procedure TF5UDP.TriggerStop;
begin
  if Assigned(FOnStop) then
    FOnStop(self);
end;

procedure TF5UDP.TriggerRead;
begin
  if Assigned(FOnRead) then
    FOnRead(self);
end;

procedure TF5UDP.TriggerWrite;
begin
  if Assigned(FOnWrite) then
    FOnWrite(self);
end;

procedure TF5UDP.StartProcessThread;
begin
  Assert(not Assigned(FProcessThread));
  FProcessThread := TUDPThread.Create(self);
end;

procedure TF5UDP.StopThread;
begin
  if not Assigned(FProcessThread) then
    exit;
  if not FProcessThread.Terminated then
    FProcessThread.Terminate;
  FProcessThread.WaitFor;
  FreeAndNil(FProcessThread);
end;

procedure TF5UDP.CreateSocket;
begin
  Assert(not Assigned(FSocket));
  FSocket := TSysSocket.Create(FAddressFamily, ipUDP, False);
end;

procedure TF5UDP.BindSocket;
begin
  FBindAddress := ResolveHost(FBindAddressStr, FAddressFamily);
  SetSocketAddrPort(FBindAddress, FServerPort);

  Assert(Assigned(FSocket));
  FSocket.Bind(FBindAddress);
end;

procedure TF5UDP.CloseSocket;
begin
  if Assigned(FSocket) then
    FSocket.CloseSocket;
end;

procedure TF5UDP.FillBufferFromSocket;
const
  MaxBufSize = $10000;
var
  RecvSize   : Int32;
  Buf        : array[0..MaxBufSize - 1] of Byte;
  FromAddr   : TSocketAddr;
  Truncated  : Boolean;
  RecvPacket : Boolean;
  Packet     : PUDPPacket;
begin
  repeat
    Lock;
    try
      if (FMaxReadBufferPackets > 0) and (FReadBuffer.Count >= FMaxReadBufferPackets) then
        RecvPacket := False
      else
        begin
          RecvSize := FSocket.RecvFromEx(Buf[0], SizeOf(Buf), FromAddr, Truncated);
          RecvPacket := RecvSize >= 0;
          if RecvPacket then
            begin
              New(Packet);
              UDPPacketInitialise(Packet^);
              Packet^.BufSize := RecvSize;
              if RecvSize > 0 then
                begin
                  GetMem(Packet^.BufPtr, RecvSize);
                  Move(Buf[0], Packet^.BufPtr^, RecvSize);
                end;
              Packet^.Addr := FromAddr;
              Packet^.Truncated := Truncated;
              Packet^.TimeStamp := Now;
              UDPBufferAdd(FReadBuffer, Packet);
            end;
        end;
    finally
      Unlock;
    end;
    if RecvPacket then
      TriggerRead;
  until not RecvPacket;
end;

procedure TF5UDP.WriteBufferToSocket;
var
  Packet : PUDPPacket;
  SentPacket : Boolean;
begin
  Lock;
  try
    SentPacket := False;
    while UDPBufferPeek(FWriteBuffer, Packet) do
      begin
        if FSocket.SendTo(Packet^.Addr, Packet^.BufPtr^, Packet^.BufSize) < 0 then
          break;
        UDPBufferDiscardPacket(FWriteBuffer);
        SentPacket := True;
      end;
    if SentPacket then
      FWriteEventPending := True;
  finally
    Unlock;
  end;
end;

procedure TF5UDP.ProcessSocket(out IsError, IsTerminated: Boolean);
var
  LWriteEventPending : Boolean;
  LWriteSelectPending : Boolean;
  LWriteBufferNotEmpty : Boolean;
  ReadSelect, WriteSelect, ErrorSelect : Boolean;
  SelectSuccess : Boolean;
begin
  Lock;
  try
    Assert(Assigned(FSocket));
    if FSocket.IsSocketHandleInvalid then
      begin
        IsError := True;
        IsTerminated := True;
        exit;
      end;
    LWriteEventPending := FWriteEventPending;
    if LWriteEventPending then
      begin
        FWriteEventPending := False;
        FWriteSelectPending := True;
      end;
    LWriteSelectPending := FWriteSelectPending;
    LWriteBufferNotEmpty := not UDPBufferIsEmpty(FWriteBuffer);
  finally
    Unlock;
  end;
  IsTerminated := False;
  ReadSelect := True;
  WriteSelect :=
      LWriteSelectPending or
      LWriteBufferNotEmpty;
  ErrorSelect := False;
  IsError := False;
  try
    SelectSuccess := FSocket.Select(
        100 * 1000, // 100ms
        ReadSelect, WriteSelect, ErrorSelect);
  except
    SelectSuccess := False;
    IsError := True;
  end;
  if not IsError then
    if SelectSuccess then
      begin
        if ReadSelect then
          begin
            TriggerRead;
            FillBufferFromSocket;
          end;
        if WriteSelect then
          begin
            WriteBufferToSocket;
            TriggerWrite;
            if LWriteSelectPending then
              begin
                Lock;
                try
                  FWriteSelectPending := False;
                finally
                  Unlock;
                end;
              end;
          end;
      end;
end;

// The processing thread handles processing of client sockets
// Event handlers are called from this thread
// A single instance of the processing thread executes
procedure TF5UDP.ProcessThreadExecute(const AThread: TUDPThread);

  function IsTerminated: Boolean;
  begin
    Result := AThread.Terminated;
  end;

var
  ProcIsError, ProcIsTerminated : Boolean;
begin
  {$IFDEF UDP_DEBUG_THREAD}
  Log(ultDebug, 'ProcessThreadExecute');
  {$ENDIF}

  Assert(Assigned(AThread));
  Assert(FState = usStarting);

  try
    CreateSocket;

    FSocket.SetBlocking(True);

    BindSocket;
    if IsTerminated then
      exit;

    FSocket.SetBlocking(False);

    SetReady;
    if IsTerminated then
      exit;
  finally
    FReadyEvent.SetEvent;
  end;

  while not IsTerminated do
    begin
      ProcessSocket(ProcIsError, ProcIsTerminated);
      if ProcIsTerminated then
        break;
      if IsTerminated then
        break;
      if ProcIsError then
        Sleep(100);
    end;
end;

procedure TF5UDP.ThreadError(const Thread: TUDPThread; const Error: Exception);
begin
  FErrorStr := Error.Message;
  Log(ultError, Format('ThreadError(%s,%s)', [Error.ClassName, Error.Message]));
  if GetState in [usInit, usStarting, usReady] then
    SetState(usFailure);
end;

procedure TF5UDP.ThreadTerminate(const Thread: TUDPThread);
begin
  {$IFDEF UDP_DEBUG_THREAD}
  Log(ultDebug, 'ThreadTerminate');
  {$ENDIF}
end;

procedure TF5UDP.Close;
begin
  CloseSocket;
  SetClosed;
end;

procedure TF5UDP.InternalStart;
begin
  {$IFDEF UDP_DEBUG}
  Log(ultDebug, 'Starting');
  {$ENDIF}

  TriggerStart;
  SetState(usStarting);

  StartProcessThread;
  if FReadyEvent.WaitFor(INFINITE) <> wrSignaled then
    raise EUDPError.Create(SError_StartFailed);
  if GetState <> usReady then
    raise EUDPError.Create(SError_StartFailed);

  {$IFDEF UDP_DEBUG}
  Log(ultDebug, 'Started');
  {$ENDIF}
end;

procedure TF5UDP.InternalStop;
begin
  {$IFDEF UDP_DEBUG}
  Log(ultDebug, 'Stopping');
  {$ENDIF}

  TriggerStop;

  StopThread;
  Close;
  FreeAndNil(FSocket);

  {$IFDEF UDP_DEBUG}
  Log(ultDebug, 'Stopped');
  {$ENDIF}
end;

procedure TF5UDP.Start;
begin
  Lock;
  try
    if FActive then
      exit;
    FActive := True;
  finally
    Unlock;
  end;

  InternalStart;
end;

procedure TF5UDP.Stop;
begin
  Lock;
  try
    if not FActive then
      exit;
    FActive := False;
  finally
    Unlock;
  end;

  InternalStop;
end;

function TF5UDP.Read(
         var Buf;
         const BufSize: Int32;
         out FromAddr: TSocketAddr;
         out Truncated: Boolean): Integer;
var
  Packet : PUDPPacket;
  Len : Int32;
begin
  Lock;
  try
    if not UDPBufferIsEmpty(FReadBuffer) then
      begin
        UDPBufferRemove(FReadBuffer, Packet);
        Assert(Assigned(Packet));
        FromAddr := Packet^.Addr;
        Truncated := Packet^.Truncated;
        Len := Packet^.BufSize;
        if BufSize < Len then
          Len := BufSize;
        if Len > 0 then
          Move(Packet^.BufPtr^, Buf, Len);
        Result := Packet^.BufSize;
        UDPPacketFree(Packet);
        exit;
      end;
    if not FActive or (FState <> usReady) then
      raise EUDPError.Create(SError_NotReady);
    Result := FSocket.RecvFromEx(Buf, BufSize, FromAddr, Truncated);
    if Result < 0 then
      begin
        InitSocketAddrNone(FromAddr);
        Truncated := False;
      end;
  finally
    Unlock;
  end;
end;

procedure TF5UDP.Write(
          const ToAddr: TSocketAddr;
          const Buf;
          const BufSize: Int32);
var
  AddToBuf : Boolean;
  Packet   : PUDPPacket;
begin
  Lock;
  try
    if not FActive or (FState <> usReady) then
      raise EUDPError.Create(SError_NotReady);
    if not UDPBufferIsEmpty(FWriteBuffer) then
      AddToBuf := True
    else
      begin
        Assert(Assigned(FSocket));
        if FSocket.SendTo(ToAddr, Buf, BufSize) < 0 then
          AddToBuf := True
        else
          begin
            AddToBuf := False;
            FWriteEventPending := True;
          end;
      end;
    if AddToBuf then
      begin
        New(Packet);
        UDPPacketInitialise(Packet^);
        Packet^.BufSize := BufSize;
        if BufSize > 0 then
          begin
            GetMem(Packet^.BufPtr, BufSize);
            Move(Buf, Packet^.BufPtr^, BufSize);
          end;
        Packet^.Addr := ToAddr;
        Packet^.TimeStamp := Now;
        UDPBufferAdd(FWriteBuffer, Packet);
      end;
  finally
    Unlock;
  end;
end;



{                                                                              }
{ Tests                                                                        }
{                                                                              }

{$IFDEF UDP_TEST}
procedure Test_Simple;
var
  UDP1 : TF5UDP;
  UDP2 : TF5UDP;
  ToAddr : TSocketAddr;
  FromAddr : TSocketAddr;
  Buf  : Int64;
  Trunced : Boolean;
begin
  UDP1 := TF5UDP.Create(nil);
  UDP1.AddressFamily := iaIP4;
  UDP1.BindAddress := '127.0.0.1';
  UDP1.ServerPort := 3344;

  UDP1.Start;
  Assert(UDP1.State = usReady);

  UDP2 := TF5UDP.Create(nil);
  UDP2.AddressFamily := iaIP4;
  UDP2.BindAddress := '127.0.0.1';
  UDP2.ServerPort := 3345;

  UDP2.Start;
  Assert(UDP2.State = usReady);

  ToAddr := ResolveHost('127.0.0.1', iaIP4);
  SetSocketAddrPort(ToAddr, 3344);
  Buf := $123456789;
  UDP2.Write(ToAddr, Buf, SizeOf(Buf));

  Sleep(100);

  Buf := 0;
  InitSocketAddrNone(FromAddr);
  Assert(UDP1.Read(Buf, SizeOf(Buf), FromAddr, Trunced) = SizeOf(Buf));
  Assert(FromAddr.AddrIP4.Addr32 = ToAddr.AddrIP4.Addr32);
  Assert(not Trunced);
  Assert(Buf = $123456789);

  Assert(UDP1.Read(Buf, SizeOf(Buf), FromAddr, Trunced) < 0);
  Assert(UDP2.Read(Buf, SizeOf(Buf), FromAddr, Trunced) < 0);

  UDP2.Stop;

  UDP1.Stop;

  FreeAndNil(UDP2);
  FreeAndNil(UDP1);
end;

procedure Test;
begin
  Test_Simple;
end;
{$ENDIF}



end.

