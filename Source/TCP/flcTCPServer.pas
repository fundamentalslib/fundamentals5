{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcTCPServer.pas                                         }
{   File version:     5.32                                                     }
{   Description:      TCP server.                                              }
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
{   2015/04/27  4.14  Address lists.                                           }
{   2016/01/09  5.15  Revised for Fundamentals 5.                              }
{   2018/08/30  5.16  Trigger Close event when ready client is terminated.     }
{   2018/09/07  5.17  Implement ClientList as linked list.                     }
{   2018/09/07  5.18  Improve latency for large number of clients.             }
{   2018/09/10  5.19  Change polling to use Sockets Poll function.             }
{   2018/12/31  5.20  OnActivity events.                                       }
{   2019/04/10  5.21  String changes.                                          }
{   2019/04/16  5.22  Client shutdown events.                                  }
{   2019/05/19  5.23  Multiple processing threads.                             }
{   2019/10/06  5.24  Use TSimpleEvents to wait on process and controller      }
{                     threads. Improved latency.                               }
{   2019/12/30  5.25  MinReadBufferSize, MinWriteBuffersize,                   }
{                     SocketReadBufferSize and SocketWriteBufferSize.          }
{   2020/03/21  5.26  Remove address lists.                                    }
{   2020/05/02  5.27  Log exceptions raised in event handlers.                 }
{   2020/07/14  5.28  Refactor thread processes into classes.                  }
{   2020/07/15  5.29  Replace polling in controller thread and process threads }
{                     with short poll process thread.                          }
{   2020/07/15  5.30  Use spin poll process thread for accepted clients when   }
{                     short poll process thread is waiting.                    }
{   2020/07/15  5.31  Start option to wait for startup to complete.            }
{   2020/07/19  5.32  Separate Accept thread.                                  }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 7-10.4 Win32/Win64           5.32  2021/01/20                       }
{   Delphi 10.2 Linux64                 5.32  2020/07/30                       }
{   Delphi 10.3-10.4 Linux64            5.27  2020/06/02                       }
{   Delphi 10.2-10.4 iOS32/64           5.27  2020/06/02                       }
{   Delphi 10.2-10.4 OSX32/64           5.27  2020/06/02                       }
{   Delphi 10.2-10.4 Android32/64       5.27  2020/06/02                       }
{   FreePascal 3.0.4 Win64              5.27  2020/06/02                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}
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

  { Utils }

  flcStdTypes,

  { Sockets }

  flcSocketLib,
  flcSocketLibSys,
  flcSocket,

  { TCP }

  flcTCPUtils,
  flcTCPBuffer,
  flcTCPConnection,
  flcTCPServerUtils

  { TLS }

  {$IFDEF TCPSERVER_TLS},
  flcTLSTransportTypes,
  flcTLSTransportConnection,
  flcTLSTransportServer
  {$ENDIF}
  ;



const
  TCP_SERVER_DEFAULT_MaxBacklog = 64;
  TCP_SERVER_DEFAULT_MaxClients = -1;
  TCP_SERVER_DEFAULT_ProcessThreadCount = 1;

  TCP_SERVER_DEFAULT_MinBufferSize = ETHERNET_MTU;     // 1500 bytes
  TCP_SERVER_DEFAULT_MaxBufferSize = ETHERNET_MTU * 6; // 9000 bytes

  TCP_SERVER_DEFAULT_SocketBufferSize = 0; // if 0 the default socket buffer size is not modified



{$IFDEF TCPSERVER_TLS}
type
  TTCPServerTLSOption = (
    stoNone
    );

  TTCPServerTLSOptions = set of TTCPServerTLSOption;

const
  DefaultTCPServerTLSOptions = [];
{$ENDIF}



