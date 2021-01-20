{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcTCPServerUtils.pas                                    }
{   File version:     5.03                                                     }
{   Description:      TCP server utilities.                                    }
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
{   2020/07/13  5.01  Initial development: Accept process, Poll process.       }
{   2020/07/14  5.02  Spin process.                                            }
{   2020/07/15  5.03  Test poll and spin processes.                            }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}
{$INCLUDE flcTCP.inc}

unit flcTCPServerUtils;

interface

uses
  SysUtils,
  Classes,
  SyncObjs,

  flcStdTypes,

  flcSocketLibSys,
  flcSocketLib,
  flcSocket,

  flcTCPUtils,
  flcTCPConnection;



{ TCP Server Error }

type
  ETCPServerError = class(Exception);



{ TCP Server Thread }

type
  TTCPServerThreadBase = class(TTCPThread)
  public
  end;



{ TCP Server Accept Process }

type
  TTCPServerAcceptProcessSocketEvent = procedure (
      const ASocketHandle: TSocket;
      const AAddr: TSocketAddr;
      var AAcceptSocket: Boolean) of object;

  TTCPServerAcceptProcessEvent = procedure of object;

  TTCPServerAcceptProcess = class
  private
    FLock         : TCriticalSection;
    FReadyEvent   : TSimpleEvent;
    FAcceptPaused : Boolean;

    procedure Lock;
    procedure Unlock;

    function  GetAcceptPaused: Boolean;
    procedure SetAcceptPaused(const AAcceptPaused: Boolean);

  public
    constructor Create;
    destructor Destroy; override;
    procedure Finalise;

    property  AcceptPaused: Boolean read FAcceptPaused write SetAcceptPaused;

    procedure Execute(
              const AThread: TTCPServerThreadBase;
              const AServerSocketHandle: TSocket;
              const AAcceptSocketProc: TTCPServerAcceptProcessSocketEvent;
              const AWaitTime: Int32 = 2000);
  end;



{ TCP Server Client Base }

type
  TTCPServerClientBase = class
  private
    FListPrev : TTCPServerClientBase;
    FListNext : TTCPServerClientBase;

    FSocketHandle : TSocketHandle;

    //FConnection : TTCPConnection;

  public
    constructor Create(const ASocketHandle: TSocketHandle);

    procedure Finalise; virtual;

    property  ListPrev: TTCPServerClientBase read FListPrev write FListPrev;
    property  ListNext: TTCPServerClientBase read FListNext write FListNext;

    //property  Connection: TTCPConnection read FConnection;
  end;

  TTCPServerClientBaseArray = array of TTCPServerClientBase;



{ TCP Server Client List }

type
  TTCPServerClientList = class
  private
    FCount : Int32;
    FFirst : TTCPServerClientBase;
    FLast  : TTCPServerClientBase;

  public
    destructor Destroy; override;
    procedure Finalise;

    procedure Add(const AClient: TTCPServerClientBase);
    procedure Remove(const AClient: TTCPServerClientBase);
    property  First: TTCPServerClientBase read FFirst write FFirst;
    property  Last: TTCPServerClientBase read FLast write FLast;
    property  Count: Int32 read FCount;
  end;



{ TCP Server Poll List                                                       }
{ Poll list maintains poll buffer used in call to Poll.                      }

type
  TTCPServerPollList = class
  private
    FListLen    : Int32;
    FListUsed   : Int32;
    FListCount  : Int32;
    FFDList     : packed array of TPollfd;
    FClientList : array of TTCPServerClientBase;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Finalise;

    function  Add(const AClient: TTCPServerClientBase; const ASocketHandle: TSocket): Int32;
    procedure Remove(const AIdx: Int32);
    property  ClientCount: Integer read FListCount;
    function  GetClientByIndex(const AIdx: Int32): TTCPServerClientBase;        {$IFDEF UseInline}inline;{$ENDIF}
    procedure GetPollBuffer(out APollBufPtr: Pointer; out AItemCount: Int32);   {$IFDEF UseInline}inline;{$ENDIF}
  end;



{ TCP Server Poll Process }

