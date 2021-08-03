{$INCLUDE ../../flcInclude.inc}
{$INCLUDE flcTest_Include.inc}

unit flcTest_Utils;

interface



procedure Test;



implementation

uses
  flcStdTypes,
  flcUtils;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
procedure Test_Misc;
var A, B : Byte;
    C, D : Word32;
    P, Q : TObject;
begin
  // Integer types
  Assert(Sizeof(Int16Rec) = Sizeof(Int16), 'Int16Rec');
  Assert(Sizeof(Int32Rec) = Sizeof(Int32), 'Int32Rec');

  // Min / Max
  Assert(MinInt(-1, 1) = -1);
  Assert(MaxInt(-1, 1) = 1);
  Assert(MinUInt(1, 2) = 1);
  Assert(MaxUInt(1, 2) = 2);
  Assert(MaxUInt($FFFFFFFF, 0) = $FFFFFFFF);
  Assert(MinUInt($FFFFFFFF, 0) = 0);

  Assert(MinNatInt(-1, 1) = -1);
  Assert(MaxNatInt(-1, 1) = 1);
  Assert(MinNatUInt(1, 2) = 1);
  Assert(MaxNatUInt(1, 2) = 2);
  Assert(MaxNatUInt($FFFFFFFF, 0) = $FFFFFFFF);
  Assert(MinNatUInt($FFFFFFFF, 0) = 0);

  // IsInRange8
  Assert(IsIntInUInt8Range(2));
  Assert(IsIntInUInt8Range(0));
  Assert(IsIntInUInt8Range($FF));
  Assert(not IsIntInUInt8Range(-1));
  Assert(not IsIntInUInt8Range($100));

  Assert(IsIntInInt8Range(2));
  Assert(IsIntInInt8Range(0));
  Assert(IsIntInInt8Range(-1));
  Assert(IsIntInInt8Range($7F));
  Assert(IsIntInInt8Range(-$80));
  Assert(not IsIntInInt8Range($FF));
  Assert(not IsIntInInt8Range($80));
  Assert(not IsIntInInt8Range(-$81));

  Assert(IsUIntInUInt8Range(2));
  Assert(IsUIntInUInt8Range(0));
  Assert(IsUIntInUInt8Range($FF));
  Assert(not IsUIntInUInt8Range($100));

  Assert(IsUIntInInt8Range(2));
  Assert(IsUIntInInt8Range(0));
  Assert(IsUIntInInt8Range($7F));
  Assert(not IsUIntInInt8Range($FF));
  Assert(not IsUIntInInt8Range($80));
  Assert(not IsUIntInInt8Range($100));

  // IsInRange16
  Assert(IsIntInUInt16Range(2));
  Assert(IsIntInUInt16Range(0));
  Assert(IsIntInUInt16Range($FFFF));
  Assert(not IsIntInUInt16Range(-1));
  Assert(not IsIntInUInt16Range($10000));

  Assert(IsIntInInt16Range(2));
  Assert(IsIntInInt16Range(0));
  Assert(IsIntInInt16Range(-1));
  Assert(IsIntInInt16Range($7FFF));
  Assert(IsIntInInt16Range(-$8000));
  Assert(not IsIntInInt16Range($FFFF));
  Assert(not IsIntInInt16Range($8000));
  Assert(not IsIntInInt16Range(-$8001));

  Assert(IsUIntInUInt16Range(2));
  Assert(IsUIntInUInt16Range(0));
  Assert(IsUIntInUInt16Range($FFFF));
  Assert(not IsUIntInUInt16Range($10000));

  Assert(IsUIntInInt16Range(2));
  Assert(IsUIntInInt16Range(0));
  Assert(IsUIntInInt16Range($7FFF));
  Assert(not IsUIntInInt16Range($FFFF));
  Assert(not IsUIntInInt16Range($8000));
  Assert(not IsUIntInInt16Range($10000));

  // IsInRange32
  Assert(IsIntInUInt32Range(2));
  Assert(IsIntInUInt32Range(0));
  Assert(IsIntInUInt32Range($FFFFFFFF));
  Assert(not IsIntInUInt32Range(-1));
  Assert(not IsIntInUInt32Range($100000000));

  Assert(IsIntInInt32Range(2));
  Assert(IsIntInInt32Range(0));
  Assert(IsIntInInt32Range(-1));
  Assert(IsIntInInt32Range($7FFFFFFF));
  {$IFNDEF DELPHI7}
  Assert(IsIntInInt32Range(-$80000000));
  {$ENDIF}
  Assert(not IsIntInInt32Range($FFFFFFFF));
  Assert(not IsIntInInt32Range($80000000));
  {$IFNDEF DELPHI7}
  Assert(not IsIntInInt32Range(-$80000001));
  {$ENDIF}

  Assert(IsUIntInUInt32Range(2));
  Assert(IsUIntInUInt32Range(0));
  Assert(IsUIntInUInt32Range($FFFFFFFF));
  Assert(not IsUIntInUInt32Range($100000000));

  Assert(IsUIntInInt32Range(2));
  Assert(IsUIntInInt32Range(0));
  Assert(IsUIntInInt32Range($7FFFFFFF));
  Assert(not IsUIntInInt32Range($FFFFFFFF));
  Assert(not IsUIntInInt32Range($80000000));
  Assert(not IsUIntInInt32Range($100000000));

  // Swap
  A := $11; B := $22;
  Swap(A, B);
  Assert((A = $22) and (B = $11),              'Swap');
  C := $11111111; D := $22222222;
  Swap(C, D);
  Assert((C = $22222222) and (D = $11111111),  'Swap');
  P := TObject.Create;
  Q := nil;
  SwapObjects(P, Q);
  Assert(Assigned(Q) and not Assigned(P),      'SwapObjects');
  Q.Free;

  // iif
  Assert(iif(True, 1, 2) = 1,         'iif');
  Assert(iif(False, 1, 2) = 2,        'iif');
  Assert(iif(True, -1, -2) = -1,      'iif');
  Assert(iif(False, -1, -2) = -2,     'iif');
  Assert(iif(True, '1', '2') = '1',   'iif');
  Assert(iif(False, '1', '2') = '2',  'iif');
  Assert(iifU(True, '1', '2') = '1',  'iif');
  Assert(iifU(False, '1', '2') = '2', 'iif');
  Assert(iif(True, 1.1, 2.2) = 1.1,   'iif');
  Assert(iif(False, 1.1, 2.2) = 2.2,  'iif');

  // Compare
  Assert(Compare(1, 1) = crEqual,          'Compare');
  Assert(Compare(1, 2) = crLess,           'Compare');
  Assert(Compare(1, 0) = crGreater,        'Compare');

  Assert(Compare(1.0, 1.0) = crEqual,      'Compare');
  Assert(Compare(1.0, 1.1) = crLess,       'Compare');
  Assert(Compare(1.0, 0.9) = crGreater,    'Compare');

  Assert(Compare(False, False) = crEqual,  'Compare');
  Assert(Compare(True, True) = crEqual,    'Compare');
  Assert(Compare(False, True) = crLess,    'Compare');
  Assert(Compare(True, False) = crGreater, 'Compare');

  {$IFDEF SupportAnsiString}
  Assert(CompareA(ToAnsiString(''), ToAnsiString('')) = crEqual,        'Compare');
  Assert(CompareA(ToAnsiString('a'), ToAnsiString('a')) = crEqual,      'Compare');
  Assert(CompareA(ToAnsiString('a'), ToAnsiString('b')) = crLess,       'Compare');
  Assert(CompareA(ToAnsiString('b'), ToAnsiString('a')) = crGreater,    'Compare');
  Assert(CompareA(ToAnsiString(''), ToAnsiString('a')) = crLess,        'Compare');
  Assert(CompareA(ToAnsiString('a'), ToAnsiString('')) = crGreater,     'Compare');
  Assert(CompareA(ToAnsiString('aa'), ToAnsiString('a')) = crGreater,   'Compare');
  {$ENDIF}

  Assert(CompareB(ToRawByteString(''), ToRawByteString('')) = crEqual,        'Compare');
  Assert(CompareB(ToRawByteString('a'), ToRawByteString('a')) = crEqual,      'Compare');
  Assert(CompareB(ToRawByteString('a'), ToRawByteString('b')) = crLess,       'Compare');
  Assert(CompareB(ToRawByteString('b'), ToRawByteString('a')) = crGreater,    'Compare');
  Assert(CompareB(ToRawByteString(''), ToRawByteString('a')) = crLess,        'Compare');
  Assert(CompareB(ToRawByteString('a'), ToRawByteString('')) = crGreater,     'Compare');
  Assert(CompareB(ToRawByteString('aa'), ToRawByteString('a')) = crGreater,   'Compare');

  Assert(CompareU(ToUnicodeString(''), ToUnicodeString('')) = crEqual,        'Compare');
  Assert(CompareU(ToUnicodeString('a'), ToUnicodeString('a')) = crEqual,      'Compare');
  Assert(CompareU(ToUnicodeString('a'), ToUnicodeString('b')) = crLess,       'Compare');
  Assert(CompareU(ToUnicodeString('b'), ToUnicodeString('a')) = crGreater,    'Compare');
  Assert(CompareU(ToUnicodeString(''), ToUnicodeString('a')) = crLess,        'Compare');
  Assert(CompareU(ToUnicodeString('a'), ToUnicodeString('')) = crGreater,     'Compare');
  Assert(CompareU(ToUnicodeString('aa'), ToUnicodeString('a')) = crGreater,   'Compare');

  Assert(Sgn(1) = 1,     'Sign');
  Assert(Sgn(0) = 0,     'Sign');
  Assert(Sgn(-1) = -1,   'Sign');
  Assert(Sgn(2) = 1,     'Sign');
  Assert(Sgn(-2) = -1,   'Sign');
  Assert(Sgn(-1.5) = -1, 'Sign');
  Assert(Sgn(1.5) = 1,   'Sign');
  Assert(Sgn(0.0) = 0,   'Sign');

  Assert(InverseCompareResult(crLess) = crGreater, 'ReverseCompareResult');
  Assert(InverseCompareResult(crGreater) = crLess, 'ReverseCompareResult');
