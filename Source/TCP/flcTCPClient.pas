{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcTCPClient.pas                                         }
{   File version:     5.19                                                     }
{   Description:      TCP client.                                              }
{                                                                              }
{   Copyright:        Copyright (c) 2007-2019, David J Butler                  }
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
{   2008/08/15  0.01  Initial development.                                     }
{   2010/11/07  0.02  Revision.                                                }
{   2010/11/12  0.03  Refactor for asynchronous operation.                     }
{   2010/12/02  0.04  TLS support.                                             }
{   2010/12/20  0.05  Various enhancements.                                    }
{   2011/04/22  0.06  Thread safe Start/Stop.                                  }
{   2011/06/18  0.07  IsConnected, IsConnectionClosed, etc.                    }
{   2011/06/25  0.08  Improved logging.                                        }
{   2011/09/03  4.09  Revise for Fundamentals 4.                               }
{   2011/09/10  4.10  Synchronised events option.                              }
{   2011/10/06  4.11  Remove wait condition on startup.                        }
{   2011/11/07  4.12  Allow client to be restarted after being stopped.        }
{                     Added WaitForStartup property to optionally enable       }
{                     waiting for thread initialisation.                       }
{   2015/04/26  4.13  Blocking interface and worker thread.                    }
{   2015/04/27  4.14  Options to retry failed connections.                     }
{   2016/01/09  5.15  Revised for Fundamentals 5.                              }
{   2018/07/19  5.16  ReconnectOnDisconnect property.                          }
{   2018/08/30  5.17  Close socket before thread shutdown to prevent blocking. }
{   2018/09/01  5.18  Handle client stopping in process thread.                }
{   2018/12/31  5.19  OnActivity events.                                       }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 10.2 Win32                   5.18  2018/09/10                       }
{   Delphi 10.2 Win64                   5.18  2018/09/10                       }
{   Delphi 10.2 Linux64                 5.18  2018/09/10                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE flcTCP.inc}

unit flcTCPClient;

interface

uses
  { System }
  {$IFDEF OS_MSWIN}
  Messages,
  Windows,
  {$ENDIF}
  SysUtils,
  SyncObjs,
  Classes,
  { Sockets }
  flcSocketLib,
  flcSocket,
  { TCP }
  flcTCPConnection
  { Socks }
  {$IFDEF TCPCLIENT_SOCKS},
  flcSocksClient
  {$ENDIF}
  { TLS }
  {$IFDEF TCPCLIENT_TLS},
  flcTLSUtils,
  flcTLSConnection,
  flcTLSClient
  {$ENDIF}
  { WebSocket }
  {$IFDEF TCPCLIENT_WEBSOCKET},
  flcWebSocketUtils,
  flcWebSocketConnection,
  flcWebSocketClient
  {$ENDIF}
  ;



