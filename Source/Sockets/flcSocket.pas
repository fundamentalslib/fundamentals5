{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcSocket.pas                                            }
{   File version:     5.09                                                     }
{   Description:      System independent socket class.                         }
{                                                                              }
{   Copyright:        Copyright (c) 2001-2018, David J Butler                  }
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
{   2006/12/04  0.01  Initial version.                                         }
{   2007/08/13  0.02  Improvements.                                            }
{   2008/12/29  4.03  Revision for Fundamentals 4.                             }
{   2010/09/12  4.04  Revision.                                                }
{   2011/09/15  4.05  Debug logging.                                           }
{   2011/10/13  4.06  Change to Recv error handling.                           }
{   2014/04/23  4.07  Revision.                                                }
{   2016/01/09  5.08  Revised for Fundamentals 5.                              }
{   2018/07/11  5.09  Type changes for Win64.                                  }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi XE2 Win32                    4.07  2014/04/23                       }
{   Delphi XE7 Win32                    5.08  2016/01/09                       }
{   Delphi 10 Win32                     5.08  2016/01/09                       }
{   FreePascal 2.6.2 Linux i386         4.07  2014/04/23                       }
{   FreePascal 2.6.2 Win32 i386         4.07  2014/04/23                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF DEBUG}
{$IFDEF TEST}
  {$DEFINE SOCKET_TEST}
  {$DEFINE SOCKET_TEST_IP4}
  {.DEFINE SOCKET_TEST_IP4_INTERNET}
{$ENDIF}
{$ENDIF}

{$IFDEF DEBUG}
  {$DEFINE SOCKET_DEBUG}
{$ENDIF}

{$IFDEF MSWIN}
  {$DEFINE SOCKET_WIN}
  {$DEFINE SOCKET_SUPPORT_ASYNC}
{$ELSE}
  {$IFDEF FREEPASCAL}
    {$DEFINE SOCKET_POSIX_FPC}
  {$ELSE}
    {$DEFINE SOCKET_POSIX_DELPHI}
  {$ENDIF}
{$ENDIF}

unit flcSocket;

interface

uses
  { System }
  {$IFDEF MSWIN}
  Windows,
  {$ENDIF}
  SysUtils,
  SyncObjs,

  { Fundamentals }
  flcStdTypes,
  flcSocketLib;



