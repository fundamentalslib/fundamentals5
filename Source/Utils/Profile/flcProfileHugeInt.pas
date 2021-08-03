{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcProfileHugeInt.pas                                    }
{   File version:     5.01                                                     }
{   Description:      Profile: HugeInt                                         }
{                                                                              }
{******************************************************************************}

{$INCLUDE ../../flcInclude.inc}

unit flcProfileHugeInt;

interface



{$IFDEF OS_MSWIN}
{$IFDEF PROFILE}
procedure Profile;
{$ENDIF}
{$ENDIF}



implementation

{$IFDEF OS_MSWIN}
{$IFDEF PROFILE}
uses
  Windows,
  SysUtils,

  flcStdTypes,
  flcHugeInt;



{
Win64 Debug:
-----------
                    Shl1:     32000 1612903.2/s
                    Shl1:    320000 168350.2/s
                    Shl1:    800000 66666.7/s
                     Add:     32000 889679.7/s
                     Add:    320000 85557.8/s
                     Add:    800000 33756.4/s
                     Sub:     32000 800000.0/s
                     Sub:    320000 70323.5/s
                     Sub:    800000 27586.2/s
             Sub_ALarger:     32000 714285.7/s
             Sub_ALarger:    320000 69541.0/s
             Sub_ALarger:    800000 27122.3/s
                     Div:       320 142857.1/s
                     Div:      1600 23017.9/s
                     Div:      3200 8348.8/s
                     Mod:       320 212766.0/s
                     Mod:      1600 71428.6/s
                     Mod:      3200 33670.0/s
             PowerAndMod:      1024 10.63830/s
             PowerAndMod:      2048 1.68350/s
             PowerAndMod:      4096 0.26344/s
                Mul_Long:       320 7092198.6/s
                Mul_Long:      1600 435350.5/s
                Mul_Long:      3200 104920.8/s
               Mul_Long4:       128 18129079.0/s
            Mul_ShiftAdd:       320 160000.0/s
            Mul_ShiftAdd:      1600 9551.1/s
            Mul_ShiftAdd:      3200 2438.1/s
           Mul_Karatsuba:       320 458715.6/s
           Mul_Karatsuba:      1600 44444.4/s
           Mul_Karatsuba:      3200 14220.7/s
     Equals (worst case):     32000 1785714.3/s
     Equals (worst case):    320000 195007.8/s
     Equals (worst case):    800000 79617.8/s
     Compare (best case):     32000 130548302.9/s
     Compare (best case):    320000 136239782.0/s
     Compare (best case):    800000 142247510.7/s
    Compare (worst case):     32000 4545454.5/s
    Compare (worst case):    320000 438596.5/s
    Compare (worst case):    800000 182815.4/s
       SetBitScanReverse:     32000 158730158.7/s
       SetBitScanReverse:    320000 128205128.2/s
       SetBitScanReverse:    800000 161290322.6/s
                   ISqrt:       320 12766.0/s
                   ISqrt:      1600 1500.0/s
                   ISqrt:      3200 509.3/s
                    Shr1:     32000 1063829.8/s
                    Shr1:    320000 108459.9/s
                    Shr1:    800000 41288.2/s
}
procedure Profile;
const
  Digit_Test_Count = 3;
  Digits_Default: array[0..Digit_Test_Count - 1] of Integer = (1000, 10000, 25000);
  Digits_Multiply: array[0..Digit_Test_Count - 1] of Integer = (10, 50, 100);
  Digits_PowerMod: array[0..Digit_Test_Count - 1] of Integer = (32, 64, 128);
var
  A, B, C, D : HugeWord;
  I, J, Di : Integer;
  T : Word32;
