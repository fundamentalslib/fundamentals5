{***************************************************************************** }
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
{***************************************************************************** }

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



{ TStrObjMap }

type
  EStrObjMapError = class(Exception);

  TStrObjMapItem = record
    Hash  : Word32;
    Key   : String;
    Value : TObject;
  end;
  PStrObjMapItem = ^TStrObjMapItem;

  TStrObjHashListSlot = record
    Count : Int32;
    List  : packed array of TStrObjMapItem;
  end;
  PStrObjHashListSlot = ^TStrObjHashListSlot;
  TStrObjHashListSlotArray = array of TStrObjHashListSlot;

  TStrObjMapIterator = record
    SlotIdx  : Int32;
    ItemIdx  : Int32;
    Finished : Boolean;
    Deleted  : Boolean;
  end;

  TStrObjMapVisitValueEvent = procedure (const AKey: String; const AValue: TObject; var Stop: Boolean) of object;
  TStrObjMapFreeValueEvent = procedure (const AKey: String; var AValue: TObject) of object;

  TStrObjMap = class
  private
    FItemOwner       : Boolean;
    FCaseSensitive   : Boolean;
    FAllowDuplicates : Boolean;

    FOnFreeValue : TStrObjMapFreeValueEvent;

    FCount : Int32;
    FSlots : Int32;
    FList  : TStrObjHashListSlotArray;

    procedure ClearList;
    procedure AddToSlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: String;
              const AValue: TObject); {$IFDEF UseInline}inline;{$ENDIF}
    procedure ExpandSlots(const ANewSlotCount: Int64);

    function  LocateItemIndexBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: String;
              out Item: PStrObjMapItem): Int32;
    function  LocateNextItemIndexBySlot(
              const ASlotIdx: Int32; const AItemIdx: Int32;
              const AHash: Word32; const AKey: String;
              out Item: PStrObjMapItem): Int32;
    function  LocateItemBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: String;
              out AItem: PStrObjMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  LocateItem(
              const AKey: String;
              out AItem: PStrObjMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  RequireItem(const AKey: String): PStrObjMapItem;

    function  IterateGetNext(var AIterator: TStrObjMapIterator): PStrObjMapItem;

  protected
    procedure FreeValue(const AKey: String; var AValue: TObject); virtual;

  public
    constructor Create(
                const AItemOwner: Boolean = False;
                const ACaseSensitive: Boolean = True;
                const AAllowDuplicates: Boolean = True);
    destructor Destroy; override;

    property  ItemOwner: Boolean read FItemOwner;
    property  CaseSensitive: Boolean read FCaseSensitive;
    property  AllowDuplicates: Boolean read FAllowDuplicates;

    property  OnFreeValue: TStrObjMapFreeValueEvent read FOnFreeValue write FOnFreeValue;

    procedure Clear;
    property  Count: Int32 read FCount;

    procedure Add(const AKey: String; const AValue: TObject);

    function  KeyExists(const AKey: String): Boolean;
    function  KeyCount(const AKey: String): Int32;

    function  Get(const AKey: String): TObject;

    function  GetValue(const AKey: String; out AValue: TObject): Boolean;
    function  GetNextValue(const AKey: String; const AValue: TObject; out ANextValue: TObject): Boolean;

    function  RequireValue(const AKey: String): TObject;

    procedure SetValue(const AKey: String; const AValue: TObject);
    procedure SetOrAdd(const AKey: String; const AValue: TObject);

    property  Value[const AKey: String]: TObject read RequireValue write SetValue; default;

    function  DeleteFirstIfExists(const AKey: String): Boolean;
    procedure DeleteFirst(const AKey: String);

    function  DeleteIfExists(const AKey: String): Int32;
    procedure Delete(const AKey: String);

    function  DeleteValueIfExists(const AKey: String; const AValue: TObject): Boolean;
    procedure DeleteValue(const AKey: String; const AValue: TObject);

    function  RemoveIfExists(const AKey: String; out AValue: TObject): Boolean;
    procedure Remove(const AKey: String; out AValue: TObject);

    function  RemoveValueIfExists(const AKey: String; const AValue: TObject): Boolean;
    procedure RemoveValue(const AKey: String; const AValue: TObject);

    function  Iterate(out AIterator: TStrObjMapIterator): PStrObjMapItem;
    function  IteratorNext(var AIterator: TStrObjMapIterator): PStrObjMapItem;
    function  IteratorRemoveItem(var AIterator: TStrObjMapIterator): TObject;

    function  VisitAll(
              const ACallback: TStrObjMapVisitValueEvent;
              var AKey: String;
              var AValue: TObject): Boolean;
  end;



{ TIntObjMap }

type
  EIntObjMapError = class(Exception);

  TIntObjMapItem = record
    Hash  : Word32;
    Key   : Int64;
    Value : TObject;
  end;
  PIntObjMapItem = ^TIntObjMapItem;

  TIntObjHashListSlot = record
    Count : Int32;
    List  : packed array of TIntObjMapItem;
  end;
  PIntObjHashListSlot = ^TIntObjHashListSlot;
  TIntObjHashListSlotArray = array of TIntObjHashListSlot;

  TIntObjMapIterator = record
    SlotIdx  : Int32;
    ItemIdx  : Int32;
    Finished : Boolean;
    Deleted  : Boolean;
  end;

  TIntObjMapVisitValueEvent = procedure (const AKey: Int64; const AValue: TObject; var Stop: Boolean) of object;
  TIntObjMapFreeValueEvent = procedure (const AKey: Int64; var AValue: TObject) of object;

  TIntObjMap = class
  private
    FItemOwner       : Boolean;
    FAllowDuplicates : Boolean;

    FOnFreeValue : TIntObjMapFreeValueEvent;

    FCount : Int32;
    FSlots : Int32;
    FList  : TIntObjHashListSlotArray;

    procedure ClearList;
    procedure AddToSlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              const AValue: TObject); {$IFDEF UseInline}inline;{$ENDIF}
    procedure ExpandSlots(const ANewSlotCount: Int64);

    function  LocateItemIndexBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              out Item: PIntObjMapItem): Int32;
    function  LocateNextItemIndexBySlot(
              const ASlotIdx: Int32; const AItemIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              out Item: PIntObjMapItem): Int32;
    function  LocateItemBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              out AItem: PIntObjMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  LocateItem(
              const AKey: Int64;
              out AItem: PIntObjMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  RequireItem(const AKey: Int64): PIntObjMapItem;

    function  IterateGetNext(var AIterator: TIntObjMapIterator): PIntObjMapItem;

  protected
    procedure FreeValue(const AKey: Int64; var AValue: TObject); virtual;

  public
    constructor Create(
                const AItemOwner: Boolean = False;
                const AAllowDuplicates: Boolean = True);
    destructor Destroy; override;

    property  ItemOwner: Boolean read FItemOwner;
    property  AllowDuplicates: Boolean read FAllowDuplicates;

    property  OnFreeValue: TIntObjMapFreeValueEvent read FOnFreeValue write FOnFreeValue;

    procedure Clear;
    property  Count: Int32 read FCount;

    procedure Add(const AKey: Int64; const AValue: TObject);

    function  KeyExists(const AKey: Int64): Boolean;
    function  KeyCount(const AKey: Int64): Int32;

    function  Get(const AKey: Int64): TObject;

    function  GetValue(const AKey: Int64; out AValue: TObject): Boolean;
    function  GetNextValue(const AKey: Int64; const AValue: TObject; out ANextValue: TObject): Boolean;

    function  RequireValue(const AKey: Int64): TObject;

    procedure SetValue(const AKey: Int64; const AValue: TObject);
    procedure SetOrAdd(const AKey: Int64; const AValue: TObject);

    property  Value[const AKey: Int64]: TObject read RequireValue write SetValue; default;

    function  DeleteFirstIfExists(const AKey: Int64): Boolean;
    procedure DeleteFirst(const AKey: Int64);

    function  DeleteIfExists(const AKey: Int64): Int32;
    procedure Delete(const AKey: Int64);

    function  DeleteValueIfExists(const AKey: Int64; const AValue: TObject): Boolean;
    procedure DeleteValue(const AKey: Int64; const AValue: TObject);

    function  RemoveIfExists(const AKey: Int64; out AValue: TObject): Boolean;
    procedure Remove(const AKey: Int64; out AValue: TObject);

    function  RemoveValueIfExists(const AKey: Int64; const AValue: TObject): Boolean;
    procedure RemoveValue(const AKey: Int64; const AValue: TObject);

    function  Iterate(out AIterator: TIntObjMapIterator): PIntObjMapItem;
    function  IteratorNext(var AIterator: TIntObjMapIterator): PIntObjMapItem;
    function  IteratorRemoveItem(var AIterator: TIntObjMapIterator): TObject;

    function  VisitAll(
              const ACallback: TIntObjMapVisitValueEvent;
              var AKey: Int64;
              var AValue: TObject): Boolean;
  end;



{ TStrIntMap }

type
  EStrIntMapError = class(Exception);

  TStrIntMapItem = record
    Hash  : Word32;
    Key   : String;
    Value : Int64;
  end;
  PStrIntMapItem = ^TStrIntMapItem;

  TStrIntHashListSlot = record
    Count : Int32;
    List  : packed array of TStrIntMapItem;
  end;
  PStrIntHashListSlot = ^TStrIntHashListSlot;
  TStrIntHashListSlotArray = array of TStrIntHashListSlot;

  TStrIntMapIterator = record
    SlotIdx  : Int32;
    ItemIdx  : Int32;
    Finished : Boolean;
    Deleted  : Boolean;
  end;

  TStrIntMapVisitValueEvent = procedure (const AKey: String; const AValue: Int64; var Stop: Boolean) of object;

  TStrIntMap = class
  private
    FCaseSensitive   : Boolean;
    FAllowDuplicates : Boolean;


    FCount : Int32;
    FSlots : Int32;
    FList  : TStrIntHashListSlotArray;

    procedure ClearList;
    procedure AddToSlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: String;
              const AValue: Int64); {$IFDEF UseInline}inline;{$ENDIF}
    procedure ExpandSlots(const ANewSlotCount: Int64);

    function  LocateItemIndexBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: String;
              out Item: PStrIntMapItem): Int32;
    function  LocateNextItemIndexBySlot(
              const ASlotIdx: Int32; const AItemIdx: Int32;
              const AHash: Word32; const AKey: String;
              out Item: PStrIntMapItem): Int32;
    function  LocateItemBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: String;
              out AItem: PStrIntMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  LocateItem(
              const AKey: String;
              out AItem: PStrIntMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  RequireItem(const AKey: String): PStrIntMapItem;

    function  IterateGetNext(var AIterator: TStrIntMapIterator): PStrIntMapItem;


  public
    constructor Create(
                const ACaseSensitive: Boolean = True;
                const AAllowDuplicates: Boolean = True);
    destructor Destroy; override;

    property  CaseSensitive: Boolean read FCaseSensitive;
    property  AllowDuplicates: Boolean read FAllowDuplicates;

    procedure Clear;
    property  Count: Int32 read FCount;

    procedure Add(const AKey: String; const AValue: Int64);

    function  KeyExists(const AKey: String): Boolean;
    function  KeyCount(const AKey: String): Int32;

    function  Get(const AKey: String): Int64;

    function  GetValue(const AKey: String; out AValue: Int64): Boolean;
    function  GetNextValue(const AKey: String; const AValue: Int64; out ANextValue: Int64): Boolean;

    function  RequireValue(const AKey: String): Int64;

    procedure SetValue(const AKey: String; const AValue: Int64);
    procedure SetOrAdd(const AKey: String; const AValue: Int64);

    property  Value[const AKey: String]: Int64 read RequireValue write SetValue; default;

    function  RemoveIfExists(const AKey: String; out AValue: Int64): Boolean;
    procedure Remove(const AKey: String; out AValue: Int64);

    function  RemoveValueIfExists(const AKey: String; const AValue: Int64): Boolean;
    procedure RemoveValue(const AKey: String; const AValue: Int64);

    function  Iterate(out AIterator: TStrIntMapIterator): PStrIntMapItem;
    function  IteratorNext(var AIterator: TStrIntMapIterator): PStrIntMapItem;
    function  IteratorRemoveItem(var AIterator: TStrIntMapIterator): Int64;

    function  VisitAll(
              const ACallback: TStrIntMapVisitValueEvent;
              var AKey: String;
              var AValue: Int64): Boolean;
  end;



{ TIntIntMap }

type
  EIntIntMapError = class(Exception);

  TIntIntMapItem = record
    Hash  : Word32;
    Key   : Int64;
    Value : Int64;
  end;
  PIntIntMapItem = ^TIntIntMapItem;

  TIntIntHashListSlot = record
    Count : Int32;
    List  : packed array of TIntIntMapItem;
  end;
  PIntIntHashListSlot = ^TIntIntHashListSlot;
  TIntIntHashListSlotArray = array of TIntIntHashListSlot;

  TIntIntMapIterator = record
    SlotIdx  : Int32;
    ItemIdx  : Int32;
    Finished : Boolean;
    Deleted  : Boolean;
  end;

  TIntIntMapVisitValueEvent = procedure (const AKey: Int64; const AValue: Int64; var Stop: Boolean) of object;

  TIntIntMap = class
  private
    FAllowDuplicates : Boolean;


    FCount : Int32;
    FSlots : Int32;
    FList  : TIntIntHashListSlotArray;

    procedure ClearList;
    procedure AddToSlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              const AValue: Int64); {$IFDEF UseInline}inline;{$ENDIF}
    procedure ExpandSlots(const ANewSlotCount: Int64);

    function  LocateItemIndexBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              out Item: PIntIntMapItem): Int32;
    function  LocateNextItemIndexBySlot(
              const ASlotIdx: Int32; const AItemIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              out Item: PIntIntMapItem): Int32;
    function  LocateItemBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              out AItem: PIntIntMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  LocateItem(
              const AKey: Int64;
              out AItem: PIntIntMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  RequireItem(const AKey: Int64): PIntIntMapItem;

    function  IterateGetNext(var AIterator: TIntIntMapIterator): PIntIntMapItem;


  public
    constructor Create(
                const AAllowDuplicates: Boolean = True);
    destructor Destroy; override;

    property  AllowDuplicates: Boolean read FAllowDuplicates;

    procedure Clear;
    property  Count: Int32 read FCount;

    procedure Add(const AKey: Int64; const AValue: Int64);

    function  KeyExists(const AKey: Int64): Boolean;
    function  KeyCount(const AKey: Int64): Int32;

    function  Get(const AKey: Int64): Int64;

    function  GetValue(const AKey: Int64; out AValue: Int64): Boolean;
    function  GetNextValue(const AKey: Int64; const AValue: Int64; out ANextValue: Int64): Boolean;

    function  RequireValue(const AKey: Int64): Int64;

    procedure SetValue(const AKey: Int64; const AValue: Int64);
    procedure SetOrAdd(const AKey: Int64; const AValue: Int64);

    property  Value[const AKey: Int64]: Int64 read RequireValue write SetValue; default;

    function  RemoveIfExists(const AKey: Int64; out AValue: Int64): Boolean;
    procedure Remove(const AKey: Int64; out AValue: Int64);

    function  RemoveValueIfExists(const AKey: Int64; const AValue: Int64): Boolean;
    procedure RemoveValue(const AKey: Int64; const AValue: Int64);

    function  Iterate(out AIterator: TIntIntMapIterator): PIntIntMapItem;
    function  IteratorNext(var AIterator: TIntIntMapIterator): PIntIntMapItem;
    function  IteratorRemoveItem(var AIterator: TIntIntMapIterator): Int64;

    function  VisitAll(
              const ACallback: TIntIntMapVisitValueEvent;
              var AKey: Int64;
              var AValue: Int64): Boolean;
  end;



{ TStrStrMap }

type
  EStrStrMapError = class(Exception);

  TStrStrMapItem = record
    Hash  : Word32;
    Key   : String;
    Value : String;
  end;
  PStrStrMapItem = ^TStrStrMapItem;

  TStrStrHashListSlot = record
    Count : Int32;
    List  : packed array of TStrStrMapItem;
  end;
  PStrStrHashListSlot = ^TStrStrHashListSlot;
  TStrStrHashListSlotArray = array of TStrStrHashListSlot;

  TStrStrMapIterator = record
    SlotIdx  : Int32;
    ItemIdx  : Int32;
    Finished : Boolean;
    Deleted  : Boolean;
  end;

  TStrStrMapVisitValueEvent = procedure (const AKey: String; const AValue: String; var Stop: Boolean) of object;

  TStrStrMap = class
  private
    FCaseSensitive   : Boolean;
    FAllowDuplicates : Boolean;


    FCount : Int32;
    FSlots : Int32;
    FList  : TStrStrHashListSlotArray;

    procedure ClearList;
    procedure AddToSlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: String;
              const AValue: String); {$IFDEF UseInline}inline;{$ENDIF}
    procedure ExpandSlots(const ANewSlotCount: Int64);

    function  LocateItemIndexBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: String;
              out Item: PStrStrMapItem): Int32;
    function  LocateNextItemIndexBySlot(
              const ASlotIdx: Int32; const AItemIdx: Int32;
              const AHash: Word32; const AKey: String;
              out Item: PStrStrMapItem): Int32;
    function  LocateItemBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: String;
              out AItem: PStrStrMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  LocateItem(
              const AKey: String;
              out AItem: PStrStrMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  RequireItem(const AKey: String): PStrStrMapItem;

    function  IterateGetNext(var AIterator: TStrStrMapIterator): PStrStrMapItem;


  public
    constructor Create(
                const ACaseSensitive: Boolean = True;
                const AAllowDuplicates: Boolean = True);
    destructor Destroy; override;

    property  CaseSensitive: Boolean read FCaseSensitive;
    property  AllowDuplicates: Boolean read FAllowDuplicates;

    procedure Clear;
    property  Count: Int32 read FCount;

    procedure Add(const AKey: String; const AValue: String);

    function  KeyExists(const AKey: String): Boolean;
    function  KeyCount(const AKey: String): Int32;

    function  Get(const AKey: String): String;

    function  GetValue(const AKey: String; out AValue: String): Boolean;
    function  GetNextValue(const AKey: String; const AValue: String; out ANextValue: String): Boolean;

    function  RequireValue(const AKey: String): String;

    procedure SetValue(const AKey: String; const AValue: String);
    procedure SetOrAdd(const AKey: String; const AValue: String);

    property  Value[const AKey: String]: String read RequireValue write SetValue; default;

    function  RemoveIfExists(const AKey: String; out AValue: String): Boolean;
    procedure Remove(const AKey: String; out AValue: String);

    function  RemoveValueIfExists(const AKey: String; const AValue: String): Boolean;
    procedure RemoveValue(const AKey: String; const AValue: String);

    function  Iterate(out AIterator: TStrStrMapIterator): PStrStrMapItem;
    function  IteratorNext(var AIterator: TStrStrMapIterator): PStrStrMapItem;
    function  IteratorRemoveItem(var AIterator: TStrStrMapIterator): String;

    function  VisitAll(
              const ACallback: TStrStrMapVisitValueEvent;
              var AKey: String;
              var AValue: String): Boolean;
  end;



{ TIntStrMap }

type
  EIntStrMapError = class(Exception);

  TIntStrMapItem = record
    Hash  : Word32;
    Key   : Int64;
    Value : String;
  end;
  PIntStrMapItem = ^TIntStrMapItem;

  TIntStrHashListSlot = record
    Count : Int32;
    List  : packed array of TIntStrMapItem;
  end;
  PIntStrHashListSlot = ^TIntStrHashListSlot;
  TIntStrHashListSlotArray = array of TIntStrHashListSlot;

  TIntStrMapIterator = record
    SlotIdx  : Int32;
    ItemIdx  : Int32;
    Finished : Boolean;
    Deleted  : Boolean;
  end;

  TIntStrMapVisitValueEvent = procedure (const AKey: Int64; const AValue: String; var Stop: Boolean) of object;

  TIntStrMap = class
  private
    FAllowDuplicates : Boolean;


    FCount : Int32;
    FSlots : Int32;
    FList  : TIntStrHashListSlotArray;

    procedure ClearList;
    procedure AddToSlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              const AValue: String); {$IFDEF UseInline}inline;{$ENDIF}
    procedure ExpandSlots(const ANewSlotCount: Int64);

    function  LocateItemIndexBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              out Item: PIntStrMapItem): Int32;
    function  LocateNextItemIndexBySlot(
              const ASlotIdx: Int32; const AItemIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              out Item: PIntStrMapItem): Int32;
    function  LocateItemBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              out AItem: PIntStrMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  LocateItem(
              const AKey: Int64;
              out AItem: PIntStrMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  RequireItem(const AKey: Int64): PIntStrMapItem;

    function  IterateGetNext(var AIterator: TIntStrMapIterator): PIntStrMapItem;


  public
    constructor Create(
                const AAllowDuplicates: Boolean = True);
    destructor Destroy; override;

    property  AllowDuplicates: Boolean read FAllowDuplicates;

    procedure Clear;
    property  Count: Int32 read FCount;

    procedure Add(const AKey: Int64; const AValue: String);

    function  KeyExists(const AKey: Int64): Boolean;
    function  KeyCount(const AKey: Int64): Int32;

    function  Get(const AKey: Int64): String;

    function  GetValue(const AKey: Int64; out AValue: String): Boolean;
    function  GetNextValue(const AKey: Int64; const AValue: String; out ANextValue: String): Boolean;

    function  RequireValue(const AKey: Int64): String;

    procedure SetValue(const AKey: Int64; const AValue: String);
    procedure SetOrAdd(const AKey: Int64; const AValue: String);

    property  Value[const AKey: Int64]: String read RequireValue write SetValue; default;

    function  RemoveIfExists(const AKey: Int64; out AValue: String): Boolean;
    procedure Remove(const AKey: Int64; out AValue: String);

    function  RemoveValueIfExists(const AKey: Int64; const AValue: String): Boolean;
    procedure RemoveValue(const AKey: Int64; const AValue: String);

    function  Iterate(out AIterator: TIntStrMapIterator): PIntStrMapItem;
    function  IteratorNext(var AIterator: TIntStrMapIterator): PIntStrMapItem;
    function  IteratorRemoveItem(var AIterator: TIntStrMapIterator): String;

    function  VisitAll(
              const ACallback: TIntStrMapVisitValueEvent;
              var AKey: Int64;
              var AValue: String): Boolean;
  end;



{ TStrPtrMap }

type
  EStrPtrMapError = class(Exception);

  TStrPtrMapItem = record
    Hash  : Word32;
    Key   : String;
    Value : Pointer;
  end;
  PStrPtrMapItem = ^TStrPtrMapItem;

  TStrPtrHashListSlot = record
    Count : Int32;
    List  : packed array of TStrPtrMapItem;
  end;
  PStrPtrHashListSlot = ^TStrPtrHashListSlot;
  TStrPtrHashListSlotArray = array of TStrPtrHashListSlot;

  TStrPtrMapIterator = record
    SlotIdx  : Int32;
    ItemIdx  : Int32;
    Finished : Boolean;
    Deleted  : Boolean;
  end;

  TStrPtrMapVisitValueEvent = procedure (const AKey: String; const AValue: Pointer; var Stop: Boolean) of object;

  TStrPtrMap = class
  private
    FCaseSensitive   : Boolean;
    FAllowDuplicates : Boolean;


    FCount : Int32;
    FSlots : Int32;
    FList  : TStrPtrHashListSlotArray;

    procedure ClearList;
    procedure AddToSlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: String;
              const AValue: Pointer); {$IFDEF UseInline}inline;{$ENDIF}
    procedure ExpandSlots(const ANewSlotCount: Int64);

    function  LocateItemIndexBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: String;
              out Item: PStrPtrMapItem): Int32;
    function  LocateNextItemIndexBySlot(
              const ASlotIdx: Int32; const AItemIdx: Int32;
              const AHash: Word32; const AKey: String;
              out Item: PStrPtrMapItem): Int32;
    function  LocateItemBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: String;
              out AItem: PStrPtrMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  LocateItem(
              const AKey: String;
              out AItem: PStrPtrMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  RequireItem(const AKey: String): PStrPtrMapItem;

    function  IterateGetNext(var AIterator: TStrPtrMapIterator): PStrPtrMapItem;


  public
    constructor Create(
                const ACaseSensitive: Boolean = True;
                const AAllowDuplicates: Boolean = True);
    destructor Destroy; override;

    property  CaseSensitive: Boolean read FCaseSensitive;
    property  AllowDuplicates: Boolean read FAllowDuplicates;

    procedure Clear;
    property  Count: Int32 read FCount;

    procedure Add(const AKey: String; const AValue: Pointer);

    function  KeyExists(const AKey: String): Boolean;
    function  KeyCount(const AKey: String): Int32;

    function  Get(const AKey: String): Pointer;

    function  GetValue(const AKey: String; out AValue: Pointer): Boolean;
    function  GetNextValue(const AKey: String; const AValue: Pointer; out ANextValue: Pointer): Boolean;

    function  RequireValue(const AKey: String): Pointer;

    procedure SetValue(const AKey: String; const AValue: Pointer);
    procedure SetOrAdd(const AKey: String; const AValue: Pointer);

    property  Value[const AKey: String]: Pointer read RequireValue write SetValue; default;

    function  RemoveIfExists(const AKey: String; out AValue: Pointer): Boolean;
    procedure Remove(const AKey: String; out AValue: Pointer);

    function  RemoveValueIfExists(const AKey: String; const AValue: Pointer): Boolean;
    procedure RemoveValue(const AKey: String; const AValue: Pointer);

    function  Iterate(out AIterator: TStrPtrMapIterator): PStrPtrMapItem;
    function  IteratorNext(var AIterator: TStrPtrMapIterator): PStrPtrMapItem;
    function  IteratorRemoveItem(var AIterator: TStrPtrMapIterator): Pointer;

    function  VisitAll(
              const ACallback: TStrPtrMapVisitValueEvent;
              var AKey: String;
              var AValue: Pointer): Boolean;
  end;



{ TIntPtrMap }

type
  EIntPtrMapError = class(Exception);

  TIntPtrMapItem = record
    Hash  : Word32;
    Key   : Int64;
    Value : Pointer;
  end;
  PIntPtrMapItem = ^TIntPtrMapItem;

  TIntPtrHashListSlot = record
    Count : Int32;
    List  : packed array of TIntPtrMapItem;
  end;
  PIntPtrHashListSlot = ^TIntPtrHashListSlot;
  TIntPtrHashListSlotArray = array of TIntPtrHashListSlot;

  TIntPtrMapIterator = record
    SlotIdx  : Int32;
    ItemIdx  : Int32;
    Finished : Boolean;
    Deleted  : Boolean;
  end;

  TIntPtrMapVisitValueEvent = procedure (const AKey: Int64; const AValue: Pointer; var Stop: Boolean) of object;

  TIntPtrMap = class
  private
    FAllowDuplicates : Boolean;


    FCount : Int32;
    FSlots : Int32;
    FList  : TIntPtrHashListSlotArray;

    procedure ClearList;
    procedure AddToSlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              const AValue: Pointer); {$IFDEF UseInline}inline;{$ENDIF}
    procedure ExpandSlots(const ANewSlotCount: Int64);

    function  LocateItemIndexBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              out Item: PIntPtrMapItem): Int32;
    function  LocateNextItemIndexBySlot(
              const ASlotIdx: Int32; const AItemIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              out Item: PIntPtrMapItem): Int32;
    function  LocateItemBySlot(
              const ASlotIdx: Int32;
              const AHash: Word32; const AKey: Int64;
              out AItem: PIntPtrMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  LocateItem(
              const AKey: Int64;
              out AItem: PIntPtrMapItem): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
    function  RequireItem(const AKey: Int64): PIntPtrMapItem;

    function  IterateGetNext(var AIterator: TIntPtrMapIterator): PIntPtrMapItem;


  public
    constructor Create(
                const AAllowDuplicates: Boolean = True);
    destructor Destroy; override;

    property  AllowDuplicates: Boolean read FAllowDuplicates;

    procedure Clear;
    property  Count: Int32 read FCount;

    procedure Add(const AKey: Int64; const AValue: Pointer);

    function  KeyExists(const AKey: Int64): Boolean;
    function  KeyCount(const AKey: Int64): Int32;

    function  Get(const AKey: Int64): Pointer;

    function  GetValue(const AKey: Int64; out AValue: Pointer): Boolean;
    function  GetNextValue(const AKey: Int64; const AValue: Pointer; out ANextValue: Pointer): Boolean;

    function  RequireValue(const AKey: Int64): Pointer;

    procedure SetValue(const AKey: Int64; const AValue: Pointer);
    procedure SetOrAdd(const AKey: Int64; const AValue: Pointer);

    property  Value[const AKey: Int64]: Pointer read RequireValue write SetValue; default;

    function  RemoveIfExists(const AKey: Int64; out AValue: Pointer): Boolean;
    procedure Remove(const AKey: Int64; out AValue: Pointer);

    function  RemoveValueIfExists(const AKey: Int64; const AValue: Pointer): Boolean;
    procedure RemoveValue(const AKey: Int64; const AValue: Pointer);

    function  Iterate(out AIterator: TIntPtrMapIterator): PIntPtrMapItem;
    function  IteratorNext(var AIterator: TIntPtrMapIterator): PIntPtrMapItem;
    function  IteratorRemoveItem(var AIterator: TIntPtrMapIterator): Pointer;

    function  VisitAll(
              const ACallback: TIntPtrMapVisitValueEvent;
              var AKey: Int64;
              var AValue: Pointer): Boolean;
  end;



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

function mapSameStringKey(const AStr1, AStr2: String; const ACaseSensitive: Boolean): Boolean; {$IFDEF UseInline}inline;{$ENDIF}
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



{ TStrObjMap helper functions }

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

procedure mapStrObjSlotRemoveItem(var ASlt: TStrObjHashListSlot; const AItmIdx: Int32); {$IFDEF UseInline}inline;{$ENDIF}
var
  Idx  : Int32;
  Cnt  : Int32;
  DstP : PStrObjMapItem;
  SrcP : PStrObjMapItem;
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
  Dec(Cnt);
  DstP := @ASlt.List[Cnt];
  DstP^.Key := '';
  DstP := @ASlt.List[Cnt];
  DstP^.Value := nil;
  ASlt.Count := Cnt;
end;

{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



{ TStrObjMap }

const
  StrObjHashList_InitialSlots        = 16;
  StrObjHashList_InitialItemsPerSlot = 8;
  StrObjHashList_TargetItemsPerSlot  = 8;
  StrObjHashList_SlotExpandFactor    = 4;
  StrObjHashList_MaxSlots            = $40000000;

constructor TStrObjMap.Create(
            const AItemOwner: Boolean;
            const ACaseSensitive: Boolean;
            const AAllowDuplicates: Boolean);
var
  Idx : Int32;
begin
  inherited Create;
  FItemOwner := AItemOwner;
  FCaseSensitive := ACaseSensitive;
  FAllowDuplicates := AAllowDuplicates;
  FSlots := StrObjHashList_InitialSlots;
  SetLength(FList, FSlots);
  for Idx := 0 to FSlots - 1 do
    FList[Idx].Count := 0;
end;

destructor TStrObjMap.Destroy;
begin
  ClearList;
  inherited Destroy;
end;

procedure TStrObjMap.FreeValue(const AKey: String; var AValue: TObject);
begin
  if Assigned(FOnFreeValue) then
    FOnFreeValue(AKey, AValue)
  else
    FreeAndNil(AValue);
end;

procedure TStrObjMap.ClearList;
var
  SltIdx : Int32;
  ItmIdx : Int32;
  Slt    : PStrObjHashListSlot;
  Itm    : PStrObjMapItem;
begin
  if FItemOwner then
    for SltIdx := Length(FList) - 1 downto 0 do
      begin
        Slt := @FList[SltIdx];
        for ItmIdx := Slt^.Count - 1 downto 0 do
          begin
            Itm := @Slt^.List[ItmIdx];
            FreeValue(Itm^.Key, Itm^.Value);
          end;
      end;
  SetLength(FList, 0);
end;

procedure TStrObjMap.Clear;
var
  SltIdx : Int32;
begin
  ClearList;
  FSlots := StrObjHashList_InitialSlots;
  SetLength(FList, FSlots);
  for SltIdx := 0 to FSlots - 1 do
    FList[SltIdx].Count := 0;
  FCount := 0;
end;

procedure TStrObjMap.AddToSlot(
          const ASlotIdx: Int32;
          const AHash: Word32; const AKey: String;
          const AValue: TObject);
var
  Slt : PStrObjHashListSlot;
  Cnt : Int32;
  ICn : Int32;
  Itm : PStrObjMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Cnt := Length(Slt^.List);
  ICn := Slt^.Count;
  if Cnt = 0 then
    begin
      Cnt := StrObjHashList_InitialItemsPerSlot;
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

procedure TStrObjMap.ExpandSlots(const ANewSlotCount: Int64);
var
  NewCount  : Int32;
  OldCount  : Int32;
  OldList   : TStrObjHashListSlotArray;
  NewList   : TStrObjHashListSlotArray;
  SltIdx    : Int32;
  ItmIdx    : Int32;
  Slt       : PStrObjHashListSlot;
  Itm       : PStrObjMapItem;
  Hsh       : Word32;
  NewSltIdx : Int32;
begin
  NewCount := ANewSlotCount;
  if NewCount > StrObjHashList_MaxSlots then
    NewCount := StrObjHashList_MaxSlots;
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

function TStrObjMap.LocateItemIndexBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: String;
         out Item: PStrObjMapItem): Int32;
var
  Slt : PStrObjHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PStrObjMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := Pointer(Slt^.List);
  ICn := Slt^.Count;
  for Idx := 0 to ICn - 1 do
    begin
      if Itm^.Hash = AHash then
        if mapSameStringKey(Itm^.Key, AKey, FCaseSensitive) then
          begin
            Item := Itm;
            Result := Idx;
            exit;
          end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TStrObjMap.LocateNextItemIndexBySlot(
         const ASlotIdx: Int32; const AItemIdx: Int32;
         const AHash: Word32; const AKey: String;
         out Item: PStrObjMapItem): Int32;
var
  Slt : PStrObjHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PStrObjMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := @Slt^.List[AItemIdx];
  ICn := Slt^.Count;
  for Idx := AItemIdx + 1 to ICn - 1 do
    begin
      if Itm^.Hash = AHash then
        if mapSameStringKey(Itm^.Key, AKey, FCaseSensitive) then
          begin
            Item := Itm;
            Result := Idx;
            exit;
          end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TStrObjMap.LocateItemBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: String;
         out AItem: PStrObjMapItem): Boolean;
