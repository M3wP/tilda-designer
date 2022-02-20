unit TildaDesignDoc;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, DOM, TildaDesignTypes;


function  OutputXML: TXMLDocument;


implementation

function  OutputXML: TXMLDocument;
	var
	i: Integer;
	r: TDOMElement;
	n: TDOMElement;

	begin
	Result:= TXMLDocument.Create;

	r:= Result.CreateElement('Application');
	Result.AppendChild(r);

	r:= Result.DocumentElement;

	n:= Result.CreateElement('TEST');
	r.AppendChild(n);

	for i:= 0 to abstracts.Count - 1 do
		r.AppendChild(abstracts[i].WriteToNode(Result));
	end;

end.

