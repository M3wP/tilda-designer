unit FormTildaDesignMain;

{$mode Delphi}
{$H+}

interface

uses
	Classes, Generics.Collections, SysUtils, Forms, Controls, Graphics, Dialogs,
	ExtCtrls, ComCtrls, ActnList, Menus, VirtualTrees, TildaDesignTypes,
	FrameTildaDesignEdit;

type

	{ TTildaDesignMainForm }

	TTildaDesignMainForm = class(TForm)
		actFileGenC: TAction;
		actHelpAbout: TAction;
		actFileSave: TAction;
		actFileOpen: TAction;
		actViewTheme5: TAction;
		actViewTheme4: TAction;
		actViewTheme3: TAction;
		actViewTheme2: TAction;
		actViewTheme1: TAction;
		actViewTheme0: TAction;
		actObjNewCtrl: TAction;
		actObjNewPoint: TAction;
		actObjNewText: TAction;
		actObjNewPanel: TAction;
		actObjNewPage: TAction;
		actFileNewApp: TAction;
		ActionList1: TActionList;
		ControlBar1: TControlBar;
		ImageList1: TImageList;
		ImageList2: TImageList;
		ImageList3: TImageList;
		MainMenu1: TMainMenu;
		MenuItem1: TMenuItem;
		MenuItem10: TMenuItem;
		MenuItem11: TMenuItem;
		MenuItem12: TMenuItem;
		MenuItem13: TMenuItem;
		MenuItem14: TMenuItem;
		MenuItem15: TMenuItem;
		MenuItem16: TMenuItem;
		MenuItem17: TMenuItem;
		MenuItem18: TMenuItem;
		MenuItem19: TMenuItem;
		MenuItem20: TMenuItem;
		MenuItem21: TMenuItem;
		Separator2: TMenuItem;
		MenuItem2: TMenuItem;
		MenuItem3: TMenuItem;
		MenuItem4: TMenuItem;
		MenuItem5: TMenuItem;
		MenuItem6: TMenuItem;
		MenuItem7: TMenuItem;
		MenuItem8: TMenuItem;
		MenuItem9: TMenuItem;
		OpenDialog1: TOpenDialog;
		SaveDialog1: TSaveDialog;
		SelectDirectoryDialog1: TSelectDirectoryDialog;
		Separator1: TMenuItem;
		Panel1: TPanel;
		Splitter1: TSplitter;
		ToolBar1: TToolBar;
		ToolBar2: TToolBar;
		ToolButton1: TToolButton;
		ToolButton13: TToolButton;
		ToolButton14: TToolButton;
		ToolButton15: TToolButton;
		ToolButton17: TToolButton;
		ToolButton2: TToolButton;
		ToolButton20: TToolButton;
		ToolButton21: TToolButton;
		ToolButton22: TToolButton;
		ToolButton23: TToolButton;
		ToolButton24: TToolButton;
		ToolButton25: TToolButton;
		ToolButton26: TToolButton;
		ToolButton27: TToolButton;
		ToolButton28: TToolButton;
		ToolButton29: TToolButton;
		ToolButton3: TToolButton;
		ToolButton4: TToolButton;
		ToolButton5: TToolButton;
		VirtualStringTree1: TVirtualStringTree;
		procedure actFileGenCExecute(Sender: TObject);
		procedure actFileNewAppExecute(Sender: TObject);
		procedure actFileOpenExecute(Sender: TObject);
		procedure actFileSaveExecute(Sender: TObject);
		procedure actHelpAboutExecute(Sender: TObject);
		procedure actObjNewCtrlExecute(Sender: TObject);
		procedure actObjNewPageExecute(Sender: TObject);
		procedure actObjNewPanelExecute(Sender: TObject);
		procedure actObjNewPointExecute(Sender: TObject);
		procedure actObjNewTextExecute(Sender: TObject);
		procedure actViewTheme0Execute(Sender: TObject);
		procedure ControlBar1BandDrag(Sender: TObject; Control: TControl;
			var Drag: Boolean);
		procedure ControlBar1EndDrag(Sender, Target: TObject; X, Y: Integer);
		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure VirtualStringTree1Change(Sender: TBaseVirtualTree;
			Node: PVirtualNode);
		procedure VirtualStringTree1DragAllowed(Sender: TBaseVirtualTree;
			Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
		procedure VirtualStringTree1DragOver(Sender: TBaseVirtualTree;
			Source: TObject; Shift: TShiftState; State: TDragState; const Pt: TPoint;
			Mode: TDropMode; var Effect: LongWord; var Accept: Boolean);
		procedure VirtualStringTree1GetImageIndex(Sender: TBaseVirtualTree;
			Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
			var Ghosted: Boolean; var ImageIndex: Integer);
		procedure VirtualStringTree1GetNodeDataSize(Sender: TBaseVirtualTree;
			var NodeDataSize: Integer);
		procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
			Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
			var CellText: String);
	private
		FFrame: TTildaDesignEditFrame;
		FNodeEvt,
		FNodePts,
		FNodeTex,
		FNodeObj,
		FNodeElm,
		FNodePge,
		FNodePnl,
		FNodeCtl: PVirtualNode;

		FBaseName: string;
		FSelected: TTildaAbstract;
		FTheme: Integer;

		procedure DoBuildTree;
		procedure DoScreenChange(ASender: TObject);
		procedure DoAbstractsNotify(ASender: TObject;
				constref AItem: TTildaAbstract;
				AAction: TCollectionNotification);
	public

	end;

