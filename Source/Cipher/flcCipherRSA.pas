{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcCipherRSA.pas                                         }
{   File version:     5.10                                                     }
{   Description:      RSA cipher routines                                      }
{                                                                              }
{   Copyright:        Copyright (c) 2008-2018, David J Butler                  }
{                     All rights reserved.                                     }
{                     This file is licensed under the BSD License.             }
{                     See http://www.opensource.org/licenses/bsd-license.php   }
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
{   2008/01/20  0.01  Initial development                                      }
{   2010/08/04  0.02  Update for changes to HugeWord                           }
{   2010/08/04  0.03  PKCS encoding                                            }
{   2010/08/09  0.04  OAEP encoding                                            }
{   2010/08/10  4.05  Test cases                                               }
{   2010/12/01  4.06  RSAPublicKeyAssignBuf                                    }
{   2015/03/31  4.07  Use RawByteString                                        }
{   2015/06/08  4.08  RSASignMessage and RSACheckSignature                     }
{   2016/01/09  5.09  Revised for Fundamentals 5.                              }
{   2018/07/17  5.10  Word32 changes.                                          }
{                                                                              }
{******************************************************************************}

{$INCLUDE flcCipher.inc}

unit flcCipherRSA;

interface

uses
  { System }
  SysUtils,
  { Fundamentals }
  flcStdTypes,
  flcHash,
  flcHugeInt;



{                                                                              }
{ RSA                                                                          }
{                                                                              }
type
  ERSA = class(Exception);

  TRSAPublicKey = record
    KeySize  : Integer;
    Modulus  : HugeWord;
    Exponent : HugeWord;
  end;

  TRSAPrivateKey = record
    KeySize        : Integer;
    Modulus        : HugeWord;
    Exponent       : HugeWord; // d
    PublicExponent : HugeWord; // e
    Prime1         : HugeWord; // p
    Prime2         : HugeWord; // q
    Phi            : HugeWord; // (p-1) * (q-1)
    Exponent1      : HugeWord; // d mod (p - 1)
    Exponent2      : HugeWord; // d mod (q - 1)
    Coefficient    : HugeWord; // (inverse of q) mod p
  end;

  TRSAMessage = HugeWord;

  TRSAEncryptionType = (
    rsaetPKCS1,
    rsaetOAEP);

procedure RSAPublicKeyInit(var Key: TRSAPublicKey);
procedure RSAPublicKeyFinalise(var Key: TRSAPublicKey);
procedure RSAPublicKeyAssign(var KeyD: TRSAPublicKey; const KeyS: TRSAPublicKey);
procedure RSAPublicKeyAssignHex(var Key: TRSAPublicKey;
          const KeySize: Integer;
          const HexMod, HexExp: String);
procedure RSAPublicKeyAssignBuf(var Key: TRSAPublicKey;
          const KeySize: Integer;
          const ModBuf; const ModBufSize: Integer;
          const ExpBuf; const ExpBufSize: Integer;
          const ReverseByteOrder: Boolean);
procedure RSAPublicKeyAssignBufStr(var Key: TRSAPublicKey;
          const KeySize: Integer;
          const ModBuf, ExpBuf: RawByteString);

procedure RSAPrivateKeyInit(var Key: TRSAPrivateKey);
procedure RSAPrivateKeyFinalise(var Key: TRSAPrivateKey);
procedure RSAPrivateKeyAssign(var KeyD: TRSAPrivateKey; const KeyS: TRSAPrivateKey);
procedure RSAPrivateKeyAssignHex(var Key: TRSAPrivateKey;
          const KeySize: Integer;
          const HexMod, HexExp: RawByteString);
procedure RSAPrivateKeyAssignBuf(var Key: TRSAPrivateKey;
          const KeySize: Integer;
          const ModBuf; const ModBufSize: Integer;
          const ExpBuf; const ExpBufSize: Integer;
          const ReverseByteOrder: Boolean);
procedure RSAPrivateKeyAssignBufStr(var Key: TRSAPrivateKey;
          const KeySize: Integer;
          const ModBuf, ExpBuf: RawByteString);

procedure RSAGenerateKeys(const KeySize: Integer;
          var PrivateKey: TRSAPrivateKey;
          var PublicKey: TRSAPublicKey);

function  RSACipherMessageBufSize(const KeySize: Integer): Integer;

procedure RSAEncodeMessagePKCS1(
          const KeySize: Integer;
          const Buf; const BufSize: Integer;
          var EncodedMessage: TRSAMessage);
procedure RSAEncodeMessageOAEP(
          const KeySize: Integer;
          const Buf; const BufSize: Integer;
          var EncodedMessage: TRSAMessage);
procedure RSAEncryptMessage(
          const PublicKey: TRSAPublicKey;
          const PlainMessage: TRSAMessage;
          var CipherMessage: TRSAMessage);
function  RSACipherMessageToBuf(
          const KeySize: Integer;
          const CipherMessage: TRSAMessage;
          var CipherBuf; const CipherBufSize: Integer): Integer;

function  RSAEncrypt(
          const EncryptionType: TRSAEncryptionType;
          const PublicKey: TRSAPublicKey;
          const PlainBuf; const PlainBufSize: Integer;
          var CipherBuf; const CipherBufSize: Integer): Integer;
function  RSAEncryptStr(
          const EncryptionType: TRSAEncryptionType;
          const PublicKey: TRSAPublicKey;
          const Plain: RawByteString): RawByteString;

procedure RSACipherBufToMessage(
          const KeySize: Integer;
          const CipherBuf; const CipherBufSize: Integer;
          var CipherMessage: TRSAMessage);
procedure RSADecryptMessage(
          const PrivateKey: TRSAPrivateKey;
          const CipherMessage: TRSAMessage;
          var EncodedMessage: TRSAMessage);
function  RSADecodeMessagePKCS1(
          const KeySize: Integer;
          const EncodedMessage: HugeWord;
          var Buf; const BufSize: Integer): Integer;
function  RSADecodeMessageOAEP(
          const KeySize: Integer;
          const EncodedMessage: HugeWord;
          var Buf; const BufSize: Integer): Integer;

function  RSADecrypt(
          const EncryptionType: TRSAEncryptionType;
          const PrivateKey: TRSAPrivateKey;
          const CipherBuf; const CipherBufSize: Integer;
          var PlainBuf; const PlainBufSize: Integer): Integer;
function  RSADecryptStr(
          const EncryptionType: TRSAEncryptionType;
          const PrivateKey: TRSAPrivateKey;
          const Cipher: RawByteString): RawByteString;

function  RSASignMessage(
          const PrivateKey: TRSAPrivateKey;
          const MessageHashBuf; const MessageHashBufSize: Integer;
          var SignatureBuf; const SignatureBufSize: Integer): Integer;
function  RSACheckSignature(
          const PublicKey: TRSAPublicKey;
          const MessageHashBuf; const MessageHashBufSize: Integer;
          const SignatureBuf; const SignatureBufSize: Integer): Boolean;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF CIPHER_TEST}
procedure Test;
{$ENDIF}
{$IFDEF OS_WIN}
{$IFDEF CIPHER_PROFILE}
procedure Profile;
{$ENDIF}
{$ENDIF}



implementation

uses
  { System }
  {$IFDEF OS_WIN}
  {$IFDEF CIPHER_PROFILE}
  Windows,
  {$ENDIF}
  {$ENDIF}
  { Fundamentals }
  flcUtils,
  flcRandom;



{                                                                              }
{ SecureClear                                                                  }
{                                                                              }
procedure SecureClearHugeWord(var A: HugeWord);
begin
  if (A.Alloc = 0) or not Assigned(A.Data) then
    exit;
  SecureClear(A.Data^, A.Alloc * HugeWordElementSize);
end;

procedure SecureHugeWordFinalise(var A: HugeWord);
begin
  SecureClearHugeWord(A);
  HugeWordFinalise(A);
