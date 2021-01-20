{$INCLUDE ../../flcInclude.inc}
{$INCLUDE ../flcCrypto.inc}

unit flcTestCryptoHash;

interface



{$IFDEF CRYPTO_TEST}
procedure Test;
{$ENDIF}



implementation

{$IFDEF CRYPTO_TEST}
uses
  flcCryptoUtils,
  flcCryptoHash;



{                                                                              }
{ Test                                                                         }
{                                                                              }
{$ASSERTIONS ON}
procedure Test;

  function DupChar(const Count: Integer; const Ch: Byte): RawByteString;
  var
    A : RawByteString;
    I : Integer;
  begin
    A := '';
    for I := 1 to Count do
      A := A + AnsiChar(Ch);
    Result := A;
  end;

const
  QuickBrownFoxStr = 'The quick brown fox jumps over the lazy dog';
var
  MillionA, TenThousandA : RawByteString;
  S, T : RawByteString;
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

  SetLength(MillionA, 1000000);
  FillChar(MillionA[1], 1000000, Ord('a'));
  SetLength(TenThousandA, 10000);
  FillChar(TenThousandA[1], 10000, Ord('a'));

  Assert(UnicodeString(MD5DigestToHexA(CalcMD5(''))) = MD5DigestToHexU(CalcMD5('')));
  Assert(MD5DigestToHexA(CalcMD5(''))                    = 'd41d8cd98f00b204e9800998ecf8427e');
  Assert(MD5DigestToHexA(CalcMD5('Delphi Fundamentals')) = 'ea98b65da23d19756d46a36faa481dd8');

  Assert(UnicodeString(SHA1DigestToHexA(CalcSHA1(''))) = SHA1DigestToHexU(CalcSHA1('')));
  Assert(SHA1DigestToHexA(CalcSHA1(''))               = 'da39a3ee5e6b4b0d3255bfef95601890afd80709');
  Assert(SHA1DigestToHexA(CalcSHA1('Fundamentals'))   = '052d8ad81d99f33b2eb06e6d194282b8675fb201');
  Assert(SHA1DigestToHexA(CalcSHA1(QuickBrownFoxStr)) = '2fd4e1c67a2d28fced849ee1bb76e7391b93eb12');
  Assert(SHA1DigestToHexA(CalcSHA1(TenThousandA))     = 'a080cbda64850abb7b7f67ee875ba068074ff6fe');

  Assert(UnicodeString(SHA224DigestToHexA(CalcSHA224(''))) = SHA224DigestToHexU(CalcSHA224('')));
  Assert(SHA224DigestToHexA(CalcSHA224(''))               = 'd14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f');
  Assert(SHA224DigestToHexA(CalcSHA224('Fundamentals'))   = '1cccba6b3c6b08494733efb3a77fe8baef5bf6eeae89ec303ef4660e');
  Assert(SHA224DigestToHexA(CalcSHA224(QuickBrownFoxStr)) = '730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525');
  Assert(SHA224DigestToHexA(CalcSHA224(TenThousandA))     = '00568fba93e8718c2f7dcd82fa94501d59bb1bbcba2c7dc2ba5882db');

  Assert(UnicodeString(SHA256DigestToHexA(CalcSHA256(''))) = SHA256DigestToHexU(CalcSHA256('')));
  Assert(SHA256DigestToHexA(CalcSHA256(''))               = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855');
  Assert(SHA256DigestToHexA(CalcSHA256('Fundamentals'))   = '915ff7435daeac2f66aa866e59bf293f101b79403dbdde2b631fd37fa524f26b');
  Assert(SHA256DigestToHexA(CalcSHA256(QuickBrownFoxStr)) = 'd7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592');
  Assert(SHA256DigestToHexA(CalcSHA256(TenThousandA))     = '27dd1f61b867b6a0f6e9d8a41c43231de52107e53ae424de8f847b821db4b711');
  Assert(SHA256DigestToHexA(CalcSHA256(MillionA))         = 'cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0');

  Assert(UnicodeString(SHA384DigestToHexA(CalcSHA384(''))) = SHA384DigestToHexU(CalcSHA384('')));
  Assert(SHA384DigestToHexA(CalcSHA384(''))               = '38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b');
  Assert(SHA384DigestToHexA(CalcSHA384('Fundamentals'))   = 'cf9380b7d2e0237296093a0f5f09066f0cea0742ba752a1e6c60aed92998eda2c86c1549879007a94e9d75a4a7bdb6e8');
  Assert(SHA384DigestToHexA(CalcSHA384(QuickBrownFoxStr)) = 'ca737f1014a48f4c0b6dd43cb177b0afd9e5169367544c494011e3317dbf9a509cb1e5dc1e85a941bbee3d7f2afbc9b1');
  Assert(SHA384DigestToHexA(CalcSHA384(TenThousandA))     = '2bca3b131bb7e922bcd1de98c44786d32e6b6b2993e69c4987edf9dd49711eb501f0e98ad248d839f6bf9e116e25a97c');

  Assert(UnicodeString(SHA512DigestToHexA(CalcSHA512(''))) = SHA512DigestToHexU(CalcSHA512('')));
  Assert(SHA512DigestToHexA(CalcSHA512(''))               = 'cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e');
  Assert(SHA512DigestToHexA(CalcSHA512('Fundamentals'))   = 'f430fed95ff285843bc68a5e2a1ad8275d7c242a504a5d0b23deb7f8252774a132c3672aeeffa9bf5c25449e8905cdb6f89097a3c88f20a6e0d8945bf4310dd6');
  Assert(SHA512DigestToHexA(CalcSHA512(QuickBrownFoxStr)) = '07e547d9586f6a73f73fbac0435ed76951218fb7d0c8d788a309d785436bbb642e93a252a954f23912547d1e8a3b5ed6e1bfd7097821233fa0538f3db854fee6');
  Assert(SHA512DigestToHexA(CalcSHA512(TenThousandA))     = '0593036f4f479d2eb8078ca26b1d59321a86bdfcb04cb40043694f1eb0301b8acd20b936db3c916ebcc1b609400ffcf3fa8d569d7e39293855668645094baf0e');

  Assert(MD5DigestToHexA(CalcHMAC_MD5('', ''))                    = '74e6f7298a9c2d168935f58c001bad88');
  Assert(MD5DigestToHexA(CalcHMAC_MD5('', 'Delphi Fundamentals')) = 'b9da02d5f94bd6eac410708a72b05d9f');
  Assert(MD5DigestToHexA(CalcHMAC_MD5('Delphi Fundamentals', '')) = 'a09f3300c236156d27f4d031db7e91ce');
  Assert(MD5DigestToHexA(CalcHMAC_MD5('Delphi', 'Fundamentals'))  = '1c4e8a481c2c781eb43ca58d9324c37d');

  Assert(SHA1DigestToHexA(CalcHMAC_SHA1('', ''))                           = 'fbdb1d1b18aa6c08324b7d64b71fb76370690e1d');
  Assert(SHA1DigestToHexA(CalcHMAC_SHA1('', QuickBrownFoxStr))             = '2ba7f707ad5f187c412de3106583c3111d668de8');
  Assert(SHA1DigestToHexA(CalcHMAC_SHA1('Fundamentals', QuickBrownFoxStr)) = '8b52855bbd09842d4ac3e4ff4c574c1f87d63e0b');
  Assert(SHA1DigestToHexA(CalcHMAC_SHA1('Fundamentals', ''))               = '2208ce7279f26fcb90dbc1900019aa9b2b85456a');
  Assert(SHA1DigestToHexA(CalcHMAC_SHA1('Fundamentals', TenThousandA))     = '2f9cf91c82963b54fdbc0a26149be0c1f29746dc');
  Assert(SHA1DigestToHexA(CalcHMAC_SHA1(TenThousandA, TenThousandA))       = 'cf792cef5570b47f3e1272581a5af87e5715defd');

  Assert(SHA256DigestToHexA(CalcHMAC_SHA256('', ''))                           = 'b613679a0814d9ec772f95d778c35fc5ff1697c493715653c6c712144292c5ad');
  Assert(SHA256DigestToHexA(CalcHMAC_SHA256('', QuickBrownFoxStr))             = 'fb011e6154a19b9a4c767373c305275a5a69e8b68b0b4c9200c383dced19a416');
  Assert(SHA256DigestToHexA(CalcHMAC_SHA256('Fundamentals', QuickBrownFoxStr)) = '853b22d0aa389d8123452710b3d09ed7f0b5afe4114896bfeb8cfd8818963146');
  Assert(SHA256DigestToHexA(CalcHMAC_SHA256('Fundamentals', ''))               = '28659c86585404fe0e87255bc9a2244ff1d921d48f9c5f8b12b4b40a064a20a3');
  Assert(SHA256DigestToHexA(CalcHMAC_SHA256('Fundamentals', TenThousandA))     = '42347405bf2a459054bd95af2c48e070275d0d701ee62108b385a6e925c43163');
  Assert(SHA256DigestToHexA(CalcHMAC_SHA256(TenThousandA, TenThousandA))       = '6b7576a741bd2eb2c1c12017d5f4984108ce25a3a427a3d5f52ba93c0ac85e1f');

  Assert(SHA512DigestToHexA(CalcHMAC_SHA512('', ''))                           = 'b936cee86c9f87aa5d3c6f2e84cb5a4239a5fe50480a6ec66b70ab5b1f4ac6730c6c515421b327ec1d69402e53dfb49ad7381eb067b338fd7b0cb22247225d47');
  Assert(SHA512DigestToHexA(CalcHMAC_SHA512('', QuickBrownFoxStr))             = '1de78322e11d7f8f1035c12740f2b902353f6f4ac4233ae455baccdf9f37791566e790d5c7682aad5d3ceca2feff4d3f3fdfd9a140c82a66324e9442b8af71b6');
  Assert(SHA512DigestToHexA(CalcHMAC_SHA512('Fundamentals', QuickBrownFoxStr)) = 'f0352dff9b8984fb5fcfdd95de7f9db3df990723a2d909b99faf8cd4ccb9a5b1b840282c190ad41e521eb662512782bb9bf0fb81589cc101bfdc625914b1d8ed');
  Assert(SHA512DigestToHexA(CalcHMAC_SHA512('Fundamentals', ''))               = 'affa539a93acbb675e638aceb0456806564f19bec219c0b6c61d2cd675c37dc3cb7ef4f14831d9638b23d617e6e5c57f586f1804502e4b0b45027a1ae2b254e1');
  Assert(SHA512DigestToHexA(CalcHMAC_SHA512('Fundamentals', TenThousandA))     = 'd6e309c24d7fab8da9db0382f50051821df6966fb22121cebfbb2a6623e9849e05f3c9aeba1448353faffbc3b0e52e618efee36d22bf06b9117adc42b33892c2');
  Assert(SHA512DigestToHexA(CalcHMAC_SHA512(TenThousandA, TenThousandA))       = 'aacebd574e32713a306598b27583de5e253743dea5d3bd3ed7603fa97e098c9197b76584bf23bb21be242e2dd659626f70a9af68a29e0584890dc3a13480b4a3');

  // Test cases from RFC 2202
  Assert(MD5DigestToHexA(CalcHMAC_MD5('Jefe', 'what do ya want for nothing?')) = '750c783e6ab0b503eaa86e310a5db738');
  S := DupChar(16, $0B);
  Assert(MD5DigestToHexA(CalcHMAC_MD5(S, 'Hi There')) = '9294727a3638bb1c13f48ef8158bfc9d');
  S := DupChar(16, $AA);
  T := DupChar(50, $DD);
  Assert(MD5DigestToHexA(CalcHMAC_MD5(S, T)) = '56be34521d144c88dbb8c733f0e8b3f6');
  S := DupChar(80, $AA);
  Assert(MD5DigestToHexA(CalcHMAC_MD5(S, 'Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data')) = '6f630fad67cda0ee1fb1f562db3aa53e');

  Assert(SHA1DigestToHexA(CalcHMAC_SHA1('Jefe', 'what do ya want for nothing?')) = 'effcdf6ae5eb2fa2d27416d5f184df9c259a7c79');
  S := DupChar(20, $0B);
  Assert(SHA1DigestToHexA(CalcHMAC_SHA1(S, 'Hi There')) = 'b617318655057264e28bc0b6fb378c8ef146be00');
  S := DupChar(80, $AA);
  Assert(SHA1DigestToHexA(CalcHMAC_SHA1(S, 'Test Using Larger Than Block-Size Key - Hash Key First')) = 'aa4ae5e15272d00e95705637ce8a3b55ed402112');

  // Test cases from RFC 4231
  Assert(SHA256DigestToHexA(CalcHMAC_SHA256(#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b, 'Hi There')) = 'b0344c61d8db38535ca8afceaf0bf12b881dc200c9833da726e9376c2e32cff7');
  Assert(SHA256DigestToHexA(CalcHMAC_SHA256('Jefe', 'what do ya want for nothing?')) = '5bdcc146bf60754e6a042426089575c75a003f089d2739839dec58b964ec3843');
  S := DupChar(131, $aa);
  Assert(SHA256DigestToHexA(CalcHMAC_SHA256(S, 'This is a test using a larger than block-size key and a larger than block-size data. The key needs to be hashed before being used by the HMAC algorithm.')) = '9b09ffa71b942fcb27635fbcd5b0e944bfdc63644f0713938a7f51535c3a35e2');
  // see RFC 4231 truncated case --> Assert(SHA256DigestToHex(CalcHMAC_SHA256(#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c#$0c, 'Test With Truncation')) = 'a3b6167473100ee06e0c796c2955552b', 'CalcHMAC_SHA256');

  Assert(SHA512DigestToHexA(CalcHMAC_SHA512(#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b, 'Hi There')) = '87aa7cdea5ef619d4ff0b4241a1d6cb02379f4e2ce4ec2787ad0b30545e17cdedaa833b7d6b8a702038b274eaea3f4e4be9d914eeb61f1702e696c203a126854');
  Assert(SHA512DigestToHexA(CalcHMAC_SHA512('Jefe', 'what do ya want for nothing?')) = '164b7a7bfcf819e2e395fbe73b56e0a387bd64222e831fd610270cd7ea2505549758bf75c05a994a6d034f65f8f0e6fdcaeab1a34d4a6b4b636e070a38bce737');
  S := DupChar(131, $aa);
  Assert(SHA512DigestToHexA(CalcHMAC_SHA512(S, 'This is a test using a larger than block-size key and a larger than block-size data. The key needs to be hashed before being used by the HMAC algorithm.')) = 'e37b6a775dc87dbaa4dfa9f96e5e3ffddebd71f8867289865df5a32d20cdc944b6022cac3c4982b10d5eeb55c3e4de15134676fb6de0446065c97440fa8c6a58');

  // RipeMD160
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('')) = '9c1185a5c5e9fc54612808977ee8f548b2258d31');
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('a')) = '0bdc9d2d256b3ee9daae347be6f4dc835a467ffe');
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('abc')) = '8eb208f7e05d987a9b044a8e98c6b087f15a0bfc');
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('message digest')) = '5d0689ef49d2fae572b881b123a85ffa21595f36');
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('abcdefghijklmnopqrstuvwxyz')) = 'f71c27109c692c1b56bbdceb5b9d2865b3708dbc');
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq')) = '12a053384a9c0c88e405a06c27dcf49ada62eb2b');
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789')) = 'b0e20b6e3116640286ed3a87a5713079b21f5189');
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('12345678901234567890123456789012345678901234567890123456789012345678901234567890')) = '9b752e45573d4b39f4dbd3323cab82bf63326bfb');
  Assert(RipeMD160DigestToHexA(CalcRipeMD160(MillionA)) = '52783243c1697bdbe16d37f97f68f08325dc1528');
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('Fundamentals')) = '0b4dfcb4cf845bee8a53bad703e164b50e8199cc');
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789')) = 'e5ad452926b1b80e69a8c116748386ed920fd80e');          // 119 bytes
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890')) = '65aaa2d6fb77e63b02a56ed9eced04fe47da43c1');         // 120 bytes
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567')) = '5ef3b16743e09d8ac8410d03e72bb2fabb507749');  // 127 bytes
  Assert(RipeMD160DigestToHexA(CalcRipeMD160('12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678')) = 'e6841f68c8fe1a94cbb8b53d79056d139434b49a'); // 128 bytes
end;
{$ENDIF}



end.