{                                                                              }
{ TCP Client                                                                   }
{                                                                              }
type
  ETCPClient = class(Exception);

  TTCPClientState = (
    csInit,           // Client initialise
    csStarting,       // Client starting (thread starting up)
    csStarted,        // Client activated (thread running)
    csConnectRetry,   // Client retrying connection
    csResolvingLocal, // Local IP resolving
    csResolvedLocal,  // Local IP resolved
    csBound,          // Local IP bound
    csResolving,      // IP resolving
    csResolved,       // IP resolved
    csConnecting,     // TCP connecting
    csConnected,      // TCP connected
    csNegotiating,    // Connection proxy negotiation
    csReady,          // Client ready, connection negotiated and ready
    csClosed,         // Connection closed
    csStopped         // Client stopped
    );
  TTCPClientStates = set of TTCPClientState;

  TTCPClientLogType = (
    cltDebug,
    cltInfo,
    cltError);

  TTCPClientAddressFamily = (
    cafIP4,
    cafIP6);

  {$IFDEF TCPCLIENT_TLS}
  TTCPClientTLSOption = (
    ctoDisableSSL3,
    ctoDisableTLS10,
    ctoDisableTLS11,
    ctoDisableTLS12,
    ctoDisableKeyExchangeRSA);

  TTCPClientTLSOptions = set of TTCPClientTLSOption;
  {$ENDIF}

  TF5TCPClient = class;

  TTCPClientNotifyEvent = procedure (Client: TF5TCPClient) of object;
  TTCPClientLogEvent = procedure (Client: TF5TCPClient; LogType: TTCPClientLogType; Msg: String; LogLevel: Integer) of object;
  TTCPClientStateEvent = procedure (Client: TF5TCPClient; State: TTCPClientState) of object;
  TTCPClientErrorEvent = procedure (Client: TF5TCPClient; ErrorMsg: String; ErrorCode: Integer) of object;
  TTCPClientWorkerExecuteEvent = procedure (Client: TF5TCPClient; Connection: TTCPBlockingConnection; var CloseOnExit: Boolean) of object;

  TSyncProc = procedure of object;

  TTCPClientProcessThread = class(TThread)
  protected
    FTCPClient : TF5TCPClient;
    procedure Execute; override;
  public
    constructor Create(const TCPClient: TF5TCPClient);
    property Terminated;
  end;

  TF5TCPClient = class(TComponent)
  protected
    // parameters
    FAddressFamily      : TTCPClientAddressFamily;
    FHost               : String;
    FPort               : String;
    FLocalHost          : String;
    FLocalPort          : String;

    FRetryFailedConnect            : Boolean;
    FRetryFailedConnectDelaySec    : Integer;
    FRetryFailedConnectMaxAttempts : Integer;
    FReconnectOnDisconnect         : Boolean;

    {$IFDEF TCPCLIENT_SOCKS}
    FSocksEnabled       : Boolean;
    FSocksHost          : RawByteString;
    FSocksPort          : RawByteString;
    FSocksAuth          : Boolean;
    FSocksUsername      : RawByteString;
    FSocksPassword      : RawByteString;
    {$ENDIF}

    {$IFDEF TCPCLIENT_TLS}
    FTLSEnabled         : Boolean;
    FTLSOptions         : TTCPClientTLSOptions;
    {$ENDIF}

    {$IFDEF TCPCLIENT_WEBSOCKET}
    FWebSocketEnabled   : Boolean;
    FWebSocketURI       : RawByteString;
    FWebSocketOrigin    : RawByteString;
    FWebSocketProtocol  : RawByteString;
    {$ENDIF}

    FUseWorkerThread    : Boolean;

    FSynchronisedEvents : Boolean;
    FWaitForStartup     : Boolean;

    FTrackLastActivityTime : Boolean;

    FUserTag            : NativeInt;
    FUserObject         : TObject;

    // event handlers
    FOnLog               : TTCPClientLogEvent;
    FOnError             : TTCPClientErrorEvent;
    FOnStart             : TTCPClientNotifyEvent;
    FOnStop              : TTCPClientNotifyEvent;
    FOnActive            : TTCPClientNotifyEvent;
    FOnInactive          : TTCPClientNotifyEvent;
    FOnProcessThreadIdle : TTCPClientNotifyEvent;
    FOnStateChanged      : TTCPClientStateEvent;
    FOnStarted           : TTCPClientNotifyEvent;
    FOnConnected         : TTCPClientNotifyEvent;
    FOnConnectFailed     : TTCPClientNotifyEvent;
    FOnNegotiating       : TTCPClientNotifyEvent;
    FOnReady             : TTCPClientNotifyEvent;
    FOnRead              : TTCPClientNotifyEvent;
    FOnWrite             : TTCPClientNotifyEvent;
    FOnReadActivity      : TTCPClientNotifyEvent;
    FOnWriteActivity     : TTCPClientNotifyEvent;
    FOnClose             : TTCPClientNotifyEvent;
    FOnStopped           : TTCPClientNotifyEvent;
    FOnMainThreadWait    : TTCPClientNotifyEvent;
    FOnThreadWait        : TTCPClientNotifyEvent;
    FOnWorkerExecute     : TTCPClientWorkerExecuteEvent;

    // state
    FLock              : TCriticalSection;
    FState             : TTCPClientState;
    FIsStopping        : Boolean;
    FProcessThread     : TTCPClientProcessThread;
    FErrorMsg          : String;
    FErrorCode         : Integer;
    FActive            : Boolean;
    FActivateOnLoaded  : Boolean;
    FIPAddressFamily   : TIPAddressFamily;
    FSocket            : TSysSocket;
    FLocalAddr         : TSocketAddr;
    FConnectAddr       : TSocketAddr;
    FConnection        : TTCPConnection;
    FSyncListLog       : TList;

    {$IFDEF TCPCLIENT_TLS}
    FTLSProxy          : TTCPConnectionProxy;
    FTLSClient         : TTLSClient;
    {$ENDIF}

    {$IFDEF TCPCLIENT_SOCKS}
    FSocksResolvedAddr : TSocketAddr;
    {$ENDIF}

    {$IFDEF TCPCLIENT_WEBSOCKET}
    FWebSocketProxy    : TTCPConnectionProxy;
    {$ENDIF}

  protected
    procedure Init; virtual;
    procedure InitDefaults; virtual;

    procedure Synchronize(const SyncProc: TSyncProc);

    procedure SyncLog;
    procedure Log(const LogType: TTCPClientLogType; const Msg: String; const LogLevel: Integer = 0); overload;
    procedure Log(const LogType: TTCPClientLogType; const Msg: String; const Args: array of const; const LogLevel: Integer = 0); overload;

    procedure Lock;
    procedure Unlock;

    function  GetState: TTCPClientState;
    function  GetStateStr: String;
    procedure SetState(const State: TTCPClientState);

    procedure CheckNotActive;
    procedure CheckActive;

    procedure SetAddressFamily(const AddressFamily: TTCPClientAddressFamily);
    procedure SetHost(const Host: String);
    procedure SetPort(const Port: String);
    function  GetPortInt: Integer;
    procedure SetPortInt(const PortInt: Integer);
    procedure SetLocalHost(const LocalHost: String);
    procedure SetLocalPort(const LocalPort: String);

    procedure SetRetryFailedConnect(const RetryFailedConnect: Boolean);
    procedure SetRetryFailedConnectDelaySec(const RetryFailedConnectDelaySec: Integer);
    procedure SetRetryFailedConnectMaxAttempts(const RetryFailedConnectMaxAttempts: Integer);
    procedure SetReconnectOnDisconnect(const ReconnectOnDisconnect: Boolean);

    {$IFDEF TCPCLIENT_SOCKS}
    procedure SetSocksProxy(const SocksProxy: Boolean);
    procedure SetSocksHost(const SocksHost: RawByteString);
    procedure SetSocksPort(const SocksPort: RawByteString);
    procedure SetSocksAuth(const SocksAuth: Boolean);
    procedure SetSocksUsername(const SocksUsername: RawByteString);
    procedure SetSocksPassword(const SocksPassword: RawByteString);
    {$ENDIF}

    {$IFDEF TCPCLIENT_TLS}
    procedure SetTLSEnabled(const TLSEnabled: Boolean);
    procedure SetTLSOptions(const TLSOptions: TTCPClientTLSOptions);
    {$ENDIF}

    {$IFDEF TCPCLIENT_WEBSOCKET}
    procedure SetWebSocketEnabled(const WebSocketEnabled: Boolean);
    procedure SetWebSocketURI(const WebSocketURI: RawByteString);
    procedure SetWebSocketOrigin(const WebSocketOrigin: RawByteString);
    procedure SetWebSocketProtocol(const WebSocketProtocol: RawByteString);
    {$ENDIF}

    procedure SetUseWorkerThread(const UseWorkerThread: Boolean);

    procedure SetSynchronisedEvents(const SynchronisedEvents: Boolean);
    procedure SetWaitForStartup(const WaitForStartup: Boolean);

    procedure SetActive(const Active: Boolean);
    procedure Loaded; override;

    procedure SyncTriggerError;
    procedure SyncTriggerStateChanged;
    procedure SyncTriggerStart;
    procedure SyncTriggerStop;
    procedure SyncTriggerActive;
    procedure SyncTriggerInactive;
    procedure SyncTriggerStarted;
    procedure SyncTriggerConnected;
    procedure SyncTriggerNegotiating;
    procedure SyncTriggerConnectFailed;
    procedure SyncTriggerReady;
    procedure SyncTriggerRead;
    procedure SyncTriggerWrite;
    procedure SyncTriggerReadActivity;
    procedure SyncTriggerWriteActivity;
    procedure SyncTriggerClose;
    procedure SyncTriggerStopped;

    procedure TriggerError; virtual;
    procedure TriggerStateChanged; virtual;
    procedure TriggerStart; virtual;
    procedure TriggerStop; virtual;
    procedure TriggerActive; virtual;
    procedure TriggerInactive; virtual;
    procedure TriggerProcessThreadIdle; virtual;
    procedure TriggerStarted; virtual;
    procedure TriggerConnected; virtual;
    procedure TriggerNegotiating; virtual;
    procedure TriggerConnectFailed; virtual;
    procedure TriggerReady; virtual;
    procedure TriggerRead; virtual;
    procedure TriggerWrite; virtual;
    procedure TriggerReadActivity; virtual;
    procedure TriggerWriteActivity; virtual;
    procedure TriggerClose; virtual;
    procedure TriggerStopped; virtual;

    procedure SetError(const ErrorMsg: String; const ErrorCode: Integer);
    procedure SetStarted;
    procedure SetConnected;
    procedure SetNegotiating;
    procedure SetReady;
    procedure SetClosed;
    procedure SetStopped;

    procedure SocketLog(Sender: TSysSocket; LogType: TSysSocketLogType; Msg: String);

    procedure ConnectionLog(Sender: TTCPConnection; LogType: TTCPLogType; LogMsg: String; LogLevel: Integer);
    procedure ConnectionStateChange(Sender: TTCPConnection; State: TTCPConnectionState);
    procedure ConnectionRead(Sender: TTCPConnection);
    procedure ConnectionWrite(Sender: TTCPConnection);
    procedure ConnectionReadActivity(Sender: TTCPConnection);
    procedure ConnectionWriteActivity(Sender: TTCPConnection);
    procedure ConnectionClose(Sender: TTCPConnection);

    procedure ConnectionWorkerExecute(Sender: TTCPConnection;
              Connection: TTCPBlockingConnection; var CloseOnExit: Boolean);

    {$IFDEF TCPCLIENT_TLS}
    procedure InstallTLSProxy;
    function  GetTLSClient: TTLSClient;
    {$ENDIF}

    {$IFDEF TCPCLIENT_SOCKS}
    procedure InstallSocksProxy;
    {$ENDIF}

    {$IFDEF TCPCLIENT_WEBSOCKET}
    procedure InstallWebSocketProxy;
    {$ENDIF}

    function  GetConnection: TTCPConnection;
    procedure CreateConnection;
    procedure FreeConnection;

    function  GetBlockingConnection: TTCPBlockingConnection;

    procedure DoResolveLocal;
    procedure DoBind;
    procedure DoResolve;
    procedure DoConnect;
    procedure DoClose;

    procedure StartThread;
    procedure StopThread;
    {$IFDEF OS_MSWIN}
    function  ProcessMessage(var MsgTerminated: Boolean): Boolean;
    {$ENDIF}
    procedure ThreadExecute(const Thread: TTCPClientProcessThread);

    procedure TerminateWorkerThread;

    procedure DoStart;
    procedure DoStop;

    procedure Wait; virtual;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Finalise;

    // Parameters
    property  AddressFamily: TTCPClientAddressFamily read FAddressFamily write SetAddressFamily default cafIP4;
    property  Host: String read FHost write SetHost;
    property  Port: String read FPort write SetPort;
    property  PortInt: Integer read GetPortInt write SetPortInt;
    property  LocalHost: String read FLocalHost write SetLocalHost;
    property  LocalPort: String read FLocalPort write SetLocalPort;

    // Connect retry
    // If RetryFailedConnect if True, a failed connection attempt will be
    // retried RetryFailedConnectMaxAttempts times after waiting
    // RetryFailedConnectDelaySec seconds between retries.
    // If RetryFailedConnectMaxAttempts is -1, the connection will be retried
    // until the client is stopped.
    // If ReconnectOnDisconnect is True, a connect will automatically be
    // initiated after an established connection is disconnected.
    property  RetryFailedConnect: Boolean read FRetryFailedConnect write SetRetryFailedConnect default False;
    property  RetryFailedConnectDelaySec: Integer read FRetryFailedConnectDelaySec write SetRetryFailedConnectDelaySec default 60;
    property  RetryFailedConnectMaxAttempts: Integer read FRetryFailedConnectMaxAttempts write SetRetryFailedConnectMaxAttempts default -1;
    property  ReconnectOnDisconnect: Boolean read FReconnectOnDisconnect write SetReconnectOnDisconnect default False;

    // Socks
    {$IFDEF TCPCLIENT_SOCKS}
    property  SocksEnabled: Boolean read FSocksEnabled write SetSocksProxy default False;
    property  SocksHost: RawByteString read FSocksHost write SetSocksHost;
    property  SocksPort: RawByteString read FSocksPort write SetSocksPort;
    property  SocksAuth: Boolean read FSocksAuth write SetSocksAuth default False;
    property  SocksUsername: RawByteString read FSocksUsername write SetSocksUsername;
    property  SocksPassword: RawByteString read FSocksPassword write SetSocksPassword;
    {$ENDIF}

    // TLS
    {$IFDEF TCPCLIENT_TLS}
    property  TLSEnabled: Boolean read FTLSEnabled write SetTLSEnabled default False;
    property  TLSOptions: TTCPClientTLSOptions read FTLSOptions write SetTLSOptions default [ctoDisableSSL3];
    {$ENDIF}

    // WebSocket
    {$IFDEF TCPCLIENT_WEBSOCKET}
    property  WebSocketEnabled: Boolean read FWebSocketEnabled write SetWebSocketEnabled default False;
    property  WebSocketURI: RawByteString read FWebSocketURI write SetWebSocketURI;
    property  WebSocketOrigin: RawByteString read FWebSocketOrigin write SetWebSocketOrigin;
    property  WebSocketProtocol: RawByteString read FWebSocketProtocol write SetWebSocketProtocol;
    {$ENDIF}

    // When SynchronisedEvents is set, events handlers are called in the main thread
    // through the TThread.Synchronise mechanism.
    // When SynchronisedEvents is not set, events handlers will be called from
    // an external thread. In this case event handler should handle their own
    // synchronisation if required.
    property  SynchronisedEvents: Boolean read FSynchronisedEvents write SetSynchronisedEvents default False;

    property  TrackLastActivityTime: Boolean read FTrackLastActivityTime write FTrackLastActivityTime default True;

    property  OnLog: TTCPClientLogEvent read FOnLog write FOnLog;
    property  OnError: TTCPClientErrorEvent read FOnError write FOnError;
    property  OnStart: TTCPClientNotifyEvent read FOnStart write FOnStart;
    property  OnStop: TTCPClientNotifyEvent read FOnStop write FOnStop;
    property  OnActive: TTCPClientNotifyEvent read FOnActive write FOnActive;
    property  OnInactive: TTCPClientNotifyEvent read FOnInactive write FOnInactive;
    property  OnProcessThreadIdle: TTCPClientNotifyEvent read FOnProcessThreadIdle write FOnProcessThreadIdle;
    property  OnStateChanged: TTCPClientStateEvent read FOnStateChanged write FOnStateChanged;
    property  OnStarted: TTCPClientNotifyEvent read FOnStarted write FOnStarted;
    property  OnConnected: TTCPClientNotifyEvent read FOnConnected write FOnConnected;
    property  OnConnectFailed: TTCPClientNotifyEvent read FOnConnectFailed write FOnConnectFailed;
    property  OnNegotiating: TTCPClientNotifyEvent read FOnNegotiating write FOnNegotiating;
    property  OnReady: TTCPClientNotifyEvent read FOnReady write FOnReady;
    property  OnRead: TTCPClientNotifyEvent read FOnRead write FOnRead;
    property  OnWrite: TTCPClientNotifyEvent read FOnWrite write FOnWrite;
    property  OnReadActivity: TTCPClientNotifyEvent read FOnReadActivity write FOnReadActivity;
    property  OnWriteActivity: TTCPClientNotifyEvent read FOnWriteActivity write FOnWriteActivity;
    property  OnClose: TTCPClientNotifyEvent read FOnClose write FOnClose;
    property  OnStopped: TTCPClientNotifyEvent read FOnStopped write FOnStopped;

    // state
    property  State: TTCPClientState read GetState;
    property  StateStr: String read GetStateStr;

    function  IsConnecting: Boolean;
    function  IsConnectingOrConnected: Boolean;
    function  IsConnected: Boolean;
    function  IsConnectionClosed: Boolean;
    function  IsStopping: Boolean;

    // When WaitForStartup is set, the call to Start or Active := True will only return
    // when the thread has started and the Connection property is available.
    // This option is usally only needed in a non-GUI application.
    // Note:
    // When this is set to True in a GUI application with SynchronisedEvents True,
    // the OnMainThreadWait handler must call Application.ProcessMessages otherwise
    // blocking conditions may occur.
    property  WaitForStartup: Boolean read FWaitForStartup write SetWaitForStartup default False;

    property  Active: Boolean read FActive write SetActive default False;
    procedure Start;
    procedure Stop;

    property  ErrorMessage: String read FErrorMsg;
    property  ErrorCode: Integer read FErrorCode;

    // TLS
    {$IFDEF TCPCLIENT_TLS}
    property  TLSClient: TTLSClient read GetTLSClient;
    procedure StartTLS;
    {$ENDIF}

    // The Connection property is only available when the client is active,
    // when not active it is nil.
    property  Connection: TTCPConnection read GetConnection;

    // The BlockingConnection can be used in the worker thread for blocking
    // operations.
    // Note: These BlockingConnection should not be used from this object's
    // event handlers.
    property  BlockingConnection: TTCPBlockingConnection read GetBlockingConnection;

    // Worker thread
    // When UseWorkerThread is True, the client will have a worker thread
    // created when it is in the Ready state. OnWorkerExecute will
    // be called where the client can use the blocking connection interface.
    property  UseWorkerThread: Boolean read FUseWorkerThread write SetUseWorkerThread default False;
    property  OnWorkerExecute: TTCPClientWorkerExecuteEvent read FOnWorkerExecute write FOnWorkerExecute;

    // Wait events
    // Called by wait loops in this class (WaitForStartup, WaitForState)
    // When blocking occurs in the main thread, OnMainThreadWait is called.
    // When blocking occurs in another thread, OnThreadWait is called.
    // Usually the handler for OnMainThreadWait calls Application.ProcessMessages.
    property  OnMainThreadWait: TTCPClientNotifyEvent read FOnMainThreadWait write FOnMainThreadWait;
    property  OnThreadWait: TTCPClientNotifyEvent read FOnThreadWait write FOnThreadWait;

    // Blocking helpers
    // These functions will block until a result is available or timeout expires.
    // If TimeOut is set to -1 the function may wait indefinetely for result.
    // Note: These functions should not be called from this object's event handlers.
    function  WaitForState(const States: TTCPClientStates; const TimeOutMs: Integer): TTCPClientState;
    function  WaitForConnect(const TimeOutMs: Integer): Boolean;
    function  WaitForClose(const TimeOutMs: Integer): Boolean;

    // User defined values
    property  UserTag: NativeInt read FUserTag write FUserTag;
    property  UserObject: TObject read FUserObject write FUserObject;
  end;



