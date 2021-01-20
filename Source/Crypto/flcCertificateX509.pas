{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcCertificateX509.pas                                   }
{   File version:     5.07                                                     }
{   Description:      X.509 certificate                                        }
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
{                                                                              }
{ References:                                                                  }
{                                                                              }
{   RFC 2459 Internet X.509 Public Key Infrastructure - Jan 1999               }
{   RFC 3280 Internet X.509 Public Key Infrastructure - Apr 2002               }
{   RFC 5280 Internet X.509 Public Key Infrastructure - May 2008               }
{                                                                              }
{ Revision history:                                                            }
{                                                                              }
{   2010/11/21  0.01  Initial development: Encoding                            }
{   2010/11/23  0.02  Initial development: Decoding                            }
{   2010/11/24  0.03  Test case: Example D.1 from RFC 2459                     }
{   2010/12/15  0.04  RSAPrivateKey structure                                  }
{   2015/03/31  4.05  Revision for Fundamentals 4                              }
{   2018/07/17  5.06  Revised for Fundamentals 5                               }
{   2019/09/24  5.07  Compilable with FreePascal 3.04                          }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}
{$INCLUDE flcCrypto.inc}

unit flcCertificateX509;

interface

uses
  { System }

  SysUtils,

  { Fundamentals }

  flcStdTypes,
  flcEncodingASN1;



{                                                                              }
{ X.509 errors                                                                 }
{                                                                              }
type
  EX509 = class(Exception);



{                                                                              }
{ X.509 structures                                                             }
{                                                                              }

{ Name }

type
  TX509AttributeType = TASN1ObjectIdentifier;
  TX509AttributeValue = RawByteString;
  TX509AttributeTypeAndValue = record
     AType : TX509AttributeType;
     Value : TX509AttributeValue;
     _Decoded : Boolean;
  end;
  PX509AttributeTypeAndValue = ^TX509AttributeTypeAndValue;

const
  OID_X509At                      : array[0..2] of Integer = (2, 5, 4);
  OID_X509At_Name                 : array[0..3] of Integer = (2, 5, 4, 41);
  OID_X509At_Surname              : array[0..3] of Integer = (2, 5, 4, 4);
  OID_X509At_GivenName            : array[0..3] of Integer = (2, 5, 4, 42);
  OID_X509At_Initials             : array[0..3] of Integer = (2, 5, 4, 43);
  OID_X509At_GenerationQualifier  : array[0..3] of Integer = (2, 5, 4, 41);
  OID_X509At_CommonName           : array[0..3] of Integer = (2, 5, 4, 3);
  OID_X509At_LocalityName         : array[0..3] of Integer = (2, 5, 4, 7);
  OID_X509At_StateOrProvince      : array[0..3] of Integer = (2, 5, 4, 8);
  OID_X509At_OrganizationName     : array[0..3] of Integer = (2, 5, 4, 10);
  OID_X509At_OrganizationUnitName : array[0..3] of Integer = (2, 5, 4, 11);
  OID_X509At_Title                : array[0..3] of Integer = (2, 5, 4, 12);
  OID_X509At_DnQualifier          : array[0..3] of Integer = (2, 5, 4, 46);
  OID_X509At_CountryName          : array[0..3] of Integer = (2, 5, 4, 6);
  OID_X509At_SerialNumber         : array[0..3] of Integer = (2, 5, 4, 5);
  OID_X509At_Pseudonym            : array[0..3] of Integer = (2, 5, 4, 65);
  OID_PKCS9                       : array[0..5] of Integer = (1, 2, 840,  113549,   1,   9);
  OID_PKCS9_EmailAddress          : array[0..6] of Integer = (1, 2, 840,  113549,   1,   9, 1);
  OID_AtDomainComponent           : array[0..6] of Integer = (0, 9, 2342, 19200300, 100, 1, 25);

