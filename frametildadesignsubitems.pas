unit FrameTildaDesignSubItems;

{$mode ObjFPC}{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, ComCtrls, StdCtrls, VirtualTrees,
	TildaDesignTypes;

type

	{ TTildaDesignSubItemsFrame }
	TGetItemTextEvent = procedure (const AIndex: Integer; out AText: string) of object;
	TAddItemEvent = procedure (const AItem: TTildaAbstract) of object;
	TRemoveItemEvent = procedure (const AIndex: Integer) of object;

	TTildaDesignSubItemsFrame = class(TFrame)
		Label1: TLabel;
		ToolBar1: TToolBar;
		ToolButton1: TToolButton;
		ToolButton2: TToolButton;
		ToolButton3: TToolButton;
		VirtualStringTree1: TVirtualStringTree;
		procedure ToolButton1Click(Sender: TObject);
		procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
				Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
				var CellText: String);
	private
		function  GetItemCount: Integer;
		procedure SetItemCount(const AValue: Integer);

	protected
		FItemClass: TTildaAbstractClass;
		FOnGetText: TGetItemTextEvent;
		FOnAddItem: TAddItemEvent;
		FOnRemoveItem: TRemoveItemEvent;

	public
		property  OnGetText: TGetItemTextEvent read FOnGetText write FOnGetText;
		property  OnAddItem: TAddItemEvent read FOnAddItem write FOnAddItem;
		property  OnRemoveItem: TRemoveItemEvent read FOnRemoveItem write FOnRemoveItem;

		property  ItemCount: Integer read GetItemCount write SetItemCount;
		property  ItemClass: TTildaAbstractClass read FItemClass write FItemClass;
	end;

implementation

{$R *.lfm}

uses
	FormTildaDesignAddSubItem;

{ TTildaDesignSubItemsFrame }

procedure TTildaDesignSubItemsFrame.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
		Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
		var CellText: String);
	begin
	if  Assigned(FOnGetText) then
		FOnGetText(Node^.Index, CellText);
	end;

procedure TTildaDesignSubItemsFrame.ToolButton1Click(Sender: TObject);
	begin
	if  Assigned(FOnAddItem) then
		if  TildaDesignAddSubItemForm.ShowAddSubItem(FItemClass) = mrOk then
			if  Assigned(TildaDesignAddSubItemForm.Selected) then
				FOnAddItem(TildaDesignAddSubItemForm.Selected);
	end;

function TTildaDesignSubItemsFrame.GetItemCount: Integer;
	begin
	Result:= VirtualStringTree1.RootNodeCount;
	end;

procedure TTildaDesignSubItemsFrame.SetItemCount(const AValue: Integer);
	begin
	VirtualStringTree1.RootNodeCount:= AValue;
	end;

end.