begin
  Result := LocateItemIndexBySlot(ASlotIdx, AHash, AKey, AItem) >= 0;
end;

function TStrObjMap.LocateItem(const AKey: String; out AItem: PStrObjMapItem): Boolean;
var
  Hsh : Word32;
  Slt : Int32;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  Slt := Hsh mod Word32(FSlots);
  Result := LocateItemIndexBySlot(Slt, Hsh, AKey, AItem) >= 0;
end;

procedure TStrObjMap.Add(const AKey: String; const AValue: TObject);
var
  Hsh : Word32;
  Slt : Int32;
  Itm : PStrObjMapItem;
begin
  if FCount = FSlots * StrObjHashList_TargetItemsPerSlot then
    ExpandSlots(FSlots * StrObjHashList_SlotExpandFactor);
  Hsh := mapHashStr(AKey, FCaseSensitive);
  Slt := Hsh mod Word32(FSlots);
  if not FAllowDuplicates then
    if LocateItemBySlot(Slt, Hsh, AKey, Itm) then
      raise EStrObjMapError.CreateFmt(SErrDuplicateKey, [AKey]);
  AddToSlot(Slt, Hsh, AKey, AValue);
  Inc(FCount);
end;

function TStrObjMap.KeyExists(const AKey: String): Boolean;
var
  Itm : PStrObjMapItem;
