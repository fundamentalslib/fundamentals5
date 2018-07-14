{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcSocketLib.pas                                         }
{   File version:     5.18                                                     }
{   Description:      Socket library.                                          }
{                                                                              }
{   Copyright:        Copyright (c) 2001-2016, David J Butler                  }
{                     All rights reserved.                                     }
{                     This file is licensed under the BSD License.             }
{                     See http://www.opensource.org/licenses/bsd-license.php   }
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
{   2001/12/11  0.01  Initial version.                                         }
{   2001/12/12  0.02  Added LocalHost functions.                               }
{   2002/07/01  3.03  Revised for Fundamentals 3.                              }
{   2003/08/19  3.04  Added IP4AddressType function.                           }
{   2005/07/01  4.05  Renamed to cSocketsLib.                                  }
{   2005/07/13  4.06  Initial Unix support.                                    }
{   2005/07/14  4.07  Compilable with FreePascal 2 Win32 i386.                 }
{   2005/07/17  4.08  Minor improvements.                                      }
{   2005/12/06  4.09  Compilable with FreePascal 2.0.1 Linux i386.             }
{   2005/12/10  4.10  Revised for Fundamentals 4.                              }
{   2006/12/04  4.11  Improved Winsock 2 support.                              }
{   2006/12/14  4.12  IP6 support.                                             }
{   2007/12/29  4.13  Revision.                                                }
{   2010/09/12  4.14  Revision.                                                }
{   2014/04/23  4.15  Revision.                                                }
{   2015/04/24  4.16  SocketAddrArray help functions.                          }
{   2015/05/06  4.17  Rename IP4/IP6 address functions.                        }
{   2016/01/09  5.18  Revised for Fundamentals 5.                              }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 5 Win32                      4.14  2011/09/27                       }
{   Delphi 6 Win32                      4.14  2011/09/27                       }
{   Delphi 7 Win32                      4.14  2011/09/27                       }
{   Delphi 2006 Win32                   4.14  2011/09/27                       }
{   Delphi 2007 Win32                   4.14  2011/09/27                       }
{   Delphi 2009 Win32                   4.14  2011/09/27                       }
{   Delphi XE2 Win32                    4.15  2014/04/23                       }
{   Delphi XE7 Win32                    5.18  2016/01/09                       }
{   Delphi XE7 Win64                    5.18  2016/01/09                       }
{   Delphi 10 Win32                     5.18  2016/01/09                       }
{   Delphi 10 Win64                     5.18  2016/01/09                       }
{   FreePascal 2.6.2 Linux i386         4.15  2014/04/23                       }
{   FreePascal 2.6.2 Linux x64          4.15  2015/04/01                       }
{   FreePascal 2.6.2 Win32 i386         4.15  2014/04/23                       }
{                                                                              }
{ References:                                                                  }
{                                                                              }
{   Microsoft Platform SDK: Windows Sockets                                    }
{   http://www.die.net/doc/linux/man/man7/socket.7.html                        }
{                                                                              }
{******************************************************************************}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF DEBUG}
{$IFDEF TEST}
  {$DEFINE SOCKETLIB_TEST}
  {.DEFINE SOCKETLIB_TEST_IP6}
  {.DEFINE SOCKETLIB_TEST_IP4_INTERNET}
  {.DEFINE SOCKETLIB_TEST_OUTPUT}
{$ENDIF}
{$ENDIF}

// Socket system type
{$IFDEF MSWIN}
  {$DEFINE SOCKETLIB_WIN}
{$ELSE}
  {$DEFINE SOCKETLIB_UNIX}
{$ENDIF}

unit flcSocketLib;

interface

{$IFDEF SOCKETLIB_WIN}
uses
  { System }
  Windows,
  SysUtils,
  { Fundamentals }
  flcUtils,
  flcWinSock;
{$ENDIF}

{$IFDEF SOCKETLIB_UNIX}
uses
  { System }
  SysUtils,
  { Fundamentals }
  flcUtils,
  flcUnixSock;
{$ENDIF}



{                                                                              }
{ Socket structures                                                            }
{                                                                              }
type
  TIPAddressFamily = (
      iaNone,
      iaIP4,
      iaIP6);

function IPAddressFamilyToAF(const AddressFamily: TIPAddressFamily): LongInt; {$IFDEF UseInline}inline;{$ENDIF}
function AFToIPAddressFamily(const AF: LongInt): TIPAddressFamily;

type
  TIPProtocol = (
      ipNone,
      ipIP,
      ipICMP,
      ipTCP,
      ipUDP,
      ipRaw);

function IPProtocolToIPPROTO(const Protocol: TIPProtocol): LongInt;

type
  TIP4Addr = record
    case Integer of
      0 : (Addr8  : array[0..3] of Byte);
      1 : (Addr16 : array[0..1] of Word);
      2 : (Addr32 : LongWord);
  end;
  PIP4Addr = ^TIP4Addr;
  TIP4AddrArray = array of TIP4Addr;
  TIP4AddrArrayArray = array of TIP4AddrArray;

const
  IP4AddrZero      : TIP4Addr = (Addr32: $00000000);
  IP4AddrLoopback  : TIP4Addr = (Addr32: $7F000001);
  IP4AddrBroadcast : TIP4Addr = (Addr32: $FFFFFFFF);
  IP4AddrNone      : TIP4Addr = (Addr32: $FFFFFFFF);

  IP4AddrStrAny       = '0.0.0.0';
  IP4AddrStrLoopback  = '127.0.0.1';
  IP4AddrStrBroadcast = '255.255.255.255';

function IP4AddrIsZero(const A: TIP4Addr): Boolean;
function IP4AddrIsNone(const A: TIP4Addr): Boolean;

type
  TIP6Addr = record
    case Integer of
      0 : (Addr8  : array[0..15] of Byte);
      1 : (Addr16 : array[0..7] of Word);
      2 : (Addr32 : array[0..3] of LongWord);
  end;
  PIP6Addr = ^TIP6Addr;
  TIP6AddrArray = array of TIP6Addr;
  TIP6AddrArrayArray = array of TIP6AddrArray;

const
  IP6AddrStrUnspecified = '::';
  IP6AddrStrAnyHost     = '::0';
  IP6AddrStrLocalHost   = '::1';
  IP6AddrStrBroadcast   = 'ffff::1';

  IP6AddrZero : TIP6Addr = (Addr32: (0, 0, 0, 0));

function  IP6AddrIsZero(const A: TIP6Addr): Boolean;
function  IP6AddrIsLocalHost(const A: TIP6Addr): Boolean;
function  IP6AddrIsBroadcast(const A: TIP6Addr): Boolean;
function  IP6AddrIsEqual(const A, B: TIP6Addr): Boolean;
procedure IP6AddrSetZero(out A: TIP6Addr); {$IFDEF UseInline}inline;{$ENDIF}
procedure IP6AddrSetLocalHost(var A: TIP6Addr);
procedure IP6AddrSetBroadcast(var A: TIP6Addr);
procedure IP6AddrAssign(var A: TIP6Addr; const B: TIP6Addr); {$IFDEF UseInline}inline;{$ENDIF}

type
  TSocketAddr = record
    Port : Word; // port in host endian (not network endian)
    case AddrFamily : TIPAddressFamily of
      iaIP4 : (AddrIP4  : TIP4Addr);
      iaIP6 : (AddrIP6  : TIP6Addr;
               FlowInfo : LongWord;
               ScopeID  : LongWord);
  end;
  PSocketAddr = ^TSocketAddr;
  TSocketAddrArray = array of TSocketAddr;
  TSocketAddrArrayArray = array of TSocketAddrArray;

procedure InitSocketAddrNone(out Addr: TSocketAddr); {$IFDEF UseInline}inline;{$ENDIF}
function  InitSocketAddr(out SocketAddr: TSocketAddr; const Addr: TIP4Addr; const Port: Word): Integer; overload;
function  InitSocketAddr(out SocketAddr: TSocketAddr; const Addr: TIP6Addr; const Port: Word): Integer; overload;
procedure SetSocketAddrPort(var SocketAddr: TSocketAddr; const Port: Word);

function  SockAddrLen(const SockAddr: TSockAddr): Integer; {$IFDEF UseInline}inline;{$ENDIF}
function  SockAddrToSocketAddr(const Addr: TSockAddr): TSocketAddr;
function  SocketAddrToSockAddr(const Addr: TSocketAddr): TSockAddr;

function  SocketAddrIPStrA(const Addr: TSocketAddr): RawByteString;
function  SocketAddrIPStr(const Addr: TSocketAddr): String;

function  SocketAddrStrA(const Addr: TSocketAddr): RawByteString;
function  SocketAddrStr(const Addr: TSocketAddr): String;

function  SocketAddrEqual(const Addr1, Addr2: TSocketAddr): Boolean;

procedure SocketAddrArrayAppend(var AddrArray: TSocketAddrArray; const Addr: TSocketAddr);
function  SocketAddrArrayGetAddrIndex(const AddrArray: TSocketAddrArray; const Addr: TSocketAddr): Integer;
function  SocketAddrArrayHasAddr(const AddrArray: TSocketAddrArray; const Addr: TSocketAddr): Boolean; {$IFDEF UseInline}inline;{$ENDIF}

type
  TSocketHost = record
    Used  : Boolean;
    Host  : AnsiString;
    Alias : array of AnsiString;
    Addr  : TSocketAddrArray;
  end;
  PSocketHost = ^TSocketHost;
  TSocketHostArray = array of TSocketHost;
  TSocketHostArrayArray = array of TSocketHostArray;

function HostEntToSocketHost(const HostEnt: PHostEnt): TSocketHost;

type
  {$IFDEF CPU_X86_64}
  TSocketHandle = UInt64;
  {$ELSE}
  TSocketHandle = LongWord;
  {$ENDIF}
  TSocketHandleArray = array of TSocketHandle;

function  SocketHandleArrayToFDSet(const Handles: TSocketHandleArray): TFDSet;
procedure SocketHandleArrayAppend(var Handles: TSocketHandleArray; const Handle: TSocketHandle);
function  SocketHandleArrayLocate(var Handles: TSocketHandleArray; const Handle: TSocketHandle): Integer;

const
  INVALID_SOCKETHANDLE = TSocketHandle(-1);

function  AddrInfoCount(const AddrInfo: PAddrInfo; const Family: Word): Integer;



{                                                                              }
{ Socket library functions                                                     }
{                                                                              }
type
  TSocketShutdown = (ssBoth, ssSend, ssRecv);
  TSocketRecvFlag = (srfOOB, srfPeek);
  TSocketRecvFlags = set of TSocketRecvFlag;

function  SocketAccept(const S: TSocketHandle; out Addr: TSocketAddr): TSocketHandle;
function  SocketBind(const S: TSocketHandle; const Addr: TSocketAddr): Integer;
function  SocketClose(const S: TSocketHandle): Integer;
function  SocketConnect(const S: TSocketHandle; const Addr: TSocketAddr): Integer;
procedure SocketGetAddrInfo(
          const AddressFamily: TIPAddressFamily;
          const Protocol: TIPProtocol;
          const Host, Port: AnsiString;
          out Addresses: TSocketAddrArray);
function  SocketGetHostByAddr(const Addr: Pointer; const Len: Integer; const AF: Integer): TSocketHost;
function  SocketGetHostByName(const Name: PAnsiChar): TSocketHost;
function  SocketGetHostName(const Name: PAnsiChar; const Len: Integer): Integer;
function  SocketGetNameInfo(const Address: TSocketAddr): AnsiString;
function  SocketGetPeerName(const S: TSocketHandle; out Name: TSocketAddr): Integer;
function  SocketGetServByName(const Name, Proto: PAnsiChar): PServEnt;
function  SocketGetServByPort(const Port: Integer; const Proto: PAnsiChar): PServEnt;
function  SocketGetSockName(const S: TSocketHandle; out Name: TSocketAddr): Integer;
function  SocketGetSockOpt(const S: TSocketHandle; const Level, OptName: Integer;
          const OptVal: Pointer; var OptLen: Integer): Integer;
function  Sockethtons(const HostShort: Word): Word;
function  Sockethtonl(const HostLong: LongWord): LongWord;
function  Socketinet_ntoa(const InAddr: TIP4Addr): RawByteString;
function  Socketinet_addr(const P: PAnsiChar): TIP4Addr;
function  SocketListen(const S: TSocketHandle; const Backlog: Integer): Integer;
function  Socketntohs(const NetShort: Word): Word;
function  Socketntohl(const NetLong: LongWord): LongWord;
function  SocketRecv(const S: TSocketHandle; var Buf; const Len: Integer; const Flags: TSocketRecvFlags): Integer;
function  SocketRecvFrom(const S: TSocketHandle; var Buf; const Len: Integer; const Flags: TSocketRecvFlags;
          out From: TSocketAddr): Integer;
function  SocketSelect(const nfds: LongWord;
          var ReadFDS, WriteFDS, ExceptFDS: TSocketHandleArray;
          const TimeOutMicroseconds: Int64): Integer; overload;
function  SocketSelect(const S: TSocketHandle;
          var ReadSelect, WriteSelect, ExceptSelect: Boolean;
          const TimeOutMicroseconds: Int64): Integer; overload;
function  SocketSend(const S: TSocketHandle; const Buf; const Len, Flags: Integer): Integer;
function  SocketSendTo(const S: TSocketHandle; const Buf; const Len, Flags: Integer;
          const AddrTo: TSocketAddr): Integer;
function  SocketSetSockOpt(const S: TSocketHandle; const Level, OptName: Integer;
          const OptVal: Pointer; const OptLen: Integer): Integer;
function  SocketShutdown(const S: TSocketHandle; const How: TSocketShutdown): Integer;
function  SocketSocket(const Family: TIPAddressFamily; const Struct: Integer;
          const Protocol: TIPProtocol): TSocketHandle;



{                                                                              }
{ Socket library errors                                                        }
{                                                                              }
const
  // Error result for socket library functions
  SOCKET_ERROR = -1;

