{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals TLS                                         }
{   File name:        flcTLSClient.pas                                         }
{   File version:     5.06                                                     }
{   Description:      TLS client                                               }
{                                                                              }
{   Copyright:        Copyright (c) 2008-2018, David J Butler                  }
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
{   2008/01/18  0.01  Initial development.                                     }
{   2010/11/26  0.02  Protocol messages.                                       }
{   2010/11/30  0.03  Encrypted messages.                                      }
{   2010/12/03  0.04  Connection base class.                                   }
{   2016/01/08  0.05  String changes.                                          }
{   2018/07/17  5.06  Revised for Fundamentals 5.                              }
{                                                                              }
{ Todo:                                                                        }
{ - OnClientStateChange event                                                  }
{ - Send connection close alert                                                }
{ - SecureClear memory                                                         }
{ - Option to set allowable ciphers/hashes.                                    }
{******************************************************************************}

{$INCLUDE flcTLS.inc}

unit flcTLSClient;

interface

uses
  { Cipher }
  flcCipherRSA,
  flcCipherDH,
  { X509 }
  flcX509Certificate,
  { TLS }
  flcTLSUtils,
  flcTLSCipherSuite,
  flcTLSRecord,
  flcTLSAlert,
  flcTLSHandshake,
  flcTLSConnection;



{                                                                              }
{ TLS Client                                                                   }
{                                                                              }
type
  TTLSClient = class;

  TTLSClientNotifyEvent = procedure (Sender: TTLSClient) of object;

  TTLSClientOptions = set of (
    tlscoDisableSSL3,
    tlscoDisableTLS10,
    tlscoDisableTLS11,
    tlscoDisableTLS12,
    tlscoDisableCipherRC4_128,
    tlscoDisableCipherDES,
    tlscoDisableCipherAES128,
    tlscoDisableCipherAES256,
    tlscoDisableHashMD5,
    tlscoDisableHashSHA1,
    tlscoDisableHashSHA256,
    tlscoDisableKeyExchangeRSA,
    tlscoDisableKeyExchangeDH_Anon,
    tlscoDisableKeyExchangeDH_RSA);

  TTLSClientState = (
    tlsclInit,
    tlsclHandshakeAwaitingServerHello,
    tlsclHandshakeAwaitingServerHelloDone,
    tlsclHandshakeClientKeyExchange,
    tlsclConnection);

  TTLSClient = class(TTLSConnection)
  protected
    FClientOptions         : TTLSClientOptions;
    FResumeSessionID       : RawByteString;

    FClientState           : TTLSClientState;
    FClientProtocolVersion : TTLSProtocolVersion;
    FServerProtocolVersion : TTLSProtocolVersion;
    FClientHello           : TTLSClientHello;
    FClientHelloRandomStr  : RawByteString;
    FServerHello           : TTLSServerHello;
    FServerHelloRandomStr  : RawByteString;
    FServerCertificateList : TTLSCertificateList;
    FServerX509Certs       : TX509CertificateArray;
    FServerKeyExchange     : TTLSServerKeyExchange;
    FCertificateRequest    : TTLSCertificateRequest;
    FCertificateRequested  : Boolean;
    FClientKeyExchange     : TTLSClientKeyExchange;
    FServerRSAPublicKey    : TRSAPublicKey;
    FDHState               : PDHState;
    FPreMasterSecret       : TTLSPreMasterSecret;
    FPreMasterSecretStr    : RawByteString;
    FMasterSecret          : RawByteString;

    procedure Init; override;

    procedure SetClientState(const State: TTLSClientState);
    procedure CheckNotActive;

    procedure SetClientOptions(const ClientOptions: TTLSClientOptions);

    procedure InitInitialProtocolVersion;
    procedure InitSessionProtocolVersion;
    procedure InitClientHelloCipherSuites;
    procedure InitDHState;

    procedure InitHandshakeClientHello;
    procedure InitServerPublicKey_RSA;
    procedure InitHandshakeClientKeyExchange;

    procedure SendHandshakeClientHello;
    procedure SendHandshakeCertificate;
    procedure SendHandshakeClientKeyExchange;
    procedure SendHandshakeCertificateVerify;
    procedure SendHandshakeFinished;

    procedure HandleHandshakeHelloRequest(const Buffer; const Size: Integer);
    procedure HandleHandshakeServerHello(const Buffer; const Size: Integer);
    procedure HandleHandshakeCertificate(const Buffer; const Size: Integer);
    procedure HandleHandshakeServerKeyExchange(const Buffer; const Size: Integer);
    procedure HandleHandshakeCertificateRequest(const Buffer; const Size: Integer);
    procedure HandleHandshakeServerHelloDone(const Buffer; const Size: Integer);
    procedure HandleHandshakeFinished(const Buffer; const Size: Integer);
    procedure HandleHandshakeMessage(const MsgType: TTLSHandshakeType; const Buffer; const Size: Integer); override;

    procedure InitCipherSpecNone;
    procedure InitCipherSpecNewFromServerHello;

    procedure DoStart;

  public
    constructor Create(const TransportLayerSendProc: TTLSConnectionTransportLayerSendProc);
    destructor Destroy; override;

    property  ClientOptions: TTLSClientOptions read FClientOptions write SetClientOptions;
    property  ResumeSessionID: RawByteString read FResumeSessionID write FResumeSessionID;

    property  ClientState: TTLSClientState read FClientState;
    procedure Start;
  end;



