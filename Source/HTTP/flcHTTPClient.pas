{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcHTTPClient.pas                                        }
{   File version:     5.17                                                     }
{   Description:      HTTP client.                                             }
{                                                                              }
{   Copyright:        Copyright (c) 2009-2020, David J Butler                  }
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
{   2009/09/03  0.01  Initial development.                                     }
{   2011/06/12  0.02  Further development.                                     }
{   2011/06/14  0.03  HTTPS support.                                           }
{   2011/06/17  0.04  Cookies.                                                 }
{   2011/06/18  0.05  Multiple requests on same connection.                    }
{   2011/06/19  0.06  Response content mechanisms.                             }
{   2011/07/31  0.07  Connection close support.                                }
{   2011/10/06  4.08  SynchronisedEvents option.                               }
{   2013/03/23  4.09  CustomHeader property.                                   }
{   2013/03/24  4.10  SetRequestContentWwwFormUrlEncodedField method.          }
{   2015/05/05  4.11  RawByteString changes.                                   }
{   2016/01/09  5.12  Revised for Fundamentals 5.                              }
{   2020/07/25  5.13  Remove SynchronisedEvents option.                        }
{   2020/07/25  5.14  Remove TComponent base class.                            }
{   2020/07/25  5.15  Change event order: Active, Start, Stop, Inactive.       }
{   2020/07/25  5.16  WaitReadyForRequest and WaitForRequestComplete.          }
{   2020/09/21  5.17  Request and Response object wrappers.                    }
{                                                                              }
{******************************************************************************}

{ Todo: }
{ - State manegement }
{ - Wait for Connect: Test }
{ - Wait for Complete: Test }
{ - Log types: share with TCP server }

{$INCLUDE flcHTTP.inc}

unit flcHTTPClient;

interface

uses
  { System }
  {$IFDEF MSWIN}
  Windows,
  {$ENDIF}
  SysUtils,
  Classes,
  SyncObjs,
  { Fundamentals }
  flcStdTypes,
  flcStrings,
  { Fundamentals TCP }
  flcTCPConnection,
  flcTCPClient,
  { Fundamentals HTTP }
  flcHTTPUtils;



