unit FormTildaDesignMain;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
	ExtCtrls, ComCtrls, ActnList, Menus, VirtualTrees, FrameTildaDesignEdit;

type

	{ TTildaDesignMainForm }

	TTildaDesignMainForm = class(TForm)
		actObjNewPanel: TAction;
		actObjNewPage: TAction;
		actFileNewApp: TAction;
		ActionList1: TActionList;
		MainMenu1: TMainMenu;
		MenuItem1: TMenuItem;
		MenuItem2: TMenuItem;
		MenuItem3: TMenuItem;
		MenuItem4: TMenuItem;
		MenuItem5: TMenuItem;
		Panel1: TPanel;
		Splitter1: TSplitter;
		ToolBar1: TToolBar;
		ToolButton1: TToolButton;
		VirtualStringTree1: TVirtualStringTree;
		procedure actFileNewAppExecute(Sender: TObject);
		procedure actObjNewPageExecute(Sender: TObject);
		procedure actObjNewPanelExecute(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure VirtualStringTree1Change(Sender: TBaseVirtualTree;
			Node: PVirtualNode);
		procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
			Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
			var CellText: String);
	private
		FFrame: TTildaDesignEditFrame;

		procedure DoScreenChange(ASender: TObject);
	public

	end;

var
	TildaDesignMainForm: TTildaDesignMainForm;

implementation

{$R *.lfm}

uses
	DOM, XMLWrite, TildaDesignTypes, TildaDesignDoc, TildaDesignClasses,
	TildaDesignUtils, FormTildaDesignNewApp, FormTildaDesignScreen;

{ TTildaDesignMainForm }

procedure TTildaDesignMainForm.actFileNewAppExecute(Sender: TObject);
	begin
	if  TildaDesignNewAppForm.ShowModal = mrOk then
		VirtualStringTree1.RootNodeCount:=  abstracts.Count;
	end;

procedure TTildaDesignMainForm.actObjNewPageExecute(Sender: TObject);
	var
	id: string;
	p: TTildaPage;
	u: TTildaUInterface;

	begin
	id:= InputBox('New Page...', 'ident:', '');

	if  IsValidIdent(id) then
		begin
		u:= FirstByClass(TTildaUInterface) as TTildaUInterface;

		p:= TTildaPage.Create(id, u);
		abstracts.Add(p);

		VirtualStringTree1.RootNodeCount:= abstracts.Count;
		end;
	end;

procedure TTildaDesignMainForm.actObjNewPanelExecute(Sender: TObject);
	var
	id: string;
	p: TTildaPanel;
	u: TTildaUInterface;
	l: TTildaLayer;

	begin
	id:= InputBox('New Panel...', 'ident:', '');

	if  IsValidIdent(id) then
		begin
		u:= FirstByClass(TTildaUInterface) as TTildaUInterface;
		l:= FirstByClass(TTildaLayer) as TTildaLayer;

		p:= TTildaPanel.Create(id, u);
		p.layer:= l;
		abstracts.Add(p);

		VirtualStringTree1.RootNodeCount:= abstracts.Count;
		end;
	end;

procedure TTildaDesignMainForm.FormCreate(Sender: TObject);
	begin
	end;

procedure TTildaDesignMainForm.FormShow(Sender: TObject);
	begin
	TildaDesignScreenForm.Show;
	end;

procedure TTildaDesignMainForm.VirtualStringTree1Change(Sender: TBaseVirtualTree;
		Node: PVirtualNode);
	var
	a: TTildaAbstract;
	f: TTildaDesignEditFrameClass;

	begin
	if  Assigned(FFrame) then
		begin
		FFrame.Closing:= True;

		FFrame.Free;
		FFrame:= nil;
		end;

	if  Assigned(Node) then
		begin
		a:= abstracts[Node^.Index];

		f:= EditorForClass(TTildaAbstractClass(a.ClassType));

		if  Assigned(f) then
			begin
			FFrame:= f.Create(Self);
			FFrame.Parent:= Panel1;
			FFrame.Align:= alClient;
			FFrame.SetItem(a);
			FFrame.OnChange:= DoScreenChange;
			end;
		end;
	end;

procedure TTildaDesignMainForm.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
		Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
		var CellText: String);
	begin
	CellText:= abstracts[Node^.Index].ident;
	end;

procedure TTildaDesignMainForm.DoScreenChange(ASender: TObject);
	begin
	TildaDesignScreenForm.PaintInterface;
	end;


end.