type
  TTCPServerPollProcessClientPollEvent = procedure (
      const AClient: TTCPServerClientBase;
      var AEventRead, AEventWrite: Boolean) of object;

  TTCPServerPollProcessClientProcessEvent = procedure (
      const AClient: TTCPServerClientBase;
      const AEventRead, AEventWrite, AEventError: Boolean;
      out AClientTerminated: Boolean) of object;

  TTCPServerPollProcessEvent = procedure of object;

  TTCPServerPollProcess = class
  private
    FPollList   : TTCPServerPollList;
    FReadyEvent : TSimpleEvent;

    procedure RemoveClient(const AIdx: Int32);

  public
    constructor Create;
    destructor Destroy; override;
    procedure Finalise;
    procedure Terminate;

    procedure Execute(
              const AThread: TTCPServerThreadBase;
              const APollProcessStartProc: TTCPServerPollProcessEvent;
              const AClientPollEventProc: TTCPServerPollProcessClientPollEvent;
              const AClientProcessEventProc: TTCPServerPollProcessClientProcessEvent;
              const APollProcessCompleteProc: TTCPServerPollProcessEvent;
              const AWaitTimeMs: Int32);

    function  GetClientCount: Int32;
    function  AddClient(const AClient: TTCPServerClientBase): Int32;
  end;



{ TCP Server Spin Process }

type
  TTCPServerSpinProcessClientPollEvent = procedure (
      const AClient: TTCPServerClientBase;
      var AEventRead, AEventWrite: Boolean) of object;

  TTCPServerSpinProcessClientProcessEvent = procedure (
      const AClient: TTCPServerClientBase;
      const AEventRead, AEventWrite, AEventError: Boolean;
      out AClientTerminated: Boolean) of object;

  TTCPServerSpinProcess = class
  private
    FLock          : TCriticalSection;
    FReadyEvent    : TSimpleEvent;
    FClientCount   : Int32;
    FClientList    : TTCPServerClientBaseArray;
    FProcessBusy   : Boolean;
    FRemoveAllWait : Boolean;

    procedure Lock;
    procedure Unlock;

    procedure RemoveClient(const AIdx: Int32);

  public
    constructor Create;
    destructor Destroy; override;
    procedure Terminate;

    procedure Execute(
              const AThread: TTCPServerThreadBase;
              const AClientPollEventProc: TTCPServerSpinProcessClientPollEvent;
              const AClientProcessEventProc: TTCPServerSpinProcessClientProcessEvent);

    function  GetClientCount: Int32;
    function  AddClient(const AClient: TTCPServerClientBase): Int32;
    function  RemoveClients: TTCPServerClientBaseArray;
  end;



implementation




{ TTCPServerAcceptProcess }

constructor TTCPServerAcceptProcess.Create;
begin
  inherited Create;
  FLock := TCriticalSection.Create;
  FReadyEvent := TSimpleEvent.Create;
  FAcceptPaused := False;
  FReadyEvent.SetEvent;
end;

destructor TTCPServerAcceptProcess.Destroy;
begin
  if Assigned(FReadyEvent) then
    FReadyEvent.SetEvent;
  FreeAndNil(FReadyEvent);
  FreeAndNil(FLock);
  inherited Destroy;
end;

procedure TTCPServerAcceptProcess.Lock;
begin
  FLock.Acquire;
end;

procedure TTCPServerAcceptProcess.Unlock;
begin
  FLock.Release;
end;

procedure TTCPServerAcceptProcess.Finalise;
begin
  Lock;
  try
    FAcceptPaused := False;
    FReadyEvent.SetEvent;
  finally
    Unlock;
  end;
end;

function TTCPServerAcceptProcess.GetAcceptPaused: Boolean;
begin
  Lock;
  try
    Result := FAcceptPaused;
  finally
    Unlock;
  end;
end;

procedure TTCPServerAcceptProcess.SetAcceptPaused(const AAcceptPaused: Boolean);
begin
  Lock;
  try
    if FAcceptPaused = AAcceptPaused then
      exit;
    FAcceptPaused := AAcceptPaused;
    if AAcceptPaused then
      FReadyEvent.ResetEvent
    else
      FReadyEvent.SetEvent;
  finally
    Unlock;
  end;
