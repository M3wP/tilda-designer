unit FrameTildaDesignElem;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ValEdit,
	FrameTildaDesignEdit;

type

	{ TTildaDesignElemFrame }

	TTildaDesignElemFrame = class(TTildaDesignEditFrame)
	private
	protected
		procedure DoValidateProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); override;
		procedure DoLookupProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); override;
		procedure DoEditProp(const AProp: string; const AValue: string); override;
		procedure DoSetItem; override;
	public

	end;

implementation

{$R *.lfm}

uses
	TildaDesignTypes, TildaDesignClasses, TildaDesignUtils,
	FormTildaDesignAddSubItem, FormTildaDesignSelClr;


{ TTildaDesignElemFrame }

procedure TTildaDesignElemFrame.DoValidateProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	var
	v: Integer;

	begin
	if  (CompareText(AProp, 'posx') = 0)
	or  (CompareText(AProp, 'posy') = 0)
	or  (CompareText(AProp, 'width') = 0)
	or	(CompareText(AProp, 'height') = 0) then
		begin
		if  not TryStrToInt(ANewValue, v) then
			ANewValue:= AOldValue
		end
	else
		inherited DoValidateProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignElemFrame.DoLookupProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	var
	ev: TTildaEvent;

	begin
	if  TestLookupEventProp(AProp, 'present', tekPresent, ANewValue, ev) then
		TTildaElement(FItem).present:= ev
	else if  TestLookupEventProp(AProp, 'keypress', tekKeypress, ANewValue, ev) then
		TTildaElement(FItem).keypress:= ev
	else if  CompareText('owner', AProp) = 0 then
		begin
		if  TildaDesignAddSubItemForm.ShowAddSubItem(TTildaElement, True) = mrOk then
			if  Assigned(TildaDesignAddSubItemForm.Selected) then
				begin
				ANewValue:= TildaDesignAddSubItemForm.Selected.ident;
				TTildaElement(FItem).owner:= TildaDesignAddSubItemForm.Selected
						as TTildaElement;
				end
			else
				ANewValue:= ''
		else
			ANewValue:= AOldValue;
		end
	else if  CompareText('ptoffs', AProp) = 0 then
		begin
		if  TildaDesignAddSubItemForm.ShowAddSubItem(TTildaPoint, True) = mrOk then
			if  Assigned(TildaDesignAddSubItemForm.Selected) then
				begin
				ANewValue:= TildaDesignAddSubItemForm.Selected.ident;
				TTildaElement(FItem).ptoffs:= TildaDesignAddSubItemForm.Selected
						as TTildaPoint;
				end
			else
				ANewValue:= ''
		else
			ANewValue:= AOldValue;
		end
	else if  CompareText('colour', AProp) = 0 then
		begin
		if  TildaDesignSelClrForm.ShowSelColour(TTildaElement(FItem).colour) = mrOk then
			begin
			ANewValue:= ColourToString(TildaDesignSelClrForm.Selected);
			TTildaElement(FItem).colour:= TildaDesignSelClrForm.Selected;
			end
		else
			ANewValue:= AOldValue;
		end
	else
		inherited DoLookupProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignElemFrame.DoEditProp(const AProp: string;
		const AValue: string);
	begin
	if  CompareText(AProp, 'posx') = 0 then
		TTildaElement(FItem).posx:= StrToInt(AValue)
	else if  CompareText(AProp, 'posy') = 0 then
		TTildaElement(FItem).posy:= StrToInt(AValue)
	else if  CompareText(AProp, 'width') = 0 then
		TTildaElement(FItem).width:= StrToInt(AValue)
	else if  CompareText(AProp, 'height') = 0 then
		TTildaElement(FItem).height:= StrToInt(AValue)
	else
		inherited DoEditProp(AProp, AValue);
	end;

procedure TTildaDesignElemFrame.DoSetItem;
	var
	e: TTildaElement;

	begin
	inherited DoSetItem;

	e:= TTildaElement(FItem);

	EditorAddItemEvent(ValueListEditor1, 'present', e.present);
	EditorAddItemEvent(ValueListEditor1, 'keypress', e.keypress);

	ValueListEditor1.Strings.Add('owner=' + IdentOrEmpty(e.owner));

	ValueListEditor1.ItemProps['owner'].EditStyle:= esEllipsis;
	ValueListEditor1.ItemProps['owner'].ReadOnly:= True;

	ValueListEditor1.Strings.Add('colour=' + ColourToString(e.colour));
	ValueListEditor1.ItemProps['colour'].EditStyle:= esEllipsis;
	ValueListEditor1.ItemProps['colour'].ReadOnly:= True;

	ValueListEditor1.Strings.Add('ptoffs=' + IdentOrEmpty(e.ptoffs));

	ValueListEditor1.ItemProps['ptoffs'].EditStyle:= esEllipsis;
	ValueListEditor1.ItemProps['ptoffs'].ReadOnly:= True;

	ValueListEditor1.Strings.Add('posx=' + IntToStr(e.posx));
	ValueListEditor1.Strings.Add('posy=' + IntToStr(e.posy));
	ValueListEditor1.Strings.Add('width=' + IntToStr(e.width));
	ValueListEditor1.Strings.Add('height=' + IntToStr(e.height));
	end;

end.

