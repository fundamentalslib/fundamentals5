{ 2020/07/05  0.01  Move tests from flcDatastucts unit. }
{ 2020/07/07  0.02  Tests for String and Object arrays. }

{$INCLUDE ../../flcInclude.inc}
{$INCLUDE flcTest_Include.inc}

unit flcTest_DataStructArrays;

interface



procedure Test;



implementation

uses
  SysUtils,
  flcStdTypes,
  flcDataStructArrays;



procedure Test_1_Int32Array;
var
  I : Int32;
  F : TInt32Array;
begin
  F := TInt32Array.Create;
  for I := 0 to 16384 do
    Assert(F.Add(I) = I,  'Array.Add');
  Assert(F.Count = 16385, 'Array.Count');
  for I := 0 to 16384 do
    Assert(F[I] = I,      'Array.GetItem');
  for I := 0 to 16384 do
    F[I] := I + 1;
  for I := 0 to 16384 do
    Assert(F[I] = I + 1,  'Array.SetItem');
  F.Delete(0, 1);
  Assert(F.Count = 16384, 'Array.Delete');
  for I := 0 to 16383 do
    Assert(F[I] = I + 2,  'Array.Delete');
  F.Insert(0, 2);
  F[0] := 0;
  F[1] := 1;
  for I := 0 to 16384 do
    Assert(F[I] = I,      'Array.Insert');
  Assert(F.GetIndex(16382) = 16382);

  F.Count := 4;
  Assert(F.Count = 4,     'Array.SetCount');
  F[0] := 9;
  F[1] := -2;
  F[2] := 3;
  F[3] := 4;
  F.Sort;
  Assert(F[0] = -2,       'Array.Sort');
  Assert(F[1] = 3,        'Array.Sort');
  Assert(F[2] = 4,        'Array.Sort');
  Assert(F[3] = 9,        'Array.Sort');

  F.Count := 7;
  F[0] := 3;
  F[1] := 5;
  F[2] := 5;
  F[3] := 2;
  F[4] := 5;
  F[5] := 5;
  F[6] := 1;
  F.Sort;
  Assert(F[0] = 1,        'Array.Sort');
  Assert(F[1] = 2,        'Array.Sort');
  Assert(F[2] = 3,        'Array.Sort');
  Assert(F[3] = 5,        'Array.Sort');
  Assert(F[4] = 5,        'Array.Sort');
  Assert(F[5] = 5,        'Array.Sort');
  Assert(F[6] = 5,        'Array.Sort');

  F.Clear;
  Assert(F.Count = 0,     'Array.Clear');

  F.Free;
end;

procedure Test_1_Int64Array;
var
  I : Int32;
  F : TInt64Array;
begin
  F := TInt64Array.Create;
  for I := 0 to 16384 do
    Assert(F.Add(I) = I,  'Array.Add');
  Assert(F.Count = 16385, 'Array.Count');
  for I := 0 to 16384 do
    Assert(F[I] = I,      'Array.GetItem');
  for I := 0 to 16384 do
    F[I] := I + 1;
  for I := 0 to 16384 do
    Assert(F[I] = I + 1,  'Array.SetItem');
  F.Delete(0, 1);
  Assert(F.Count = 16384, 'Array.Delete');
  for I := 0 to 16383 do
    Assert(F[I] = I + 2,  'Array.Delete');
  F.Insert(0, 2);
  F[0] := 0;
  F[1] := 1;
  for I := 0 to 16384 do
    Assert(F[I] = I,      'Array.Insert');
  Assert(F.GetIndex(16382) = 16382);

  F.Count := 4;
  Assert(F.Count = 4,     'Array.SetCount');
  F[0] := 9;
  F[1] := -2;
  F[2] := 3;
  F[3] := 4;
  F.Sort;
  Assert(F[0] = -2,       'Array.Sort');
  Assert(F[1] = 3,        'Array.Sort');
  Assert(F[2] = 4,        'Array.Sort');
  Assert(F[3] = 9,        'Array.Sort');

  F.Count := 7;
  F[0] := 3;
  F[1] := 5;
  F[2] := 5;
  F[3] := 2;
  F[4] := 5;
  F[5] := 5;
  F[6] := 1;
  F.Sort;
  Assert(F[0] = 1,        'Array.Sort');
  Assert(F[1] = 2,        'Array.Sort');
  Assert(F[2] = 3,        'Array.Sort');
  Assert(F[3] = 5,        'Array.Sort');
  Assert(F[4] = 5,        'Array.Sort');
  Assert(F[5] = 5,        'Array.Sort');
  Assert(F[6] = 5,        'Array.Sort');

  F.Clear;
  Assert(F.Count = 0,     'Array.Clear');

  F.Free;
end;

procedure Test_1_UInt32Array;
var
  I : Int32;
  F : TUInt32Array;
