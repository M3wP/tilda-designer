unit FormTildaDesignAddSubItem;

{$mode ObjFPC}{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
	Buttons, VirtualTrees, TildaDesignTypes;

type

	{ TTildaDesignAddSubItemForm }

	TTildaDesignAddSubItemForm = class(TForm)
		BitBtn1: TBitBtn;
		BitBtn2: TBitBtn;
		Panel2: TPanel;
		VirtualStringTree1: TVirtualStringTree;
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  procedure FormCreate(Sender: TObject);
		procedure VirtualStringTree1Change(Sender: TBaseVirtualTree;
			Node: PVirtualNode);
		procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
			Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
			var CellText: String);
	private
		FSelected: TTildaAbstract;
		FItems: TTildaAbstracts;

	public
		function  ShowAddSubItem(const AClass: TTildaAbstractClass;
				const AShowNone: Boolean = False): TModalResult;

		property  Selected: TTildaAbstract read FSelected;
	end;

var
	TildaDesignAddSubItemForm: TTildaDesignAddSubItemForm;

implementation

{$R *.lfm}

uses
	TildaDesignUtils;

{ TTildaDesignAddSubItemForm }

procedure TTildaDesignAddSubItemForm.FormCreate(Sender: TObject);
	begin
	FItems:= TTildaAbstracts.Create;
	end;

procedure TTildaDesignAddSubItemForm.FormCloseQuery(Sender: TObject;
		var CanClose: Boolean);
	begin

	end;

procedure TTildaDesignAddSubItemForm.VirtualStringTree1Change(
		Sender: TBaseVirtualTree; Node: PVirtualNode);
	begin
	if  Assigned(Node)
	and Assigned(FItems[Node^.Index]) then
		begin
		FSelected:= FindByIdent(FItems[Node^.Index].ident);
		end
	else
		FSelected:= nil;
	end;

procedure TTildaDesignAddSubItemForm.VirtualStringTree1GetText(
		Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
		TextType: TVSTTextType; var CellText: String);
	begin
	if  Assigned(FItems[Node^.Index]) then
		CellText:= FItems[Node^.Index].ident
	else
		CellText:= '[None]';
	end;

function TTildaDesignAddSubItemForm.ShowAddSubItem(
		const AClass: TTildaAbstractClass; const AShowNone: Boolean): TModalResult;
	var
	i: Integer;

	begin
	FItems.Clear;

	FSelected:= nil;
	VirtualStringTree1.RootNodeCount:= 0;

	if  AShowNone then
		begin
		FItems.Add(nil);
		Caption:= 'Select Object Reference...';
		end
	else
		Caption:= 'Add Sub Item...';

	for i:= 0 to abstracts.Count - 1 do
		if  abstracts[i] is AClass then
			FItems.Add(abstracts[i]);

	VirtualStringTree1.RootNodeCount:= FItems.Count;

	Result:= ShowModal;
	end;

end.