{                                                                              }
{ Component                                                                    }
{                                                                              }
type
  TfclTCPClient = class(TF5TCPClient)
  published
    property  Active;
    property  AddressFamily;
    property  Host;
    property  Port;
    property  LocalHost;
    property  LocalPort;

    property  RetryFailedConnect;
    property  RetryFailedConnectDelaySec;
    property  RetryFailedConnectMaxAttempts;
    property  ReconnectOnDisconnect;

    {$IFDEF TCPCLIENT_SOCKS}
    property  SocksHost;
    property  SocksPort;
    property  SocksAuth;
    property  SocksUsername;
    property  SocksPassword;
    {$ENDIF}

    {$IFDEF TCPCLIENT_TLS}
    property  TLSEnabled;
    property  TLSOptions;
    {$ENDIF}

    {$IFDEF TCPCLIENT_WEBSOCKET}
    property  WebSocketEnabled;
    property  WebSocketURI;
    property  WebSocketOrigin;
    property  WebSocketProtocol;
    {$ENDIF}

    property  SynchronisedEvents;
    property  WaitForStartup;

    property  OnLog;
    property  OnError;
    property  OnStart;
    property  OnStop;
    property  OnActive;
    property  OnInactive;
    property  OnProcessThreadIdle;
    property  OnStateChanged;
    property  OnStarted;
    property  OnConnected;
    property  OnConnectFailed;
    property  OnNegotiating;
    property  OnReady;
    property  OnRead;
    property  OnWrite;
    property  OnClose;
    property  OnStopped;

    property  UseWorkerThread;
    property  OnWorkerExecute;

    property  OnThreadWait;
    property  OnMainThreadWait;

    property  UserTag;
    property  UserObject;
  end;



implementation

uses
  { Fundamentals }
  flcStdTypes;



{                                                                              }
{ Error and debug strings                                                      }
{                                                                              }
const
  SError_NotAllowedWhileActive   = 'Operation not allowed while active';
  SError_NotAllowedWhileInactive = 'Operation not allowed while inactive';
  SError_TLSNotActive            = 'TLS not active';
  SError_ProxyNotReady           = 'Proxy not ready';
  SError_InvalidParameter        = 'Invalid parameter';
  SError_StartupFailed           = 'Startup failed';
  SError_HostNotSpecified        = 'Host not specified';
  SError_PortNotSpecified        = 'Port not specified';
  SError_Terminated              = 'Terminated';
  SError_TimedOut                = 'Timed out';

  SClientState : array[TTCPClientState] of String = (
      'Initialise',
      'Starting',
      'Started',
      'Connect retry',
      'Resolving local',
      'Resolved local',
      'Bound',
      'Resolving',
      'Resolved',
      'Connecting',
      'Connected',
      'Negotiating proxy',
      'Ready',
      'Closed',
      'Stopped');



{                                                                              }
{ TCP Client State                                                             }
{                                                                              }
const
  TCPClientStates_All = [
      csInit,
      csStarting,
      csStarted,
      csConnectRetry,
      csResolvingLocal,
      csResolvedLocal,
      csBound,
      csResolving,
      csResolved,
      csConnecting,
      csConnected,
      csNegotiating,
      csReady,
      csClosed,
      csStopped
  ];

  TCPClientStates_Connecting = [
      csStarting,
      csStarted,
      csConnectRetry,
      csResolvingLocal,
      csResolvedLocal,
      csBound,
      csResolving,
      csResolved,
      csConnecting,
      csConnected,
      csNegotiating
  ];

  TCPClientStates_ConnectingOrConnected =
      TCPClientStates_Connecting + [
      csReady
  ];

  TCPClientStates_Connected = [
      csReady
  ];

  TCPClientStates_Closed = [
      csInit,
      csClosed,
      csStopped
  ];



{                                                                              }
{ TCP Client Socks Connection Proxy                                            }
{                                                                              }
{$IFDEF TCPCLIENT_SOCKS}
type
  TTCPClientSocksConnectionProxy = class(TTCPConnectionProxy)
  private
    FTCPClient   : TF5TCPClient;
    FSocksClient : TSocksClient;

    procedure SocksClientClientWrite(const Client: TSocksClient; const Buf; const BufSize: Integer);

  public
    class function ProxyName: String; override;
    
    constructor Create(const TCPClient: TF5TCPClient);
    destructor Destroy; override;

    procedure ProxyStart; override;
    procedure ProcessReadData(const Buf; const BufSize: Integer); override;
    procedure ProcessWriteData(const Buf; const BufSize: Integer); override;
  end;

class function TTCPClientSocksConnectionProxy.ProxyName: String;
begin
  Result := 'Socks';
end;

constructor TTCPClientSocksConnectionProxy.Create(const TCPClient: TF5TCPClient);
begin
  Assert(Assigned(TCPClient));
  inherited Create(TCPClient.Connection);
  FTCPClient := TCPClient;
  FSocksClient := TSocksClient.Create;
  FSocksClient.OnClientWrite := SocksClientClientWrite;
end;

destructor TTCPClientSocksConnectionProxy.Destroy;
begin
  FreeAndNil(FSocksClient);
  inherited Destroy;
end;

procedure TTCPClientSocksConnectionProxy.ProxyStart;
begin
  SetState(prsNegotiating);
  // initialise socks client parameters
  FSocksClient.SocksVersion := scvSocks5;
  case FTCPClient.FSocksResolvedAddr.AddrFamily of
    iaIP4 :
      begin
        FSocksClient.AddrType := scaIP4;
        FSocksClient.AddrIP4  := FTCPClient.FSocksResolvedAddr.AddrIP4;
      end;
    iaIP6 :
      begin
        FSocksClient.AddrType := scaIP6;
        FSocksClient.AddrIP6  := FTCPClient.FSocksResolvedAddr.AddrIP6;
      end;
  else
    raise ETCPClient.Create(SError_InvalidParameter);
  end;
  FSocksClient.AddrPort := FTCPClient.FSocksResolvedAddr.Port;
  if FTCPClient.SocksAuth then
    begin
      FSocksClient.AuthMethod := scamSocks5UserPass;
      FSocksClient.UserID     := FTCPClient.FSocksUsername;
      FSocksClient.Password   := FTCPClient.FSocksPassword;
    end
  else
    FSocksClient.AuthMethod := scamNone;
  // connect
  FSocksClient.Connect;
end;

procedure TTCPClientSocksConnectionProxy.SocksClientClientWrite(const Client: TSocksClient; const Buf; const BufSize: Integer);
begin
  ConnectionPutWriteData(Buf, BufSize);
