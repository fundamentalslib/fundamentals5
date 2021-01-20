{$INCLUDE ../../flcInclude.inc}
{$INCLUDE flcTest_Include.inc}

unit flcUtilsTest;

interface


procedure Test;



implementation

uses
  flcTest_StdTypes,
  flcTest_Utils,
  flcTest_HashGeneral,
  flcTest_DataStructArrays,
  flcTest_DataStructMaps;



procedure Test;
begin
  flcTest_StdTypes.Test;
  flcTest_Utils.Test;
  flcTest_HashGeneral.Test;
  flcTest_DataStructArrays.Test;
  flcTest_DataStructMaps.Test;
end;



end.