begin
  Result := LocateItem(AKey, Itm);
end;

function TStrObjMap.KeyCount(const AKey: String): Int32;
var
  Hsh      : Word32;
  SltIdx   : Int32;
  ItmIdx   : Int32;
  Itm      : PStrObjMapItem;
  AllowDup : Boolean;
  Cnt      : Int32;
  Fin      : Boolean;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
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

function TStrObjMap.Get(const AKey: String): TObject;
var
  Itm : PStrObjMapItem;
begin
  if not LocateItem(AKey, Itm) then
    Result := nil
  else
    Result := Itm^.Value;
end;

function TStrObjMap.GetValue(const AKey: String; out AValue: TObject): Boolean;
var
  Itm : PStrObjMapItem;
begin
  if not LocateItem(AKey, Itm) then
    begin
      AValue := nil;
      Result := False;
    end
  else
    begin
      AValue := Itm^.Value;
      Result := True;
    end;
end;

function TStrObjMap.GetNextValue(
         const AKey: String; const AValue: TObject;
         out ANextValue: TObject): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrObjMapItem;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
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
  ANextValue := nil;
  Result := False;
end;

function TStrObjMap.RequireItem(const AKey: String): PStrObjMapItem;
var
  Itm : PStrObjMapItem;
begin
  if not LocateItem(AKey, Itm) then
    raise EStrObjMapError.CreateFmt(SErrKeyNotFound, [AKey]);
  Result := Itm;
end;

function TStrObjMap.RequireValue(const AKey: String): TObject;
begin
  Result := RequireItem(AKey)^.Value;
end;

procedure TStrObjMap.SetValue(const AKey: String; const AValue: TObject);
var
  Itm : PStrObjMapItem;
begin
  Itm := RequireItem(AKey);
  if FItemOwner then
    FreeValue(Itm^.Key, Itm^.Value);
  Itm^.Value := AValue;
end;

procedure TStrObjMap.SetOrAdd(const AKey: String; const AValue: TObject);
var
  Hsh    : Word32;
  Slt    : Int32;
  Itm    : PStrObjMapItem;
  ItmIdx : Int32;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  Slt := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(Slt, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      if FCount = FSlots * StrObjHashList_TargetItemsPerSlot then
        begin
          ExpandSlots(FSlots * StrObjHashList_SlotExpandFactor);
          Slt := Hsh mod Word32(FSlots);
        end;
      AddToSlot(Slt, Hsh, AKey, AValue);
      Inc(FCount);
    end
  else
    begin
      if FItemOwner then
        FreeValue(Itm^.Key, Itm^.Value);
      Itm^.Value := AValue;
    end;
end;

function TStrObjMap.DeleteFirstIfExists(const AKey: String): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrObjMapItem;
  Slt    : PStrObjHashListSlot;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
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
  mapStrObjSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  Result := True;
end;

procedure TStrObjMap.DeleteFirst(const AKey: String);
begin
  if not DeleteFirstIfExists(AKey) then
    raise EStrObjMapError.CreateFmt(SErrKeyNotFound, [AKey]);
end;

function TStrObjMap.DeleteIfExists(const AKey: String): Int32;
var
  Hsh      : Word32;
  SltIdx   : Int32;
  ItmIdx   : Int32;
  Itm      : PStrObjMapItem;
  Slt      : PStrObjHashListSlot;
  AllowDup : Boolean;
  Res      : Int32;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
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
    mapStrObjSlotRemoveItem(Slt^, ItmIdx);
    Dec(FCount);
    Inc(Res);
  until not AllowDup;
  Result := Res;
end;

procedure TStrObjMap.Delete(const AKey: String);
begin
  if DeleteIfExists(AKey) = 0 then
    raise EStrObjMapError.CreateFmt(SErrKeyNotFound, [AKey])
end;

function TStrObjMap.DeleteValueIfExists(const AKey: String; const AValue: TObject): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrObjMapItem;
  Slt    : PStrObjHashListSlot;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  SltIdx := Hsh mod Word32(FSlots);
  Slt := @FList[SltIdx];
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    if Itm^.Value = AValue then
      begin
        if FItemOwner then
          FreeValue(Itm^.Key, Itm^.Value);
        mapStrObjSlotRemoveItem(Slt^, ItmIdx);
        Dec(FCount);
        Result := True;
        exit;
      end
    else
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
  Result := False;
end;

procedure TStrObjMap.DeleteValue(const AKey: String; const AValue: TObject);
begin
  if not DeleteValueIfExists(AKey, AValue) then
    raise EStrObjMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TStrObjMap.RemoveIfExists(const AKey: String; out AValue: TObject): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrObjMapItem;
  Slt    : PStrObjHashListSlot;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      AValue := nil;
      Result := False;
      exit;
    end;
  AValue := Itm^.Value;
  Itm^.Value := nil;
  Slt := @FList[SltIdx];
  mapStrObjSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  Result := True;
end;

procedure TStrObjMap.Remove(const AKey: String; out AValue: TObject);
begin
  if not RemoveIfExists(AKey, AValue) then
    raise EStrObjMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TStrObjMap.RemoveValueIfExists(const AKey: String; const AValue: TObject): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrObjMapItem;
  Slt    : PStrObjHashListSlot;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    if Itm^.Value = AValue then
      begin
        Itm^.Value := nil;
        Slt := @FList[SltIdx];
        mapStrObjSlotRemoveItem(Slt^, ItmIdx);
        Dec(FCount);
        Result := True;
        exit;
      end
    else
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
  Result := False;
end;

procedure TStrObjMap.RemoveValue(const AKey: String; const AValue: TObject);
begin
  if not RemoveValueIfExists(AKey, AValue) then
    raise EStrObjMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TStrObjMap.IterateGetNext(var AIterator: TStrObjMapIterator): PStrObjMapItem;
var
  SltIdx : Int32;
  Slt    : PStrObjHashListSlot;
  DoNext : Boolean;
begin
  if AIterator.Finished then
    raise EStrObjMapError.Create(SErrNoCurrentItem);
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

function TStrObjMap.Iterate(out AIterator: TStrObjMapIterator): PStrObjMapItem;
begin
  AIterator.SlotIdx := 0;
  AIterator.ItemIdx := 0;
  AIterator.Finished := False;
  Result := IterateGetNext(AIterator);
end;

function TStrObjMap.IteratorNext(var AIterator: TStrObjMapIterator): PStrObjMapItem;
begin
  if AIterator.Finished then
    raise EStrObjMapError.Create(SErrNoCurrentItem);

  Inc(AIterator.ItemIdx);
  Result := IterateGetNext(AIterator);
end;

function TStrObjMap.IteratorRemoveItem(var AIterator: TStrObjMapIterator): TObject;
var
  SltIdx : Integer;
  ItmIdx : Int32;
  Itm    : PStrObjMapItem;
  Slt    : PStrObjHashListSlot;
begin
  if AIterator.Finished or AIterator.Deleted then
    raise EStrObjMapError.Create(SErrNoCurrentItem);

  SltIdx := AIterator.SlotIdx;
  ItmIdx := AIterator.ItemIdx;
  Slt := @FList[SltIdx];
  if ItmIdx >= Slt^.Count then
    begin
      Result := nil;
      exit;
    end;
  Itm := @Slt^.List[ItmIdx];
  Result := Itm^.Value;
  mapStrObjSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  AIterator.Deleted := True;
end;

function TStrObjMap.VisitAll(
         const ACallback: TStrObjMapVisitValueEvent;
         var AKey: String;
         var AValue: TObject): Boolean;
var
  Stop   : Boolean;
  SltIdx : Int32;
  ItmIdx : Int32;
  Slt    : PStrObjHashListSlot;
  Itm    : PStrObjMapItem;
begin
  if not Assigned(ACallback) then
    raise EStrObjMapError.Create(SErrNoCallback);

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
  AKey := '';
  AValue := nil;
  Result := False;
end;



{ TIntObjMap helper functions }

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

procedure mapIntObjSlotRemoveItem(var ASlt: TIntObjHashListSlot; const AItmIdx: Int32); {$IFDEF UseInline}inline;{$ENDIF}
var
  Idx  : Int32;
  Cnt  : Int32;
  DstP : PIntObjMapItem;
  SrcP : PIntObjMapItem;
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
  Dec(Cnt);
  DstP := @ASlt.List[Cnt];
  DstP^.Value := nil;
  ASlt.Count := Cnt;
end;

{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



{ TIntObjMap }

const
  IntObjHashList_InitialSlots        = 16;
  IntObjHashList_InitialItemsPerSlot = 8;
  IntObjHashList_TargetItemsPerSlot  = 8;
  IntObjHashList_SlotExpandFactor    = 4;
  IntObjHashList_MaxSlots            = $40000000;

constructor TIntObjMap.Create(
            const AItemOwner: Boolean;
            const AAllowDuplicates: Boolean);
var
  Idx : Int32;
begin
  inherited Create;
  FItemOwner := AItemOwner;
  FAllowDuplicates := AAllowDuplicates;
  FSlots := IntObjHashList_InitialSlots;
  SetLength(FList, FSlots);
  for Idx := 0 to FSlots - 1 do
    FList[Idx].Count := 0;
end;

destructor TIntObjMap.Destroy;
begin
  ClearList;
  inherited Destroy;
end;

procedure TIntObjMap.FreeValue(const AKey: Int64; var AValue: TObject);
begin
  if Assigned(FOnFreeValue) then
    FOnFreeValue(AKey, AValue)
  else
    FreeAndNil(AValue);
end;

procedure TIntObjMap.ClearList;
var
  SltIdx : Int32;
  ItmIdx : Int32;
  Slt    : PIntObjHashListSlot;
  Itm    : PIntObjMapItem;
begin
  if FItemOwner then
    for SltIdx := Length(FList) - 1 downto 0 do
      begin
        Slt := @FList[SltIdx];
        for ItmIdx := Slt^.Count - 1 downto 0 do
          begin
            Itm := @Slt^.List[ItmIdx];
            FreeValue(Itm^.Key, Itm^.Value);
          end;
      end;
  SetLength(FList, 0);
end;

procedure TIntObjMap.Clear;
var
  SltIdx : Int32;
begin
  ClearList;
  FSlots := IntObjHashList_InitialSlots;
  SetLength(FList, FSlots);
  for SltIdx := 0 to FSlots - 1 do
    FList[SltIdx].Count := 0;
  FCount := 0;
end;

procedure TIntObjMap.AddToSlot(
          const ASlotIdx: Int32;
          const AHash: Word32; const AKey: Int64;
          const AValue: TObject);
var
  Slt : PIntObjHashListSlot;
  Cnt : Int32;
  ICn : Int32;
  Itm : PIntObjMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Cnt := Length(Slt^.List);
  ICn := Slt^.Count;
  if Cnt = 0 then
    begin
      Cnt := IntObjHashList_InitialItemsPerSlot;
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

procedure TIntObjMap.ExpandSlots(const ANewSlotCount: Int64);
var
  NewCount  : Int32;
  OldCount  : Int32;
  OldList   : TIntObjHashListSlotArray;
  NewList   : TIntObjHashListSlotArray;
  SltIdx    : Int32;
  ItmIdx    : Int32;
  Slt       : PIntObjHashListSlot;
  Itm       : PIntObjMapItem;
  Hsh       : Word32;
  NewSltIdx : Int32;
begin
  NewCount := ANewSlotCount;
  if NewCount > IntObjHashList_MaxSlots then
    NewCount := IntObjHashList_MaxSlots;
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

function TIntObjMap.LocateItemIndexBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: Int64;
         out Item: PIntObjMapItem): Int32;
var
  Slt : PIntObjHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PIntObjMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := Pointer(Slt^.List);
  ICn := Slt^.Count;
  for Idx := 0 to ICn - 1 do
    begin
      if Itm^.Key = AKey then
        begin
          Item := Itm;
          Result := Idx;
          exit;
        end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TIntObjMap.LocateNextItemIndexBySlot(
         const ASlotIdx: Int32; const AItemIdx: Int32;
         const AHash: Word32; const AKey: Int64;
         out Item: PIntObjMapItem): Int32;
var
  Slt : PIntObjHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PIntObjMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := @Slt^.List[AItemIdx];
  ICn := Slt^.Count;
  for Idx := AItemIdx + 1 to ICn - 1 do
    begin
      if Itm^.Key = AKey then
        begin
          Item := Itm;
          Result := Idx;
          exit;
        end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TIntObjMap.LocateItemBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: Int64;
         out AItem: PIntObjMapItem): Boolean;
