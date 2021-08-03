{$INCLUDE ../../flcInclude.inc}
{$INCLUDE flcTestInclude.inc}

unit flcTestHugeInt;

interface



procedure Test;



implementation

uses
  SysUtils,

  flcStdTypes,
  flcHugeInt;



{                                                                              }
{ Tests                                                                        }
{                                                                              }
{$ASSERTIONS ON}
procedure Test_HugeWord;
var A, B, C, D : HugeWord;
    X, Y : HugeInt;
    I : Integer;
    S : UTF8String;
    F : Word32;
begin
  HugeWordInit(A);
  HugeWordInit(B);
  HugeWordInit(C);
  HugeWordInit(D);
  HugeIntInit(X);
  HugeIntInit(Y);

  // Zero
  HugeWordAssignZero(A);
  Assert(HugeWordGetSize(A) = 0);
  Assert(HugeWordIsZero(A));
  Assert(HugeWordToWord32(A) = 0);
  Assert(HugeWordToInt32(A) = 0);
  Assert(HugeWordToInt64(A) = 0);
  Assert(HugeWordCompareWord32(A, 0) = 0);
  Assert(HugeWordCompareWord32(A, 1) = -1);
  Assert(HugeWordCompare(A, A) = 0);
  Assert(HugeWordIsWord32Range(A));
  Assert(HugeWordIsWord64Range(A));
  Assert(HugeWordIsInt32Range(A));
  Assert(HugeWordIsInt64Range(A));
  Assert(HugeWordIsEven(A));
  Assert(not HugeWordIsOdd(A));
  Assert(HugeWordToStrB(A) = '0');
  Assert(HugeWordToHexB(A) = '00000000');
  Assert(HugeWordSetBitScanForward(A) = -1);
  Assert(HugeWordSetBitScanReverse(A) = -1);
  Assert(HugeWordClearBitScanForward(A) = 0);
  Assert(HugeWordClearBitScanReverse(A) = 0);
  Assert(HugeWordToDouble(A) = 0.0);

  // One
  HugeWordAssignOne(A);
  Assert(not HugeWordIsEven(A));
  Assert(HugeWordIsOdd(A));
  Assert(not HugeWordIsZero(A));
  Assert(HugeWordIsOne(A));
  Assert(HugeWordToInt32(A) = 1);
  Assert(HugeWordCompareWord32(A, 0) = 1);
  Assert(HugeWordToHexB(A) = '00000001');
  Assert(HugeWordSetBitScanForward(A) = 0);
  Assert(HugeWordSetBitScanReverse(A) = 0);
  Assert(HugeWordClearBitScanForward(A) = 1);
  Assert(HugeWordClearBitScanReverse(A) = 1);
  Assert(HugeWordToDouble(A) = 1.0);

  // $FFFFFFFF
  HugeWordAssignZero(A);
  HugeWordAddWord32(A, $FFFFFFFF);
  Assert(HugeWordGetSize(A) = 1);
  Assert(HugeWordGetElement(A, 0) = $FFFFFFFF);
  Assert(HugeWordIsWord32Range(A));
  Assert(not HugeWordIsInt32Range(A));
  Assert(HugeWordIsInt64Range(A));
  Assert(HugeWordToWord32(A) = $FFFFFFFF);
  Assert(HugeWordToInt64(A) = $FFFFFFFF);
  Assert(not HugeWordIsZero(A));
  Assert(HugeWordCompareWord32(A, 0) = 1);
  HugeWordAddWord32(A, $FFFFFFFF);
  Assert(HugeWordGetSize(A) = 2);
  Assert((HugeWordGetElement(A, 0) = $FFFFFFFE) and (HugeWordGetElement(A, 1) = 1));
  Assert(not HugeWordIsWord32Range(A));
  Assert(HugeWordToInt64(A) = $1FFFFFFFE);
  HugeWordAddWord32(A, $FFFFFFFF);
  Assert(HugeWordGetSize(A) = 2);
  Assert((HugeWordGetElement(A, 0) = $FFFFFFFD) and (HugeWordGetElement(A, 1) = 2));
  Assert(HugeWordToInt64(A) = $2FFFFFFFD);
  Assert(HugeWordSubtractWord32(A, $FFFFFFFF) = 1);
  Assert(HugeWordGetSize(A) = 2);
  Assert((HugeWordGetElement(A, 0) = $FFFFFFFE) and (HugeWordGetElement(A, 1) = 1));
  Assert(HugeWordSubtractWord32(A, $FFFFFFFF) = 1);
  Assert(HugeWordToWord32(A) = $FFFFFFFF);
  Assert(HugeWordSubtractWord32(A, $FFFFFFFF) = 0);
  Assert(HugeWordToWord32(A) = 0);
  Assert(HugeWordSubtractWord32(A, $FFFFFFFF) = -1);
  Assert(HugeWordToWord32(A) = $FFFFFFFF);
  Assert(HugeWordToHexB(A) = 'FFFFFFFF');
  Assert(HugeWordSetBitScanForward(A) = 0);
  Assert(HugeWordSetBitScanReverse(A) = 31);
  Assert(HugeWordClearBitScanForward(A) = 32);
  Assert(HugeWordClearBitScanReverse(A) = 32);
  Assert(HugeWordToDouble(A) = 4294967295.0);

  // $80000000
  HugeWordAssignWord32(A, $80000000);
  Assert(HugeWordIsWord32Range(A));
  Assert(not HugeWordIsInt32Range(A));
  Assert(HugeWordIsInt64Range(A));
  Assert(HugeWordToWord32(A) = $80000000);
  Assert(HugeWordEqualsWord32(A, $80000000));
  Assert(HugeWordSetBitScanForward(A) = 31);
  Assert(HugeWordSetBitScanReverse(A) = 31);
  Assert(HugeWordClearBitScanForward(A) = 0);
  Assert(HugeWordClearBitScanReverse(A) = 32);

  // $100000000
  HugeWordAssignWord32(A, $80000000);
  HugeWordAdd(A, A);
  Assert(HugeWordToInt64(A) = $100000000);
  Assert(not HugeWordIsWord32Range(A));
  Assert(HugeWordEqualsInt64(A, $100000000));
  Assert(HugeWordToHexB(A) = '0000000100000000');
  Assert(HugeWordSetBitScanForward(A) = 32);
  Assert(HugeWordSetBitScanReverse(A) = 32);
  Assert(HugeWordClearBitScanForward(A) = 0);
  Assert(HugeWordClearBitScanReverse(A) = 33);
  Assert(HugeWordToDouble(A) = 4294967296.0);

  // $1234567890ABCDEF
  HugeWordAssignInt64(A, $1234567890ABCDEF);
  Assert(HugeWordToInt64(A) = $1234567890ABCDEF);
  Assert(not HugeWordIsWord32Range(A));
  Assert(not HugeWordIsZero(A));
  Assert(HugeWordIsInt64Range(A));
  Assert(HugeWordToHexB(A) = '1234567890ABCDEF');
  Assert(Abs(HugeWordToDouble(A) - 1311768467294899695.0) <= 1E12);

  // $7654321800000000
  HugeWordAssignInt64(A, $7654321800000000);
  Assert(HugeWordToInt64(A) = $7654321800000000);
  Assert(not HugeWordIsZero(A));
  Assert(not HugeWordIsWord32Range(A));
  Assert(not HugeWordIsInt32Range(A));
  Assert(HugeWordIsInt64Range(A));
  Assert(HugeWordToStrB(A) = '8526495073179795456');
  Assert(HugeWordToDouble(A) = 8526495073179795456.0);
  Assert(HugeWordToHexB(A) = '7654321800000000');

  // Swap
  HugeWordAssignInt32(A, 0);
  HugeWordAssignInt32(B, 1);
  HugeWordSwap(A, B);
  Assert(HugeWordToInt32(A) = 1);
  Assert(HugeWordToInt32(B) = 0);

  // Compare/Subtract
  HugeWordAssignZero(A);
  HugeWordAssignInt64(B, $FFFFFFFF);
  Assert(HugeWordToWord32(B) = $FFFFFFFF);
  Assert(HugeWordCompare(A, B) = -1);
  Assert(HugeWordCompare(B, A) = 1);
  Assert(HugeWordCompareWord32(B, $FFFFFFFF) = 0);
  Assert(HugeWordCompareWord32(B, 0) = 1);
  Assert(not HugeWordEquals(A, B));
  Assert(HugeWordEquals(B, B));
  HugeWordAdd(A, B);
  Assert(HugeWordGetSize(A) = 1);
  Assert(HugeWordGetElement(A, 0) = $FFFFFFFF);
  HugeWordAdd(A, B);
  Assert(HugeWordGetSize(A) = 2);
  Assert((HugeWordGetElement(A, 0) = $FFFFFFFE) and (HugeWordGetElement(A, 1) = 1));
  Assert(HugeWordCompare(A, B) = 1);
  Assert(HugeWordCompare(B, A) = -1);
  HugeWordAdd(A, B);
  Assert(HugeWordGetSize(A) = 2);
  Assert((HugeWordGetElement(A, 0) = $FFFFFFFD) and (HugeWordGetElement(A, 1) = 2));
  Assert(HugeWordSubtract(A, B) = 1);
  Assert(HugeWordGetSize(A) = 2);
  Assert((HugeWordGetElement(A, 0) = $FFFFFFFE) and (HugeWordGetElement(A, 1) = 1));
  Assert(HugeWordSubtract(A, B) = 1);
  Assert(HugeWordToWord32(A) = $FFFFFFFF);
  Assert(HugeWordSubtract(A, B) = 0);
  Assert(HugeWordToWord32(A) = 0);
  Assert(HugeWordSubtract(A, B) = -1);
  Assert(HugeWordToWord32(A) = $FFFFFFFF);

  // And/Or/Xor/Not
  HugeWordAssignInt64(A, $1234678FFFFFFFF);
  HugeWordAssignWord32(B, 0);
  HugeWordAndHugeWord(B, A);
  Assert(HugeWordToInt64(B) = 0);
  HugeWordOrHugeWord(B, A);
  Assert(HugeWordToInt64(B) = $1234678FFFFFFFF);
  HugeWordXorHugeWord(B, A);
  Assert(HugeWordToInt64(B) = 0);
  HugeWordAssignInt64(A, $FFFFFFFF);
  HugeWordNot(A);
  Assert(HugeWordToWord32(A) = 0);

  // Shl/Shr
  HugeWordAssignWord32(A, $101);
  HugeWordShr(A, 1);
  Assert(HugeWordToWord32(A) = $80);
  HugeWordShl(A, 1);
  Assert(HugeWordToWord32(A) = $100);
  HugeWordShl1(A);
  Assert(HugeWordToWord32(A) = $200);
  HugeWordShr1(A);
  Assert(HugeWordToWord32(A) = $100);

  // Shl1/Shl/Shr1/Shr
  HugeWordAssignWord32(A, 1);
  HugeWordAssignWord32(B, 1);
  for I := 0 to 50 do
    begin
      Assert(HugeWordToInt64(A) = Int64(1) shl I);
      Assert(HugeWordToInt64(B) = Int64(1) shl I);
      HugeWordShl1(A);
      HugeWordShl(B, 1);
    end;
  for I := 1 to 32 do
    HugeWordShl1(A);
  HugeWordShl(B, 32);
  Assert(HugeWordEquals(A, B));
  for I := 1 to 1000 do
    HugeWordShl1(A);
  HugeWordShl(B, 1000);
  Assert(HugeWordEquals(A, B));
  for I := 1 to 1032 do
    HugeWordShr1(A);
  HugeWordShr(B, 1000);
  HugeWordShr(B, 32);
  HugeWordNormalise(A);
  HugeWordNormalise(B);
  Assert(HugeWordEquals(A, B));
  for I := 51 downto 1 do
    begin
      Assert(HugeWordToInt64(A) = Int64(1) shl I);
      Assert(HugeWordToInt64(B) = Int64(1) shl I);
      HugeWordShr1(A);
      HugeWordShr(B, 1);
      HugeWordNormalise(A);
      HugeWordNormalise(B);
    end;

  // Shl/Shr
  HugeWordAssignInt64(A, $1234678FFFFFFFF);
  HugeWordShl1(A);
  Assert(HugeWordToInt64(A) = $2468CF1FFFFFFFE);
  HugeWordShr1(A);
  Assert(HugeWordToInt64(A) = $1234678FFFFFFFF);

  // Add/Subtract
  HugeWordAssignZero(A);
  HugeWordAddWord32(A, 1);
  Assert(HugeWordToWord32(A) = 1);
  Assert(HugeWordSubtractWord32(A, 1) = 0);
  Assert(HugeWordToWord32(A) = 0);
  Assert(HugeWordSubtractWord32(A, 1) = -1);
  Assert(HugeWordToWord32(A) = 1);

  // Add/Subtract
  HugeWordAssignZero(A);
  HugeWordAssignWord32(B, 1);
  HugeWordAdd(A, B);
  Assert(HugeWordToWord32(A) = 1);
  Assert(HugeWordSubtract(A, B) = 0);
  Assert(HugeWordToWord32(A) = 0);
  Assert(HugeWordSubtract(A, B) = -1);
  Assert(HugeWordToWord32(A) = 1);

  // Add/Subtract
  HugeWordAssignInt64(A, $FFFFFFFF);
  HugeWordAddWord32(A, 1);
  Assert(HugeWordGetSize(A) = 2);
  Assert((HugeWordGetElement(A, 0) = 0) and (HugeWordGetElement(A, 1) = 1));
  Assert(HugeWordSubtractWord32(A, 1) = 1);
  Assert(HugeWordToWord32(A) = $FFFFFFFF);
  Assert(HugeWordSubtractWord32(A, 1) = 1);
  Assert(HugeWordToWord32(A) = $FFFFFFFE);

  // Add/Subtract
  HugeWordAssignInt64(A, $FFFFFFFF);
  HugeWordAssignWord32(B, 1);
  HugeWordAdd(A, B);
  Assert(HugeWordGetSize(A) = 2);
  Assert((HugeWordGetElement(A, 0) = 0) and (HugeWordGetElement(A, 1) = 1));
  Assert(HugeWordSubtract(A, B) = 1);
  Assert(HugeWordToWord32(A) = $FFFFFFFF);
  Assert(HugeWordSubtract(A, B) = 1);
  Assert(HugeWordToWord32(A) = $FFFFFFFE);

  // Add/Subtract
  StrToHugeWordB('111111111111111111111111111111111111111111111111111111111', A);
  StrToHugeWordB('222222222222222222222222222222222222222222222222222222222', B);
  HugeWordAdd(A, B);
  Assert(HugeWordToStrB(A) = '333333333333333333333333333333333333333333333333333333333');
  HugeWordSubtract(A, B);
  Assert(HugeWordToStrB(A) = '111111111111111111111111111111111111111111111111111111111');
  HugeWordSubtract(A, A);
  Assert(HugeWordIsZero(A));

  // Multiply/Divide
  HugeWordAssignWord32(A, $10000000);
  HugeWordAssignWord32(B, $20000000);
  HugeWordMultiply(C, A, B);
  Assert(HugeWordToInt64(C) = $200000000000000);
  HugeWordDivide(C, B, D, C);
  Assert(HugeWordToInt64(D) = $10000000);
  Assert(HugeWordIsZero(C));

  // Multiply/Divide
  StrToHugeWordB('111111111111111111111111111111111111', A);
  StrToHugeWordB('100000000000000000000000000000000000', B);
  HugeWordMultiply(C, A, B);
  Assert(HugeWordToStrB(A) = '111111111111111111111111111111111111');
  Assert(HugeWordToStrB(C) = '11111111111111111111111111111111111100000000000000000000000000000000000');
  HugeWordDivide(C, B, D, C);
  Assert(HugeWordToStrB(D) = '111111111111111111111111111111111111');
  Assert(HugeWordToStrB(C) = '0');
  HugeWordMultiplyWord8(D, 10);
  Assert(HugeWordToStrB(D) = '1111111111111111111111111111111111110');
  HugeWordMultiplyWord16(D, 100);
  Assert(HugeWordToStrB(D) = '111111111111111111111111111111111111000');
  HugeWordMultiplyWord32(D, 1000);
  Assert(HugeWordToStrB(D) = '111111111111111111111111111111111111000000');
  HugeWordDivideWord32(D, 1000000, D, F);
  Assert(HugeWordToStrB(D) = '111111111111111111111111111111111111');
  Assert(F = 0);
  StrToHugeWordB('1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111', A);
  StrToHugeWordB('1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', B);
  HugeWordMultiply(C, A, B);
  Assert(HugeWordToStrB(C) = '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');

  // Multiply_ShiftAdd
  StrToHugeWordB('111111111111111111111111111111111111', A);
  StrToHugeWordB('100000000000000000000000000000000000', B);
  HugeWordMultiply_ShiftAdd(C, A, B);
  Assert(HugeWordToStrB(C) = '11111111111111111111111111111111111100000000000000000000000000000000000');
  StrToHugeWordB('1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111', A);
  StrToHugeWordB('1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', B);
  HugeWordMultiply_ShiftAdd(C, A, B);
  Assert(HugeWordToStrB(C) = '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');

  // Multiply_Karatsuba
  StrToHugeWordB('111111111111111111111111111111111111', A);
  StrToHugeWordB('100000000000000000000000000000000000', B);
  HugeWordMultiply_Karatsuba(C, A, B);
  Assert(HugeWordToStrB(C) = '11111111111111111111111111111111111100000000000000000000000000000000000');
  StrToHugeWordB('1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111', A);
  StrToHugeWordB('1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', B);
  HugeWordMultiply_Karatsuba(C, A, B);
  Assert(HugeWordToStrB(C) = '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');

  // ISqrt/Sqr
  HugeWordAssignWord32(A, $FFFF);
  HugeWordISqrt(A);
  Assert(HugeWordToInt64(A) = $FF);
  HugeWordAssignWord32(A, $10000);
  HugeWordISqrt(A);
  Assert(HugeWordToInt64(A) = $100);
  HugeWordAssignInt64(A, $FFFFFFFF);
  HugeWordISqrt(A);
  Assert(HugeWordToInt64(A) = $FFFF);
  HugeWordAssignInt64(A, $100000000);
  HugeWordISqrt(A);
  Assert(HugeWordToInt64(A) = $10000);
  HugeWordAssignInt64(A, $10000FFFF);
  HugeWordISqrt(A);
  Assert(HugeWordToInt64(A) = $10000);
  StrToHugeWordB('10000000000000000000000000000000000000000', A);
  HugeWordISqrt(A);
  Assert(HugeWordToStrB(A) = '100000000000000000000');
  HugeWordSqr(A, A);
  Assert(HugeWordToStrB(A) = '10000000000000000000000000000000000000000');
  HugeWordAssignWord32(A, $10000000);
  HugeWordSqr(A, A);
  Assert(HugeWordToInt64(A) = $100000000000000);
  HugeWordISqrt(A);
  Assert(HugeWordToInt64(A) = $10000000);

  // GCD
  HugeWordAssignWord32(A, 111);
  HugeWordAssignWord32(B, 159);
  HugeWordGCD(A, B, C);
  Assert(HugeWordToStrB(C) = '3');

  // GCD
  StrToHugeWordB('359334085968622831041960188598043661065388726959079837', A);   // Bell number prime
  StrToHugeWordB('1298074214633706835075030044377087', B);                       // Carol prime
  HugeWordGCD(A, B, C);
  Assert(HugeWordToStrB(C) = '1');

  // PowerAndMod
  HugeWordAssignWord32(A, 3);
  HugeWordAssignWord32(B, 500);
  HugeWordAssignWord32(C, 5);
  HugeWordPowerAndMod(D, A, B, C);
  Assert(HugeWordToStrB(D) = '1');

  // PowerAndMod
  HugeWordAssignWord32(A, 3);
  HugeWordAssignWord32(B, 123456);
  HugeWordAssignWord32(C, 7);
  HugeWordPowerAndMod(D, A, B, C);
  Assert(HugeWordToStrB(D) = '1');

  // PowerAndMod
  HugeWordAssignWord32(A, 2905);
  HugeWordAssignWord32(B, 323);
  HugeWordAssignWord32(C, 245363);
  HugeWordPowerAndMod(D, A, B, C);
  Assert(HugeWordToStrB(D) = '13388');

  // PowerAndMod
  StrToHugeWordB('9999999999', A);
  HugeWordAssignWord32(B, 10);
  HugeWordPower(B, 100);
  HugeWordAssignWord32(C, 700);
  HugeWordPowerAndMod(D, A, B, C);
  Assert(HugeWordToStrB(D) = '501');

  // Power/Mod
  HugeWordAssignWord32(A, 3);
  HugeWordAssignWord32(C, 5);
  HugeWordPower(A, 500);
  Assert(HugeWordToStrB(A) =
      '36360291795869936842385267079543319118023385026001623040346035832580600191583895' +
      '48419850826297938878330817970253440385575285593151701306614299243091656202578002' +
      '1771247847643450125342836565813209972590371590152578728008385990139795377610001');
  HugeWordMod(A, C, D);
  Assert(HugeWordToStrB(D) = '1');

  // Power/Mod
  HugeWordAssignWord32(A, 3);
  HugeWordAssignWord32(C, 7);
  HugeWordPower(A, 123456);
  HugeWordMod(A, C, D);
  Assert(HugeWordToStrB(D) = '1');

  // Power
  HugeWordAssignZero(A);
  HugeWordPower(A, 0);
  Assert(HugeWordToInt32(A) = 1);
  HugeWordAssignZero(A);
  HugeWordPower(A, 1);
  Assert(HugeWordToInt32(A) = 0);
  HugeWordAssignOne(A);
  HugeWordPower(A, 0);
  Assert(HugeWordToInt32(A) = 1);
  HugeWordAssignOne(A);
  HugeWordPower(A, 1);
  Assert(HugeWordToInt32(A) = 1);

  // AssignDouble
  HugeWordAssignDouble(A, 0.0);
  Assert(HugeWordToInt64(A) = 0);
  HugeWordAssignDouble(A, 1.0);
  Assert(HugeWordToInt64(A) = 1);
  HugeWordAssignDouble(A, 4294967295.0);
  Assert(HugeWordToInt64(A) = $FFFFFFFF);
  HugeWordAssignDouble(A, 4294967296.0);
  Assert(HugeWordToInt64(A) = $100000000);

  // HexTo/ToHex
  HexToHugeWordB('0', A);
  Assert(HugeWordToHexB(A) = '00000000');
  StrToHugeWordB('123456789', A);
  Assert(HugeWordToHexB(A) = '075BCD15');
  HexToHugeWordB('123456789ABCDEF', A);
  Assert(HugeWordToHexB(A) = '0123456789ABCDEF');
  Assert(HugeWordToStrB(A) = '81985529216486895');
  HexToHugeWordB('0123456789ABCDEF00112233F', A);
  Assert(HugeWordToHexB(A) = '00000000123456789ABCDEF00112233F');

  // StrTo/ToStr
  StrToHugeWordB('12345', A);
  Assert(HugeWordToWord32(A) = 12345);
  Assert(HugeWordToStrB(A) = '12345');

  // StrTo/ToStr
  S := '123456789012345678901234567890123456789012345678901234567890';
  StrToHugeWordB(S, A);
  for I := 1 to 100 do
    begin
      HugeWordMultiplyWord8(A, 10);
      S := S + '0';
      Assert(HugeWordToStrB(A) = S);
      StrToHugeWordB(S, B);
      Assert(HugeWordEquals(A, B));
    end;

  // Prime
  HugeWordAssignWord32(A, 1);
  Assert(HugeWordIsPrime(A) = pNotPrime);
  HugeWordAssignWord32(A, 31);
  Assert(HugeWordIsPrime(A) = pPrime);
  HugeWordAssignWord32(A, 982451653);
  Assert(HugeWordIsPrime(A) <> pNotPrime);
  HugeWordAssignWord32(A, 3464946713);
  Assert(HugeWordIsPrime(A) <> pNotPrime);
  HugeWordAssignWord32(A, 3464946767);
  Assert(HugeWordIsPrime(A) = pNotPrime);
  HugeWordAssignWord32(A, 3464946769);
  Assert(HugeWordIsPrime(A) <> pNotPrime);
  StrToHugeWordB('359334085968622831041960188598043661065388726959079837', A);     // Bell number prime
  Assert(HugeWordIsPrime(A) <> pNotPrime);
  StrToHugeWordB('1298074214633706835075030044377087', A);                         // Carol prime
  Assert(HugeWordIsPrime(A) <> pNotPrime);
  StrToHugeWordB('393050634124102232869567034555427371542904833', A);              // Cullen prime
  Assert(HugeWordIsPrime(A) <> pNotPrime);
  StrToHugeWordB('8683317618811886495518194401279999999', A);                      // Factorial prime
  Assert(HugeWordIsPrime(A) <> pNotPrime);
  StrToHugeWordB('19134702400093278081449423917', A);                              // Fibonacci prime
  Assert(HugeWordIsPrime(A) <> pNotPrime);
  StrToHugeWordB('1363005552434666078217421284621279933627102780881053358473', A); // Padovan prime
  Assert(HugeWordIsPrime(A) <> pNotPrime);
  StrToHugeWordB('1363005552434666078217421284621279933627102780881053358473', A); // Padovan prime
  HugeWordNextPotentialPrime(A);
  Assert(HugeWordToStrB(A) = '1363005552434666078217421284621279933627102780881053358551');
  HugeWordAssignWord32(A, 340561);                                                 // Carmichael number 340561 = 13 * 17 * 23 * 67
  Assert(HugeWordIsPrime(A) = pNotPrime);
  HugeWordAssignWord32(A, 82929001);                                               // Carmichael number 82929001 = 281 * 421 * 701
  Assert(HugeWordIsPrime(A) = pNotPrime);
  StrToHugeWordB('975177403201', A);                                               // Carmichael number 975177403201 = 2341 * 2861 * 145601
  Assert(HugeWordIsPrime(A) = pNotPrime);
  StrToHugeWordB('989051977369', A);                                               // Carmichael number 989051977369 = 173 * 36809 * 155317
  Assert(HugeWordIsPrime(A) = pNotPrime);
  StrToHugeWordB('999629786233', A);                                               // Carmichael number 999629786233 = 13 * 43 * 127 * 1693 * 8317
  Assert(HugeWordIsPrime(A) = pNotPrime);

  // ExtendedEuclid
  HugeWordAssignWord32(A, 120);
  HugeWordAssignWord32(B, 23);
  HugeWordExtendedEuclid(A, B, C, X, Y);
  Assert(HugeWordToWord32(C) = 1);
  Assert(HugeIntToInt32(X) = -9);
  Assert(HugeIntToInt32(Y) = 47);

  // ExtendedEuclid
  HugeWordAssignWord32(A, 11391);
  HugeWordAssignWord32(B, 5673);
  HugeWordExtendedEuclid(A, B, C, X, Y);
  Assert(HugeWordToWord32(C) = 3);
  Assert(HugeIntToInt32(X) = -126);
  Assert(HugeIntToInt32(Y) = 253);

  // ModInv
  HugeWordAssignWord32(A, 3);
  HugeWordAssignWord32(B, 26);
  Assert(HugeWordModInv(A, B, C));
  Assert(HugeWordToWord32(C) = 9);

  // ModInv
  HugeWordAssignWord32(A, 6);
  HugeWordAssignWord32(B, 3);
  Assert(not HugeWordModInv(A, B, C));

  // ModInv
  HugeWordAssignWord32(A, 31);
  HugeWordAssignWord32(B, 8887231);
  Assert(HugeWordModInv(A, B, C));
  Assert(HugeWordToWord32(C) = 2293479);

  // ModInv
  HugeWordAssignWord32(A, 999961543);
  StrToHugeWordB('3464946713311', B);
  Assert(HugeWordModInv(A, B, C));
  Assert(HugeWordToStrB(C) = '2733464305244');

  HugeIntFinalise(Y);
  HugeIntFinalise(X);
  HugeWordFinalise(D);
  HugeWordFinalise(C);
  HugeWordFinalise(B);
  HugeWordFinalise(A);