var
	TildaDesignMainForm: TTildaDesignMainForm;

implementation

{$R *.lfm}

uses
	DOM, XMLWrite, XMLRead, TildaDesignPersist, TildaDesignDoc,
	TildaDesignClasses, TildaDesignUtils, FormTildaDesignNewApp,
	FormTildaDesignScreen, FormTildaDesignAbout;

type
	PCustNode = ^TCustNode;
	TCustNode = packed record
		internal: string;
		icon: Integer;
		abstract: TTildaAbstract;
	end;


function  CTypeOf(const APersist: TTildaPersistent): string;
	begin
	if  APersist.ClassType = TTildaPersistent then
		Result:= 'karlFarPtr_t'
	else if APersist.ClassType = TTildaText then
		Result:= 'char'
	else if APersist.ClassType = TTildaModule then
		Result:= 'karlModule_t'
	else if APersist.ClassType = TTildaUInterface then
		Result:= 'judeUInterface_t'
	else if APersist.ClassType = TTildaLayer then
		Result:= 'judeLayer_t'
	else if APersist.ClassType = TTildaView then
		Result:= 'judeView_t'
	else if APersist.ClassType = TTildaPage then
		Result:= 'judePage_t'
	else if APersist.ClassType = TTildaPanel then
		Result:= 'judePanel_t'
	else if APersist.ClassType = TTildaBar then
		Result:= 'judeBar_t'
	else if APersist.ClassType = TTildaControl then
		Result:= 'judeControl_t'
	else if APersist.mode = tpmEvent then
		Result:= 'void __fastcall__'
	else
		Result:= 'judeObject_t';
	end;

{ TTildaDesignMainForm }

procedure TTildaDesignMainForm.actFileNewAppExecute(Sender: TObject);
	begin
	if  TildaDesignNewAppForm.ShowModal = mrOk then
		begin
		FBaseName:= TildaDesignNewAppForm.BaseName;
		VirtualStringTree1.FullExpand(FNodeObj);
		end;
//		VirtualStringTree1.RootNodeCount:=  abstracts.Count;
//		DoBuildTree;
	end;

procedure TTildaDesignMainForm.actFileOpenExecute(Sender: TObject);
	var
	d: TXMLDocument;

	begin
	if  OpenDialog1.Execute then
		begin
		ReadXMLFile(d, OpenDialog1.FileName);

		FBaseName:= InputXML(d);
		end;
	end;

procedure TTildaDesignMainForm.actFileSaveExecute(Sender: TObject);
	var
	d: TXMLDocument;

	begin
	SaveDialog1.FileName:= FBaseName + '.tilda';

	if  SaveDialog1.Execute then
		begin
		d:= OutputXML(FBaseName);
		try
			WriteXMLFile(d, SaveDialog1.FileName);

			finally
			d.Free;
			end;
		end;
	end;