end;

procedure TTCPServerAcceptProcess.Execute(
          const AThread: TTCPServerThreadBase;
          const AServerSocketHandle: TSocket;
          const AAcceptSocketProc: TTCPServerAcceptProcessSocketEvent;
          const AWaitTime: Int32);

  function IsTerminated: Boolean;
  begin
    Result := AThread.Terminated;
  end;

var
  LEvent  : TSimpleEvent;
  LReady  : Boolean;
  LSelRd  : Boolean;
  LSelWr  : Boolean;
  LSelEr  : Boolean;
  LRetSel : NativeInt;
  LAccAdr : TSocketAddr;
  LAccSoc : TSocketHandle;
  LAccept : Boolean;
begin
  if IsTerminated then
    exit;
  LEvent := FReadyEvent;
  repeat
    if IsTerminated then
      exit;
    LReady := False;
    case LEvent.WaitFor(AWaitTime) of
      wrSignaled  : LReady := True;
      wrTimeout   : ;
      wrAbandoned : exit;
      wrError     :
        if IsTerminated then
          exit
        else
          if not AThread.SleepUnterminated(2000) then
            exit;
    end;
    if IsTerminated then
      exit;
    if LReady then
      begin
        LSelRd := True;
        LSelWr := False;
        LSelEr := True;
        LRetSel := SocketSelect(AServerSocketHandle, LSelRd, LSelWr, LSelEr, AWaitTime);
        if IsTerminated then
          exit;
        if LRetSel < 0 then
          begin
            if not AThread.SleepUnterminated(2000) then
              exit;
          end
        else
        if (LRetSel = 1) and LSelRd then
          repeat
            LAccSoc := SocketAccept(AServerSocketHandle, LAccAdr);
            if LAccSoc = INVALID_SOCKETHANDLE then
              break;
            if IsTerminated then
              begin
                SocketClose(LAccSoc);
                exit;
              end;
            LAccept := True;
            AAcceptSocketProc(LAccSoc, LAccAdr, LAccept);
            if not LAccept then
              SocketClose(LAccSoc);
            if IsTerminated then
              exit;
            if GetAcceptPaused then
              break;
            if IsTerminated then
              exit;
          until False;
      end;
  until false;
end;




{ TTCPServerClientBase }

constructor TTCPServerClientBase.Create(const ASocketHandle: TSocketHandle);
begin
  inherited Create;
  FSocketHandle := ASocketHandle;
end;

procedure TTCPServerClientBase.Finalise;
begin
  FListNext := nil;
  FListPrev := nil;
end;



{                                                                              }
{ TCP Server Client List                                                       }
{                                                                              }
{ This implementation uses a linked list to avoid any heap operations.         }
{                                                                              }
destructor TTCPServerClientList.Destroy;
begin
  inherited Destroy;
end;

procedure TTCPServerClientList.Finalise;
begin
end;

procedure TTCPServerClientList.Add(const AClient: TTCPServerClientBase);
var
  Last : TTCPServerClientBase;
begin
  Assert(Assigned(AClient));
  Last := FLast;
  AClient.FListNext := nil;
  AClient.FListPrev := Last;
  if Assigned(Last) then
    Last.FListNext := AClient
  else
    FFirst := AClient;
  FLast := AClient;
  Inc(FCount);
end;

procedure TTCPServerClientList.Remove(const AClient: TTCPServerClientBase);
var
  LPrev, LNext : TTCPServerClientBase;
begin
  Assert(Assigned(AClient));
  Assert(FCount > 0);
  LPrev := AClient.FListPrev;
  LNext := AClient.FListNext;
  if Assigned(LPrev) then
    begin
      LPrev.FListNext := LNext;
      AClient.FListPrev := nil;
    end
  else
    begin
      Assert(FFirst = AClient);
      FFirst := LNext;
    end;
  if Assigned(LNext) then
    begin
      LNext.FListPrev := LPrev;
      AClient.FListNext := nil;
    end
  else
    begin
      Assert(FLast = AClient);
      FLast := LPrev;
    end;
  Dec(FCount);