procedure InitX509AttributeTypeAndValue(var A: TX509AttributeTypeAndValue; const AType: TX509AttributeType; const Value: TX509AttributeValue);
procedure InitX509AtName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtSurname(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtGivenName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtInitials(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtGenerationQuailifier(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtCommonName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtLocailityName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtStateOrProvince(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtOriganizationName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtOriganizationUnitName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtTitle(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtDnQualifier(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtCountryName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
procedure InitX509AtEmailAddress(var A: TX509AttributeTypeAndValue; const B: RawByteString);

function  EncodeX509AttributeTypeAndValue(const A: TX509AttributeTypeAndValue): RawByteString;
function  DecodeX509AttributeTypeAndValue(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509AttributeTypeAndValue): Integer;

type
  TX509RelativeDistinguishedName = array of TX509AttributeTypeAndValue;
  PX509RelativeDistinguishedName = ^TX509RelativeDistinguishedName;

procedure AppendX509RelativeDistinguishedName(var A: TX509RelativeDistinguishedName; const V: TX509AttributeTypeAndValue);
function  EncodeX509RelativeDistinguishedName(const A: TX509RelativeDistinguishedName): RawByteString;
function  DecodeX509RelativeDistinguishedName(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509RelativeDistinguishedName): Integer;

type
  TX509RDNSequence = array of TX509RelativeDistinguishedName;
  PX509RDNSequence = ^TX509RDNSequence;

  TX509Name = TX509RDNSequence;

procedure AppendX509RDNSequence(var A: TX509RDNSequence; const B: TX509RelativeDistinguishedName);
function  EncodeX509RDNSequence(const A: TX509RDNSequence): RawByteString;
function  DecodeX509RDNSequence(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509RDNSequence): Integer;

function  EncodeX509Name(const A: TX509Name): RawByteString;
function  DecodeX509Name(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Name): Integer;



{ Version }

type
  TX509Version = (
      X509v1 = 0,
      X509v2 = 1,
      X509v3 = 2,
      X509vUndefined = $FF // implementation defined value
  );

const
  CurrentX509Version = X509v3;

procedure InitX509Version(var A: TX509Version);
function  EncodeX509Version(const A: TX509Version): RawByteString;
function  DecodeX509Version(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Version): Integer;



{ Time }

type
  TX509Time = TDateTime;

function EncodeX509Time(const A: TX509Time): RawByteString;
function DecodeX509Time(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Time): Integer;



{ Validity }

type
  TX509Validity = record
    NotBefore : TX509Time;
    NotAfter  : TX509Time;
    _Decoded  : Boolean;
  end;
  PX509Validity = ^TX509Validity;

function EncodeX509Validity(const A: TX509Validity): RawByteString;
function DecodeX509Validity(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Validity): Integer;



{ Diffie-Hellman DomainParameters }

type
  TX509DHValidationParms = record
    Seed        : RawByteString;
    PgenCounter : Integer;
  end;
  PX509DHValidationParms = ^TX509DHValidationParms;
  TX509DHDomainParameters = record
    P : RawByteString;
    G : RawByteString;
    Q : RawByteString;
    J : RawByteString;
    ValidationParms : TX509DHValidationParms;
  end;
  PX509DHDomainParameters = ^TX509DHDomainParameters;

function EncodeX509DHValidationParms(const A: TX509DHValidationParms): RawByteString;
function DecodeX509DHValidationParms(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509DHValidationParms): Integer;

function EncodeX509DHDomainParameters(const A: TX509DHDomainParameters): RawByteString;
function DecodeX509DHDomainParameters(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509DHDomainParameters): Integer;



{ DSS Parms }

type
  TX509DSSParms = record
    P : RawByteString;
    Q : RawByteString;
    G : RawByteString;
  end;
  PX509DSSParms = ^TX509DSSParms;

function EncodeX509DSSParms(const A: TX509DSSParms): RawByteString;
function DecodeX509DSSParms(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509DSSParms): Integer;



{ DSS Sig Value }

type
  TX509DSSSigValue = record
    R : RawByteString;
    S : RawByteString;
  end;
  PX509DSSSigValue = ^TX509DSSSigValue;

function EncodeX509DSSSigValue(const A: TX509DSSSigValue): RawByteString;
function DecodeX509DSSSigValue(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509DSSSigValue): Integer;



{ AlgorithmIdentifier }

type
  TX509AlgorithmIdentifier = record
    Algorithm  : TASN1ObjectIdentifier;
    Parameters : RawByteString;
    _Decoded   : Boolean;
  end;
  PX509AlgorithmIdentifier = ^TX509AlgorithmIdentifier;

procedure InitX509AlgorithmIdentifier(var A: TX509AlgorithmIdentifier; const Algorithm: array of Integer; const Parameters: RawByteString);
procedure InitX509AlgorithmIdentifierDSA_SHA1(var A: TX509AlgorithmIdentifier; const Parameters: RawByteString);
function  EncodeX509AlgorithmIdentifier(const A: TX509AlgorithmIdentifier): RawByteString;
function  DecodeX509AlgorithmIdentifier(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509AlgorithmIdentifier): Integer;



{ PublicKeyInfo }

type
  TX509RSAPublicKey = record
    Modulus        : RawByteString;
    PublicExponent : RawByteString;
  end;
  PX509RSAPublicKey = ^TX509RSAPublicKey;

function EncodeX509RSAPublicKey(const A: TX509RSAPublicKey): RawByteString;
function DecodeX509RSAPublicKey(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509RSAPublicKey): Integer;
function ParseX509RSAPublicKey(const Buf; const Size: Integer; var A: TX509RSAPublicKey): Integer;

type
  TX509DHPublicKey = RawByteString;

function EncodeX509DHPublicKey(const A: TX509DHPublicKey): RawByteString;

type
  TX509DSAPublicKey = RawByteString;

function EncodeX509DSAPublicKey(const A: TX509DSAPublicKey): RawByteString;

type
  TX509SubjectPublicKeyInfo = record
    Algorithm        : TX509AlgorithmIdentifier;
    SubjectPublicKey : RawByteString;
    _Decoded         : Boolean;
  end;
  PX509SubjectPublicKeyInfo = ^TX509SubjectPublicKeyInfo;

procedure InitX509SubjectPublicKeyInfoDSA(var A: TX509SubjectPublicKeyInfo; const B: TX509DSSParms; const PublicKey: RawByteString);
function  EncodeX509SubjectPublicKeyInfo(const A: TX509SubjectPublicKeyInfo): RawByteString;
function  DecodeX509SubjectPublicKeyInfo(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509SubjectPublicKeyInfo): Integer;
function  ParseX509SubjectPublicKeyInfo(const Buf; const Size: Integer; var A: TX509SubjectPublicKeyInfo): Integer;



{ GeneralName }

type
  TX509GeneralNameType = (
    gnOtherName                 = 0,
    gnRFC822Name                = 1,
    gnDNSName                   = 2,
    gnX400Address               = 3,
    gnDirectoryName             = 4,
    gnEDIPartyName              = 5,
    gnUniformResourceIdentifier = 6,
    gnIPAddress                 = 7,
    gnRegisteredID              = 8);

function EncodeX509GeneralName(const A: TX509GeneralNameType; const EncodedName: RawByteString): RawByteString;
function DecodeX509GeneralName(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509GeneralNameType; var B: RawByteString): Integer;

type
  TX509GeneralNames = array of record
    NameType : TX509GeneralNameType;
    Name     : RawByteString;
  end;
  PX509GeneralNames = ^TX509GeneralNames;

function EncodeX509GeneralNames(const A: TX509GeneralNames): RawByteString;
function DecodeX509GeneralNames(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509GeneralNames): Integer;



{ Extensions }

type
  TX509BasicConstraints = record
    CA                : Boolean;
    PathLenConstraint : RawByteString;
    _DecodedCA        : Boolean;
  end;
  PX509BasicConstraints = ^TX509BasicConstraints;

function EncodeX509BasicConstraints(const A: TX509BasicConstraints): RawByteString;
function DecodeX509BasicConstraints(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509BasicConstraints): Integer;

type
  TX509AuthorityKeyIdentifier = record
    KeyIdentifier             : RawByteString;
    AuthorityCertIssuer       : TX509GeneralNames;
    AuthorityCertSerialNumber : Int64;
  end;
  PX509AuthorityKeyIdentifier = ^TX509AuthorityKeyIdentifier;

function EncodeX509AuthorityKeyIdentifier(const A: TX509AuthorityKeyIdentifier): RawByteString;

type
  TX509SubjectKeyIdentifier = RawByteString;

type
  TX509KeyUsage = RawByteString;

type
  TX509Extension = record
    ExtnID    : TASN1ObjectIdentifier;
    Critical  : Boolean;
    ExtnValue : RawByteString;
    _DecodedCritical : Boolean;
    _Decoded         : Boolean;
  end;
  PX509Extension = ^TX509Extension;

const
  OID_CE                            : array[0..2] of Integer = (2, 5, 29);
  OID_CE_AuthorityKeyIdentifier     : array[0..3] of Integer = (2, 5, 29, 35);
  OID_CE_SubjectKeyIdentifier       : array[0..3] of Integer = (2, 5, 29, 14);
  OID_CE_KeyUsage                   : array[0..3] of Integer = (2, 5, 29, 15);
  OID_CE_PrivateKeyUsagePeriod      : array[0..3] of Integer = (2, 5, 29, 16);
  OID_CE_CertificatePolicies        : array[0..3] of Integer = (2, 5, 29, 32);
  OID_CE_PolicyMappings             : array[0..3] of Integer = (2, 5, 29, 33);
  OID_CE_SubjectAltName             : array[0..3] of Integer = (2, 5, 29, 17);
  OID_CE_IssuerAltName              : array[0..3] of Integer = (2, 5, 29, 18);
  OID_CE_SubjectDirectoryAttributes : array[0..3] of Integer = (2, 5, 29, 9);
  OID_CE_BasicConstraints           : array[0..3] of Integer = (2, 5, 29, 19);
  OID_CE_NameConstraints            : array[0..3] of Integer = (2, 5, 29, 30);
  OID_CE_PolicyConstraints          : array[0..3] of Integer = (2, 5, 29, 36);
  OID_CE_CRLDistributionPoints      : array[0..3] of Integer = (2, 5, 29, 31);

procedure InitX509ExtAuthorityKeyIdentifier(var A: TX509Extension; const B: TX509AuthorityKeyIdentifier);
procedure InitX509ExtSubjectKeyIdentifier(var A: TX509Extension; const B: TX509SubjectKeyIdentifier);
procedure InitX509ExtBasicConstraints(var A: TX509Extension; const B: TX509BasicConstraints);

function  EncodeX509Extension(const A: TX509Extension): RawByteString;
function  DecodeX509Extension(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Extension): Integer;

type
  TX509Extensions = array of TX509Extension;
  PX509Extensions = ^TX509Extensions;

procedure AppendX509Extensions(var A: TX509Extensions; const B: TX509Extension);
function  EncodeX509Extensions(const A: TX509Extensions): RawByteString;
function  DecodeX509Extensions(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Extensions): Integer;



{ Key }

function  NormaliseX509IntKeyBuf(var KeyBuf: RawByteString): Integer;



{ TBSCertificate }

type
  TX509TBSCertificate = record
    Version              : TX509Version;
    SerialNumber         : RawByteString;
    Signature            : TX509AlgorithmIdentifier;
    Issuer               : TX509Name;
    Validity             : TX509Validity;
    Subject              : TX509Name;
    SubjectPublicKeyInfo : TX509SubjectPublicKeyInfo;
    IssuerUniqueID       : RawByteString;
    SubjectUniqueID      : RawByteString;
    Extensions           : TX509Extensions;
    _DecodedVersion      : Boolean;
    _Decoded             : Boolean;
  end;
  PX509TBSCertificate = ^TX509TBSCertificate;

function EncodeX509TBSCertificate(const A: TX509TBSCertificate): RawByteString;
function DecodeX509TBSCertificate(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509TBSCertificate): Integer;



{ Certificate }

type
  TX509Certificate = record
    TBSCertificate     : TX509TBSCertificate;
    SignatureAlgorithm : TX509AlgorithmIdentifier;
    SignatureValue     : RawByteString;
    _Decoded           : Boolean;
  end;
  PX509Certificate = ^TX509Certificate;
  TX509CertificateArray = array of TX509Certificate;

procedure InitX509Certificate(var A: TX509Certificate);
function  EncodeX509Certificate(const A: TX509Certificate): RawByteString;
function  DecodeX509Certificate(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Certificate): Integer;
function  ParseX509Certificate(const Buf; const Size: Integer; var A: TX509Certificate): Integer;
procedure ParseX509CertificateStr(const BufStr: RawByteString; var A: TX509Certificate);
procedure ParseX509CertificatePEM(const BufStr: RawByteString; var A: TX509Certificate);



{ RSAPrivateKey }

type
  TX509RSAPrivateKey = record
    Version         : Integer;
    Modulus         : RawByteString;
    PublicExponent  : RawByteString;
    PrivateExponent : RawByteString;
    Prime1          : RawByteString;
    Prime2          : RawByteString;
    Exponent1       : RawByteString;
    Exponent2       : RawByteString;
    CRTCoefficient  : RawByteString;
    _Decoded        : Boolean;
  end;
  PX509RSAPrivateKey = ^TX509RSAPrivateKey;

function  EncodeX509RSAPrivateKey(const A: TX509RSAPrivateKey): RawByteString;
function  DecodeX509RSAPrivateKey(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509RSAPrivateKey): Integer;
function  ParseX509RSAPrivateKey(const Buf; const Size: Integer; var A: TX509RSAPrivateKey): Integer;
procedure ParseX509RSAPrivateKeyStr(const BufStr: RawByteString; var A: TX509RSAPrivateKey);
procedure ParseX509RSAPrivateKeyPEM(const BufStr: RawByteString; var A: TX509RSAPrivateKey);



implementation

uses
  { Fundamentals }

  flcBase64;



{                                                                              }
{ X.509 errors                                                                 }
{                                                                              }
const
  SErr_InvalidBuffer = 'Invalid buffer';
  SErr_DecodeError   = 'Decode error';
  SErr_EncodeError   = 'Encode error';



{                                                                              }
{ X.509 structures                                                             }
{                                                                              }

(*
  AttributeType ::= OBJECT IDENTIFIER
  AttributeValue ::= ANY DEFINED BY AttributeType
  AttributeTypeAndValue ::= SEQUENCE {
      type   AttributeType,
      value  AttributeValue }
*)
procedure InitX509AttributeTypeAndValue(
          var A: TX509AttributeTypeAndValue;
          const AType: TX509AttributeType; const Value: TX509AttributeValue);
begin
  A.AType := AType;
  A.Value := Value;
end;

procedure InitX509AtName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_Name);
  A.Value := B;
end;

procedure InitX509AtSurname(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_Surname);
  A.Value := B;
end;

procedure InitX509AtGivenName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_GivenName);
  A.Value := B;
end;

procedure InitX509AtInitials(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_Initials);
  A.Value := B;
end;

procedure InitX509AtGenerationQuailifier(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_GenerationQualifier);
  A.Value := B;
end;

procedure InitX509AtCommonName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_CommonName);
  A.Value := B;
end;

procedure InitX509AtLocailityName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_LocalityName);
  A.Value := B;
end;

procedure InitX509AtStateOrProvince(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_StateOrProvince);
  A.Value := B;
end;

procedure InitX509AtOriganizationName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_OrganizationName);
  A.Value := B;
end;

procedure InitX509AtOriganizationUnitName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_OrganizationUnitName);
  A.Value := B;
