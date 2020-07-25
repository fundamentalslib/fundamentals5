{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcDataStructMaps.pas                                    }
{   File version:     0.16                                                     }
{   Description:      Data structures: Maps                                    }
{                                                                              }
{   Copyright:        Copyright (c) 1999-2020, David J Butler                  }
{                     All rights reserved.                                     }
{                     Redistribution and use in source and binary forms, with  }
{                     or without modification, are permitted provided that     }
{                     the following conditions are met:                        }
{                     Redistributions of source code must retain the above     }
{                     copyright notice, this list of conditions and the        }
{                     following disclaimer.                                    }
{                     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND   }
{                     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED          }
{                     WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED   }
{                     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A          }
{                     PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL     }
{                     THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,    }
{                     INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR             }
{                     CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,    }
{                     PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF     }
{                     USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)         }
{                     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER   }
{                     IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING        }
{                     NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE   }
{                     USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE             }
{                     POSSIBILITY OF SUCH DAMAGE.                              }
{                                                                              }
{                     Copyright (c) 2018-2020 KeyVast, David J Butler          }
{                     KeyVast is released under the terms of the MIT license.  }
{                                                                              }
{   Github:           https://github.com/fundamentalslib                       }
{   E-mail:           fundamentals.library at gmail.com                        }
{                                                                              }
{ Description:                                                                 }
{                                                                              }
{   Map (associative arrays) classes for various key and value types.          }
{                                                                              }
{ Revision history:                                                            }
{                                                                              }
{   2001/04/13  0.01  Initial version of TObjectDictionary for Fundamentals.   }
{   2018/02/08  0.02  Initial version for KeyVast.                             }
{   2018/03/02  0.03  Remove LongWord references.                              }
{   2018/09/27  0.04  AddOrSet.                                                }
{   2019/09/30  0.05  Modify string hash function.                             }
{   2020/03/31  0.06  Add Hash value to slot item.                             }
{   2020/04/01  0.07  FreeValue method and event.                              }
{   2020/04/04  0.08  Iterator remove curent item.                             }
{   2020/04/05  0.09  Add methods similar to qStrObjMap.                       }
{   2020/04/05  0.10  Maximum slot count.                                      }
{   2020/07/07  0.11  Modify string hash function.                             }
{   2020/07/07  0.12  VisitAll function.                                       }
{   2020/07/07  0.13  Convert to template.                                     }
{   2020/07/07  0.14  TIntObjMap.                                              }
{   2020/07/07  0.15  TStrIntMap, TIntIntMap, TStrStrMap and TIntStrMap.       }
{   2020/07/07  0.16  TIntPtrMap and TStrPtrMap.                               }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 2010-10.4 Win32/Win64        0.16  2020/07/07                       }
{   Delphi 10.2-10.4 Linux64            -     -                                }
{   FreePascal 3.0.4 Win64              -     -                                }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

unit flcDataStructMaps;

interface

uses
  { System }
  SysUtils,

  { Fundamentals }
  flcStdTypes;



{%DEFINE AMapIntf}
{ T%1%Map }