implementation

uses
  { Fundamentals }
  flcHugeInt,
  flcASN1,
  flcCipherUtils,
  { TLS }
  flcTLSCompress,
  flcTLSCipher;



{                                                                              }
{ TLS Client                                                                   }
{                                                                              }
const
  STLSClientState: array[TTLSClientState] of String = (
    'Init',
    'HandshakeAwaitingServerHello',
    'HandshakeAwaitingServerHelloDone',
    'HandshakeClientKeyExchange',
    'Connection');

constructor TTLSClient.Create(const TransportLayerSendProc: TTLSConnectionTransportLayerSendProc);
begin
  inherited Create(TransportLayerSendProc);
end;

destructor TTLSClient.Destroy;
begin
  if Assigned(FDHState) then
    begin
      DHStateFinalise(FDHState^);
      Dispose(FDHState);
      FDHState := nil;
    end;
  RSAPublicKeyFinalise(FServerRSAPublicKey);
  SecureClearStr(FMasterSecret);
  inherited Destroy;
end;

procedure TTLSClient.Init;
begin
  inherited Init;
  RSAPublicKeyInit(FServerRSAPublicKey);
  FClientOptions := [tlscoDisableSSL3];
  FClientState := tlsclInit;
end;

procedure TTLSClient.SetClientState(const State: TTLSClientState);
begin
  {$IFDEF TLS_DEBUG}
  Log(tlsltDebug, 'State:%s', [STLSClientState[State]]);
  {$ENDIF}

  FClientState := State;
end;

procedure TTLSClient.CheckNotActive;
begin
  if FClientState <> tlsclInit then
    raise ETLSError.Create(TLSError_InvalidState, 'Operation not allowed while active');
end;

procedure TTLSClient.SetClientOptions(const ClientOptions: TTLSClientOptions);
begin
  if ClientOptions = FClientOptions then
    exit;
  CheckNotActive;
  if ClientOptions * [tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11, tlscoDisableTLS12] =
      [tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11, tlscoDisableTLS12] then
    raise ETLSError.Create(TLSError_InvalidParameter, 'Invalid version options');
  FClientOptions := ClientOptions;
end;

procedure TTLSClient.InitInitialProtocolVersion;
begin
  // set highest allowable protocol version
  if not (tlscoDisableTLS12 in FClientOptions) then
    InitTLSProtocolVersion12(FProtocolVersion) else
  if not (tlscoDisableTLS11 in FClientOptions) then
    InitTLSProtocolVersion11(FProtocolVersion) else
  if not (tlscoDisableTLS10 in FClientOptions) then
    InitTLSProtocolVersion10(FProtocolVersion) else
  if not (tlscoDisableSSL3 in FClientOptions) then
    InitSSLProtocolVersion30(FProtocolVersion)
  else
    raise ETLSError.Create(TLSError_InvalidParameter, 'Invalid version options');
  FClientProtocolVersion := FProtocolVersion;

  {$IFDEF TLS_DEBUG}
  Log(tlsltDebug, 'InitialProtocolVersion:%s', [TLSProtocolVersionName(FProtocolVersion)]);
  {$ENDIF}
