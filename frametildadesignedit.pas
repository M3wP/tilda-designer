unit FrameTildaDesignEdit;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, ValEdit, TildaDesignTypes, Grids, StdCtrls;

type

	{ TTildaDesignEditFrame }
	TTildaDesignEditFrame = class(TFrame)
		ScrollBox1: TScrollBox;
		ValueListEditor1: TValueListEditor;
		procedure ValueListEditor1ButtonClick(Sender: TObject; aCol,
				aRow: Integer);
 		procedure ValueListEditor1EditingDone(Sender: TObject);
		procedure ValueListEditor1StringsChange(Sender: TObject);
		procedure ValueListEditor1ValidateEntry(sender: TObject; aCol,
				aRow: Integer; const OldValue: string; var NewValue: string);
	private

	protected
		FOnChange: TNotifyEvent;
		FItem: TTildaAbstract;
		FReading: Boolean;
		FClosing: Boolean;
		FValidated: Boolean;

		procedure DoValidateProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); virtual;
		procedure DoLookupProp(const AProp: string; const AOldValue: string;
			var ANewValue: string); virtual;
		procedure DoEditProp(const AProp: string; const AValue: string); virtual;

		procedure DoSetItem; virtual;

	public
		class procedure RegisterEditor; virtual; abstract;

		procedure SetItem(const AItem: TTildaAbstract);

		property Item: TTildaAbstract read FItem;
		property OnChange: TNotifyEvent read FOnChange write FOnChange;

		property Closing: Boolean read FClosing write FClosing;
	end;

	TTildaDesignEditFrameClass = class of TTildaDesignEditFrame;

implementation

{$R *.lfm}

uses
	TildaDesignClasses, TildaDesignUtils, FormTildaDesignEventRef,
	FormTildaDesignSelOptions, FormTildaDesignSelState;


{ TTildaDesignEditFrame }

procedure TTildaDesignEditFrame.ValueListEditor1ValidateEntry(sender: TObject;
		aCol, aRow: Integer; const OldValue: string; var NewValue: string);
	begin
	DoValidateProp(ValueListEditor1.Keys[ARow], OldValue, NewValue);

	if  CompareStr(NewValue, OldValue) <> 0 then
		begin
		FValidated:= True;
		if  Assigned(FOnChange) then
			FOnChange(Self);
		end;
	end;

procedure TTildaDesignEditFrame.ValueListEditor1EditingDone(Sender: TObject);
	var
	p,
	v: string;

	begin
	if  (not FReading)
	and (not FClosing)
	and (FValidated) then
		begin
		p:= ValueListEditor1.Keys[ValueListEditor1.Selection.Top];
		v:= ValueListEditor1.Values[p];

		DoEditProp(p, v);
		end;
	end;

procedure TTildaDesignEditFrame.ValueListEditor1ButtonClick(Sender: TObject;
		aCol, aRow: Integer);
	var
	p,
	o,
	n: string;

	begin
	p:= ValueListEditor1.Keys[ValueListEditor1.Selection.Top];
	o:= ValueListEditor1.Values[p];
	n:= o;

	DoLookupProp(p, o, n);

	ValueListEditor1.Values[p]:= n;

	if  CompareStr(o, n) <> 0 then
		if  Assigned(FOnChange) then
			FOnChange(Self);
	end;


procedure TTildaDesignEditFrame.ValueListEditor1StringsChange(Sender: TObject);
	begin
	FValidated:= False;
	end;

procedure TTildaDesignEditFrame.DoValidateProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	begin
	if  CompareText(AProp, 'ident') = 0 then
		if  not IsValidIdent(ANewValue) then
			ANewValue:= AOldValue;
	end;

procedure TTildaDesignEditFrame.DoLookupProp(const AProp: string;
		const AOldValue: string; var ANewValue: string);
	var
	e: TTildaEvent;

	begin
	ANewValue:= AOldValue;

	if  FItem is TTildaObject then
		begin
		if  TestLookupEventProp(AProp, 'prepare', tekPrepare, ANewValue, e) then
			TTildaObject(FItem).prepare:= e
		else if  TestLookupEventProp(AProp, 'initialise', tekInitialise, ANewValue, e) then
			TTildaObject(FItem).initialise:= e
		else if  TestLookupEventProp(AProp, 'change', tekChange, ANewValue, e) then
			TTildaObject(FItem).change:= e
		else if  TestLookupEventProp(AProp, 'release', tekRelease, ANewValue, e) then
			TTildaObject(FItem).release:= e
		else if  CompareText('state', AProp) = 0 then
			begin
			if  TildaDesignSelStateForm.ShowSelSetState(TTildaObject(FItem).state) = mrOK then
				begin
				TTildaObject(FItem).state:= TildaDesignSelStateForm.Selected;
				ANewValue:= StateToHex(TTildaObject(FItem).state);
				end;
			end
		else if  CompareText('options', AProp) = 0 then
			begin
			if  TildaDesignSelOptionsForm.ShowSelSetOptions(
					TTildaObject(FItem).options) = mrOK then
				begin
				TTildaObject(FItem).options:= TildaDesignSelOptionsForm.Selected;
				ANewValue:= OptionsToHex(TTildaObject(FItem).options);
				end;
			end;
		end;
	end;

procedure TTildaDesignEditFrame.DoEditProp(const AProp: string;
		const AValue: string);
	begin
	if  CompareText(AProp, 'ident') = 0 then
		FItem.ident:= AValue;
	end;

procedure TTildaDesignEditFrame.DoSetItem;
	procedure AddItemLookupVal(const AProp: string; const AValue: string);
		begin
		ValueListEditor1.Strings.Add(AProp + '=' + AValue);

		ValueListEditor1.ItemProps[AProp].EditStyle:= esEllipsis;
		ValueListEditor1.ItemProps[AProp].ReadOnly:= True;
		end;

	begin
	ValueListEditor1.Strings.Add('ident=' + FItem.ident);
	ValueListEditor1.ItemProps['ident'].MaxLength:= 32;

	if  FItem is TTildaObject then
		begin
		EditorAddItemEvent(ValueListEditor1, 'prepare', TTildaObject(FItem).prepare);
		EditorAddItemEvent(ValueListEditor1, 'initialise', TTildaObject(FItem).initialise);
		EditorAddItemEvent(ValueListEditor1, 'change', TTildaObject(FItem).change);
		EditorAddItemEvent(ValueListEditor1, 'release', TTildaObject(FItem).release);

		AddItemLookupVal('state', StateToHex(TTildaObject(FItem).state));
		AddItemLookupVal('options', OptionsToHex(TTildaObject(FItem).options));

		ValueListEditor1.Strings.Add('tag=' +
				IntToStr(TTildaObject(FItem).tag));
		end;
	end;

procedure TTildaDesignEditFrame.SetItem(const AItem: TTildaAbstract);
	begin
	FValidated:= False;
	FReading:= True;
	try
		ValueListEditor1.Clear;

		FItem:= AItem;

		DoSetItem;

		finally
		FReading:= False;
		end;
	end;

end.