type
  E%1%MapError = class(Exception);

  T%1%MapItem = record
    Hash  : Word32;
    Key   : %2%;
    Value : %5%;
  end;
  P%1%MapItem = ^T%1%MapItem;

  T%1%HashListSlot = record
    Count : Int32;
    List  : packed array of T%1%MapItem;
  end;
  P%1%HashListSlot = ^T%1%HashListSlot;
  T%1%HashListSlotArray = array of T%1%HashListSlot;

  T%1%MapIterator = record
    SlotIdx  : Int32;
    ItemIdx  : Int32;
    Finished : Boolean;
    Deleted  : Boolean;
  end;

  T%1%MapVisitValueEvent = procedure (const AKey: %2%; const AValue: %5%; var Stop: Boolean) of object;{%IF 6}
  T%1%MapFreeValueEvent = procedure (const AKey: %2%; var AValue: TObject) of object;{%ENDIF}

  T%1%Map = class
  private{%IF 6}
    FItemOwner       : Boolean;{%ENDIF}{%IF 3}
    FCaseSensitive   : Boolean;{%ENDIF}
    FAllowDuplicates : Boolean;
{%IF 6}
    FOnFreeValue : T%1%MapFreeValueEvent;{%ENDIF}

    FCount : Int32;
    FSlots : Int32;
    FList  : T%1%HashListSlotArray;

    procedure ClearList;
    procedure AddToSlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: %2%;
              const AValue: %5%); inline;
    procedure ExpandSlots(const ANewSlotCount: Int64);

    function  LocateItemIndexBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: %2%;
              out Item: P%1%MapItem): Int32;
    function  LocateNextItemIndexBySlot(
              const ASlotIdx: Int32; const AItemIdx: Int32;
              const AHash: Word32; const AKey: %2%;
              out Item: P%1%MapItem): Int32;
    function  LocateItemBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: %2%;
              out AItem: P%1%MapItem): Boolean; inline;
    function  LocateItem(
              const AKey: %2%;
              out AItem: P%1%MapItem): Boolean; inline;
    function  RequireItem(const AKey: %2%): P%1%MapItem;

    function  IterateGetNext(var AIterator: T%1%MapIterator): P%1%MapItem;
{%IF 6}
  protected
    procedure FreeValue(const AKey: %2%; var AValue: TObject); virtual;{%ENDIF}

  public
    constructor Create({%IF 6}
                const AItemOwner: Boolean = False;{%ENDIF}{%IF 3}
                const ACaseSensitive: Boolean = True;{%ENDIF}
                const AAllowDuplicates: Boolean = True);
    destructor Destroy; override;
{%IF 6}
    property  ItemOwner: Boolean read FItemOwner;{%ENDIF}{%IF 3}
    property  CaseSensitive: Boolean read FCaseSensitive;{%ENDIF}
    property  AllowDuplicates: Boolean read FAllowDuplicates;
{%IF 6}
    property  OnFreeValue: T%1%MapFreeValueEvent read FOnFreeValue write FOnFreeValue;
{%ENDIF}
    procedure Clear;
    property  Count: Int32 read FCount;

    procedure Add(const AKey: %2%; const AValue: %5%);

    function  KeyExists(const AKey: %2%): Boolean;
    function  KeyCount(const AKey: %2%): Int32;

    function  Get(const AKey: %2%): %5%;

    function  GetValue(const AKey: %2%; out AValue: %5%): Boolean;
    function  GetNextValue(const AKey: %2%; const AValue: %5%; out ANextValue: %5%): Boolean;

    function  RequireValue(const AKey: %2%): %5%;

    procedure SetValue(const AKey: %2%; const AValue: %5%);
    procedure SetOrAdd(const AKey: %2%; const AValue: %5%);

    property  Value[const AKey: %2%]: %5% read RequireValue write SetValue; default;{%IF 6}

    function  DeleteFirstIfExists(const AKey: %2%): Boolean;
    procedure DeleteFirst(const AKey: %2%);

    function  DeleteIfExists(const AKey: %2%): Int32;
    procedure Delete(const AKey: %2%);

    function  DeleteValueIfExists(const AKey: %2%; const AValue: TObject): Boolean;
    procedure DeleteValue(const AKey: %2%; const AValue: TObject);{%ENDIF}

    function  RemoveIfExists(const AKey: %2%; out AValue: %5%): Boolean;
    procedure Remove(const AKey: %2%; out AValue: %5%);

    function  RemoveValueIfExists(const AKey: %2%; const AValue: %5%): Boolean;
    procedure RemoveValue(const AKey: %2%; const AValue: %5%);

    function  Iterate(out AIterator: T%1%MapIterator): P%1%MapItem;
    function  IteratorNext(var AIterator: T%1%MapIterator): P%1%MapItem;
    function  IteratorRemoveItem(var AIterator: T%1%MapIterator): %5%;

    function  VisitAll(
              const ACallback: T%1%MapVisitValueEvent;
              var AKey: %2%;
              var AValue: %5%): Boolean;
  end;


{%ENDDEF}
{%TEMPLATE AMapIntf  'StrObj'  'String'  'StrKey'  ''        'TObject'  'ObjVal'  ''        ''        ''        }
{%TEMPLATE AMapIntf  'IntObj'  'Int64'   ''        'IntKey'  'TObject'  'ObjVal'  ''        ''        ''        }
{%TEMPLATE AMapIntf  'StrInt'  'String'  'StrKey'  ''        'Int64'    ''        'IntVal'  ''        ''        }
{%TEMPLATE AMapIntf  'IntInt'  'Int64'   ''        'IntKey'  'Int64'    ''        'IntVal'  ''        ''        }
{%TEMPLATE AMapIntf  'StrStr'  'String'  'StrKey'  ''        'String'   ''        ''        'StrVal'  ''        }
{%TEMPLATE AMapIntf  'IntStr'  'Int64'   ''        'IntKey'  'String'   ''        ''        'StrVal'  ''        }
{%TEMPLATE AMapIntf  'StrPtr'  'String'  'StrKey'  ''        'Pointer'  ''        ''        ''        'PtrVal'  }
{%TEMPLATE AMapIntf  'IntPtr'  'Int64'   ''        'IntKey'  'Pointer'  ''        ''        ''        'PtrVal'  }
{ Hash functions }