end;

procedure InitX509AtTitle(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_Title);
  A.Value := B;
end;

procedure InitX509AtDnQualifier(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_DnQualifier);
  A.Value := B;
end;

procedure InitX509AtCountryName(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_X509At_CountryName);
  A.Value := B;
end;

procedure InitX509AtEmailAddress(var A: TX509AttributeTypeAndValue; const B: RawByteString);
begin
  ASN1OIDInit(A.AType, OID_PKCS9_EmailAddress);
  A.Value := B;
end;

function EncodeX509AttributeTypeAndValue(const A: TX509AttributeTypeAndValue): RawByteString;
begin
  Result :=
      ASN1EncodeSequence(
          ASN1EncodeOID(A.AType) +
          ASN1EncodePrintableString(A.Value)
          );
end;

procedure X509AttributeTypeAndValueParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509AttributeTypeAndValue;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : ASN1DecodeOID(TypeID, DataBuf, DataSize, D^.AType);
    1 : ASN1DecodeString(TypeID, DataBuf, DataSize, D^.Value);
  end;
  if ObjectIdx >= 1 then
    D^._Decoded := True;
end;

function DecodeX509AttributeTypeAndValue(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509AttributeTypeAndValue): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  A._Decoded := False;
  Result := ASN1Parse(Buf, Size, X509AttributeTypeAndValueParseProc, NativeInt(@A));
  if not A._Decoded then
    raise EX509.Create(SErr_DecodeError); // incomplete structure
end;

(*
  RelativeDistinguishedName ::= SET OF AttributeTypeAndValue
*)
procedure AppendX509RelativeDistinguishedName(var A: TX509RelativeDistinguishedName; const V: TX509AttributeTypeAndValue);
var L : Integer;
begin
  L := Length(A);
  SetLength(A, L + 1);
  A[L] := V;
end;

function EncodeX509RelativeDistinguishedName(const A: TX509RelativeDistinguishedName): RawByteString;
var I : Integer;
    S : RawByteString;
begin
  S := '';
  for I := 0 to Length(A) - 1 do
    S := S + EncodeX509AttributeTypeAndValue(A[I]);
  Result := ASN1EncodeSet(S);
end;

procedure X509RelativeDistinguishedNameParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509RelativeDistinguishedName;
    L : Integer;
begin
  D := Pointer(CallerData);
  L := Length(D^);
  SetLength(D^, L + 1);
  DecodeX509AttributeTypeAndValue(TypeID, DataBuf, DataSize, D^[L]);
end;

function DecodeX509RelativeDistinguishedName(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509RelativeDistinguishedName): Integer;
begin
  Assert(TypeID = ASN1_ID_SET);
  Result := ASN1Parse(Buf, Size, X509RelativeDistinguishedNameParseProc, NativeInt(@A));