end;

procedure TTLSClient.InitSessionProtocolVersion;
begin
  FProtocolVersion := FServerProtocolVersion;
  if IsTLS12(FProtocolVersion) and (tlscoDisableTLS12 in FClientOptions)then
    InitTLSProtocolVersion11(FProtocolVersion);
  if IsTLS11(FProtocolVersion) and (tlscoDisableTLS11 in FClientOptions) then
    InitTLSProtocolVersion10(FProtocolVersion);
  if IsTLS10(FProtocolVersion) and (tlscoDisableTLS10 in FClientOptions) then
    InitSSLProtocolVersion30(FProtocolVersion);
  if IsSSL3(FProtocolVersion) and (tlscoDisableSSL3 in FClientOptions) then
    raise ETLSAlertError.Create(tlsadProtocol_version); // no allowable protocol version

  {$IFDEF TLS_DEBUG}
  Log(tlsltDebug, 'SessionProtocolVersion:%s', [TLSProtocolVersionName(FProtocolVersion)]);
  {$ENDIF}
end;

procedure TTLSClient.InitClientHelloCipherSuites;
var C : TTLSCipherSuites;
    I : TTLSCipherSuite;
    P : PTLSCipherSuiteInfo;
    R : Boolean;
begin
  C := [];
  for I := Low(I) to High(I) do
    begin
      P := @TLSCipherSuiteInfo[I];
      R := P^.ClientSupport;
      if R then
        if tlscoDisableCipherRC4_128 in FClientOptions then
          if P^.Cipher in [tlscscRC4_128] then
            R := False;
      if R then
        if tlscoDisableCipherDES in FClientOptions then
          if P^.Cipher in [tlscscDES_CBC] then
            R := False;
      if R then
        if tlscoDisableCipherAES128 in FClientOptions then
          if P^.Cipher in [tlscscAES_128_CBC] then
            R := False;
      if R then
        if tlscoDisableCipherAES256 in FClientOptions then
          if P^.Cipher in [tlscscAES_256_CBC] then
            R := False;
      if R then
        if tlscoDisableHashMD5 in FClientOptions then
          if P^.Hash in [tlscshMD5] then
            R := False;
      if R then
        if tlscoDisableHashSHA1 in FClientOptions then
          if P^.Hash in [tlscshSHA] then
            R := False;
      if R then
        if tlscoDisableHashSHA256 in FClientOptions then
          if P^.Hash in [tlscshSHA256] then
            R := False;
      if R then
        if tlscoDisableKeyExchangeRSA in FClientOptions then
          if P^.KeyExchange in [tlscskeRSA] then
            R := False;
      if R then
        if tlscoDisableKeyExchangeDH_Anon in FClientOptions then
          if P^.KeyExchange in [tlscskeDH_anon] then
            R := False;
      if R then
        if tlscoDisableKeyExchangeDH_RSA in FClientOptions then
          if P^.KeyExchange in [tlscskeDH_RSA] then
            R := False;
      if R then
        Include(C, I);
    end;
  if C = [] then
    raise ETLSError.Create(TLSError_InvalidParameter, 'No allowable cipher suite');
  FClientHello.CipherSuites := C;
end;

procedure TTLSClient.InitDHState;
begin
  New(FDHState);
  DHStateInit(FDHState^);
  DHInitHashAlgorithm(FDHState^, dhhSHA1);
end;

procedure TTLSClient.InitHandshakeClientHello;
begin
  InitTLSClientHello(FClientHello,
      FClientProtocolVersion,
      FResumeSessionID);
  InitClientHelloCipherSuites;
  FClientHello.CompressionMethods := [tlscmNull];
  FClientHelloRandomStr := TLSRandomToStr(FClientHello.Random);