function mapHashStr(const AStr: String; const ACaseSensitive: Boolean = True): Word32;
function mapHashInt(const AInt: Int64): Word32;



implementation



{ Hash functions }

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

// Based on KeyVast hash
function mapHashStr(const AStr: String; const ACaseSensitive: Boolean = True): Word32;
var
  H : Word32;
  L : NativeInt;
  A : Word32;
  C : PChar;
  I : NativeInt;
  F : Word32;
  G : Word32;
begin
  H := $5A1F7304;
  L := Length(AStr);
  A := Word32(L);
  H := H xor Word32(A shl 4)
         xor Word32(A shl 11)
         xor Word32(A shl 21)
         xor Word32(A shl 26);
  C := Pointer(AStr);
  for I := 1 to L do
    begin
      F := Ord(C^);
      if not ACaseSensitive then
        if (F >= Ord('a')) and (F <= Ord('z')) then
          Dec(F, 32);
      A := Word32(I);
      F := F xor (F shl 7)
             xor Word32(A shl 5)
             xor Word32(A shl 12);
      F := F xor Word32(F shl 19)
             xor Word32(F shr 13);
      G := Word32(Word32(F * 69069) + 1);
      H := H xor G;
      H := Word32(Word32(H shl 5) xor (H shr 27));
      Inc(C);
    end;
  Result := H;
end;

// Based on Fowler–Noll–Vo hash 1a
function mapHashInt(const AInt: Int64): Word32;
var
  P : PByte;
  I : Int32;
  H : Word32;
begin
  P := @AInt;
  H := 2166136261;
  for I := 1 to SizeOf(Int64) do
    begin
      H := Word32(Int64(H xor P^) * 16777619);
      Inc(P);
    end;
  Result := H;
end;