end;

procedure Test_IntStr;
var I : Int64;
    W : Word32;
    {$IFDEF SupportAnsiString}
    L : Integer;
    U : UInt64;
    A : AnsiString;
    {$ENDIF}
begin
  Assert(HexCharDigitToInt('A') = 10,   'HexCharDigitToInt');
  Assert(HexCharDigitToInt('a') = 10,   'HexCharDigitToInt');
  Assert(HexCharDigitToInt('1') = 1,    'HexCharDigitToInt');
  Assert(HexCharDigitToInt('0') = 0,    'HexCharDigitToInt');
  Assert(HexCharDigitToInt('F') = 15,   'HexCharDigitToInt');
  Assert(HexCharDigitToInt('G') = -1,   'HexCharDigitToInt');

  {$IFDEF SupportAnsiString}
  Assert(IntToStringA(0) = ToAnsiString('0'),                           'IntToStringA');
  Assert(IntToStringA(1) = ToAnsiString('1'),                           'IntToStringA');
  Assert(IntToStringA(-1) = ToAnsiString('-1'),                         'IntToStringA');
  Assert(IntToStringA(10) = ToAnsiString('10'),                         'IntToStringA');
  Assert(IntToStringA(-10) = ToAnsiString('-10'),                       'IntToStringA');
  Assert(IntToStringA(123) = ToAnsiString('123'),                       'IntToStringA');
  Assert(IntToStringA(-123) = ToAnsiString('-123'),                     'IntToStringA');
  Assert(IntToStringA(MinInt32) = ToAnsiString('-2147483648'),          'IntToStringA');
  {$IFNDEF DELPHI7_DOWN}
  Assert(IntToStringA(-2147483649) = ToAnsiString('-2147483649'),       'IntToStringA');
  {$ENDIF}
  Assert(IntToStringA(MaxInt32) = ToAnsiString('2147483647'),           'IntToStringA');
  Assert(IntToStringA(2147483648) = ToAnsiString('2147483648'),         'IntToStringA');
  Assert(IntToStringA(MinInt64) = ToAnsiString('-9223372036854775808'), 'IntToStringA');
  Assert(IntToStringA(MaxInt64) = ToAnsiString('9223372036854775807'),  'IntToStringA');
  {$ENDIF}

  Assert(IntToStringB(0) = ToRawByteString('0'),                           'IntToStringB');
  Assert(IntToStringB(1) = ToRawByteString('1'),                           'IntToStringB');
  Assert(IntToStringB(-1) = ToRawByteString('-1'),                         'IntToStringB');
  Assert(IntToStringB(10) = ToRawByteString('10'),                         'IntToStringB');
  Assert(IntToStringB(-10) = ToRawByteString('-10'),                       'IntToStringB');
  Assert(IntToStringB(123) = ToRawByteString('123'),                       'IntToStringB');
  Assert(IntToStringB(-123) = ToRawByteString('-123'),                     'IntToStringB');
  Assert(IntToStringB(MinInt32) = ToRawByteString('-2147483648'),          'IntToStringB');
  {$IFNDEF DELPHI7_DOWN}
  Assert(IntToStringB(-2147483649) = ToRawByteString('-2147483649'),       'IntToStringB');
  {$ENDIF}
  Assert(IntToStringB(MaxInt32) = ToRawByteString('2147483647'),           'IntToStringB');
  Assert(IntToStringB(2147483648) = ToRawByteString('2147483648'),         'IntToStringB');
  Assert(IntToStringB(MinInt64) = ToRawByteString('-9223372036854775808'), 'IntToStringB');
  Assert(IntToStringB(MaxInt64) = ToRawByteString('9223372036854775807'),  'IntToStringB');

  Assert(IntToStringU(0) = '0',                     'IntToString');
  Assert(IntToStringU(1) = '1',                     'IntToString');
  Assert(IntToStringU(-1) = '-1',                   'IntToString');
  Assert(IntToStringU(1234567890) = '1234567890',   'IntToString');
  Assert(IntToStringU(-1234567890) = '-1234567890', 'IntToString');

  Assert(IntToString(0) = '0',                     'IntToString');
  Assert(IntToString(1) = '1',                     'IntToString');
  Assert(IntToString(-1) = '-1',                   'IntToString');
  Assert(IntToString(1234567890) = '1234567890',   'IntToString');
  Assert(IntToString(-1234567890) = '-1234567890', 'IntToString');

  {$IFDEF SupportAnsiString}
  Assert(UIntToStringA(0) = ToAnsiString('0'),                  'UIntToString');
  Assert(UIntToStringA($FFFFFFFF) = ToAnsiString('4294967295'), 'UIntToString');
  {$ENDIF}
  Assert(UIntToStringU(0) = '0',                  'UIntToString');
  Assert(UIntToStringU($FFFFFFFF) = '4294967295', 'UIntToString');
  Assert(UIntToString(0) = '0',                   'UIntToString');
  Assert(UIntToString($FFFFFFFF) = '4294967295',  'UIntToString');

  {$IFDEF SupportAnsiString}
  Assert(Word32ToStrA(0, 8) = ToAnsiString('00000000'),           'Word32ToStr');
  Assert(Word32ToStrA($FFFFFFFF, 0) = ToAnsiString('4294967295'), 'Word32ToStr');
  {$ENDIF}
  Assert(Word32ToStrB(0, 8) = ToRawByteString('00000000'),           'Word32ToStr');
  Assert(Word32ToStrB($FFFFFFFF, 0) = ToRawByteString('4294967295'), 'Word32ToStr');
  Assert(Word32ToStrU(0, 8) = '00000000',           'Word32ToStr');
  Assert(Word32ToStrU($FFFFFFFF, 0) = '4294967295', 'Word32ToStr');
  Assert(Word32ToStr(0, 8) = '00000000',            'Word32ToStr');
  Assert(Word32ToStr($FFFFFFFF, 0) = '4294967295',  'Word32ToStr');
  Assert(Word32ToStr(123) = '123',                  'Word32ToStr');
  Assert(Word32ToStr(10000) = '10000',              'Word32ToStr');
  Assert(Word32ToStr(99999) = '99999',              'Word32ToStr');
  Assert(Word32ToStr(1, 1) = '1',                   'Word32ToStr');
  Assert(Word32ToStr(1, 3) = '001',                 'Word32ToStr');
  Assert(Word32ToStr(1234, 3) = '1234',             'Word32ToStr');

  {$IFDEF SupportAnsiString}
  Assert(UIntToStringA(0) = ToAnsiString('0'),                     'UIntToString');
  Assert(UIntToStringA($FFFFFFFF) = ToAnsiString('4294967295'),    'UIntToString');
  {$ENDIF}
  Assert(UIntToStringB(0) = ToRawByteString('0'),                  'UIntToString');
  Assert(UIntToStringB($FFFFFFFF) = ToRawByteString('4294967295'), 'UIntToString');
  Assert(UIntToStringU(0) = '0',                                   'UIntToString');
  Assert(UIntToStringU($FFFFFFFF) = '4294967295',                  'UIntToString');
  Assert(UIntToString(0) = '0',                                    'UIntToString');
  Assert(UIntToString($FFFFFFFF) = '4294967295',                   'UIntToString');
  Assert(UIntToString(123) = '123',                                'UIntToString');
  Assert(UIntToString(10000) = '10000',                            'UIntToString');
  Assert(UIntToString(99999) = '99999',                            'UIntToString');
  Assert(UIntToString(1) = '1',                                    'UIntToString');
  Assert(UIntToString(1234) = '1234',                              'UIntToString');
  Assert(UIntToString($100000000) = '4294967296',                  'UIntToString');
  Assert(UIntToString(MaxUInt64) = '18446744073709551615',         'UIntToString');
  Assert(UIntToString(MaxUInt64 - 5) = '18446744073709551610',     'UIntToString');

  {$IFDEF SupportAnsiString}
  Assert(Word32ToHexA(0, 8) = ToAnsiString('00000000'),         'Word32ToHex');
  Assert(Word32ToHexA($FFFFFFFF, 0) = ToAnsiString('FFFFFFFF'), 'Word32ToHex');
  Assert(Word32ToHexA($10000) = ToAnsiString('10000'),          'Word32ToHex');
  Assert(Word32ToHexA($12345678) = ToAnsiString('12345678'),    'Word32ToHex');
  Assert(Word32ToHexA($AB, 4) = ToAnsiString('00AB'),           'Word32ToHex');
  Assert(Word32ToHexA($ABCD, 8) = ToAnsiString('0000ABCD'),     'Word32ToHex');
  Assert(Word32ToHexA($CDEF, 2) = ToAnsiString('CDEF'),         'Word32ToHex');
  Assert(Word32ToHexA($ABC3, 0, False) = ToAnsiString('abc3'),  'Word32ToHex');
  {$ENDIF}

  Assert(Word32ToHexU(0, 8) = '00000000',         'Word32ToHex');
  Assert(Word32ToHexU(0) = '0',                   'Word32ToHex');
  Assert(Word32ToHexU($FFFFFFFF, 0) = 'FFFFFFFF', 'Word32ToHex');
  Assert(Word32ToHexU($AB, 4) = '00AB',           'Word32ToHex');
  Assert(Word32ToHexU($ABC3, 0, False) = 'abc3',  'Word32ToHex');

  Assert(Word32ToHex(0, 8) = '00000000',          'Word32ToHex');
  Assert(Word32ToHex($FFFFFFFF, 0) = 'FFFFFFFF',  'Word32ToHex');
  Assert(Word32ToHex(0) = '0',                    'Word32ToHex');
  Assert(Word32ToHex($ABCD, 8) = '0000ABCD',      'Word32ToHex');
  Assert(Word32ToHex($ABC3, 0, False) = 'abc3',   'Word32ToHex');

  {$IFDEF SupportAnsiString}
  Assert(StringToIntA(ToAnsiString('0')) = 0,       'StringToInt');
  Assert(StringToIntA(ToAnsiString('1')) = 1,       'StringToInt');
  Assert(StringToIntA(ToAnsiString('-1')) = -1,     'StringToInt');
  Assert(StringToIntA(ToAnsiString('10')) = 10,     'StringToInt');
  Assert(StringToIntA(ToAnsiString('01')) = 1,      'StringToInt');
  Assert(StringToIntA(ToAnsiString('-10')) = -10,   'StringToInt');
  Assert(StringToIntA(ToAnsiString('-01')) = -1,    'StringToInt');
  Assert(StringToIntA(ToAnsiString('123')) = 123,   'StringToInt');
  Assert(StringToIntA(ToAnsiString('-123')) = -123, 'StringToInt');
  {$ENDIF}

  Assert(StringToIntB(ToRawByteString('321')) = 321,   'StringToInt');
  Assert(StringToIntB(ToRawByteString('-321')) = -321, 'StringToInt');

  Assert(StringToIntU('321') = 321,   'StringToInt');
  Assert(StringToIntU('-321') = -321, 'StringToInt');

  {$IFDEF SupportAnsiString}
  A := ToAnsiString('-012A');
  Assert(TryStringToInt64PB(PAnsiChar(A), Length(A), I, L) = convertOK,          'StringToInt');
  Assert((I = -12) and (L = 4),                                                  'StringToInt');
  A := ToAnsiString('-A012');
  Assert(TryStringToInt64PB(PAnsiChar(A), Length(A), I, L) = convertFormatError, 'StringToInt');
  Assert((I = 0) and (L = 1),                                                    'StringToInt');

  Assert(TryStringToInt64A(ToAnsiString('0'), I),                        'StringToInt');
  Assert(I = 0,                                            'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('-0'), I),                       'StringToInt');
  Assert(I = 0,                                            'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('+0'), I),                       'StringToInt');
  Assert(I = 0,                                            'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('1234'), I),                     'StringToInt');
  Assert(I = 1234,                                         'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('-1234'), I),                    'StringToInt');
  Assert(I = -1234,                                        'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('000099999'), I),                'StringToInt');
  Assert(I = 99999,                                        'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('999999999999999999'), I),       'StringToInt');
  Assert(I = 999999999999999999,                           'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('-999999999999999999'), I),      'StringToInt');
  Assert(I = -999999999999999999,                          'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('4294967295'), I),               'StringToInt');
  Assert(I = $FFFFFFFF,                                    'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('4294967296'), I),               'StringToInt');
  Assert(I = $100000000,                                   'StringToInt');
  Assert(TryStringToInt64A(ToAnsiString('9223372036854775807'), I),      'StringToInt');
  Assert(I = 9223372036854775807,                          'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(TryStringToInt64A(ToAnsiString('-9223372036854775808'), I),     'StringToInt');
  Assert(I = -9223372036854775808,                         'StringToInt');
  {$ENDIF}
  Assert(not TryStringToInt64A(ToAnsiString(''), I),                     'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('-'), I),                    'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('+'), I),                    'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('+-0'), I),                  'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('0A'), I),                   'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('1A'), I),                   'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString(' 0'), I),                   'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('0 '), I),                   'StringToInt');
  Assert(not TryStringToInt64A(ToAnsiString('9223372036854775808'), I),  'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(not TryStringToInt64A(ToAnsiString('-9223372036854775809'), I), 'StringToInt');
  {$ENDIF}
  {$ENDIF}

  {$IFDEF SupportUInt64}
  {$IFDEF SupportAnsiString}
  Assert(TryStringToUInt64A(ToAnsiString('0'), U),                        'StringToInt');
  Assert(U = 0,                                            'StringToInt');
  Assert(TryStringToUInt64A(ToAnsiString('1234'), U),                     'StringToInt');
  Assert(U = 1234,                                         'StringToInt');
  Assert(TryStringToUInt64A(ToAnsiString('000099999'), U),                'StringToInt');
  Assert(U = 99999,                                        'StringToInt');
  Assert(TryStringToUInt64A(ToAnsiString('999999999999999999'), U),       'StringToInt');
  Assert(U = 999999999999999999,                           'StringToInt');
  Assert(TryStringToUInt64A(ToAnsiString('4294967295'), U),               'StringToInt');
  Assert(U = $FFFFFFFF,                                    'StringToInt');
  Assert(TryStringToUInt64A(ToAnsiString('4294967296'), U),               'StringToInt');
  Assert(U = $100000000,                                   'StringToInt');
  Assert(TryStringToUInt64A(ToAnsiString('18446744073709551615'), U),      'StringToInt');
  Assert(U = 18446744073709551615,                          'StringToInt');
  Assert(not TryStringToUInt64A(ToAnsiString(''), U),                      'StringToInt');
  Assert(not TryStringToUInt64A(ToAnsiString('-'), U),                     'StringToInt');
  Assert(not TryStringToUInt64A(ToAnsiString('+'), U),                     'StringToInt');
  Assert(not TryStringToUInt64A(ToAnsiString('+-0'), U),                   'StringToInt');
  Assert(not TryStringToUInt64A(ToAnsiString('0A'), U),                    'StringToInt');
  Assert(not TryStringToUInt64A(ToAnsiString('1A'), U),                    'StringToInt');
  Assert(not TryStringToUInt64A(ToAnsiString(' 0'), U),                    'StringToInt');
  Assert(not TryStringToUInt64A(ToAnsiString('0 '), U),                    'StringToInt');
  Assert(not TryStringToUInt64A(ToAnsiString('18446744073709551616'), U),  'StringToInt');
  {$ENDIF}
  {$ENDIF}

  Assert(TryStringToInt64U('9223372036854775807', I),      'StringToInt');
  Assert(I = 9223372036854775807,                          'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(TryStringToInt64U('-9223372036854775808', I),     'StringToInt');
  Assert(I = -9223372036854775808,                         'StringToInt');
  Assert(not TryStringToInt64U('', I),                     'StringToInt');
  Assert(not TryStringToInt64U('-', I),                    'StringToInt');
  Assert(not TryStringToInt64U('0A', I),                   'StringToInt');
  Assert(not TryStringToInt64U('9223372036854775808', I),  'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(not TryStringToInt64U('-9223372036854775809', I), 'StringToInt');
  {$ENDIF}
  {$ENDIF}

  Assert(TryStringToInt64('9223372036854775807', I),       'StringToInt');
  Assert(I = 9223372036854775807,                          'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(TryStringToInt64('-9223372036854775808', I),      'StringToInt');
  Assert(I = -9223372036854775808,                         'StringToInt');
  {$ENDIF}
  Assert(not TryStringToInt64('', I),                      'StringToInt');
  Assert(not TryStringToInt64('-', I),                     'StringToInt');
  Assert(not TryStringToInt64('9223372036854775808', I),   'StringToInt');
  {$IFNDEF DELPHI7_DOWN}
  Assert(not TryStringToInt64('-9223372036854775809', I),  'StringToInt');
  {$ENDIF}

  {$IFDEF SupportAnsiString}
  Assert(StringToInt64A(ToAnsiString('0')) = 0,                                       'StringToInt64');
  Assert(StringToInt64A(ToAnsiString('1')) = 1,                                       'StringToInt64');
  Assert(StringToInt64A(ToAnsiString('-123')) = -123,                                 'StringToInt64');
  Assert(StringToInt64A(ToAnsiString('-0001')) = -1,                                  'StringToInt64');
  Assert(StringToInt64A(ToAnsiString('-9223372036854775807')) = -9223372036854775807, 'StringToInt64');
  {$IFNDEF DELPHI7_DOWN}
  Assert(StringToInt64A(ToAnsiString('-9223372036854775808')) = -9223372036854775808, 'StringToInt64');
  {$ENDIF}
  Assert(StringToInt64A(ToAnsiString('9223372036854775807')) = 9223372036854775807,   'StringToInt64');

  Assert(HexToUIntA(ToAnsiString('FFFFFFFF')) = $FFFFFFFF, 'HexStringToUInt');
  Assert(HexToUIntA(ToAnsiString('FFFFFFFF')) = $FFFFFFFF, 'HexStringToUInt');
  {$ENDIF}
  Assert(HexToUInt('FFFFFFFF') = $FFFFFFFF,  'HexStringToUInt');

  Assert(HexToWord32('FFFFFFFF') = $FFFFFFFF,  'HexToWord32');
  Assert(HexToWord32('0') = 0,                 'HexToWord32');
  Assert(HexToWord32('123456') = $123456,      'HexToWord32');
  Assert(HexToWord32('ABC') = $ABC,            'HexToWord32');
  Assert(HexToWord32('abc') = $ABC,            'HexToWord32');
  Assert(not TryHexToWord32('', W),            'HexToWord32');
  Assert(not TryHexToWord32('x', W),           'HexToWord32');

  {$IFDEF SupportAnsiString}
  Assert(HexToWord32A(ToAnsiString('FFFFFFFF')) = $FFFFFFFF, 'HexToWord32');
  Assert(HexToWord32A(ToAnsiString('0')) = 0,                'HexToWord32');
  Assert(HexToWord32A(ToAnsiString('ABC')) = $ABC,           'HexToWord32');
  Assert(HexToWord32A(ToAnsiString('abc')) = $ABC,           'HexToWord32');
  Assert(not TryHexToWord32A(ToAnsiString(''), W),           'HexToWord32');
  Assert(not TryHexToWord32A(ToAnsiString('x'), W),          'HexToWord32');
  {$ENDIF}

  Assert(HexToWord32B(ToRawByteString('FFFFFFFF')) = $FFFFFFFF, 'HexToWord32');
  Assert(HexToWord32B(ToRawByteString('0')) = 0,                'HexToWord32');
  Assert(HexToWord32B(ToRawByteString('ABC')) = $ABC,           'HexToWord32');
  Assert(HexToWord32B(ToRawByteString('abc')) = $ABC,           'HexToWord32');
  Assert(not TryHexToWord32B(ToRawByteString(''), W),           'HexToWord32');
  Assert(not TryHexToWord32B(ToRawByteString('x'), W),          'HexToWord32');

  Assert(HexToWord32U('FFFFFFFF') = $FFFFFFFF, 'HexToWord32');
  Assert(HexToWord32U('0') = 0,                'HexToWord32');
  Assert(HexToWord32U('123456') = $123456,     'HexToWord32');
  Assert(HexToWord32U('ABC') = $ABC,           'HexToWord32');
  Assert(HexToWord32U('abc') = $ABC,           'HexToWord32');
  Assert(not TryHexToWord32U('', W),           'HexToWord32');
  Assert(not TryHexToWord32U('x', W),          'HexToWord32');

  {$IFDEF SupportAnsiString}
  Assert(not TryStringToWord32A(ToAnsiString(''), W),             'StringToWord32');
  Assert(StringToWord32A(ToAnsiString('123')) = 123,              'StringToWord32');
  Assert(StringToWord32A(ToAnsiString('4294967295')) = $FFFFFFFF, 'StringToWord32');
  Assert(StringToWord32A(ToAnsiString('999999999')) = 999999999,  'StringToWord32');
  {$ENDIF}

  Assert(StringToWord32B(ToRawByteString('0')) = 0,                  'StringToWord32');
  Assert(StringToWord32B(ToRawByteString('4294967295')) = $FFFFFFFF, 'StringToWord32');

  Assert(StringToWord32U('0') = 0,                  'StringToWord32');
  Assert(StringToWord32U('4294967295') = $FFFFFFFF, 'StringToWord32');

  Assert(StringToWord32('0') = 0,                   'StringToWord32');
  Assert(StringToWord32('4294967295') = $FFFFFFFF,  'StringToWord32');
end;

procedure Test_Hash;
begin
  // HashStr
  {$IFDEF SupportAnsiString}
  Assert(HashStrA(ToAnsiString('Fundamentals')) = $3FB7796E, 'HashStr');
  Assert(HashStrA(ToAnsiString('0')) = $B2420DE,             'HashStr');
  Assert(HashStrA(ToAnsiString('Fundamentals'), 1, -1, False) = HashStrA(ToAnsiString('FUNdamentals'), 1, -1, False), 'HashStr');
  Assert(HashStrA(ToAnsiString('Fundamentals'), 1, -1, True) <> HashStrA(ToAnsiString('FUNdamentals'), 1, -1, True),  'HashStr');
  {$ENDIF}

  Assert(HashStrB(ToRawByteString('Fundamentals')) = $3FB7796E, 'HashStr');
  Assert(HashStrB(ToRawByteString('0')) = $B2420DE,             'HashStr');
  Assert(HashStrB(ToRawByteString('Fundamentals'), 1, -1, False) = HashStrB(ToRawByteString('FUNdamentals'), 1, -1, False), 'HashStr');
  Assert(HashStrB(ToRawByteString('Fundamentals'), 1, -1, True) <> HashStrB(ToRawByteString('FUNdamentals'), 1, -1, True),  'HashStr');

  Assert(HashStrU(ToUnicodeString('Fundamentals')) = $FD6ED837, 'HashStr');
  Assert(HashStrU(ToUnicodeString('0')) = $6160DBF3,            'HashStr');
  Assert(HashStrU(ToUnicodeString('Fundamentals'), 1, -1, False) = HashStrU(ToUnicodeString('FUNdamentals'), 1, -1, False), 'HashStr');
  Assert(HashStrU(ToUnicodeString('Fundamentals'), 1, -1, True) <> HashStrU(ToUnicodeString('FUNdamentals'), 1, -1, True),  'HashStr');

  {$IFDEF StringIsUnicode}
  Assert(HashStr('Fundamentals') = $FD6ED837, 'HashStr');
  Assert(HashStr('0') = $6160DBF3,            'HashStr');
  {$ELSE}
  Assert(HashStr('Fundamentals') = $3FB7796E, 'HashStr');
  Assert(HashStr('0') = $B2420DE,             'HashStr');
  {$ENDIF}
  Assert(HashStr('Fundamentals', 1, -1, False) = HashStr('FUNdamentals', 1, -1, False), 'HashStr');
  Assert(HashStr('Fundamentals', 1, -1, True) <> HashStr('FUNdamentals', 1, -1, True),  'HashStr');
end;

procedure Test_Memory;
var I, J : Integer;
    A, B : RawByteString;
    C, D : UnicodeString;
begin
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('0123456789ABC                       ');
  Assert(EqualMem(A[1], B[1], 0));
  Assert(EqualMem(A[1], B[1], 1));
  Assert(EqualMem(A[1], B[1], 13));
  Assert(EqualMem(A[13], B[13], 1));
  Assert(not EqualMem(A[1], B[1], 14));
  Assert(not EqualMem(A[13], B[13], 2));
  Assert(not EqualMem(A[14], B[14], 1));
  Assert(EqualMem(A[14], B[14], 0));
  for I := 1 to 13 do
    Assert(EqualMem(A[1], B[1], I));
  for I := 1 to 13 do
    Assert(EqualMem(A[I], B[I], 14 - I));
  for I := 14 to Length(A) do
    Assert(not EqualMem(A[1], B[1], I));
  for I := 14 to Length(A) do
    Assert(not EqualMem(A[I], B[I], Length(A) - I + 1));

  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('0123456789ABC                       ');
  Assert(EqualMemNoAsciiCaseB(A[1], B[1], 0));
  Assert(EqualMemNoAsciiCaseB(A[1], B[1], 1));
  Assert(EqualMemNoAsciiCaseB(A[1], B[1], 13));
  Assert(EqualMemNoAsciiCaseB(A[13], B[13], 1));
  Assert(not EqualMemNoAsciiCaseB(A[1], B[1], 14));
  Assert(not EqualMemNoAsciiCaseB(A[13], B[13], 2));
  Assert(not EqualMemNoAsciiCaseB(A[14], B[14], 1));
  Assert(EqualMemNoAsciiCaseB(A[14], B[14], 0));
  for I := 1 to 13 do
    Assert(EqualMemNoAsciiCaseB(A[1], B[1], I));
  for I := 1 to 13 do
    Assert(EqualMemNoAsciiCaseB(A[I], B[I], 14 - I));
  for I := 14 to Length(A) do
    Assert(not EqualMemNoAsciiCaseB(A[1], B[1], I));
  for I := 14 to Length(A) do
    Assert(not EqualMemNoAsciiCaseB(A[I], B[I], Length(A) - I + 1));

  A := ToRawByteString('0123456789AbCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('0123456789aBc                       ');
  Assert(EqualMemNoAsciiCaseB(A[1], B[1], 0));
  Assert(EqualMemNoAsciiCaseB(A[1], B[1], 1));
  Assert(EqualMemNoAsciiCaseB(A[1], B[1], 13));
  Assert(EqualMemNoAsciiCaseB(A[13], B[13], 1));
  Assert(not EqualMemNoAsciiCaseB(A[1], B[1], 14));
  Assert(not EqualMemNoAsciiCaseB(A[13], B[13], 2));
  Assert(not EqualMemNoAsciiCaseB(A[14], B[14], 1));
  Assert(EqualMemNoAsciiCaseB(A[14], B[14], 0));
  for I := 1 to 13 do
    Assert(EqualMemNoAsciiCaseB(A[1], B[1], I));
  for I := 1 to 13 do
    Assert(EqualMemNoAsciiCaseB(A[I], B[I], 14 - I));
  for I := 14 to Length(A) do
    Assert(not EqualMemNoAsciiCaseB(A[1], B[1], I));
  for I := 14 to Length(A) do
    Assert(not EqualMemNoAsciiCaseB(A[I], B[I], Length(A) - I + 1));

  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('0123456789ABC                       ');
  Assert(CompareMemB(A[1], B[1], 0) = 0);
  Assert(CompareMemB(A[1], B[1], -1) = 0);
  for I := 1 to 13 do
    Assert(CompareMemB(A[1], B[1], I) = 0);
  Assert(CompareMemB(A[1], B[1], 14) > 0);
  Assert(CompareMemB(A[1], B[1], Length(A)) > 0);
  for I := 1 to 13 do
    Assert(CompareMemB(B[1], A[1], I) = 0);
  Assert(CompareMemB(B[1], A[1], 14) < 0);
  Assert(CompareMemB(B[1], A[1], Length(A)) < 0);
  Assert(CompareMemB(A[1], A[1], 0) = 0);
  Assert(CompareMemB(A[1], A[1], 1) = 0);
  Assert(CompareMemB(A[1], A[1], Length(A)) = 0);
  Assert(CompareMemB(A[1], A[2], 1) < 0);
  Assert(CompareMemB(A[2], A[1], 1) > 0);
  Assert(CompareMemB(A[1], A[2], 0) = 0);
  Assert(CompareMemB(A[1], A[2], -1) = 0);
  Assert(CompareMemB(Pointer(A), Pointer(A), 1) = 0);
  Assert(CompareMemB(Pointer(A), Pointer(A), Length(A)) = 0);

  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('0123456789ABC                       ');
  Assert(CompareMemNoAsciiCaseB(A[1], B[1], 0) = 0);
  Assert(CompareMemNoAsciiCaseB(A[1], B[1], -1) = 0);
  for I := 1 to 13 do
    Assert(CompareMemNoAsciiCaseB(A[1], B[1], I) = 0);
  Assert(CompareMemNoAsciiCaseB(A[1], B[1], 14) > 0);
  Assert(CompareMemNoAsciiCaseB(A[1], B[1], Length(A)) > 0);
  for I := 1 to 13 do
    Assert(CompareMemNoAsciiCaseB(B[1], A[1], I) = 0);
  Assert(CompareMemNoAsciiCaseB(B[1], A[1], 14) < 0);
  Assert(CompareMemNoAsciiCaseB(B[1], A[1], Length(A)) < 0);
  Assert(CompareMemNoAsciiCaseB(A[1], A[1], 0) = 0);
  Assert(CompareMemNoAsciiCaseB(A[1], A[1], 1) = 0);
  Assert(CompareMemNoAsciiCaseB(A[1], A[1], Length(A)) = 0);
  Assert(CompareMemNoAsciiCaseB(A[1], A[2], 1) < 0);
  Assert(CompareMemNoAsciiCaseB(A[2], A[1], 1) > 0);
  Assert(CompareMemNoAsciiCaseB(A[1], A[2], 0) = 0);
  Assert(CompareMemNoAsciiCaseB(A[1], A[2], -1) = 0);
  Assert(CompareMemNoAsciiCaseB(Pointer(A), Pointer(A), 1) = 0);
  Assert(CompareMemNoAsciiCaseB(Pointer(A), Pointer(A), Length(A)) = 0);

  A := ToRawByteString('0123456789AbCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('0123456789aBc                       ');
  Assert(CompareMemNoAsciiCaseB(A[1], B[1], 0) = 0);
  Assert(CompareMemNoAsciiCaseB(A[1], B[1], -1) = 0);
  for I := 1 to 13 do
    Assert(CompareMemNoAsciiCaseB(A[1], B[1], I) = 0);
  Assert(CompareMemNoAsciiCaseB(A[1], B[1], 14) > 0);
  Assert(CompareMemNoAsciiCaseB(A[1], B[1], Length(A)) > 0);
  for I := 1 to 13 do
    Assert(CompareMemNoAsciiCaseB(B[1], A[1], I) = 0);
  Assert(CompareMemNoAsciiCaseB(B[1], A[1], 14) < 0);
  Assert(CompareMemNoAsciiCaseB(B[1], A[1], Length(A)) < 0);
  Assert(CompareMemNoAsciiCaseB(A[1], A[1], 0) = 0);
  Assert(CompareMemNoAsciiCaseB(A[1], A[1], 1) = 0);
  Assert(CompareMemNoAsciiCaseB(A[1], A[1], Length(A)) = 0);
  Assert(CompareMemNoAsciiCaseB(A[1], A[2], 1) < 0);
  Assert(CompareMemNoAsciiCaseB(A[2], A[1], 1) > 0);
  Assert(CompareMemNoAsciiCaseB(A[1], A[2], 0) = 0);
  Assert(CompareMemNoAsciiCaseB(A[1], A[2], -1) = 0);
  Assert(CompareMemNoAsciiCaseB(Pointer(A), Pointer(A), 1) = 0);
  Assert(CompareMemNoAsciiCaseB(Pointer(A), Pointer(A), Length(A)) = 0);

  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('0123456789ABCDE                     ');
  for I := 1 to 15 do
    Assert(EqualMem(A[1], B[1], I));
  Assert(not EqualMem(A[1], B[1], 16));
  for I := 1 to 15 do
    Assert(CompareMemB(A[1], B[1], I) = 0);
  Assert(CompareMemB(A[1], B[1], 16) > 0);

  for I := -1 to 33 do
    begin
      A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      B := ToRawByteString('                                    ');
      if I > 0 then
        Assert(not EqualMem(A[1], B[1], I),  'EqualMem');
      MoveMem(A[1], B[1], I);
      for J := 1 to MinInt(I, 10) do
        Assert(B[J] = AnsiChar(48 + J - 1),  'MoveMem');
      for J := 11 to MinInt(I, 36) do
        Assert(B[J] = AnsiChar(65 + J - 11), 'MoveMem');
      for J := MaxInt(I + 1, 1) to 36 do
        Assert(B[J] = AnsiChar(Ord(' ')),    'MoveMem');
      Assert(EqualMem(A[1], B[1], I),        'EqualMem');
    end;

  for J := 1000 to 1500 do
    begin
      SetLength(A, 4096);
      for I := 1 to 4096 do
        A[I] := AnsiChar(Ord('A'));
      SetLength(B, 4096);
      for I := 1 to 4096 do
        B[I] := AnsiChar(Ord('B'));
      Assert(not EqualMem(A[1], B[1], J),    'EqualMem');
      MoveMem(A[1], B[1], J);
      for I := 1 to J do
        Assert(B[I] = AnsiChar(Ord('A')),    'MoveMem');
      for I := J + 1 to 4096 do
        Assert(B[I] = AnsiChar(Ord('B')),    'MoveMem');
      Assert(EqualMem(A[1], B[1], J),        'EqualMem');
    end;

  B := ToRawByteString('1234567890');
  MoveMem(B[1], B[3], 4);
  Assert(B = ToRawByteString('1212347890'), 'MoveMem');
  MoveMem(B[3], B[2], 4);
  Assert(B = ToRawByteString('1123447890'), 'MoveMem');
  MoveMem(B[1], B[3], 2);
  Assert(B = ToRawByteString('1111447890'), 'MoveMem');
  MoveMem(B[5], B[7], 3);
  Assert(B = ToRawByteString('1111444470'), 'MoveMem');
  MoveMem(B[9], B[10], 1);
  Assert(B = ToRawByteString('1111444477'), 'MoveMem');

  for I := -1 to 33 do
    begin
      A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      ZeroMem(A[1], I);
      for J := 1 to I do
        Assert(A[J] = AnsiChar(0),              'ZeroMem');
      for J := MaxInt(I + 1, 1) to 10 do
        Assert(A[J] = AnsiChar(48 + J - 1),     'ZeroMem');
      for J := MaxInt(I + 1, 11) to 36 do
        Assert(A[J] = AnsiChar(65 + J - 11),    'ZeroMem');
    end;

  for I := -1 to 33 do
    begin
      A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      FillMem(A[1], I, Ord('!'));
      for J := 1 to I do
        Assert(A[J] = AnsiChar(Ord('!')),       'FillMem');
      for J := MaxInt(I + 1, 1) to 10 do
        Assert(A[J] = AnsiChar(48 + J - 1),     'FillMem');
      for J := MaxInt(I + 1, 11) to 36 do
        Assert(A[J] = AnsiChar(65 + J - 11),    'FillMem');
    end;

  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('0123456789ABC                       ');
  Assert(EqualMemNoAsciiCaseW(C[1], D[1], 0));
  Assert(EqualMemNoAsciiCaseW(C[1], D[1], 1));
  Assert(EqualMemNoAsciiCaseW(C[1], D[1], 13));
  Assert(EqualMemNoAsciiCaseW(C[13], D[13], 1));
  Assert(not EqualMemNoAsciiCaseW(C[1], D[1], 14));
  Assert(not EqualMemNoAsciiCaseW(C[13], D[13], 2));
  Assert(not EqualMemNoAsciiCaseW(C[14], D[14], 1));
  Assert(EqualMemNoAsciiCaseW(C[14], D[14], 0));
  for I := 1 to 13 do
    Assert(EqualMemNoAsciiCaseW(C[1], D[1], I));
  for I := 1 to 13 do
    Assert(EqualMemNoAsciiCaseW(C[I], D[I], 14 - I));
  for I := 14 to Length(C) do
    Assert(not EqualMemNoAsciiCaseW(C[1], D[1], I));
  for I := 14 to Length(C) do
    Assert(not EqualMemNoAsciiCaseW(C[I], D[I], Length(C) - I + 1));

  C := ToUnicodeString('0123456789AbCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('0123456789aBc                       ');
  Assert(EqualMemNoAsciiCaseW(C[1], D[1], 0));
  Assert(EqualMemNoAsciiCaseW(C[1], D[1], 1));
  Assert(EqualMemNoAsciiCaseW(C[1], D[1], 13));
  Assert(EqualMemNoAsciiCaseW(C[13], D[13], 1));
  Assert(not EqualMemNoAsciiCaseW(C[1], D[1], 14));
  Assert(not EqualMemNoAsciiCaseW(C[13], D[13], 2));
  Assert(not EqualMemNoAsciiCaseW(C[14], D[14], 1));
  Assert(EqualMemNoAsciiCaseW(C[14], D[14], 0));
  for I := 1 to 13 do
    Assert(EqualMemNoAsciiCaseW(C[1], D[1], I));
  for I := 1 to 13 do
    Assert(EqualMemNoAsciiCaseW(C[I], D[I], 14 - I));
  for I := 14 to Length(C) do
    Assert(not EqualMemNoAsciiCaseW(C[1], D[1], I));
  for I := 14 to Length(C) do
    Assert(not EqualMemNoAsciiCaseW(C[I], D[I], Length(C) - I + 1));

  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('0123456789ABC                       ');
  Assert(CompareMemW(C[1], D[1], 0) = 0);
  Assert(CompareMemW(C[1], D[1], -1) = 0);
  for I := 1 to 13 do
    Assert(CompareMemW(C[1], D[1], I) = 0);
  Assert(CompareMemW(C[1], D[1], 14) > 0);
  Assert(CompareMemW(C[1], D[1], Length(C)) > 0);
  for I := 1 to 13 do
    Assert(CompareMemW(D[1], C[1], I) = 0);
  Assert(CompareMemW(D[1], C[1], 14) < 0);
  Assert(CompareMemW(D[1], C[1], Length(C)) < 0);
  Assert(CompareMemW(C[1], C[1], 0) = 0);
  Assert(CompareMemW(C[1], C[1], 1) = 0);
  Assert(CompareMemW(C[1], C[1], Length(C)) = 0);
  Assert(CompareMemW(C[1], C[2], 1) < 0);
  Assert(CompareMemW(C[2], C[1], 1) > 0);
  Assert(CompareMemW(C[1], C[2], 0) = 0);
  Assert(CompareMemW(C[1], C[2], -1) = 0);
  Assert(CompareMemW(Pointer(C), Pointer(C), 1) = 0);
  Assert(CompareMemW(Pointer(C), Pointer(C), Length(C)) = 0);

  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('0123456789ABC                       ');
  Assert(CompareMemNoAsciiCaseW(C[1], D[1], 0) = 0);
  Assert(CompareMemNoAsciiCaseW(C[1], D[1], -1) = 0);
  for I := 1 to 13 do
    Assert(CompareMemNoAsciiCaseW(C[1], D[1], I) = 0);
  Assert(CompareMemNoAsciiCaseW(C[1], D[1], 14) > 0);
  Assert(CompareMemNoAsciiCaseW(C[1], D[1], Length(C)) > 0);
  for I := 1 to 13 do
    Assert(CompareMemNoAsciiCaseW(D[1], C[1], I) = 0);
  Assert(CompareMemNoAsciiCaseW(D[1], C[1], 14) < 0);
  Assert(CompareMemNoAsciiCaseW(D[1], C[1], Length(C)) < 0);
  Assert(CompareMemNoAsciiCaseW(C[1], C[1], 0) = 0);
  Assert(CompareMemNoAsciiCaseW(C[1], C[1], 1) = 0);
  Assert(CompareMemNoAsciiCaseW(C[1], C[1], Length(C)) = 0);
  Assert(CompareMemNoAsciiCaseW(C[1], C[2], 1) < 0);
  Assert(CompareMemNoAsciiCaseW(C[2], C[1], 1) > 0);
  Assert(CompareMemNoAsciiCaseW(C[1], C[2], 0) = 0);
  Assert(CompareMemNoAsciiCaseW(C[1], C[2], -1) = 0);
  Assert(CompareMemNoAsciiCaseW(Pointer(C), Pointer(C), 1) = 0);
  Assert(CompareMemNoAsciiCaseW(Pointer(C), Pointer(C), Length(C)) = 0);

  C := ToUnicodeString('0123456789AbCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('0123456789aBc                       ');
  Assert(CompareMemNoAsciiCaseW(C[1], D[1], 0) = 0);
  Assert(CompareMemNoAsciiCaseW(C[1], D[1], -1) = 0);
  for I := 1 to 13 do
    Assert(CompareMemNoAsciiCaseW(C[1], D[1], I) = 0);
  Assert(CompareMemNoAsciiCaseW(C[1], D[1], 14) > 0);
  Assert(CompareMemNoAsciiCaseW(C[1], D[1], Length(C)) > 0);
  for I := 1 to 13 do
    Assert(CompareMemNoAsciiCaseW(D[1], C[1], I) = 0);
  Assert(CompareMemNoAsciiCaseW(D[1], C[1], 14) < 0);
  Assert(CompareMemNoAsciiCaseW(D[1], C[1], Length(C)) < 0);
  Assert(CompareMemNoAsciiCaseW(C[1], C[1], 0) = 0);
  Assert(CompareMemNoAsciiCaseW(C[1], C[1], 1) = 0);
  Assert(CompareMemNoAsciiCaseW(C[1], C[1], Length(C)) = 0);
  Assert(CompareMemNoAsciiCaseW(C[1], C[2], 1) < 0);
  Assert(CompareMemNoAsciiCaseW(C[2], C[1], 1) > 0);
  Assert(CompareMemNoAsciiCaseW(C[1], C[2], 0) = 0);
  Assert(CompareMemNoAsciiCaseW(C[1], C[2], -1) = 0);
  Assert(CompareMemNoAsciiCaseW(Pointer(C), Pointer(C), 1) = 0);
  Assert(CompareMemNoAsciiCaseW(Pointer(C), Pointer(C), Length(C)) = 0);

  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('ABC');
  Assert(LocateMemB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = 10);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('ABCC');
  Assert(LocateMemB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = -1);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('');
  Assert(LocateMemB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = -1);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('0');
  Assert(LocateMemB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = 0);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('Z');
  Assert(LocateMemB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = 35);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('z');
  Assert(LocateMemB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = -1);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('ABCDEFGHIJKLMNOPQ');
  Assert(LocateMemB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = 10);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('ABCDEFGHIJKLMNOPq');
  Assert(LocateMemB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = -1);

  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('ABC');
  Assert(LocateMemNoAsciiCaseB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = 10);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('ABCC');
  Assert(LocateMemNoAsciiCaseB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = -1);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('');
  Assert(LocateMemNoAsciiCaseB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = -1);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('0');
  Assert(LocateMemNoAsciiCaseB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = 0);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('Z');
  Assert(LocateMemNoAsciiCaseB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = 35);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('z');
  Assert(LocateMemNoAsciiCaseB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = 35);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('ABCDEFGHIJKLMNOPQ');
  Assert(LocateMemNoAsciiCaseB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = 10);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('ABCDEFGHIJKLMNOPq');
  Assert(LocateMemNoAsciiCaseB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = 10);
  A := ToRawByteString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  B := ToRawByteString('aBc');
  Assert(LocateMemNoAsciiCaseB(Pointer(A)^, Length(A), Pointer(B)^, Length(B)) = 10);

  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('ABC');
  Assert(LocateMemW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = 10);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('ABCC');
  Assert(LocateMemW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = -1);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('');
  Assert(LocateMemW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = -1);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('0');
  Assert(LocateMemW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = 0);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('Z');
  Assert(LocateMemW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = 35);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('z');
  Assert(LocateMemW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = -1);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('ABCDEFGHIJKLMNOPQ');
  Assert(LocateMemW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = 10);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('ABCDEFGHIJKLMNOPq');
  Assert(LocateMemW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = -1);

  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('ABC');
  Assert(LocateMemNoAsciiCaseW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = 10);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('ABCC');
  Assert(LocateMemNoAsciiCaseW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = -1);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('');
  Assert(LocateMemNoAsciiCaseW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = -1);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('0');
  Assert(LocateMemNoAsciiCaseW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = 0);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('Z');
  Assert(LocateMemNoAsciiCaseW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = 35);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('z');
  Assert(LocateMemNoAsciiCaseW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = 35);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('ABCDEFGHIJKLMNOPQ');
  Assert(LocateMemNoAsciiCaseW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = 10);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('ABCDEFGHIJKLMNOPq');
  Assert(LocateMemNoAsciiCaseW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = 10);
  C := ToUnicodeString('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  D := ToUnicodeString('aBc');
  Assert(LocateMemNoAsciiCaseW(Pointer(C)^, Length(C), Pointer(D)^, Length(D)) = 10);
end;

procedure Test_Char;
var
  C : ByteChar;
begin
  Assert(CharEqualNoAsciiCaseB(AnsiChar('a'), AnsiChar('a')));
  Assert(CharEqualNoAsciiCaseB(AnsiChar('B'), AnsiChar('b')));
  Assert(not CharEqualNoAsciiCaseB(AnsiChar('C'), AnsiChar('D')));

  Assert(CharIsAsciiB(ByteChar(32)));
  Assert(CharIsAsciiW(#32));
  Assert(CharIsAscii(#32));

  Assert(not CharIsAsciiB(ByteChar(128)));
  Assert(not CharIsAsciiW(#128));
  Assert(not CharIsAscii(#128));

  {$IFDEF SupportAnsiChar}
  Assert(CharAsciiLowCaseB('A') = 'a');
  {$ENDIF}
  Assert(CharAsciiLowCaseW('A') = 'a');
  Assert(CharAsciiLowCase('A') = 'a');

  {$IFDEF SupportAnsiChar}
  Assert(CharAsciiLowCaseB('a') = 'a');
  {$ENDIF}
  Assert(CharAsciiLowCaseW('a') = 'a');
  Assert(CharAsciiLowCase('a') = 'a');

  {$IFDEF SupportAnsiChar}
  Assert(CharAsciiUpCaseB('A') = 'A');
  {$ENDIF}
  Assert(CharAsciiUpCaseW('A') = 'A');
  Assert(CharAsciiUpCase('A') = 'A');

  {$IFDEF SupportAnsiChar}
  Assert(CharAsciiUpCaseB('a') = 'A');
  {$ENDIF}
  Assert(CharAsciiUpCaseW('a') = 'A');
  Assert(CharAsciiUpCase('a') = 'A');

  for C := AnsiChar('A') to AnsiChar('Z') do
    Assert(CharAsciiLowCaseB(C) <> C);
  for C := AnsiChar('a') to AnsiChar('z') do
    Assert(CharAsciiLowCaseB(C) = C);
end;

{$IFDEF ImplementsStringRefCount}
procedure Test_StringRefCount;
const
  C1 = 'ABC';
var
  B, C : RawByteString;
  {$IFDEF SupportUnicodeString}
  U, V : UnicodeString;
  {$ENDIF}
begin
  B := C1;
  Assert(StringRefCount(B) = -1);
  C := B;
  Assert(StringRefCount(C) = -1);
  C[1] := '1';
  Assert(StringRefCount(C) = 1);
  B := C;
  Assert(StringRefCount(B) = 2);

  {$IFDEF SupportUnicodeString}
  U := C1;
  Assert(StringRefCount(U) = -1);
  V := U;
  Assert(StringRefCount(V) = -1);
  V[1] := '1';
  Assert(StringRefCount(V) = 1);
  U := V;
  Assert(StringRefCount(U) = 2);
  {$ENDIF}
end;
{$ENDIF}

procedure Test_String;
var
  S : RawByteString;
  T : RawByteString;
  A : UnicodeString;
  B : UnicodeString;
  X : String;
  W : WideChar;
const
  TestStrA1 : RawByteString = '012XYZabc{}_ ';
  TestStrA2 : RawByteString = #$80;
  TestStrA3 : RawByteString = '';
  TestStrU1 : UnicodeString = '012XYZabc{}_ ';
begin
  S := ToRawByteString('');
  T := StrAsciiUpperCaseB(S);
  Assert(T = '');

  S := ToRawByteString('1234567890AbCdefGhiJklmNopQRStuvWXyz');
  T := StrAsciiUpperCaseB(S);
  Assert(T = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ');

  S := ToRawByteString('1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  S := Copy(S, 1, Length(S));
  T := StrAsciiUpperCaseB(S);
  Assert(T = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  Assert(Pointer(T) = Pointer(S));


  S := ToRawByteString('');
  T := StrAsciiLowerCaseB(S);
  Assert(T = '');

  S := ToRawByteString('1234567890AbCdefGhiJklmNopQRStuvWXyz');
  T := StrAsciiLowerCaseB(S);
  Assert(T = '1234567890abcdefghijklmnopqrstuvwxyz');
  S := ToRawByteString('1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ');

  S := ToRawByteString('1234567890abcdefghijklmnopqrstuvwxyz');
  S := Copy(S, 1, Length(S));
  T := StrAsciiLowerCaseB(S);
  Assert(T = '1234567890abcdefghijklmnopqrstuvwxyz');
  Assert(Pointer(T) = Pointer(S));


  A := ToUnicodeString('');
  B := StrAsciiUpperCaseU(A);
  Assert(B = '');

  A := ToUnicodeString('1234567890AbCdefGhiJklmNopQRStuvWXyz');
  B := StrAsciiUpperCaseU(A);
  Assert(B = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ');

  A := ToUnicodeString('1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  A := Copy(A, 1, Length(A));
  B := StrAsciiUpperCaseU(A);
  Assert(B = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  Assert(Pointer(A) = Pointer(B));


  A := ToUnicodeString('');
  B := StrAsciiLowerCaseU(A);
  Assert(B = '');

  A := ToUnicodeString('1234567890AbCdefGhiJklmNopQRStuvWXyz');
  B := StrAsciiLowerCaseU(A);
  Assert(B = '1234567890abcdefghijklmnopqrstuvwxyz');
  A := ToUnicodeString('1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ');

  A := ToUnicodeString('1234567890abcdefghijklmnopqrstuvwxyz');
  A := Copy(A, 1, Length(A));
  B := StrAsciiLowerCaseU(A);
  Assert(B = '1234567890abcdefghijklmnopqrstuvwxyz');
  Assert(Pointer(A) = Pointer(B));

  {$IFDEF SupportAnsiChar}
  S := '012AbcdEF';
  Assert(StrAsciiLowerCaseB(S) ='012abcdef');
  StrAsciiConvertLowerCaseB(S);
  Assert(S = '012abcdef');
  {$ENDIF}

  A := '012AbcdEF';
  Assert(StrAsciiLowerCaseU(A) ='012abcdef');
  StrAsciiConvertLowerCaseU(A);
  Assert(A = '012abcdef');

  X := '012AbcdEF';
  Assert(StrAsciiLowerCase(X) ='012abcdef');
  StrAsciiConvertLowerCase(X);
  Assert(X = '012abcdef');

  {$IFDEF SupportAnsiChar}
  S := 'aBcDEfg-123';
  StrAsciiConvertUpperCaseB(S);
  Assert(S = 'ABCDEFG-123', 'ConvertUpper');

  S := 'aBcDEfg-123';
  StrAsciiConvertLowerCaseB(S);
  Assert(S = 'abcdefg-123', 'ConvertLower');

  S := '';
  StrAsciiConvertLowerCaseB(S);
  Assert(S = '', 'ConvertLower');

  S := 'abc';
  StrAsciiConvertLowerCaseB(S);
  Assert(S = 'abc', 'ConvertLower');
  {$ENDIF}

  {$IFDEF SupportAnsiChar}
  S := '012AbcdEF';
  Assert(StrAsciiUpperCaseB(S) = '012ABCDEF');
  StrAsciiConvertUpperCaseB(S);
  Assert(S = '012ABCDEF');
  {$ENDIF}

  A := '012AbcdEF';
  Assert(StrAsciiUpperCaseU(A) = '012ABCDEF');
  StrAsciiConvertUpperCaseU(A);
  Assert(A = '012ABCDEF');

  X := '012AbcdEF';
  Assert(StrAsciiUpperCase(X) = '012ABCDEF');
  StrAsciiConvertUpperCase(X);
  Assert(X = '012ABCDEF');

  {$IFDEF SupportAnsiChar}
  Assert(CharAsciiLowCaseB('A') = 'a', 'LowCase');
  {$ENDIF}
  Assert(UpCase('a') = 'A', 'UpCase');
  {$IFDEF SupportAnsiChar}
  Assert(CharAsciiLowCaseB('-') = '-', 'LowCase');
  {$ENDIF}

  {$IFDEF SupportAnsiChar}
  Assert(StrCompareNoAsciiCaseA('a', 'a') = 0);
  Assert(StrCompareNoAsciiCaseA('a', 'b') = -1);
  Assert(StrCompareNoAsciiCaseA('b', 'a') = 1);
  Assert(StrCompareNoAsciiCaseA('A', 'a') = 0);
  Assert(StrCompareNoAsciiCaseA('A', 'b') = -1);
  Assert(StrCompareNoAsciiCaseA('b', 'A') = 1);
  Assert(StrCompareNoAsciiCaseA('aa', 'a') = 1);
  Assert(StrCompareNoAsciiCaseA('a', 'aa') = -1);
  Assert(StrCompareNoAsciiCaseA('AA', 'b') = -1);
  Assert(StrCompareNoAsciiCaseA('B', 'aa') = 1);
  Assert(StrCompareNoAsciiCaseA('aa', 'Aa') = 0);

  Assert(StrCompareNoAsciiCaseB('a', 'a') = 0);
  Assert(StrCompareNoAsciiCaseB('a', 'b') = -1);
  Assert(StrCompareNoAsciiCaseB('b', 'a') = 1);
  Assert(StrCompareNoAsciiCaseB('A', 'a') = 0);
  Assert(StrCompareNoAsciiCaseB('A', 'b') = -1);
  Assert(StrCompareNoAsciiCaseB('b', 'A') = 1);
  Assert(StrCompareNoAsciiCaseB('aa', 'a') = 1);
  Assert(StrCompareNoAsciiCaseB('a', 'aa') = -1);
  Assert(StrCompareNoAsciiCaseB('AA', 'b') = -1);
  Assert(StrCompareNoAsciiCaseB('B', 'aa') = 1);
  Assert(StrCompareNoAsciiCaseB('aa', 'Aa') = 0);
  {$ENDIF}

  Assert(StrCompareNoAsciiCaseU('a', 'a') = 0);
  Assert(StrCompareNoAsciiCaseU('a', 'b') = -1);
  Assert(StrCompareNoAsciiCaseU('b', 'a') = 1);
  Assert(StrCompareNoAsciiCaseU('A', 'a') = 0);
  Assert(StrCompareNoAsciiCaseU('A', 'b') = -1);
  Assert(StrCompareNoAsciiCaseU('b', 'A') = 1);
  Assert(StrCompareNoAsciiCaseU('aa', 'a') = 1);
  Assert(StrCompareNoAsciiCaseU('a', 'aa') = -1);
  Assert(StrCompareNoAsciiCaseU('AA', 'b') = -1);
  Assert(StrCompareNoAsciiCaseU('B', 'aa') = 1);
  Assert(StrCompareNoAsciiCaseU('aa', 'Aa') = 0);

  Assert(StrCompareNoAsciiCase('a', 'a') = 0);
  Assert(StrCompareNoAsciiCase('a', 'b') = -1);
  Assert(StrCompareNoAsciiCase('b', 'a') = 1);
  Assert(StrCompareNoAsciiCase('A', 'a') = 0);
  Assert(StrCompareNoAsciiCase('A', 'b') = -1);
  Assert(StrCompareNoAsciiCase('b', 'A') = 1);
  Assert(StrCompareNoAsciiCase('aa', 'a') = 1);
  Assert(StrCompareNoAsciiCase('a', 'aa') = -1);
  Assert(StrCompareNoAsciiCase('AA', 'b') = -1);
  Assert(StrCompareNoAsciiCase('B', 'aa') = 1);
  Assert(StrCompareNoAsciiCase('aa', 'Aa') = 0);

  {$IFDEF SupportAnsiChar}
  Assert(StrAsciiFirstUpB('abra') = 'Abra');
  Assert(StrAsciiFirstUpB('') = '');
  {$ENDIF}

  Assert(IsAsciiStringB(TestStrA1), 'IsAsciiString');
  Assert(not IsAsciiStringB(TestStrA2), 'IsAsciiString');
  Assert(IsAsciiStringB(TestStrA3), 'IsAsciiString');

  Assert(IsAsciiStringU(TestStrU1), 'IsAsciiString');
  W := WideChar(#$0080);
  Assert(not IsAsciiStringU(W), 'IsAsciiString');
  W := WideChar($2262);
  Assert(not IsAsciiStringU(W), 'IsAsciiString');
  Assert(IsAsciiStringU(''), 'IsAsciiString');
end;

procedure Test;
begin
  {$IFDEF CPU_INTEL386}
  {$WARNINGS OFF}
  Set8087CW(Default8087CW);
  {$ENDIF}
  Test_Misc;
  Test_IntStr;
  Test_Hash;
  Test_Memory;
  Test_Char;
  {$IFDEF ImplementsStringRefCount}
  Test_StringRefCount;
  {$ENDIF}
  Test_String;
end;



end.
