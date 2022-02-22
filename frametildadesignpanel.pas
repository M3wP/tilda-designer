unit FrameTildaDesignPanel;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ValEdit,
	TildaDesignTypes, FrameTildaDesignElem, FrameTildaDesignSubItems;

type

	{ TTildaDesignPanelFrame }

 TTildaDesignPanelFrame = class(TTildaDesignElemFrame)
		subitemsControls: TTildaDesignSubItemsFrame;
	private
		procedure ControlsGetItemText(const AIndex: Integer; out AText: string);
		procedure ControlsAddItem(const AItem: TTildaAbstract);
		procedure ControlsRemoveItem(const AIndex: Integer);

	protected
		procedure DoValidateProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); override;
		procedure DoLookupProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); override;
		procedure DoEditProp(const AProp: string; const AValue: string); override;
		procedure DoSetItem; override;
	public
		class procedure RegisterEditor; override;

		constructor Create(AOwner: TComponent); override;
	end;

implementation

{$R *.lfm}

uses
	FormTildaDesignAddSubItem, TildaDesignClasses;

{ TTildaDesignPanelFrame }

procedure TTildaDesignPanelFrame.ControlsGetItemText(const AIndex: Integer; out
		AText: string);
	begin
	AText:= TTildaPanel(FItem).controls[AIndex].ident;
	end;

procedure TTildaDesignPanelFrame.ControlsAddItem(const AItem: TTildaAbstract);
	var
	p: TTildaPanel;

	begin
	p:= TTildaPanel(FItem);

	if  p.controls.IndexOf(AItem as TTildaControl) = -1 then
		begin
		p.controls.Add(AItem as TTildaControl);
		subitemsControls.ItemCount:= p.controls.Count;
		end;
	end;

procedure TTildaDesignPanelFrame.ControlsRemoveItem(const AIndex: Integer);
	begin

	end;

procedure TTildaDesignPanelFrame.DoValidateProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	begin
	inherited DoValidateProp(AProp, AOldValue, ANewValue);
	end;

procedure TTildaDesignPanelFrame.DoLookupProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	begin
	if  (CompareText(AProp, 'layer') = 0) then
		begin
		if  TildaDesignAddSubItemForm.ShowAddSubItem(TTildaLayer, True) = mrOk then
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

procedure TTildaDesignPanelFrame.DoEditProp(const AProp: string;
		const AValue: string);
	begin
	inherited DoEditProp(AProp, AValue);
	end;

procedure TTildaDesignPanelFrame.DoSetItem;
	var
	p: TTildaPanel;

	begin
	inherited DoSetItem;

	p:= TTildaPanel(FItem);

	ValueListEditor1.Strings.Add('layer=' + IdentOrEmpty(p.layer));

	ValueListEditor1.ItemProps['layer'].EditStyle:= esEllipsis;
	ValueListEditor1.ItemProps['layer'].ReadOnly:= True;

	subItemsControls.ItemCount:= p.controls.Count;
	end;

class procedure TTildaDesignPanelFrame.RegisterEditor;
	begin
	TTildaDesignClass.Create(TTildaPanel, Self);
	end;

constructor TTildaDesignPanelFrame.Create(AOwner: TComponent);
	begin
	inherited Create(AOwner);

	subItemsControls.ItemClass:= TTildaControl;
	subItemsControls.OnAddItem:= ControlsAddItem;
	subItemsControls.OnGetText:= ControlsGetItemText;
	subItemsControls.OnRemoveItem:= ControlsRemoveItem;
	end;


initialization
	TTildaDesignPanelFrame.RegisterEditor;

end.

