unit TildaDesignTypes;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Generics.Collections, DOM, TildaDesignPersist;

const
	VAL_SIZ_TILDA_BAR = 0;
	VAL_SIZ_TILDA_CTRL = 0;
	VAL_SIZ_TILDA_ELEM = 0;
	VAL_SIZ_TILDA_LAYR = 0;
	VAL_SIZ_TILDA_MODL = 0;
	VAL_SIZ_TILDA_OBJT = 0;
	VAL_SIZ_TILDA_PAGE = 0;
	VAL_SIZ_TILDA_PANL = 0;
	VAL_SIZ_TILDA_UINT = 0;
	VAL_SIZ_TILDA_VIEW = 0;

type
	TTildaEventKind = (tekPrepare, tekInitialise, tekChange, tekRelease, tekPresent, tekKeypress);
	TTildaStateKind = (tskChanged, tskDirty, tskPrepared, tskVisible, tskEnabled, tskPicked, 
			tskActive, tskDown, tskExPresent);
	TTildaState = set of TTildaStateKind;
	TTildaOptionKind = (tokNoAutoInvl, tokNoNavigate, tokNoDownActv, tokDownCapture, 
			tokAutoCheck, tokTextAccel2X, tokTextContMrk, tokNoAutoChkOf, tokAutoTrack);
	TTildaOptions = set of TTildaOptionKind;

	TTildaColourDomain = (tcdTheme, tcdSysText, tcdSysControl);
	TTildaColourKind = (tckBack, tckEmpty, tckCursor, tckText, tckFocus, tckInset, tckFace,
			tckShadow, tckPaper, tckMoney, tckItem, tckInform, tckAccept, tckApply, tckAbort);

	TTildaFarPointer = Cardinal;

	TTildaNameStr = string[16];

	TTildaColour = Word;

 	TTildaAbstract = class;
	TTildaAbstractClass = class of TTildaAbstract;

	TTildaObject = class;

	{ TTildaAbstract }

 	TTildaAbstract = class(TTildaPersistent)
		refCount: Integer;

		constructor Create(const AIdent: string; const AParent: TTildaObject); virtual;
	end;

	TTildaAbstracts = TList<TTildaAbstract>;

	{ TTildaPoint }

 	TTildaPoint = class(TTildaAbstract)
	public
		x,
		y: Byte;

		procedure PersistState; override;

		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override;
	end;

	{ TTildaText }

	TTildaText = class(TTildaAbstract)
		text: string;

		procedure PersistState; override;

		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override;
	end;

	{ TTildaEvent }

	TTildaEvent = class(TTildaAbstract)
		kind: TTildaEventKind;
		system: Boolean;

		procedure PersistState; override;

		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override;
	end;

	TTildaEvents = TList<TTildaEvent>;

	{ TTildaObject }

 	TTildaObject = class(TTildaAbstract)
		parent: TTildaObject;

		prepare,
		initialise,
		change,
		release: TTildaEvent;

		state,
 		oldState: TTildaState;
		options: TTildaOptions;
		tag: Word;

		procedure PersistState; override;

		class function size: Byte; virtual; abstract;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override;
	end;

	{ TTildaNamedObject }

	TTildaNamedObject = class(TTildaObject)
		name:	TTildaNameStr;

		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ReadFromNode(const ANode: TDomNode); override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		procedure PersistState; override;
	end;

	TTildaUnit = class(TTildaNamedObject);

	TTildaUnits = TList<TTildaUnit>;

	{ TTildaModule }

 	TTildaModule = class(TTildaNamedObject)
		units: TTildaUnits;

		procedure PersistState; override;

		class function size: Byte; override;
		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override; 
		destructor  Destroy; override;
	end;

	TTildaView = class;
	TTildaViews = TList<TTildaView>;

	{ TTildaUInterface }

 	TTildaUInterface = class(TTildaUnit)
		mouseloc,
		mptrloc: TTildaFarPointer;

		mousepal: Byte;

		views: TTildaViews;

		procedure PersistState; override;

		class function size: Byte; override;
		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override; 
		destructor  Destroy; override;
	end;

	TTildaLayer = class;
	TTildaLayers = TList<TTildaLayer>;

	TTildaBar = class;
	TTildaBars = TList<TTildaBar>;

	TTildaPage = class;
	TTildaPages = TList<TTildaPage>;

	{ TTildaLayer }

 	TTildaLayer = class(TTildaObject)
		width: Byte;
		offset: Word;
		transparent: Byte;
		background: Byte;

		procedure PersistState; override;

		class function size: Byte; override;
		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override; 
		destructor  Destroy; override;
	end;

	{ TTildaView }

 	TTildaView = class(TTildaObject)
		width,
		height: Byte;

		location: TTildaFarPointer;
		cellsize: Byte;

		layers: TTildaLayers;

		bars: TTildaBars;

		actvpage: TTildaPage;

		pages: TTildaPages;

		linelen: Word;

		procedure PersistState; override;

		class function size: Byte; override;
		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override;
		destructor  Destroy; override;
	end;

	{ TTildaElement }

 	TTildaElement = class(TTildaObject)
		present,
		keypress: TTildaEvent;

		owner: TTildaObject;

		colour: TTildaColour;

		ptoffs: TTildaPoint;

		posx,
		posy,
		width,
		height: Byte;

		procedure PersistState; override;

		class function size: Byte; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override; 
		destructor  Destroy; override;
	end;

	TTildaControl = class;

	TTildaControls = TList<TTildaControl>;

	{ TTildaPanel }

 	TTildaPanel = class(TTildaElement)
		layer: TTildaLayer;

		controls: TTildaControls;

		procedure PersistState; override;

		class function size: Byte; override;
		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override; 
		destructor  Destroy; override;
	end;

	TTildaPanels = TList<TTildaPanel>;

	{ TTildaBar }

 	TTildaBar = class(TTildaPanel)
		position: Byte;

		procedure PersistState; override;

		class function size: Byte; override;
		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override; 
		destructor  Destroy; override;
	end;


	{ TTildaPage }

 	TTildaPage = class(TTildaElement)
		pagenxt,
		pagebak: TTildaPage;

		text: TTildaText;
		textoffx: Byte;

		panels: TTildaPanels;

		procedure PersistState; override;

		class function size: Byte; override;
		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override; 
		destructor  Destroy; override;
	end;

	{ TTildaControl }

 	TTildaControl = class(TTildaElement)
		text: TTildaText;
		textoffx,
		textaccel,
		accelchar: Byte;

		procedure PersistState; override;

		class function size: Byte; override;
		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override; 
		destructor  Destroy; override;
	end;

