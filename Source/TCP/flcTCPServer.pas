{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcTCPServer.pas                                         }
{   File version:     5.18                                                     }
{   Description:      TCP server.                                              }
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
{   2007/12/01  0.01  Initial development.                                     }
{   2010/11/07  0.02  Development.                                             }
{   2010/11/12  0.03  Refactor for asynchronous operation.                     }
{   2010/12/15  0.04  TLS support.                                             }
{   2010/12/20  0.05  Option to limit the number of clients.                   }
{   2010/12/29  0.06  Indicate when client is in the negotiating state.        }
{   2010/12/30  0.07  Separate control and process threads.                    }
{   2011/06/25  0.08  Improved logging.                                        }
{   2011/07/26  0.09  Improvements.                                            }
{   2011/09/03  4.10  Revise for Fundamentals 4.                               }
{   2013/01/28  4.11  Fix for restarting server.                               }
{   2015/04/25  4.12  OnReady event.                                           }
{   2015/04/26  4.13  Blocking interface and worker thread.                    }
{   2015/04/27  4.14  Whitelist/Blacklist.                                     }
{   2016/01/09  5.15  Revised for Fundamentals 5.                              }
{   2018/08/30  5.16  Trigger Close event when ready client is terminated.     }
{   2018/09/07  5.17  Implement ClientList as linked list.                     }
{   2018/09/07  5.18  Improve latency for large number of clients.             }
{                                                                              }
{******************************************************************************}

{$INCLUDE flcTCP.inc}

unit flcTCPServer;

interface

uses
  { System }
  {$IFDEF DELPHI5}
  Windows,
  {$ENDIF}
  SysUtils,
  SyncObjs,
  Classes,
  { Fundamentals }
  flcStdTypes,
  flcSocketLib,
  flcSocket,
  flcTCPBuffer,
  flcTCPConnection
  { TLS }
  {$IFDEF TCPSERVER_TLS},
  flcTLSConnection,
  flcTLSServer
  {$ENDIF}
  ;



{                                                                              }
{ TCP Server                                                                   }
{                                                                              }
const
  TCP_SERVER_DEFAULT_MaxBacklog = 8;
  TCP_SERVER_DEFAULT_MaxClients = -1;