begin
  Result := LocateItemIndexBySlot(ASlotIdx, AHash, AKey, AItem) >= 0;
end;

function TIntObjMap.LocateItem(const AKey: Int64; out AItem: PIntObjMapItem): Boolean;
var
  Hsh : Word32;
  Slt : Int32;
begin
  Hsh := mapHashInt(AKey);
  Slt := Hsh mod Word32(FSlots);
  Result := LocateItemIndexBySlot(Slt, Hsh, AKey, AItem) >= 0;
end;

procedure TIntObjMap.Add(const AKey: Int64; const AValue: TObject);
var
  Hsh : Word32;
  Slt : Int32;
  Itm : PIntObjMapItem;
begin
  if FCount = FSlots * IntObjHashList_TargetItemsPerSlot then
    ExpandSlots(FSlots * IntObjHashList_SlotExpandFactor);
  Hsh := mapHashInt(AKey);
  Slt := Hsh mod Word32(FSlots);
  if not FAllowDuplicates then
    if LocateItemBySlot(Slt, Hsh, AKey, Itm) then
      raise EIntObjMapError.CreateFmt(SErrDuplicateKey, [AKey]);
  AddToSlot(Slt, Hsh, AKey, AValue);
  Inc(FCount);
end;

function TIntObjMap.KeyExists(const AKey: Int64): Boolean;
var
  Itm : PIntObjMapItem;
begin
  Result := LocateItem(AKey, Itm);
end;

function TIntObjMap.KeyCount(const AKey: Int64): Int32;
var
  Hsh      : Word32;
  SltIdx   : Int32;
  ItmIdx   : Int32;
  Itm      : PIntObjMapItem;
  AllowDup : Boolean;
  Cnt      : Int32;
  Fin      : Boolean;
begin
  Hsh := mapHashInt(AKey);
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

function TIntObjMap.Get(const AKey: Int64): TObject;
var
  Itm : PIntObjMapItem;
begin
  if not LocateItem(AKey, Itm) then
    Result := nil
  else
    Result := Itm^.Value;
end;

function TIntObjMap.GetValue(const AKey: Int64; out AValue: TObject): Boolean;
var
  Itm : PIntObjMapItem;
begin
  if not LocateItem(AKey, Itm) then
    begin
      AValue := nil;
      Result := False;
    end
  else
    begin
      AValue := Itm^.Value;
      Result := True;
    end;
end;

function TIntObjMap.GetNextValue(
         const AKey: Int64; const AValue: TObject;
         out ANextValue: TObject): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntObjMapItem;
begin
  Hsh := mapHashInt(AKey);
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
  ANextValue := nil;
  Result := False;
end;

function TIntObjMap.RequireItem(const AKey: Int64): PIntObjMapItem;
var
  Itm : PIntObjMapItem;
begin
  if not LocateItem(AKey, Itm) then
    raise EIntObjMapError.CreateFmt(SErrKeyNotFound, [AKey]);
  Result := Itm;
end;

function TIntObjMap.RequireValue(const AKey: Int64): TObject;
begin
  Result := RequireItem(AKey)^.Value;
end;

procedure TIntObjMap.SetValue(const AKey: Int64; const AValue: TObject);
var
  Itm : PIntObjMapItem;
begin
  Itm := RequireItem(AKey);
  if FItemOwner then
    FreeValue(Itm^.Key, Itm^.Value);
  Itm^.Value := AValue;
end;

procedure TIntObjMap.SetOrAdd(const AKey: Int64; const AValue: TObject);
var
  Hsh    : Word32;
  Slt    : Int32;
  Itm    : PIntObjMapItem;
  ItmIdx : Int32;
begin
  Hsh := mapHashInt(AKey);
  Slt := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(Slt, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      if FCount = FSlots * IntObjHashList_TargetItemsPerSlot then
        begin
          ExpandSlots(FSlots * IntObjHashList_SlotExpandFactor);
          Slt := Hsh mod Word32(FSlots);
        end;
      AddToSlot(Slt, Hsh, AKey, AValue);
      Inc(FCount);
    end
  else
    begin
      if FItemOwner then
        FreeValue(Itm^.Key, Itm^.Value);
      Itm^.Value := AValue;
    end;
end;

function TIntObjMap.DeleteFirstIfExists(const AKey: Int64): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntObjMapItem;
  Slt    : PIntObjHashListSlot;
begin
  Hsh := mapHashInt(AKey);
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
  mapIntObjSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  Result := True;
end;

procedure TIntObjMap.DeleteFirst(const AKey: Int64);
begin
  if not DeleteFirstIfExists(AKey) then
    raise EIntObjMapError.CreateFmt(SErrKeyNotFound, [AKey]);
end;

function TIntObjMap.DeleteIfExists(const AKey: Int64): Int32;
var
  Hsh      : Word32;
  SltIdx   : Int32;
  ItmIdx   : Int32;
  Itm      : PIntObjMapItem;
  Slt      : PIntObjHashListSlot;
  AllowDup : Boolean;
  Res      : Int32;
begin
  Hsh := mapHashInt(AKey);
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
    mapIntObjSlotRemoveItem(Slt^, ItmIdx);
    Dec(FCount);
    Inc(Res);
  until not AllowDup;
  Result := Res;
end;

procedure TIntObjMap.Delete(const AKey: Int64);
begin
  if DeleteIfExists(AKey) = 0 then
    raise EIntObjMapError.CreateFmt(SErrKeyNotFound, [AKey])
end;

function TIntObjMap.DeleteValueIfExists(const AKey: Int64; const AValue: TObject): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntObjMapItem;
  Slt    : PIntObjHashListSlot;
begin
  Hsh := mapHashInt(AKey);
  SltIdx := Hsh mod Word32(FSlots);
  Slt := @FList[SltIdx];
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    if Itm^.Value = AValue then
      begin
        if FItemOwner then
          FreeValue(Itm^.Key, Itm^.Value);
        mapIntObjSlotRemoveItem(Slt^, ItmIdx);
        Dec(FCount);
        Result := True;
        exit;
      end
    else
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
  Result := False;
end;

procedure TIntObjMap.DeleteValue(const AKey: Int64; const AValue: TObject);
begin
  if not DeleteValueIfExists(AKey, AValue) then
    raise EIntObjMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TIntObjMap.RemoveIfExists(const AKey: Int64; out AValue: TObject): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntObjMapItem;
  Slt    : PIntObjHashListSlot;
begin
  Hsh := mapHashInt(AKey);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      AValue := nil;
      Result := False;
      exit;
    end;
  AValue := Itm^.Value;
  Itm^.Value := nil;
  Slt := @FList[SltIdx];
  mapIntObjSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  Result := True;
end;

procedure TIntObjMap.Remove(const AKey: Int64; out AValue: TObject);
begin
  if not RemoveIfExists(AKey, AValue) then
    raise EIntObjMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TIntObjMap.RemoveValueIfExists(const AKey: Int64; const AValue: TObject): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntObjMapItem;
  Slt    : PIntObjHashListSlot;
begin
  Hsh := mapHashInt(AKey);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    if Itm^.Value = AValue then
      begin
        Itm^.Value := nil;
        Slt := @FList[SltIdx];
        mapIntObjSlotRemoveItem(Slt^, ItmIdx);
        Dec(FCount);
        Result := True;
        exit;
      end
    else
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
  Result := False;
end;

procedure TIntObjMap.RemoveValue(const AKey: Int64; const AValue: TObject);
begin
  if not RemoveValueIfExists(AKey, AValue) then
    raise EIntObjMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TIntObjMap.IterateGetNext(var AIterator: TIntObjMapIterator): PIntObjMapItem;
var
  SltIdx : Int32;
  Slt    : PIntObjHashListSlot;
  DoNext : Boolean;
begin
  if AIterator.Finished then
    raise EIntObjMapError.Create(SErrNoCurrentItem);
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

function TIntObjMap.Iterate(out AIterator: TIntObjMapIterator): PIntObjMapItem;
begin
  AIterator.SlotIdx := 0;
  AIterator.ItemIdx := 0;
  AIterator.Finished := False;
  Result := IterateGetNext(AIterator);
end;

function TIntObjMap.IteratorNext(var AIterator: TIntObjMapIterator): PIntObjMapItem;
begin
  if AIterator.Finished then
    raise EIntObjMapError.Create(SErrNoCurrentItem);

  Inc(AIterator.ItemIdx);
  Result := IterateGetNext(AIterator);
end;

function TIntObjMap.IteratorRemoveItem(var AIterator: TIntObjMapIterator): TObject;
var
  SltIdx : Integer;
  ItmIdx : Int32;
  Itm    : PIntObjMapItem;
  Slt    : PIntObjHashListSlot;
begin
  if AIterator.Finished or AIterator.Deleted then
    raise EIntObjMapError.Create(SErrNoCurrentItem);

  SltIdx := AIterator.SlotIdx;
  ItmIdx := AIterator.ItemIdx;
  Slt := @FList[SltIdx];
  if ItmIdx >= Slt^.Count then
    begin
      Result := nil;
      exit;
    end;
  Itm := @Slt^.List[ItmIdx];
  Result := Itm^.Value;
  mapIntObjSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  AIterator.Deleted := True;
end;

function TIntObjMap.VisitAll(
         const ACallback: TIntObjMapVisitValueEvent;
         var AKey: Int64;
         var AValue: TObject): Boolean;
var
  Stop   : Boolean;
  SltIdx : Int32;
  ItmIdx : Int32;
  Slt    : PIntObjHashListSlot;
  Itm    : PIntObjMapItem;
begin
  if not Assigned(ACallback) then
    raise EIntObjMapError.Create(SErrNoCallback);

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
  AKey := 0;
  AValue := nil;
  Result := False;
end;



{ TStrIntMap helper functions }

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

procedure mapStrIntSlotRemoveItem(var ASlt: TStrIntHashListSlot; const AItmIdx: Int32); {$IFDEF UseInline}inline;{$ENDIF}
var
  Idx  : Int32;
  Cnt  : Int32;
  DstP : PStrIntMapItem;
  SrcP : PStrIntMapItem;
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
  Dec(Cnt);
  DstP := @ASlt.List[Cnt];
  DstP^.Key := '';
  ASlt.Count := Cnt;
end;

{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



{ TStrIntMap }

const
  StrIntHashList_InitialSlots        = 16;
  StrIntHashList_InitialItemsPerSlot = 8;
  StrIntHashList_TargetItemsPerSlot  = 8;
  StrIntHashList_SlotExpandFactor    = 4;
  StrIntHashList_MaxSlots            = $40000000;

constructor TStrIntMap.Create(
            const ACaseSensitive: Boolean;
            const AAllowDuplicates: Boolean);
var
  Idx : Int32;
begin
  inherited Create;
  FCaseSensitive := ACaseSensitive;
  FAllowDuplicates := AAllowDuplicates;
  FSlots := StrIntHashList_InitialSlots;
  SetLength(FList, FSlots);
  for Idx := 0 to FSlots - 1 do
    FList[Idx].Count := 0;
end;

destructor TStrIntMap.Destroy;
begin
  ClearList;
  inherited Destroy;
end;

procedure TStrIntMap.ClearList;
begin
  SetLength(FList, 0);
end;

procedure TStrIntMap.Clear;
var
  SltIdx : Int32;
begin
  ClearList;
  FSlots := StrIntHashList_InitialSlots;
  SetLength(FList, FSlots);
  for SltIdx := 0 to FSlots - 1 do
    FList[SltIdx].Count := 0;
  FCount := 0;
end;

procedure TStrIntMap.AddToSlot(
          const ASlotIdx: Int32;
          const AHash: Word32; const AKey: String;
          const AValue: Int64);
var
  Slt : PStrIntHashListSlot;
  Cnt : Int32;
  ICn : Int32;
  Itm : PStrIntMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Cnt := Length(Slt^.List);
  ICn := Slt^.Count;
  if Cnt = 0 then
    begin
      Cnt := StrIntHashList_InitialItemsPerSlot;
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

procedure TStrIntMap.ExpandSlots(const ANewSlotCount: Int64);
var
  NewCount  : Int32;
  OldCount  : Int32;
  OldList   : TStrIntHashListSlotArray;
  NewList   : TStrIntHashListSlotArray;
  SltIdx    : Int32;
  ItmIdx    : Int32;
  Slt       : PStrIntHashListSlot;
  Itm       : PStrIntMapItem;
  Hsh       : Word32;
  NewSltIdx : Int32;
begin
  NewCount := ANewSlotCount;
  if NewCount > StrIntHashList_MaxSlots then
    NewCount := StrIntHashList_MaxSlots;
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

function TStrIntMap.LocateItemIndexBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: String;
         out Item: PStrIntMapItem): Int32;
var
  Slt : PStrIntHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PStrIntMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := Pointer(Slt^.List);
  ICn := Slt^.Count;
  for Idx := 0 to ICn - 1 do
    begin
      if Itm^.Hash = AHash then
        if mapSameStringKey(Itm^.Key, AKey, FCaseSensitive) then
          begin
            Item := Itm;
            Result := Idx;
            exit;
          end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TStrIntMap.LocateNextItemIndexBySlot(
         const ASlotIdx: Int32; const AItemIdx: Int32;
         const AHash: Word32; const AKey: String;
         out Item: PStrIntMapItem): Int32;
var
  Slt : PStrIntHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PStrIntMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := @Slt^.List[AItemIdx];
  ICn := Slt^.Count;
  for Idx := AItemIdx + 1 to ICn - 1 do
    begin
      if Itm^.Hash = AHash then
        if mapSameStringKey(Itm^.Key, AKey, FCaseSensitive) then
          begin
            Item := Itm;
            Result := Idx;
            exit;
          end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TStrIntMap.LocateItemBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: String;
         out AItem: PStrIntMapItem): Boolean;
begin
  Result := LocateItemIndexBySlot(ASlotIdx, AHash, AKey, AItem) >= 0;
end;

function TStrIntMap.LocateItem(const AKey: String; out AItem: PStrIntMapItem): Boolean;
var
  Hsh : Word32;
  Slt : Int32;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  Slt := Hsh mod Word32(FSlots);
  Result := LocateItemIndexBySlot(Slt, Hsh, AKey, AItem) >= 0;
end;

procedure TStrIntMap.Add(const AKey: String; const AValue: Int64);
var
  Hsh : Word32;
  Slt : Int32;
  Itm : PStrIntMapItem;
begin
  if FCount = FSlots * StrIntHashList_TargetItemsPerSlot then
    ExpandSlots(FSlots * StrIntHashList_SlotExpandFactor);
  Hsh := mapHashStr(AKey, FCaseSensitive);
  Slt := Hsh mod Word32(FSlots);
  if not FAllowDuplicates then
    if LocateItemBySlot(Slt, Hsh, AKey, Itm) then
      raise EStrIntMapError.CreateFmt(SErrDuplicateKey, [AKey]);
  AddToSlot(Slt, Hsh, AKey, AValue);
  Inc(FCount);