{$IFDEF SOCKETLIB_WIN}
const
  // Define Berkeley/Posix error identifiers for equivalent Windows error codes
  EINTR              = WSAEINTR;
  EBADF              = WSAEBADF;
  EACCES             = WSAEACCES;
  EFAULT             = WSAEFAULT;
  EINVAL             = WSAEINVAL;
  EMFILE             = WSAEMFILE;
  EWOULDBLOCK        = WSAEWOULDBLOCK;
  EAGAIN             = WSAEWOULDBLOCK;
  EINPROGRESS        = WSAEINPROGRESS;
  EALREADY           = WSAEALREADY;
  ENOTSOCK           = WSAENOTSOCK;
  EDESTADDRREQ       = WSAEDESTADDRREQ;
  EMSGSIZE           = WSAEMSGSIZE;
  EPROTOTYPE         = WSAEPROTOTYPE;
  ENOPROTOOPT        = WSAENOPROTOOPT;
  EPROTONOSUPPORT    = WSAEPROTONOSUPPORT;
  ESOCKTNOSUPPORT    = WSAESOCKTNOSUPPORT;
  EOPNOTSUPP         = WSAEOPNOTSUPP;
  EPFNOSUPPORT       = WSAEPFNOSUPPORT;
  EAFNOSUPPORT       = WSAEAFNOSUPPORT;
  EADDRINUSE         = WSAEADDRINUSE;
  EADDRNOTAVAIL      = WSAEADDRNOTAVAIL;
  ENETDOWN           = WSAENETDOWN;
  ENETUNREACH        = WSAENETUNREACH;
  ENETRESET          = WSAENETRESET;
  ECONNABORTED       = WSAECONNABORTED;
  ECONNRESET         = WSAECONNRESET;
  ENOBUFS            = WSAENOBUFS;
  EISCONN            = WSAEISCONN;
  ENOTCONN           = WSAENOTCONN;
  ESHUTDOWN          = WSAESHUTDOWN;
  ETOOMANYREFS       = WSAETOOMANYREFS;
  ETIMEDOUT          = WSAETIMEDOUT;
  ECONNREFUSED       = WSAECONNREFUSED;
  ELOOP              = WSAELOOP;
  ENAMETOOLONG       = WSAENAMETOOLONG;
  EHOSTDOWN          = WSAEHOSTDOWN;
  EHOSTUNREACH       = WSAEHOSTUNREACH;
  ENOTEMPTY          = WSAENOTEMPTY;
  EUSERS             = WSAEUSERS;
  EDQUOT             = WSAEDQUOT;
  ESTALE             = WSAESTALE;
  EREMOTE            = WSAEREMOTE;
  HOST_NOT_FOUND     = WSAHOST_NOT_FOUND;
  TRY_AGAIN          = WSATRY_AGAIN;
  NO_RECOVERY        = WSANO_RECOVERY;
  ENOMEM             = WSA_NOT_ENOUGH_MEMORY;
{$ENDIF}
{$IFDEF SOCKETLIB_UNIX}
const
  // Define Berkeley/Posix error identifiers for equivalent Unix error codes
  EINTR              = flcUnixSock.EINTR;
  EBADF              = flcUnixSock.EBADF;
  EACCES             = flcUnixSock.EACCES;
  EFAULT             = flcUnixSock.EFAULT;
  EINVAL             = flcUnixSock.EINVAL;
  EMFILE             = flcUnixSock.EMFILE;
  EWOULDBLOCK        = flcUnixSock.EWOULDBLOCK;
  EAGAIN             = flcUnixSock.EWOULDBLOCK;
  EINPROGRESS        = flcUnixSock.EINPROGRESS;
  EALREADY           = flcUnixSock.EALREADY;
  ENOTSOCK           = flcUnixSock.ENOTSOCK;
  EDESTADDRREQ       = flcUnixSock.EDESTADDRREQ;
  EMSGSIZE           = flcUnixSock.EMSGSIZE;
  EPROTOTYPE         = flcUnixSock.EPROTOTYPE;
  ENOPROTOOPT        = flcUnixSock.ENOPROTOOPT;
  EPROTONOSUPPORT    = flcUnixSock.EPROTONOSUPPORT;
  ESOCKTNOSUPPORT    = flcUnixSock.ESOCKTNOSUPPORT;
  EOPNOTSUPP         = flcUnixSock.EOPNOTSUPP;
  EPFNOSUPPORT       = flcUnixSock.EPFNOSUPPORT;
  EAFNOSUPPORT       = flcUnixSock.EAFNOSUPPORT;
  EADDRINUSE         = flcUnixSock.EADDRINUSE;
  EADDRNOTAVAIL      = flcUnixSock.EADDRNOTAVAIL;
  ENETDOWN           = flcUnixSock.ENETDOWN;
  ENETUNREACH        = flcUnixSock.ENETUNREACH;
  ENETRESET          = flcUnixSock.ENETRESET;
  ECONNABORTED       = flcUnixSock.ECONNABORTED;
  ECONNRESET         = flcUnixSock.ECONNRESET;
  ENOBUFS            = flcUnixSock.ENOBUFS;
  EISCONN            = flcUnixSock.EISCONN;
  ENOTCONN           = flcUnixSock.ENOTCONN;
  ESHUTDOWN          = flcUnixSock.ESHUTDOWN;
  ETOOMANYREFS       = flcUnixSock.ETOOMANYREFS;
  ETIMEDOUT          = flcUnixSock.ETIMEDOUT;
  ECONNREFUSED       = flcUnixSock.ECONNREFUSED;
  //ELOOP              = cUnixSock.ELOOP;
  ENAMETOOLONG       = flcUnixSock.ENAMETOOLONG;
  EHOSTDOWN          = flcUnixSock.EHOSTDOWN;
  EHOSTUNREACH       = flcUnixSock.EHOSTUNREACH;
  //ENOTEMPTY          = cUnixSock.ENOTEMPTY;
  //EUSERS             = cUnixSock.EUSERS;
  //EDQUOT             = cUnixSock.EDQUOT;
  //ESTALE             = cUnixSock.ESTALE;
  //EREMOTE            = cUnixSock.EREMOTE;
  //HOST_NOT_FOUND     = cUnixSock.HOST_NOT_FOUND;
  //TRY_AGAIN          = cUnixSock.TRY_AGAIN;
  //NO_RECOVERY        = cUnixSock.NO_RECOVERY;
  //ENOMEM             = cUnixSock._NOT_ENOUGH_MEMORY;
{$ENDIF}

type
  ESocketLib = class(Exception)
  protected
    FErrorCode : Integer;

  public
    constructor Create(const Msg: String; const ErrorCode: Integer = 0);
    constructor CreateFmt(const Msg: String; const Args: array of const;
                const ErrorCode: Integer = 0);
    {$IFNDEF FREEPASCAL}
    constructor CreateResFmt(Ident: Integer; const Args: array of TVarRec;
                const ErrorCode: Integer = 0);
    {$ENDIF}

    property ErrorCode: Integer read FErrorCode;
  end;

function  SocketGetLastError: Integer;
function  SocketGetErrorMessage(const ErrorCode: Integer): String;



{                                                                              }
{ IP addresses                                                                 }
{   IsIPAddress returns True if Address is a valid IP address. NetAddress      }
{   contains the address in network byte order.                                }
{   IsInternetIP returns True if Address appears to be an Internet IP.         }
{                                                                              }
type
  TIP4AddressType = (
      inaPublic,
      inaPrivate,
      inaNone,
      inaReserved,
      inaLoopback,
      inaLinkLocalNetwork,
      inaTestNetwork,
      inaMulticast,
      inaBroadcast);

function  IsIP4AddressA(const Address: RawByteString; out NetAddress: TIP4Addr): Boolean;
function  IsIP6AddressA(const Address: RawByteString; out NetAddress: TIP6Addr): Boolean;

function  IsIP4AddressU(const Address: UnicodeString; out NetAddress: TIP4Addr): Boolean;
{$IFDEF SOCKETLIB_WIN}
function  IsIP6AddressU(const Address: UnicodeString; out NetAddress: TIP6Addr): Boolean;
{$ENDIF}

function  IsIP4Address(const Address: String; out NetAddress: TIP4Addr): Boolean;
function  IsIP6Address(const Address: String; out NetAddress: TIP6Addr): Boolean;

function  IP4AddressStrA(const Address: TIP4Addr): RawByteString;
function  IP6AddressStrA(const Address: TIP6Addr): RawByteString;

function  IP4AddressStr(const Address: TIP4Addr): String;
function  IP6AddressStr(const Address: TIP6Addr): String;

function  IP4AddressType(const Address: TIP4Addr): TIP4AddressType;
function  IsPrivateIP4Address(const Address: TIP4Addr): Boolean;
function  IsInternetIP4Address(const Address: TIP4Addr): Boolean;
procedure SwapIP4Endian(var Address: TIP4Addr);



{                                                                              }
{ Port constants                                                               }
{                                                                              }
const
  // IP ports
  IPPORT_ECHO       = 7;
  IPPORT_DISCARD    = 9;
  IPPORT_DAYTIME    = 13;
  IPPORT_QOTD       = 17;
  IPPORT_FTPDATA    = 20;
  IPPORT_FTP        = 21;
  IPPORT_SSH        = 22;
  IPPORT_TELNET     = 23;
  IPPORT_SMTP       = 25;
  IPPORT_TIMESERVER = 37;
  IPPORT_NAMESERVER = 42;
  IPPORT_WHOIS      = 43;
  IPPORT_GOPHER     = 70;
  IPPORT_FINGER     = 79;
  IPPORT_HTTP       = 80;
  IPPORT_POP3       = 110;
  IPPORT_IDENT      = 113;
  IPPORT_NNTP       = 119;
  IPPORT_NTP        = 123;
  IPPORT_HTTPS      = 443;
  IPPORT_SSMTP      = 465;
  IPPORT_SNNTP      = 563;

  // IP port names
  IPPORTSTR_FTP    = 'ftp';
  IPPORTSTR_SSH    = 'ssh';
  IPPORTSTR_TELNET = 'telnet';
  IPPORTSTR_SMTP   = 'smtp';
  IPPORTSTR_HTTP   = 'http';
  IPPORTSTR_POP3   = 'pop3';
  IPPORTSTR_NNTP   = 'nntp';



{                                                                              }
{ HostEnt decoding                                                             }
{                                                                              }
function  HostEntAddressesCount(const HostEnt: PHostEnt): Integer;
function  HostEntAddresses(const HostEnt: PHostEnt): TIP4AddrArray;
function  HostEntAddress(const HostEnt: PHostEnt; const Index: Integer): TSocketAddr;
function  HostEntAddressIP4(const HostEnt: PHostEnt; const Index: Integer = 0): TIP4Addr;
function  HostEntAddressStr(const HostEnt: PHostEnt; const Index: Integer = 0): RawByteString;
function  HostEntName(const HostEnt: PHostEnt): AnsiString;



{                                                                              }
{ IP protocol                                                                  }
{   Enumeration of IP protocols.                                               }
{                                                                              }
function  IPProtocolToStrA(const Protocol: TIPProtocol): RawByteString;
function  StrToIPProtocolA(const Protocol: RawByteString): TIPProtocol;

function  IPProtocolToStr(const Protocol: TIPProtocol): String;
function  StrToIPProtocol(const Protocol: String): TIPProtocol;



{                                                                              }
{ Local host                                                                   }
{                                                                              }
type
  AddressStrArrayA = Array of RawByteString;
  AddressStrArray = Array of String;

function  LocalHostNameA: AnsiString;
function  LocalHostName: String;

function  LocalIPAddresses: TIP4AddrArray;
function  LocalIP6Addresses: TIP6AddrArray;

function  LocalIP4AddressesStrA: AddressStrArrayA;
function  LocalIP6AddressesStrA: AddressStrArrayA;

function  LocalIP4AddressesStr: AddressStrArray;
function  LocalIP6AddressesStr: AddressStrArray;

function  GuessInternetIP4: TIP4Addr;
function  GuessInternetIP4StrA: RawByteString;
function  GuessInternetIP4Str: String;



{                                                                              }
{ Remote host                                                                  }
{   Reverse name lookup (domain name from IP address).                         }
{   Blocks. Raises an exception if unsuccessful.                               }
{                                                                              }
function  GetRemoteHostNameA(const Address: TSocketAddr): AnsiString; overload;
function  GetRemoteHostNameA(const Address: TIP4Addr): AnsiString; overload;
function  GetRemoteHostNameA(const Address: TIP6Addr): AnsiString; overload;

function  GetRemoteHostName(const Address: TSocketAddr): String; overload;
function  GetRemoteHostName(const Address: TIP4Addr): String; overload;
function  GetRemoteHostName(const Address: TIP6Addr): String; overload;



{                                                                              }
{ Resolve host                                                                 }
{   Resolves Host (IP or domain name).                                         }
{   Blocks. Raises an exception if unsuccessful.                               }
{                                                                              }
function  ResolveHostExA(const Host: AnsiString; const AddressFamily: TIPAddressFamily): TSocketAddrArray;
function  ResolveHostA(const Host: AnsiString; const AddressFamily: TIPAddressFamily): TSocketAddr;

function  ResolveHostEx(const Host: String; const AddressFamily: TIPAddressFamily): TSocketAddrArray;
function  ResolveHost(const Host: String; const AddressFamily: TIPAddressFamily): TSocketAddr;

function  ResolveHostIP4ExA(const Host: AnsiString): TIP4AddrArray;
function  ResolveHostIP4A(const Host: AnsiString): TIP4Addr;

function  ResolveHostIP4Ex(const Host: String): TIP4AddrArray;
function  ResolveHostIP4(const Host: String): TIP4Addr;

function  ResolveHostIP6ExA(const Host: AnsiString): TIP6AddrArray;
function  ResolveHostIP6A(const Host: AnsiString): TIP6Addr;

function  ResolveHostIP6Ex(const Host: String): TIP6AddrArray;
function  ResolveHostIP6(const Host: String): TIP6Addr;



{                                                                              }
{ Port                                                                         }
{   NetPort is the Port value in network byte order.                           }
{   ResolvePort returns the NetPort.                                           }
{                                                                              }
function  ResolvePortA(const Port: AnsiString; const Protocol: TIPProtocol): Word;
function  ResolvePort(const Port: String; const Protocol: TIPProtocol): Word;

function  NetPortToPort(const NetPort: Word): Word;
function  NetPortToPortStr(const NetPort: Word): String;
function  NetPortToPortStrA(const NetPort: Word): RawByteString;

function  PortToNetPort(const Port: Word): Word;



{                                                                              }
{ Resolve host and port                                                        }
{                                                                              }
function  ResolveA(
          const Host: AnsiString; const Port: Integer;
          const AddressFamily: TIPAddressFamily = iaIP4;
          const Protocol: TIPProtocol = ipTCP): TSocketAddr; overload;
function  ResolveA(
          const Host, Port: AnsiString;
          const AddressFamily: TIPAddressFamily = iaIP4;
          const Protocol: TIPProtocol = ipTCP): TSocketAddr; overload;

function  Resolve(
          const Host: String; const Port: Integer;
          const AddressFamily: TIPAddressFamily = iaIP4;
          const Protocol: TIPProtocol = ipTCP): TSocketAddr; overload;
function  Resolve(
          const Host, Port: String;
          const AddressFamily: TIPAddressFamily = iaIP4;
          const Protocol: TIPProtocol = ipTCP): TSocketAddr; overload;



