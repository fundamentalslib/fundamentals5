{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcCryptoHash.pas                                        }
{   File version:     5.23                                                     }
{   Description:      Crypto hashing functions                                 }
{                                                                              }
{   Copyright:        Copyright (c) 1999-2021, David J Butler                  }
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
{   Github:           https://github.com/fundamentalslib                       }
{   E-mail:           fundamentals.library at gmail.com                        }
{                                                                              }
{ Revision history:                                                            }
{                                                                              }
{   2002/04/02  0.01  Initial version from cUtils unit.                        }
{                     Hash: MD5, SHA1, SHA256                                  }
{                     Keyed hash: HMAC-MD5, HMAC-SHA1                          }
{   2002/04/03  0.02  Securely clear passwords from memory after use.          }
{   2003/09/08  3.03  Revised for Fundamentals 3.                              }
{   2005/07/22  4.04  Compilable with FreePascal 2.0 Win32 i386.               }
{   2005/08/27  4.05  Revised for Fundamentals 4.                              }
{   2008/12/30  4.06  Revision.                                                }
{   2010/06/27  4.07  Compilable with FreePascal 2.4.0 OSX x86-64              }
{   2010/11/14  4.08  Added SHA256.                                            }
{   2010/11/15  4.09  Added HMAC-SHA256.                                       }
{   2010/11/16  4.10  Added SHA512.                                            }
{   2010/11/17  4.11  Added HMAC-SHA512, SHA224, SHA384.                       }
{   2011/04/02  4.12  Compilable with Delphi 5.                                }
{   2011/10/14  4.13  Compilable with Delphi XE.                               }
{   2013/01/27  4.14  Added RipeMD160 sponsored and donated by Stefan Westner. }
{   2016/01/09  5.15  Revised for Fundamentals 5.                              }
{   2016/01/29  5.16  Fix in SecureClear for constant string references.       }
{   2018/07/11  5.17  Word32 type changes.                                     }
{   2018/08/12  5.18  String type changes.                                     }
{   2019/09/24  5.19  Optimise RipeMD/SHA1/SHA256/SHA512.                      }
{   2020/03/20  5.20  Optimise Word64 routines used in SHA256/512.             }
{   2020/05/16  5.21  NativeInt changes.                                       }
{   2020/07/20  5.22  Move crypto hash functions to unit flcCryptoHash.        }
{   2020/12/29  5.23  Move tests to unit flcTestCryptoHash.                    }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 2010-10.4 Win32/Win64        5.21  2020/06/02                       }
{   Delphi 10.2-10.4 Linux64            5.21  2020/06/02                       }
{   FreePascal 3.0.4 Win64              5.21  2020/06/02                       }
{                                                                              }
{ Definitions:                                                                 }
{                                                                              }
{   Hashes are algorithms for computing condensed representations of           }
{   messages.                                                                  }
{   The condensed representation is called the message digest.                 }
{                                                                              }
{   Hashes are called secure if it is computationally infeasible to            }
{   find a message that produce a given digest.                                }
{                                                                              }
{   Keyed hashes use a key (password) in the hashing process.                  }
{                                                                              }
{ Hash algorithms:                                                             }
{                                                                              }
{   Algorithm    Digest size (bits)  Uses                      Security        }
{   ------------ ------------------  ------------------------- --------        }
{   MD5            128               Legacy secure hash        Low             }
{   SHA1           160               Legacy secure hash        Low             }
{   SHA256         256               Secure hash               High            }
{   SHA384         384               Secure hash               High            }
{   SHA512         512               Secure hash               High            }
{   RipeMD160      160               Legacy secure hash        Low             }
{   HMAC/MD5       128               Legacy secure keyed hash  Low             }
{   HMAC/SHA1      160               Legacy secure keyed hash  Low             }
{   HMAC/SHA256    256               Secure keyed hash         High            }
{   HMAC/SHA512    512               Secure keyed hash         High            }
{                                                                              }
{ Low security hashes should be avoided. They are included for legacy          }
{ applications.                                                                }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}
{$INCLUDE flcCrypto.inc}

{$IFDEF FREEPASCAL}
  {$WARNINGS OFF}
  {$HINTS OFF}
  {$Q-,R-} // bug in fpc (version?)
{$ENDIF}

unit flcCryptoHash;

interface

uses
  { System }
  SysUtils,

  { Fundamentals }
  flcStdTypes;



{                                                                              }
{ Hash digests                                                                 }
{                                                                              }
type
  Word64Rec = packed record
    case Integer of
    0 : (Bytes   : packed array[0..7] of Byte);
    1 : (Word16s : packed array[0..3] of Word16);
    2 : (Word32s : packed array[0..1] of Word32);
  end;
  PWord64Rec = ^Word64Rec;

  T128BitDigest = packed record
    case integer of
      0 : (Int64s  : packed array[0..1] of Int64);
      1 : (Word32s : packed array[0..3] of Word32);
      2 : (Word16s : packed array[0..7] of Word16);
      3 : (Bytes   : packed array[0..15] of Byte);
    end;
  P128BitDigest = ^T128BitDigest;

  T160BitDigest = packed record
    case integer of
      0 : (Word32s : packed array[0..4] of Word32);
      1 : (Word16s : packed array[0..9] of Word16);
      2 : (Bytes   : packed array[0..19] of Byte);
    end;
  P160BitDigest = ^T160BitDigest;

  T224BitDigest = packed record
    case integer of
      0 : (Word32s : packed array[0..6] of Word32);
      1 : (Word16s : packed array[0..13] of Word16);
      2 : (Bytes   : packed array[0..27] of Byte);
    end;
  P224BitDigest = ^T224BitDigest;

  T256BitDigest = packed record
    case integer of
      0 : (Word64s : packed array[0..3] of Word64);
      1 : (Word32s : packed array[0..7] of Word32);
      2 : (Word16s : packed array[0..15] of Word16);
      3 : (Bytes   : packed array[0..31] of Byte);
    end;
  P256BitDigest = ^T256BitDigest;

  T384BitDigest = packed record
    case integer of
      0 : (Word64s : packed array[0..5] of Word64);
      1 : (Word32s : packed array[0..11] of Word32);
      2 : (Word16s : packed array[0..23] of Word16);
      3 : (Bytes   : packed array[0..47] of Byte);
    end;
  P384BitDigest = ^T384BitDigest;

  T512BitDigest = packed record
    case integer of
      0 : (Word64s : packed array[0..7] of Word64);
      1 : (Word32s : packed array[0..15] of Word32);
      2 : (Word16s : packed array[0..31] of Word16);
      3 : (Bytes   : packed array[0..63] of Byte);
    end;
  P512BitDigest = ^T512BitDigest;

  T512BitBuf  = packed array[0..63] of Byte;

  T1024BitBuf = packed array[0..127] of Byte;



const
  // Maximum digest size used by a hash function in this unit.
  MaxHashDigestSize = Sizeof(T512BitDigest);



{$IFDEF SupportAnsiString}
procedure DigestToHexBufA(const Digest; const Size: Integer; const Buf);
{$ENDIF}
procedure DigestToHexBufU(const Digest; const Size: Integer; const Buf);

{$IFDEF SupportAnsiString}
function  DigestToHexA(const Digest; const Size: Integer): RawByteString;
{$ENDIF}
function  DigestToHexU(const Digest; const Size: Integer): UnicodeString;
{$IFDEF StringIsUnicode}
function  DigestToHex(const Digest; const Size: Integer): String;
{$ENDIF}

function  DigestToBufB(const Digest; const Size: Integer): RawByteString;

function  Digest128Equal(const Digest1, Digest2: T128BitDigest): Boolean;
function  Digest160Equal(const Digest1, Digest2: T160BitDigest): Boolean;
function  Digest224Equal(const Digest1, Digest2: T224BitDigest): Boolean;
function  Digest256Equal(const Digest1, Digest2: T256BitDigest): Boolean;
function  Digest384Equal(const Digest1, Digest2: T384BitDigest): Boolean;
function  Digest512Equal(const Digest1, Digest2: T512BitDigest): Boolean;

procedure Digest512XOR8(var Digest: T512BitDigest; const A: Byte);
procedure Digest512XOR32(var Digest: T512BitDigest; const A: Word32);



{                                                                              }
{ Hash errors                                                                  }
{                                                                              }
const
  hashNoError              = 0;
  hashInternalError        = 1;
  hashInvalidHashType      = 2;
  hashInvalidKeyedHashType = 3;
  hashInvalidBuffer        = 4;
  hashInvalidBufferSize    = 5;
  hashInvalidDigest        = 6;
  hashInvalidKey           = 7;
  hashInvalidFileName      = 8;
  hashFileOpenError        = 9;
  hashFileSeekError        = 10;
  hashFileReadError        = 11;
  hashMAX_ERROR            = 11;

function  GetHashErrorMessage(const ErrorCode: Integer): PChar;


type
  EHashError = class(Exception)
  protected
    FErrorCode : Integer;

  public
    constructor Create(const ErrorCode: Integer; const Msg: String = '');
    property ErrorCode: Integer read FErrorCode;
  end;



{                                                                              }
{ Secure memory clear                                                          }
{   Used to clear keys and other sensitive data from memory                    }
{                                                                              }
procedure SecureClear512(var Buf: T512BitBuf);
procedure SecureClear1024(var Buf: T1024BitBuf);



{                                                                              }
{ MD5 hash                                                                     }
{                                                                              }
{   MD5 is an Internet standard secure hashing function, that was              }
{   developed by Professor Ronald L. Rivest in 1991. Subsequently it has       }
{   been placed in the public domain.                                          }
{   MD5 was developed to be more secure after MD4 was 'broken'.                }
{   Den Boer and Bosselaers estimate that if a custom machine were to be       }
{   built specifically to find collisions for MD5 (costing $10m in 1994) it    }
{   would on average take 24 days to find a collision.                         }
{                                                                              }
procedure MD5InitDigest(var Digest: T128BitDigest);
procedure MD5Buf(var Digest: T128BitDigest; const Buf; const BufSize: NativeInt);
procedure MD5FinalBuf(var Digest: T128BitDigest; const Buf; const BufSize: Int32;
          const TotalSize: Int64);

function  CalcMD5(const Buf; const BufSize: NativeInt): T128BitDigest; overload;
function  CalcMD5(const Buf: RawByteString): T128BitDigest; overload;

function  MD5DigestToStrA(const Digest: T128BitDigest): RawByteString;
function  MD5DigestToHexA(const Digest: T128BitDigest): RawByteString;
function  MD5DigestToHexU(const Digest: T128BitDigest): UnicodeString;