begin
  HugeWordInit(A);
  HugeWordInit(B);
  HugeWordInit(C);
  HugeWordInit(D);


  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Default[J];
      HugeWordRandom(C, Di);
      T := GetTickCount;
      for I := 1 to 100000 do
        begin
          HugeWordAssign(A, C);
          HugeWordShl1(A);
        end;
      T := GetTickCount - T;
      Writeln('Shl1:':25, Di*32:10, ' ', 1000 / (T / 100000):0:1, '/s');
  end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Default[J];
      HugeWordRandom(C, Di);
      HugeWordRandom(D, Di - 2);
      HugeWordAssign(B, D);
      T := GetTickCount;
      for I := 1 to 250000 do
        begin
          HugeWordAssign(A, C);
          HugeWordAdd(A, B);
        end;
      T := GetTickCount - T;
      Writeln('Add:':25, Di*32:10, ' ', 1000 / (T / 250000):0:1, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Default[J];
      repeat
        HugeWordRandom(C, Di);
        HugeWordRandom(D, Di);
      until HugeWordCompare(C, D) > 0;
      HugeWordAssign(B, D);
      T := GetTickCount;
      for I := 1 to 100000 do
        begin
          HugeWordAssign(A, C);
          HugeWordSubtract(A, B);
        end;
      T := GetTickCount - T;
      Writeln('Sub:':25, Di*32:10, ' ', 1000 / (T / 100000):0:1, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Default[J];
      repeat
        HugeWordRandom(C, Di);
        HugeWordRandom(D, Di);
      until HugeWordCompare(C, D) > 0;
      HugeWordAssign(B, D);
      T := GetTickCount;
      for I := 1 to 100000 do
        begin
          HugeWordAssign(A, C);
          HugeWordSubtract_ALarger(A, B);
        end;
      T := GetTickCount - T;
      Writeln('Sub_ALarger:':25, Di*32:10, ' ', 1000 / (T / 100000):0:1, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Multiply[J];
      repeat
        HugeWordRandom(A, Di);
        HugeWordRandom(B, Di - 2);
      until HugeWordCompare(A, B) > 0;

      T := GetTickCount;
      for I := 1 to 9000 do
        HugeWordDivide(A, B, C, D);
      T := GetTickCount - T;
      Writeln('Div:':25, Di*32:10, ' ', 1000 / (T / 9000):0:1, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Multiply[J];
      HugeWordRandom(A, Di);
      HugeWordRandom(B, Di - 3);

      T := GetTickCount;
      for I := 1 to 10000 do
        HugeWordMod(A, B, C);
      T := GetTickCount - T;
      Writeln('Mod:':25, Di*32:10, ' ', 1000 / (T / 10000):0:1, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_PowerMod[J];
      HugeWordRandom(A, Di);
      HugeWordRandom(B, Di);
      HugeWordRandom(C, Di);
      T := GetTickCount;
      for I := 1 to 1 do
        begin
          HugeWordPowerAndMod(D, A, B, C);
        end;
      T := GetTickCount - T;
      Writeln('PowerAndMod:':25, Di*32:10, ' ', 1000 / (T / 1):0:5, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Multiply[J];
      HugeWordRandom(A, Di);
      HugeWordRandom(B, Di);

      T := GetTickCount;
      for I := 1 to 1000000 do
        HugeWordMultiply_Long(C, A, B);
      T := GetTickCount - T;
      Writeln('Mul_Long:':25, Di*32:10, ' ', 1000 / (T / 1000000):0:1, '/s');
    end;

    Di := 4;
    HugeWordRandom(A, Di);
    HugeWordRandom(B, Di);

    T := GetTickCount;
    for I := 1 to 100000000 do
      HugeWordMultiply_Long(C, A, B);
    T := GetTickCount - T;
    Writeln('Mul_Long4:':25, Di*32:10, ' ', 1000 / (T / 100000000):0:1, '/s');

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Multiply[J];
      HugeWordRandom(A, Di);
      HugeWordRandom(B, Di);

      T := GetTickCount;
      for I := 1 to 20000 do
        HugeWordMultiply_ShiftAdd_Unsafe(C, A, B);
      T := GetTickCount - T;
      Writeln('Mul_ShiftAdd:':25, Di*32:10, ' ', 1000 / (T / 20000):0:1, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Multiply[J];
      HugeWordRandom(A, Di);
      HugeWordRandom(B, Di);

      T := GetTickCount;
      for I := 1 to 50000 do
        HugeWordMultiply_Karatsuba(C, A, B);
      T := GetTickCount - T;
      Writeln('Mul_Karatsuba:':25, Di*32:10, ' ', 1000 / (T / 50000):0:1, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Default[J];
      HugeWordRandom(A, Di);
      HugeWordAssign(B, A);

      T := GetTickCount;
      for I := 1 to 250000 do
        HugeWordEquals(A, B);
      T := GetTickCount - T;
      Writeln('Equals (worst case):':25, Di*32:10, ' ', 1000 / (T / 250000):0:1, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Default[J];
      repeat
        HugeWordRandom(A, Di);
        HugeWordRandom(B, Di);
      until HugeWordGetElement(A, 0) <> HugeWordGetElement(B, 0);

      T := GetTickCount;
      for I := 1 to 100000000 do
        HugeWordCompare(A, B);
      T := GetTickCount - T;
      Writeln('Compare (best case):':25, Di*32:10, ' ', 1000 / (T / 100000000):0:1, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Default[J];
      HugeWordRandom(A, Di);
      HugeWordAssign(B, A);

      T := GetTickCount;
      for I := 1 to 500000 do
        HugeWordCompare(A, B);
      T := GetTickCount - T;
      Writeln('Compare (worst case):':25, Di*32:10, ' ', 1000 / (T / 500000):0:1, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Default[J];
      HugeWordRandom(A, Di);
      HugeWordSetElement(A, Di - 1, 0);
      T := GetTickCount;
      for I := 1 to 10000000 do
        HugeWordSetBitScanReverse(A);
      T := GetTickCount - T;
      Writeln('SetBitScanReverse:':25, Di*32:10, ' ', 1000 / (T / 10000000):0:1, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Multiply[J];
      HugeWordRandom(A, Di);
      HugeWordAssign(B, A);

      T := GetTickCount;
      for I := 1 to 3000 do
        begin
          HugeWordAssign(A, B);
          HugeWordISqrt(A);
        end;
      T := GetTickCount - T;
      Writeln('ISqrt:':25, Di*32:10, ' ', 1000 / (T / 3000):0:1, '/s');
    end;

  for J := 0 to Digit_Test_Count - 1 do
    begin
      Di := Digits_Default[J];
      HugeWordRandom(C, Di);
      T := GetTickCount;
      for I := 1 to 100000 do
        begin
          HugeWordAssign(A, C);
          HugeWordShr1(A);
        end;
      T := GetTickCount - T;
      Writeln('Shr1:':25, Di*32:10, ' ', 1000 / (T / 100000):0:1, '/s');
  end;

  HugeWordFinalise(D);
  HugeWordFinalise(C);
  HugeWordFinalise(B);
  HugeWordFinalise(A);
end;
{$ENDIF}
{$ENDIF}



end.