{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



{ Helper functions }

function mapSameStringKey(const AStr1, AStr2: String; const ACaseSensitive: Boolean): Boolean; inline;
begin
  if ACaseSensitive then
    Result := AStr1 = AStr2
  else
    Result := SameText(AStr1, AStr2);
end;



{ Error strings }

const
  SErrNoCurrentItem    = 'No current item';
  SErrKeyValueNotFound = 'Key/Value not found: %s';
  SErrKeyNotFound      = 'Key not found: %s';
  SErrDuplicateKey     = 'Duplicate key: %s';
  SErrNoCallback       = 'No callback';



{%DEFINE AMapImpl1}
{ T%1%Map helper functions }

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

procedure map%1%SlotRemoveItem(var ASlt: T%1%HashListSlot; const AItmIdx: Int32); inline;
var
  Idx  : Int32;
  Cnt  : Int32;
  DstP : P%1%MapItem;
  SrcP : P%1%MapItem;
begin
  Assert(ASlt.Count > 0);
  Assert(AItmIdx >= 0);
  DstP := @ASlt.List[AItmIdx];
  SrcP := DstP;
  Inc(SrcP);
  Cnt := ASlt.Count;
  for Idx := AItmIdx to Cnt - 2 do
    begin
      DstP^ := SrcP^;
      Inc(DstP);
      Inc(SrcP);
    end;
  Dec(Cnt);{%IF 3}
  DstP := @ASlt.List[Cnt];
  DstP^.Key := '';{%ENDIF}{%IF 6}
  DstP := @ASlt.List[Cnt];
  DstP^.Value := nil;{%ENDIF}{%IF 8}
  DstP := @ASlt.List[Cnt];
  DstP^.Value := '';{%ENDIF}
  ASlt.Count := Cnt;
end;

{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



{ T%1%Map }

const
  %1%HashList_InitialSlots        = 16;
  %1%HashList_InitialItemsPerSlot = 8;
  %1%HashList_TargetItemsPerSlot  = 8;
  %1%HashList_SlotExpandFactor    = 4;
  %1%HashList_MaxSlots            = $40000000;

constructor T%1%Map.Create({%IF 6}
            const AItemOwner: Boolean;{%ENDIF}{%IF 3}
            const ACaseSensitive: Boolean;{%ENDIF}
            const AAllowDuplicates: Boolean);
var
  Idx : Int32;
begin
  inherited Create;{%IF 6}
  FItemOwner := AItemOwner;{%ENDIF}{%IF 3}
  FCaseSensitive := ACaseSensitive;{%ENDIF}
  FAllowDuplicates := AAllowDuplicates;
  FSlots := %1%HashList_InitialSlots;
  SetLength(FList, FSlots);
  for Idx := 0 to FSlots - 1 do
    FList[Idx].Count := 0;
end;

destructor T%1%Map.Destroy;
begin
  ClearList;
  inherited Destroy;
end;{%IF 6}

procedure T%1%Map.FreeValue(const AKey: %2%; var AValue: TObject);
begin
  if Assigned(FOnFreeValue) then
    FOnFreeValue(AKey, AValue)
  else
    FreeAndNil(AValue);
end;{%ENDIF}

procedure T%1%Map.ClearList;{%IF 6}
var
  SltIdx : Int32;
  ItmIdx : Int32;
  Slt    : P%1%HashListSlot;
  Itm    : P%1%MapItem;{%ENDIF}
begin{%IF 6}
  if FItemOwner then
    for SltIdx := Length(FList) - 1 downto 0 do
      begin
        Slt := @FList[SltIdx];
        for ItmIdx := Slt^.Count - 1 downto 0 do
          begin
            Itm := @Slt^.List[ItmIdx];
            FreeValue(Itm^.Key, Itm^.Value);
          end;
      end;{%ENDIF}
  SetLength(FList, 0);
end;

procedure T%1%Map.Clear;
var
  SltIdx : Int32;
begin
  ClearList;
  FSlots := %1%HashList_InitialSlots;
  SetLength(FList, FSlots);
  for SltIdx := 0 to FSlots - 1 do
    FList[SltIdx].Count := 0;
  FCount := 0;
end;

procedure T%1%Map.AddToSlot(
          const ASlotIdx: Int32;
          const AHash: Word32; const AKey: %2%;
          const AValue: %5%);
var
  Slt : P%1%HashListSlot;
  Cnt : Int32;
  ICn : Int32;
  Itm : P%1%MapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Cnt := Length(Slt^.List);
  ICn := Slt^.Count;
  if Cnt = 0 then
    begin
      Cnt := %1%HashList_InitialItemsPerSlot;
      SetLength(Slt^.List, Cnt);
    end
  else
  if ICn = Cnt then
    begin
      Cnt := Cnt * 2;
      SetLength(Slt^.List, Cnt);
    end;

  Itm := @Slt^.List[ICn];

  Itm^.Hash := AHash;
  Itm^.Key := AKey;
  Itm^.Value := AValue;

  Slt^.Count := ICn + 1;
end;

procedure T%1%Map.ExpandSlots(const ANewSlotCount: Int64);
var
  NewCount  : Int32;
  OldCount  : Int32;
  OldList   : T%1%HashListSlotArray;
  NewList   : T%1%HashListSlotArray;
  SltIdx    : Int32;
  ItmIdx    : Int32;
  Slt       : P%1%HashListSlot;
  Itm       : P%1%MapItem;
  Hsh       : Word32;
  NewSltIdx : Int32;
begin
  NewCount := ANewSlotCount;
  if NewCount > %1%HashList_MaxSlots then
    NewCount := %1%HashList_MaxSlots;
  OldList := FList;
  OldCount := Length(OldList);
  if NewCount = OldCount then
    exit;
  SetLength(NewList, ANewSlotCount);
  for SltIdx := 0 to ANewSlotCount - 1 do
    NewList[SltIdx].Count := 0;
  FList := NewList;
  FSlots := ANewSlotCount;
  for SltIdx := 0 to Length(OldList) - 1 do
    begin
      Slt := @OldList[SltIdx];
      for ItmIdx := 0 to Slt^.Count - 1 do
        begin
          Itm := @Slt^.List[ItmIdx];
          Hsh := Itm^.Hash;
          NewSltIdx := Hsh mod Word32(ANewSlotCount);
          AddToSlot(NewSltIdx, Hsh, Itm^.Key, Itm^.Value);
        end;
      Slt^.List := nil;
    end;
  OldList := nil;
end;

function T%1%Map.LocateItemIndexBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: %2%;
         out Item: P%1%MapItem): Int32;
var
  Slt : P%1%HashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : P%1%MapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := Pointer(Slt^.List);
  ICn := Slt^.Count;
  for Idx := 0 to ICn - 1 do
    begin{%IF 3}
      if Itm^.Hash = AHash then
        if mapSameStringKey(Itm^.Key, AKey, FCaseSensitive) then
          begin
            Item := Itm;
            Result := Idx;
            exit;
          end;{%ENDIF}{%IF 4}
      if Itm^.Key = AKey then
        begin
          Item := Itm;
          Result := Idx;
          exit;
        end;{%ENDIF}
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function T%1%Map.LocateNextItemIndexBySlot(
         const ASlotIdx: Int32; const AItemIdx: Int32;
         const AHash: Word32; const AKey: %2%;
         out Item: P%1%MapItem): Int32;
var
  Slt : P%1%HashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : P%1%MapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := @Slt^.List[AItemIdx];
  ICn := Slt^.Count;
  for Idx := AItemIdx + 1 to ICn - 1 do
    begin{%IF 3}
      if Itm^.Hash = AHash then
        if mapSameStringKey(Itm^.Key, AKey, FCaseSensitive) then
          begin
            Item := Itm;
            Result := Idx;
            exit;
          end;{%ENDIF}{%IF 4}
      if Itm^.Key = AKey then
        begin
          Item := Itm;
          Result := Idx;
          exit;
        end;{%ENDIF}
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function T%1%Map.LocateItemBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: %2%;
         out AItem: P%1%MapItem): Boolean;