procedure TTildaDesignMainForm.actHelpAboutExecute(Sender: TObject);
	begin
	TildaDesignAboutForm.ShowModal;
	end;

procedure TTildaDesignMainForm.actObjNewCtrlExecute(Sender: TObject);
	var
	s,
	id: string;
	c: TTildaControl;

	begin
	s:= 'ctl_'+FBaseName+'_';
	id:= InputBox('New Control...', 'ident:', s);

	if  (s <> id)
	and IsValidIdent(id) then
		begin
		c:= TTildaControl.Create(id, nil);
		abstracts.Add(c);
		end;
	end;

procedure TTildaDesignMainForm.actFileGenCExecute(Sender: TObject);
	var
	i: Integer;
	f: TStringStream;
	cid: string;
	l: string;
	k: TTildaPersistent;

	function DecorateDataValue(const AKey: TTildaPersistent;
			const AData: TTildaDataItem): string;
		begin
		case AData.dataType of
			tdtEventRef:
				if  AData.value = '' then
					Result:= 'EVENTPTRNULLREC'
				else
					Result:= 'NEARTOEVENTPTR(' + AData.value + ')';
			tdtFarRef:
				if  AData.value = '' then
					Result:= 'FARPTRNULLREC'
				else
					Result:= 'NEARTOFARPTRREC(' + AData.value + ')';
			tdtFarPtr:
				Result:= 'DWRDTOFARPTRREC(0x' + Copy(AData.value, 5, 4) + ', 0x' +
						Copy(AData.value, 1, 4) + ')';
			tdtSize:
				Result:= 'sizeof(' + CTypeOf(AKey) + ')';
			tdtString:
				Result:= '"' + AData.value + '"';
			tdtHexValue:
				Result:= '0x' + Copy(AData.value, 2, MaxInt);
			else
//			tdtValue:
				Result:= AData.value;
			end;
		end;

	procedure EmitArrayData(const AKey: TTildaPersistent;
			AData: TTildaPersistDataList);
		var
		i: Integer;
		l: string;

		begin
		l:= CTypeOf(AKey) + ' ' + AKey.ident + '[] = ';

		if  (AData.Count = 1)
		and (AData[0].dataType = tdtString) then
			begin
			l:= l + '"' + AData[0].value + '";' + LineEnding;
			f.WriteString(l);
			end
		else
			begin
			l:= l + '{' + LineEnding;
			f.WriteString(l);

			if  AData.Count > 0 then
				for i:= 0 to AData.Count - 1 do
					begin
					l:= #09#09 + DecorateDataValue(AKey, AData[i]);
					if  i < AData.Count - 1 then
						l:= l + ',' + LineEnding
					else
						l:= l + '};' + LineEnding;
					f.WriteString(l);
					end
			else
				begin
				l:= #09#09 + '0};' + LineEnding;
				f.WriteString(l);
				end;
			end;
		end;

	procedure EmitStructData(const AKey: TTildaPersistent;
			AData: TTildaPersistDataList);
		var
		i: Integer;
		l: string;

		begin
		l:= CTypeOf(AKey) + ' ' + AKey.ident + ' = {' + LineEnding;
		f.WriteString(l);

		for i:= 0 to AData.Count - 1 do
			begin
			l:= #09#09 + DecorateDataValue(AKey, AData[i]);
			if  i < AData.Count - 1 then
				l:= l + ',' + LineEnding
			else
				l:= l + '};' + LineEnding;
			f.WriteString(l);
			end
		end;

	procedure EmitEventData(const AKey: TTildaPersistent;
			AData: TTildaPersistDataList);
		var
		l: string;

		begin
		l:= CTypeOf(AKey) + ' ' + AKey.ident + '(void) {' + LineEnding;
		f.WriteString(l);
		l:= '}' + LineEnding;
		f.WriteString(l);
		end;

	begin
	if  IsValidIdent(FBaseName) then
		cid:= FBaseName
	else
		cid:= InputBox('Generate C...', 'unit id:', '');

	if  IsValidIdent(cid)
	and SelectDirectoryDialog1.Execute then
		begin
		persistents.Clear;
		persistTemp.Clear;
		persistData.Clear;

		for i:= 0 to abstracts.Count - 1 do
			abstracts[i].PersistState;

		f:= TStringStream.Create;
		for i:= 0 to persistents.Count - 1 do
			begin
			if  (persistents[i] is TTildaEvent)
			and TTildaEvent(persistents[i]).system then
				Continue;

			l:= 'extern ' + CTypeOf(persistents[i]) + ' ' + persistents[i].ident;

			if  persistents[i].mode = tpmArray then
				l:= l + '[]'
			else if persistents[i].mode = tpmEvent then
				l:= l + '(void)';

			l:= l + ';' + LineEnding;

			f.WriteString(l);
			f.WriteString(LineEnding);
			end;

		f.Position:= 0;
		f.SaveToFile(IncludeTrailingPathDelimiter(SelectDirectoryDialog1.FileName) +
				cid + '.h');

		f.Clear;

		for i:= 0 to persistData.Keys.Count - 1 do
			begin
			k:= persistData.Keys.ToArray[i];

			if  (k is TTildaEvent)
			and TTildaEvent(k).system then
				Continue;

			if  k.mode = tpmArray then
				EmitArrayData(k, persistData.Items[k])
			else if k.mode = tpmStruct then
				EmitStructData(k, persistData.Items[k])
			else if k.mode = tpmEvent then
				EmitEventData(k, persistData.Items[k]);

			f.WriteString(LineEnding);
			end;

		f.Position:= 0;
		f.SaveToFile(IncludeTrailingPathDelimiter(SelectDirectoryDialog1.FileName) +
				cid + '.c');
		end;
	end;