end;



{                                                                              }
{ TCP Server Poll List                                                         }
{                                                                              }
{ This implementation aims to:                                                 }
{   - Keep a populated buffer ready for use in calls to Poll (one entry for    }
{     every active client).                                                    }
{   - Avoid heap operations for calls to frequently used operations Add        }
{     and Remove.                                                              }
{                                                                              }
constructor TTCPServerPollList.Create;
begin
  inherited Create;
end;

destructor TTCPServerPollList.Destroy;
begin
  inherited Destroy;
end;

procedure TTCPServerPollList.Finalise;
begin
  FFDList := nil;
  FClientList := nil;
end;

function TTCPServerPollList.Add(const AClient: TTCPServerClientBase; const ASocketHandle: TSocket): Int32;
var
  Idx, I, N, L : Int32;
begin
  if FListCount < FListUsed then
    begin
      Idx := -1;
      for I := 0 to FListUsed - 1 do
        if not Assigned(FClientList[I]) then
          begin
            Idx := I;
            break;
          end;
      if Idx < 0 then
        raise ETCPServerError.Create('Internal error');
    end
  else
  if FListUsed < FListLen then
    begin
      Idx := FListUsed;
      Inc(FListUsed);
    end
  else
    begin
      N := FListLen;
      L := N;
      if L < 16 then
        L := 16
      else
        L := L * 2;
      SetLength(FFDList, L);
      SetLength(FClientList, L);
      for I := N to L - 1 do
        begin
          FFDList[I].fd := INVALID_SOCKET;
          FFDList[I].events := 0;
          FFDList[I].revents := 0;
          FClientList[I] := nil;
        end;
      FListLen := L;
      Idx := FListUsed;
      Inc(FListUsed);
    end;
  FClientList[Idx] := AClient;
  FFDList[Idx].fd := ASocketHandle;
  FFDList[Idx].events := POLLIN or POLLOUT;
  FFDList[Idx].revents := 0;
  Inc(FListCount);
  Result := Idx;
end;

procedure TTCPServerPollList.Remove(const AIdx: Int32);
begin
  if (AIdx < 0) or (AIdx >= FListUsed) or not Assigned(FClientList[AIdx]) then
    raise ETCPServerError.Create('Invalid index');
  FClientList[AIdx] := nil;
  FFDList[AIdx].fd := INVALID_SOCKET;
  FFDList[AIdx].events := 0;
  FFDList[AIdx].revents := 0;
  Dec(FListCount);
  if AIdx = FListUsed - 1 then
    while (FListUsed > 0) and not Assigned(FClientList[FListUsed - 1]) do
      Dec(FListUsed);
end;

function TTCPServerPollList.GetClientByIndex(const AIdx: Int32): TTCPServerClientBase;
begin
  Assert(AIdx >= 0);
  Assert(AIdx < FListUsed);
  Result := FClientList[AIdx];
end;

procedure TTCPServerPollList.GetPollBuffer(out APollBufPtr: Pointer; out AItemCount: Int32);
begin
  APollBufPtr := Pointer(FFDList);
  AItemCount := FListUsed;
end;




{ TTCPServerPollProcess }

constructor TTCPServerPollProcess.Create;
begin
  inherited Create;
  FPollList := TTCPServerPollList.Create;
  FReadyEvent := TSimpleEvent.Create;
  FReadyEvent.ResetEvent;
end;

destructor TTCPServerPollProcess.Destroy;
begin
  if Assigned(FReadyEvent) then
    FReadyEvent.SetEvent;
  FreeAndNil(FReadyEvent);
  FreeAndNil(FPollList);
  inherited Destroy;
end;

procedure TTCPServerPollProcess.Finalise;
begin
  FPollList.Finalise;
end;

procedure TTCPServerPollProcess.Terminate;
begin
  FReadyEvent.SetEvent;
end;

