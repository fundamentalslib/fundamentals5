{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals TLS                                         }
{   File name:        flcTLSHandshake.pas                                      }
{   File version:     5.04                                                     }
{   Description:      TLS handshake protocol                                   }
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
{   2008/01/18  0.01  Initial development: Headers                             }
{   2010/11/26  0.02  Initial development: Messages                            }
{   2016/01/08  0.03  String changes                                           }
{   2018/07/17  5.04  Revised for Fundamentals 5.                              }
{                                                                              }
{******************************************************************************}

{$INCLUDE flcTLS.inc}

unit flcTLSHandshake;

interface

uses
  { Fundamentals }
  flcStdTypes,
  flcCipherRSA,
  { TLS }
  flcTLSUtils,
  flcTLSCipherSuite;



{                                                                              }
{ HandshakeHeader                                                              }
{                                                                              }
type
  TTLSHandshakeType = (
    tlshtHello_request       = 0,
    tlshtClient_hello        = 1,
    tlshtServer_hello        = 2,
    tlshtCertificate         = 11,
    tlshtServer_key_exchange = 12,
    tlshtCertificate_request = 13,
    tlshtServer_hello_done   = 14,
    tlshtCertificate_verify  = 15,
    tlshtClient_key_exchange = 16,
    tlshtFinished            = 20,
    tlshtCertificate_url     = 21, // RFC 6066
    tlshtCertificate_status  = 22, // RFC 6066
    tlshtMax                 = 255
    );

  TTLSHandshakeHeader = packed record
    msg_type : TTLSHandshakeType;    // handshake type
    length   : array[0..2] of Byte;  // bytes in message
  end;
  PTLSHandshakeHeader = ^TTLSHandshakeHeader;

const
  TLSHandshakeHeaderSize = Sizeof(TTLSHandshakeHeader);

function  TLSHandshakeTypeToStr(const A: TTLSHandshakeType): String;

procedure EncodeTLSHandshakeHeader(
          var Handshake: TTLSHandshakeHeader;
          const MsgType: TTLSHandshakeType;
          const Length: Integer);
procedure DecodeTLSHandshakeHeader(
          const Handshake: TTLSHandshakeHeader;
          var MsgType: TTLSHandshakeType;
          var Length: Integer);

function  TLSHandshakeDataPtr(
          const Buffer; const Size: Integer;
          var DataSize: Integer): Pointer;
function  EncodeTLSHandshake(
          var Buffer; const Size: Integer;
          const MsgType: TTLSHandshakeType; const MsgSize: Integer): Integer;



{                                                                              }
{ HelloRequest                                                                 }
{                                                                              }
function  EncodeTLSHandshakeHelloRequest(var Buffer; const Size: Integer): Integer;



{                                                                              }
{ ClientHello                                                                  }
{                                                                              }
type
  TTLSClientHello = record
    ProtocolVersion    : TTLSProtocolVersion;
    SessionID          : TTLSSessionID;
    CipherSuites       : TTLSCipherSuites;
    CompressionMethods : TTLSCompressionMethods;
    Random             : TTLSRandom;
    ExtensionsPresent  : Boolean;
  end;

procedure InitTLSClientHello(
          var ClientHello: TTLSClientHello;
          const ProtocolVersion: TTLSProtocolVersion;
          const SessionID: RawByteString);
function  EncodeTLSClientHello(
          var Buffer; const Size: Integer;
          const ClientHello: TTLSClientHello): Integer;
function  DecodeTLSClientHello(
          const Buffer; const Size: Integer;
          var ClientHello: TTLSClientHello): Integer;

function  EncodeTLSHandshakeClientHello(
          var Buffer; const Size: Integer;
          const ClientHello: TTLSClientHello): Integer;



{                                                                              }
{ ServerHello                                                                  }
{                                                                              }
type
  TTLSServerHello = record
    ProtocolVersion   : TTLSProtocolVersion;
    SessionID         : TTLSSessionID;
    CipherSuite       : TTLSCipherSuiteRec;
    CompressionMethod : TTLSCompressionMethod;
    Random            : TTLSRandom;
  end;

procedure InitTLSServerHello(
          var ServerHello: TTLSServerHello;
          const ProtocolVersion: TTLSProtocolVersion;
          const SessionID: RawByteString;
          const CipherSuite: TTLSCipherSuiteRec;
          const CompressionMethod: TTLSCompressionMethod);
function  EncodeTLSServerHello(
          var Buffer; const Size: Integer;
          const ServerHello: TTLSServerHello): Integer;
function  DecodeTLSServerHello(
          const Buffer; const Size: Integer;
          var ServerHello: TTLSServerHello): Integer;

function  EncodeTLSHandshakeServerHello(
          var Buffer; const Size: Integer;
          const ServerHello: TTLSServerHello): Integer;



{                                                                              }
{ Certificate                                                                  }
{                                                                              }
type
  TTLSCertificateList = array of RawByteString;

procedure TLSCertificateListAppend(var List: TTLSCertificateList; const A: RawByteString);

function  EncodeTLSCertificate(
          var Buffer; const Size: Integer;
          const CertificateList: TTLSCertificateList): Integer;
function  DecodeTLSCertificate(
          const Buffer; const Size: Integer;
          var CertificateList: TTLSCertificateList): Integer;

function  EncodeTLSHandshakeCertificate(
          var Buffer; const Size: Integer;
          const CertificateList: TTLSCertificateList): Integer;



{                                                                              }
{ ServerDHParams                                                               }
{                                                                              }
type
  TTLSServerDHParams = record
    dh_p  : RawByteString;
    dh_g  : RawByteString;
    dh_Ys : RawByteString;
  end;

procedure InitTLSServerDHParams_None(var ServerDHParams: TTLSServerDHParams);
procedure InitTLSServerDHParams(var ServerDHParams: TTLSServerDHParams;
          const p, g, Ys: RawByteString);

function  EncodeTLSServerDHParams(
          var Buffer; const Size: Integer;
          const ServerDHParams: TTLSServerDHParams): Integer;
function  DecodeTLSServerDHParams(
          const Buffer; const Size: Integer;
          var ServerDHParams: TTLSServerDHParams): Integer;



{                                                                              }
{ SignedParams                                                                 }
{                                                                              }
type
  TTLSSignedParams = record
    client_random : array[0..31] of Byte;
    server_random : array[0..31] of Byte;
    params        : TTLSServerDHParams;
  end;

procedure InitTLSSignedParams(var SignedParams: TTLSSignedParams);

function  EncodeTLSSignedParams(
          var Buffer; const Size: Integer;
          const SignedParams: TTLSSignedParams): Integer;
function  DecodeTLSSignedParams(
          const Buffer; const Size: Integer;
          var SignedParams: TTLSSignedParams): Integer;



{                                                                              }
{ ServerKeyExchange                                                            }
{                                                                              }
type
  TTLSServerKeyExchange = record
    Params       : TTLSServerDHParams;
    SignedParams : TTLSSignedParams;
  end;

procedure InitTLSServerKeyExchange(var ServerKeyExchange: TTLSServerKeyExchange);

function  EncodeTLSServerKeyExchange(
          var Buffer; const Size: Integer;
          const KeyExchangeAlgorithm: TTLSKeyExchangeAlgorithm;
          const ServerKeyExchange: TTLSServerKeyExchange): Integer;