procedure TTildaDesignMainForm.actObjNewPageExecute(Sender: TObject);
	var
	s,
	id: string;
	p: TTildaPage;
	u: TTildaUInterface;

	begin
	s:= 'pge_' + FBaseName + '_';
	id:= InputBox('New Page...', 'ident:', s);

	if  (s <> id)
	and IsValidIdent(id) then
		begin
		u:= FirstByClass(TTildaUInterface) as TTildaUInterface;

		p:= TTildaPage.Create(id, u);
		abstracts.Add(p);

//		VirtualStringTree1.RootNodeCount:= abstracts.Count;
//		DoBuildTree;
		end;
	end;

procedure TTildaDesignMainForm.actObjNewPanelExecute(Sender: TObject);
	var
	s,
	id: string;
	p: TTildaPanel;
	u: TTildaUInterface;
	l: TTildaLayer;

	begin
	s:= 'pnl_' + FBaseName + '_';
	id:= InputBox('New Panel...', 'ident:', s);

	if  (s <> id)
	and IsValidIdent(id) then
		begin
		u:= FirstByClass(TTildaUInterface) as TTildaUInterface;
		l:= FirstByClass(TTildaLayer) as TTildaLayer;

		p:= TTildaPanel.Create(id, u);
		p.layer:= l;
		abstracts.Add(p);
		end;
	end;

procedure TTildaDesignMainForm.actObjNewPointExecute(Sender: TObject);
	var
	s,
	id: string;
	p: TTildaPoint;

	begin
	s:= 'pnt_'+FBaseName+'_';
	id:= InputBox('New Point...', 'ident:', s);

	if  (id <> s)
	and IsValidIdent(id) then
		begin
		p:= TTildaPoint.Create(id, nil);
		abstracts.Add(p);
		end;
	end;

procedure TTildaDesignMainForm.actObjNewTextExecute(Sender: TObject);
	var
	s,
	id: string;
	t: TTildaText;

	begin
	s:= 'str_'+FBaseName+'_';
	id:= InputBox('New Text...', 'ident:', s);

	if  (id <> s)
	and IsValidIdent(id) then
		begin
		t:= TTildaText.Create(id, nil);
		abstracts.Add(t);
		end;
	end;

procedure TTildaDesignMainForm.actViewTheme0Execute(Sender: TObject);
	begin
	FTheme:= TAction(Sender).Tag;
	DoScreenChange(Sender);
	end;