begin
  F := TUInt32Array.Create;
  for I := 0 to 16384 do
    Assert(F.Add(I) = I,  'Array.Add');
  Assert(F.Count = 16385, 'Array.Count');
  for I := 0 to 16384 do
    Assert(F[I] = UInt32(I), 'Array.GetItem');
  for I := 0 to 16384 do
    F[I] := I + 1;
  for I := 0 to 16384 do
    Assert(F[I] = UInt32(I) + 1, 'Array.SetItem');
  F.Delete(0, 1);
  Assert(F.Count = 16384, 'Array.Delete');
  for I := 0 to 16383 do
    Assert(F[I] = UInt32(I) + 2, 'Array.Delete');
  F.Insert(0, 2);
  F[0] := 0;
  F[1] := 1;
  for I := 0 to 16384 do
    Assert(F[I] = UInt32(I), 'Array.Insert');
  Assert(F.GetIndex(16382) = 16382);

  F.Count := 4;
  Assert(F.Count = 4,     'Array.SetCount');
  F[0] := 9;
  F[1] := 2;
  F[2] := 3;
  F[3] := 4;
  F.Sort;
  Assert(F[0] = 2,        'Array.Sort');
  Assert(F[1] = 3,        'Array.Sort');
  Assert(F[2] = 4,        'Array.Sort');
  Assert(F[3] = 9,        'Array.Sort');

  F.Count := 7;
  F[0] := 3;
  F[1] := 5;
  F[2] := 5;
  F[3] := 2;
  F[4] := 5;
  F[5] := 5;
  F[6] := 1;
  F.Sort;
  Assert(F[0] = 1,        'Array.Sort');
  Assert(F[1] = 2,        'Array.Sort');
  Assert(F[2] = 3,        'Array.Sort');
  Assert(F[3] = 5,        'Array.Sort');
  Assert(F[4] = 5,        'Array.Sort');
  Assert(F[5] = 5,        'Array.Sort');
  Assert(F[6] = 5,        'Array.Sort');

  F.Clear;
  Assert(F.Count = 0,     'Array.Clear');

  F.Free;
end;

procedure Test_1_UInt64Array;
var
  I : Int32;
  F : TUInt64Array;
begin
  F := TUInt64Array.Create;
  for I := 0 to 16384 do
    Assert(F.Add(I) = NativeInt(I),  'Array.Add');
  Assert(F.Count = 16385, 'Array.Count');
  for I := 0 to 16384 do
    Assert(F[I] = I,      'Array.GetItem');
  for I := 0 to 16384 do
    F[I] := I + 1;
  for I := 0 to 16384 do
    Assert(F[I] = I + 1,  'Array.SetItem');
  F.Delete(0, 1);
  Assert(F.Count = 16384, 'Array.Delete');
  for I := 0 to 16383 do
    Assert(F[I] = I + 2,  'Array.Delete');
  F.Insert(0, 2);
  F[0] := 0;
  F[1] := 1;
  for I := 0 to 16384 do
    Assert(F[I] = I,      'Array.Insert');
  Assert(F.GetIndex(16382) = 16382);

  F.Count := 4;
  Assert(F.Count = 4,     'Array.SetCount');
  F[0] := 9;
  F[1] := 2;
  F[2] := 3;
  F[3] := 4;
  F.Sort;
  Assert(F[0] = 2,        'Array.Sort');
  Assert(F[1] = 3,        'Array.Sort');
  Assert(F[2] = 4,        'Array.Sort');
  Assert(F[3] = 9,        'Array.Sort');

  F.Count := 7;
  F[0] := 3;
  F[1] := 5;
  F[2] := 5;
  F[3] := 2;
  F[4] := 5;
  F[5] := 5;
  F[6] := 1;
  F.Sort;
  Assert(F[0] = 1,        'Array.Sort');
  Assert(F[1] = 2,        'Array.Sort');
  Assert(F[2] = 3,        'Array.Sort');
  Assert(F[3] = 5,        'Array.Sort');
  Assert(F[4] = 5,        'Array.Sort');
  Assert(F[5] = 5,        'Array.Sort');
  Assert(F[6] = 5,        'Array.Sort');

  F.Clear;
  Assert(F.Count = 0,     'Array.Clear');

  F.Free;
end;

procedure Test_1_UnicodeStringArray;
var
  I : Int32;
  F : TUnicodeStringArray;