function  DecodeTLSServerKeyExchange(
          const Buffer; const Size: Integer;
          const KeyExchangeAlgorithm: TTLSKeyExchangeAlgorithm;
          var ServerKeyExchange: TTLSServerKeyExchange): Integer;

function  EncodeTLSHandshakeServerKeyExchange(
          var Buffer; const Size: Integer;
          const KeyExchangeAlgorithm: TTLSKeyExchangeAlgorithm;
          const ServerKeyExchange: TTLSServerKeyExchange): Integer;



{                                                                              }
{ CertificateRequest                                                           }
{                                                                              }
type
  TTLSClientCertificateType = (
      tlscctRsa_sign                  = 1,
      tlscctDss_sign                  = 2,
      tlscctRsa_fixed_dh              = 3,
      tlscctDss_fixed_dh              = 4,
      tlscctRsa_ephemeral_dh_RESERVED = 5,
      tlscctDss_ephemeral_dh_RESERVED = 6,
      tlscctFortezza_dms_RESERVED     = 20,
      tlscctMax                       = 255
  );
  TTLSClientCertificateTypeArray = array of TTLSClientCertificateType;

  TTLSCertificateRequest = record
    CertificateTypes             : TTLSClientCertificateTypeArray;
    SupportedSignatureAlgorithms : TTLSSignatureAndHashAlgorithmArray;
    DistinguishedName            : RawByteString;
  end;

function  EncodeTLSCertificateRequest(
          var Buffer; const Size: Integer;
          const CertificateRequest: TTLSCertificateRequest): Integer;
function  DecodeTLSCertificateRequest(
          const Buffer; const Size: Integer;
          var CertificateRequest: TTLSCertificateRequest): Integer;

function  EncodeTLSHandshakeCertificateRequest(
          var Buffer; const Size: Integer;
          const CertificateRequest: TTLSCertificateRequest): Integer;



{                                                                              }
{ ServerHelloDone                                                              }
{                                                                              }
function  EncodeTLSHandshakeServerHelloDone(var Buffer; const Size: Integer): Integer;



{                                                                              }
{ CertificateVerify                                                            }
{                                                                              }
function  EncodeTLSHandshakeCertificateVerify(var Buffer; const Size: Integer): Integer;



{                                                                              }
{ PreMasterSecret                                                              }
{                                                                              }
type
  TTLSPreMasterSecret = packed record
    client_version : TTLSProtocolVersion;
    random         : array[0..45] of Byte;
  end;

const
  TLSPreMasterSecretSize = SizeOf(TTLSPreMasterSecret);

procedure InitTLSPreMasterSecret_Random(
          var PreMasterSecret: TTLSPreMasterSecret;
          const ClientVersion: TTLSProtocolVersion);

function  TLSPreMasterSecretToStr(const PreMasterSecret: TTLSPreMasterSecret): RawByteString;

procedure InitTLSEncryptedPreMasterSecret_RSA(
          var EncryptedPreMasterSecret: RawByteString;
          const PreMasterSecret: TTLSPreMasterSecret;
          const RSAPublicKey: TRSAPublicKey);




{                                                                              }
{ ClientDiffieHellmanPublic                                                    }
{                                                                              }
type
  TTLSClientDiffieHellmanPublic = record
    PublicValueEncodingExplicit : Boolean;
    dh_Yc : RawByteString;
  end;

function EncodeTLSClientDiffieHellmanPublic(
         var Buffer; const Size: Integer;
         const ClientDiffieHellmanPublic: TTLSClientDiffieHellmanPublic): Integer;
function DecodeTLSClientDiffieHellmanPublic(
         const Buffer; const Size: Integer;
         const PublicValueEncodingExplicit: Boolean;
         var ClientDiffieHellmanPublic: TTLSClientDiffieHellmanPublic): Integer;



{                                                                              }
{ ClientKeyExchange                                                            }
{                                                                              }
type
  TTLSClientKeyExchange = record
    EncryptedPreMasterSecret  : RawByteString;
    ClientDiffieHellmanPublic : TTLSClientDiffieHellmanPublic;
  end;

function  EncodeTLSClientKeyExchange(
          var Buffer; const Size: Integer;
          const KeyExchangeAlgorithm: TTLSKeyExchangeAlgorithm;
          const ClientKeyExchange: TTLSClientKeyExchange): Integer;

function  EncodeTLSHandshakeClientKeyExchange(
          var Buffer; const Size: Integer;
          const KeyExchangeAlgorithm: TTLSKeyExchangeAlgorithm;
          const ClientKeyExchange: TTLSClientKeyExchange): Integer;

function  DecodeTLSClientKeyExchange(
          const Buffer; const Size: Integer;
          const KeyExchangeAlgorithm: TTLSKeyExchangeAlgorithm;
          const PublicValueEncodingExplicit: Boolean;
          var ClientKeyExchange: TTLSClientKeyExchange): Integer;



{                                                                              }
{ Finished                                                                     }
{                                                                              }
function  EncodeTLSHandshakeFinished(var Buffer; const Size: Integer;
          const MasterSecret: RawByteString;
          const ProtocolVersion: TTLSProtocolVersion;
          const HandshakeData: RawByteString;
          const SenderIsClient: Boolean): Integer;



{                                                                              }
{ ChangeCipherSpec Protocol                                                    }
{                                                                              }
type
  TTLSChangeCipherSpecType = (
    spectype_change_cipher_spec = 1);
  TTLSChangeCipherSpec = packed record
    _type : TTLSChangeCipherSpecType;
  end;
  PTLSChangeCipherSpec = ^TTLSChangeCipherSpec;

const
  TLSChangeCipherSpecSize = Sizeof(TTLSChangeCipherSpec);

procedure InitTLSChangeCipherSpec(var ChangeCipherSpec: TTLSChangeCipherSpec);



{                                                                              }
{ Unit test                                                                    }
{                                                                              }
{$IFDEF TLS_TEST}
procedure Test;
{$ENDIF}



implementation

uses
  { System }
  SysUtils,
  { Fundamentals }
  flcStrings,
  flcHash,
  flcCipherRandom;



{                                                                              }
{ Helper functions                                                             }
{                                                                              }
function EncodeTLSLen16(var Buffer; const Size: Integer; const Len: Integer): Integer;
var P : PByte;
begin
  Assert(Len >= 0);
  Assert(Len <= $FFFF);
  if Size < 2 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  P := @Buffer;
  P^ := (Len and $FF00) shr 8;
  Inc(P);
  P^ := (Len and $00FF);
  Result := 2;
end;

function EncodeTLSLen24(var Buffer; const Size: Integer; const Len: Integer): Integer;
var P : PByte;
begin
  Assert(Len >= 0);
  Assert(Len <= $FFFFFF);
  if Size < 3 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  P := @Buffer;
  P^ := (Len and $FF0000) shr 16;
  Inc(P);
  P^ := (Len and $00FF00) shr 8;
  Inc(P);
  P^ := (Len and $0000FF);
  Result := 3;
end;

function DecodeTLSLen16(const Buffer; const Size: Integer; var Len: Integer): Integer;
var P : PByte;
begin
  if Size < 2 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  P := @Buffer;
  Len := P^ shl 8;
  Inc(P);
  Inc(Len, P^);
  Result := 2;
end;