{                                                                              }
{ TSysSocket                                                                   }
{   System socket class.                                                       }
{                                                                              }
type
  ESysSocket = class(Exception);

  TSysSocket = class; // forward

  TSysSocketLogType = (
    sltDebug);

  TSysSocketLogEvent     = procedure (Sender: TSysSocket; LogType: TSysSocketLogType; Msg: String) of object;
  TSysSocketConnectEvent = procedure (Sender: TSysSocket; ErrorCode: Word) of object;
  TSysSocketCloseEvent   = procedure (Sender: TSysSocket) of object;
  TSysSocketReadEvent    = procedure (Sender: TSysSocket) of object;
  TSysSocketWriteEvent   = procedure (Sender: TSysSocket) of object;
  TSysSocketAcceptEvent  = procedure (Sender: TSysSocket) of object;
  TSysSocketResolveEvent = procedure (Sender: TSysSocket; Host, Port: RawByteString;
                           var SockAddr: TSocketAddr; var Resolved: Boolean) of object;

  {$IFDEF SOCKET_SUPPORT_ASYNC}
  TSysSocketAsynchronousEvent = TSocketAsynchronousEvent;
  TSysSocketAsynchronousEventSet = TSocketAsynchronousEvents;
  {$ENDIF}

  TSysSocket = class
  protected
    // Creation parameters
    FAddressFamily : TIPAddressFamily;
    FProtocol      : TIPProtocol;
    FOverlapped    : Boolean;
    FSocketHandle  : TSocketHandle;

    // Runtime parameters
    {$IFDEF SOCKET_SUPPORT_ASYNC}
    FAsyncEvents   : TSysSocketAsynchronousEventSet;
    {$ENDIF}

    // Asynchronous notifications
    FOnConnect     : TSysSocketConnectEvent;
    FOnClose       : TSysSocketCloseEvent;
    FOnRead        : TSysSocketReadEvent;
    FOnWrite       : TSysSocketWriteEvent;
    FOnAccept      : TSysSocketAcceptEvent;

    // Events
    FOnLog         : TSysSocketLogEvent;
    FOnResolve     : TSysSocketResolveEvent;

    // Runtime state
    {$IFDEF SOCKET_WIN}
    FWindowHandle  : HWND;
    {$ENDIF}

    // Init
    procedure Init(
              const AddressFamily: TIPAddressFamily;
              const Protocol: TIPProtocol;
              const Overlapped: Boolean;
              const SocketHandle: TSocketHandle); virtual;

    // Log
    procedure Log(const LogType: TSysSocketLogType; const Msg: String); overload;
    procedure Log(const LogType: TSysSocketLogType; const Msg: String; const Args: array of const); overload;

    // Asynchronous notifications
    procedure TriggerConnect(const ErrorCode: Word);
    procedure TriggerClose;
    procedure TriggerRead;
    procedure TriggerWrite;
    procedure TriggerAccept;

    // Events
    procedure TriggerResolve(
              const Host, Port: RawByteString;
              var SockAddr: TSocketAddr;
              var Resolved: Boolean); virtual;

    {$IFDEF SOCKET_WIN}
    // WinSock asynchronous event notifications
    procedure HandleSocketMessage(const Events: TSocketAsynchronousEvents; const Param: Word);
    {$ENDIF}
    {$IFDEF UNIX}
    // procedure ProcessAsynchronousEventsUnix;
    {$ENDIF}

    // Socket options
    function  GetReceiveTimeout: Integer;
    procedure SetReceiveTimeout(const TimeoutUs: Integer);
    function  GetSendTimeout: Integer;
    procedure SetSendTimeout(const TimeoutUs: Integer);
    function  GetReceiveBufferSize: Integer;
    procedure SetReceiveBufferSize(const BufferSize: Integer);
    function  GetSendBufferSize: Integer;
    procedure SetSendBufferSize(const BufferSize: Integer);
    function  GetBroadcastEnabled: Boolean;
    procedure SetBroadcastEnabled(const BroadcastEnabled: Boolean);

    // Resolve
    procedure Resolve(const Host, Port: RawByteString; var SockAddr: TSocketAddr);
    procedure ResolveRequired(const Host, Port: RawByteString; var SockAddr: TSocketAddr);

  public
    constructor Create(
                const AddressFamily: TIPAddressFamily = iaIP4;
                const Protocol: TIPProtocol = ipTCP;
                const Overlapped: Boolean = False;
                const SocketHandle: TSocketHandle = INVALID_SOCKETHANDLE);
    destructor Destroy; override;

    property  AddressFamily: TIPAddressFamily read FAddressFamily;
    property  Protocol: TIPProtocol read FProtocol;
    property  Overlapped: Boolean read FOverlapped;
    property  SocketHandle: TSocketHandle read FSocketHandle;
    function  SocketHandleInvalid: Boolean;

    procedure AllocateSocketHandle;
    function  ReleaseSocketHandle: TSocketHandle;
    procedure CloseSocket;
    procedure Close;

    procedure SetBlocking(const Block: Boolean);
    {$IFDEF SOCKET_SUPPORT_ASYNC}
    procedure SetAsynchronous(const AsyncEvents: TSysSocketAsynchronousEventSet);
    {$ENDIF}

    property  OnConnect: TSysSocketConnectEvent read FOnConnect write FOnConnect;
    property  OnClose: TSysSocketCloseEvent read FOnClose write FOnClose;
    property  OnRead: TSysSocketReadEvent read FOnRead write FOnRead;
    property  OnWrite: TSysSocketWriteEvent read FOnWrite write FOnWrite;
    property  OnAccept: TSysSocketAcceptEvent read FOnAccept write FOnAccept;

    property  OnLog: TSysSocketLogEvent read FOnLog write FOnLog;
    property  OnResolve: TSysSocketResolveEvent read FOnResolve write FOnResolve;

    property  ReceiveTimeout: Integer read GetReceiveTimeout write SetReceiveTimeout;
    property  SendTimeout: Integer read GetSendTimeout write SetSendTimeout;
    property  ReceiveBufferSize: Integer read GetReceiveBufferSize write SetReceiveBufferSize;
    property  SendBufferSize: Integer read GetSendBufferSize write SetSendBufferSize;

    property  BroadcastEnabled: Boolean read GetBroadcastEnabled write SetBroadcastEnabled;
    procedure GetLingerOption(var LingerOption: Boolean; var LingerTimeSec: Integer);
    procedure SetLingerOption(const LingerOption: Boolean; const LingerTimeSec: Integer = 0);

    function  Select(const WaitMicroseconds: Integer;
              var ReadSelect, WriteSelect, ErrorSelect: Boolean): Boolean; overload;
    function  Select(var ReadSelect, WriteSelect, ErrorSelect: Boolean): Boolean; overload;

    procedure Bind(const Address: TSocketAddr); overload;
    procedure Bind(const Address: TIP4Addr; const Port: Word); overload;
    procedure Bind(const Address: TIP6Addr; const Port: Word); overload;
    procedure Bind(const Host, Port: RawByteString); overload;
    procedure Bind(const Host: RawByteString; const Port: Word); overload;

    function  GetLocalAddress: TSocketAddr;
    function  GetLocalAddressIP: TIP4Addr;
    function  GetLocalAddressIP6: TIP6Addr;
    function  GetLocalAddressStr: RawByteString;
    function  GetLocalPort: Integer;
    function  GetLocalPortStr: String;

    procedure Shutdown(const How: TSocketShutdown);

    function  Connect(const Address: TSocketAddr): Boolean; overload;
    function  Connect(const Address: TIP4Addr; const Port: Word): Boolean; overload;
    function  Connect(const Address: TIP6Addr; const Port: Word): Boolean; overload;
    function  Connect(const Host, Port: RawByteString): Boolean; overload;

    procedure Listen(const Backlog: Integer);

    function  Accept(var Address: TSocketAddr): TSocketHandle; overload;
    function  Accept(var Address: TIP4Addr): TSocketHandle; overload;
    function  Accept(var Address: TIP6Addr): TSocketHandle; overload;
    procedure Accept(var Socket: TSysSocket; var Address: TSocketAddr); overload;
    procedure Accept(var Socket: TSysSocket; var Address: TIP4Addr); overload;
    procedure Accept(var Socket: TSysSocket; var Address: TIP6Addr); overload;

    function  GetRemoteAddress: TSocketAddr;
    function  GetRemoteAddressIP: TIP4Addr;
    function  GetRemoteAddressIP6: TIP6Addr;
    function  GetRemoteAddressStr: RawByteString;
    function  GetRemoteHostName: RawByteString;

    function  Send(const Buf; const BufSize: Integer): Integer; overload;
    function  Send(const Buf: RawByteString): Integer; overload;

    function  SendTo(const Address: TSocketAddr; const Buf; const BufSize: Integer): Integer; overload;
    function  SendTo(const Host, Port: RawByteString; const Buf; const BufSize: Integer): Integer; overload;
    procedure SendToBroadcast(const Port: Word; const Data; const DataSize: Integer);

    function  Recv(var Buf; const BufSize: Integer): Integer;
    function  Peek(var Buf; const BufSize: Integer): Integer;

    function  RecvFromEx(var Buf; const BufSize: Integer; var From: TSocketAddr; var Truncated: Boolean): Integer;
    function  RecvFrom(var Buf; const BufSize: Integer; var From: TSocketAddr): Integer; overload;
    function  RecvFrom(var Buf; const BufSize: Integer; var FromAddr: TIP4Addr; var FromPort: Word): Integer; overload;
    function  RecvFrom(var Buf; const BufSize: Integer; var FromAddr: TIP6Addr; var FromPort: Word): Integer; overload;

    function  AvailableToRecv: Integer;
  end;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF SOCKET_TEST}
procedure Test;
{$ENDIF}



implementation

{$IFDEF SOCKET_WIN}
uses
  { System }
  Messages;
{$ENDIF}
{$IFDEF SOCKET_POSIX_DELPHI}
uses
  flcSocketLibSys;
{$ENDIF}