end;

(*
  Name ::= CHOICE {
      RDNSequence }
  RDNSequence ::= SEQUENCE OF RelativeDistinguishedName
*)
procedure AppendX509RDNSequence(var A: TX509RDNSequence; const B: TX509RelativeDistinguishedName);
var L : Integer;
begin
  L := Length(A);
  SetLength(A, L + 1);
  A[L] := B;
end;

function EncodeX509RDNSequence(const A: TX509RDNSequence): RawByteString;
var I : Integer;
    S : RawByteString;
begin
  S := '';
  for I := 0 to Length(A) - 1 do
    S := S + EncodeX509RelativeDistinguishedName(A[I]);
  Result := ASN1EncodeSequence(S);
end;

procedure X509RDNSequenceParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509RDNSequence;
    L : Integer;
begin
  D := Pointer(CallerData);
  L := Length(D^);
  SetLength(D^, L + 1);
  DecodeX509RelativeDistinguishedName(TypeID, DataBuf, DataSize, D^[L]);
end;

function DecodeX509RDNSequence(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509RDNSequence): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  Result := ASN1Parse(Buf, Size, X509RDNSequenceParseProc, NativeInt(@A));
end;

function EncodeX509Name(const A: TX509Name): RawByteString;
begin
  Result := EncodeX509RDNSequence(A);
end;

function DecodeX509Name(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Name): Integer;
begin
  Result := DecodeX509RDNSequence(TypeID, Buf, Size, A);
end;

(*
      Version ::= INTEGER { v1(0), v2(1), v3(2) }
*)
procedure InitX509Version(var A: TX509Version);
begin
  A := CurrentX509Version;
end;

function EncodeX509Version(const A: TX509Version): RawByteString;
begin
  Result := ASN1EncodeInteger32(Ord(A));
end;

function DecodeX509Version(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Version): Integer;
var I : Int32;
begin
  Result := ASN1DecodeInteger32(TypeID, Buf, Size, I);
  A := TX509Version(I);
end;

(*
  Time ::= CHOICE {
      utcTime      UTCTime,
      generalTime  GeneralizedTime }
   CAs conforming to this profile MUST always encode certificate
   validity dates through the year 2049 as UTCTime; certificate validity
   dates in 2050 or later MUST be encoded as GeneralizedTime.
   For the purposes of this profile, UTCTime values MUST be expressed
   Greenwich Mean Time (Zulu) and MUST include seconds (i.e., times are
   YYMMDDHHMMSSZ), even where the number of seconds is zero.  Conforming
   systems MUST interpret the year field (YY) as follows:
      Where YY is greater than or equal to 50, the year shall be
      interpreted as 19YY; and
      Where YY is less than 50, the year shall be interpreted as 20YY.
   For the purposes of this profile, GeneralizedTime values MUST be
   expressed Greenwich Mean Time (Zulu) and MUST include seconds (i.e.,
   times are YYYYMMDDHHMMSSZ), even where the number of seconds is zero.
   GeneralizedTime values MUST NOT include fractional seconds.
*)
function EncodeX509Time(const A: TX509Time): RawByteString;
var
  Y, M, D : Word;
begin
  DecodeDate(A, Y, M, D);
  if Y >= 2050 then
    Result := ASN1EncodeGeneralizedTime(A)
  else
    Result := ASN1EncodeUTCTime(A);
end;

function DecodeX509Time(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Time): Integer;
var T : TDateTime;
begin
  Result := ASN1DecodeTime(TypeID, Buf, Size, T);
  A := T;
end;

(*
  Validity ::= SEQUENCE {
      notBefore  Time,
      notAfter   Time }
*)
function EncodeX509Validity(const A: TX509Validity): RawByteString;
begin
  Result :=
      ASN1EncodeSequence(
          EncodeX509Time(A.NotBefore) +
          EncodeX509Time(A.NotAfter)
      );
end;

procedure X509ValidityParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509Validity;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : ASN1DecodeTime(TypeID, DataBuf, DataSize, D^.NotBefore);
    1 : ASN1DecodeTime(TypeID, DataBuf, DataSize, D^.NotAfter);
  end;
  if ObjectIdx >= 1 then
    D^._Decoded := True;
end;

function DecodeX509Validity(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Validity): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  A._Decoded := False;
  Result := ASN1Parse(Buf, Size, X509ValidityParseProc, NativeInt(@A));
  if not A._Decoded then
    raise EX509.Create(SErr_DecodeError); // incomplete structure
end;

(*
  Diffie-Hellman Key Exchange Key:
  ValidationParms ::= SEQUENCE {
      seed         BIT STRING,
      pgenCounter  INTEGER }
*)
function EncodeX509DHValidationParms(const A: TX509DHValidationParms): RawByteString;
begin
  Result :=
      ASN1EncodeSequence(
          ASN1EncodeBitString(A.Seed, 0) +
          ASN1EncodeInteger32(A.PgenCounter)
      );
end;

procedure X509DHValidationParmsParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509DHValidationParms;
    K : Byte;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : ASN1DecodeBitString(TypeID, DataBuf, DataSize, D^.Seed, K);
    1 : ASN1DecodeInteger32(TypeID, DataBuf, DataSize, D^.PgenCounter);
  end;
end;

function DecodeX509DHValidationParms(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509DHValidationParms): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  Result := ASN1Parse(Buf, Size, X509DHValidationParmsParseProc, NativeInt(@A));
end;

(*
  Diffie-Hellman Key Exchange Key:
  DomainParameters ::= SEQUENCE {
      p                INTEGER, -- odd prime, p=jq +1
      g                INTEGER, -- generator, g
      q                INTEGER, -- factor of p-1
      j                INTEGER OPTIONAL, -- subgroup factor
      validationParms  ValidationParms OPTIONAL }
*)
function EncodeX509DHDomainParameters(const A: TX509DHDomainParameters): RawByteString;
var S : RawByteString;
begin
  if (A.P = '') or (A.G = '') or (A.Q = '') then
    raise EX509.Create(SErr_EncodeError);
  S := ASN1EncodeIntegerBufStr(A.P) +
       ASN1EncodeIntegerBufStr(A.G) +
       ASN1EncodeIntegerBufStr(A.Q);
  if A.J <> '' then
    S := S + ASN1EncodeIntegerBufStr(A.J);
  if A.ValidationParms.Seed <> '' then
    S := S + EncodeX509DHValidationParms(A.ValidationParms);
  Result := ASN1EncodeSequence(S);
end;

procedure X509DHDomainParametersParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509DHDomainParameters;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.P);
    1 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.G);
    2 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.Q);
    3 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.J);
    4 : DecodeX509DHValidationParms(TypeID, DataBuf, DataSize, D^.ValidationParms);
  end;
end;

function DecodeX509DHDomainParameters(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509DHDomainParameters): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  Result := ASN1Parse(Buf, Size, X509DHDomainParametersParseProc, NativeInt(@A));
end;

(*
  Dss-Parms  ::=  SEQUENCE  {
      p  INTEGER,
      q  INTEGER,
      g  INTEGER  }
*)
function EncodeX509DSSParms(const A: TX509DSSParms): RawByteString;
begin
  Result := ASN1EncodeSequence(
      ASN1EncodeIntegerBufStr(A.P) +
      ASN1EncodeIntegerBufStr(A.Q) +
      ASN1EncodeIntegerBufStr(A.G)
  );
end;