end;

procedure TTCPClientSocksConnectionProxy.ProcessReadData(const Buf; const BufSize: Integer);
begin
  // check if negotiation completed previously
  case FSocksClient.ReqState of
    scrsSuccess : ConnectionPutReadData(Buf, BufSize); // pass data to connection
    scrsFailed  : ;
  else
    // pass data to socks client
    FSocksClient.ClientData(Buf, BufSize);
    // check completion
    case FSocksClient.ReqState of
      scrsSuccess : SetState(prsFinished);
      scrsFailed  : SetState(prsError);
    end;
  end;
end;

procedure TTCPClientSocksConnectionProxy.ProcessWriteData(const Buf; const BufSize: Integer);
begin
  if FSocksClient.ReqState <> scrsSuccess then
    raise ETCPClient.Create(SError_ProxyNotReady);
  ConnectionPutWriteData(Buf, BufSize);
end;
{$ENDIF}



{                                                                              }
{ TCP Client TLS Connection Proxy                                              }
{                                                                              }
{$IFDEF TCPCLIENT_TLS}
type
  TTCPClientTLSConnectionProxy = class(TTCPConnectionProxy)
  private
    FTCPClient : TF5TCPClient;
    FTLSClient : TTLSClient;

    procedure TLSClientTransportLayerSendProc(const Sender: TTLSConnection; const Buffer; const Size: Integer);
    procedure TLSClientLog(Sender: TTLSConnection; LogType: TTLSLogType; LogMsg: String; LogLevel: Integer);
    procedure TLSClientStateChange(Sender: TTLSConnection; State: TTLSConnectionState);

  public
    class function ProxyName: String; override;

    constructor Create(const TCPClient: TF5TCPClient);
    destructor Destroy; override;

    procedure ProxyStart; override;
    procedure ProcessReadData(const Buf; const BufSize: Integer); override;
    procedure ProcessWriteData(const Buf; const BufSize: Integer); override;
  end;

class function TTCPClientTLSConnectionProxy.ProxyName: String;
begin
  Result := 'TLS';
end;

function TCPClientTLSOptionsToTLSOptions(A: TTCPClientTLSOptions): TTLSClientOptions;
var TLSOpts : TTLSClientOptions;
begin
  TLSOpts := [];
  if ctoDisableSSL3 in A then
    Include(TLSOpts, tlscoDisableSSL3);
  if ctoDisableTLS10 in A then
    Include(TLSOpts, tlscoDisableTLS10);
  if ctoDisableTLS11 in A then
    Include(TLSOpts, tlscoDisableTLS11);
  if ctoDisableTLS12 in A then
    Include(TLSOpts, tlscoDisableTLS12);
  if ctoDisableKeyExchangeRSA in A then
    Include(TLSOpts, tlscoDisableKeyExchangeRSA);
  Result := TLSOpts;
end;

constructor TTCPClientTLSConnectionProxy.Create(const TCPClient: TF5TCPClient);
begin
  Assert(Assigned(TCPClient));

  inherited Create(TCPClient.FConnection);
  FTCPClient := TCPClient;
  FTLSClient := TTLSClient.Create(TLSClientTransportLayerSendProc);
  FTLSClient.OnLog := TLSClientLog;
  FTLSClient.OnStateChange := TLSClientStateChange;
  FTLSClient.ClientOptions := TCPClientTLSOptionsToTLSOptions(FTCPClient.FTLSOptions);
end;

destructor TTCPClientTLSConnectionProxy.Destroy;
begin
  FreeAndNil(FTLSClient);
  inherited Destroy;
end;

procedure TTCPClientTLSConnectionProxy.ProxyStart;
begin
  SetState(prsNegotiating);
  FTLSClient.Start;
end;

procedure TTCPClientTLSConnectionProxy.TLSClientTransportLayerSendProc(const Sender: TTLSConnection; const Buffer; const Size: Integer);
begin
  ConnectionPutWriteData(Buffer, Size);
end;

procedure TTCPClientTLSConnectionProxy.TLSClientLog(Sender: TTLSConnection; LogType: TTLSLogType; LogMsg: String; LogLevel: Integer);
begin
  {$IFDEF TCP_DEBUG_TLS}
  Log(tlDebug, 'TLS:%s', [LogMsg], LogLevel + 1);
  {$ENDIF}
end;

procedure TTCPClientTLSConnectionProxy.TLSClientStateChange(Sender: TTLSConnection; State: TTLSConnectionState);
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

procedure TTCPClientTLSConnectionProxy.ProcessReadData(const Buf; const BufSize: Integer);
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

procedure TTCPClientTLSConnectionProxy.ProcessWriteData(const Buf; const BufSize: Integer);
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(tlDebug, 'ProcessWriteData:%db', [BufSize]);
  {$ENDIF}
  FTLSClient.Write(Buf, BufSize);
end;
{$ENDIF}



{                                                                              }
{ TCP Client WebSocket Connection Proxy                                        }
{                                                                              }
{$IFDEF TCPCLIENT_WEBSOCKET}
type
  TTCPClientWebSocketConnectionProxy = class(TTCPConnectionProxy)
  private
    FTCPClient : TF5TCPClient;
    FWebSocketClient : TWebSocketClient;

    procedure WebSocketConnectionTransportLayerSendProc(const Sender: TWebSocketConnection; const Buffer; const Size: Integer);
    procedure WebSocketClientLog(Sender: TWebSocketConnection; LogType: TWebSocketLogType; LogMsg: String; LogLevel: Integer);

  public
    class function ProxyName: String; override;

    constructor Create(const TCPClient: TF5TCPClient);
    destructor Destroy; override;

    procedure ProxyStart; override;
    procedure ProcessReadData(const Buf; const BufSize: Integer); override;
    procedure ProcessWriteData(const Buf; const BufSize: Integer); override;
  end;

class function TTCPClientWebSocketConnectionProxy.ProxyName: String;
begin
  Result := 'WebSocket';
end;

constructor TTCPClientWebSocketConnectionProxy.Create(const TCPClient: TF5TCPClient);
begin
  Assert(Assigned(TCPClient));

  inherited Create(TCPClient.FConnection);
  FTCPClient := TCPClient;
  FWebSocketClient := TWebSocketClient.Create(WebSocketConnectionTransportLayerSendProc);
  FWebSocketClient.OnLog := WebSocketClientLog;
end;

destructor TTCPClientWebSocketConnectionProxy.Destroy;
begin
  FreeAndNil(FWebSocketClient);
  inherited Destroy;
end;

procedure TTCPClientWebSocketConnectionProxy.WebSocketConnectionTransportLayerSendProc(const Sender: TWebSocketConnection; const Buffer; const Size: Integer);
begin
  ConnectionPutWriteData(Buffer, Size);
end;

procedure TTCPClientWebSocketConnectionProxy.WebSocketClientLog(Sender: TWebSocketConnection; LogType: TWebSocketLogType; LogMsg: String; LogLevel: Integer);
begin
  {$IFDEF TCP_DEBUG_WEBSOCKET}
  Log(tlDebug, 'WebSocket:%s', [LogMsg], LogLevel + 1);
  {$ENDIF}
end;

procedure TTCPClientWebSocketConnectionProxy.ProxyStart;
begin
  SetState(prsNegotiating);
  FWebSocketClient.Host := FTCPClient.FHost;
  FWebSocketClient.URI := FTCPClient.FWebSocketURI;
  FWebSocketClient.Origin := FTCPClient.FWebSocketOrigin;
  FWebSocketClient.WebSocketProtocol := FTCPClient.FWebSocketProtocol;
  FWebSocketClient.Start;
end;

procedure TTCPClientWebSocketConnectionProxy.ProcessReadData(const Buf; const BufSize: Integer);
const
  ReadBufSize = 65536;
var
  ReadBuf : array[0..ReadBufSize - 1] of Byte;
  L : Integer;
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(tlDebug, 'ProcessReadData:%db', [BufSize]);
  {$ENDIF}
  FWebSocketClient.ProcessTransportLayerReceivedData(Buf, BufSize);
  repeat
    L := FWebSocketClient.AvailableToRead;
    if L > ReadBufSize then
      L := ReadBufSize;
    if L > 0 then
      begin
        L := FWebSocketClient.Read(ReadBuf, L);
        if L > 0 then
          ConnectionPutReadData(ReadBuf, L);
      end;
  until L <= 0;
end;

procedure TTCPClientWebSocketConnectionProxy.ProcessWriteData(const Buf; const BufSize: Integer);
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(tlDebug, 'ProcessWriteData:%db', [BufSize]);
  {$ENDIF}
  FWebSocketClient.Write(Buf, BufSize);
end;
{$ENDIF}



{                                                                              }
{ TTCPClientProcessThread                                                      }
{                                                                              }
constructor TTCPClientProcessThread.Create(const TCPClient: TF5TCPClient);
begin
  Assert(Assigned(TCPClient));
  FTCPClient := TCPClient;
  FreeOnTerminate := False;
  inherited Create(False);
end;

procedure TTCPClientProcessThread.Execute;
begin
  Assert(Assigned(FTCPClient));
  FTCPClient.ThreadExecute(self);
  FTCPClient := nil;
end;



{                                                                              }
{ TTCPClient                                                                   }
{                                                                              }
constructor TF5TCPClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Init;
end;

procedure TF5TCPClient.Init;
begin
  FState := csInit;
  FActivateOnLoaded := False;
  FLock := TCriticalSection.Create;
  InitDefaults;
end;

procedure TF5TCPClient.InitDefaults;
begin
  FActive := False;
  FAddressFamily := cafIP4;
  FRetryFailedConnect := False;
  FRetryFailedConnectDelaySec := 60;
  FRetryFailedConnectMaxAttempts := -1;
  FReconnectOnDisconnect := False;
  {$IFDEF TCPCLIENT_SOCKS}
  FSocksEnabled := False;
  FSocksAuth := False;
  {$ENDIF}
  {$IFDEF TCPCLIENT_TLS}
  FTLSEnabled := False;
  FTLSOptions := [ctoDisableSSL3];
  {$ENDIF}
  {$IFDEF TCPCLIENT_WEBSOCKET}
  FWebSocketEnabled := False;
  FWebSocketURI := '/';
  {$ENDIF}
  FSynchronisedEvents := False;
  FWaitForStartup := False;
  FTrackLastActivityTime := True;
  FUseWorkerThread := False;