{$IFDEF SOCKET_WIN}
{                                                                              }
{ WinSock asynchronous event notifications                                     }
{                                                                              }

{ WinSock notification messages                                                }
const
  WM_SOCKET = WM_USER + 580;



{ Socket message handling procedure                                            }
function SocketHandleMessageProc(
         const WindowHandle: HWND; const Msg: UINT;
         const wParam: WPARAM; const lParam: LPARAM): LRESULT; stdcall;
var Events : Word;
    Param  : Word;
    Socket : TSysSocket;
    EventsAsync : TSocketAsynchronousEvents;
begin
  if Msg = WM_SOCKET then
    begin
      // dispatch socket messages to socket object
      Socket := TSysSocket(GetWindowLongPtr(WindowHandle, 0));
      Assert(TObject(Socket) is TSysSocket);
      if Assigned(Socket) then
        if Socket.FSocketHandle = TSocketHandle(wParam) then
          begin
            Events := LoWord(lParam);
            EventsAsync := EventsToSocketAsynchronousEvents(Events);
            Param := HiWord(lParam);
            Socket.HandleSocketMessage(EventsAsync, Param);
          end;
      // signal success
      Result := 0;
    end
  else
    // use default message handler
    Result := DefWindowProc(WindowHandle, Msg, wParam, lParam);
end;



{ SocketWindowClass                                                            }
var
  SocketWindowClass : TWndClass = (
      style         : 0;
      lpfnWndProc   : @SocketHandleMessageProc;
      cbClsExtra    : 0;
      cbWndExtra    : SizeOf(Pointer); // size of extra user data
      hInstance     : 0;
      hIcon         : 0;
      hCursor       : 0;
      hbrBackground : 0;
      lpszMenuName  : nil;
      lpszClassName : 'Fundamentals4SocketWindowClass');
  SocketWindowClassRegistered : Boolean = False;
  SocketWindowClassLock       : TRTLCriticalSection;
  SocketWindowClassLockInit   : Boolean = False;

procedure InitializeSocketWindowClassLock;
begin
  InitializeCriticalSection(SocketWindowClassLock);
  SocketWindowClassLockInit := True;
end;

procedure FinalizeSocketWindowClassLock;
begin
  if SocketWindowClassLockInit then
    DeleteCriticalSection(SocketWindowClassLock);
end;

resourcestring
  SWindowClassRegistrationFailed = 'Window class registration failed';

procedure RegisterSocketWindowClass;
begin
  EnterCriticalSection(SocketWindowClassLock);
  try
    if SocketWindowClassRegistered then
      exit;
    SocketWindowClass.hInstance := HInstance;
    if Windows.RegisterClass(SocketWindowClass) = 0 then
      raise ESysSocket.CreateFmt(SWindowClassRegistrationFailed, []);
    SocketWindowClassRegistered := True;
  finally
    LeaveCriticalSection(SocketWindowClassLock);
  end;
end;



{ SocketWindowHandle                                                           }
resourcestring
  SWindowHandleAllocationFailed  = 'Window handle allocation failed';

function AllocateSocketWindowHandle(const Instance: TSysSocket): HWND;
begin
  Assert(Assigned(Instance));
  // register class
  if not SocketWindowClassRegistered then
    RegisterSocketWindowClass;
  // register window
  Result := CreateWindowEx(
      WS_EX_TOOLWINDOW, SocketWindowClass.lpszClassName, '',
      WS_POPUP, 0, 0, 0, 0, 0, 0, HInstance, nil);
  if Result = 0 then
    raise ESysSocket.CreateFmt(SWindowHandleAllocationFailed, []);
  // associate instance pointer with window handle
  SetWindowLongPtr(Result, 0, NativeInt(Instance));
end;
{$ENDIF}



{                                                                              }
{ TSysSocket                                                                   }
{                                                                              }
constructor TSysSocket.Create(
            const AddressFamily: TIPAddressFamily;
            const Protocol: TIPProtocol; const Overlapped: Boolean;
            const SocketHandle: TSocketHandle);
begin
  inherited Create;
  Init(AddressFamily, Protocol, Overlapped, SocketHandle);
end;

procedure TSysSocket.Init(
          const AddressFamily: TIPAddressFamily;
          const Protocol: TIPProtocol;
          const Overlapped: Boolean;
          const SocketHandle: TSocketHandle);
begin
  // initialise socket paramaters
  FAddressFamily := AddressFamily;
  FProtocol := Protocol;
  FOverlapped := Overlapped;
  // allocate a new socket handle if not specified
  if (SocketHandle = INVALID_SOCKETHANDLE) or (SocketHandle = 0) then
    AllocateSocketHandle
  else
    FSocketHandle := SocketHandle;
  Assert(FSocketHandle <> 0);
  Assert(FSocketHandle <> INVALID_SOCKETHANDLE);
  // initialise state
  {$IFDEF SOCKET_WIN}
  FWindowHandle := INVALID_HANDLE_VALUE;
  Assert(FWindowHandle <> 0);
  {$ENDIF}
  {$IFDEF SOCKET_WIN}
  FAsyncEvents := [];
  {$ENDIF}
end;

destructor TSysSocket.Destroy;
var S : TSocketHandle;
    {$IFDEF SOCKET_WIN}
    W : HWND;
    {$ENDIF}
begin
  // close socket handle
  // note that the socket handle can be 0 (on exception during creation) or
  // INVALID_SOCKET (handle not allocated)
  S := FSocketHandle;
  if (S <> 0) and (S <> INVALID_SOCKETHANDLE) then
    begin
      FSocketHandle := INVALID_SOCKETHANDLE;
      SocketClose(S); // don't check for CloseSocket errors during destruction
    end;
  {$IFDEF SOCKET_WIN}
  // destroy window handle
  // note that the window handle can be 0 (on exception during creation) or
  // INVALID_HANDLE_VALUE (handle not allocated)
  W := FWindowHandle;
  if (W <> 0) and (W <> INVALID_HANDLE_VALUE) then
    begin
      FWindowHandle := INVALID_HANDLE_VALUE;
      DestroyWindow(W); // don't check for DestroyWindow errors during destruction
    end;
  {$ENDIF}
  inherited Destroy;