{                                                                              }
{ Socket handle                                                                }
{   AllocateSocketHandle returns a handle to a new socket.                     }
{   Raises an exception if allocation failed.                                  }
{                                                                              }
function  AllocateSocketHandle(
          const AddressFamily: TIPAddressFamily;
          const Protocol: TIPProtocol;
          const Overlapped: Boolean = False): TSocketHandle;



{                                                                              }
{ Socket options                                                               }
{                                                                              }
function  GetSocketReceiveTimeout(const SocketHandle: TSocketHandle): Integer;
procedure SetSocketReceiveTimeout(const SocketHandle: TSocketHandle;
          const TimeoutUs: Integer);
function  GetSocketSendTimeOut(const SocketHandle: TSocketHandle): Integer;
procedure SetSocketSendTimeout(const SocketHandle: TSocketHandle;
          const TimeoutUs: Integer);
function  GetSocketReceiveBufferSize(const SocketHandle: TSocketHandle): Integer;
procedure SetSocketReceiveBufferSize(const SocketHandle: TSocketHandle; const BufferSize: Integer);
function  GetSocketSendBufferSize(const SocketHandle: TSocketHandle): Integer;
procedure SetSocketSendBufferSize(const SocketHandle: TSocketHandle; const BufferSize: Integer);
procedure GetSocketLinger(const SocketHandle: TSocketHandle;
          var Linger: Boolean; var LingerTimeSec: Integer);
procedure SetSocketLinger(const SocketHandle: TSocketHandle;
          const Linger: Boolean; const LingerTimeSec: Integer = 0);
function  GetSocketBroadcast(const SocketHandle: TSocketHandle): Boolean;
procedure SetSocketBroadcast(const SocketHandle: TSocketHandle;
          const Broadcast: Boolean);
function  GetSocketMulticastTTL(const SocketHandle: TSocketHandle): Integer;
procedure SetSocketMulticastTTL(const SocketHandle: TSocketHandle; const TTL: Integer);



{                                                                              }
{ Socket mode                                                                  }
{                                                                              }
procedure SetSocketBlocking(const SocketHandle: TSocketHandle; const Block: Boolean);

{$IFDEF SOCKETLIB_WIN}
type
  TSocketAsynchronousEvent = (
    saeConnect,
    saeClose,
    saeRead,
    saeWrite,
    saeAccept);
  TSocketAsynchronousEvents = set of TSocketAsynchronousEvent;

function  SocketAsynchronousEventsToEvents(const Events: TSocketAsynchronousEvents): LongInt;
function  EventsToSocketAsynchronousEvents(const Events: LongInt): TSocketAsynchronousEvents;

procedure SetSocketAsynchronous(
          const SocketHandle: TSocketHandle;
          const WindowHandle: HWND;
          const Msg: Integer;
          const Events: TSocketAsynchronousEvents);
{$ENDIF}



{                                                                              }
{ Socket helpers                                                               }
{                                                                              }
function  GetSocketAvailableToRecv(const SocketHandle: TSocketHandle): Integer;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF SOCKETLIB_TEST}
procedure Test;
{$ENDIF}



implementation

uses
  { System }
  {$IFDEF SOCKETLIB_UNIX}
  dynlibs,
  {$ENDIF}
  SyncObjs,
  { Fundamentals }
  flcASCII,
  flcStrings,
  flcZeroTermStrings;



{                                                                              }
{ Socket library lock                                                          }
{                                                                              }
var
  SocketLibLock : TCriticalSection = nil;

procedure InitializeLibLock;
begin
  SocketLibLock := TCriticalSection.Create;
end;

procedure FinalizeLibLock;
begin
  FreeAndNil(SocketLibLock);
end;

procedure LibLock;
begin
  if Assigned(SocketLibLock) then
    SocketLibLock.Acquire;
end;

procedure LibUnlock;
begin
  if Assigned(SocketLibLock) then
    SocketLibLock.Release;
end;



{                                                                              }
{ Socket structure routines                                                    }
{                                                                              }
function IPAddressFamilyToAF(const AddressFamily: TIPAddressFamily): LongInt;
begin
  case AddressFamily of
    iaIP4 : Result := AF_INET;
    iaIP6 : Result := AF_INET6;
  else
    Result := AF_UNSPEC;
  end;
end;

function AFToIPAddressFamily(const AF: LongInt): TIPAddressFamily;
begin
  case AF of
    AF_INET  : Result := iaIP4;
    AF_INET6 : Result := iaIP6;
  else
    Result := iaNone;
  end;
end;

function IPProtocolToIPPROTO(const Protocol: TIPProtocol): LongInt;
begin
  case Protocol of
    ipIP   : Result := IPPROTO_IP;
    ipICMP : Result := IPPROTO_ICMP;
    ipTCP  : Result := IPPROTO_TCP;
    ipUDP  : Result := IPPROTO_UDP;
    ipRaw  : Result := IPPROTO_RAW;
  else
    Result := -1;
  end;
end;

function IP4AddrIsZero(const A: TIP4Addr): Boolean;
begin
  Result := A.Addr32 = IP4AddrZero.Addr32;
end;

function IP4AddrIsNone(const A: TIP4Addr): Boolean;
begin
  Result := A.Addr32 = IP4AddrNone.Addr32;
end;

function IP6AddrIsZero(const A: TIP6Addr): Boolean;
begin
  Result := (A.Addr32[0] = $00000000) and
            (A.Addr32[1] = $00000000) and
            (A.Addr32[2] = $00000000) and
            (A.Addr32[3] = $00000000);
end;

function IP6AddrIsLocalHost(const A: TIP6Addr): Boolean;
begin
  Result := (A.Addr32[0] = $00000000) and
            (A.Addr32[1] = $00000000) and
            (A.Addr32[2] = $00000000) and
            (A.Addr32[3] = $01000000);
end;

function IP6AddrIsBroadcast(const A: TIP6Addr): Boolean;
begin
  Result := (A.Addr32[0] = $0000FFFF) and
            (A.Addr32[1] = $00000000) and
            (A.Addr32[2] = $00000000) and
            (A.Addr32[3] = $01000000);
end;

function IP6AddrIsEqual(const A, B: TIP6Addr): Boolean;
begin
  Result := (A.Addr32[0] = B.Addr32[0]) and
            (A.Addr32[1] = B.Addr32[1]) and
            (A.Addr32[2] = B.Addr32[2]) and
            (A.Addr32[3] = B.Addr32[3]);
end;

procedure IP6AddrSetZero(out A: TIP6Addr);
begin
  A.Addr32[0] := 0;
  A.Addr32[1] := 0;
  A.Addr32[2] := 0;
  A.Addr32[3] := 0;
end;

procedure IP6AddrSetLocalHost(var A: TIP6Addr);
begin
  A.Addr32[0] := $00000000;
  A.Addr32[1] := $00000000;
  A.Addr32[2] := $00000000;
  A.Addr32[3] := $01000000;
end;

procedure IP6AddrSetBroadcast(var A: TIP6Addr);
begin
  A.Addr32[0] := $0000FFFF;
  A.Addr32[1] := $00000000;
  A.Addr32[2] := $00000000;
  A.Addr32[3] := $01000000;
end;

procedure IP6AddrAssign(var A: TIP6Addr; const B: TIP6Addr);
begin
  Move(B, A, Sizeof(TIn6Addr));
end;

procedure InitSocketAddrNone(out Addr: TSocketAddr);
begin
  FillChar(Addr, SizeOf(TSocketAddr), 0);
  Addr.AddrFamily := iaNone;
end;

function InitSocketAddr(out SocketAddr: TSocketAddr; const Addr: TIP4Addr; const Port: Word): Integer;
begin
  InitSocketAddrNone(SocketAddr);
  SocketAddr.AddrFamily := iaIP4;
  SocketAddr.Port       := Port;
  SocketAddr.AddrIP4    := Addr;
  Result := Sizeof(TSocketAddr);
end;

function InitSocketAddr(out SocketAddr: TSocketAddr; const Addr: TIP6Addr; const Port: Word): Integer;
begin
  InitSocketAddrNone(SocketAddr);
  SocketAddr.AddrFamily := iaIP6;
  SocketAddr.Port       := Port;
  IP6AddrAssign(SocketAddr.AddrIP6, Addr);
  Result := Sizeof(TSocketAddr);
end;

procedure SetSocketAddrPort(var SocketAddr: TSocketAddr; const Port: Word);
begin
  SocketAddr.Port := Port;
end;

function SockAddrLen(const SockAddr: TSockAddr): Integer;
begin
  case SockAddr.sa_family of
    AF_INET  : Result := Sizeof(TSockAddrIn);
    AF_INET6 : Result := Sizeof(TSockAddrIn6);
  else
    Result := 0;
  end;
end;

function SockAddrToSocketAddr(const Addr: TSockAddr): TSocketAddr;
begin
  case Addr.sa_family of
    AF_INET :
    begin
      Result.AddrFamily := iaIP4;
      Result.Port := NetPortToPort(Addr.sin_port);
      Result.AddrIP4.Addr32 := Addr.sin_addr.S_addr;
    end;
    AF_INET6 :
    begin
      Result.AddrFamily := iaIP6;
      Result.Port := NetPortToPort(Addr.sin6_port);
      Move(Addr.sin6_addr.u6_addr32, Result.AddrIP6.Addr32, SizeOf(TIP6Addr));
    end;
  else
    raise ESocketLib.Create('Address family not supported', -1);
  end;
end;

function SocketAddrToSockAddr(const Addr: TSocketAddr): TSockAddr;
begin
  case Addr.AddrFamily of
    iaIP4 :
    begin
      Result.sa_family := AF_INET;
      Result.sin_port := PortToNetPort(Addr.Port);
      Result.sin_addr.S_addr := Addr.AddrIP4.Addr32;
    end;
    iaIP6 :
    begin
      Result.sa_family := AF_INET6;
      Result.sin6_port := PortToNetPort(Addr.Port);
      Move(Addr.AddrIP6.Addr32[0], Result.sin6_addr.u6_addr32[0], 16);
    end;
  else
    Result.sa_family := AF_UNSPEC;
  end;
end;

function SocketAddrIPStrA(const Addr: TSocketAddr): RawByteString;
begin
  case Addr.AddrFamily of
    iaIP4 : Result := IP4AddressStrA(Addr.AddrIP4);
    iaIP6 : Result := IP6AddressStrA(Addr.AddrIP6);
  else
    Result := '';
  end;
end;

function SocketAddrIPStr(const Addr: TSocketAddr): String;
begin
  case Addr.AddrFamily of
    iaIP4 : Result := IP4AddressStr(Addr.AddrIP4);
    iaIP6 : Result := IP6AddressStr(Addr.AddrIP6);
  else
    Result := '';
  end;
end;

function SocketAddrStrA(const Addr: TSocketAddr): RawByteString;
begin
  Result := SocketAddrIPStrA(Addr) + ':' + IntToStringB(Addr.Port);
end;

function SocketAddrStr(const Addr: TSocketAddr): String;
begin
  Result := Format('%s:%d', [SocketAddrIPStr(Addr), Addr.Port]);
end;

function SocketAddrEqual(const Addr1, Addr2: TSocketAddr): Boolean;
begin
  if Addr1.AddrFamily <> Addr2.AddrFamily then
    Result := False
  else
  if Addr1.Port <> Addr2.Port then
    Result := False
  else
  case Addr1.AddrFamily of
    iaIP4 : Result := Addr1.AddrIP4.Addr32 = Addr2.AddrIP4.Addr32;
    iaIP6 : Result := IP6AddrIsEqual(Addr1.AddrIP6, Addr2.AddrIP6)
  else
    Result := False;
  end;
end;

procedure SocketAddrArrayAppend(var AddrArray: TSocketAddrArray; const Addr: TSocketAddr);
var L : Integer;
begin
  L := Length(AddrArray);
  SetLength(AddrArray, L + 1);
  AddrArray[L] := Addr;
end;

function SocketAddrArrayGetAddrIndex(const AddrArray: TSocketAddrArray; const Addr: TSocketAddr): Integer;
var I : Integer;
begin
  for I := 0 to Length(AddrArray) - 1 do
    if SocketAddrEqual(AddrArray[I], Addr) then
      begin
        Result := I;
        exit;
      end;
  Result := -1;
end;

function SocketAddrArrayHasAddr(const AddrArray: TSocketAddrArray; const Addr: TSocketAddr): Boolean;
begin
  Result := SocketAddrArrayGetAddrIndex(AddrArray, Addr) >= 0;
end;

function HostEntToSocketHost(const HostEnt: PHostEnt): TSocketHost;
var C, I : Integer;
begin
  if not Assigned(HostEnt) then
    begin
      Result.Used := False;
      Result.Host := '';
      Result.Alias := nil;
      Result.Addr := nil;
      exit;
    end;
  Result.Used := True;
  Result.Host := HostEntName(HostEnt);
  C := HostEntAddressesCount(HostEnt);
  SetLength(Result.Addr, C);
  for I := 0 to C - 1 do
    Result.Addr[I] := HostEntAddress(HostEnt, I);
end;

function SocketHandleArrayToFDSet(const Handles: TSocketHandleArray): TFDSet;
var I : Integer;
begin
  FD_ZERO(Result);
  for I := 0 to Length(Handles) - 1 do
    FD_SET(Handles[I], Result);
end;

{$IFDEF SOCKETLIB_WIN}
function FDSetToSocketHandleArray(const FDSet: TFDSet): TSocketHandleArray;
var I, L : Integer;
begin
  Result := nil;
  L := FD_COUNT(FDSet);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := FDSet.fd_array[I];
end;
{$ENDIF}
{$IFDEF SOCKETLIB_UNIX}
function FDSetToSocketHandleArray(const FDSet: TFDSet): TSocketHandleArray;
var I, L, J : Integer;
    F : LongInt;
begin
  Result := nil;
  L := FD_COUNT(FDSet);
  SetLength(Result, L);
  for I := 0 to FD_ARRAYSIZE - 1 do
    if FDSet.fds_bits[I] <> 0 then
      begin
        F := I * NFDBITS;
        for J := 0 to NFDBITS - 1 do
          begin
            if FD_ISSET(F, FDSet) then
              SocketHandleArrayAppend(Result, F);
            Inc(F);
          end;
      end;
end;
{$ENDIF}

procedure SocketHandleArrayAppend(var Handles: TSocketHandleArray; const Handle: TSocketHandle);
var L : Integer;
begin
  L := Length(Handles);
  SetLength(Handles, L + 1);
  Handles[L] := Handle;
end;

function SocketHandleArrayLocate(var Handles: TSocketHandleArray; const Handle: TSocketHandle): Integer;
var I : Integer;
begin
  for I := 0 to Length(Handles) - 1 do
    if Handles[I] = Handle then
      begin
        Result := I;
        exit;
      end;
  Result := -1;