procedure X509DSSParmsParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509DSSParms;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.P);
    1 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.Q);
    2 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.G);
  end;
end;

function DecodeX509DSSParms(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509DSSParms): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  Result := ASN1Parse(Buf, Size, X509DSSParmsParseProc, NativeInt(@A));
end;

(*
  Dss-Sig-Value  ::=  SEQUENCE  {
      r  INTEGER,
      s  INTEGER  }
*)
function EncodeX509DSSSigValue(const A: TX509DSSSigValue): RawByteString;
begin
  Result := ASN1EncodeSequence(
      ASN1EncodeIntegerBufStr(A.R) +
      ASN1EncodeIntegerBufStr(A.S)
  );
end;

procedure X509DSSSigValueParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509DSSSigValue;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.R);
    1 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.S);
  end;
end;

function DecodeX509DSSSigValue(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509DSSSigValue): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  Result := ASN1Parse(Buf, Size, X509DSSSigValueParseProc, NativeInt(@A));
end;

(*
  AlgorithmIdentifier ::= SEQUENCE {
      algorithm   OBJECT IDENTIFIER,
      parameters  ANY DEFINED BY algorithm OPTIONAL  }
*)
procedure InitX509AlgorithmIdentifier(var A: TX509AlgorithmIdentifier; const Algorithm: array of Integer; const Parameters: RawByteString);
begin
  ASN1OIDInit(A.Algorithm, Algorithm);
  A.Parameters := Parameters;
end;

procedure InitX509AlgorithmIdentifierDSA_SHA1(var A: TX509AlgorithmIdentifier; const Parameters: RawByteString);
begin
  InitX509AlgorithmIdentifier(A, OID_DSA_SHA1, Parameters);
end;

function EncodeX509AlgorithmIdentifier(const A: TX509AlgorithmIdentifier): RawByteString;
var S : RawByteString;
begin
  S := ASN1EncodeOID(A.Algorithm);
  if A.Parameters <> '' then
    S := S + A.Parameters;
  Result := ASN1EncodeSequence(S);
end;

procedure X509AlgorithmIdentifierParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509AlgorithmIdentifier;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : ASN1DecodeOID(TypeID, DataBuf, DataSize, D^.Algorithm);
    1 : ASN1DecodeDataRawByteString(DataBuf, DataSize, D^.Parameters);
  end;
  if ObjectIdx >= 0 then
    D^._Decoded := True;
end;

function DecodeX509AlgorithmIdentifier(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509AlgorithmIdentifier): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  A._Decoded := False;
  Result := ASN1Parse(Buf, Size, X509AlgorithmIdentifierParseProc, NativeInt(@A));
  if not A._Decoded then
    raise EX509.Create(SErr_DecodeError); // incomplete structure
end;

(*
  RSAPublicKey ::= SEQUENCE {
      modulus         INTEGER, -- n
      publicExponent  INTEGER  -- e -- }
*)
function EncodeX509RSAPublicKey(const A: TX509RSAPublicKey): RawByteString;
begin
  Result :=
      ASN1EncodeSequence(
          ASN1EncodeIntegerBufStr(A.Modulus) +
          ASN1EncodeIntegerBufStr(A.PublicExponent)
      );
end;

procedure X509RSAPublicKeyParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509RSAPublicKey;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.Modulus);
    1 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.PublicExponent);
  end;
end;

function DecodeX509RSAPublicKey(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509RSAPublicKey): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  Result := ASN1Parse(Buf, Size, X509RSAPublicKeyParseProc, NativeInt(@A));
end;

procedure X509RSAPublicKeyTopParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509RSAPublicKey;
begin
  D := Pointer(CallerData);
  DecodeX509RSAPublicKey(TypeID, DataBuf, DataSize, D^);
end;

function ParseX509RSAPublicKey(const Buf; const Size: Integer; var A: TX509RSAPublicKey): Integer;
begin
  Result := ASN1Parse(Buf, Size, X509RSAPublicKeyTopParseProc, NativeInt(@A));
end;

(*
  DHPublicKey ::= INTEGER -- public key, y = g^x mod p
*)
function EncodeX509DHPublicKey(const A: TX509DHPublicKey): RawByteString;
begin
  Result := ASN1EncodeIntegerBufStr(A);
end;

(*
  DSAPublicKey ::= INTEGER -- public key, Y
*)
function EncodeX509DSAPublicKey(const A: TX509DSAPublicKey): RawByteString;
begin
  Result := ASN1EncodeIntegerBufStr(A);
end;

(*
  SubjectPublicKeyInfo ::= SEQUENCE {
      algorithm          AlgorithmIdentifier,
      subjectPublicKey   BIT STRING }
*)
procedure InitX509SubjectPublicKeyInfoDSA(var A: TX509SubjectPublicKeyInfo; const B: TX509DSSParms; const PublicKey: RawByteString);
begin
  ASN1OIDInit(A.Algorithm.Algorithm, OID_DSA);
  A.Algorithm.Parameters := EncodeX509DSSParms(B);
  A.SubjectPublicKey := PublicKey;
end;

function EncodeX509SubjectPublicKeyInfo(const A: TX509SubjectPublicKeyInfo): RawByteString;
begin
  Result :=
      ASN1EncodeSequence(
          EncodeX509AlgorithmIdentifier(A.Algorithm) +
          ASN1EncodeBitString(A.SubjectPublicKey, 0)
      );
end;

procedure X509SubjectPublicKeyInfoParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509SubjectPublicKeyInfo;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : DecodeX509AlgorithmIdentifier(TypeID, DataBuf, DataSize, D^.Algorithm);
    1 : ASN1DecodeString(TypeID, DataBuf, DataSize, D^.SubjectPublicKey);
  end;
  if ObjectIdx >= 1 then
    D^._Decoded := True;
end;

function DecodeX509SubjectPublicKeyInfo(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509SubjectPublicKeyInfo): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  A._Decoded := False;
  Result := ASN1Parse(Buf, Size, X509SubjectPublicKeyInfoParseProc, NativeInt(@A));
  if not A._Decoded then
    raise EX509.Create(SErr_DecodeError); // incomplete structure
end;

procedure X509SubjectPublicKeyInfoTopParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509SubjectPublicKeyInfo;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : DecodeX509SubjectPublicKeyInfo(TypeID, DataBuf, DataSize, D^);
  end;
end;

function ParseX509SubjectPublicKeyInfo(const Buf; const Size: Integer; var A: TX509SubjectPublicKeyInfo): Integer;
var P : Pointer;
begin
  P := @Buf;
  if not Assigned(P) or (Size <= 0) then
    raise EX509.Create(SErr_InvalidBuffer);
  Result := ASN1Parse(Buf, Size, X509SubjectPublicKeyInfoTopParseProc, NativeInt(@A));
  if Result <> Size then
    raise EX509.Create(SErr_DecodeError); // incomplete parsing
end;

(*
  BasicConstraints ::= SEQUENCE {
      cA                 BOOLEAN DEFAULT FALSE,
      pathLenConstraint  INTEGER (0..MAX) OPTIONAL }
*)
function EncodeX509BasicConstraints(const A: TX509BasicConstraints): RawByteString;
var S : RawByteString;
begin
  S := ASN1EncodeBoolean(A.CA);
  if A.PathLenConstraint <> '' then
    S := S + ASN1EncodeIntegerBufStr(A.PathLenConstraint);
  Result := ASN1EncodeSequence(S);
end;