end;

procedure TSysSocket.Log(const LogType: TSysSocketLogType; const Msg: String);
begin
  if Assigned(FOnLog) then
    FOnLog(self, LogType, Msg);
end;

procedure TSysSocket.Log(const LogType: TSysSocketLogType; const Msg: String; const Args: array of const);
begin
  Log(LogType, Format(Msg, Args));
end;

procedure TSysSocket.AllocateSocketHandle;
begin
  if (FSocketHandle = INVALID_SOCKETHANDLE) or (FSocketHandle = 0) then
    FSocketHandle := flcSocketLib.AllocateSocketHandle(AddressFamily, Protocol,
        Overlapped)
end;

function TSysSocket.SocketHandleInvalid: Boolean;
begin
  Result := FSocketHandle = INVALID_SOCKETHANDLE;
end;

function TSysSocket.ReleaseSocketHandle: TSocketHandle;
begin
  Result := FSocketHandle;
  FSocketHandle := INVALID_SOCKETHANDLE;
end;

procedure TSysSocket.CloseSocket;
var S : TSocketHandle;
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'CloseSocket');
  {$ENDIF}
  // close socket
  S := FSocketHandle;
  if S = INVALID_SOCKETHANDLE then
    exit;
  if SocketClose(S) < 0 then
    raise ESocketLib.Create('Close failed', SocketGetLastError);
  FSocketHandle := INVALID_SOCKETHANDLE;
end;

procedure TSysSocket.Close;
var S : TSocketHandle;
    {$IFDEF SOCKET_WIN}
    W : HWND;
    {$ENDIF}
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'Close:Handle:%d', [Ord(FSocketHandle)]);
  {$ENDIF}
  // close socket
  S := FSocketHandle;
  if S <> INVALID_SOCKETHANDLE then
    begin
      if SocketClose(S) < 0 then
        raise ESocketLib.Create('Close failed', SocketGetLastError);
      FSocketHandle := INVALID_SOCKETHANDLE;
    end;
  {$IFDEF SOCKET_WIN}
  // destroy window handle
  W := FWindowHandle;
  if W <> INVALID_HANDLE_VALUE then
   begin
     SetWindowLong(W, 0, 0);
     if not DestroyWindow(W) then
       raise ESysSocket.Create('Close failed: ' + SysErrorMessage(Windows.GetLastError));
     FWindowHandle := INVALID_HANDLE_VALUE;
   end;
  {$ENDIF}
end;

procedure TSysSocket.SetBlocking(const Block: Boolean);
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'SetBlocking:%d', [Ord(Block)]);
  {$ENDIF}
  flcSocketLib.SetSocketBlocking(FSocketHandle, Block);
end;

{$IFDEF SOCKET_SUPPORT_ASYNC}
procedure TSysSocket.SetAsynchronous(const AsyncEvents: TSysSocketAsynchronousEventSet);
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'SetAsynchronous');
  {$ENDIF}
  {$IFDEF SOCKET_WIN}
  if AsyncEvents = FAsyncEvents then
    exit;
  FAsyncEvents := AsyncEvents;
  if AsyncEvents <> [] then
    begin
      // allocate window handle if not already allocated
      if FWindowHandle = INVALID_HANDLE_VALUE then
        FWindowHandle := AllocateSocketWindowHandle(self);
      // register for WinSock event notification messages
      flcSocketLib.SetSocketAsynchronous(FSocketHandle,
          FWindowHandle, WM_SOCKET, AsyncEvents);
    end
  else
    // clear all WinSock event notification messages
    if FWindowHandle <> INVALID_HANDLE_VALUE then
      flcSocketLib.SetSocketAsynchronous(FSocketHandle, FWindowHandle, 0, []);
  {$ELSE}
  if AsyncEvents <> [] then
    raise ESysSocket.Create('Asynchronous mode not supported');
  {$ENDIF}
end;
{$ENDIF}

procedure TSysSocket.TriggerConnect(const ErrorCode: Word);
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'TriggerConnect');
  {$ENDIF}
  if Assigned(FOnConnect) then
    FOnConnect(self, ErrorCode);
end;

procedure TSysSocket.TriggerClose;
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'TriggerClose');
  {$ENDIF}
  if Assigned(FOnClose) then
    FOnClose(self);
end;

procedure TSysSocket.TriggerRead;
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'TriggerRead');
  {$ENDIF}
  if Assigned(FOnRead) then
    FOnRead(self);
end;

procedure TSysSocket.TriggerWrite;
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'TriggerWrite');
  {$ENDIF}
  if Assigned(FOnWrite) then
    FOnWrite(self);
end;

procedure TSysSocket.TriggerAccept;
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'TriggerAccept');
  {$ENDIF}
  if Assigned(FOnAccept) then
    FOnAccept(self);
end;

procedure TSysSocket.TriggerResolve(const Host, Port: RawByteString; var SockAddr: TSocketAddr;
          var Resolved: Boolean);
begin
  if Assigned(FOnResolve) then
    FOnResolve(self, Host, Port, SockAddr, Resolved);
end;

{$IFDEF SOCKET_WIN}
procedure TSysSocket.HandleSocketMessage(const Events: TSocketAsynchronousEvents; const Param: Word);
begin
  if saeRead in Events then
    TriggerRead;
  if saeWrite in Events then
    TriggerWrite;
  if saeClose in Events then
    TriggerClose;
  if saeConnect in Events then
    TriggerConnect(Param);
  if saeAccept in Events then
    TriggerAccept;
end;
{$ENDIF}

function TSysSocket.GetReceiveTimeout: Integer;
begin
  Result := flcSocketLib.GetSocketReceiveTimeout(FSocketHandle);
end;

procedure TSysSocket.SetReceiveTimeout(const TimeoutUs: Integer);
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'SetReceiveTimeOut:%d', [TimeoutUs]);
  {$ENDIF}
  flcSocketLib.SetSocketReceiveTimeout(FSocketHandle, TimeoutUs);
end;

function TSysSocket.GetSendTimeout: Integer;
begin
  Result := flcSocketLib.GetSocketSendTimeout(FSocketHandle);
