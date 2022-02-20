unit FrameTildaDesignPage;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ValEdit,
	TildaDesignTypes, FrameTildaDesignElem, FrameTildaDesignSubItems;

type

	{ TTildaDesignPageFrame }

 TTildaDesignPageFrame = class(TTildaDesignElemFrame)
		subitemsPanels: TTildaDesignSubItemsFrame;
	private
		procedure PanelsGetItemText(const AIndex: Integer; out AText: string);
		procedure PanelsAddItem(const AItem: TTildaAbstract);
		procedure PanelsRemoveItem(const AIndex: Integer);

	protected
		procedure DoValidateProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); override;
		procedure DoLookupProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); override;
		procedure DoEditProp(const AProp: string; const AValue: string); override;
		procedure DoSetItem; override;
	public
		constructor Create(AOwner: TComponent); override;
	end;


implementation

{$R *.lfm}

uses
	FormTildaDesignAddSubItem;

{ TTildaDesignPageFrame }

procedure TTildaDesignPageFrame.PanelsGetItemText(const AIndex: Integer; out
		AText: string);
	begin
	AText:= TTildaPage(FItem).panels[AIndex].ident;
	end;

procedure TTildaDesignPageFrame.PanelsAddItem(const AItem: TTildaAbstract);
	var
	p: TTildaPage;

	begin
	p:= TTildaPage(FItem);

	if  p.panels.IndexOf(AItem as TTildaPanel) = -1 then
		begin
		p.panels.Add(AItem as TTildaPanel);
		subitemsPanels.ItemCount:= p.panels.Count;
		end;
	end;

procedure TTildaDesignPageFrame.PanelsRemoveItem(const AIndex: Integer);
	begin

	end;

procedure TTildaDesignPageFrame.DoValidateProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	begin
	inherited DoValidateProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignPageFrame.DoLookupProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	begin
	if  (CompareText(AProp, 'pagenxt') = 0)
	or  (CompareText(AProp, 'pagebak') = 0) then
		begin
		if  TildaDesignAddSubItemForm.ShowAddSubItem(TTildaPage, True) = mrOk then
			if  Assigned(TildaDesignAddSubItemForm.Selected) then
				ANewValue:= TildaDesignAddSubItemForm.Selected.ident
			else
				ANewValue:= ''
		else
			ANewValue:= AOldValue;
		end
	else if  CompareText(AProp, 'text') = 0 then
		begin
		if  TildaDesignAddSubItemForm.ShowAddSubItem(TTildaText, True) = mrOk then
			if  Assigned(TildaDesignAddSubItemForm.Selected) then
				ANewValue:= TildaDesignAddSubItemForm.Selected.ident
			else
				ANewValue:= ''
		else
			ANewValue:= AOldValue;
		end
	else
		inherited DoLookupProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignPageFrame.DoEditProp(const AProp: string;
		const AValue: string);
	begin
	inherited DoEditProp(AProp, AValue);
	end;

procedure TTildaDesignPageFrame.DoSetItem;
	var
	p: TTildaPage;

	begin
	inherited DoSetItem;

	p:= TTildaPage(FItem);

	if  Assigned(p.pagenxt) then
		ValueListEditor1.Strings.Add('pagenxt=' + p.pagenxt.ident)
	else
		ValueListEditor1.Strings.Add('pagenxt=');

	ValueListEditor1.ItemProps['pagenxt'].EditStyle:= esEllipsis;
	ValueListEditor1.ItemProps['pagenxt'].ReadOnly:= True;

	if  Assigned(p.pagebak) then
		ValueListEditor1.Strings.Add('pagebak=' + p.pagebak.ident)
	else
		ValueListEditor1.Strings.Add('pagebak=');

	ValueListEditor1.ItemProps['pagebak'].EditStyle:= esEllipsis;
	ValueListEditor1.ItemProps['pagebak'].ReadOnly:= True;

	if  Assigned(p.text) then
		ValueListEditor1.Strings.Add('text=' + p.text.ident)
	else
		ValueListEditor1.Strings.Add('text=');

	ValueListEditor1.ItemProps['text'].EditStyle:= esEllipsis;
	ValueListEditor1.ItemProps['text'].ReadOnly:= True;

	ValueListEditor1.Strings.Add('textoffx=' + IntToStr(p.textoffx));

	subItemsPanels.ItemCount:= p.panels.Count;
	end;

constructor TTildaDesignPageFrame.Create(AOwner: TComponent);
	begin
	inherited Create(AOwner);

	subItemsPanels.ItemClass:= TTildaPanel;
	subItemsPanels.OnAddItem:= PanelsAddItem;
	subItemsPanels.OnGetText:= PanelsGetItemText;
	subItemsPanels.OnRemoveItem:= PanelsRemoveItem;
	end;

end.