{                                                                              }
{ HTTP Client                                                                  }
{                                                                              }
type
  THTTPClientLogType = (
    cltDebug,
    cltParameter,
    cltInfo,
    cltError
    );

  THTTPClientAddressFamily = (
    cafIP4,
    cafIP6
    );

  THTTPClientMethod = (
    cmGET,
    cmPOST,
    cmCustom
    );

  THTTPKeepAliveOption = (
    kaDefault,
    kaKeepAlive,
    kaClose
    );

  {$IFDEF HTTP_TLS}
  THTTPSClientOption = (
    csoDontUseSSL3,
    csoDontUseTLS10,
    csoDontUseTLS11,
    csoDontUseTLS12
    );

  THTTPSClientOptions = set of THTTPSClientOption;
  {$ENDIF}

  TF5HTTPClientState = (
    hcsInit,
    hcsStarting,                          { Starting }
                                          { Connecting }
    hcsConnectFailed,                     { ReadyFailed }
    hcsConnectedReady,                    { Ready }
    hcsSendingRequest,                    { RequestBusy }
    hcsSendingContent,                    { RequestBusy }
    hcsAwaitingResponse,                  { RequestBusy }
    hcsReceivedResponse,                  { RequestBusy }
    hcsReceivingContent,                  { RequestBusy }
    hcsResponseComplete,                  { RequestComplete -> Ready }
    hcsResponseCompleteAndClosing,        { RequestComplete -> Closing}
    hcsResponseCompleteAndClosed,         { RequestComplete -> Closed }
    hcsRequestInterruptedAndClosed,       { RequestFail -> Closed }
    hcsRequestFailed,                     { RequestFail -> Closed }
                                          { Closing }
                                          { Closed }
    hcsStopping,                          { Stopping }
    hcsStopped                            { Stopped }
    );

  TF5HTTPClient = class;

  TSyncProc = procedure of object;

  THTTPClientEvent = procedure (Client: TF5HTTPClient) of object;
  THTTPClientLogEvent = procedure (Client: TF5HTTPClient; LogType: THTTPClientLogType; Msg: String; Level: Integer) of object;
  THTTPClientStateEvent = procedure (Client: TF5HTTPClient; State: TF5HTTPClientState) of object;
  THTTPClientContentEvent = procedure (Client: TF5HTTPClient; const Buf; const Size: Integer) of object;

  TF5HTTPClient = class
  protected
    // event handlers
    FOnLog                     : THTTPClientLogEvent;
    FOnStateChange             : THTTPClientStateEvent;
    FOnActive                  : THTTPClientEvent;
    FOnStart                   : THTTPClientEvent;
    FOnResponseHeader          : THTTPClientEvent;
    FOnResponseContentBuffer   : THTTPClientContentEvent;
    FOnResponseContentComplete : THTTPClientEvent;
    FOnResponseComplete        : THTTPClientEvent;
    FOnStop                    : THTTPClientEvent;
    FOnInactive                : THTTPClientEvent;

    // host
    FAddressFamily : THTTPClientAddressFamily;
    FHost          : String;
    FPort          : String;

    // https
    {$IFDEF HTTP_TLS}
    FUseHTTPS      : Boolean;
    FHTTPSOptions  : THTTPSClientOptions;
    {$ENDIF}

    // http proxy
    FUseHTTPProxy  : Boolean;
    FHTTPProxyHost : String;
    FHTTPProxyPort : String;

    // http request
    FMethod        : THTTPClientMethod;
    FMethodCustom  : RawByteString;
    FURI           : RawByteString;
    FUserAgent     : RawByteString;
    FKeepAlive     : THTTPKeepAliveOption;
    FReferer       : RawByteString;
    FCookie        : RawByteString;
    FAuthorization : RawByteString;
    FCustomHeaders : THTTPCustomHeaders;

    // request content parameters
    FRequestContentType   : RawByteString;
    FRequestContentWriter : THTTPContentWriter;

    // other parameters
    FUserObject : TObject;
    FUserData   : Pointer;
    FUserTag    : NativeInt;

    // state
    FLock                 : TCriticalSection;
    FState                : TF5HTTPClientState;
    FErrorMsg             : String;
    FActive               : Boolean;
    FIsStopping           : Boolean;
    FViaHTTPProxy         : Boolean;
    FTCPClient            : TF5TCPClient;
    FHTTPParser           : THTTPParser;
    FInRequest            : Boolean;
    FReadyEvent           : TSimpleEvent;
    FRequestCompleteEvent : TSimpleEvent;
    
    FRequestPending    : Boolean;
    FRequestObj        : THTTPRequestObj;
    FRequestHasContent : Boolean;

    FResponseObj            : THTTPResponseObj;
    FResponseCode           : Integer;
    FResponseCookies        : TStrings;
    FResponseContentReader  : THTTPContentReader;
    FResponseRequireClose   : Boolean;

    procedure Init; virtual;
    procedure InitDefaults; virtual;

    procedure Log(const LogType: THTTPClientLogType; const Msg: String; const Level: Integer = 0); overload;
    procedure Log(const LogType: THTTPClientLogType; const Msg: String; const Args: array of const; const Level: Integer = 0); overload;
    procedure LogDebug(const Msg: String; const Level: Integer = 0); overload;
    procedure LogDebug(const Msg: String; const Args: array of const; const Level: Integer = 0); overload;
    procedure LogParameter(const Msg: String; const Args: array of const; const Level: Integer = 0);

    procedure Lock;
    procedure Unlock;

    function  GetState: TF5HTTPClientState;
    function  GetStateStr: String;
    procedure SetState(const State: TF5HTTPClientState);

    procedure CheckNotActive;
    function  IsBusyStarting: Boolean;
    function  IsBusyWithRequest: Boolean;
    procedure CheckNotBusyWithRequest;

    procedure SetAddressFamily(const AAddressFamily: THTTPClientAddressFamily);
    procedure SetHost(const AHost: String);
    procedure SetPort(const APort: String);
    function  GetPortInt: Int32;
    procedure SetPortInt(const APortInt: Int32);

    {$IFDEF HTTP_TLS}
    procedure SetUseHTTPS(const UseHTTPS: Boolean);
    procedure SetHTTPSOptions(const HTTPSOptions: THTTPSClientOptions);
    {$ENDIF}

    procedure SetUseHTTPProxy(const AUseHTTPProxy: Boolean);
    procedure SetHTTPProxyHost(const AHTTPProxyHost: String);
    procedure SetHTTPProxyPort(const AHTTPProxyPort: String);

    procedure SetMethod(const AMethod: THTTPClientMethod);
    procedure SetMethodCustom(const AMethodCustom: RawByteString);
    procedure SetURI(const AURI: RawByteString);

    procedure SetUserAgent(const AUserAgent: RawByteString);
    procedure SetKeepAlive(const AKeepAlive: THTTPKeepAliveOption);
    procedure SetReferer(const AReferer: RawByteString);
    procedure SetAuthorization(const AAuthorization: RawByteString);

    function  GetCustomHeaderByName(const AFieldName: RawByteString): PHTTPCustomHeader;
    function  AddCustomHeader(const AFieldName: RawByteString): PHTTPCustomHeader;
    function  GetCustomHeader(const AFieldName: RawByteString): RawByteString;
    procedure SetCustomHeader(const AFieldName: RawByteString; const AFieldValue: RawByteString);

    procedure SetRequestContentType(const ARequestContentType: RawByteString);
    function  GetRequestContentMechanism: THTTPContentWriterMechanism;
    procedure SetRequestContentMechanism(const ARequestContentMechanism: THTTPContentWriterMechanism);
    function  GetRequestContentStr: RawByteString;
    procedure SetRequestContentStr(const ARequestContentStr: RawByteString);
    function  GetRequestContentStream: TStream;
    procedure SetRequestContentStream(const ARequestContentStream: TStream);
    function  GetRequestContentFileName: String;
    procedure SetRequestContentFileName(const ARequestContentFileName: String);

    function  GetResponseContentMechanism: THTTPContentReaderMechanism;
    procedure SetResponseContentMechanism(const AResponseContentMechanism: THTTPContentReaderMechanism);
    function  GetResponseContentFileName: String;
    procedure SetResponseContentFileName(const AResponseContentFileName: String);
    function  GetResponseContentStream: TStream;
    procedure SetResponseContentStream(const AResponseContentStream: TStream);

    procedure LogTriggerException(const TriggerName: String; const E: Exception);

    procedure TriggerStateChanged;
    procedure TriggerActive;
    procedure TriggerStart;
    procedure TriggerResponseHeader;
    procedure TriggerResponseContentBuffer(const Buf; const BufSize: Integer);
    procedure TriggerResponseContentComplete;
    procedure TriggerResponseComplete;
    procedure TriggerStop;
    procedure TriggerInactive;

    procedure ProcessResponseHeader;
    procedure SetResponseComplete;
    procedure SetResponseCompleteThenClosed;

    procedure InitTCPClientHost;
    procedure InitTCPClient;

    procedure TCPClientLog(Client: TF5TCPClient; LogType: TTCPClientLogType; Msg: String; LogLevel: Integer);
    procedure TCPClientIdle(Client: TF5TCPClient);
    procedure TCPClientStateChanged(Client: TF5TCPClient; State: TTCPClientState);
    procedure TCPClientError(Client: TF5TCPClient; ErrorMsg: String; ErrorCode: Integer);
    procedure TCPClientConnected(Client: TF5TCPClient);
    procedure TCPClientConnectFailed(Client: TF5TCPClient);
    procedure TCPClientReady(Client: TF5TCPClient);
    procedure TCPClientRead(Client: TF5TCPClient);
    procedure TCPClientWrite(Client: TF5TCPClient);
    procedure TCPClientClose(Client: TF5TCPClient);

    procedure ResetRequest;

    procedure SetErrorMsg(const ErrorMsg: String);
    procedure SetRequestFailedFromException(const E: Exception);

    procedure StartTCPClient;
    procedure ClientStart;

    procedure StopTCPClient;
    procedure ClientStop;

    procedure ClientSetActive;
    procedure ClientSetInactive;

    procedure SetActive(const AActive: Boolean);

    function  InitRequestContent(out HasContent: Boolean): Int64;
    procedure FinaliseRequestContent;

    procedure PrepareHTTPRequest;
    function  GetHTTPRequestStr: RawByteString;

    procedure SendStr(const S: RawByteString);
    procedure SendRequest;

    procedure InitResponseContent;
    procedure HandleResponseContent(const Buf; const Size: Integer);
    procedure FinaliseResponseContent(const Success: Boolean);

    procedure ContentWriterLog(const Sender: THTTPContentWriter; const LogMsg: String);
    function  ContentWriterWriteProc(const Sender: THTTPContentWriter;
              const Buf; const Size: Integer): Integer;

    procedure ContentReaderLog(const Sender: THTTPContentReader; const LogMsg: String; const LogLevel: Integer);
    function  ContentReaderReadProc(const Sender: THTTPContentReader;
              var Buf; const Size: Integer): Integer;
    procedure ContentReaderContentProc(const Sender: THTTPContentReader;
              const Buf; const Size: Integer);
    procedure ContentReaderCompleteProc(const Sender: THTTPContentReader);

    procedure ReadResponseHeader;
    procedure ReadResponseContent;
    procedure ReadResponse;

    function  GetResponseRecord: THTTPResponseRec;

    function  GetResponseContentStr: RawByteString;

  public
    constructor Create;
    destructor Destroy; override;

    property  OnLog: THTTPClientLogEvent read FOnLog write FOnLog;

    property  OnStateChange: THTTPClientStateEvent read FOnStateChange write FOnStateChange;
    property  OnActive: THTTPClientEvent read FOnActive write FOnActive;
    property  OnStart: THTTPClientEvent read FOnStart write FOnStart;
    property  OnResponseHeader: THTTPClientEvent read FOnResponseHeader write FOnResponseHeader;
    property  OnResponseContentBuffer: THTTPClientContentEvent read FOnResponseContentBuffer write FOnResponseContentBuffer;
    property  OnResponseContentComplete: THTTPClientEvent read FOnResponseContentComplete write FOnResponseContentComplete;
    property  OnResponseComplete: THTTPClientEvent read FOnResponseComplete write FOnResponseComplete;
    property  OnStop: THTTPClientEvent read FOnStop write FOnStop;
    property  OnInactive: THTTPClientEvent read FOnInactive write FOnInactive;

    property  AddressFamily: THTTPClientAddressFamily read FAddressFamily write SetAddressFamily default cafIP4;
    property  Host: String read FHost write SetHost;
    property  Port: String read FPort write SetPort;
    property  PortInt: Int32 read GetPortInt write SetPortInt;

    {$IFDEF HTTP_TLS}
    property  UseHTTPS: Boolean read FUseHTTPS write SetUseHTTPS default False;
    property  HTTPSOptions: THTTPSClientOptions read FHTTPSOptions write SetHTTPSOptions default [];
    {$ENDIF}

    property  UseHTTPProxy: Boolean read FUseHTTPProxy write SetUseHTTPProxy default False;
    property  HTTPProxyHost: String read FHTTPProxyHost write SetHTTPProxyHost;
    property  HTTPProxyPort: String read FHTTPProxyPort write SetHTTPProxyPort;

    property  Method: THTTPClientMethod read FMethod write SetMethod default cmGET;
    property  MethodCustom: RawByteString read FMethodCustom write SetMethodCustom;
    property  URI: RawByteString read FURI write SetURI;

    property  UserAgent: RawByteString read FUserAgent write SetUserAgent;
    property  KeepAlive: THTTPKeepAliveOption read FKeepAlive write SetKeepAlive default kaDefault;
    property  Referer: RawByteString read FReferer write SetReferer;
    property  Cookie: RawByteString read FCookie write FCookie;
    property  Authorization: RawByteString read FAuthorization write SetAuthorization;
    procedure SetBasicAuthorization(const Username, Password: RawByteString);
    property  CustomHeader[const FieldName: RawByteString]: RawByteString read GetCustomHeader write SetCustomHeader;

    property  RequestContentType: RawByteString read FRequestContentType write SetRequestContentType;
    property  RequestContentMechanism: THTTPContentWriterMechanism read GetRequestContentMechanism write SetRequestContentMechanism default hctmString;
    property  RequestContentStr: RawByteString read GetRequestContentStr write SetRequestContentStr;
    property  RequestContentStream: TStream read GetRequestContentStream write SetRequestContentStream;
    property  RequestContentFileName: String read GetRequestContentFileName write SetRequestContentFileName;

    procedure SetRequestContentWwwFormUrlEncodedField(const FieldName, FieldValue: RawByteString);

    property  ResponseContentMechanism: THTTPContentReaderMechanism read GetResponseContentMechanism write SetResponseContentMechanism default hcrmEvent;
    property  ResponseContentFileName: String read GetResponseContentFileName write SetResponseContentFileName;
    property  ResponseContentStream: TStream read GetResponseContentStream write SetResponseContentStream;

    property  State: TF5HTTPClientState read GetState;
    property  StateStr: String read GetStateStr;
    property  ErrorMsg: String read FErrorMsg;

    property  Active: Boolean read FActive write SetActive default False;
    procedure Start;
    procedure Stop;

    procedure Request;

    function  RequestIsBusy: Boolean;
    function  RequestIsSuccess: Boolean;

    property  ResponseRecord: THTTPResponseRec read GetResponseRecord;

    property  ResponseCode: Integer read FResponseCode;
    property  ResponseCookies: TStrings read FResponseCookies;
    property  ResponseContentStr: RawByteString read GetResponseContentStr;

    function  WaitReadyForRequest(const Timeout: Integer): Boolean;
    function  WaitForRequestComplete(const Timeout: Integer): Boolean;

    property  UserObject: TObject read FUserObject write FUserObject;
    property  UserData: Pointer read FUserData write FUserData;
    property  UserTag: NativeInt read FUserTag write FUserTag;
  end;

  EHTTPClient = class(Exception);