end;

function AddrInfoCount(const AddrInfo: PAddrInfo; const Family: Word): Integer;
var CurrAddr : PAddrInfo;
    Found : Integer;
    SockAddr : PSockAddr;
begin
  CurrAddr := AddrInfo;
  Found := 0;
  while Assigned(CurrAddr) do
    begin
      SockAddr := CurrAddr^.ai_addr;
      if Assigned(SockAddr) and (SockAddr^.sa_family = Family) then
        Inc(Found);
      CurrAddr := CurrAddr^.ai_next;
    end;
  Result := Found;
end;



{                                                                              }
{ Socket library functions                                                     }
{                                                                              }
function SocketAccept(const S: TSocketHandle; out Addr: TSocketAddr): TSocketHandle;
var AAddrLen : Integer;
    AAddr    : TSockAddr;
    ASocket  : TSocketHandle;
begin
  AAddrLen := SizeOf(TSockAddr);
  FillChar(AAddr, SizeOf(TSockAddr), 0);
  ASocket := Accept(S, @AAddr, AAddrLen);
  if (ASocket <> INVALID_SOCKET) and (AAddrLen > 0) then
    begin
      Addr := SockAddrToSocketAddr(AAddr);
      Result := ASocket;
    end
  else
    begin
      InitSocketAddrNone(Addr);
      Result := INVALID_SOCKETHANDLE;
    end;
end;

function SocketBind(const S: TSocketHandle; const Addr: TSocketAddr): Integer;
var AAddr : TSockAddr;
begin
  AAddr := SocketAddrToSockAddr(Addr);
  Result := Bind(S, AAddr, SizeOf(AAddr));
end;

function SocketClose(const S: TSocketHandle): Integer;
begin
  Result := CloseSocket(S);
end;

function SocketConnect(const S: TSocketHandle; const Addr: TSocketAddr): Integer;
var AAddr : TSockAddr;
begin
  AAddr := SocketAddrToSockAddr(Addr);
  Result := Connect(S, @AAddr, SizeOf(AAddr));
end;

procedure SocketGetAddrInfo(
          const AddressFamily: TIPAddressFamily;
          const Protocol: TIPProtocol;
          const Host, Port: AnsiString;
          out Addresses: TSocketAddrArray);
var Hints    : TAddrInfo;
    AddrInfo : PAddrInfo;
    Error    : Integer;
    CurrAddr : PAddrInfo;
    Found    : Integer;
    AddrIdx  : Integer;
    SockAddr : PSockAddr;
    QHost    : PAnsiChar;
    QPort    : PAnsiChar;
begin
  // Initialize Hints for GetAddrInfo
  FillChar(Hints, Sizeof(TAddrInfo), 0);
  Hints.ai_family := IPAddressFamilyToAF(AddressFamily);
  if Hints.ai_family = AF_UNSPEC then
    raise ESocketLib.Create('Invalid address family');
  Hints.ai_protocol := IPProtocolToIPPROTO(Protocol);
  // GetAddrInfo
  AddrInfo := nil;
  if Host = '' then
    QHost := nil
  else
    QHost := PAnsiChar(Host);
  if Port = '' then
    QPort := nil
  else
    QPort := PAnsiChar(Port);
  {$IFDEF SOCKETLIB_WIN}
  if not WinSockStarted then
    WinSockStartup;
  {$ENDIF}
  Error := GetAddrInfo(QHost, QPort, @Hints, AddrInfo);
  if Error <> 0 then
    raise ESocketLib.Create('Lookup failed', SocketGetLastError);
  try
    // Count number of results
    Found := AddrInfoCount(AddrInfo, Hints.ai_family);
    if Found = 0 then
      // No results returned
      Addresses := nil
    else
      begin
        // Populate results
        SetLength(Addresses, Found);
        for AddrIdx := 0 to Found - 1 do
          InitSocketAddrNone(Addresses[AddrIdx]);
        CurrAddr := AddrInfo;
        AddrIdx := 0;
        while Assigned(CurrAddr) do
          begin
            SockAddr := CurrAddr^.ai_addr;
            if Assigned(SockAddr) and (SockAddr^.sa_family = Hints.ai_family) then
              begin
                Addresses[AddrIdx] := SockAddrToSocketAddr(PSockAddr(SockAddr)^);
                Inc(AddrIdx);
                if AddrIdx = Found then // last result
                  break;
              end;
            CurrAddr := CurrAddr^.ai_next;
          end;
      end;
  finally
    // Release resources allocated by GetAddrInfo
    FreeAddrInfo(AddrInfo);
  end;
end;

function SocketGetHostByAddr(const Addr: Pointer; const Len: Integer; const AF: Integer): TSocketHost;
var HostEnt : PHostEnt;
begin
  HostEnt := GetHostByAddr(Addr, Len, AF);
  Result := HostEntToSocketHost(HostEnt);
end;

function SocketGetHostByName(const Name: PAnsiChar): TSocketHost;
var HostEnt : PHostEnt;
begin
  HostEnt := GetHostByName(Name);
  Result := HostEntToSocketHost(HostEnt);
end;

function SocketGetHostName(const Name: PAnsiChar; const Len: Integer): Integer;
begin
  Result := GetHostName(Name, Len);
end;

function SocketGetNameInfo(const Address: TSocketAddr): AnsiString;
var Hints : TAddrInfo;
    Host  : Array[0..NI_MAXHOST] of AnsiChar;
    Serv  : Array[0..NI_MAXSERV] of AnsiChar;
    Error : Integer;
    Addr  : TSockAddr;
begin
  Addr := SocketAddrToSockAddr(Address);
  FillChar(Hints, Sizeof(TAddrInfo), 0);
  Hints.ai_family := Addr.sa_family;
  FillChar(Host, Sizeof(Host), 0);
  FillChar(Serv, Sizeof(Serv), 0);
  {$IFDEF SOCKETLIB_WIN}
  if not WinSockStarted then
    WinSockStartup;
  {$ENDIF}
  Error := GetNameInfo(@Addr, SockAddrLen(Addr), @Host, NI_MAXHOST,
      @Serv, NI_MAXSERV, NI_NUMERICSERV);
  if Error <> 0 then
    raise ESocketLib.Create('Reverse lookup failed', SocketGetLastError);
  Result := StrZPasA(PAnsiChar(@Host));
end;

function SocketGetPeerName(const S: TSocketHandle; out Name: TSocketAddr): Integer;
var Addr : TSockAddr;
    L : Integer;
begin
  L := SizeOf(Addr);
  Result := GetPeerName(S, Addr, L);
  Name := SockAddrToSocketAddr(Addr);
end;

function SocketGetServByName(const Name, Proto: PAnsiChar): PServEnt;
begin
  Result := GetServByName(Name, Proto);
end;

function SocketGetServByPort(const Port: Integer; const Proto: PAnsiChar): PServEnt;
begin
  Result := GetServByPort(Port, Proto);
end;

function SocketGetSockName(const S: TSocketHandle; out Name: TSocketAddr): Integer;
var Addr : TSockAddr;
    L : Integer;
begin
  L := SizeOf(Addr);
  Result := GetSockName(S, Addr, L);
  Name := SockAddrToSocketAddr(Addr);
end;

function SocketGetSockOpt(const S: TSocketHandle; const Level, OptName: Integer;
         const OptVal: Pointer; var OptLen: Integer): Integer;
begin
  FillChar(OptVal^, OptLen, 0);
  Result := GetSockOpt(S, Level, OptName, OptVal, OptLen);
end;

function Sockethtons(const HostShort: Word): Word;
begin
  Result := htons(HostShort);
end;

function Sockethtonl(const HostLong: LongWord): LongWord;
begin
  Result := htonl(HostLong);
end;

function Socketinet_ntoa(const InAddr: TIP4Addr): RawByteString;
var A : TInAddr;
begin
  A.S_addr := InAddr.Addr32;
  Result := StrZPasB(inet_ntoa(A));
end;

function Socketinet_addr(const P: PAnsiChar): TIP4Addr;
begin
  Result.Addr32 := inet_addr(P);
end;

function SocketListen(const S: TSocketHandle; const Backlog: Integer): Integer;
begin
  Result := Listen(S, Backlog);
end;

function Socketntohs(const NetShort: Word): Word;
begin
  Result := ntohs(NetShort);
end;

function Socketntohl(const NetLong: LongWord): LongWord;
begin
  Result := ntohl(NetLong);
end;

function SocketRecvFlagsToFlags(const Flags: TSocketRecvFlags): LongInt;
var F : LongInt;
begin
  F := 0;
  if srfOOB in Flags then
    F := F or MSG_OOB;
  if srfPeek in Flags then
    F := F or MSG_PEEK;
  Result := F;
end;

function SocketRecv(const S: TSocketHandle; var Buf; const Len: Integer; const Flags: TSocketRecvFlags): Integer;
begin
  Result := Recv(S, Buf, Len, SocketRecvFlagsToFlags(Flags));
end;

function SocketRecvFrom(const S: TSocketHandle; var Buf; const Len: Integer; const Flags: TSocketRecvFlags;
         out From: TSocketAddr): Integer;
var Addr : TSockAddr;
    L : Integer;
begin
  L := SizeOf(Addr);
  Result := RecvFrom(S, Buf, Len, SocketRecvFlagsToFlags(Flags), Addr, L);
  if Result <> SOCKET_ERROR then
    From := SockAddrToSocketAddr(Addr);
end;

function SocketSelect(const nfds: LongWord;
         var ReadFDS, WriteFDS, ExceptFDS: TSocketHandleArray;
         const TimeOutMicroseconds: Int64): Integer;
var R, W, E : TFDSet;
    T       : TTimeVal;
    P       : PTimeVal;
begin
  R := SocketHandleArrayToFDSet(ReadFDS);
  W := SocketHandleArrayToFDSet(WriteFDS);
  E := SocketHandleArrayToFDSet(ExceptFDS);
  if TimeOutMicroseconds >= 0 then
    begin
      FillChar(T, Sizeof(TTimeVal), 0);
      T.tv_sec  := TimeOutMicroseconds div 1000000;
      T.tv_usec := TimeOutMicroseconds mod 1000000;
      P := @T;
    end
  else
    P := nil;
  Result := Select(nfds, @R, @W, @E, P);
  if Result >= 0 then
    begin
      ReadFDS := FDSetToSocketHandleArray(R);
      WriteFDS := FDSetToSocketHandleArray(W);
      ExceptFDS := FDSetToSocketHandleArray(E);
    end;
end;

function SocketSelect(const S: TSocketHandle;
         var ReadSelect, WriteSelect, ExceptSelect: Boolean;
         const TimeOutMicroseconds: Int64): Integer;
var R, W, E : TFDSet;
    T       : TTimeVal;
    P       : PTimeVal;
begin
  FD_ZERO(R);
  FD_ZERO(W);
  FD_ZERO(E);
  if ReadSelect then
    FD_SET(S, R);
  if WriteSelect then
    FD_SET(S, W);
  if ExceptSelect then
    FD_SET(S, E);
  if TimeOutMicroseconds >= 0 then
    begin
      FillChar(T, Sizeof(TTimeVal), 0);
      T.tv_sec  := TimeOutMicroseconds div 1000000;
      T.tv_usec := TimeOutMicroseconds mod 1000000;
      P := @T;
    end
  else
    P := nil;
  Result := Select(S + 1, @R, @W, @E, P);
  if Result >= 0 then
    begin
      if ReadSelect then
        ReadSelect := FD_ISSET(S, R);
      if WriteSelect then
        WriteSelect := FD_ISSET(S, W);
      if ExceptSelect then
        ExceptSelect := FD_ISSET(S, E);
    end;
end;

function SocketSend(const S: TSocketHandle; const Buf; const Len, Flags: Integer): Integer;
begin
  Result := Send(S, Buf, Len, Flags);
end;

function SocketSendTo(const S: TSocketHandle; const Buf; const Len, Flags: Integer;
         const AddrTo: TSocketAddr): Integer;
var Addr : TSockAddr;
begin
  Addr := SocketAddrToSockAddr(AddrTo);
  Result := SendTo(S, Buf, Len, Flags, @Addr, SizeOf(Addr));
end;

function SocketSetSockOpt(const S: TSocketHandle; const Level, OptName: Integer;
         const OptVal: Pointer; const OptLen: Integer): Integer;
begin
  Result := SetSockOpt(S, Level, OptName, OptVal, OptLen);
end;

{$IFDEF SOCKETLIB_UNIX}
function SocketShutdown(const S: TSocketHandle; const How: TSocketShutdown): Integer;
begin
  Result := 0;
end;
{$ENDIF}

{$IFDEF SOCKETLIB_WIN}
function SocketShutdown(const S: TSocketHandle; const How: TSocketShutdown): Integer;
var H : Integer;
begin
  case How of
    ssBoth : H := SD_BOTH;
    ssSend : H := SD_SEND;
    ssRecv : H := SD_RECEIVE;
  else
    H := SD_BOTH;
  end;
  Result := Shutdown(S, H);
end;
{$ENDIF}

function SocketSocket(const Family: TIPAddressFamily; const Struct: Integer; const Protocol: TIPProtocol): TSocketHandle;
var AF, Pr : Integer;
begin
  AF := IPAddressFamilyToAF(Family);
  Pr := IPProtocolToIPPROTO(Protocol);
  Result := Socket(AF, Struct, Pr);
end;



{                                                                              }
{ Socket library errors                                                        }
{                                                                              }
function ESocketLibErrorMsg(const Msg: String; const ErrorCode: Integer): String;
var S : String;
begin
  if ErrorCode <> 0 then
    begin
      S := SocketGetErrorMessage(ErrorCode);
      if Msg <> '' then
        S := Format('%s: %s', [Msg, S]);
    end
  else
    S := Msg;
  Result := S;
end;

constructor ESocketLib.Create(const Msg: String; const ErrorCode: Integer);
begin
  inherited Create(ESocketLibErrorMsg(Msg, ErrorCode));
  FErrorCode := ErrorCode;
end;

constructor ESocketLib.CreateFmt(const Msg: String; const Args: array of const;
    const ErrorCode: Integer);
begin
  inherited CreateFmt(ESocketLibErrorMsg(Msg, ErrorCode), Args);
  FErrorCode := ErrorCode;
end;

{$IFNDEF FREEPASCAL}
constructor ESocketLib.CreateResFmt(Ident: Integer; const Args: array of TVarRec;
    const ErrorCode: Integer);
begin
  inherited CreateResFmt(Ident, Args);
  FErrorCode := ErrorCode;
end;
{$ENDIF}