var
//	colours: TTildaColours;
//	events: TTildaEvents;

	abstracts: TTildaAbstracts;
//	abstractRefs: TTildaAbstractRefs;


implementation

uses
	TildaDesignClasses, TildaDesignUtils, TildaDesignDoc;

//procedure PopulateSystemColours;
//	var
//	clr: TTildaColour;
//	k: TTildaColourKind;
//
//	begin
//	for k in TTildaColourKind do
//		begin
//		clr:= TTildaColour.Create;
//		clr.domain:= tcdTheme;
//		clr.kind:= k;
//		clr.system:= 0;
//
//		colours.Add(clr);
//		end;
//	end;


type
	TTildaEventRec = packed record
		k: TTildaEventKind;
		i: string;
	end;

const
	ARR_REC_TILDA_SYSEVTS: array[0..38] of TTildaEventRec = (
			(k: tekPrepare; i: 'KarlDefModPrepare'),
			(k: tekInitialise; i: 'KarlDefModInit'),
			(k: tekChange; i: 'KarlDefModChange'),
			(k: tekRelease; i: 'KarlDefModRelease'),
			(k: tekPrepare; i: 'JudeDefUIPrepare'),
			(k: tekInitialise; i: 'JudeDefUIInit'),
			(k: tekChange; i: 'JudeDefUIChange'),
			(k: tekRelease; i: 'JudeDefUIRelease'),
			(k: tekPrepare; i: 'JudeDefLyrPrepare'),
			(k: tekInitialise; i: 'JudeDefLyrInit'),
			(k: tekChange; i: 'JudeDefLyrChange'),
			(k: tekRelease; i: 'JudeDefLyrRelease'),
			(k: tekPrepare; i: 'JudeDefViewPrepare'),
			(k: tekInitialise; i: 'JudeDefViewInit'),
			(k: tekChange; i: 'JudeDefViewChange'),
			(k: tekRelease; i: 'JudeDefViewRelease'),
			(k: tekPrepare; i: 'JudeDefPgePrepare'),
			(k: tekInitialise; i: 'JudeDefPgeInit'),
			(k: tekChange; i: 'JudeDefPgeChange'),
			(k: tekRelease; i: 'JudeDefPgeRelease'),
			(k: tekPresent; i: 'JudeDefPgePresent'),
			(k: tekPrepare; i: 'JudeDefPnlPrepare'),
			(k: tekInitialise; i: 'JudeDefPnlInit'),
			(k: tekChange; i: 'JudeDefPnlChange'),
			(k: tekRelease; i: 'JudeDefPnlRelease'),
			(k: tekPresent; i: 'JudeDefPnlPresent'),
			(k: tekPrepare; i: 'JudeDefCtlPrepare'),
			(k: tekInitialise; i: 'JudeDefCtlInit'),
			(k: tekChange; i: 'JudeDefCtlChange'),
			(k: tekRelease; i: 'JudeDefCtlRelease'),
			(k: tekPresent; i: 'JudeDefCtlPresent'),
			(k: tekKeypress; i: 'JudeDefCtlKeypress'),
			(k: tekPresent; i: 'JudeDefEdtPresent'),
			(k: tekKeypress; i: 'JudeDefEdtKeypress'),
			(k: tekChange; i: 'JudeDefLblChange'),
			(k: tekChange; i: 'JudeDefPBtChange'),
			(k: tekPresent; i: 'JudeDefPBtPresent'),
			(k: tekChange; i: 'JudeDefRGpChange'),
			(k: tekChange; i: 'JudeDefRBtChange'));


procedure PopulateSystemEvents;
	var
	i: Integer;
	evt: TTildaEvent;

	begin
	for i:= Low(ARR_REC_TILDA_SYSEVTS) to High(ARR_REC_TILDA_SYSEVTS) do
		begin
		evt:= TTildaEvent.Create(ARR_REC_TILDA_SYSEVTS[i].i, nil);
		evt.kind:= ARR_REC_TILDA_SYSEVTS[i].k;
		evt.system:= True;

//		events.Add(evt);
		abstracts.Add(evt);
		end;
	end;

function SystemEventByRecIndex(const AIndex: Integer): TTildaEvent;
	begin
	Result:= FindByIdent(ARR_REC_TILDA_SYSEVTS[AIndex].i) as TTildaEvent;
	end;

{ TTildaPoint }

procedure TTildaPoint.PersistState;
	begin
//	inherited PersistState;
	end;

class function TTildaPoint.node: string;
	begin
	Result:= 'Point';
	end;

procedure TTildaPoint.ReadFromNode(const ANode: TDomNode);
	begin
	inherited ReadFromNode(ANode);

	x:= StrToInt(ANode.Attributes.GetNamedItem('x').TextContent);
	y:= StrToInt(ANode.Attributes.GetNamedItem('y').TextContent);
	end;

function TTildaPoint.WriteToNode(const ADoc: TDomDocument): TDomElement;
	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('x', IntToStr(x));
	Result.SetAttribute('y', IntToStr(y));
	end;

procedure TTildaPoint.ApplyReference(const ARef: TTildaReference);
	begin
	inherited ApplyReference(ARef);
	end;

constructor TTildaPoint.Create(const AIdent: string;
		const AParent: TTildaObject);
	begin
	inherited Create(AIdent, AParent);
	end;

{ TTildaNamedObject }