{                                                                              }
{ HTTP Client Collection                                                       }
{                                                                              }
type
  THTTPClientCollection = class
  private
    FItemOwner : Boolean;
    FList : array of TF5HTTPClient;

    function  GetCount: NativeInt;
    function  GetItem(const Idx: NativeInt): TF5HTTPClient;

  protected
    function  CreateNew: TF5HTTPClient; virtual;

  public
    constructor Create(const ItemOwner: Boolean);
    destructor Destroy; override;

    property  ItemOwner: Boolean read FItemOwner;
    property  Count: NativeInt read GetCount;
    property  Item[const Idx: NativeInt]: TF5HTTPClient read GetItem; default;
    function  Add(const Item: TF5HTTPClient): NativeInt;
    function  AddNew: TF5HTTPClient;
    function  GetItemIndex(const Item: TF5HTTPClient): NativeInt;
    procedure RemoveByIndex(const Idx: NativeInt);
    function  Remove(const Item: TF5HTTPClient): Boolean;
    procedure Clear;
  end;

  EHTTPClientCollection = class(Exception);



implementation

uses
  { Fundamentals }
  flcBase64,
  flcStringBuilder,
  flcDateTime,
  flcSocketLib,
  {$IFDEF HTTP_TLS}
  flcTLSTransportClient,
  {$ENDIF}
  flcTCPUtils;



{                                                                              }
{ HTTP Client constants                                                        }
{                                                                              }
const
  HTTPCLIENT_PORT     = 80;
  HTTPCLIENT_PORT_STR = '80';

  HTTPCLIENT_METHOD_GET  = 'GET';
  HTTPCLIENT_METHOD_POST = 'POST';

  HTTPCLIENT_ResponseHeader_MaxSize  = 16384;
  HTTPCLIENT_ResponseHeader_Delim    = #13#10#13#10;
  HTTPCLIENT_ResponseHeader_DelimLen = Length(HTTPCLIENT_ResponseHeader_Delim);

  HTTPCLIENT_Default_UserAgent =
      'Mozilla/5.0 (compatible; ' +
      {$IFDEF WIN64}
      'Windows NT 10.0; Win64; x64; ' +
      {$ELSE}{$IFDEF WIN32}
      'Win32; ' +
      {$ELSE}{$IFDEF LINUX}
      'Linux; ' +
      {$ELSE}{$IFDEF IOS}
      'iOS; ' +
      {$ELSE}{$IFDEF ANDROID}
      'Android; ' +
      {$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}
      'FCL-HTTP/5.0) ' +
      'AppleWebKit/537.36 (KHTML, like Gecko) ' +
      {$IFDEF OS_MOBILE}
      'Mobile ' +
      {$ENDIF}
      'Safari/537.36 ' +
      'Fundamentals/5.0 (HTTP' +
      {$IFDEF TLS}
      '; HTTPS' +
      {$ENDIF}
      ')';

  HTTP5ClientState_All = [
    hcsInit,
    hcsStarting,
    hcsStopping,
    hcsStopped,
    hcsConnectFailed,
    hcsConnectedReady,
    hcsSendingRequest,
    hcsSendingContent,
    hcsAwaitingResponse,
    hcsReceivedResponse,
    hcsReceivingContent,
    hcsResponseComplete,
    hcsResponseCompleteAndClosing,
    hcsResponseCompleteAndClosed,
    hcsRequestInterruptedAndClosed,
    hcsRequestFailed
  ];

  HTTP5ClientState_BusyWithRequest = [
    hcsSendingRequest,
    hcsSendingContent,
    hcsAwaitingResponse,
    hcsReceivedResponse,
    hcsReceivingContent
  ];

  HTTP5ClientState_Closed = [
    hcsInit,
    hcsStopped,
    hcsConnectFailed,
    hcsResponseCompleteAndClosed,
    hcsRequestInterruptedAndClosed
  ];

  HTTP5ClientState_ResponseComplete = [
    hcsResponseComplete,
    hcsResponseCompleteAndClosing,
    hcsResponseCompleteAndClosed
  ];



{                                                                              }
{ Errors and debug strings                                                     }
{                                                                              }
const
  SError_NotAllowedWhileActive          = 'Operation not allowed while active';
  SError_NotAllowedWhileBusyWithRequest = 'Operation not allowed while busy with request';
  SError_NotActive                      = 'Not active';
  SError_NotConnected                   = 'Not connected';

  SError_MethodNotSet     = 'Method not set';
  SError_URINotSet        = 'URI not set';
  SError_HostNotSet       = 'Host not set';
  SError_InvalidParameter = 'Invalid parameter';

  SClientState : array[TF5HTTPClientState] of String = (
      'Initialise',
      'Starting',
      'ConnectFailed',
      'Connected',
      'SendingRequest',
      'SendingContent',
      'AwaitingResponse',
      'ReceivedResponse',
      'ReceivingContent',
      'ResponseComplete',
      'ResponseCompleteAndClosing',
      'ResponseCompleteAndClosed',
      'RequestInterruptedAndClosed',
      'RequestFailed',
      'Stopping',
      'Stopped'
      );



{                                                                              }
{ THTTPClient                                                                  }
{                                                                              }
constructor TF5HTTPClient.Create;
begin
  inherited Create;
  Init;
end;

procedure TF5HTTPClient.Init;
begin
  FLock := TCriticalSection.Create;

  FReadyEvent := TSimpleEvent.Create;
  FReadyEvent.ResetEvent;

  FRequestCompleteEvent := TSimpleEvent.Create;
  FRequestCompleteEvent.ResetEvent;

  FResponseCookies := TStringList.Create;

  FHTTPParser := THTTPParser.Create;

  FRequestContentWriter := THTTPContentWriter.Create(
      ContentWriterWriteProc);
  FRequestContentWriter.OnLog := ContentWriterLog;

  FResponseContentReader := THTTPContentReader.Create(
      ContentReaderReadProc,
      ContentReaderContentProc,
      ContentReaderCompleteProc);
  FResponseContentReader.OnLog := ContentReaderLog;

  FState := hcsInit;

  FRequestObj := THTTPRequestObj.Create;
  FResponseObj := THTTPResponseObj.Create;

  InitDefaults;
end;

procedure TF5HTTPClient.InitDefaults;
begin
  FMethod := cmGET;
  FPort := HTTPCLIENT_PORT_STR;

  {$IFDEF HTTP_TLS}
  FUseHTTPS := False;
  FHTTPSOptions := [];
  {$ENDIF}

  FUseHTTPProxy := False;
  FUserAgent := HTTPCLIENT_Default_UserAgent;
  FRequestContentWriter.Mechanism := hctmString;
  FResponseContentReader.Mechanism := hcrmEvent;
  FUserObject := nil;
  FUserData := nil;
  FUserTag := 0;
end;

destructor TF5HTTPClient.Destroy;
begin
  if Assigned(FTCPClient) then
    begin
      FTCPClient.Finalise;
      FreeAndNil(FTCPClient);
    end;
  FreeAndNil(FRequestContentWriter);
  FreeAndNil(FResponseContentReader);
  FreeAndNil(FHTTPParser);
  FreeAndNil(FResponseCookies);
  FreeAndNil(FResponseObj);
  FreeAndNil(FRequestObj);
  FreeAndNil(FRequestCompleteEvent);
  FreeAndNil(FReadyEvent);
  FreeAndNil(FLock);
  inherited Destroy;