procedure TTildaDesignMainForm.ControlBar1BandDrag(Sender: TObject;
		Control: TControl; var Drag: Boolean);
	begin
	Drag:= False;
	end;

procedure TTildaDesignMainForm.ControlBar1EndDrag(Sender, Target: TObject; X,
		Y: Integer);
	begin
	end;

procedure TTildaDesignMainForm.FormCreate(Sender: TObject);
	begin
//	VirtualStringTree1.NodeDataSize:= SizeOf(TCustNode);
//	VirtualStringTree1.RootNodeCount:= 4;

	actViewTheme0.Caption:= ARR_REC_JUDE_THEME[0].name;
	actViewTheme1.Caption:= ARR_REC_JUDE_THEME[1].name;
	actViewTheme2.Caption:= ARR_REC_JUDE_THEME[2].name;
	actViewTheme3.Caption:= ARR_REC_JUDE_THEME[3].name;
	actViewTheme4.Caption:= ARR_REC_JUDE_THEME[4].name;
	actViewTheme5.Caption:= ARR_REC_JUDE_THEME[5].name;

	abstracts.OnNotify:= DoAbstractsNotify;
	DoBuildTree;
	end;

procedure TTildaDesignMainForm.FormShow(Sender: TObject);
	begin
	TildaDesignScreenForm.Show;
	ControlBar1.AutoSize:= True;
	end;

procedure TTildaDesignMainForm.VirtualStringTree1Change(Sender: TBaseVirtualTree;
		Node: PVirtualNode);
	var
	a: TTildaAbstract;
	f: TTildaDesignEditFrameClass;
	d: PCustNode;

	begin
	if  Assigned(FFrame) then
		begin
		FFrame.Closing:= True;

		FFrame.Free;
		FFrame:= nil;
		end;

	FSelected:= nil;

	if  Assigned(Node) then
		begin
		d:= VirtualStringTree1.GetNodeData(Node);

		if  not Assigned(d^.abstract) then
			Exit;

		a:= d^.abstract;

		f:= EditorForClass(TTildaAbstractClass(a.ClassType));

		if  Assigned(f) then
			begin
			FFrame:= f.Create(Self);
			FFrame.Parent:= Panel1;
			FFrame.Align:= alClient;
			FFrame.SetItem(a);

			FSelected:= a;

			ActiveControl:= FFrame.ValueListEditor1;

			FFrame.OnChange:= DoScreenChange;
			DoScreenChange(Self);
			end;
		end;
	end;

procedure TTildaDesignMainForm.VirtualStringTree1DragAllowed(
	Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
	var Allowed: Boolean);
begin
    Allowed:= False;
end;

procedure TTildaDesignMainForm.VirtualStringTree1DragOver(
	Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState;
	State: TDragState; const Pt: TPoint; Mode: TDropMode; var Effect: LongWord;
	var Accept: Boolean);
begin
	Accept:= False;
end;

procedure TTildaDesignMainForm.VirtualStringTree1GetImageIndex(
		Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
		Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
	var
	d: PCustNode;

	begin
	if  Assigned(Node) then
		begin
		d:= Sender.GetNodeData(Node);

		if  not Assigned(d^.abstract) then
			ImageIndex:= d^.Icon;
		end;
	end;

procedure TTildaDesignMainForm.VirtualStringTree1GetNodeDataSize(
		Sender: TBaseVirtualTree; var NodeDataSize: Integer);
	begin
	NodeDataSize:= SizeOf(TCustNode);
	end;


procedure TTildaDesignMainForm.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
		Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
		var CellText: String);
	var
	data: PCustNode;

	begin
	data:= VirtualStringTree1.GetNodeData(Node);
	if  not Assigned(data^.abstract) then
		CellText:= data^.internal
	else
		CellText:= data^.abstract.ident;
	end;