type
  ETCPServer = class(Exception);

  TF5TCPServer = class;

  { TCP Server Client                                                          }

  TTCPServerClientState = (
      scsInit,
      scsStarting,
      scsNegotiating,
      scsReady,
      scsClosed
    );

  TTCPServerClient = class(TTCPServerClientBase)
  protected
    FServer         : TF5TCPServer;
    FState          : TTCPServerClientState;
    FTerminated     : Boolean;
    FRemoteAddr     : TSocketAddr;
    FSocket         : TSysSocket;
    FConnection     : TTCPConnection;
    FReferenceCount : Integer;
    FOrphanClient   : Boolean;
    FClientID       : Int64;
    FPollThread     : TTCPServerThreadBase;
    FPollIndex      : Integer;
    FUserTag        : NativeInt;
    FUserObject     : TObject;

    {$IFDEF TCPSERVER_TLS}
    FTLSClient      : TTLSServerClient;
    FTLSProxy       : TTCPConnectionProxy;
    {$ENDIF}

    procedure Log(const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer = 0); overload;
    procedure Log(const LogType: TTCPLogType; const LogMsg: String; const LogArgs: array of const; const LogLevel: Integer = 0); overload;

    function  GetState: TTCPServerClientState;
    function  GetStateStr: String;
    procedure SetState(const AState: TTCPServerClientState);

    procedure SetNegotiating;
    procedure SetReady;

    function  GetRemoteAddrStr: String;

    function  GetBlockingConnection: TTCPBlockingConnection;

    {$IFDEF TCPSERVER_TLS}
    procedure InstallTLSProxy;
    {$ENDIF}

    procedure ConnectionLog(Sender: TTCPConnection; LogType: TTCPLogType; LogMsg: String; LogLevel: Integer);

    procedure ConnectionStateChange(Sender: TTCPConnection; State: TTCPConnectionState);
    procedure ConnectionReady(Sender: TTCPConnection);
    procedure ConnectionReadShutdown(Sender: TTCPConnection);
    procedure ConnectionShutdown(Sender: TTCPConnection);
    procedure ConnectionClose(Sender: TTCPConnection);

    procedure ConnectionRead(Sender: TTCPConnection);
    procedure ConnectionWrite(Sender: TTCPConnection);
    procedure ConnectionReadActivity(Sender: TTCPConnection);

    procedure ConnectionWorkerExecute(Sender: TTCPConnection;
              Connection: TTCPBlockingConnection; var CloseOnExit: Boolean);

    procedure TriggerStateChange;
    procedure TriggerNegotiating;
    procedure TriggerConnected;
    procedure TriggerReady;
    procedure TriggerReadShutdown;
    procedure TriggerShutdown;
    procedure TriggerClose;
    procedure TriggerRead;
    procedure TriggerWrite;
    procedure TriggerReadActivity;

    procedure Start;
    procedure Process(
              const AProcessRead, AProcessWrite: Boolean;
              const AActivityTime: TDateTime;
              out AIdle, ATerminated: Boolean);
    procedure AddReference;
    procedure SetClientOrphaned;

  public
    constructor Create(
                const AServer: TF5TCPServer;
                const ASocketHandle: TSocketHandle;
                const AClientID: Int64;
                const ARemoteAddr: TSocketAddr);
    destructor Destroy; override;
    procedure Finalise; override;

    property  State: TTCPServerClientState read GetState;
    property  StateStr: String read GetStateStr;
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
    property  RemoteAddrStr: String read GetRemoteAddrStr;

    property  ClientID: Int64 read FClientID;

    // Worker thread
    procedure TerminateWorkerThread;

    // User defined values
    property  UserTag: NativeInt read FUserTag write FUserTag;
    property  UserObject: TObject read FUserObject write FUserObject;
  end;

  TTCPServerClientClass = class of TTCPServerClient;



  { TCP Server Thread                                                          }

  TTCPServerThread = class(TTCPServerThreadBase)
  protected
    FServer : TF5TCPServer;
  public
    constructor Create(const AServer: TF5TCPServer);
    procedure Finalise; override;
  end;

  TTCPServerControlThread = class(TTCPServerThread)
  protected
    procedure Execute; override;
  end;

  TTCPServerAcceptThread = class(TTCPServerThread)
  private
    FAcceptProcess : TTCPServerAcceptProcess;
  protected
    procedure Execute; override;
  public
    constructor Create(const AServer: TF5TCPServer);
    destructor Destroy; override;
    procedure Finalise; override;
  end;

  TTCPServerProcessPollThread = class(TTCPServerThread)
  private
    FPollProcess : TTCPServerPollProcess;
    FPollTime    : TDateTime;
  public
    constructor Create(const AServer: TF5TCPServer);
    destructor Destroy; override;
    procedure Finalise; override;
  end;

  TTCPServerProcessPollLongThread = class(TTCPServerProcessPollThread)
  protected
    procedure Execute; override;
  end;

  TTCPServerProcessPollShortThread = class(TTCPServerProcessPollThread)
  protected
    procedure Execute; override;
  end;

  TTCPServerProcessSpinThread = class(TTCPServerThread)
  private
    FSpinProcess : TTCPServerSpinProcess;
  protected
    procedure Execute; override;
  public
    constructor Create(const AServer: TF5TCPServer);
    destructor Destroy; override;
    procedure Finalise; override;
  end;

  ////
  TTCPServerThreads = class
  {
    FControlThread        : TTCPServerControlThread;
    FAcceptThread         : TTCPServerAcceptThread;
    FPollLongThread       : array of TTCPServerProcessPollLongThread;
    FPollShortThread      : array of TTCPServerProcessPollShortThread;
    FPollBusyThread       : array of TTCPServerProcessSpinThread;
  }
  end;
  ////



  { TCP Server                                                                 }

  TTCPServerState = (
      ssInit,
      ssStarting,
      ssReady,
      ssError,
      ssClosed
    );

  {$IFDEF TCPSERVER_TLS}
  TTCPServerTLSServerOptions = TTLSServerOptions;
  TTCPServerTLSVersionOptions = TTLSVersionOptions;
  TTCPServerTLSKeyExchangeOptions = TTLSKeyExchangeOptions;
  TTCPServerTLSCipherOptions = TTLSCipherOptions;
  TTCPServerTLSHashOptions = TTLSHashOptions;
  {$ENDIF}

  TTCPServerNotifyEvent = procedure (AServer: TF5TCPServer) of object;
  TTCPServerLogEvent = procedure (AServer: TF5TCPServer; LogType: TTCPLogType;
      Msg: String; LogLevel: Integer) of object;
  TTCPServerStateEvent = procedure (AServer: TF5TCPServer; AState: TTCPServerState) of object;
  TTCPServerClientEvent = procedure (AClient: TTCPServerClient) of object;
  TTCPServerIdleEvent = procedure (AServer: TF5TCPServer; AThread: TTCPServerThread) of object;
  TTCPServerAcceptEvent = procedure (AServer: TF5TCPServer; AAddress: TSocketAddr;
      var AAcceptClient: Boolean) of object;
  TTCPServerClientWorkerExecuteEvent = procedure (AClient: TTCPServerClient;
      AConnection: TTCPBlockingConnection; var ACloseOnExit: Boolean) of object;

  TF5TCPServer = class(TComponent)
  private
    // parameters
    FAddressFamily         : TIPAddressFamily;
    FBindAddressStr        : String;
    FServerPort            : Integer;
    FMaxBacklog            : Integer;
    FMaxClients            : Integer;
    FMinReadBufferSize     : Integer;
    FMaxReadBufferSize     : Integer;
    FMinWriteBufferSize    : Integer;
    FMaxWriteBufferSize    : Integer;
    FSocketReadBufferSize  : Integer;
    FSocketWriteBufferSize : Integer;
    FTrackLastActivityTime : Boolean;
    FProcessThreadCount    : Integer;

    {$IFDEF TCPSERVER_TLS}
    FTLSEnabled            : Boolean;
    FTLSOptions            : TTCPServerTLSOptions;
    FTLSServerOptions      : TTLSServerOptions;
    FTLSVersionOptions     : TTCPServerTLSVersionOptions;
    FTLSKeyExchangeOptions : TTCPServerTLSKeyExchangeOptions;
    FTLSCipherOptions      : TTCPServerTLSCipherOptions;
    FTLSHashOptions        : TTCPServerTLSHashOptions;
    {$ENDIF}

    FUseWorkerThread       : Boolean;
    FUserTag               : NativeInt;
    FUserObject            : TObject;

    FStartFinishEvent      : TSimpleEvent;

    // event handlers
    FOnLog                 : TTCPServerLogEvent;

    FOnActive              : TTCPServerNotifyEvent;
    FOnStarting            : TTCPServerNotifyEvent;
    FOnError               : TTCPServerNotifyEvent;
    FOnReady               : TTCPServerNotifyEvent;
    FOnStopping            : TTCPServerNotifyEvent;
    FOnInactive            : TTCPServerNotifyEvent;

    FOnStateChanged        : TTCPServerStateEvent;
    FOnThreadIdle          : TTCPServerIdleEvent;

    FOnClientAccept        : TTCPServerAcceptEvent;
    FOnClientCreate        : TTCPServerClientEvent;
    FOnClientAdd           : TTCPServerClientEvent;
    FOnClientRemove        : TTCPServerClientEvent;
    FOnClientDestroy       : TTCPServerClientEvent;

    FOnClientStateChange   : TTCPServerClientEvent;
    FOnClientNegotiating   : TTCPServerClientEvent;
    FOnClientConnected     : TTCPServerClientEvent;
    FOnClientReady         : TTCPServerClientEvent;
    FOnClientReadShutdown  : TTCPServerClientEvent;
    FOnClientShutdown      : TTCPServerClientEvent;
    FOnClientClose         : TTCPServerClientEvent;

    FOnClientRead          : TTCPServerClientEvent;
    FOnClientWrite         : TTCPServerClientEvent;
    FOnClientReadActivity  : TTCPServerClientEvent;

    FOnClientWorkerExecute : TTCPServerClientWorkerExecuteEvent;

    // state
    FLock                 : TCriticalSection;
    FActive               : Boolean;
    FActiveOnLoaded       : Boolean;
    FState                : TTCPServerState;
    FStateErrorMsg        : String;
    FStopping             : Boolean;
    FControlThread        : TTCPServerControlThread;
    FAcceptThread         : TTCPServerAcceptThread;
    ////FPollLongThread       : TTCPServerProcessPollLongThread;
    FPollShortThread      : TTCPServerProcessPollShortThread;
    FPollSpinThread       : TTCPServerProcessSpinThread;
    FServerSocket         : TSysSocket;
    FBindAddress          : TSocketAddr;
    FClientActiveList     : TTCPServerClientList;
    FClientAcceptedList   : TTCPServerClientList;
    FClientTerminatedList : TTCPServerClientList;
    FClientIDCounter      : Int64;
    {$IFDEF TCPSERVER_TLS}
    FTLSServer            : TTLSServer;
    {$ENDIF}

  protected
    procedure Init; virtual;
    procedure InitDefaults; virtual;

    procedure Lock;
    procedure Unlock;

    procedure Log(const LogType: TTCPLogType; const Msg: String; const LogLevel: Integer = 0); overload;
    procedure Log(const LogType: TTCPLogType; const Msg: String; const Args: array of const; const LogLevel: Integer = 0); overload;
    procedure LogParameter(const Msg: String; const Args: array of const; const LogLevel: Integer = 0); overload;
    procedure LogException(const Msg: String; const E: Exception);

    procedure CheckNotActive;

    procedure SetAddressFamily(const AAddressFamily: TIPAddressFamily);
    procedure SetBindAddress(const ABindAddressStr: String);
    procedure SetServerPort(const AServerPort: Integer);
    procedure SetMaxBacklog(const AMaxBacklog: Integer);
    procedure SetMaxClients(const AMaxClients: Integer);

    procedure SetMinReadBufferSize(const AMinReadBufferSize: Integer);
    procedure SetMaxReadBufferSize(const AMaxReadBufferSize: Integer);
    procedure SetMinWriteBufferSize(const AMinWriteBufferSize: Integer);
    procedure SetMaxWriteBufferSize(const AMaxWriteBufferSize: Integer);
    procedure SetSocketReadBufferSize(const ASocketReadBufferSize: Integer);
    procedure SetSocketWriteBufferSize(const ASocketWriteBufferSize: Integer);

    procedure SetTrackLastActivityTime(const Track: Boolean);

    procedure SetProcessThreadCount(const AThreadCount: Integer);

    procedure SetUseWorkerThread(const AUseWorkerThread: Boolean);

    {$IFDEF TCPSERVER_TLS}
    procedure SetTLSEnabled(const TLSEnabled: Boolean);
    procedure SetTLSOptions(const ATLSOptions: TTCPServerTLSOptions);
    procedure SetTLSServerOptions(const ATLSServerOptions: TTCPServerTLSServerOptions);
    procedure SetTLSVersionOptions(const ATLSVersionOptions: TTCPServerTLSVersionOptions);
    procedure SetTLSKeyExchangeOptions(const ATLSKeyExchangeOptions: TTCPServerTLSKeyExchangeOptions);
    procedure SetTLSCipherOptions(const ATLSCipherOptions: TTCPServerTLSCipherOptions);
    procedure SetTLSHashOptions(const ATLSHashOptions: TTCPServerTLSHashOptions);
    {$ENDIF}

    procedure ServerSocketLog(Sender: TSysSocket; LogType: TSysSocketLogType; Msg: String);

    procedure ClientLog(const AClient: TTCPServerClient; const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer);

    procedure TriggerClientAccept(const AAddress: TSocketAddr; var AAcceptClient: Boolean); virtual;
    procedure TriggerClientCreate(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientAdd(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientRemove(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientDestroy(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientStateChange(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientNegotiating(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientConnected(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientReady(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientReadShutdown(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientShutdown(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientClose(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientRead(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientWrite(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientReadActivity(const AClient: TTCPServerClient); virtual;
    procedure TriggerClientWorkerExecute(const AClient: TTCPServerClient;
              const AConnection: TTCPBlockingConnection; var ACloseOnExit: Boolean); virtual;

    {$IFDEF TCPSERVER_TLS}
    procedure TLSServerTransportLayerSendProc(
              AServer: TTLSServer; AClient: TTLSServerClient;
              const Buffer; const Size: Integer);
    {$ENDIF}

    function  GetState: TTCPServerState;
    function  GetStateStr: String;
    function  GetStateErrorMsg: String;

    procedure SetState(const AState: TTCPServerState);

    procedure ServerActive; virtual;
    procedure ServerStarting; virtual;
    procedure ServerReady; virtual;
    procedure ServerError(const ErrorMsg: String);
    procedure ServerStopping; virtual;
    procedure ServerInactive; virtual;

    procedure StartControlThread;
    procedure StartAcceptThread;
    procedure StartPollThreads;
    procedure StopServerThreads;

    procedure ServerCloseClients;
    procedure ServerCloseServer;
    procedure ServerClose; virtual;
    procedure ServerSetStateError(const ErrorMsg: String); virtual;
    procedure ServerSetStateReady; virtual;
    procedure ServerStart; virtual;
    procedure ServerStop; virtual;
    procedure ServerActivate; virtual;
    procedure ServerDeactivate; virtual;

    procedure ServerSetError(const ErrorMsg: String);
    procedure ServerSetReady;
    procedure ServerSetActive;
    procedure ServerSetInactive;

    procedure SetActive(const AActive: Boolean);

    procedure Loaded; override;

    function  CreateClient(const ASocketHandle: TSocketHandle; const ASocketAddr: TSocketAddr): TTCPServerClient; virtual;

    function  CanAcceptClient: Boolean;
    function  ServerAcceptClient(
              const AcceptSocket: TSocketHandle;
              const AcceptAddr: TSocketAddr): Boolean;

    function  ServerDropClient: Boolean;

    procedure ProcessClient(
              const AClient: TTCPServerClient;
              const AProcessRead, AProcessWrite: Boolean;
              const AActivityTime: TDateTime;
              out AClientIdle, AClientTerminated: Boolean);

    function  ControlThreadListen(const AThread: TTCPThread): Boolean;
    function  ControlThreadDropClients(const AThread: TTCPThread): Boolean;
    procedure ControlThreadExecute(const AThread: TTCPServerControlThread);

    procedure AcceptThreadAcceptSocket(
              const ASocketHandle: TSocket;
              const AAddr: TSocketAddr;
              var AAcceptSocket: Boolean);
    procedure AcceptThreadExecute(const AThread: TTCPServerAcceptThread);

    procedure ProcessPollLongThreadExecute(const AThread: TTCPServerProcessPollLongThread);

    procedure AddAcceptedClientsToPollShort;
    procedure AddAcceptedClientsToPollSpin;

    procedure ProcessPollShortThreadStartPoll;
    procedure ProcessPollShortThreadClientPoll(
              const AClient: TTCPServerClientBase;
              var AEventRead, AEventWrite: Boolean);
    procedure ProcessPollShortThreadClientProcess(
              const AClient: TTCPServerClientBase;
              const AEventRead, AEventWrite, AEventError: Boolean;
              out AClientTerminated: Boolean);
    procedure ProcessPollShortThreadCompletePoll;
    procedure ProcessPollShortThreadExecute(const AThread: TTCPServerProcessPollShortThread);

    procedure ProcessPollSpinThreadClientPoll(
              const AClient: TTCPServerClientBase;
              var AEventRead, AEventWrite: Boolean);
    procedure ProcessPollSpinThreadClientProcess(
              const AClient: TTCPServerClientBase;
              const AEventRead, AEventWrite, AEventError: Boolean;
              out AClientTerminated: Boolean);
    procedure ProcessPollSpinThreadExecute(const AThread: TTCPServerProcessSpinThread);

    function  GetActiveClientCount: Integer;
    function  GetClientCount: Integer;

    function  GetReadRate: Int64;
    function  GetWriteRate: Int64;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Finalise; virtual;

    // Parameters
    property  AddressFamily: TIPAddressFamily read FAddressFamily write SetAddressFamily default iaIP4;
    property  BindAddress: String read FBindAddressStr write SetBindAddress;
    property  ServerPort: Integer read FServerPort write SetServerPort;
    property  MaxBacklog: Integer read FMaxBacklog write SetMaxBacklog default TCP_SERVER_DEFAULT_MaxBacklog;
    property  MaxClients: Integer read FMaxClients write SetMaxClients default TCP_SERVER_DEFAULT_MaxClients;

    property  MinReadBufferSize: Integer read FMinReadBufferSize write SetMinReadBufferSize default TCP_SERVER_DEFAULT_MinBufferSize;
    property  MaxReadBufferSize: Integer read FMaxReadBufferSize write SetMaxReadBufferSize default TCP_SERVER_DEFAULT_MaxBufferSize;
    property  MinWriteBufferSize: Integer read FMinWriteBufferSize write SetMinWriteBufferSize default TCP_SERVER_DEFAULT_MinBufferSize;
    property  MaxWriteBufferSize: Integer read FMaxWriteBufferSize write SetMaxWriteBufferSize default TCP_SERVER_DEFAULT_MaxBufferSize;

    property  SocketReadBufferSize: Integer read FSocketReadBufferSize write SetSocketReadBufferSize default TCP_SERVER_DEFAULT_SocketBufferSize;
    property  SocketWriteBufferSize: Integer read FSocketWriteBufferSize write SetSocketWriteBufferSize default TCP_SERVER_DEFAULT_SocketBufferSize;

    property  TrackLastActivityTime: Boolean read FTrackLastActivityTime write SetTrackLastActivityTime default True;
    property  ProcessThreadCount: Integer read FProcessThreadCount write SetProcessThreadCount default TCP_SERVER_DEFAULT_ProcessThreadCount;

    // TLS
    {$IFDEF TCPSERVER_TLS}
    property  TLSEnabled: Boolean read FTLSEnabled write SetTLSEnabled default False;
    property  TLSOptions: TTCPServerTLSOptions read FTLSOptions write SetTLSOptions default DefaultTCPServerTLSOptions;
    property  TLSServerOptions: TTCPServerTLSServerOptions read FTLSServerOptions write SetTLSServerOptions default DefaultTLSServerOptions;
    property  TLSVersionOptions: TTCPServerTLSVersionOptions read FTLSVersionOptions write SetTLSVersionOptions default DefaultTLSServerVersionOptions;
    property  TLSKeyExchangeOptions: TTCPServerTLSKeyExchangeOptions read FTLSKeyExchangeOptions write SetTLSKeyExchangeOptions default DefaultTLSServerKeyExchangeOptions;
    property  TLSCipherOptions: TTCPServerTLSCipherOptions read FTLSCipherOptions write SetTLSCipherOptions default DefaultTLSServerCipherOptions;
    property  TLSHashOptions: TTCPServerTLSHashOptions read FTLSHashOptions write SetTLSHashOptions default DefaultTLSServerHashOptions;
    property  TLSServer: TTLSServer read FTLSServer;
    {$ENDIF}

    // Event handlers may be triggered from any number of external threads.
    // Event handlers should do their own synchronisation if required.
    property  OnLog: TTCPServerLogEvent read FOnLog write FOnLog;

    property  OnActive: TTCPServerNotifyEvent read FOnActive write FOnActive;
    property  OnStarting: TTCPServerNotifyEvent read FOnStarting write FOnStarting;
    property  OnError: TTCPServerNotifyEvent read FOnError write FOnError;
    property  OnReady: TTCPServerNotifyEvent read FOnReady write FOnReady;
    property  OnStopping: TTCPServerNotifyEvent read FOnStopping write FOnStopping;
    property  OnInactive: TTCPServerNotifyEvent read FOnInactive write FOnInactive;

    property  OnStateChanged: TTCPServerStateEvent read FOnStateChanged write FOnStateChanged;

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
    property  OnClientReadShutdown: TTCPServerClientEvent read FOnClientReadShutdown write FOnClientReadShutdown;
    property  OnClientShutdown: TTCPServerClientEvent read FOnClientShutdown write FOnClientShutdown;
    property  OnClientClose: TTCPServerClientEvent read FOnClientClose write FOnClientClose;

    property  OnClientRead: TTCPServerClientEvent read FOnClientRead write FOnClientRead;
    property  OnClientWrite: TTCPServerClientEvent read FOnClientWrite write FOnClientWrite;
    property  OnClientReadActivity: TTCPServerClientEvent read FOnClientReadActivity write FOnClientReadActivity;

    // State
    property  State: TTCPServerState read GetState;
    property  StateStr: String read GetStateStr;
    property  StateErrorMsg: String read GetStateErrorMsg;

    property  Active: Boolean read FActive write SetActive default False;

    procedure Start(
              const AWaitStartup: Boolean = False;
              const AWaitTimeoutMs: Int32 = 30000);
    procedure Stop;

    property  ActiveClientCount: Integer read GetActiveClientCount;
    property  ClientCount: Integer read GetClientCount;
    function  ClientIterateFirst: TTCPServerClient;
    function  ClientIterateNext(const C: TTCPServerClient): TTCPServerClient;

    property  ReadRate: Int64 read GetReadRate;
    property  WriteRate: Int64 read GetWriteRate;

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
{ Fundamentals Code Library TCP Server component                               }
{                                                                              }
type
  TfclTCPServer = class(TF5TCPServer)
  published
    property  Active;
    property  AddressFamily;
    property  BindAddress;
    property  ServerPort;
    property  MaxBacklog;
    property  MinReadBufferSize;
    property  MaxReadBufferSize;
    property  MinWriteBufferSize;
    property  MaxWriteBufferSize;

    {$IFDEF TCPSERVER_TLS}
    property  TLSEnabled;
    property  TLSOptions;
    property  TLSServerOptions;
    property  TLSVersionOptions;
    property  TLSKeyExchangeOptions;
    property  TLSCipherOptions;
    property  TLSHashOptions;
    {$ENDIF}

    property  OnLog;

    property  OnActive;
    property  OnStarting;
    property  OnError;
    property  OnReady;
    property  OnStopping;
    property  OnInactive;

    property  OnStateChanged;

    property  OnThreadIdle;

    property  OnClientAccept;
    property  OnClientCreate;
    property  OnClientAdd;
    property  OnClientRemove;
    property  OnClientDestroy;

    property  OnClientStateChange;
    property  OnClientNegotiating;
    property  OnClientReady;
    property  OnClientReadShutdown;
    property  OnClientShutdown;
    property  OnClientClose;

    property  OnClientRead;
    property  OnClientWrite;
    property  OnClientReadActivity;

    property  UseWorkerThread;
    property  OnClientWorkerExecute;
  end;



implementation

{$IFDEF TCPSERVER_TLS}
uses
  { TLS }

  flcTLSConsts;
{$ENDIF}



{                                                                              }
{ Error and debug strings                                                      }
{                                                                              }
const
  SError_NotAllowedWhileActive = 'Operation not allowed while server is active';
  SError_InvalidServerPort     = 'Invalid server port';

  STCPServerState : array[TTCPServerState] of String = (
      'Initialise',
      'Starting',
      'Ready',
      'Error',
      'Closed');

  STCPServerClientState : array[TTCPServerClientState] of String = (
      'Initialise',
      'Starting',
      'Negotiating',
      'Ready',
      'Closed');

  LogLevel_Client       = 2;
  LogLevel_Connection   = 2;
  LogLevel_ServerSocket = 5;



{$IFDEF TCPSERVER_TLS}
{                                                                              }
{ TCP Server Client TLS Connection Proxy                                       }
{                                                                              }
type
  TTCPServerClientTLSConnectionProxy = class(TTCPConnectionProxy)
  private
    FTLSServer : TTLSServer;
    FTLSClient : TTLSServerClient;

  protected
    procedure TLSClientTransportLayerSendProc(const Sender: TTLSConnection; const Buffer; const Size: Integer);
    procedure TLSClientLog(Sender: TTLSConnection; LogType: TTLSLogType; LogMsg: String; LogLevel: Integer);
    procedure TLSClientStateChange(Sender: TTLSConnection; State: TTLSConnectionState);

  public
    class function ProxyName: String; override;

    constructor Create(const ATLSServer: TTLSServer; const ATCPConnection: TTCPConnection);
    destructor Destroy; override;

    procedure ProxyStart; override;
    procedure ProcessReadData(const Buf; const BufSize: Integer); override;
    procedure ProcessWriteData(const Buf; const BufSize: Integer); override;
  end;

class function TTCPServerClientTLSConnectionProxy.ProxyName: String;
begin
  Result := 'TLSServerClient';
end;

constructor TTCPServerClientTLSConnectionProxy.Create(
            const ATLSServer: TTLSServer;
            const ATCPConnection: TTCPConnection);
begin
  Assert(Assigned(ATLSServer));
  Assert(Assigned(ATCPConnection));

  inherited Create;

  FTLSServer := ATLSServer;
  FTLSClient := ATLSServer.AddClient(self);
  {$IFDEF TCP_DEBUG_TLS}
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
            const AServer: TF5TCPServer;
            const ASocketHandle: TSocketHandle;
            const AClientID: Int64;
            const ARemoteAddr: TSocketAddr);
begin
  Assert(Assigned(AServer));
  Assert(ASocketHandle <> INVALID_SOCKETHANDLE);

  inherited Create(ASocketHandle);

  FState := scsInit;
  FServer := AServer;
  FClientID := AClientID;
  FSocket := TSysSocket.Create(AServer.FAddressFamily, ipTCP, False, ASocketHandle);
  FRemoteAddr := ARemoteAddr;

  FConnection := TTCPConnection.Create(
      FSocket,
      AServer.FMinReadBufferSize,
      AServer.FMaxReadBufferSize,
      AServer.FMinWriteBufferSize,
      AServer.FMaxWriteBufferSize);
  if FServer.FSocketReadBufferSize > 0 then
    FConnection.SocketReadBufferSize := FServer.FSocketReadBufferSize;
  if FServer.FSocketWriteBufferSize > 0 then
    FConnection.SocketWriteBufferSize := FServer.FSocketWriteBufferSize;
  FConnection.TrackLastActivityTime := AServer.FTrackLastActivityTime;
  if Assigned(FServer.FOnLog) then
    FConnection.OnLog := ConnectionLog;
  FConnection.OnStateChange    := ConnectionStateChange;
  FConnection.OnReady          := ConnectionReady;
  FConnection.OnReadShutdown   := ConnectionReadShutdown;
  FConnection.OnShutdown       := ConnectionShutdown;
  FConnection.OnClose          := ConnectionClose;
  FConnection.OnWorkerExecute  := ConnectionWorkerExecute;
  if Assigned(FServer.FOnClientRead) then
    FConnection.OnRead := ConnectionRead;
  if Assigned(FServer.FOnClientWrite) then
    FConnection.OnWrite := ConnectionWrite;
  if Assigned(FServer.FOnClientReadActivity) then
    FConnection.OnReadActivity := ConnectionReadActivity;

  {$IFDEF TCPSERVER_TLS}
  if FServer.FTLSEnabled then
    InstallTLSProxy;
  {$ENDIF}
end;

destructor TTCPServerClient.Destroy;
begin
  if Assigned(FConnection) then
    FConnection.Finalise;
  FreeAndNil(FConnection);
  FreeAndNil(FSocket);
  inherited Destroy;
end;

procedure TTCPServerClient.Finalise;
begin
  inherited Finalise;
  FPollThread := nil;
  FUserObject := nil;
  FServer := nil;
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

function TTCPServerClient.GetStateStr: String;
begin
  Result := STCPServerClientState[GetState];
end;

procedure TTCPServerClient.SetState(const AState: TTCPServerClientState);
begin
  Assert(FState <> AState);
  FState := AState;

  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'State:%s', [STCPServerClientState[AState]]);
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

function TTCPServerClient.GetRemoteAddrStr: String;
begin
  Result := SocketAddrStr(FRemoteAddr);
end;

function TTCPServerClient.GetBlockingConnection: TTCPBlockingConnection;
begin
  Assert(Assigned(FConnection));
  Result := FConnection.BlockingConnection;
end;

{$IFDEF TCPSERVER_TLS}
procedure TTCPServerClient.InstallTLSProxy;
var
  Proxy : TTCPServerClientTLSConnectionProxy;
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
  Log(LogType, 'Connection:%s', [LogMsg], LogLevel_Connection + LogLevel);
  {$ELSE}
  if LogType in [tlWarning, tlError] then
    Log(LogType, 'Connection:%s', [LogMsg], LogLevel_Connection + LogLevel);
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

procedure TTCPServerClient.ConnectionReadShutdown(Sender: TTCPConnection);
begin
  TriggerReadShutdown;
end;

procedure TTCPServerClient.ConnectionShutdown(Sender: TTCPConnection);
begin
  TriggerShutdown;
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

procedure TTCPServerClient.ConnectionRead(Sender: TTCPConnection);
begin
  TriggerRead;
end;

procedure TTCPServerClient.ConnectionWrite(Sender: TTCPConnection);
begin
  TriggerWrite;
end;

procedure TTCPServerClient.ConnectionReadActivity(Sender: TTCPConnection);
begin
  TriggerReadActivity;
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

procedure TTCPServerClient.TriggerReadShutdown;
begin
  if Assigned(FServer) then
    FServer.TriggerClientReadShutdown(self);
end;

procedure TTCPServerClient.TriggerShutdown;
begin
  if Assigned(FServer) then
    FServer.TriggerClientShutdown(self);
end;

procedure TTCPServerClient.TriggerClose;
begin
  if Assigned(FServer) then
    FServer.TriggerClientClose(self);
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

procedure TTCPServerClient.TriggerReadActivity;
begin
  if Assigned(FServer) then
    FServer.TriggerClientReadActivity(self);
end;

procedure TTCPServerClient.Start;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Start');
  {$ENDIF}
  SetState(scsStarting);
  FConnection.Start;
end;

procedure TTCPServerClient.Process(
          const AProcessRead, AProcessWrite: Boolean;
          const AActivityTime: TDateTime;
          out AIdle, ATerminated: Boolean);
begin
  FConnection.ProcessSocket(
      AProcessRead, AProcessWrite,
      AActivityTime,
      AIdle, ATerminated);

  if ATerminated then
    FTerminated := True;
end;

procedure TTCPServerClient.AddReference;
begin
  FServer.Lock;
  try
    Inc(FReferenceCount);
  finally
    FServer.Unlock;
  end;
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
        begin
          Finalise;
          {$IFNDEF NEXTGEN}
          Free;
          {$ENDIF}
        end;
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
{ TCP Server Thread                                                            }
{                                                                              }
constructor TTCPServerThread.Create(const AServer: TF5TCPServer);
begin
  Assert(Assigned(AServer));
  FServer := AServer;
  inherited Create;
end;

procedure TTCPServerThread.Finalise;
begin
  inherited Finalise;
  FServer := nil;
end;


{ TTCPServerControlThread }

procedure TTCPServerControlThread.Execute;
begin
  FServer.ControlThreadExecute(self);
end;



{ TTCPServerAcceptThread }

constructor TTCPServerAcceptThread.Create(const AServer: TF5TCPServer);
begin
  FAcceptProcess := TTCPServerAcceptProcess.Create;
  inherited Create(AServer);
end;

destructor TTCPServerAcceptThread.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FAcceptProcess);
end;

procedure TTCPServerAcceptThread.Finalise;
begin
  inherited Finalise;
  FAcceptProcess.Finalise;
end;

procedure TTCPServerAcceptThread.Execute;
begin
  FServer.AcceptThreadExecute(self);
end;



{ TTCPServerProcessPollThread }

constructor TTCPServerProcessPollThread.Create(const AServer: TF5TCPServer);
begin
  FPollProcess := TTCPServerPollProcess.Create;
  inherited Create(AServer);
end;

destructor TTCPServerProcessPollThread.Destroy;
begin
  if not Terminated then
    Terminate;
  if Assigned(FPollProcess) then
    FPollProcess.Terminate;
  inherited Destroy;
  FreeAndNil(FPollProcess);
end;

procedure TTCPServerProcessPollThread.Finalise;
begin
  if not Terminated then
    Terminate;
  FPollProcess.Terminate;
  inherited Finalise;
  FPollProcess.Finalise;
end;



{ TTCPServerProcessPollLongThread }

procedure TTCPServerProcessPollLongThread.Execute;
begin
  FServer.ProcessPollLongThreadExecute(self);
end;



{ TTCPServerProcessPollShortThread }

procedure TTCPServerProcessPollShortThread.Execute;
begin
  FServer.ProcessPollShortThreadExecute(self);
end;



{ TTCPServerProcessSpinThread }

constructor TTCPServerProcessSpinThread.Create(const AServer: TF5TCPServer);
begin
  FSpinProcess := TTCPServerSpinProcess.Create;
  inherited Create(AServer);
end;

destructor TTCPServerProcessSpinThread.Destroy;
begin
  if not Terminated then
    Terminate;
  if Assigned(FSpinProcess) then
    FSpinProcess.Terminate;
  inherited Destroy;
  FreeAndNil(FSpinProcess);
end;

procedure TTCPServerProcessSpinThread.Finalise;
begin
  if not Terminated then
    Terminate;
  FSpinProcess.Terminate;
  inherited Finalise;
end;

procedure TTCPServerProcessSpinThread.Execute;
begin
  FServer.ProcessPollSpinThreadExecute(self);
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
  FClientActiveList := TTCPServerClientList.Create;
  FClientAcceptedList := TTCPServerClientList.Create;
  FClientTerminatedList := TTCPServerClientList.Create;
  {$IFDEF TCPSERVER_TLS}
  FTLSServer := TTLSServer.Create(TLSServerTransportLayerSendProc);
  {$ENDIF}
  FStartFinishEvent := TSimpleEvent.Create;
  InitDefaults;
end;

procedure TF5TCPServer.InitDefaults;
begin
  FActive := False;
  FAddressFamily := iaIP4;
  FBindAddressStr := '0.0.0.0';
  FMaxBacklog := TCP_SERVER_DEFAULT_MaxBacklog;
  FMaxClients := TCP_SERVER_DEFAULT_MaxClients;
  FMinReadBufferSize := TCP_SERVER_DEFAULT_MinBufferSize;
  FMaxReadBufferSize := TCP_SERVER_DEFAULT_MaxBufferSize;
  FMinWriteBufferSize := TCP_SERVER_DEFAULT_MinBufferSize;
  FMaxWriteBufferSize := TCP_SERVER_DEFAULT_MaxBufferSize;
  FSocketReadBufferSize := TCP_SERVER_DEFAULT_SocketBufferSize;
  FSocketWriteBufferSize := TCP_SERVER_DEFAULT_SocketBufferSize;
  FTrackLastActivityTime := True;
  FProcessThreadCount := TCP_SERVER_DEFAULT_ProcessThreadCount;
  {$IFDEF TCPSERVER_TLS}
  FTLSEnabled := False;
  FTLSOptions := DefaultTCPServerTLSOptions;
  FTLSServerOptions := DefaultTLSServerOptions;
  FTLSVersionOptions := DefaultTLSServerVersionOptions;
  FTLSKeyExchangeOptions := DefaultTLSServerKeyExchangeOptions;
  FTLSCipherOptions := DefaultTLSServerCipherOptions;
  FTLSHashOptions := DefaultTLSServerHashOptions;
  {$ENDIF}
end;

destructor TF5TCPServer.Destroy;

  procedure FreeList(var AList: TTCPServerClientList);
  var
    LIter, LNext : TTCPServerClient;
  begin
    LIter := TTCPServerClient(AList.First);
    AList.First := nil;
    AList.Last := nil;
    while Assigned(LIter) do
      begin
        LNext := TTCPServerClient(LIter.ListNext);
        if LIter.FReferenceCount = 0 then
          begin
            LIter.Finalise;
            FreeAndNil(LIter);
          end
        else
          LIter.SetClientOrphaned;
        LIter := LNext;
      end;
    FreeAndNil(AList);
  end;

begin
  FreeAndNil(FControlThread);
  FreeAndNil(FAcceptThread);
  //FreeAndNil(FPollLongThread);
  FreeAndNil(FPollShortThread);
  FreeAndNil(FPollSpinThread);
  FreeAndNil(FStartFinishEvent);
  FreeList(FClientTerminatedList);
  FreeList(FClientAcceptedList);
  FreeList(FClientActiveList);
  {$IFDEF TCPSERVER_TLS}
  FreeAndNil(FTLSServer);
  {$ENDIF}
  FreeAndNil(FServerSocket);
  FreeAndNil(FLock);
  inherited Destroy;
end;

procedure TF5TCPServer.Finalise;
var
  Iter : TTCPServerClient;
begin
  try
    StopServerThreads;
    if Assigned(FClientActiveList) then
      begin
        Iter := TTCPServerClient(FClientActiveList.First);
        while Assigned(Iter) do
          begin
            Iter.TerminateWorkerThread;
            Iter := TTCPServerClient(Iter.ListNext);
          end;
      end;
  except
    on E : Exception do
       LogException('Error stopping threads: %s', E);
  end;
  FUserObject := nil;
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

procedure TF5TCPServer.LogParameter(const Msg: String; const Args: array of const; const LogLevel: Integer);
begin
  Log(tlParameter, Format(Msg, Args), LogLevel);
end;

procedure TF5TCPServer.LogException(const Msg: String; const E: Exception);
begin
  Log(tlError, Msg, [E.Message]);
end;

procedure TF5TCPServer.CheckNotActive;
begin
  if not (csDesigning in ComponentState) then
    if FActive then
      raise ETCPServer.Create(SError_NotAllowedWhileActive);
end;

procedure TF5TCPServer.SetAddressFamily(const AAddressFamily: TIPAddressFamily);
begin
  if AAddressFamily = FAddressFamily then
    exit;
  CheckNotActive;
  FAddressFamily := AAddressFamily;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('AddressFamily:%s', [IPAddressFamilyStr[FAddressFamily]]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetBindAddress(const ABindAddressStr: String);
begin
  if ABindAddressStr = FBindAddressStr then
    exit;
  CheckNotActive;
  FBindAddressStr := ABindAddressStr;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('BindAddress:%s', [FBindAddressStr]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetServerPort(const AServerPort: Integer);
begin
  if AServerPort = FServerPort then
    exit;
  CheckNotActive;
  if (AServerPort <= 0) or (AServerPort > $FFFF) then
    raise ETCPServer.Create(SError_InvalidServerPort);
  FServerPort := AServerPort;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('ServerPort:%d', [FServerPort]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetMaxBacklog(const AMaxBacklog: Integer);
begin
  if AMaxBacklog = FMaxBacklog then
    exit;
  CheckNotActive;
  FMaxBacklog := AMaxBacklog;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('MaxBacklog:%d', [FMaxBacklog]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetMaxClients(const AMaxClients: Integer);
begin
  if AMaxClients = FMaxClients then
    exit;
  Lock;
  try
    FMaxClients := AMaxClients;
  finally
    Unlock;
  end;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('MaxClients:%d', [FMaxClients]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetMinReadBufferSize(const AMinReadBufferSize: Integer);
begin
  if AMinReadBufferSize = FMinReadBufferSize then
    exit;
  CheckNotActive;
  FMinReadBufferSize := AMinReadBufferSize;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('MinReadBufferSize:%d', [FMinReadBufferSize]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetMaxReadBufferSize(const AMaxReadBufferSize: Integer);
begin
  if AMaxReadBufferSize = FMaxReadBufferSize then
    exit;
  CheckNotActive;
  FMaxReadBufferSize := AMaxReadBufferSize;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('MaxReadBufferSize:%d', [FMaxReadBufferSize]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetMinWriteBufferSize(const AMinWriteBufferSize: Integer);
begin
  if AMinWriteBufferSize = FMinWriteBufferSize then
    exit;
  CheckNotActive;
  FMinWriteBufferSize := AMinWriteBufferSize;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('MinWriteBufferSize:%d', [FMinWriteBufferSize]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetMaxWriteBufferSize(const AMaxWriteBufferSize: Integer);
begin
  if AMaxWriteBufferSize = FMaxWriteBufferSize then
    exit;
  CheckNotActive;
  FMaxWriteBufferSize := AMaxWriteBufferSize;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('MaxWriteBufferSize:%d', [FMaxWriteBufferSize]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetSocketReadBufferSize(const ASocketReadBufferSize: Integer);
begin
  if ASocketReadBufferSize = FSocketReadBufferSize then
    exit;
  CheckNotActive;
  FSocketReadBufferSize := ASocketReadBufferSize;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('SocketReadBufferSize:%d', [FSocketReadBufferSize]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetSocketWriteBufferSize(const ASocketWriteBufferSize: Integer);
begin
  if ASocketWriteBufferSize = FSocketWriteBufferSize then
    exit;
  CheckNotActive;
  FSocketWriteBufferSize := ASocketWriteBufferSize;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('SocketWriteBufferSize:%d', [FSocketWriteBufferSize]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetTrackLastActivityTime(const Track: Boolean);
begin
  if Track = FTrackLastActivityTime then
    exit;
  CheckNotActive;
  FTrackLastActivityTime := Track;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('TrackLastActivityTime:%d', [Ord(Track)]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetProcessThreadCount(const AThreadCount: Integer);
begin
  if AThreadCount = FProcessThreadCount then
    exit;
  CheckNotActive;
  FProcessThreadCount := AThreadCount;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('ProcessThreadCount:%d', [ThreadCount]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetUseWorkerThread(const AUseWorkerThread: Boolean);
begin
  if AUseWorkerThread = FUseWorkerThread then
    exit;
  CheckNotActive;
  FUseWorkerThread := AUseWorkerThread;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('UseWorkerThread:%d', [UseWorkerThread]);
  {$ENDIF}
end;

{$IFDEF TCPSERVER_TLS}
procedure TF5TCPServer.SetTLSEnabled(const TLSEnabled: Boolean);
begin
  if TLSEnabled = FTLSEnabled then
    exit;
  CheckNotActive;
  FTLSEnabled := TLSEnabled;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('TLSEnabled:%d', [Ord(TLSEnabled)]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetTLSOptions(const ATLSOptions: TTCPServerTLSOptions);
begin
  if ATLSOptions = FTLSOptions then
    exit;
  CheckNotActive;
  FTLSOptions := ATLSOptions;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('TLSOptions:%d', [Ord(ATLSOptions)]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetTLSServerOptions(const ATLSServerOptions: TTCPServerTLSServerOptions);
begin
  if ATLSServerOptions = FTLSServerOptions then
    exit;
  CheckNotActive;
  FTLSServerOptions := ATLSServerOptions;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('TLSServerOptions:%d', [Ord(ATLSServerOptions)]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetTLSVersionOptions(const ATLSVersionOptions: TTCPServerTLSVersionOptions);
begin
  if ATLSVersionOptions = FTLSVersionOptions then
    exit;
  CheckNotActive;
  FTLSVersionOptions := ATLSVersionOptions;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('TLSVersionOptions:%d', [Ord(ATLSVersionOptions)]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetTLSKeyExchangeOptions(const ATLSKeyExchangeOptions: TTCPServerTLSKeyExchangeOptions);
begin
  if ATLSKeyExchangeOptions = FTLSKeyExchangeOptions then
    exit;
  CheckNotActive;
  FTLSKeyExchangeOptions := ATLSKeyExchangeOptions;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('TLSKeyExchangeOptions:%d', [Ord(ATLSKeyExchangeOptions)]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetTLSCipherOptions(const ATLSCipherOptions: TTCPServerTLSCipherOptions);
begin
  if ATLSCipherOptions = FTLSCipherOptions then
    exit;
  CheckNotActive;
  FTLSCipherOptions := ATLSCipherOptions;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('TLSCipherOptions:%d', [Ord(ATLSCipherOptions)]);
  {$ENDIF}
end;

procedure TF5TCPServer.SetTLSHashOptions(const ATLSHashOptions: TTCPServerTLSHashOptions);
begin
  if ATLSHashOptions = FTLSHashOptions then
    exit;
  CheckNotActive;
  FTLSHashOptions := ATLSHashOptions;
  {$IFDEF TCP_LOG_PARAMETERS}
  LogParameter('TLSHashOptions:%d', [Ord(ATLSHashOptions)]);
  {$ENDIF}
end;
{$ENDIF}

function TF5TCPServer.GetState: TTCPServerState;
begin
  Lock;
  try
    Result := FState;
  finally
    Unlock;
  end;
end;

function TF5TCPServer.GetStateStr: String;
var
  S : String;
begin
  Lock;
  try
    S := STCPServerState[FState];
    if (FState = ssError) and (FStateErrorMsg <> '') then
      S := S + ': ' + FStateErrorMsg;
    Result := S;
  finally
    Unlock;
  end;
end;

function TF5TCPServer.GetStateErrorMsg: String;
begin
  Lock;
  try
    if FState in [ssError, ssClosed] then
      Result := FStateErrorMsg
    else
      Result := '';
  finally
    Unlock;
  end;
end;

procedure TF5TCPServer.SetState(const AState: TTCPServerState);
begin
  Lock;
  try
    Assert(FState <> AState);
    FState := AState;
  finally
    Unlock;
  end;
  {$IFDEF TCP_LOG_SERVERSTATE}
  Log(tlInfo, 'State=%s', [GetStateStr]);
  {$ENDIF}
  if Assigned(FOnStateChanged) then
    FOnStateChanged(self, AState);
end;

procedure TF5TCPServer.ServerSocketLog(Sender: TSysSocket; LogType: TSysSocketLogType; Msg: String);
begin
  {$IFDEF TCP_DEBUG_SOCKET}
  Log(tlDebug, 'ServerSocket:%s', [Msg], LogLevel_Socket);
  {$ENDIF}
end;

procedure TF5TCPServer.ClientLog(const AClient: TTCPServerClient; const LogType: TTCPLogType; const LogMsg: String; const LogLevel: Integer);
begin
  Assert(Assigned(AClient));
  {$IFDEF TCP_DEBUG}
  Log(LogType, 'Client[%d]:%s', [Client.ClientID, LogMsg], LogLevel_Client + LogLevel);
  {$ENDIF}
end;

procedure TF5TCPServer.TriggerClientAccept(const AAddress: TSocketAddr; var AAcceptClient: Boolean);
begin
  if Assigned(FOnClientAccept) then
    try
      FOnClientAccept(self, AAddress, AAcceptClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientAccept.Error:Address=%s,Error=%s[%s]',
            [SocketAddrStr(AAddress), E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientCreate(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientCreate) then
    try
      FOnClientCreate(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientCreate.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientAdd(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientAdd) then
    try
      FOnClientAdd(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientAdd.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientRemove(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientRemove) then
    try
      FOnClientRemove(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientRemove.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientDestroy(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientDestroy) then
    try
      FOnClientDestroy(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientDestroy.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientStateChange(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientStateChange) then
    try
      FOnClientStateChange(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientStateChange.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientNegotiating(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientNegotiating) then
    FOnClientNegotiating(AClient);
end;

procedure TF5TCPServer.TriggerClientConnected(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientConnected) then
    try
      FOnClientConnected(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientConnected.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientReady(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientReady) then
    try
      FOnClientReady(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientReady.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientReadShutdown(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientReadShutdown) then
    try
      FOnClientReadShutdown(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientReadShutdown.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientShutdown(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientShutdown) then
    try
      FOnClientShutdown(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientShutdown.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientClose(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientClose) then
    try
      FOnClientClose(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientClose.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientRead(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientRead) then
    try
      FOnClientRead(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientRead.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientWrite(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientWrite) then
    try
      FOnClientWrite(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientWrite.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientReadActivity(const AClient: TTCPServerClient);
begin
  if Assigned(FOnClientReadActivity) then
    try
      FOnClientReadActivity(AClient);
    except
      on E : Exception do
        Log(tlError, 'TriggerClientReadActivity.Error:Client=%d,Error=%s[%s]',
            [AClient.ClientID, E.ClassName, E.Message]);
    end;
end;

procedure TF5TCPServer.TriggerClientWorkerExecute(const AClient: TTCPServerClient;
          const AConnection: TTCPBlockingConnection; var ACloseOnExit: Boolean);
begin
  if Assigned(FOnClientWorkerExecute) then
    FOnClientWorkerExecute(AClient, AConnection, ACloseOnExit);
end;

{$IFDEF TCPSERVER_TLS}
procedure TF5TCPServer.TLSServerTransportLayerSendProc(AServer: TTLSServer; AClient: TTLSServerClient; const Buffer; const Size: Integer);
var Proxy : TTCPServerClientTLSConnectionProxy;
begin
  Assert(Assigned(AClient.UserObj));
  Assert(AClient.UserObj is TTCPServerClientTLSConnectionProxy);

  Proxy := TTCPServerClientTLSConnectionProxy(AClient.UserObj);
  Proxy.TLSClientTransportLayerSendProc(AClient, Buffer, Size);
end;
{$ENDIF}

procedure TF5TCPServer.ServerActive;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'ServerActive');
  {$ENDIF}
  if Assigned(FOnActive) then
    FOnActive(self);
end;

procedure TF5TCPServer.ServerStarting;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'ServerStarting');
  {$ENDIF}
  if Assigned(FOnStarting) then
    FOnStarting(self);
end;

procedure TF5TCPServer.ServerReady;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'ServerReady');
  {$ENDIF}
  if Assigned(FOnReady) then
    FOnReady(self);
end;

procedure TF5TCPServer.ServerError(const ErrorMsg: String);
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'ServerError');
  {$ENDIF}
  if Assigned(FOnError) then
    FOnError(self);
end;

procedure TF5TCPServer.ServerStopping;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'ServerStopping');
  {$ENDIF}
  if Assigned(FOnStopping) then
    FOnStopping(self);
end;

procedure TF5TCPServer.ServerInactive;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'ServerInactive');
  {$ENDIF}
  if Assigned(FOnInactive) then
    FOnInactive(self);
end;

procedure TF5TCPServer.StartControlThread;
begin
  Assert(not Assigned(FControlThread));
  FControlThread := TTCPServerControlThread.Create(self);
end;

procedure TF5TCPServer.StartAcceptThread;
begin
  Assert(not Assigned(FAcceptThread));
  FAcceptThread := TTCPServerAcceptThread.Create(self);
end;

procedure TF5TCPServer.StartPollThreads;
begin
  Assert(not Assigned(FPollShortThread));
  Assert(not Assigned(FPollSpinThread));
  //Assert(not Assigned(FPollLongThread));

  FPollSpinThread := TTCPServerProcessSpinThread.Create(self);
  FPollShortThread := TTCPServerProcessPollShortThread.Create(self);
  //FPollLongThread := TTCPServerProcessPollLongThread.Create(self);
end;

procedure TF5TCPServer.StopServerThreads;
begin
  TCPThreadTerminate(FControlThread);
  TCPThreadTerminate(FAcceptThread);
  //TCPThreadTerminate(FPollLongThread);
  TCPThreadTerminate(FPollShortThread);
  TCPThreadTerminate(FPollSpinThread);

  TCPThreadFinalise(FControlThread);
  TCPThreadFinalise(FAcceptThread);
  //TCPThreadFinalise(FPollLongThread);
  TCPThreadFinalise(FPollShortThread);
  TCPThreadFinalise(FPollSpinThread);

  FreeAndNil(FControlThread);
  FreeAndNil(FAcceptThread);
  //FreeAndNil(FPollLongThread);
  FreeAndNil(FPollShortThread);
  FreeAndNil(FPollSpinThread);
end;

procedure TF5TCPServer.ServerCloseClients;
var
  C : TTCPServerClient;
begin
  C := TTCPServerClient(FClientActiveList.First);
  while Assigned(C) do
    begin
      C.Close;
      C := TTCPServerClient(C.ListNext);
    end;
end;

procedure TF5TCPServer.ServerCloseServer;
begin
  if Assigned(FServerSocket) then
    FServerSocket.CloseSocket;
end;

procedure TF5TCPServer.ServerClose;
begin
  ServerCloseServer;
  ServerCloseClients;
end;

procedure TF5TCPServer.ServerSetStateError(const ErrorMsg: String);
begin
  Lock;
  try
    FStateErrorMsg := ErrorMsg;
  finally
    Unlock;
  end;
  SetState(ssError);
  ServerError(ErrorMsg);
end;

procedure TF5TCPServer.ServerSetStateReady;
begin
  Assert(FState = ssStarting);
  SetState(ssReady);
  ServerReady;
end;

procedure TF5TCPServer.ServerStart;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Starting');
  {$ENDIF}
  SetState(ssStarting);
  ServerStarting;
  {$IFDEF TCPSERVER_TLS}
  if FTLSEnabled then
    begin
      FTLSServer.ServerOptions := FTLSServerOptions;
      FTLSServer.VersionOptions := FTLSVersionOptions;
      FTLSServer.KeyExchangeOptions := FTLSKeyExchangeOptions;
      FTLSServer.CipherOptions := FTLSCipherOptions;
      FTLSServer.HashOptions := FTLSHashOptions;
      FTLSServer.Start;
    end;
  {$ENDIF}
  StartPollThreads;
  StartControlThread;
end;

procedure TF5TCPServer.ServerStop;

  procedure RemoveAllClients(const AList: TTCPServerClientList);
  var
    LIter, LNext : TTCPServerClient;
  begin
    LIter := TTCPServerClient(AList.First);
    while Assigned(LIter) do
      begin
        LNext := TTCPServerClient(LIter.ListNext);
        TriggerClientRemove(LIter);
        AList.Remove(LIter);
        if LIter.FReferenceCount = 0 then
          begin
            TriggerClientDestroy(LIter);
            LIter.Finalise;
            FreeAndNil(LIter);
          end
        else
          LIter.SetClientOrphaned;
        LIter := LNext;
      end;
  end;

var
  LIter : TTCPServerClient;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Stopping');
  {$ENDIF}
  ServerStopping;
  StopServerThreads;
  LIter := TTCPServerClient(FClientActiveList.First);
  while Assigned(LIter) do
    begin
      LIter.TerminateWorkerThread;
      LIter := TTCPServerClient(LIter.ListNext);
    end;
  ServerClose;
  {$IFDEF TCPSERVER_TLS}
  if FTLSEnabled then
    FTLSServer.Stop;
  {$ENDIF}
  RemoveAllClients(FClientTerminatedList);
  RemoveAllClients(FClientAcceptedList);
  RemoveAllClients(FClientActiveList);
  FreeAndNil(FServerSocket);
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'Stopped');
  {$ENDIF}
  SetState(ssClosed);
end;

procedure TF5TCPServer.ServerActivate;
begin
  FStateErrorMsg := '';
  FStopping := False;
  FStartFinishEvent.ResetEvent;
  ServerActive;
  ServerStart;
end;

procedure TF5TCPServer.ServerDeactivate;
begin
  Lock;
  try
    FActive := False;
  finally
    Unlock;
  end;
  ServerInactive;
end;

procedure TF5TCPServer.ServerSetError(const ErrorMsg: String);
begin
  ServerSetStateError(ErrorMsg);
end;

procedure TF5TCPServer.ServerSetReady;
begin
  ServerSetStateReady;
end;

procedure TF5TCPServer.ServerSetActive;
begin
  Lock;
  try
    if FActive then
      exit;
    FActive := True;
  finally
    Unlock;
  end;
  ServerActivate;
end;

procedure TF5TCPServer.ServerSetInactive;
begin
  Lock;
  try
    if not FActive then
      exit;
    if FStopping then
      exit;
    FStopping := True;
  finally
    Unlock;
  end;
  ServerStop;
  ServerDeactivate;
end;

procedure TF5TCPServer.SetActive(const AActive: Boolean);
begin
  if AActive = FActive then
    exit;
  if csDesigning in ComponentState then
    FActive := AActive else
  if csLoading in ComponentState then
    FActiveOnLoaded := AActive
  else
    if AActive then
      ServerSetActive
    else
      ServerSetInactive;
end;

procedure TF5TCPServer.Loaded;
begin
  inherited Loaded;
  if FActiveOnLoaded then
    ServerSetActive;
end;

procedure TF5TCPServer.Start(
          const AWaitStartup: Boolean;
          const AWaitTimeoutMs: Int32);
begin
  ServerSetActive;
  if AWaitStartup then
    begin
      FStartFinishEvent.WaitFor(AWaitTimeoutMs);
      case GetState of
        ssInit,
        ssStarting : raise ETCPServerError.Create('Startup timeout');
        ssReady    : ;
        ssError,
        ssClosed   : raise ETCPServerError.CreateFmt('Not ready: %s', [GetStateStr]);
      end;
    end;
end;

procedure TF5TCPServer.Stop;
begin
  ServerSetInactive;
end;

function TF5TCPServer.CreateClient(const ASocketHandle: TSocketHandle; const ASocketAddr: TSocketAddr): TTCPServerClient;
var
  ClientId : Int64;
begin
  Inc(FClientIDCounter);
  ClientId := FClientIDCounter;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'CreateClient(ID:%d,Handle:%d)', [ClientId, Ord(SocketHandle)]);
  {$ENDIF}
  Result := TTCPServerClient.Create(self, ASocketHandle, ClientId, ASocketAddr);
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
      Result := FClientActiveList.Count + FClientAcceptedList.Count < M;
  finally
    Unlock;
  end;
end;

function TF5TCPServer.ServerAcceptClient(
         const AcceptSocket: TSocketHandle;
         const AcceptAddr: TSocketAddr): Boolean;
var
  AcceptClient : Boolean;
  Client       : TTCPServerClient;
begin
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, Format('IncommingConnection(%s:%d)', [
      SocketAddrIPStrA(AcceptAddr),
      AcceptAddr.Port]));
  {$ENDIF}
  AcceptClient := True;
  if (AcceptAddr.AddrFamily = iaNone) or
     (AcceptAddr.AddrFamily <> FAddressFamily) then
    begin
      Log(tlError, 'Accept: Invalid address family: Closing');
      AcceptClient := False;
    end;
  if AcceptClient then
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
  // set socket TcpNoDelay option
  try
    Client.Connection.Socket.TcpNoDelayEnabled := True;
  except
  end;
  // set socket non-blocking for processing
  try
    Client.Connection.Socket.SetBlocking(False);
  except
    Client.Free;
    raise;
  end;
  TriggerClientCreate(Client);
  Lock;
  try
    FClientAcceptedList.Add(Client);
  finally
    Unlock;
  end;
  {$IFDEF TCP_DEBUG}
  Log(tlDebug, 'ClientAdded');
  {$ENDIF}
  TriggerClientAdd(Client);
  Client.Start;  // 2020/07/15 moved to after trigger add; and removed from lock
  Result := True;
end;

// Find a terminated client without any references to it, if found
// remove from client list and free client object
// Returns True if client found and dropped
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
    Iter := TTCPServerClient(FClientTerminatedList.First);
    for ItCnt := 0 to ClCnt - 1 do
      begin
        if Iter.FReferenceCount = 0 then
          begin
            DropCl := Iter;
            FClientTerminatedList.Remove(DropCl);
            break;
          end;
        Iter := TTCPServerClient(Iter.ListNext);
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
  DropCl.Finalise;
  {$IFNDEF NEXTGEN}
  DropCl.Free;
  {$ENDIF}
  Result := True;
end;

// Process a client (read from socket, write to socket, handle socket errors)
procedure TF5TCPServer.ProcessClient(
          const AClient: TTCPServerClient;
          const AProcessRead, AProcessWrite: Boolean;
          const AActivityTime: TDateTime;
          out AClientIdle, AClientTerminated: Boolean);
var
  ClSt : TTCPServerClientState;
  ClFr : Boolean;
begin
  AClient.Process(AProcessRead, AProcessWrite, AActivityTime, AClientIdle, AClientTerminated);
  if AClientTerminated then
    begin
      AClient.TerminateWorkerThread;
      Lock;
      try
        ClSt := AClient.State;
        ClFr := AClient.FReferenceCount = 0;
        AClient.FPollThread := nil;
        AClient.FPollIndex := -1;
        FClientActiveList.Remove(AClient);
      finally
        Unlock;
      end;
      if ClSt = scsReady then
        begin
          AClient.SetState(scsClosed);
          TriggerClientClose(AClient);
        end;
      TriggerClientRemove(AClient);
      if ClFr then
        begin
          {$IFDEF TCP_DEBUG}
          Log(tlDebug, 'ClientDestroy');
          {$ENDIF}
          TriggerClientDestroy(AClient);
          AClient.Finalise;
          {$IFNDEF NEXTGEN}
          AClient.Free;
          {$ENDIF}
        end
      else
        begin
          Lock;
          try
            FClientTerminatedList.Add(AClient);
          finally
            Unlock;
          end;
        end;
    end;
end;

function TF5TCPServer.ControlThreadListen(const AThread: TTCPThread): Boolean;

  function IsTerminated: Boolean;
  begin
    Result := AThread.Terminated;
  end;

begin
  Assert(FState = ssStarting);
  Assert(not Assigned(FServerSocket));

  Result := False;
  if IsTerminated then
    exit;
  try
    FBindAddress := ResolveHost(FBindAddressStr, FAddressFamily);
    SetSocketAddrPort(FBindAddress, FServerPort);
  except
    on E: Exception do
      begin
        ServerSetError(E.Message);
        exit;
      end;
  end;
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
    FServerSocket.SetBlocking(False);
  except
    on E : Exception do
      begin
        FreeAndNil(FServerSocket);
        ServerSetError(E.Message);
        exit; //// retry in loop if transient
      end;
  end;
  if IsTerminated then
    exit;

  Result := True;
end;

function TF5TCPServer.ControlThreadDropClients(const AThread: TTCPThread): Boolean;

  function IsTerminated: Boolean;
  begin
    Result := AThread.Terminated;
  end;

begin
  Result := False;
  if IsTerminated then
    exit;
  while ServerDropClient do
    begin
      Result := True;
      if IsTerminated then
        exit;
    end;
end;

procedure TF5TCPServer.ControlThreadExecute(const AThread: TTCPServerControlThread);

  function IsTerminated: Boolean;
  begin
    Result := AThread.Terminated;
  end;

var
  IsIdle : Boolean;
begin
  try
    try
      {$IFDEF TCP_DEBUG_THREAD}
      Log(tlDebug, 'ControlThreadExecute');
      {$ENDIF}

      Assert(Assigned(AThread));

      if IsTerminated then
        exit;

      if not ControlThreadListen(AThread) then
        exit;

      // server socket ready
      StartAcceptThread;

      ServerSetReady;
      if IsTerminated then
        exit;

    finally
      // start complete (server state is ready or error)
      FStartFinishEvent.SetEvent;
    end;

    while not IsTerminated do
      begin
        IsIdle := True;
        if ControlThreadDropClients(AThread) then
          begin
            IsIdle := False;
            if IsTerminated then
              exit;
          end;
        if IsTerminated then
          break;
        FAcceptThread.FAcceptProcess.AcceptPaused := not CanAcceptClient;
        if IsIdle then
          AThread.SleepUnterminated(1000);
      end;
    if not IsTerminated then
      Log(tlError, 'ControlThreadExecute.UnexpectedTerminatation');
  except
    on E : Exception do
      if not IsTerminated then
        LogException('ControlThreadExecute.Error', E);
  end;
end;

procedure TF5TCPServer.AcceptThreadAcceptSocket(
          const ASocketHandle: TSocket;
          const AAddr: TSocketAddr;
          var AAcceptSocket: Boolean);
begin
  if ServerAcceptClient(ASocketHandle, AAddr) then
    begin
      AAcceptSocket := True;
      Lock;
      try
        if FPollShortThread.FPollProcess.GetClientCount = 0 then
          AddAcceptedClientsToPollShort
        else
          AddAcceptedClientsToPollSpin;
      finally
        Unlock;
      end;
    end
  else
    AAcceptSocket := False;
end;

procedure TF5TCPServer.AcceptThreadExecute(const AThread: TTCPServerAcceptThread);

  function IsTerminated: Boolean;
  begin
    Result := AThread.Terminated;
  end;

begin
  try
    Assert(Assigned(AThread));

    {$IFDEF TCP_DEBUG_THREAD}
    Log(tlDebug, 'AcceptThreadExecute');
    {$ENDIF}

    while not IsTerminated do
      begin
        AThread.FAcceptProcess.Execute(AThread, FServerSocket.SocketHandle,
            AcceptThreadAcceptSocket, 2000);
      end;
    if not IsTerminated then
      Log(tlError, 'AcceptThreadExecute.UnexpectedTerminatation');
  except
    on E : Exception do
      if not IsTerminated then
        LogException('AcceptThreadExecute.Error', E);
  end;
end;

procedure TF5TCPServer.ProcessPollLongThreadExecute(const AThread: TTCPServerProcessPollLongThread);
begin
  ////
end;

procedure TF5TCPServer.AddAcceptedClientsToPollShort;
var
  Cl, Nx : TTCPServerClient;
begin
  Cl := TTCPServerClient(FClientAcceptedList.First);
  while Assigned(Cl) do
    begin
      Nx := TTCPServerClient(Cl.ListNext);
      FClientAcceptedList.Remove(Cl);
      FClientActiveList.Add(Cl);
      Cl.FPollThread := FPollShortThread;
      Cl.FPollIndex := FPollShortThread.FPollProcess.AddClient(Cl);
      Cl := Nx;
    end;
end;

procedure TF5TCPServer.AddAcceptedClientsToPollSpin;
var
  Cl, Nx : TTCPServerClient;
begin
  Cl := TTCPServerClient(FClientAcceptedList.First);
  while Assigned(Cl) do
    begin
      Nx := TTCPServerClient(Cl.ListNext);
      FClientAcceptedList.Remove(Cl);
      FClientActiveList.Add(Cl);
      Cl.FPollThread := FPollSpinThread;
      Cl.FPollIndex := FPollSpinThread.FSpinProcess.AddClient(Cl);
      Cl := Nx;
    end;
end;

procedure TF5TCPServer.ProcessPollShortThreadStartPoll;
var
  ClAr : TTCPServerClientBaseArray;
  ClIdx : Int32;
  Cl : TTCPServerClient;
begin
  ClAr := FPollSpinThread.FSpinProcess.RemoveClients; // 2020/07/15: must be outside Lock

  Lock;
  try
    for ClIdx := 0 to Length(ClAr) - 1 do
      begin
        Cl := TTCPServerClient(ClAr[ClIdx]);
        if Assigned(Cl) then
          begin
            Cl.FPollThread := FPollShortThread;
            Cl.FPollIndex := FPollShortThread.FPollProcess.AddClient(Cl);
          end;
      end;

    AddAcceptedClientsToPollShort;

    FPollShortThread.FPollTime := Now;
  finally
    Unlock;
  end;
end;

procedure TF5TCPServer.ProcessPollShortThreadClientPoll(
          const AClient: TTCPServerClientBase;
          var AEventRead, AEventWrite: Boolean);
var
  Con : TTCPConnection;
begin
  Con := TTCPServerClient(AClient).Connection;
  if Assigned(Con) then
    begin
      Con.ProcessPendingEvents;
      Con.GetEventsToPoll(AEventRead, AEventWrite);
    end
  else
    begin
      AEventRead := False;
      AEventWrite := False;
    end;
end;

procedure TF5TCPServer.ProcessPollShortThreadClientProcess(
          const AClient: TTCPServerClientBase;
          const AEventRead, AEventWrite, AEventError: Boolean;
          out AClientTerminated: Boolean);
var
  LIdle : Boolean;
begin
  ProcessClient(TTCPServerClient(AClient),
      AEventRead, AEventWrite, FPollShortThread.FPollTime, LIdle, AClientTerminated);
  if not AClientTerminated then
    TTCPServerClient(AClient).Connection.ProcessPendingEvents;
end;

procedure TF5TCPServer.ProcessPollShortThreadCompletePoll;
begin
end;

procedure TF5TCPServer.ProcessPollShortThreadExecute(const AThread: TTCPServerProcessPollShortThread);
begin
  try
    AThread.FPollProcess.Execute(
        AThread,
        ProcessPollShortThreadStartPoll,
        ProcessPollShortThreadClientPoll,
        ProcessPollShortThreadClientProcess,
        ProcessPollShortThreadCompletePoll,
        100);
    if not AThread.Terminated then
      Log(tlError, 'ProcessPollShortThreadExecute.UnexpectedTerminatation');
  except
    on E : Exception do
      if not AThread.Terminated then
        LogException('ProcessPollShortThreadExecute.Error', E);
  end;
end;

procedure TF5TCPServer.ProcessPollSpinThreadClientPoll(
          const AClient: TTCPServerClientBase;
          var AEventRead, AEventWrite: Boolean);
var
  Con : TTCPConnection;
begin
  Con := TTCPServerClient(AClient).Connection;
  if Assigned(Con) then
    begin
      Con.ProcessPendingEvents;
      Con.GetEventsToPoll(AEventRead, AEventWrite);
    end
  else
    begin
      AEventRead := False;
      AEventWrite := False;
    end;
end;

procedure TF5TCPServer.ProcessPollSpinThreadClientProcess(
          const AClient: TTCPServerClientBase;
          const AEventRead, AEventWrite, AEventError: Boolean;
          out AClientTerminated: Boolean);
var
  LIdle : Boolean;
begin
  ProcessClient(TTCPServerClient(AClient),
      AEventRead, AEventWrite, FPollShortThread.FPollTime, LIdle, AClientTerminated);
  if not AClientTerminated then
    TTCPServerClient(AClient).Connection.ProcessPendingEvents;
end;

procedure TF5TCPServer.ProcessPollSpinThreadExecute(const AThread: TTCPServerProcessSpinThread);
begin
  try
    AThread.FSpinProcess.Execute(
        AThread,
        ProcessPollSpinThreadClientPoll,
        ProcessPollSpinThreadClientProcess);
    if not AThread.Terminated then
      Log(tlError, 'ProcessPollSpinThreadExecute.UnexpectedTerminatation');
  except
    on E : Exception do
      if not AThread.Terminated then
        LogException('ProcessPollSpinThreadExecute.Error', E);
  end;
end;

function TF5TCPServer.GetActiveClientCount: Integer;
var
  N : Integer;
  C : TTCPServerClient;
begin
  Lock;
  try
    N := 0;
    C := TTCPServerClient(FClientActiveList.First);
    while Assigned(C) do
      begin
        if not C.FTerminated and (C.FState in [scsNegotiating, scsReady]) then
          Inc(N);
        C := TTCPServerClient(C.ListNext);
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
    Result := FClientActiveList.Count;
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
    C := TTCPServerClient(FClientActiveList.First);
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
    N := TTCPServerClient(C.ListNext);
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
    C := TTCPServerClient(FClientActiveList.First);
    while Assigned(C) do
      begin
        if not C.FTerminated and (C.FState = scsReady) then
          Inc(R, C.Connection.ReadRate);
        C := TTCPServerClient(C.ListNext);
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
    C := TTCPServerClient(FClientActiveList.First);
    while Assigned(C) do
      begin
        if not C.FTerminated and (C.FState = scsReady) then
          Inc(R, C.Connection.WriteRate);
        C := TTCPServerClient(C.ListNext);
      end;
  finally
    Unlock;
  end;
  Result := R;
end;



end.