type
  ETCPServer = class(Exception);

  TF5TCPServer = class;

  { TTCPServerClient                                                           }
  TTCPServerClientState = (
      scsInit,
      scsStarting,
      scsNegotiating,
      scsReady,
      scsClosed);

  TTCPServerClient = class
  protected
    FServer         : TF5TCPServer;
    FPrev           : TTCPServerClient;
    FNext           : TTCPServerClient;
    FState          : TTCPServerClientState;
    FTerminated     : Boolean;
    FRemoteAddr     : TSocketAddr;
    FSocket         : TSysSocket;
    FConnection     : TTCPConnection;
    FReferenceCount : Integer;
    FOrphanClient   : Boolean;
    FClientID       : Int64;
    FUserTag        : NativeInt;
    FUserObject     : TObject;

    {$IFDEF TCPSERVER_TLS}
    FTLSClient      : TTLSServerClient;
    FTLSProxy       : TTCPConnectionProxy;
    {$ENDIF}

    procedure Log(const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer = 0); overload;
    procedure Log(const LogType: TTCPLogType; const LogMsg: String; const LogArgs: array of const; const LogLevel: Integer = 0); overload;

    function  GetState: TTCPServerClientState;
    function  GetStateStr: RawByteString;
    procedure SetState(const State: TTCPServerClientState);

    procedure SetNegotiating;
    procedure SetReady;

    function  GetRemoteAddrStr: RawByteString;

    function  GetBlockingConnection: TTCPBlockingConnection;

    {$IFDEF TCPSERVER_TLS}
    procedure InstallTLSProxy;
    {$ENDIF}

    procedure ConnectionLog(Sender: TTCPConnection; LogType: TTCPLogType; LogMsg: String; LogLevel: Integer);
    procedure ConnectionStateChange(Sender: TTCPConnection; State: TTCPConnectionState);
    procedure ConnectionReady(Sender: TTCPConnection);
    procedure ConnectionRead(Sender: TTCPConnection);
    procedure ConnectionWrite(Sender: TTCPConnection);
    procedure ConnectionClose(Sender: TTCPConnection);

    procedure ConnectionWorkerExecute(Sender: TTCPConnection;
              Connection: TTCPBlockingConnection; var CloseOnExit: Boolean);

    procedure TriggerStateChange;
    procedure TriggerNegotiating;
    procedure TriggerConnected;
    procedure TriggerReady;
    procedure TriggerRead;
    procedure TriggerWrite;
    procedure TriggerClose;

    procedure Start;
    procedure Process(var Idle, Terminated: Boolean);
    procedure AddReference;
    procedure SetClientOrphaned;

  public
    constructor Create(
                const Server: TF5TCPServer;
                const SocketHandle: TSocketHandle;
                const ClientID: Int64;
                const RemoteAddr: TSocketAddr);
    destructor Destroy; override;

    property  State: TTCPServerClientState read GetState;
    property  StateStr: RawByteString read GetStateStr;
    property  Terminated: Boolean read FTerminated;

    // Connection has a non-blocking interface.
    // BlockingConnection has a blocking interface. It can be used from a
    // worker thread, it should not be used from an event handler.
    property  Connection: TTCPConnection read FConnection;
    property  BlockingConnection: TTCPBlockingConnection read GetBlockingConnection;

    procedure Close;
    procedure ReleaseReference;

    {$IFDEF TCPSERVER_TLS}
    property  TLSClient: TTLSServerClient read FTLSClient;
    procedure StartTLS;
    {$ENDIF}

    property  RemoteAddr: TSocketAddr read FRemoteAddr;
    property  RemoteAddrStr: RawByteString read GetRemoteAddrStr;

    property  ClientID: Int64 read FClientID;

    // Worker thread
    procedure TerminateWorkerThread;

    // User defined values
    property  UserTag: NativeInt read FUserTag write FUserTag;
    property  UserObject: TObject read FUserObject write FUserObject;
  end;

  TTCPServerClientClass = class of TTCPServerClient;

  { TTCPServer                                                                 }

  TTCPServerClientList = class
  private
    FCount : Integer;
    FFirst : TTCPServerClient;
    FLast  : TTCPServerClient;

  public
    destructor Destroy; override;
    procedure Finalise;
    procedure Add(const Client: TTCPServerClient);
    procedure Remove(const Client: TTCPServerClient);
    property First: TTCPServerClient read FFirst;
    property Count: Integer read FCount;
  end;

  TTCPServerThreadTask = (
      sttControl,
      sttProcess);

  TTCPServerThread = class(TThread)
  protected
    FServer : TF5TCPServer;
    FTask   : TTCPServerThreadTask;
    procedure Execute; override;
  public
    constructor Create(const Server: TF5TCPServer; const Task: TTCPServerThreadTask);
    property Terminated;
  end;

  TTCPServerState = (
      ssInit,
      ssStarting,
      ssReady,
      ssFailure,
      ssClosed);

  TTCPServerNotifyEvent = procedure (Sender: TF5TCPServer) of object;
  TTCPServerLogEvent = procedure (Sender: TF5TCPServer; LogType: TTCPLogType;
      Msg: String; LogLevel: Integer) of object;
  TTCPServerStateEvent = procedure (Sender: TF5TCPServer; State: TTCPServerState) of object;
  TTCPServerClientEvent = procedure (Sender: TTCPServerClient) of object;
  TTCPServerIdleEvent = procedure (Sender: TF5TCPServer; Thread: TTCPServerThread) of object;
  TTCPServerAcceptEvent = procedure (Sender: TF5TCPServer; Address: TSocketAddr;
      var AcceptClient: Boolean) of object;
  TTCPServerNameLookupEvent = procedure (Sender: TF5TCPServer; Address: TSocketAddr;
      HostName: RawByteString; var AcceptClient: Boolean) of object;
  TTCPServerClientWorkerExecuteEvent = procedure (Sender: TTCPServerClient;
      Connection: TTCPBlockingConnection; var CloseOnExit: Boolean) of object;

  TF5TCPServer = class(TComponent)
  private
    // parameters
    FAddressFamily      : TIPAddressFamily;
    FBindAddressStr     : String;
    FServerPort         : Integer;
    FMaxBacklog         : Integer;
    FMaxClients         : Integer;
    FMaxReadBufferSize  : Integer;
    FMaxWriteBufferSize : Integer;
    {$IFDEF TCPSERVER_TLS}
    FTLSEnabled         : Boolean;
    {$ENDIF}
    FUseWorkerThread    : Boolean;
    FUserTag            : NativeInt;
    FUserObject         : TObject;

    // event handlers
    FOnLog                 : TTCPServerLogEvent;
    FOnStateChanged        : TTCPServerStateEvent;
    FOnStart               : TTCPServerNotifyEvent;
    FOnStop                : TTCPServerNotifyEvent;
    FOnThreadIdle          : TTCPServerIdleEvent;

    FOnClientAccept        : TTCPServerAcceptEvent;
    FOnClientNameLookup    : TTCPServerNameLookupEvent;
    FOnClientCreate        : TTCPServerClientEvent;
    FOnClientAdd           : TTCPServerClientEvent;
    FOnClientRemove        : TTCPServerClientEvent;
    FOnClientDestroy       : TTCPServerClientEvent;
    FOnClientStateChange   : TTCPServerClientEvent;
    FOnClientNegotiating   : TTCPServerClientEvent;
    FOnClientConnected     : TTCPServerClientEvent;
    FOnClientReady         : TTCPServerClientEvent;
    FOnClientRead          : TTCPServerClientEvent;
    FOnClientWrite         : TTCPServerClientEvent;
    FOnClientClose         : TTCPServerClientEvent;
    FOnClientWorkerExecute : TTCPServerClientWorkerExecuteEvent;

    // state
    FLock                 : TCriticalSection;
    FActive               : Boolean;
    FActiveOnLoaded       : Boolean;
    FState                : TTCPServerState;
    FControlThread        : TTCPServerThread;
    FProcessThread        : TTCPServerThread;
    FServerSocket         : TSysSocket;
    FBindAddress          : TSocketAddr;
    FClientList           : TTCPServerClientList;
    FClientTerminatedList : TTCPServerClientList;
    FClientIDCounter      : Int64;
    FIteratorProcess      : TTCPServerClient;
    FWhitelist            : TSocketAddrArray;
    FBlacklist            : TSocketAddrArray;

    {$IFDEF TCPSERVER_TLS}
    FTLSServer          : TTLSServer;
    {$ENDIF}

  protected
    procedure Init; virtual;
    procedure InitDefaults; virtual;

    procedure Lock;
    procedure Unlock;

    procedure Log(const LogType: TTCPLogType; const Msg: String; const LogLevel: Integer = 0); overload;
    procedure Log(const LogType: TTCPLogType; const Msg: String; const Args: array of const; const LogLevel: Integer = 0); overload;
    procedure LogException(const Msg: String; const E: Exception);

    function  GetState: TTCPServerState;
    function  GetStateStr: RawByteString;
    procedure SetState(const State: TTCPServerState);
    procedure CheckNotActive;

    procedure SetActive(const Active: Boolean);
    procedure Loaded; override;

    procedure SetAddressFamily(const AddressFamily: TIPAddressFamily);
    procedure SetBindAddress(const BindAddressStr: String);
    procedure SetServerPort(const ServerPort: Integer);
    procedure SetMaxBacklog(const MaxBacklog: Integer);
    procedure SetMaxClients(const MaxClients: Integer);

    procedure SetReadBufferSize(const ReadBufferSize: Integer);
    procedure SetWriteBufferSize(const WriteBufferSize: Integer);

    {$IFDEF TCPSERVER_TLS}
    procedure SetTLSEnabled(const TLSEnabled: Boolean);
    {$ENDIF}

    procedure SetUseWorkerThread(const UseWorkerThread: Boolean);

    procedure TriggerStart; virtual;
    procedure TriggerStop; virtual;

    procedure TriggerThreadIdle(const Thread: TTCPServerThread); virtual;

    procedure ServerSocketLog(Sender: TSysSocket; LogType: TSysSocketLogType; Msg: String);

    procedure ClientLog(const Client: TTCPServerClient; const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer);

    procedure TriggerClientAccept(const Address: TSocketAddr; var AcceptClient: Boolean); virtual;
    procedure TriggerClientNameLookup(const Address: TSocketAddr; const HostName: RawByteString; var AcceptClient: Boolean); virtual;
    procedure TriggerClientCreate(const Client: TTCPServerClient); virtual;
    procedure TriggerClientAdd(const Client: TTCPServerClient); virtual;
    procedure TriggerClientRemove(const Client: TTCPServerClient); virtual;
    procedure TriggerClientDestroy(const Client: TTCPServerClient); virtual;
    procedure TriggerClientStateChange(const Client: TTCPServerClient); virtual;
    procedure TriggerClientNegotiating(const Client: TTCPServerClient); virtual;
    procedure TriggerClientConnected(const Client: TTCPServerClient); virtual;
    procedure TriggerClientReady(const Client: TTCPServerClient); virtual;
    procedure TriggerClientRead(const Client: TTCPServerClient); virtual;
    procedure TriggerClientWrite(const Client: TTCPServerClient); virtual;
    procedure TriggerClientClose(const Client: TTCPServerClient); virtual;
    procedure TriggerClientWorkerExecute(const Client: TTCPServerClient;
              const Connection: TTCPBlockingConnection; var CloseOnExit: Boolean); virtual;

    procedure SetReady; virtual;
    procedure SetClosed; virtual;

    procedure DoCloseClients;
    procedure DoCloseServer;
    procedure DoClose;

    {$IFDEF TCPSERVER_TLS}
    procedure TLSServerTransportLayerSendProc(Server: TTLSServer; Client: TTLSServerClient; const Buffer; const Size: Integer);
    {$ENDIF}

    procedure StartControlThread;
    procedure StartProcessThread;
    procedure StopServerThreads;

    procedure DoStart;
    procedure DoStop;

    function  CreateClient(const SocketHandle: TSocketHandle; const SocketAddr: TSocketAddr): TTCPServerClient; virtual;

    function  CanAcceptClient: Boolean;
    function  ServerAcceptClient: Boolean;
    function  ServerDropClient: Boolean;
    function  ProcessClientFromList(const List: TTCPServerClientList;
              var Iter: TTCPServerClient; var ItCnt: Integer;
              out ClientIdle, ClientTerminated: Boolean): Boolean;
    function  ServerProcessClient: Boolean;

    procedure ControlThreadExecute(const Thread: TTCPServerThread);
    procedure ProcessThreadExecute(const Thread: TTCPServerThread);
    procedure ThreadError(const Thread: TTCPServerThread; const Error: Exception);
    procedure ThreadTerminate(const Thread: TTCPServerThread);

    function  GetActiveClientCount: Integer;
    function  GetClientCount: Integer;

    function  GetReadRate: Int64;
    function  GetWriteRate: Int64;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Finalise;

    // Parameters
    property  AddressFamily: TIPAddressFamily read FAddressFamily write SetAddressFamily default iaIP4;
    property  BindAddress: String read FBindAddressStr write SetBindAddress;
    property  ServerPort: Integer read FServerPort write SetServerPort;
    property  MaxBacklog: Integer read FMaxBacklog write SetMaxBacklog default TCP_SERVER_DEFAULT_MaxBacklog;
    property  MaxClients: Integer read FMaxClients write SetMaxClients default TCP_SERVER_DEFAULT_MaxClients;
    property  MaxReadBufferSize: Integer read FMaxReadBufferSize write SetReadBufferSize;
    property  MaxWriteBufferSize: Integer read FMaxWriteBufferSize write SetWriteBufferSize;

    // TLS
    {$IFDEF TCPSERVER_TLS}
    property  TLSEnabled: Boolean read FTLSEnabled write SetTLSEnabled default False;
    property  TLSServer: TTLSServer read FTLSServer;
    {$ENDIF}

    // Event handlers may be called from any number of external threads.
    // Event handlers should do their own synchronisation if required.
    property  OnLog: TTCPServerLogEvent read FOnLog write FOnLog;
    property  OnStateChanged: TTCPServerStateEvent read FOnStateChanged write FOnStateChanged;
    property  OnStart: TTCPServerNotifyEvent read FOnStart write FOnStart;
    property  OnStop: TTCPServerNotifyEvent read FOnStop write FOnStop;
    property  OnThreadIdle: TTCPServerIdleEvent read FOnThreadIdle write FOnThreadIdle;

    property  OnClientAccept: TTCPServerAcceptEvent read FOnClientAccept write FOnClientAccept;
    property  OnClientCreate: TTCPServerClientEvent read FOnClientCreate write FOnClientCreate;
    property  OnClientAdd: TTCPServerClientEvent read FOnClientAdd write FOnClientAdd;
    property  OnClientRemove: TTCPServerClientEvent read FOnClientRemove write FOnClientRemove;
    property  OnClientDestroy: TTCPServerClientEvent read FOnClientDestroy write FOnClientDestroy;

    property  OnClientStateChange: TTCPServerClientEvent read FOnClientStateChange write FOnClientStateChange;
    property  OnClientNegotiating: TTCPServerClientEvent read FOnClientNegotiating write FOnClientNegotiating;
    property  OnClientConnected: TTCPServerClientEvent read FOnClientConnected write FOnClientConnected;
    property  OnClientReady: TTCPServerClientEvent read FOnClientReady write FOnClientReady;
    property  OnClientRead: TTCPServerClientEvent read FOnClientRead write FOnClientRead;
    property  OnClientWrite: TTCPServerClientEvent read FOnClientWrite write FOnClientWrite;
    property  OnClientClose: TTCPServerClientEvent read FOnClientClose write FOnClientClose;

    // State
    property  State: TTCPServerState read GetState;
    property  StateStr: RawByteString read GetStateStr;
    property  Active: Boolean read FActive write SetActive default False;
    procedure Start;
    procedure Stop;

    property  ActiveClientCount: Integer read GetActiveClientCount;
    property  ClientCount: Integer read GetClientCount;
    function  ClientIterateFirst: TTCPServerClient;
    function  ClientIterateNext(const C: TTCPServerClient): TTCPServerClient;

    property  ReadRate: Int64 read GetReadRate;
    property  WriteRate: Int64 read GetWriteRate;

    // Whitelist/Blacklist addresses
    // IPs from Whitelist are allowed, IPs from Blacklist are denied.
    procedure AddWhitelistAddr(const Addr: TSocketAddr);
    procedure AddBlacklistAddr(const Addr: TSocketAddr);

    // Worker thread
    // When UseWorkerThread is True, each client will have a worker thread
    // created when it is in the Ready state. OnClientWorkerExecute will
    // be called where the client can use the blocking connection interface.
    property  UseWorkerThread: Boolean read FUseWorkerThread write SetUseWorkerThread default False;
    property  OnClientWorkerExecute: TTCPServerClientWorkerExecuteEvent read FOnClientWorkerExecute write FOnClientWorkerExecute;

    // User defined values
    property  UserTag: NativeInt read FUserTag write FUserTag;
    property  UserObject: TObject read FUserObject write FUserObject;
  end;