end;

destructor TF5TCPClient.Destroy;
begin
  Finalise;
  inherited Destroy;
end;

procedure TF5TCPClient.Finalise;
var I : Integer;
begin
  if Assigned(FProcessThread) then
    begin
      FProcessThread.Terminate;
      FProcessThread.WaitFor;
      FreeAndNil(FProcessThread);
    end;
  if Assigned(FConnection) then
    begin
      FConnection.Finalise;
      FreeAndNil(FConnection);
    end;
  if Assigned(FSyncListLog) then
    begin
      for I := FSyncListLog.Count - 1 downto 0 do
        Dispose(FSyncListLog.Items[0]);
      FreeAndNil(FSyncListLog);
    end;
  if Assigned(FSocket) then
    begin
      FSocket.Finalise;
      FreeAndNil(FSocket);
    end;
  FreeAndNil(FLock);
end;

{ Synchronize }

procedure TF5TCPClient.Synchronize(const SyncProc: TSyncProc);
begin
  {$IFDEF DELPHI6_DOWN}
  {$IFDEF OS_MSWIN}
  if GetCurrentThreadID = MainThreadID then
    SyncProc
  else
  {$ENDIF}
  if Assigned(FProcessThread) then
    FProcessThread.Synchronize(SyncProc);
  {$ELSE}
  TThread.Synchronize(nil, SyncProc);
  {$ENDIF}
end;

{ Log }

type
  TTCPClientSyncLogData = record
    LogType  : TTCPClientLogType;
    LogMsg   : String;
    LogLevel : Integer;
  end;
  PTCPClientSyncLogData = ^TTCPClientSyncLogData;

procedure TF5TCPClient.SyncLog;
var SyncRec : PTCPClientSyncLogData;
begin
  if csDestroying in ComponentState then
    exit;
  Lock;
  try
    Assert(Assigned(FSyncListLog));
    Assert(FSyncListLog.Count > 0);
    SyncRec := FSyncListLog.Items[0];
    FSyncListLog.Delete(0);
  finally
    Unlock;
  end;
  if Assigned(FOnLog) then
    FOnLog(self, SyncRec.LogType, SyncRec.LogMsg, SyncRec.LogLevel);
  Dispose(SyncRec);
end;

procedure TF5TCPClient.Log(const LogType: TTCPClientLogType; const Msg: String; const LogLevel: Integer);
var SyncRec : PTCPClientSyncLogData;
begin
  if Assigned(FOnLog) then
    if FSynchronisedEvents {$IFDEF OS_MSWIN}and (GetCurrentThreadID <> MainThreadID){$ENDIF} then
      begin
        New(SyncRec);
        SyncRec.LogType := LogType;
        SyncRec.LogMsg := Msg;
        SyncRec.LogLevel := LogLevel;
        Lock;
        try
          if not Assigned(FSyncListLog) then
            FSyncListLog := TList.Create;
          FSyncListLog.Add(SyncRec);
        finally
          Unlock;
        end;
        Synchronize(SyncLog);
      end
    else
      FOnLog(self, LogType, Msg, LogLevel);
end;

procedure TF5TCPClient.Log(const LogType: TTCPClientLogType; const Msg: String;
    const Args: array of const; const LogLevel: Integer);
begin
  Log(LogType, Format(Msg, Args), LogLevel);
end;

{ Lock }

procedure TF5TCPClient.Lock;
begin
  if Assigned(FLock) then
    FLock.Acquire;
end;

procedure TF5TCPClient.Unlock;
begin
  if Assigned(FLock) then
    FLock.Release;
end;

{ State }

function TF5TCPClient.GetState: TTCPClientState;
begin
  Lock;
  try
    Result := FState;
  finally
    Unlock;
  end;
end;

function TF5TCPClient.GetStateStr: String;
begin
  Result := SClientState[GetState];
end;

procedure TF5TCPClient.SetState(const State: TTCPClientState);
begin
  Lock;
  try
    Assert(State <> FState);
    FState := State;
  finally
    Unlock;
  end;
  TriggerStateChanged;
end;

procedure TF5TCPClient.CheckNotActive;
begin
  if not (csDesigning in ComponentState) then
    if FActive then
      raise ETCPClient.Create(SError_NotAllowedWhileActive);
end;

procedure TF5TCPClient.CheckActive;
begin
  if not FActive then
    raise ETCPClient.Create(SError_NotAllowedWhileInactive);
end;

{ Property setters }

procedure TF5TCPClient.SetAddressFamily(const AddressFamily: TTCPClientAddressFamily);
begin
  if AddressFamily = FAddressFamily then
    exit;
  CheckNotActive;
  FAddressFamily := AddressFamily;
end;

procedure TF5TCPClient.SetHost(const Host: String);
begin
  if Host = FHost then
    exit;
  CheckNotActive;
  FHost := Host;
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'Host:%s', [Host]);
  {$ENDIF}
end;

procedure TF5TCPClient.SetPort(const Port: String);
begin
  if Port = FPort then
    exit;
  CheckNotActive;
  FPort := Port;
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'Port:%s', [Port]);
  {$ENDIF}
end;

function TF5TCPClient.GetPortInt: Integer;
begin
  Result := StrToIntDef(FPort, -1)
end;

procedure TF5TCPClient.SetPortInt(const PortInt: Integer);
begin
  SetPort(IntToStr(PortInt));
end;

procedure TF5TCPClient.SetLocalHost(const LocalHost: String);
begin
  if LocalHost = FLocalHost then
    exit;
  CheckNotActive;
  FLocalHost := LocalHost;
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'LocalHost:%s', [LocalHost]);
  {$ENDIF}
end;

procedure TF5TCPClient.SetLocalPort(const LocalPort: String);
begin
  if LocalPort = FLocalPort then
    exit;
  CheckNotActive;
  FLocalPort := LocalPort;
end;

procedure TF5TCPClient.SetRetryFailedConnect(const RetryFailedConnect: Boolean);
begin
  if RetryFailedConnect = FRetryFailedConnect then
    exit;
  CheckNotActive;
  FRetryFailedConnect := RetryFailedConnect;
end;

procedure TF5TCPClient.SetRetryFailedConnectDelaySec(const RetryFailedConnectDelaySec: Integer);
begin
  if RetryFailedConnectDelaySec = FRetryFailedConnectDelaySec then
    exit;
  CheckNotActive;
  FRetryFailedConnectDelaySec := RetryFailedConnectDelaySec;
end;

procedure TF5TCPClient.SetRetryFailedConnectMaxAttempts(const RetryFailedConnectMaxAttempts: Integer);
begin
  if RetryFailedConnectMaxAttempts = FRetryFailedConnectMaxAttempts then
    exit;
  CheckNotActive;
  FRetryFailedConnectMaxAttempts := RetryFailedConnectMaxAttempts;
end;

procedure TF5TCPClient.SetReconnectOnDisconnect(const ReconnectOnDisconnect: Boolean);
begin
  if ReconnectOnDisconnect = FReconnectOnDisconnect then
    exit;
  CheckNotActive;
  FReconnectOnDisconnect := ReconnectOnDisconnect;
end;

{$IFDEF TCPCLIENT_SOCKS}
procedure TF5TCPClient.SetSocksProxy(const SocksProxy: Boolean);
begin
  if SocksProxy = FSocksEnabled then
    exit;
  CheckNotActive;
  FSocksEnabled := SocksProxy;
end;

procedure TF5TCPClient.SetSocksHost(const SocksHost: RawByteString);
begin
  if SocksHost = FSocksHost then
    exit;
  CheckNotActive;
  FSocksHost := SocksHost;
end;

procedure TF5TCPClient.SetSocksPort(const SocksPort: RawByteString);
begin
  if SocksPort = FSocksPort then
    exit;
  CheckNotActive;
  FSocksHost := SocksHost;
end;

procedure TF5TCPClient.SetSocksAuth(const SocksAuth: Boolean);
begin
  if SocksAuth = FSocksAuth then
    exit;
  CheckNotActive;
  FSocksAuth := SocksAuth;
end;

procedure TF5TCPClient.SetSocksUsername(const SocksUsername: RawByteString);
begin
  if SocksUsername = FSocksUsername then
    exit;
  CheckNotActive;
  FSocksUsername := SocksUsername;
end;

procedure TF5TCPClient.SetSocksPassword(const SocksPassword: RawByteString);
begin
  if SocksPassword = FSocksPassword then
    exit;
  CheckNotActive;
  FSocksPassword := SocksPassword;
end;
{$ENDIF}

{$IFDEF TCPCLIENT_TLS}
procedure TF5TCPClient.SetTLSEnabled(const TLSEnabled: Boolean);
begin
  if TLSEnabled = FTLSEnabled then
    exit;
  CheckNotActive;
  FTLSEnabled := TLSEnabled;
  {$IFDEF TCP_DEBUG_TLS}
  Log(cltDebug, 'TLSEnabled:%d', [Ord(TLSEnabled)]);
  {$ENDIF}
end;

procedure TF5TCPClient.SetTLSOptions(const TLSOptions: TTCPClientTLSOptions);
begin
  if TLSOptions = FTLSOptions then
    exit;
  CheckNotActive;
  FTLSOptions := TLSOptions;
end;
{$ENDIF}

{$IFDEF TCPCLIENT_WEBSOCKET}
procedure TF5TCPClient.SetWebSocketEnabled(const WebSocketEnabled: Boolean);
begin
  if WebSocketEnabled = FWebSocketEnabled then
    exit;
  CheckNotActive;
  FWebSocketEnabled := WebSocketEnabled;
  {$IFDEF TCP_DEBUG_WEBSOCKET}
  Log(cltDebug, 'WebSocketEnabled:%d', [Ord(WebSocketEnabled)]);
  {$ENDIF}