function TTildaNamedObject.WriteToNode(const ADoc: TDomDocument): TDomElement;
	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('name', name);
	end;

procedure TTildaNamedObject.ReadFromNode(const ANode: TDomNode);
	begin
	inherited ReadFromNode(ANode);

	name:= ANode.Attributes.GetNamedItem('name').TextContent;
	end;

procedure TTildaNamedObject.ApplyReference(const ARef: TTildaReference);
	begin
	inherited ApplyReference(ARef);
	end;

procedure TTildaNamedObject.PersistState;
	var
	d: TTildaDataItem;

	begin
	inherited PersistState;

	d:= TTildaDataItem.Create('name', tdtString, name);
	persistData.Items[Self].Add(d);
	end;

{ TTildaEvent }

procedure TTildaEvent.PersistState;
	begin

	end;

class function TTildaEvent.node: string;
	begin
	Result:= 'Event';
	end;

procedure TTildaEvent.ReadFromNode(const ANode: TDomNode);
	var
	s: string;

	begin
	inherited ReadFromNode(ANode);

	s:= ANode.Attributes.GetNamedItem('kind').TextContent;

	kind:= TTildaEventKind(StrToInt(s));
	end;

function TTildaEvent.WriteToNode(const ADoc: TDomDocument): TDomElement;
	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('kind', IntToStr(Ord(kind)));
	end;

procedure TTildaEvent.ApplyReference(const ARef: TTildaReference);
	begin

	end;

constructor TTildaEvent.Create(const AIdent: string;
		const AParent: TTildaObject);
	begin
	inherited Create(AIdent, nil);

	mode:= tpmEvent;
	end;

{ TTildaText }

procedure TTildaText.PersistState;
	var
	d: TTildaDataItem;

	begin
	inherited;

	d:= TTildaDataItem.Create('text', tdtString, text);
	persistData.Items[Self].Add(d);
	end;

class function TTildaText.node: string;
	begin
	Result:= 'Text';
	end;

procedure TTildaText.ReadFromNode(const ANode: TDomNode);
	begin
	inherited ReadFromNode(ANode);

	text:= ANode.TextContent;
	end;

function TTildaText.WriteToNode(const ADoc: TDomDocument): TDomElement;
	var
	n: TDomText;

	begin
	Result:= inherited WriteToNode(ADoc);

	n:= ADoc.CreateTextNode(text);
	Result.AppendChild(n);
	end;

procedure TTildaText.ApplyReference(const ARef: TTildaReference);
	begin

	end;

constructor TTildaText.Create(const AIdent: string;
		const AParent: TTildaObject);
	begin
	inherited Create(AIdent, nil);

	mode:= tpmArray;
	end;


{ TTildaControl }

procedure TTildaControl.PersistState;
	var
	p: TTildaPersistent;
	d: TTildaDataItem;
	id: string;
	i: Integer;

	begin
	inherited PersistState;

	if  Assigned(text) then
		id:= text.ident
	else
		id:= '';
	d:= TTildaDataItem.Create('text_p', tdtFarRef, id);
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('textoffx', tdtValue, IntToStr(textoffx));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('textaccel', tdtHexValue, IntToHex(textaccel, 2));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('accelchar', tdtValue, IntToStr(accelchar));
	persistData.Items[Self].Add(d);
	end;

class function TTildaControl.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_CTRL;
	end;

class function TTildaControl.node: string;
	begin
	Result:= 'Control';
	end;

procedure TTildaControl.ReadFromNode(const ANode: TDomNode);
	var
	s: string;

	begin
	inherited;

	AddAbstactRefFromNode(Self, 'text', ANode, TTildaText);

	s:= ANode.Attributes.GetNamedItem('textoffx').TextContent;
	textoffx:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('textaccel').TextContent;
	textaccel:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('accelchar').TextContent;
	accelchar:= StrToInt(s);
	end;

function TTildaControl.WriteToNode(const ADoc: TDomDocument): TDomElement;
	var
	elem: TDomElement;

	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('textoffx', IntToStr(textoffx));
	Result.SetAttribute('textaccel', IntToStr(textaccel));
	Result.SetAttribute('accelchar', IntToStr(accelchar));

	Result.SetAttribute('text', IdentOrEmpty(text));
	end;

procedure TTildaControl.ApplyReference(const ARef: TTildaReference);
	begin
	if  CompareText('text', ARef.prop) = 0 then
		text:= FindByIdent(ARef.ident) as TTildaText
	else
		inherited;
	end;

constructor TTildaControl.Create(const AIdent: string;
		const AParent: TTildaObject);
	begin
	inherited Create(AIdent, AParent);

	prepare:= SystemEventByRecIndex(26);
	initialise:= SystemEventByRecIndex(27);
	change:= SystemEventByRecIndex(28);
	release:= SystemEventByRecIndex(29);
	present:= SystemEventByRecIndex(30);
	keypress:= SystemEventByRecIndex(31);

	end;

destructor TTildaControl.Destroy;
	begin
	inherited Destroy;
	end;

{ TTildaPage }

procedure TTildaPage.PersistState;
	var
	p: TTildaPersistent;
	d: TTildaDataItem;
	id: string;
	i: Integer;

	begin
	inherited PersistState;

	if  Assigned(pagenxt) then
		id:= pagenxt.ident
	else
		id:= '';
	d:= TTildaDataItem.Create('pagenxt', tdtFarRef, id);
	persistData.Items[Self].Add(d);

	if  Assigned(pagebak) then
		id:= pagebak.ident
	else
		id:= '';
	d:= TTildaDataItem.Create('pagebak', tdtFarRef, id);
	persistData.Items[Self].Add(d);

	if  Assigned(text) then
		id:= text.ident
	else
		id:= '';
	d:= TTildaDataItem.Create('text_p', tdtFarRef, id);
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('textoffx', tdtValue, IntToStr(textoffx));
	persistData.Items[Self].Add(d);

	p:= TTildaPersistent.Create(ident + '_panels', tpmArray);
	persistTemp.Add(p);
	p.PersistState;

	d:= TTildaDataItem.Create('panels_p', tdtFarRef, p.ident);
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('panelscnt', tdtValue, IntToStr(panels.Count));
	persistData.Items[Self].Add(d);

	for i:= 0 to panels.Count - 1 do
		begin
		d:= TTildaDataItem.Create('panels_p' + IntToStr(i), tdtFarRef,
				panels[i].ident);
		persistData.Items[p].Add(d);
		end;
	end;