end;

procedure TSysSocket.SetSendTimeout(const TimeoutUs: Integer);
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'SetSendTimeOut:%d', [TimeoutUs]);
  {$ENDIF}
  flcSocketLib.SetSocketSendTimeout(FSocketHandle, TimeoutUs);
end;

function TSysSocket.GetReceiveBufferSize: Integer;
begin
  Result := flcSocketLib.GetSocketReceiveBufferSize(FSocketHandle);
end;

procedure TSysSocket.SetReceiveBufferSize(const BufferSize: Integer);
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'SetReceiveBufferSize:%db', [BufferSize]);
  {$ENDIF}
  flcSocketLib.SetSocketReceiveBufferSize(FSocketHandle, BufferSize);
end;

function TSysSocket.GetSendBufferSize: Integer;
begin
  Result := flcSocketLib.GetSocketSendBufferSize(FSocketHandle);
end;

procedure TSysSocket.SetSendBufferSize(const BufferSize: Integer);
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'SetSendBufferSize:%db', [BufferSize]);
  {$ENDIF}
  flcSocketLib.SetSocketSendBufferSize(FSocketHandle, BufferSize);
end;

function TSysSocket.GetBroadcastEnabled: Boolean;
begin
  Result := flcSocketLib.GetSocketBroadcast(FSocketHandle);
end;

procedure TSysSocket.SetBroadcastEnabled(const BroadcastEnabled: Boolean);
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'SetBroadcastEnabled:%d', [Ord(BroadcastEnabled)]);
  {$ENDIF}
  flcSocketLib.SetSocketBroadcast(FSocketHandle, BroadcastEnabled);
end;

procedure TSysSocket.GetLingerOption(var LingerOption: Boolean; var LingerTimeSec: Integer);
begin
  {$IFDEF MSWIN}
  flcSocketLib.GetSocketLinger(FSocketHandle, LingerOption, LingerTimeSec);
  {$ENDIF}
end;

procedure TSysSocket.SetLingerOption(const LingerOption: Boolean; const LingerTimeSec: Integer);
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'SetLingerOption:%d:%ds', [Ord(LingerOption), LingerTimeSec]);
  {$ENDIF}
  {$IFDEF MSWIN}
  flcSocketLib.SetSocketLinger(FSocketHandle, LingerOption, LingerTimeSec);
  {$ENDIF}
end;

procedure TSysSocket.Resolve(const Host, Port: RawByteString; var SockAddr: TSocketAddr);
var R : Boolean;
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'Resolve:%s:%s', [Host, Port]);
  {$ENDIF}
  R := False;
  TriggerResolve(Host, Port, SockAddr, R);
  if not R then
    SockAddr := flcSocketLib.ResolveB(Host, Port, FAddressFamily, FProtocol);
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'Resolve:Addr:%s', [SocketAddrStr(SockAddr)]);
  {$ENDIF}
end;

procedure TSysSocket.ResolveRequired(const Host, Port: RawByteString; var SockAddr: TSocketAddr);
begin
  if Host = '' then
    raise ESysSocket.Create('Host not specified');
  if Port = '' then
    raise ESysSocket.Create('Port not specified');
  Resolve(Host, Port, SockAddr);
end;

function TSysSocket.Select(
         const WaitMicroseconds: Integer;
         var ReadSelect, WriteSelect, ErrorSelect: Boolean): Boolean;
var Error : Integer;
begin
  Error := SocketSelect(FSocketHandle, ReadSelect, WriteSelect, ErrorSelect, WaitMicroseconds);
  Result := Error > 0;
  if Error < 0 then
    raise ESocketLib.Create('Select failed', SocketGetLastError) else
  if Error = 0 then
    begin
      ReadSelect := False;
      WriteSelect := False;
      ErrorSelect := False;
    end;
  {$IFDEF SOCKET_DEBUG}
  if Result then
    Log(sltDebug, 'Select:%d:r%d:w%d:e%d',
        [Error, Ord(ReadSelect), Ord(WriteSelect), Ord(ErrorSelect)]);
  {$ENDIF}
end;

function TSysSocket.Select(var ReadSelect, WriteSelect, ErrorSelect: Boolean): Boolean;
begin
  Result := Select(-1, ReadSelect, WriteSelect, ErrorSelect);
end;

procedure TSysSocket.Bind(const Address: TSocketAddr);
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'Bind:%s', [SocketAddrStr(Address)]);
  {$ENDIF}
  if SocketBind(FSocketHandle, Address) < 0 then
    raise ESocketLib.Create('Socket bind failed', SocketGetLastError);
end;

procedure TSysSocket.Bind(const Address: TIP4Addr; const Port: Word);
var SockAddr : TSocketAddr;
begin
  InitSocketAddr(SockAddr, Address, Port);
  Bind(SockAddr);
end;

procedure TSysSocket.Bind(const Address: TIP6Addr; const Port: Word);
var SockAddr : TSocketAddr;
begin
  InitSocketAddr(SockAddr, Address, Port);
  Bind(SockAddr);
end;

procedure TSysSocket.Bind(const Host, Port: RawByteString);
var SockAddr : TSocketAddr;
begin
  Resolve(Host, Port, SockAddr);
  Bind(SockAddr);
end;

procedure TSysSocket.Bind(const Host: RawByteString; const Port: Word);
var SockAddr : TSocketAddr;
begin
  Resolve(Host, '0', SockAddr);
  SetSocketAddrPort(SockAddr, Port);
  Bind(SockAddr);
end;

function TSysSocket.GetLocalAddress: TSocketAddr;
begin
  InitSocketAddrNone(Result);
  if SocketGetSockName(FSocketHandle, Result) < 0 then
    raise ESocketLib.Create('Error retrieving local binding information', SocketGetLastError);
end;

function TSysSocket.GetLocalAddressIP: TIP4Addr;
var A : TSocketAddr;
begin
  A := GetLocalAddress;
  if A.AddrFamily = iaIP4 then
    Result := A.AddrIP4
  else
    Result := IP4AddrNone;
end;

function TSysSocket.GetLocalAddressIP6: TIP6Addr;
var A : TSocketAddr;
begin
  A := GetLocalAddress;
  if A.AddrFamily = iaIP6 then
    Result := A.AddrIP6
  else
    IP6AddrSetZero(Result);
