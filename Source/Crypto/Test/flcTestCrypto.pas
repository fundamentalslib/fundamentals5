{$INCLUDE ../../flcInclude.inc}
{$INCLUDE ../flcCrypto.inc}

unit flcTestCrypto;

interface


{$IFDEF CRYPTO_TEST}
procedure Test;
{$ENDIF}



implementation

{$IFDEF CRYPTO_TEST}
uses
  flcTestCryptoUtils,
  flcTestCryptoHash,
  flcTestCertificatePEM,
  flcTestEncodingASN1,
  flcTestCertificateX509;



{                                                                              }
{ Test                                                                         }
{                                                                              }
{$ASSERTIONS ON}
procedure Test;
begin
  flcTestCryptoUtils.Test;
  flcTestCryptoHash.Test;
  flcTestCertificatePEM.Test;
  flcTestEncodingASN1.Test;
  flcTestCertificateX509.Test;
end;
{$ENDIF}



end.