class function TTildaPage.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_PAGE;
	end;

class function TTildaPage.node: string;
	begin
	Result:= 'Page';
	end;

procedure TTildaPage.ReadFromNode(const ANode: TDomNode);
	var
	s: string;

	begin
	inherited;

	AddAbstactRefFromNode(Self, 'pagenxt', ANode, TTildaPage);
	AddAbstactRefFromNode(Self, 'pagebak', ANode, TTildaPage);
	AddAbstactRefFromNode(Self, 'text', ANode, TTildaText);

	AddAbstactRefsFromRefNode(Self, 'Panels', ANode, TTildaPanel);

	s:= ANode.Attributes.GetNamedItem('textoffx').TextContent;
	textoffx:= StrToInt(s);
	end;

function TTildaPage.WriteToNode(const ADoc: TDomDocument): TDomElement;
	var
	i: Integer;
	elem: TDomElement;

	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('pagenxt', IdentOrEmpty(pagenxt));
	Result.SetAttribute('pagebak', IdentOrEmpty(pagebak));

	Result.SetAttribute('textoffx', IntToStr(textoffx));

	elem:= ADoc.CreateElement('Panels');

	for i:= 0 to panels.Count - 1 do
		panels[i].WriteToRefNode(ADoc, elem);

	Result.AppendChild(elem);

	if  Assigned(text) then
		Result.SetAttribute('text', text.ident)
	else
		Result.SetAttribute('text', '');
	end;

procedure TTildaPage.ApplyReference(const ARef: TTildaReference);
	begin
	if  CompareText('pagenxt', ARef.prop) = 0 then
		pagenxt:= FindByIdent(ARef.ident) as TTildaPage
	else if  CompareText('pagebak', ARef.prop) = 0 then
		pagebak:= FindByIdent(ARef.ident) as TTildaPage
	else if  CompareText('text', ARef.prop) = 0 then
		text:= FindByIdent(ARef.ident) as TTildaText
	else if  CompareText('Panels', ARef.prop) = 0 then
		panels.Add(FindByIdent(ARef.ident) as TTildaPanel)
	else
		inherited;
	end;

constructor TTildaPage.Create(const AIdent: string; const AParent: TTildaObject);
	begin
	inherited Create(AIdent, AParent);

	panels:= TTildaPanels.Create;

	prepare:= SystemEventByRecIndex(16);
	initialise:= SystemEventByRecIndex(17);
	change:= SystemEventByRecIndex(18);
	release:= SystemEventByRecIndex(19);
	present:= SystemEventByRecIndex(20);
	keypress:= nil;

	colour:= ThemeColour(tckEmpty);

	end;

destructor TTildaPage.Destroy;
	begin
	inherited Destroy;
	end;

{ TTildaBar }

procedure TTildaBar.PersistState;
	var
	d: TTildaDataItem;

	begin
	inherited PersistState;

	d:= TTildaDataItem.Create('position', tdtValue, IntToStr(position));
	persistData.Items[Self].Add(d);
	end;

class function TTildaBar.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_BAR;
	end;

class function TTildaBar.node: string;
	begin
	Result:= 'Bar';
	end;

procedure TTildaBar.ReadFromNode(const ANode: TDomNode);
	var
	s: string;

	begin
	inherited ReadFromNode(ANode);

	s:= ANode.Attributes.GetNamedItem('position').TextContent;
	position:= StrToInt(s);
	end;

function TTildaBar.WriteToNode(const ADoc: TDomDocument): TDomElement;
	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('position', IntToStr(position));
	end;

procedure TTildaBar.ApplyReference(const ARef: TTildaReference);
	begin
	inherited ApplyReference(ARef);
	end;

constructor TTildaBar.Create(const AIdent: string; const AParent: TTildaObject);
	begin
	inherited Create(AIdent, AParent);

	end;

destructor TTildaBar.Destroy;
	begin
	inherited Destroy;
	end;

{ TTildaPanel }

procedure TTildaPanel.PersistState;
	var
	p: TTildaPersistent;
	d: TTildaDataItem;
	id: string;
	i: Integer;

	begin
	inherited PersistState;

	if  Assigned(layer) then
		id:= layer.ident
	else
		id:= '';
	d:= TTildaDataItem.Create('layer', tdtFarRef, id);
	persistData.Items[Self].Add(d);

	p:= TTildaPersistent.Create(ident + '_controls', tpmArray);
	persistTemp.Add(p);
	p.PersistState;

	d:= TTildaDataItem.Create('controls_p', tdtFarRef, p.ident);
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('controlscnt', tdtValue, IntToStr(controls.Count));
	persistData.Items[Self].Add(d);

	for i:= 0 to controls.Count - 1 do
		begin
		d:= TTildaDataItem.Create('controls_p' + IntToStr(i), tdtFarRef,
				controls[i].ident);
		persistData.Items[p].Add(d);
		end;
	end;

class function TTildaPanel.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_PANL;
	end;

class function TTildaPanel.node: string;
	begin
	Result:= 'Panel';
	end;

procedure TTildaPanel.ReadFromNode(const ANode: TDomNode);
	begin
	inherited ReadFromNode(ANode);

	AddAbstactRefFromNode(Self, 'layer', ANode, TTildaPage);

	AddAbstactRefsFromRefNode(Self, 'Controls', ANode, TTildaLayer);
	end;

