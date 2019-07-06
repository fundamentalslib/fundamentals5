unit flcHTMLTest;

interface

procedure Test;

implementation

uses
  flcHTMLCharEntity,
  flcHTMLProperties,
  flcHTMLLexer,
  flcHTMLParser,
  flcHTMLElements;

procedure Test;
begin
  flcHTMLCharEntity.Test;
  flcHTMLProperties.Test;
  flcHTMLLexer.Test;
  flcHTMLParser.Test;
  flcHTMLElements.Test;
end;



end.