begin
  Result := LocateItemIndexBySlot(ASlotIdx, AHash, AKey, AItem) >= 0;
end;

function T%1%Map.LocateItem(const AKey: %2%; out AItem: P%1%MapItem): Boolean;
var
  Hsh : Word32;
  Slt : Int32;
begin{%IF 3}
  Hsh := mapHashStr(AKey, FCaseSensitive);{%ENDIF}{%IF 4}
  Hsh := mapHashInt(AKey);{%ENDIF}
  Slt := Hsh mod Word32(FSlots);
  Result := LocateItemIndexBySlot(Slt, Hsh, AKey, AItem) >= 0;
end;

procedure T%1%Map.Add(const AKey: %2%; const AValue: %5%);
var
  Hsh : Word32;
  Slt : Int32;
  Itm : P%1%MapItem;
begin
  if FCount = FSlots * %1%HashList_TargetItemsPerSlot then
    ExpandSlots(FSlots * %1%HashList_SlotExpandFactor);{%IF 3}
  Hsh := mapHashStr(AKey, FCaseSensitive);{%ENDIF}{%IF 4}
  Hsh := mapHashInt(AKey);{%ENDIF}
  Slt := Hsh mod Word32(FSlots);
  if not FAllowDuplicates then
    if LocateItemBySlot(Slt, Hsh, AKey, Itm) then
      raise E%1%MapError.CreateFmt(SErrDuplicateKey, [AKey]);
  AddToSlot(Slt, Hsh, AKey, AValue);
  Inc(FCount);
end;

function T%1%Map.KeyExists(const AKey: %2%): Boolean;
var
  Itm : P%1%MapItem;
begin
  Result := LocateItem(AKey, Itm);
end;

function T%1%Map.KeyCount(const AKey: %2%): Int32;
var
  Hsh      : Word32;
  SltIdx   : Int32;
  ItmIdx   : Int32;
  Itm      : P%1%MapItem;
  AllowDup : Boolean;
  Cnt      : Int32;
  Fin      : Boolean;
begin{%IF 3}
  Hsh := mapHashStr(AKey, FCaseSensitive);{%ENDIF}{%IF 4}
  Hsh := mapHashInt(AKey);{%ENDIF}
  SltIdx := Hsh mod Word32(FSlots);
  AllowDup := FAllowDuplicates;
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      Result := 0;
      exit;
    end;
  if not AllowDup then
    begin
      Result := 1;
      exit;
    end;
  Cnt := 1;
  Fin := False;
  repeat
    ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
    if ItmIdx < 0 then
      Fin := True
    else
      Inc(Cnt);
  until Fin;
  Result := Cnt;
end;

function T%1%Map.Get(const AKey: %2%): %5%;
var
  Itm : P%1%MapItem;
begin
  if not LocateItem(AKey, Itm) then
    Result := {%IF 6}nil{%ENDIF}{%IF 7}0{%ENDIF}{%IF 8}''{%ENDIF}{%IF 9}nil{%ENDIF}
  else
    Result := Itm^.Value;
end;

function T%1%Map.GetValue(const AKey: %2%; out AValue: %5%): Boolean;
var
  Itm : P%1%MapItem;
begin
  if not LocateItem(AKey, Itm) then
    begin
      AValue := {%IF 6}nil{%ENDIF}{%IF 7}0{%ENDIF}{%IF 8}''{%ENDIF}{%IF 9}nil{%ENDIF};
      Result := False;
    end
  else
    begin
      AValue := Itm^.Value;
      Result := True;
    end;
end;

function T%1%Map.GetNextValue(
         const AKey: %2%; const AValue: %5%;
         out ANextValue: %5%): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : P%1%MapItem;