end;

procedure Test_HugeInt;
var A, B, C, D : HugeInt;
    F : HugeWord;
    K : Word32;
    L : Int32;
begin
  HugeIntInit(A);
  HugeIntInit(B);
  HugeIntInit(C);
  HugeIntInit(D);
  HugeWordInit(F);

  // Zero
  HugeIntAssignZero(A);
  Assert(HugeIntIsZero(A));
  Assert(HugeIntIsPositiveOrZero(A));
  Assert(HugeIntIsNegativeOrZero(A));
  Assert(not HugeIntIsPositive(A));
  Assert(not HugeIntIsNegative(A));
  Assert(HugeIntIsInt32Range(A));
  Assert(HugeIntIsWord32Range(A));
  Assert(HugeIntToStrB(A) = '0');
  Assert(HugeIntToHexB(A) = '00000000');
  Assert(HugeIntToWord32(A) = 0);
  Assert(HugeIntToInt32(A) = 0);
  Assert(HugeIntToDouble(A) = 0.0);
  StrToHugeIntB('0', A);
  Assert(HugeIntIsZero(A));
  Assert(HugeIntCompareInt64(A, MinInt64 { -$8000000000000000 }) = 1);
  Assert(HugeIntCompareInt64(A, $7FFFFFFFFFFFFFFF) = -1);
  Assert(not HugeIntEqualsInt64(A, MinInt64 { -$8000000000000000 }));
  HugeIntAddInt32(A, 0);
  Assert(HugeIntIsZero(A));
  HugeIntSubtractInt32(A, 0);
  Assert(HugeIntIsZero(A));
  HugeIntMultiplyInt8(A, 0);
  Assert(HugeIntIsZero(A));
  HugeIntMultiplyInt8(A, 1);
  Assert(HugeIntIsZero(A));
  HugeIntMultiplyInt8(A, -1);
  Assert(HugeIntIsZero(A));
  HugeIntMultiplyWord8(A, 0);
  Assert(HugeIntIsZero(A));
  HugeIntMultiplyWord8(A, 1);
  Assert(HugeIntIsZero(A));
  HugeIntMultiplyHugeWord(A, F);
  Assert(HugeIntIsZero(A));
  HugeIntMultiplyHugeInt(A, A);
  Assert(HugeIntIsZero(A));
  HugeIntSqr(A);
  Assert(HugeIntIsZero(A));
  HugeIntISqrt(A);
  Assert(HugeIntIsZero(A));

  // One
  HugeIntAssignOne(A);
  Assert(not HugeIntIsZero(A));
  Assert(HugeIntIsPositiveOrZero(A));
  Assert(not HugeIntIsNegativeOrZero(A));
  Assert(HugeIntIsOne(A));
  Assert(not HugeIntIsMinusOne(A));
  Assert(HugeIntToStrB(A) = '1');
  Assert(HugeIntToHexB(A) = '00000001');
  Assert(HugeIntIsPositive(A));
  Assert(not HugeIntIsNegative(A));
  Assert(HugeIntIsInt32Range(A));
  Assert(HugeIntIsWord32Range(A));
  Assert(HugeIntToDouble(A) = 1.0);
  StrToHugeIntB('1', A);
  Assert(HugeIntIsOne(A));
  Assert(HugeIntCompareInt64(A, MinInt64 { -$8000000000000000 }) = 1);
  Assert(HugeIntCompareInt64(A, $7FFFFFFFFFFFFFFF) = -1);
  Assert(not HugeIntEqualsInt64(A, MinInt64 { -$8000000000000000 }));
  HugeIntAddInt32(A, 0);
  Assert(HugeIntIsOne(A));
  HugeIntSubtractInt32(A, 0);
  Assert(HugeIntIsOne(A));
  HugeIntMultiplyInt8(A, 1);
  Assert(HugeIntIsOne(A));
  HugeIntMultiplyInt8(A, -1);
  Assert(HugeIntIsMinusOne(A));
  HugeIntMultiplyInt8(A, -1);
  Assert(HugeIntIsOne(A));
  HugeIntMultiplyWord8(A, 1);
  Assert(HugeIntIsOne(A));
  HugeIntSqr(A);
  Assert(HugeIntIsOne(A));
  HugeIntISqrt(A);
  Assert(HugeIntIsOne(A));

  // MinusOne
  HugeIntAssignMinusOne(A);
  Assert(not HugeIntIsZero(A));
  Assert(not HugeIntIsPositiveOrZero(A));
  Assert(HugeIntIsNegativeOrZero(A));
  Assert(not HugeIntIsOne(A));
  Assert(HugeIntIsMinusOne(A));
  Assert(HugeIntToStrB(A) = '-1');
  Assert(HugeIntToHexB(A) = '-00000001');
  Assert(not HugeIntIsPositive(A));
  Assert(HugeIntIsNegative(A));
  Assert(HugeIntIsInt32Range(A));
  Assert(HugeIntIsInt64Range(A));
  Assert(not HugeIntIsWord32Range(A));
  Assert(HugeIntToDouble(A) = -1.0);
  StrToHugeIntB('-1', A);
  Assert(HugeIntIsMinusOne(A));
  Assert(HugeIntCompareInt64(A, MinInt64 { -$8000000000000000 }) = 1);
  Assert(HugeIntCompareInt64(A, $7FFFFFFFFFFFFFFF) = -1);
  Assert(not HugeIntEqualsInt64(A, MinInt64 { -$8000000000000000 }));
  HugeIntMultiplyInt8(A, 1);
  Assert(HugeIntIsMinusOne(A));
  HugeIntAddWord32(A, 1);
  Assert(HugeIntIsZero(A));
  HugeIntAddInt32(A, -1);
  Assert(HugeIntIsMinusOne(A));
  HugeIntAddInt32(A, 0);
  Assert(HugeIntIsMinusOne(A));
  HugeIntSubtractInt32(A, 0);
  Assert(HugeIntIsMinusOne(A));
  HugeWordAssignHugeIntAbs(F, A);
  Assert(HugeWordIsOne(F));

  // MinInt64 (-$8000000000000000)
  HugeIntAssignInt64(A, MinInt64 { -$8000000000000000 });
  Assert(HugeIntToInt64(A) = MinInt64 { -$8000000000000000 });
  Assert(HugeIntToStrB(A) = '-9223372036854775808');
  Assert(HugeIntToHexB(A) = '-8000000000000000');
  Assert(HugeIntToDouble(A) = -9223372036854775808.0);
  Assert(HugeIntEqualsInt64(A, MinInt64 { -$8000000000000000 }));
  Assert(not HugeIntEqualsInt64(A, MinInt32 { -$80000000 }));
  Assert(HugeIntCompareInt64(A, MinInt64 { -$8000000000000000 }) = 0);
  Assert(HugeIntCompareInt64(A, -$7FFFFFFFFFFFFFFF) = -1);
  Assert(not HugeIntIsInt32Range(A));
  Assert(HugeIntIsInt64Range(A));
  StrToHugeIntB('-9223372036854775808', A);
  Assert(HugeIntToStrB(A) = '-9223372036854775808');
  HugeIntAbsInPlace(A);
  Assert(HugeIntToStrB(A) = '9223372036854775808');
  Assert(HugeIntToHexB(A) = '8000000000000000');
  Assert(not HugeIntEqualsInt64(A, MinInt64 { -$8000000000000000 }));
  Assert(HugeIntCompareInt64(A, MinInt64 { -$8000000000000000 }) = 1);
  Assert(not HugeIntIsInt64Range(A));
  HugeIntNegate(A);
  Assert(HugeIntToInt64(A) = MinInt64 { -$8000000000000000 });

  // MinInt64 + 1 (-$7FFFFFFFFFFFFFFF)
  HugeIntAssignInt64(A, -$7FFFFFFFFFFFFFFF);
  Assert(HugeIntToInt64(A) = -$7FFFFFFFFFFFFFFF);
  Assert(HugeIntToStrB(A) = '-9223372036854775807');
  Assert(HugeIntToHexB(A) = '-7FFFFFFFFFFFFFFF');
  {$IFNDEF DELPHIXE2_UP}
  {$IFNDEF FREEPASCAL}
  {$IFNDEF CPU_32}
  Assert(HugeIntToDouble(A) = Double(-9223372036854775807.0));
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  Assert(HugeIntEqualsInt64(A, -$7FFFFFFFFFFFFFFF));
  Assert(not HugeIntEqualsInt64(A, MinInt64 { -$8000000000000000 }));
  Assert(HugeIntCompareInt64(A, -$7FFFFFFFFFFFFFFE) = -1);
  Assert(HugeIntCompareInt64(A, -$7FFFFFFFFFFFFFFF) = 0);
  Assert(HugeIntCompareInt64(A, MinInt64 { -$8000000000000000 }) = 1);
  Assert(HugeIntIsInt64Range(A));
  HugeIntAbsInPlace(A);
  Assert(HugeIntToStrB(A) = '9223372036854775807');
  Assert(HugeIntToHexB(A) = '7FFFFFFFFFFFFFFF');
  Assert(HugeIntToInt64(A) = $7FFFFFFFFFFFFFFF);
  Assert(HugeIntEqualsInt64(A, $7FFFFFFFFFFFFFFF));
  Assert(not HugeIntEqualsInt64(A, MinInt64 { -$8000000000000000 }));
  Assert(HugeIntCompareInt64(A, MinInt64 { -$8000000000000000 }) = 1);
  Assert(HugeIntIsInt64Range(A));
  HugeIntNegate(A);
  Assert(HugeIntToInt64(A) = -$7FFFFFFFFFFFFFFF);

  // MinInt64 - 1 (-$8000000000000001)
  HugeIntAssignInt64(A, MinInt64 { -$8000000000000000 });
  HugeIntSubtractInt32(A, 1);
  Assert(HugeIntToStrB(A) = '-9223372036854775809');
  Assert(HugeIntToHexB(A) = '-8000000000000001');
  {$IFNDEF DELPHIXE2_UP}
  {$IFNDEF FREEPASCAL}
  {$IFNDEF CPU_32}
  Assert(HugeIntToDouble(A) = Double(-9223372036854775809.0));
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  Assert(not HugeIntEqualsInt64(A, MinInt64 { -$8000000000000000 }));
  Assert(HugeIntCompareInt64(A, MinInt64 { -$8000000000000000 }) = -1);
  Assert(not HugeIntIsInt64Range(A));
  HugeIntAbsInPlace(A);
  Assert(HugeIntToStrB(A) = '9223372036854775809');
  Assert(not HugeIntEqualsInt64(A, MinInt64 { -$8000000000000000 }));
  Assert(HugeIntCompareInt64(A, MinInt64 { -$8000000000000000 }) = 1);
  HugeIntNegate(A);
  Assert(HugeIntToStrB(A) = '-9223372036854775809');

  // Equals/Compare
  HugeIntAssignInt32(A, -1);
  HugeIntAssignWord32(B, 2);
  HugeIntAssignZero(C);
  Assert(HugeIntEqualsInt32(A, -1));
  Assert(not HugeIntEqualsInt32(A, 1));
  Assert(HugeIntEqualsWord32(B, 2));
  Assert(HugeIntEqualsInt32(B, 2));
  Assert(not HugeIntEqualsInt32(B, -2));
  Assert(HugeIntEqualsInt32(C, 0));
  Assert(HugeIntEqualsWord32(C, 0));
  Assert(not HugeIntEqualsWord32(C, 1));
  Assert(HugeIntEqualsInt64(C, 0));
  Assert(not HugeIntEqualsInt64(A, 1));
  Assert(HugeIntCompareWord32(A, 0) = -1);
  Assert(HugeIntCompareWord32(A, 1) = -1);
  Assert(HugeIntCompareWord32(B, 1) = 1);
  Assert(HugeIntCompareWord32(B, 2) = 0);
  Assert(HugeIntCompareWord32(C, 0) = 0);
  Assert(HugeIntCompareWord32(C, 1) = -1);
  Assert(HugeIntCompareInt32(A, 0) = -1);
  Assert(HugeIntCompareInt32(A, -1) = 0);
  Assert(HugeIntCompareInt32(A, -2) = 1);
  Assert(HugeIntCompareInt32(C, -1) = 1);
  Assert(HugeIntCompareInt32(C, 0) = 0);
  Assert(HugeIntCompareInt32(C, 1) = -1);
  Assert(HugeIntCompareInt64(A, 0) = -1);
  Assert(HugeIntCompareInt64(A, -1) = 0);
  Assert(HugeIntCompareInt64(A, -2) = 1);
  Assert(HugeIntCompareInt64(C, 0) = 0);
  Assert(HugeIntCompareInt64(C, 1) = -1);
  Assert(not HugeIntEqualsHugeInt(A, B));
  Assert(not HugeIntEqualsHugeInt(B, C));
  Assert(HugeIntEqualsHugeInt(A, A));
  Assert(HugeIntEqualsHugeInt(B, B));
  Assert(HugeIntEqualsHugeInt(C, C));
  Assert(HugeIntCompareHugeInt(A, B) = -1);
  Assert(HugeIntCompareHugeInt(B, A) = 1);
  Assert(HugeIntCompareHugeInt(A, A) = 0);
  Assert(HugeIntCompareHugeInt(B, B) = 0);
  Assert(HugeIntCompareHugeInt(C, A) = 1);
  Assert(HugeIntCompareHugeInt(C, B) = -1);
  Assert(HugeIntCompareHugeInt(C, C) = 0);
  Assert(HugeIntCompareHugeInt(A, C) = -1);
  Assert(HugeIntCompareHugeInt(B, C) = 1);
  Assert(HugeIntCompareHugeIntAbs(A, B) = -1);
  Assert(HugeIntCompareHugeIntAbs(B, A) = 1);
  Assert(HugeIntCompareHugeIntAbs(A, C) = 1);
  Assert(HugeIntCompareHugeIntAbs(B, C) = 1);
  Assert(HugeIntCompareHugeIntAbs(C, A) = -1);
  Assert(HugeIntCompareHugeIntAbs(C, B) = -1);
  Assert(HugeIntCompareHugeIntAbs(A, A) = 0);
  Assert(HugeIntCompareHugeIntAbs(B, B) = 0);
  Assert(HugeIntCompareHugeIntAbs(C, C) = 0);

  // Min/Max
  HugeIntAssignInt32(A, -1);
  HugeIntAssignInt32(B, 0);
  HugeIntAssignInt32(C, 1);
  HugeIntMin(A, B);
  Assert(HugeIntToInt32(A) = -1);
  HugeIntMin(B, A);
  Assert(HugeIntToInt32(B) = -1);
  HugeIntMax(C, A);
  Assert(HugeIntToInt32(C) = 1);
  HugeIntMax(A, C);
  Assert(HugeIntToInt32(A) = 1);

  // Swap
  HugeIntAssignInt32(A, 0);
  HugeIntAssignInt32(B, 1);
  HugeIntSwap(A, B);
  Assert(HugeIntToInt32(A) = 1);
  Assert(HugeIntToInt32(B) = 0);

  // Add/Subtract
  HugeIntAssignInt32(A, 0);
  HugeIntAssignInt32(B, 1);
  HugeIntAssignInt32(C, -1);
  HugeIntAddHugeInt(A, B);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntAddHugeInt(A, B);
  Assert(HugeIntToInt32(A) = 2);
  HugeIntAddHugeInt(A, C);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntAddHugeInt(A, C);
  Assert(HugeIntToInt32(A) = 0);
  HugeIntAddHugeInt(A, C);
  Assert(HugeIntToInt32(A) = -1);
  HugeIntAddHugeInt(A, C);
  Assert(HugeIntToInt32(A) = -2);
  HugeIntAddHugeInt(A, B);
  Assert(HugeIntToInt32(A) = -1);
  HugeIntAddHugeInt(A, B);
  Assert(HugeIntToInt32(A) = 0);
  HugeIntAddHugeInt(A, B);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntSubtractHugeInt(A, B);
  Assert(HugeIntToInt32(A) = 0);
  HugeIntSubtractHugeInt(A, B);
  Assert(HugeIntToInt32(A) = -1);
  HugeIntSubtractHugeInt(A, B);
  Assert(HugeIntToInt32(A) = -2);
  HugeIntSubtractHugeInt(A, C);
  Assert(HugeIntToInt32(A) = -1);
  HugeIntSubtractHugeInt(A, C);
  Assert(HugeIntToInt32(A) = 0);
  HugeIntSubtractHugeInt(A, C);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntSubtractHugeInt(A, C);
  Assert(HugeIntToInt32(A) = 2);

  // Add/Subtract
  HugeIntAssignInt32(A, 0);
  HugeIntAddInt32(A, 1);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntAddInt32(A, -1);
  Assert(HugeIntToInt32(A) = 0);
  HugeIntAddInt32(A, -1);
  Assert(HugeIntToInt32(A) = -1);
  HugeIntAddInt32(A, -1);
  Assert(HugeIntToInt32(A) = -2);
  HugeIntAddInt32(A, 1);
  Assert(HugeIntToInt32(A) = -1);
  HugeIntAddInt32(A, 1);
  Assert(HugeIntToInt32(A) = 0);
  HugeIntAddInt32(A, 1);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntAddInt32(A, 1);
  Assert(HugeIntToInt32(A) = 2);
  HugeIntSubtractInt32(A, 1);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntSubtractInt32(A, 1);
  Assert(HugeIntToInt32(A) = 0);
  HugeIntSubtractInt32(A, 1);
  Assert(HugeIntToInt32(A) = -1);
  HugeIntSubtractInt32(A, 1);
  Assert(HugeIntToInt32(A) = -2);
  HugeIntSubtractInt32(A, -1);
  Assert(HugeIntToInt32(A) = -1);
  HugeIntSubtractInt32(A, -1);
  Assert(HugeIntToInt32(A) = 0);
  HugeIntSubtractInt32(A, -1);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntSubtractInt32(A, -1);
  Assert(HugeIntToInt32(A) = 2);

  // Add/Subtract
  HugeIntAssignInt32(A, -1);
  HugeIntAddWord32(A, 1);
  Assert(HugeIntToInt32(A) = 0);
  HugeIntAddWord32(A, 1);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntAddWord32(A, 1);
  Assert(HugeIntToInt32(A) = 2);
  HugeIntSubtractWord32(A, 1);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntSubtractWord32(A, 1);
  Assert(HugeIntToInt32(A) = 0);
  HugeIntSubtractWord32(A, 1);
  Assert(HugeIntToInt32(A) = -1);
  HugeIntSubtractWord32(A, 1);
  Assert(HugeIntToInt32(A) = -2);

  // Multiply
  HugeIntAssignInt32(A, 10);
  HugeIntMultiplyWord8(A, 10);
  Assert(HugeIntToInt32(A) = 100);
  HugeIntMultiplyWord16(A, 10);
  Assert(HugeIntToInt32(A) = 1000);
  HugeIntMultiplyWord32(A, 10);
  Assert(HugeIntToInt32(A) = 10000);
  HugeIntAssignInt32(A, -10);
  HugeIntMultiplyWord8(A, 10);
  Assert(HugeIntToInt32(A) = -100);
  HugeIntMultiplyWord16(A, 10);
  Assert(HugeIntToInt32(A) = -1000);
  HugeIntMultiplyWord32(A, 10);
  Assert(HugeIntToInt32(A) = -10000);

  // Multiply
  HugeIntAssignInt32(A, -10);
  HugeIntMultiplyInt8(A, -10);
  Assert(HugeIntToInt32(A) = 100);
  HugeIntMultiplyInt8(A, 10);
  Assert(HugeIntToInt32(A) = 1000);
  HugeIntMultiplyInt8(A, -10);
  Assert(HugeIntToInt32(A) = -10000);
  HugeIntMultiplyInt8(A, 10);
  Assert(HugeIntToInt32(A) = -100000);
  HugeIntMultiplyInt8(A, 0);
  Assert(HugeIntToInt32(A) = 0);

  // Multiply
  HugeIntAssignInt32(A, -10);
  HugeIntMultiplyInt16(A, -10);
  Assert(HugeIntToInt32(A) = 100);
  HugeIntMultiplyInt16(A, 10);
  Assert(HugeIntToInt32(A) = 1000);
  HugeIntMultiplyInt16(A, -10);
  Assert(HugeIntToInt32(A) = -10000);
  HugeIntMultiplyInt16(A, 10);
  Assert(HugeIntToInt32(A) = -100000);
  HugeIntMultiplyInt16(A, 0);
  Assert(HugeIntToInt32(A) = 0);

  // Multiply
  HugeIntAssignInt32(A, -10);
  HugeIntMultiplyInt32(A, -10);
  Assert(HugeIntToInt32(A) = 100);
  HugeIntMultiplyInt32(A, 10);
  Assert(HugeIntToInt32(A) = 1000);
  HugeIntMultiplyInt32(A, -10);
  Assert(HugeIntToInt32(A) = -10000);
  HugeIntMultiplyInt32(A, 10);
  Assert(HugeIntToInt32(A) = -100000);
  HugeIntMultiplyInt32(A, 0);
  Assert(HugeIntToInt32(A) = 0);

  // Multiply
  HugeIntAssignInt32(A, 10);
  HugeIntAssignInt32(B, 10);
  HugeIntAssignInt32(C, -10);
  HugeIntMultiplyHugeInt(A, B);
  Assert(HugeIntToInt32(A) = 100);
  HugeIntMultiplyHugeInt(A, C);
  Assert(HugeIntToInt32(A) = -1000);
  HugeIntMultiplyHugeInt(A, B);
  Assert(HugeIntToInt32(A) = -10000);
  HugeIntMultiplyHugeInt(A, C);
  Assert(HugeIntToInt32(A) = 100000);
  HugeIntAssignInt32(B, 1);
  HugeIntMultiplyHugeInt(A, B);
  Assert(HugeIntToInt32(A) = 100000);
  HugeIntAssignInt32(B, -1);
  HugeIntMultiplyHugeInt(A, B);
  Assert(HugeIntToInt32(A) = -100000);
  HugeIntAssignInt32(B, 0);
  HugeIntMultiplyHugeInt(A, B);
  Assert(HugeIntToInt32(A) = 0);

  // Multiply
  HugeIntAssignInt32(A, 10);
  HugeWordAssignWord32(F, 10);
  HugeIntMultiplyHugeWord(A, F);
  Assert(HugeIntToInt32(A) = 100);
  HugeIntAssignInt32(A, -10);
  HugeIntMultiplyHugeWord(A, F);
  Assert(HugeIntToInt32(A) = -100);

  // Sqr
  HugeIntAssignInt32(A, -17);
  HugeIntSqr(A);
  Assert(HugeIntToInt32(A) = 289);

  // ISqrt
  HugeIntAssignInt32(A, 289);
  HugeIntISqrt(A);
  Assert(HugeIntToInt32(A) = 17);

  // Divide
  HugeIntAssignInt32(A, -1000);
  HugeIntDivideWord32(A, 3, B, K);
  Assert(HugeIntToInt32(B) = -333);
  Assert(K = 1);

  // Divide
  HugeIntAssignInt32(A, -1000);
  HugeIntDivideInt32(A, 3, B, L);
  Assert(HugeIntToInt32(B) = -333);
  Assert(L = 1);
  HugeIntDivideInt32(A, -3, B, L);
  Assert(HugeIntToInt32(B) = 333);
  Assert(L = 1);
  HugeIntAssignInt32(A, 1000);
  HugeIntDivideInt32(A, 3, B, L);
  Assert(HugeIntToInt32(B) = 333);
  Assert(L = 1);
  HugeIntDivideInt32(A, -3, B, L);
  Assert(HugeIntToInt32(B) = -333);
  Assert(L = 1);

  // Divide
  HugeIntAssignInt32(A, -1000);
  HugeIntAssignInt32(B, 3);
  HugeIntDivideHugeInt(A, B, C, D);
  Assert(HugeIntToInt32(C) = -333);
  Assert(HugeIntToInt32(D) = 1);
  HugeIntAssignInt32(B, -3);
  HugeIntDivideHugeInt(A, B, C, D);
  Assert(HugeIntToInt32(C) = 333);
  Assert(HugeIntToInt32(D) = 1);
  HugeIntAssignInt32(A, 1000);
  HugeIntAssignInt32(B, 3);
  HugeIntDivideHugeInt(A, B, C, D);
  Assert(HugeIntToInt32(C) = 333);
  Assert(HugeIntToInt32(D) = 1);
  HugeIntAssignInt32(B, -3);
  HugeIntDivideHugeInt(A, B, C, D);
  Assert(HugeIntToInt32(C) = -333);
  Assert(HugeIntToInt32(D) = 1);

  // Mod
  HugeIntAssignInt32(A, -1000);
  HugeIntAssignInt32(B, 3);
  HugeIntMod(A, B, C);
  Assert(HugeIntToInt32(C) = 1);

  // Power
  HugeIntAssignInt32(A, -2);
  HugeIntPower(A, 0);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntAssignInt32(A, -2);
  HugeIntPower(A, 1);
  Assert(HugeIntToInt32(A) = -2);
  HugeIntAssignInt32(A, -2);
  HugeIntPower(A, 2);
  Assert(HugeIntToInt32(A) = 4);
  HugeIntAssignInt32(A, -2);
  HugeIntPower(A, 3);
  Assert(HugeIntToInt32(A) = -8);
  HugeIntAssignInt32(A, -2);
  HugeIntPower(A, 4);
  Assert(HugeIntToInt32(A) = 16);

  // Power
  HugeIntAssignZero(A);
  HugeIntPower(A, 0);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntAssignZero(A);
  HugeIntPower(A, 1);
  Assert(HugeIntToInt32(A) = 0);
  HugeIntAssignOne(A);
  HugeIntPower(A, 0);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntAssignOne(A);
  HugeIntPower(A, 1);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntAssignMinusOne(A);
  HugeIntPower(A, 0);
  Assert(HugeIntToInt32(A) = 1);
  HugeIntAssignMinusOne(A);
  HugeIntPower(A, 1);
  Assert(HugeIntToInt32(A) = -1);
  HugeIntAssignMinusOne(A);
  HugeIntPower(A, 2);
  Assert(HugeIntToInt32(A) = 1);

  // AssignDouble
  HugeIntAssignDouble(A, 0.0);
  Assert(HugeIntToDouble(A) = 0.0);
  HugeIntAssignDouble(A, 1.0);
  Assert(HugeIntToDouble(A) = 1.0);
  HugeIntAssignDouble(A, -1.0);
  Assert(HugeIntToDouble(A) = -1.0);

  // ToStr/StrTo
  StrToHugeIntB('-1234567890', A);
  Assert(HugeIntToInt32(A) = -1234567890);
  Assert(HugeIntToStrB(A) = '-1234567890');
  Assert(HugeIntToHexB(A) = '-499602D2');
  StrToHugeIntB('123456789012345678901234567890123456789012345678901234567890', A);
  Assert(HugeIntToStrB(A) = '123456789012345678901234567890123456789012345678901234567890');

  // ToHex/HexTo
  HexToHugeIntB('-0123456789ABCDEF', A);
  Assert(HugeIntToHexB(A) = '-0123456789ABCDEF');
  HexToHugeIntB('-F1230', A);
  Assert(HugeIntToHexB(A) = '-000F1230');

  HugeWordFinalise(F);
  HugeIntFinalise(D);
  HugeIntFinalise(C);
  HugeIntFinalise(B);
  HugeIntFinalise(A);
end;

procedure Test;
begin
  Assert(HugeWordElementBits = 32);
  Test_HugeWord;
  Test_HugeInt;
end;



end.