function TTildaPanel.WriteToNode(const ADoc: TDomDocument): TDomElement;
	var
	i: Integer;
	elem: TDomElement;

	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('layer', IdentOrEmpty(layer));

	elem:= ADoc.CreateElement('Controls');
	Result.AppendChild(elem);

	for i:= 0 to controls.Count - 1 do
		controls[i].WriteToRefNode(ADoc, elem);
	end;

procedure TTildaPanel.ApplyReference(const ARef: TTildaReference);
	begin
	if  CompareText('layer', ARef.prop) = 0 then
		layer:= FindByIdent(ARef.ident) as TTildaLayer
	else if  CompareText('Controls', ARef.prop) = 0 then
		controls.Add(FindByIdent(ARef.ident) as TTildaControl)
	else
		inherited;
	end;

constructor TTildaPanel.Create(const AIdent: string; const AParent: TTildaObject);
	begin
	inherited Create(AIdent, AParent);

	controls:= TTildaControls.Create;

	prepare:= SystemEventByRecIndex(21);
	initialise:= SystemEventByRecIndex(22);
	change:= SystemEventByRecIndex(23);
	release:= SystemEventByRecIndex(24);
	present:= SystemEventByRecIndex(25);
	keypress:= nil;

	colour:= ThemeColour(tckInset);
	end;

destructor TTildaPanel.Destroy;
	begin
	inherited Destroy;
	end;

{ TTildaElement }

procedure TTildaElement.PersistState;
	var
	d: TTildaDataItem;
	id: string;
	pt: TPoint;

	begin
	inherited PersistState;

	if  not Assigned(present) then
		id:= ''
	else
		id:= present.ident;
	d:= TTildaDataItem.Create('present', tdtEventRef, id);
	persistData.Items[Self].Add(d);

	if  not Assigned(keypress) then
		id:= ''
	else
		id:= keypress.ident;
	d:= TTildaDataItem.Create('keypress', tdtEventRef, id);
	persistData.Items[Self].Add(d);

	if  Assigned(owner) then
		id:= owner.ident
	else
		id:= '';
	d:= TTildaDataItem.Create('owner', tdtFarRef, id);
	persistData.Items[Self].Add(d);

	if  (Ord(colour) and $FF00) <> 0 then
		d:= TTildaDataItem.Create('colour', tdtHexValue, ColourToString(colour))
	else
		d:= TTildaDataItem.Create('colour', tdtValue, ColourToString(colour));
	persistData.Items[Self].Add(d);

	if  Assigned(ptoffs) then
		begin
		pt.x:= ptoffs.x;
		pt.y:= ptoffs.y;
		end
	else
		begin
		pt.x:= 0;
		pt.y:= 0;
		end;

	d:= TTildaDataItem.Create('posx', tdtValue, IntToStr(posx + pt.x));
	persistData.Items[Self].Add(d);
	d:= TTildaDataItem.Create('posy', tdtValue, IntToStr(posy + pt.y));
	persistData.Items[Self].Add(d);
	d:= TTildaDataItem.Create('width', tdtValue, IntToStr(width));
	persistData.Items[Self].Add(d);
	d:= TTildaDataItem.Create('height', tdtValue, IntToStr(height));
	persistData.Items[Self].Add(d);

	end;

class function TTildaElement.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_ELEM;
	end;

procedure TTildaElement.ReadFromNode(const ANode: TDomNode);
	var
	s: string;

	begin
	inherited ReadFromNode(ANode);

	AddAbstactRefFromNode(Self, 'present', ANode, TTildaEvent);
	AddAbstactRefFromNode(Self, 'keypress', ANode, TTildaEvent);
	AddAbstactRefFromNode(Self, 'owner', ANode, TTildaElement);

	s:= ANode.Attributes.GetNamedItem('colour').TextContent;
	colour:= StringToColour(s);

	AddAbstactRefFromNode(Self, 'ptoffs', ANode, TTildaPoint);

	s:= ANode.Attributes.GetNamedItem('posx').TextContent;
	posx:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('posy').TextContent;
	posy:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('width').TextContent;
	width:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('height').TextContent;
	height:= StrToInt(s);
	end;

function TTildaElement.WriteToNode(const ADoc: TDomDocument): TDomElement;
	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('present', IdentOrEmpty(present));
	Result.SetAttribute('keypress', IdentOrEmpty(keypress));

	Result.SetAttribute('owner', IdentOrEmpty(owner));

	Result.SetAttribute('colour', ColourToString(colour));

	Result.SetAttribute('ptoffs', IdentOrEmpty(ptoffs));

	Result.SetAttribute('posx', IntToStr(posx));
	Result.SetAttribute('posy', IntToStr(posy));
	Result.SetAttribute('width', IntToStr(width));
	Result.SetAttribute('height', IntToStr(height));
	end;

procedure TTildaElement.ApplyReference(const ARef: TTildaReference);
	begin
	if  CompareText(ARef.prop, 'present') = 0 then
		present:= FindByIdent(ARef.ident) as TTildaEvent
	else if  CompareText(ARef.prop, 'keypress') = 0 then
		keypress:= FindByIdent(ARef.ident) as TTildaEvent
	else if  CompareText(ARef.prop, 'owner') = 0 then
		owner:= FindByIdent(ARef.ident) as TTildaElement
	else if  CompareText(ARef.prop, 'ptoffs') = 0 then
		ptoffs:= FindByIdent(ARef.ident) as TTildaPoint
	else
		inherited ApplyReference(ARef);
	end;

constructor TTildaElement.Create(const AIdent: string;
		const AParent: TTildaObject);
	begin
	inherited Create(AIdent, AParent);
	end;

destructor TTildaElement.Destroy;
	begin
	inherited Destroy;
	end;

{ TTildaLayer }

procedure TTildaLayer.PersistState;
	var
	d: TTildaDataItem;

	begin
	inherited PersistState;

	d:= TTildaDataItem.Create('width', tdtValue, IntToStr(width));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('offset', tdtValue, IntToStr(offset));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('transparent', tdtValue, IntToStr(transparent));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('background', tdtValue, IntToStr(background));
	persistData.Items[Self].Add(d);

	end;