procedure TTCPServerPollProcess.Execute(
          const AThread: TTCPServerThreadBase;
          const APollProcessStartProc: TTCPServerPollProcessEvent;
          const AClientPollEventProc: TTCPServerPollProcessClientPollEvent;
          const AClientProcessEventProc: TTCPServerPollProcessClientProcessEvent;
          const APollProcessCompleteProc: TTCPServerPollProcessEvent;
          const AWaitTimeMs: Int32);

  function IsTerminated: Boolean;
  begin
    Result := AThread.Terminated;
  end;

var
  LReady : Boolean;
  LEvent : TSimpleEvent;
  LPolBuf : Pointer;
  LPolCnt : Int32;
  LPolItmP : PPollfd;
  LPolIdx : Int32;
  LPolRet : Int32;
  {$IFDEF OS_WIN32}
  LPolRep : Int32;
  {$ENDIF}
  LCl : TTCPServerClientBase;
  LClRd : Boolean;
  LClWr : Boolean;
  LClEr : Boolean;
  LClTerm : Boolean;
  LEvCo : Int16;
begin
  if IsTerminated then
    exit;
  LEvent := FReadyEvent;
  repeat
    LReady := False;
    case LEvent.WaitFor(AWaitTimeMs) of
      wrSignaled  : LReady := True;
      wrTimeout   : ;
      wrAbandoned : raise ETCPServerError.Create('Process abandoned');
      wrError     :
        if IsTerminated then
          exit
        else
          if not AThread.SleepUnterminated(2000) then
            exit;
    end;
    if IsTerminated then
      exit;
    if LReady then
      begin
        APollProcessStartProc;
        if IsTerminated then
          exit;
        FPollList.GetPollBuffer(LPolBuf, LPolCnt);
        LPolItmP := LPolBuf;
        for LPolIdx := 0 to LPolCnt - 1 do
          begin
            LCl := FPollList.FClientList[LPolIdx];
            if not Assigned(LCl) then
              begin
                LPolItmP^.fd := INVALID_SOCKET;
                LPolItmP^.events := 0;
                LPolItmP^.revents := 0;
              end
            else
              begin
                LClRd := False;
                LClWr := False;
                AClientPollEventProc(LCl, LClRd, LClWr);
                LEvCo := 0;
                if LClRd then
                  LEvCo := LEvCo or POLLIN;
                if LClWr then
                  LEvCo := LEvCo or POLLOUT;
                LPolItmP^.events := LEvCo;
                LPolItmP^.revents := 0;
                if LPolItmP^.fd = INVALID_SOCKET then
                  LPolItmP^.fd := LCl.FSocketHandle;
              end;
            Inc(LPolItmP);
          end;
        if IsTerminated then
          exit;
        {$IFDEF OS_WIN32}
        // under Win32, WinSock blocks Socket.Write() if Socket.Poll() is active
        // use loop to reduce write latency
        LPolRet := 0;
        for LPolRep := 1 to AWaitTimeMs div 25 do
          begin
            LPolRet := SocketsPoll(LPolBuf, LPolCnt, 25); // 25 milliseconds
            if IsTerminated then
              exit;
            if LPolRet <> 0 then
              break;
          end;
        {$ELSE}
        LPolRet := SocketsPoll(LPolBuf, LPolCnt, AWaitTimeMs);
        {$ENDIF}
        if IsTerminated then
          exit;
        //// if LPolRet < 0 then
        //// Check error: log error/warn/alter/critial
        if LPolRet > 0 then
          begin
            LPolItmP := LPolBuf;
            for LPolIdx := 0 to LPolCnt - 1 do
              begin
                LEvCo := LPolItmP^.revents;
                if (LEvCo <> 0) and (LPolItmP^.fd <> INVALID_SOCKET) then
                  begin
                    LCl := FPollList.FClientList[LPolIdx];
                    if Assigned(LCl) then
                      begin
                        LClRd := LEvCo and (POLLIN or POLLHUP or POLLERR) <> 0;
                        LClWr := LEvCo and (POLLOUT or POLLHUP or POLLERR) <> 0;
                        LClEr := LEvCo and (POLLHUP or POLLERR) <> 0;
                        AClientProcessEventProc(LCl, LClRd, LClWr, LClEr, LClTerm);
                        if LClTerm then
                          RemoveClient(LPolIdx);
                        if IsTerminated then
                          exit;
                      end;
                  end;
                Inc(LPolItmP);
              end;
          end;
        APollProcessCompleteProc;
        if IsTerminated then
          exit;
      end;
  until False;