function DecodeTLSLen24(const Buffer; const Size: Integer; var Len: Integer): Integer;
var P : PByte;
begin
  if Size < 3 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  P := @Buffer;
  Len := P^ shl 16;
  Inc(P);
  Inc(Len, P^ shl 8);
  Inc(P);
  Inc(Len, P^);
  Result := 3;
end;

function EncodeTLSOpaque16(var Buffer; const Size: Integer; const A: RawByteString): Integer;
var P : PByte;
    N, L : Integer;
begin
  N := Size;
  P := @Buffer;
  L := Length(A);
  EncodeTLSLen16(P^, N, L);
  Inc(P, 2);
  Dec(N, 2);
  Dec(N, L);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  if L > 0 then
    Move(A[1], P^, L);
  Result := Size - N;
end;

function EncodeTLSOpaque24(var Buffer; const Size: Integer; const A: RawByteString): Integer;
var P : PByte;
    N, L : Integer;
begin
  N := Size;
  P := @Buffer;
  L := Length(A);
  EncodeTLSLen24(P^, N, L);
  Inc(P, 3);
  Dec(N, 3);
  Dec(N, L);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  if L > 0 then
    Move(A[1], P^, L);
  Result := Size - N;
end;

function DecodeTLSOpaque16(const Buffer; const Size: Integer; var A: RawByteString): Integer;
var P : PByte;
    N, L : Integer;
begin
  N := Size;
  P := @Buffer;
  DecodeTLSLen16(P^, N, L);
  Inc(P, 2);
  Dec(N, 2);
  Dec(N, L);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  SetLength(A, L);
  if L > 0 then
    Move(P^, A[1], L);
  Result := Size - N;
end;

function DecodeTLSOpaque24(const Buffer; const Size: Integer; var A: RawByteString): Integer;
var P : PByte;
    N, L : Integer;
begin
  N := Size;
  P := @Buffer;
  DecodeTLSLen24(P^, N, L);
  Inc(P, 3);
  Dec(N, 3);
  Dec(N, L);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  SetLength(A, L);
  if L > 0 then
    Move(P^, A[1], L);
  Result := Size - N;
end;



{                                                                              }
{ Handshake Header                                                             }
{                                                                              }
function TLSHandshakeTypeToStr(const A: TTLSHandshakeType): String;
begin
  case A of
    tlshtHello_request       : Result := 'Hello request';
    tlshtClient_hello        : Result := 'Client hello';
    tlshtServer_hello        : Result := 'Server hello';
    tlshtCertificate         : Result := 'Certificate';
    tlshtServer_key_exchange : Result := 'Server key exchange';
    tlshtCertificate_request : Result := 'Certficiate request';
    tlshtServer_hello_done   : Result := 'Server hello done';
    tlshtCertificate_verify  : Result := 'Certificate verify';
    tlshtClient_key_exchange : Result := 'Client key exchange';
    tlshtFinished            : Result := 'Finished';
  else
    Result := '[Handshake#' + IntToStr(Ord(A)) + ']';
  end;
end;

procedure EncodeTLSHandshakeHeader(
          var Handshake: TTLSHandshakeHeader;
          const MsgType: TTLSHandshakeType;
          const Length: Integer);
var I : Byte;
    L : Integer;
begin
  Assert(Length >= 0);
  Assert(Length <= $FFFFFF);
  Handshake.msg_type := MsgType;
  L := Length;
  I := L div $10000;
  Handshake.length[0] := I;
  L := L - I * $10000;
  I := L div $100;
  Handshake.length[1] := I;
  L := L - I * $100;
  I := Byte(L);
  Handshake.length[2] := I;
end;

procedure DecodeTLSHandshakeHeader(
          const Handshake: TTLSHandshakeHeader;
          var MsgType: TTLSHandshakeType;
          var Length: Integer);
begin
  MsgType := Handshake.msg_type;
  Length :=
      Handshake.length[0] * $10000 +
      Handshake.length[1] * $100 +
      Handshake.length[2];
end;

function TLSHandshakeDataPtr(
         const Buffer; const Size: Integer;
         var DataSize: Integer): Pointer;
var P : PByte;
begin
  P := @Buffer;
  if not Assigned(P) or (Size < TLSHandshakeHeaderSize) then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  DataSize := Size - TLSHandshakeHeaderSize;
  Inc(P, TLSHandshakeHeaderSize);
  Result := P;
end;

function EncodeTLSHandshake(
         var Buffer; const Size: Integer;
         const MsgType: TTLSHandshakeType; const MsgSize: Integer): Integer;
var L : Integer;
    P : PByte;
begin
  Assert(MsgSize >= 0);
  P := @Buffer;
  L := TLSHandshakeHeaderSize + MsgSize;
  if not Assigned(P) or (Size < L) then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  EncodeTLSHandshakeHeader(PTLSHandshakeHeader(P)^, MsgType, MsgSize);
  Result := L;
end;



{                                                                              }
{ Hello Request                                                                }
{                                                                              }
function EncodeTLSHandshakeHelloRequest(var Buffer; const Size: Integer): Integer;
begin
  Result := EncodeTLSHandshake(Buffer, Size, tlshtHello_request, 0);
end;



{                                                                              }
{ ClientHello                                                                  }
{   client_version                : TTLSProtocolVersion;                       }
{   random                        : TTLSRandom;                                }
{   session_id                    : TLSSessionID;                              }
{   cipher_suites_count           : Word;                                      }
{   cipher_suites                 : <2..2^16-1> TTLSCipherSuite;               }
{   compression_methods_count     : Byte;                                      }
{   compression_methods           : <1..2^8-1> TTLSCompressionMethod;          }
{   select (extensions_present)                                                }
{       case false: ;                                                          }
{       case true:  Extension extensions<0..2^16-1>;                           }
{                                                                              }
procedure InitTLSClientHello(
          var ClientHello: TTLSClientHello;
          const ProtocolVersion: TTLSProtocolVersion;
          const SessionID: RawByteString);
begin
  ClientHello.ProtocolVersion := ProtocolVersion;
  InitTLSSessionID(ClientHello.SessionID, SessionID);
  InitTLSRandom(ClientHello.Random);
end;

function EncodeTLSClientHello(
         var Buffer; const Size: Integer;
         const ClientHello: TTLSClientHello): Integer;
var P     : PByte;
    L, N  : Integer;
    C     : TTLSCipherSuite;
    D     : TTLSCompressionMethod;
    Suite : TTLSCipherSuiteRec;