class function TTildaLayer.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_LAYR;
	end;

class function TTildaLayer.node: string;
	begin
	Result:= 'Layer';
	end;

procedure TTildaLayer.ReadFromNode(const ANode: TDomNode);
	var
	s: string;

	begin
	inherited;

	s:= ANode.Attributes.GetNamedItem('width').TextContent;
	width:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('offset').TextContent;
	offset:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('transparent').TextContent;
	transparent:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('background').TextContent;
	background:= StrToInt(s);
	end;

function TTildaLayer.WriteToNode(const ADoc: TDomDocument): TDomElement;
	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('width', IntToStr(width));
	Result.SetAttribute('offset', IntToStr(offset));
	Result.SetAttribute('transparent', IntToStr(transparent));
	Result.SetAttribute('background', IntToStr(background));
	end;

procedure TTildaLayer.ApplyReference(const ARef: TTildaReference);
	begin
	inherited ApplyReference(ARef);
	end;

constructor TTildaLayer.Create(const AIdent: string; const AParent: TTildaObject);
	begin
	inherited Create(AIdent, AParent);

	prepare:= SystemEventByRecIndex(8);
	initialise:= SystemEventByRecIndex(9);
	change:= SystemEventByRecIndex(10);
	release:= SystemEventByRecIndex(11);

	end;

destructor TTildaLayer.Destroy;
	begin
	inherited Destroy;
	end;

{ TTildaView }

procedure TTildaView.PersistState;
	var
	p: TTildaPersistent;
	d: TTildaDataItem;
	i: Integer;
	id: string;

	begin
	inherited PersistState;

	d:= TTildaDataItem.Create('width', tdtValue, IntToStr(width));
	persistData.Items[Self].Add(d);
	d:= TTildaDataItem.Create('height', tdtValue, IntToStr(height));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('location', tdtFarPtr, IntToHex(location, 8));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('cellsize', tdtValue, IntToStr(cellsize));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('layers_p', tdtFarRef, ident + '_layers');
	persistData.Items[Self].Add(d);
	d:= TTildaDataItem.Create('layerscnt', tdtValue, IntToStr(layers.Count));
	persistData.Items[Self].Add(d);

	p:= TTildaPersistent.Create(ident + '_layers', tpmArray);
	persistTemp.Add(p);
	p.PersistState;

	for i:= 0 to layers.Count - 1 do
		begin
		d:= TTildaDataItem.Create('layers_p' + IntToStr(i), tdtFarRef,
				layers[i].ident);
		persistData.Items[p].Add(d);
		end;

	d:= TTildaDataItem.Create('bars_p', tdtFarRef, ident + '_bars');
	persistData.Items[Self].Add(d);
	d:= TTildaDataItem.Create('barscnt', tdtValue, IntToStr(bars.Count));
	persistData.Items[Self].Add(d);

	p:= TTildaPersistent.Create(ident + '_bars', tpmArray);
	persistTemp.Add(p);
	p.PersistState;

	for i:= 0 to bars.Count - 1 do
		begin
		d:= TTildaDataItem.Create('bars_p' + IntToStr(i), tdtFarRef,
				bars[i].ident);
		persistData.Items[p].Add(d);
		end;

	if  Assigned(actvpage) then
		id:= actvpage.ident
	else
		id:= '';
	d:= TTildaDataItem.Create('actvpage', tdtFarRef, id);
	persistData.Items[Self].Add(d);


	d:= TTildaDataItem.Create('pages_p', tdtFarRef, ident + '_pages');
	persistData.Items[Self].Add(d);
	d:= TTildaDataItem.Create('pagescnt', tdtValue, IntToStr(pages.Count));
	persistData.Items[Self].Add(d);

	p:= TTildaPersistent.Create(ident + '_pages', tpmArray);
	persistTemp.Add(p);
	p.PersistState;

	for i:= 0 to pages.Count - 1 do
		begin
		d:= TTildaDataItem.Create('pages_p' + IntToStr(i), tdtFarRef,
				pages[i].ident);
		persistData.Items[p].Add(d);
		end;

	d:= TTildaDataItem.Create('linelen', tdtValue, IntToStr(linelen));
	persistData.Items[Self].Add(d);
	end;

class function TTildaView.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_VIEW;
	end;

class function TTildaView.node: string;
	begin
	Result:= 'View';
	end;

procedure TTildaView.ReadFromNode(const ANode: TDomNode);
	var
	s: string;

	begin
	inherited;

	s:= ANode.Attributes.GetNamedItem('width').TextContent;
	width:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('height').TextContent;
	height:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('location').TextContent;
	location:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('cellsize').TextContent;
	cellsize:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('linelen').TextContent;
	linelen:= StrToInt(s);

	AddAbstactRefFromNode(Self, 'actvpage', ANode, TTildaPage);

	AddAbstactRefsFromRefNode(Self, 'Layers', ANode, TTildaLayer);
	AddAbstactRefsFromRefNode(Self, 'Bars', ANode, TTildaBar);
	AddAbstactRefsFromRefNode(Self, 'Pages', ANode, TTildaPage);
	end;

function TTildaView.WriteToNode(const ADoc: TDomDocument): TDomElement;
	var
	i: Integer;
	elem: TDomElement;

	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('width', IntToStr(width));
	Result.SetAttribute('height', IntToStr(height));
	Result.SetAttribute('location', IntToStr(location));
	Result.SetAttribute('cellsize', IntToStr(cellsize));

	if  Assigned(actvpage) then
		Result.SetAttribute('actvpage', actvpage.ident)
	else
		Result.SetAttribute('actvpage', '');

	Result.SetAttribute('linelen', IntToStr(linelen));

	elem:= ADoc.CreateElement('Layers');
	Result.AppendChild(elem);

	for i:= 0 to layers.Count - 1 do
		layers[i].WriteToRefNode(ADoc, elem);

	elem:= ADoc.CreateElement('Bars');
	Result.AppendChild(elem);

	for i:= 0 to bars.Count - 1 do
		bars[i].WriteToRefNode(ADoc, elem);

	elem:= ADoc.CreateElement('Pages');
	Result.AppendChild(elem);

	for i:= 0 to pages.Count - 1 do
		pages[i].WriteToRefNode(ADoc, elem);
	end;

