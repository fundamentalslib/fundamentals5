{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals TLS                                         }
{   File name:        flcTLSTests.pas                                          }
{   File version:     5.04                                                     }
{   Description:      TLS tests                                                }
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
{   2008/01/18  0.01  Initial version.                                         }
{   2010/12/15  0.02  Client/Server test case.                                 ]
{   2010/12/17  0.03  Client/Server test cases for TLS 1.0, 1.1 and 1.2.       }
{   2018/07/17  5.04  Revised for Fundamentals 5.                              }
{                                                                              }
{ References:                                                                  }
{                                                                              }
{   SSL 3 - www.mozilla.org/projects/security/pki/nss/ssl/draft302.txt         }
{   RFC 2246 - The TLS Protocol Version 1.0                                    }
{   RFC 4346 - The TLS Protocol Version 1.1                                    }
{   RFC 5246 - The TLS Protocol Version 1.2                                    }
{   RFC 4366 - Transport Layer Security (TLS) Extensions                       }
{   www.mozilla.org/projects/security/pki/nss/ssl/traces/trc-clnt-ex.html      }
{                                                                              }
{ Todo:                                                                        }
{ - Test compression.                                                          }
{******************************************************************************}

{$INCLUDE flcTLS.inc}

{$DEFINE TLS_TEST_LOG_TO_CONSOLE}

unit flcTLSTests;

interface



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF TLS_TEST}
procedure Test;
{$ENDIF}



implementation

uses
  SysUtils,
  SyncObjs,
  { Utils }
  flcUtils,
  flcBase64,
  flcStrings,
  flcX509Certificate,
  { TLS }
  flcTLSUtils,
  flcTLSRecord,
  flcTLSAlert,
  flcTLSHandshake,
  flcTLSCipher,
  flcTLSConnection,
  flcTLSClient,
  flcTLSServer;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF TLS_TEST}
type
  TTLSClientServerTester = class
    Lock : TCriticalSection;
    Sr : TTLSServer;
    Cl : TTLSClient;
    SCl : TTLSServerClient;
    constructor Create;
    destructor Destroy; override;
    procedure ServerTLSendProc(Server: TTLSServer; Client: TTLSServerClient; const Buffer; const Size: Integer);
    procedure ClientTLSendProc(const Sender: TTLSConnection; const Buffer; const Size: Integer);
    procedure Log(Msg: String);
    procedure ClientLog(Sender: TTLSConnection; LogType: TTLSLogType; LogMsg: String; LogLevel: Integer);
    procedure ServerLog(Sender: TTLSServer; LogType: TTLSLogType; LogMsg: String; LogLevel: Integer);
  end;

constructor TTLSClientServerTester.Create;
begin
  inherited Create;
  Lock := TCriticalSection.Create;
  Sr := TTLSServer.Create(ServerTLSendProc);
  Sr.OnLog := ServerLog;
  Cl := TTLSClient.Create(ClientTLSendProc);
  Cl.OnLog := ClientLog;
end;

destructor TTLSClientServerTester.Destroy;
begin
  FreeAndNil(Cl);
  FreeAndNil(Sr);
  FreeAndNil(Lock);
  inherited Destroy;
end;

procedure TTLSClientServerTester.ServerTLSendProc(Server: TTLSServer; Client: TTLSServerClient; const Buffer; const Size: Integer);
begin
  Assert(Assigned(Cl));
  Cl.ProcessTransportLayerReceivedData(Buffer, Size);
end;

procedure TTLSClientServerTester.ClientTLSendProc(const Sender: TTLSConnection; const Buffer; const Size: Integer);
begin
  Assert(Assigned(SCl));
  SCl.ProcessTransportLayerReceivedData(Buffer, Size);
end;

{$IFDEF TLS_TEST_LOG_TO_CONSOLE}
procedure TTLSClientServerTester.Log(Msg: String);
var S : String;
begin
  S := FormatDateTime('hh:nn:ss.zzz', Now) + ' ' + Msg;
  Lock.Acquire;
  try
    Writeln(S);
  finally
    Lock.Release;
  end;
end;
{$ELSE}
procedure TTLSClientServerTester.Log(Msg: String);
begin
end;
{$ENDIF}

procedure TTLSClientServerTester.ClientLog(Sender: TTLSConnection; LogType: TTLSLogType; LogMsg: String; LogLevel: Integer);
begin
  Log(IntToStr(LogLevel) + ' C:' + LogMsg);
end;

procedure TTLSClientServerTester.ServerLog(Sender: TTLSServer; LogType: TTLSLogType; LogMsg: String; LogLevel: Integer);
begin
  Log(IntToStr(LogLevel) + ' S:' + LogMsg);
end;

procedure SelfTestClientServer(const ClientOptions: TTLSClientOptions);
const
  LargeBlockSize = TLS_PLAINTEXT_FRAGMENT_MAXSIZE * 8;
var CS : TTLSClientServerTester;
    CtL : TTLSCertificateList;
    S : RawByteString;
    I, L : Integer;