procedure X509BasicConstraintsParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509BasicConstraints;
begin
  D := Pointer(CallerData);
  if (ObjectIdx = 0) and (TypeID = ASN1_ID_BOOLEAN) then
    begin
      ASN1DecodeBoolean(TypeID, DataBuf, DataSize, D^.CA);
      D^._DecodedCA := True;
    end
  else
  if ((ObjectIdx = 0) and (TypeID = ASN1_ID_INTEGER)) or
     ((ObjectIdx = 1) and (TypeID = ASN1_ID_INTEGER) and D^._DecodedCA) then
    ASN1DecodeDataIntegerBuf(DataBuf, DataSize, D^.PathLenConstraint);
end;

function DecodeX509BasicConstraints(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509BasicConstraints): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  A.CA := False;
  A._DecodedCA := False;
  Result := ASN1Parse(Buf, Size, X509BasicConstraintsParseProc, NativeInt(@A));
end;

(*
  GeneralName ::= CHOICE {
      otherName                       [0]     OtherName,
      rfc822Name                      [1]     IA5String,
      dNSName                         [2]     IA5String,
      x400Address                     [3]     ORAddress,
      directoryName                   [4]     Name,
      ediPartyName                    [5]     EDIPartyName,
      uniformResourceIdentifier       [6]     IA5String,
      iPAddress                       [7]     OCTET STRING,
      registeredID                    [8]     OBJECT IDENTIFIER }
*)
function EncodeX509GeneralName(const A: TX509GeneralNameType; const EncodedName: RawByteString): RawByteString;
begin
  Result := ASN1EncodeContextSpecific(Ord(A), EncodedName);
end;

function DecodeX509GeneralName(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509GeneralNameType; var B: RawByteString): Integer;
var I : Integer;
begin
  if not ASN1TypeIsContextSpecific(TypeID, I) then
    raise EX509.Create(SErr_DecodeError);
  A := TX509GeneralNameType(I);
  Result := ASN1DecodeString(TypeID, Buf, Size, B);
end;

(*
  GeneralNames ::= SEQUENCE SIZE (1..MAX) OF GeneralName
*)
function EncodeX509GeneralNames(const A: TX509GeneralNames): RawByteString;
var I : Integer;
    S : RawByteString;
begin
  S := '';
  for I := 0 to Length(A) - 1 do
    S := S + EncodeX509GeneralName(A[I].NameType, A[I].Name);
  Result := ASN1EncodeSequence(S);
end;

procedure X509GeneralNamesParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509GeneralNames;
    L : Integer;
begin
  D := Pointer(CallerData);
  L := Length(D^);
  SetLength(D^, L + 1);
  DecodeX509GeneralName(TypeID, DataBuf, DataSize, D^[L].NameType, D^[L].Name);
end;

function DecodeX509GeneralNames(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509GeneralNames): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  Result := ASN1Parse(Buf, Size, X509GeneralNamesParseProc, NativeInt(@A));
end;

(*
  AuthorityKeyIdentifier ::= SEQUENCE {
      keyIdentifier             [0] KeyIdentifier           OPTIONAL,
      authorityCertIssuer       [1] GeneralNames            OPTIONAL,
      authorityCertSerialNumber [2] CertificateSerialNumber OPTIONAL  }
*)
function EncodeX509AuthorityKeyIdentifier(const A: TX509AuthorityKeyIdentifier): RawByteString;
var S : RawByteString;
begin
  S := '';
  if A.KeyIdentifier <> '' then
    S := S + ASN1EncodeContextSpecific(0, ASN1EncodeBitString(A.KeyIdentifier, 0));
  if Length(A.AuthorityCertIssuer) > 0 then
    S := S + ASN1EncodeContextSpecific(1, EncodeX509GeneralNames(A.AuthorityCertIssuer));
  S := S + ASN1EncodeContextSpecific(2, ASN1EncodeInteger64(A.AuthorityCertSerialNumber));
  Result := ASN1EncodeSequence(S);
end;

(*
  KeyUsage ::= BIT STRING {
      digitalSignature        (0),
      nonRepudiation          (1),
      keyEncipherment         (2),
      dataEncipherment        (3),
      keyAgreement            (4),
      keyCertSign             (5),
      cRLSign                 (6),
      encipherOnly            (7),
      decipherOnly            (8) }
*)

(*
  KeyIdentifier ::= OCTET STRING

  SubjectKeyIdentifier ::= KeyIdentifier

  PrivateKeyUsagePeriod ::= SEQUENCE {
      notBefore       [0]     GeneralizedTime OPTIONAL,
      notAfter        [1]     GeneralizedTime OPTIONAL }

  SubjectAltName ::= GeneralNames

  OtherName ::= SEQUENCE {
      type-id    OBJECT IDENTIFIER,
      value      [0] EXPLICIT ANY DEFINED BY type-id }

  EDIPartyName ::= SEQUENCE {
      nameAssigner            [0]     DirectoryString OPTIONAL,
      partyName               [1]     DirectoryString }

  IssuerAltName ::= GeneralNames

  NameConstraints ::= SEQUENCE {
      permittedSubtrees       [0]     GeneralSubtrees OPTIONAL,
      excludedSubtrees        [1]     GeneralSubtrees OPTIONAL }

  GeneralSubtrees ::= SEQUENCE SIZE (1..MAX) OF GeneralSubtree

  GeneralSubtree ::= SEQUENCE {
      base                    GeneralName,
      minimum         [0]     BaseDistance DEFAULT 0,
      maximum         [1]     BaseDistance OPTIONAL }

  BaseDistance ::= INTEGER (0..MAX)

  ExtKeyUsageSyntax ::= SEQUENCE SIZE (1..MAX) OF KeyPurposeId

  KeyPurposeId ::= OBJECT IDENTIFIER
*)

procedure InitX509ExtAuthorityKeyIdentifier(var A: TX509Extension; const B: TX509AuthorityKeyIdentifier);
begin
  ASN1OIDInit(A.ExtnID, OID_CE_AuthorityKeyIdentifier);
  A.Critical := False;
  A.ExtnValue := EncodeX509AuthorityKeyIdentifier(B);
end;

procedure InitX509ExtSubjectKeyIdentifier(var A: TX509Extension; const B: TX509SubjectKeyIdentifier);
begin
  ASN1OIDInit(A.ExtnID, OID_CE_SubjectKeyIdentifier);
  A.Critical := False;
  A.ExtnValue := B;
end;

procedure InitX509ExtBasicConstraints(var A: TX509Extension; const B: TX509BasicConstraints);
begin
  ASN1OIDInit(A.ExtnID, OID_CE_BasicConstraints);
  A.Critical := True;
  A.ExtnValue := EncodeX509BasicConstraints(B);
end;

(*
  Extension ::= SEQUENCE {
      extnID     OBJECT IDENTIFIER,
      critical   BOOLEAN DEFAULT FALSE,
      extnValue  OCTET STRING
      }
*)
function EncodeX509Extension(const A: TX509Extension): RawByteString;
var S : RawByteString;
begin
  S := ASN1EncodeOID(A.ExtnID);
  if A.Critical then
    S := S + ASN1EncodeBoolean(A.Critical);
  S := S + ASN1EncodeOctetString(A.ExtnValue);
  Result := ASN1EncodeSequence(S);
end;