procedure TTildaView.ApplyReference(const ARef: TTildaReference);
	begin
	if  CompareText(ARef.prop, 'Layers') = 0 then
		layers.Add(FindByIdent(ARef.ident) as TTildaLayer)
	else if CompareText(ARef.prop, 'Bars') = 0 then
		bars.Add(FindByIdent(ARef.ident) as TTildaBar)
	else if CompareText(ARef.prop, 'Pages') = 0 then
		pages.Add(FindByIdent(ARef.ident) as TTildaPage)
	else if CompareText(ARef.prop, 'actvpage') = 0 then
		actvpage:=  FindByIdent(ARef.ident) as TTildaPage
	else
		inherited ApplyReference(ARef);
	end;

constructor TTildaView.Create(const AIdent: string; const AParent: TTildaObject);
	begin
	inherited Create(AIdent, AParent);

	layers:= TTildaLayers.Create;
	bars:= TTildaBars.Create;
	pages:= TTildaPages.Create;

	prepare:= SystemEventByRecIndex(12);
	initialise:= SystemEventByRecIndex(13);
	change:= SystemEventByRecIndex(14);
	release:= SystemEventByRecIndex(15);

	end;

destructor TTildaView.Destroy;
	begin
	inherited Destroy;
	end;

{ TTildaUInterface }

procedure TTildaUInterface.PersistState;
	var
	p: TTildaPersistent;
	d: TTildaDataItem;
	i: Integer;

	begin
	inherited PersistState;

	d:= TTildaDataItem.Create('mouseloc', tdtFarPtr, IntToHex(mouseloc, 8));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('mptrloc', tdtFarPtr, IntToHex(mptrloc, 8));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('mousepal', tdtValue, IntToStr(mousepal));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('views_p', tdtFarRef, ident + '_views');
	persistData.Items[Self].Add(d);
	d:= TTildaDataItem.Create('viewscnt', tdtValue, IntToStr(views.Count));
	persistData.Items[Self].Add(d);

	p:= TTildaPersistent.Create(ident + '_views', tpmArray);
	persistTemp.Add(p);
	p.PersistState;

	for i:= 0 to views.Count - 1 do
		begin
		d:= TTildaDataItem.Create('views_p' + IntToStr(i), tdtFarRef,
				views[i].ident);
		persistData.Items[p].Add(d);
		end;
	end;

class function TTildaUInterface.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_UINT;
	end;

class function TTildaUInterface.node: string;
	begin
	Result:= 'UInterface';
	end;

procedure TTildaUInterface.ReadFromNode(const ANode: TDomNode);
	var
	s: string;

	begin
	inherited;

	s:= ANode.Attributes.GetNamedItem('mouseloc').TextContent;
	mouseloc:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('mptrloc').TextContent;
	mptrloc:= StrToInt(s);

	s:= ANode.Attributes.GetNamedItem('mousepal').TextContent;
	mousepal:= StrToInt(s);

	AddAbstactRefsFromRefNode(Self, 'Views', ANode, TTildaView);
	end;

function TTildaUInterface.WriteToNode(const ADoc: TDomDocument): TDomElement;
	var
	i: Integer;
	elem: TDomElement;

	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('mouseloc', IntToStr(mouseloc));
	Result.SetAttribute('mptrloc', IntToStr(mptrloc));

	Result.SetAttribute('mousepal', IntToStr(mousepal));

	elem:= ADoc.CreateElement('Views');
	Result.AppendChild(elem);

	for i:= 0 to views.Count - 1 do
		views[i].WriteToRefNode(ADoc, elem);
	end;

procedure TTildaUInterface.ApplyReference(const ARef: TTildaReference);
	begin
	if  CompareText(ARef.prop, 'Views') = 0 then
		views.Add(FindByIdent(ARef.ident) as TTildaView)
	else
		inherited ApplyReference(ARef);
	end;

constructor TTildaUInterface.Create(const AIdent: string; 
		const AParent: TTildaObject);
	begin
	inherited Create(AIdent, AParent);

	prepare:= SystemEventByRecIndex(4);
	initialise:= SystemEventByRecIndex(5);
	change:= SystemEventByRecIndex(6);
	release:= SystemEventByRecIndex(7);

	name:= StringOfChar(' ', 16);

	views:= TTildaViews.Create;
	end;

destructor TTildaUInterface.Destroy;
	begin
	inherited Destroy;
	end;

{ TTildaModule }

procedure TTildaModule.PersistState;
	var
	p: TTildaPersistent;
	d: TTildaDataItem;
	i: Integer;

	begin
	inherited PersistState;

	d:= TTildaDataItem.Create('units_p', tdtFarRef, ident + '_units');
	persistData.Items[Self].Add(d);
	d:= TTildaDataItem.Create('unitscnt', tdtValue, IntToStr(units.Count));
	persistData.Items[Self].Add(d);

	p:= TTildaPersistent.Create(ident + '_units', tpmArray);
	persistTemp.Add(p);
	p.PersistState;

	for i:= 0 to units.Count - 1 do
		begin
		d:= TTildaDataItem.Create('units_p' + IntToStr(i), tdtFarRef,
				units[i].ident);
		persistData.Items[p].Add(d);
		end;
	end;

class function TTildaModule.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_MODL;
	end;

class function TTildaModule.node: string;
	begin
	Result:= 'Module'
	end;

procedure TTildaModule.ReadFromNode(const ANode: TDomNode);
	begin
	inherited;

	AddAbstactRefsFromRefNode(Self, 'Units', ANode, TTildaUInterface);
	end;

