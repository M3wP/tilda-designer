unit FormTildaDesignEventRef;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
	VirtualTrees, TildaDesignTypes;

type

	{ TTildaDesignEventRefForm }

	TTildaDesignEventRefForm = class(TForm)
		BitBtn1: TBitBtn;
		BitBtn2: TBitBtn;
		Panel2: TPanel;
		VirtualStringTree1: TVirtualStringTree;
		procedure FormCreate(Sender: TObject);
		procedure VirtualStringTree1Change(Sender: TBaseVirtualTree;
			Node: PVirtualNode);
		procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
			Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
			var CellText: String);
	private
		FSelected: TTildaEvent;
		FItems: TTildaAbstracts;

	public
		function  ShowSelEventRef(const AKind: TTildaEventKind): TModalResult;

		property  Selected: TTildaEvent read FSelected;
	end;

var
	TildaDesignEventRefForm: TTildaDesignEventRefForm;

implementation

{$R *.lfm}


{ TTildaDesignEventRefForm }

procedure TTildaDesignEventRefForm.FormCreate(Sender: TObject);
	begin
	FItems:= TTildaAbstracts.Create;
	end;

procedure TTildaDesignEventRefForm.VirtualStringTree1Change(
		Sender: TBaseVirtualTree; Node: PVirtualNode);
	begin
	if  Assigned(Node) then
		FSelected:= TTildaEvent(FItems[Node^.Index])
	else
		FSelected:= nil;
	end;

procedure TTildaDesignEventRefForm.VirtualStringTree1GetText(
		Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
		TextType: TVSTTextType; var CellText: String);
	begin
	if  Assigned(FItems[Node^.Index]) then
		CellText:= FItems[Node^.Index].ident
	else
		CellText:= '[None]';
	end;

function TTildaDesignEventRefForm.ShowSelEventRef(
		const AKind: TTildaEventKind): TModalResult;
	var
	i: Integer;

	begin
	FItems.Clear;

	FSelected:= nil;
	VirtualStringTree1.RootNodeCount:= 0;

	FItems.Add(nil);

	//for i:= 0 to events.Count - 1 do
	//	if  events[i].kind = AKind then
	//		FItems.Add(events[i]);

	for i:= 0 to abstracts.Count - 1 do
		if  (abstracts[i] is TTildaEvent)
		and (TTildaEvent(abstracts[i]).kind = AKind) then
			FItems.Add(abstracts[i]);

	VirtualStringTree1.RootNodeCount:= FItems.Count;

	Result:= ShowModal;
	end;

end.

