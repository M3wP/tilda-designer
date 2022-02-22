unit TildaDesignDoc;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Generics.Collections, DOM, TildaDesignPersist,
	TildaDesignTypes;


type

	{ TTildaReference }

	TTildaReferences = TObjectList<TTildaReference>;
	TTildaAbstractRefs = TObjectDictionary<TTildaAbstract, TTildaReferences>;


function  OutputXML(const ABaseName: string): TXMLDocument;
function  InputXML(const ADocument: TXMLDocument): string;

procedure AddAbstactRef(const AOwner: TTildaAbstract;
		const AProp: string; const AChild: TTildaAbstractClass;
		const AIdent: string);

procedure AddAbstactRefFromNode(const AOwner: TTildaAbstract;
		const AProp: string; const ANode: TDomNode;
		const AChild: TTildaAbstractClass);
procedure AddAbstactRefsFromRefNode(const AOwner: TTildaAbstract;
		const AProp: string; const ANode: TDomNode;
		const AChild: TTildaAbstractClass);

var
	abstractRefs: TTildaAbstractRefs;


implementation

uses
	TildaDesignClasses;


procedure AddAbstactRefsFromRefNode(const AOwner: TTildaAbstract;
		const AProp: string; const ANode: TDomNode;
		const AChild: TTildaAbstractClass);
	var
	s: string;
	r,
	n: TDomNode;
	i: Integer;

	begin
//	n:= ADoc.CreateElement('Ref');

//	n.SetAttribute('node', node);
//	n.SetAttribute('ident', ident);

	r:= ANode.FindNode(AProp);

	if  Assigned(r) then
		for i:= 0 to r.ChildNodes.Count - 1 do
			begin
			n:= r.ChildNodes[i];
			s:= n.Attributes.GetNamedItem('ident').TextContent;
			AddAbstactRef(AOwner, AProp, AChild, s);
			end;
	end;


procedure AddAbstactRefFromNode(const AOwner: TTildaAbstract;
		const AProp: string; const ANode: TDomNode;
		const AChild: TTildaAbstractClass);
	var
	s: string;

	begin
	s:= ANode.Attributes.GetNamedItem(AProp).TextContent;
	AddAbstactRef(AOwner, AProp, AChild, s);

	end;


procedure AddAbstactRef(const AOwner: TTildaAbstract;
		const AProp: string; const AChild: TTildaAbstractClass;
		const AIdent: string);
	var
	refs: TTildaReferences;
	ref: TTildaReference;

	begin
	ref:= TTildaReference.Create(AProp, AChild, AIdent);

	if  not abstractRefs.ContainsKey(AOwner) then
		begin
		refs:= TTildaReferences.Create;
		abstractRefs.Add(AOwner, refs);
		end
	else
		refs:= abstractRefs.Items[AOwner];

	refs.Add(ref);
	end;

function InputXML(const ADocument: TXMLDocument): string;
	var
	r,
	n: TDOMNode;
	i,
	j: Integer;
	c: TTildaAbstractClass;
	a: TTildaAbstract;
	s: string;
	refs: TTildaReferences;

	begin
	abstractRefs.Clear;

	r:= ADocument.ChildNodes[0];
	Result:= r.Attributes.GetNamedItem('BaseName').TextContent;

	for i:= 0 to r.ChildNodes.Count - 1 do
		begin
		n:= r.ChildNodes[i];
		s:= n.NodeName;
		c:= ClassByNode(s);

		if  Assigned(c) then
			begin
			a:= c.Create('', nil);

			a.ReadFromNode(n);

			abstracts.Add(a);
			end;
		end;

	for i:= 0 to abstractRefs.Keys.Count - 1 do
		begin
		refs:= abstractRefs.Items[abstractRefs.Keys.ToArray[i]];

		for j:= 0 to refs.Count - 1 do
			abstractRefs.Keys.ToArray[i].ApplyReference(refs[j]);
		end;
	end;

function  OutputXML(const ABaseName: string): TXMLDocument;
	var
	i: Integer;
	r: TDOMElement;

	begin
	Result:= TXMLDocument.Create;

	r:= Result.CreateElement('Application');
	r.SetAttribute('BaseName', ABaseName);

	Result.AppendChild(r);

	r:= Result.DocumentElement;

	for i:= 0 to abstracts.Count - 1 do
		if  (abstracts[i] is TTildaEvent)
		and (TTildaEvent(abstracts[i]).system) then
			Continue
		else
			r.AppendChild(abstracts[i].WriteToNode(Result));
	end;

{ TTildaReference }


initialization
	abstractRefs:= TTildaAbstractRefs.Create([doOwnsValues]);

end.

