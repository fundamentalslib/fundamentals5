unit flcHTMLTest;

interface

procedure Test;

implementation

uses
  flcHTMLCharEntity,
  flcHTMLProperties,
  flcHTMLLexer,
  flcHTMLParser;

procedure Test;
begin
  flcHTMLCharEntity.Test;
  flcHTMLProperties.Test;
  flcHTMLLexer.Test;
  flcHTMLParser.Test;
end;



end.
