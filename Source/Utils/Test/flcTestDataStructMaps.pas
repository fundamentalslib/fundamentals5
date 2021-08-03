{ 2020/07/07  0.01  Basic tests for TStrObjMap and TIntObjMap. }

{$INCLUDE ../../flcInclude.inc}
{$INCLUDE flcTestInclude.inc}

unit flcTestDataStructMaps;

interface



procedure Test;



implementation

uses
  SysUtils,
  flcStdTypes,
  flcDataStructMaps
  {$IFDEF Profile},
  flcTimers
  {$ENDIF};



procedure Test_1_StrObjMap;
const
  TestN = 500000;
type
  KeyRefArr = array[0..TestN - 1] of String;
  KeyRefArrP = ^KeyRefArr;
var
  A : TStrObjMap;
  I, J : Integer;
  It : TStrObjMapIterator;
  KeyRef : KeyRefArrP;
  ValObj : TObject;
  {$IFDEF Profile}
  T1 : Word64;
  {$ENDIF}
begin
  A := TStrObjMap.Create(False, True, True);
  try
    Assert(A.Count = 0);
    A.Add('a', A);
    Assert(A.Count = 1);
    Assert(A.RequireValue('a') = A);

    New(KeyRef);
    for I := 0 to TestN - 1 do
      KeyRef^[I] := IntToStr(I + 1);

    {$IFDEF Profile}
    T1 := GetMilliTick;
    {$ENDIF}
    for I := 0 to TestN - 1 do
      A.Add(KeyRef^[I], A);
    {$IFDEF Profile}
    T1 := Word64(GetMilliTick - T1);
    Writeln('StrObjMap.Add:', T1 / 1000000 / (TestN / 100000):0:6, 's/100k');
    {$ENDIF}

    {$IFDEF Profile}
    T1 := GetMilliTick;
    {$ENDIF}
    for J := 1 to 4 do
      for I := 0 to TestN - 1 do
        Assert(A.KeyExists(KeyRef^[I]));
    {$IFDEF Profile}
    T1 := Word64(GetMilliTick - T1);
    Writeln('StrObjMap.Exists:', T1 / 1000000 / (TestN / (100000 / 4)):0:6, 's/100k');
    {$ENDIF}

    {$IFDEF Profile}
    T1 := GetMilliTick;
    {$ENDIF}
    for I := 0 to TestN - 1 do
      Assert(A.GetValue(KeyRef^[I], ValObj));
    {$IFDEF Profile}
    T1 := Word64(GetMilliTick - T1);
    Writeln('StrObjMap.GetValue:', T1 / 1000000 / (TestN / 100000):0:6, 's/100k');
    {$ENDIF}

    Dispose(KeyRef);

    Assert(A.Count = TestN + 1);

    Assert(A.KeyExists('1'));
    A.Delete('1');
    Assert(A.Count = TestN);
    Assert(not A.KeyExists('1'));

    Assert(Assigned(A.Iterate(It)));
    for I := 1 to TestN - 1 do
      Assert(Assigned(A.IteratorNext(It)));
    Assert(not Assigned(A.IteratorNext(It)));

    A.Clear;
    Assert(A.Count = 0);
  finally
    A.Free;
  end;
end;

procedure Test_1_IntObjMap;
const
  TestN = 500000;
var
  A : TIntObjMap;
  I, J : Integer;
  It : TIntObjMapIterator;
  ValObj : TObject;
  {$IFDEF Profile}
  T1 : Word64;
  {$ENDIF}
begin
  A := TIntObjMap.Create(False, True);
  try
    Assert(A.Count = 0);
    A.Add(-1, A);
    Assert(A.Count = 1);
    Assert(A.RequireValue(-1) = A);

    {$IFDEF Profile}
    T1 := GetMilliTick;
    {$ENDIF}
    for I := 0 to TestN - 1 do
      A.Add(I + 1, A);
    {$IFDEF Profile}
    T1 := Word64(GetMilliTick - T1);
    Writeln('IntObjMap.Add:', T1 / 1000000 / (TestN / 100000):0:6, 's/100k');
    {$ENDIF}

    {$IFDEF Profile}
    T1 := GetMilliTick;
    {$ENDIF}
    for J := 1 to 4 do
      for I := 0 to TestN - 1 do
        Assert(A.KeyExists(I + 1));
    {$IFDEF Profile}
    T1 := Word64(GetMilliTick - T1);
    Writeln('IntObjMap.Exists:', T1 / 1000000 / (TestN / (100000 / 4)):0:6, 's/100k');
    {$ENDIF}

    {$IFDEF Profile}
    T1 := GetMilliTick;
    {$ENDIF}
    for I := 0 to TestN - 1 do
      Assert(A.GetValue(I + 1, ValObj));
    {$IFDEF Profile}
    T1 := Word64(GetMilliTick - T1);
    Writeln('IntObjMap.GetValue:', T1 / 1000000 / (TestN / 100000):0:6, 's/100k');
    {$ENDIF}

    Assert(A.Count = TestN + 1);

    Assert(A.KeyExists(1));
    A.Delete(1);
    Assert(A.Count = TestN);
    Assert(not A.KeyExists(1));

    Assert(Assigned(A.Iterate(It)));
    for I := 1 to TestN - 1 do
      Assert(Assigned(A.IteratorNext(It)));
    Assert(not Assigned(A.IteratorNext(It)));

    A.Clear;
    Assert(A.Count = 0);
  finally
    A.Free;
  end;
end;

procedure Test;
begin
  Test_1_StrObjMap;
  Test_1_IntObjMap;
end;



end.

