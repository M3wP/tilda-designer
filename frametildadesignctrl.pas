unit FrameTildaDesignCtrl;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ValEdit,
	FrameTildaDesignElem;

type

	{ TTildaDesignCtrlFrame }

	TTildaDesignCtrlFrame = class(TTildaDesignElemFrame)
	private
		procedure DoValidateProp(const AProp: string; const AOldValue: string;
				var ANewValue: string); override;
		procedure DoLookupProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); override;
		procedure DoEditProp(const AProp: string; const AValue: string); override;
		procedure DoSetItem; override;

	public
		class procedure RegisterEditor; override;
	end;


implementation

{$R *.lfm}

uses
	TildaDesignTypes, TildaDesignClasses, TildaDesignUtils,
	FormTildaDesignAddSubItem;

{ TTildaDesignCtrlFrame }

procedure TTildaDesignCtrlFrame.DoValidateProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	var
	v: Integer;

	begin
	if  CompareText(AProp, 'textoffx') = 0 then
		begin
		if  not TryStrToInt(ANewValue, v) then
			ANewValue:= AOldValue
		end
	else
		inherited DoValidateProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignCtrlFrame.DoLookupProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	begin
	if  (CompareText(AProp, 'text') = 0) then
		begin
		if  TildaDesignAddSubItemForm.ShowAddSubItem(TTildaText, True) = mrOk then
			if  Assigned(TildaDesignAddSubItemForm.Selected) then
				begin
				ANewValue:= TildaDesignAddSubItemForm.Selected.ident;
				TTildaControl(FItem).text:= FindByIdent(
						TildaDesignAddSubItemForm.Selected.ident) as TTildaText;
				end
			else
				ANewValue:= ''
		else
			ANewValue:= AOldValue;
		end
	else
		inherited DoLookupProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignCtrlFrame.DoEditProp(const AProp: string;
		const AValue: string);
	begin
	if  CompareText(AProp, 'textoffx') = 0 then
		TTildaControl(FItem).textoffx:= StrToInt(AValue)
	else
		inherited DoEditProp(AProp, AValue);
	end;

procedure TTildaDesignCtrlFrame.DoSetItem;
	var
	c: TTildaControl;

	begin
	inherited DoSetItem;

	c:= TTildaControl(FItem);

	ValueListEditor1.Strings.Add('text=' + IdentOrEmpty(c.text));

	ValueListEditor1.ItemProps['text'].EditStyle:= esEllipsis;
	ValueListEditor1.ItemProps['text'].ReadOnly:= True;

	ValueListEditor1.Strings.Add('textoffx=' + IntToStr(c.textoffx));

		//text: TTildaText;
		//textoffx,
		//textaccel,
		//accelchar: Byte;
	end;

class procedure TTildaDesignCtrlFrame.RegisterEditor;
	begin
	TTildaDesignClass.Create(TTildaControl, Self);
	end;


initialization
	TTildaDesignCtrlFrame.RegisterEditor;

end.

