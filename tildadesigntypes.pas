unit TildaDesignTypes;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Generics.Collections, DOM;

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

	//TTildaColour = class(TObject)
	//	domain: TTildaColourDomain;
	//	kind: TTildaColourKind;
	//	system: Byte;
	//end;
 //
	//TTildaColours = TList<TTildaColour>;


 	TTildaAbstract = class;
	TTildaAbstractClass = class of TTildaAbstract;

	TTildaReference = class(TObject)
		node: string;
		abstract: TTildaAbstractClass;
		ident: string;
	end;

	TTildaReferences = TList<TTildaReference>;
	TTildaAbstractRefs = TDictionary<TTildaAbstract, TTildaReferences>;

	{ TTildaAbstract }

 	TTildaAbstract = class(TObject)
		ident: string;
		refCount: Integer;

		class function node: string; virtual; abstract;

		procedure ReadFromNode(const ANode: TDomNode); virtual; abstract;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; virtual;
		procedure WriteToRefNode(const ADoc: TDomDocument;
				const AParent: TDomElement); virtual;
		procedure ApplyReference(const ARef: TTildaReference); virtual; abstract;

		constructor Create(const AIdent: string);
	end;

	TTildaAbstracts = TList<TTildaAbstract>;

	{ TTildaText }

	TTildaText = class(TTildaAbstract)
		text: string;

		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string);
	end;

	{ TTildaEvent }

	TTildaEvent = class(TTildaAbstract)
		kind: TTildaEventKind;
		system: Boolean;

		class function node: string; override;

		procedure ReadFromNode(const ANode: TDomNode); override;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;
		procedure ApplyReference(const ARef: TTildaReference); override;

		constructor Create(const AIdent: string);
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

		class function size: Byte; virtual; abstract;

		function  WriteToNode(const ADoc: TDomDocument): TDomElement; override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); virtual; 
	end;

	TTildaNamedObject = class(TTildaObject)
		name:	TTildaNameStr;
	end;

	TTildaUnit = class(TTildaNamedObject);

	TTildaUnits = TList<TTildaUnit>;

	{ TTildaModule }

 	TTildaModule = class(TTildaNamedObject)
		name: TTildaNameStr;
		units: TTildaUnits;

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
		name: TTildaNameStr;
		mouseloc,
		mptrloc: TTildaFarPointer;

		mousepal: Byte;

		views: TTildaViews;

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

		posx,
		posy,
		width,
		height: Byte;

		class function size: Byte; override;

		constructor Create(const AIdent: string; const AParent: TTildaObject); override; 
		destructor  Destroy; override;
	end;

	TTildaControl = class;

	TTildaControls = TList<TTildaControl>;

	{ TTildaPanel }

 	TTildaPanel = class(TTildaElement)
		layer: TTildaLayer;

		controls: TTildaControls;

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
	events: TTildaEvents;

	abstracts: TTildaAbstracts;
	abstractRefs: TTildaAbstractRefs;


implementation

uses
	TildaDesignClasses;

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
		evt:= TTildaEvent.Create(ARR_REC_TILDA_SYSEVTS[i].i);
		evt.kind:= ARR_REC_TILDA_SYSEVTS[i].k;
		evt.system:= True;

		events.Add(evt);
		end;
	end;

function SystemEventByRecIndex(const AIndex: Integer): TTildaEvent;
	begin
	Result:= events[AIndex] as TTildaEvent;
	end;

{ TTildaEvent }

class function TTildaEvent.node: string;
	begin
	Result:= 'Event';
	end;

procedure TTildaEvent.ReadFromNode(const ANode: TDomNode);
	begin

	end;

function TTildaEvent.WriteToNode(const ADoc: TDomDocument): TDomElement;
	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('kind', IntToStr(Ord(kind)));
	end;

procedure TTildaEvent.ApplyReference(const ARef: TTildaReference);
	begin

	end;

constructor TTildaEvent.Create(const AIdent: string);
	begin
	inherited Create(AIdent);

	end;

{ TTildaText }

class function TTildaText.node: string;
	begin
	Result:= 'Text';
	end;

procedure TTildaText.ReadFromNode(const ANode: TDomNode);
	begin

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

constructor TTildaText.Create(const AIdent: string);
	begin
	inherited Create(AIdent);

	end;


{ TTildaControl }

class function TTildaControl.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_CTRL;
	end;

class function TTildaControl.node: string;
	begin
	Result:= 'Control';
	end;

procedure TTildaControl.ReadFromNode(const ANode: TDomNode);
	begin

	end;