begin{%IF 3}
  Hsh := mapHashStr(AKey, FCaseSensitive);{%ENDIF}{%IF 4}
  Hsh := mapHashInt(AKey);{%ENDIF}
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    begin
      if Itm^.Value = AValue then
        begin
          ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
          if ItmIdx < 0 then
            break;
          ANextValue := Itm^.Value;
          Result := True;
          exit;
        end;
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
    end;
  ANextValue := {%IF 6}nil{%ENDIF}{%IF 7}0{%ENDIF}{%IF 8}''{%ENDIF}{%IF 9}nil{%ENDIF};
  Result := False;
end;

function T%1%Map.RequireItem(const AKey: %2%): P%1%MapItem;
var
  Itm : P%1%MapItem;
begin
  if not LocateItem(AKey, Itm) then
    raise E%1%MapError.CreateFmt(SErrKeyNotFound, [AKey]);
  Result := Itm;
end;

function T%1%Map.RequireValue(const AKey: %2%): %5%;
begin
  Result := RequireItem(AKey)^.Value;
end;

procedure T%1%Map.SetValue(const AKey: %2%; const AValue: %5%);
var
  Itm : P%1%MapItem;
begin
  Itm := RequireItem(AKey);{%IF 6}
  if FItemOwner then
    FreeValue(Itm^.Key, Itm^.Value);{%ENDIF}
  Itm^.Value := AValue;
end;

procedure T%1%Map.SetOrAdd(const AKey: %2%; const AValue: %5%);
var
  Hsh    : Word32;
  Slt    : Int32;
  Itm    : P%1%MapItem;
  ItmIdx : Int32;