{                                                                              }
{ Components                                                                   }
{                                                                              }
type
  TfclTCPServer = class(TF5TCPServer)
  published
    property  Active;
    property  AddressFamily;
    property  BindAddress;
    property  ServerPort;
    property  MaxBacklog;
    property  MaxReadBufferSize;
    property  MaxWriteBufferSize;

    property  OnLog;
    property  OnStateChanged;
    property  OnStart;
    property  OnStop;
    property  OnThreadIdle;

    property  OnClientAccept;
    property  OnClientCreate;
    property  OnClientAdd;
    property  OnClientRemove;
    property  OnClientDestroy;

    property  OnClientStateChange;
    property  OnClientNegotiating;
    property  OnClientReady;

    property  OnClientRead;
    property  OnClientWrite;
    property  OnClientClose;

    property  UseWorkerThread;
    property  OnClientWorkerExecute;
  end;



implementation

{$IFDEF TCPSERVER_TLS}
uses
  { TLS }
  flcTLSUtils;
{$ENDIF}



{                                                                              }
{ Error and debug strings                                                      }
{                                                                              }
const
  SError_NotAllowedWhileActive = 'Operation not allowed while server is active';
  SError_InvalidServerPort     = 'Invalid server port';

  STCPServerState : array[TTCPServerState] of RawByteString = (
      'Initialise',
      'Starting',
      'Ready',
      'Failure',
      'Closed');

  STCPServerClientState : array[TTCPServerClientState] of RawByteString = (
      'Initialise',
      'Starting',
      'Negotiating',
      'Ready',
      'Closed');



{$IFDEF TCPSERVER_TLS}
{                                                                              }
{ TCP Server Client TLS Connection Proxy                                       }
{                                                                              }
type
  TTCPServerClientTLSConnectionProxy = class(TTCPConnectionProxy)
  private
    FTLSServer : TTLSServer;
    FTLSClient : TTLSServerClient;

    procedure TLSClientTransportLayerSendProc(const Sender: TTLSConnection; const Buffer; const Size: Integer);
    procedure TLSClientLog(Sender: TTLSConnection; LogType: TTLSLogType; LogMsg: String; LogLevel: Integer);
    procedure TLSClientStateChange(Sender: TTLSConnection; State: TTLSConnectionState);

  public
    class function ProxyName: String; override;
    
    constructor Create(const TLSServer: TTLSServer; const Connection: TTCPConnection);
    destructor Destroy; override;

    procedure ProxyStart; override;
    procedure ProcessReadData(const Buf; const BufSize: Integer); override;
    procedure ProcessWriteData(const Buf; const BufSize: Integer); override;
  end;

class function TTCPServerClientTLSConnectionProxy.ProxyName: String;
begin
  Result := 'TLSServerClient';
end;

constructor TTCPServerClientTLSConnectionProxy.Create(const TLSServer: TTLSServer; const Connection: TTCPConnection);
begin
  Assert(Assigned(TLSServer));
  Assert(Assigned(Connection));

  inherited Create(Connection);
  FTLSServer := TLSServer;
  FTLSClient := TLSServer.AddClient(self);
  {$IFDEF TCP_DEBUG}
  FTLSClient.OnLog := TLSClientLog;
  {$ENDIF}
  FTLSClient.OnStateChange := TLSClientStateChange;
end;

destructor TTCPServerClientTLSConnectionProxy.Destroy;
begin
  if Assigned(FTLSServer) and Assigned(FTLSClient) then
    FTLSServer.RemoveClient(FTLSClient);
  inherited Destroy;
end;

procedure TTCPServerClientTLSConnectionProxy.ProxyStart;
begin
  SetState(prsNegotiating);
  FTLSClient.Start;
end;

procedure TTCPServerClientTLSConnectionProxy.TLSClientTransportLayerSendProc(const Sender: TTLSConnection; const Buffer; const Size: Integer);
begin
  ConnectionPutWriteData(Buffer, Size);
end;

procedure TTCPServerClientTLSConnectionProxy.TLSClientLog(Sender: TTLSConnection; LogType: TTLSLogType; LogMsg: String; LogLevel: Integer);
begin
  {$IFDEF TCP_DEBUG_TLS}
  Log(tlDebug, Format('TLS:%s', [LogMsg]), LogLevel + 1);
  {$ENDIF}
end;

