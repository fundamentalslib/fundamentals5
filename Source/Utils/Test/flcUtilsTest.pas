{$INCLUDE ../../flcInclude.inc}
{$INCLUDE flcTestInclude.inc}

unit flcUtilsTest;

interface


procedure Test;



implementation

uses
  flcTestStdTypes,
  flcTestUtils,
  flcTestHashGeneral,
  flcTestDataStructArrays,
  flcTestDataStructMaps;



procedure Test;
begin
  flcTestStdTypes.Test;
  flcTestUtils.Test;
  flcTestHashGeneral.Test;
  flcTestDataStructArrays.Test;
  flcTestDataStructMaps.Test;
end;



end.