end;

procedure TF5HTTPClient.Log(const LogType: THTTPClientLogType; const Msg: String; const Level: Integer);
begin
  if Assigned(FOnLog) then
    FOnLog(self, LogType, Msg, Level);
end;

procedure TF5HTTPClient.Log(const LogType: THTTPClientLogType; const Msg: String; const Args: array of const; const Level: Integer);
begin
  Log(LogType, Format(Msg, Args), Level);
end;

procedure TF5HTTPClient.LogDebug(const Msg: String; const Level: Integer); {$IFDEF UseInline}inline;{$ENDIF}
begin
  {$IFDEF HTTP_DEBUG}
  Log(cltDebug, Msg, Level);
  {$ENDIF}
end;

procedure TF5HTTPClient.LogDebug(const Msg: String; const Args: array of const; const Level: Integer);
begin
  {$IFDEF HTTP_DEBUG}
  Log(cltDebug, Msg, Args, Level);
  {$ENDIF}
end;

procedure TF5HTTPClient.LogParameter(const Msg: String; const Args: array of const; const Level: Integer = 0);
begin
  Log(cltParameter, Msg, Args, Level);
end;

procedure TF5HTTPClient.Lock;
begin
  FLock.Acquire;
end;

procedure TF5HTTPClient.Unlock;
begin
  FLock.Release;
end;

function TF5HTTPClient.GetState: TF5HTTPClientState;
begin
  Lock;
  try
    Result := FState;
  finally
    Unlock;
  end;
end;

function TF5HTTPClient.GetStateStr: String;
var
  St : String;
begin
  Lock;
  try
    St := SClientState[FState];
    if FErrorMsg <> '' then
      if FState in [
          hcsStopped,
          hcsConnectFailed,
          hcsRequestInterruptedAndClosed,
          hcsRequestFailed] then
        St := St + ': ' + FErrorMsg;
  finally
    Unlock;
  end;
  Result := St;
end;

procedure TF5HTTPClient.SetState(const State: TF5HTTPClientState);
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

procedure TF5HTTPClient.CheckNotActive;
begin
  if FActive then
    raise EHTTPClient.Create(SError_NotAllowedWhileActive);
end;

function TF5HTTPClient.IsBusyStarting: Boolean;
begin
  Result := (FState = hcsStarting);
end;

function TF5HTTPClient.IsBusyWithRequest: Boolean;
begin
  Result := False;
  if FActive then
    if FState in HTTP5ClientState_BusyWithRequest then
      Result := True
    else
    if FRequestPending and (FState in [hcsStarting, hcsConnectedReady]) then
      Result := True;
end;

procedure TF5HTTPClient.CheckNotBusyWithRequest;
begin
  Lock;
  try
    if IsBusyWithRequest then
      raise EHTTPClient.Create(SError_NotAllowedWhileBusyWithRequest);
  finally
    Unlock;
  end;
end;

procedure TF5HTTPClient.SetAddressFamily(const AAddressFamily: THTTPClientAddressFamily);
begin
  if AAddressFamily = FAddressFamily then
    exit;
  CheckNotBusyWithRequest;
  FAddressFamily := AAddressFamily;
end;

procedure TF5HTTPClient.SetHost(const AHost: String);
begin
  if AHost = FHost then
    exit;
  CheckNotBusyWithRequest;
  FHost := AHost;

  LogParameter('Host:%s', [AHost]);
end;

procedure TF5HTTPClient.SetPort(const APort: String);
begin
  if APort = FPort then
    exit;
  CheckNotBusyWithRequest;
  FPort := APort;

  LogParameter('Port:%s', [APort]);
end;

function TF5HTTPClient.GetPortInt: Int32;
begin
  Result := StrToIntDef(FPort, -1);
end;

procedure TF5HTTPClient.SetPortInt(const APortInt: Int32);
begin
  if (APortInt <= 0) or (APortInt >= $FFFF) then
    raise EHTTPClient.Create(SError_InvalidParameter);
  SetPort(IntToStr(APortInt));
end;

{$IFDEF HTTP_TLS}
procedure TF5HTTPClient.SetUseHTTPS(const UseHTTPS: Boolean);
begin
  if UseHTTPS = FUseHTTPS then
    exit;
  CheckNotBusyWithRequest;
  FUseHTTPS := UseHTTPS;

  LogParameter('UseHTTPS:%d', [Ord(UseHTTPS)]);
end;

procedure TF5HTTPClient.SetHTTPSOptions(const HTTPSOptions: THTTPSClientOptions);
begin
  if HTTPSOptions = FHTTPSOptions then
    exit;
  CheckNotBusyWithRequest;
  FHTTPSOptions := HTTPSOptions;
end;
{$ENDIF}

procedure TF5HTTPClient.SetUseHTTPProxy(const AUseHTTPProxy: Boolean);
begin
  if AUseHTTPProxy = FUseHTTPProxy then
    exit;
  CheckNotBusyWithRequest;
  FUseHTTPProxy := AUseHTTPProxy;
end;

procedure TF5HTTPClient.SetHTTPProxyHost(const AHTTPProxyHost: String);
begin
  if AHTTPProxyHost = FHTTPProxyHost then
    exit;
  CheckNotBusyWithRequest;
  FHTTPProxyHost := AHTTPProxyHost;
end;

procedure TF5HTTPClient.SetHTTPProxyPort(const AHTTPProxyPort: String);
begin
  if AHTTPProxyPort = FHTTPProxyPort then
    exit;
  CheckNotBusyWithRequest;
  FHTTPProxyPort := AHTTPProxyPort;
end;

procedure TF5HTTPClient.SetMethod(const AMethod: THTTPClientMethod);
begin
  if AMethod = FMethod then
    exit;
  CheckNotBusyWithRequest;
  FMethod := AMethod;
end;

procedure TF5HTTPClient.SetMethodCustom(const AMethodCustom: RawByteString);
begin
  if AMethodCustom = FMethodCustom then
    exit;
  CheckNotBusyWithRequest;
  FMethodCustom := AMethodCustom;
end;

procedure TF5HTTPClient.SetURI(const AURI: RawByteString);
begin
  if AURI = FURI then
    exit;
  CheckNotBusyWithRequest;
  FURI := AURI;

  LogParameter('URI:%s', [AURI]);
end;

procedure TF5HTTPClient.SetUserAgent(const AUserAgent: RawByteString);
begin
  if AUserAgent = FUserAgent then
    exit;
  CheckNotBusyWithRequest;
  FUserAgent := AUserAgent;

  LogParameter('UserAgent:%s', [AUserAgent]);
end;

procedure TF5HTTPClient.SetKeepAlive(const AKeepAlive: THTTPKeepAliveOption);
begin
  if AKeepAlive = FKeepAlive then
    exit;
  CheckNotBusyWithRequest;
  FKeepAlive := AKeepAlive;
end;

procedure TF5HTTPClient.SetReferer(const AReferer: RawByteString);
begin
  if AReferer = FReferer then
    exit;
  CheckNotBusyWithRequest;
  FReferer := AReferer;

  LogParameter('Referer:%s', [AReferer]);
end;

procedure TF5HTTPClient.SetAuthorization(const AAuthorization: RawByteString);
begin
  if AAuthorization = FAuthorization then
    exit;
  CheckNotBusyWithRequest;
  FAuthorization := AAuthorization;
end;

procedure TF5HTTPClient.SetBasicAuthorization(const Username, Password: RawByteString);
begin
  SetAuthorization('Basic ' + MIMEBase64Encode(Username + ':' + Password));
end;

function TF5HTTPClient.GetCustomHeaderByName(const AFieldName: RawByteString): PHTTPCustomHeader;
begin
  Result := HTTPCustomHeadersGetByName(FCustomHeaders, AFieldName);
end;

function TF5HTTPClient.AddCustomHeader(const AFieldName: RawByteString): PHTTPCustomHeader;
var
  P : PHTTPCustomHeader;
begin
  Assert(AFieldName <> '');
  P := HTTPCustomHeadersAdd(FCustomHeaders);
  P^.FieldName := AFieldName;
  Result := P;
end;

function TF5HTTPClient.GetCustomHeader(const AFieldName: RawByteString): RawByteString;
var
  P : PHTTPCustomHeader;