procedure TTCPServerClientTLSConnectionProxy.TLSClientStateChange(Sender: TTLSConnection; State: TTLSConnectionState);
begin
  case State of
    tlscoApplicationData : SetState(prsFiltering);
    tlscoCancelled,
    tlscoErrorBadProtocol :
      begin
        ConnectionClose;
        SetState(prsError);
      end;
    tlscoClosed :
      begin
        ConnectionClose;
        SetState(prsClosed);
      end;
  end;
end;

procedure TTCPServerClientTLSConnectionProxy.ProcessReadData(const Buf; const BufSize: Integer);
const
  ReadBufSize = TLS_PLAINTEXT_FRAGMENT_MAXSIZE * 2;
var
  ReadBuf : array[0..ReadBufSize - 1] of Byte;
  L : Integer;
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(tlDebug, 'ProcessReadData:%db', [BufSize]);
  {$ENDIF}
  FTLSClient.ProcessTransportLayerReceivedData(Buf, BufSize);
  repeat
    L := FTLSClient.AvailableToRead;
    if L > ReadBufSize then
      L := ReadBufSize;
    if L > 0 then
      begin
        L := FTLSClient.Read(ReadBuf, L);
        if L > 0 then
          ConnectionPutReadData(ReadBuf, L);
      end;
  until L <= 0;
end;

procedure TTCPServerClientTLSConnectionProxy.ProcessWriteData(const Buf; const BufSize: Integer);
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(tlDebug, 'ProcessWriteData:%db', [BufSize]);
  {$ENDIF}
  FTLSClient.Write(Buf, BufSize);
end;
{$ENDIF}



{                                                                              }
{ TCP Server Client                                                            }
{                                                                              }
constructor TTCPServerClient.Create(
            const Server: TF5TCPServer;
            const SocketHandle: TSocketHandle;
            const ClientID: Int64;
            const RemoteAddr: TSocketAddr);
begin
  Assert(Assigned(Server));
  Assert(SocketHandle <> INVALID_SOCKETHANDLE);

  inherited Create;
  FState := scsInit;
  FServer := Server;
  FClientID := ClientID;
  FSocket := TSysSocket.Create(Server.FAddressFamily, ipTCP, False, SocketHandle);
  FRemoteAddr := RemoteAddr;
  FConnection := TTCPConnection.Create(FSocket);
  FConnection.ReadBufferMaxSize  := Server.FMaxReadBufferSize;
  FConnection.WriteBufferMaxSize := Server.FMaxWriteBufferSize;
  FConnection.OnLog           := ConnectionLog;
  FConnection.OnStateChange   := ConnectionStateChange;
  FConnection.OnReady         := ConnectionReady;
  FConnection.OnRead          := ConnectionRead;
  FConnection.OnWrite         := ConnectionWrite;
  FConnection.OnClose         := ConnectionClose;
  FConnection.OnWorkerExecute := ConnectionWorkerExecute;
  {$IFDEF TCPSERVER_TLS}
  if FServer.FTLSEnabled then
    InstallTLSProxy;
  {$ENDIF}
end;

destructor TTCPServerClient.Destroy;
begin
  FreeAndNil(FConnection);
  FreeAndNil(FSocket);
  inherited Destroy;
end;

procedure TTCPServerClient.Log(const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer);
begin
  if Assigned(FServer) then
    FServer.ClientLog(self, LogType, LogMsg, LogLevel);
end;

procedure TTCPServerClient.Log(const LogType: TTCPLogType; const LogMsg: String; const LogArgs: array of const; const LogLevel: Integer);
begin
  Log(LogType, Format(LogMsg, LogArgs), LogLevel);
end;

function TTCPServerClient.GetState: TTCPServerClientState;
begin
  Result := FState;
end;

function TTCPServerClient.GetStateStr: RawByteString;
begin
  Result := STCPServerClientState[GetState];
end;

procedure TTCPServerClient.SetState(const State: TTCPServerClientState);
begin
  Assert(FState <> State);
  FState := State;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'State:%s', [STCPServerClientState[State]]);
  {$ENDIF}
end;

procedure TTCPServerClient.SetNegotiating;
begin
  SetState(scsNegotiating);
  TriggerNegotiating;
end;

procedure TTCPServerClient.SetReady;
begin
  SetState(scsReady);
  TriggerReady;
end;

function TTCPServerClient.GetRemoteAddrStr: RawByteString;
begin
  Result := SocketAddrStrA(FRemoteAddr);
end;

function TTCPServerClient.GetBlockingConnection: TTCPBlockingConnection;
begin
  Assert(Assigned(FConnection));
  Result := FConnection.BlockingConnection;
end;

{$IFDEF TCPSERVER_TLS}
procedure TTCPServerClient.InstallTLSProxy;
var Proxy : TTCPServerClientTLSConnectionProxy;
begin
  Assert(Assigned(FServer));

  {$IFDEF TCP_DEBUG_TLS}
  Log(tlDebug, 'InstallTLSProxy');
  {$ENDIF}
  Proxy := TTCPServerClientTLSConnectionProxy.Create(FServer.FTLSServer, FConnection);
  FTLSClient := Proxy.FTLSClient;
  FTLSProxy := Proxy;
  FConnection.AddProxy(Proxy);
end;
{$ENDIF}

procedure TTCPServerClient.ConnectionLog(Sender: TTCPConnection; LogType: TTCPLogType; LogMsg: String; LogLevel: Integer);
begin
  {$IFDEF TCP_DEBUG_CONNECTION}
  Log(LogType, 'Connection:%s', [LogMsg], LogLevel + 1);
  {$ENDIF}
end;

procedure TTCPServerClient.ConnectionStateChange(Sender: TTCPConnection; State: TTCPConnectionState);
begin
  {$IFDEF TCP_DEBUG_CONNECTION}
  Log(tlDebug, 'Connection_StateChange:%s', [Sender.StateStr]);
  {$ENDIF}
  case State of
    cnsProxyNegotiation : SetNegotiating;
    cnsConnected        : SetReady;
  end;
  TriggerStateChange;
end;

procedure TTCPServerClient.ConnectionReady(Sender: TTCPConnection);
begin
  TriggerConnected;
end;

procedure TTCPServerClient.ConnectionRead(Sender: TTCPConnection);
begin
  TriggerRead;
end;

procedure TTCPServerClient.ConnectionWrite(Sender: TTCPConnection);
begin
  TriggerWrite;
end;

procedure TTCPServerClient.ConnectionClose(Sender: TTCPConnection);
begin
  {$IFDEF TCP_DEBUG_CONNECTION}
  Log(tlDebug, 'Connection_Close');
  {$ENDIF}
  if FState = scsClosed then
    exit;
  SetState(scsClosed);
  TriggerClose;
end;

procedure TTCPServerClient.ConnectionWorkerExecute(Sender: TTCPConnection;
          Connection: TTCPBlockingConnection;
          var CloseOnExit: Boolean);
begin
  if Assigned(FServer) then
    FServer.TriggerClientWorkerExecute(self, Connection, CloseOnExit);
end;

procedure TTCPServerClient.TriggerStateChange;
begin
  if Assigned(FServer) then
    FServer.TriggerClientStateChange(self);
end;

procedure TTCPServerClient.TriggerNegotiating;
begin
  if Assigned(FServer) then
    FServer.TriggerClientNegotiating(self);
end;

procedure TTCPServerClient.TriggerConnected;
begin
  if Assigned(FServer) then
    FServer.TriggerClientConnected(self);
end;

procedure TTCPServerClient.TriggerReady;
begin
  if Assigned(FServer) then
    FServer.TriggerClientReady(self);
end;

procedure TTCPServerClient.TriggerRead;
begin
  if Assigned(FServer) then
    FServer.TriggerClientRead(self);
end;

procedure TTCPServerClient.TriggerWrite;
begin
  if Assigned(FServer) then
    FServer.TriggerClientWrite(self);
end;

procedure TTCPServerClient.TriggerClose;
begin
  if Assigned(FServer) then
    FServer.TriggerClientClose(self);
end;

procedure TTCPServerClient.Start;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Start');
  {$ENDIF}
  SetState(scsStarting);
  FConnection.Start;