function TTildaModule.WriteToNode(const ADoc: TDomDocument): TDomElement;
	var
	elem: TDomElement;
	i: Integer;

	begin
	Result:= inherited WriteToNode(ADoc);

	elem:= ADoc.CreateElement('Units');
	Result.AppendChild(elem);

	for i:= 0 to units.Count - 1 do
		units[i].WriteToRefNode(ADoc, elem);
	end;

procedure TTildaModule.ApplyReference(const ARef: TTildaReference);
	begin
	if  CompareText(ARef.prop, 'Units') = 0 then
		units.Add(FindByIdent(ARef.ident) as TTildaUInterface)
	else
		inherited ApplyReference(ARef);
	end;

constructor TTildaModule.Create(const AIdent: string;
		const AParent: TTildaObject);
	begin
	inherited Create(AIdent, AParent);

	prepare:= SystemEventByRecIndex(0);
	initialise:= SystemEventByRecIndex(1);
	change:= SystemEventByRecIndex(2);
	release:= SystemEventByRecIndex(3);

	name:= StringOfChar(' ', 16);

	units:= TTildaUnits.Create;
	end;

destructor TTildaModule.Destroy;
	begin
	inherited Destroy;
	end;

{ TTildaObject }

procedure TTildaObject.PersistState;
	var
	d: TTildaDataItem;
	id: string;

	begin
	inherited;

	d:= TTildaDataItem.Create('size', tdtSize, IntToStr(size));
	persistData.Items[Self].Add(d);

	if  Assigned(parent) then
		id:= parent.ident
	else
		id:= '';
	d:= TTildaDataItem.Create('parent', tdtFarRef, id);
	persistData.Items[Self].Add(d);

	if  not Assigned(prepare) then
		id:= ''
	else
		id:= prepare.ident;
	d:= TTildaDataItem.Create('prepare', tdtEventRef, id);
	persistData.Items[Self].Add(d);

	if  not Assigned(initialise) then
		id:= ''
	else
		id:= initialise.ident;
	d:= TTildaDataItem.Create('initialise', tdtEventRef, id);
	persistData.Items[Self].Add(d);

	if  not Assigned(change) then
		id:= ''
	else
		id:= change.ident;
	d:= TTildaDataItem.Create('change', tdtEventRef, id);
	persistData.Items[Self].Add(d);

	if  not Assigned(release) then
		id:= ''
	else
		id:= release.ident;
	d:= TTildaDataItem.Create('release', tdtEventRef, id);
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('state', tdtHexValue, StateToHex(state));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('oldstate', tdtHexValue, StateToHex(oldState));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('options', tdtHexValue, OptionsToHex(options));
	persistData.Items[Self].Add(d);

	d:= TTildaDataItem.Create('tag', tdtValue, IntToStr(tag));
	persistData.Items[Self].Add(d);
	end;

procedure TTildaObject.ReadFromNode(const ANode: TDomNode);
	var
	s: string;

	begin
	inherited ReadFromNode(ANode);

	AddAbstactRefFromNode(Self, 'parent', ANode, TTildaObject);

	AddAbstactRefFromNode(Self, 'prepare', ANode, TTildaEvent);
	AddAbstactRefFromNode(Self, 'initialise', ANode, TTildaEvent);
	AddAbstactRefFromNode(Self, 'change', ANode, TTildaEvent);
	AddAbstactRefFromNode(Self, 'release', ANode, TTildaEvent);

	s:= ANode.Attributes.GetNamedItem('state').TextContent;
	state:= HexToState(s);

	s:= ANode.Attributes.GetNamedItem('oldstate').TextContent;
	oldstate:= HexToState(s);

	s:= ANode.Attributes.GetNamedItem('options').TextContent;
	options:= HexToOptions(s);

	s:= ANode.Attributes.GetNamedItem('tag').TextContent;
	tag:= StrToInt(s);
	end;

function TTildaObject.WriteToNode(const ADoc: TDomDocument): TDomElement;
	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('size', IntToStr(size));

	Result.SetAttribute('parent', IdentOrEmpty(parent));

	Result.SetAttribute('prepare', IdentOrEmpty(prepare));
	Result.SetAttribute('initialise', IdentOrEmpty(initialise));
	Result.SetAttribute('change', IdentOrEmpty(change));
	Result.SetAttribute('release', IdentOrEmpty(release));

	Result.SetAttribute('state', StateToHex(state));
	Result.SetAttribute('oldstate', StateToHex(oldstate));

	Result.SetAttribute('options', OptionsToHex(options));

	Result.SetAttribute('tag', IntToStr(tag));
	end;

procedure TTildaObject.ApplyReference(const ARef: TTildaReference);
	begin
	if  CompareText(ARef.prop, 'parent') = 0  then
		parent:= FindByIdent(ARef.ident) as TTildaObject
	else if CompareText(ARef.prop, 'prepare') = 0  then
		prepare:= FindByIdent(ARef.ident) as TTildaEvent
	else if CompareText(ARef.prop, 'initialise') = 0  then
		initialise:= FindByIdent(ARef.ident) as TTildaEvent
	else if CompareText(ARef.prop, 'change') = 0  then
		change:= FindByIdent(ARef.ident) as TTildaEvent
	else if CompareText(ARef.prop, 'release') = 0  then
		release:= FindByIdent(ARef.ident) as TTildaEvent
	else
		inherited ApplyReference(ARef);
	end;

constructor TTildaObject.Create(const AIdent: string;
		const AParent: TTildaObject);
	begin
	inherited Create(AIdent, nil);

	parent:= AParent;

	state:= [tskVisible, tskEnabled];

	mode:= tpmStruct;
	end;

{ TTildaAbstract }

constructor TTildaAbstract.Create(const AIdent: string;
		const AParent: TTildaObject);
	begin
	ident:= AIdent;
	end;


initialization
//	colours:= TTildaColours.Create;
//	events:= TTildaEvents.Create;

	abstracts:= TTildaAbstracts.Create;
//	abstractRefs:= TTildaAbstractRefs.Create;

//	PopulateSystemColours;
	PopulateSystemEvents;


finalization

end.

