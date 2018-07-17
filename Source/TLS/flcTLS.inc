{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals TLS                                         }
{   File name:        flcTLS.inc                                               }
{   File version:     5.04                                                     }
{   Description:      TLS library defines                                      }
{                                                                              }
{******************************************************************************}

{.DEFINE DEBUG}
{.DEFINE SELFTEST}

{$INCLUDE ..\flcInclude.inc}

{$IFDEF DEBUG}
  {$DEFINE TLS_DEBUG}
{$ENDIF}

{$IFDEF DEBUG}
{$IFDEF TEST}
  {$DEFINE TLS_TEST}
{$ENDIF}
{$ENDIF}

{$IFNDEF MSWIN}
  {$DEFINE TLS_ZLIB_DISABLE}
{$ENDIF}