end;

procedure TTCPServerClient.Process(var Idle, Terminated: Boolean);
begin
  FConnection.PollSocket(Idle, Terminated);
  if Terminated then
    FTerminated := True;
end;

procedure TTCPServerClient.AddReference;
begin
  Inc(FReferenceCount);
end;

procedure TTCPServerClient.SetClientOrphaned;
begin
  Assert(not FOrphanClient);
  Assert(Assigned(FServer));

  FOrphanClient := True;
  FServer := nil;
end;

procedure TTCPServerClient.ReleaseReference;
begin
  if FOrphanClient then
    begin
      Dec(FReferenceCount);
      if FReferenceCount = 0 then
        Free;
    end
  else
    begin
      Assert(Assigned(FServer));
      FServer.Lock;
      try
        if FReferenceCount = 0 then
          exit;
        Dec(FReferenceCount);
      finally
        FServer.Unlock;
      end;
    end;
end;

procedure TTCPServerClient.Close;
begin
  if FState = scsClosed then
    exit;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Close');
  {$ENDIF}
  FSocket.Close;
  SetState(scsClosed);
  TriggerClose;
end;

{$IFDEF TCPSERVER_TLS}
procedure TTCPServerClient.StartTLS;
begin
  Assert(Assigned(FServer));

  if FServer.FTLSEnabled then
    exit;
  InstallTLSProxy;
end;
{$ENDIF}

procedure TTCPServerClient.TerminateWorkerThread;
begin
  if Assigned(FConnection) then
    FConnection.TerminateWorkerThread;
end;



{                                                                              }
{ TCP Server Client List                                                       }
{                                                                              }
destructor TTCPServerClientList.Destroy;
begin
  Finalise;
  inherited Destroy;
end;

procedure TTCPServerClientList.Finalise;
var
  Item : TTCPServerClient;
  Next : TTCPServerClient;
begin
  Item := FFirst;
  while Assigned(Item) do
    begin
      Next := Item.FNext;
      Item.FNext := nil;
      Item.FPrev := nil;
      Item := Next;
    end;
  FFirst := nil;
  FLast := nil;
end;

procedure TTCPServerClientList.Add(const Client: TTCPServerClient);
var
  Last : TTCPServerClient;
begin
  Assert(Assigned(Client));
  Last := FLast;
  Client.FNext := nil;
  Client.FPrev := Last;
  if Assigned(Last) then
    Last.FNext := Client
  else
    FFirst := Client;
  FLast := Client;
  Inc(FCount);
end;

procedure TTCPServerClientList.Remove(const Client: TTCPServerClient);
var
  Prev, Next : TTCPServerClient;
begin
  Assert(Assigned(Client));
  Assert(FCount > 0);
  Prev := Client.FPrev;
  Next := Client.FNext;
  if Assigned(Prev) then
    begin
      Prev.FNext := Next;
      Client.FPrev := nil;
    end
  else
    begin
      Assert(FFirst = Client);
      FFirst := Next;
    end;
  if Assigned(Next) then
    begin
      Next.FPrev := Prev;
      Client.FNext := nil;
    end
  else
    begin
      Assert(FLast = Client);
      FLast := Prev;
    end;
  Dec(FCount);
end;



{                                                                              }
{ TCP Server Thread                                                            }
{                                                                              }
constructor TTCPServerThread.Create(const Server: TF5TCPServer; const Task: TTCPServerThreadTask);
begin
  Assert(Assigned(Server));
  FServer := Server;
  FTask := Task;
  FreeOnTerminate := False;
  inherited Create(False);
end;

procedure TTCPServerThread.Execute;
begin
  Assert(Assigned(FServer));
  try
    try
      case FTask of
        sttControl : FServer.ControlThreadExecute(self);
        sttProcess : FServer.ProcessThreadExecute(self);
      end;
    except
      on E : Exception do
        FServer.ThreadError(self, E);
    end;
  finally
    FServer.ThreadTerminate(self);
    FServer := nil;
  end;
end;



{                                                                              }
{ TCP Server                                                                   }
{                                                                              }
constructor TF5TCPServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Init;
end;

procedure TF5TCPServer.Init;
begin
  FState := ssInit;
  FActiveOnLoaded := False;
  FLock := TCriticalSection.Create;
  FClientList := TTCPServerClientList.Create;
  FClientTerminatedList := TTCPServerClientList.Create;
  {$IFDEF TCPSERVER_TLS}
  FTLSServer := TTLSServer.Create(TLSServerTransportLayerSendProc);
  {$ENDIF}
  InitDefaults;
end;

procedure TF5TCPServer.InitDefaults;
begin
  FActive := False;
  FAddressFamily := iaIP4;
  FBindAddressStr := '0.0.0.0';
  FMaxBacklog := TCP_SERVER_DEFAULT_MaxBacklog;
  FMaxClients := TCP_SERVER_DEFAULT_MaxClients;
  FMaxReadBufferSize := TCP_BUFFER_DEFAULTBUFSIZE;
  {$IFDEF TCPSERVER_TLS}
  FTLSEnabled := False;
  {$ENDIF}
end;

destructor TF5TCPServer.Destroy;
begin
  Finalise;
  inherited Destroy;
end;

procedure TF5TCPServer.Finalise;

  procedure FinaliseClientList(const List: TTCPServerClientList);
  var
    Iter, Next : TTCPServerClient;
  begin
    Iter := List.First;
    while Assigned(Iter) do
      begin
        Next := Iter.FNext;
        List.Remove(Iter);
        if Iter.FReferenceCount = 0 then
          Iter.Free
        else
          Iter.SetClientOrphaned;
        Iter := Next;
      end;
  end;

var
  Iter : TTCPServerClient;
begin
  // stop threads
  try
    StopServerThreads;
    if Assigned(FClientList) then
      begin
        Iter := FClientList.First;
        while Assigned(Iter) do
          begin
            Iter.TerminateWorkerThread;
            Iter := Iter.FNext;
          end;
      end;
  except
    {$IFDEF TCP_DEBUG} raise; {$ELSE}
    on E : Exception do
       LogException('Error stopping threads: %s', E); {$ENDIF}
  end;
  {$IFDEF TCPSERVER_TLS}
  FreeAndNil(FTLSServer);
  {$ENDIF}
  // Clients
  // Remove & Destroy/MarkOrphaned
  if Assigned(FClientTerminatedList) then
    begin
      FinaliseClientList(FClientTerminatedList);
      FreeAndNil(FClientTerminatedList);
    end;
  if Assigned(FClientList) then
    begin
      FinaliseClientList(FClientList);
      FreeAndNil(FClientList);
    end;
  // free
  FreeAndNil(FServerSocket);
  FreeAndNil(FLock);
end;

procedure TF5TCPServer.Lock;
begin
  Assert(Assigned(FLock));
  FLock.Acquire;
end;

procedure TF5TCPServer.Unlock;
begin
  Assert(Assigned(FLock));
  FLock.Release;
end;

procedure TF5TCPServer.Log(const LogType: TTCPLogType; const Msg: String; const LogLevel: Integer);
begin
  if Assigned(FOnLog) then
    FOnLog(self, LogType, Msg, LogLevel);
end;

procedure TF5TCPServer.Log(const LogType: TTCPLogType; const Msg: String; const Args: array of const; const LogLevel: Integer);
begin
  Log(LogType, Format(Msg, Args), LogLevel);
end;

procedure TF5TCPServer.LogException(const Msg: String; const E: Exception);
begin
  Log(tlError, Msg, [E.Message]);
end;

function TF5TCPServer.GetState: TTCPServerState;
begin
  Lock;
  try
    Result := FState;
  finally
    Unlock;
  end;
end;

function TF5TCPServer.GetStateStr: RawByteString;
begin
  Result := STCPServerState[GetState];
end;

procedure TF5TCPServer.SetState(const State: TTCPServerState);
begin
  Lock;
  try
    Assert(FState <> State);
    FState := State;
  finally
    Unlock;
  end;
  if Assigned(FOnStateChanged) then
    FOnStateChanged(self, State);
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'State:%s', [GetStateStr]);
  {$ENDIF}