begin
  Assert(Assigned(@Buffer));

  N := Size;
  P := @Buffer;

  // client_version
  Dec(N, TLSProtocolVersionSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  PTLSProtocolVersion(P)^ := ClientHello.ProtocolVersion;
  Inc(P, TLSProtocolVersionSize);
  // random
  Dec(N, TLSRandomSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  PTLSRandom(P)^ := ClientHello.Random;
  Inc(P, TLSRandomSize);
  // session_id
  L := EncodeTLSSessionID(P^, N, ClientHello.SessionID);
  Dec(N, L);
  Inc(P, L);
  // cipher_suites
  L := 0;
  for C := Low(TTLSCipherSuite) to High(TTLSCipherSuite) do
    if C in ClientHello.CipherSuites then
      Inc(L);
  Assert(L <= $FFFF);
  EncodeTLSLen16(P^, N, L * TLSCipherSuiteRecSize);
  Inc(P, 2);
  Dec(N, 2 + L * TLSCipherSuiteRecSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  for C := Low(TTLSCipherSuite) to High(TTLSCipherSuite) do
    if C in ClientHello.CipherSuites then
      begin
        Suite.B1 := TLSCipherSuiteInfo[C].Rec.B1;
        Suite.B2 := TLSCipherSuiteInfo[C].Rec.B2;
        PTLSCipherSuiteRec(P)^ := Suite;
        Inc(P, TLSCipherSuiteRecSize);
      end;
  // compression_methods
  L := 0;
  for D := Low(TTLSCompressionMethod) to High(TTLSCompressionMethod) do
    if D in ClientHello.CompressionMethods then
      Inc(L);
  Assert(L <= $FF);
  Dec(N, 1 + L);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  P^ := L;
  Inc(P);
  for D := Low(TTLSCompressionMethod) to High(TTLSCompressionMethod) do
    if D in ClientHello.CompressionMethods then
      begin
        P^ := Ord(D);
        Inc(P);
      end;

  Result := Size - N;
end;

function DecodeTLSClientHello(
         const Buffer; const Size: Integer;
         var ClientHello: TTLSClientHello): Integer;
var P : PByte;
    L, N, C : Integer;
    I : Word;
    E : TTLSCipherSuite;
    F : TTLSCipherSuiteRec;
    D : TTLSCompressionMethod;
begin
  Assert(Assigned(@Buffer));
  Assert(Size >= 0);

  N := Size;
  P := @Buffer;

  // client_version
  Dec(N, TLSProtocolVersionSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  ClientHello.ProtocolVersion := PTLSProtocolVersion(P)^;
  Inc(P, TLSProtocolVersionSize);
  // random
  Dec(N, TLSRandomSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  ClientHello.Random := PTLSRandom(P)^;
  Inc(P, TLSRandomSize);
  // session_id
  L := DecodeTLSSessionID(P^, N, ClientHello.SessionID);
  Dec(N, L);
  Inc(P, L);
  // cipher_suites
  ClientHello.CipherSuites := [];
  L := DecodeTLSLen16(P^, N, C);
  Dec(N, L);
  Inc(P, L);
  Dec(N, C);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  C := C div TLSCipherSuiteRecSize;
  for I := 0 to C - 1 do
    begin
      F := PTLSCipherSuiteRec(P)^;
      E := GetCipherSuiteByRec(F.B1, F.B2);
      Include(ClientHello.CipherSuites, E);
      Inc(P, TLSCipherSuiteRecSize);
    end;
  // compression_methods
  Dec(N);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  ClientHello.CompressionMethods := [];
  C := P^;
  Inc(P);
  Dec(N, C);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  for I := 0 to C - 1 do
    begin
      D := PTLSCompressionMethod(P)^;
      Include(ClientHello.CompressionMethods, D);
      Inc(P, TLSCompressionMethodSize);
    end;
  // extensions
  ClientHello.ExtensionsPresent := N > 0;
  
  Result := Size - N;
end;

function EncodeTLSHandshakeClientHello(
         var Buffer; const Size: Integer;
         const ClientHello: TTLSClientHello): Integer;
var P : Pointer;
    N, L : Integer;
begin
  P := TLSHandshakeDataPtr(Buffer, Size, N);
  L := EncodeTLSClientHello(P^, N, ClientHello);
  Result := EncodeTLSHandshake(Buffer, Size, tlshtClient_hello, L);
end;



{                                                                              }
{ ServerHello                                                                  }
{   server_version     : TTLSProtocolVersion;                                  }
{   random             : TTLSRandom;                                           }
{   session_id         : TLSSessionID;                                         }
{   cipher_suite       : TTLSCipherSuite;                                      }
{   compression_method : TTLSCompressionMethod;                                }
{   select (extensions_present)                                                }
{       case false: ;                                                          }
{       case true:  Extension extensions<0..2^16-1>;                           }
{                                                                              }
procedure InitTLSServerHello(
          var ServerHello: TTLSServerHello;
          const ProtocolVersion: TTLSProtocolVersion;
          const SessionID: RawByteString;
          const CipherSuite: TTLSCipherSuiteRec;
          const CompressionMethod: TTLSCompressionMethod);
begin
  ServerHello.ProtocolVersion := ProtocolVersion;
  InitTLSSessionID(ServerHello.SessionID, SessionID);
  ServerHello.CipherSuite := CipherSuite;
  ServerHello.CompressionMethod := CompressionMethod;
  InitTLSRandom(ServerHello.Random);
end;

function EncodeTLSServerHello(
         var Buffer; const Size: Integer;
         const ServerHello: TTLSServerHello): Integer;
var P : PByte;
    L, N : Integer;
begin
  Assert(Assigned(@Buffer));
  Assert(Size >= 0);

  N := Size;
  P := @Buffer;
  // server_version
  Dec(N, TLSProtocolVersionSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  PTLSProtocolVersion(P)^ := ServerHello.ProtocolVersion;
  Inc(P, TLSProtocolVersionSize);
  // random
  Dec(N, TLSRandomSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  PTLSRandom(P)^ := ServerHello.Random;
  Inc(P, TLSRandomSize);
  // session_id
  L := EncodeTLSSessionID(P^, N, ServerHello.SessionID);
  Dec(N, L);
  Inc(P, L);
  // cipher_suite
  Dec(N, TLSCipherSuiteRecSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  PTLSCipherSuiteRec(P)^ := ServerHello.CipherSuite;
  Inc(P, TLSCipherSuiteRecSize);
  // compression_method
  Dec(N, TLSCompressionMethodSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  PTLSCompressionMethod(P)^ := ServerHello.CompressionMethod;

  Result := Size - N;
end;

function DecodeTLSServerHello(
         const Buffer; const Size: Integer;
         var ServerHello: TTLSServerHello): Integer;
var P : PByte;
    L, N : Integer;
begin
  Assert(Assigned(@Buffer));
  Assert(Size >= 0);

  N := Size;
  P := @Buffer;
  // server_version
  Dec(N, TLSProtocolVersionSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  ServerHello.ProtocolVersion := PTLSProtocolVersion(P)^;
  Inc(P, TLSProtocolVersionSize);
  // random
  Dec(N, TLSRandomSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  ServerHello.Random := PTLSRandom(P)^;
  Inc(P, TLSRandomSize);
  // session_id
  L := DecodeTLSSessionID(P^, N, ServerHello.SessionID);
  Dec(N, L);
  Inc(P, L);
  // cipher_suite
  Dec(N, TLSCipherSuiteRecSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  ServerHello.CipherSuite := PTLSCipherSuiteRec(P)^;
  Inc(P, TLSCipherSuiteRecSize);
  // compression_method
  Dec(N, TLSCompressionMethodSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  ServerHello.CompressionMethod := PTLSCompressionMethod(P)^;

  Result := Size - N;
end;

function EncodeTLSHandshakeServerHello(
         var Buffer; const Size: Integer;
         const ServerHello: TTLSServerHello): Integer;
var P : Pointer;
    N, L : Integer;
begin
  P := TLSHandshakeDataPtr(Buffer, Size, N);
  L := EncodeTLSServerHello(P^, N, ServerHello);
  Result := EncodeTLSHandshake(Buffer, Size, tlshtServer_hello, L);
end;



{                                                                              }
{ Certificate                                                                  }
{   certificate_list  : <0..2^24-1> ASN.1Cert;                                 }
{                                                                              }
{ ASN.1Cert = <1..2^24-1> opaque;                                              }
{                                                                              }
procedure TLSCertificateListAppend(var List: TTLSCertificateList; const A: RawByteString);
var L : Integer;
begin
  L := Length(List);
  SetLength(List, L + 1);
  List[L] := A;
end;

function EncodeTLSCertificate(
         var Buffer; const Size: Integer;
         const CertificateList: TTLSCertificateList): Integer;
var P : PByte;
    N, L, I, M, T : Integer;
    C : RawByteString;
begin
  Assert(Size >= 0);
  N := Size;
  P := @Buffer;
  // certificate_list
  L := Length(CertificateList);
  T := 0;
  for I := 0 to L - 1 do
    Inc(T, 3 + Length(CertificateList[I]));
  EncodeTLSLen24(P^, N, T);
  Dec(N, 3);
  Inc(P, 3);
  for I := 0 to L - 1 do
    begin
      // ASN.1Cert
      C := CertificateList[I];
      if C = '' then
        raise ETLSError.Create(TLSError_InvalidCertificate);
      M := EncodeTLSOpaque24(P^, N, C);
      Dec(N, M);
      Inc(P, M);
    end;

  Result := Size - N;
end;

function DecodeTLSCertificate(
         const Buffer; const Size: Integer;
         var CertificateList: TTLSCertificateList): Integer;
var P : PByte;
    N, L, M, F : Integer;
    C : RawByteString;
begin
  Assert(Size >= 0);
  N := Size;
  P := @Buffer;
  // certificate_list
  DecodeTLSLen24(P^, N, L);
  Dec(N, 3);
  Inc(P, 3);
  SetLength(CertificateList, 0);
  F := 0;
  while L > 0 do
    begin
      // ASN.1Cert
      M := DecodeTLSOpaque24(P^, N, C);
      Dec(N, M);
      Inc(P, M);
      Dec(L, M);
      Inc(F);
      SetLength(CertificateList, F);
      CertificateList[F - 1] := C;
    end;
  Result := Size - N;
end;

function EncodeTLSHandshakeCertificate(
         var Buffer; const Size: Integer;
         const CertificateList: TTLSCertificateList): Integer;
var P : Pointer;
    N, L : Integer;
begin
  P := TLSHandshakeDataPtr(Buffer, Size, N);
  L := EncodeTLSCertificate(P^, N, CertificateList);
  Result := EncodeTLSHandshake(Buffer, Size, tlshtCertificate, L);
end;



{                                                                              }
{ ServerDHParams                                                               }
{ Ephemeral DH parameters                                                      }
{                                                                              }
{     dh_p  : opaque <1..2^16-1>;                                              }
{     dh_g  : opaque <1..2^16-1>;                                              }
{     dh_Ys : opaque <1..2^16-1>;                                              }
{                                                                              }
procedure InitTLSServerDHParams_None(var ServerDHParams: TTLSServerDHParams);
begin
  ServerDHParams.dh_p := '';
  ServerDHParams.dh_g := '';
  ServerDHParams.dh_Ys := '';
end;

procedure InitTLSServerDHParams(var ServerDHParams: TTLSServerDHParams;
          const p, g, Ys: RawByteString);
begin
  ServerDHParams.dh_p := p;
  ServerDHParams.dh_g := g;
  ServerDHParams.dh_Ys := Ys;
end;

function EncodeTLSServerDHParams(
         var Buffer; const Size: Integer;
         const ServerDHParams: TTLSServerDHParams): Integer;
var P : PByte;
    N, L : Integer;
begin
  Assert(Size >= 0);
  if (ServerDHParams.dh_p = '') or
     (ServerDHParams.dh_g = '') or
     (ServerDHParams.dh_Ys = '') then
    raise ETLSError.Create(TLSError_InvalidParameter);
  N := Size;
  P := @Buffer;
  // dh_p
  L := EncodeTLSOpaque16(P^, N, ServerDHParams.dh_p);
  Dec(N, L);
  Inc(P, L);
  // dh_g
  L := EncodeTLSOpaque16(P^, N, ServerDHParams.dh_g);
  Dec(N, L);
  Inc(P, L);
  // dh_Ys
  L := EncodeTLSOpaque16(P^, N, ServerDHParams.dh_Ys);
  Dec(N, L);
  Result := Size - N;
end;

function DecodeTLSServerDHParams(
         const Buffer; const Size: Integer;
         var ServerDHParams: TTLSServerDHParams): Integer;
var P : PByte;
    N, L : Integer;
begin
  Assert(Size >= 0);
  N := Size;
  P := @Buffer;
  // dh_p
  L := DecodeTLSOpaque16(P^, N, ServerDHParams.dh_p);
  Dec(N, L);
  Inc(P, L);
  // dh_g
  L := DecodeTLSOpaque16(P^, N, ServerDHParams.dh_g);
  Dec(N, L);
  Inc(P, L);
  // dh_Ys
  L := DecodeTLSOpaque16(P^, N, ServerDHParams.dh_Ys);
  Dec(N, L);
  Result := Size - N;
end;


{                                                                              }
{ TTLSSignedParams                                                             }
{                   signed_params = digitally-signed struct (                  }
{                     client_random : opaque [32];                             }
{                     server_random : opaque [32];                             }
{                     params : ServerDHParams ;                                }
{                     );                                                       }
{                                                                              }
procedure InitTLSSignedParams(var SignedParams: TTLSSignedParams);
begin
  FillChar(SignedParams.client_random, SizeOf(SignedParams.client_random), 0);
  FillChar(SignedParams.server_random, SizeOf(SignedParams.server_random), 0);
  InitTLSServerDHParams_None(SignedParams.params);
end;

function EncodeTLSSignedParams(
         var Buffer; const Size: Integer;
         const SignedParams: TTLSSignedParams): Integer;
var P : PByte;
    N, L : Integer;
begin
  N := Size;
  P := @Buffer;
  Dec(N, 64);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  Move(SignedParams.client_random, P^, 32);
  Inc(P, 32);
  Move(SignedParams.server_random, P^, 32);
  Inc(P, 32);
  L := EncodeTLSServerDHParams(P^, N, SignedParams.params);
  Dec(N, L);
  Result := Size - N;
end;

function DecodeTLSSignedParams(
         const Buffer; const Size: Integer;
         var SignedParams: TTLSSignedParams): Integer;
var P : PByte;
    N, L : Integer;
begin
  N := Size;
  P := @Buffer;
  Dec(N, 64);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  Move(P^, SignedParams.client_random, 32);
  Inc(P, 32);
  Move(P^, SignedParams.server_random, 32);
  Inc(P, 32);
  L := DecodeTLSServerDHParams(P^, N, SignedParams.params);
  Dec(N, L);
  Result := Size - N;
end;



{                                                                              }
{ Server Key Exchange                                                          }
{                                                                              }
{   select (KeyExchangeAlgorithm)                                              }
{     case dh_anon: params : ServerDHParams;                                   }
{     case dhe_dss:                                                            }
{     case dhe_rsa: params : ServerDHParams;                                   }
{                   signed_params : digitally-signed = struct (                }
{                     client_random : opaque [32];                             }
{                     server_random : opaque [32];                             }
{                     params : ServerDHParams ;                                }
{                     );                                                       }
{     case rsa:                                                                }
{     case dh_dss:                                                             }
{     case dh_rsa: struct ();                                                  }
{                                                                              }
procedure InitTLSServerKeyExchange(var ServerKeyExchange: TTLSServerKeyExchange);
begin
  InitTLSServerDHParams_None(ServerKeyExchange.Params);
  InitTLSSignedParams(ServerKeyExchange.SignedParams);
end;

function  EncodeTLSServerKeyExchange(
          var Buffer; const Size: Integer;
          const KeyExchangeAlgorithm: TTLSKeyExchangeAlgorithm;
          const ServerKeyExchange: TTLSServerKeyExchange): Integer;
var P : PByte;
    N, L : Integer;
begin
  N := Size;
  P := @Buffer;
  case KeyExchangeAlgorithm of
    tlskeaDH_Anon :
      begin
        L := EncodeTLSServerDHParams(P^, N, ServerKeyExchange.Params);
        Dec(N, L);
      end;
    tlskeaDHE_DSS,
    tlskeaDHE_RSA :
      begin
        L := EncodeTLSServerDHParams(P^, N, ServerKeyExchange.Params);
        Dec(N, L);
        Inc(P, L);
        L := EncodeTLSSignedParams(P^, N, ServerKeyExchange.SignedParams);
        Dec(N, L);
      end;
    tlskeaRSA,
    tlskeaDH_DSS,
    tlskeaDH_RSA : ;
  end;
  Result := Size - N;
end;

function DecodeTLSServerKeyExchange(
         const Buffer; const Size: Integer;
         const KeyExchangeAlgorithm: TTLSKeyExchangeAlgorithm;
         var ServerKeyExchange: TTLSServerKeyExchange): Integer;
var P : PByte;
    N, L : Integer;
begin
  N := Size;
  P := @Buffer;
  case KeyExchangeAlgorithm of
    tlskeaDH_Anon :
      begin
        L := DecodeTLSServerDHParams(P^, N, ServerKeyExchange.Params);
        Dec(N, L);
      end;
    tlskeaDHE_DSS,
    tlskeaDHE_RSA :
      begin
        L := DecodeTLSServerDHParams(P^, N, ServerKeyExchange.Params);
        Dec(N, L);
        Inc(P, L);
        L := DecodeTLSSignedParams(P^, N, ServerKeyExchange.SignedParams);
        Dec(N, L);
      end;
    tlskeaRSA,
    tlskeaDH_DSS,
    tlskeaDH_RSA : ;
  end;
  Result := Size - N;
end;

function EncodeTLSHandshakeServerKeyExchange(
         var Buffer; const Size: Integer;
         const KeyExchangeAlgorithm: TTLSKeyExchangeAlgorithm;
         const ServerKeyExchange: TTLSServerKeyExchange): Integer;
var P : Pointer;
    N, L : Integer;
begin
  P := TLSHandshakeDataPtr(Buffer, Size, N);
  L := EncodeTLSServerKeyExchange(P^, N, KeyExchangeAlgorithm, ServerKeyExchange);
  Result := EncodeTLSHandshake(Buffer, Size, tlshtServer_key_exchange, L);
end;



{                                                                              }
{ Certificate Request                                                          }
{     certificate_types              : ClientCertificateType <1..2^8-1>;       }
{     supported_signature_algorithms : SignatureAndHashAlgorithm <2^16-1>;     }
{     certificate_authorities        : DistinguishedName <0..2^16-1>;          }
{ DistinguishedName = opaque <1..2^16-1>                                       }
{                                                                              }
function EncodeTLSCertificateRequest(
         var Buffer; const Size: Integer;
         const CertificateRequest: TTLSCertificateRequest): Integer;
var P : PByte;
    N, L, I : Integer;
begin
  Assert(Assigned(@Buffer));
  Assert(Size >= 0);

  N := Size;
  P := @Buffer;
  // certificate_types
  L := Length(CertificateRequest.CertificateTypes);
  if (L <= 0) or (L > 255) then
    raise ETLSError.Create(TLSError_InvalidParameter);
  Dec(N, 1 + L);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  P^ := L;
  Inc(P);
  for I := 0 to L -  1 do
    begin
      P^ := Ord(CertificateRequest.CertificateTypes[I]);
      Inc(P);
    end;
  // supported_signature_algorithms
  L := Length(CertificateRequest.SupportedSignatureAlgorithms);
  EncodeTLSLen16(P^, N, L * TLSSignatureAndHashAlgorithmSize);
  Inc(P, 2);
  Dec(N, 2 + L * TLSSignatureAndHashAlgorithmSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  for I := 0 to L - 1 do
    begin
      PTLSSignatureAndHashAlgorithm(P)^ := CertificateRequest.SupportedSignatureAlgorithms[I];
      Inc(P, TLSSignatureAndHashAlgorithmSize);
    end;
  // certificate_authorities
  L := EncodeTLSOpaque16(P^, N, CertificateRequest.DistinguishedName);
  Dec(N, L);
  Result := Size - N;
end;

function DecodeTLSCertificateRequest(
         const Buffer; const Size: Integer;
         var CertificateRequest: TTLSCertificateRequest): Integer;
var P : PByte;
    N, L, I : Integer;
begin
  Assert(Assigned(@Buffer));
  Assert(Size >= 0);

  N := Size;
  P := @Buffer;
  // certificate_types
  Dec(N);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  L := P^;
  Inc(P);
  Dec(N, L);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  SetLength(CertificateRequest.CertificateTypes, L);
  for I := 0 to L - 1 do
    begin
      CertificateRequest.CertificateTypes[I] := TTLSClientCertificateType(P^);
      Inc(P);
    end;
  // supported_signature_algorithms
  DecodeTLSLen16(P^, N, L);
  Assert(L mod TLSSignatureAndHashAlgorithmSize = 0);
  L := L div TLSSignatureAndHashAlgorithmSize;
  Inc(P, 2);
  Dec(N, 2 + L * TLSSignatureAndHashAlgorithmSize);
  if N < 0 then
    raise ETLSError.Create(TLSError_InvalidBuffer);
  SetLength(CertificateRequest.SupportedSignatureAlgorithms, L);
  for I := 0 to L - 1 do
    begin
      CertificateRequest.SupportedSignatureAlgorithms[I] := PTLSSignatureAndHashAlgorithm(P)^;
      Inc(P, TLSSignatureAndHashAlgorithmSize);
    end;
  // certificate_authorities
  L := DecodeTLSOpaque16(P^, N, CertificateRequest.DistinguishedName);
  Dec(N, L);
  Result := Size - N;
end;

function EncodeTLSHandshakeCertificateRequest(
         var Buffer; const Size: Integer;
         const CertificateRequest: TTLSCertificateRequest): Integer;
var P : Pointer;
    N, L : Integer;
    C : TTLSCertificateRequest;
begin
  P := TLSHandshakeDataPtr(Buffer, Size, N);
  L := EncodeTLSCertificateRequest(P^, N, C);
  Result := EncodeTLSHandshake(Buffer, Size, tlshtCertificate_request, L);
end;



{                                                                              }
{ Server Hello Done                                                            }
{                                                                              }
function EncodeTLSHandshakeServerHelloDone(var Buffer; const Size: Integer): Integer;
begin
  Result := EncodeTLSHandshake(Buffer, Size, tlshtServer_hello_done, 0);
end;



{                                                                              }
{ Certificate Verify                                                           }
{                                                                              }
function EncodeTLSHandshakeCertificateVerify(var Buffer; const Size: Integer): Integer;
begin
  Result := EncodeTLSHandshake(Buffer, Size, tlshtCertificate_verify, 0);
end;



{                                                                              }
{ PreMasterSecret                                                              }
{   client_version : ProtocolVersion;                                          }
{   random         : opaque[46];                                               }
{                                                                              }
{ EncryptedPreMasterSecret = public-key-encrypted PreMasterSecret              }
{ Public-key-encrypted data is represented as an opaque vector <0..2^16-1>.    }
{ Thus, the RSA-encrypted PreMasterSecret in a ClientKeyExchange is preceded   }
{ by two length bytes.                                                         }
{                                                                              }
procedure InitTLSPreMasterSecret_Random(var PreMasterSecret: TTLSPreMasterSecret;
          const ClientVersion: TTLSProtocolVersion);
begin
  PreMasterSecret.client_version := ClientVersion;
  SecureRandomBuf(PreMasterSecret.random, SizeOf(PreMasterSecret.random));
end;

function TLSPreMasterSecretToStr(const PreMasterSecret: TTLSPreMasterSecret): RawByteString;
begin
  SetLength(Result, TLSPreMasterSecretSize);
  Move(PreMasterSecret, Result[1], TLSPreMasterSecretSize);
end;

procedure InitTLSEncryptedPreMasterSecret_RSA(
          var EncryptedPreMasterSecret: RawByteString;
          const PreMasterSecret: TTLSPreMasterSecret;
          const RSAPublicKey: TRSAPublicKey);
var B : array[0..1023] of Byte;
    L : Integer;
begin
  L := RSAEncrypt(rsaetPKCS1, RSAPublicKey, PreMasterSecret, SizeOf(PreMasterSecret),
      B, SizeOf(B));
  SetLength(EncryptedPreMasterSecret, L + 2);
  EncodeTLSLen16(EncryptedPremasterSecret[1], L + 2, L);
  Move(B, EncryptedPreMasterSecret[3], L);
end;



{                                                                              }
{ ClientDiffieHellmanPublic                                                    }
{   select (PublicValueEncoding)                                               }
{       case implicit: struct ();                                              }
{       case explicit: opaque dh_Yc<1..2^16-1>;                                }
{                                                                              }
function EncodeTLSClientDiffieHellmanPublic(
         var Buffer; const Size: Integer;
         const ClientDiffieHellmanPublic: TTLSClientDiffieHellmanPublic): Integer;
var P : PByte;
    N, L : Integer;
begin
  N := Size;
  P := @Buffer;
  if ClientDiffieHellmanPublic.PublicValueEncodingExplicit then
    begin
      if ClientDiffieHellmanPublic.dh_Yc = '' then
        raise ETLSError.Create(TLSError_InvalidParameter);
      L := EncodeTLSOpaque16(P^, N, ClientDiffieHellmanPublic.dh_Yc);
      Dec(N, L);
    end;
  Result := Size - N;
end;

function DecodeTLSClientDiffieHellmanPublic(
         const Buffer; const Size: Integer;
         const PublicValueEncodingExplicit: Boolean;
         var ClientDiffieHellmanPublic: TTLSClientDiffieHellmanPublic): Integer;
var P : PByte;
    N, L : Integer;
begin
  N := Size;
  P := @Buffer;
  if PublicValueEncodingExplicit then
    begin
      L := DecodeTLSOpaque16(P^, N, ClientDiffieHellmanPublic.dh_Yc);
      Dec(N, L);
    end;
  Result := Size - N;
end;



{                                                                              }
{ ClientKeyExchange                                                            }
{                                                                              }
{   select (KeyExchangeAlgorithm)                                              }
{       case rsa : EncryptedPreMasterSecret;                                   }
{       case dhe_dss :                                                         }
{       case dhe_rsa :                                                         }
{       case dh_dss  :                                                         }
{       case dh_rsa  :                                                         }
{       case dh_anon : ClientDiffieHellmanPublic;                              }
{                                                                              }
function EncodeTLSClientKeyExchange(
         var Buffer; const Size: Integer;
         const KeyExchangeAlgorithm: TTLSKeyExchangeAlgorithm;
         const ClientKeyExchange: TTLSClientKeyExchange): Integer;
var P : PByte;
    N, L : Integer;
begin
  N := Size;
  P := @Buffer;
  case KeyExchangeAlgorithm of
    tlskeaRSA :
      begin
        L := Length(ClientKeyExchange.EncryptedPreMasterSecret);
        if L = 0 then
          raise ETLSError.Create(TLSError_InvalidParameter);
        Move(ClientKeyExchange.EncryptedPreMasterSecret[1], P^, L);
        Dec(N, L);
      end;
    tlskeaDHE_DSS,
    tlskeaDHE_RSA,
    tlskeaDH_DSS,
    tlskeaDH_RSA,
    tlskeaDH_Anon :
      begin
        L := EncodeTLSClientDiffieHellmanPublic(P^, N, ClientKeyExchange.ClientDiffieHellmanPublic);
        Dec(N, L);
      end;
  end;
  Result := Size - N;
end;

function EncodeTLSHandshakeClientKeyExchange(
         var Buffer; const Size: Integer;
         const KeyExchangeAlgorithm: TTLSKeyExchangeAlgorithm;
         const ClientKeyExchange: TTLSClientKeyExchange): Integer;
var N, L : Integer;
    P : PByte;
begin
  P := TLSHandshakeDataPtr(Buffer, Size, N);
  L := EncodeTLSClientKeyExchange(P^, N, KeyExchangeAlgorithm, ClientKeyExchange);
  Result := EncodeTLSHandshake(Buffer, Size, tlshtClient_key_exchange, L);
end;

function DecodeTLSClientKeyExchange(
         const Buffer; const Size: Integer;
         const KeyExchangeAlgorithm: TTLSKeyExchangeAlgorithm;
         const PublicValueEncodingExplicit: Boolean;
         var ClientKeyExchange: TTLSClientKeyExchange): Integer;
var P : PByte;
    N, L, C : Integer;
begin
  N := Size;
  P := @Buffer;
  case KeyExchangeAlgorithm of
    tlskeaRSA :
      begin
        L := DecodeTLSLen16(P^, N, C);
        Dec(N, L);
        Inc(P, L);
        Assert(N = C);
        SetLength(ClientKeyExchange.EncryptedPreMasterSecret, C);
        Move(P^, ClientKeyExchange.EncryptedPreMasterSecret[1], C);
        Dec(N, C);
      end;
    tlskeaDHE_DSS,
    tlskeaDHE_RSA,
    tlskeaDH_DSS,
    tlskeaDH_RSA,
    tlskeaDH_Anon :
      begin
        L := DecodeTLSClientDiffieHellmanPublic(P^, N, PublicValueEncodingExplicit, ClientKeyExchange.ClientDiffieHellmanPublic);
        Dec(N, L);
      end;
  end;
  Result := Size - N;
end;



{                                                                              }
{ Finished                                                                     }
{                                                                              }
{ SSL 3:                                                                       }
{   Finished                                                                   }
{       opaque md5_hash[16];                                                   }
{       opaque sha_hash[20];                                                   }
{                                                                              }
{ TLS 1.0 1.1 1.2:                                                             }
{   Finished                                                                   }
{       opaque verify_data[12];                                                }
{                                                                              }
type
  TSSLFinishedMD5Hash = array[0..15] of Byte;
  TSSLFinishedSHAHash = array[0..19] of Byte;
  TSSLFinished = packed record
    md5_hash : TSSLFinishedMD5Hash;
    sha_hash : TSSLFinishedSHAHash;
  end;
  PSSLFinished = ^TSSLFinished;

  TTLSFinished = packed record
    verify_data : array[0..11] of Byte;
  end;
  PTLSFinished = ^TTLSFinished;

const
  SSLFinishedSize = SizeOf(TSSLFinished);
  TLSFinishedSize = Sizeof(TTLSFinished);



{                                                                              }
{ SSL 3.0:                                                                     }
{ md5_hash = MD5(master_secret + pad2 +                                        }
{     MD5(handshake_messages + Sender + master_secret + pad1));                }
{ sha_hash = SHA(master_secret + pad2 +                                        }
{     SHA(handshake_messages + Sender + master_secret + pad1));                }
{ pad_1 = The character 0x36 repeated 48 times for MD5 or 40 times for SHA.    }
{ pad_2 = The character 0x5c repeated 48 times for MD5 or 40 times for SHA.    }
{ Sender = enum ( client(0x434C4E54), server(0x53525652) )                     }
{                                                                              }
{ TLS 1.0: verify_data =                                                       }
{     PRF(master_secret, finished_label, MD5(handshake_messages) +             }
{          SHA-1(handshake_messages)) [0..11];                                 }
{                                                                              }
{ TLS 1.2: verify_data =                                                       }
{     PRF(master_secret, finished_label, Hash(handshake_messages))             }
{            [0..verify_data_length-1];                                        }
{                                                                              }
{ For the PRF defined in Section 5, the Hash MUST be the Hash used as the      }
{ basis for the PRF.  Any cipher suite which defines a different PRF MUST      }
{ also define the Hash to use in the Finished computation.                     }
{ In previous versions of TLS, the verify_data was always 12 octets            }
{ long.  In the current version of TLS, it depends on the cipher suite.        }
{ Any cipher suite which does not explicitly specify verify_data_length has a  }
{ verify_data_length equal to 12.  This includes all existing cipher suites.   }
{ All of the data from all messages in this handshake (not                     }
{ including any HelloRequest messages) up to, but not including,               }
{ this message.  This is only data visible at the handshake layer              }
{ and does not include record layer headers.  This is the                      }
{ concatenation of all the Handshake structures as defined in                  }
{ Section 7.4, exchanged thus far.                                             }
{                                                                              }
procedure CalcSSLVerifyData(
          const MasterSecret: RawByteString;
          const HandshakeData: RawByteString;
          const SenderIsClient: Boolean;
          var md5_hash: TSSLFinishedMD5Hash;
          var sha_hash: TSSLFinishedSHAHash);
var M, S, T : RawByteString;
begin
  if SenderIsClient then
    T := #$43#$4C#$4E#$54
  else
    T := #$53#$52#$56#$52;
  M := MD5DigestToStrA(
           CalcMD5(MasterSecret + DupCharB(#$5C, 48) +
               MD5DigestToStrA(
                   CalcMD5(HandshakeData + T + MasterSecret + DupCharB(#$36, 48)))));
  S := SHA1DigestToStrA(
           CalcSHA1(MasterSecret + DupCharB(#$5C, 40) +
               SHA1DigestToStrA(
                   CalcSHA1(HandshakeData + T + MasterSecret + DupCharB(#$36, 40)))));
  Move(M[1], md5_hash, 16);
  Move(S[1], sha_hash, 20);
end;

const
  client_finished_label = 'client finished';
  server_finished_label = 'server finished';

function CalcTLSVerifyData(
         const ProtocolVersion: TTLSProtocolVersion;
         const MasterSecret: RawByteString;
         const HandshakeData: RawByteString): RawByteString;
var VDL : Integer;
    D1 : T128BitDigest;
    D2 : T160BitDigest;
    D3 : T256BitDigest;
    Seed : RawByteString;
    PRF : RawByteString;
begin
  if IsTLS12OrLater(ProtocolVersion) then
    begin
      VDL := 12;
      D3 := CalcSHA256(HandshakeData[1], Length(HandshakeData));
      SetLength(Seed, SizeOf(D3));
      Move(D3, Seed[1], SizeOf(D3));
      PRF := tls12PRF_SHA256(MasterSecret, client_finished_label, Seed, VDL);
    end else
  if IsTLS10OrLater(ProtocolVersion) then
    begin
      VDL := 12;
      D1 := CalcMD5(HandshakeData);
      D2 := CalcSHA1(HandshakeData);
      SetLength(Seed, SizeOf(D1) + SizeOf(D2));
      Move(D1, Seed[1], SizeOf(D1));
      Move(D2, Seed[SizeOf(D1) + 1], SizeOf(D2));
      PRF := tls10PRF(MasterSecret, client_finished_label, Seed, VDL);
    end
  else
    raise ETLSError.Create(TLSError_InvalidParameter);
  Result := PRF;
end;

function EncodeTLSHandshakeFinished(var Buffer; const Size: Integer;
         const MasterSecret: RawByteString;
         const ProtocolVersion: TTLSProtocolVersion;
         const HandshakeData: RawByteString;
         const SenderIsClient: Boolean): Integer;
var N : Integer;
    P : PByte;
    V : RawByteString;
    F : PSSLFinished;
begin
  P := TLSHandshakeDataPtr(Buffer, Size, N);
  if IsTLS10OrLater(ProtocolVersion) then
    begin
      V := CalcTLSVerifyData(ProtocolVersion, MasterSecret, HandshakeData);
      Assert(Length(V) >= 12);
      Move(V[1], PTLSFinished(P)^.verify_data[0], 12);
      Result := EncodeTLSHandshake(Buffer, Size, tlshtFinished, TLSFinishedSize);
    end else
  if IsSSL3(ProtocolVersion) then
    begin
      F := PSSLFinished(P);
      CalcSSLVerifyData(MasterSecret, HandshakeData, SenderIsClient, F^.md5_hash, F^.sha_hash);
      Result := EncodeTLSHandshake(Buffer, Size, tlshtFinished, SSLFinishedSize);
    end
  else
    raise ETLSError.Create(TLSError_InvalidParameter);
end;



{                                                                              }
{ ChangeCipherSpec Protocol                                                    }
{                                                                              }
procedure InitTLSChangeCipherSpec(var ChangeCipherSpec: TTLSChangeCipherSpec);
begin
  ChangeCipherSpec._type := spectype_change_cipher_spec;
end;



{                                                                              }
{ Unit test                                                                    }
{                                                                              }
{$IFDEF TLS_TEST}
{$ASSERTIONS ON}
procedure Test;
begin
  Assert(TLSHandshakeHeaderSize = 4);
end;
{$ENDIF}



end.