{                                                                              }
{ SHA1 Hashing                                                                 }
{                                                                              }
{   Specification at http://www.itl.nist.gov/fipspubs/fip180-1.htm             }
{   Also see RFC 3174.                                                         }
{   SHA1 was developed by NIST and is specified in the Secure Hash Standard    }
{   (SHS, FIPS 180) and corrects an unpublished flaw the original SHA          }
{   algorithm.                                                                 }
{   SHA1 produces a 160-bit digest and is considered more secure than MD5.     }
{   SHA1 has a similar design to the MD4-family of hash functions.             }
{                                                                              }
const
  SHA1DigestBits = 160;
  SHA1DigestSize = SHA1DigestBits div 8;

procedure SHA1InitDigest(var Digest: T160BitDigest);
procedure SHA1Buf(var Digest: T160BitDigest; const Buf; const BufSize: NativeInt);
procedure SHA1FinalBuf(var Digest: T160BitDigest; const Buf; const BufSize: Int32;
          const TotalSize: Int64);

function  CalcSHA1(const Buf; const BufSize: NativeInt): T160BitDigest; overload;
function  CalcSHA1(const Buf: RawByteString): T160BitDigest; overload;

function  SHA1DigestToStrA(const Digest: T160BitDigest): RawByteString;
function  SHA1DigestToHexA(const Digest: T160BitDigest): RawByteString;
function  SHA1DigestToHexU(const Digest: T160BitDigest): UnicodeString;



{                                                                              }
{ SHA224 Hashing                                                               }
{                                                                              }
{   224 bit SHA-2 hash                                                         }
{   http://en.wikipedia.org/wiki/SHA-2                                         }
{   SHA-224 is based on SHA-256                                                }
{                                                                              }
procedure SHA224InitDigest(var Digest: T256BitDigest);
procedure SHA224Buf(var Digest: T256BitDigest; const Buf; const BufSize: NativeInt);
procedure SHA224FinalBuf(var Digest: T256BitDigest; const Buf; const BufSize: Int32;
          const TotalSize: Int64; var OutDigest: T224BitDigest);

function  CalcSHA224(const Buf; const BufSize: NativeInt): T224BitDigest; overload;
function  CalcSHA224(const Buf: RawByteString): T224BitDigest; overload;

function  SHA224DigestToStrA(const Digest: T224BitDigest): RawByteString;
function  SHA224DigestToHexA(const Digest: T224BitDigest): RawByteString;
function  SHA224DigestToHexU(const Digest: T224BitDigest): UnicodeString;



{                                                                              }
{ SHA256 Hashing                                                               }
{   256 bit SHA-2 hash                                                         }
{                                                                              }
procedure SHA256InitDigest(var Digest: T256BitDigest);
procedure SHA256Buf(var Digest: T256BitDigest; const Buf; const BufSize: NativeInt);
procedure SHA256FinalBuf(var Digest: T256BitDigest; const Buf; const BufSize: Int32;
          const TotalSize: Int64);

function  CalcSHA256(const Buf; const BufSize: NativeInt): T256BitDigest; overload;
function  CalcSHA256(const Buf: RawByteString): T256BitDigest; overload;

function  SHA256DigestToStrA(const Digest: T256BitDigest): RawByteString;
function  SHA256DigestToHexA(const Digest: T256BitDigest): RawByteString;
function  SHA256DigestToHexU(const Digest: T256BitDigest): UnicodeString;



{                                                                              }
{ SHA384 Hashing                                                               }
{   384 bit SHA-2 hash                                                         }
{   SHA-384 is based on SHA-512                                                }
{                                                                              }
procedure SHA384InitDigest(var Digest: T512BitDigest);
procedure SHA384Buf(var Digest: T512BitDigest; const Buf; const BufSize: NativeInt);
procedure SHA384FinalBuf(var Digest: T512BitDigest; const Buf; const BufSize: Int32;
          const TotalSize: Int64; var OutDigest: T384BitDigest);

function  CalcSHA384(const Buf; const BufSize: NativeInt): T384BitDigest; overload;
function  CalcSHA384(const Buf: RawByteString): T384BitDigest; overload;

function  SHA384DigestToStrA(const Digest: T384BitDigest): RawByteString;
function  SHA384DigestToHexA(const Digest: T384BitDigest): RawByteString;
function  SHA384DigestToHexU(const Digest: T384BitDigest): UnicodeString;



{                                                                              }
{ SHA512 Hashing                                                               }
{   512 bit SHA-2 hash                                                         }
{                                                                              }
procedure SHA512InitDigest(var Digest: T512BitDigest);
procedure SHA512Buf(var Digest: T512BitDigest; const Buf; const BufSize: NativeInt);
procedure SHA512FinalBuf(var Digest: T512BitDigest; const Buf; const BufSize: Int32;
          const TotalSize: Int64);

function  CalcSHA512(const Buf; const BufSize: NativeInt): T512BitDigest; overload;
function  CalcSHA512(const Buf: RawByteString): T512BitDigest; overload;

function  SHA512DigestToStrA(const Digest: T512BitDigest): RawByteString;
function  SHA512DigestToHexA(const Digest: T512BitDigest): RawByteString;
function  SHA512DigestToHexU(const Digest: T512BitDigest): UnicodeString;



{                                                                              }
{ RIPEMD160                                                                    }
{                                                                              }
{   RIPEMD-160 is a 160-bit cryptographic hash function, designed by           }
{   Hans Dobbertin, Antoon Bosselaers, and Bart Preneel. It is intended to     }
{   be used as a secure replacement for the 128-bit hash functions MD4, MD5,   }
{   and RIPEMD.                                                                }
{   The authors of RIPEMD-160 and RIPEMD-128 do not hold any patents on the    }
{   algorithms (nor on the optional extensions), and are also not aware of     }
{   any patents on these algorithms.                                           }
{                                                                              }
procedure RipeMD160InitDigest(var Digest: T160BitDigest);
procedure RipeMD160Buf(var Digest: T160BitDigest; const Buf; const BufSize: NativeInt);
procedure RipeMD160FinalBuf(var Digest: T160BitDigest; const Buf; const BufSize: Int32;
          const TotalSize: Int64);

function  CalcRipeMD160(const Buf; const BufSize: NativeInt): T160BitDigest; overload;
function  CalcRipeMD160(const Buf: RawByteString): T160BitDigest; overload;

function  RipeMD160DigestToStrA(const Digest: T160BitDigest): RawByteString;
function  RipeMD160DigestToHexA(const Digest: T160BitDigest): RawByteString;
function  RipeMD160DigestToHexU(const Digest: T160BitDigest): UnicodeString;



{                                                                              }
{ HMAC-MD5 keyed hashing                                                       }
{                                                                              }
{   HMAC allows secure keyed hashing (hashing with a password).                }
{   HMAC was designed to meet the requirements of the IPSEC working group in   }
{   the IETF, and is now a standard.                                           }
{   HMAC, are proven to be secure as long as the underlying hash function      }
{   has some reasonable cryptographic strengths.                               }
{   See RFC 2104 for details on HMAC.                                          }
{                                                                              }
procedure HMAC_MD5Init(const Key: Pointer; const KeySize: Int32;
          var Digest: T128BitDigest; var K: T512BitBuf);
procedure HMAC_MD5Buf(var Digest: T128BitDigest; const Buf; const BufSize: NativeInt);
procedure HMAC_MD5FinalBuf(const K: T512BitBuf; var Digest: T128BitDigest;
          const Buf; const BufSize: Int32; const TotalSize: Int64);

function  CalcHMAC_MD5(const Key: Pointer; const KeySize: Int32;
          const Buf; const BufSize: NativeInt): T128BitDigest; overload;
function  CalcHMAC_MD5(const Key: RawByteString;
          const Buf; const BufSize: NativeInt): T128BitDigest; overload;
function  CalcHMAC_MD5(const Key, Buf: RawByteString): T128BitDigest; overload;



{                                                                              }
{ HMAC-SHA1 keyed hashing                                                      }
{                                                                              }
procedure HMAC_SHA1Init(const Key: Pointer; const KeySize: Int32;
          var Digest: T160BitDigest; var K: T512BitBuf);
procedure HMAC_SHA1Buf(var Digest: T160BitDigest; const Buf; const BufSize: NativeInt);
procedure HMAC_SHA1FinalBuf(const K: T512BitBuf; var Digest: T160BitDigest;
          const Buf; const BufSize: Int32; const TotalSize: Int64);

function  CalcHMAC_SHA1(const Key: Pointer; const KeySize: Int32;
          const Buf; const BufSize: NativeInt): T160BitDigest; overload;
function  CalcHMAC_SHA1(const Key: RawByteString;
          const Buf; const BufSize: NativeInt): T160BitDigest; overload;
function  CalcHMAC_SHA1(const Key, Buf: RawByteString): T160BitDigest; overload;



{                                                                              }
{ HMAC-SHA256 keyed hashing                                                    }
{                                                                              }
procedure HMAC_SHA256Init(const Key: Pointer; const KeySize: Int32;
          var Digest: T256BitDigest; var K: T512BitBuf);
procedure HMAC_SHA256Buf(var Digest: T256BitDigest; const Buf; const BufSize: NativeInt);
procedure HMAC_SHA256FinalBuf(const K: T512BitBuf; var Digest: T256BitDigest;
          const Buf; const BufSize: Int32; const TotalSize: Int64);

function  CalcHMAC_SHA256(const Key: Pointer; const KeySize: Int32;
          const Buf; const BufSize: NativeInt): T256BitDigest; overload;
function  CalcHMAC_SHA256(const Key: RawByteString;
          const Buf; const BufSize: NativeInt): T256BitDigest; overload;
function  CalcHMAC_SHA256(const Key, Buf: RawByteString): T256BitDigest; overload;



{                                                                              }
{ HMAC-SHA512 keyed hashing                                                    }
{                                                                              }
procedure HMAC_SHA512Init(const Key: Pointer; const KeySize: Int32;
          var Digest: T512BitDigest; var K: T1024BitBuf);
procedure HMAC_SHA512Buf(var Digest: T512BitDigest; const Buf; const BufSize: NativeInt);
procedure HMAC_SHA512FinalBuf(const K: T1024BitBuf; var Digest: T512BitDigest;
          const Buf; const BufSize: Int32; const TotalSize: Int64);

function  CalcHMAC_SHA512(const Key: Pointer; const KeySize: Int32;
          const Buf; const BufSize: NativeInt): T512BitDigest; overload;
function  CalcHMAC_SHA512(const Key: RawByteString; const Buf; const BufSize: NativeInt): T512BitDigest; overload;
function  CalcHMAC_SHA512(const Key, Buf: RawByteString): T512BitDigest; overload;



{                                                                              }
{ Hash class wrappers                                                          }
{                                                                              }
type
  { AHash                                                                      }
  {   Base class for hash classes.                                             }
  AHash = class
  protected
    FDigest    : Pointer;
    FTotalSize : Int64;

    procedure InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32); virtual; abstract;
    procedure ProcessBuf(const Buf; const BufSize: NativeInt); virtual; abstract;
    procedure ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64); virtual;

  public
    class function DigestSize: Int32; virtual; abstract;
    class function BlockSize: Int32; virtual;

    procedure Init(const Digest: Pointer; const Key: Pointer = nil;
              const KeySize: Int32 = 0); overload;
    procedure Init(const Digest: Pointer; const Key: RawByteString); overload;

    procedure HashBuf(const Buf; const BufSize: NativeInt; const FinalBuf: Boolean);
    procedure HashFile(const FileName: String; const Offset: Int64 = 0;
              const MaxCount: Int64 = -1);
  end;
  THashClass = class of AHash;

  { TMD5Hash                                                                   }
  TMD5Hash = class(AHash)
  protected
    procedure InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32); override;
    procedure ProcessBuf(const Buf; const BufSize: NativeInt); override;
    procedure ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64); override;

  public
    class function DigestSize: Int32; override;
    class function BlockSize: Int32; override;
  end;

  { TSHA1Hash                                                                  }
  TSHA1Hash = class(AHash)
  protected
    procedure InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32); override;
    procedure ProcessBuf(const Buf; const BufSize: NativeInt); override;
    procedure ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64); override;

  public
    class function DigestSize: Int32; override;
    class function BlockSize: Int32; override;
  end;

  { TSHA256Hash                                                                }
  TSHA256Hash = class(AHash)
  protected
    procedure InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32); override;
    procedure ProcessBuf(const Buf; const BufSize: NativeInt); override;
    procedure ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64); override;

  public
    class function DigestSize: Int32; override;
    class function BlockSize: Int32; override;
  end;

  { TSHA512Hash                                                                }
  TSHA512Hash = class(AHash)
  protected
    procedure InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32); override;
    procedure ProcessBuf(const Buf; const BufSize: NativeInt); override;
    procedure ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64); override;

  public
    class function DigestSize: Int32; override;
    class function BlockSize: Int32; override;
  end;

  { TRipeMD160Hash                                                             }
  TRipeMD160Hash = class(AHash)
  protected
    procedure InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32); override;
    procedure ProcessBuf(const Buf; const BufSize: NativeInt); override;
    procedure ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64); override;

  public
    class function DigestSize: Int32; override;
    class function BlockSize: Int32; override;
  end;

  { THMAC_MD5Hash                                                              }
  THMAC_MD5Hash = class(AHash)
  protected
    FKey : T512BitBuf;

    procedure InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32); override;
    procedure ProcessBuf(const Buf; const BufSize: NativeInt); override;
    procedure ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64); override;

  public
    class function DigestSize: Int32; override;
    class function BlockSize: Int32; override;

    destructor Destroy; override;
  end;

  { THMAC_SHA1Hash                                                             }
  THMAC_SHA1Hash = class(AHash)
  protected
    FKey : T512BitBuf;

    procedure InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32); override;
    procedure ProcessBuf(const Buf; const BufSize: NativeInt); override;
    procedure ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64); override;

  public
    class function DigestSize: Int32; override;
    class function BlockSize: Int32; override;

    destructor Destroy; override;
  end;

  { THMAC_SHA256Hash                                                           }
  THMAC_SHA256Hash = class(AHash)
  protected
    FKey : T512BitBuf;

    procedure InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32); override;
    procedure ProcessBuf(const Buf; const BufSize: NativeInt); override;
    procedure ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64); override;

  public
    class function DigestSize: Int32; override;
    class function BlockSize: Int32; override;

    destructor Destroy; override;
  end;

  { THMAC_SHA512Hash                                                           }
  THMAC_SHA512Hash = class(AHash)
  protected
    FKey : T1024BitBuf;

    procedure InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32); override;
    procedure ProcessBuf(const Buf; const BufSize: NativeInt); override;
    procedure ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64); override;

  public
    class function DigestSize: Int32; override;
    class function BlockSize: Int32; override;

    destructor Destroy; override;
  end;



{                                                                              }
{ THashType                                                                    }
{                                                                              }
type
  THashType = (
    hashMD5,
    hashSHA1,
    hashSHA256,
    hashSHA512,
    hashRipeMD160,
    hashHMAC_MD5,
    hashHMAC_SHA1,
    hashHMAC_SHA256,
    hashHMAC_SHA512
    );



{                                                                              }
{ GetHashClassByType                                                           }
{                                                                              }
function  GetHashClassByType(const HashType: THashType): THashClass;
function  GetDigestSize(const HashType: THashType): Integer;



{                                                                              }
{ CalculateHash                                                                }
{                                                                              }
procedure CalculateHash(
          const HashType: THashType;
          const Buf; const BufSize: Integer;
          const Digest: Pointer;
          const Key: Pointer = nil; const KeySize: Integer = 0); overload;

procedure CalculateHash(
          const HashType: THashType;
          const Buf; const BufSize: Integer;
          const Digest: Pointer;
          const Key: RawByteString); overload;

procedure CalculateHash(
          const HashType: THashType;
          const Buf: RawByteString;
          const Digest: Pointer;
          const Key: RawByteString); overload;



implementation

uses
  { System }
  {$IFDEF MSWIN}
  Windows,
  {$ENDIF}

  {$IFDEF DELPHI}
  {$IFDEF POSIX}
  Posix.Unistd,
  {$ENDIF}
  {$ENDIF}

  { Fundamentals }
  flcSysUtils,
  flcCryptoUtils;



{                                                                              }
{ Hash errors                                                                  }
{                                                                              }
const
  hashErrorMessages : array[0..hashMAX_ERROR] of String = (
      '',
      'Internal error',
      'Invalid hash type',
      'Invalid keyed hash type',
      'Invalid buffer',
      'Invalid buffer size',
      'Invalid digest',
      'Invalid key',
      'Invalid file name',
      'File open error',
      'File seek error',
      'File read error');

function GetHashErrorMessage(const ErrorCode: Integer): PChar;
begin
  if (ErrorCode <= hashNoError) or (ErrorCode > hashMAX_ERROR) then
    Result := nil
  else
    Result := PChar(hashErrorMessages[ErrorCode]);
end;



{                                                                              }
{ EHashError                                                                   }
{                                                                              }
constructor EHashError.Create(const ErrorCode: Integer; const Msg: String);
begin
  FErrorCode := ErrorCode;
  if (Msg = '') and (ErrorCode <= hashMAX_ERROR) then
    inherited Create(hashErrorMessages[ErrorCode])
  else
    inherited Create(Msg);
end;



{                                                                              }
{ String internals functions                                                   }
{                                                                              }
{$IFNDEF SupportStringRefCount}
{$IFDEF DELPHI}
function StringRefCount(const S: UnicodeString): LongInt; overload; {$IFDEF UseInline}inline;{$ENDIF}
var
  P : PInteger;
begin
  P := Pointer(S);
  if not Assigned(P) then
    Result := 0
  else
    begin
      Dec(P, 2);
      Result := P^;
    end;
end;

function StringRefCount(const S: RawByteString): LongInt; overload; {$IFDEF UseInline}inline;{$ENDIF}
var
  P : PInteger;
begin
  P := Pointer(S);
  if not Assigned(P) then
    Result := 0
  else
    begin
      Dec(P, 2);
      Result := P^;
    end;
end;
{$ENDIF}
{$ENDIF}



{                                                                              }
{ Secure memory clear                                                          }
{                                                                              }
procedure SecureClear512(var Buf: T512BitBuf);
begin
  SecureClearBuf(Buf, SizeOf(Buf));
end;

procedure SecureClear1024(var Buf: T1024BitBuf);
begin
  SecureClearBuf(Buf, SizeOf(Buf));
end;



{                                                                              }
{ Digests                                                                      }
{                                                                              }
const
  s_HexDigitsLowerB : RawByteString = '0123456789abcdef';
  s_HexDigitsLower : String = '0123456789abcdef';

procedure DigestToHexBufA(const Digest; const Size: Integer; const Buf);
var
  I : Integer;
  P : PByteChar;
  Q : PByte;
begin
  P := @Buf;;
  Assert(Assigned(P));
  Q := @Digest;
  Assert(Assigned(Q));
  for I := 0 to Size - 1 do
    begin
      P^ := s_HexDigitsLowerB[Q^ shr 4 + 1];
      Inc(P);
      P^ := s_HexDigitsLowerB[Q^ and 15 + 1];
      Inc(P);
      Inc(Q);
    end;
end;

procedure DigestToHexBufU(const Digest; const Size: Integer; const Buf);
var
  I : Integer;
  P : PWideChar;
  Q : PByte;
begin
  P := @Buf;;
  Assert(Assigned(P));
  Q := @Digest;
  Assert(Assigned(Q));
  for I := 0 to Size - 1 do
    begin
      P^ := WideChar(s_HexDigitsLower[Q^ shr 4 + 1]);
      Inc(P);
      P^ := WideChar(s_HexDigitsLower[Q^ and 15 + 1]);
      Inc(P);
      Inc(Q);
    end;
end;

function DigestToHexA(const Digest; const Size: Integer): RawByteString;
begin
  SetLength(Result, Size * 2);
  DigestToHexBufA(Digest, Size, Pointer(Result)^);
end;

function DigestToHexU(const Digest; const Size: Integer): UnicodeString;
begin
  SetLength(Result, Size * 2);
  DigestToHexBufU(Digest, Size, Pointer(Result)^);
end;

{$IFDEF StringIsUnicode}
function DigestToHex(const Digest; const Size: Integer): String;
begin
  SetLength(Result, Size * 2);
  DigestToHexBufU(Digest, Size, Pointer(Result)^);
end;
{$ENDIF}

function DigestToBufB(const Digest; const Size: Integer): RawByteString;
var
  S : RawByteString;
begin
  SetLength(S, Size);
  if Size > 0 then
    Move(Digest, S[1], Size);
  Result := S;
end;

function Digest128Equal(const Digest1, Digest2: T128BitDigest): Boolean;
var
  I : Integer;