end;

procedure TF5TCPServer.CheckNotActive;
begin
  if not (csDesigning in ComponentState) then
    if FActive then
      raise ETCPServer.Create(SError_NotAllowedWhileActive);
end;

procedure TF5TCPServer.SetActive(const Active: Boolean);
begin
  if Active = FActive then
    exit;
  if csDesigning in ComponentState then
    FActive := Active else
  if csLoading in ComponentState then
    FActiveOnLoaded := Active
  else
    if Active then
      DoStart
    else
      DoStop;
end;

procedure TF5TCPServer.Loaded;
begin
  inherited Loaded;
  if FActiveOnLoaded then
    DoStart;
end;

procedure TF5TCPServer.SetAddressFamily(const AddressFamily: TIPAddressFamily);
begin
  if AddressFamily = FAddressFamily then
    exit;
  CheckNotActive;
  FAddressFamily := AddressFamily;
end;

procedure TF5TCPServer.SetBindAddress(const BindAddressStr: String);
begin
  if BindAddressStr = FBindAddressStr then
    exit;
  CheckNotActive;
  FBindAddressStr := BindAddressStr;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'BindAddress:%s', [BindAddressStr]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetServerPort(const ServerPort: Integer);
begin
  if ServerPort = FServerPort then
    exit;
  CheckNotActive;
  if (ServerPort <= 0) or (ServerPort > $FFFF) then
    raise ETCPServer.Create(SError_InvalidServerPort);
  FServerPort := ServerPort;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'ServerPort:%d', [ServerPort]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetMaxBacklog(const MaxBacklog: Integer);
begin
  if MaxBacklog = FMaxBacklog then
    exit;
  CheckNotActive;
  FMaxBacklog := MaxBacklog;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'MaxBacklog:%d', [MaxBacklog]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetMaxClients(const MaxClients: Integer);
begin
  if MaxClients = FMaxClients then
    exit;
  Lock;
  try
    FMaxClients := MaxClients;
  finally
    Unlock;
  end;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'MaxClients:%d', [MaxClients]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetReadBufferSize(const ReadBufferSize: Integer);
begin
  if ReadBufferSize = FMaxReadBufferSize then
    exit;
  CheckNotActive;
  FMaxReadBufferSize := ReadBufferSize;
end;

procedure TF5TCPServer.SetWriteBufferSize(const WriteBufferSize: Integer);
begin
  if WriteBufferSize = FMaxWriteBufferSize then
    exit;
  CheckNotActive;
  FMaxWriteBufferSize := WriteBufferSize;
end;

{$IFDEF TCPSERVER_TLS}
procedure TF5TCPServer.SetTLSEnabled(const TLSEnabled: Boolean);
begin
  if TLSEnabled = FTLSEnabled then
    exit;
  CheckNotActive;
  FTLSEnabled := TLSEnabled;
  {$IFDEF TCP_DEBUG_TLS}
  Log(tlDebug, 'TLSEnabled:%d', [Ord(TLSEnabled)]);
  {$ENDIF}
end;
{$ENDIF}

procedure TF5TCPServer.SetUseWorkerThread(const UseWorkerThread: Boolean);
begin
  if UseWorkerThread = FUseWorkerThread then
    exit;
  CheckNotActive;
  FUseWorkerThread := UseWorkerThread;
end;

procedure TF5TCPServer.TriggerStart;
begin
  if Assigned(FOnStart) then
    FOnStart(self);
end;

procedure TF5TCPServer.TriggerStop;
begin
  if Assigned(FOnStop) then
    FOnStop(self);
end;

procedure TF5TCPServer.TriggerThreadIdle(const Thread: TTCPServerThread);
begin
  if Assigned(FOnThreadIdle) then
    FOnThreadIdle(self, Thread)
  else
    if Thread.FTask = sttProcess then
      Sleep(1)
    else
      Sleep(10);
end;

procedure TF5TCPServer.ServerSocketLog(Sender: TSysSocket; LogType: TSysSocketLogType; Msg: String);
begin
  {$IFDEF TCP_DEBUG_SOCKET}
  Log(tlDebug, 'ServerSocket:%s', [Msg], 1);
  {$ENDIF}
end;

procedure TF5TCPServer.ClientLog(const Client: TTCPServerClient; const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer);
begin
  Assert(Assigned(Client));
  {$IFDEF TCP_DEBUG}
  Log(LogType, 'Client[%d]:%s', [Client.ClientID, LogMsg], LogLevel + 1);
  {$ENDIF}
end;

procedure TF5TCPServer.TriggerClientAccept(const Address: TSocketAddr; var AcceptClient: Boolean);
begin
  if Assigned(FOnClientAccept) then
    FOnClientAccept(self, Address, AcceptClient);
end;

procedure TF5TCPServer.TriggerClientNameLookup(const Address: TSocketAddr; const HostName: RawByteString; var AcceptClient: Boolean);
begin
  if Assigned(FOnClientNameLookup) then
    FOnClientNameLookup(self, Address, HostName, AcceptClient);
end;

procedure TF5TCPServer.TriggerClientCreate(const Client: TTCPServerClient);
begin
  if Assigned(FOnClientCreate) then
    try
      FOnClientCreate(Client);
    except
      {$IFDEF TCP_DEBUG} raise; {$ELSE}
      on E : Exception do LogException('Error in ClientCreate handler: %s', E); {$ENDIF}
    end;
end;

procedure TF5TCPServer.TriggerClientAdd(const Client: TTCPServerClient);
begin
  if Assigned(FOnClientAdd) then
    try
      FOnClientAdd(Client);
    except
      {$IFDEF TCP_DEBUG} raise; {$ELSE}
      on E : Exception do LogException('Error in ClientAdd handler: %s', E); {$ENDIF}
    end;
end;

procedure TF5TCPServer.TriggerClientRemove(const Client: TTCPServerClient);
begin
  if Assigned(FOnClientRemove) then
    try
      FOnClientRemove(Client);
    except
      {$IFDEF TCP_DEBUG} raise; {$ELSE}
      on E : Exception do LogException('Error in ClientRemove handler: %s', E); {$ENDIF}
    end;
end;

procedure TF5TCPServer.TriggerClientDestroy(const Client: TTCPServerClient);
begin
  if Assigned(FOnClientDestroy) then
    try
      FOnClientDestroy(Client);
    except
      {$IFDEF TCP_DEBUG} raise; {$ELSE}
      on E : Exception do LogException('Error in ClientDestroy handler: %s', E); {$ENDIF}
    end;
end;

procedure TF5TCPServer.TriggerClientStateChange(const Client: TTCPServerClient);
begin
  if Assigned(FOnClientStateChange) then
    FOnClientStateChange(Client);
end;

procedure TF5TCPServer.TriggerClientNegotiating(const Client: TTCPServerClient);
begin
  if Assigned(FOnClientNegotiating) then
    FOnClientNegotiating(Client);
end;

procedure TF5TCPServer.TriggerClientConnected(const Client: TTCPServerClient);
begin
  if Assigned(FOnClientConnected) then
    FOnClientConnected(Client);
end;

procedure TF5TCPServer.TriggerClientReady(const Client: TTCPServerClient);
begin
  if Assigned(FOnClientReady) then
    FOnClientReady(Client);
end;

procedure TF5TCPServer.TriggerClientRead(const Client: TTCPServerClient);
begin
  if Assigned(FOnClientRead) then
    FOnClientRead(Client);
end;

procedure TF5TCPServer.TriggerClientWrite(const Client: TTCPServerClient);
begin
  if Assigned(FOnClientWrite) then
    FOnClientWrite(Client);
end;

procedure TF5TCPServer.TriggerClientClose(const Client: TTCPServerClient);
begin
  if Assigned(FOnClientClose) then
    FOnClientClose(Client);
end;