{$IFDEF SOCKETLIB_UNIX}
function SocketGetLastError: Integer;
begin
  Result := flcUnixSock.SockGetLastError;
end;
{$ENDIF}
{$IFDEF SOCKETLIB_WIN}
function SocketGetLastError: Integer;
begin
  Result := flcWinSock.WSAGetLastError;
end;
{$ENDIF}

function SocketGetErrorMessage(const ErrorCode: Integer): String;
begin
  case ErrorCode of
    0                      : Result := '';
    EINTR                  : Result := 'Operation interrupted';
    EBADF                  : Result := 'Invalid handle';
    EACCES                 : Result := 'Permission denied';
    EFAULT                 : Result := 'Invalid pointer';
    EINVAL                 : Result := 'Invalid argument';
    EMFILE                 : Result := 'Too many open handles';
    EWOULDBLOCK            : Result := 'Blocking operation';
    EINPROGRESS            : Result := 'Operation in progress';
    EALREADY               : Result := 'Operation already performed';
    ENOTSOCK               : Result := 'Socket operation on non-socket or not connected';
    EDESTADDRREQ           : Result := 'Destination address required';
    EMSGSIZE               : Result := 'Invalid message size';
    EPROTOTYPE             : Result := 'Invalid protocol type';
    ENOPROTOOPT            : Result := 'Protocol not available';
    EPROTONOSUPPORT        : Result := 'Protocol not supported';
    ESOCKTNOSUPPORT        : Result := 'Socket type not supported';
    EOPNOTSUPP             : Result := 'Socket operation not supported';
    EPFNOSUPPORT           : Result := 'Protocol family not supported';
    EAFNOSUPPORT           : Result := 'Address family not supported by protocol family';
    EADDRINUSE             : Result := 'Address in use';
    EADDRNOTAVAIL          : Result := 'Address not available';
    ENETDOWN	             : Result := 'The network is down';
    ENETUNREACH            : Result := 'The network is unreachable';
    ENETRESET              : Result := 'Network connection reset';
    ECONNABORTED           : Result := 'Connection aborted';
    ECONNRESET             : Result := 'Connection reset by peer';
    ENOBUFS	               : Result := 'No buffer space available';
    EISCONN                : Result := 'Socket connected';
    ENOTCONN               : Result := 'Socket not connected';
    ESHUTDOWN              : Result := 'Socket shutdown';
    ETOOMANYREFS           : Result := 'Too many references';
    ETIMEDOUT              : Result := 'Connection timed out';
    ECONNREFUSED           : Result := 'Connection refused';
    ENAMETOOLONG           : Result := 'Name too long';
    EHOSTDOWN              : Result := 'Host is unavailable';
    EHOSTUNREACH           : Result := 'Host is unreachable';
    {$IFDEF SOCKETLIB_WIN}
    HOST_NOT_FOUND         : Result := 'Host not found';
    TRY_AGAIN              : Result := 'Try again';
    NO_RECOVERY            : Result := 'Nonrecoverable error';
    ENOMEM                 : Result := 'Insufficient memory';
    {$ENDIF}
  else
    {$IFDEF SOCKETLIB_WIN}
    Result := flcWinSock.WinSockErrorMessage(ErrorCode);
    {$ELSE}
    {$IFDEF SOCKETLIB_UNIX}
    Result := flcUnixSock.UnixSockErrorMessage(ErrorCode);
    {$ELSE}
    Result := Format('System error #%d', [ErrorCode]);
    {$ENDIF}
    {$ENDIF}
  end;
end;



{                                                                              }
{ IP Addresses                                                                 }
{                                                                              }
function IsIP4AddressA(const Address: RawByteString; out NetAddress: TIP4Addr): Boolean;
var I, L, N : Integer;
begin
  // Validate length: shortest full IP address is 7 characters: #.#.#.#
  L := Length(Address);
  if L < 7 then
    begin
      NetAddress := IP4AddrNone;
      Result := False;
      exit;
    end;
  // Validate number of '.' characters: full IP address must have 3 dots
  N := 0;
  for I := 1 to L do
    if Address[I] = '.' then
      Inc(N);
  if N <> 3 then
    begin
      NetAddress := IP4AddrNone;
      Result := False;
      exit;
    end;
  // Use system to resolve IP
  {$IFDEF SOCKETLIB_WIN}
  if not WinSockStarted then
    WinSockStartup;
  {$ENDIF}
  NetAddress := Socketinet_addr(PAnsiChar(Address));
  if NetAddress.Addr32 <> LongWord(INADDR_NONE) then
    Result := True
  else
    // Check for broadcast IP (INADDR_NONE = INADDR_BROADCAST)
    if Address = IP4AddrStrBroadcast then
      begin
        NetAddress := IP4AddrBroadcast;
        Result := True;
      end
    else
      // Unable to resolve IP
      Result := False;
end;

function IsIP6AddressA(const Address: RawByteString; out NetAddress: TIP6Addr): Boolean;
var Hints    : TAddrInfo;
    AddrInfo : PAddrInfo;
    CurrAddr : PAddrInfo;
    Error    : Integer;
    SockAddr : PSockAddr;
begin
  // Check length
  if Length(Address) <= 1 then
    begin
      IP6AddrSetZero(NetAddress);
      Result := False;
      exit;
    end;
  // Check special addresses
  if (Address = IP6AddrStrUnspecified) or (Address = IP6AddrStrAnyHost) then
    begin
      IP6AddrSetZero(NetAddress);
      Result := True;
      exit;
    end;
  // Use system to resolve IP
  {$IFDEF SOCKETLIB_WIN}
  if not WinSockStarted then
    WinSockStartup;
  {$ENDIF}
  // Call GetAddrInfo with IP6 address family hint
  FillChar(Hints, Sizeof(TAddrInfo), 0);
  Hints.ai_flags := AI_NUMERICHOST;
  Hints.ai_family := AF_INET6;
  AddrInfo := nil;
  Error := GetAddrInfo(PAnsiChar(Address), nil, @Hints, AddrInfo);
  if (Error = 0) and Assigned(AddrInfo) then
    try
      // Iterate through list of returned addresses until IP6 address is found
      CurrAddr := AddrInfo;
      Result := False;
      repeat
        SockAddr := CurrAddr^.ai_addr;
        if Assigned(SockAddr) and (SockAddr^.sa_family = AF_INET6) then
          begin
            // Found
            Move(SockAddr^.sin6_addr.u6_addr32, NetAddress.Addr32, SizeOf(TIP6Addr));
            Result := True;
            break;
          end;
        CurrAddr := CurrAddr^.ai_next;
      until not Assigned(CurrAddr);
      if not Result then
        IP6AddrSetZero(NetAddress);
    finally
      // Release resources allocated by GetAddrInfo
      FreeAddrInfo(AddrInfo);
    end
  else
    begin
      // Failure
      IP6AddrSetZero(NetAddress);
      Result := False;
    end;
end;

function IsIP4AddressU(const Address: UnicodeString; out NetAddress: TIP4Addr): Boolean;
begin
  Result := IsIP4AddressA(UTF8Encode(Address), NetAddress);
end;

{$IFDEF SOCKETLIB_WIN}
function IsIP6AddressU(const Address: UnicodeString; out NetAddress: TIP6Addr): Boolean;
var Hints    : TAddrInfoW;
    AddrInfo : PAddrInfoW;
    CurrAddr : PAddrInfoW;
    Error    : Integer;
    SockAddr : PSockAddr;
begin
  // Check length
  if Length(Address) <= 1 then
    begin
      IP6AddrSetZero(NetAddress);
      Result := False;
      exit;
    end;
  // Check special addresses
  if (Address = IP6AddrStrUnspecified) or (Address = IP6AddrStrAnyHost) then
    begin
      IP6AddrSetZero(NetAddress);
      Result := True;
      exit;
    end;
  // Use system to resolve IP
  {$IFDEF SOCKETLIB_WIN}
  if not WinSockStarted then
    WinSockStartup;
  {$ENDIF}
  // Call GetAddrInfo with IP6 address family hint
  FillChar(Hints, Sizeof(TAddrInfoW), 0);
  Hints.ai_flags := AI_NUMERICHOST;
  Hints.ai_family := AF_INET6;
  AddrInfo := nil;
  Error := GetAddrInfoW(PWideChar(Address), nil, @Hints, AddrInfo);
  if (Error = 0) and Assigned(AddrInfo) then
    try
      // Iterate through list of returned addresses until IP6 address is found
      CurrAddr := AddrInfo;
      Result := False;
      repeat
        SockAddr := CurrAddr^.ai_addr;
        if Assigned(SockAddr) and (SockAddr^.sa_family = AF_INET6) then
          begin
            // Found
            Move(SockAddr^.sin6_addr.u6_addr32, NetAddress.Addr32, SizeOf(TIP6Addr));
            Result := True;
            break;
          end;
        CurrAddr := CurrAddr^.ai_next;
      until not Assigned(CurrAddr);
      if not Result then
        IP6AddrSetZero(NetAddress);
    finally
      // Release resources allocated by GetAddrInfo
      FreeAddrInfoW(AddrInfo);
    end
  else
    begin
      // Failure
      IP6AddrSetZero(NetAddress);
      Result := False;
    end;
end;
{$ENDIF}

function IsIP4Address(const Address: String; out NetAddress: TIP4Addr): Boolean;
begin
  {$IFDEF StringIsUnicode}
  Result := IsIP4AddressU(Address, NetAddress);
  {$ELSE}
  Result := IsIP4AddressA(Address, NetAddress);
  {$ENDIF}
end;

function IsIP6Address(const Address: String; out NetAddress: TIP6Addr): Boolean;
begin
  {$IFDEF StringIsUnicode}
  Result := IsIP6AddressU(Address, NetAddress);
  {$ELSE}
  Result := IsIP6AddressA(Address, NetAddress);
  {$ENDIF}
end;

function IP4AddressStrA(const Address: TIP4Addr): RawByteString;
begin
  Result := Socketinet_ntoa(Address);
end;

function IP6AddressStrA(const Address: TIP6Addr): RawByteString;
var I : Integer;
begin
  // Handle special addresses
  if IP6AddrIsZero(Address) then
    begin
      Result := IP6AddrStrUnspecified;
      exit;
    end;
  if IP6AddrIsLocalHost(Address) then
    begin
      Result := IP6AddrStrLocalHost;
      exit;
    end;
  // Return full IP6 address
  Result := '';
  for I := 0 to 7 do
    begin
      Result := Result + LongWordToHexB(ntohs(Address.Addr16[I]), 0, True);
      if I < 7 then
        Result := Result + ':';
    end;
  AsciiConvertLowerB(Result);
end;

function IP4AddressStr(const Address: TIP4Addr): String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(IP4AddressStrA(Address));
  {$ELSE}
  Result := IP4AddressStrA(Address);
  {$ENDIF}
end;

function IP6AddressStr(const Address: TIP6Addr): String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(IP6AddressStrA(Address));
  {$ELSE}
  Result := IP6AddressStrA(Address);
  {$ENDIF}
end;

function IP4AddressType(const Address: TIP4Addr): TIP4AddressType;
begin
  Result := inaPublic;
  case Address.Addr8[0] of
    0        : if Address.Addr32 = 0 then
                 Result := inaNone
               else
                 Result := inaReserved;
    10       : Result := inaPrivate;
    127      : Result := inaLoopback;
    169      : if Address.Addr8[1] = 254 then
                 Result := inaLinkLocalNetwork;
    172      : if Address.Addr8[1] and $F0 = $10 then
                 Result := inaPrivate;
    192      : case Address.Addr8[1] of
                 0   : if Address.Addr8[2] = 2 then
                         Result := inaTestNetwork;
                 168 : Result := inaPrivate;
               end;
    224..239 : Result := inaMulticast;
    240..254 : Result := inaReserved;
    255      : if Address.Addr32 = $FFFFFFFF then
                 Result := inaBroadcast
               else
                 Result := inaReserved;
  end;
end;

function IsPrivateIP4Address(const Address: TIP4Addr): Boolean;
begin
  Result := IP4AddressType(Address) = inaPrivate;
end;

function IsInternetIP4Address(const Address: TIP4Addr): Boolean;
begin
  Result := IP4AddressType(Address) = inaPublic;
end;

procedure SwapIP4Endian(var Address: TIP4Addr);
var A : Byte;
begin
  A := Address.Addr8[0];
  Address.Addr8[0] := Address.Addr8[3];
  Address.Addr8[3] := A;
  A := Address.Addr8[1];
  Address.Addr8[1] := Address.Addr8[2];
  Address.Addr8[2] := A;
end;


{                                                                              }
{ HostEnt functions                                                            }
{                                                                              }
function HostEntAddressesCount(const HostEnt: PHostEnt): Integer;
var P : ^PInAddr;
    Q : PInAddr;
begin
  Result := 0;
  if not Assigned(HostEnt) then
    exit;
  Assert(HostEnt^.h_addrtype = AF_INET);
  Assert(HostEnt^.h_length = Sizeof(TInAddr));
  P := Pointer(HostEnt^.h_addr_list);
  if not Assigned(P) then
    exit;
  Q := P^;
  while Assigned(Q) do
    begin
      Inc(P);
      Inc(Result);
      Q := P^
    end;
end;

function HostEntAddresses(const HostEnt: PHostEnt): TIP4AddrArray;
var P : ^PInAddr;
    I, L : Integer;
begin
  L := HostEntAddressesCount(HostEnt);
  SetLength(Result, L);
  if L = 0 then
    exit;
  P := Pointer(HostEnt^.h_addr_list);
  for I := 0 to L - 1 do
    begin
      Result[I].Addr32 := P^^.S_addr;
      Inc(P);
    end;
end;

function HostEntAddress(const HostEnt: PHostEnt; const Index: Integer): TSocketAddr;
var A : TIPAddressFamily;
    L : Integer;
    P : ^Pointer;
    Q : Pointer;
    I : Integer;
begin
  InitSocketAddrNone(Result);
  if not Assigned(HostEnt) then
    exit;
  A := AFToIPAddressFamily(HostEnt^.h_addrtype);
  if A = iaNone then
    raise ESocketLib.Create('Invalid address family');
  L := HostEnt^.h_length;
  Assert( ((A = iaIP4) and (L = Sizeof(TInAddr))) or
          ((A = iaIP6) and (L = Sizeof(TIn6Addr))) );
  P := Pointer(HostEnt^.h_addr_list);
  if not Assigned(P) then
    exit;
  Q := P^;
  I := 0;
  while Assigned(Q) and (I < Index) do
    begin
      Inc(P);
      Inc(I);
      Q := P^
    end;
  if not Assigned(Q) then
    exit;
  Result.AddrFamily := A;
  case A of
    iaIP4 : Result.AddrIP4.Addr32 := PInAddr(Q)^.S_addr;
    iaIP6 : Move(PIn6Addr(Q)^, Result.AddrIP6, SizeOf(TIP6Addr));
  end;
