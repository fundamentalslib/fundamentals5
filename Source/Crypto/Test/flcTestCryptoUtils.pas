{$INCLUDE ../../flcInclude.inc}
{$INCLUDE ../flcCrypto.inc}

unit flcTestCryptoUtils;

interface



{$IFDEF CRYPTO_TEST}
procedure Test;
{$ENDIF}



implementation

{$IFDEF CRYPTO_TEST}
uses
  flcCryptoUtils;



{                                                                              }
{ Test                                                                         }
{                                                                              }
{$ASSERTIONS ON}
procedure Test;
var
  S : RawByteString;
  U : UnicodeString;
begin
  // SecureClear allocated string reference
  SetLength(S, 5);
  FillChar(S[1], 5, #1);
  SecureClearStrB(S);
  Assert(Length(S) = 0);
  //
  SetLength(U, 5);
  FillChar(U[1], 10, #1);
  SecureClearStrU(U);
  Assert(U = '');
  // SecureClear constant string reference
  S := 'ABC';
  SecureClearStrB(S);
  //
  U := 'ABC';
  SecureClearStrU(U);
end;
{$ENDIF}



end.