begin{%IF 3}
  Hsh := mapHashStr(AKey, FCaseSensitive);{%ENDIF}{%IF 4}
  Hsh := mapHashInt(AKey);{%ENDIF}
  Slt := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(Slt, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      if FCount = FSlots * %1%HashList_TargetItemsPerSlot then
        begin
          ExpandSlots(FSlots * %1%HashList_SlotExpandFactor);
          Slt := Hsh mod Word32(FSlots);
        end;
      AddToSlot(Slt, Hsh, AKey, AValue);
      Inc(FCount);
    end
  else
    begin{%IF 6}
      if FItemOwner then
        FreeValue(Itm^.Key, Itm^.Value);{%ENDIF}
      Itm^.Value := AValue;
    end;
end;
{%ENDDEF}
{%DEFINE AMapImpl2}
function T%1%Map.DeleteFirstIfExists(const AKey: %2%): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : P%1%MapItem;
  Slt    : P%1%HashListSlot;
begin{%IF 3}
  Hsh := mapHashStr(AKey, FCaseSensitive);{%ENDIF}{%IF 4}
  Hsh := mapHashInt(AKey);{%ENDIF}
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      Result := False;
      exit;
    end;
  if FItemOwner then
    FreeValue(Itm^.Key, Itm^.Value);
  Slt := @FList[SltIdx];
  map%1%SlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  Result := True;
end;

procedure T%1%Map.DeleteFirst(const AKey: %2%);
begin
  if not DeleteFirstIfExists(AKey) then
    raise E%1%MapError.CreateFmt(SErrKeyNotFound, [AKey]);
end;

function T%1%Map.DeleteIfExists(const AKey: %2%): Int32;
var
  Hsh      : Word32;
  SltIdx   : Int32;
  ItmIdx   : Int32;
  Itm      : P%1%MapItem;
  Slt      : P%1%HashListSlot;
  AllowDup : Boolean;
  Res      : Int32;
begin{%IF 3}
  Hsh := mapHashStr(AKey, FCaseSensitive);{%ENDIF}{%IF 4}
  Hsh := mapHashInt(AKey);{%ENDIF}
  SltIdx := Hsh mod Word32(FSlots);
  Slt := @FList[SltIdx];
  AllowDup := FAllowDuplicates;
  Res := 0;
  repeat
    ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
    if ItmIdx < 0 then
      break;
    if FItemOwner then
      FreeValue(Itm^.Key, Itm^.Value);
    map%1%SlotRemoveItem(Slt^, ItmIdx);
    Dec(FCount);
    Inc(Res);
  until not AllowDup;
  Result := Res;
end;

procedure T%1%Map.Delete(const AKey: %2%);
begin
  if DeleteIfExists(AKey) = 0 then
    raise E%1%MapError.CreateFmt(SErrKeyNotFound, [AKey])
end;

function T%1%Map.DeleteValueIfExists(const AKey: %2%; const AValue: TObject): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : P%1%MapItem;
  Slt    : P%1%HashListSlot;
begin{%IF 3}
  Hsh := mapHashStr(AKey, FCaseSensitive);{%ENDIF}{%IF 4}
  Hsh := mapHashInt(AKey);{%ENDIF}
  SltIdx := Hsh mod Word32(FSlots);
  Slt := @FList[SltIdx];
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    if Itm^.Value = AValue then
      begin
        if FItemOwner then
          FreeValue(Itm^.Key, Itm^.Value);
        map%1%SlotRemoveItem(Slt^, ItmIdx);
        Dec(FCount);
        Result := True;
        exit;
      end
    else
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
  Result := False;
end;

procedure T%1%Map.DeleteValue(const AKey: %2%; const AValue: TObject);
begin
  if not DeleteValueIfExists(AKey, AValue) then
    raise E%1%MapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;
{%ENDDEF}
{%DEFINE AMapImpl3}
function T%1%Map.RemoveIfExists(const AKey: %2%; out AValue: %5%): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : P%1%MapItem;
  Slt    : P%1%HashListSlot;
begin{%IF 3}
  Hsh := mapHashStr(AKey, FCaseSensitive);{%ENDIF}{%IF 4}
  Hsh := mapHashInt(AKey);{%ENDIF}
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      AValue := {%IF 6}nil{%ENDIF}{%IF 7}0{%ENDIF}{%IF 8}''{%ENDIF}{%IF 9}nil{%ENDIF};
      Result := False;
      exit;
    end;
  AValue := Itm^.Value;
  Itm^.Value := {%IF 6}nil{%ENDIF}{%IF 7}0{%ENDIF}{%IF 8}''{%ENDIF}{%IF 9}nil{%ENDIF};
  Slt := @FList[SltIdx];
  map%1%SlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  Result := True;
end;

procedure T%1%Map.Remove(const AKey: %2%; out AValue: %5%);
begin
  if not RemoveIfExists(AKey, AValue) then
    raise E%1%MapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function T%1%Map.RemoveValueIfExists(const AKey: %2%; const AValue: %5%): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : P%1%MapItem;
  Slt    : P%1%HashListSlot;
begin{%IF 3}
  Hsh := mapHashStr(AKey, FCaseSensitive);{%ENDIF}{%IF 4}
  Hsh := mapHashInt(AKey);{%ENDIF}
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    if Itm^.Value = AValue then
      begin
        Itm^.Value := {%IF 6}nil{%ENDIF}{%IF 7}0{%ENDIF}{%IF 8}''{%ENDIF}{%IF 9}nil{%ENDIF};
        Slt := @FList[SltIdx];
        map%1%SlotRemoveItem(Slt^, ItmIdx);
        Dec(FCount);
        Result := True;
        exit;
      end
    else
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
  Result := False;
end;

procedure T%1%Map.RemoveValue(const AKey: %2%; const AValue: %5%);
begin
  if not RemoveValueIfExists(AKey, AValue) then
    raise E%1%MapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function T%1%Map.IterateGetNext(var AIterator: T%1%MapIterator): P%1%MapItem;
var
  SltIdx : Int32;
  Slt    : P%1%HashListSlot;
  DoNext : Boolean;
begin
  if AIterator.Finished then
    raise E%1%MapError.Create(SErrNoCurrentItem);
  AIterator.Deleted := False;
  repeat
    DoNext := False;
    SltIdx := AIterator.SlotIdx;
    if SltIdx >= FSlots then
      begin
        AIterator.Finished := True;
        Result := nil;
        exit;
      end;
    Slt := @FList[SltIdx];
    if AIterator.ItemIdx >= Slt^.Count then
      begin
        Inc(AIterator.SlotIdx);
        AIterator.ItemIdx := 0;
        DoNext := True;
      end;
  until not DoNext;
  Result := @Slt^.List[AIterator.ItemIdx];
end;

function T%1%Map.Iterate(out AIterator: T%1%MapIterator): P%1%MapItem;
begin
  AIterator.SlotIdx := 0;
  AIterator.ItemIdx := 0;
  AIterator.Finished := False;
  Result := IterateGetNext(AIterator);
end;

function T%1%Map.IteratorNext(var AIterator: T%1%MapIterator): P%1%MapItem;
begin
  if AIterator.Finished then
    raise E%1%MapError.Create(SErrNoCurrentItem);

  Inc(AIterator.ItemIdx);
  Result := IterateGetNext(AIterator);
end;

function T%1%Map.IteratorRemoveItem(var AIterator: T%1%MapIterator): %5%;
var
  SltIdx : Integer;
  ItmIdx : Int32;
  Itm    : P%1%MapItem;
  Slt    : P%1%HashListSlot;
begin
  if AIterator.Finished or AIterator.Deleted then
    raise E%1%MapError.Create(SErrNoCurrentItem);

  SltIdx := AIterator.SlotIdx;
  ItmIdx := AIterator.ItemIdx;
  Slt := @FList[SltIdx];
  if ItmIdx >= Slt^.Count then
    begin
      Result := {%IF 6}nil{%ENDIF}{%IF 7}0{%ENDIF}{%IF 8}''{%ENDIF}{%IF 9}nil{%ENDIF};
      exit;
    end;
  Itm := @Slt^.List[ItmIdx];
  Result := Itm^.Value;
  map%1%SlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  AIterator.Deleted := True;
end;

function T%1%Map.VisitAll(
         const ACallback: T%1%MapVisitValueEvent;
         var AKey: %2%;
         var AValue: %5%): Boolean;
var
  Stop   : Boolean;
  SltIdx : Int32;
  ItmIdx : Int32;
  Slt    : P%1%HashListSlot;
  Itm    : P%1%MapItem;
begin
  if not Assigned(ACallback) then
    raise E%1%MapError.Create(SErrNoCallback);

  Stop := False;
  for SltIdx := 0 to Length(FList) - 1 do
    begin
      Slt := @FList[SltIdx];
      for ItmIdx := 0 to Slt^.Count - 1 do
        begin
          Itm := @Slt^.List[ItmIdx];
          ACallback(Itm^.Key, Itm^.Value, Stop);
          if Stop then
            begin
              AKey := Itm^.Key;
              AValue := Itm^.Value;
              Result := True;
              exit;
            end;
        end;
    end;
  AKey := {%IF 3}''{%ENDIF}{%IF 4}0{%ENDIF};
  AValue := {%IF 6}nil{%ENDIF}{%IF 7}0{%ENDIF}{%IF 8}''{%ENDIF}{%IF 9}nil{%ENDIF};
  Result := False;
end;


{%ENDDEF}
{%TEMPLATE AMapImpl1  'StrObj'  'String'  'StrKey'  ''        'TObject'  'ObjVal'  ''        ''        ''        }
{%TEMPLATE AMapImpl2  'StrObj'  'String'  'StrKey'  ''        'TObject'  'ObjVal'  ''        ''        ''        }
{%TEMPLATE AMapImpl3  'StrObj'  'String'  'StrKey'  ''        'TObject'  'ObjVal'  ''        ''        ''        }
{%TEMPLATE AMapImpl1  'IntObj'  'Int64'   ''        'IntKey'  'TObject'  'ObjVal'  ''        ''        ''        }
{%TEMPLATE AMapImpl2  'IntObj'  'Int64'   ''        'IntKey'  'TObject'  'ObjVal'  ''        ''        ''        }
{%TEMPLATE AMapImpl3  'IntObj'  'Int64'   ''        'IntKey'  'TObject'  'ObjVal'  ''        ''        ''        }
{%TEMPLATE AMapImpl1  'StrInt'  'String'  'StrKey'  ''        'Int64'    ''        'IntVal'  ''        ''        }
{%TEMPLATE AMapImpl3  'StrInt'  'String'  'StrKey'  ''        'Int64'    ''        'IntVal'  ''        ''        }
{%TEMPLATE AMapImpl1  'IntInt'  'Int64'   ''        'IntKey'  'Int64'    ''        'IntVal'  ''        ''        }
{%TEMPLATE AMapImpl3  'IntInt'  'Int64'   ''        'IntKey'  'Int64'    ''        'IntVal'  ''        ''        }
{%TEMPLATE AMapImpl1  'StrStr'  'String'  'StrKey'  ''        'String'   ''        ''        'StrVal'  ''        }
{%TEMPLATE AMapImpl3  'StrStr'  'String'  'StrKey'  ''        'String'   ''        ''        'StrVal'  ''        }
{%TEMPLATE AMapImpl1  'IntStr'  'Int64'   ''        'IntKey'  'String'   ''        ''        'StrVal'  ''        }
{%TEMPLATE AMapImpl3  'IntStr'  'Int64'   ''        'IntKey'  'String'   ''        ''        'StrVal'  ''        }
{%TEMPLATE AMapImpl1  'StrPtr'  'String'  'StrKey'  ''        'Pointer'  ''        ''        ''        'PtrVal'  }
{%TEMPLATE AMapImpl3  'StrPtr'  'String'  'StrKey'  ''        'Pointer'  ''        ''        ''        'PtrVal'  }
{%TEMPLATE AMapImpl1  'IntPtr'  'Int64'   ''        'IntKey'  'Pointer'  ''        ''        ''        'PtrVal'  }
{%TEMPLATE AMapImpl3  'IntPtr'  'Int64'   ''        'IntKey'  'Pointer'  ''        ''        ''        'PtrVal'  }
end.

