{$INCLUDE ../../flcInclude.inc}
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
  Assert(SizeOf(Int8) = 1);
  Assert(SizeOf(Int16) = 2);
  Assert(SizeOf(Int32) = 4);
  Assert(SizeOf(Int64) = 8);

  Assert(SizeOf(UInt8) = 1);
  Assert(SizeOf(UInt16) = 2);
  Assert(SizeOf(UInt32) = 4);
  Assert(SizeOf(UInt64) = 8);

  Assert(SizeOf(UInt8) = SizeOf(Word8));
  Assert(SizeOf(UInt16) = SizeOf(Word16));
  Assert(SizeOf(UInt32) = SizeOf(Word32));
  Assert(SizeOf(UInt64) = SizeOf(Word64));

  Assert(SizeOf(Integer) = 4);
  Assert(SizeOf(Cardinal) = 4);

  {$IFDEF LongWordIs32Bits}
  Assert(SizeOf(LongWord) = 4);
  {$ENDIF}
  {$IFDEF LongWordIs64Bits}
  Assert(SizeOf(LongWord) = 8);
  {$ENDIF}

  {$IFDEF LongIntIs32Bits}
  Assert(SizeOf(LongInt) = 4);
  {$ENDIF}
  {$IFDEF LongIntIs64Bits}
  Assert(SizeOf(LongInt) = 8);
  {$ENDIF}

  {$IFDEF NativeIntIs32Bits}
  Assert(SizeOf(NativeInt) = 4);
  {$ENDIF}
  {$IFDEF NativeIntIs64Bits}
  Assert(SizeOf(NativeInt) = 8);
  {$ENDIF}

  {$IFDEF NativeUIntIs32Bits}
  Assert(SizeOf(NativeUInt) = 4);
  {$ENDIF}
  {$IFDEF NativeUIntIs64Bits}
  Assert(SizeOf(NativeUInt) = 8);
  {$ENDIF}

  Assert(SizeOf(ByteChar) = 1);
  Assert(SizeOf(WideChar) = 2);

  {$IFDEF CharIsWide}
  Assert(SizeOf(Char) = 2);
  {$ENDIF}
  {$IFDEF CharIsAnsi}
  Assert(SizeOf(Char) = 1);
  {$ENDIF}

  {$IFDEF StringIsUnicode}
  Assert(SizeOf(Char) = 2);
  {$ENDIF}
  {$IFDEF StringIsAnsi}
  Assert(SizeOf(Char) = 1);
  {$ENDIF}

  Assert(SizeOf(Double) = 8);

  {$IFDEF ExtendedIsDouble}
  Assert(SizeOf(Extended) = SizeOf(Double));
  {$ENDIF}
  {$IFDEF ExtendedIs80Bits}
  Assert(SizeOf(Extended) = 10);
  {$ENDIF}
  {$IFDEF ExtendedIs16Bytes}
  Assert(SizeOf(Extended) = 16);
  {$ENDIF}

  {$IFDEF FloatIsDouble}
  Assert(SizeOf(Float) = SizeOf(Double));
  {$ENDIF}
  {$IFDEF FloatIsExtended}
  Assert(SizeOf(Float) = SizeOf(Extended));
  {$ENDIF}
end;



end.