end;

procedure TF5TCPClient.SetWebSocketURI(const WebSocketURI: RawByteString);
begin
  if WebSocketURI = FWebSocketURI then
    exit;
  CheckNotActive;
  FWebSocketURI := WebSocketURI;
end;

procedure TF5TCPClient.SetWebSocketOrigin(const WebSocketOrigin: RawByteString);
begin
  if WebSocketOrigin = FWebSocketOrigin then
    exit;
  CheckNotActive;
  FWebSocketOrigin := WebSocketOrigin;
end;

procedure TF5TCPClient.SetWebSocketProtocol(const WebSocketProtocol: RawByteString);
begin
  if WebSocketProtocol = FWebSocketProtocol then
    exit;
  CheckNotActive;
  FWebSocketProtocol := WebSocketProtocol;
end;
{$ENDIF}

procedure TF5TCPClient.SetUseWorkerThread(const UseWorkerThread: Boolean);
begin
  if UseWorkerThread = FUseWorkerThread then
    exit;
  CheckNotActive;
  FUseWorkerThread := UseWorkerThread;
end;

procedure TF5TCPClient.SetSynchronisedEvents(const SynchronisedEvents: Boolean);
begin
  if SynchronisedEvents = FSynchronisedEvents then
    exit;
  CheckNotActive;
  FSynchronisedEvents := SynchronisedEvents;
end;

procedure TF5TCPClient.SetWaitForStartup(const WaitForStartup: Boolean);
begin
  if WaitForStartup = FWaitForStartup then
    exit;
  CheckNotActive;
  FWaitForStartup := WaitForStartup;
end;

procedure TF5TCPClient.SetActive(const Active: Boolean);
begin
  if csDesigning in ComponentState then
    FActive := Active else
  if csLoading in ComponentState then
    FActivateOnLoaded := Active
  else
    if Active then
      DoStart
    else
      DoStop;
end;

procedure TF5TCPClient.Loaded;
begin
  inherited Loaded;
  if FActivateOnLoaded then
    DoStart;
end;

{ SyncTrigger }

procedure TF5TCPClient.SyncTriggerError;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnError) then
    FOnError(self, FErrorMsg, FErrorCode);
end;

procedure TF5TCPClient.SyncTriggerStateChanged;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnStateChanged) then
    FOnStateChanged(self, FState);
end;

procedure TF5TCPClient.SyncTriggerStart;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnStart) then
    FOnStart(self);
end;

procedure TF5TCPClient.SyncTriggerStop;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnStop) then
    FOnStop(self);
end;

procedure TF5TCPClient.SyncTriggerActive;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnActive) then
    FOnActive(self);
end;

procedure TF5TCPClient.SyncTriggerInactive;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnInactive) then
    FOnInactive(self);
end;

procedure TF5TCPClient.SyncTriggerStarted;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnStarted) then
    FOnStarted(self);
end;

procedure TF5TCPClient.SyncTriggerConnected;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnConnected) then
    FOnConnected(self);
end;

procedure TF5TCPClient.SyncTriggerNegotiating;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnNegotiating) then
    FOnNegotiating(self);
end;

procedure TF5TCPClient.SyncTriggerConnectFailed;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnConnectFailed) then
    FOnConnectFailed(self);
end;

procedure TF5TCPClient.SyncTriggerReady;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnReady) then
    FOnReady(self);
end;

procedure TF5TCPClient.SyncTriggerRead;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnRead) then
    FOnRead(self);
end;

procedure TF5TCPClient.SyncTriggerWrite;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnWrite) then
    FOnWrite(self);
end;

procedure TF5TCPClient.SyncTriggerReadActivity;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnReadActivity) then
    FOnReadActivity(self);
end;

procedure TF5TCPClient.SyncTriggerWriteActivity;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnWriteActivity) then
    FOnWriteActivity(self);
end;

procedure TF5TCPClient.SyncTriggerClose;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnClose) then
    FOnClose(self);
end;

procedure TF5TCPClient.SyncTriggerStopped;
begin
  if csDestroying in ComponentState then
    exit;
  if Assigned(FOnStopped) then
    FOnStopped(self);
end;

{ Trigger }

procedure TF5TCPClient.TriggerError;
begin
  Log(cltError, 'Error:%d:%s', [FErrorCode, FErrorMsg]);
  if Assigned(FOnError) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerError)
    else
      FOnError(self, FErrorMsg, FErrorCode);
end;

procedure TF5TCPClient.TriggerStateChanged;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'State:%s', [GetStateStr]);
  {$ENDIF}
  if Assigned(FOnStateChanged) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerStateChanged)
    else
      FOnStateChanged(self, FState);
end;

procedure TF5TCPClient.TriggerStart;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'Start');
  {$ENDIF}
  if Assigned(FOnStart) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerStart)
    else
      FOnStart(self);
end;

procedure TF5TCPClient.TriggerStop;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'Stop');
  {$ENDIF}
  if Assigned(FOnStop) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerStop)
    else
      FOnStop(self);
end;

procedure TF5TCPClient.TriggerActive;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'Active');
  {$ENDIF}
  if Assigned(FOnActive) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerActive)
    else
      FOnActive(self);
end;

procedure TF5TCPClient.TriggerInactive;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'Inactive');
  {$ENDIF}
  if Assigned(FOnInactive) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerInactive)
    else
      FOnInactive(self);
end;

procedure TF5TCPClient.TriggerProcessThreadIdle;
begin
  if Assigned(FOnProcessThreadIdle) then
    FOnProcessThreadIdle(self);
  Sleep(1);
end;

procedure TF5TCPClient.TriggerStarted;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'Started');
  {$ENDIF}
  if Assigned(FOnStarted) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerStarted)
    else
      FOnStarted(self);
end;

procedure TF5TCPClient.TriggerConnected;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'Connected');
  {$ENDIF}
  if Assigned(FOnConnected) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerConnected)
    else
      FOnConnected(self);
end;

procedure TF5TCPClient.TriggerNegotiating;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'Negotiating');
  {$ENDIF}
  if Assigned(FOnNegotiating) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerNegotiating)
    else
      FOnNegotiating(self);
end;

procedure TF5TCPClient.TriggerConnectFailed;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'ConnectFailed');
  {$ENDIF}
  if Assigned(FOnConnectFailed) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerConnectFailed)
    else
      FOnConnectFailed(self);
end;

procedure TF5TCPClient.TriggerReady;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'Ready');
  {$ENDIF}
  if Assigned(FOnReady) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerReady)
    else
      FOnReady(self);
end;

procedure TF5TCPClient.TriggerRead;
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(cltDebug, 'Read');
  {$ENDIF}
  if Assigned(FOnRead) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerRead)
    else
      FOnRead(self);
end;

procedure TF5TCPClient.TriggerWrite;
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(cltDebug, 'Write');
  {$ENDIF}
  if Assigned(FOnWrite) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerWrite)
    else
      FOnWrite(self);
end;

procedure TF5TCPClient.TriggerReadActivity;
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(cltDebug, 'Activity');
  {$ENDIF}
  if Assigned(FOnReadActivity) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerReadActivity)
    else
      FOnReadActivity(self);
end;

procedure TF5TCPClient.TriggerWriteActivity;
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(cltDebug, 'Activity');
  {$ENDIF}
  if Assigned(FOnWriteActivity) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerWriteActivity)
    else
      FOnWriteActivity(self);
end;

procedure TF5TCPClient.TriggerClose;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'Close');
  {$ENDIF}
  if Assigned(FOnClose) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerClose)
    else
      FOnClose(self);
end;

procedure TF5TCPClient.TriggerStopped;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'Stopped');
  {$ENDIF}
  if Assigned(FOnStopped) then
    if FSynchronisedEvents then
      Synchronize(SyncTriggerStopped)
    else
      FOnStopped(self);
end;

{ SetStates }

procedure TF5TCPClient.SetError(const ErrorMsg: String; const ErrorCode: Integer);
begin
  FErrorMsg := ErrorMsg;
  FErrorCode := ErrorCode;
  TriggerError;
end;

procedure TF5TCPClient.SetStarted;
begin
  SetState(csStarted);
  TriggerStarted;
end;

procedure TF5TCPClient.SetConnected;
begin
  SetState(csConnected);
  TriggerConnected;
  FConnection.Start;
end;

procedure TF5TCPClient.SetNegotiating;
begin
  SetState(csNegotiating);
  TriggerNegotiating;
end;

procedure TF5TCPClient.SetReady;
begin
  SetState(csReady);
  TriggerReady;
end;

procedure TF5TCPClient.SetClosed;
begin
  if GetState in [csClosed, csStopped] then
    exit;
  SetState(csClosed);
  TriggerClose;
end;

procedure TF5TCPClient.SetStopped;
begin
  SetState(csStopped);
  TriggerStopped;
end;

{ Socket }

procedure TF5TCPClient.SocketLog(Sender: TSysSocket; LogType: TSysSocketLogType; Msg: String);
begin
  {$IFDEF TCP_DEBUG_SOCKET}
  Log(cltDebug, 'Socket:%s', [Msg], 10);
  {$ENDIF}
end;

{ Connection events }

procedure TF5TCPClient.ConnectionLog(Sender: TTCPConnection; LogType: TTCPLogType; LogMsg: String; LogLevel: Integer);
begin
  {$IFDEF TCP_DEBUG_CONNECTION}
  Log(cltDebug, 'Connection:%s', [LogMsg], LogLevel + 1);
  {$ENDIF}
end;

procedure TF5TCPClient.ConnectionStateChange(Sender: TTCPConnection; State: TTCPConnectionState);
begin
  {$IFDEF TCP_DEBUG_CONNECTION}
  Log(cltDebug, 'Connection_StateChange:%s', [Sender.StateStr]);
  {$ENDIF}
  case State of
    cnsProxyNegotiation : SetNegotiating;
    cnsConnected        : SetReady;
  end;
end;