end;



{                                                                              }
{ RSA                                                                          }
{                                                                              }
const
  SRSAInvalidKeySize        = 'Invalid RSA key size';
  SRSAInvalidBufferSize     = 'Invalid RSA buffer size';
  SRSAInvalidMessage        = 'Invalid RSA message';
  SRSAMessageTooLong        = 'RSA message too long';
  SRSAInvalidEncryptionType = 'Invalid RSA encryption type';

procedure RSAPublicKeyInit(var Key: TRSAPublicKey);
begin
  Key.KeySize := 0;
  HugeWordInit(Key.Modulus);
  HugeWordInit(Key.Exponent);
end;

procedure RSAPublicKeyFinalise(var Key: TRSAPublicKey);
begin
  SecureHugeWordFinalise(Key.Exponent);
  SecureHugeWordFinalise(Key.Modulus);
end;

procedure RSAPublicKeyAssign(var KeyD: TRSAPublicKey; const KeyS: TRSAPublicKey);
begin
  KeyD.KeySize := KeyS.KeySize;
  HugeWordAssign(KeyD.Modulus, KeyS.Modulus);
  HugeWordAssign(KeyD.Exponent, KeyS.Exponent);
end;

procedure RSAPublicKeyAssignHex(var Key: TRSAPublicKey;
          const KeySize: Integer;
          const HexMod, HexExp: String);