end;

function TStrIntMap.KeyExists(const AKey: String): Boolean;
var
  Itm : PStrIntMapItem;
begin
  Result := LocateItem(AKey, Itm);
end;

function TStrIntMap.KeyCount(const AKey: String): Int32;
var
  Hsh      : Word32;
  SltIdx   : Int32;
  ItmIdx   : Int32;
  Itm      : PStrIntMapItem;
  AllowDup : Boolean;
  Cnt      : Int32;
  Fin      : Boolean;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
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

function TStrIntMap.Get(const AKey: String): Int64;
var
  Itm : PStrIntMapItem;
begin
  if not LocateItem(AKey, Itm) then
    Result := 0
  else
    Result := Itm^.Value;
end;

function TStrIntMap.GetValue(const AKey: String; out AValue: Int64): Boolean;
var
  Itm : PStrIntMapItem;
begin
  if not LocateItem(AKey, Itm) then
    begin
      AValue := 0;
      Result := False;
    end
  else
    begin
      AValue := Itm^.Value;
      Result := True;
    end;
end;

function TStrIntMap.GetNextValue(
         const AKey: String; const AValue: Int64;
         out ANextValue: Int64): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrIntMapItem;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
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
  ANextValue := 0;
  Result := False;
end;

function TStrIntMap.RequireItem(const AKey: String): PStrIntMapItem;
var
  Itm : PStrIntMapItem;
begin
  if not LocateItem(AKey, Itm) then
    raise EStrIntMapError.CreateFmt(SErrKeyNotFound, [AKey]);
  Result := Itm;
end;

function TStrIntMap.RequireValue(const AKey: String): Int64;
begin
  Result := RequireItem(AKey)^.Value;
end;

procedure TStrIntMap.SetValue(const AKey: String; const AValue: Int64);
var
  Itm : PStrIntMapItem;
begin
  Itm := RequireItem(AKey);
  Itm^.Value := AValue;
end;

procedure TStrIntMap.SetOrAdd(const AKey: String; const AValue: Int64);
var
  Hsh    : Word32;
  Slt    : Int32;
  Itm    : PStrIntMapItem;
  ItmIdx : Int32;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  Slt := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(Slt, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      if FCount = FSlots * StrIntHashList_TargetItemsPerSlot then
        begin
          ExpandSlots(FSlots * StrIntHashList_SlotExpandFactor);
          Slt := Hsh mod Word32(FSlots);
        end;
      AddToSlot(Slt, Hsh, AKey, AValue);
      Inc(FCount);
    end
  else
    begin
      Itm^.Value := AValue;
    end;
end;

function TStrIntMap.RemoveIfExists(const AKey: String; out AValue: Int64): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrIntMapItem;
  Slt    : PStrIntHashListSlot;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      AValue := 0;
      Result := False;
      exit;
    end;
  AValue := Itm^.Value;
  Itm^.Value := 0;
  Slt := @FList[SltIdx];
  mapStrIntSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  Result := True;
end;

procedure TStrIntMap.Remove(const AKey: String; out AValue: Int64);
begin
  if not RemoveIfExists(AKey, AValue) then
    raise EStrIntMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TStrIntMap.RemoveValueIfExists(const AKey: String; const AValue: Int64): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrIntMapItem;
  Slt    : PStrIntHashListSlot;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    if Itm^.Value = AValue then
      begin
        Itm^.Value := 0;
        Slt := @FList[SltIdx];
        mapStrIntSlotRemoveItem(Slt^, ItmIdx);
        Dec(FCount);
        Result := True;
        exit;
      end
    else
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
  Result := False;
end;

procedure TStrIntMap.RemoveValue(const AKey: String; const AValue: Int64);
begin
  if not RemoveValueIfExists(AKey, AValue) then
    raise EStrIntMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TStrIntMap.IterateGetNext(var AIterator: TStrIntMapIterator): PStrIntMapItem;
var
  SltIdx : Int32;
  Slt    : PStrIntHashListSlot;
  DoNext : Boolean;
begin
  if AIterator.Finished then
    raise EStrIntMapError.Create(SErrNoCurrentItem);
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

function TStrIntMap.Iterate(out AIterator: TStrIntMapIterator): PStrIntMapItem;
begin
  AIterator.SlotIdx := 0;
  AIterator.ItemIdx := 0;
  AIterator.Finished := False;
  Result := IterateGetNext(AIterator);
end;

function TStrIntMap.IteratorNext(var AIterator: TStrIntMapIterator): PStrIntMapItem;
begin
  if AIterator.Finished then
    raise EStrIntMapError.Create(SErrNoCurrentItem);

  Inc(AIterator.ItemIdx);
  Result := IterateGetNext(AIterator);
end;

function TStrIntMap.IteratorRemoveItem(var AIterator: TStrIntMapIterator): Int64;
var
  SltIdx : Integer;
  ItmIdx : Int32;
  Itm    : PStrIntMapItem;
  Slt    : PStrIntHashListSlot;
begin
  if AIterator.Finished or AIterator.Deleted then
    raise EStrIntMapError.Create(SErrNoCurrentItem);

  SltIdx := AIterator.SlotIdx;
  ItmIdx := AIterator.ItemIdx;
  Slt := @FList[SltIdx];
  if ItmIdx >= Slt^.Count then
    begin
      Result := 0;
      exit;
    end;
  Itm := @Slt^.List[ItmIdx];
  Result := Itm^.Value;
  mapStrIntSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  AIterator.Deleted := True;
end;

function TStrIntMap.VisitAll(
         const ACallback: TStrIntMapVisitValueEvent;
         var AKey: String;
         var AValue: Int64): Boolean;
var
  Stop   : Boolean;
  SltIdx : Int32;
  ItmIdx : Int32;
  Slt    : PStrIntHashListSlot;
  Itm    : PStrIntMapItem;
begin
  if not Assigned(ACallback) then
    raise EStrIntMapError.Create(SErrNoCallback);

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
  AKey := '';
  AValue := 0;
  Result := False;
end;



{ TIntIntMap helper functions }

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

procedure mapIntIntSlotRemoveItem(var ASlt: TIntIntHashListSlot; const AItmIdx: Int32); {$IFDEF UseInline}inline;{$ENDIF}
var
  Idx  : Int32;
  Cnt  : Int32;
  DstP : PIntIntMapItem;
  SrcP : PIntIntMapItem;
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
  Dec(Cnt);
  ASlt.Count := Cnt;
end;

{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



{ TIntIntMap }

const
  IntIntHashList_InitialSlots        = 16;
  IntIntHashList_InitialItemsPerSlot = 8;
  IntIntHashList_TargetItemsPerSlot  = 8;
  IntIntHashList_SlotExpandFactor    = 4;
  IntIntHashList_MaxSlots            = $40000000;

constructor TIntIntMap.Create(
            const AAllowDuplicates: Boolean);
var
  Idx : Int32;
begin
  inherited Create;
  FAllowDuplicates := AAllowDuplicates;
  FSlots := IntIntHashList_InitialSlots;
  SetLength(FList, FSlots);
  for Idx := 0 to FSlots - 1 do
    FList[Idx].Count := 0;
end;

destructor TIntIntMap.Destroy;
begin
  ClearList;
  inherited Destroy;
end;

procedure TIntIntMap.ClearList;
begin
  SetLength(FList, 0);
end;

procedure TIntIntMap.Clear;
var
  SltIdx : Int32;
begin
  ClearList;
  FSlots := IntIntHashList_InitialSlots;
  SetLength(FList, FSlots);
  for SltIdx := 0 to FSlots - 1 do
    FList[SltIdx].Count := 0;
  FCount := 0;
end;

procedure TIntIntMap.AddToSlot(
          const ASlotIdx: Int32;
          const AHash: Word32; const AKey: Int64;
          const AValue: Int64);
var
  Slt : PIntIntHashListSlot;
  Cnt : Int32;
  ICn : Int32;
  Itm : PIntIntMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Cnt := Length(Slt^.List);
  ICn := Slt^.Count;
  if Cnt = 0 then
    begin
      Cnt := IntIntHashList_InitialItemsPerSlot;
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

procedure TIntIntMap.ExpandSlots(const ANewSlotCount: Int64);
var
  NewCount  : Int32;
  OldCount  : Int32;
  OldList   : TIntIntHashListSlotArray;
  NewList   : TIntIntHashListSlotArray;
  SltIdx    : Int32;
  ItmIdx    : Int32;
  Slt       : PIntIntHashListSlot;
  Itm       : PIntIntMapItem;
  Hsh       : Word32;
  NewSltIdx : Int32;
begin
  NewCount := ANewSlotCount;
  if NewCount > IntIntHashList_MaxSlots then
    NewCount := IntIntHashList_MaxSlots;
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

function TIntIntMap.LocateItemIndexBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: Int64;
         out Item: PIntIntMapItem): Int32;
var
  Slt : PIntIntHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PIntIntMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := Pointer(Slt^.List);
  ICn := Slt^.Count;
  for Idx := 0 to ICn - 1 do
    begin
      if Itm^.Key = AKey then
        begin
          Item := Itm;
          Result := Idx;
          exit;
        end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TIntIntMap.LocateNextItemIndexBySlot(
         const ASlotIdx: Int32; const AItemIdx: Int32;
         const AHash: Word32; const AKey: Int64;
         out Item: PIntIntMapItem): Int32;
var
  Slt : PIntIntHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PIntIntMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := @Slt^.List[AItemIdx];
  ICn := Slt^.Count;
  for Idx := AItemIdx + 1 to ICn - 1 do
    begin
      if Itm^.Key = AKey then
        begin
          Item := Itm;
          Result := Idx;
          exit;
        end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TIntIntMap.LocateItemBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: Int64;
         out AItem: PIntIntMapItem): Boolean;
begin
  Result := LocateItemIndexBySlot(ASlotIdx, AHash, AKey, AItem) >= 0;
end;

function TIntIntMap.LocateItem(const AKey: Int64; out AItem: PIntIntMapItem): Boolean;
var
  Hsh : Word32;
  Slt : Int32;
begin
  Hsh := mapHashInt(AKey);
  Slt := Hsh mod Word32(FSlots);
  Result := LocateItemIndexBySlot(Slt, Hsh, AKey, AItem) >= 0;
end;

procedure TIntIntMap.Add(const AKey: Int64; const AValue: Int64);
var
  Hsh : Word32;
  Slt : Int32;
  Itm : PIntIntMapItem;
begin
  if FCount = FSlots * IntIntHashList_TargetItemsPerSlot then
    ExpandSlots(FSlots * IntIntHashList_SlotExpandFactor);
  Hsh := mapHashInt(AKey);
  Slt := Hsh mod Word32(FSlots);
  if not FAllowDuplicates then
    if LocateItemBySlot(Slt, Hsh, AKey, Itm) then
      raise EIntIntMapError.CreateFmt(SErrDuplicateKey, [AKey]);
  AddToSlot(Slt, Hsh, AKey, AValue);
  Inc(FCount);
end;

function TIntIntMap.KeyExists(const AKey: Int64): Boolean;
var
  Itm : PIntIntMapItem;
begin
  Result := LocateItem(AKey, Itm);
end;

function TIntIntMap.KeyCount(const AKey: Int64): Int32;
var
  Hsh      : Word32;
  SltIdx   : Int32;
  ItmIdx   : Int32;
  Itm      : PIntIntMapItem;
  AllowDup : Boolean;
  Cnt      : Int32;
  Fin      : Boolean;
begin
  Hsh := mapHashInt(AKey);
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

function TIntIntMap.Get(const AKey: Int64): Int64;
var
  Itm : PIntIntMapItem;
begin
  if not LocateItem(AKey, Itm) then
    Result := 0
  else
    Result := Itm^.Value;
end;

function TIntIntMap.GetValue(const AKey: Int64; out AValue: Int64): Boolean;
var
  Itm : PIntIntMapItem;
begin
  if not LocateItem(AKey, Itm) then
    begin
      AValue := 0;
      Result := False;
    end
  else
    begin
      AValue := Itm^.Value;
      Result := True;
    end;
end;

function TIntIntMap.GetNextValue(
         const AKey: Int64; const AValue: Int64;
         out ANextValue: Int64): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntIntMapItem;
begin
  Hsh := mapHashInt(AKey);
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
  ANextValue := 0;
  Result := False;
end;

function TIntIntMap.RequireItem(const AKey: Int64): PIntIntMapItem;
var
  Itm : PIntIntMapItem;
begin
  if not LocateItem(AKey, Itm) then
    raise EIntIntMapError.CreateFmt(SErrKeyNotFound, [AKey]);
  Result := Itm;
end;

function TIntIntMap.RequireValue(const AKey: Int64): Int64;
begin
  Result := RequireItem(AKey)^.Value;
end;

procedure TIntIntMap.SetValue(const AKey: Int64; const AValue: Int64);
var
  Itm : PIntIntMapItem;
begin
  Itm := RequireItem(AKey);
  Itm^.Value := AValue;
end;

procedure TIntIntMap.SetOrAdd(const AKey: Int64; const AValue: Int64);
var
  Hsh    : Word32;
  Slt    : Int32;
  Itm    : PIntIntMapItem;
  ItmIdx : Int32;