begin
  P := GetCustomHeaderByName(AFieldName);
  if Assigned(P) then
    Result := P^.FieldValue
  else
    Result := '';
end;

procedure TF5HTTPClient.SetCustomHeader(const AFieldName: RawByteString; const AFieldValue: RawByteString);
var
  P : PHTTPCustomHeader;
begin
  P := GetCustomHeaderByName(AFieldName);
  if Assigned(P) then
    if StrEqualNoAsciiCaseB(AFieldValue, P^.FieldValue) then
      exit;
  CheckNotBusyWithRequest;
  if not Assigned(P) then
    P := AddCustomHeader(AFieldName);
  Assert(Assigned(P));
  P^.FieldValue := AFieldValue;

  LogParameter('HTTP-Header:%s=%s', [AFieldName, AFieldValue]);
end;

procedure TF5HTTPClient.SetRequestContentType(const ARequestContentType: RawByteString);
begin
  if ARequestContentType = FRequestContentType then
    exit;
  CheckNotBusyWithRequest;
  FRequestContentType := ARequestContentType;

  LogParameter('Request-ContentType:%s', [ARequestContentType]);
end;

function TF5HTTPClient.GetRequestContentMechanism: THTTPContentWriterMechanism;
begin
  Result := FRequestContentWriter.Mechanism;
end;

procedure TF5HTTPClient.SetRequestContentMechanism(const ARequestContentMechanism: THTTPContentWriterMechanism);
begin
  if ARequestContentMechanism = FRequestContentWriter.Mechanism then
    exit;
  CheckNotBusyWithRequest;
  FRequestContentWriter.Mechanism := ARequestContentMechanism;
end;

function TF5HTTPClient.GetRequestContentStr: RawByteString;
begin
  Result := FRequestContentWriter.ContentString;
end;

procedure TF5HTTPClient.SetRequestContentStr(const ARequestContentStr: RawByteString);
begin
  if ARequestContentStr = FRequestContentWriter.ContentString then
    exit;
  CheckNotBusyWithRequest;
  FRequestContentWriter.ContentString := ARequestContentStr;
end;

function TF5HTTPClient.GetRequestContentStream: TStream;
begin
  Result := FRequestContentWriter.ContentStream;
end;

procedure TF5HTTPClient.SetRequestContentStream(const ARequestContentStream: TStream);
begin
  if ARequestContentStream = FRequestContentWriter.ContentStream then
    exit;
  CheckNotBusyWithRequest;
  FRequestContentWriter.ContentStream := ARequestContentStream;
end;

function TF5HTTPClient.GetRequestContentFileName: String;
begin
  Result := FRequestContentWriter.ContentFileName;
end;

procedure TF5HTTPClient.SetRequestContentFileName(const ARequestContentFileName: String);
begin
  if ARequestContentFileName = FRequestContentWriter.ContentFileName then
    exit;
  CheckNotBusyWithRequest;
  FRequestContentWriter.ContentFileName := ARequestContentFileName;
end;

procedure TF5HTTPClient.SetRequestContentWwwFormUrlEncodedField(const FieldName, FieldValue: RawByteString);
var
  Req, S : RawByteString;
begin
  Req := GetRequestContentStr;
  if Req <> '' then
    S := '&'
  else
    S := '';
  S := S + FieldName + '=' + FieldValue;
  Req := Req + S;
  SetRequestContentType('application/x-www-form-urlencoded');
  SetRequestContentStr(Req);
end;

function TF5HTTPClient.GetResponseContentMechanism: THTTPContentReaderMechanism;
begin
  Result := FResponseContentReader.Mechanism;
end;

procedure TF5HTTPClient.SetResponseContentMechanism(const AResponseContentMechanism: THTTPContentReaderMechanism);
begin
  if AResponseContentMechanism = FResponseContentReader.Mechanism then
    exit;
  CheckNotBusyWithRequest;
  FResponseContentReader.Mechanism := AResponseContentMechanism;
end;

function TF5HTTPClient.GetResponseContentFileName: String;
begin
  Result := FResponseContentReader.ContentFileName;
end;

procedure TF5HTTPClient.SetResponseContentFileName(const AResponseContentFileName: String);
begin
  if AResponseContentFileName = FResponseContentReader.ContentFileName then
    exit;
  CheckNotBusyWithRequest;
  FResponseContentReader.ContentFileName := AResponseContentFileName;
end;

function TF5HTTPClient.GetResponseContentStream: TStream;
begin
  Result := FResponseContentReader.ContentStream;
end;

procedure TF5HTTPClient.SetResponseContentStream(const AResponseContentStream: TStream);
begin
  if AResponseContentStream = FResponseContentReader.ContentStream then
    exit;
  CheckNotBusyWithRequest;
  FResponseContentReader.ContentStream := AResponseContentStream;
end;

procedure TF5HTTPClient.LogTriggerException(const TriggerName: String; const E: Exception);
begin
  Log(cltError, 'Trigger%s.Error:Error=%s:%s', [TriggerName, E.ClassName, E.Message]);
end;

procedure TF5HTTPClient.TriggerStateChanged;
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('State=%s', [GetStateStr]);
  {$ENDIF}

  if Assigned(FOnStateChange) then
    try
      FOnStateChange(self, FState);
    except
      on E : Exception do LogTriggerException('StateChanged', E);
    end;
end;

procedure TF5HTTPClient.TriggerActive;
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('Active');
  {$ENDIF}

  if Assigned(FOnActive) then
    try
      FOnActive(self);
    except
      on E : Exception do LogTriggerException('Active', E);
    end;
end;

procedure TF5HTTPClient.TriggerStart;
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('Start');
  {$ENDIF}

  if Assigned(FOnStart) then
    try
      FOnStart(self);
    except
      on E : Exception do LogTriggerException('Start', E);
    end;
end;

procedure TF5HTTPClient.TriggerResponseHeader;
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('ResponseHeader:'#13#10'%s',
      [Copy(FResponseObj.GetString, 1, 128)]);
  {$ENDIF}

  if Assigned(FOnResponseHeader) then
    try
      FOnResponseHeader(self);
    except
      on E : Exception do LogTriggerException('ResponseHeader', E);
    end;
end;

procedure TF5HTTPClient.TriggerResponseContentBuffer(const Buf; const BufSize: Integer);
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('ContentBuffer:%db', [BufSize]);
  {$ENDIF}

  if Assigned(FOnResponseContentBuffer) then
    try
      FOnResponseContentBuffer(self, Buf, BufSize);
    except
      on E : Exception do LogTriggerException('ResponseContentBuffer', E);
    end;
end;

procedure TF5HTTPClient.TriggerResponseContentComplete;
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('ContentComplete');
  {$ENDIF}

  if Assigned(FOnResponseContentComplete) then
    try
      FOnResponseContentComplete(self);
    except
      on E : Exception do LogTriggerException('ResponseContentComplete', E);
    end;
end;

procedure TF5HTTPClient.TriggerResponseComplete;
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('ResponseComplete');
  {$ENDIF}

  if Assigned(FOnResponseComplete) then
    try
      FOnResponseComplete(self);
    except
      on E : Exception do LogTriggerException('ResponseComplete', E);
    end;
end;

procedure TF5HTTPClient.TriggerStop;
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('Stop');
  {$ENDIF}

  if Assigned(FOnStop) then
    try
      FOnStop(self);
    except
      on E : Exception do LogTriggerException('Stop', E);
    end;
end;

procedure TF5HTTPClient.TriggerInactive;
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('Inactive');
  {$ENDIF}

  if Assigned(FOnInactive) then
    try
      FOnInactive(self);
    except
      on E : Exception do LogTriggerException('Inactive', E);
    end;
end;

procedure TF5HTTPClient.ProcessResponseHeader;
var
  L, I : Integer;
  B : TRawByteStringBuilder;
begin
  FResponseCode := FResponseObj.RecPtr^.StartLine.Code;
  B := TRawByteStringBuilder.Create;
  try
    L := Length(FResponseObj.RecPtr^.Header.SetCookies);
    FResponseCookies.Clear;
    for I := 0 to L - 1 do
      begin
        B.Clear;
        BuildStrHTTPSetCookieFieldValue(FResponseObj.RecPtr^.Header.SetCookies[I], B, []);
        {$IFDEF StringIsUnicode}
        FResponseCookies.Add(B.AsString);
        {$ELSE}
        FResponseCookies.Add(String(B.AsRawByteString));
        {$ENDIF}
      end;
    FResponseRequireClose :=
      ( (FResponseObj.HTTPVersion = hvHTTP10) and
        (FResponseObj.HeaderConnection = hcfNone)
      )
      or
      ( FResponseObj.HeaderConnection = hcfClose );
  finally
    B.Free;
  end;