procedure TF5TCPServer.TriggerClientWorkerExecute(const Client: TTCPServerClient;
          const Connection: TTCPBlockingConnection; var CloseOnExit: Boolean);
begin
  if Assigned(FOnClientWorkerExecute) then
    FOnClientWorkerExecute(Client, Connection, CloseOnExit);
end;

procedure TF5TCPServer.SetReady;
begin
  SetState(ssReady);
end;

procedure TF5TCPServer.SetClosed;
begin
  SetState(ssClosed);
end;

procedure TF5TCPServer.DoCloseClients;
var
  C : TTCPServerClient;
begin
  C := FClientList.FFirst;
  while Assigned(C) do
    begin
      C.Close;
      C := C.FNext;
    end;
end;

procedure TF5TCPServer.DoCloseServer;
begin
  if Assigned(FServerSocket) then
    FServerSocket.CloseSocket;
end;

procedure TF5TCPServer.DoClose;
begin
  DoCloseServer;
  DoCloseClients;
  SetClosed;
end;

{$IFDEF TCPSERVER_TLS}
procedure TF5TCPServer.TLSServerTransportLayerSendProc(Server: TTLSServer; Client: TTLSServerClient; const Buffer; const Size: Integer);
var Proxy : TTCPServerClientTLSConnectionProxy;
begin
  Assert(Assigned(Client.UserObj));
  Assert(Client.UserObj is TTCPServerClientTLSConnectionProxy);

  Proxy := TTCPServerClientTLSConnectionProxy(Client.UserObj);
  Proxy.TLSClientTransportLayerSendProc(Client, Buffer, Size);
end;
{$ENDIF}

procedure TF5TCPServer.StartControlThread;
begin
  Assert(not Assigned(FControlThread));
  FControlThread := TTCPServerThread.Create(self, sttControl);
end;

procedure TF5TCPServer.StartProcessThread;
begin
  Assert(not Assigned(FProcessThread));
  FProcessThread := TTCPServerThread.Create(self, sttProcess);
end;

procedure TF5TCPServer.StopServerThreads;
begin
  if Assigned(FProcessThread) then
    begin
      FProcessThread.Terminate;
      FProcessThread.WaitFor;
    end;
  if Assigned(FControlThread) then
    begin
      FControlThread.Terminate;
      FControlThread.WaitFor;
    end;
  FreeAndNil(FProcessThread);
  FreeAndNil(FControlThread);
end;

procedure TF5TCPServer.DoStart;
begin
  Assert(not FActive);
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Starting');
  {$ENDIF}
  TriggerStart;
  FActive := True;
  SetState(ssStarting);
  {$IFDEF TCPSERVER_TLS}
  if FTLSEnabled then
    FTLSServer.Start;
  {$ENDIF}
  StartControlThread;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Started');
  {$ENDIF}
end;

procedure TF5TCPServer.DoStop;

  procedure RemoveAllClients(const List: TTCPServerClientList);
  var
    Iter, Next : TTCPServerClient;
  begin
    Iter := List.First;
    while Assigned(Iter) do
      begin
        Next := Iter.FNext;
        TriggerClientRemove(Iter);
        List.Remove(Iter);
        if Iter.FReferenceCount = 0 then
          begin
            TriggerClientDestroy(Iter);
            Iter.Free;
          end
        else
          Iter.SetClientOrphaned;
        Iter := Next;
      end;
  end;

var
  Iter : TTCPServerClient;
begin
  Assert(FActive);
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Stopping');
  {$ENDIF}
  TriggerStop;
  StopServerThreads;
  Iter := FClientList.First;
  while Assigned(Iter) do
    begin
      Iter.TerminateWorkerThread;
      Iter := Iter.FNext;
    end;
  DoClose;
  {$IFDEF TCPSERVER_TLS}
  if FTLSEnabled then
    FTLSServer.Stop;
  {$ENDIF}
  RemoveAllClients(FClientTerminatedList);
  RemoveAllClients(FClientList);
  FreeAndNil(FServerSocket);
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Stopped');
  {$ENDIF}
  FActive := False;
end;

function TF5TCPServer.CreateClient(const SocketHandle: TSocketHandle; const SocketAddr: TSocketAddr): TTCPServerClient;
var
  ClientId : Int64;
begin
  Inc(FClientIDCounter);
  ClientId := FClientIDCounter;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'CreateClient(ID:%d,Handle:%d)', [ClientId, Ord(SocketHandle)]);
  {$ENDIF}
  Result := TTCPServerClient.Create(self, SocketHandle, ClientId, SocketAddr);
end;

function TF5TCPServer.CanAcceptClient: Boolean;
var M : Integer;
begin
  Lock;
  try
    M := FMaxClients;
    if M < 0 then // no limit
      Result := True else
    if M = 0 then // paused
      Result := False
    else
      Result := FClientList.Count < M;
  finally
    Unlock;
  end;
end;

function TF5TCPServer.ServerAcceptClient: Boolean;
var AcceptAddr   : TSocketAddr;
    AcceptSocket : TSocketHandle;
    AcceptClient : Boolean;
    Client       : TTCPServerClient;
begin
  // accept socket
  AcceptSocket := FServerSocket.Accept(AcceptAddr);
  if AcceptSocket = INVALID_SOCKETHANDLE then
    begin
      Result := False;
      exit;
    end;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, Format('IncommingConnection(%s:%d)', [
      SocketAddrIPStrA(AcceptAddr),
      AcceptAddr.Port]));
  {$ENDIF}
  AcceptClient := True;
  // check whitelist/blacklist
  Lock;
  try
    if Length(FWhitelist) > 0 then
      if not SocketAddrArrayHasAddr(FWhitelist, AcceptAddr) then
        AcceptClient := False;
    if AcceptClient then
      if SocketAddrArrayHasAddr(FBlacklist, AcceptAddr) then
        AcceptClient := False;
  finally
    Unlock;
  end;
  TriggerClientAccept(AcceptAddr, AcceptClient);
  if not AcceptClient then
    begin
      SocketClose(AcceptSocket);
      Result := False;
      exit;
    end;
  // create, add and start new client
  Lock;
  try
    Client := CreateClient(AcceptSocket, AcceptAddr);
    Client.Connection.UseWorkerThread := FUseWorkerThread;
  finally
    Unlock;
  end;
  try
    Client.Connection.Socket.SetBlocking(False);
  except
    Client.Free;
    raise;
  end;
  TriggerClientCreate(Client);
  Lock;
  try
    FClientList.Add(Client);
    Client.Start;
  finally
    Unlock;
  end;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'ClientAdded');
  {$ENDIF}
  TriggerClientAdd(Client);
  Result := True;
end;

function TF5TCPServer.ServerDropClient: Boolean;
var
  ItCnt, ClCnt : Integer;
  Iter : TTCPServerClient;
  DropCl : TTCPServerClient;
begin
  // find terminated client to free
  Lock;
  try
    DropCl := nil;
    ClCnt := FClientTerminatedList.Count;
    Iter := FClientTerminatedList.First;
    for ItCnt := 0 to ClCnt - 1 do
      begin
        if Iter.FReferenceCount = 0 then
          begin
            DropCl := Iter;
            FClientTerminatedList.Remove(DropCl);
            break;
          end;
        Iter := Iter.FNext;
      end;
  finally
    Unlock;
  end;
  if not Assigned(DropCl) then
    begin
      // no client to drop
      Result := False;
      exit;
    end;
  // notify and free client
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'ClientDestroy');
  {$ENDIF}
  TriggerClientDestroy(DropCl);
  DropCl.Free;
  Result := True;
end;

function TF5TCPServer.ProcessClientFromList(const List: TTCPServerClientList;
         var Iter: TTCPServerClient; var ItCnt: Integer;
         out ClientIdle, ClientTerminated: Boolean): Boolean;
var
  ClCnt : Integer;
  Cl, It, ProcCl : TTCPServerClient;
  ClSt : TTCPServerClientState;
  ClFr : Boolean;
