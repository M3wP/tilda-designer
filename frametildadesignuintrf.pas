unit FrameTildaDesignUIntrf;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ValEdit,
	FrameTildaDesignEdit;

type
	{ TTildaDesignUIntrfFrame }

	TTildaDesignUIntrfFrame = class(TTildaDesignEditFrame)
	private
	protected
		procedure DoValidateProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); override;
		procedure DoEditProp(const AProp: string; const AValue: string); override;
		procedure DoSetItem; override;

	public
		class procedure RegisterEditor; override;
	end;

implementation

{$R *.lfm}

uses
	TildaDesignTypes, TildaDesignClasses, TildaDesignUtils;

{ TTildaDesignUIntrfFrame }

procedure TTildaDesignUIntrfFrame.DoValidateProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	var
	v: Integer;

	begin
	if  CompareText(AProp, 'name') = 0 then
		begin
		if  Length(ANewValue) < 16 then
			ANewValue:= ANewValue + StringOfChar(' ', 16);

		if  Length(ANewValue) > 16 then
			ANewValue:= Copy(ANewValue, Low(string), 16);
		end
	else if CompareText(AProp, 'mousepal') = 0 then
		begin
		if  not TryStrToInt(ANewValue, v) then
			ANewValue:= AOldValue;
		end
	else
		inherited DoValidateProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignUIntrfFrame.DoEditProp(const AProp: string;
		const AValue: string);
	begin
	if  CompareText(AProp, 'name') = 0 then
		TTildaUInterface(FItem).name:= AValue
	else if CompareText(AProp, 'mouseloc') = 0 then
		TTildaUInterface(FItem).mouseloc:= HexToDWord(AValue)
	else if CompareText(AProp, 'mptrloc') = 0 then
		TTildaUInterface(FItem).mptrloc:= HexToDWord(AValue)
	else if CompareText(AProp, 'mousepal') = 0 then
		TTildaUInterface(FItem).mousepal:= StrToInt(AValue)
	else
		inherited DoEditProp(AProp, AValue);
	end;

procedure TTildaDesignUIntrfFrame.DoSetItem;
	begin
	inherited DoSetItem;

	ValueListEditor1.Strings.Add('name=' + TTildaUInterface(FItem).name);
	ValueListEditor1.ItemProps['name'].MaxLength:= 16;

	ValueListEditor1.Strings.Add('mouseloc=$' +
			IntToHex(TTildaUInterface(FItem).mouseloc, 8));
	ValueListEditor1.ItemProps['mouseloc'].EditStyle:= esSimple;
	ValueListEditor1.ItemProps['mouseloc'].EditMask:= '\$HHHHHHHH';

	ValueListEditor1.Strings.Add('mptrloc=$' +
			IntToHex(TTildaUInterface(FItem).mptrloc, 8));
	ValueListEditor1.ItemProps['mptrloc'].EditStyle:= esSimple;
	ValueListEditor1.ItemProps['mptrloc'].EditMask:= '\$HHHHHHHH';

	ValueListEditor1.Strings.Add('mousepal=' +
			IntToStr(TTildaUInterface(FItem).mousepal));
	end;

class procedure TTildaDesignUIntrfFrame.RegisterEditor;
	begin
	TTildaDesignClass.Create(TTildaUInterface, Self);
	end;


initialization
	TTildaDesignUIntrfFrame.RegisterEditor;

end.