begin
  Hsh := mapHashInt(AKey);
  Slt := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(Slt, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      if FCount = FSlots * IntIntHashList_TargetItemsPerSlot then
        begin
          ExpandSlots(FSlots * IntIntHashList_SlotExpandFactor);
          Slt := Hsh mod Word32(FSlots);
        end;
      AddToSlot(Slt, Hsh, AKey, AValue);
      Inc(FCount);
    end
  else
    begin
      Itm^.Value := AValue;
    end;
end;

function TIntIntMap.RemoveIfExists(const AKey: Int64; out AValue: Int64): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntIntMapItem;
  Slt    : PIntIntHashListSlot;
begin
  Hsh := mapHashInt(AKey);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      AValue := 0;
      Result := False;
      exit;
    end;
  AValue := Itm^.Value;
  Itm^.Value := 0;
  Slt := @FList[SltIdx];
  mapIntIntSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  Result := True;
end;

procedure TIntIntMap.Remove(const AKey: Int64; out AValue: Int64);
begin
  if not RemoveIfExists(AKey, AValue) then
    raise EIntIntMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TIntIntMap.RemoveValueIfExists(const AKey: Int64; const AValue: Int64): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntIntMapItem;
  Slt    : PIntIntHashListSlot;
begin
  Hsh := mapHashInt(AKey);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    if Itm^.Value = AValue then
      begin
        Itm^.Value := 0;
        Slt := @FList[SltIdx];
        mapIntIntSlotRemoveItem(Slt^, ItmIdx);
        Dec(FCount);
        Result := True;
        exit;
      end
    else
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
  Result := False;
end;

procedure TIntIntMap.RemoveValue(const AKey: Int64; const AValue: Int64);
begin
  if not RemoveValueIfExists(AKey, AValue) then
    raise EIntIntMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TIntIntMap.IterateGetNext(var AIterator: TIntIntMapIterator): PIntIntMapItem;
var
  SltIdx : Int32;
  Slt    : PIntIntHashListSlot;
  DoNext : Boolean;
begin
  if AIterator.Finished then
    raise EIntIntMapError.Create(SErrNoCurrentItem);
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

function TIntIntMap.Iterate(out AIterator: TIntIntMapIterator): PIntIntMapItem;
begin
  AIterator.SlotIdx := 0;
  AIterator.ItemIdx := 0;
  AIterator.Finished := False;
  Result := IterateGetNext(AIterator);
end;

function TIntIntMap.IteratorNext(var AIterator: TIntIntMapIterator): PIntIntMapItem;
begin
  if AIterator.Finished then
    raise EIntIntMapError.Create(SErrNoCurrentItem);

  Inc(AIterator.ItemIdx);
  Result := IterateGetNext(AIterator);
end;

function TIntIntMap.IteratorRemoveItem(var AIterator: TIntIntMapIterator): Int64;
var
  SltIdx : Integer;
  ItmIdx : Int32;
  Itm    : PIntIntMapItem;
  Slt    : PIntIntHashListSlot;
begin
  if AIterator.Finished or AIterator.Deleted then
    raise EIntIntMapError.Create(SErrNoCurrentItem);

  SltIdx := AIterator.SlotIdx;
  ItmIdx := AIterator.ItemIdx;
  Slt := @FList[SltIdx];
  if ItmIdx >= Slt^.Count then
    begin
      Result := 0;
      exit;
    end;
  Itm := @Slt^.List[ItmIdx];
  Result := Itm^.Value;
  mapIntIntSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  AIterator.Deleted := True;
end;

function TIntIntMap.VisitAll(
         const ACallback: TIntIntMapVisitValueEvent;
         var AKey: Int64;
         var AValue: Int64): Boolean;
var
  Stop   : Boolean;
  SltIdx : Int32;
  ItmIdx : Int32;
  Slt    : PIntIntHashListSlot;
  Itm    : PIntIntMapItem;
begin
  if not Assigned(ACallback) then
    raise EIntIntMapError.Create(SErrNoCallback);

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
  AKey := 0;
  AValue := 0;
  Result := False;
end;



{ TStrStrMap helper functions }

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

procedure mapStrStrSlotRemoveItem(var ASlt: TStrStrHashListSlot; const AItmIdx: Int32); {$IFDEF UseInline}inline;{$ENDIF}
var
  Idx  : Int32;
  Cnt  : Int32;
  DstP : PStrStrMapItem;
  SrcP : PStrStrMapItem;
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
  Dec(Cnt);
  DstP := @ASlt.List[Cnt];
  DstP^.Key := '';
  DstP := @ASlt.List[Cnt];
  DstP^.Value := '';
  ASlt.Count := Cnt;
end;

{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



{ TStrStrMap }

const
  StrStrHashList_InitialSlots        = 16;
  StrStrHashList_InitialItemsPerSlot = 8;
  StrStrHashList_TargetItemsPerSlot  = 8;
  StrStrHashList_SlotExpandFactor    = 4;
  StrStrHashList_MaxSlots            = $40000000;

constructor TStrStrMap.Create(
            const ACaseSensitive: Boolean;
            const AAllowDuplicates: Boolean);
var
  Idx : Int32;
begin
  inherited Create;
  FCaseSensitive := ACaseSensitive;
  FAllowDuplicates := AAllowDuplicates;
  FSlots := StrStrHashList_InitialSlots;
  SetLength(FList, FSlots);
  for Idx := 0 to FSlots - 1 do
    FList[Idx].Count := 0;
end;

destructor TStrStrMap.Destroy;
begin
  ClearList;
  inherited Destroy;
end;

procedure TStrStrMap.ClearList;
begin
  SetLength(FList, 0);
end;

procedure TStrStrMap.Clear;
var
  SltIdx : Int32;
begin
  ClearList;
  FSlots := StrStrHashList_InitialSlots;
  SetLength(FList, FSlots);
  for SltIdx := 0 to FSlots - 1 do
    FList[SltIdx].Count := 0;
  FCount := 0;
end;

procedure TStrStrMap.AddToSlot(
          const ASlotIdx: Int32;
          const AHash: Word32; const AKey: String;
          const AValue: String);
var
  Slt : PStrStrHashListSlot;
  Cnt : Int32;
  ICn : Int32;
  Itm : PStrStrMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Cnt := Length(Slt^.List);
  ICn := Slt^.Count;
  if Cnt = 0 then
    begin
      Cnt := StrStrHashList_InitialItemsPerSlot;
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

procedure TStrStrMap.ExpandSlots(const ANewSlotCount: Int64);
var
  NewCount  : Int32;
  OldCount  : Int32;
  OldList   : TStrStrHashListSlotArray;
  NewList   : TStrStrHashListSlotArray;
  SltIdx    : Int32;
  ItmIdx    : Int32;
  Slt       : PStrStrHashListSlot;
  Itm       : PStrStrMapItem;
  Hsh       : Word32;
  NewSltIdx : Int32;
begin
  NewCount := ANewSlotCount;
  if NewCount > StrStrHashList_MaxSlots then
    NewCount := StrStrHashList_MaxSlots;
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

function TStrStrMap.LocateItemIndexBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: String;
         out Item: PStrStrMapItem): Int32;
var
  Slt : PStrStrHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PStrStrMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := Pointer(Slt^.List);
  ICn := Slt^.Count;
  for Idx := 0 to ICn - 1 do
    begin
      if Itm^.Hash = AHash then
        if mapSameStringKey(Itm^.Key, AKey, FCaseSensitive) then
          begin
            Item := Itm;
            Result := Idx;
            exit;
          end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TStrStrMap.LocateNextItemIndexBySlot(
         const ASlotIdx: Int32; const AItemIdx: Int32;
         const AHash: Word32; const AKey: String;
         out Item: PStrStrMapItem): Int32;
var
  Slt : PStrStrHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PStrStrMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := @Slt^.List[AItemIdx];
  ICn := Slt^.Count;
  for Idx := AItemIdx + 1 to ICn - 1 do
    begin
      if Itm^.Hash = AHash then
        if mapSameStringKey(Itm^.Key, AKey, FCaseSensitive) then
          begin
            Item := Itm;
            Result := Idx;
            exit;
          end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TStrStrMap.LocateItemBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: String;
         out AItem: PStrStrMapItem): Boolean;
begin
  Result := LocateItemIndexBySlot(ASlotIdx, AHash, AKey, AItem) >= 0;
end;

function TStrStrMap.LocateItem(const AKey: String; out AItem: PStrStrMapItem): Boolean;
var
  Hsh : Word32;
  Slt : Int32;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  Slt := Hsh mod Word32(FSlots);
  Result := LocateItemIndexBySlot(Slt, Hsh, AKey, AItem) >= 0;
end;

procedure TStrStrMap.Add(const AKey: String; const AValue: String);
var
  Hsh : Word32;
  Slt : Int32;
  Itm : PStrStrMapItem;
begin
  if FCount = FSlots * StrStrHashList_TargetItemsPerSlot then
    ExpandSlots(FSlots * StrStrHashList_SlotExpandFactor);
  Hsh := mapHashStr(AKey, FCaseSensitive);
  Slt := Hsh mod Word32(FSlots);
  if not FAllowDuplicates then
    if LocateItemBySlot(Slt, Hsh, AKey, Itm) then
      raise EStrStrMapError.CreateFmt(SErrDuplicateKey, [AKey]);
  AddToSlot(Slt, Hsh, AKey, AValue);
  Inc(FCount);
end;

function TStrStrMap.KeyExists(const AKey: String): Boolean;
var
  Itm : PStrStrMapItem;
begin
  Result := LocateItem(AKey, Itm);
end;

function TStrStrMap.KeyCount(const AKey: String): Int32;
var
  Hsh      : Word32;
  SltIdx   : Int32;
  ItmIdx   : Int32;
  Itm      : PStrStrMapItem;
  AllowDup : Boolean;
  Cnt      : Int32;
  Fin      : Boolean;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
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

function TStrStrMap.Get(const AKey: String): String;
var
  Itm : PStrStrMapItem;
begin
  if not LocateItem(AKey, Itm) then
    Result := ''
  else
    Result := Itm^.Value;
end;

function TStrStrMap.GetValue(const AKey: String; out AValue: String): Boolean;
var
  Itm : PStrStrMapItem;
begin
  if not LocateItem(AKey, Itm) then
    begin
      AValue := '';
      Result := False;
    end
  else
    begin
      AValue := Itm^.Value;
      Result := True;
    end;
end;

function TStrStrMap.GetNextValue(
         const AKey: String; const AValue: String;
         out ANextValue: String): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrStrMapItem;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
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
  ANextValue := '';
  Result := False;
end;

function TStrStrMap.RequireItem(const AKey: String): PStrStrMapItem;
var
  Itm : PStrStrMapItem;
begin
  if not LocateItem(AKey, Itm) then
    raise EStrStrMapError.CreateFmt(SErrKeyNotFound, [AKey]);
  Result := Itm;
end;

function TStrStrMap.RequireValue(const AKey: String): String;
begin
  Result := RequireItem(AKey)^.Value;
end;

procedure TStrStrMap.SetValue(const AKey: String; const AValue: String);
var
  Itm : PStrStrMapItem;
begin
  Itm := RequireItem(AKey);
  Itm^.Value := AValue;
end;

procedure TStrStrMap.SetOrAdd(const AKey: String; const AValue: String);
var
  Hsh    : Word32;
  Slt    : Int32;
  Itm    : PStrStrMapItem;
  ItmIdx : Int32;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  Slt := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(Slt, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      if FCount = FSlots * StrStrHashList_TargetItemsPerSlot then
        begin
          ExpandSlots(FSlots * StrStrHashList_SlotExpandFactor);
          Slt := Hsh mod Word32(FSlots);
        end;
      AddToSlot(Slt, Hsh, AKey, AValue);
      Inc(FCount);
    end
  else
    begin
      Itm^.Value := AValue;
    end;
end;

function TStrStrMap.RemoveIfExists(const AKey: String; out AValue: String): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrStrMapItem;
  Slt    : PStrStrHashListSlot;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      AValue := '';
      Result := False;
      exit;
    end;
  AValue := Itm^.Value;
  Itm^.Value := '';
  Slt := @FList[SltIdx];
  mapStrStrSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  Result := True;
end;

procedure TStrStrMap.Remove(const AKey: String; out AValue: String);
begin
  if not RemoveIfExists(AKey, AValue) then
    raise EStrStrMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TStrStrMap.RemoveValueIfExists(const AKey: String; const AValue: String): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrStrMapItem;
  Slt    : PStrStrHashListSlot;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    if Itm^.Value = AValue then
      begin
        Itm^.Value := '';
        Slt := @FList[SltIdx];
        mapStrStrSlotRemoveItem(Slt^, ItmIdx);
        Dec(FCount);
        Result := True;
        exit;
      end
    else
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
  Result := False;
end;

procedure TStrStrMap.RemoveValue(const AKey: String; const AValue: String);
begin
  if not RemoveValueIfExists(AKey, AValue) then
    raise EStrStrMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TStrStrMap.IterateGetNext(var AIterator: TStrStrMapIterator): PStrStrMapItem;
var
  SltIdx : Int32;
  Slt    : PStrStrHashListSlot;
  DoNext : Boolean;
begin
  if AIterator.Finished then
    raise EStrStrMapError.Create(SErrNoCurrentItem);
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

function TStrStrMap.Iterate(out AIterator: TStrStrMapIterator): PStrStrMapItem;
begin
  AIterator.SlotIdx := 0;
  AIterator.ItemIdx := 0;
  AIterator.Finished := False;
  Result := IterateGetNext(AIterator);
end;

function TStrStrMap.IteratorNext(var AIterator: TStrStrMapIterator): PStrStrMapItem;
begin
  if AIterator.Finished then
    raise EStrStrMapError.Create(SErrNoCurrentItem);

  Inc(AIterator.ItemIdx);
  Result := IterateGetNext(AIterator);
end;

function TStrStrMap.IteratorRemoveItem(var AIterator: TStrStrMapIterator): String;
var
  SltIdx : Integer;
  ItmIdx : Int32;
  Itm    : PStrStrMapItem;
  Slt    : PStrStrHashListSlot;
begin
  if AIterator.Finished or AIterator.Deleted then
    raise EStrStrMapError.Create(SErrNoCurrentItem);

  SltIdx := AIterator.SlotIdx;
  ItmIdx := AIterator.ItemIdx;
  Slt := @FList[SltIdx];
  if ItmIdx >= Slt^.Count then
    begin
      Result := '';
      exit;
    end;
  Itm := @Slt^.List[ItmIdx];
  Result := Itm^.Value;
  mapStrStrSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  AIterator.Deleted := True;
end;

function TStrStrMap.VisitAll(
         const ACallback: TStrStrMapVisitValueEvent;
         var AKey: String;
         var AValue: String): Boolean;
var
  Stop   : Boolean;
  SltIdx : Int32;
  ItmIdx : Int32;
  Slt    : PStrStrHashListSlot;
  Itm    : PStrStrMapItem;
begin
  if not Assigned(ACallback) then
    raise EStrStrMapError.Create(SErrNoCallback);

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
  AKey := '';
  AValue := '';
  Result := False;
end;



{ TIntStrMap helper functions }

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

procedure mapIntStrSlotRemoveItem(var ASlt: TIntStrHashListSlot; const AItmIdx: Int32); {$IFDEF UseInline}inline;{$ENDIF}
var
  Idx  : Int32;
  Cnt  : Int32;
  DstP : PIntStrMapItem;
  SrcP : PIntStrMapItem;
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
  Dec(Cnt);
  DstP := @ASlt.List[Cnt];
  DstP^.Value := '';
  ASlt.Count := Cnt;
end;

{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



{ TIntStrMap }

const
  IntStrHashList_InitialSlots        = 16;
  IntStrHashList_InitialItemsPerSlot = 8;
  IntStrHashList_TargetItemsPerSlot  = 8;
  IntStrHashList_SlotExpandFactor    = 4;
  IntStrHashList_MaxSlots            = $40000000;

constructor TIntStrMap.Create(
            const AAllowDuplicates: Boolean);
var
  Idx : Int32;
begin
  inherited Create;
  FAllowDuplicates := AAllowDuplicates;
  FSlots := IntStrHashList_InitialSlots;
  SetLength(FList, FSlots);
  for Idx := 0 to FSlots - 1 do
    FList[Idx].Count := 0;
end;

destructor TIntStrMap.Destroy;
begin
  ClearList;
  inherited Destroy;
end;

procedure TIntStrMap.ClearList;
begin
  SetLength(FList, 0);
end;

procedure TIntStrMap.Clear;
var
  SltIdx : Int32;
begin
  ClearList;
  FSlots := IntStrHashList_InitialSlots;
  SetLength(FList, FSlots);
  for SltIdx := 0 to FSlots - 1 do
    FList[SltIdx].Count := 0;
  FCount := 0;
end;

procedure TIntStrMap.AddToSlot(
          const ASlotIdx: Int32;
          const AHash: Word32; const AKey: Int64;
          const AValue: String);
var
  Slt : PIntStrHashListSlot;
  Cnt : Int32;
  ICn : Int32;
  Itm : PIntStrMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Cnt := Length(Slt^.List);
  ICn := Slt^.Count;
  if Cnt = 0 then
    begin
      Cnt := IntStrHashList_InitialItemsPerSlot;
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

procedure TIntStrMap.ExpandSlots(const ANewSlotCount: Int64);
var
  NewCount  : Int32;
  OldCount  : Int32;
  OldList   : TIntStrHashListSlotArray;
  NewList   : TIntStrHashListSlotArray;
  SltIdx    : Int32;
  ItmIdx    : Int32;
  Slt       : PIntStrHashListSlot;
  Itm       : PIntStrMapItem;
  Hsh       : Word32;
  NewSltIdx : Int32;
begin
  NewCount := ANewSlotCount;
  if NewCount > IntStrHashList_MaxSlots then
    NewCount := IntStrHashList_MaxSlots;
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

function TIntStrMap.LocateItemIndexBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: Int64;
         out Item: PIntStrMapItem): Int32;
var
  Slt : PIntStrHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PIntStrMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := Pointer(Slt^.List);
  ICn := Slt^.Count;
  for Idx := 0 to ICn - 1 do
    begin
      if Itm^.Key = AKey then
        begin
          Item := Itm;
          Result := Idx;
          exit;
        end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TIntStrMap.LocateNextItemIndexBySlot(
         const ASlotIdx: Int32; const AItemIdx: Int32;
         const AHash: Word32; const AKey: Int64;
         out Item: PIntStrMapItem): Int32;
var
  Slt : PIntStrHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PIntStrMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := @Slt^.List[AItemIdx];
  ICn := Slt^.Count;
  for Idx := AItemIdx + 1 to ICn - 1 do
    begin
      if Itm^.Key = AKey then
        begin
          Item := Itm;
          Result := Idx;
          exit;
        end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TIntStrMap.LocateItemBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: Int64;
         out AItem: PIntStrMapItem): Boolean;