begin
  for I := 0 to 3 do
    if Digest1.Word32s[I] <> Digest2.Word32s[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function Digest160Equal(const Digest1, Digest2: T160BitDigest): Boolean;
var
  I : Integer;
begin
  for I := 0 to 4 do
    if Digest1.Word32s[I] <> Digest2.Word32s[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function Digest224Equal(const Digest1, Digest2: T224BitDigest): Boolean;
var
  I : Integer;
begin
  for I := 0 to 6 do
    if Digest1.Word32s[I] <> Digest2.Word32s[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function Digest256Equal(const Digest1, Digest2: T256BitDigest): Boolean;
var
  I : Integer;
begin
  for I := 0 to 7 do
    if Digest1.Word32s[I] <> Digest2.Word32s[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function Digest384Equal(const Digest1, Digest2: T384BitDigest): Boolean;
var
  I : Integer;
begin
  for I := 0 to 11 do
    if Digest1.Word32s[I] <> Digest2.Word32s[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function Digest512Equal(const Digest1, Digest2: T512BitDigest): Boolean;
var
  I : Integer;
begin
  for I := 0 to 15 do
    if Digest1.Word32s[I] <> Digest2.Word32s[I] then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

procedure Digest512XOR8(var Digest: T512BitDigest; const A: Byte);
var
  I : Integer;
begin
  for I := 0 to 63 do
    Digest.Bytes[I] := Digest.Bytes[I] xor A;
end;

procedure Digest512XOR32(var Digest: T512BitDigest; const A: Word32);
var
  I : Integer;
begin
  for I := 0 to 15 do
    Digest.Word32s[I] := Digest.Word32s[I] xor A;
end;



{                                                                              }
{ ReverseMem                                                                   }
{ Utility function to reverse order of data in buffer.                         }
{                                                                              }
procedure ReverseMem(var Buf; const BufSize: Integer);
var
  I : Integer;
  P : PByte;
  Q : PByte;
  T : Byte;
begin
  P := @Buf;
  Q := P;
  Inc(Q, BufSize - 1);
  for I := 1 to BufSize div 2 do
    begin
      T := P^;
      P^ := Q^;
      Q^ := T;
      Inc(P);
      Dec(Q);
    end;
end;



{                                                                              }
{ StdFinalBuf                                                                  }
{ Utility function to prepare final buffer(s).                                 }
{ Fills Buf1 and potentially Buf2 from Buf (FinalBufCount = 1 or 2).           }
{ Used by MD5, SHA1, SHA256, SHA512.                                           }
{                                                                              }
procedure StdFinalBuf512(
          const Buf; const BufSize: Int32; const TotalSize: Int64;
          var Buf1, Buf2: T512BitBuf;
          var FinalBufs: Int32;
          const SwapEndian: Boolean);
var
  P, Q : PByte;
  I : Int32;
  L : Int64;
begin
  Assert(BufSize < 64, 'Final BufSize must be less than 64 bytes');
  Assert(TotalSize >= BufSize, 'TotalSize >= BufSize');

  P := @Buf;
  Q := @Buf1[0];
  if BufSize > 0 then
    begin
      Move(P^, Q^, BufSize);
      Inc(Q, BufSize);
    end;
  Q^ := $80;
  Inc(Q);

  {$IFDEF DELPHI5}
  // Delphi 5 sometimes reports fatal error (internal error C1093) when compiling:
  //   L := TotalSize * 8
  L := TotalSize;
  L := L * 8;
  {$ELSE}
  L := TotalSize * 8;
  {$ENDIF}
  if SwapEndian then
    ReverseMem(L, 8);
  if BufSize + 1 > 64 - Sizeof(Int64) then
    begin
      FillChar(Q^, 64 - BufSize - 1, #0);
      Q := @Buf2[0];
      FillChar(Q^, 64 - Sizeof(Int64), #0);
      Inc(Q, 64 - Sizeof(Int64));
      PInt64(Q)^ := L;
      FinalBufs := 2;
    end
  else
    begin
      I := 64 - Sizeof(Int64) - BufSize - 1;
      FillChar(Q^, I, #0);
      Inc(Q, I);
      PInt64(Q)^ := L;
      FinalBufs := 1;
    end;
end;

procedure StdFinalBuf1024(
          const Buf; const BufSize: Int32; const TotalSize: Int64;
          var Buf1, Buf2: T1024BitBuf;
          var FinalBufs: Int32;
          const SwapEndian: Boolean);
var
  P, Q : PByte;
  I : Int32;
  L : Int64;
begin
  Assert(BufSize < 128, 'Final BufSize must be less than 128 bytes');
  Assert(TotalSize >= BufSize, 'TotalSize >= BufSize');

  P := @Buf;
  Q := @Buf1[0];
  if BufSize > 0 then
    begin
      Move(P^, Q^, BufSize);
      Inc(Q, BufSize);
    end;
  Q^ := $80;
  Inc(Q);

  {$IFDEF DELPHI5}
  // Delphi 5 sometimes reports fatal error (internal error C1093) when compiling:
  //   L := TotalSize * 8
  L := TotalSize;
  L := L * 8;
  {$ELSE}
  L := TotalSize * 8;
  {$ENDIF}
  if SwapEndian then
    ReverseMem(L, 8);
  if BufSize + 1 > 128 - Sizeof(Int64) * 2 then
    begin
      FillChar(Q^, 128 - BufSize - 1, #0);
      Q := @Buf2[0];
      FillChar(Q^, 128 - Sizeof(Int64) * 2, #0);
      Inc(Q, 128 - Sizeof(Int64) * 2);
      PInt64(Q)^ := 0;
      Inc(Q, 8);
      PInt64(Q)^ := L;
      FinalBufs := 2;
    end
  else
    begin
      I := 128 - Sizeof(Int64) * 2 - BufSize - 1;
      FillChar(Q^, I, #0);
      Inc(Q, I);
      PInt64(Q)^ := 0;
      Inc(Q, 8);
      PInt64(Q)^ := L;
      FinalBufs := 1;
    end;
end;

{                                                                              }
{ Utility functions SwapEndian, RotateLeftBits, RotateRightBits.               }
{ Used by SHA1 and SHA256.                                                     }
{                                                                              }
{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

{$IFDEF ASM386}
function SwapEndian(const Value: Word32): Word32; register; assembler;
asm
      XCHG    AH, AL
      ROL     EAX, 16
      XCHG    AH, AL
end;
{$ELSE}
function SwapEndian(const Value: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := ((Value and $000000FF) shl 24)  or
            ((Value and $0000FF00) shl 8)   or
            ((Value and $00FF0000) shr 8)   or
            ((Value and $FF000000) shr 24);
end;
{$ENDIF}

procedure SwapEndianBuf(var Buf; const Count: NativeInt);
var
  P : PWord32;
  I : NativeInt;
begin
  P := @Buf;
  for I := 1 to Count do
    begin
      P^ := SwapEndian(P^);
      Inc(P);
    end;
end;

{$IFDEF ASM386_DELPHI}
function RotateLeftBits(const Value: Word32; const Bits: Byte): Word32;
asm
      MOV     CL, DL
      ROL     EAX, CL
end;
{$ELSE}
function RotateLeftBits(const Value: Word32; const Bits: Byte): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Assert(Bits > 0);
  Assert(Bits < 32);
  Result := (Value shl Bits) or Word32(Value shr (32 - Bits));
end;
{$ENDIF}

{$IFDEF ASM386_DELPHI}
function RotateRightBits(const Value: Word32; const Bits: Byte): Word32;
asm
      MOV     CL, DL
      ROR     EAX, CL
end;
{$ELSE}
function RotateRightBits(const Value: Word32; const Bits: Byte): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Assert(Bits > 0);
  Assert(Bits < 32);
  Result := (Value shr Bits) or Word32(Value shl (32 - Bits));
end;
{$ENDIF}

{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



{                                                                              }
{ Utility functions for Word64 arithmetic                                      }
{ Used by SHA-512                                                              }
{                                                                              }
{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}
{$IFDEF SupportUInt64}
procedure Word64InitZero(var A: Word64); {$IFDEF UseInline}inline;{$ENDIF}
begin
  UInt64(A) := 0;
end;
{$ELSE}
procedure Word64InitZero(var A: Word64);
begin
  Word64Rec(A).Word32s[0] := 0;
  Word64Rec(A).Word32s[1] := 0;
end;
{$ENDIF}

{$IFDEF SupportUInt64}
procedure Word64Not(var A: Word64); {$IFDEF UseInline}inline;{$ENDIF}
begin
  UInt64(A) := not UInt64(A);
end;
{$ELSE}
procedure Word64Not(var A: Word64); {$IFDEF UseInline}inline;{$ENDIF}
begin
  Word64Rec(A).Word32s[0] := not Word64Rec(A).Word32s[0];
  Word64Rec(A).Word32s[1] := not Word64Rec(A).Word32s[1];
end;
{$ENDIF}

{$IFDEF SupportUInt64}
procedure Word64AndWord64(var A: Word64; const B: Word64); {$IFDEF UseInline}inline;{$ENDIF}
begin
  UInt64(A) := UInt64(A) and UInt64(B);
end;
{$ELSE}
procedure Word64AndWord64(var A: Word64; const B: Word64); {$IFDEF UseInline}inline;{$ENDIF}
begin
  Word64Rec(A).Word32s[0] := Word64Rec(A).Word32s[0] and Word64Rec(B).Word32s[0];
  Word64Rec(A).Word32s[1] := Word64Rec(A).Word32s[1] and Word64Rec(B).Word32s[1];
end;
{$ENDIF}

{$IFDEF SupportUInt64}
procedure Word64XorWord64(var A: Word64; const B: Word64); {$IFDEF UseInline}inline;{$ENDIF}
begin
  UInt64(A) := UInt64(A) xor UInt64(B);
end;
{$ELSE}
procedure Word64XorWord64(var A: Word64; const B: Word64); {$IFDEF UseInline}inline;{$ENDIF}
begin
  Word64Rec(A).Word32s[0] := Word64Rec(A).Word32s[0] xor Word64Rec(B).Word32s[0];
  Word64Rec(A).Word32s[1] := Word64Rec(A).Word32s[1] xor Word64Rec(B).Word32s[1];
end;
{$ENDIF}

{$IFDEF SupportUInt64}
procedure Word64AddWord64(var A: Word64; const B: Word64); {$IFDEF UseInline}inline;{$ENDIF}
begin
  Inc(UInt64(A), UInt64(B));
end;
{$ELSE}
procedure Word64AddWord64(var A: Word64; const B: Word64); {$IFDEF UseInline}inline;{$ENDIF}
var
  C, D : Int64;
begin
  C := Int64(Word64Rec(A).Word32s[0]) + Word64Rec(B).Word32s[0];
  D := Int64(Word64Rec(A).Word32s[1]) + Word64Rec(B).Word32s[1];
  Inc(D, C shr 32);
  Word64Rec(A).Word32s[0] := C and $FFFFFFFF;
  Word64Rec(A).Word32s[1] := D and $FFFFFFFF;
end;
{$ENDIF}

{$IFDEF SupportUInt64}
procedure Word64Shr(var A: Word64; const B: Byte); {$IFDEF UseInline}inline;{$ENDIF}
begin
  UInt64(A) := UInt64(A) shr B;
end;
{$ELSE}
procedure Word64Shr(var A: Word64; const B: Byte); {$IFDEF UseInline}inline;{$ENDIF}
var C : Byte;
    A1 : Word32;
begin
  Assert(B > 0);
  Assert(B < 64);
  if B < 32 then
    begin
      C := 32 - B;
      A1 := Word64Rec(A).Word32s[1];
      Word64Rec(A).Word32s[0] := (Word64Rec(A).Word32s[0] shr B) or (A1 shl C);
      Word64Rec(A).Word32s[1] := A1 shr B;
    end
  else
    begin
      C := B - 32;
      Word64Rec(A).Word32s[0] := Word64Rec(A).Word32s[1] shr C;
      Word64Rec(A).Word32s[1] := 0;
    end;
end;
{$ENDIF}

{$IFDEF SupportUInt64}
procedure Word64Ror(var A: Word64; const B: Byte); {$IFDEF UseInline}inline;{$ENDIF}
var
  C : UInt64;
  D : Byte;
begin
  C := UInt64(A);
  D := 64 - B;
  UInt64(A) := (C shr B) or (C shl D);
end;
{$ELSE}
procedure Word64Ror(var A: Word64; const B: Byte); {$IFDEF UseInline}inline;{$ENDIF}
var
  C, D : Byte;
  A0, A1 : Word32;
  E, F : Word32;
begin
  Assert(B > 0);
  Assert(B < 64);
  if B < 32 then
    begin
      D := 32 - B;
      A0 := Word64Rec(A).Word32s[0];
      A1 := Word64Rec(A).Word32s[1];
      E := (A1 shr B) or (A0 shl D);
      F := (A0 shr B) or (A1 shl D);
    end
  else
    begin
      C := B - 32;
      D := 32 - C;
      A0 := Word64Rec(A).Word32s[0];
      A1 := Word64Rec(A).Word32s[1];
      E := (A0 shr C) or (A1 shl D);
      F := (A1 shr C) or (A0 shl D);
    end;
  Word64Rec(A).Word32s[1] := E;
  Word64Rec(A).Word32s[0] := F;
end;
{$ENDIF}

procedure Word64SwapEndian(var A: Word64); {$IFDEF UseInline}inline;{$ENDIF}
var
  B : Word64;
  I : Integer;
begin
  B := A;
  for I := 0 to 7 do
    Word64Rec(A).Bytes[I] := Word64Rec(B).Bytes[7 - I];
end;

procedure SwapEndianBuf64(var Buf; const Count: Integer);
var
  P : PWord64;
  I : Integer;
begin
  P := @Buf;
  for I := 1 to Count do
    begin
      Word64SwapEndian(P^);
      Inc(P);
    end;
end;
{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}



{                                                                              }
{ MD5 hashing                                                                  }
{                                                                              }
const
  MD5Table_1 : array[0..15] of Word32 = (
      $D76AA478, $E8C7B756, $242070DB, $C1BDCEEE,
      $F57C0FAF, $4787C62A, $A8304613, $FD469501,
      $698098D8, $8B44F7AF, $FFFF5BB1, $895CD7BE,
      $6B901122, $FD987193, $A679438E, $49B40821);
  MD5Table_2 : array[0..15] of Word32 = (
      $F61E2562, $C040B340, $265E5A51, $E9B6C7AA,
      $D62F105D, $02441453, $D8A1E681, $E7D3FBC8,
      $21E1CDE6, $C33707D6, $F4D50D87, $455A14ED,
      $A9E3E905, $FCEFA3F8, $676F02D9, $8D2A4C8A);
  MD5Table_3 : array[0..15] of Word32 = (
      $FFFA3942, $8771F681, $6D9D6122, $FDE5380C,
      $A4BEEA44, $4BDECFA9, $F6BB4B60, $BEBFBC70,
      $289B7EC6, $EAA127FA, $D4EF3085, $04881D05,
      $D9D4D039, $E6DB99E5, $1FA27CF8, $C4AC5665);
  MD5Table_4 : array[0..15] of Word32 = (
      $F4292244, $432AFF97, $AB9423A7, $FC93A039,
      $655B59C3, $8F0CCC92, $FFEFF47D, $85845DD1,
      $6FA87E4F, $FE2CE6E0, $A3014314, $4E0811A1,
      $F7537E82, $BD3AF235, $2AD7D2BB, $EB86D391);

{ Calculates a MD5 Digest (16 bytes) given a Buffer (64 bytes)                 }
{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}
type
  TMD5Buffer = array[0..15] of Word32;
  PMD5Buffer = ^TMD5Buffer;

procedure TransformMD5Buffer(var Digest: T128BitDigest; const Buffer);
var
  A, B, C, D : Word32;
  P          : PWord32;
  I          : Integer;
  J          : Byte;
  Buf        : PMD5Buffer;
begin
  Buf := @Buffer;

  A := Digest.Word32s[0];
  B := Digest.Word32s[1];
  C := Digest.Word32s[2];
  D := Digest.Word32s[3];

  P := @MD5Table_1;
  for I := 0 to 3 do
    begin
      J := I * 4;
      Inc(A, Buf^[J]     + P^ + (D xor (B and (C xor D)))); A := A shl  7 or A shr 25 + B; Inc(P);
      Inc(D, Buf^[J + 1] + P^ + (C xor (A and (B xor C)))); D := D shl 12 or D shr 20 + A; Inc(P);
      Inc(C, Buf^[J + 2] + P^ + (B xor (D and (A xor B)))); C := C shl 17 or C shr 15 + D; Inc(P);
      Inc(B, Buf^[J + 3] + P^ + (A xor (C and (D xor A)))); B := B shl 22 or B shr 10 + C; Inc(P);
    end;

  P := @MD5Table_2;
  for I := 0 to 3 do
    begin
      J := I * 4;
      Inc(A, Buf^[J + 1]           + P^ + (C xor (D and (B xor C)))); A := A shl  5 or A shr 27 + B; Inc(P);
      Inc(D, Buf^[(J + 6) and $F]  + P^ + (B xor (C and (A xor B)))); D := D shl  9 or D shr 23 + A; Inc(P);
      Inc(C, Buf^[(J + 11) and $F] + P^ + (A xor (B and (D xor A)))); C := C shl 14 or C shr 18 + D; Inc(P);
      Inc(B, Buf^[J]               + P^ + (D xor (A and (C xor D)))); B := B shl 20 or B shr 12 + C; Inc(P);
    end;

  P := @MD5Table_3;
  for I := 0 to 3 do
    begin
      J := 16 - (I * 4);
      Inc(A, Buf^[(J + 5) and $F]  + P^ + (B xor C xor D)); A := A shl  4 or A shr 28 + B; Inc(P);
      Inc(D, Buf^[(J + 8) and $F]  + P^ + (A xor B xor C)); D := D shl 11 or D shr 21 + A; Inc(P);
      Inc(C, Buf^[(J + 11) and $F] + P^ + (D xor A xor B)); C := C shl 16 or C shr 16 + D; Inc(P);
      Inc(B, Buf^[(J + 14) and $F] + P^ + (C xor D xor A)); B := B shl 23 or B shr  9 + C; Inc(P);
    end;

  P := @MD5Table_4;
  for I := 0 to 3 do
    begin
      J := 16 - (I * 4);
      Inc(A, Buf^[J and $F]        + P^ + (C xor (B or not D))); A := A shl  6 or A shr 26 + B; Inc(P);
      Inc(D, Buf^[(J + 7) and $F]  + P^ + (B xor (A or not C))); D := D shl 10 or D shr 22 + A; Inc(P);
      Inc(C, Buf^[(J + 14) and $F] + P^ + (A xor (D or not B))); C := C shl 15 or C shr 17 + D; Inc(P);
      Inc(B, Buf^[(J + 5) and $F]  + P^ + (D xor (C or not A))); B := B shl 21 or B shr 11 + C; Inc(P);
    end;

  Inc(Digest.Word32s[0], A);
  Inc(Digest.Word32s[1], B);
  Inc(Digest.Word32s[2], C);
  Inc(Digest.Word32s[3], D);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}

procedure MD5InitDigest(var Digest: T128BitDigest);
begin
  Digest.Word32s[0] := $67452301;
  Digest.Word32s[1] := $EFCDAB89;
  Digest.Word32s[2] := $98BADCFE;
  Digest.Word32s[3] := $10325476;
end;

procedure MD5Buf(var Digest: T128BitDigest; const Buf; const BufSize: NativeInt);
var
  P : PByte;
  I, J : NativeInt;
begin
  I := BufSize;
  if I <= 0 then
    exit;
  Assert(I mod 64 = 0, 'BufSize must be multiple of 64 bytes');
  P := @Buf;
  for J := 0 to I div 64 - 1 do
    begin
      TransformMD5Buffer(Digest, P^);
      Inc(P, 64);
    end;
end;

procedure MD5FinalBuf(var Digest: T128BitDigest; const Buf; const BufSize: Int32; const TotalSize: Int64);
var
  B1, B2 : T512BitBuf;
  C : Int32;
begin
  StdFinalBuf512(Buf, BufSize, TotalSize, B1, B2, C, False);
  TransformMD5Buffer(Digest, B1);
  if C > 1 then
    TransformMD5Buffer(Digest, B2);
  SecureClear512(B1);
  if C > 1 then
    SecureClear512(B2);
end;

function CalcMD5(const Buf; const BufSize: NativeInt): T128BitDigest;
var
  I, J : NativeInt;
  P    : PByte;
begin
  MD5InitDigest(Result);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 64) * 64;
  if J > 0 then
    begin
      MD5Buf(Result, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  MD5FinalBuf(Result, P^, I, BufSize);
end;

function CalcMD5(const Buf: RawByteString): T128BitDigest;
begin
  Result := CalcMD5(Pointer(Buf)^, Length(Buf));
end;

function MD5DigestToStrA(const Digest: T128BitDigest): RawByteString;
begin
  SetLength(Result, Sizeof(Digest));
  Move(Digest, Pointer(Result)^, Sizeof(Digest));
end;

function MD5DigestToHexA(const Digest: T128BitDigest): RawByteString;
begin
  Result := DigestToHexA(Digest, Sizeof(Digest));
end;

function MD5DigestToHexU(const Digest: T128BitDigest): UnicodeString;
begin
  Result := DigestToHexU(Digest, Sizeof(Digest));
end;



{                                                                              }
{ SHA hashing                                                                  }
{                                                                              }
procedure SHA1InitDigest(var Digest: T160BitDigest);
begin
  Digest.Word32s[0] := $67452301;
  Digest.Word32s[1] := $EFCDAB89;
  Digest.Word32s[2] := $98BADCFE;
  Digest.Word32s[3] := $10325476;
  Digest.Word32s[4] := $C3D2E1F0;
end;

{ Calculates a SHA Digest (20 bytes) given a Buffer (64 bytes)                 }
{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}
procedure TransformSHABuffer(var Digest: T160BitDigest; const Buffer; const SHA1: Boolean);
var
  A, B, C, D, E : Word32;
  W : array[0..79] of Word32;
  P, Q : PWord32;
  I : Integer;
  J : Word32;
begin
  P := @Buffer;
  Q := @W;
  for I := 0 to 15 do
    begin
      Q^ := SwapEndian(P^);
      Inc(P);
      Inc(Q);
    end;
  for I := 0 to 63 do
    begin
      P := Q;
      Dec(P, 16);
      J := P^;
      Inc(P, 2);
      J := J xor P^;
      Inc(P, 6);
      J := J xor P^;
      Inc(P, 5);
      J := J xor P^;
      if SHA1 then
        J := RotateLeftBits(J, 1);
      Q^ := J;
      Inc(Q);
    end;

  A := Digest.Word32s[0];
  B := Digest.Word32s[1];
  C := Digest.Word32s[2];
  D := Digest.Word32s[3];
  E := Digest.Word32s[4];

  P := @W;
  for I := 0 to 3 do
    begin
      Inc(E, (A shl 5 or A shr 27) + (D xor (B and (C xor D))) + P^ + $5A827999); B := B shr 2 or B shl 30; Inc(P);
      Inc(D, (E shl 5 or E shr 27) + (C xor (A and (B xor C))) + P^ + $5A827999); A := A shr 2 or A shl 30; Inc(P);
      Inc(C, (D shl 5 or D shr 27) + (B xor (E and (A xor B))) + P^ + $5A827999); E := E shr 2 or E shl 30; Inc(P);
      Inc(B, (C shl 5 or C shr 27) + (A xor (D and (E xor A))) + P^ + $5A827999); D := D shr 2 or D shl 30; Inc(P);
      Inc(A, (B shl 5 or B shr 27) + (E xor (C and (D xor E))) + P^ + $5A827999); C := C shr 2 or C shl 30; Inc(P);
    end;

  for I := 0 to 3 do
    begin
      Inc(E, (A shl 5 or A shr 27) + (D xor B xor C) + P^ + $6ED9EBA1); B := B shr 2 or B shl 30; Inc(P);
      Inc(D, (E shl 5 or E shr 27) + (C xor A xor B) + P^ + $6ED9EBA1); A := A shr 2 or A shl 30; Inc(P);
      Inc(C, (D shl 5 or D shr 27) + (B xor E xor A) + P^ + $6ED9EBA1); E := E shr 2 or E shl 30; Inc(P);
      Inc(B, (C shl 5 or C shr 27) + (A xor D xor E) + P^ + $6ED9EBA1); D := D shr 2 or D shl 30; Inc(P);
      Inc(A, (B shl 5 or B shr 27) + (E xor C xor D) + P^ + $6ED9EBA1); C := C shr 2 or C shl 30; Inc(P);
    end;

  for I := 0 to 3 do
    begin
      Inc(E, (A shl 5 or A shr 27) + ((B and C) or (D and (B or C))) + P^ + $8F1BBCDC); B := B shr 2 or B shl 30; Inc(P);
      Inc(D, (E shl 5 or E shr 27) + ((A and B) or (C and (A or B))) + P^ + $8F1BBCDC); A := A shr 2 or A shl 30; Inc(P);
      Inc(C, (D shl 5 or D shr 27) + ((E and A) or (B and (E or A))) + P^ + $8F1BBCDC); E := E shr 2 or E shl 30; Inc(P);
      Inc(B, (C shl 5 or C shr 27) + ((D and E) or (A and (D or E))) + P^ + $8F1BBCDC); D := D shr 2 or D shl 30; Inc(P);
      Inc(A, (B shl 5 or B shr 27) + ((C and D) or (E and (C or D))) + P^ + $8F1BBCDC); C := C shr 2 or C shl 30; Inc(P);
    end;

  for I := 0 to 3 do
    begin
      Inc(E, (A shl 5 or A shr 27) + (D xor B xor C) + P^ + $CA62C1D6); B := B shr 2 or B shl 30; Inc(P);
      Inc(D, (E shl 5 or E shr 27) + (C xor A xor B) + P^ + $CA62C1D6); A := A shr 2 or A shl 30; Inc(P);
      Inc(C, (D shl 5 or D shr 27) + (B xor E xor A) + P^ + $CA62C1D6); E := E shr 2 or E shl 30; Inc(P);
      Inc(B, (C shl 5 or C shr 27) + (A xor D xor E) + P^ + $CA62C1D6); D := D shr 2 or D shl 30; Inc(P);
      Inc(A, (B shl 5 or B shr 27) + (E xor C xor D) + P^ + $CA62C1D6); C := C shr 2 or C shl 30; Inc(P);
    end;

  Inc(Digest.Word32s[0], A);
  Inc(Digest.Word32s[1], B);
  Inc(Digest.Word32s[2], C);
  Inc(Digest.Word32s[3], D);
  Inc(Digest.Word32s[4], E);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}

procedure SHA1Buf(var Digest: T160BitDigest; const Buf; const BufSize: NativeInt);
var
  P : PByte;
  I, J : NativeInt;
begin
  I := BufSize;
  if I <= 0 then
    exit;
  Assert(I mod 64 = 0, 'BufSize must be multiple of 64 bytes');
  P := @Buf;
  for J := 0 to I div 64 - 1 do
    begin
      TransformSHABuffer(Digest, P^, True);
      Inc(P, 64);
    end;
end;

procedure SHA1FinalBuf(var Digest: T160BitDigest; const Buf; const BufSize: Int32; const TotalSize: Int64);
var B1, B2 : T512BitBuf;
    C : Int32;
begin
  StdFinalBuf512(Buf, BufSize, TotalSize, B1, B2, C, True);
  TransformSHABuffer(Digest, B1, True);
  if C > 1 then
    TransformSHABuffer(Digest, B2, True);
  SwapEndianBuf(Digest, Sizeof(Digest) div Sizeof(Word32));
  SecureClear512(B1);
  if C > 1 then
    SecureClear512(B2);
end;

function CalcSHA1(const Buf; const BufSize: NativeInt): T160BitDigest;
var
  I, J : NativeInt;
  P    : PByte;
begin
  SHA1InitDigest(Result);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 64) * 64;
  if J > 0 then
    begin
      SHA1Buf(Result, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  SHA1FinalBuf(Result, P^, I, BufSize);
end;

function CalcSHA1(const Buf: RawByteString): T160BitDigest;
begin
  Result := CalcSHA1(Pointer(Buf)^, Length(Buf));
end;

function SHA1DigestToStrA(const Digest: T160BitDigest): RawByteString;
begin
  SetLength(Result, Sizeof(Digest));
  Move(Digest, Pointer(Result)^, Sizeof(Digest));
end;

function SHA1DigestToHexA(const Digest: T160BitDigest): RawByteString;
begin
  Result := DigestToHexA(Digest, Sizeof(Digest));
end;

function SHA1DigestToHexU(const Digest: T160BitDigest): UnicodeString;
begin
  Result := DigestToHexU(Digest, Sizeof(Digest));
end;



{                                                                              }
{ SHA224 Hashing                                                               }
{                                                                              }
{ SHA-224 is identical to SHA-256, except that:                                }
{ - the initial variable values h0 through h7 are different, and               }
{ - the output is constructed by omitting h7                                   }
{                                                                              }
procedure SHA224InitDigest(var Digest: T256BitDigest);
begin
  // The second 32 bits of the fractional parts of the square roots of the 9th through 16th primes 23..53
  Digest.Word32s[0] := $c1059ed8;
  Digest.Word32s[1] := $367cd507;
  Digest.Word32s[2] := $3070dd17;
  Digest.Word32s[3] := $f70e5939;
  Digest.Word32s[4] := $ffc00b31;
  Digest.Word32s[5] := $68581511;
  Digest.Word32s[6] := $64f98fa7;
  Digest.Word32s[7] := $befa4fa4;
end;

procedure SHA224Buf(var Digest: T256BitDigest; const Buf; const BufSize: NativeInt);
begin
  SHA256Buf(Digest, Buf, BufSize);
end;

procedure SHA224FinalBuf(var Digest: T256BitDigest; const Buf; const BufSize: Int32; const TotalSize: Int64;
          var OutDigest: T224BitDigest);
begin
  SHA256FinalBuf(Digest, Buf, BufSize, TotalSize);
  Move(Digest.Word32s[0], OutDigest.Word32s[0], SizeOf(T224BitDigest));
end;

function CalcSHA224(const Buf; const BufSize: NativeInt): T224BitDigest;
var
  D    : T256BitDigest;
  I, J : NativeInt;
  P    : PByte;
begin
  SHA224InitDigest(D);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 64) * 64;
  if J > 0 then
    begin
      SHA224Buf(D, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  SHA224FinalBuf(D, P^, I, BufSize, Result);
end;

function CalcSHA224(const Buf: RawByteString): T224BitDigest;
begin
  Result := CalcSHA224(Pointer(Buf)^, Length(Buf));
end;

function SHA224DigestToStrA(const Digest: T224BitDigest): RawByteString;
begin
  SetLength(Result, Sizeof(Digest));
  Move(Digest, Pointer(Result)^, Sizeof(Digest));
end;

function SHA224DigestToHexA(const Digest: T224BitDigest): RawByteString;
begin
  Result := DigestToHexA(Digest, Sizeof(Digest));
end;

function  SHA224DigestToHexU(const Digest: T224BitDigest): UnicodeString;
begin
  Result := DigestToHexU(Digest, Sizeof(Digest));
end;



{                                                                              }
{ SHA256 hashing                                                               }
{                                                                              }
procedure SHA256InitDigest(var Digest: T256BitDigest);
begin
  Digest.Word32s[0] := $6a09e667;
  Digest.Word32s[1] := $bb67ae85;
  Digest.Word32s[2] := $3c6ef372;
  Digest.Word32s[3] := $a54ff53a;
  Digest.Word32s[4] := $510e527f;
  Digest.Word32s[5] := $9b05688c;
  Digest.Word32s[6] := $1f83d9ab;
  Digest.Word32s[7] := $5be0cd19;
end;

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}
function SHA256Transform1(const A: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := RotateRightBits(A, 7) xor RotateRightBits(A, 18) xor (A shr 3);
end;

function SHA256Transform2(const A: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := RotateRightBits(A, 17) xor RotateRightBits(A, 19) xor (A shr 10);
end;

function SHA256Transform3(const A: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := RotateRightBits(A, 2) xor RotateRightBits(A, 13) xor RotateRightBits(A, 22);
end;

function SHA256Transform4(const A: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := RotateRightBits(A, 6) xor RotateRightBits(A, 11) xor RotateRightBits(A, 25);
end;

const
  // first 32 bits of the fractional parts of the cube roots of the first 64 primes 2..311
  SHA256K: array[0..63] of Word32 = (
    $428a2f98, $71374491, $b5c0fbcf, $e9b5dba5, $3956c25b, $59f111f1, $923f82a4, $ab1c5ed5,
    $d807aa98, $12835b01, $243185be, $550c7dc3, $72be5d74, $80deb1fe, $9bdc06a7, $c19bf174,
    $e49b69c1, $efbe4786, $0fc19dc6, $240ca1cc, $2de92c6f, $4a7484aa, $5cb0a9dc, $76f988da,
    $983e5152, $a831c66d, $b00327c8, $bf597fc7, $c6e00bf3, $d5a79147, $06ca6351, $14292967,
    $27b70a85, $2e1b2138, $4d2c6dfc, $53380d13, $650a7354, $766a0abb, $81c2c92e, $92722c85,
    $a2bfe8a1, $a81a664b, $c24b8b70, $c76c51a3, $d192e819, $d6990624, $f40e3585, $106aa070,
    $19a4c116, $1e376c08, $2748774c, $34b0bcb5, $391c0cb3, $4ed8aa4a, $5b9cca4f, $682e6ff3,
    $748f82ee, $78a5636f, $84c87814, $8cc70208, $90befffa, $a4506ceb, $bef9a3f7, $c67178f2
  );

procedure TransformSHA256Buffer(var Digest: T256BitDigest; const Buf);
var
  I : Integer;
  W : array[0..63] of Word32;
  P : PWord32;
  S0, S1, Maj, T1, T2, Ch : Word32;
  H : array[0..7] of Word32;
begin
  P := @Buf;
  for I := 0 to 15 do
    begin
      W[I] := SwapEndian(P^);
      Inc(P);
    end;
  for I := 16 to 63 do
    begin
      S0 := SHA256Transform1(W[I - 15]);
      S1 := SHA256Transform2(W[I - 2]);
      W[I] := W[I - 16] + S0 + W[I - 7] + S1;
    end;
  for I := 0 to 7 do
    H[I] := Digest.Word32s[I];
  for I := 0 to 63 do
    begin
      S0 := SHA256Transform3(H[0]);
      Maj := (H[0] and H[1]) xor (H[0] and H[2]) xor (H[1] and H[2]);
      T2 := S0 + Maj;
      S1 := SHA256Transform4(H[4]);
      Ch := (H[4] and H[5]) xor ((not H[4]) and H[6]);
      T1 := H[7] + S1 + Ch + SHA256K[I] + W[I];
      H[7] := H[6];
      H[6] := H[5];
      H[5] := H[4];
      H[4] := H[3] + T1;
      H[3] := H[2];
      H[2] := H[1];
      H[1] := H[0];
      H[0] := T1 + T2;
    end;
  for I := 0 to 7 do
    Inc(Digest.Word32s[I], H[I]);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}

procedure SHA256Buf(var Digest: T256BitDigest; const Buf; const BufSize: NativeInt);
var
  P : PByte;
  I, J : NativeInt;
begin
  I := BufSize;
  if I <= 0 then
    exit;
  Assert(I mod 64 = 0, 'BufSize must be multiple of 64 bytes');
  P := @Buf;
  for J := 0 to I div 64 - 1 do
    begin
      TransformSHA256Buffer(Digest, P^);
      Inc(P, 64);
    end;
end;

procedure SHA256FinalBuf(var Digest: T256BitDigest; const Buf; const BufSize: Int32; const TotalSize: Int64);
var B1, B2 : T512BitBuf;
    C : Int32;
begin
  StdFinalBuf512(Buf, BufSize, TotalSize, B1, B2, C, True);
  TransformSHA256Buffer(Digest, B1);
  if C > 1 then
    TransformSHA256Buffer(Digest, B2);
  SwapEndianBuf(Digest, Sizeof(Digest) div Sizeof(Word32));
  SecureClear512(B1);
  if C > 1 then
    SecureClear512(B2);
end;

function CalcSHA256(const Buf; const BufSize: NativeInt): T256BitDigest;
var
  I, J : NativeInt;
  P    : PByte;
begin
  SHA256InitDigest(Result);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 64) * 64;
  if J > 0 then
    begin
      SHA256Buf(Result, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  SHA256FinalBuf(Result, P^, I, BufSize);
end;

function CalcSHA256(const Buf: RawByteString): T256BitDigest;
begin
  Result := CalcSHA256(Pointer(Buf)^, Length(Buf));
end;

function SHA256DigestToStrA(const Digest: T256BitDigest): RawByteString;
begin
  SetLength(Result, Sizeof(Digest));
  Move(Digest, Pointer(Result)^, Sizeof(Digest));
end;

function SHA256DigestToHexA(const Digest: T256BitDigest): RawByteString;
begin
  Result := DigestToHexA(Digest, Sizeof(Digest));
end;

function SHA256DigestToHexU(const Digest: T256BitDigest): UnicodeString;
begin
  Result := DigestToHexU(Digest, Sizeof(Digest));
end;



{                                                                              }
{ SHA384 Hashing                                                               }
{                                                                              }
procedure SHA384InitDigest(var Digest: T512BitDigest);
begin
  Word64Rec(Digest.Word64s[0]).Word32s[0] := $c1059ed8;
  Word64Rec(Digest.Word64s[0]).Word32s[1] := $cbbb9d5d;
  Word64Rec(Digest.Word64s[1]).Word32s[0] := $367cd507;
  Word64Rec(Digest.Word64s[1]).Word32s[1] := $629a292a;
  Word64Rec(Digest.Word64s[2]).Word32s[0] := $3070dd17;
  Word64Rec(Digest.Word64s[2]).Word32s[1] := $9159015a;
  Word64Rec(Digest.Word64s[3]).Word32s[0] := $f70e5939;
  Word64Rec(Digest.Word64s[3]).Word32s[1] := $152fecd8;
  Word64Rec(Digest.Word64s[4]).Word32s[0] := $ffc00b31;
  Word64Rec(Digest.Word64s[4]).Word32s[1] := $67332667;
  Word64Rec(Digest.Word64s[5]).Word32s[0] := $68581511;
  Word64Rec(Digest.Word64s[5]).Word32s[1] := $8eb44a87;
  Word64Rec(Digest.Word64s[6]).Word32s[0] := $64f98fa7;
  Word64Rec(Digest.Word64s[6]).Word32s[1] := $db0c2e0d;
  Word64Rec(Digest.Word64s[7]).Word32s[0] := $befa4fa4;
  Word64Rec(Digest.Word64s[7]).Word32s[1] := $47b5481d;
end;

procedure SHA384Buf(var Digest: T512BitDigest; const Buf; const BufSize: NativeInt);
begin
  SHA512Buf(Digest, Buf, BufSize);
end;

procedure SHA384FinalBuf(var Digest: T512BitDigest; const Buf; const BufSize: Int32; const TotalSize: Int64; var OutDigest: T384BitDigest);
begin
  SHA512FinalBuf(Digest, Buf, BufSize, TotalSize);
  Move(Digest, OutDigest, SizeOf(OutDigest));
end;

function CalcSHA384(const Buf; const BufSize: NativeInt): T384BitDigest;
var
  I, J : NativeInt;
  P    : PByte;
  D    : T512BitDigest;
begin
  SHA384InitDigest(D);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 128) * 128;
  if J > 0 then
    begin
      SHA384Buf(D, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  SHA384FinalBuf(D, P^, I, BufSize, Result);
end;

function CalcSHA384(const Buf: RawByteString): T384BitDigest;
begin
  Result := CalcSHA384(Pointer(Buf)^, Length(Buf));
end;

function SHA384DigestToStrA(const Digest: T384BitDigest): RawByteString;
begin
  SetLength(Result, Sizeof(Digest));
  Move(Digest, Pointer(Result)^, Sizeof(Digest));
end;

function SHA384DigestToHexA(const Digest: T384BitDigest): RawByteString;
begin
  Result := DigestToHexA(Digest, Sizeof(Digest));
end;

function SHA384DigestToHexU(const Digest: T384BitDigest): UnicodeString;
begin
  Result := DigestToHexU(Digest, Sizeof(Digest));
end;



{                                                                              }
{ SHA512 Hashing                                                               }
{                                                                              }
{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}
procedure SHA512InitDigest(var Digest: T512BitDigest);
begin
  Word64Rec(Digest.Word64s[0]).Word32s[0] := $f3bcc908;
  Word64Rec(Digest.Word64s[0]).Word32s[1] := $6a09e667;
  Word64Rec(Digest.Word64s[1]).Word32s[0] := $84caa73b;
  Word64Rec(Digest.Word64s[1]).Word32s[1] := $bb67ae85;
  Word64Rec(Digest.Word64s[2]).Word32s[0] := $fe94f82b;
  Word64Rec(Digest.Word64s[2]).Word32s[1] := $3c6ef372;
  Word64Rec(Digest.Word64s[3]).Word32s[0] := $5f1d36f1;
  Word64Rec(Digest.Word64s[3]).Word32s[1] := $a54ff53a;
  Word64Rec(Digest.Word64s[4]).Word32s[0] := $ade682d1;
  Word64Rec(Digest.Word64s[4]).Word32s[1] := $510e527f;
  Word64Rec(Digest.Word64s[5]).Word32s[0] := $2b3e6c1f;
  Word64Rec(Digest.Word64s[5]).Word32s[1] := $9b05688c;
  Word64Rec(Digest.Word64s[6]).Word32s[0] := $fb41bd6b;
  Word64Rec(Digest.Word64s[6]).Word32s[1] := $1f83d9ab;
  Word64Rec(Digest.Word64s[7]).Word32s[0] := $137e2179;
  Word64Rec(Digest.Word64s[7]).Word32s[1] := $5be0cd19;
end;

// BSIG0(x) = ROTR^28(x) XOR ROTR^34(x) XOR ROTR^39(x)
function SHA512Transform1(const A: Word64): Word64; {$IFDEF UseInline}inline;{$ENDIF}
var
  T1, T2, T3 : Word64;
begin
  T1 := A;
  T2 := A;
  T3 := A;
  Word64Ror(T1, 28);
  Word64Ror(T2, 34);
  Word64Ror(T3, 39);
  Word64XorWord64(T1, T2);
  Word64XorWord64(T1, T3);
  Result := T1;
end;

// BSIG1(x) = ROTR^14(x) XOR ROTR^18(x) XOR ROTR^41(x)
function SHA512Transform2(const A: Word64): Word64; {$IFDEF UseInline}inline;{$ENDIF}
var
  T1, T2, T3 : Word64;
begin
  T1 := A;
  T2 := A;
  T3 := A;
  Word64Ror(T1, 14);
  Word64Ror(T2, 18);
  Word64Ror(T3, 41);
  Word64XorWord64(T1, T2);
  Word64XorWord64(T1, T3);
  Result := T1;
end;

// SSIG0(x) = ROTR^1(x) XOR ROTR^8(x) XOR SHR^7(x)
function SHA512Transform3(const A: Word64): Word64; {$IFDEF UseInline}inline;{$ENDIF}
var
  T1, T2, T3 : Word64;
begin
  T1 := A;
  T2 := A;
  T3 := A;
  Word64Ror(T1, 1);
  Word64Ror(T2, 8);
  Word64Shr(T3, 7);
  Word64XorWord64(T1, T2);
  Word64XorWord64(T1, T3);
  Result := T1;
end;

// SSIG1(x) = ROTR^19(x) XOR ROTR^61(x) XOR SHR^6(x)
function SHA512Transform4(const A: Word64): Word64; {$IFDEF UseInline}inline;{$ENDIF}
var
  T1, T2, T3 : Word64;
begin
  T1 := A;
  T2 := A;
  T3 := A;
  Word64Ror(T1, 19);
  Word64Ror(T2, 61);
  Word64Shr(T3, 6);
  Word64XorWord64(T1, T2);
  Word64XorWord64(T1, T3);
  Result := T1;
end;

// CH( x, y, z) = (x AND y) XOR ( (NOT x) AND z)
function SHA512Transform5(const X, Y, Z: Word64): Word64; {$IFDEF UseInline}inline;{$ENDIF}
var
  T1, T2 : Word64;
begin
  T1 := X;
  Word64AndWord64(T1, Y);
  T2 := X;
  Word64Not(T2);
  Word64AndWord64(T2, Z);
  Word64XorWord64(T1, T2);
  Result := T1;
end;

// MAJ( x, y, z) = (x AND y) XOR (x AND z) XOR (y AND z)
function SHA512Transform6(const X, Y, Z: Word64): Word64; {$IFDEF UseInline}inline;{$ENDIF}
var
  T1, T2, T3 : Word64;
begin
  T1 := X;
  Word64AndWord64(T1, Y);
  T2 := X;
  Word64AndWord64(T2, Z);
  T3 := Y;
  Word64AndWord64(T3, Z);
  Word64XorWord64(T1, T2);
  Word64XorWord64(T1, T3);
  Result := T1;
end;

const
  // first 64 bits of the fractional parts of the cube roots of the first eighty prime numbers
  // (stored High Word32 first then Low Word32)
  SHA512K: array[0..159] of Word32 = (
    $428a2f98, $d728ae22, $71374491, $23ef65cd, $b5c0fbcf, $ec4d3b2f, $e9b5dba5, $8189dbbc,
    $3956c25b, $f348b538, $59f111f1, $b605d019, $923f82a4, $af194f9b, $ab1c5ed5, $da6d8118,
    $d807aa98, $a3030242, $12835b01, $45706fbe, $243185be, $4ee4b28c, $550c7dc3, $d5ffb4e2,
    $72be5d74, $f27b896f, $80deb1fe, $3b1696b1, $9bdc06a7, $25c71235, $c19bf174, $cf692694,
    $e49b69c1, $9ef14ad2, $efbe4786, $384f25e3, $0fc19dc6, $8b8cd5b5, $240ca1cc, $77ac9c65,
    $2de92c6f, $592b0275, $4a7484aa, $6ea6e483, $5cb0a9dc, $bd41fbd4, $76f988da, $831153b5,
    $983e5152, $ee66dfab, $a831c66d, $2db43210, $b00327c8, $98fb213f, $bf597fc7, $beef0ee4,
    $c6e00bf3, $3da88fc2, $d5a79147, $930aa725, $06ca6351, $e003826f, $14292967, $0a0e6e70,
    $27b70a85, $46d22ffc, $2e1b2138, $5c26c926, $4d2c6dfc, $5ac42aed, $53380d13, $9d95b3df,
    $650a7354, $8baf63de, $766a0abb, $3c77b2a8, $81c2c92e, $47edaee6, $92722c85, $1482353b,
    $a2bfe8a1, $4cf10364, $a81a664b, $bc423001, $c24b8b70, $d0f89791, $c76c51a3, $0654be30,
    $d192e819, $d6ef5218, $d6990624, $5565a910, $f40e3585, $5771202a, $106aa070, $32bbd1b8,
    $19a4c116, $b8d2d0c8, $1e376c08, $5141ab53, $2748774c, $df8eeb99, $34b0bcb5, $e19b48a8,
    $391c0cb3, $c5c95a63, $4ed8aa4a, $e3418acb, $5b9cca4f, $7763e373, $682e6ff3, $d6b2b8a3,
    $748f82ee, $5defb2fc, $78a5636f, $43172f60, $84c87814, $a1f0ab72, $8cc70208, $1a6439ec,
    $90befffa, $23631e28, $a4506ceb, $de82bde9, $bef9a3f7, $b2c67915, $c67178f2, $e372532b,
    $ca273ece, $ea26619c, $d186b8c7, $21c0c207, $eada7dd6, $cde0eb1e, $f57d4f7f, $ee6ed178,
    $06f067aa, $72176fba, $0a637dc5, $a2c898a6, $113f9804, $bef90dae, $1b710b35, $131c471b,
    $28db77f5, $23047d84, $32caab7b, $40c72493, $3c9ebe0a, $15c9bebc, $431d67c4, $9c100d4c,
    $4cc5d4be, $cb3e42b6, $597f299c, $fc657e2a, $5fcb6fab, $3ad6faec, $6c44198c, $4a475817
    );

procedure TransformSHA512Buffer(var Digest: T512BitDigest; const Buf);
var
  I : Integer;
  P : PWord64;
  W : array[0..79] of Word64;
  T1, T2, T3, T4, K : Word64;
  H : array[0..7] of Word64;
begin
  P := @Buf;
  for I := 0 to 15 do
    begin
      W[I] := P^;
      Word64SwapEndian(W[I]);
      Inc(P);
    end;
  for I := 16 to 79 do
    begin
      T1 := SHA512Transform4(W[I - 2]);
      T2 := W[I - 7];
      T3 := SHA512Transform3(W[I - 15]);  // bug in RFC (specifies I-15 instead of W[I-15])
      T4 := W[I - 16];
      Word64AddWord64(T1, T2);
      Word64AddWord64(T1, T3);
      Word64AddWord64(T1, T4);
      W[I] := T1;
    end;
  for I := 0 to 7 do
    H[I] := Digest.Word64s[I];
  for I := 0 to 79 do
    begin
      // T1 = h + BSIG1(e) + CH(e,f,g) + Kt + Wt
      T1 := H[7];
      Word64AddWord64(T1, SHA512Transform2(H[4]));
      Word64AddWord64(T1, SHA512Transform5(H[4], H[5], H[6]));
      Word64Rec(K).Word32s[0] := SHA512K[I * 2 + 1];
      Word64Rec(K).Word32s[1] := SHA512K[I * 2];
      Word64AddWord64(T1, K);
      Word64AddWord64(T1, W[I]);
      // T2 = BSIG0(a) + MAJ(a,b,c)
      T2 := SHA512Transform1(H[0]);
      Word64AddWord64(T2, SHA512Transform6(H[0], H[1], H[2]));
      // h = g    g = f
      // f = e    e = d + T1
      // d = c    c = b
      // b = a    a = T1 + T2
      H[7] := H[6];
      H[6] := H[5];
      H[5] := H[4];
      H[4] := H[3];
      Word64AddWord64(H[4], T1);
      H[3] := H[2];
      H[2] := H[1];
      H[1] := H[0];
      H[0] := T1;
      Word64AddWord64(H[0], T2);
    end;
  for I := 0 to 7 do
    Word64AddWord64(Digest.Word64s[I], H[I]);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}

procedure SHA512Buf(var Digest: T512BitDigest; const Buf; const BufSize: NativeInt);
var
  P : PByte;
  I, J : NativeInt;
begin
  I := BufSize;
  if I <= 0 then
    exit;
  Assert(I mod 128 = 0, 'BufSize must be multiple of 128 bytes');
  P := @Buf;
  for J := 0 to I div 128 - 1 do
    begin
      TransformSHA512Buffer(Digest, P^);
      Inc(P, 128);
    end;
end;

procedure SHA512FinalBuf(var Digest: T512BitDigest; const Buf; const BufSize: Int32; const TotalSize: Int64);
var
  B1, B2 : T1024BitBuf;
  C : Int32;
begin
  StdFinalBuf1024(Buf, BufSize, TotalSize, B1, B2, C, True);
  TransformSHA512Buffer(Digest, B1);
  if C > 1 then
    TransformSHA512Buffer(Digest, B2);
  SwapEndianBuf64(Digest, Sizeof(Digest) div Sizeof(Word64));
  SecureClear1024(B1);
  if C > 1 then
    SecureClear1024(B2);
end;

function CalcSHA512(const Buf; const BufSize: NativeInt): T512BitDigest;
var
  I, J : NativeInt;
  P    : PByte;
begin
  SHA512InitDigest(Result);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 128) * 128;
  if J > 0 then
    begin
      SHA512Buf(Result, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  SHA512FinalBuf(Result, P^, I, BufSize);
end;

function CalcSHA512(const Buf: RawByteString): T512BitDigest;
begin
  Result := CalcSHA512(Pointer(Buf)^, Length(Buf));
end;

function SHA512DigestToStrA(const Digest: T512BitDigest): RawByteString;
begin
  SetLength(Result, Sizeof(Digest));
  Move(Digest, Pointer(Result)^, Sizeof(Digest));
end;

function SHA512DigestToHexA(const Digest: T512BitDigest): RawByteString;
begin
  Result := DigestToHexA(Digest, Sizeof(Digest));
end;

function SHA512DigestToHexU(const Digest: T512BitDigest): UnicodeString;
begin
  Result := DigestToHexU(Digest, Sizeof(Digest));
end;



{                                                                              }
{ RIPEMD160                                                                    }
{   160 bit RIPEMD.                                                            }
{                                                                              }

{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
{$IFOPT R+}{$DEFINE ROn}{$R-}{$ELSE}{$UNDEF ROn}{$ENDIF}

// f(j, x, y, z) = x XOR y XOR z                (0 <= j <= 15)
function RipeMD_F1(const X, Y, Z: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := X xor Y xor Z;
end;

// f(j, x, y, z) = (x AND y) OR (NOT(x) AND z)  (16 <= j <= 31)
function RipeMD_F2(const X, Y, Z: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := (X and Y) or ((not X) and Z);
end;

// f(j, x, y, z) = (x OR NOT(y)) XOR z          (32 <= j <= 47)
function RipeMD_F3(const X, Y, Z: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := (X or (not Y)) xor Z;
end;

// f(j, x, y, z) = (x AND z) OR (y AND NOT(z))  (48 <= j <= 63)
function RipeMD_F4(const X, Y, Z: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := (X and Z) or (Y and (not Z));
end;

// f(j, x, y, z) = x XOR (y OR NOT(z))          (64 <= j <= 79)
function RipeMD_F5(const X, Y, Z: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := X xor (Y or (not Z));
end;

// f(j, x, y, z)
function RipeMD_F(const J: Byte; const X, Y, Z: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Assert(J < 80);
  case J shr 4 of
    0 : Result := RipeMD_F1(X, Y, Z);
    1 : Result := RipeMD_F2(X, Y, Z);
    2 : Result := RipeMD_F3(X, Y, Z);
    3 : Result := RipeMD_F4(X, Y, Z);
  else
    {4 :} Result := RipeMD_F5(X, Y, Z);
  end;
end;

const
  // K(j) = 0x00000000      (0 <= j <= 15)
  // K(j) = 0x5A827999     (16 <= j <= 31)      int(2**30 x sqrt(2))
  // K(j) = 0x6ED9EBA1     (32 <= j <= 47)      int(2**30 x sqrt(3))
  // K(j) = 0x8F1BBCDC     (48 <= j <= 63)      int(2**30 x sqrt(5))
  // K(j) = 0xA953FD4E     (64 <= j <= 79)      int(2**30 x sqrt(7))
  RipeMD_K : array[0..4] of Word32 = (
      $00000000,
      $5A827999,
      $6ED9EBA1,
      $8F1BBCDC,
      $A953FD4E );

  // K'(j) = 0x50A28BE6     (0 <= j <= 15)      int(2**30 x cbrt(2))
  // K'(j) = 0x5C4DD124    (16 <= j <= 31)      int(2**30 x cbrt(3))
  // K'(j) = 0x6D703EF3    (32 <= j <= 47)      int(2**30 x cbrt(5))
  // K'(j) = 0x7A6D76E9    (48 <= j <= 63)      int(2**30 x cbrt(7))
  // K'(j) = 0x00000000    (64 <= j <= 79)
  RipeMD_KP : array[0..4] of Word32 = (
      $50A28BE6,
      $5C4DD124,
      $6D703EF3,
      $7A6D76E9,
      $00000000 );

  // r(j)      = j                    (0 <= j <= 15)
  // r(16..31) = 7, 4, 13, 1, 10, 6, 15, 3, 12, 0, 9, 5, 2, 14, 11, 8
  // r(32..47) = 3, 10, 14, 4, 9, 15, 8, 1, 2, 7, 0, 6, 13, 11, 5, 12
  // r(48..63) = 1, 9, 11, 10, 0, 8, 12, 4, 13, 3, 7, 15, 14, 5, 6, 2
  // r(64..79) = 4, 0, 5, 9, 7, 12, 2, 10, 14, 1, 3, 8, 11, 6, 15, 13
  RipeMD_R : array[0..79] of Byte = (
      0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
      7,  4, 13,  1, 10,  6, 15,  3, 12,  0,  9,  5,  2, 14, 11,  8,
      3, 10, 14,  4,  9, 15,  8,  1,  2,  7,  0,  6, 13, 11,  5, 12,
      1,  9, 11, 10,  0,  8, 12,  4, 13,  3,  7, 15, 14,  5,  6,  2,
      4,  0,  5,  9,  7, 12,  2, 10, 14,  1,  3,  8, 11,  6, 15, 13 );

  // r'(0..15) = 5, 14, 7, 0, 9, 2, 11, 4, 13, 6, 15, 8, 1, 10, 3, 12
  // r'(16..31)= 6, 11, 3, 7, 0, 13, 5, 10, 14, 15, 8, 12, 4, 9, 1, 2
  // r'(32..47)= 15, 5, 1, 3, 7, 14, 6, 9, 11, 8, 12, 2, 10, 0, 4, 13
  // r'(48..63)= 8, 6, 4, 1, 3, 11, 15, 0, 5, 12, 2, 13, 9, 7, 10, 14
  // r'(64..79)= 12, 15, 10, 4, 1, 5, 8, 7, 6, 2, 13, 14, 0, 3, 9, 11
  RipeMD_RP : array[0..79] of Byte = (
       5, 14,  7,  0,  9,  2, 11,  4, 13,  6, 15, 8,  1, 10,  3, 12,
       6, 11,  3,  7,  0, 13,  5, 10, 14, 15,  8, 12, 4,  9,  1,  2,
      15,  5,  1,  3,  7, 14,  6,  9, 11,  8, 12, 2, 10,  0,  4, 13,
       8,  6,  4,  1,  3, 11, 15,  0,  5, 12,  2, 13, 9,  7, 10, 14,
      12, 15, 10,  4,  1,  5,  8,  7,  6,  2, 13, 14, 0,  3,  9, 11 );

  // s(0..15)  = 11, 14, 15, 12, 5, 8, 7, 9, 11, 13, 14, 15, 6, 7, 9, 8
  // s(16..31) = 7, 6, 8, 13, 11, 9, 7, 15, 7, 12, 15, 9, 11, 7, 13, 12
  // s(32..47) = 11, 13, 6, 7, 14, 9, 13, 15, 14, 8, 13, 6, 5, 12, 7, 5
  // s(48..63) = 11, 12, 14, 15, 14, 15, 9, 8, 9, 14, 5, 6, 8, 6, 5, 12
  // s(64..79) = 9, 15, 5, 11, 6, 8, 13, 12, 5, 12, 13, 14, 11, 8, 5, 6
  RipeMD_S : array[0..79] of Byte = (
      11, 14, 15, 12,  5,  8,  7,  9, 11, 13, 14, 15,  6,  7,  9,  8,
       7,  6,  8, 13, 11,  9,  7, 15,  7, 12, 15,  9, 11,  7, 13, 12,
      11, 13,  6,  7, 14,  9, 13, 15, 14,  8, 13,  6,  5, 12,  7,  5,
      11, 12, 14, 15, 14, 15,  9,  8,  9, 14,  5,  6,  8,  6,  5, 12,
       9, 15,  5, 11,  6,  8, 13, 12,  5, 12, 13, 14, 11,  8,  5,  6 );

  // s'(0..15) = 8, 9, 9, 11, 13, 15, 15, 5, 7, 7, 8, 11, 14, 14, 12, 6
  // s'(16..31)= 9, 13, 15, 7, 12, 8, 9, 11, 7, 7, 12, 7, 6, 15, 13, 11
  // s'(32..47)= 9, 7, 15, 11, 8, 6, 6, 14, 12, 13, 5, 14, 13, 13, 7, 5
  // s'(48..63)= 15, 5, 8, 11, 14, 14, 6, 14, 6, 9, 12, 9, 12, 5, 15, 8
  // s'(64..79)= 8, 5, 12, 9, 12, 5, 14, 6, 8, 13, 6, 5, 15, 13, 11, 11
  RipeMD_SP : array[0..79] of Byte = (
       8,  9,  9, 11, 13, 15, 15,  5,  7,  7,  8, 11, 14, 14, 12,  6,
       9, 13, 15,  7, 12,  8,  9, 11,  7,  7, 12,  7,  6, 15, 13, 11,
       9,  7, 15, 11,  8,  6,  6, 14, 12, 13,  5, 14, 13, 13,  7,  5,
      15,  5,  8, 11, 14, 14,  6, 14,  6,  9, 12,  9, 12,  5, 15,  8,
       8,  5, 12,  9, 12,  5, 14,  6,  8, 13,  6,  5, 15, 13, 11, 11 );

function Word32Add(const A, B: Word32): Word32; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := Word32(A + B);
end;

type
  TRipeMD160Block = array[0..15] of Word32;
  PRipeMD160Block = ^TRipeMD160Block;

(*
    It is assumed that the message after padding consists of t 16-word blocks
    that will be denoted with X[i][j], with 0 <= i <= t-1 and 0 <= j <= 15.
    The symbol [+] denotes addition modulo 2**32 and rol_s denotes cyclic left
    shift (rotate) over s positions.
    A := h0; B := h1; C := h2; D = h3; E = h4;
    A' := h0; B' := h1; C' := h2; D' = h3; E' = h4;
    for j := 0 to 79 {
        T := rol_s(j)(A [+] f(j, B, C, D) [+] X[i][r(j)] [+] K(j)) [+] E;
        A := E; E := D; D := rol_10(C); C := B; B := T;
        T := rol_s'(j)(A' [+] f(79-j, B', C', D') [+] X[i][r'(j)] [+] K'(j)) [+] E';
        A' := E'; E' := D'; D' := rol_10(C'); C' := B'; B' := T;
    }
    T := h1 [+] C [+] D'; h1 := h2 [+] D [+] E'; h2 := h3 [+] E [+] A';
    h3 := h4 [+] A [+] B'; h4 := h0 [+] B [+] C'; h0 := T;
*)
procedure RipeMD160Block(var Digest: T160BitDigest; const Block: TRipeMD160Block);
var
  H0, H1, H2, H3, H4 : Word32;
  A, B, C, D, E : Word32;
  AP, BP, CP, DP, EP : Word32;
  J, J16 : Byte;
  T : Word32;
begin
  H0 := Digest.Word32s[0];
  H1 := Digest.Word32s[1];
  H2 := Digest.Word32s[2];
  H3 := Digest.Word32s[3];
  H4 := Digest.Word32s[4];

  // A := h0; B := h1; C := h2; D = h3; E = h4;
  A := H0;
  B := H1;
  C := H2;
  D := H3;
  E := H4;

  // A' := h0; B' := h1; C' := h2; D' = h3; E' = h4;
  AP := H0;
  BP := H1;
  CP := H2;
  DP := H3;
  EP := H4;

  for J := 0 to 79 do
    begin
      J16 := J shr 4;
      // T := rol_s(j)(A [+] f(j, B, C, D) [+] X[i][r(j)] [+] K(j)) [+] E;
      T := Word32Add(A, RipeMD_F(J, B, C, D));
      T := Word32Add(T, Block[RipeMD_R[J]]);
      T := Word32Add(T, RipeMD_K[J16]);
      T := RotateLeftBits(T, RipeMD_S[J]);
      T := Word32Add(T, E);
      // A := E; E := D; D := rol_10(C); C := B; B := T;
      A := E;
      E := D;
      D := RotateLeftBits(C, 10);
      C := B;
      B := T;
      // T := rol_s'(j)(A' [+] f(79-j, B', C', D') [+] X[i][r'(j)] [+] K'(j)) [+] E';
      T := Word32Add(AP, RipeMD_F(79 - J, BP, CP, DP));
      T := Word32Add(T, Block[RipeMD_RP[J]]);
      T := Word32Add(T, RipeMD_KP[J16]);
      T := RotateLeftBits(T, RipeMD_SP[J]);
      T := Word32Add(T, EP);
      // A' := E'; E' := D'; D' := rol_10(C'); C' := B'; B' := T;
      AP := EP;
      EP := DP;
      DP := RotateLeftBits(CP, 10);
      CP := BP;
      BP := T;
    end;

  // T := h1 [+] C [+] D';
  T := Word32Add(H1, C);
  T := Word32Add(T, DP);
  // h1 := h2 [+] D [+] E';
  H1 := Word32Add(H2, D);
  H1 := Word32Add(H1, EP);
  // h2 := h3 [+] E [+] A';
  H2 := Word32Add(H3, E);
  H2 := Word32Add(H2, AP);
  // h3 := h4 [+] A [+] B';
  H3 := Word32Add(H4, A);
  H3 := Word32Add(H3, BP);
  // h4 := h0 [+] B [+] C';
  H4 := Word32Add(H0, B);
  H4 := Word32Add(H4, CP);
  // h0 := T;
  H0 := T;

  Digest.Word32s[0] := H0;
  Digest.Word32s[1] := H1;
  Digest.Word32s[2] := H2;
  Digest.Word32s[3] := H3;
  Digest.Word32s[4] := H4;
end;
{$IFDEF QOn}{$Q+}{$ENDIF}
{$IFDEF ROn}{$R+}{$ENDIF}

// initial value (hexadecimal)
// h0 = 0x67452301; h1 = 0xEFCDAB89; h2 = 0x98BADCFE; h3 = 0x10325476; h4 = 0xC3D2E1F0;
procedure RipeMD160InitDigest(var Digest: T160BitDigest);
begin
  Digest.Word32s[0] := $67452301;
  Digest.Word32s[1] := $EFCDAB89;
  Digest.Word32s[2] := $98BADCFE;
  Digest.Word32s[3] := $10325476;
  Digest.Word32s[4] := $C3D2E1F0;
end;

procedure RipeMD160Buf(
          var Digest: T160BitDigest;
          const Buf; const BufSize: NativeInt);
var
  P : PRipeMD160Block;
  I, J : NativeInt;
begin
  I := BufSize;
  if I <= 0 then
    exit;
  Assert(I mod 64 = 0, 'BufSize must be multiple of 64 bytes');
  P := @Buf;
  for J := 0 to I div 64 - 1 do
    begin
      RipeMD160Block(Digest, P^);
      Inc(P);
    end;
end;

procedure RipeMD160FinalBuf(
          var Digest: T160BitDigest;
          const Buf; const BufSize: Int32;
          const TotalSize: Int64);
var
  B1, B2 : T512BitBuf;
  C : Int32;
begin
  StdFinalBuf512(Buf, BufSize, TotalSize, B1, B2, C, False);
  RipeMD160Block(Digest, PRipeMD160Block(@B1)^);
  if C > 1 then
    RipeMD160Block(Digest, PRipeMD160Block(@B2)^);
  SecureClear512(B1);
  if C > 1 then
    SecureClear512(B2);
end;

function CalcRipeMD160(const Buf; const BufSize: NativeInt): T160BitDigest;
var
  I, J : NativeInt;
  P    : PByte;
begin
  RipeMD160InitDigest(Result);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 64) * 64;
  if J > 0 then
    begin
      RipeMD160Buf(Result, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  RipeMD160FinalBuf(Result, P^, I, BufSize);
end;

function CalcRipeMD160(const Buf: RawByteString): T160BitDigest;
begin
  Result := CalcRipeMD160(Pointer(Buf)^, Length(Buf));
end;

function RipeMD160DigestToStrA(const Digest: T160BitDigest): RawByteString;
begin
  SetLength(Result, Sizeof(Digest));
  Move(Digest, Pointer(Result)^, Sizeof(Digest));
end;

function RipeMD160DigestToHexA(const Digest: T160BitDigest): RawByteString;
begin
  Result := DigestToHexA(Digest, Sizeof(Digest));
end;

function RipeMD160DigestToHexU(const Digest: T160BitDigest): UnicodeString;
begin
  Result := DigestToHexU(Digest, Sizeof(Digest));
end;



{                                                                              }
{ HMAC utility functions                                                       }
{                                                                              }
procedure HMAC_KeyBlock512(const Key; const KeySize: Integer; var Buf: T512BitBuf);
var
  P : PByte;
begin
  Assert(KeySize <= 64);
  P := @Buf;
  if KeySize > 0 then
    begin
      Move(Key, P^, KeySize);
      Inc(P, KeySize);
    end;
  FillChar(P^, 64 - KeySize, #0);
end;

procedure HMAC_KeyBlock1024(const Key; const KeySize: Integer; var Buf: T1024BitBuf);
var
  P : PByte;
begin
  Assert(KeySize <= 128);
  P := @Buf;
  if KeySize > 0 then
    begin
      Move(Key, P^, KeySize);
      Inc(P, KeySize);
    end;
  FillChar(P^, 128 - KeySize, #0);
end;

procedure XORBlock512(var Buf: T512BitBuf; const XOR8: Byte);
var
  I : Integer;
  P : PByte;
begin
  P := @Buf;
  for I := 0 to SizeOf(Buf) - 1 do
    begin
      P^ := P^ xor XOR8;
      Inc(P);
    end;
end;

procedure XORBlock1024(var Buf: T1024BitBuf; const XOR8: Byte);
var
  I : Integer;
  P : PByte;
begin
  P := @Buf;
  for I := 0 to SizeOf(Buf) - 1 do
    begin
      P^ := P^ xor XOR8;
      Inc(P);
    end;
end;



{                                                                              }
{ HMAC-MD5 keyed hashing                                                       }
{                                                                              }
procedure HMAC_MD5Init(
          const Key: Pointer; const KeySize: Int32;
          var Digest: T128BitDigest;
          var K: T512BitBuf);
var
  S : T512BitBuf;
  D : T128BitDigest;
begin
  MD5InitDigest(Digest);

  if KeySize > 64 then
    begin
      D := CalcMD5(Key^, KeySize);
      HMAC_KeyBlock512(D, Sizeof(D), K);
    end else
    HMAC_KeyBlock512(Key^, KeySize, K);

  Move(K, S, SizeOf(K));
  XORBlock512(S, $36);
  TransformMD5Buffer(Digest, S);
  SecureClear512(S);
end;

procedure HMAC_MD5Buf(
          var Digest: T128BitDigest;
          const Buf; const BufSize: NativeInt);
begin
  MD5Buf(Digest, Buf, BufSize);
end;

procedure HMAC_MD5FinalBuf(
          const K: T512BitBuf;
          var Digest: T128BitDigest;
          const Buf; const BufSize: Int32;
          const TotalSize: Int64);
var
  FinBuf : packed record
    K : T512BitBuf;
    D : T128BitDigest;
  end;
begin
  MD5FinalBuf(Digest, Buf, BufSize, TotalSize + 64);
  Move(K, FinBuf.K, SizeOf(K));
  XORBlock512(FinBuf.K, $5C);
  Move(Digest, FinBuf.D, SizeOf(Digest));
  Digest := CalcMD5(FinBuf, SizeOf(FinBuf));
  SecureClearBuf(FinBuf, SizeOf(FinBuf));
end;

function CalcHMAC_MD5(
         const Key: Pointer; const KeySize: Int32;
         const Buf; const BufSize: NativeInt): T128BitDigest;
var
  I, J : NativeInt;
  P    : PByte;
  K    : T512BitBuf;
begin
  HMAC_MD5Init(Key, KeySize, Result, K);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 64) * 64;
  if J > 0 then
    begin
      HMAC_MD5Buf(Result, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  HMAC_MD5FinalBuf(K, Result, P^, I, BufSize);
  SecureClear512(K);
end;

function CalcHMAC_MD5(
         const Key: RawByteString;
         const Buf; const BufSize: NativeInt): T128BitDigest;
begin
  Result := CalcHMAC_MD5(Pointer(Key), Length(Key), Buf, BufSize);
end;

function CalcHMAC_MD5(const Key, Buf: RawByteString): T128BitDigest;
begin
  Result := CalcHMAC_MD5(Key, Pointer(Buf)^, Length(Buf));
end;



{                                                                              }
{ HMAC-SHA1 keyed hashing                                                      }
{                                                                              }
procedure HMAC_SHA1Init(
          const Key: Pointer; const KeySize: Int32;
          var Digest: T160BitDigest; var K: T512BitBuf);
var
  D : T160BitDigest;
  S : T512BitBuf;
begin
  SHA1InitDigest(Digest);

  if KeySize > 64 then
    begin
      D := CalcSHA1(Key^, KeySize);
      HMAC_KeyBlock512(D, Sizeof(D), K);
    end else
    HMAC_KeyBlock512(Key^, KeySize, K);

  Move(K, S, SizeOf(K));
  XORBlock512(S, $36);
  TransformSHABuffer(Digest, S, True);
  SecureClear512(S);
end;

procedure HMAC_SHA1Buf(
          var Digest: T160BitDigest;
          const Buf; const BufSize: NativeInt);
begin
  SHA1Buf(Digest, Buf, BufSize);
end;

procedure HMAC_SHA1FinalBuf(
          const K: T512BitBuf;
          var Digest: T160BitDigest;
          const Buf; const BufSize: Int32;
          const TotalSize: Int64);
var
  FinBuf : packed record
    K : T512BitBuf;
    D : T160BitDigest;
  end;
begin
  SHA1FinalBuf(Digest, Buf, BufSize, TotalSize + 64);
  Move(K, FinBuf.K, SizeOf(K));
  XORBlock512(FinBuf.K, $5C);
  Move(Digest, FinBuf.D, SizeOf(Digest));
  Digest := CalcSHA1(FinBuf, SizeOf(FinBuf));
  SecureClearBuf(FinBuf, SizeOf(FinBuf));
end;

function CalcHMAC_SHA1(
         const Key: Pointer; const KeySize: Int32;
         const Buf; const BufSize: NativeInt): T160BitDigest;
var
  I, J : NativeInt;
  P    : PByte;
  K    : T512BitBuf;
begin
  HMAC_SHA1Init(Key, KeySize, Result, K);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 64) * 64;
  if J > 0 then
    begin
      HMAC_SHA1Buf(Result, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  HMAC_SHA1FinalBuf(K, Result, P^, I, BufSize);
  SecureClear512(K);
end;

function CalcHMAC_SHA1(
         const Key: RawByteString;
         const Buf; const BufSize: NativeInt): T160BitDigest;
begin
  Result := CalcHMAC_SHA1(Pointer(Key), Length(Key), Buf, BufSize);
end;

function CalcHMAC_SHA1(const Key, Buf: RawByteString): T160BitDigest;
begin
  Result := CalcHMAC_SHA1(Key, Pointer(Buf)^, Length(Buf));
end;



{                                                                              }
{ HMAC-SHA256 keyed hashing                                                    }
{                                                                              }
procedure HMAC_SHA256Init(
          const Key: Pointer; const KeySize: Int32;
          var Digest: T256BitDigest;
          var K: T512BitBuf);
var
  D : T256BitDigest;
  S : T512BitBuf;
begin
  SHA256InitDigest(Digest);

  if KeySize > 64 then
    begin
      D := CalcSHA256(Key^, KeySize);
      HMAC_KeyBlock512(D, Sizeof(D), K);
    end
  else
    HMAC_KeyBlock512(Key^, KeySize, K);

  Move(K, S, SizeOf(K));
  XORBlock512(S, $36);
  TransformSHA256Buffer(Digest, S);
  SecureClear512(S);
end;

procedure HMAC_SHA256Buf(
          var Digest: T256BitDigest;
          const Buf; const BufSize: NativeInt);
begin
  SHA256Buf(Digest, Buf, BufSize);
end;

procedure HMAC_SHA256FinalBuf(
          const K: T512BitBuf;
          var Digest: T256BitDigest;
          const Buf; const BufSize: Int32; const TotalSize: Int64);
var
  FinBuf : packed record
    K : T512BitBuf;
    D : T256BitDigest;
  end;
begin
  SHA256FinalBuf(Digest, Buf, BufSize, TotalSize + 64);
  Move(K, FinBuf.K, SizeOf(K));
  XORBlock512(FinBuf.K, $5C);
  Move(Digest, FinBuf.D, SizeOf(Digest));
  Digest := CalcSHA256(FinBuf, SizeOf(FinBuf));
  SecureClearBuf(FinBuf, SizeOf(FinBuf));
end;

function CalcHMAC_SHA256(const
         Key: Pointer; const KeySize: Int32;
         const Buf; const BufSize: NativeInt): T256BitDigest;
var
  I, J : NativeInt;
  P    : PByte;
  K    : T512BitBuf;
begin
  HMAC_SHA256Init(Key, KeySize, Result, K);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 64) * 64;
  if J > 0 then
    begin
      HMAC_SHA256Buf(Result, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  HMAC_SHA256FinalBuf(K, Result, P^, I, BufSize);
  SecureClear512(K);
end;

function CalcHMAC_SHA256(
         const Key: RawByteString;
         const Buf; const BufSize: NativeInt): T256BitDigest;
begin
  Result := CalcHMAC_SHA256(Pointer(Key), Length(Key), Buf, BufSize);
end;

function CalcHMAC_SHA256(
         const Key, Buf: RawByteString): T256BitDigest;
begin
  Result := CalcHMAC_SHA256(Key, Pointer(Buf)^, Length(Buf));
end;



{                                                                              }
{ HMAC-SHA512 keyed hashing                                                    }
{                                                                              }
procedure HMAC_SHA512Init(
          const Key: Pointer; const KeySize: Int32;
          var Digest: T512BitDigest;
          var K: T1024BitBuf);
var
  D : T512BitDigest;
  S : T1024BitBuf;
begin
  SHA512InitDigest(Digest);

  if KeySize > 128 then
    begin
      D := CalcSHA512(Key^, KeySize);
      HMAC_KeyBlock1024(D, Sizeof(D), K);
    end else
    HMAC_KeyBlock1024(Key^, KeySize, K);

  Move(K, S, SizeOf(K));
  XORBlock1024(S, $36);
  TransformSHA512Buffer(Digest, S);
  SecureClear1024(S);
end;

procedure HMAC_SHA512Buf(
          var Digest: T512BitDigest;
          const Buf; const BufSize: NativeInt);
begin
  SHA512Buf(Digest, Buf, BufSize);
end;

procedure HMAC_SHA512FinalBuf(
          const K: T1024BitBuf; var Digest: T512BitDigest;
          const Buf; const BufSize: Int32; const TotalSize: Int64);
var
  FinBuf : packed record
    K : T1024BitBuf;
    D : T512BitDigest;
  end;
begin
  SHA512FinalBuf(Digest, Buf, BufSize, TotalSize + 128);
  Move(K, FinBuf.K, SizeOf(K));
  XORBlock1024(FinBuf.K, $5C);
  Move(Digest, FinBuf.D, SizeOf(Digest));
  Digest := CalcSHA512(FinBuf, SizeOf(FinBuf));
  SecureClearBuf(FinBuf, SizeOf(FinBuf));
end;

function CalcHMAC_SHA512(
         const Key: Pointer; const KeySize: Int32;
         const Buf; const BufSize: NativeInt): T512BitDigest;
var
  I, J : NativeInt;
  P    : PByte;
  K    : T1024BitBuf;
begin
  HMAC_SHA512Init(Key, KeySize, Result, K);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 128) * 128;
  if J > 0 then
    begin
      HMAC_SHA512Buf(Result, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  HMAC_SHA512FinalBuf(K, Result, P^, I, BufSize);
  SecureClear1024(K);
end;

function CalcHMAC_SHA512(
         const Key: RawByteString;
         const Buf; const BufSize: NativeInt): T512BitDigest;
begin
  Result := CalcHMAC_SHA512(Pointer(Key), Length(Key), Buf, BufSize);
end;

function CalcHMAC_SHA512(const Key, Buf: RawByteString): T512BitDigest;
begin
  Result := CalcHMAC_SHA512(Key, Pointer(Buf)^, Length(Buf));
end;



{                                                                              }
{ CalculateHash                                                                }
{                                                                              }
procedure CalculateHash(const HashType: THashType;
          const Buf; const BufSize: Integer;
          const Digest: Pointer;
          const Key: Pointer; const KeySize: Int32);
begin
  if KeySize > 0 then
    case HashType of
      hashHMAC_MD5    : P128BitDigest(Digest)^ := CalcHMAC_MD5(Key, KeySize, Buf, BufSize);
      hashHMAC_SHA1   : P160BitDigest(Digest)^ := CalcHMAC_SHA1(Key, KeySize, Buf, BufSize);
      hashHMAC_SHA256 : P256BitDigest(Digest)^ := CalcHMAC_SHA256(Key, KeySize, Buf, BufSize);
      hashHMAC_SHA512 : P512BitDigest(Digest)^ := CalcHMAC_SHA512(Key, KeySize, Buf, BufSize);
    else
      raise EHashError.Create(hashInvalidKeyedHashType);
    end
  else
    case HashType of
      hashMD5         : P128BitDigest(Digest)^ := CalcMD5(Buf, BufSize);
      hashSHA1        : P160BitDigest(Digest)^ := CalcSHA1(Buf, BufSize);
      hashSHA256      : P256BitDigest(Digest)^ := CalcSHA256(Buf, BufSize);
      hashSHA512      : P512BitDigest(Digest)^ := CalcSHA512(Buf, BufSize);
      hashRipeMD160   : P160BitDigest(Digest)^ := CalcRipeMD160(Buf, BufSize);
      hashHMAC_MD5    : P128BitDigest(Digest)^ := CalcHMAC_MD5(nil, 0, Buf, BufSize);
      hashHMAC_SHA1   : P160BitDigest(Digest)^ := CalcHMAC_SHA1(nil, 0, Buf, BufSize);
      hashHMAC_SHA256 : P256BitDigest(Digest)^ := CalcHMAC_SHA256(nil, 0, Buf, BufSize);
      hashHMAC_SHA512 : P512BitDigest(Digest)^ := CalcHMAC_SHA512(nil, 0, Buf, BufSize);
    else
      raise EHashError.Create(hashInvalidHashType);
    end;
end;

procedure CalculateHash(const HashType: THashType;
          const Buf; const BufSize: Integer;
          const Digest: Pointer;
          const Key: RawByteString);
begin
  CalculateHash(HashType, Buf, BufSize, Digest, Pointer(Key), Length(Key));
end;

procedure CalculateHash(const HashType: THashType;
          const Buf: RawByteString;
          const Digest: Pointer;
          const Key: RawByteString);
begin
  CalculateHash(HashType, Pointer(Buf)^, Length(Buf), Digest, Key);
end;



{                                                                              }
{ AHash                                                                        }
{                                                                              }
class function AHash.BlockSize: Int32;
begin
  Result := -1;
end;

procedure AHash.ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64);
begin
  ProcessBuf(Buf, BufSize);
end;

procedure AHash.Init(const Digest: Pointer; const Key: Pointer; const KeySize: Int32);
begin
  Assert(Assigned(Digest));
  FDigest := Digest;
  FTotalSize := 0;
  InitHash(Digest, Key, KeySize);
end;

procedure AHash.Init(const Digest: Pointer; const Key: RawByteString);
begin
  Init(Digest, Pointer(Key), Length(Key));
end;

procedure AHash.HashBuf(const Buf; const BufSize: NativeInt; const FinalBuf: Boolean);
var
  I, D : NativeInt;
  P : PByte;
begin
  Inc(FTotalSize, BufSize);

  D := BlockSize;
  if D < 0 then
    D := 64;
  P := @Buf;
  I := (BufSize div D) * D;
  if I > 0 then
    begin
      ProcessBuf(P^, I);
      Inc(P, I);
    end;

  I := BufSize mod D;
  if FinalBuf then
    ProcessFinalBuf(P^, I, FTotalSize)
  else
    if I > 0 then
      raise EHashError.Create(hashInvalidBufferSize,
          'Non final buffer must be multiple of block size');
end;

procedure AHash.HashFile(
          const FileName: String;
          const Offset: Int64;
          const MaxCount: Int64);
const ChunkSize = 8192;
var
  Handle : THandle;
  Buf    : Pointer;
  I, C   : Integer;
  Left   : Int64;
  Fin    : Boolean;
begin
  if FileName = '' then
    raise EHashError.Create(hashInvalidFileName);
  Handle := FileOpen(FileName, fmOpenReadWrite or fmShareDenyNone);
  if Handle = THandle(-1) then
    raise EHashError.Create(hashFileOpenError, GetLastOSErrorMessage);
  if Offset > 0 then
    I := FileSeek(Handle, Offset, 0) else
  if Offset < 0 then
    I := FileSeek(Handle, Offset, 2) else
    I := 0;
  if I = -1 then
    raise EHashError.Create(hashFileSeekError, GetLastOSErrorMessage);
  try
    GetMem(Buf, ChunkSize);
    try
      if MaxCount < 0 then
        Left := High(Int64) else
        Left := MaxCount;
      repeat
        if Left > ChunkSize then
          C := ChunkSize else
          C := Left;
        if C = 0 then
          begin
            I := 0;
            Fin := True;
          end else
          begin
            I := FileRead(Handle, Buf^, C);
            if I = -1 then
              raise EHashError.Create(hashFileReadError, GetLastOSErrorMessage);
            Dec(Left, I);
            Fin := (I < C) or (Left <= 0);
          end;
        HashBuf(Buf^, I, Fin);
      until Fin;
    finally
      FreeMem(Buf, ChunkSize);
    end;
  finally
    FileClose(Handle);
  end;
end;



{                                                                              }
{ TMD5Hash                                                                     }
{                                                                              }
procedure TMD5Hash.InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32);
begin
  MD5InitDigest(P128BitDigest(FDigest)^);
end;

procedure TMD5Hash.ProcessBuf(const Buf; const BufSize: NativeInt);
begin
  MD5Buf(P128BitDigest(FDigest)^, Buf, BufSize);
end;

procedure TMD5Hash.ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64);
begin
  MD5FinalBuf(P128BitDigest(FDigest)^, Buf, BufSize, TotalSize);
end;

class function TMD5Hash.DigestSize: Int32;
begin
  Result := 16;
end;

class function TMD5Hash.BlockSize: Int32;
begin
  Result := 64;
end;



{                                                                              }
{ TSHA1Hash                                                                    }
{                                                                              }
procedure TSHA1Hash.InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32);
begin
  SHA1InitDigest(P160BitDigest(FDigest)^);
end;

procedure TSHA1Hash.ProcessBuf(const Buf; const BufSize: NativeInt);
begin
  SHA1Buf(P160BitDigest(FDigest)^, Buf, BufSize);
end;

procedure TSHA1Hash.ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64);
begin
  SHA1FinalBuf(P160BitDigest(FDigest)^, Buf, BufSize, TotalSize);
end;

class function TSHA1Hash.DigestSize: Int32;
begin
  Result := 20;
end;

class function TSHA1Hash.BlockSize: Int32;
begin
  Result := 64;
end;



{                                                                              }
{ TSHA256Hash                                                                  }
{                                                                              }
procedure TSHA256Hash.InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32);
begin
  SHA256InitDigest(P256BitDigest(FDigest)^);
end;

procedure TSHA256Hash.ProcessBuf(const Buf; const BufSize: NativeInt);
begin
  SHA256Buf(P256BitDigest(FDigest)^, Buf, BufSize);
end;

procedure TSHA256Hash.ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64);
begin
  SHA256FinalBuf(P256BitDigest(FDigest)^, Buf, BufSize, TotalSize);
end;

class function TSHA256Hash.DigestSize: Int32;
begin
  Result := 32;
end;

class function TSHA256Hash.BlockSize: Int32;
begin
  Result := 64;
end;



{                                                                              }
{ TSHA512Hash                                                                  }
{                                                                              }
procedure TSHA512Hash.InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32);
begin
  SHA512InitDigest(P512BitDigest(FDigest)^);
end;

procedure TSHA512Hash.ProcessBuf(const Buf; const BufSize: NativeInt);
begin
  SHA512Buf(P512BitDigest(FDigest)^, Buf, BufSize);
end;

procedure TSHA512Hash.ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64);
begin
  SHA512FinalBuf(P512BitDigest(FDigest)^, Buf, BufSize, TotalSize);
end;

class function TSHA512Hash.DigestSize: Int32;
begin
  Result := 64;
end;

class function TSHA512Hash.BlockSize: Int32;
begin
  Result := 128;
end;



{                                                                              }
{ TRipeMD160Hash                                                               }
{                                                                              }
procedure TRipeMD160Hash.InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32);
begin
  RipeMD160InitDigest(P160BitDigest(FDigest)^);
end;

procedure TRipeMD160Hash.ProcessBuf(const Buf; const BufSize: NativeInt);
begin
  RipeMD160Buf(P160BitDigest(FDigest)^, Buf, BufSize);
end;

procedure TRipeMD160Hash.ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64);
begin
  RipeMD160FinalBuf(P160BitDigest(FDigest)^, Buf, BufSize, TotalSize);
end;

class function TRipeMD160Hash.DigestSize: Int32;
begin
  Result := 20;
end;

class function TRipeMD160Hash.BlockSize: Int32;
begin
  Result := 64;
end;



{                                                                              }
{ THMAC_MD5Hash                                                                }
{                                                                              }
destructor THMAC_MD5Hash.Destroy;
begin
  SecureClear512(FKey);
  inherited Destroy;
end;

procedure THMAC_MD5Hash.InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32);
begin
  HMAC_MD5Init(Key, KeySize, P128BitDigest(FDigest)^, FKey);
end;

procedure THMAC_MD5Hash.ProcessBuf(const Buf; const BufSize: NativeInt);
begin
  HMAC_MD5Buf(P128BitDigest(FDigest)^, Buf, BufSize);
end;

procedure THMAC_MD5Hash.ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64);
begin
  HMAC_MD5FinalBuf(FKey, P128BitDigest(FDigest)^, Buf, BufSize, TotalSize);
end;

class function THMAC_MD5Hash.DigestSize: Int32;
begin
  Result := 16;
end;

class function THMAC_MD5Hash.BlockSize: Int32;
begin
  Result := 64;
end;



{                                                                              }
{ THMAC_SHA1Hash                                                               }
{                                                                              }
destructor THMAC_SHA1Hash.Destroy;
begin
  SecureClear512(FKey);
  inherited Destroy;
end;

procedure THMAC_SHA1Hash.InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32);
begin
  HMAC_SHA1Init(Key, KeySize, P160BitDigest(FDigest)^, FKey);
end;

procedure THMAC_SHA1Hash.ProcessBuf(const Buf; const BufSize: NativeInt);
begin
  HMAC_SHA1Buf(P160BitDigest(FDigest)^, Buf, BufSize);
end;

procedure THMAC_SHA1Hash.ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64);
begin
  HMAC_SHA1FinalBuf(FKey, P160BitDigest(FDigest)^, Buf, BufSize, TotalSize);
end;

class function THMAC_SHA1Hash.DigestSize: Int32;
begin
  Result := 20;
end;

class function THMAC_SHA1Hash.BlockSize: Int32;
begin
  Result := 64;
end;



{                                                                              }
{ THMAC_SHA256Hash                                                             }
{                                                                              }
destructor THMAC_SHA256Hash.Destroy;
begin
  SecureClear512(FKey);
  inherited Destroy;
end;

procedure THMAC_SHA256Hash.InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32);
begin
  HMAC_SHA256Init(Key, KeySize, P256BitDigest(FDigest)^, FKey);
end;

procedure THMAC_SHA256Hash.ProcessBuf(const Buf; const BufSize: NativeInt);
begin
  HMAC_SHA256Buf(P256BitDigest(FDigest)^, Buf, BufSize);
end;

procedure THMAC_SHA256Hash.ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64);
begin
  HMAC_SHA256FinalBuf(FKey, P256BitDigest(FDigest)^, Buf, BufSize, TotalSize);
end;

class function THMAC_SHA256Hash.DigestSize: Int32;
begin
  Result := 32;
end;

class function THMAC_SHA256Hash.BlockSize: Int32;
begin
  Result := 64;
end;



{                                                                              }
{ THMAC_SHA512Hash                                                             }
{                                                                              }
destructor THMAC_SHA512Hash.Destroy;
begin
  SecureClear1024(FKey);
  inherited Destroy;
end;

procedure THMAC_SHA512Hash.InitHash(const Digest: Pointer; const Key: Pointer; const KeySize: Int32);
begin
  HMAC_SHA512Init(Key, KeySize, P512BitDigest(FDigest)^, FKey);
end;

procedure THMAC_SHA512Hash.ProcessBuf(const Buf; const BufSize: NativeInt);
begin
  HMAC_SHA512Buf(P512BitDigest(FDigest)^, Buf, BufSize);
end;

procedure THMAC_SHA512Hash.ProcessFinalBuf(const Buf; const BufSize: Int32; const TotalSize: Int64);
begin
  HMAC_SHA512FinalBuf(FKey, P512BitDigest(FDigest)^, Buf, BufSize, TotalSize);
end;

class function THMAC_SHA512Hash.DigestSize: Int32;
begin
  Result := 64;
end;

class function THMAC_SHA512Hash.BlockSize: Int32;
begin
  Result := 128;
end;



{                                                                              }
{ Hash by THashType                                                            }
{                                                                              }
const
  HashTypeClasses : array[THashType] of THashClass = (
      TMD5Hash, TSHA1Hash, TSHA256Hash, TSHA512Hash, TRipeMD160Hash,
      THMAC_MD5Hash, THMAC_SHA1Hash, THMAC_SHA256Hash, THMAC_SHA512Hash);

function GetHashClassByType(const HashType: THashType): THashClass;
begin
  Result := HashTypeClasses[HashType];
end;

function GetDigestSize(const HashType: THashType): Integer;
begin
  Result := GetHashClassByType(HashType).DigestSize;
end;



end.