end;

function TSysSocket.GetLocalAddressStr: RawByteString;
var A : TSocketAddr;
begin
  A := GetLocalAddress;
  case A.AddrFamily of
    iaIP4 :
      if IP4AddrIsNone(A.AddrIP4) then
        Result := ''
      else
        Result := IP4AddressStrB(A.AddrIP4);
    iaIP6 :
      if IP6AddrIsZero(A.AddrIP6) then
        Result := ''
      else
        Result := IP6AddressStrB(A.AddrIP6);
  else
    Result := '';
  end;
end;

function TSysSocket.GetLocalPort: Integer;
var A : TSocketAddr;
begin
  A := GetLocalAddress;
  case A.AddrFamily of
    iaIP4 : Result := A.Port;
    iaIP6 : Result := A.Port;
  else
    Result := 0;
  end;
end;

function TSysSocket.GetLocalPortStr: String;
begin
  Result := IntToStr(GetLocalPort);
end;

procedure TSysSocket.Shutdown(const How: TSocketShutdown);
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'Shutdown:%d', [Ord(How)]);
  {$ENDIF}
  Assert(FSocketHandle <> INVALID_SOCKETHANDLE);
  if SocketShutdown(FSocketHandle, How) < 0 then
    raise ESocketLib.Create('Shutdown failed', SocketGetLastError);
end;

function TSysSocket.Connect(const Address: TSocketAddr): Boolean;
var ErrorCode : Integer;
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'Connect:%s', [SocketAddrStr(Address)]);
  {$ENDIF}
  if SocketConnect(FSocketHandle, Address) < 0 then
    begin
      ErrorCode := flcSocketLib.SocketGetLastError;
      if ErrorCode <> EWOULDBLOCK then
        raise ESocketLib.Create('Connect failed', SocketGetLastError)
      else
        Result := False;
    end
  else
    Result := True;
end;

function TSysSocket.Connect(const Address: TIP4Addr; const Port: Word): Boolean;
var SockAddr : TSocketAddr;
begin
  InitSocketAddr(SockAddr, Address, Port);
  Result := Connect(SockAddr);
end;

function TSysSocket.Connect(const Address: TIP6Addr; const Port: Word): Boolean;
var SockAddr : TSocketAddr;
begin
  InitSocketAddr(SockAddr, Address, Port);
  Result := Connect(SockAddr);
end;

function TSysSocket.Connect(const Host, Port: RawByteString): Boolean;
var SockAddr : TSocketAddr;
begin
  ResolveRequired(Host, Port, SockAddr);
  Result := Connect(SockAddr);
end;

procedure TSysSocket.Listen(const Backlog: Integer);
begin
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'Listen:%d', [Backlog]);
  {$ENDIF}
  if SocketListen(FSocketHandle, Backlog) < 0 then
    raise ESocketLib.Create('Listen failed', SocketGetLastError);
end;

// Returns INVALID_SOCKETHANDLE if no connection is waiting
function TSysSocket.Accept(var Address: TSocketAddr): TSocketHandle;
var ErrorCode  : Integer;
begin
  Result := SocketAccept(FSocketHandle, Address);
  if Result = INVALID_SOCKETHANDLE then
    begin
      ErrorCode := flcSocketLib.SocketGetLastError;
      if ErrorCode <> EWOULDBLOCK then
        raise ESocketLib.Create('Accept failed', ErrorCode);
      Result := INVALID_SOCKETHANDLE;
      InitSocketAddrNone(Address);
    end;
end;

function TSysSocket.Accept(var Address: TIP4Addr): TSocketHandle;
var SockAddr : TSocketAddr;
begin
  Result := Accept(SockAddr);
  if Result = INVALID_SOCKETHANDLE then
    Address := IP4AddrNone
  else
    if SockAddr.AddrFamily = iaIP4 then
      Address := SockAddr.AddrIP4
    else
      Address := IP4AddrNone;
end;

function TSysSocket.Accept(var Address: TIP6Addr): TSocketHandle;
var SockAddr : TSocketAddr;
begin
  Result := Accept(SockAddr);
  if Result = INVALID_SOCKETHANDLE then
    IP6AddrSetZero(Address)
  else
    if SockAddr.AddrFamily = iaIP6 then
      Address := SockAddr.AddrIP6
    else
      IP6AddrSetZero(Address);
end;

procedure TSysSocket.Accept(var Socket: TSysSocket; var Address: TSocketAddr);
var SocketHandle : TSocketHandle;
begin
  SocketHandle := Accept(Address);
  if SocketHandle = INVALID_SOCKETHANDLE then
    Socket := nil
  else
    Socket := TSysSocket.Create(FAddressFamily, FProtocol, False, SocketHandle);
end;

procedure TSysSocket.Accept(var Socket: TSysSocket; var Address: TIP4Addr);
var SockAddr : TSocketAddr;
begin
  Accept(Socket, SockAddr);
  if not Assigned(Socket) then
    Address := IP4AddrNone
  else
    if SockAddr.AddrFamily = iaIP4 then
      Address := SockAddr.AddrIP4
    else
      Address := IP4AddrNone;
end;

procedure TSysSocket.Accept(var Socket: TSysSocket; var Address: TIP6Addr);
var SockAddr : TSocketAddr;
begin
  Accept(Socket, SockAddr);
  if not Assigned(Socket) then
    IP6AddrSetZero(Address)
  else
    if SockAddr.AddrFamily = iaIP6 then
      Address := SockAddr.AddrIP6
    else
      IP6AddrSetZero(Address)
end;

function TSysSocket.GetRemoteAddress: TSocketAddr;
begin
  if SocketGetPeerName(FSocketHandle, Result) < 0 then
    raise ESocketLib.Create('Failed to get peer name', SocketGetLastError);
end;

function TSysSocket.GetRemoteAddressIP: TIP4Addr;
var A : TSocketAddr;
begin
  A := GetRemoteAddress;
  if A.AddrFamily = iaIP4 then
    Result := A.AddrIP4
  else
    Result := IP4AddrNone;
end;