begin
  CS := TTLSClientServerTester.Create;
  try
    // initialise client
    CS.Cl.ClientOptions := ClientOptions;
    // initialise server
    CS.Sr.PrivateKeyRSAPEM := // from stunnel pem file
      'MIICXAIBAAKBgQCxUFMuqJJbI9KnB8VtwSbcvwNOltWBtWyaSmp7yEnqwWel5TFf' +
      'cOObCuLZ69sFi1ELi5C91qRaDMow7k5Gj05DZtLDFfICD0W1S+n2Kql2o8f2RSvZ' +
      'qD2W9l8i59XbCz1oS4l9S09L+3RTZV9oer/Unby/QmicFLNM0WgrVNiKywIDAQAB' +
      'AoGAKX4KeRipZvpzCPMgmBZi6bUpKPLS849o4pIXaO/tnCm1/3QqoZLhMB7UBvrS' +
      'PfHj/Tejn0jjHM9xYRHi71AJmAgzI+gcN1XQpHiW6kATNDz1r3yftpjwvLhuOcp9' +
      'tAOblojtImV8KrAlVH/21rTYQI+Q0m9qnWKKCoUsX9Yu8UECQQDlbHL38rqBvIMk' +
      'zK2wWJAbRvVf4Fs47qUSef9pOo+p7jrrtaTqd99irNbVRe8EWKbSnAod/B04d+cQ' +
      'ci8W+nVtAkEAxdqPOnCISW4MeS+qHSVtaGv2kwvfxqfsQw+zkwwHYqa+ueg4wHtG' +
      '/9+UgxcXyCXrj0ciYCqURkYhQoPbWP82FwJAWWkjgTgqsYcLQRs3kaNiPg8wb7Yb' +
      'NxviX0oGXTdCaAJ9GgGHjQ08lNMxQprnpLT8BtZjJv5rUOeBuKoXagggHQJAaUAF' +
      '91GLvnwzWHg5p32UgPsF1V14siX8MgR1Q6EfgKQxS5Y0Mnih4VXfnAi51vgNIk/2' +
      'AnBEJkoCQW8BTYueCwJBALvz2JkaUfCJc18E7jCP7qLY4+6qqsq+wr0t18+ogOM9' +
      'JIY9r6e1qwNxQ/j1Mud6gn6cRrObpRtEad5z2FtcnwY=';
    TLSCertificateListAppend(CtL,
      MIMEBase64Decode( // from stunnel pem file
        'MIICDzCCAXigAwIBAgIBADANBgkqhkiG9w0BAQQFADBCMQswCQYDVQQGEwJQTDEf' +
        'MB0GA1UEChMWU3R1bm5lbCBEZXZlbG9wZXJzIEx0ZDESMBAGA1UEAxMJbG9jYWxo' +
        'b3N0MB4XDTk5MDQwODE1MDkwOFoXDTAwMDQwNzE1MDkwOFowQjELMAkGA1UEBhMC' +
        'UEwxHzAdBgNVBAoTFlN0dW5uZWwgRGV2ZWxvcGVycyBMdGQxEjAQBgNVBAMTCWxv' +
        'Y2FsaG9zdDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAsVBTLqiSWyPSpwfF' +
        'bcEm3L8DTpbVgbVsmkpqe8hJ6sFnpeUxX3Djmwri2evbBYtRC4uQvdakWgzKMO5O' +
        'Ro9OQ2bSwxXyAg9FtUvp9iqpdqPH9kUr2ag9lvZfIufV2ws9aEuJfUtPS/t0U2Vf' +
        'aHq/1J28v0JonBSzTNFoK1TYissCAwEAAaMVMBMwEQYJYIZIAYb4QgEBBAQDAgZA' +
        'MA0GCSqGSIb3DQEBBAUAA4GBAAhYFTngWc3tuMjVFhS4HbfFF/vlOgTu44/rv2F+' +
        'ya1mEB93htfNxx3ofRxcjCdorqONZFwEba6xZ8/UujYfVmIGCBy4X8+aXd83TJ9A' +
        'eSjTzV9UayOoGtmg8Dv2aj/5iabNeK1Qf35ouvlcTezVZt2ZeJRhqUHcGaE+apCN' +
        'TC9Y'));
    CS.Sr.CertificateList := CtL;
    CS.Sr.DHKeySize := 256;
    // start server
    CS.Sr.Start;
    Assert(CS.Sr.State = tlssActive);
    // start connection
    CS.SCl := CS.Sr.AddClient(nil);
    CS.SCl.Start;
    CS.Cl.Start;
    // negotiated
    Assert(CS.Cl.IsReadyState);
    Assert(CS.SCl.IsReadyState);
    // application data (small block)
    S := 'Fundamentals';
    CS.Cl.Write(S[1], Length(S));
    Assert(CS.SCl.AvailableToRead = 12);
    S := '1234567890';
    Assert(CS.SCl.Read(S[1], 3) = 3);
    Assert(CS.SCl.AvailableToRead = 9);
    Assert(S = 'Fun4567890');
    Assert(CS.SCl.Read(S[1], 9) = 9);
    Assert(CS.SCl.AvailableToRead = 0);
    Assert(S = 'damentals0');
    S := 'Fundamentals';
    CS.SCl.Write(S[1], Length(S));
    Assert(CS.Cl.AvailableToRead = 12);
    S := '123456789012';
    Assert(CS.Cl.Read(S[1], 12) = 12);
    Assert(CS.Cl.AvailableToRead = 0);
    Assert(S = 'Fundamentals');
    // application data (large blocks)
    for L := LargeBlockSize - 1 to LargeBlockSize + 1 do
      begin
        SetLength(S, L);
        FillChar(S[1], L, #1);
        CS.Cl.Write(S[1], L);
        Assert(CS.SCl.AvailableToRead = L);
        FillChar(S[1], L, #0);
        CS.SCl.Read(S[1], L);
        for I := 1 to L do
          Assert(S[I] = #1);
        Assert(CS.SCl.AvailableToRead = 0);
        CS.SCl.Write(S[1], L);
        Assert(CS.Cl.AvailableToRead = L);
        FillChar(S[1], L, #0);
        Assert(CS.Cl.Read(S[1], L) = L);
        for I := 1 to L do
          Assert(S[I] = #1);
        Assert(CS.Cl.AvailableToRead = 0);
      end;
    // close
    CS.Cl.Close;
    Assert(CS.Cl.IsFinishedState);
    Assert(CS.SCl.IsFinishedState);
    // stop
    CS.Sr.RemoveClient(CS.SCl);
    CS.Sr.Stop;
  finally
    FreeAndNil(CS);
  end;
end;

procedure Test;
begin
  flcTLSUtils.Test;
  flcTLSRecord.Test;
  flcTLSHandshake.Test;
  flcTLSCipher.Test;

  // TLS version tests
  // TLS 1.2
  SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11]);
  // TLS 1.1
  SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS12]);
  // TLS 1.0
  SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS11, tlscoDisableTLS12]);
  // SSL 3
  // Fails with invalid parameter
  // SelfTestClientServer([tlscoDisableTLS10, tlscoDisableTLS11, tlscoDisableTLS12]);

  // TLS cipher tests
  // TLS 1.2 RC4_128
  SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11,
      tlscoDisableCipherAES128, tlscoDisableCipherAES256, tlscoDisableCipherDES]);
  // TLS 1.2 AES128
  SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11,
      tlscoDisableCipherAES256, tlscoDisableCipherRC4_128, tlscoDisableCipherDES]);
  // TLS 1.2 AES256
  SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11,
      tlscoDisableCipherAES128, tlscoDisableCipherRC4_128, tlscoDisableCipherDES]);
  // TLS 1.2 DES
  SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11,
      tlscoDisableCipherAES128, tlscoDisableCipherAES256, tlscoDisableCipherRC4_128]);

  // TLS hash tests
  // TLS 1.2 SHA256
  SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11,
      tlscoDisableHashMD5, tlscoDisableHashSHA1]);
  // TLS 1.2 SHA1
  SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11,
      tlscoDisableHashMD5, tlscoDisableHashSHA256]);
  // TLS 1.2 MD5
  SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11,
      tlscoDisableHashSHA1, tlscoDisableHashSHA256]);

  // TLS key exchange tests
  // TLS 1.2 RSA
  SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11,
       tlscoDisableKeyExchangeDH_Anon, tlscoDisableKeyExchangeDH_RSA]);
  // TLS 1.2 DH_RSA
  // Not implemented
  // SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11,
  //     tlscoDisableKeyExchangeDH_Anon, tlscoDisableKeyExchangeRSA]);
  // TLS 1.2 DH_anon
  // Under development/testing
  // SelfTestClientServer([tlscoDisableSSL3, tlscoDisableTLS10, tlscoDisableTLS11,
  //    tlscoDisableKeyExchangeDH_RSA, tlscoDisableKeyExchangeRSA]);