begin
  if (KeySize = 0) or
     (KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  Key.KeySize := KeySize;
  HexToHugeWord(HexMod, Key.Modulus);
  HexToHugeWord(HexExp, Key.Exponent);
  if (HugeWordGetBitCount(Key.Modulus) > KeySize) or
     (HugeWordGetBitCount(Key.Exponent) > KeySize) then
    raise ERSA.Create(SRSAInvalidKeySize);
end;

procedure RSAPublicKeyAssignBuf(var Key: TRSAPublicKey;
          const KeySize: Integer;
          const ModBuf; const ModBufSize: Integer;
          const ExpBuf; const ExpBufSize: Integer;
          const ReverseByteOrder: Boolean);
begin
  if (KeySize = 0) or
     (KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  Key.KeySize := KeySize;
  HugeWordAssignBuf(Key.Modulus, ModBuf, ModBufSize, ReverseByteOrder);
  HugeWordAssignBuf(Key.Exponent, ExpBuf, ExpBufSize, ReverseByteOrder);
end;

procedure RSAPublicKeyAssignBufStr(var Key: TRSAPublicKey;
          const KeySize: Integer;
          const ModBuf, ExpBuf: RawByteString);
begin
  RSAPublicKeyAssignBuf(Key, KeySize, PByteChar(ModBuf)^, Length(ModBuf),
      PByteChar(ExpBuf)^, Length(ExpBuf), True);
end;

procedure RSAPrivateKeyInit(var Key: TRSAPrivateKey);
begin
  Key.KeySize := 0;
  HugeWordInit(Key.Modulus);
  HugeWordInit(Key.Exponent);
  HugeWordInit(Key.PublicExponent);
  HugeWordInit(Key.Prime1);
  HugeWordInit(Key.Prime2);
  HugeWordInit(Key.Phi);
  HugeWordInit(Key.Exponent1);
  HugeWordInit(Key.Exponent2);
  HugeWordInit(Key.Coefficient);
end;

procedure RSAPrivateKeyFinalise(var Key: TRSAPrivateKey);
begin
  SecureHugeWordFinalise(Key.Coefficient);
  SecureHugeWordFinalise(Key.Exponent2);
  SecureHugeWordFinalise(Key.Exponent1);
  SecureHugeWordFinalise(Key.Phi);
  SecureHugeWordFinalise(Key.Prime2);
  SecureHugeWordFinalise(Key.Prime1);
  SecureHugeWordFinalise(Key.PublicExponent);
  SecureHugeWordFinalise(Key.Exponent);
  SecureHugeWordFinalise(Key.Modulus);
end;

procedure RSAPrivateKeyAssign(var KeyD: TRSAPrivateKey; const KeyS: TRSAPrivateKey);
begin
  KeyD.KeySize := KeyS.KeySize;
  HugeWordAssign(KeyD.Modulus, KeyS.Modulus);
  HugeWordAssign(KeyD.Exponent, KeyS.Exponent);
  HugeWordAssign(KeyD.PublicExponent, KeyS.PublicExponent);
  HugeWordAssign(KeyD.Prime1, KeyS.Prime1);
  HugeWordAssign(KeyD.Prime2, KeyS.Prime2);
  HugeWordAssign(KeyD.Phi, KeyS.Phi);
  HugeWordAssign(KeyD.Exponent1, KeyS.Exponent1);
  HugeWordAssign(KeyD.Exponent2, KeyS.Exponent2);
  HugeWordAssign(KeyD.Coefficient, KeyS.Coefficient);
end;

procedure RSAPrivateKeyAssignHex(var Key: TRSAPrivateKey;
          const KeySize: Integer;
          const HexMod, HexExp: RawByteString);
begin
  if (KeySize = 0) or
     (KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  Key.KeySize := KeySize;
  HexToHugeWordB(HexMod, Key.Modulus);
  HexToHugeWordB(HexExp, Key.Exponent);
  if (HugeWordGetBitCount(Key.Modulus) > KeySize) or
     (HugeWordGetBitCount(Key.Exponent) > KeySize) then
    raise ERSA.Create(SRSAInvalidKeySize);
end;

procedure RSAPrivateKeyAssignBuf(var Key: TRSAPrivateKey;
          const KeySize: Integer;
          const ModBuf; const ModBufSize: Integer;
          const ExpBuf; const ExpBufSize: Integer;
          const ReverseByteOrder: Boolean);
begin
  if (KeySize = 0) or
     (KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  Key.KeySize := KeySize;
  HugeWordAssignBuf(Key.Modulus, ModBuf, ModBufSize, ReverseByteOrder);
  HugeWordAssignBuf(Key.Exponent, ExpBuf, ExpBufSize, ReverseByteOrder);
  if (HugeWordGetBitCount(Key.Modulus) > KeySize) or
     (HugeWordGetBitCount(Key.Exponent) > KeySize) then
    raise ERSA.Create(SRSAInvalidKeySize);
end;

procedure RSAPrivateKeyAssignBufStr(var Key: TRSAPrivateKey;
          const KeySize: Integer;
          const ModBuf, ExpBuf: RawByteString);
begin
  RSAPrivateKeyAssignBuf(Key, KeySize, PByteChar(ModBuf)^, Length(ModBuf),
      PByteChar(ExpBuf)^, Length(ExpBuf), True);
end;

{ RSA Key Random Number                                                        }
{   Returns a random number for use in RSA key generation.                     }
procedure RSAKeyRandomNumber(const Bits: Integer; var A: HugeWord);
var L : Integer;
begin
  Assert(HugeWordElementBits >= 32);
  if (Bits <= 0) or
     (Bits mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  // generate non-zero random number
  L := Bits div HugeWordElementBits;
  repeat
    HugeWordRandom(A, L);
  until not HugeWordIsZero(A);
  // set least significant bit to make odd
  HugeWordSetBit(A, 0);
  // set one of the 15 most significant bits to ensure product is Bits * 2 large
  // and this number allocates requested number of Bits in the HugeWord structure
  HugeWordSetBit(A, Bits - RandomUniform(15) - 1);
  // validate
  Assert(HugeWordIsOdd(A));
  Assert(HugeWordGetBitCount(A) = Bits);
end;

{ RSA Key Random Prime1                                                        }
{   Returns the first of two random primes for use in RSA key generation.      }
procedure RSAKeyRandomPrime1(const Bits: Integer; var P: HugeWord);
begin
  repeat
    RSAKeyRandomNumber(Bits, P);
    // set the 2 most significant bits to:
    // i) ensure that first prime is large enough so that there are
    //    enough smaller primes to choose from for the second prime;
    // ii) the product is large enough
    HugeWordSetBit(P, Bits - 1);
    HugeWordSetBit(P, Bits - 2);
  until HugeWordIsPrime(P) <> pNotPrime;
end;

{ RSA Key Random Prime2                                                        }
{   Returns the second of two random primes for use in RSA key generation.     }
procedure RSAKeyRandomPrime2(const Bits: Integer; const P: HugeWord; var Q: HugeWord);
var L : HugeWord;
    C : Integer;
    N : Word32;
begin
  C := Bits div HugeWordElementBits;
  HugeWordInit(L);
  try
    repeat
      repeat
        repeat
          repeat
            // choose a new random number with every iteration to maintain
            // uniform distribution
            RSAKeyRandomNumber(Bits, Q);
            // "Numbers p and q should not be 'too close', lest the Fermat factorization for n be successful,
            // if p - q, for instance is less than 2n^1/4 (which for even small 1024-bit values of n is 3×10^77)
            // solving for p and q is trivial"
            HugeWordAssignOne(L);
            HugeWordShl(L, (Bits div 4) + 1);
            HugeWordAdd(L, Q);
          until HugeWordCompare(P, L) > 0;
          // ensure p > 2q - prevents certain attacks
          HugeWordAssign(L, Q);
          HugeWordShl1(L);
        until HugeWordCompare(P, L) > 0;
        // ensure N = P * Q large enough
        N := Byte(HugeWordGetElement(P, C - 1) shr (HugeWordElementBits - 8)) *
             Byte(HugeWordGetElement(Q, C - 1) shr (HugeWordElementBits - 8));
      until N >= $0100;
      // ensure prime
    until HugeWordIsPrime(Q) <> pNotPrime;
  finally
    SecureHugeWordFinalise(L);
  end;
end;

{ RSA Key Random Prime Pair                                                    }
{   Returns a pair of random primes for use in RSA key generation.             }
procedure RSAKeyRandomPrimePair(const Bits: Integer; var P, Q: HugeWord);
begin
  RSAKeyRandomPrime1(Bits, P);
  RSAKeyRandomPrime2(Bits, P, Q);
end;

{ RSA Generate Keys                                                            }
{   Returns a randomly generated PrivateKey/PublicKey pair.                    }
const
  RSAExpCount = 7;
  RSAExp : array[0..RSAExpCount - 1] of Integer = (3, 5, 7, 11, 17, 257, 65537);

procedure RSAGenerateKeys(const KeySize: Integer;
          var PrivateKey: TRSAPrivateKey;
          var PublicKey: TRSAPublicKey);
var Bits : Integer;
    P, Q, N, E, D, G : HugeWord;
    F, T : Word32;
    R : Boolean;
begin
  if (KeySize <= 0) or
     (KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  HugeWordInit(P);
  HugeWordInit(Q);
  HugeWordInit(N);
  HugeWordInit(E);
  HugeWordInit(D);
  HugeWordInit(G);
  try
    Bits := KeySize div 2;
    repeat
      R := False;
      repeat
        // generate random prime values for p and q
        RSAKeyRandomPrimePair(Bits, P, Q);
        // calculate n = p * q
        HugeWordMultiply(N, P, Q);
        Assert(HugeWordGetBitCount(N) = KeySize);
        // save private key primes
        HugeWordAssign(PrivateKey.Prime1, P);
        HugeWordAssign(PrivateKey.Prime2, Q);
        // calculate phi = (p-1) * (q-1)
        HugeWordDec(P);
        HugeWordDec(Q);
        HugeWordMultiply(PrivateKey.Phi, P, Q);
        // choose e such that 1 < e < phi and gcd(e, phi) = 1
        // try 3 values for e before giving up
        T := 0;
        repeat
          Inc(T);
          F := RSAExp[RandomUniform(RSAExpCount)];
          HugeWordAssignWord32(E, F);
          HugeWordGCD(E, PrivateKey.Phi, G);
          if HugeWordIsOne(G) then
            R := True;
        until R or (T = 3);
      until R;
      // d = inverse(e) mod phi
    until HugeWordModInv(E, PrivateKey.Phi, D);
    // populate PrivateKey and PublicKey
    PrivateKey.KeySize := KeySize;
    HugeWordMod(D, P, PrivateKey.Exponent1); // d mod (p - 1)
    HugeWordMod(D, Q, PrivateKey.Exponent2); // d mod (q - 1)
    HugeWordAssign(PrivateKey.Modulus, N);
    HugeWordAssign(PrivateKey.Exponent, D);
    HugeWordAssign(PrivateKey.PublicExponent, E);
    PublicKey.KeySize := KeySize;
    HugeWordAssign(PublicKey.Modulus, N);
    HugeWordAssign(PublicKey.Exponent, E);
  finally
    SecureHugeWordFinalise(G);
    SecureHugeWordFinalise(D);
    SecureHugeWordFinalise(E);
    SecureHugeWordFinalise(N);
    SecureHugeWordFinalise(Q);
    SecureHugeWordFinalise(P);
  end;
end;

{ RSA Cipher Message Buf Size                                                  }
function RSACipherMessageBufSize(const KeySize: Integer): Integer;
begin
  Result := KeySize div 8;
end;

{ RSA Encode Message PKCS1                                                     }
{   Encodes a message buffer as a RSA message.                                 }
{   Uses EME-PKCS1-v1_5 encoding.                                              }
{   EM = 0x00 || 0x02 || PS || 0x00 || M                                       }
procedure RSAEncodeMessagePKCS1(
          const KeySize: Integer;
          const Buf; const BufSize: Integer;
          var EncodedMessage: TRSAMessage);
var N, L, I, C : Integer;
    P, Q : PByte;
begin
  // validate
  if (KeySize <= 0) or
     (KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  // message size
  N := KeySize div 8; // number of bytes in key (max message size)
  C := BufSize;
  if C < 0 then
    C := 0;
  L := N - 3 - C;     // number of padding bytes in PS
  if L < 8 then
    raise ERSA.Create(SRSAMessageTooLong);
  HugeWordSetSize(EncodedMessage, N div HugeWordElementSize);
  // 0x00
  P := EncodedMessage.Data;
  Inc(P, N - 1);
  P^ := 0;
  // 0x02
  Dec(P);
  P^ := 2;
  // PS
  Dec(P);
  for I := 0 to L - 1 do
    begin
      P^ := RandomByteNonZero;
      Dec(P);
    end;
  // 0x00
  P^ := 0;
  Dec(P);
  // M
  if C = 0 then
    exit;
  Q := @Buf;
  for I := 0 to C - 1 do
    begin
      P^ := Q^;
      Dec(P);
      Inc(Q);
    end;
end;

{ RSA OAEP MGF1                                                                }
{   Mask generation function (MGF) function for OAEP encoding.                 }
{   This implements MGF1 from PKCS1v2-1 using SHA1 hashing.                    }
{                                                                              }
{   MGF1 (mgfSeed, maskLen)                                                    }
{   mgfSeed = seed from which mask is generated, an octet string               }
{   maskLen = intended length in octets of the mask, at most 2^32 * hLen       }
{   Hash = hash function                                                       }
{   hLen = length in octets of the hash function output                        }
{   mask = mask, an octet string of length maskLen                             }
{   Steps:                                                                     }
{   1. If maskLen > 2^32 * hLen, output “mask too long” and stop.              }
{   2. Let T be the empty octet string.                                        }
{   3. For counter from 0 to [ maskLen / hLen ] – 1, do the following:         }
{     a. Convert counter to an octet string C of length 4 octets               }
{       C = I2OSP (counter, 4)                                                 }
{     b. Concatenate the hash of the seed mgfSeed and C to the octet string T  }
{       T = T || Hash (mgfSeed || C)                                           }
{   4. Output the leading maskLen octets of T as the octet string mask.        }
procedure RSAOAEPMGF1(
          const SeedBuf; const SeedBufSize: Integer;
          var MaskBuf; const MaskBufSize: Integer);
var N, I, C, D, J : Integer;
    HashStr : RawByteString;
    HashSHA1 : T160BitDigest;
    P, Q, R : PByte;
const
  hLen = SizeOf(T160BitDigest);
begin
  Assert(SeedBufSize > 0);
  Assert(MaskBufSize > 0);

  SetLength(HashStr, SeedBufSize + 4);
  N := (MaskBufSize + hLen - 1) div hLen;
  C := MaskBufSize;
  P := @MaskBuf;
  for I := 0 to N - 1 do
    begin
      // HashStr = mgfSeed || C
      Move(SeedBuf, HashStr[1], SeedBufSize);
      R := @HashStr[SeedBufSize + 1];
      Q := @I;
      Inc(Q, 3);
      for J := 0 to 3 do
        begin
          R^ := Q^;
          Inc(R);
          Dec(Q);
        end;
      // HashSHA1 = Hash (mgfSeed || C)
      HashSHA1 := CalcSHA1(HashStr);
      // T = T || Hash (mgfSeed || C)
      D := C;
      if D > hLen then
        D := hLen;
      Move(HashSHA1, P^, D);
      Inc(P, D);
      Dec(C, D);
    end;
end;

{ RSA XOR Buf                                                                  }
procedure RSAXORBuf(
          var Buf; const BufSize: Integer;
          const MaskBuf; const MaskSize: Integer);
var N, I, J, C : Integer;
    P, Q : PByte;
begin
  Assert(MaskSize > 0);

  C := BufSize;
  if C < 0 then
    C := 0;
  if C = 0 then
    exit;
  N := (C + MaskSize - 1) div MaskSize;
  P := @Buf;
  for I := 0 to N - 1 do
    begin
      Q := @MaskBuf;
      for J := 0 to MaskSize - 1 do
        begin
          P^ := P^ xor Q^;
          Inc(P);
          Inc(Q);
          Dec(C);
          if C = 0 then
            exit;
        end;
    end;
end;

{ RSA Encode Message OAEP                                                      }
{   Encodes a message buffer as a RSA message.                                 }
{   Uses EME-OAEP encoding using SHA1 hashing.                                 }
{                                                                              }
{   EME-OAEP-Encode(M, P,emLen)                                                }
{   M = message to be encoded, length at most emLen - 2 - 2 * hLen             }
{   mLen = length in octets of the message M                                   }
{   hLen = length in octets of the hash function output                        }
{   PS = emLen - mLen - 2 * hLen - 2 zero octets                               }
{   P = encoding parameters, an octet string (default empty)                   }
{   pHash = Hash(P), an octet string of length hLen                            }
{   DB = pHash || PS || 01 || M                                                }
{   seed = random octet string of length hLen                                  }
{   dbMask = MGF(seed, emLen - hLen)                                           }
{   maskedDB = DB x dbMask                                                     }
{   seedMask = MGF(maskedDB, hLen)                                             }
{   maskedSeed = seed x seedMask                                               }
{   EM = 0x00 || maskedSeed || maskedDB                                        }
const
  RSAOAEPHashBufSize = SizeOf(T160BitDigest);

{.DEFINE DEBUG_RSAFixedSeed}
procedure RSAEncodeMessageOAEP(
          const KeySize: Integer;
          const Buf; const BufSize: Integer;
          var EncodedMessage: TRSAMessage);
var mLen, emLen, psLen, dbMaskLen, dbLen, I : Integer;
    seed, PS, dbMask, pHash, DB, maskedDB, seedMask, maskedSeed, EM : RawByteString;
    P, Q : PByte;
const
  hLen = RSAOAEPHashBufSize;
begin
  // validate
  if (KeySize <= 0) or
     (KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  // message size
  emLen := KeySize div 8; // number of bytes in key (max message size)
  mLen := BufSize;
  if mLen < 0 then
    mLen := 0;
  if mLen > emLen - 2 * hLen - 2 then
    raise ERSA.Create(SRSAMessageTooLong);
  HugeWordSetSize(EncodedMessage, emLen div HugeWordElementSize);
  // pHash = Hash(P), an octet string of length hLen
  // SetLength(pHash, hLen);
  // HashP := CalcSHA1('');
  // Move(HashP, pHash[1], hLen);
  pHash := RawByteString(
           #$DA#$39#$A3#$EE#$5E#$6B#$4B#$0D#$32#$55 +
           #$BF#$EF#$95#$60#$18#$90#$AF#$D8#$07#$09);
  // seed = random octet string of length hLen
  {$IFDEF DEBUG_RSAFixedSeed}
  seed := RawByteString(
          #$aa#$fd#$12#$f6#$59#$ca#$e6#$34#$89#$b4 +
          #$79#$e5#$07#$6d#$de#$c2#$f0#$6c#$b5#$8f);
  {$ELSE}
  SetLength(seed, hLen);
  for I := 1 to hLen do
    seed[I] := AnsiChar(RandomByteNonZero);
  {$ENDIF}
  // PS = emLen - mLen - 2 * hLen - 2 zero octets
  psLen := emLen - mLen - 2 * hLen - 2;
  SetLength(PS, psLen);
  for I := 1 to psLen do
    PS[I] := #0;
  // dbMask = MGF(seed, emLen - hLen - 1)
  dbMaskLen := emLen - hLen - 1;
  SetLength(dbMask, dbMaskLen);
  RSAOAEPMGF1(seed[1], hLen, dbMask[1], dbMaskLen);
  // DB = pHash || PS || 01 || M
  dbLen := hLen + psLen + 1 + mLen;
  SetLength(DB, dbLen);
  P := @DB[1];
  Move(pHash[1], P^, hLen);
  Inc(P, hLen);
  Move(PS[1], P^, psLen);
  Inc(P, psLen);
  P^ := 1;
  Inc(P);
  Move(Buf, P^, mLen);
  // maskedDB = DB x dbMask
  SetLength(maskedDB, dbLen);
  Move(DB[1], maskedDB[1], dbLen);
  RSAXORBuf(maskedDB[1], dbLen, dbMask[1], dbMaskLen);
  // seedMask = MGF(maskedDB, hLen)
  SetLength(seedMask, hLen);
  RSAOAEPMGF1(maskedDB[1], dbLen, seedMask[1], hLen);
  // maskedSeed = seed x seedMask
  SetLength(maskedSeed, hLen);
  Move(seed[1], maskedSeed[1], hLen);
  RSAXORBuf(maskedSeed[1], hLen, seedMask[1], hLen);
  // EM = 0x00 || maskedSeed || maskedDB
  SetLength(EM, emLen);
  P := @EM[1];
  P^ := 0;
  Inc(P);
  Move(maskedSeed[1], P^, hLen);
  Inc(P, hLen);
  Move(maskedDB[1], P^, dbLen);
  // populate message
  P := EncodedMessage.Data;
  Inc(P, emLen - 1);
  Q := @EM[1];
  for I := 0 to emLen - 1 do
    begin
      P^ := Q^;
      Dec(P);
      Inc(Q);
    end;
end;

{ RSA Encrypt Message                                                          }
procedure RSAEncryptMessage(
          const PublicKey: TRSAPublicKey;
          const PlainMessage: TRSAMessage;
          var CipherMessage: TRSAMessage);
begin
  // validate
  if (PublicKey.KeySize <= 0) or
     (PublicKey.KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  if HugeWordCompare(PlainMessage, PublicKey.Modulus) >= 0 then
    raise ERSA.Create(SRSAInvalidMessage);
  Assert(HugeWordGetBitCount(PlainMessage) = PublicKey.KeySize);
  // encrypt
  HugeWordPowerAndMod(CipherMessage, PlainMessage, PublicKey.Exponent, PublicKey.Modulus);
  Assert(HugeWordGetBitCount(CipherMessage) = PublicKey.KeySize);
end;

{ RSA Cipher Message To Buf                                                    }
{   Copies cipher message to buffer.                                           }
{   Returns the buffer size required for the message.                          }
function RSACipherMessageToBuf(
         const KeySize: Integer;
         const CipherMessage: TRSAMessage;
         var CipherBuf; const CipherBufSize: Integer): Integer;
var L, I : Integer;
    P, Q : PByte;
begin
  if HugeWordGetBitCount(CipherMessage) <> KeySize then
    raise ERSA.Create(SRSAInvalidMessage);
  L := KeySize div 8;
  Result := L;
  if CipherBufSize <= 0 then
    exit;
  P := CipherMessage.Data;
  Inc(P, L - 1);
  Q := @CipherBuf;
  for I := 0 to L - 1 do
    begin
      if I >= CipherBufSize then
        exit;
      Q^ := P^;
      Inc(Q);
      Dec(P);
    end;
end;

{ RSA Encrypt                                                                  }
function RSAEncrypt(
         const EncryptionType: TRSAEncryptionType;
         const PublicKey: TRSAPublicKey;
         const PlainBuf; const PlainBufSize: Integer;
         var CipherBuf; const CipherBufSize: Integer): Integer;
var EncodedMsg, CipherMsg : HugeWord;
begin
  // validate
  if (PublicKey.KeySize <= 0) or
     (PublicKey.KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  if (PlainBufSize < 0) or
     (CipherBufSize <= 0) then
    raise ERSA.Create(SRSAInvalidBufferSize);
  // encrypt
  HugeWordInit(EncodedMsg);
  HugeWordInit(CipherMsg);
  try
    case EncryptionType of
      rsaetPKCS1 : RSAEncodeMessagePKCS1(PublicKey.KeySize, PlainBuf, PlainBufSize, EncodedMsg);
      rsaetOAEP  : RSAEncodeMessageOAEP(PublicKey.KeySize, PlainBuf, PlainBufSize, EncodedMsg);
    else
      raise ERSA.Create(SRSAInvalidEncryptionType);
    end;
    RSAEncryptMessage(PublicKey, EncodedMsg, CipherMsg);
    Result := RSACipherMessageToBuf(PublicKey.KeySize, CipherMsg, CipherBuf, CipherBufSize);
    if Result > CipherBufSize then
      raise ERSA.Create(SRSAInvalidBufferSize);
  finally
    SecureHugeWordFinalise(CipherMsg);
    SecureHugeWordFinalise(EncodedMsg);
  end;
end;

{ RSA Encrypt Str                                                              }
function RSAEncryptStr(
         const EncryptionType: TRSAEncryptionType;
         const PublicKey: TRSAPublicKey;
         const Plain: RawByteString): RawByteString;
var L : Integer;
begin
  L := RSACipherMessageBufSize(PublicKey.KeySize);
  SetLength(Result, L);
  L := RSAEncrypt(EncryptionType, PublicKey, PByteChar(Plain)^, Length(Plain),
      PByteChar(Result)^, L);
  SetLength(Result, L);
end;

{ RSA Cipher Buf To Message                                                    }
procedure RSACipherBufToMessage(
          const KeySize: Integer;
          const CipherBuf; const CipherBufSize: Integer;
          var CipherMessage: TRSAMessage);
var L, I : Integer;
    P, Q : PByte;
begin
  // validate
  if (KeySize <= 0) or
     (KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  // message size
  L := KeySize div 8;
  if CipherBufSize <> L then
    raise ERSA.Create(SRSAInvalidBufferSize);
  HugeWordSetSize(CipherMessage, L div HugeWordElementSize);
  // move data
  P := CipherMessage.Data;
  Inc(P, L - 1);
  Q := @CipherBuf;
  for I := 0 to L - 1 do
    begin
      P^ := Q^;
      Dec(P);
      Inc(Q);
    end;
end;

{ RSA Decrypt Message                                                          }
{   Decrypts using m = c^d mod n                                               }
procedure RSADecryptMessage(
          const PrivateKey: TRSAPrivateKey;
          const CipherMessage: TRSAMessage;
          var EncodedMessage: TRSAMessage);
begin
  // validate
  if (PrivateKey.KeySize <= 0) or
     (PrivateKey.KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  if HugeWordGetBitCount(CipherMessage) <> PrivateKey.KeySize then
    raise ERSA.Create(SRSAInvalidMessage);
  // decrypt
  HugeWordPowerAndMod(EncodedMessage, CipherMessage, PrivateKey.Exponent, PrivateKey.Modulus);
end;

{
Alternative decryption algorithm (works with smaller factors):
if the second form (p, q, dP, dQ,qInv) of K is used:
Let m1 = c^dP mod p
Let m2 = c^dQ mod q
Let h = (m1 - m2) . qInv mod p
Let m = m2 + q . h
}
procedure RSADecryptMessage2(
          const PrivateKey: TRSAPrivateKey;
          const CipherMessage: TRSAMessage;
          var EncodedMessage: TRSAMessage);
var A, M1, M2, H, M : HugeWord;
begin
  HugeWordInit(A);
  HugeWordInit(M1);
  HugeWordInit(M2);
  HugeWordInit(H);
  try
    // m1 = c^dP mod p
    HugeWordPowerAndMod(M1, CipherMessage, PrivateKey.Exponent1, PrivateKey.Prime1);
    // m2 = c^dQ mod q
    HugeWordPowerAndMod(M2, CipherMessage, PrivateKey.Exponent2, PrivateKey.Prime2);
    // h = (m1 - m2) . qInv mod p
    HugeWordAssign(H, M1);
    HugeWordSubtract(H, M2);
    HugeWordMultiply(H, H, PrivateKey.Coefficient);
    // m = m2 + q . h
    HugeWordMultiply(M, PrivateKey.Prime2, H);
    HugeWordAdd(M, M2);
  finally
    SecureHugeWordFinalise(H);
    SecureHugeWordFinalise(M2);
    SecureHugeWordFinalise(M1);
    SecureHugeWordFinalise(A);
  end;
end;

{ RSA Decode Message PKCS1                                                     }
{   Decodes message previously encoded with RSAEncodeMessagePKCS1.             }
{   Uses EME-PKCS1-v1_5 encoding.                                              }
{   EM = 0x00 || 0x02 || PS || 0x00 || M                                       }
{   Returns number of bytes needed to decode message.                          }
function  RSADecodeMessagePKCS1(
          const KeySize: Integer;
          const EncodedMessage: HugeWord;
          var Buf; const BufSize: Integer): Integer;
var L, I : Integer;
    P, Q : PByte;
begin
  // validate
  if (KeySize <= 0) or
     (KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  if HugeWordGetBitCount(EncodedMessage) <> KeySize then
    raise ERSA.Create(SRSAInvalidMessage);
  // decode
  L := HugeWordGetSize(EncodedMessage) * HugeWordElementSize;
  if L < 3 then
    raise ERSA.Create(SRSAInvalidMessage);
  // 0x00
  P := EncodedMessage.Data;
  Inc(P, L - 1);
  if P^ <> 0 then
    raise ERSA.Create(SRSAInvalidMessage);
  // 0x02
  Dec(P);
  if P^ <> 2 then
    raise ERSA.Create(SRSAInvalidMessage);
  Dec(L, 2);
  // PS
  if L < 9 then
    raise ERSA.Create(SRSAInvalidMessage);
  repeat
    Dec(P);
    Dec(L);
  until (L = 0) or (P^ = 0);
  // 0x00
  if P^ <> 0 then
    raise ERSA.Create(SRSAInvalidMessage);
  // M
  Result := L;
  if L = 0 then
    exit;
  if BufSize = 0 then
    exit;
  Dec(P);
  Q := @Buf;
  for I := 0 to L - 1 do
    begin
      Q^ := P^;
      if I >= BufSize then
        exit;
      Dec(P);
      Inc(Q);
    end;
end;

{ RSA Decode Message OAEP                                                      }
{   Decodes message previously encoded with RSAEncodeMessageOAEP.              }
{   Uses EME-OAEP encoding using SHA1 hashing.                                 }
{                                                                              }
{   EME-OAEP-Encode(M, P,emLen)                                                }
{   M = message to be encoded, length at most emLen - 2 - 2h * Len             }
{   mLen = length in octets of the message M                                   }
{   hLen = length in octets of the hash function output                        }
{   PS = emLen - mLen - 2 * hLen - 2 zero octets                               }
{   P = encoding parameters, an octet string (default empty)                   }
{   pHash = Hash(P), an octet string of length hLen                            }
{   DB = pHash || PS || 01 || M                                                }
{   seed = random octet string of length hLen                                  }
{   dbMask = MGF(seed, emLen - hLen)                                           }
{   maskedDB = DB x dbMask                                                     }
{   seedMask = MGF(maskedDB, hLen)                                             }
{   maskedSeed = seed x seedMask                                               }
{   EM = 0x00 || maskedSeed || maskedDB                                        }
function  RSADecodeMessageOAEP(
          const KeySize: Integer;
          const EncodedMessage: HugeWord;
          var Buf; const BufSize: Integer): Integer;
var I, L, emLen, dbLen : Integer;
    maskedSeed, maskedDB, seedMask, seed, dbMask, DB, pHash, pHashPr : RawByteString;
    P, Q : PByte;
const
  hLen = RSAOAEPHashBufSize;
begin
  // validate
  if (KeySize <= 0) or
     (KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  if HugeWordGetBitCount(EncodedMessage) <> KeySize then
    raise ERSA.Create(SRSAInvalidMessage);
  // decode
  emLen := HugeWordGetSize(EncodedMessage) * HugeWordElementSize;
  // EM = 0x00 || maskedSeed || maskedDB
  dbLen := emLen - hLen - 1;
  SetLength(maskedSeed, hLen);
  SetLength(maskedDB, dbLen);
  P := EncodedMessage.Data;
  Inc(P, emLen - 1);
  if P^ <> 0 then
    raise ERSA.Create(SRSAInvalidMessage);
  Dec(P);
  Q := @maskedSeed[1];
  for I := 0 to hLen - 1 do
    begin
      Q^ := P^;
      Dec(P);
      Inc(Q);
    end;
  Q := @maskedDB[1];
  for I := 0 to dbLen - 1 do
    begin
      Q^ := P^;
      Dec(P);
      Inc(Q);
    end;
  // Let seedMask = MGF(maskedDB, hLen)
  SetLength(seedMask, hLen);
  RSAOAEPMGF1(maskedDB[1], dbLen, seedMask[1], hLen);
  // Let seed = maskedSeed xor seedMask
  SetLength(seed, hLen);
  Move(maskedSeed[1], seed[1], hLen);
  RSAXORBuf(seed[1], hLen, seedMask[1], hLen);
  // Let dbMask = MGF(seed, ||EM|| - hLen)
  SetLength(dbMask, dbLen);
  RSAOAEPMGF1(seed[1], hLen, dbMask[1], dbLen);
  // Let DB = maskedDB xor dbMask.
  SetLength(DB, dbLen);
  Move(maskedDB[1], DB[1], dbLen);
  RSAXORBuf(DB[1], dbLen, dbMask[1], dbLen);
  // Let pHash = Hash(P), an octet string of length hLen
  // SetLength(pHash, hLen);
  // Hash := CalcSHA1('');
  // Move(Hash, pHash[1], hLen);
  pHash := RawByteString(
           #$DA#$39#$A3#$EE#$5E#$6B#$4B#$0D#$32#$55 +
           #$BF#$EF#$95#$60#$18#$90#$AF#$D8#$07#$09);
  // DB = pHash' || PS || 01 || M
  // Decode pHash'
  SetLength(pHashPr, hLen);
  Move(DB[1], pHashPr[1], hLen);
  if pHashPr <> pHash then
    raise ERSA.Create(SRSAInvalidMessage);
  // Decode PS || 01
  I := hLen + 1;
  while I <= dbLen do
    case Byte(DB[I]) of
      0 : Inc(I);
      1 : break;
    else
      raise ERSA.Create(SRSAInvalidMessage);
    end;
  if I > dbLen then
    raise ERSA.Create(SRSAInvalidMessage);
  if Byte(DB[I]) <> 1 then
    raise ERSA.Create(SRSAInvalidMessage);
  Inc(I);
  // Decode M
  L := dbLen - I + 1;
  Result := L;
  if L > BufSize then
    L := BufSize;
  if L > 0 then
    Move(DB[I], Buf, L);
end;

{ RSA Decrypt                                                                  }
function RSADecrypt(
         const EncryptionType: TRSAEncryptionType;
         const PrivateKey: TRSAPrivateKey;
         const CipherBuf; const CipherBufSize: Integer;
         var PlainBuf; const PlainBufSize: Integer): Integer;
var CipherMsg, EncodedMsg : HugeWord;
begin
  // validate
  if (PrivateKey.KeySize <= 0) or
     (PrivateKey.KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  // decrypt
  HugeWordInit(CipherMsg);
  HugeWordInit(EncodedMsg);
  try
    RSACipherBufToMessage(PrivateKey.KeySize, CipherBuf, CipherBufSize, CipherMsg);
    RSADecryptMessage(PrivateKey, CipherMsg, EncodedMsg);
    case EncryptionType of
      rsaetPKCS1 : Result := RSADecodeMessagePKCS1(PrivateKey.KeySize, EncodedMsg, PlainBuf, PlainBufSize);
      rsaetOAEP  : Result := RSADecodeMessageOAEP(PrivateKey.KeySize, EncodedMsg, PlainBuf, PlainBufSize);
    else
      raise ERSA.Create(SRSAInvalidEncryptionType);
    end;
  finally
    SecureHugeWordFinalise(EncodedMsg);
    SecureHugeWordFinalise(CipherMsg);
  end;
end;

{ RSA Decrypt Str                                                              }
function RSADecryptStr(
         const EncryptionType: TRSAEncryptionType;
         const PrivateKey: TRSAPrivateKey;
         const Cipher: RawByteString): RawByteString;
var L, N : Integer;
begin
  L := Length(Cipher);
  if L = 0 then
    raise ERSA.Create(SRSAInvalidMessage);
  N := RSACipherMessageBufSize(PrivateKey.KeySize);
  SetLength(Result, N);
  N := RSADecrypt(EncryptionType, PrivateKey, PByteChar(Cipher)^, L, PByteChar(Result)^, N);
  SetLength(Result, N);
end;

{ RSA Sign Message                                                             }
procedure RSASignBufToMsg(const KeySize: Integer; var Msg: HugeWord; const Buf; const BufSize: Integer);
var
  L, I : Integer;
  P, Q : PByte;
begin
  L := KeySize div 8;
  if BufSize > L then
    raise ERSA.Create(SRSAInvalidBufferSize);
  HugeWordSetSize(Msg, L div HugeWordElementSize);
  P := Msg.Data;
  FillChar(P^, L, 0);
  Inc(P, L - 1);
  Q := @Buf;
  for I := 0 to BufSize - 1 do
    begin
      P^ := Q^;
      Dec(P);
      Inc(Q);
    end;
end;

function RSAMsgToSignBuf(const KeySize: Integer; var Buf; const BufSize: Integer; const Msg: HugeWord): Integer;
var
  L, N, I, C : Integer;
  P, Q : PByte;
begin
  L := KeySize div 8;
  if BufSize < L then
    raise ERSA.Create(SRSAInvalidBufferSize);
  N := Msg.Used * HugeWordElementSize;
  P := Msg.Data;
  Inc(P, N - 1);
  Q := @Buf;
  C := MinInt(N, L);
  for I := 0 to C - 1 do
    begin
      Q^ := P^;
      Dec(P);
      Inc(Q);
    end;
  Result := C;
end;

function RSASignMessage(
         const PrivateKey: TRSAPrivateKey;
         const MessageHashBuf; const MessageHashBufSize: Integer;
         var SignatureBuf; const SignatureBufSize: Integer): Integer;
var
  CipherMsg, EncodedMsg : HugeWord;
  L : Integer;
begin
  // validate
  if (PrivateKey.KeySize <= 0) or
     (PrivateKey.KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  L := PrivateKey.KeySize div 8;
  if SignatureBufSize < L then
    raise ERSA.Create(SRSAInvalidBufferSize);
  // sign
  HugeWordInit(CipherMsg);
  HugeWordInit(EncodedMsg);
  try
    RSASignBufToMsg(PrivateKey.KeySize, CipherMsg, MessageHashBuf, MessageHashBufSize);
    HugeWordPowerAndMod(EncodedMsg, CipherMsg, PrivateKey.Exponent, PrivateKey.Modulus);
    RSAMsgToSignBuf(PrivateKey.KeySize, SignatureBuf, SignatureBufSize, EncodedMsg);
  finally
    SecureHugeWordFinalise(EncodedMsg);
    SecureHugeWordFinalise(CipherMsg);
  end;
  Result := L;
end;

function RSACheckSignature(
         const PublicKey: TRSAPublicKey;
         const MessageHashBuf; const MessageHashBufSize: Integer;
         const SignatureBuf; const SignatureBufSize: Integer): Boolean;
var
  L, C : Integer;
  HashBuf : Pointer;
  HashBufSize : Integer;
  EncodedMsg, CipherMsg : HugeWord;
begin
  // validate
  if (PublicKey.KeySize <= 0) or
     (PublicKey.KeySize mod HugeWordElementBits <> 0) then
    raise ERSA.Create(SRSAInvalidKeySize);
  L := PublicKey.KeySize div 8;
  if SignatureBufSize < L then
    raise ERSA.Create(SRSAInvalidBufferSize);
  // check signature
  HashBufSize := L;
  GetMem(HashBuf, HashBufSize);
  try
    HugeWordInit(EncodedMsg);
    HugeWordInit(CipherMsg);
    try
      RSASignBufToMsg(PublicKey.KeySize, CipherMsg, SignatureBuf, SignatureBufSize);
      HugeWordPowerAndMod(EncodedMsg, CipherMsg, PublicKey.Exponent, PublicKey.Modulus);
      C := RSAMsgToSignBuf(PublicKey.KeySize, HashBuf^, HashBufSize, EncodedMsg);
    finally
      SecureHugeWordFinalise(CipherMsg);
      SecureHugeWordFinalise(EncodedMsg);
    end;
    Result := EqualMem(HashBuf^, MessageHashBuf, MinInt(C, MessageHashBufSize));
  finally
    FreeMem(HashBuf);
  end;
end;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF CIPHER_TEST}
{$ASSERTIONS ON}
procedure Test;

  procedure TestMGF;
  var Seed, Mask : RawByteString;
  begin
    Seed :=
        RawByteString(
        #$aa#$fd#$12#$f6#$59#$ca#$e6#$34#$89#$b4 +
        #$79#$e5#$07#$6d#$de#$c2#$f0#$6c#$b5#$8f);
    SetLength(Mask, 107);
    FillChar(Mask[1], 107, 0);
    RSAOAEPMGF1(Seed[1], 20, Mask[1], 107);
    Assert(Mask =
        #$06#$e1#$de#$b2#$36#$9a#$a5#$a5#$c7#$07#$d8#$2c#$8e#$4e#$93#$24 +
        #$8a#$c7#$83#$de#$e0#$b2#$c0#$46#$26#$f5#$af#$f9#$3e#$dc#$fb#$25 +
        #$c9#$c2#$b3#$ff#$8a#$e1#$0e#$83#$9a#$2d#$db#$4c#$dc#$fe#$4f#$f4 +
        #$77#$28#$b4#$a1#$b7#$c1#$36#$2b#$aa#$d2#$9a#$b4#$8d#$28#$69#$d5 +
        #$02#$41#$21#$43#$58#$11#$59#$1b#$e3#$92#$f9#$82#$fb#$3e#$87#$d0 +
        #$95#$ae#$b4#$04#$48#$db#$97#$2f#$3a#$c1#$4e#$af#$f4#$9c#$8c#$3b +
        #$7c#$fc#$95#$1a#$51#$ec#$d1#$dd#$e6#$12#$64);
  end;

  procedure TestEncrypt;
  var EM, CM : TRSAMessage;
      Pub : TRSAPublicKey;
  begin
    HugeWordInit(EM);
    HugeWordInit(CM);
    RSAPublicKeyInit(Pub);

    RSAPublicKeyAssignHex(Pub,
        1024,
        'bbf82f090682ce9c2338ac2b9da871f7' +
        '368d07eed41043a440d6b6f07454f51f' +
        'b8dfbaaf035c02ab61ea48ceeb6fcd48' +
        '76ed520d60e1ec4619719d8a5b8b807f' +
        'afb8e0a3dfc737723ee6b4b7d93a2584' +
        'ee6a649d060953748834b2454598394e' +
        'e0aab12d7b61a51f527a9a41f6c1687f' +
        'e2537298ca2a8f5946f8e5fd091dbdcb',
        '00000011');
    HexToHugeWordB(
        '00EB7A19ACE9E3006350E329504B45E2CA82310B26DCD87D5C68F1EEA8F55267C31B2E8BB4251F84' +
        'D7E0B2C04626F5AFF93EDCFB25C9C2B3FF8AE10E839A2DDB4CDCFE4FF47728B4A1B7C1362BAAD29A' +
        'B48D2869D5024121435811591BE392F982FB3E87D095AEB40448DB972F3AC14F7BC275195281CE32' +
        'D2F1B76D4D353E2D', EM);
    RSAEncryptMessage(Pub, EM, CM);
    Assert(HugeWordToHexB(CM) =
        '1253E04DC0A5397BB44A7AB87E9BF2A039A33D1E996FC82A94CCD30074C95DF763722017069E5268' +
        'DA5D1C0B4F872CF653C11DF82314A67968DFEAE28DEF04BB6D84B1C31D654A1970E5783BD6EB96A0' +
        '24C2CA2F4A90FE9F2EF5C9C140E5BB48DA9536AD8700C84FC9130ADEA74E558D51A74DDF85D8B50D' +
        'E96838D6063E0955');

    RSAPublicKeyFinalise(Pub);
    HugeWordFinalise(CM);
    HugeWordFinalise(EM);
  end;

var Pri : TRSAPrivateKey;
    Pub : TRSAPublicKey;

  procedure TestStr(const EncryptionType: TRSAEncryptionType; const Pln: RawByteString);
  var Enc, Dec : RawByteString;
  begin
    Enc := RSAEncryptStr(EncryptionType, Pub, Pln);
    Assert(Enc <> Pln);
    Dec := RSADecryptStr(EncryptionType, Pri, Enc);
    Assert(Dec = Pln);
  end;

  procedure TestCase1;
  begin
    RSAPrivateKeyAssignHex(Pri,
        1024,
        'bbf82f090682ce9c2338ac2b9da871f7' +
        '368d07eed41043a440d6b6f07454f51f' +
        'b8dfbaaf035c02ab61ea48ceeb6fcd48' +
        '76ed520d60e1ec4619719d8a5b8b807f' +
        'afb8e0a3dfc737723ee6b4b7d93a2584' +
        'ee6a649d060953748834b2454598394e' +
        'e0aab12d7b61a51f527a9a41f6c1687f' +
        'e2537298ca2a8f5946f8e5fd091dbdcb',
        'a5dafc5341faf289c4b988db30c1cdf8' +
        '3f31251e0668b42784813801579641b2' +
        '9410b3c7998d6bc465745e5c392669d6' +
        '870da2c082a939e37fdcb82ec93edac9' +
        '7ff3ad5950accfbc111c76f1a9529444' +
        'e56aaf68c56c092cd38dc3bef5d20a93' +
        '9926ed4f74a13eddfbe1a1cecc4894af' +
        '9428c2b7b8883fe4463a4bc85b1cb3c1');
    HexToHugeWordB(
        'eecfae81b1b9b3c908810b10a1b56001' +
        '99eb9f44aef4fda493b81a9e3d84f632' +
        '124ef0236e5d1e3b7e28fae7aa040a2d' +
        '5b252176459d1f397541ba2a58fb6599',
        Pri.Prime1);
    HexToHugeWordB(
        'c97fb1f027f453f6341233eaaad1d935' +
        '3f6c42d08866b1d05a0f2035028b9d86' +
        '9840b41666b42e92ea0da3b43204b5cf' +
        'ce3352524d0416a5a441e700af461503',
        Pri.Prime2);
    RSAPublicKeyAssignHex(Pub,
        1024,
        'bbf82f090682ce9c2338ac2b9da871f7' +
        '368d07eed41043a440d6b6f07454f51f' +
        'b8dfbaaf035c02ab61ea48ceeb6fcd48' +
        '76ed520d60e1ec4619719d8a5b8b807f' +
        'afb8e0a3dfc737723ee6b4b7d93a2584' +
        'ee6a649d060953748834b2454598394e' +
        'e0aab12d7b61a51f527a9a41f6c1687f' +
        'e2537298ca2a8f5946f8e5fd091dbdcb',
        '00000011');
    TestStr(rsaetOAEP,
        RawByteString(
        #$d4#$36#$e9#$95#$69#$fd#$32#$a7#$c8#$a0#$5b#$bc#$90#$d3#$2c#$49));
  end;

  procedure TestCase2;
  begin
    RSAPrivateKeyAssignHex(Pri,
        1024,
        'FED6F2848D95AFACE2354A771792D30E57B0C964D33BD700A53B92FCE0EFC7ADE2DEBC947FE762BD' +
        '07F5C803ACB2CC603796E2D12684C1F827B0544575D1EE7E93500F2011A853EBBFECA78781D29D6D' +
        '46B347FE76F209C0F4B9F1D457843B432CEA8060369748D858222F773758BAB16301345B02AEC17B' +
        '2C09E7CE9D37F4C5',
        '89DCC2AA0EE65179578EB8D020829F86FCCD78C600B838A1F2C17DCD2BEACBBD382483245AE55437' +
        '2B1D3DAD2F3A32F242607027F18C945AA92DED08FEAA293860221F0838132036F833B2203EDA26C1' +
        '5C90664A5627E3C6B1B4EF621FE34D239AD144F28C4891BF0354FE1D5C2FBA62B3F9A4793B835B5B' +
        '6A1A3EE0AF995E69');
    RSAPublicKeyAssignHex(Pub,
        1024,
        'FED6F2848D95AFACE2354A771792D30E57B0C964D33BD700A53B92FCE0EFC7ADE2DEBC947FE762BD' +
        '07F5C803ACB2CC603796E2D12684C1F827B0544575D1EE7E93500F2011A853EBBFECA78781D29D6D' +
        '46B347FE76F209C0F4B9F1D457843B432CEA8060369748D858222F773758BAB16301345B02AEC17B' +
        '2C09E7CE9D37F4C5',
        '00010001');
    TestStr(rsaetPKCS1, '');
    TestStr(rsaetOAEP, '');
    TestStr(rsaetPKCS1, 'Fundamentals');
    TestStr(rsaetOAEP, '12345678901234567890123456789012345678901234567890');
  end;

  procedure TestSign;
  var Msg : RawByteString;
      Hash : T256BitDigest;
      Sign : RawByteString;
      L : Integer;
  begin
    RSAPrivateKeyAssignHex(Pri,
        1024,
        'FED6F2848D95AFACE2354A771792D30E57B0C964D33BD700A53B92FCE0EFC7ADE2DEBC947FE762BD' +
        '07F5C803ACB2CC603796E2D12684C1F827B0544575D1EE7E93500F2011A853EBBFECA78781D29D6D' +
        '46B347FE76F209C0F4B9F1D457843B432CEA8060369748D858222F773758BAB16301345B02AEC17B' +
        '2C09E7CE9D37F4C5',
        '89DCC2AA0EE65179578EB8D020829F86FCCD78C600B838A1F2C17DCD2BEACBBD382483245AE55437' +
        '2B1D3DAD2F3A32F242607027F18C945AA92DED08FEAA293860221F0838132036F833B2203EDA26C1' +
        '5C90664A5627E3C6B1B4EF621FE34D239AD144F28C4891BF0354FE1D5C2FBA62B3F9A4793B835B5B' +
        '6A1A3EE0AF995E69');
    RSAPublicKeyAssignHex(Pub,
        1024,
        'FED6F2848D95AFACE2354A771792D30E57B0C964D33BD700A53B92FCE0EFC7ADE2DEBC947FE762BD' +
        '07F5C803ACB2CC603796E2D12684C1F827B0544575D1EE7E93500F2011A853EBBFECA78781D29D6D' +
        '46B347FE76F209C0F4B9F1D457843B432CEA8060369748D858222F773758BAB16301345B02AEC17B' +
        '2C09E7CE9D37F4C5',
        '00010001');

    Msg := 'Test message 123';
    Hash := CalcSHA256(Msg);
    SetLength(Sign, 128);
    L := RSASignMessage(Pri, Hash, SizeOf(Hash), Sign[1], Length(Sign));
    Assert(L = 128);
    Assert(RSACheckSignature(Pub, Hash, SizeOf(Hash), Sign[1], L));
  end;

begin
  RSAPrivateKeyInit(Pri);
  RSAPublicKeyInit(Pub);

  TestMGF;
  TestEncrypt;
  TestCase1;
  TestCase2;
  TestSign;

  RSAPublicKeyFinalise(Pub);
  RSAPrivateKeyFinalise(Pri);
end;
{$ENDIF}

{$IFDEF OS_WIN}
{$IFDEF CIPHER_PROFILE}
procedure Profile;
const KeySize = 2048 + 64;
var T : Word32;
    Pri : TRSAPrivateKey;
    Pub : TRSAPublicKey;
    Pln, Enc, Dec : RawByteString;
begin
  SetRandomSeed($12345679);

  RSAPrivateKeyInit(Pri);
  RSAPublicKeyInit(Pub);

  T := GetTickCount;
  RSAGenerateKeys(KeySize, Pri, Pub);
  T := GetTickCount - T;
  Writeln('GenerateKeys: ', T / 1000.0:0:2, 's');
  Writeln('Pri.Mod:');
  Writeln(HugeWordToHexB(Pri.Modulus));
  Writeln('Pri.Exp:');
  Writeln(HugeWordToHexB(Pri.Exponent));
  Writeln('Pub.Mod:');
  Writeln(HugeWordToHexB(Pub.Modulus));
  Writeln('Pub.Exp:');
  Writeln(HugeWordToHexB(Pub.Exponent));

  T := GetTickCount;
  Pln := '123456';
  Enc := RSAEncryptStr(rsaetPKCS1, Pub, Pln);
  Assert(Enc <> Pln);
  T := GetTickCount - T;
  Writeln('EncryptStr: ', T, 'ms');

  T := GetTickCount;
  Dec := RSADecryptStr(rsaetPKCS1, Pri, Enc);
  Assert(Dec = Pln);
  T := GetTickCount - T;
  Writeln('DecryptStr: ', T, 'ms');

  RSAPublicKeyFinalise(Pub);
  RSAPrivateKeyFinalise(Pri);
end;
{$ENDIF}
{$ENDIF}



end.