end;

function TTCPServerPollProcess.GetClientCount: Int32;
begin
  Result := FPollList.FListCount;
end;

function TTCPServerPollProcess.AddClient(const AClient: TTCPServerClientBase): Int32;
begin
  Assert(Assigned(AClient));
  Result := FPollList.Add(AClient, AClient.FSocketHandle);
  if FPollList.FListCount = 1 then
    FReadyEvent.SetEvent;
end;

procedure TTCPServerPollProcess.RemoveClient(const AIdx: Int32);
begin
  FPollList.Remove(AIdx);
  if FPollList.FListCount = 0 then
    FReadyEvent.ResetEvent;
end;



{ TTCPServerSpinProcess }

constructor TTCPServerSpinProcess.Create;
begin
  inherited Create;
  FLock := TCriticalSection.Create;
  FReadyEvent := TSimpleEvent.Create;
  FReadyEvent.ResetEvent;
  FClientCount := 0;
end;

destructor TTCPServerSpinProcess.Destroy;
begin
  if Assigned(FReadyEvent) then
    FReadyEvent.SetEvent;
  FreeAndNil(FReadyEvent);
  FreeAndNil(FLock);
  inherited Destroy;
end;

procedure TTCPServerSpinProcess.Terminate;
begin
  FReadyEvent.SetEvent;
end;

procedure TTCPServerSpinProcess.Lock;
begin
  FLock.Acquire;
end;

procedure TTCPServerSpinProcess.Unlock;
begin
  FLock.Release;
end;

procedure TTCPServerSpinProcess.Execute(
          const AThread: TTCPServerThreadBase;
          const AClientPollEventProc: TTCPServerSpinProcessClientPollEvent;
          const AClientProcessEventProc: TTCPServerSpinProcessClientProcessEvent);

  function IsTerminated: Boolean;
  begin
    Result := AThread.Terminated;
  end;

var
  LReady : Boolean;
  LEvent : TSimpleEvent;
  LSpinIdleCount : Int32;
  LSpinIdle : Boolean;
  LSpinIdx : Int32;
  LClient : TTCPServerClientBase;
  LSelRet : Int32;
  LSelRd : Boolean;
  LSelWr : Boolean;
  LSelEr : Boolean;
  LSelTerm : Boolean;
  LProcCl : Boolean;
  LRemWait : Boolean;
