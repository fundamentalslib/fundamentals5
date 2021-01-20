{$INCLUDE ../../flcInclude.inc}
{$INCLUDE ../flcCrypto.inc}

unit flcTestCertificateX509;

interface



{$IFDEF CRYPTO_TEST}
procedure Test;
{$ENDIF}



implementation

{$IFDEF CRYPTO_TEST}
uses
  SysUtils,

  flcStdTypes,

  flcEncodingASN1,
  flcCertificateX509;



{                                                                              }
{ Test                                                                         }
{                                                                              }
{$ASSERTIONS ON}
procedure TestRFC2459;
var A, B : TX509Certificate;
    C : RawByteString;
    F : TX509AttributeTypeAndValue;
    N : TX509RelativeDistinguishedName;
    M : TX509RDNSequence;
    EXT : TX509Extension;
    EXTS : TX509Extensions;
    EBC : TX509BasicConstraints;
    ESK : TX509SubjectKeyIdentifier;
    PKD : TX509DSSParms;
    L : Integer;
begin
  InitX509Certificate(A);
  InitX509Certificate(B);

  //                                                                          //
  // Example D.1 from RFC 2459                                                //
  //                                                                          //
  A.TBSCertificate.Version := X509v3;
  A.TBSCertificate.SerialNumber := #17;
  InitX509AlgorithmIdentifierDSA_SHA1(A.TBSCertificate.Signature, '');
  A.TBSCertificate.Validity.NotBefore := EncodeDate(1997, 6, 30);
  A.TBSCertificate.Validity.NotAfter := EncodeDate(1997, 12, 31);

  PKD.P := RawByteString(
      #$d4#$38#$02#$c5#$35#$7b#$d5#$0b#$a1#$7e#$5d#$72#$59#$63#$55#$d3 +
      #$45#$56#$ea#$e2#$25#$1a#$6b#$c5#$a4#$ab#$aa#$0b#$d4#$62#$b4#$d2 +
      #$21#$b1#$95#$a2#$c6#$01#$c9#$c3#$fa#$01#$6f#$79#$86#$83#$3d#$03 +
      #$61#$e1#$f1#$92#$ac#$bc#$03#$4e#$89#$a3#$c9#$53#$4a#$f7#$e2#$a6 +
      #$48#$cf#$42#$1e#$21#$b1#$5c#$2b#$3a#$7f#$ba#$be#$6b#$5a#$f7#$0a +
      #$26#$d8#$8e#$1b#$eb#$ec#$bf#$1e#$5a#$3f#$45#$c0#$bd#$31#$23#$be +
      #$69#$71#$a7#$c2#$90#$fe#$a5#$d6#$80#$b5#$24#$dc#$44#$9c#$eb#$4d +
      #$f9#$da#$f0#$c8#$e8#$a2#$4c#$99#$07#$5c#$8e#$35#$2b#$7d#$57#$8d);
  PKD.Q := RawByteString(
      #$a7#$83#$9b#$f3#$bd#$2c#$20#$07#$fc#$4c#$e7#$e8#$9f#$f3#$39#$83 +
      #$51#$0d#$dc#$dd);
  PKD.G := RawByteString(
      #$0e#$3b#$46#$31#$8a#$0a#$58#$86#$40#$84#$e3#$a1#$22#$0d#$88#$ca +
      #$90#$88#$57#$64#$9f#$01#$21#$e0#$15#$05#$94#$24#$82#$e2#$10#$90 +
      #$d9#$e1#$4e#$10#$5c#$e7#$54#$6b#$d4#$0c#$2b#$1b#$59#$0a#$a0#$b5 +
      #$a1#$7d#$b5#$07#$e3#$65#$7c#$ea#$90#$d8#$8e#$30#$42#$e4#$85#$bb +
      #$ac#$fa#$4e#$76#$4b#$78#$0e#$df#$6c#$e5#$a6#$e1#$bd#$59#$77#$7d +
      #$a6#$97#$59#$c5#$29#$a7#$b3#$3f#$95#$3e#$9d#$f1#$59#$2d#$f7#$42 +
      #$87#$62#$3f#$f1#$b8#$6f#$c7#$3d#$4b#$b8#$8d#$74#$c4#$ca#$44#$90 +
      #$cf#$67#$db#$de#$14#$60#$97#$4a#$d1#$f7#$6d#$9e#$09#$94#$c4#$0d);
  InitX509SubjectPublicKeyInfoDSA(A.TBSCertificate.SubjectPublicKeyInfo, PKD,
      RawByteString(
      #$02#$81#$80#$aa#$98#$ea#$13#$94#$a2#$db#$f1#$5b#$7f#$98#$2f#$78 +
      #$e7#$d8#$e3#$b9#$71#$86#$f6#$80#$2f#$40#$39#$c3#$da#$3b#$4b#$13 +
      #$46#$26#$ee#$0d#$56#$c5#$a3#$3a#$39#$b7#$7d#$33#$c2#$6b#$5c#$77 +
      #$92#$f2#$55#$65#$90#$39#$cd#$1a#$3c#$86#$e1#$32#$eb#$25#$bc#$91 +
      #$c4#$ff#$80#$4f#$36#$61#$bd#$cc#$e2#$61#$04#$e0#$7e#$60#$13#$ca +
      #$c0#$9c#$dd#$e0#$ea#$41#$de#$33#$c1#$f1#$44#$a9#$bc#$71#$de#$cf +
      #$59#$d4#$6e#$da#$44#$99#$3c#$21#$64#$e4#$78#$54#$9d#$d0#$7b#$ba +
      #$4e#$f5#$18#$4d#$5e#$39#$30#$bf#$e0#$d1#$f6#$f4#$83#$25#$4f#$14 +
      #$aa#$71#$e1));

  M := nil;
  N := nil;
  InitX509AtCountryName(F, 'US');
  AppendX509RelativeDistinguishedName(N, F);
  AppendX509RDNSequence(M, N);
  N := nil;
  InitX509AtOriganizationName(F, 'gov');
  AppendX509RelativeDistinguishedName(N, F);
  AppendX509RDNSequence(M, N);
  N := nil;
  InitX509AtOriganizationUnitName(F, 'nist');
  AppendX509RelativeDistinguishedName(N, F);
  AppendX509RDNSequence(M, N);
  A.TBSCertificate.Issuer := M;

  M := nil;
  N := nil;
  InitX509AtCountryName(F, 'US');
  AppendX509RelativeDistinguishedName(N, F);
  AppendX509RDNSequence(M, N);
  N := nil;
  InitX509AtOriganizationName(F, 'gov');
  AppendX509RelativeDistinguishedName(N, F);
  AppendX509RDNSequence(M, N);
  N := nil;
  InitX509AtOriganizationUnitName(F, 'nist');
  AppendX509RelativeDistinguishedName(N, F);
  AppendX509RDNSequence(M, N);
  A.TBSCertificate.Subject := M;

  EXTS := nil;

  EBC.CA := True;
  EBC.PathLenConstraint := '';
  InitX509ExtBasicConstraints(EXT, EBC);
  AppendX509Extensions(EXTS, EXT);

  ESK := RawByteString(
      #$04#$14#$e7#$26#$c5#$54#$cd#$5b#$a3#$6f#$35#$68#$95#$aa#$d5#$ff#$1c#$21#$e4#$22#$75#$d6);
  InitX509ExtSubjectKeyIdentifier(EXT, ESK);
  AppendX509Extensions(EXTS, EXT);

  A.TBSCertificate.Extensions := EXTS;

  InitX509AlgorithmIdentifierDSA_SHA1(A.SignatureAlgorithm, '');
  A.SignatureValue := RawByteString(
      #$30#$2c#$02#$14#$a0#$66#$c1#$76#$33#$99#$13#$51#$8d#$93#$64#$2f +
      #$ca#$13#$73#$de#$79#$1a#$7d#$33#$02#$14#$5d#$90#$f6#$ce#$92#$4a +
      #$bf#$29#$11#$24#$80#$28#$a6#$5a#$8e#$73#$b6#$76#$02#$68);

  C := EncodeX509Certificate(A);
  Assert(C =
      #$30#$82#$02#$b7 +  // 695: SEQUENCE
      #$30#$82#$02#$77 +  // 631: . SEQUENCE    tbscertificate
      #$a0#$03 +          //   3: . . [0]
      #$02#$01 +          //   1: . . . INTEGER 2
      #$02 +
      #$02#$01 +          //   1: . . INTEGER 17
      #$11 +
      #$30#$09 +          //   9: . . SEQUENCE
      #$06#$07 +          //   7: . . . OID 1.2.840.10040.4.3: dsa-with-sha
      #$2a#$86#$48#$ce#$38#$04#$03 +
      #$30#$2a +          //  42: . . SEQUENCE
      #$31#$0b +          //  11: . . . SET
      #$30#$09 +          //   9: . . . . SEQUENCE
      #$06#$03 +          //   3: . . . . . OID 2.5.4.6: C
      #$55#$04#$06 +
      #$13#$02 +          //   2: . . . . . PrintableString  'US'
      #$55#$53 +
      #$31#$0c +          //  12: . . . SET
      #$30#$0a +          //  10: . . . . SEQUENCE
      #$06#$03 +          //   3: . . . . . OID 2.5.4.10: O
      #$55#$04#$0a +
      #$13#$03 +          //   3: . . . . . PrintableString  'gov'
      #$67#$6f#$76 +
      #$31#$0d +          //  13: . . . SET
      #$30#$0b +          //  11: . . . . SEQUENCE
      #$06#$03 +          //   3: . . . . . OID 2.5.4.11: OU
      #$55#$04#$0b +
      #$13#$04 +          //   4: . . . . . PrintableString  'nist'
      #$6e#$69#$73#$74 +
      #$30#$1e +          //  30: . . SEQUENCE
      #$17#$0d +          //  13: . . . UTCTime  '970630000000Z'
      #$39#$37#$30#$36#$33#$30#$30#$30#$30#$30#$30#$30#$5a +
      #$17#$0d +          //  13: . . . UTCTime  '971231000000Z'
      #$39#$37#$31#$32#$33#$31#$30#$30#$30#$30#$30#$30#$5a +
      #$30#$2a +          //  42: . . SEQUENCE
      #$31#$0b +          //  11: . . . SET
      #$30#$09 +          //   9: . . . . SEQUENCE
      #$06#$03 +          //   3: . . . . . OID 2.5.4.6: C
      #$55#$04#$06 +
      #$13#$02 +          //   2: . . . . . PrintableString  'US'
      #$55#$53 +
      #$31#$0c +          //  12: . . . SET
      #$30#$0a +          //  10: . . . . SEQUENCE
      #$06#$03 +          //   3: . . . . . OID 2.5.4.10: O
      #$55#$04#$0a +
      #$13#$03 +          //   3: . . . . . PrintableString  'gov'
      #$67#$6f#$76 +
      #$31#$0d +          //  13: . . . SET
      #$30#$0b +          //  11: . . . . SEQUENCE
      #$06#$03 +          //   3: . . . . . OID 2.5.4.11: OU
      #$55#$04#$0b +
      #$13#$04 +          //   4: . . . . . PrintableString  'nist'
      #$6e#$69#$73#$74 +
      #$30#$82#$01#$b4 +  // 436: . . SEQUENCE
      #$30#$82#$01#$29 +  // 297: . . . SEQUENCE
      #$06#$07 +          //   7: . . . . OID 1.2.840.10040.4.1: dsa
      #$2a#$86#$48#$ce#$38#$04#$01 +
      #$30#$82#$01#$1c +  // 284: . . . . SEQUENCE
      #$02#$81#$80 +      // 128: . . . . . INTEGER
            #$d4#$38#$02#$c5#$35#$7b#$d5#$0b#$a1#$7e#$5d#$72#$59#$63#$55#$d3 +
            #$45#$56#$ea#$e2#$25#$1a#$6b#$c5#$a4#$ab#$aa#$0b#$d4#$62#$b4#$d2 +
            #$21#$b1#$95#$a2#$c6#$01#$c9#$c3#$fa#$01#$6f#$79#$86#$83#$3d#$03 +
            #$61#$e1#$f1#$92#$ac#$bc#$03#$4e#$89#$a3#$c9#$53#$4a#$f7#$e2#$a6 +
            #$48#$cf#$42#$1e#$21#$b1#$5c#$2b#$3a#$7f#$ba#$be#$6b#$5a#$f7#$0a +
            #$26#$d8#$8e#$1b#$eb#$ec#$bf#$1e#$5a#$3f#$45#$c0#$bd#$31#$23#$be +
            #$69#$71#$a7#$c2#$90#$fe#$a5#$d6#$80#$b5#$24#$dc#$44#$9c#$eb#$4d +
            #$f9#$da#$f0#$c8#$e8#$a2#$4c#$99#$07#$5c#$8e#$35#$2b#$7d#$57#$8d +
      #$02#$14 +          //  20: . . . . . INTEGER
            #$a7#$83#$9b#$f3#$bd#$2c#$20#$07#$fc#$4c#$e7#$e8#$9f#$f3#$39#$83 +
            #$51#$0d#$dc#$dd +
      #$02#$81#$80 +      // 128: . . . . . INTEGER
            #$0e#$3b#$46#$31#$8a#$0a#$58#$86#$40#$84#$e3#$a1#$22#$0d#$88#$ca +
            #$90#$88#$57#$64#$9f#$01#$21#$e0#$15#$05#$94#$24#$82#$e2#$10#$90 +
            #$d9#$e1#$4e#$10#$5c#$e7#$54#$6b#$d4#$0c#$2b#$1b#$59#$0a#$a0#$b5 +
            #$a1#$7d#$b5#$07#$e3#$65#$7c#$ea#$90#$d8#$8e#$30#$42#$e4#$85#$bb +
            #$ac#$fa#$4e#$76#$4b#$78#$0e#$df#$6c#$e5#$a6#$e1#$bd#$59#$77#$7d +
            #$a6#$97#$59#$c5#$29#$a7#$b3#$3f#$95#$3e#$9d#$f1#$59#$2d#$f7#$42 +
            #$87#$62#$3f#$f1#$b8#$6f#$c7#$3d#$4b#$b8#$8d#$74#$c4#$ca#$44#$90 +
            #$cf#$67#$db#$de#$14#$60#$97#$4a#$d1#$f7#$6d#$9e#$09#$94#$c4#$0d +
      #$03#$81#$84#$00 +  // 132: . . . BIT STRING  (0 unused bits)
            #$02#$81#$80#$aa#$98#$ea#$13#$94#$a2#$db#$f1#$5b#$7f#$98#$2f#$78 +
            #$e7#$d8#$e3#$b9#$71#$86#$f6#$80#$2f#$40#$39#$c3#$da#$3b#$4b#$13 +
            #$46#$26#$ee#$0d#$56#$c5#$a3#$3a#$39#$b7#$7d#$33#$c2#$6b#$5c#$77 +
            #$92#$f2#$55#$65#$90#$39#$cd#$1a#$3c#$86#$e1#$32#$eb#$25#$bc#$91 +
            #$c4#$ff#$80#$4f#$36#$61#$bd#$cc#$e2#$61#$04#$e0#$7e#$60#$13#$ca +
            #$c0#$9c#$dd#$e0#$ea#$41#$de#$33#$c1#$f1#$44#$a9#$bc#$71#$de#$cf +
            #$59#$d4#$6e#$da#$44#$99#$3c#$21#$64#$e4#$78#$54#$9d#$d0#$7b#$ba +
            #$4e#$f5#$18#$4d#$5e#$39#$30#$bf#$e0#$d1#$f6#$f4#$83#$25#$4f#$14 +
            #$aa#$71#$e1 +
      #$a3#$32 +          //  50: . . [3]
      #$30#$30 +          //  48: . . . SEQUENCE
      #$30#$0f +          //   9: . . . . SEQUENCE
      #$06#$03 +          //   3: . . . . . OID 2.5.29.19: basicConstraints
      #$55#$1d#$13 +
      #$01#$01 +          //   1: . . . . . TRUE
      #$ff +
      #$04#$05 +          //   5: . . . . . OCTET STRING
      #$30#$03#$01#$01#$ff +
      #$30#$1d +          //  29: . SEQUENCE
      #$06#$03 +          //   3: . . . . . OID 2.5.29.14: subjectKeyIdentifier
      #$55#$1d#$0e +
      #$04#$16 +          //   22: . . . . . OCTET STRING
      #$04#$14#$e7#$26#$c5#$54#$cd#$5b#$a3#$6f#$35#$68#$95#$aa#$d5#$ff +
      #$1c#$21#$e4#$22#$75#$d6 +
      #$30#$09 +          //   9: . SEQUENCE
      #$06#$07 +          //   7: . . OID 1.2.840.10040.4.3: dsa-with-sha
      #$2a#$86#$48#$ce#$38#$04#$03 +
      #$03#$2f#$00 +      //  47: . BIT STRING  (0 unused bits)
            #$30#$2c#$02#$14#$a0#$66#$c1#$76#$33#$99#$13#$51#$8d#$93#$64#$2f +
            #$ca#$13#$73#$de#$79#$1a#$7d#$33#$02#$14#$5d#$90#$f6#$ce#$92#$4a +
            #$bf#$29#$11#$24#$80#$28#$a6#$5a#$8e#$73#$b6#$76#$02#$68);

  L := ParseX509Certificate(C[1], Length(C), B);
  Assert(L = Length(C));
  Assert(B.TBSCertificate.Version = X509v3);
  Assert(B.TBSCertificate.SerialNumber = #17);
  Assert(B.TBSCertificate.Validity.NotBefore = EncodeDate(1997, 6, 30));
  Assert(B.TBSCertificate.Validity.NotAfter = EncodeDate(1997, 12, 31));
  Assert(B.SignatureValue =
      #$30#$2c#$02#$14#$a0#$66#$c1#$76#$33#$99#$13#$51#$8d#$93#$64#$2f +
      #$ca#$13#$73#$de#$79#$1a#$7d#$33#$02#$14#$5d#$90#$f6#$ce#$92#$4a +
      #$bf#$29#$11#$24#$80#$28#$a6#$5a#$8e#$73#$b6#$76#$02#$68);
end;

procedure TestSTunnelOrg;
var A, B : TX509Certificate;
    C, D : RawByteString;
    L : Integer;
    S : RawByteString;
    PKR : TX509RSAPublicKey;
    PRK : TX509RSAPrivateKey;
begin
  InitX509Certificate(A);
  InitX509Certificate(B);

  //                                                                          //
  // stunnel.org public certificate                                           //
  //                                                                          //
  C := RawByteString(
      #$30#$82#$02#$0F#$30#$82#$01#$78#$A0#$03#$02#$01#$02#$02#$01#$00 +
      #$30#$0D#$06#$09#$2A#$86#$48#$86#$F7#$0D#$01#$01#$04#$05#$00#$30 +
      #$42#$31#$0B#$30#$09#$06#$03#$55#$04#$06#$13#$02#$50#$4C#$31#$1F +
      #$30#$1D#$06#$03#$55#$04#$0A#$13#$16#$53#$74#$75#$6E#$6E#$65#$6C +
      #$20#$44#$65#$76#$65#$6C#$6F#$70#$65#$72#$73#$20#$4C#$74#$64#$31 +
      #$12#$30#$10#$06#$03#$55#$04#$03#$13#$09#$6C#$6F#$63#$61#$6C#$68 +
      #$6F#$73#$74#$30#$1E#$17#$0D#$39#$39#$30#$34#$30#$38#$31#$35#$30 +
      #$39#$30#$38#$5A#$17#$0D#$30#$30#$30#$34#$30#$37#$31#$35#$30#$39 +
      #$30#$38#$5A#$30#$42#$31#$0B#$30#$09#$06#$03#$55#$04#$06#$13#$02 +
      #$50#$4C#$31#$1F#$30#$1D#$06#$03#$55#$04#$0A#$13#$16#$53#$74#$75 +
      #$6E#$6E#$65#$6C#$20#$44#$65#$76#$65#$6C#$6F#$70#$65#$72#$73#$20 +
      #$4C#$74#$64#$31#$12#$30#$10#$06#$03#$55#$04#$03#$13#$09#$6C#$6F +
      #$63#$61#$6C#$68#$6F#$73#$74#$30#$81#$9F#$30#$0D#$06#$09#$2A#$86 +
      #$48#$86#$F7#$0D#$01#$01#$01#$05#$00#$03#$81#$8D#$00#$30#$81#$89 +
      #$02#$81#$81#$00#$B1#$50#$53#$2E#$A8#$92#$5B#$23#$D2#$A7#$07#$C5 +
      #$6D#$C1#$26#$DC#$BF#$03#$4E#$96#$D5#$81#$B5#$6C#$9A#$4A#$6A#$7B +
      #$C8#$49#$EA#$C1#$67#$A5#$E5#$31#$5F#$70#$E3#$9B#$0A#$E2#$D9#$EB +
      #$DB#$05#$8B#$51#$0B#$8B#$90#$BD#$D6#$A4#$5A#$0C#$CA#$30#$EE#$4E +
      #$46#$8F#$4E#$43#$66#$D2#$C3#$15#$F2#$02#$0F#$45#$B5#$4B#$E9#$F6 +
      #$2A#$A9#$76#$A3#$C7#$F6#$45#$2B#$D9#$A8#$3D#$96#$F6#$5F#$22#$E7 +
      #$D5#$DB#$0B#$3D#$68#$4B#$89#$7D#$4B#$4F#$4B#$FB#$74#$53#$65#$5F +
      #$68#$7A#$BF#$D4#$9D#$BC#$BF#$42#$68#$9C#$14#$B3#$4C#$D1#$68#$2B +
      #$54#$D8#$8A#$CB#$02#$03#$01#$00#$01#$A3#$15#$30#$13#$30#$11#$06 +
      #$09#$60#$86#$48#$01#$86#$F8#$42#$01#$01#$04#$04#$03#$02#$06#$40 +
      #$30#$0D#$06#$09#$2A#$86#$48#$86#$F7#$0D#$01#$01#$04#$05#$00#$03 +
      #$81#$81#$00#$08#$58#$15#$39#$E0#$59#$CD#$ED#$B8#$C8#$D5#$16#$14 +
      #$B8#$1D#$B7#$C5#$17#$FB#$E5#$3A#$04#$EE#$E3#$8F#$EB#$BF#$61#$7E +
      #$C9#$AD#$66#$10#$1F#$77#$86#$D7#$CD#$C7#$1D#$E8#$7D#$1C#$5C#$8C +
      #$27#$68#$AE#$A3#$8D#$64#$5C#$04#$6D#$AE#$B1#$67#$CF#$D4#$BA#$36 +
      #$1F#$56#$62#$06#$08#$1C#$B8#$5F#$CF#$9A#$5D#$DF#$37#$4C#$9F#$40 +
      #$79#$28#$D3#$CD#$5F#$54#$6B#$23#$A8#$1A#$D9#$A0#$F0#$3B#$F6#$6A +
      #$3F#$F9#$89#$A6#$CD#$78#$AD#$50#$7F#$7E#$68#$BA#$F9#$5C#$4D#$EC +
      #$D5#$66#$DD#$99#$78#$94#$61#$A9#$41#$DC#$19#$A1#$3E#$6A#$90#$8D +
      #$4C#$2F#$58);
  L := ParseX509Certificate(C[1], Length(C), A);
  Assert(L = Length(C));
  Assert(ASN1OIDEqual(A.TBSCertificate.SubjectPublicKeyInfo.Algorithm.Algorithm, OID_RSA));
  S := A.TBSCertificate.SubjectPublicKeyInfo.SubjectPublicKey;
  L := Length(S);
  Assert(L > 0);
  Assert(ParseX509RSAPublicKey(S[1], L, PKR) = L);
  Assert(Length(PKR.Modulus) = 129);
  Assert((PKR.Modulus[1] = #0) and (PKR.Modulus[2] <> #0));
  Assert(Length(PKR.PublicExponent) = 3);

  D := EncodeX509Certificate(A);
  Assert(D <> '');

  //                                                                          //
  // stunnel.org PEM file                                                     //
  //                                                                          //
  ParseX509RSAPrivateKeyPEM(
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
      'JIY9r6e1qwNxQ/j1Mud6gn6cRrObpRtEad5z2FtcnwY=', PRK);
  Assert(PRK.Version = 0);
  Assert(Length(PRK.PrivateExponent) = 128);

  ParseX509CertificatePEM(
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
      'TC9Y', A);
  Assert(A.TBSCertificate.Version = X509v3);
end;

procedure Test;
begin
  TestRFC2459;
  TestSTunnelOrg;
end;
{$ENDIF}



end.