function TSysSocket.GetRemoteAddressIP6: TIP6Addr;
var A : TSocketAddr;
begin
  A := GetRemoteAddress;
  if A.AddrFamily = iaIP6 then
    Result := A.AddrIP6
  else
    IP6AddrSetZero(Result);
end;

function TSysSocket.GetRemoteAddressStr: RawByteString;
var A : TSocketAddr;
begin
  A := GetRemoteAddress;
  case A.AddrFamily of
    iaIP4 :
      if IP4AddrIsNone(A.AddrIP4) then
        Result := ''
      else
        Result := IP4AddressStrB(A.AddrIP4);
    iaIP6 :
      if IP6AddrIsZero(A.AddrIP6) then
        Result := ''
      else
        Result := IP6AddressStrB(A.AddrIP6);
  else
    Result := '';
  end;
end;

function TSysSocket.GetRemoteHostName: RawByteString;
var Address : TIP4Addr;
begin
  Address := GetRemoteAddressIP;
  if IP4AddrIsNone(Address) or IP4AddrIsZero(Address) then
    Result := ''
  else
    begin
      Result := flcSocketLib.GetRemoteHostNameB(Address);
      if Result = '' then
        Result := IP4AddressStrB(Address);
      {$IFDEF SOCKET_DEBUG}
      Log(sltDebug, 'RemoteHostName:%s', [Result]);
      {$ENDIF}
    end;
end;

function TSysSocket.Send(const Buf; const BufSize: Integer): Integer;
var ErrorCode : Integer;
begin
  Result := SocketSend(FSocketHandle, Buf, BufSize, 0);
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'Send:%db:%db', [BufSize, Result]);
  {$ENDIF}
  if Result < 0 then
    begin
      ErrorCode := flcSocketLib.SocketGetLastError;
      if ErrorCode <> EWOULDBLOCK then
        raise ESocketLib.Create('Socket send error', ErrorCode)
      else
        Result := 0;
    end;
end;

function TSysSocket.Send(const Buf: RawByteString): Integer;
var L : Integer;
begin
  L := Length(Buf);
  if L = 0 then
    Result := 0
  else
    Result := Send(Pointer(Buf)^, L);
end;

function TSysSocket.SendTo(const Address: TSocketAddr; const Buf; const BufSize: Integer): Integer;
var ErrorCode : Integer;
begin
  Result := SocketSendTo(FSocketHandle, Buf, BufSize, 0, Address);
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'SendTo:%s:%db:%db', [SocketAddrStr(Address), BufSize, Result]);
  {$ENDIF}
  if Result < 0 then
    begin
      ErrorCode := flcSocketLib.SocketGetLastError;
      if ErrorCode <> EWOULDBLOCK then
        raise ESocketLib.Create('Socket send error', ErrorCode);
    end;
end;

function TSysSocket.SendTo(const Host, Port: RawByteString; const Buf; const BufSize: Integer): Integer;
var SockAddr : TSocketAddr;
begin
  ResolveRequired(Host, Port, SockAddr);
  Result := SendTo(SockAddr, Buf, BufSize);
end;

procedure TSysSocket.SendToBroadcast(const Port: Word; const Data; const DataSize: Integer);
var Addr : TSocketAddr;
    In4  : TIP4Addr;
    In6  : TIP6Addr;
begin
  case FAddressFamily of
    iaIP4 : begin
              In4 := IP4AddrBroadcast;
              InitSocketAddr(Addr, In4, Port);
            end;
    iaIP6 : begin
              IP6AddrSetBroadcast(In6);
              InitSocketAddr(Addr, In6, Port);
            end;
  else
    raise ESocketLib.Create('Invalid address family');
  end;
  SendTo(Addr, Data, DataSize);
end;

function TSysSocket.Recv(var Buf; const BufSize: Integer): Integer;
var ErrorCode : Integer;
begin
  Result := SocketRecv(FSocketHandle, Buf, BufSize, []);
  {$IFDEF SOCKET_DEBUG}
  Log(sltDebug, 'Recv:%db:%db', [BufSize, Result]);
  {$ENDIF}
  if Result < 0 then
    begin
      ErrorCode := flcSocketLib.SocketGetLastError;
      if (ErrorCode <> EWOULDBLOCK) and (ErrorCode <> 0) then
        raise ESocketLib.Create('Socket recv failed', ErrorCode);
    end;
end;

function TSysSocket.Peek(var Buf; const BufSize: Integer): Integer;
var ErrorCode : Integer;
begin
  Result := SocketRecv(FSocketHandle, Buf, BufSize, [srfPeek]);
  if Result < 0 then
    begin
      ErrorCode := flcSocketLib.SocketGetLastError;
      if (ErrorCode <> EWOULDBLOCK) and (ErrorCode <> 0) then
        raise ESocketLib.Create('Socket recv failed', ErrorCode);
    end;
end;

function TSysSocket.RecvFromEx(var Buf; const BufSize: Integer; var From: TSocketAddr;
         var Truncated: Boolean): Integer;
var ErrorCode : Integer;
begin
  Result := SocketRecvFrom(FSocketHandle, Buf, BufSize, [], From);
  Truncated := False;
  if Result < 0 then
    begin
      ErrorCode := flcSocketLib.SocketGetLastError;
      {$IFDEF SOCKET_WIN}
      if ErrorCode = EMSGSIZE then // partial packet received
        begin
          Truncated := True;
          Result := BufSize;
          exit;
        end;
      {$ENDIF}
      if (ErrorCode <> EWOULDBLOCK) and (ErrorCode <> 0) then
        raise ESocketLib.Create('Socket recv failed', ErrorCode);
    end;
end;

function TSysSocket.RecvFrom(var Buf; const BufSize: Integer; var From: TSocketAddr): Integer;
var T : Boolean;
begin
  Result := RecvFromEx(Buf, BufSize, From, T);
end;

function TSysSocket.RecvFrom(var Buf; const BufSize: Integer; var FromAddr: TIP4Addr; var FromPort: Word): Integer;
var SockAddr : TSocketAddr;
begin
  InitSocketAddrNone(SockAddr);
  Result := RecvFrom(Buf, BufSize, SockAddr);
  if SockAddr.AddrFamily = iaIP4 then
    begin
      FromAddr := SockAddr.AddrIP4;
      FromPort := SockAddr.Port;
    end
  else
    begin
      FromAddr := IP4AddrNone;
      FromPort := 0;
    end;
