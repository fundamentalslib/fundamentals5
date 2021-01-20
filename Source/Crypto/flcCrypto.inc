{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcCrypto.inc                                            }
{   Description:      Crypto library defines                                   }
{                                                                              }
{******************************************************************************}

{.DEFINE DEBUG}
{.DEFINE TEST}
{.DEFINE PROFILE}

{.DEFINE Cipher_SupportEC}
{.DEFINE Cipher_SupportRSA}

{$IFDEF DEBUG}
{$IFDEF TEST}
  {$DEFINE CRYPTO_TEST}
  {$DEFINE CIPHER_TEST}
{$ENDIF}
{$ENDIF}

{$IFDEF DEBUG}
{$IFDEF PROFILE}
  {$DEFINE CRYPTO_PROFILE}
{$ENDIF}
{$ENDIF}