function TTildaControl.WriteToNode(const ADoc: TDomDocument): TDomElement;
	var
	elem: TDomElement;

	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('textoffx', IntToStr(textoffx));
	Result.SetAttribute('textaccel', IntToStr(textaccel));
	Result.SetAttribute('accelchar', IntToStr(accelchar));

	if  Assigned(text) then
		Result.SetAttribute('text', text.ident)
	else
		Result.SetAttribute('text', '');
	end;

procedure TTildaControl.ApplyReference(const ARef: TTildaReference);
	begin

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

class function TTildaPage.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_PAGE;
	end;

class function TTildaPage.node: string;
	begin
	Result:= 'Page';
	end;

procedure TTildaPage.ReadFromNode(const ANode: TDomNode);
	begin

	end;

function TTildaPage.WriteToNode(const ADoc: TDomDocument): TDomElement;
	var
	i: Integer;
	elem: TDomElement;

	begin
	Result:= inherited WriteToNode(ADoc);

	if  Assigned(pagenxt) then
		Result.SetAttribute('pagenxt', pagenxt.ident)
	else
		Result.SetAttribute('pagenxt', '');

	if  Assigned(pagebak) then
		Result.SetAttribute('pagebak', pagebak.ident)
	else
		Result.SetAttribute('pagebak', '');

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

class function TTildaBar.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_BAR;
	end;

class function TTildaBar.node: string;
	begin
	Result:= 'Bar';
	end;

procedure TTildaBar.ReadFromNode(const ANode: TDomNode);
	begin
	inherited ReadFromNode(ANode);

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

	end;

function TTildaPanel.WriteToNode(const ADoc: TDomDocument): TDomElement;
	var
	i: Integer;
	elem: TDomElement;

	begin
	Result:= inherited WriteToNode(ADoc);

	if  Assigned(layer) then
		Result.SetAttribute('layer', layer.ident)
	else
		Result.SetAttribute('layer', '');

	elem:= ADoc.CreateElement('Controls');
	Result.AppendChild(elem);

	for i:= 0 to controls.Count - 1 do
		controls[i].WriteToRefNode(ADoc, elem);
	end;

procedure TTildaPanel.ApplyReference(const ARef: TTildaReference);
	begin

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

class function TTildaElement.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_ELEM;
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

class function TTildaLayer.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_LAYR;
	end;

class function TTildaLayer.node: string;
	begin
	Result:= 'Layer';
	end;

procedure TTildaLayer.ReadFromNode(const ANode: TDomNode);
	begin

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

class function TTildaView.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_VIEW;
	end;

class function TTildaView.node: string;
	begin
	Result:= 'View';
	end;

procedure TTildaView.ReadFromNode(const ANode: TDomNode);
	begin

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

class function TTildaUInterface.size: Byte;
	begin
	Result:= VAL_SIZ_TILDA_UINT;
	end;

class function TTildaUInterface.node: string;
	begin
	Result:= 'UInterface';
	end;

procedure TTildaUInterface.ReadFromNode(const ANode: TDomNode);
	begin

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

function TTildaObject.WriteToNode(const ADoc: TDomDocument): TDomElement;
	begin
	Result:= inherited WriteToNode(ADoc);

	Result.SetAttribute('size', IntToStr(size));
	end;

constructor TTildaObject.Create(const AIdent: string;
		const AParent: TTildaObject);
	begin
	inherited Create(AIdent);

	parent:= AParent;

	state:= [tskVisible, tskEnabled];
	end;

{ TTildaAbstract }

function TTildaAbstract.WriteToNode(const ADoc: TDomDocument): TDomElement;
	begin
	Result:= ADoc.CreateElement(node);

	Result.SetAttribute('ident', ident);
	end;

procedure TTildaAbstract.WriteToRefNode(const ADoc: TDomDocument;
		const AParent: TDomElement);
	var
	n: TDomElement;

	begin
	n:= ADoc.CreateElement('Ref');

	n.SetAttribute('node', node);
	n.SetAttribute('ident', ident);

	AParent.AppendChild(n);
	end;

constructor TTildaAbstract.Create(const AIdent: string);
	begin
	ident:= AIdent;
	end;


initialization
//	colours:= TTildaColours.Create;
	events:= TTildaEvents.Create;

	abstracts:= TTildaAbstracts.Create;
	abstractRefs:= TTildaAbstractRefs.Create;

//	PopulateSystemColours;
	PopulateSystemEvents;


finalization

end.

