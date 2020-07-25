{$INCLUDE flcHTML.inc}

unit flcHTMLTest;

interface

{$IFDEF HTML_TEST}
procedure Test;
{$ENDIF}

implementation

{$IFDEF HTML_TEST}
uses
  flcHTMLCharEntity,
  flcHTMLProperties,
  flcHTMLElements,
  flcHTMLLexer,
  flcHTMLParser;

procedure Test;
begin
  flcHTMLCharEntity.Test;
  flcHTMLProperties.Test;
  flcHTMLElements.Test;
  flcHTMLLexer.Test;
  flcHTMLParser.Test;
end;
{$ENDIF}



end.