end;

procedure TF5HTTPClient.SetResponseComplete;
begin
  if FState in [
      hcsResponseCompleteAndClosing,
      hcsResponseCompleteAndClosed,
      hcsResponseComplete,
      hcsRequestInterruptedAndClosed,
      hcsRequestFailed] then
    exit;

  SetState(hcsResponseComplete);
  TriggerResponseComplete;

  FRequestCompleteEvent.SetEvent;

  if FResponseRequireClose then
    begin
      SetState(hcsResponseCompleteAndClosing);
      FTCPClient.Connection.Shutdown;
    end;
end;

procedure TF5HTTPClient.SetResponseCompleteThenClosed;
begin
  Assert(FState in [hcsReceivedResponse, hcsReceivingContent]);

  SetState(hcsResponseComplete);
  TriggerResponseComplete;

  FRequestCompleteEvent.SetEvent;

  SetState(hcsResponseCompleteAndClosed);
end;

procedure TF5HTTPClient.InitTCPClientHost;
begin
  Assert(Assigned(FTCPClient));

  case FAddressFamily of
    cafIP4 : FTCPClient.AddressFamily := flcTCPClient.cafIP4;
    cafIP6 : FTCPClient.AddressFamily := flcTCPClient.cafIP6;
  else
    raise EHTTPClient.Create('Invalid HTTP client address family');
  end;
  if FHost = '' then
    raise EHTTPClient.Create(SError_HostNotSet);
  FTCPClient.Host := FHost;
  FTCPClient.Port := FPort;
  FTCPClient.LocalHost := '0.0.0.0';
end;

procedure TF5HTTPClient.InitTCPClient;
{$IFDEF HTTP_TLS}
var
  TLSOpt : TTCPClientTLSOptions;
{$ENDIF}
begin
  FTCPClient := TF5TCPClient.Create(nil);
  try
    FTCPClient.OnLog := TCPClientLog;
    FTCPClient.OnStateChanged := TCPClientStateChanged;
    FTCPClient.OnError := TCPClientError;
    FTCPClient.OnProcessThreadIdle := TCPClientIdle;
    FTCPClient.OnConnected := TCPClientConnected;
    FTCPClient.OnConnectFailed := TCPClientConnectFailed;
    FTCPClient.OnReady := TCPClientReady;
    FTCPClient.OnRead := TCPClientRead;
    FTCPClient.OnWrite := TCPClientWrite;
    FTCPClient.OnClose := TCPClientClose;
    {$IFDEF TCPCLIENT_SOCKS}
    FTCPClient.SocksEnabled := False;
    {$ENDIF}
    {$IFDEF HTTP_TLS}
    FTCPClient.TLSEnabled := FUseHTTPS;
    TLSOpt := [];
    /////
    (*
    if csoDontUseSSL3 in FHTTPSOptions then
      Include(TLSOpt, ctoDisableSSL3);
    if csoDontUseTLS10 in FHTTPSOptions then
      Include(TLSOpt, ctoDisableTLS10);
    if csoDontUseTLS11 in FHTTPSOptions then
      Include(TLSOpt, ctoDisableTLS11);
    if csoDontUseTLS12 in FHTTPSOptions then
      Include(TLSOpt, ctoDisableTLS12);
    *)
    FTCPClient.TLSOptions := TLSOpt;
    {$ENDIF}
    InitTCPClientHost;
  except
    FreeAndNil(FTCPClient);
    raise;
  end;
end;

procedure TF5HTTPClient.TCPClientLog(Client: TF5TCPClient; LogType: TTCPClientLogType; Msg: String; LogLevel: Integer);
begin
  {$IFDEF HTTP_LOG_DEBUG_TCP}
  LogDebug('TCP.%s', [Msg], LogLevel + 1);
  {$ENDIF}
end;

procedure TF5HTTPClient.TCPClientIdle(Client: TF5TCPClient);
begin
end;

procedure TF5HTTPClient.TCPClientStateChanged(Client: TF5TCPClient; State: TTCPClientState);
begin
  {$IFDEF HTTP_LOG_DEBUG_TCP}
  LogDebug('TCP_StateChanged.State=%s', [Client.StateStr]);
  {$ENDIF}
end;

procedure TF5HTTPClient.TCPClientError(Client: TF5TCPClient; ErrorMsg: String; ErrorCode: Integer);
begin
  {$IFDEF HTTP_LOG_DEBUG_TCP}
  LogDebug('TCP_Error.Error=%d:%s', [ErrorCode, ErrorMsg]);
  {$ENDIF}
end;

procedure TF5HTTPClient.TCPClientConnected(Client: TF5TCPClient);
begin
  {$IFDEF HTTP_LOG_DEBUG_TCP}
  LogDebug('TCP_Connected');
  {$ENDIF}
end;

procedure TF5HTTPClient.TCPClientConnectFailed(Client: TF5TCPClient);
begin
  {$IFDEF HTTP_LOG_DEBUG_TCP}
  LogDebug('TCP_ConnectFailed');
  {$ENDIF}

  SetErrorMsg(Client.ErrorMessage);
  SetState(hcsConnectFailed);
  FReadyEvent.SetEvent;
  FRequestCompleteEvent.SetEvent;
end;

procedure TF5HTTPClient.TCPClientReady(Client: TF5TCPClient);
var
  ReqPending : Boolean;
begin
  {$IFDEF HTTP_LOG_DEBUG_TCP}
  LogDebug('TCP_Ready');
  {$ENDIF}

  SetState(hcsConnectedReady);
  FReadyEvent.SetEvent;
  Lock;
  try
    ReqPending := FRequestPending;
  finally
    Unlock;
  end;
  if ReqPending then
    try
      try
        SendRequest;
      finally
        Lock;
        try
          FRequestPending := False;
        finally
          Unlock;
        end;
      end;
    except
      on E : Exception do
        SetRequestFailedFromException(E);
    end;
end;

procedure TF5HTTPClient.TCPClientRead(Client: TF5TCPClient);
begin
  {$IFDEF HTTP_LOG_DEBUG_TCP}
  LogDebug('TCP_Read');
  {$ENDIF}
  ReadResponse;
end;

procedure TF5HTTPClient.TCPClientWrite(Client: TF5TCPClient);
begin
  {$IFDEF HTTP_LOG_DEBUG_TCP}
  LogDebug('TCP_Write');
  {$ENDIF}
end;

procedure TF5HTTPClient.TCPClientClose(Client: TF5TCPClient);
begin
  {$IFDEF HTTP_LOG_DEBUG_TCP}
  LogDebug('TCP_Close');
  {$ENDIF}

  FReadyEvent.SetEvent;
  FRequestCompleteEvent.SetEvent;

  case FState of
    hcsInit,
    hcsStopping,
    hcsConnectFailed,
    hcsResponseCompleteAndClosed,
    hcsRequestInterruptedAndClosed :
      exit;

    hcsResponseComplete,
    hcsResponseCompleteAndClosing :
      SetState(hcsResponseCompleteAndClosed);

    hcsStarting,
    hcsSendingRequest,
    hcsSendingContent,
    hcsAwaitingResponse :
      SetState(hcsRequestInterruptedAndClosed);

    hcsReceivedResponse :
      if not FResponseObj.RecPtr^.HasContent and FResponseRequireClose then
        SetResponseCompleteThenClosed
      else
        SetState(hcsRequestInterruptedAndClosed);

    hcsReceivingContent :
      if FResponseRequireClose and FResponseContentReader.ContentComplete then
        SetResponseCompleteThenClosed
      else
        SetState(hcsRequestInterruptedAndClosed);
  end;
end;

procedure TF5HTTPClient.SetErrorMsg(const ErrorMsg: String);
begin
  FErrorMsg := ErrorMsg;
end;

procedure TF5HTTPClient.SetRequestFailedFromException(const E: Exception);
begin
  SetErrorMsg(E.Message);
  SetState(hcsRequestFailed);
end;