procedure TF5TCPClient.ConnectionRead(Sender: TTCPConnection);
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(cltDebug, 'Connection_Read');
  {$ENDIF}
  TriggerRead;
end;

procedure TF5TCPClient.ConnectionWrite(Sender: TTCPConnection);
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(cltDebug, 'Connection_Write');
  {$ENDIF}
  TriggerWrite;
end;

procedure TF5TCPClient.ConnectionReadActivity(Sender: TTCPConnection);
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(cltDebug, 'Connection_ReadActivity');
  {$ENDIF}
  TriggerReadActivity;
end;

procedure TF5TCPClient.ConnectionWriteActivity(Sender: TTCPConnection);
begin
  {$IFDEF TCP_DEBUG_DATA}
  Log(cltDebug, 'Connection_WriteActivity');
  {$ENDIF}
  TriggerWriteActivity;
end;

procedure TF5TCPClient.ConnectionClose(Sender: TTCPConnection);
begin
  {$IFDEF TCP_DEBUG_CONNECTION}
  Log(cltDebug, 'Connection_Close');
  {$ENDIF}
  SetClosed;
end;

procedure TF5TCPClient.ConnectionWorkerExecute(Sender: TTCPConnection;
          Connection: TTCPBlockingConnection; var CloseOnExit: Boolean);
begin
  if Assigned(FOnWorkerExecute) then
    FOnWorkerExecute(self, Connection, CloseOnExit);
end;

{ Proxies }

{$IFDEF TCPCLIENT_TLS}
procedure TF5TCPClient.InstallTLSProxy;
var Proxy : TTCPClientTLSConnectionProxy;
begin
  {$IFDEF TCP_DEBUG_TLS}
  Log(cltDebug, 'InstallTLSProxy');
  {$ENDIF}
  Proxy := TTCPClientTLSConnectionProxy.Create(self);
  FTLSProxy := Proxy;
  FTLSClient := Proxy.FTLSClient;
  FConnection.AddProxy(Proxy);
end;

function TF5TCPClient.GetTLSClient: TTLSClient;
var C : TTLSClient;
begin
  C := FTLSClient;
  if not Assigned(C) then
    raise ETCPClient.Create(SError_TLSNotActive);
  Result := C;
end;
{$ENDIF}

{$IFDEF TCPCLIENT_SOCKS}
procedure TF5TCPClient.InstallSocksProxy;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'InstallSocksProxy');
  {$ENDIF}
  FConnection.AddProxy(TTCPClientSocksConnectionProxy.Create(self));
end;
{$ENDIF}

{$IFDEF TCPCLIENT_WEBSOCKET}
procedure TF5TCPClient.InstallWebSocketProxy;
begin
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'InstallWebSocketProxy');
  {$ENDIF}
  FConnection.AddProxy(TTCPClientWebSocketConnectionProxy.Create(self));
end;
{$ENDIF}

{ Connection }

function TF5TCPClient.GetConnection: TTCPConnection;
begin
  Result := FConnection;
end;

procedure TF5TCPClient.CreateConnection;
var AF : TIPAddressFamily;
begin
  Lock;
  try
    Assert(FActive);
    Assert(FState = csStarting);
    Assert(not Assigned(FSocket));
    Assert(not Assigned(FConnection));

    case FAddressFamily of
      cafIP4 : AF := iaIP4;
      cafIP6 : AF := iaIP6;
    else
      raise ETCPClient.Create('Invalid address family');
    end;
    FIPAddressFamily := AF;
    FSocket := TSysSocket.Create(AF, ipTCP, False, INVALID_SOCKETHANDLE);
    {$IFDEF TCP_DEBUG}
    FSocket.OnLog := SocketLog;
    {$ENDIF}

    FConnection := TTCPConnection.Create(FSocket);

    FConnection.OnLog           := ConnectionLog;
    FConnection.OnStateChange   := ConnectionStateChange;
    FConnection.OnClose         := ConnectionClose;
    FConnection.OnWorkerExecute := ConnectionWorkerExecute;

    if Assigned(FOnRead) then
      FConnection.OnRead := ConnectionRead;
    if Assigned(FOnWrite) then
      FConnection.OnWrite := ConnectionWrite;
    if Assigned(FOnReadActivity) then
      FConnection.OnReadActivity := ConnectionReadActivity;
    if Assigned(FOnWriteActivity) then
      FConnection.OnWriteActivity := ConnectionWriteActivity;

    FConnection.UseWorkerThread       := FUseWorkerThread;
    FConnection.TrackLastActivityTime := FTrackLastActivityTime;
  finally
    Unlock;
  end;

  {$IFDEF TCPCLIENT_SOCKS}
  if FSocksEnabled then
    InstallSocksProxy;
  {$ENDIF}

  {$IFDEF TCPCLIENT_TLS}
  if FTLSEnabled then
    InstallTLSProxy;
  {$ENDIF}

  {$IFDEF TCPCLIENT_WEBSOCKET}
  if FWebSocketEnabled then
    InstallWebSocketProxy;
  {$ENDIF}
end;

procedure TF5TCPClient.FreeConnection;
begin
  if Assigned(FConnection) then
    begin
      FConnection.Finalise;
      FreeAndNil(FConnection);
    end;
  if Assigned(FSocket) then
    begin
      FSocket.Finalise;
      FreeAndNil(FSocket);
    end;
end;

function TF5TCPClient.GetBlockingConnection: TTCPBlockingConnection;
begin
  if Assigned(FConnection) then
    Result := FConnection.BlockingConnection
  else
    Result := nil;
end;

{ Resolve }

procedure TF5TCPClient.DoResolveLocal;
var
  LocAddr : TSocketAddr;
begin
  Assert(FActive);
  Assert(FState in [csStarted, csConnectRetry, csClosed]);
  Assert(FHost <> '');
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'DoResolveLocal');
  {$ENDIF}

  SetState(csResolvingLocal);
  LocAddr := flcSocketLib.Resolve(FLocalHost, FLocalPort, FIPAddressFamily, ipTCP);
  Lock;
  try
    FLocalAddr := LocAddr;
  finally
    Unlock;
  end;
  SetState(csResolvedLocal);
end;

procedure TF5TCPClient.DoBind;
begin
  Assert(FActive);
  Assert(FState in [csResolvedLocal, csClosed]);
  Assert(Assigned(FSocket));
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'DoBind');
  {$ENDIF}
  if GetState = csClosed then
    raise ETCPClient.Create('Closed');
  FSocket.Bind(FLocalAddr);
  SetState(csBound);
end;

procedure TF5TCPClient.DoResolve;
var
  ConAddr : TSocketAddr;
begin
  Assert(FActive);
  Assert(FState in [csBound, csConnectRetry, csClosed]);
  Assert(FHost <> '');
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'DoResolve');
  {$ENDIF}

  Lock;
  try
    if FState = csClosed then
      raise ETCPClient.Create('Closed');
    SetState(csResolving);
  finally
    Unlock;
  end;
  ConAddr := flcSocketLib.Resolve(FHost, FPort, FIPAddressFamily, ipTCP);

  Lock;
  try
    {$IFDEF TCPCLIENT_SOCKS}
    if FState = csClosed then
      raise ETCPClient.Create('Closed');
    if FSocksEnabled then
      begin
        FSocksResolvedAddr := ConAddr;
        ConAddr := flcSocketLib.ResolveA(FSocksHost, FSocksPort, FIPAddressFamily, ipTCP);
      end
    else
      InitSocketAddrNone(FSocksResolvedAddr);
    {$ENDIF}
    FConnectAddr := ConAddr;
  finally
    Unlock;
  end;
  SetState(csResolved);
end;

{ Connect / Close }

procedure TF5TCPClient.DoConnect;
begin
  Assert(FActive);
  Assert(FState in [csResolved, csClosed, csStopped]);
  Assert(Assigned(FSocket));
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'DoConnect');
  {$ENDIF}

  Lock;
  try
    if FState = csClosed then
      raise ETCPClient.Create('Closed');
    SetState(csConnecting);
  finally
    Unlock;
  end;
  FSocket.Connect(FConnectAddr);
  SetConnected;
end;

procedure TF5TCPClient.DoClose;
begin
  Assert(Assigned(FSocket));
  Assert(Assigned(FConnection));
  {$IFDEF TCP_DEBUG}
  Log(cltDebug, 'DoClose');
  {$ENDIF}

  FConnection.Close;
  SetClosed;
end;

{ Thread }

procedure TF5TCPClient.StartThread;
begin
  {$IFDEF TCP_DEBUG_THREAD}
  Log(cltDebug, 'StartThread');
  {$ENDIF}
  FProcessThread := TTCPClientProcessThread.Create(self);
end;

procedure TF5TCPClient.StopThread;
begin
  {$IFDEF TCP_DEBUG_THREAD}
  Log(cltDebug, 'StopThread');
  {$ENDIF}
  if Assigned(FProcessThread) then
    begin
      FProcessThread.Terminate;
      FProcessThread.WaitFor;
    end;
  FreeAndNil(FProcessThread);
end;

{$IFDEF OS_MSWIN}
function TF5TCPClient.ProcessMessage(var MsgTerminated: Boolean): Boolean;
var Msg : TMsg;
begin
  Result := PeekMessage(Msg, 0, 0, 0, PM_REMOVE);
  if not Result then
    exit;
  if Msg.Message = WM_QUIT then
    begin
      MsgTerminated := True;
      exit;
    end;
  TranslateMessage(Msg);
  DispatchMessage(Msg);
end;
{$ENDIF}

// The client thread is responsible for connecting and processing the socket.
// Events are dispatches from this thread.
procedure TF5TCPClient.ThreadExecute(const Thread: TTCPClientProcessThread);

  function IsTerminated: Boolean;
  begin
    Result := Thread.Terminated;
    if Result then
      exit;
    Result := IsStopping;
  end;

  procedure SetErrorFromException(const E: Exception);
  begin
    if E is ESocketLib then
      SetError(E.Message, ESocketLib(E).ErrorCode)
    else
      SetError(E.Message, -1);
  end;

  function WaitSec(const NSec: Integer): Boolean;
  var
    T : Word32;
  begin
    Result := True;
    if NSec <= 0 then
      exit;
    T := TCPGetTick;
    repeat
      if IsTerminated then
        begin
          Result := False;
          exit;
        end;
      Sleep(10);
    until TCPTickDelta(T, TCPGetTick) >= NSec * 1000;
  end;