end;

procedure TTLSClient.InitServerPublicKey_RSA;
var I, L, N1, N2 : Integer;
    C : PX509Certificate;
    S : RawByteString;
    PKR : TX509RSAPublicKey;
    R : Boolean;
begin
  // find RSA public key from certificates
  R := False;
  L := Length(FServerX509Certs);
  for I := 0 to L - 1 do
    begin
      C := @FServerX509Certs[I];
      if ASN1OIDEqual(C^.TBSCertificate.SubjectPublicKeyInfo.Algorithm.Algorithm, OID_RSA) then
        begin
          S := C^.TBSCertificate.SubjectPublicKeyInfo.SubjectPublicKey;
          Assert(S <> '');
          ParseX509RSAPublicKey(S[1], Length(S), PKR);
          R := True;
          break;
        end;
    end;
  if not R then
    exit;
  N1 := NormaliseX509IntKeyBuf(PKR.Modulus);
  N2 := NormaliseX509IntKeyBuf(PKR.PublicExponent);
  if N2 > N1 then
    N1 := N2;
  // initialise RSA public key
  RSAPublicKeyAssignBuf(FServerRSAPublicKey, N1 * 8,
      PKR.Modulus[1], Length(PKR.Modulus),
      PKR.PublicExponent[1], Length(PKR.PublicExponent), True);
end;