procedure X509ExtensionParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509Extension;
begin
  D := Pointer(CallerData);
  if ObjectIdx = 0 then
    ASN1DecodeOID(TypeID, DataBuf, DataSize, D^.ExtnID)
  else
  if (ObjectIdx = 1) and (TypeID = ASN1_ID_BOOLEAN) then
    begin
      ASN1DecodeBoolean(TypeID, DataBuf, DataSize, D^.Critical);
      D^._DecodedCritical := True;
    end
  else
  if ((ObjectIdx = 1) and (TypeID = ASN1_ID_OCTET_STRING)) or
     ((ObjectIdx = 2) and (TypeID = ASN1_ID_OCTET_STRING) and D^._DecodedCritical) then
    begin
      ASN1DecodeString(TypeID, DataBuf, DataSize, D^.ExtnValue);
      D^._Decoded := True;
    end;
end;

function DecodeX509Extension(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Extension): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  A.Critical := False;
  A._DecodedCritical := False;
  A._Decoded := False;
  Result := ASN1Parse(Buf, Size, X509ExtensionParseProc, NativeInt(@A));
  if not A._Decoded then
    raise EX509.Create(SErr_DecodeError); // incomplete structure
end;

(*
  Extensions ::= SEQUENCE SIZE (1..MAX) OF Extension
*)
procedure AppendX509Extensions(var A: TX509Extensions; const B: TX509Extension);
var L : Integer;
begin
  L := Length(A);
  SetLength(A, L + 1);
  A[L] := B;
end;

function EncodeX509Extensions(const A: TX509Extensions): RawByteString;
var I : Integer;
    S : RawByteString;
begin
  S := '';
  for I := 0 to Length(A) - 1 do
    S := S + EncodeX509Extension(A[I]);
  Result := ASN1EncodeSequence(S);
end;

procedure X509ExtensionsParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509Extensions;
    L : Integer;
begin
  D := Pointer(CallerData);
  L := Length(D^);
  SetLength(D^, L + 1);
  DecodeX509Extension(TypeID, DataBuf, DataSize, D^[L]);
end;

function DecodeX509Extensions(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Extensions): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  Result := ASN1Parse(Buf, Size, X509ExtensionsParseProc, NativeInt(@A));
end;



{ Key }

function NormaliseX509IntKeyBuf(var KeyBuf: RawByteString): Integer;
var L : Integer;
begin
  L := Length(KeyBuf);
  // some integer key values have an extra #0 padding prefixed.
  // remove the extra character if found.
  if (L mod 8 = 1) and (KeyBuf[1] = #0) then
    begin
      Delete(KeyBuf, 1, 1);
      Dec(L);
    end;
  Result := L;
end;



(*
  TBSCertificate ::= SEQUENCE {
      version         [0]  EXPLICIT Version DEFAULT v1,
      serialNumber         CertificateSerialNumber,
      signature            AlgorithmIdentifier,
      issuer               Name,
      validity             Validity,
      subject              Name,
      subjectPublicKeyInfo SubjectPublicKeyInfo,
      issuerUniqueID  [1]  IMPLICIT UniqueIdentifier OPTIONAL,
                           -- If present, version shall be v2 or v3
      subjectUniqueID [2]  IMPLICIT UniqueIdentifier OPTIONAL,
                           -- If present, version shall be v2 or v3
      extensions      [3]  EXPLICIT Extensions OPTIONAL
                           -- If present, version shall be v3
      }
  CertificateSerialNumber ::= INTEGER
  Certificate users MUST be able to handle serialNumber values up to 20 octets.
  UniqueIdentifier ::= BIT STRING
*)
function EncodeX509TBSCertificate(const A: TX509TBSCertificate): RawByteString;
var S : RawByteString;
begin
  if A.Version = X509vUndefined then
    raise EX509.Create(SErr_EncodeError); // version not defined
  if A.SerialNumber = '' then
    raise EX509.Create(SErr_EncodeError); // serial number not defined
  S := '';
  if A.Version <> X509v1 then
    S := S + ASN1EncodeContextSpecific(0, EncodeX509Version(A.Version));
  S := S +
      ASN1EncodeIntegerBufStr(A.SerialNumber) +
      EncodeX509AlgorithmIdentifier(A.Signature) +
      EncodeX509Name(A.Issuer) +
      EncodeX509Validity(A.Validity) +
      EncodeX509Name(A.Subject) +
      EncodeX509SubjectPublicKeyInfo(A.SubjectPublicKeyInfo);
  if A.IssuerUniqueID <> '' then
    S := S +
        ASN1EncodeContextSpecific(1, ASN1EncodeBitString(A.IssuerUniqueID, 0));
  if A.SubjectUniqueID <> '' then
    S := S +
        ASN1EncodeContextSpecific(2, ASN1EncodeBitString(A.SubjectUniqueID, 0));
  if Length(A.Extensions) > 0 then
    S := S +
        ASN1EncodeContextSpecific(3, EncodeX509Extensions(A.Extensions));
  Result :=
      ASN1EncodeSequence(S);
end;

procedure X509TBSCertificateCS0ParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509TBSCertificate;
begin
  D := Pointer(CallerData);
  DecodeX509Version(TypeID, DataBuf, DataSize, D^.Version);
  D^._DecodedVersion := True;
end;

procedure X509TBSCertificateCS1ParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509TBSCertificate;
begin
  D := Pointer(CallerData);
  ASN1DecodeString(TypeID, DataBuf, DataSize, D^.IssuerUniqueID);
  if D^.Version in [X509vUndefined, X509v1] then
    raise EX509.Create(SErr_DecodeError); // invalid version specified
end;

procedure X509TBSCertificateCS2ParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509TBSCertificate;
begin
  D := Pointer(CallerData);
  ASN1DecodeString(TypeID, DataBuf, DataSize, D^.SubjectUniqueID);
  if D^.Version in [X509vUndefined, X509v1] then
    raise EX509.Create(SErr_DecodeError); // invalid version specified
end;

procedure X509TBSCertificateCS3ParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509TBSCertificate;
begin
  D := Pointer(CallerData);
  DecodeX509Extensions(TypeID, DataBuf, DataSize, D^.Extensions);
  if D^.Version in [X509vUndefined, X509v1, X509v2] then
    raise EX509.Create(SErr_DecodeError); // invalid version specified
end;

procedure X509TBSCertificateParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509TBSCertificate;
    I : Integer;
begin
  D := Pointer(CallerData);
  if ASN1TypeIsContextSpecific(TypeID, I) then
    case I of
      0 : ASN1Parse(DataBuf, DataSize, X509TBSCertificateCS0ParseProc, CallerData);
      1 : ASN1Parse(DataBuf, DataSize, X509TBSCertificateCS1ParseProc, CallerData);
      2 : ASN1Parse(DataBuf, DataSize, X509TBSCertificateCS2ParseProc, CallerData);
      3 : ASN1Parse(DataBuf, DataSize, X509TBSCertificateCS3ParseProc, CallerData);
    end
  else
    begin
      if D^._DecodedVersion then
        I := 0
      else
        I := 1;
      case ObjectIdx + I of
        1 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.SerialNumber);
        2 : DecodeX509AlgorithmIdentifier(TypeID, DataBuf, DataSize, D^.Signature);
        3 : DecodeX509Name(TypeID, DataBuf, DataSize, D^.Issuer);
        4 : DecodeX509Validity(TypeID, DataBuf, DataSize, D^.Validity);
        5 : DecodeX509Name(TypeID, DataBuf, DataSize, D^.Subject);
        6 : begin
              DecodeX509SubjectPublicKeyInfo(TypeID, DataBuf, DataSize, D^.SubjectPublicKeyInfo);
              D^._Decoded := True;
            end;
      end;
    end;
