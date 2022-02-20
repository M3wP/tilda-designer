unit FrameTildaDesignView;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ValEdit,
	FrameTildaDesignEdit, FrameTildaDesignSubItems, TildaDesignTypes;

type

	{ TTildaDesignViewFrame }

	TTildaDesignViewFrame = class(TTildaDesignEditFrame)
		subItemsLayers: TTildaDesignSubItemsFrame;
		subItemsBars: TTildaDesignSubItemsFrame;
		subItemsPages: TTildaDesignSubItemsFrame;
	private
		procedure LayersGetItemText(const AIndex: Integer; out AText: string);
		procedure LayersAddItem(const AItem: TTildaAbstract);
		procedure LayersRemoveItem(const AIndex: Integer);

		procedure BarsGetItemText(const AIndex: Integer; out AText: string);
		procedure BarsAddItem(const AItem: TTildaAbstract);
		procedure BarsRemoveItem(const AIndex: Integer);

		procedure PagesGetItemText(const AIndex: Integer; out AText: string);
		procedure PagesAddItem(const AItem: TTildaAbstract);
		procedure PagesRemoveItem(const AIndex: Integer);

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

{ TTildaDesignViewFrame }

procedure TTildaDesignViewFrame.LayersGetItemText(const AIndex: Integer; out
		AText: string);
	begin
	AText:= TTildaView(FItem).layers[AIndex].ident;
	end;

procedure TTildaDesignViewFrame.LayersAddItem(const AItem: TTildaAbstract);
	var
	v: TTildaView;

	begin
	v:= TTildaView(FItem);

	if  v.layers.IndexOf(AItem as TTildaLayer) = -1 then
		begin
		v.layers.Add(AItem as TTildaLayer);
		subItemsLayers.ItemCount:= v.layers.Count;
		end;
	end;

procedure TTildaDesignViewFrame.LayersRemoveItem(const AIndex: Integer);
	begin

	end;

procedure TTildaDesignViewFrame.BarsGetItemText(const AIndex: Integer; out
		AText: string);
	begin
	AText:= TTildaView(FItem).bars[AIndex].ident;
	end;

procedure TTildaDesignViewFrame.BarsAddItem(const AItem: TTildaAbstract);
	var
	v: TTildaView;

	begin
	v:= TTildaView(FItem);

	if  v.bars.IndexOf(AItem as TTildaBar) = -1 then
		begin
		v.bars.Add(AItem as TTildaBar);
		subItemsBars.ItemCount:= v.bars.Count;
		end;
	end;

procedure TTildaDesignViewFrame.BarsRemoveItem(const AIndex: Integer);
	begin

	end;

procedure TTildaDesignViewFrame.PagesGetItemText(const AIndex: Integer; out
		AText: string);
	begin
	AText:= TTildaView(FItem).pages[AIndex].ident;
	end;

procedure TTildaDesignViewFrame.PagesAddItem(const AItem: TTildaAbstract);
	var
	v: TTildaView;

	begin
	v:= TTildaView(FItem);

	if  v.pages.IndexOf(AItem as TTildaPage) = -1 then
		begin
		v.pages.Add(AItem as TTildaPage);
		subItemsPages.ItemCount:= v.pages.Count;
		end;
	end;

procedure TTildaDesignViewFrame.PagesRemoveItem(const AIndex: Integer);
	begin

	end;

procedure TTildaDesignViewFrame.DoValidateProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	begin
	inherited DoValidateProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignViewFrame.DoLookupProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	begin
	if  CompareText(AProp, 'actvpage') = 0 then
		begin
		if  TildaDesignAddSubItemForm.ShowAddSubItem(TTildaPage, True) = mrOk then
			if  Assigned(TildaDesignAddSubItemForm.Selected) then
				begin
				TTildaView(FItem).actvpage:=
						TildaDesignAddSubItemForm.Selected as TTildaPage;
				ANewValue:= TildaDesignAddSubItemForm.Selected.ident;
				end
			else
				ANewValue:= ''
		else
			ANewValue:= AOldValue;
		end
	else
		inherited DoLookupProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignViewFrame.DoEditProp(const AProp: string;
		const AValue: string);
	begin
	inherited DoEditProp(AProp, AValue);
	end;

procedure TTildaDesignViewFrame.DoSetItem;
	var
	v: TTildaView;

	begin
	inherited DoSetItem;

	v:= TTildaView(FItem);

	ValueListEditor1.Strings.Add('width=' + IntToStr(v.width));
	ValueListEditor1.Strings.Add('height=' + IntToStr(v.height));
	ValueListEditor1.Strings.Add('location=$' + IntToHex(v.location, 8));

	if  Assigned(v.actvpage) then
		ValueListEditor1.Strings.Add('actvpage=' + v.actvpage.ident)
	else
		ValueListEditor1.Strings.Add('actvpage=');

	ValueListEditor1.ItemProps['actvpage'].EditStyle:= esEllipsis;
	ValueListEditor1.ItemProps['actvpage'].ReadOnly:= True;

	subItemsLayers.ItemCount:= v.layers.Count;
	subItemsBars.ItemCount:= v.bars.Count;
	subItemsPages.ItemCount:= v.pages.Count;
	end;

constructor TTildaDesignViewFrame.Create(AOwner: TComponent);
	begin
	inherited Create(AOwner);

	subItemsLayers.ItemClass:= TTildaLayer;
	subItemsLayers.OnAddItem:= LayersAddItem;
	subItemsLayers.OnGetText:= LayersGetItemText;
	subItemsLayers.OnRemoveItem:= LayersRemoveItem;

	subItemsBars.ItemClass:= TTildaBar;
	subItemsBars.OnAddItem:= BarsAddItem;
	subItemsBars.OnGetText:= BarsGetItemText;
	subItemsBars.OnRemoveItem:= BarsRemoveItem;

	subItemsPages.ItemClass:= TTildaPage;
	subItemsPages.OnAddItem:= PagesAddItem;
	subItemsPages.OnGetText:= PagesGetItemText;
	subItemsPages.OnRemoveItem:= PagesRemoveItem;
	end;

end.