end;

function TSysSocket.RecvFrom(var Buf; const BufSize: Integer; var FromAddr: TIP6Addr; var FromPort: Word): Integer;
var SockAddr : TSocketAddr;
begin
  InitSocketAddrNone(SockAddr);
  Result := RecvFrom(Buf, BufSize, SockAddr);
  if SockAddr.AddrFamily = iaIP6 then
    begin
      FromAddr := SockAddr.AddrIP6;
      FromPort := SockAddr.Port;
    end
  else
    begin
      IP6AddrSetZero(FromAddr);
      FromPort := 0;
    end;
end;

function TSysSocket.AvailableToRecv: Integer;
begin
  Result := GetSocketAvailableToRecv(FSocketHandle);
end;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF SOCKET_TEST}
{$ASSERTIONS ON}

{$IFDEF SOCKET_TEST_IP4}
procedure TestIP4TCP;
var T, S, C : TSysSocket;
    A : TIP4Addr;
    B : Array[0..255] of AnsiChar;
    R, W, E : Boolean;
begin
  S := TSysSocket.Create(iaIP4, ipTCP, False, INVALID_SOCKETHANDLE);
  T := TSysSocket.Create(iaIP4, ipTCP, False, INVALID_SOCKETHANDLE);
  C := nil;
  try
    Assert(S.SocketHandle <> 0, 'TSysSocket.Create');

    S.SetBlocking(True);
    {$IFDEF SOCKET_WIN}
    S.SetAsynchronous([]);
    {$ENDIF}
    S.Bind('127.0.0.1', '12345');
    S.Listen(2);
    R := True; W := True; E := True;
    Assert(not S.Select(0, R, W, E));
    Assert(not R and not W and not E);

    Assert(S.GetLocalAddressStr = '127.0.0.1');
    Assert(S.GetLocalPort = 12345);

    Assert(T.SocketHandle <> 0, 'TSysSocket.Create');

    T.SetBlocking(True);
    {$IFDEF SOCKET_WIN}
    T.SetAsynchronous([]);
    {$ENDIF}
    T.Connect('127.0.0.1', '12345');

    Assert(T.GetLocalAddressStr <> '');
    Assert(T.GetLocalPort <> 0);

    Assert(T.ReceiveTimeout = 0);
    Assert(T.SendTimeout = 0);
    T.ReceiveBufferSize := 16384;
    Assert(T.ReceiveBufferSize > 0);
    T.SendBufferSize := 16384;
    Assert(T.SendBufferSize > 0);

    R := True; W := True; E := True;
    Assert(S.Select(20, R, W, E));
    Assert(R and not W and not E);

    S.Accept(C, A);
    Assert(Assigned(C));

    R := True; W := True; E := True;
    Assert(C.Select(20, R, W, E));
    Assert(not R and W and not E);

    Assert(T.GetRemoteAddressStr = '127.0.0.1');
    Assert(C.GetRemoteAddressStr = '127.0.0.1');
    Assert(T.GetRemoteHostName <> '');
    Assert(C.GetRemoteHostName <> '');

    T.Send('abc');
    Sleep(1);

    R := True; W := True; E := True;
    Assert(C.Select(0, R, W, E));
    Assert(R and W and not E);

    FillChar(B[0], Sizeof(B), #0);

    {$IFNDEF SOCKET_POSIX_DELPHI}
    Assert(C.AvailableToRecv = 3);
    {$ENDIF}
    Assert(C.Recv(B[0], 3) = 3);
    Assert((B[0] = 'a') and (B[1] = 'b') and (B[2] = 'c'));
    Assert(C.AvailableToRecv = 0);

    R := True; W := True; E := True;
    Assert(C.Select(0, R, W, E));
    Assert(not R and W and not E);

    C.Send('de');
    Sleep(1);

    {$IFNDEF SOCKET_POSIX_DELPHI}
    Assert(T.AvailableToRecv = 2);
    {$ENDIF}
    Assert(T.Recv(B[0], 2) = 2);
    Assert((B[0] = 'd') and (B[1] = 'e'));
    Assert(T.AvailableToRecv = 0);

    T.Send('fghi');
    Sleep(1);

    {$IFNDEF SOCKET_POSIX_DELPHI}
    Assert(C.AvailableToRecv = 4);
    {$ENDIF}
    Assert(C.Recv(B[0], 4) = 4);
    Assert((B[0] = 'f') and (B[1] = 'g') and (B[2] = 'h') and (B[3] = 'i'));
    Assert(C.AvailableToRecv = 0);

    T.Close;
    C.Close;
  finally
    C.Free;
    T.Free;
    S.Free;
  end;

  {$IFDEF SOCKET_TEST_IP4_INTERNET}
  C := TSysSocket.Create(iaIP4, ipTCP, False, INVALID_SOCKETHANDLE);
  try
    C.SetBlocking(True);
    {$IFDEF SOCKET_WIN}
    C.SetAsynchronous([]);
    {$ENDIF}
    C.Connect('www.google.com', '80');
    C.Send(
      'GET / HTTP/1.1'#13#10 +
      'Date: Fri, 15 Aug 2008 15:27:11 GMT'#13#10 +
      'Host: www.google.com'#13#10 +
      #13#10);
    Assert(C.Recv(B[0], 9) = 9);
    Assert(B = 'HTTP/1.1 ');
    C.Close;
  finally
    C.Free;
  end;
  {$ENDIF}
end;
{$ENDIF}

procedure Test;
begin
  {$IFDEF SOCKET_TEST_IP4}
  TestIP4TCP;
  {$ENDIF}
end;
{$ENDIF}



{                                                                              }
{ Unit initialization and finalization                                         }
{                                                                              }
initialization
  {$IFDEF SOCKET_WIN}
  InitializeSocketWindowClassLock;
  {$ENDIF}
finalization
  {$IFDEF SOCKET_WIN}
  FinalizeSocketWindowClassLock;
  {$ENDIF}
end.