procedure TTLSClient.InitHandshakeClientKeyExchange;
var S : RawByteString;
begin
  {$IFDEF TLS_DEBUG}
  Log(tlsltDebug, 'InitHandshakeClientKeyExchange:%s', [
      TLSKeyExchangeAlgorithmInfo[FCipherSpecNew.KeyExchangeAlgorithm].Name]);
  {$ENDIF}

  case FCipherSpecNew.KeyExchangeAlgorithm of
    tlskeaRSA :
      begin
        { RFC 5246: When RSA is used for server authentication and key exchange, a 48- }
        { byte pre_master_secret is generated by the client, encrypted under }
        { the server's public key, and sent to the server.  The server uses its }
        { private key to decrypt the pre_master_secret.  Both parties then }
        { convert the pre_master_secret into the master_secret, as specified above. }

        InitTLSPreMasterSecret_Random(FPreMasterSecret, FClientHello.ProtocolVersion);
        FPreMasterSecretStr := TLSPreMasterSecretToStr(FPreMasterSecret);

        InitServerPublicKey_RSA;

        InitTLSEncryptedPreMasterSecret_RSA(S, FPreMasterSecret, FServerRSAPublicKey);
        FClientKeyExchange.EncryptedPreMasterSecret := S;
      end;
    tlskeaDHE_DSS,
    tlskeaDHE_RSA,
    tlskeaDH_Anon :
      begin
        Assert(Assigned(FDHState));

        { RFC 5246: A conventional Diffie-Hellman computation is performed.  The }
        { negotiated key (Z) is used as the pre_master_secret, and is converted }
        { into the master_secret, as specified above.  Leading bytes of Z that }
        { contain all zero bits are stripped before it is used as the }
        { pre_master_secret }

        FClientKeyExchange.ClientDiffieHellmanPublic.PublicValueEncodingExplicit := True;
        FClientKeyExchange.ClientDiffieHellmanPublic.dh_Yc := DHHugeWordKeyEncodeBytes(FDHState^.Y);

        FPreMasterSecretStr := DHHugeWordKeyEncodeBytes(FDHState^.ZZ);
      end;
    tlskeaDH_DSS,
    tlskeaDH_RSA :
      begin
        FClientKeyExchange.ClientDiffieHellmanPublic.PublicValueEncodingExplicit := False;
        FClientKeyExchange.ClientDiffieHellmanPublic.dh_Yc := '';
      end;
  end;

  case FCipherSpecNew.KeyExchangeAlgorithm of
    tlskeaRSA,
    tlskeaDHE_DSS,
    tlskeaDHE_RSA,
    tlskeaDH_Anon :
      begin
        Assert(FPreMasterSecretStr <> '');
        FMasterSecret := TLSMasterSecret(FProtocolVersion, FPreMasterSecretStr,
            FClientHelloRandomStr, FServerHelloRandomStr);
        SecureClearStr(FPreMasterSecretStr);

        GenerateTLSKeys(FProtocolVersion,
            FCipherSpecNew.CipherSuiteDetails.HashInfo^.KeyLength,
            FCipherSpecNew.CipherSuiteDetails.CipherInfo^.KeyBits,
            FCipherSpecNew.CipherSuiteDetails.CipherInfo^.IVSize * 8,
            FMasterSecret,
            FServerHelloRandomStr,
            FClientHelloRandomStr,
            FKeys);
        GenerateFinalTLSKeys(FProtocolVersion,
            FCipherSpecNew.CipherSuiteDetails.CipherInfo^.Exportable,
            FCipherSpecNew.CipherSuiteDetails.CipherInfo^.ExpKeyMat * 8,
            FServerHelloRandomStr,
            FClientHelloRandomStr,
            FKeys);

        SetEncodeKeys(FKeys.ClientMACKey, FKeys.ClientEncKey, FKeys.ClientIV);
        SetDecodeKeys(FKeys.ServerMACKey, FKeys.ServerEncKey, FKeys.ServerIV);
      end;
  end;
end;

const
  MaxHandshakeClientHelloSize       = 16384;
  MaxHandshakeCertificateSize       = 65536;
  MaxHandshakeClientKeyExchangeSize = 2048;
  MaxHandshakeCertificateVerifySize = 16384;
  MaxHandshakeFinishedSize          = 2048;

procedure TTLSClient.SendHandshakeClientHello;
var B : array[0..MaxHandshakeClientHelloSize - 1] of Byte;
    L : Integer;
begin
  {$IFDEF TLS_DEBUG}
  Log(tlsltDebug, 'T:Handshake:ClientHello');
  {$ENDIF}

  InitHandshakeClientHello;
  L := EncodeTLSHandshakeClientHello(B, SizeOf(B), FClientHello);
  SendHandshake(B, L);
end;

procedure TTLSClient.SendHandshakeCertificate;
var B : array[0..MaxHandshakeCertificateSize - 1] of Byte;
    L : Integer;
begin
  {$IFDEF TLS_DEBUG}
  Log(tlsltDebug, 'T:Handshake:Certificate');
  {$ENDIF}

  L := EncodeTLSHandshakeCertificate(B, SizeOf(B), nil);
  SendHandshake(B, L);
end;

procedure TTLSClient.SendHandshakeClientKeyExchange;
var B : array[0..MaxHandshakeClientKeyExchangeSize - 1] of Byte;
    L : Integer;
begin
  {$IFDEF TLS_DEBUG}
  Log(tlsltDebug, 'T:Handshake:ClientKeyExchange');
  {$ENDIF}

  InitHandshakeClientKeyExchange;
  L := EncodeTLSHandshakeClientKeyExchange(
      B, SizeOf(B),
      FCipherSpecNew.KeyExchangeAlgorithm,
      FClientKeyExchange);
  SendHandshake(B, L);
end;

procedure TTLSClient.SendHandshakeCertificateVerify;
var B : array[0..MaxHandshakeCertificateVerifySize - 1] of Byte;
    L : Integer;
begin
  L := EncodeTLSHandshakeCertificateVerify(B, SizeOf(B));
  SendHandshake(B, L);
end;

procedure TTLSClient.SendHandshakeFinished;
var B : array[0..MaxHandshakeFinishedSize - 1] of Byte;
    L : Integer;
begin
  {$IFDEF TLS_DEBUG}
  Log(tlsltDebug, 'T:Handshake:Finished:%s', [TLSProtocolVersionName(FProtocolVersion)]);
  {$ENDIF}

  L := EncodeTLSHandshakeFinished(B, SizeOf(B), FMasterSecret, FProtocolVersion, FVerifyHandshakeData, True);
  SendHandshake(B, L);
end;

procedure TTLSClient.HandleHandshakeHelloRequest(const Buffer; const Size: Integer);
begin
  if IsNegotiatingState then
    exit; // ignore while negotiating
  if FConnectionState = tlscoApplicationData then
    SendAlert(tlsalWarning, tlsadNo_renegotiation); // client does not support renegotiation, notify server
end;

procedure TTLSClient.HandleHandshakeServerHello(const Buffer; const Size: Integer);
begin
  if not (FClientState in [tlsclHandshakeAwaitingServerHello]) or
     not (FConnectionState in [tlscoStart, tlscoHandshaking]) then
    raise ETLSAlertError.Create(tlsadUnexpected_message);
  DecodeTLSServerHello(Buffer, Size, FServerHello);
  FServerProtocolVersion := FServerHello.ProtocolVersion;

  {$IFDEF TLS_DEBUG}
  Log(tlsltDebug, 'ServerProtocolVersion:%s', [TLSProtocolVersionName(FServerProtocolVersion)]);
  {$ENDIF}

  FServerHelloRandomStr := TLSRandomToStr(FServerHello.Random);
  if not IsTLSProtocolVersion(FServerProtocolVersion, FProtocolVersion) then // different protocol version
    begin
      if IsFutureTLSVersion(FServerProtocolVersion) then
        raise ETLSAlertError.Create(tlsadProtocol_version); // unsupported future version of TLS
      if not IsKnownTLSVersion(FServerProtocolVersion) then
        raise ETLSAlertError.Create(tlsadProtocol_version); // unknown past TLS version
    end;
  InitSessionProtocolVersion;
  InitCipherSpecNewFromServerHello;
  SetClientState(tlsclHandshakeAwaitingServerHelloDone);
end;

procedure TTLSClient.HandleHandshakeCertificate(const Buffer; const Size: Integer);
var I, L : Integer;
    C : RawByteString;
begin
  if FClientState <> tlsclHandshakeAwaitingServerHelloDone then
    raise ETLSAlertError.Create(tlsadUnexpected_message);
  DecodeTLSCertificate(Buffer, Size, FServerCertificateList);
  L := Length(FServerCertificateList);
  SetLength(FServerX509Certs, L);
  for I := 0 to L - 1 do
    begin
      C := FServerCertificateList[I];
      InitX509Certificate(FServerX509Certs[I]);
      if C <> '' then
        ParseX509Certificate(C[1], Length(C), FServerX509Certs[I]);
    end;

  {$IFDEF TLS_DEBUG}
  Log(tlsltDebug, 'R:Handshake:Certificate:Count=%d', [L]);
  {$ENDIF}
end;

procedure TTLSClient.HandleHandshakeServerKeyExchange(const Buffer; const Size: Integer);
var
  R : HugeWord;
begin
  if FClientState <> tlsclHandshakeAwaitingServerHelloDone then
    raise ETLSAlertError.Create(tlsadUnexpected_message);
  DecodeTLSServerKeyExchange(Buffer, Size, FCipherSpecNew.KeyExchangeAlgorithm,
      FServerKeyExchange);
  case FCipherSpecNew.KeyExchangeAlgorithm of
    tlskeaDHE_DSS,
    tlskeaDHE_RSA,
    tlskeaDH_Anon :
      begin
        InitDHState;
        DHHugeWordKeyDecodeBytes(FDHState^.P, FServerKeyExchange.Params.dh_p);
        DHHugeWordKeyDecodeBytes(FDHState^.G, FServerKeyExchange.Params.dh_g);
        FDHState^.PrimePBitCount := HugeWordGetSizeInBits(FDHState^.P);
        FDHState^.PrimeQBitCount := DHQBitCount(FDHState^.PrimePBitCount);
        DHGeneratePrivateKeyX(FDHState^);
        DHGeneratePublicKeyY(FDHState^);

        HugeWordInit(R);
        DHHugeWordKeyDecodeBytes(R, FServerKeyExchange.Params.dh_Ys);
        DHGenerateSharedSecretZZ(FDHState^, HugeWordGetSizeInBits(R), R);
        HugeWordFinalise(R);
      end;
  end;
end;

procedure TTLSClient.HandleHandshakeCertificateRequest(const Buffer; const Size: Integer);
begin
  if FClientState <> tlsclHandshakeAwaitingServerHelloDone then
    raise ETLSAlertError.Create(tlsadUnexpected_message);
  DecodeTLSCertificateRequest(Buffer, Size, FCertificateRequest);
  FCertificateRequested := True;
end;

procedure TTLSClient.HandleHandshakeServerHelloDone(const Buffer; const Size: Integer);
begin
  if FClientState <> tlsclHandshakeAwaitingServerHelloDone then
    raise ETLSAlertError.Create(tlsadUnexpected_message);
  SetClientState(tlsclHandshakeClientKeyExchange);
  if FCertificateRequested then
    SendHandshakeCertificate;
  SendHandshakeClientKeyExchange;
  // TODO SendHandshakeCertificateVerify;
  SendChangeCipherSpec;
  ChangeEncryptCipherSpec;
  SendHandshakeFinished;
end;

procedure TTLSClient.HandleHandshakeFinished(const Buffer; const Size: Integer);
begin
  if FClientState <> tlsclHandshakeClientKeyExchange then
    raise ETLSAlertError.Create(tlsadUnexpected_message);
  SetClientState(tlsclConnection);
  SetConnectionState(tlscoApplicationData);
  TriggerHandshakeFinished;
end;

procedure TTLSClient.HandleHandshakeMessage(const MsgType: TTLSHandshakeType; const Buffer; const Size: Integer);
begin
  {$IFDEF TLS_DEBUG}
  Log(tlsltDebug, 'R:Handshake:%s:%db', [TLSHandshakeTypeToStr(MsgType), Size]);
  {$ENDIF}

  case MsgType of
    tlshtHello_request       : HandleHandshakeHelloRequest(Buffer, Size);
    tlshtClient_hello        : ShutdownBadProtocol(tlsadUnexpected_message);
    tlshtServer_hello        : HandleHandshakeServerHello(Buffer, Size);
    tlshtCertificate         : HandleHandshakeCertificate(Buffer, Size);
    tlshtServer_key_exchange : HandleHandshakeServerKeyExchange(Buffer, Size);
    tlshtCertificate_request : HandleHandshakeCertificateRequest(Buffer, Size);
    tlshtServer_hello_done   : HandleHandshakeServerHelloDone(Buffer, Size);
    tlshtCertificate_verify  : ShutdownBadProtocol(tlsadUnexpected_message);
    tlshtClient_key_exchange : ShutdownBadProtocol(tlsadUnexpected_message);
    tlshtFinished            : HandleHandshakeFinished(Buffer, Size);
  else
    ShutdownBadProtocol(tlsadUnexpected_message);
  end;
end;

procedure TTLSClient.InitCipherSpecNone;
begin
  InitTLSSecurityParametersNone(FCipherEncryptSpec);
  InitTLSSecurityParametersNone(FCipherDecryptSpec);
  TLSCipherInitNone(FCipherEncryptState, tlscoEncrypt);
  TLSCipherInitNone(FCipherDecryptState, tlscoDecrypt);
end;

procedure TTLSClient.InitCipherSpecNewFromServerHello;
begin
  InitTLSSecurityParameters(
      FCipherSpecNew,
      FServerHello.CompressionMethod,
      GetCipherSuiteByRec(FServerHello.CipherSuite.B1, FServerHello.CipherSuite.B2));

  {$IFDEF TLS_DEBUG}
  Log(tlsltDebug, 'CipherSpec:%s', [FCipherSpecNew.CipherSuiteDetails.CipherSuiteInfo^.Name]);
  {$ENDIF}
end;

procedure TTLSClient.DoStart;
begin
  SetConnectionState(tlscoStart);
  InitInitialProtocolVersion;
  InitCipherSpecNone;
  SetConnectionState(tlscoHandshaking);
  SetClientState(tlsclHandshakeAwaitingServerHello);
  SendHandshakeClientHello;
end;

procedure TTLSClient.Start;
begin
  Assert(FConnectionState = tlscoInit);
  Assert(FClientState = tlsclInit);
  DoStart;
end;



end.