procedure TTildaDesignMainForm.DoBuildTree;
	var
	node: PVirtualNode;
	data: PCustNode;
	i: Integer;

	begin
	VirtualStringTree1.RootNodeCount:= 0;

	FNodeEvt:= VirtualStringTree1.AddChild(nil);
	data:= VirtualStringTree1.GetNodeData(FNodeEvt);
	data^.internal:= 'Events';
	data^.icon:= 2;

	FNodePts:= VirtualStringTree1.AddChild(nil);
	data:= VirtualStringTree1.GetNodeData(FNodePts);
	data^.internal:= 'Points';
	data^.icon:= 4;

	FNodeTex:= VirtualStringTree1.AddChild(nil);
	data:= VirtualStringTree1.GetNodeData(FNodeTex);
	data^.internal:= 'Texts';
	data^.icon:= 3;

	FNodeObj:= VirtualStringTree1.AddChild(nil);
	data:= VirtualStringTree1.GetNodeData(FNodeObj);
	data^.internal:= 'Objects';
	data^.icon:= 0;

	FNodeElm:= VirtualStringTree1.AddChild(nil);
	data:= VirtualStringTree1.GetNodeData(FNodeElm);
	data^.internal:= 'Elements';
	data^.icon:= 1;


	FNodePge:= VirtualStringTree1.AddChild(FNodeElm);
	data:= VirtualStringTree1.GetNodeData(FNodePge);
	data^.internal:= 'Pages';
	data^.icon:= 5;

	FNodePnl:= VirtualStringTree1.AddChild(FNodeElm);
	data:= VirtualStringTree1.GetNodeData(FNodePnl);
	data^.internal:= 'Panels';
	data^.icon:= 6;

	FNodeCtl:= VirtualStringTree1.AddChild(FNodeElm);
	data:= VirtualStringTree1.GetNodeData(FNodeCtl);
	data^.internal:= 'Controls';
	data^.icon:= 7;

	VirtualStringTree1.FullExpand(FNodeElm);

	for i:= 0 to abstracts.Count - 1 do
		begin
		if  abstracts[i] is TTildaEvent then
			node:= VirtualStringTree1.AddChild(FNodeEvt)
		else if abstracts[i] is TTildaPoint then
			node:= VirtualStringTree1.AddChild(FNodePts)
		else if abstracts[i] is TTildaText then
			node:= VirtualStringTree1.AddChild(FNodeTex)
		else if abstracts[i] is TTildaPage then
			node:= VirtualStringTree1.AddChild(FNodePge)
		else if abstracts[i] is TTildaPanel then
			node:= VirtualStringTree1.AddChild(FNodePnl)
		else if abstracts[i] is TTildaControl then
			node:= VirtualStringTree1.AddChild(FNodeCtl)
		else if abstracts[i] is TTildaElement then
			node:= VirtualStringTree1.AddChild(FNodeElm)
		else
			node:= VirtualStringTree1.AddChild(FNodeObj);

		data:= VirtualStringTree1.GetNodeData(node);
		data^.abstract:= abstracts[i];
		end;
	end;

procedure TTildaDesignMainForm.DoScreenChange(ASender: TObject);
	begin
	TildaDesignScreenForm.PaintInterface(FSelected, FTheme);
	end;

procedure TTildaDesignMainForm.DoAbstractsNotify(ASender: TObject; constref
		AItem: TTildaAbstract; AAction: TCollectionNotification);
	var
	pnode,
	node: PVirtualNode;
	data: PCustNode;

	begin
	if  AAction = cnAdded then
		begin
		if  AItem is TTildaEvent then
			pnode:= FNodeEvt
		else if AItem is TTildaPoint then
			pnode:= FNodePts
		else if AItem is TTildaText then
			pnode:= FNodeTex
		else if AItem is TTildaPage then
			pnode:= FNodePge
		else if AItem is TTildaPanel then
			pnode:= FNodePnl
		else if AItem is TTildaControl then
			pnode:= FNodeCtl
		else if AItem is TTildaElement then
			pnode:= FNodeElm
		else
			pnode:= FNodeObj;

		node:= VirtualStringTree1.AddChild(pnode);

		data:= VirtualStringTree1.GetNodeData(node);
		data^.abstract:= AItem;

		VirtualStringTree1.FullExpand(pnode);
		end;
	end;


end.