end;

function HostEntAddressIP4(const HostEnt: PHostEnt; const Index: Integer): TIP4Addr;
var P : ^PInAddr;
    Q : PInAddr;
    I : Integer;
begin
  Result := IP4AddrNone;
  if not Assigned(HostEnt) then
    exit;
  Assert(HostEnt^.h_addrtype = AF_INET);
  Assert(HostEnt^.h_length = Sizeof(TInAddr));
  P := Pointer(HostEnt^.h_addr_list);
  if not Assigned(P) then
    exit;
  Q := P^;
  I := 0;
  while Assigned(Q) and (I < Index) do
    begin
      Inc(P);
      Inc(I);
      Q := P^
    end;
  if Assigned(Q) then
    Result.Addr32 := Q^.S_addr;
end;

function HostEntAddressStr(const HostEnt: PHostEnt; const Index: Integer): RawByteString;
begin
  Result := IP4AddressStrA(HostEntAddressIP4(HostEnt, Index));
end;

function HostEntName(const HostEnt: PHostEnt): AnsiString;
begin
  Result := StrZPasA(HostEnt.h_name);
end;



{                                                                              }
{ SocketProtocolAsString                                                       }
{                                                                              }
const
  ProtocolStr: Array[TIPProtocol] of RawByteString =
      ('', 'ip', 'icmp', 'tcp', 'udp', 'raw');

function IPProtocolToStrA(const Protocol: TIPProtocol): RawByteString;
var ProtoNum : Integer;
    PEnt     : PProtoEnt;
begin
  case Protocol of
    ipTCP : ProtoNum := IPPROTO_TCP;
    ipUDP : ProtoNum := IPPROTO_UDP;
    ipRaw : ProtoNum := IPPROTO_RAW;
  else
    ProtoNum := -1;
  end;
  if ProtoNum >= 0 then
    begin
      {$IFDEF SOCKETLIB_WIN}
      if not WinSockStarted then
        WinSockStartup;
      {$ENDIF}
      PEnt := GetProtoByNumber(ProtoNum);
      if Assigned(PEnt) then
        Result := StrZPasB(PEnt^.p_name)
      else
        Result := ProtocolStr[Protocol];
    end
  else
    Result := '';
end;

function StrToIPProtocolA(const Protocol: RawByteString): TIPProtocol;
var I    : TIPProtocol;
    PEnt : PProtoEnt;
begin
  PEnt := GetProtoByName(PAnsiChar(Protocol));
  if Assigned(PEnt) then
    case PEnt^.p_proto of
      IPPROTO_TCP : Result := ipTCP;
      IPPROTO_UDP : Result := ipUDP;
      IPPROTO_RAW : Result := ipRaw;
    else
      Result := ipNone;
    end
  else
    begin
      for I := Low(TIPProtocol) to High(TIPProtocol) do
        if StrEqualNoAsciiCaseB(Protocol, ProtocolStr[I]) then
          begin
            Result := I;
            exit;
          end;
      Result := ipNone;
    end;
end;

function IPProtocolToStr(const Protocol: TIPProtocol): String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(IPProtocolToStrA(Protocol));
  {$ELSE}
  Result := IPProtocolToStrA(Protocol);
  {$ENDIF}
end;

function StrToIPProtocol(const Protocol: String): TIPProtocol;
begin
  {$IFDEF StringIsUnicode}
  Result := StrToIPProtocolA(AnsiString(Protocol));
  {$ELSE}
  Result := StrToIPProtocolA(Protocol);
  {$ENDIF}
end;


{                                                                              }
{ Local Host                                                                   }
{                                                                              }
function LocalHostNameA: AnsiString;
var Buf : Array[0..1024] of AnsiChar;
    Err : Integer;
begin
  {$IFDEF SOCKETLIB_WIN}
  if not WinSockStarted then
    WinSockStartup;
  {$ENDIF}
  FillChar(Buf, Sizeof(Buf), 0);
  Err := SocketGetHostName(@Buf, Sizeof(Buf) - 1);
  if Err <> 0 then
    raise ESocketLib.Create('Local host name not available', Err);
  Result := StrZPasA(PAnsiChar(@Buf));
end;

function LocalHostName: String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(LocalHostNameA);
  {$ELSE}
  Result := LocalHostNameA;
  {$ENDIF}
end;

function LocalIPAddresses: TIP4AddrArray;
begin
  {$IFDEF SOCKETLIB_WIN}
  if not WinSockStarted then
    WinSockStartup;
  {$ENDIF}
  Result := HostEntAddresses(GetHostByName(PAnsiChar(LocalHostNameA)));
end;

function LocalIP6Addresses: TIP6AddrArray;
var Addr : TSocketAddrArray;
    L, I : Integer;
begin
  SocketGetAddrInfo(iaIP6, ipNone, LocalHostNameA, '', Addr);
  L := Length(Addr);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    IP6AddrAssign(Result[I], Addr[I].AddrIP6);
end;

function LocalIP4AddressesStrA: AddressStrArrayA;
var V : TIP4AddrArray;
    I, L : Integer;
begin
  V := LocalIPAddresses;
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := IP4AddressStrA(V[I]);
end;

function LocalIP6AddressesStrA: AddressStrArrayA;
var V : TIP6AddrArray;
    I, L : Integer;
begin
  V := LocalIP6Addresses;
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := IP6AddressStrA(V[I]);
end;

function LocalIP4AddressesStr: AddressStrArray;
var V : TIP4AddrArray;
    I, L : Integer;
begin
  V := LocalIPAddresses;
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := IP4AddressStr(V[I]);
end;

function LocalIP6AddressesStr: AddressStrArray;
var V : TIP6AddrArray;
    I, L : Integer;
begin
  V := LocalIP6Addresses;
  L := Length(V);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := IP6AddressStr(V[I]);
end;

function GuessInternetIP4: TIP4Addr;
var A : TIP4AddrArray;
    I : Integer;
begin
  A := LocalIPAddresses;
  for I := 0 to Length(A) - 1 do
    if IsInternetIP4Address(A[I]) then
      begin
        Result.Addr32 := A[I].Addr32;
        exit;
      end;
  Result := IP4AddrNone;
end;

function GuessInternetIP4StrA: RawByteString;
var A : TIP4Addr;
begin
  A := GuessInternetIP4;
  if LongInt(A) = LongInt(INADDR_NONE) then
    Result := ''
  else
    Result := IP4AddressStrA(A);
end;

function GuessInternetIP4Str: String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(GuessInternetIP4StrA);
  {$ELSE}
  Result := GuessInternetIP4StrA;
  {$ENDIF}
end;



{                                                                              }
{ Remote host name                                                             }
{                                                                              }
function GetRemoteHostNameA(const Address: TSocketAddr): AnsiString;
var NewAPI  : Boolean;
    HostEnt : TSocketHost;
begin
  {$IFDEF SOCKETLIB_WIN}
  if not WinSockStarted then
    WinSockStartup;
  {$ENDIF}
  NewAPI := {$IFDEF SOCKETLIB_WIN}WinSock2API or{$ENDIF}
            (Address.AddrFamily = iaIP6);
  if NewAPI then
    begin
      Result := SocketGetNameInfo(Address);
      exit;
    end;
  case Address.AddrFamily of
    iaIP4 : HostEnt := SocketGetHostByAddr(@Address.AddrIP4, Sizeof(TInAddr), AF_INET);
    iaIP6 : HostEnt := SocketGetHostByAddr(@Address.AddrIP6, Sizeof(TIn6Addr), AF_INET6);
  else
    raise ESocketLib.Create('Invalid address family');
  end;
  if not HostEnt.Used then
    raise ESocketLib.Create('Reverse lookup failed', SocketGetLastError);
  Result := HostEnt.Host;
end;

function GetRemoteHostNameA(const Address: TIP4Addr): AnsiString;
var S : TSocketAddr;
begin
  InitSocketAddrNone(S);
  S.AddrFamily := iaIP4;
  S.AddrIP4 := Address;
  Result := GetRemoteHostNameA(S);
end;

function GetRemoteHostNameA(const Address: TIP6Addr): AnsiString;
var S : TSocketAddr;
begin
  InitSocketAddrNone(S);
  S.AddrFamily := iaIP6;
  IP6AddrAssign(S.AddrIP6, Address);
  Result := GetRemoteHostNameA(S);
end;

function GetRemoteHostName(const Address: TSocketAddr): String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(GetRemoteHostNameA(Address));
  {$ELSE}
  Result := GetRemoteHostNameA(Address);
  {$ENDIF}
end;

function GetRemoteHostName(const Address: TIP4Addr): String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(GetRemoteHostNameA(Address));
  {$ELSE}
  Result := GetRemoteHostNameA(Address);
  {$ENDIF}
end;

function GetRemoteHostName(const Address: TIP6Addr): String;
begin
  {$IFDEF StringIsUnicode}
  Result := String(GetRemoteHostNameA(Address));
  {$ELSE}
  Result := GetRemoteHostNameA(Address);
  {$ENDIF}
end;



{                                                                              }
{ Resolve host                                                                 }
{                                                                              }
function ResolveHostExA(const Host: AnsiString;
    const AddressFamily: TIPAddressFamily): TSocketAddrArray;
var NewAPI  : Boolean;
    HostEnt : PHostEnt;
    InAddr  : TIP4Addr;
    In6Addr : TIP6Addr;
    InAddrs : TIP4AddrArray;
    L, I    : Integer;
begin
  {$IFDEF DELPHI7_DOWN}
  InAddrs := nil;
  {$ENDIF}
  if Host = '' then
    raise ESocketLib.Create('Host not specified');
  if AddressFamily = iaIP4 then
    if IsIP4AddressA(Host, InAddr) then
      begin
        SetLength(Result, 1);
        InitSocketAddr(Result[0], InAddr, 0);
        exit;
      end;
  if AddressFamily = iaIP6 then
    if IsIP6AddressA(Host, In6Addr) then
      begin
        SetLength(Result, 1);
        InitSocketAddr(Result[0], In6Addr, 0);
        exit;
      end;
  {$IFDEF SOCKETLIB_WIN}
  if not WinSockStarted then
    WinSockStartup;
  {$ENDIF}
  NewAPI :=
      {$IFDEF SOCKETLIB_WIN}WinSock2API or{$ENDIF}
      (AddressFamily = iaIP6);
  if NewAPI then
    begin
      SocketGetAddrInfo(AddressFamily, ipNone, Host, '', Result);
      exit;
    end;
  HostEnt := GetHostByName(PAnsiChar(Host));
  if Assigned(HostEnt) then
    begin
      InAddrs := HostEntAddresses(HostEnt);
      L := Length(InAddrs);
      SetLength(Result, L);
      for I := 0 to L - 1 do
        InitSocketAddr(Result[I], InAddrs[I], 0);
    end
  else
    raise ESocketLib.Create('Failed to resolve host', SocketGetLastError);
end;

function ResolveHostA(const Host: AnsiString;
    const AddressFamily: TIPAddressFamily): TSocketAddr;
var A : TSocketAddrArray;
begin
  A := ResolveHostExA(Host, AddressFamily);
  if Length(A) = 0 then
    raise ESocketLib.Create('Failed to resolve host');
  Result := A[0];
end;

function ResolveHostEx(const Host: String; const AddressFamily: TIPAddressFamily): TSocketAddrArray;
begin
  {$IFDEF StringIsUnicode}
  Result := ResolveHostExA(AnsiString(Host), AddressFamily);
  {$ELSE}
  Result := ResolveHostExA(Host, AddressFamily);
  {$ENDIF}
end;

function ResolveHost(const Host: String; const AddressFamily: TIPAddressFamily): TSocketAddr;
begin
  {$IFDEF StringIsUnicode}
  Result := ResolveHostA(AnsiString(Host), AddressFamily);
  {$ELSE}
  Result := ResolveHostA(Host, AddressFamily);
  {$ENDIF}
end;

function ResolveHostIP4ExA(const Host: AnsiString): TIP4AddrArray;
var HostEnt : PHostEnt;
    InAddr  : TIP4Addr;
    {$IFDEF SOCKETLIB_WIN}
    Addrs   : TSocketAddrArray;
    I, L    : Integer;
    {$ENDIF}
begin
  if Host = '' then
    raise ESocketLib.Create('Host not specified');
  if IsIP4AddressA(Host, InAddr) then
    begin
      SetLength(Result, 1);
      Result[0] := InAddr;
      exit;
    end;
  {$IFDEF SOCKETLIB_WIN}
  if not WinSockStarted then
    WinSockStartup;
  if WinSock2API then
    begin
      SocketGetAddrInfo(iaIP4, ipNone, Host, '', Addrs);
      L := Length(Addrs);
      if L = 0 then
        raise ESocketLib.Create('Failed to resolve host', SocketGetLastError);
      SetLength(Result, L);
      for I := 0 to L - 1 do
        Result[I] := Addrs[I].AddrIP4;
      exit;
    end;
  {$ENDIF}
  HostEnt := GetHostByName(PAnsiChar(Host));
  if Assigned(HostEnt) then
    Result := HostEntAddresses(HostEnt)
  else
    raise ESocketLib.Create('Failed to resolve host', SocketGetLastError);
end;

function ResolveHostIP4A(const Host: AnsiString): TIP4Addr;
var A : TIP4AddrArray;
begin
  A := ResolveHostIP4ExA(Host);
  if Length(A) = 0 then
    raise ESocketLib.Create('Failed to resolve host');
  Result.Addr32 := A[0].Addr32;
end;

function ResolveHostIP4Ex(const Host: String): TIP4AddrArray;
begin
  {$IFDEF StringIsUnicode}
  Result := ResolveHostIP4ExA(AnsiString(Host));
  {$ELSE}
  Result := ResolveHostIP4ExA(Host);
  {$ENDIF}
end;

function ResolveHostIP4(const Host: String): TIP4Addr;
begin
  {$IFDEF StringIsUnicode}
  Result := ResolveHostIP4A(AnsiString(Host));
  {$ELSE}
  Result := ResolveHostIP4A(Host);
  {$ENDIF}
end;

function ResolveHostIP6ExA(const Host: AnsiString): TIP6AddrArray;
var In6Addr : TIP6Addr;
    Addrs   : TSocketAddrArray;
    L, I    : Integer;