end;

function DecodeX509TBSCertificate(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509TBSCertificate): Integer;
begin
  Assert(TypeID = ASN1_ID_SEQUENCE);
  A.Version := X509vUndefined;
  A._DecodedVersion := False;
  A._Decoded := False;
  Result := ASN1Parse(Buf, Size, X509TBSCertificateParseProc, NativeInt(@A));
  if not A._Decoded then
    raise EX509.Create(SErr_DecodeError); // incomplete structure
  if not A._DecodedVersion then
    A.Version := X509v1;
end;

(*
  Certificate ::= SEQUENCE {
      tbsCertificate      TBSCertificate,
      signatureAlgorithm  AlgorithmIdentifier,
      signature           BIT STRING }
  Signature is based on ASN.1 DER encoded tbsCertificate
*)
procedure InitX509Certificate(var A: TX509Certificate);
begin
  FillChar(A, SizeOf(A), 0);
end;

function EncodeX509Certificate(const A: TX509Certificate): RawByteString;
begin
  Result := ASN1EncodeSequence(
    EncodeX509TBSCertificate(A.TBSCertificate) +
    EncodeX509AlgorithmIdentifier(A.SignatureAlgorithm) +
    ASN1EncodeBitString(A.SignatureValue, 0)
    );
end;

procedure X509CertificateParseProc(const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509Certificate;
    K : Byte;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : DecodeX509TBSCertificate(TypeID, DataBuf, DataSize, D^.TBSCertificate);
    1 : DecodeX509AlgorithmIdentifier(TypeID, DataBuf, DataSize, D^.SignatureAlgorithm);
    2 : ASN1DecodeBitString(TypeID, DataBuf, DataSize, D^.SignatureValue, K);
  end;
  if ObjectIdx >= 2 then
    D^._Decoded := True;
end;

function DecodeX509Certificate(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509Certificate): Integer;
begin
  A._Decoded := False;
  Result := ASN1Parse(Buf, Size, X509CertificateParseProc, NativeInt(@A));
  if not A._Decoded then
    raise EX509.Create(SErr_DecodeError); // incomplete structure
  if not ASN1OIDEqual(A.SignatureAlgorithm.Algorithm, A.TBSCertificate.Signature.Algorithm) then
    raise EX509.Create(SErr_DecodeError); // signature algorithm specifications not the same
end;

procedure X509CertificateTopParseProc(const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509Certificate;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : DecodeX509Certificate(TypeID, DataBuf, DataSize, D^);
  end;
end;

function ParseX509Certificate(const Buf; const Size: Integer; var A: TX509Certificate): Integer;
var P : Pointer;
begin
  P := @Buf;
  if not Assigned(P) or (Size <= 0) then
    raise EX509.Create(SErr_InvalidBuffer);
  Result := ASN1Parse(Buf, Size, X509CertificateTopParseProc, NativeInt(@A));
  if Result <> Size then
    raise EX509.Create(SErr_DecodeError); // incomplete parsing
end;

procedure ParseX509CertificateStr(const BufStr: RawByteString; var A: TX509Certificate);
var L : Integer;
begin
  L := Length(BufStr);
  if L = 0 then
    raise EX509.Create(SErr_InvalidBuffer);
  ParseX509Certificate(BufStr[1], L, A);
end;

procedure ParseX509CertificatePEM(const BufStr: RawByteString; var A: TX509Certificate);
var S : RawByteString;
begin
  S := MIMEBase64Decode(BufStr);
  ParseX509CertificateStr(S, A);
end;

(*
  RSAPrivateKey ::= SEQUENCE {
      version         Version, -- a INTEGER version number; 0 for this standard
      modulus         INTEGER, -- n
      publicExponent  INTEGER, -- e
      privateExponent INTEGER, -- d
      prime1          INTEGER, -- primeP (p) (first prime factor of n)
      prime2          INTEGER, -- primeQ (q) (second prime factor of n)
      exponent1       INTEGER, -- primeExponentP: d mod (p - 1)
      exponent2       INTEGER, -- primeExponentQ: d mod (q - 1)
      crtCoefficient  INTEGER -- Chinese Remainder Theorem ((inverse of q) mod p) }
*)
function EncodeX509RSAPrivateKey(const A: TX509RSAPrivateKey): RawByteString;
begin
  Result := ASN1EncodeSequence(
    ASN1EncodeInteger32(A.Version) +
    ASN1EncodeIntegerBufStr(A.Modulus) +
    ASN1EncodeIntegerBufStr(A.PublicExponent) +
    ASN1EncodeIntegerBufStr(A.PrivateExponent) +
    ASN1EncodeIntegerBufStr(A.Prime1) +
    ASN1EncodeIntegerBufStr(A.Prime2) +
    ASN1EncodeIntegerBufStr(A.Exponent1) +
    ASN1EncodeIntegerBufStr(A.Exponent2) +
    ASN1EncodeIntegerBufStr(A.CRTCoefficient)
    );
end;

procedure X509RSAPrivateKeyParseProc(const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509RSAPrivateKey;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : ASN1DecodeInteger32(TypeID, DataBuf, DataSize, D^.Version);
    1 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.Modulus);
    2 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.PublicExponent);
    3 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.PrivateExponent);
    4 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.Prime1);
    5 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.Prime2);
    6 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.Exponent1);
    7 : ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.Exponent2);
    8 : begin
          ASN1DecodeIntegerBuf(TypeID, DataBuf, DataSize, D^.CRTCoefficient);
          D^._Decoded := True;
        end;
  end;
end;

function DecodeX509RSAPrivateKey(const TypeID: Byte; const Buf; const Size: Integer; var A: TX509RSAPrivateKey): Integer;
begin
  A._Decoded := False;
  Result := ASN1Parse(Buf, Size, X509RSAPrivateKeyParseProc, NativeInt(@A));
  if not A._Decoded then
    raise EX509.Create(SErr_DecodeError); // incomplete structure
end;

procedure X509RSAPrivateKeyTopParseProc(const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var D : PX509RSAPrivateKey;
begin
  D := Pointer(CallerData);
  case ObjectIdx of
    0 : DecodeX509RSAPrivateKey(TypeID, DataBuf, DataSize, D^);
  end;
end;

function ParseX509RSAPrivateKey(const Buf; const Size: Integer; var A: TX509RSAPrivateKey): Integer;
var P : Pointer;
begin
  P := @Buf;
  if not Assigned(P) or (Size <= 0) then
    raise EX509.Create(SErr_InvalidBuffer);
  Result := ASN1Parse(Buf, Size, X509RSAPrivateKeyTopParseProc, NativeInt(@A));
  if Result <> Size then
    raise EX509.Create(SErr_DecodeError); // incomplete parsing
end;

procedure ParseX509RSAPrivateKeyStr(const BufStr: RawByteString; var A: TX509RSAPrivateKey);
var L : Integer;
begin
  L := Length(BufStr);
  if L = 0 then
    raise EX509.Create(SErr_InvalidBuffer);
  ParseX509RSAPrivateKey(BufStr[1], L, A);
end;

procedure ParseX509RSAPrivateKeyPEM(const BufStr: RawByteString; var A: TX509RSAPrivateKey);
var S : RawByteString;
begin
  S := MIMEBase64Decode(BufStr);
  ParseX509RSAPrivateKeyStr(S, A);
end;



end.

