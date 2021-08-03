{ 2020/07/20  0.01  Moved tests from flcHashGeneral. }
{ 2020/07/25  0.02  Tests for fclHash1, fclHash2, fclHash3. }

{$INCLUDE ../../flcInclude.inc}
{$INCLUDE flcTestInclude.inc}

unit flcTestHashGeneral;

interface

uses
  SysUtils,
  flcStdTypes,
  flcHashGeneral;



procedure Test;



implementation



procedure Test;
var
  I : NativeInt;
begin
  Assert(CalcChecksum32B('') = 0);
  Assert(CalcChecksum32B('A') = 65);
  Assert(CalcChecksum32B('Fundamentals') = 1250);

  Assert(CalcXOR8('') = 0);
  Assert(CalcXOR8('A') = 65);
  Assert(CalcXOR8('Fundamentals') = 52);

  Assert(CalcXOR16('') = 0);
  Assert(CalcXOR16('A') = 65);
  Assert(CalcXOR16('AB') = $4241);
  Assert(CalcXOR16('what do ya want for nothing?') = $1915);
  Assert(CalcXOR16('Fundamentals') = $0034);

  Assert(CalcXOR32('') = 0);
  Assert(CalcXOR32('A') = 65);
  Assert(CalcXOR32('ABCD') = $44434241);
  Assert(CalcXOR32('what do ya want for nothing?') = $743B6D2E);
  Assert(CalcXOR32('Fundamentals')= $79677953);

  Assert(CalcCRC16('') = $FFFF);
  Assert(CalcCRC16('what do ya want for nothing?') = $581A);
  Assert(CalcCRC16('Fundamentals') = $0B48);

  Assert(CalcCRC32('') = 0);
  Assert(CalcCRC32('what do ya want for nothing?') = $6BC70A6C);
  Assert(CalcCRC32('Fundamentals') = $C0488691);
  Assert(CalcCRC32('Fundamentals') = $C0488691);
  Assert(CalcCRC32('01234567890123456789012345678901234567890123456789' +
                   '01234567890123456789012345678901234567890123456789' +
                   '01234567890123456789012345678901234567890123456789' +
                   '01234567890123456789012345678901234567890123456789' +
                   '01234567890123456789012345678901234567890123456789' +
                   '01234567890123456789012345678901234567890123456789') = $C054B7F4);
  Assert(CalcCRC32('01234567890123456789012345678901234567890123456789' +
                   '01234567890123456789012345678901234567890123456789' +
                   '01234567890123456789012345678901234567890123456789' +
                   '01234567890123456789012345678901234567890123456789' +
                   '01234567890123456789012345678901234567890123456789' +
                   '01234567890123456789012345678901234567890123456788') = $B7538762);

  Assert(CalcAdler32('Wikipedia') = $11E60398);

  Assert(IsValidISBN('3880530025'));

  Assert(IsValidLUHN('49927398716'));

  Assert(fclHash1String32B('') = 2166136261);
  Assert(fclHash1String32B('what do ya want for nothing?') = 3292967299);
  Assert(fclHash1String32B('Fundamentals') = 2327973033);

  {$IFNDEF DELPHI7}
  Assert(fclHash1String64B('') = 14695981039346656037);
  Assert(fclHash1String64B('what do ya want for nothing?') = 2306439892974478467);
  Assert(fclHash1String64B('Fundamentals') = 11045497405042532233);

  for I := 1 to $100FF do
    Assert(fclHash1String32('0') <> fclHash1String32(IntToStr(I)));

  for I := 1 to $100FF do
    Assert(fclHash1String64('0') <> fclHash1String64(IntToStr(I)));

  Assert(fclHash1Integer32Int64(0) = $9BE17165);
  for I := 1 to $100FF do
    Assert(fclHash1Integer32Int64(0) <> fclHash1Integer32Int64(I));

  Assert(fclHash1Integer64Int64(0) = $A8C7F832281A39C5);
  for I := 1 to $100FF do
    Assert(fclHash1Integer64Int64(0) <> fclHash1Integer64Int64(I));

  Assert(fclHash2String32('', True) = 1512010500);
  Assert(fclHash2String32('what do ya want for nothing?', True) = 3366894511);
  Assert(fclHash2String32('Fundamentals', True) = 459272146);

  Assert(fclHash2String64('', True) = 6494035638841530722);
  Assert(fclHash2String64('what do ya want for nothing?', True) = 12441119077884482291);
  Assert(fclHash2String64('Fundamentals', True) = 13930759544457745867);

  Assert(fclHash2String32('', False) = 1512010500);
  Assert(fclHash2String32('what do ya want for nothing?', False) = 3145541208);
  Assert(fclHash2String32('Fundamentals', False) = 4129613511);

  Assert(fclHash2String64('', False) = 6494035638841530722);
  Assert(fclHash2String64('what do ya want for nothing?', False) = 2918249338255671087);
  Assert(fclHash2String64('Fundamentals', False) = 11215042651837717125);

  Assert(fclHash2String32('Fundamentals', True) <> fclHash2String32('fundamentals', True));
  Assert(fclHash2String32('Fundamentals', False) = fclHash2String32('fundamentals', False));
  Assert(fclHash2String64('Fundamentals', True) <> fclHash2String64('fundamentals', True));
  Assert(fclHash2String64('Fundamentals', False) = fclHash2String64('fundamentals', False));

  Assert(fclHash3String32('', True) = 4294967295);
  Assert(fclHash3String32('what do ya want for nothing?', True) = 3235560669);
  Assert(fclHash3String32('Fundamentals', True) = 4251899959);

  Assert(fclHash3String64('', True) = 575924191165939584);
  Assert(fclHash3String64('what do ya want for nothing?', True) = 11543898621614637648);
  Assert(fclHash3String64('Fundamentals', True) = 14823830273907298814);

  Assert(fclHash3String32('', False) = 4294967295);
  Assert(fclHash3String32('what do ya want for nothing?', False) = 3747710262);
  Assert(fclHash3String32('Fundamentals', False) = 1947243966);

  Assert(fclHash3String64('', False) = 575924191165939584);
  Assert(fclHash3String64('what do ya want for nothing?', False) = 12178484492201484685);
  Assert(fclHash3String64('Fundamentals', False) = 11050534446774230637);

  Assert(fclHash3String32('Fundamentals', True) <> fclHash3String32('fundamentals', True));
  Assert(fclHash3String32('Fundamentals', False) = fclHash3String32('fundamentals', False));
  Assert(fclHash3String64('Fundamentals', True) <> fclHash3String64('fundamentals', True));
  Assert(fclHash3String64('Fundamentals', False) = fclHash3String64('fundamentals', False));
  {$ENDIF}

  for I := 1 to $100FF do
    Assert(fclHash3String32('0') <> fclHash3String32(IntToStr(I)));

  for I := 1 to $100FF do
    Assert(fclHash3String64('0') <> fclHash3String64(IntToStr(I)));

  Assert(fclHash3Integer32Int32(0) = $DEBB20E3);
  for I := 1 to $100FF do
    Assert(fclHash3Integer32Int32(0) <> fclHash3Integer32Int32(I));

  Assert(fclHash3Integer32Int64(0) = $9ADD2096);
  for I := 1 to $100FF do
    Assert(fclHash3Integer32Int64(0) <> fclHash3Integer64Int64(I));

  Assert(fclHash3Integer64Int64(0) = $DDE5953CFA4A06E);
  for I := 1 to $100FF do
    Assert(fclHash3Integer64Int64(0) <> fclHash3Integer64Int64(I));
end;



end.