begin
  if Host = '' then
    raise ESocketLib.Create('Host not specified');
  if IsIP6AddressA(Host, In6Addr) then
    begin
      SetLength(Result, 1);
      Result[0] := In6Addr;
      exit;
    end;
  SocketGetAddrInfo(iaIP6, ipNone, Host, '', Addrs);
  L := Length(Addrs);
  if L = 0 then
    raise ESocketLib.Create('Failed to resolve host', SocketGetLastError);
  SetLength(Result, L);
  for I := 0 to L - 1 do
    Result[I] := Addrs[I].AddrIP6;
end;

function ResolveHostIP6A(const Host: AnsiString): TIP6Addr;
var Addrs : TSocketAddrArray;
begin
  if Host = '' then
    raise ESocketLib.Create('Host not specified');
  if IsIP6AddressA(Host, Result) then
    exit;
  SocketGetAddrInfo(iaIP6, ipNone, Host, '', Addrs);
  if Length(Addrs) = 0 then
    raise ESocketLib.Create('Failed to resolve host', SocketGetLastError);
  Assert(Addrs[0].AddrFamily = iaIP6);
  Result := Addrs[0].AddrIP6;
end;

function ResolveHostIP6Ex(const Host: String): TIP6AddrArray;
begin
  {$IFDEF StringIsUnicode}
  Result := ResolveHostIP6ExA(AnsiString(Host));
  {$ELSE}
  Result := ResolveHostIP6ExA(Host);
  {$ENDIF}
end;

function ResolveHostIP6(const Host: String): TIP6Addr;
begin
  {$IFDEF StringIsUnicode}
  Result := ResolveHostIP6A(AnsiString(Host));
  {$ELSE}
  Result := ResolveHostIP6A(Host);
  {$ENDIF}
end;



{                                                                              }
{ Port                                                                         }
{                                                                              }
{$IFDEF DELPHI5}
function TryStrToInt(const S: AnsiString; var I: Integer): Boolean;
var Error : Integer;
begin
  Val(S, I, Error);
  Result := Error = 0;
end;
{$ENDIF}

function ResolvePortA(const Port: AnsiString; const Protocol: TIPProtocol): Word;
var PortInt  : Integer;
    PortPtr  : PAnsiChar;
    ProtoEnt : PProtoEnt;
    ServEnt  : PServEnt;
begin
  if Port = '' then
    raise ESocketLib.Create('Port not specified');
  // Resolve numeric port value
  if TryStringToIntA(Port, PortInt) then
    begin
      if (PortInt < 0) or (PortInt > $FFFF) then
        raise ESocketLib.Create('Port number out of range');
      Result := PortToNetPort(Word(PortInt));
      exit;
    end;
  // Resolve port using system
  {$IFDEF SOCKETLIB_WIN}
  if not WinSockStarted then
    WinSockStartup;
  {$ENDIF}
  case Protocol of
    ipTCP : ProtoEnt := GetProtoByNumber(IPPROTO_TCP);
    ipUDP : ProtoEnt := GetProtoByNumber(IPPROTO_UDP);
  else
    ProtoEnt := nil;
  end;
  PortPtr := PAnsiChar(Port);
  while PortPtr^ = ' ' do
    Inc(PortPtr);
  if Assigned(ProtoEnt) and Assigned(ProtoEnt^.p_name) then
    ServEnt := GetServByName(PortPtr, ProtoEnt^.p_name)
  else
    ServEnt := GetServByName(PortPtr, nil);
  if not Assigned(ServEnt) then
    raise ESocketLib.Create('Failed to resolve port', SocketGetLastError);
  Result := ServEnt^.s_port;
end;

function ResolvePort(const Port: String; const Protocol: TIPProtocol): Word;
begin
  {$IFDEF StringIsUnicode}
  Result := ResolvePortA(AnsiString(Port), Protocol);
  {$ELSE}
  Result := ResolvePortA(Port, Protocol);
  {$ENDIF}
end;

function NetPortToPort(const NetPort: Word): Word;
begin
  Result := Socketntohs(NetPort);
end;

function NetPortToPortStr(const NetPort: Word): String;
begin
  Result := IntToStr(NetPortToPort(NetPort));
end;

function NetPortToPortStrA(const NetPort: Word): RawByteString;
begin
  Result := IntToStringB(NetPortToPort(NetPort));
end;

function PortToNetPort(const Port: Word): Word;
begin
  Result := Sockethtons(Port);
end;



{                                                                              }
{ Resolve host and port                                                        }
{                                                                              }
function ResolveA(
         const Host: AnsiString; const Port: Integer;
         const AddressFamily: TIPAddressFamily = iaIP4;
         const Protocol: TIPProtocol = ipTCP): TSocketAddr;
begin
  InitSocketAddrNone(Result);
  case AddressFamily of
    iaIP4 :
      begin
        Result.AddrFamily := iaIP4;
        if Host <> '' then
          Result.AddrIP4 := ResolveHostIP4A(Host)
        else
          Result.AddrIP4.Addr32 := LongWord(INADDR_ANY);
        Result.Port := Port;
      end;
    iaIP6 :
      begin
        Result.AddrFamily := iaIP6;
        if Host <> '' then
          Result.AddrIP6 := ResolveHostIP6A(Host)
        else
          IP6AddrSetZero(Result.AddrIP6);
        Result.Port := Port;
      end;
  end;
end;

function ResolveA(
         const Host, Port: AnsiString;
         const AddressFamily: TIPAddressFamily;
         const Protocol: TIPProtocol): TSocketAddr;
begin
  InitSocketAddrNone(Result);
  case AddressFamily of
    iaIP4 :
      begin
        Result.AddrFamily := iaIP4;
        if Host <> '' then
          Result.AddrIP4 := ResolveHostIP4A(Host)
        else
          Result.AddrIP4.Addr32 := LongWord(INADDR_ANY);
        if Port <> '' then
          Result.Port := NetPortToPort(ResolvePortA(Port, Protocol));
      end;
    iaIP6 :
      begin
        Result.AddrFamily :=  iaIP6;
        if Host <> '' then
          Result.AddrIP6 := ResolveHostIP6A(Host)
        else
          IP6AddrSetZero(Result.AddrIP6);
        if Port <> '' then
          Result.Port := NetPortToPort(ResolvePortA(Port, Protocol));
      end;
  end;
end;

function Resolve(
         const Host: String; const Port: Integer;
         const AddressFamily: TIPAddressFamily = iaIP4;
         const Protocol: TIPProtocol = ipTCP): TSocketAddr;
begin
  {$IFDEF StringIsUnicode}
  Result := ResolveA(AnsiString(Host), Port, AddressFamily, Protocol);
  {$ELSE}
  Result := ResolveA(Host, Port, AddressFamily, Protocol);
  {$ENDIF}
end;

function Resolve(
         const Host, Port: String;
         const AddressFamily: TIPAddressFamily = iaIP4;
         const Protocol: TIPProtocol = ipTCP): TSocketAddr;
begin
  {$IFDEF StringIsUnicode}
  Result := ResolveA(AnsiString(Host), AnsiString(Port), AddressFamily, Protocol);
  {$ELSE}
  Result := ResolveA(Host, Port, AddressFamily, Protocol);
  {$ENDIF}
end;



{                                                                              }
{ Socket handle                                                                }
{                                                                              }
function AllocateSocketHandle(const AddressFamily: TIPAddressFamily;
    const Protocol: TIPProtocol; const Overlapped: Boolean): TSocketHandle;
var AF, ST, PR : LongInt;
    {$IFDEF SOCKETLIB_WIN}
    NewAPI     : Boolean;
    FL         : LongWord;
    {$ENDIF}
begin
  AF := IPAddressFamilyToAF(AddressFamily);
  if AF = AF_UNSPEC then
    raise ESocketLib.Create('Invalid address family', EINVAL);
  PR := IPProtocolToIPPROTO(Protocol);
  if PR < 0 then
    raise ESocketLib.Create('Invalid protocol', EINVAL);
  case Protocol of
    ipTCP : ST := SOCK_STREAM;
    ipUDP : ST := SOCK_DGRAM;
    ipRaw : ST := SOCK_RAW;
  else
    raise ESocketLib.Create('Invalid protocol', EINVAL);
  end;
  {$IFDEF SOCKETLIB_WIN}
  if not WinSockStarted then
    WinSockStartup;
  {$IFDEF OS_WIN64}
  NewAPI := False;
  {$ELSE}
  NewAPI := WinSock2API or Overlapped;
  {$ENDIF}
  if NewAPI then
    begin
      if Overlapped then
        FL := WSA_FLAG_OVERLAPPED
      else
        FL := 0;
      Result := WSASocketA(AF, ST, PR, nil, 0, FL);
      if Result = INVALID_SOCKET then
        raise ESocketLib.Create('Failed to allocate socket handle', SocketGetLastError);
      exit;
    end;
  {$ENDIF}
  if Overlapped then
    raise ESocketLib.Create('Overlapped sockets not supported');
  Result := Socket(AF, ST, PR);
  if Result = INVALID_SOCKET then
    raise ESocketLib.Create('Failed to allocate socket handle', SocketGetLastError);
end;



{                                                                              }
{ Socket options                                                               }
{                                                                              }

// if TimeoutUs = 0 operation doesn't time out
function GetSocketReceiveTimeout(const SocketHandle: TSocketHandle): Integer;
var Opt : TTimeVal;
    OptLen : LongInt;
begin
  OptLen := Sizeof(Opt);
  if SocketGetSockOpt(SocketHandle, SOL_SOCKET, SO_RCVTIMEO, @Opt, OptLen) < 0 then
    raise ESocketLib.Create('Socket receive timeout not available', SocketGetLastError);
  Result := Opt.tv_sec * 1000000 + Opt.tv_usec;
end;

procedure SetSocketReceiveTimeout(const SocketHandle: TSocketHandle;
    const TimeoutUs: Integer);
var Opt : TTimeVal;
begin
  Opt.tv_sec := TimeoutUs div 1000000;
  Opt.tv_usec := TimeoutUs mod 1000000;
  if SocketSetSockOpt(SocketHandle, SOL_SOCKET, SO_RCVTIMEO, @Opt, Sizeof(Opt)) < 0 then
    raise ESocketLib.Create('Socket receive timeout not set', SocketGetLastError);
end;

// if TimeoutUs = 0 operation doesn't time out
function GetSocketSendTimeOut(const SocketHandle: TSocketHandle): Integer;
var Opt : TTimeVal;
    OptLen : LongInt;
begin
  OptLen := Sizeof(Opt);
  if SocketGetSockOpt(SocketHandle, SOL_SOCKET, SO_SNDTIMEO, @Opt, OptLen) < 0 then
    raise ESocketLib.Create('Socket send timeout not available', SocketGetLastError);
  Result := Opt.tv_sec * 1000000 + Opt.tv_usec;
end;

procedure SetSocketSendTimeout(const SocketHandle: TSocketHandle;
    const TimeoutUs: Integer);
var Opt : TTimeVal;
begin
  Opt.tv_sec := TimeoutUs div 1000000;
  Opt.tv_usec := TimeoutUs mod 1000000;
  if SocketSetSockOpt(SocketHandle, SOL_SOCKET, SO_SNDTIMEO, @Opt, Sizeof(Opt)) < 0 then
    raise ESocketLib.Create('Socket send timeout not set', SocketGetLastError);
end;

function GetSocketReceiveBufferSize(const SocketHandle: TSocketHandle): Integer;
var BufferSize : LongInt;
    OptLen : LongInt;
begin
  OptLen := Sizeof(BufferSize);
  if SocketGetSockOpt(SocketHandle, SOL_SOCKET, SO_RCVBUF, @BufferSize, OptLen) < 0 then
    raise ESocketLib.Create('Receive buffer size not available', SocketGetLastError);
  Result := BufferSize;
end;

procedure SetSocketReceiveBufferSize(const SocketHandle: TSocketHandle; const BufferSize: Integer);
begin
  if SocketSetSockOpt(SocketHandle, SOL_SOCKET, SO_RCVBUF, @BufferSize, Sizeof(BufferSize)) < 0 then
    raise ESocketLib.Create('Receive buffer size not set', SocketGetLastError);
end;

function GetSocketSendBufferSize(const SocketHandle: TSocketHandle): Integer;
var BufferSize : LongInt;
    OptLen : LongInt;
begin
  OptLen := Sizeof(BufferSize);
  if SocketGetSockOpt(SocketHandle, SOL_SOCKET, SO_SNDBUF, @BufferSize, OptLen) < 0 then
    raise ESocketLib.Create('Send buffer size not available', SocketGetLastError);
  Result := BufferSize;
end;

procedure SetSocketSendBufferSize(const SocketHandle: TSocketHandle; const BufferSize: Integer);
begin
  if SocketSetSockOpt(SocketHandle, SOL_SOCKET, SO_SNDBUF, @BufferSize, Sizeof(BufferSize)) < 0 then
    raise ESocketLib.Create('Send buffer size not set', SocketGetLastError);
end;

{$IFDEF SOCKETLIB_WIN}
procedure GetSocketLinger(const SocketHandle: TSocketHandle;
    var Linger: Boolean; var LingerTimeSec: Integer);
var Opt : TLinger;
    OptLen : LongInt;
begin
  OptLen := Sizeof(Opt);
  if SocketGetSockOpt(SocketHandle, SOL_SOCKET, SO_LINGER, @Opt, OptLen) < 0 then
    raise ESocketLib.Create('Socket linger option not available', SocketGetLastError);
  Linger := Opt.l_onoff <> 0;
  LingerTimeSec := Opt.l_linger;
end;

procedure SetSocketLinger(const SocketHandle: TSocketHandle;
    const Linger: Boolean; const LingerTimeSec: Integer);
var Opt : TLinger;
begin
  if Linger then
    Opt.l_onoff := 1
  else
    Opt.l_onoff := 0;
  Opt.l_linger := LingerTimeSec;
  if SocketSetSockOpt(SocketHandle, SOL_SOCKET, SO_LINGER, @Opt, Sizeof(Opt)) < 0 then
    raise ESocketLib.Create('Socket linger option not set', SocketGetLastError);
end;
{$ENDIF}

{$IFDEF SOCKETLIB_UNIX}
procedure GetSocketLinger(const SocketHandle: TSocketHandle;
    var Linger: Boolean; var LingerTimeSec: Integer);
var Opt : TLinger;
    OptLen : LongInt;
begin
  OptLen := Sizeof(Opt);
  if SocketGetSockOpt(SocketHandle, SOL_SOCKET, SO_LINGER, @Opt, OptLen) < 0 then
    raise ESocketLib.Create('Socket linger option not available', SocketGetLastError);
  Linger := Opt.l_onoff;
  LingerTimeSec := Opt.l_linger;
end;

procedure SetSocketLinger(const SocketHandle: TSocketHandle;
    const Linger: Boolean; const LingerTimeSec: Integer);