begin
  F := TUnicodeStringArray.Create;
  for I := 0 to 16384 do
    Assert(F.Add(IntToStr(I)) = NativeInt(I));
  Assert(F.Count = 16385);
  for I := 0 to 16384 do
    Assert(F[I] = IntToStr(I));
  for I := 0 to 16384 do
    F[I] := IntToStr(I + 1);
  for I := 0 to 16384 do
    Assert(F[I] = IntToStr(I + 1));
  F.Delete(0, 1);
  Assert(F.Count = 16384);
  for I := 0 to 16383 do
    Assert(F[I] = IntToStr(I + 2));
  F.Insert(0, 2);
  F[0] := '0';
  F[1] := '1';
  for I := 0 to 16384 do
    Assert(F[I] = IntToStr(I));
  Assert(F.GetIndex('16382') = 16382);

  F.Count := 4;
  Assert(F.Count = 4);
  F[0] := '9';
  F[1] := '2';
  F[2] := '3';
  F[3] := '4';
  F.Sort;
  Assert(F[0] = '2');
  Assert(F[1] = '3');
  Assert(F[2] = '4');
  Assert(F[3] = '9');

  F.Count := 7;
  F[0] := '3';
  F[1] := '5';
  F[2] := '5';
  F[3] := '2';
  F[4] := '5';
  F[5] := '5';
  F[6] := '1';
  F.Sort;
  Assert(F[0] = '1');
  Assert(F[1] = '2');
  Assert(F[2] = '3');
  Assert(F[3] = '5');
  Assert(F[4] = '5');
  Assert(F[5] = '5');
  Assert(F[6] = '5');

  F.Clear;
  Assert(F.Count = 0);

  F.Free;
end;

function IntToRawByteString(const I: Int64): RawByteString;
begin
  Result := RawByteString(IntToStr(I));
end;

procedure Test_1_RawByteStringArray;
var
  I : Int32;
  F : TRawByteStringArray;
begin
  F := TRawByteStringArray.Create;
  for I := 0 to 16384 do
    Assert(F.Add(IntToRawByteString(I)) = NativeInt(I));
  Assert(F.Count = 16385);
  for I := 0 to 16384 do
    Assert(F[I] = IntToRawByteString(I));
  for I := 0 to 16384 do
    F[I] := IntToRawByteString(I + 1);
  for I := 0 to 16384 do
    Assert(F[I] = IntToRawByteString(I + 1));
  F.Delete(0, 1);
  Assert(F.Count = 16384);
  for I := 0 to 16383 do
    Assert(F[I] = IntToRawByteString(I + 2));
  F.Insert(0, 2);
  F[0] := '0';
  F[1] := '1';
  for I := 0 to 16384 do
    Assert(F[I] = IntToRawByteString(I));
  Assert(F.GetIndex('16382') = 16382);

  F.Count := 4;
  Assert(F.Count = 4);
  F[0] := '9';
  F[1] := '2';
  F[2] := '3';
  F[3] := '4';
  F.Sort;
  Assert(F[0] = '2');
  Assert(F[1] = '3');
  Assert(F[2] = '4');
  Assert(F[3] = '9');

  F.Count := 7;
  F[0] := '3';
  F[1] := '5';
  F[2] := '5';
  F[3] := '2';
  F[4] := '5';
  F[5] := '5';
  F[6] := '1';
  F.Sort;
  Assert(F[0] = '1');
  Assert(F[1] = '2');
  Assert(F[2] = '3');
  Assert(F[3] = '5');
  Assert(F[4] = '5');
  Assert(F[5] = '5');
  Assert(F[6] = '5');

  F.Clear;
  Assert(F.Count = 0);

  F.Free;
end;

procedure Test_1_ObjectArray;
var
  O : array[0..16385] of TObject;
  I : Int32;
  F : TObjectArray;
begin
  for I := 0 to 16385 do
    O[I] := TObject.Create;

  F := TObjectArray.Create(False);

  Assert(F.Count = 0);
  Assert(F.AddIfNotExists(O[0]) = 0);
  Assert(F.Count = 1);
  Assert(F.AddIfNotExists(O[0]) = 0);
  Assert(F.Count = 1);
  for I := 1 to 16384 do
    Assert(F.Add(O[I]) = NativeInt(I));
  Assert(F.Count = 16385);
  for I := 0 to 16384 do
    Assert(F[I] = O[I]);

  for I := 0 to 16384 do
    F[I] := O[I + 1];
  for I := 0 to 16384 do
    Assert(F[I] = O[I + 1]);

  Assert(F.GetIndex(O[1]) = 0);
  F.Delete(0, 1);
  Assert(F.GetIndex(O[1]) = -1);
  Assert(F.Count = 16384);
  for I := 0 to 16383 do
    Assert(F[I] = O[I + 2]);

  F.Insert(0, 2);
  F[0] := O[0];
  F[1] := O[1];
  for I := 0 to 16384 do
    Assert(F[I] = O[I]);
  Assert(F.GetIndex(O[0]) = 0);
  Assert(F.GetIndex(O[16382]) = 16382);
  Assert(F.HasValue(O[16382]));
  Assert(F.GetIndex(O[16384]) = 16384);
  Assert(not F.HasValue(F));

  F.Clear;
  Assert(F.Count = 0);

  F.Free;

  for I := 0 to 16385 do
    O[I].Free;
end;

procedure Test_1;
begin
  Test_1_Int32Array;
  Test_1_Int64Array;
  Test_1_UInt32Array;
  Test_1_UInt64Array;
  Test_1_UnicodeStringArray;
  Test_1_RawByteStringArray;
  Test_1_ObjectArray;
end;

procedure Test;
begin
  Test_1;
end;



end.