begin
  if IsTerminated then
    exit;
  LReady := False;
  LEvent := FReadyEvent;
  repeat
    // wait until client list not empty
    case LEvent.WaitFor(2000) of
      wrSignaled  : LReady := True;
      wrTimeout   : ;
      wrAbandoned : raise ETCPServerError.Create('Process abandoned');
      wrError     :
        if IsTerminated then
          exit
        else
          if not AThread.SleepUnterminated(2000) then
            exit;
    end;
    if IsTerminated then
      exit;
    if LReady then
      begin
        // process until client list empty
        LSpinIdleCount := 0;
        repeat
          Lock;
          try
            if IsTerminated then
              exit;
            if FClientCount = 0 then
              break;
            FProcessBusy := True;
          finally
            Unlock;
          end;
          try
            // process clients in client list if Select indidcates event
            LSpinIdle := True;
            LSpinIdx := 0;
            repeat
              Lock;
              try
                if IsTerminated then
                  exit;
                ////if FRemoveAllWait then
                ////break;
                if LSpinIdx >= Length(FClientList) then
                  break;
                LClient := FClientList[LSpinIdx];
              finally
                Unlock;
              end;
              LSelTerm := False;
              LProcCl := False;
              if Assigned(LClient) then // 2020/07/15: outside lock
                begin
                  LSelRd := True;
                  LSelWr := True;
                  LSelEr := True;
                  AClientPollEventProc(LClient, LSelRd, LSelWr);
                  if IsTerminated then
                    exit;
                  LSelRet := SocketSelect(LClient.FSocketHandle, LSelRd, LSelWr, LSelEr, 0);
                  if IsTerminated then
                    exit;
                  LProcCl := (LSelRet = 1) and (LSelRd or LSelWr);
                end;
              if LProcCl then // 2020/07/15: outside lock
                begin
                  LSpinIdle := False;
                  AClientProcessEventProc(LClient, LSelRd, LSelWr, LSelEr, LSelTerm);
                  if IsTerminated then
                    exit;
                  if LSelTerm then
                    RemoveClient(LSpinIdx);
                end;
              ////TThread.Yield; // yield for lock to be acquired by other thread
              if IsTerminated then
                exit;
              Inc(LSpinIdx);
            until False;
          finally
            Lock;
            FProcessBusy := False;
            LRemWait := FRemoveAllWait;
            Unlock;
          end;
          if LRemWait then
            begin
              // 2020/07/25:
              // yield for lock to be acquired by thread calling RemoveAll
              {$IFDEF DELPHIXE2_UP}
              TThread.Yield;
              {$ENDIF}
              Sleep(0);
              if IsTerminated then
                exit;
              break;
            end
          else
          // idle spin
          if LSpinIdle then
            begin
              Inc(LSpinIdleCount);
              if LSpinIdleCount >= 16 then
                begin
                  {$IFDEF DELPHIXE2_UP}
                  TThread.Yield;
                  {$ENDIF}
                  Sleep(0);
                end
              {$IFDEF DELPHIXE2_UP}
              else
              if LSpinIdleCount >= 8 then
                TThread.SpinWait(LSpinIdleCount)
              {$ENDIF};
              if IsTerminated then
                exit;
            end
          else
            LSpinIdleCount := 0;
          if IsTerminated then
            exit;
        until False;
      end;
  until False;
end;

function TTCPServerSpinProcess.GetClientCount: Int32;
begin
  Lock;
  try
    Result := FClientCount;
  finally
    Unlock;
  end;
end;

function TTCPServerSpinProcess.AddClient(const AClient: TTCPServerClientBase): Int32;
var
  I : Int32;
  L : Int32;
begin
  Lock;
  try
    L := Length(FClientList);
    I := FClientCount;
    if L <= I then
      begin
        SetLength(FClientList, I + 1);
        FClientList[I] := AClient;
        FClientCount := I + 1;
        Result := I;
      end
    else
      begin
        Result := -1;
        for I := 0 to L - 1 do
          if not Assigned(FClientList[I]) then
            begin
              FClientList[I] := AClient;
              Inc(FClientCount);
              Result := I;
              break;
            end;
        Assert(Result >= 0);
      end;
    if FClientCount = 1 then
      FReadyEvent.SetEvent;
  finally
    Unlock;
  end;
end;

function TTCPServerSpinProcess.RemoveClients: TTCPServerClientBaseArray;
begin
  repeat
    Lock;
    try
      if not FProcessBusy then
        begin
          FRemoveAllWait := False;
          if FClientCount = 0 then
            begin
              Result := nil;
              exit;
            end;
          Result := FClientList;
          FClientList := nil;
          FReadyEvent.ResetEvent;
          FClientCount := 0;
          exit;
        end;
      FRemoveAllWait := True;
    finally
      Unlock;
    end;
    {$IFDEF DELPHIXE2_UP}
    TThread.Yield;
    {$ENDIF}
  until False;
end;

procedure TTCPServerSpinProcess.RemoveClient(const AIdx: Int32);
begin
  Lock;
  try
    Assert(AIdx >= 0);
    Assert(AIdx < FClientCount);
    Assert(Assigned(FClientList[AIdx]));

    FClientList[AIdx] := nil;
    Dec(FClientCount);
    if FClientCount = 0 then
      FReadyEvent.ResetEvent;
  finally
    Unlock;
  end;
end;



end.