var Opt : TLinger;
begin
  Opt.l_onoff := Linger;
  Opt.l_linger := LingerTimeSec;
  if SocketSetSockOpt(SocketHandle, SOL_SOCKET, SO_LINGER, @Opt, Sizeof(Opt)) < 0 then
    raise ESocketLib.Create('Socket linger option not set', SocketGetLastError);
end;
{$ENDIF}

function GetSocketBroadcast(const SocketHandle: TSocketHandle): Boolean;
var Opt : LongBool;
    OptLen : LongInt;
begin
  OptLen := Sizeof(Opt);
  if SocketSetSockOpt(SocketHandle, SOL_SOCKET, SO_BROADCAST, @Opt, OptLen) < 0 then
    raise ESocketLib.Create('Socket broadcast option not available', SocketGetLastError);
  Result := Opt;
end;

procedure SetSocketBroadcast(const SocketHandle: TSocketHandle;
    const Broadcast: Boolean);
var Opt : LongBool;
begin
  Opt := Broadcast;
  if SocketSetSockOpt(SocketHandle, SOL_SOCKET, SO_BROADCAST, @Opt, Sizeof(Opt)) < 0 then
    raise ESocketLib.Create('Socket broadcast option not set', SocketGetLastError);
end;

function GetSocketMulticastTTL(const SocketHandle: TSocketHandle): Integer;
var Opt : LongInt;
    OptLen : LongInt;
begin
  Opt := -1;
  OptLen := Sizeof(Opt);
  if SocketGetSockOpt(SocketHandle, IPPROTO_IP, IP_MULTICAST_TTL, @Opt, OptLen) < 0 then
    raise ESocketLib.Create('Socket multicast TTL option not available', SocketGetLastError);
  Result := Opt;
end;

procedure SetSocketMulticastTTL(const SocketHandle: TSocketHandle; const TTL: Integer);
var Opt : LongInt;
begin
  Opt := TTL;
  if SocketSetSockOpt(SocketHandle, IPPROTO_IP, IP_MULTICAST_TTL, @Opt, Sizeof(Opt)) < 0 then
    raise ESocketLib.Create('Socket multicast TTL option not set', SocketGetLastError);
end;



{                                                                              }
{ Socket mode                                                                  }
{                                                                              }
procedure SetSocketBlocking(const SocketHandle: TSocketHandle; const Block: Boolean);
begin
  SetSockBlocking(SocketHandle, Block);
end;

{$IFDEF SOCKETLIB_WIN}
function SocketAsynchronousEventsToEvents(const Events: TSocketAsynchronousEvents): LongInt;
var E : LongInt;
begin
  E := 0;
  if saeConnect in Events then
    E := E or FD_CONNECT;
  if saeClose in Events then
    E := E or FD_CLOSE;
  if saeRead in Events then
    E := E or FD_READ;
  if saeWrite in Events then
    E := E or FD_WRITE;
  if saeAccept in Events then
    E := E or FD_ACCEPT;
  Result := E;
end;

function EventsToSocketAsynchronousEvents(const Events: LongInt): TSocketAsynchronousEvents;
var E : TSocketAsynchronousEvents;
begin
  E := [];
  if Events and FD_CONNECT <> 0 then
    Include(E, saeConnect);
  if Events and FD_CLOSE <> 0 then
    Include(E, saeClose);
  if Events and FD_READ <> 0 then
    Include(E, saeRead);
  if Events and FD_WRITE <> 0 then
    Include(E, saeWrite);
  if Events and FD_ACCEPT <> 0 then
    Include(E, saeAccept);
  Result := E;
end;

procedure SetSocketAsynchronous(
          const SocketHandle: TSocketHandle;
          const WindowHandle: HWND; const Msg: Integer;
          const Events: TSocketAsynchronousEvents);
var E : LongInt;
begin
  E := SocketAsynchronousEventsToEvents(Events);
  if WSAAsyncSelect(SocketHandle, WindowHandle, Msg, E) < 0 then
    raise ESocketLib.Create('Asynchronous mode not set', SocketGetLastError);
end;
{$ENDIF}

function GetSocketAvailableToRecv(const SocketHandle: TSocketHandle): Integer;
begin
  Result := SockAvailableToRecv(SocketHandle);
end;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF SOCKETLIB_TEST}
{$ASSERTIONS ON}
procedure Test;
var S : AnsiString;
    W : AddressStrArrayA;
    A : TIP4Addr;
    L : TIP4AddrArray;
    H : TSocket;
    P : Word;
    D : TSocketAddr;
    E : TSocketAddrArray;
    {$IFDEF SOCKETLIB_TEST_IP6}
    B : TIP6Addr;
    C : TIP6AddrArray;
    {$ENDIF}
begin
  Assert(Sizeof(TInAddr) = 4,                     'TInAddr');
  Assert(Sizeof(TIn6Addr) = 16,                   'TIn6Addr');

  Assert(IPAddressFamilyToAF(iaIP4) = AF_INET);
  Assert(AFToIPAddressFamily(AF_INET) = iaIP4);

  // IsIPAddress
  Assert(IsIP4AddressA('192.168.0.1', A),          'IsIPAddress');
  Assert((A.Addr8[0] = 192) and
         (A.Addr8[1] = 168) and
         (A.Addr8[2] = 0)   and
         (A.Addr8[3] = 1),                         'IsIPAddress');
  Assert(IP4AddressType(A) = inaPrivate,           'IPAddressType');
  Assert(IP4AddressStrA(A) = '192.168.0.1',        'IPAddressStr');
  Assert(IP4AddressStr(A) = '192.168.0.1',         'IPAddressStr');
  Assert(IsIP4AddressA('0.0.0.0', A),              'IsIPAddress');
  Assert(A.Addr32 = 0,                             'IsIPAddress');
  Assert(IsIP4Address('0.0.0.0', A),               'IsIPAddress');
  Assert(A.Addr32 = 0,                             'IsIPAddress');
  Assert(IsIP4AddressA('255.255.255.255', A),      'IsIPAddress');
  Assert(A.Addr32 = INADDR_BROADCAST,              'IsIPAddress');
  Assert(IP4AddressStrA(A) = '255.255.255.255',    'IPAddressStr');
  Assert(not IsIP4AddressA('', A),                 'IsIPAddress');
  Assert(not IsIP4AddressA('192.168.0.', A),       'IsIPAddress');
  Assert(not IsIP4AddressA('192.168.0', A),        'IsIPAddress');
  Assert(not IsIP4AddressA('192.168.0.256', A),    'IsIPAddress');
  Assert(SocketGetLastError = 0,                   'IsIPAddress');
  Assert(IsIP4AddressA('192.168.0.255', A),        'IsIPAddress');
  Assert(IP4AddressStrA(A) = '192.168.0.255',      'IPAddressStr');
  Assert(SocketGetLastError = 0,                   'IsIPAddress');

  // ResolveHost IP
  A := ResolveHostIP4A('192.168.0.1');
  Assert(IP4AddressStrA(A) = '192.168.0.1',        'ResolveHostIP4');
  Assert((A.Addr8[0] = 192) and
         (A.Addr8[1] = 168) and
         (A.Addr8[2] = 0)   and
         (A.Addr8[3] = 1),                        'ResolveHostIP4');
  InitSocketAddr(D, A, 80);
  Assert(D.AddrFamily = iaIP4,                    'PopulateSockAddr');
  Assert(D.Port = 80,                             'PopulateSockAddr');
  Assert(D.AddrIP4.Addr32 = A.Addr32,             'PopulateSockAddr');

  // ResolveHost: local
  S := LocalHostNameA;
  Assert(S <> '',                                 'LocalHostName');
  A := ResolveHostIP4A(S);
  Assert(A.Addr32 <> 0,                           'ResolveHostIP4');
  L := ResolveHostIP4ExA(S);
  Assert(Length(L) > 0,                           'ResolveHostIP4Ex');
  Assert(L[0].Addr32 <> INADDR_ANY,               'ResolveHostIP4Ex');
  {$IFDEF SOCKETLIB_TEST_IP6}
  B := ResolveHostIP6A(S);
  Assert(not IP6AddrIsZero(B),                    'ResolveHostIP6');
  C := ResolveHostIP6ExA(S);
  Assert(Length(C) > 0,                           'ResolveHostIP6Ex');
  {$ENDIF}
  E := ResolveHostExA(S, iaIP4);
  Assert(Length(E) > 0,                           'ResolveHost');
  Assert(E[0].AddrFamily = iaIP4,                 'ResolveHost');
  Assert(E[0].AddrIP4.Addr32 <> INADDR_ANY,       'ResolveHost');
  {$IFDEF SOCKETLIB_TEST_IP6}
  E := ResolveHostExA(S, iaIP6);
  Assert(Length(E) > 0,                           'ResolveHost');
  Assert(E[0].AddrFamily = iaIP6,                 'ResolveHost');
  Assert(not IP6AddrIsZero(E[0].AddrIP6),         'ResolveHost');
  {$ENDIF}
  S := GetRemoteHostNameA(A);
  Assert(S <> '',                                 'GetRemoteHostName');

  {$IFDEF SOCKETLIB_TEST_IP4_INTERNET}
  // ResolveHost: internet
  S := 'www.google.com';
  A := ResolveHostIP4A(S);
  Assert(A.Addr32 <> 0,                           'ResolveHostIP4');
  L := ResolveHostIP4ExA(S);
  Assert(Length(L) > 0,                           'ResolveHostIP4Ex');
  Assert(L[0].Addr32 <> INADDR_ANY,               'ResolveHostIP4Ex');
  {$IFDEF SOCKETLIB_TEST_OUTPUT}
  Write('{google:n=', Length(L), ':', IPAddressStr(L[0]), '}');
  {$ENDIF}
  {$ENDIF}

  // ResolvePort
  P := ResolvePortA('25', ipTCP);
  Assert(ntohs(P) = 25,                           'ResolvePort');
  P := ResolvePortA('http', ipTCP);
  Assert(ntohs(P) = 80,                           'ResolvePort');
  P := ResolvePort('http', ipTCP);
  Assert(ntohs(P) = 80,                           'ResolvePort');

  // LocalIPAddresses
  W := LocalIP4AddressesStrA;
  Assert(Length(W) > 0,                           'LocalIPAddresses');

  {$IFDEF SOCKETLIB_TEST_IP6}
  // IP6 addresses
  Assert(not IsIPAddress('', B),                  'IsIP6Address');
  Assert(IsIPAddress('::1', B),                   'IsIP6Address');
  Assert(IN6ADDR_IsLocalHost(B),                  'IN6ADDR_IsLocalHost');
  IN6ADDR_SetLocalHost(B);
  Assert(IN6ADDR_IsLocalHost(B),                  'IN6ADDR_SetLocalHost');
  Assert(IPAddressStr(B) = '::1',                 'IP6AddressStr');
  Assert(IsIPAddress('ffff::1', B),               'IsIP6Address');
  Assert(IPAddressStr(B) = 'ffff:0:0:0:0:0:0:1',  'IP6AddressStr');
  Assert(IsIPAddress('::', B),                    'IsIP6Address');
  Assert(IPAddressStr(B) = '::',                  'IP6AddressStr');
  Assert(IN6ADDR_IsZero(B),                       'IN6ADDR_IsZero');
  IN6ADDR_SetZero(B);
  Assert(IPAddressStr(B) = '::',                  'IN6ADDR_SetZero');
  Assert(IN6ADDR_IsZero(B),                       'IN6ADDR_IsZero');
  IN6ADDR_SetBroadcast(B);
  Assert(IPAddressStr(B) = 'ffff:0:0:0:0:0:0:1',  'IN6ADDR_SetBroadcast');
  Assert(IN6ADDR_IsBroadcast(B),                  'IN6ADDR_IsBroadcast');

  C := LocalIP6Addresses;
  Assert(Length(C) > 0,                           'LocalIP6Addresses');
  Assert(IPAddressStr(C[0]) = '::1',              'LocalIP6Addresses');
  S := GetRemoteHostName(C[0]);
  Assert(S <> '',                                 'GetRemoteHostName');

  B := ResolveHostIP6('ffff::1');
  Assert(IPAddressStr(B) = 'ffff:0:0:0:0:0:0:1',  'ResolveHostIP6');
  B := ResolveHostIP6(LocalHostName);
  Assert(IN6ADDR_IsLocalHost(B),                  'ResolveHostIP6');
  {$ENDIF}

  // Sockets
  H := AllocateSocketHandle(iaIP4, ipTCP);
  Assert(H <> 0,                                  'AllocateSocketHandle');
  Assert(SocketGetLastError = 0,                  'AllocateSocketHandle');
  SetSocketBlocking(H, True);
  Assert(SocketGetLastError = 0,                  'SetSocketBlocking');
  SetSocketBlocking(H, False);
  Assert(SocketGetLastError = 0,                  'SetSocketBlocking');
  Assert(SocketClose(H) = 0,                      'SocketClose');
  Assert(SocketGetLastError = 0,                  'SocketClose');

  H := AllocateSocketHandle(iaIP4, ipUDP);
  Assert(H <> 0,                                  'AllocateSocketHandle');
  Assert(SocketGetLastError = 0,                  'AllocateSocketHandle');
  Assert(SocketClose(H) = 0,                      'SocketClose');
  Assert(SocketGetLastError = 0,                  'SocketClose');

  {$IFDEF SOCKETLIB_TEST_IP6}
  H := AllocateSocketHandle(iaIP6, ipTCP);
  Assert(H <> 0,                                  'AllocateSocketHandle');
  Assert(SocketGetLastError = 0,                  'AllocateSocketHandle');
  Assert(SocketClose(H) = 0,                      'SocketClose');
  Assert(SocketGetLastError = 0,                  'SocketClose');

  H := AllocateSocketHandle(iaIP6, ipUDP);
  Assert(H <> 0,                                  'AllocateSocketHandle');
  Assert(SocketGetLastError = 0,                  'AllocateSocketHandle');
  Assert(SocketClose(H) = 0,                      'SocketClose');
  Assert(SocketGetLastError = 0,                  'SocketClose');
  {$ENDIF}

  {$IFDEF SOCKETLIB_WIN}
  {$IFNDEF OS_WIN64}
  // overlapped socket
  H := AllocateSocketHandle(iaIP4, ipTCP, True);
  Assert(H <> 0,                                  'AllocateSocketHandle');
  Assert(SocketGetLastError = 0,                  'AllocateSocketHandle');
  Assert(SocketClose(H) = 0,                      'SocketClose');
  Assert(SocketGetLastError = 0,                  'SocketClose');
  {$ENDIF}
  {$ENDIF}
end;
{$ENDIF}



{                                                                              }
{ Unit initialization and finalization                                         }
{                                                                              }
initialization
  InitializeLibLock;
finalization
  FinalizeLibLock;
end.

