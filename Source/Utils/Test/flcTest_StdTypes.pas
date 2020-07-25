{$INCLUDE flcTest_Include.inc}

unit flcTest_StdTypes;

interface

uses
  SysUtils,
  flcStdTypes;



procedure Test;



implementation



procedure Test;
begin
  {$IFDEF LongWordIs32Bits}    Assert(SizeOf(LongWord) = 4);   {$ENDIF}
  {$IFDEF LongIntIs32Bits}     Assert(SizeOf(LongInt) = 4);    {$ENDIF}
  {$IFDEF LongWordIs64Bits}    Assert(SizeOf(LongWord) = 8);   {$ENDIF}
  {$IFDEF LongIntIs64Bits}     Assert(SizeOf(LongInt) = 8);    {$ENDIF}
  {$IFDEF NativeIntIs32Bits}   Assert(SizeOf(NativeInt) = 4);  {$ENDIF}
  {$IFDEF NativeIntIs64Bits}   Assert(SizeOf(NativeInt) = 8);  {$ENDIF}
  {$IFDEF NativeUIntIs32Bits}  Assert(SizeOf(NativeUInt) = 4); {$ENDIF}
  {$IFDEF NativeUIntIs64Bits}  Assert(SizeOf(NativeUInt) = 8); {$ENDIF}
end;



end.