procedure TF5HTTPClient.ClientStart;
begin
  Lock;
  try
    if not FActive or
      (FState in [
        hcsStarting,
        hcsConnectedReady,
        hcsSendingRequest,
        hcsSendingContent,
        hcsAwaitingResponse,
        hcsReceivedResponse,
        hcsReceivingContent,
        hcsResponseComplete,
        hcsRequestFailed]) then
      exit;
  finally
    Unlock;
  end;

  FReadyEvent.ResetEvent;
  FRequestCompleteEvent.ResetEvent;

  TriggerStart;

  SetState(hcsStarting);

  StartTCPClient;
end;

procedure TF5HTTPClient.StopTCPClient;
begin
  Assert(Assigned(FTCPClient));
  FTCPClient.Stop;
end;

procedure TF5HTTPClient.ClientStop;
begin
  Lock;
  try
    if not FActive or
      (FState in [
        hcsInit,
        hcsStopping,
        hcsStopped]) then
      exit;
  finally
    Unlock;
  end;
  TriggerStop;

  SetState(hcsStopping);

  try
    StopTCPClient;
  except
    on E : Exception do
      Log(cltError, 'TCP client stop error:Error=%s', [E.Message]);
  end;

  SetState(hcsStopped);
end;

procedure TF5HTTPClient.ClientSetActive;
begin
  Lock;
  try
    if FActive then
      exit;
    FActive := True;
  finally
    Unlock;
  end;
  TriggerActive;

  ClientStart;
end;

procedure TF5HTTPClient.ClientSetInactive;
begin
  Lock;
  try
    if not FActive or FIsStopping then
      exit;
    FIsStopping := True;
  finally
    Unlock;
  end;

  ClientStop;

  Lock;
  try
    FIsStopping := False;
    FActive := False;
  finally
    Unlock;
  end;

  FReadyEvent.SetEvent;
  FRequestCompleteEvent.SetEvent;

  TriggerInactive;
end;

procedure TF5HTTPClient.SetActive(const AActive: Boolean);
begin
  if AActive then
    ClientSetActive
  else
    ClientSetInactive;
end;

procedure TF5HTTPClient.Start;
begin
  ClientSetActive;
end;

procedure TF5HTTPClient.Stop;
begin
  ClientSetInactive;
end;

function TF5HTTPClient.InitRequestContent(out HasContent: Boolean): Int64;
var L : Int64;
begin
  FRequestContentWriter.InitContent(HasContent, L);
  Result := L;
end;

procedure TF5HTTPClient.FinaliseRequestContent;
begin
  FRequestContentWriter.FinaliseContent;
end;

procedure TF5HTTPClient.InitResponseContent;
begin
  FResponseContentReader.InitReader(FResponseObj.RecPtr^.Header.CommonHeaders);
end;

procedure TF5HTTPClient.HandleResponseContent(const Buf; const Size: Integer);
begin
end;

procedure TF5HTTPClient.FinaliseResponseContent(const Success: Boolean);
begin
end;

procedure TF5HTTPClient.ContentWriterLog(const Sender: THTTPContentWriter; const LogMsg: String);
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('ContentWriter.%s', [LogMsg], 1);
  {$ENDIF}
end;

function TF5HTTPClient.ContentWriterWriteProc(const Sender: THTTPContentWriter;
         const Buf; const Size: Integer): Integer;
begin
  Result := FTCPClient.Connection.Write(Buf, Size);
end;

procedure TF5HTTPClient.ContentReaderLog(const Sender: THTTPContentReader; const LogMsg: String; const LogLevel: Integer);
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('ContentReader.%s', [LogMsg], LogLevel + 1);
  {$ENDIF}
end;

function TF5HTTPClient.ContentReaderReadProc(const Sender: THTTPContentReader; var Buf; const Size: Integer): Integer;
begin
  Assert(Assigned(FTCPClient));
  Assert(FState in [hcsReceivingContent]);
  //
  Result := FTCPClient.Connection.Read(Buf, Size);

  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('ContentReader_Read:%db:%db', [Size, Result]);
  {$ENDIF}
end;

procedure TF5HTTPClient.ContentReaderContentProc(const Sender: THTTPContentReader;
    const Buf; const Size: Integer);
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('ContentReader_Content:%db', [Size]);
  {$ENDIF}

  TriggerResponseContentBuffer(Buf, Size);
  HandleResponseContent(Buf, Size);
end;

procedure TF5HTTPClient.ContentReaderCompleteProc(const Sender: THTTPContentReader);
begin
  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('ContentReader_Complete');
  {$ENDIF}

  FinaliseResponseContent(True);
  TriggerResponseContentComplete;
  SetResponseComplete;
end;

procedure TF5HTTPClient.ReadResponseHeader;
const
  HdrBufSize = HTTPCLIENT_ResponseHeader_MaxSize + HTTPCLIENT_ResponseHeader_DelimLen;
var
  HdrBuf : array[0..HdrBufSize - 1] of Byte;
  HdrLen : Integer;
begin
  Assert(Assigned(FTCPClient));
  Assert(FState in [hcsAwaitingResponse]);
  //
  HdrLen := FTCPClient.Connection.PeekDelimited(
      HdrBuf[0], HdrBufSize,
      HTTPCLIENT_ResponseHeader_Delim,
      HTTPCLIENT_ResponseHeader_MaxSize);
  if HdrLen < 0 then
    exit;

  FResponseObj.Clear;
  FHTTPParser.SetTextBuf(HdrBuf[0], HdrLen);
  FHTTPParser.ParseResponse(FResponseObj.RecPtr^);
  if not FResponseObj.RecPtr^.HeaderComplete then
    exit;

  FTCPClient.Connection.Discard(HdrLen);
  SetState(hcsReceivedResponse);
  ProcessResponseHeader;
  TriggerResponseHeader
end;

procedure TF5HTTPClient.ReadResponseContent;
begin
  FResponseContentReader.Process;
end;

procedure TF5HTTPClient.ReadResponse;
begin
  if FState = hcsStarting then
    exit;
  Assert(FTCPClient.State in [csReady, csClosed]);
  Assert(FState in [
      hcsAwaitingResponse, hcsReceivedResponse, hcsReceivingContent,
      hcsResponseComplete, hcsResponseCompleteAndClosing, hcsResponseCompleteAndClosed,
      hcsRequestInterruptedAndClosed,
      hcsRequestFailed]);

  try
    if FState = hcsAwaitingResponse then
      ReadResponseHeader;
    if FState = hcsReceivedResponse then
      if FResponseObj.RecPtr^.HasContent then
        begin
          InitResponseContent;
          SetState(hcsReceivingContent);
        end
      else
        SetResponseComplete;
    if FState = hcsReceivingContent then
      ReadResponseContent;
  except
    on E : Exception do
      SetRequestFailedFromException(E);
  end;
end;

procedure TF5HTTPClient.StartTCPClient;
begin
  InitTCPClient;

  FViaHTTPProxy := FUseHTTPProxy and (FHTTPProxyHost <> '');

  Assert(Assigned(FTCPClient));
  FTCPClient.Start;
end;

procedure TF5HTTPClient.PrepareHTTPRequest;
var
  C : THTTPConnectionFieldEnum;
  R : Boolean;
  L : Int64;
begin
  FRequestObj.Clear;

  case FMethod of
    cmGET    : FRequestObj.RequestMethod := hmGET;
    cmPOST   : FRequestObj.RequestMethod := hmPOST;
    cmCustom :
      begin
        if FMethodCustom = '' then
          raise EHTTPClient.Create(SError_MethodNotSet);
        FRequestObj.RequestMethod := hmCustom;
        FRequestObj.RecPtr^.StartLine.Method.Custom := FMethodCustom;
      end;
  else
    raise EHTTPClient.Create(SError_MethodNotSet);
  end;

  if FURI = '' then
    raise EHTTPClient.Create(SError_URINotSet);
  FRequestObj.RecPtr^.StartLine.URI := FURI;

  FRequestObj.HTTPVersion := hvHTTP11;
  FRequestObj.HeaderDate := Now;

  case FKeepAlive of
    kaKeepAlive : C := hcfKeepAlive;
    kaClose     : C := hcfClose;
  else
    C := hcfNone;
  end;
  if C <> hcfNone then
    if FViaHTTPProxy then
      FRequestObj.RecPtr^.Header.CommonHeaders.ProxyConnection.Value := C
    else
      FRequestObj.RecPtr^.Header.CommonHeaders.Connection.Value := C;

  FRequestObj.HeaderHost := FHost;
  FRequestObj.RecPtr^.Header.FixedHeaders[hntUserAgent] := FUserAgent;
  FRequestObj.RecPtr^.Header.FixedHeaders[hntReferer] := FReferer;
  FRequestObj.RecPtr^.Header.FixedHeaders[hntAuthorization] := FAuthorization;

  if FCookie <> '' then
    begin
      FRequestObj.RecPtr^.Header.Cookie.Value := hcoCustom;
      FRequestObj.RecPtr^.Header.Cookie.Custom := FCookie;
    end;

  FRequestObj.RecPtr^.Header.CustomHeaders := FCustomHeaders;

  if FRequestContentType <> '' then
    begin
      FRequestObj.ContentTypeString := FRequestContentType;
      L := InitRequestContent(R);
      Assert(L >= 0);
      FRequestObj.ContentLengthBytes := L;
      FRequestHasContent := True;
    end
  else
    FRequestHasContent := False;
