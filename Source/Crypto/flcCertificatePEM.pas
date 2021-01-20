{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcCertificatePEM.pas                                    }
{   File version:     5.03                                                     }
{   Description:      PEM parsing                                              }
{                                                                              }
{   Copyright:        Copyright (c) 2010-2021, David J Butler                  }
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
{                                                                              {
{ Description:                                                                 }
{                                                                              }
{   Privacy Enhanced Mail (PEM) is a Base64 encoded DER certificate.           }
{                                                                              }
{ Revision history:                                                            }
{                                                                              }
{   2011/10/18  0.01  Initial development.                                     }
{   2016/01/10  0.02  String changes.                                          }
{   2018/07/17  5.03  Revised for Fundamentals 5.                              }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}
{$INCLUDE flcCrypto.inc}

unit flcCertificatePEM;

interface

uses
  { System }

  SysUtils,

  { Fundamentals }

  flcStdTypes;



{ TPEMFile }

type
  TPEMFile = class
  private
    FCertificates  : array of RawByteString;
    FRSAPrivateKey : RawByteString;

    procedure Clear;
    procedure AddCertificate(const CertificatePEM: RawByteString);
    procedure SetRSAPrivateKey(const RSAPrivateKeyPEM: RawByteString);
    procedure ParsePEMContent(const Content: RawByteString);

    function  GetCertificateCount: Integer;
    function  GetCertificate(const Idx: Integer): RawByteString;

  public
    procedure LoadFromText(const Txt: RawByteString);
    procedure LoadFromFile(const FileName: String);

    property  CertificateCount: Integer read GetCertificateCount;
    property  Certificate[const Idx: Integer]: RawByteString read GetCertificate;
    property  RSAPrivateKey: RawByteString read FRSAPrivateKey;
  end;

  EPEMFile = class(Exception);



implementation

uses
  { System }

  Classes,

  { Fundamentals }

  flcStrings,
  flcBase64;



{ TPEMFile }

procedure TPEMFile.Clear;
begin
  FCertificates := nil;
  FRSAPrivateKey := '';
end;

procedure TPEMFile.AddCertificate(const CertificatePEM: RawByteString);
var
  L : Integer;
  C : RawByteString;
begin
  C := MIMEBase64Decode(CertificatePEM);
  L := Length(FCertificates);
  SetLength(FCertificates, L + 1);
  FCertificates[L] := C;
end;

procedure TPEMFile.SetRSAPrivateKey(const RSAPrivateKeyPEM: RawByteString);
begin
  FRSAPrivateKey := MIMEBase64Decode(RSAPrivateKeyPEM);
end;

procedure TPEMFile.ParsePEMContent(const Content: RawByteString);
var
  S : RawByteString;

  function GetTextBetween(const Start, Stop: RawByteString; var Between: RawByteString): Boolean;
  var I, J : Integer;
  begin
    I := PosStrB(Start, S, 1, False);
    if I > 0 then
      begin
        J := PosStrB(Stop, S, 1, False);
        if J = 0 then
          J := Length(S) + 1;
        Between := CopyRangeB(S, I + Length(Start), J - 1);
        Delete(S, I, J + Length(Stop) - I);
        Between := StrRemoveCharSetB(Between, [#0..#32]);
        Result := True;
      end
    else
      Result := False;
  end;

var
  Found : Boolean;
  Cert : RawByteString;
  RSAPriv : RawByteString;

begin
  S := Content;
  repeat
    Found := GetTextBetween('-----BEGIN CERTIFICATE-----', '-----END CERTIFICATE-----', Cert);
    if Found then
      AddCertificate(Cert);
  until not Found;
  Found := GetTextBetween('-----BEGIN RSA PRIVATE KEY-----', '-----END RSA PRIVATE KEY-----', RSAPriv);
  if Found then
    SetRSAPrivateKey(RSAPriv);
end;

procedure TPEMFile.LoadFromText(const Txt: RawByteString);
begin
  Clear;
  ParsePEMContent(Txt);
end;

procedure TPEMFile.LoadFromFile(const FileName: String);
var
  F : TFileStream;
  B : RawByteString;
  L : Int64;
  N : Integer;
begin
  try
    F := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      L := F.Size;
      if L > 16 * 1024 * 1024 then
        raise EPEMFile.Create('File too large');
      N := L;
      if N = 0 then
        B := ''
      else
        begin
          SetLength(B, N);
          F.ReadBuffer(B[1], N);
        end;
    finally
      F.Free;
    end;
  except
    on E : Exception do
      raise EPEMFile.CreateFmt('Error loading PEM file: %s: %s', [E.ClassName, E.Message]);
  end;
  LoadFromText(B);
end;

function TPEMFile.GetCertificateCount: Integer;
begin
  Result := Length(FCertificates);
end;

function TPEMFile.GetCertificate(const Idx: Integer): RawByteString;
begin
  Result := FCertificates[Idx];
end;



end.

