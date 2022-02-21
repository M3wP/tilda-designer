unit TildaDesignUtils;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, ValEdit, TildaDesignTypes;


function  HexToDWord(const AHex: string): Cardinal;
function  FirstByClass(const AClass: TTildaAbstractClass): TTildaAbstract;
function  FindByIdent(const AIdent: string): TTildaAbstract;
function  IsValidIdent(const AValue: string): Boolean;

procedure EditorAddItemEvent(const AEditor: TValueListEditor;
		const AProp: string; const AEvent: TTildaAbstract);
function TestLookupEventProp(const AProp, ATest: string;
		const AKind: TTildaEventKind; var ANewValue: string;
		out AEvent: TTildaEvent): Boolean;


implementation

uses
	Controls, FormTildaDesignEventRef;


function  HexToDWord(const AHex: string): Cardinal;
	var
	buf: array[0..7] of AnsiChar;
	val: array[0..7] of AnsiChar;

	begin
	val:= Copy(AnsiString(AHex), 2, 8);
	if  HexToBin(val, buf, 8) = 4 then
		begin
//!!!FIXME This is little endian only
		Result:= (Byte(buf[0]) shl 24) or (Byte(buf[1]) shl 16) or
				(Byte(buf[2]) shl 8) or Byte(buf[3]);

//		if  IntToHex(Result, 8) <> val then
//			raise Exception.Create('blah');

		end
	else
		Result:= $FFFFFFFF;
	end;

procedure EditorAddItemEvent(const AEditor: TValueListEditor;
		const AProp: string; const AEvent: TTildaAbstract);
	begin
	if  Assigned(AEvent) then
		AEditor.Strings.Add(AProp + '=' + AEvent.ident)
	else
		AEditor.Strings.Add(AProp + '=');

	AEditor.ItemProps[AProp].EditStyle:= esEllipsis;
	AEditor.ItemProps[AProp].ReadOnly:= True;
	end;

function TestLookupEventProp(const AProp, ATest: string;
		const AKind: TTildaEventKind; var ANewValue: string;
		out AEvent: TTildaEvent): Boolean;
	begin
	Result:= CompareText(AProp, ATest) = 0;

	if  Result then
		begin
		if  TildaDesignEventRefForm.ShowSelEventRef(AKind) = mrOk then
			begin
			AEvent:= TildaDesignEventRefForm.Selected;
			ANewValue:= AEvent.ident;
			end
		else
			begin
			AEvent:= nil;
//			ANewValue:= '';
			end;
		end;
	end;

function FirstByClass(const AClass: TTildaAbstractClass): TTildaAbstract;
	var
	i: Integer;

	begin
	Result:= nil;

	for i:= 0 to abstracts.Count - 1 do
		if  abstracts[i].ClassType = AClass then
			begin
			Result:= abstracts[i];
			Exit;
			end;
	end;

function FindByIdent(const AIdent: string): TTildaAbstract;
	var
	i: Integer;

	begin
	Result:= nil;

	for i:= 0 to abstracts.Count - 1 do
		if  CompareStr(abstracts[i].ident, AIdent) = 0 then
			begin
			Result:= abstracts[i];
			Exit;
			end;
	end;


function IsValidIdent(const AValue: string): Boolean;
	begin
	Result:= True;

	if  (Length(AValue) = 0)
	or  (not (UpCase(AValue[Low(string)]) in ['A'..'Z','_']))
	or  (Pos(' ', AValue) > 0)
	or  (Pos('.', AValue) > 0)
	or  (Assigned(FindByIdent(AValue))) then
		Result:= False;
	end;

end.