begin
  Result := LocateItemIndexBySlot(ASlotIdx, AHash, AKey, AItem) >= 0;
end;

function TIntStrMap.LocateItem(const AKey: Int64; out AItem: PIntStrMapItem): Boolean;
var
  Hsh : Word32;
  Slt : Int32;
begin
  Hsh := mapHashInt(AKey);
  Slt := Hsh mod Word32(FSlots);
  Result := LocateItemIndexBySlot(Slt, Hsh, AKey, AItem) >= 0;
end;

procedure TIntStrMap.Add(const AKey: Int64; const AValue: String);
var
  Hsh : Word32;
  Slt : Int32;
  Itm : PIntStrMapItem;
begin
  if FCount = FSlots * IntStrHashList_TargetItemsPerSlot then
    ExpandSlots(FSlots * IntStrHashList_SlotExpandFactor);
  Hsh := mapHashInt(AKey);
  Slt := Hsh mod Word32(FSlots);
  if not FAllowDuplicates then
    if LocateItemBySlot(Slt, Hsh, AKey, Itm) then
      raise EIntStrMapError.CreateFmt(SErrDuplicateKey, [AKey]);
  AddToSlot(Slt, Hsh, AKey, AValue);
  Inc(FCount);
end;

function TIntStrMap.KeyExists(const AKey: Int64): Boolean;
var
  Itm : PIntStrMapItem;
begin
  Result := LocateItem(AKey, Itm);
end;

function TIntStrMap.KeyCount(const AKey: Int64): Int32;
var
  Hsh      : Word32;
  SltIdx   : Int32;
  ItmIdx   : Int32;
  Itm      : PIntStrMapItem;
  AllowDup : Boolean;
  Cnt      : Int32;
  Fin      : Boolean;
begin
  Hsh := mapHashInt(AKey);
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

function TIntStrMap.Get(const AKey: Int64): String;
var
  Itm : PIntStrMapItem;
begin
  if not LocateItem(AKey, Itm) then
    Result := ''
  else
    Result := Itm^.Value;
end;

function TIntStrMap.GetValue(const AKey: Int64; out AValue: String): Boolean;
var
  Itm : PIntStrMapItem;
begin
  if not LocateItem(AKey, Itm) then
    begin
      AValue := '';
      Result := False;
    end
  else
    begin
      AValue := Itm^.Value;
      Result := True;
    end;
end;

function TIntStrMap.GetNextValue(
         const AKey: Int64; const AValue: String;
         out ANextValue: String): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntStrMapItem;
begin
  Hsh := mapHashInt(AKey);
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
  ANextValue := '';
  Result := False;
end;

function TIntStrMap.RequireItem(const AKey: Int64): PIntStrMapItem;
var
  Itm : PIntStrMapItem;
begin
  if not LocateItem(AKey, Itm) then
    raise EIntStrMapError.CreateFmt(SErrKeyNotFound, [AKey]);
  Result := Itm;
end;

function TIntStrMap.RequireValue(const AKey: Int64): String;
begin
  Result := RequireItem(AKey)^.Value;
end;

procedure TIntStrMap.SetValue(const AKey: Int64; const AValue: String);
var
  Itm : PIntStrMapItem;
begin
  Itm := RequireItem(AKey);
  Itm^.Value := AValue;
end;

procedure TIntStrMap.SetOrAdd(const AKey: Int64; const AValue: String);
var
  Hsh    : Word32;
  Slt    : Int32;
  Itm    : PIntStrMapItem;
  ItmIdx : Int32;
begin
  Hsh := mapHashInt(AKey);
  Slt := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(Slt, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      if FCount = FSlots * IntStrHashList_TargetItemsPerSlot then
        begin
          ExpandSlots(FSlots * IntStrHashList_SlotExpandFactor);
          Slt := Hsh mod Word32(FSlots);
        end;
      AddToSlot(Slt, Hsh, AKey, AValue);
      Inc(FCount);
    end
  else
    begin
      Itm^.Value := AValue;
    end;
end;

function TIntStrMap.RemoveIfExists(const AKey: Int64; out AValue: String): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntStrMapItem;
  Slt    : PIntStrHashListSlot;
begin
  Hsh := mapHashInt(AKey);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      AValue := '';
      Result := False;
      exit;
    end;
  AValue := Itm^.Value;
  Itm^.Value := '';
  Slt := @FList[SltIdx];
  mapIntStrSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  Result := True;
end;

procedure TIntStrMap.Remove(const AKey: Int64; out AValue: String);
begin
  if not RemoveIfExists(AKey, AValue) then
    raise EIntStrMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TIntStrMap.RemoveValueIfExists(const AKey: Int64; const AValue: String): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntStrMapItem;
  Slt    : PIntStrHashListSlot;
begin
  Hsh := mapHashInt(AKey);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    if Itm^.Value = AValue then
      begin
        Itm^.Value := '';
        Slt := @FList[SltIdx];
        mapIntStrSlotRemoveItem(Slt^, ItmIdx);
        Dec(FCount);
        Result := True;
        exit;
      end
    else
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
  Result := False;
end;

procedure TIntStrMap.RemoveValue(const AKey: Int64; const AValue: String);
begin
  if not RemoveValueIfExists(AKey, AValue) then
    raise EIntStrMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TIntStrMap.IterateGetNext(var AIterator: TIntStrMapIterator): PIntStrMapItem;
var
  SltIdx : Int32;
  Slt    : PIntStrHashListSlot;
  DoNext : Boolean;
begin
  if AIterator.Finished then
    raise EIntStrMapError.Create(SErrNoCurrentItem);
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

function TIntStrMap.Iterate(out AIterator: TIntStrMapIterator): PIntStrMapItem;
begin
  AIterator.SlotIdx := 0;
  AIterator.ItemIdx := 0;
  AIterator.Finished := False;
  Result := IterateGetNext(AIterator);
end;

function TIntStrMap.IteratorNext(var AIterator: TIntStrMapIterator): PIntStrMapItem;
begin
  if AIterator.Finished then
    raise EIntStrMapError.Create(SErrNoCurrentItem);

  Inc(AIterator.ItemIdx);
  Result := IterateGetNext(AIterator);
end;

function TIntStrMap.IteratorRemoveItem(var AIterator: TIntStrMapIterator): String;
var
  SltIdx : Integer;
  ItmIdx : Int32;
  Itm    : PIntStrMapItem;
  Slt    : PIntStrHashListSlot;
begin
  if AIterator.Finished or AIterator.Deleted then
    raise EIntStrMapError.Create(SErrNoCurrentItem);

  SltIdx := AIterator.SlotIdx;
  ItmIdx := AIterator.ItemIdx;
  Slt := @FList[SltIdx];
  if ItmIdx >= Slt^.Count then
    begin
      Result := '';
      exit;
    end;
  Itm := @Slt^.List[ItmIdx];
  Result := Itm^.Value;
  mapIntStrSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  AIterator.Deleted := True;
end;

function TIntStrMap.VisitAll(
         const ACallback: TIntStrMapVisitValueEvent;
         var AKey: Int64;
         var AValue: String): Boolean;
var
  Stop   : Boolean;
  SltIdx : Int32;
  ItmIdx : Int32;
  Slt    : PIntStrHashListSlot;
  Itm    : PIntStrMapItem;
begin
  if not Assigned(ACallback) then
    raise EIntStrMapError.Create(SErrNoCallback);

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
  AKey := 0;
  AValue := '';
  Result := False;
end;



{ TStrPtrMap helper functions }

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

procedure mapStrPtrSlotRemoveItem(var ASlt: TStrPtrHashListSlot; const AItmIdx: Int32); {$IFDEF UseInline}inline;{$ENDIF}
var
  Idx  : Int32;
  Cnt  : Int32;
  DstP : PStrPtrMapItem;
  SrcP : PStrPtrMapItem;
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
  Dec(Cnt);
  DstP := @ASlt.List[Cnt];
  DstP^.Key := '';
  ASlt.Count := Cnt;
end;

{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



{ TStrPtrMap }

const
  StrPtrHashList_InitialSlots        = 16;
  StrPtrHashList_InitialItemsPerSlot = 8;
  StrPtrHashList_TargetItemsPerSlot  = 8;
  StrPtrHashList_SlotExpandFactor    = 4;
  StrPtrHashList_MaxSlots            = $40000000;

constructor TStrPtrMap.Create(
            const ACaseSensitive: Boolean;
            const AAllowDuplicates: Boolean);
var
  Idx : Int32;
begin
  inherited Create;
  FCaseSensitive := ACaseSensitive;
  FAllowDuplicates := AAllowDuplicates;
  FSlots := StrPtrHashList_InitialSlots;
  SetLength(FList, FSlots);
  for Idx := 0 to FSlots - 1 do
    FList[Idx].Count := 0;
end;

destructor TStrPtrMap.Destroy;
begin
  ClearList;
  inherited Destroy;
end;

procedure TStrPtrMap.ClearList;
begin
  SetLength(FList, 0);
end;

procedure TStrPtrMap.Clear;
var
  SltIdx : Int32;
begin
  ClearList;
  FSlots := StrPtrHashList_InitialSlots;
  SetLength(FList, FSlots);
  for SltIdx := 0 to FSlots - 1 do
    FList[SltIdx].Count := 0;
  FCount := 0;
end;

procedure TStrPtrMap.AddToSlot(
          const ASlotIdx: Int32;
          const AHash: Word32; const AKey: String;
          const AValue: Pointer);
var
  Slt : PStrPtrHashListSlot;
  Cnt : Int32;
  ICn : Int32;
  Itm : PStrPtrMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Cnt := Length(Slt^.List);
  ICn := Slt^.Count;
  if Cnt = 0 then
    begin
      Cnt := StrPtrHashList_InitialItemsPerSlot;
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

procedure TStrPtrMap.ExpandSlots(const ANewSlotCount: Int64);
var
  NewCount  : Int32;
  OldCount  : Int32;
  OldList   : TStrPtrHashListSlotArray;
  NewList   : TStrPtrHashListSlotArray;
  SltIdx    : Int32;
  ItmIdx    : Int32;
  Slt       : PStrPtrHashListSlot;
  Itm       : PStrPtrMapItem;
  Hsh       : Word32;
  NewSltIdx : Int32;
begin
  NewCount := ANewSlotCount;
  if NewCount > StrPtrHashList_MaxSlots then
    NewCount := StrPtrHashList_MaxSlots;
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

function TStrPtrMap.LocateItemIndexBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: String;
         out Item: PStrPtrMapItem): Int32;
var
  Slt : PStrPtrHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PStrPtrMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := Pointer(Slt^.List);
  ICn := Slt^.Count;
  for Idx := 0 to ICn - 1 do
    begin
      if Itm^.Hash = AHash then
        if mapSameStringKey(Itm^.Key, AKey, FCaseSensitive) then
          begin
            Item := Itm;
            Result := Idx;
            exit;
          end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TStrPtrMap.LocateNextItemIndexBySlot(
         const ASlotIdx: Int32; const AItemIdx: Int32;
         const AHash: Word32; const AKey: String;
         out Item: PStrPtrMapItem): Int32;
var
  Slt : PStrPtrHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PStrPtrMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := @Slt^.List[AItemIdx];
  ICn := Slt^.Count;
  for Idx := AItemIdx + 1 to ICn - 1 do
    begin
      if Itm^.Hash = AHash then
        if mapSameStringKey(Itm^.Key, AKey, FCaseSensitive) then
          begin
            Item := Itm;
            Result := Idx;
            exit;
          end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TStrPtrMap.LocateItemBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: String;
         out AItem: PStrPtrMapItem): Boolean;
begin
  Result := LocateItemIndexBySlot(ASlotIdx, AHash, AKey, AItem) >= 0;
end;

function TStrPtrMap.LocateItem(const AKey: String; out AItem: PStrPtrMapItem): Boolean;
var
  Hsh : Word32;
  Slt : Int32;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  Slt := Hsh mod Word32(FSlots);
  Result := LocateItemIndexBySlot(Slt, Hsh, AKey, AItem) >= 0;
end;

procedure TStrPtrMap.Add(const AKey: String; const AValue: Pointer);
var
  Hsh : Word32;
  Slt : Int32;
  Itm : PStrPtrMapItem;
begin
  if FCount = FSlots * StrPtrHashList_TargetItemsPerSlot then
    ExpandSlots(FSlots * StrPtrHashList_SlotExpandFactor);
  Hsh := mapHashStr(AKey, FCaseSensitive);
  Slt := Hsh mod Word32(FSlots);
  if not FAllowDuplicates then
    if LocateItemBySlot(Slt, Hsh, AKey, Itm) then
      raise EStrPtrMapError.CreateFmt(SErrDuplicateKey, [AKey]);
  AddToSlot(Slt, Hsh, AKey, AValue);
  Inc(FCount);
end;

function TStrPtrMap.KeyExists(const AKey: String): Boolean;
var
  Itm : PStrPtrMapItem;
begin
  Result := LocateItem(AKey, Itm);
end;

function TStrPtrMap.KeyCount(const AKey: String): Int32;
var
  Hsh      : Word32;
  SltIdx   : Int32;
  ItmIdx   : Int32;
  Itm      : PStrPtrMapItem;
  AllowDup : Boolean;
  Cnt      : Int32;
  Fin      : Boolean;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
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

function TStrPtrMap.Get(const AKey: String): Pointer;
var
  Itm : PStrPtrMapItem;
begin
  if not LocateItem(AKey, Itm) then
    Result := nil
  else
    Result := Itm^.Value;
end;

function TStrPtrMap.GetValue(const AKey: String; out AValue: Pointer): Boolean;
var
  Itm : PStrPtrMapItem;
begin
  if not LocateItem(AKey, Itm) then
    begin
      AValue := nil;
      Result := False;
    end
  else
    begin
      AValue := Itm^.Value;
      Result := True;
    end;
end;

function TStrPtrMap.GetNextValue(
         const AKey: String; const AValue: Pointer;
         out ANextValue: Pointer): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrPtrMapItem;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
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
  ANextValue := nil;
  Result := False;
end;

function TStrPtrMap.RequireItem(const AKey: String): PStrPtrMapItem;
var
  Itm : PStrPtrMapItem;
begin
  if not LocateItem(AKey, Itm) then
    raise EStrPtrMapError.CreateFmt(SErrKeyNotFound, [AKey]);
  Result := Itm;
end;

function TStrPtrMap.RequireValue(const AKey: String): Pointer;
begin
  Result := RequireItem(AKey)^.Value;
end;

procedure TStrPtrMap.SetValue(const AKey: String; const AValue: Pointer);
var
  Itm : PStrPtrMapItem;
begin
  Itm := RequireItem(AKey);
  Itm^.Value := AValue;
end;