begin
  Lock;
  try
    ClCnt := List.Count;
    ProcCl := nil;
    It := Iter;
    repeat
      Inc(ItCnt);
      if ItCnt > ClCnt then
        begin
          Result := False;
          exit;
        end;
      if not Assigned(It) then
        It := List.First;
      Cl := It;
      It := It.FNext;
      if not Cl.FTerminated then
        begin
          ProcCl := Cl;
          // add reference to client to prevent removal while processing
          ProcCl.AddReference;
        end;
    until Assigned(ProcCl);
    Iter := It;
  finally
    Unlock;
  end;
  try
    ProcCl.Process(ClientIdle, ClientTerminated);
  finally
    ProcCl.ReleaseReference;
  end;
  if ClientTerminated then
    begin
      ProcCl.TerminateWorkerThread;
      Lock;
      try
        ClSt := ProcCl.State;
        ClFr := ProcCl.FReferenceCount = 0;
        List.Remove(ProcCl);
        if not ClFr then
          FClientTerminatedList.Add(ProcCl);
      finally
        Unlock;
      end;
      if ClSt = scsReady then
        begin
          ProcCl.SetState(scsClosed);
          TriggerClientClose(ProcCl);
        end;
      TriggerClientRemove(ProcCl);
      if ClFr then
        begin
          TriggerClientDestroy(ProcCl);
          ProcCl.Free;
        end;
    end;
  Result := True;
end;

function TF5TCPServer.ServerProcessClient: Boolean;
var
  ItCnt : Integer;
  ClientIdle, ClientTerminated : Boolean;
begin
  ItCnt := 0;
  repeat
    if not ProcessClientFromList(FClientList, FIteratorProcess, ItCnt,
        ClientIdle, ClientTerminated) then
      begin
        Result := False;
        exit;
      end;
  until not ClientIdle;
  Result := True;
end;

// The control thread handles accepting new clients and removing deleted client
// A single instance of the control thread executes
procedure TF5TCPServer.ControlThreadExecute(const Thread: TTCPServerThread);

  function IsTerminated: Boolean;
  begin
    Result := Thread.Terminated;
  end;

var
  IsIdle : Boolean;
begin
  {$IFDEF TCP_DEBUG_THREAD}
  Log(tlDebug, 'ControlThreadExecute');
  {$ENDIF}
  Assert(FState = ssStarting);
  Assert(not Assigned(FServerSocket));
  Assert(Assigned(Thread));
  if IsTerminated then
    exit;
  // initialise server socket
  FBindAddress := ResolveHost(FBindAddressStr, FAddressFamily);
  SetSocketAddrPort(FBindAddress, FServerPort);
  if IsTerminated then
    exit;
  FServerSocket := TSysSocket.Create(FAddressFamily, ipTCP, False, INVALID_SOCKETHANDLE);
  try
    {$IFDEF TCP_DEBUG}
    FServerSocket.OnLog := ServerSocketLog;
    {$ENDIF}
    FServerSocket.SetBlocking(True);
    FServerSocket.Bind(FBindAddress);
    FServerSocket.Listen(FMaxBacklog);
  except
    FreeAndNil(FServerSocket);
    SetState(ssFailure);
    raise;
  end;
  if IsTerminated then
    exit;
  // server socket ready
  FServerSocket.SetBlocking(False);
  SetReady;
  StartProcessThread;
  // loop until thread termination
  while not IsTerminated do
    begin
      IsIdle := True;
      // drop terminated client
      if ServerDropClient then
        IsIdle := False;
      // accept new client
      if IsTerminated then
        break;
      if CanAcceptClient then
        if ServerAcceptClient then
          IsIdle := False;
      // sleep if idle
      if IsTerminated then
        break;
      if IsIdle then
        TriggerThreadIdle(Thread);
    end;
end;

// The processing thread handles processing of client sockets
// Event handlers are called from this thread
// A single instance of the processing thread executes
procedure TF5TCPServer.ProcessThreadExecute(const Thread: TTCPServerThread);

  function IsTerminated: Boolean;
  begin
    Result := Thread.Terminated;
  end;

var
  IsIdle : Boolean;
begin
  {$IFDEF TCP_DEBUG_THREAD}
  Log(tlDebug, 'ProcessThreadExecute');
  {$ENDIF}
  Assert(FState = ssReady);
  Assert(Assigned(Thread));
  if IsTerminated then
    exit;
  // loop until thread termination
  while not IsTerminated do
    begin
      // process clients
      IsIdle := True;
      if ServerProcessClient then
        IsIdle := False;
      // sleep if idle
      if IsTerminated then
        break;
      if IsIdle then
        TriggerThreadIdle(Thread);
    end;
end;

procedure TF5TCPServer.ThreadError(const Thread: TTCPServerThread; const Error: Exception);
begin
  Log(tlError, Format('ThreadError(Task:%d,%s,%s)', [Ord(Thread.FTask), Error.ClassName, Error.Message]));
end;

procedure TF5TCPServer.ThreadTerminate(const Thread: TTCPServerThread);
begin
  {$IFDEF TCP_DEBUG_THREAD}
  Log(tlDebug, Format('ThreadTerminate(Task:%d)', [Ord(Thread.FTask)]));
  {$ENDIF}
end;

procedure TF5TCPServer.Start;
begin
  if FActive then
    exit;
  DoStart;
end;

procedure TF5TCPServer.Stop;
begin
  if not FActive then
    exit;
  DoStop;
end;

function TF5TCPServer.GetActiveClientCount: Integer;
var
  N : Integer;
  C : TTCPServerClient;
begin
  Lock;
  try
    N := 0;
    C := FClientList.FFirst;
    while Assigned(C) do
      begin
        if not C.FTerminated and (C.FState in [scsNegotiating, scsReady]) then
          Inc(N);
        C := C.FNext;
      end;
  finally
    Unlock;
  end;
  Result := N;
end;

function TF5TCPServer.GetClientCount: Integer;
begin
  Lock;
  try
    Result := FClientList.Count;
  finally
    Unlock;
  end;
end;

function TF5TCPServer.ClientIterateFirst: TTCPServerClient;
var
  C : TTCPServerClient;
begin
  Lock;
  try
    C := FClientList.FFirst;
    // add reference to prevent removal of client
    // caller must call C.ReleaseReference
    C.AddReference;
  finally
    Unlock;
  end;
  Result := C;
end;

function TF5TCPServer.ClientIterateNext(const C: TTCPServerClient): TTCPServerClient;
var
  N : TTCPServerClient;
begin
  Lock;
  try
    N := C.FNext;
    if Assigned(N) then
      // add reference to prevent removal of client
      // caller must call C.ReleaseReference
      N.AddReference;
  finally
    Unlock;
  end;
  Result := N;
end;

function TF5TCPServer.GetReadRate: Int64;
var
  R : Int64;
  C : TTCPServerClient;
begin
  Lock;
  try
    R := 0;
    C := FClientList.FFirst;
    while Assigned(C) do
      begin
        if not C.FTerminated and (C.FState = scsReady) then
          Inc(R, C.Connection.ReadRate);
        C := C.FNext;
      end;
  finally
    Unlock;
  end;
  Result := R;
end;

function TF5TCPServer.GetWriteRate: Int64;
var
  R : Int64;
  C : TTCPServerClient;
begin
  Lock;
  try
    R := 0;
    C := FClientList.FFirst;
    while Assigned(C) do
      begin
        if not C.FTerminated and (C.FState = scsReady) then
          Inc(R, C.Connection.WriteRate);
        C := C.FNext;
      end;
  finally
    Unlock;
  end;
  Result := R;
end;

procedure TF5TCPServer.AddWhitelistAddr(const Addr: TSocketAddr);
begin
  Lock;
  try
    SocketAddrArrayAppend(FWhitelist, Addr);
  finally
    Unlock;
  end
end;

procedure TF5TCPServer.AddBlacklistAddr(const Addr: TSocketAddr);
begin
  Lock;
  try
    SocketAddrArrayAppend(FBlacklist, Addr);
  finally
    Unlock;
  end;
end;



end.

