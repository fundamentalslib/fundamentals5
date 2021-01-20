{$INCLUDE ../../flcInclude.inc}
{$INCLUDE ../flcCrypto.inc}

unit flcTestEncodingASN1;

interface



{$IFDEF CRYPTO_TEST}
procedure Test;
{$ENDIF}



implementation

{$IFDEF CRYPTO_TEST}
uses
  flcEncodingASN1;



{                                                                              }
{ Test                                                                         }
{                                                                              }
{$ASSERTIONS ON}
procedure TestParseProc(
          const TypeID: Byte; const DataBuf; const DataSize: NativeInt;
          const ObjectIdx: Int32; const CallerData: NativeInt);
var
  I : Int64;
  S : RawByteString;
begin
  case CallerData of
    0 : case ObjectIdx of
          0 : begin
                Assert(TypeID = ASN1_ID_SEQUENCE);
                Assert(ASN1Parse(DataBuf, DataSize, TestParseProc, 1) = DataSize);
              end;
        else
          Assert(False);
        end;
    1 : case ObjectIdx of
          0 : begin
                Assert(TypeID = ASN1_ID_INTEGER);
                ASN1DecodeInteger64(TypeID, DataBuf, DataSize, I);
                Assert(I = 123);
              end;
          1 : begin
                Assert(TypeID = ASN1_ID_PRINTABLESTRING);
                ASN1DecodeString(TypeID, DataBuf, DataSize, S);
                Assert(S = 'ABC');
              end;
        else
          Assert(False);
        end;
  else
    Assert(False);
  end;
end;

procedure Test;
var S : RawByteString;
    L, I, J : Integer;
    D : TASN1ObjectIdentifier;
begin
  Assert(ASN1EncodeLength(0) = #$00);
  Assert(ASN1EncodeLength(1) = #$01);
  Assert(ASN1EncodeLength($7F) = #$7F);
  Assert(ASN1EncodeLength($80) = #$81#$80);
  Assert(ASN1EncodeLength($FF) = #$81#$FF);
  Assert(ASN1EncodeLength($100) = #$82#$01#$00);

  Assert(ASN1EncodeOID(OID_3DES_wrap) = #$06#$0b#$2a#$86#$48#$86#$f7#$0d#$01#$09#$10#$03#$06);
  Assert(ASN1EncodeOID(OID_RC2_wrap)  = #$06#$0b#$2a#$86#$48#$86#$f7#$0d#$01#$09#$10#$03#$07);

  S := RawByteString(#$2a#$86#$48#$86#$f7#$0d#$01#$09#$10#$03#$06);
  L := Length(S);
  Assert(ASN1DecodeDataOID(S[1], L, D) = L);
  Assert(Length(D) = 9);
  Assert((D[0] = 1) and (D[1] = 2) and (D[2] = 840) and (D[3] = 113549) and
         (D[4] = 1) and (D[5] = 9) and (D[6] = 16) and (D[7] = 3) and (D[8] = 6));
  Assert(ASN1OIDToStrB(D) = '1.2.840.113549.1.9.16.3.6');

  S := RawByteString(#$2a#$86#$48#$86#$f7#$0d#$03#$06);
  L := Length(S);
  Assert(ASN1DecodeDataOID(S[1], L, D) = L);
  Assert(Length(D) = 6);
  Assert((D[0] = 1) and (D[1] = 2) and (D[2] = 840) and (D[3] = 113549) and
         (D[4] = 3) and (D[5] = 6));

  Assert(ASN1EncodeInteger32(0) = #$02#$01#$00);
  Assert(ASN1EncodeInteger32(1) = #$02#$01#$01);
  Assert(ASN1EncodeInteger32(-1) = #$02#$01#$FF);
  Assert(ASN1EncodeInteger32(-$80) = #$02#$01#$80);
  Assert(ASN1EncodeInteger32(-$81) = #$02#$02#$7F#$FF);
  Assert(ASN1EncodeInteger32(-$FF) = #$02#$02#$01#$FF);
  Assert(ASN1EncodeInteger32($7F) = #$02#$01#$7F);
  Assert(ASN1EncodeInteger32($80) = #$02#$02#$80#$00);
  Assert(ASN1EncodeInteger32($FF) = #$02#$02#$FF#$00);

  for I := -512 to 512 do
    begin
      S := ASN1EncodeInteger32(I);
      Assert(S = ASN1EncodeInteger64(I));
      L := Length(S);
      Assert(ASN1DecodeDataInteger32(S[3], L - 2, J) = L - 2);
      Assert(J = I);
    end;

  S :=
    ASN1EncodeSequence(
        ASN1EncodeInteger32(123) +
        ASN1EncodePrintableString('ABC')
        );
  L := Length(S);
  Assert(L > 0);
  Assert(ASN1Parse(S[1], L, @TestParseProc, 0) = L);
end;
{$ENDIF}



end.