procedure TStrPtrMap.SetOrAdd(const AKey: String; const AValue: Pointer);
var
  Hsh    : Word32;
  Slt    : Int32;
  Itm    : PStrPtrMapItem;
  ItmIdx : Int32;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  Slt := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(Slt, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      if FCount = FSlots * StrPtrHashList_TargetItemsPerSlot then
        begin
          ExpandSlots(FSlots * StrPtrHashList_SlotExpandFactor);
          Slt := Hsh mod Word32(FSlots);
        end;
      AddToSlot(Slt, Hsh, AKey, AValue);
      Inc(FCount);
    end
  else
    begin
      Itm^.Value := AValue;
    end;
end;

function TStrPtrMap.RemoveIfExists(const AKey: String; out AValue: Pointer): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrPtrMapItem;
  Slt    : PStrPtrHashListSlot;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      AValue := nil;
      Result := False;
      exit;
    end;
  AValue := Itm^.Value;
  Itm^.Value := nil;
  Slt := @FList[SltIdx];
  mapStrPtrSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  Result := True;
end;

procedure TStrPtrMap.Remove(const AKey: String; out AValue: Pointer);
begin
  if not RemoveIfExists(AKey, AValue) then
    raise EStrPtrMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TStrPtrMap.RemoveValueIfExists(const AKey: String; const AValue: Pointer): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PStrPtrMapItem;
  Slt    : PStrPtrHashListSlot;
begin
  Hsh := mapHashStr(AKey, FCaseSensitive);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    if Itm^.Value = AValue then
      begin
        Itm^.Value := nil;
        Slt := @FList[SltIdx];
        mapStrPtrSlotRemoveItem(Slt^, ItmIdx);
        Dec(FCount);
        Result := True;
        exit;
      end
    else
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
  Result := False;
end;

procedure TStrPtrMap.RemoveValue(const AKey: String; const AValue: Pointer);
begin
  if not RemoveValueIfExists(AKey, AValue) then
    raise EStrPtrMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TStrPtrMap.IterateGetNext(var AIterator: TStrPtrMapIterator): PStrPtrMapItem;
var
  SltIdx : Int32;
  Slt    : PStrPtrHashListSlot;
  DoNext : Boolean;
begin
  if AIterator.Finished then
    raise EStrPtrMapError.Create(SErrNoCurrentItem);
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

function TStrPtrMap.Iterate(out AIterator: TStrPtrMapIterator): PStrPtrMapItem;
begin
  AIterator.SlotIdx := 0;
  AIterator.ItemIdx := 0;
  AIterator.Finished := False;
  Result := IterateGetNext(AIterator);
end;

function TStrPtrMap.IteratorNext(var AIterator: TStrPtrMapIterator): PStrPtrMapItem;
begin
  if AIterator.Finished then
    raise EStrPtrMapError.Create(SErrNoCurrentItem);

  Inc(AIterator.ItemIdx);
  Result := IterateGetNext(AIterator);
end;

function TStrPtrMap.IteratorRemoveItem(var AIterator: TStrPtrMapIterator): Pointer;
var
  SltIdx : Integer;
  ItmIdx : Int32;
  Itm    : PStrPtrMapItem;
  Slt    : PStrPtrHashListSlot;
begin
  if AIterator.Finished or AIterator.Deleted then
    raise EStrPtrMapError.Create(SErrNoCurrentItem);

  SltIdx := AIterator.SlotIdx;
  ItmIdx := AIterator.ItemIdx;
  Slt := @FList[SltIdx];
  if ItmIdx >= Slt^.Count then
    begin
      Result := nil;
      exit;
    end;
  Itm := @Slt^.List[ItmIdx];
  Result := Itm^.Value;
  mapStrPtrSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  AIterator.Deleted := True;
end;

function TStrPtrMap.VisitAll(
         const ACallback: TStrPtrMapVisitValueEvent;
         var AKey: String;
         var AValue: Pointer): Boolean;
var
  Stop   : Boolean;
  SltIdx : Int32;
  ItmIdx : Int32;
  Slt    : PStrPtrHashListSlot;
  Itm    : PStrPtrMapItem;
begin
  if not Assigned(ACallback) then
    raise EStrPtrMapError.Create(SErrNoCallback);

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
  AKey := '';
  AValue := nil;
  Result := False;
end;



{ TIntPtrMap helper functions }

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

procedure mapIntPtrSlotRemoveItem(var ASlt: TIntPtrHashListSlot; const AItmIdx: Int32); {$IFDEF UseInline}inline;{$ENDIF}
var
  Idx  : Int32;
  Cnt  : Int32;
  DstP : PIntPtrMapItem;
  SrcP : PIntPtrMapItem;
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
  Dec(Cnt);
  ASlt.Count := Cnt;
end;

{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



{ TIntPtrMap }

const
  IntPtrHashList_InitialSlots        = 16;
  IntPtrHashList_InitialItemsPerSlot = 8;
  IntPtrHashList_TargetItemsPerSlot  = 8;
  IntPtrHashList_SlotExpandFactor    = 4;
  IntPtrHashList_MaxSlots            = $40000000;

constructor TIntPtrMap.Create(
            const AAllowDuplicates: Boolean);
var
  Idx : Int32;
begin
  inherited Create;
  FAllowDuplicates := AAllowDuplicates;
  FSlots := IntPtrHashList_InitialSlots;
  SetLength(FList, FSlots);
  for Idx := 0 to FSlots - 1 do
    FList[Idx].Count := 0;
end;

destructor TIntPtrMap.Destroy;
begin
  ClearList;
  inherited Destroy;
end;

procedure TIntPtrMap.ClearList;
begin
  SetLength(FList, 0);
end;

procedure TIntPtrMap.Clear;
var
  SltIdx : Int32;
begin
  ClearList;
  FSlots := IntPtrHashList_InitialSlots;
  SetLength(FList, FSlots);
  for SltIdx := 0 to FSlots - 1 do
    FList[SltIdx].Count := 0;
  FCount := 0;
end;

procedure TIntPtrMap.AddToSlot(
          const ASlotIdx: Int32;
          const AHash: Word32; const AKey: Int64;
          const AValue: Pointer);
var
  Slt : PIntPtrHashListSlot;
  Cnt : Int32;
  ICn : Int32;
  Itm : PIntPtrMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Cnt := Length(Slt^.List);
  ICn := Slt^.Count;
  if Cnt = 0 then
    begin
      Cnt := IntPtrHashList_InitialItemsPerSlot;
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

procedure TIntPtrMap.ExpandSlots(const ANewSlotCount: Int64);
var
  NewCount  : Int32;
  OldCount  : Int32;
  OldList   : TIntPtrHashListSlotArray;
  NewList   : TIntPtrHashListSlotArray;
  SltIdx    : Int32;
  ItmIdx    : Int32;
  Slt       : PIntPtrHashListSlot;
  Itm       : PIntPtrMapItem;
  Hsh       : Word32;
  NewSltIdx : Int32;
begin
  NewCount := ANewSlotCount;
  if NewCount > IntPtrHashList_MaxSlots then
    NewCount := IntPtrHashList_MaxSlots;
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

function TIntPtrMap.LocateItemIndexBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: Int64;
         out Item: PIntPtrMapItem): Int32;
var
  Slt : PIntPtrHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PIntPtrMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := Pointer(Slt^.List);
  ICn := Slt^.Count;
  for Idx := 0 to ICn - 1 do
    begin
      if Itm^.Key = AKey then
        begin
          Item := Itm;
          Result := Idx;
          exit;
        end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TIntPtrMap.LocateNextItemIndexBySlot(
         const ASlotIdx: Int32; const AItemIdx: Int32;
         const AHash: Word32; const AKey: Int64;
         out Item: PIntPtrMapItem): Int32;
var
  Slt : PIntPtrHashListSlot;
  ICn : Int32;
  Idx : Int32;
  Itm : PIntPtrMapItem;
begin
  Assert(ASlotIdx >= 0);
  Assert(ASlotIdx < FSlots);

  Slt := @FList[ASlotIdx];
  Itm := @Slt^.List[AItemIdx];
  ICn := Slt^.Count;
  for Idx := AItemIdx + 1 to ICn - 1 do
    begin
      if Itm^.Key = AKey then
        begin
          Item := Itm;
          Result := Idx;
          exit;
        end;
      Inc(Itm);
    end;
  Item := nil;
  Result := -1;
end;

function TIntPtrMap.LocateItemBySlot(
         const ASlotIdx: Int32;
         const AHash: Word32; const AKey: Int64;
         out AItem: PIntPtrMapItem): Boolean;
begin
  Result := LocateItemIndexBySlot(ASlotIdx, AHash, AKey, AItem) >= 0;
end;

function TIntPtrMap.LocateItem(const AKey: Int64; out AItem: PIntPtrMapItem): Boolean;
var
  Hsh : Word32;
  Slt : Int32;
begin
  Hsh := mapHashInt(AKey);
  Slt := Hsh mod Word32(FSlots);
  Result := LocateItemIndexBySlot(Slt, Hsh, AKey, AItem) >= 0;
end;

procedure TIntPtrMap.Add(const AKey: Int64; const AValue: Pointer);
var
  Hsh : Word32;
  Slt : Int32;
  Itm : PIntPtrMapItem;
begin
  if FCount = FSlots * IntPtrHashList_TargetItemsPerSlot then
    ExpandSlots(FSlots * IntPtrHashList_SlotExpandFactor);
  Hsh := mapHashInt(AKey);
  Slt := Hsh mod Word32(FSlots);
  if not FAllowDuplicates then
    if LocateItemBySlot(Slt, Hsh, AKey, Itm) then
      raise EIntPtrMapError.CreateFmt(SErrDuplicateKey, [AKey]);
  AddToSlot(Slt, Hsh, AKey, AValue);
  Inc(FCount);
end;

function TIntPtrMap.KeyExists(const AKey: Int64): Boolean;
var
  Itm : PIntPtrMapItem;
begin
  Result := LocateItem(AKey, Itm);
end;

function TIntPtrMap.KeyCount(const AKey: Int64): Int32;
var
  Hsh      : Word32;
  SltIdx   : Int32;
  ItmIdx   : Int32;
  Itm      : PIntPtrMapItem;
  AllowDup : Boolean;
  Cnt      : Int32;
  Fin      : Boolean;
begin
  Hsh := mapHashInt(AKey);
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

function TIntPtrMap.Get(const AKey: Int64): Pointer;
var
  Itm : PIntPtrMapItem;
begin
  if not LocateItem(AKey, Itm) then
    Result := nil
  else
    Result := Itm^.Value;
end;

function TIntPtrMap.GetValue(const AKey: Int64; out AValue: Pointer): Boolean;
var
  Itm : PIntPtrMapItem;
begin
  if not LocateItem(AKey, Itm) then
    begin
      AValue := nil;
      Result := False;
    end
  else
    begin
      AValue := Itm^.Value;
      Result := True;
    end;
end;

function TIntPtrMap.GetNextValue(
         const AKey: Int64; const AValue: Pointer;
         out ANextValue: Pointer): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntPtrMapItem;
begin
  Hsh := mapHashInt(AKey);
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
  ANextValue := nil;
  Result := False;
end;

function TIntPtrMap.RequireItem(const AKey: Int64): PIntPtrMapItem;
var
  Itm : PIntPtrMapItem;
begin
  if not LocateItem(AKey, Itm) then
    raise EIntPtrMapError.CreateFmt(SErrKeyNotFound, [AKey]);
  Result := Itm;
end;

function TIntPtrMap.RequireValue(const AKey: Int64): Pointer;
begin
  Result := RequireItem(AKey)^.Value;
end;

procedure TIntPtrMap.SetValue(const AKey: Int64; const AValue: Pointer);
var
  Itm : PIntPtrMapItem;
begin
  Itm := RequireItem(AKey);
  Itm^.Value := AValue;
end;

procedure TIntPtrMap.SetOrAdd(const AKey: Int64; const AValue: Pointer);
var
  Hsh    : Word32;
  Slt    : Int32;
  Itm    : PIntPtrMapItem;
  ItmIdx : Int32;
begin
  Hsh := mapHashInt(AKey);
  Slt := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(Slt, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      if FCount = FSlots * IntPtrHashList_TargetItemsPerSlot then
        begin
          ExpandSlots(FSlots * IntPtrHashList_SlotExpandFactor);
          Slt := Hsh mod Word32(FSlots);
        end;
      AddToSlot(Slt, Hsh, AKey, AValue);
      Inc(FCount);
    end
  else
    begin
      Itm^.Value := AValue;
    end;
end;

function TIntPtrMap.RemoveIfExists(const AKey: Int64; out AValue: Pointer): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntPtrMapItem;
  Slt    : PIntPtrHashListSlot;
begin
  Hsh := mapHashInt(AKey);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  if ItmIdx < 0 then
    begin
      AValue := nil;
      Result := False;
      exit;
    end;
  AValue := Itm^.Value;
  Itm^.Value := nil;
  Slt := @FList[SltIdx];
  mapIntPtrSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  Result := True;
end;

procedure TIntPtrMap.Remove(const AKey: Int64; out AValue: Pointer);
begin
  if not RemoveIfExists(AKey, AValue) then
    raise EIntPtrMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TIntPtrMap.RemoveValueIfExists(const AKey: Int64; const AValue: Pointer): Boolean;
var
  Hsh    : Word32;
  SltIdx : Int32;
  ItmIdx : Int32;
  Itm    : PIntPtrMapItem;
  Slt    : PIntPtrHashListSlot;
begin
  Hsh := mapHashInt(AKey);
  SltIdx := Hsh mod Word32(FSlots);
  ItmIdx := LocateItemIndexBySlot(SltIdx, Hsh, AKey, Itm);
  while ItmIdx >= 0 do
    if Itm^.Value = AValue then
      begin
        Itm^.Value := nil;
        Slt := @FList[SltIdx];
        mapIntPtrSlotRemoveItem(Slt^, ItmIdx);
        Dec(FCount);
        Result := True;
        exit;
      end
    else
      ItmIdx := LocateNextItemIndexBySlot(SltIdx, ItmIdx, Hsh, AKey, Itm);
  Result := False;
end;

procedure TIntPtrMap.RemoveValue(const AKey: Int64; const AValue: Pointer);
begin
  if not RemoveValueIfExists(AKey, AValue) then
    raise EIntPtrMapError.CreateFmt(SErrKeyValueNotFound, [AKey])
end;

function TIntPtrMap.IterateGetNext(var AIterator: TIntPtrMapIterator): PIntPtrMapItem;
var
  SltIdx : Int32;
  Slt    : PIntPtrHashListSlot;
  DoNext : Boolean;
begin
  if AIterator.Finished then
    raise EIntPtrMapError.Create(SErrNoCurrentItem);
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

function TIntPtrMap.Iterate(out AIterator: TIntPtrMapIterator): PIntPtrMapItem;
begin
  AIterator.SlotIdx := 0;
  AIterator.ItemIdx := 0;
  AIterator.Finished := False;
  Result := IterateGetNext(AIterator);
end;

function TIntPtrMap.IteratorNext(var AIterator: TIntPtrMapIterator): PIntPtrMapItem;
begin
  if AIterator.Finished then
    raise EIntPtrMapError.Create(SErrNoCurrentItem);

  Inc(AIterator.ItemIdx);
  Result := IterateGetNext(AIterator);
end;

function TIntPtrMap.IteratorRemoveItem(var AIterator: TIntPtrMapIterator): Pointer;
var
  SltIdx : Integer;
  ItmIdx : Int32;
  Itm    : PIntPtrMapItem;
  Slt    : PIntPtrHashListSlot;
begin
  if AIterator.Finished or AIterator.Deleted then
    raise EIntPtrMapError.Create(SErrNoCurrentItem);

  SltIdx := AIterator.SlotIdx;
  ItmIdx := AIterator.ItemIdx;
  Slt := @FList[SltIdx];
  if ItmIdx >= Slt^.Count then
    begin
      Result := nil;
      exit;
    end;
  Itm := @Slt^.List[ItmIdx];
  Result := Itm^.Value;
  mapIntPtrSlotRemoveItem(Slt^, ItmIdx);
  Dec(FCount);
  AIterator.Deleted := True;
end;

function TIntPtrMap.VisitAll(
         const ACallback: TIntPtrMapVisitValueEvent;
         var AKey: Int64;
         var AValue: Pointer): Boolean;
var
  Stop   : Boolean;
  SltIdx : Int32;
  ItmIdx : Int32;
  Slt    : PIntPtrHashListSlot;
  Itm    : PIntPtrMapItem;
begin
  if not Assigned(ACallback) then
    raise EIntPtrMapError.Create(SErrNoCallback);

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
  AKey := 0;
  AValue := nil;
  Result := False;
end;



end.