end;

function TF5HTTPClient.GetHTTPRequestStr: RawByteString;
begin
  Result := FRequestObj.GetString;

  {$IFDEF HTTP_LOG_DEBUG}
  LogDebug('RequestHeader:%db'#13#10'%s', [Length(Result), Copy(Result, 1, 160)]);
  {$ENDIF}
end;

procedure TF5HTTPClient.SendStr(const S: RawByteString);
begin
  Assert(Assigned(FTCPClient));
  Assert(FState in [hcsSendingRequest, hcsSendingContent]);
  //
  FTCPClient.Connection.WriteByteString(S);
end;

procedure TF5HTTPClient.SendRequest;
begin
  Assert(FState in [hcsConnectedReady, hcsResponseComplete, hcsResponseCompleteAndClosing]);

  SetState(hcsSendingRequest);
  SendStr(GetHTTPRequestStr);
  if FRequestHasContent then
    begin
      SetState(hcsSendingContent);
      FRequestContentWriter.SendContent;
      FinaliseRequestContent;
    end;
  SetState(hcsAwaitingResponse);
end;

procedure TF5HTTPClient.ResetRequest;
begin
  FErrorMsg := '';
  FResponseObj.Clear;
  FResponseCode := 0;
  FResponseCookies.Clear;
  FResponseContentReader.Reset;
  FRequestContentWriter.Reset;
end;

procedure TF5HTTPClient.Request;
var
  R_IsStarting : Boolean;
  R_Ready : Boolean;
  R_Connect : Boolean;
  R_IsActive : Boolean;
begin
  Lock;
  try
    // check state
    if FInRequest or IsBusyWithRequest then
      raise EHTTPClient.Create(SError_NotAllowedWhileBusyWithRequest);
    FInRequest := True;
    R_IsActive := FActive;
    R_IsStarting := IsBusyStarting;
    R_Ready := FState in [hcsConnectedReady, hcsResponseComplete];
    R_Connect := not R_IsStarting and not R_Ready;
    // initialise new request
    ResetRequest;
    PrepareHTTPRequest;
    FRequestPending := not R_Ready;
  finally
    Unlock;
  end;
  try
    if R_Connect then
      begin
        if R_IsActive then
          begin
            StopTCPClient;
            StartTCPClient;
          end
        else
          ClientSetActive;
      end
    else
    if R_Ready then
      SendRequest;
  finally
    Lock;
    try
      FInRequest := False;
    finally
      Unlock;
    end;
  end;
end;

function TF5HTTPClient.RequestIsBusy: Boolean;
begin
  Lock;
  try
    Result := IsBusyWithRequest;
  finally
    Unlock;
  end;
end;

function TF5HTTPClient.RequestIsSuccess: Boolean;
begin
  Result := GetState in HTTP5ClientState_ResponseComplete;
end;

function TF5HTTPClient.GetResponseRecord: THTTPResponseRec;
begin
  Result := FResponseObj.RecPtr^;
end;

function TF5HTTPClient.GetResponseContentStr: RawByteString;
begin
  Result := FResponseContentReader.ContentString;
end;

function TF5HTTPClient.WaitReadyForRequest(const Timeout: Integer): Boolean;
var
  T : Int32;
begin
  T := Timeout;
  repeat
    Lock;
    try
      if not FActive then
        raise EHTTPClient.Create(SError_NotActive);
      if FState in [
          hcsConnectFailed,
          hcsRequestInterruptedAndClosed,
          hcsRequestFailed,
          hcsStopping,
          hcsStopped] then
        raise EHTTPClient.Create(SError_NotConnected);
      if FState in [
          hcsConnectedReady,
          hcsSendingRequest,
          hcsSendingContent,
          hcsAwaitingResponse,
          hcsReceivedResponse,
          hcsReceivingContent,
          hcsResponseComplete,
          hcsResponseCompleteAndClosing] then
        begin
          Result := True;
          exit;
        end;
    finally
      Unlock;
    end;
    case FReadyEvent.WaitFor(200) of
      wrSignaled  : ;
      wrTimeout   : ;
      wrAbandoned : break;
      wrError     : break;
    end;
    if Timeout > 0 then
      Dec(T, 200);
  until T <= 0;
  Result := False;
end;

function TF5HTTPClient.WaitForRequestComplete(const Timeout: Integer): Boolean;
var
  T : Int32;
begin
  T := Timeout;
  repeat
    Lock;
    try
      if not FActive then
        raise EHTTPClient.Create(SError_NotActive);
      if FState in [
          hcsConnectFailed,
          hcsRequestInterruptedAndClosed,
          hcsRequestFailed,
          hcsResponseComplete,
          hcsResponseCompleteAndClosing,
          hcsStopping,
          hcsStopped] then
        begin
          Result := True;
          exit;
        end;
    finally
      Unlock;
    end;
    case FReadyEvent.WaitFor(200) of
      wrSignaled  : ;
      wrTimeout   : ;
      wrAbandoned : break;
      wrError     : break;
    end;
    if Timeout > 0 then
      Dec(T, 200);
  until T <= 0;
  Result := False;
end;




{                                                                              }
{ THTTPClientCollection                                                        }
{                                                                              }
constructor THTTPClientCollection.Create(const ItemOwner: Boolean);
begin
  inherited Create;
  FItemOwner := ItemOwner;
end;

destructor THTTPClientCollection.Destroy;
var
  I : NativeInt;
begin
  if FItemOwner then
    for I := Length(FList) - 1 downto 0 do
      FreeAndNil(FList[I]);
  inherited Destroy;
end;

function THTTPClientCollection.GetCount: NativeInt;
begin
  Result := Length(FList);
end;

function THTTPClientCollection.GetItem(const Idx: NativeInt): TF5HTTPClient;
begin
  Assert(Idx >= 0);
  Assert(Idx < Length(FList));

  Result := FList[Idx];
end;

function THTTPClientCollection.Add(const Item: TF5HTTPClient): NativeInt;
var
  L : NativeInt;
begin
  Assert(Assigned(Item));

  L := Length(FList);
  SetLength(FList, L + 1);
  FList[L] := Item;
  Result := L;
end;

function THTTPClientCollection.CreateNew: TF5HTTPClient;
begin
  Result := TF5HTTPClient.Create;
end;

function THTTPClientCollection.AddNew: TF5HTTPClient;
var
  C : TF5HTTPClient;
begin
  C := CreateNew;
  try
    Add(C);
  except
    C.Free;
    raise;
  end;
  Result := C;
end;

function THTTPClientCollection.GetItemIndex(const Item: TF5HTTPClient): NativeInt;
var
  I : NativeInt;
begin
  for I := 0 to Length(FList) - 1 do
    if FList[I] = Item then
      begin
        Result := I;
        exit;
      end;
  Result := -1;
end;

procedure THTTPClientCollection.RemoveByIndex(const Idx: NativeInt);
var
  L : NativeInt;
  I : NativeInt;
  T : TF5HTTPClient;
begin
  L := Length(FList);
  if (Idx < 0) or (Idx >= L) then
    raise EHTTPClientCollection.Create('Index out of range');
  T := FList[Idx];
  for I := Idx to L - 2 do
    FList[I] := FList[I + 1];
  SetLength(FList, L - 1);
  if FItemOwner then
    T.Free;
end;

function THTTPClientCollection.Remove(const Item: TF5HTTPClient): Boolean;
var
  I : NativeInt;
begin
  I := GetItemIndex(Item);
  if I >= 0 then
    begin
      RemoveByIndex(I);
      Result := True;
    end
  else
    Result := False;
end;

procedure THTTPClientCollection.Clear;
var
  I : NativeInt;
begin
  if FItemOwner then
    for I := Length(FList) - 1 downto 0 do
      FreeAndNil(FList[I]);
  FList := nil;
end;



end.

