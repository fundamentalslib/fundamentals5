{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcCipherEllipticCurve.pas                               }
{   File version:     5.05                                                     }
{   Description:      Elliptic Curve (EC) cipher routines                      }
{                                                                              }
{   Copyright:        Copyright (c) 2019-2021, David J Butler                  }
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
{ References:                                                                  }
{                                                                              }
{    Elliptic Curve Cryptography Tutorial                                      }
{    https://www.johannes-bauer.com/compsci/ecc/                               }
{                                                                              }
{    What is the math behind elliptic curve cryptography?                      }
{    https://hackernoon.com/what-is-the-math-behind-elliptic-curve-cryptography-f61b25253da3 }
{                                                                              }
{    Elliptic curve point multiplication                                       }
{    https://en.wikipedia.org/wiki/Elliptic_curve_point_multiplication         }
{                                                                              }
{    SEC 2: Recommended Elliptic Curve Domain Parameters                       }
{    https://www.secg.org/sec2-v2.pdf                                          }
{                                                                              }
{    Elliptic Curve Cryptography: ECDH and ECDSA                               }
{    https://andrea.corbellini.name/2015/05/30/elliptic-curve-cryptography-ecdh-and-ecdsa/ }
{                                                                              }
{ Revision history:                                                            }
{                                                                              }
{   2019/12/15  0.01  Initial version: Secp256k1: Generate keys,               }
{                     sign message and verify signature.                       }
{   2019/12/15  0.02  ECDH shared seed calculation.                            }
{   2020/03/08  5.03  Use Mod_F instead of Mod in calculations.                }
{                     Pass tests: Sign and VerifySignature.                    }
{   2020/05/11  5.04  Curve parameters for Secp224k1 and Secp256r1.            }
{   2020/05/19  5.05  Curve parameters for Secp384r1 and Secp521r1.            }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}
{$INCLUDE flcCrypto.inc}

{$IFDEF DEBUG}
{$IFDEF TEST}
  {$DEFINE CIPHER_EC_TEST}
{$ENDIF}
{$ENDIF}

unit flcCipherEllipticCurve;

interface

uses
  { Sysem }
  SysUtils,

  { Fundamentals }
  flcStdTypes,
  flcHugeInt;



type
  EElipticCurve = class(Exception);

  TCurvePoint = record
    HasValue : Boolean;
    X, Y     : HugeInt;
  end;

  TCurveParameters = record
    p    : HugeWord;     // p:    prime size of the finite field
    a, b : HugeWord;     // a, b: coefficients of the elliptic curve equation
    G    : TCurvePoint;  // G:    base point that generates subgroup
    n    : HugeWord;     // n:    the order of the subgroup
    h    : HugeWord;     // h:    The cofactor of the subgroup
  end;

  TCurveKeys = record
    d : HugeWord;        // d: The private key. A random integer chosen from 1..n-1
    H : TCurvePoint;     // H: The public key. The point H = dG
  end;


procedure InitCurvePoint(var APoint: TCurvePoint);
procedure FinaliseCurvePoint(var APoint: TCurvePoint);

procedure InitCurvePameters(var ACurve: TCurveParameters);
procedure FinaliseCurvePameters(var ACurve: TCurveParameters);

procedure InitCurvePametersSecp224k1(var ACurve: TCurveParameters);
procedure InitCurvePametersSecp256k1(var ACurve: TCurveParameters);
procedure InitCurvePametersSecp256r1(var ACurve: TCurveParameters);
procedure InitCurvePametersSecp384r1(var ACurve: TCurveParameters);
procedure InitCurvePametersSecp521r1(var ACurve: TCurveParameters);

procedure InitCurveKeys(var ACurveKeys: TCurveKeys);
procedure FinaliseCurveKeys(var ACurveKeys: TCurveKeys);

procedure GenerateCurveKeys(
          const ACurve: TCurveParameters;
          var Keys: TCurveKeys);

procedure CurveSignMessage(
          const ACurve: TCurveParameters;
          const AKeys: TCurveKeys;
          const MsgBuf; const MsgBufSize: Integer;
          var ASignature: TCurvePoint);

function  CurveVerifySignature(
          const ACurve: TCurveParameters;
          const AKeys: TCurveKeys;
          const MsgBuf; const MsgBufSize: Integer;
          const ASignature: TCurvePoint): Boolean;

procedure CalculateECDHSharedSeed(
          const ACurveParams: TCurveParameters;
          const ALocalPrivateKey: HugeWord;
          const ARemotePublicKey: TCurvePoint;
          var ASharedSeed: TCurvePoint);



{$IFDEF CIPHER_EC_TEST}
procedure Test;
{$ENDIF}



implementation

uses
  { Fundamentals }
  flcCryptoHash;



{ Curve point }

procedure InitCurvePoint(var APoint: TCurvePoint);
begin
  FillChar(APoint, SizeOf(APoint), 0);
  APoint.HasValue := False;
  HugeIntInit(APoint.X);
  HugeIntInit(APoint.Y);
end;

procedure FinaliseCurvePoint(var APoint: TCurvePoint);
begin
  HugeIntClearAndFinalise(APoint.X);
  HugeIntClearAndFinalise(APoint.Y);
end;

procedure CurvePointAssign(var A: TCurvePoint; const B: TCurvePoint);
begin
  A.HasValue := B.HasValue;
  HugeIntAssign(A.X, B.X);
  HugeIntAssign(A.Y, B.Y);
end;

procedure CurvePointAssignValue(var A: TCurvePoint; const X, Y: HugeInt);
begin
  A.HasValue := True;
  HugeIntAssign(A.X, X);
  HugeIntAssign(A.Y, Y);
end;

procedure CurvePointAssignNone(var APoint: TCurvePoint);
begin
  APoint.HasValue := False;
  HugeIntAssignZero(APoint.X);
  HugeIntAssignZero(APoint.Y);
end;



{ Curve parameters }

procedure InitCurvePameters(var ACurve: TCurveParameters);
begin
  FillChar(ACurve, SizeOf(ACurve), 0);
  HugeWordInit(ACurve.p);
  HugeWordInit(ACurve.a);
  HugeWordInit(ACurve.b);
  InitCurvePoint(ACurve.G);
  HugeWordInit(ACurve.n);
  HugeWordInit(ACurve.h);
end;

procedure FinaliseCurvePameters(var ACurve: TCurveParameters);
begin
  HugeWordFinalise(ACurve.p);
  HugeWordFinalise(ACurve.a);
  HugeWordFinalise(ACurve.b);
  FinaliseCurvePoint(ACurve.G);
  HugeWordFinalise(ACurve.n);
  HugeWordFinalise(ACurve.h);
end;

procedure InitCurvePametersSecp224k1(var ACurve: TCurveParameters);
begin
  InitCurvePameters(ACurve);
  HexToHugeWord('fffffffffffffffffffffffffffffffffffffffffffffffeffffe56d', ACurve.p);
  HugeWordInitZero(ACurve.a);
  HugeWordInitWord32(ACurve.b, 5);
  HexToHugeWord('a1455b334df099df30fc28a169a467e9e47075a90f7e650eb6b7a45c', ACurve.G.X.Value);
  ACurve.G.X.Sign := 1;
  HexToHugeWord('7e089fed7fba344282cafbd6f7e319f7c0b0bd59e2ca4bdb556d61a5', ACurve.G.Y.Value);
  ACurve.G.Y.Sign := 1;
  ACurve.G.HasValue := True;
  HexToHugeWord('0000000000000000000000000001dce8d2ec6184caf0a971769fB1f7', ACurve.n);
  HugeWordInitOne(ACurve.h);
end;

procedure InitCurvePametersSecp256k1(var ACurve: TCurveParameters);
begin
  InitCurvePameters(ACurve);
  HexToHugeWord('fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f', ACurve.p);
  HugeWordInitZero(ACurve.a);
  HugeWordInitWord32(ACurve.b, 7);
  HexToHugeWord('79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798', ACurve.G.X.Value);
  ACurve.G.X.Sign := 1;
  HexToHugeWord('483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8', ACurve.G.Y.Value);
  ACurve.G.Y.Sign := 1;
  ACurve.G.HasValue := True;
  HexToHugeWord('fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141', ACurve.n);
  HugeWordInitOne(ACurve.h);
end;

procedure InitCurvePametersSecp256r1(var ACurve: TCurveParameters);
begin
  InitCurvePameters(ACurve);
  HexToHugeWord('ffffffff00000001000000000000000000000000ffffffffffffffffffffffff', ACurve.p);
  HexToHugeWord('ffffffff00000001000000000000000000000000fffffffffffffffffffffffc', ACurve.a);
  HexToHugeWord('5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b', ACurve.b);
  HexToHugeWord('6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296', ACurve.G.X.Value);
  ACurve.G.X.Sign := 1;
  HexToHugeWord('4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5', ACurve.G.Y.Value);
  ACurve.G.Y.Sign := 1;
  ACurve.G.HasValue := True;
  HexToHugeWord('ffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc632551', ACurve.n);
  HugeWordInitOne(ACurve.h);
end;

procedure InitCurvePametersSecp384r1(var ACurve: TCurveParameters);
begin
  InitCurvePameters(ACurve);
  HexToHugeWord('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFF0000000000000000FFFFFFFF', ACurve.p);
  HexToHugeWord('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFF0000000000000000FFFFFFFC', ACurve.a);
  HexToHugeWord('B3312FA7E23EE7E4988E056BE3F82D19181D9C6EFE8141120314088F5013875AC656398D8A2ED19D2A85C8EDD3EC2AEF', ACurve.b);
  HexToHugeWord('AA87CA22BE8B05378EB1C71EF320AD746E1D3B628BA79B9859F741E082542A385502F25DBF55296C3A545E3872760AB7', ACurve.G.X.Value);
  ACurve.G.X.Sign := 1;
  HexToHugeWord('3617DE4A96262C6F5D9E98BF9292DC29F8F41DBD289A147CE9DA3113B5F0B8C00A60B1CE1D7E819D7A431D7C90EA0E5F', ACurve.G.Y.Value);
  ACurve.G.Y.Sign := 1;
  ACurve.G.HasValue := True;
  HexToHugeWord('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7634D81F4372DDF581A0DB248B0A77AECEC196ACCC52973', ACurve.n);
  HugeWordInitOne(ACurve.h);
end;

procedure InitCurvePametersSecp521r1(var ACurve: TCurveParameters);
begin
  InitCurvePameters(ACurve);
  HexToHugeWord('01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF', ACurve.p);
  HexToHugeWord('01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC', ACurve.a);
  HexToHugeWord('0051953EB9618E1C9A1F929A21A0B68540EEA2DA725B99B315F3B8B489918EF109E156193951EC7E937B1652C0BD3BB1BF073573DF883D2C34F1EF451FD46B503F00', ACurve.b);
  HexToHugeWord('00C6858E06B70404E9CD9E3ECB662395B4429C648139053FB521F828AF606B4D3DBAA14B5E77EFE75928FE1DC127A2FFA8DE3348B3C1856A429BF97E7E31C2E5BD66', ACurve.G.X.Value);
  ACurve.G.X.Sign := 1;
  HexToHugeWord('011839296A789A3BC0045C8A5FB42C7D1BD998F54449579B446817AFBD17273E662C97EE72995EF42640C550B9013FAD0761353C7086A272C24088BE94769FD16650', ACurve.G.Y.Value);
  ACurve.G.Y.Sign := 1;
  ACurve.G.HasValue := True;
  HexToHugeWord('01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA51868783BF2F966B7FCC0148F709A5D03BB5C9B8899C47AEBB6FB71E91386409', ACurve.n);
  HugeWordInitOne(ACurve.h);
end;



{ Curve keys }

procedure InitCurveKeys(var ACurveKeys: TCurveKeys);
begin
  FillChar(ACurveKeys, SizeOf(ACurveKeys), 0);
  HugeWordInit(ACurveKeys.d);
  InitCurvePoint(ACurveKeys.H);
end;

procedure FinaliseCurveKeys(var ACurveKeys: TCurveKeys);
begin
  HugeWordClearAndFinalise(ACurveKeys.d);
  FinaliseCurvePoint(ACurveKeys.H);
end;



{ Curve operations }

function IsPointOnCurve(
         const ACurve: TCurveParameters;
         const APoint: TCurvePoint): Boolean;
var
  Ysq   : HugeInt;
  Xcu   : HugeInt;
  Fn    : HugeInt;
  aX    : HugeInt;
  b     : HugeInt;
  p     : HugeInt;
  FnRes : HugeInt;
begin
  if not APoint.HasValue then
    begin
      // Point at infinity
      Result := True;
      exit;
    end;

  // (y^2 - x^3 - a * x - b) mod p = 0
  HugeIntInit(Ysq);
  HugeIntInit(Xcu);
  HugeIntInit(aX);
  HugeIntInit(b);
  HugeIntInit(p);
  HugeIntInit(Fn);
  HugeIntInit(FnRes);
  try

    HugeIntAssign(YSq, APoint.Y);
    HugeIntSqr(YSq);

    HugeIntAssign(Xcu, APoint.X);
    HugeIntMultiplyHugeInt(Xcu, APoint.X);
    HugeIntMultiplyHugeInt(Xcu, APoint.X);

    HugeIntAssignHugeWord(aX, ACurve.a);
    HugeIntMultiplyHugeInt(aX, APoint.X);

    HugeIntAssignHugeWord(b, ACurve.b);
    HugeIntAssignHugeWord(p, ACurve.p);

    HugeIntAssign(Fn, Ysq);
    HugeIntSubtractHugeInt(Fn, Xcu);
    HugeIntSubtractHugeInt(Fn, aX);
    HugeIntSubtractHugeInt(Fn, b);

    HugeIntMod_F(Fn, p, FnRes);

    if HugeIntIsZero(FnRes) then
      Result := True
    else
      Result := False;
  finally
    HugeIntFinalise(Ysq);
    HugeIntFinalise(Xcu);
    HugeIntFinalise(aX);
    HugeIntFinalise(b);
    HugeIntFinalise(p);
    HugeIntFinalise(Fn);
    HugeIntFinalise(FnRes);
  end;
end;

procedure CurvePointNeg(
          const ACurveParams: TCurveParameters;
          var APoint: TCurvePoint);
var
  Pt : HugeInt;
begin
  Assert(IsPointOnCurve(ACurveParams, APoint));
  if not APoint.HasValue then
    exit;

  HugeIntNegate(APoint.Y);
  HugeIntInitHugeWord(Pt, ACurveParams.p);
  try
    HugeIntMod_F(APoint.Y, Pt, APoint.Y);
  finally
    HugeIntFinalise(Pt);
  end;
  Assert(IsPointOnCurve(ACurveParams, APoint));
end;

// Point1 + Point2 according to the group law
procedure CurvePointAdd(
          const ACurve: TCurveParameters;
          var R: TCurvePoint;
          const APoint1, APoint2: TCurvePoint);
var
  XEq    : Boolean;
  M      : HugeInt;
  A      : HugeInt;
  InvMod : HugeInt;
  Y1     : HugeInt;
  XDel   : HugeInt;
  X3, Y3 : HugeInt;
  Pt     : HugeInt;
begin
  Assert(IsPointOnCurve(ACurve, APoint1));
  Assert(IsPointOnCurve(ACurve, APoint2));

  if not APoint1.HasValue then
    begin
      CurvePointAssign(R, APoint2);
      exit;
    end;

  if not APoint2.HasValue then
    begin
      CurvePointAssign(R, APoint1);
      exit;
    end;

  XEq := HugeIntEqualsHugeInt(APoint1.X, APoint2.X);
  if XEq and
     not HugeIntEqualsHugeInt(APoint1.Y, APoint2.Y) then
    begin
      CurvePointAssignNone(R);
      exit;
    end;

  HugeIntInit(X3);
  HugeIntInit(Y3);
  HugeIntInit(M);
  try
    if XEq then
      begin
        // m = (3 * x1 * x1 + curve.a) * ModInv(2 * y1, curve.p)
        HugeIntInit(A);
        HugeIntInit(InvMod);
        HugeIntInit(Y1);
        try
          HugeIntAssignWord32(M, 3);
          HugeIntMultiplyHugeInt(M, APoint1.X);
          HugeIntMultiplyHugeInt(M, APoint1.X);
          HugeIntAssignHugeWord(A, ACurve.a);
          HugeIntAddHugeInt(M, A);
          HugeIntAssign(Y1, APoint1.Y);
          HugeIntMultiplyWord8(Y1, 2);
          HugeWordModInv(Y1.Value, ACurve.p, InvMod.Value);
          if HugeWordIsZero(InvMod.Value) then
            InvMod.Sign := 0
           else
            InvMod.Sign := Y1.Sign;
          HugeIntMultiplyHugeInt(M, InvMod);
        finally
          HugeIntFinalise(A);
          HugeIntFinalise(InvMod);
          HugeIntFinalise(Y1);
        end;
      end
    else
      begin
        // point1 <> point2
        // m = (y2 - y1) * ModInv(x2 - x1, p)
        HugeIntInit(XDel);
        HugeIntInit(InvMod);
        try
          HugeIntAssign(M, APoint2.Y);
          HugeIntSubtractHugeInt(M, APoint1.Y);
          HugeIntAssign(XDel, APoint2.X);
          HugeIntSubtractHugeInt(XDel, APoint1.X);
          HugeWordModInv(XDel.Value, ACurve.p, InvMod.Value);
          if HugeWordIsZero(InvMod.Value) then
            InvMod.Sign := 0
           else
            InvMod.Sign := XDel.Sign;
          HugeIntMultiplyHugeInt(M, InvMod);
        finally
          HugeIntFinalise(XDel);
          HugeIntFinalise(InvMod);
        end;
      end;

    // x3 = m * m - x1 - x2
    HugeIntAssign(X3, M);
    HugeIntMultiplyHugeInt(X3, M);
    HugeIntSubtractHugeInt(X3, APoint1.X);
    HugeIntSubtractHugeInt(X3, APoint2.X);

    // y3 = m * (x1 - x3) - y1
    HugeIntAssign(Y3, APoint1.X);
    HugeIntSubtractHugeInt(Y3, X3);
    HugeIntMultiplyHugeInt(Y3, M);
    HugeIntSubtractHugeInt(Y3, APoint1.Y);

    // result = (x3 mod curve.p, y3 mod curve.p)
    HugeIntInitHugeWord(Pt, ACurve.p);
    try
      HugeIntMod_F(X3, Pt, X3);
      HugeIntMod_F(Y3, Pt, Y3)
    finally
      HugeIntFinalise(Pt);
    end;

    CurvePointAssignValue(R, X3, Y3);

  finally
    HugeIntFinalise(M);
    HugeIntFinalise(X3);
    HugeIntFinalise(Y3);
  end;

  Assert(IsPointOnCurve(ACurve, R));
end;

// Scalar point multiplaction
// Uses double and add algorithm
procedure CurvePointScalarMultiply(
          const ACurve: TCurveParameters;
          var R: TCurvePoint;
          const K: HugeInt;
          const APoint: TCurvePoint);
var
  Km   : HugeInt;
  Kn   : HugeInt;
  Pn   : TCurvePoint;
  Padd : TCurvePoint;
  Kt   : HugeInt;
begin
  Assert(IsPointOnCurve(ACurve, APoint));
  if not APoint.HasValue then
    begin
      CurvePointAssignNone(R);
      exit;
    end;
  HugeIntInit(Km);
  HugeIntInit(Kn);
  InitCurvePoint(Pn);
  try
    // if k mod n = 0 then None
    HugeWordMod(K.Value, ACurve.n, Km.Value);
    if HugeWordIsZero(Km.Value) then
      begin
        CurvePointAssignNone(R);
        exit;
      end;
    // if k < 0 then -k * Point
    if HugeIntSign(K) < 0 then
      begin
        HugeIntAssign(Kn, K);
        HugeIntNegate(Kn);
        CurvePointAssign(Pn, APoint);
        CurvePointNeg(ACurve, Pn);
        CurvePointScalarMultiply(ACurve, R, Kn, Pn);
        exit;
      end;
  finally
    HugeIntFinalise(Km);
    HugeIntFinalise(Kn);
    FinaliseCurvePoint(Pn);
  end;

  // Double and Add
  InitCurvePoint(Padd);
  HugeIntInitHugeInt(Kt, K);
  try
    CurvePointAssignNone(R);
    CurvePointAssign(Padd, APoint);
    while not HugeIntIsZero(Kt) do
      begin
        // Add
        if HugeIntIsOdd(Kt) then
          CurvePointAdd(ACurve, R, R, Padd);
        // Double
        CurvePointAdd(ACurve, Padd, Padd, Padd);
        // Shift
        HugeWordShr1(Kt.Value);
        HugeWordNormalise(Kt.Value);
        if HugeWordIsZero(Kt.Value) then
          Kt.Sign := 0;
      end;
  finally
    FinaliseCurvePoint(Padd);
    HugeIntFinalise(Kt);
  end;
end;

procedure GenerateCurvePrivateKey(
          const ACurve: TCurveParameters;
          var K: HugeWord);
var
  T : HugeWord;
begin
  // d: The private key. A random integer chosen from 1..n-1
  HugeWordInitHugeWord(T, ACurve.n);
  try
    if HugeWordSubtractWord32(T, 2) <= 0 then
      raise EElipticCurve.Create('Invalid parameter n');
    HugeWordRandomN(K, T);
    HugeWordInc(K);
  finally
    HugeWordFinalise(T);
  end;
end;

procedure GenerateCurveKeys(
          const ACurve: TCurveParameters;
          var Keys: TCurveKeys);
var
  Dt : HugeInt;
begin
  GenerateCurvePrivateKey(ACurve, Keys.d);
  // H: The public key. The point H = dG
  HugeIntInitHugeWord(Dt, Keys.d);
  try
    CurvePointScalarMultiply(ACurve, Keys.H, Dt, ACurve.G);
  finally
    HugeIntClearAndFinalise(Dt);
  end;
end;

// Truncated SHA512 hash of the message
procedure CurveHashMessage(
          const ACurve: TCurveParameters;
          const MsgBuf; const MsgBufSize: Integer;
          var R: HugeWord);
var
  Dig : T512BitDigest;
begin
  Dig := CalcSHA512(MsgBuf, MsgBufSize);
  HugeWordAssignBuf(R, Dig, SizeOf(Dig), False);
  HugeWordNormalise(R);
  // FIPS 180: discard rightmost bits
  while HugeWordCompare(R, ACurve.n) > 0 do
    begin
      HugeWordShr1(R);
      HugeWordNormalise(R);
    end;
end;

procedure CurveSignMessage(
          const ACurve: TCurveParameters;
          const AKeys: TCurveKeys;
          const MsgBuf; const MsgBufSize: Integer;
          var ASignature: TCurvePoint);
var
  Z  : HugeWord;
  Zi : HugeInt;
  R  : HugeInt;
  S  : HugeInt;
  K  : HugeWord;
  Ki : HugeInt;
  XY : TCurvePoint;
  Ni : HugeInt;
  St : HugeInt;
begin
  HugeWordInit(Z);
  HugeIntInit(Zi);
  HugeIntInit(R);
  HugeIntInit(S);
  HugeWordInit(K);
  HugeIntInit(Ki);
  InitCurvePoint(XY);
  HugeIntInit(Ni);
  HugeIntInit(St);
  try
    HugeIntAssignHugeWord(Ni, ACurve.n);
    // z = hash_message(message)
    CurveHashMessage(ACurve, MsgBuf, MsgBufSize, Z);
    HugeIntAssignHugeWord(Zi, Z);
    // r = 0
    // s = 0
    HugeIntAssignZero(R);
    HugeIntAssignZero(S);
    while HugeIntIsZero(R) or HugeIntIsZero(S) do
      begin
        GenerateCurvePrivateKey(ACurve, K);
        HugeIntAssignHugeWord(Ki, K);
        // xy = kG
        CurvePointScalarMultiply(ACurve, XY, Ki, ACurve.G);
        // r = x mod n
        HugeIntMod_F(XY.X, Ni, R);
        // s = ((z + r * private_key) * ModInv(k, n)) mod n
        HugeIntAssignZero(S);
        HugeWordModInv(K, ACurve.n, S.Value);
        if not HugeWordIsZero(S.Value) then
          S.Sign := 1;
        HugeIntAssignHugeWord(St, AKeys.d);
        HugeIntMultiplyHugeInt(St, R);
        HugeIntAddHugeInt(St, Zi);
        HugeIntMultiplyHugeInt(S, St);
        HugeIntMod_F(S, Ni, S);
      end;
    CurvePointAssignValue(ASignature, R, S);
  finally
    HugeWordClearAndFinalise(Z);
    HugeIntClearAndFinalise(Zi);
    HugeIntClearAndFinalise(R);
    HugeIntClearAndFinalise(S);
    HugeWordClearAndFinalise(K);
    HugeIntClearAndFinalise(Ki);
    FinaliseCurvePoint(XY);
    HugeIntClearAndFinalise(Ni);
    HugeIntClearAndFinalise(St);
  end;
end;

function CurveVerifySignature(
         const ACurve: TCurveParameters;
         const AKeys: TCurveKeys;
         const MsgBuf; const MsgBufSize: Integer;
         const ASignature: TCurvePoint): Boolean;
var
  Z   : HugeWord;
  R   : HugeInt;
  S   : HugeInt;
  W   : HugeWord;
  U1  : HugeWord;
  U2  : HugeWord;
  U1i : HugeInt;
  U2i : HugeInt;
  P1  : TCurvePoint;
  P2  : TCurvePoint;
  XY  : TCurvePoint;
begin
  HugeWordInit(Z);
  HugeIntInit(R);
  HugeIntInit(S);
  HugeWordInit(W);
  HugeWordInit(U1);
  HugeWordInit(U2);
  HugeIntInit(U1i);
  HugeIntInit(U2i);
  InitCurvePoint(P1);
  InitCurvePoint(P2);
  InitCurvePoint(XY);
  try
    // z = hash_message(message)
    // r, s = signature
    CurveHashMessage(ACurve, MsgBuf, MsgBufSize, Z);
    R := ASignature.X;
    S := ASignature.Y;
    // w = ModInv(s, curve.n)
    HugeWordModInv(S.Value, ACurve.n, W);
    // u1 = (z * w) mod curve.n
    // u2 = (r * w) mod curve.n
    HugeWordAssign(U1, Z);
    HugeWordMultiply(U1, U1, W);
    HugeWordMod(U1, ACurve.n, U1);
    HugeIntAssignHugeWord(U1i, U1);
    HugeWordAssign(U2, R.Value);
    HugeWordMultiply(U2, U2, W);
    HugeWordMod(U2, ACurve.n, U2);
    HugeIntAssignHugeWord(U2i, U2);
    // x, y = point_add(scalar_mult(u1, curve.g),
    //                  scalar_mult(u2, public_key))
    CurvePointScalarMultiply(ACurve, P1, U1i, ACurve.G);
    CurvePointScalarMultiply(ACurve, P2, U2i, AKeys.H);
    CurvePointAdd(ACurve, XY, P1, P2);
    // if r mod curve.n = x mod curve.n then
    //   signature matches
    HugeWordMod(R.Value, ACurve.n, R.Value);
    HugeWordMod(XY.X.Value, ACurve.n, XY.X.Value);
    Result := HugeWordEquals(R.Value, XY.X.Value);
  finally
    HugeWordFinalise(Z);
    HugeIntFinalise(R);
    HugeIntFinalise(S);
    HugeWordFinalise(W);
    HugeWordFinalise(U1);
    HugeWordFinalise(U2);
    HugeIntFinalise(U1i);
    HugeIntFinalise(U2i);
    FinaliseCurvePoint(P1);
    FinaliseCurvePoint(P2);
    FinaliseCurvePoint(XY);
  end;
end;



{ ECDH }

procedure CalculateECDHSharedSeed(
          const ACurveParams: TCurveParameters;
          const ALocalPrivateKey: HugeWord;
          const ARemotePublicKey: TCurvePoint;
          var ASharedSeed: TCurvePoint);
var
  K : HugeInt;
begin
  // SharedSeed = LocalPrivateKey * RemotePublicKey
  HugeIntInitHugeWord(K, ALocalPrivateKey);
  try
    CurvePointScalarMultiply(ACurveParams, ASharedSeed, K, ARemotePublicKey);
  finally
    HugeIntClearAndFinalise(K);
  end;
end;



{                                                                              }
{ Test                                                                         }
{                                                                              }
{$IFDEF CIPHER_EC_TEST}
{$ASSERTIONS ON}
procedure Test_OnCurve1;
var
  P : TCurveParameters;
  R : TCurvePoint;
  P1 : TCurvePoint;
begin
  InitCurvePametersSecp256k1(P);
  InitCurvePoint(R);
  InitCurvePoint(P1);

  P1.X.Sign := 1;
  P1.Y.Sign := 1;
  P1.HasValue := True;

  HexToHugeWord('b23790a42be63e1b251ad6c94fdef07271ec0aada31db6c3e8bd32043f8be384', P1.X.Value);
  HexToHugeWord('fc6b694919d55edbe8d50f88aa81f94517f004f4149ecb58d10a473deb19880e', P1.Y.Value);
  Assert(IsPointOnCurve(P, P1));

  HexToHugeWord('dd3625faef5ba06074669716bbd3788d89bdde815959968092f76cc4eb9a9787', P1.X.Value);
  HexToHugeWord('7a188fa3520e30d461da2501045731ca941461982883395937f68d00c644a573', P1.Y.Value);
  Assert(IsPointOnCurve(P, P1));
end;

procedure Test_Add1;
var
  P : TCurveParameters;
  R : TCurvePoint;
  P1 : TCurvePoint;
begin
  InitCurvePametersSecp256k1(P);
  InitCurvePoint(R);
  InitCurvePoint(P1);

  P1.X.Sign := 1;
  P1.Y.Sign := 1;
  P1.HasValue := True;

  HexToHugeWord('b23790a42be63e1b251ad6c94fdef07271ec0aada31db6c3e8bd32043f8be384', P1.X.Value);
  HexToHugeWord('fc6b694919d55edbe8d50f88aa81f94517f004f4149ecb58d10a473deb19880e', P1.Y.Value);

  CurvePointAdd(P, R, P1, P1);

  Assert(HugeWordToHex(R.X.Value, True) = 'dd3625faef5ba06074669716bbd3788d89bdde815959968092f76cc4eb9a9787');
  Assert(HugeWordToHex(R.Y.Value, True) = '7a188fa3520e30d461da2501045731ca941461982883395937f68d00c644a573');
end;

procedure Test_Add2;
var
  P : TCurveParameters;
  R : TCurvePoint;
  P1, P2 : TCurvePoint;
begin
  InitCurvePametersSecp256k1(P);
  InitCurvePoint(R);
  InitCurvePoint(P1);
  InitCurvePoint(P2);

  HexToHugeWord('8dfe9e41c3cf0e40a5e9ad65f880215e50d5a38b456a4e973d39901aa01aafc3', P1.X.Value);
  P1.X.Sign := 1;
  HexToHugeWord('4fdbf7539c1c7944e2d24eca28163d2f98efdcdbf2f1487f13b4855cfd0cdc12', P1.Y.Value);
  P1.Y.Sign := 1;
  P1.HasValue := True;

  HexToHugeWord('c25f637176220cd9f3a66df315559d8263cf2a23a4ab5ab9a293131da190b632', P2.X.Value);
  P2.X.Sign := 1;
  HexToHugeWord('53154fede94d2873989049903809d7980a9f04ff9e027a1d6eebf3d6fc9590cf', P2.Y.Value);
  P2.Y.Sign := 1;
  P2.HasValue := True;

  CurvePointAdd(P, R, P1, P2);

  Assert(HugeWordToHex(R.X.Value, True) = '46a3c3ddfa35e7e88838706fcd71c34d35b5850b3358c5379dbc843deffdca07');
  Assert(HugeWordToHex(R.Y.Value, True) = '930386164bd61542b528ff76638056e645ca0af6ee889de9bd3137e8370509ef');
end;

procedure Test_SignMessage1;
var
  P : TCurveParameters;
  K : TCurveKeys;
  M : RawByteString;
  S : TCurvePoint;
begin
  // Curve: secp256k1
  // Private key: 0x9f4c9eb899bd86e0e83ecca659602a15b2edb648e2ae4ee4a256b17bb29a1a1e
  // Public key: (0xabd9791437093d377ca25ea974ddc099eafa3d97c7250d2ea32af6a1556f92a, 0x3fe60f6150b6d87ae8d64b78199b13f26977407c801f233288c97ddc4acca326)
  // Message: b'Hello!'
  InitCurvePametersSecp256k1(P);
  InitCurveKeys(K);
  HexToHugeWord('9f4c9eb899bd86e0e83ecca659602a15b2edb648e2ae4ee4a256b17bb29a1a1e', K.d);
  HexToHugeWord('abd9791437093d377ca25ea974ddc099eafa3d97c7250d2ea32af6a1556f92a', K.H.X.Value);
  K.H.X.Sign := 1;
  HexToHugeWord('3fe60f6150b6d87ae8d64b78199b13f26977407c801f233288c97ddc4acca326', K.H.Y.Value);
  K.H.Y.Sign := 1;
  K.H.HasValue := True;
  M := 'Hello!';
  InitCurvePoint(S);
  CurveSignMessage(P, K, Pointer(M)^, Length(M), S);
  Assert(CurveVerifySignature(P, K, Pointer(M)^, Length(M), S));
end;

{
1. private key: D30519BCAE8D180DBFCC94FE0B8383DC310185B0BE97B4365083EBCECCD75759
2. public key x-coordinate: 3AF1E1EFA4D1E1AD5CB9E3967E98E901DAFCD37C44CF0BFB6C216997F5EE51DF
3. public key y-coordinate: E4ACAC3E6F139E0C7DB2BD736824F51392BDA176965A1C59EB9C3C5FF9E85D7A
4. hash: 3F891FDA3704F0368DAB65FA81EBE616F4AA2A0854995DA4DC0B59D2CADBD64F
5. secure random integer k: CF554F5F4224223D52DC9CA784478FAC3C1A0D0419FDEEF27849A81846C71BA3
6. r signature: A5C7B7756D34D8AAF6AA68F0B71644F0BEF90D8BFD126CE951B6060498345089
7. s signature: BC9644F1625AF13841E589FD00653AE8C763309184EA0DE481E8F06709E5D1CB
}
procedure Test_SignMessage2;
var
  P : TCurveParameters;
  K : TCurveKeys;
  M : RawByteString;
  S : TCurvePoint;
begin
  InitCurvePametersSecp256k1(P);
  InitCurveKeys(K);
  HexToHugeWord('D30519BCAE8D180DBFCC94FE0B8383DC310185B0BE97B4365083EBCECCD75759', K.d);
  HexToHugeWord('3AF1E1EFA4D1E1AD5CB9E3967E98E901DAFCD37C44CF0BFB6C216997F5EE51DF', K.H.X.Value);
  K.H.X.Sign := 1;
  HexToHugeWord('E4ACAC3E6F139E0C7DB2BD736824F51392BDA176965A1C59EB9C3C5FF9E85D7A', K.H.Y.Value);
  K.H.Y.Sign := 1;
  K.H.HasValue := True;
  M := 'Hi there!';
  InitCurvePoint(S);
  CurveSignMessage(P, K, Pointer(M)^, Length(M), S);
  Assert(CurveVerifySignature(P, K, Pointer(M)^, Length(M), S));
end;


{
procedure Test_ECDH;
begin

Curve: secp256k1
Alice's private key: 0xe32868331fa8ef0138de0de85478346aec5e3912b6029ae71691c384237a3eeb
Alice's public key: (0x86b1aa5120f079594348c67647679e7ac4c365b2c01330db782b0ba611c1d677, 0x5f4376a23eed633657a90f385ba21068ed7e29859a7fab09e953cc5b3e89beba)
Bob's private key: 0xcef147652aa90162e1fff9cf07f2605ea05529ca215a04350a98ecc24aa34342
Bob's public key: (0x4034127647bb7fdab7f1526c7d10be8b28174e2bba35b06ffd8a26fc2c20134a, 0x9e773199edc1ea792b150270ea3317689286c9fe239dd5b9c5cfd9e81b4b632)
Shared secret: (0x3e2ffbc3aa8a2836c1689e55cd169ba638b58a3a18803fcf7de153525b28c3cd, 0x43ca148c92af58ebdb525542488a4fe6397809200fe8c61b41a105449507083)

end;

}

procedure Test;
begin
  Test_OnCurve1;
  Test_Add1;
  Test_Add2;
  Test_SignMessage1;
  Test_SignMessage2;
end;
{$ENDIF}



end.