end;
{$ENDIF}

//    tlscsRSA_WITH_RC4_128_MD5,                                                // TESTED OK
//    tlscsRSA_WITH_RC4_128_SHA,                                                // TESTED OK
//    tlscsRSA_WITH_DES_CBC_SHA,                                                // TESTED OK
//    tlscsRSA_WITH_AES_128_CBC_SHA,                                            // TESTED OK
//    tlscsRSA_WITH_AES_256_CBC_SHA,                                            // TESTED OK
//    tlscsRSA_WITH_AES_128_CBC_SHA256,                                         // TESTED OK, TLS 1.2 only
//    tlscsRSA_WITH_AES_256_CBC_SHA256                                          // TESTED OK, TLS 1.2 only
//    tlscsNULL_WITH_NULL_NULL                                                  // UNTESTED
//    tlscsRSA_WITH_NULL_MD5                                                    // UNTESTED
//    tlscsRSA_WITH_NULL_SHA                                                    // UNTESTED
//    tlscsRSA_WITH_IDEA_CBC_SHA                                                // UNTESTED
//    tlscsRSA_WITH_3DES_EDE_CBC_SHA                                            // ERROR: SERVER DECRYPTION FAILED
//    tlscsRSA_WITH_NULL_SHA256                                                 // ERROR



end.

