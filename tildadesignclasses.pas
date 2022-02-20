unit TildaDesignClasses;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Generics.Collections, TildaDesignTypes,
	FrameTildaDesignEdit;

const
	ARR_LIT_STATE_KIND: array[TTildaStateKind] of string = (
			'STATE_CHANGED', 'STATE_DIRTY', 'STATE_PREPARED', 'STATE_VISIBLE',
			'STATE_ENABLED', 'STATE_PICKED', 'STATE_ACTIVE', 'STATE_DOWN',
			'STATE_EXPRESENT');

	ARR_LIT_OPTION_KIND: array[TTildaOptionKind] of string = (
			'OPT_NOAUTOINVL', 'OPT_NONAVIGATE', 'OPT_NODOWNACTV',
			'OPT_DOWNCAPTURE', 'OPT_AUTOCHECK', 'OPT_TEXTACCEL2X',
			'OPT_TEXTCONTMRK', 'OPT_NOAUTOCHKOF', 'OPT_AUTOTRACK');

type
	TTildaDesignClass = class(TObject)
		itemClass: TTildaAbstractClass;
		editor:  TTildaDesignEditFrameClass;
	end;

	TTildaDesignClasses = TList<TTildaDesignClass>;


var
	classEditors: TTildaDesignClasses;


function  EditorForClass(const AClass: TTildaAbstractClass): TTildaDesignEditFrameClass;
function  StateToHex(const AState: TTildaState): string;
function  OptionsToHex(const AOptions: TTildaOptions): string;
function  ColourToString(const AColour: TTildaColour): string;
function  ThemeColour(const AKind: TTildaColourKind): TTildaColour;

implementation

uses
	FrameTildaDesignModule, FrameTildaDesignUIntrf, FrameTildaDesignView,
	FrameTildaDesignElem, FrameTildaDesignPage, FrameTildaDesignPanel;


const
	ARR_VAL_STATE_FLGS: array[TTildaStateKind] of Word = (
			$80, $40, $20, $01, $02, $04, $08, $10, $0100);

	ARR_VAL_OPTS_FLGS: array[TTildaOptionKind] of Word = (
			$01, $02, $04, $10, $20, $40, $80, $0100, $0200);

	ARR_LIT_CLR_KINDS: array[TTildaColourKind] of string = (
			'CLR_BACK', 'CLR_EMPTY', 'CLR_CURSOR', 'CLR_TEXT',
			'CLR_FOCUS', 'CLR_INSET', 'CLR_FACE', 'CLR_SHADOW' ,
			'CLR_PAPER', 'CLR_MONEY' ,'CLR_ITEM' ,'CLR_INFORM' ,
			'CLR_ACCEPT', 'CLR_APPLY', 'CLR_ABORT');


function  ThemeColour(const AKind: TTildaColourKind): TTildaColour;
	begin
	Result:= Ord(AKind);
	end;

function  ColourToString(const AColour: TTildaColour): string;
	var
	domain: TTildaColourDomain;
	val: Byte;

	begin
	domain:= TTildaColourDomain(Word(AColour) shr 8);
	val:= Word(AColour) and $FF;

	if  domain = tcdTheme then
		Result:=  ARR_LIT_CLR_KINDS[TTildaColourKind(val)]
	else
		Result:= '$' + IntToHex(Word(AColour), 4);
	end;

function  StateToHex(const AState: TTildaState): string;
	var
	v: Word;
	k: TTildaStateKind;

	begin
	v:= 0;
	for k in TTildaStateKind do
		if  k in AState then
			v:= v or ARR_VAL_STATE_FLGS[k];

	Result:= '$' + IntToHex(v, 4);
	end;


function  OptionsToHex(const AOptions: TTildaOptions): string;
	var
	v: Word;
	k: TTildaOptionKind;

	begin
	v:= 0;
	for k in TTildaOptionKind do
		if  k in AOptions then
			v:= v or ARR_VAL_OPTS_FLGS[k];

	Result:= '$' + IntToHex(v, 4);
	end;

function  EditorForClass(const AClass: TTildaAbstractClass): TTildaDesignEditFrameClass;
	var
	i: Integer;

	begin
	Result:= nil;

	for i:= 0 to classEditors.Count - 1 do
		if  classEditors[i].itemClass = AClass then
			begin
			Result:= classEditors[i].editor;
			Exit;
			end;
	end;

procedure RegisterItemClasses;
	var
	cd: TTildaDesignClass;

	begin
	cd:= TTildaDesignClass.Create;
	cd.itemClass:= TTildaModule;
	cd.editor:= TTildaDesignModuleFrame;
	classEditors.Add(cd);

	cd:= TTildaDesignClass.Create;
	cd.itemClass:= TTildaUInterface;
	cd.editor:= TTildaDesignUIntrfFrame;
	classEditors.Add(cd);

	cd:= TTildaDesignClass.Create;
	cd.itemClass:= TTildaView;
	cd.editor:= TTildaDesignViewFrame;
	classEditors.Add(cd);

	cd:= TTildaDesignClass.Create;
	cd.itemClass:= TTildaPage;
	cd.editor:= TTildaDesignPageFrame;
	classEditors.Add(cd);

	cd:= TTildaDesignClass.Create;
	cd.itemClass:= TTildaPanel;
	cd.editor:= TTildaDesignPanelFrame;
	classEditors.Add(cd);
	end;

initialization
	classEditors:= TTildaDesignClasses.Create;

	RegisterItemClasses;

finalization


end.