var
  ConIdle, ConTerminated : Boolean;
  {$IFDEF OS_MSWIN}
  MsgProcessed, MsgTerminated : Boolean;
  {$ENDIF}
  ConnRetry : Boolean;
  ConnAttempt : Integer;
  Reconnect : Boolean;
begin
  Assert(Assigned(Thread));
  {$IFDEF TCP_DEBUG_THREAD}
  Log(cltDebug, 'ThreadExecute');
  {$ENDIF}
  try
    // connection setup
    try
      // startup
      if IsTerminated then
        exit;
      CreateConnection;
      if IsTerminated then
        exit;
      SetStarted;
    except
      on E : Exception do
        begin
          if not IsTerminated then
            begin
              SetErrorFromException(E);
              TriggerConnectFailed;
            end;
          exit;
        end;
    end;
    Reconnect := False;
    repeat
      try
        if Reconnect then
          begin
            // re-allocate socket handle
            DoClose;
            FSocket.AllocateSocketHandle;
          end;
        FSocket.SetBlocking(True);
        if IsTerminated then
          exit;
        // resolve local
        DoResolveLocal;
        if IsTerminated then
          exit;
        // bind
        DoBind;
        if IsTerminated then
          exit;
      except
        on E : Exception do
          begin
            if not IsTerminated then
              begin
                SetErrorFromException(E);
                TriggerConnectFailed;
              end;
            exit;
          end;
      end;
      // resolve and connect
      ConnAttempt := 1;
      repeat
        ConnRetry := False;
        try
          // resolve
          if IsTerminated then
            exit;
          DoResolve;
          if IsTerminated then
            exit;
          // connect
          DoConnect;
          if IsTerminated then
            exit;
          // success
        except
          on E : Exception do
            begin
              // retry
              if not IsTerminated and FRetryFailedConnect then
                if (FRetryFailedConnectMaxAttempts < 0) or
                   (ConnAttempt < FRetryFailedConnectMaxAttempts) then
                  begin
                    if not WaitSec(FRetryFailedConnectDelaySec) then
                      exit;
                    Inc(ConnAttempt);
                    ConnRetry := True;
                    SetState(csConnectRetry);
                    if IsTerminated then
                      exit;
                  end;
              if not ConnRetry then
                begin
                  if not IsTerminated then
                    begin
                      SetErrorFromException(E);
                      TriggerConnectFailed;
                    end;
                  exit;
                end;
              {$IFDEF TCP_DEBUG}
              if ConnRetry then
                Log(cltDebug, 'ConnRetry');
              {$ENDIF}
            end;
        end;
      until not ConnRetry;
      // poll loop
      try
        FSocket.SetBlocking(False);
        {$IFDEF OS_MSWIN}
        MsgTerminated := False;
        {$ENDIF}
        while not IsTerminated do
          begin
            FConnection.ProcessSocket(True, True, Now, ConIdle, ConTerminated);
            if ConTerminated then
              begin
                {$IFDEF TCP_DEBUG_THREAD}
                Log(cltDebug, 'ThreadTerminate:ConnectionTerminated');
                {$ENDIF}
                break;
              end
            else
            if ConIdle then
              begin
                {$IFDEF OS_MSWIN}
                MsgProcessed := ProcessMessage(MsgTerminated);
                if MsgTerminated then
                  begin
                    Thread.Terminate;
                    {$IFDEF TCP_DEBUG_THREAD}
                    Log(cltDebug, 'ThreadTerminate:MsgTerminated');
                    {$ENDIF}
                  end
                else
                  if not MsgProcessed then
                    TriggerProcessThreadIdle;
                {$ELSE}
                TriggerProcessThreadIdle;
                {$ENDIF}
              end;
          end;
      except
        on E : Exception do
          if not IsTerminated then
            SetErrorFromException(E);
      end;
      Reconnect := not IsTerminated and FReconnectOnDisconnect;
    until not Reconnect;
  finally
    if not IsTerminated then
      SetClosed;
  end;
  {$IFDEF TCP_DEBUG_THREAD}
  Log(cltDebug, 'ThreadTerminate:Terminated=%d', [Ord(IsTerminated)]);
  {$ENDIF}
end;

procedure TF5TCPClient.TerminateWorkerThread;
begin
  Assert(Assigned(FConnection));
  FConnection.TerminateWorkerThread;
end;

{ Start / Stop }

const
  // milliseconds to wait for thread to startup,
  // this usually happens within 1 ms but could pause for a few seconds if the
  // system is busy
  ThreadStartupTimeOut = 30000; // 30 seconds

procedure TF5TCPClient.DoStart;
var
  IsAlreadyStarting : Boolean;
  WaitForStart : Boolean;
begin
  // ensure only one thread is doing DoStart
  Lock;
  try
    if FActive then
      exit;
    // validate paramters
    if FHost = '' then
      raise ETCPClient.Create(SError_HostNotSpecified);
    if FPort = '' then
      raise ETCPClient.Create(SError_PortNotSpecified);
    // check if already starting
    IsAlreadyStarting := FState = csStarting;
    if not IsAlreadyStarting then
      SetState(csStarting);
    WaitForStart := FWaitForStartup;
  finally
    Unlock;
  end;
  if IsAlreadyStarting then
    begin
      // this thread is not doing startup,
      // wait for other thread to complete startup
      if WaitForStart then
        if WaitForState(TCPClientStates_All - [csStarting], ThreadStartupTimeOut) = csStarting then
          raise ETCPClient.Create(SError_StartupFailed); // timed out waiting for startup
      exit;
    end;
  // start
  Assert(not FActive);
  // notify start
  TriggerStart;
  // initialise active state
  Lock;
  try
    InitSocketAddrNone(FLocalAddr);
    InitSocketAddrNone(FConnectAddr);
    FErrorMsg := '';
    FErrorCode := 0;
    FActive := True;
  finally
    Unlock;
  end;
  // start thread
  StartThread;
  // wait for thread to complete startup
  if WaitForStart then
    if WaitForState(TCPClientStates_All - [csStarting], ThreadStartupTimeOut) = csStarting then
      raise ETCPClient.Create(SError_StartupFailed); // timed out waiting for thread
    // connection object initialised
  // started
  TriggerActive;
end;

const
  ClientStopTimeOut = 30000; // 30 seconds

procedure TF5TCPClient.DoStop;
var
  IsAlreadyStopping : Boolean;
begin
  // ensure only one thread is doing DoStop
  Lock;
  try
    if not FActive then
      exit;
    IsAlreadyStopping := FIsStopping;
    if not IsAlreadyStopping then
      FIsStopping := True;
  finally
    Unlock;
  end;
  if IsAlreadyStopping then
    begin
      // this thread is not doing stop,
      // wait for other thread to complete stop
      WaitForState([csStopped], ClientStopTimeOut);
      exit;
    end;
  // stop
  try
    TriggerStop;
    DoClose;
    StopThread;
    TerminateWorkerThread;
    FActive := False;
    TriggerInactive;
    SetStopped;
    FreeConnection;
  finally
    Lock;
    try
      FIsStopping := False;
    finally
      Unlock;
    end;
  end;
  // stopped
end;

procedure TF5TCPClient.Start;
begin
  DoStart;
end;

procedure TF5TCPClient.Stop;
begin
  DoStop;
end;

{ Connect state }

function TF5TCPClient.IsConnecting: Boolean;
begin
  Result := GetState in TCPClientStates_Connecting;
end;

function TF5TCPClient.IsConnectingOrConnected: Boolean;
begin
  Result := GetState in TCPClientStates_ConnectingOrConnected;
end;

function TF5TCPClient.IsConnected: Boolean;
begin
  Result := GetState in TCPClientStates_Connected;
end;

function TF5TCPClient.IsConnectionClosed: Boolean;
begin
  Result := GetState in TCPClientStates_Closed;
end;

function TF5TCPClient.IsStopping: Boolean;
begin
  Lock;
  try
    Result := FIsStopping;
  finally
    Unlock;
  end;
end;


{ TLS }

{$IFDEF TCPCLIENT_TLS}
procedure TF5TCPClient.StartTLS;
begin
  CheckActive;
  if FTLSEnabled then // TLS proxy already installed on activation
    exit;
  InstallTLSProxy;
end;
{$ENDIF}

{ Wait }

procedure TF5TCPClient.Wait;
begin
  {$IFDEF OS_MSWIN}
  if GetCurrentThreadID = MainThreadID then
    begin
      if Assigned(OnMainThreadWait) then
        FOnMainThreadWait(self);
    end
  else
    begin
      if Assigned(FOnThreadWait) then
        FOnThreadWait(self);
    end;
  {$ELSE}
  if Assigned(FOnThreadWait) then
    FOnThreadWait(self);
  {$ENDIF}
  Sleep(5);
end;

// Wait until one of the States or time out
function TF5TCPClient.WaitForState(const States: TTCPClientStates; const TimeOutMs: Integer): TTCPClientState;
var T : Word32;
    S : TTCPClientState;
begin
  CheckActive;
  T := TCPGetTick;
  repeat
    S := GetState;
    if S in States then
      break;
    if TimeOutMs >= 0 then
      if TCPTickDelta(T, TCPGetTick) >= TimeOutMs then
        break;
    Wait;
  until False;
  Result := S;
end;

// Wait until connected (ready), closed or time out
function TF5TCPClient.WaitForConnect(const TimeOutMs: Integer): Boolean;
begin
  Result := WaitForState([csReady, csClosed, csStopped], TimeOutMs) = csReady;
end;

// Wait until socket is closed or time out
function TF5TCPClient.WaitForClose(const TimeOutMs: Integer): Boolean;
begin
  Result := WaitForState([csClosed, csStopped], TimeOutMs) = csClosed;
end;



end.

